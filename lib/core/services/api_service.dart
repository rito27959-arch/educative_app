import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String defaultBaseUrl = 'https://api.ouroprep.app/v1';
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
}

enum HttpMethod { get, post, put, patch, delete }

class ApiResponse<T> {
  final int statusCode;
  final T? data;
  final String? errorMessage;
  final Map<String, String> headers;

  const ApiResponse({
    required this.statusCode,
    this.data,
    this.errorMessage,
    this.headers = const {},
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get isClientError => statusCode >= 400 && statusCode < 500;
  bool get isServerError => statusCode >= 500;

  R fold<R>(R Function(T data) onSuccess, R Function(ApiResponse<T> response) onFailure) {
    if (isSuccess && data != null) return onSuccess(data!);
    return onFailure(this);
  }
}

class ApiService {
  final String baseUrl;
  final Duration timeout;
  final int maxRetries;
  final HttpClient _client;
  String? _authToken;
  String? _refreshToken;

  final Map<String, _CacheEntry> _cache = {};
  static const Duration _cacheDuration = Duration(minutes: 2);
  final List<ApiInterceptor> _interceptors = [];

  ApiService({
    this.baseUrl = ApiConfig.defaultBaseUrl,
    this.timeout = ApiConfig.defaultTimeout,
    this.maxRetries = ApiConfig.maxRetries,
    HttpClient? client,
  }) : _client = client ?? HttpClient();

  void setAuthToken(String? token, {String? refreshToken}) {
    _authToken = token;
    if (refreshToken != null) _refreshToken = refreshToken;
  }

  void addInterceptor(ApiInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  Future<ApiResponse<T>> request<T>({
    required HttpMethod method,
    required String path,
    Map<String, String>? queryParams,
    Map<String, dynamic>? body,
    T Function(dynamic json)? fromJson,
    bool useCache = false,
    int retryCount = 0,
  }) => _request(method: method, path: path, queryParams: queryParams, body: body, fromJson: fromJson, useCache: useCache, retryCount: retryCount);

  Future<ApiResponse<T>> _request<T>({
    required HttpMethod method,
    required String path,
    Map<String, String>? queryParams,
    Map<String, dynamic>? body,
    T Function(dynamic json)? fromJson,
    bool useCache = false,
    int retryCount = 0,
  }) async {
    final uri = _buildUri(path, queryParams);
    final cacheKey = uri.toString();

    if (useCache && _cache.containsKey(cacheKey) && !_cache[cacheKey]!.isExpired) {
      final cached = _cache[cacheKey]!.data;
      if (cached != null && fromJson != null) {
        return ApiResponse<T>(statusCode: 200, data: fromJson(cached));
      }
      return ApiResponse<T>(statusCode: 200, data: cached as T?);
    }

    for (final interceptor in _interceptors) {
      await interceptor.onRequest(method, path, body);
    }

    try {
      final httpRequest = await _client.openUrl(method.name.toUpperCase(), uri);
      httpRequest.headers.set('Content-Type', 'application/json');
      httpRequest.headers.set('Accept', 'application/json');
      httpRequest.headers.set('X-Client-Version', '1.0.0');
      httpRequest.headers.set('X-Platform', 'ouro-prep-mobile');
      if (_authToken != null) {
        httpRequest.headers.set('Authorization', 'Bearer $_authToken');
      }
      if (body != null && (method == HttpMethod.post || method == HttpMethod.put || method == HttpMethod.patch)) {
        httpRequest.write(jsonEncode(body));
      }

      final httpResponse = await httpRequest.close().timeout(timeout);
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      final statusCode = httpResponse.statusCode;
      final headers = <String, String>{};
      httpResponse.headers.forEach((name, values) {
        headers[name] = values.join(', ');
      });

      for (final interceptor in _interceptors) {
        await interceptor.onResponse(statusCode, responseBody);
      }

      if (statusCode == 401 && _refreshToken != null && retryCount < maxRetries) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          return _request(
            method: method, path: path, queryParams: queryParams,
            body: body, fromJson: fromJson, useCache: false, retryCount: retryCount + 1,
          );
        }
      }

      if (statusCode >= 200 && statusCode < 300) {
        dynamic decoded;
        if (responseBody.isNotEmpty) {
          try { decoded = jsonDecode(responseBody); } catch (e) { debugPrint('[API] $e'); decoded = responseBody; }
        }
        if (useCache && decoded != null) {
          _cache[cacheKey] = _CacheEntry(data: decoded, expiry: DateTime.now().add(_cacheDuration));
        }
        final data = decoded != null && fromJson != null ? fromJson(decoded) : decoded as T?;
        return ApiResponse<T>(statusCode: statusCode, data: data, headers: headers);
      }

      if (statusCode >= 500 && retryCount < maxRetries) {
        final delay = Duration(milliseconds: (pow(2, retryCount) * 1000 + Random().nextInt(1000)).toInt());
        await Future.delayed(delay);
        return _request(method: method, path: path, queryParams: queryParams, body: body, fromJson: fromJson, retryCount: retryCount + 1);
      }

      return ApiResponse<T>(statusCode: statusCode, errorMessage: _parseError(responseBody, statusCode), headers: headers);
    } on SocketException {
      if (retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: pow(2, retryCount).toInt()));
        return request(method: method, path: path, queryParams: queryParams, body: body, fromJson: fromJson, retryCount: retryCount + 1);
      }
      return ApiResponse<T>(statusCode: 0, errorMessage: 'Aucune connexion réseau. Vérifiez votre connexion Internet.');
    } on TimeoutException {
      return ApiResponse<T>(statusCode: 0, errorMessage: 'La requête a expiré. Veuillez réessayer.');
    } catch (e) {
      return ApiResponse<T>(statusCode: 0, errorMessage: 'Erreur inattendue : $e');
    }
  }

  Uri _buildUri(String path, Map<String, String>? queryParams) {
    final uri = Uri.parse('$baseUrl$path');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  Future<bool> _tryRefreshToken() async {
    if (_refreshToken == null) return false;
    try {
      final req = await _client.postUrl(Uri.parse('$baseUrl/auth/refresh'));
      req.headers.set('Content-Type', 'application/json');
      req.write(jsonEncode({'refreshToken': _refreshToken}));
      final res = await req.close();
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final data = jsonDecode(body) as Map<String, dynamic>;
        _authToken = data['accessToken'] as String?;
        _refreshToken = data['refreshToken'] as String?;
        return _authToken != null;
      }
    } catch (e) { debugPrint('[API] $e'); }
    return false;
  }

  String _parseError(String body, int statusCode) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['message'] as String? ?? json['error'] as String? ?? 'Erreur $statusCode';
    } catch (e) {
      debugPrint('[API] $e');
      if (statusCode == 401) return 'Session expirée. Veuillez vous reconnecter.';
      if (statusCode == 403) return 'Accès refusé.';
      if (statusCode == 404) return 'Ressource introuvable.';
      if (statusCode == 429) return 'Trop de requêtes. Veuillez patienter.';
      if (statusCode >= 500) return 'Erreur serveur. Veuillez réessayer plus tard.';
      return 'Erreur $statusCode.';
    }
  }

  Future<ApiResponse<T>> get<T>(String path, {Map<String, String>? queryParams, T Function(dynamic)? fromJson, bool useCache = false}) =>
      request(method: HttpMethod.get, path: path, queryParams: queryParams, fromJson: fromJson, useCache: useCache);

  Future<ApiResponse<T>> post<T>(String path, {Map<String, dynamic>? body, T Function(dynamic)? fromJson}) =>
      request(method: HttpMethod.post, path: path, body: body, fromJson: fromJson);

  Future<ApiResponse<T>> put<T>(String path, {Map<String, dynamic>? body, T Function(dynamic)? fromJson}) =>
      request(method: HttpMethod.put, path: path, body: body, fromJson: fromJson);

  Future<ApiResponse<T>> patch<T>(String path, {Map<String, dynamic>? body, T Function(dynamic)? fromJson}) =>
      request(method: HttpMethod.patch, path: path, body: body, fromJson: fromJson);

  Future<ApiResponse<T>> delete<T>(String path, {T Function(dynamic)? fromJson}) =>
      request(method: HttpMethod.delete, path: path, fromJson: fromJson);

  void clearCache() => _cache.clear();
  void dispose() => _client.close(force: true);
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiry;
  _CacheEntry({required this.data, required this.expiry});
  bool get isExpired => DateTime.now().isAfter(expiry);
}

abstract class ApiInterceptor {
  Future<void> onRequest(HttpMethod method, String path, Map<String, dynamic>? body);
  Future<void> onResponse(int statusCode, String body);
}

class LoggingInterceptor extends ApiInterceptor {
  @override Future<void> onRequest(HttpMethod method, String path, Map<String, dynamic>? body) async {
    debugPrint('[API] --> $method $path');
  }
  @override Future<void> onResponse(int statusCode, String body) async {
    debugPrint('[API] <-- $statusCode (${body.length} bytes)');
  }
}
