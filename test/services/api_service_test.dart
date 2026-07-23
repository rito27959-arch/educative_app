import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ouro_prep/core/services/api_service.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class FakeHttpClientResponse extends Fake implements HttpClientResponse {
  final int _statusCode;
  final List<int> _bodyBytes;
  final HttpHeaders _headers;

  FakeHttpClientResponse({
    required int statusCode,
    required String body,
    HttpHeaders? headers,
  })  : _statusCode = statusCode,
        _bodyBytes = body.codeUnits,
        _headers = headers ?? MockHttpHeaders();

  @override
  int get statusCode => _statusCode;

  @override
  HttpHeaders get headers => _headers;

  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) {
    return Stream<List<int>>.fromIterable([_bodyBytes])
        .transform(streamTransformer);
  }

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_bodyBytes]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  late MockHttpClient mockClient;
  late MockHttpClientRequest mockRequest;
  late MockHttpHeaders mockHeaders;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://fallback.test'));
    registerFallbackValue(HttpMethod.get);
  });

  setUp(() {
    mockClient = MockHttpClient();
    mockRequest = MockHttpClientRequest();
    mockHeaders = MockHttpHeaders();
  });

  void setupMockChain({int statusCode = 200, String body = '{"ok":true}'}) {
    final response = FakeHttpClientResponse(statusCode: statusCode, body: body);
    when(() => mockClient.openUrl(any(), any()))
        .thenAnswer((_) async => mockRequest);
    when(() => mockRequest.headers).thenReturn(mockHeaders);
    when(() => mockRequest.close()).thenAnswer((_) async => response);
  }

  group('ApiConfig', () {
    test('default timeout is 30 seconds', () {
      expect(ApiConfig.defaultTimeout, const Duration(seconds: 30));
    });

    test('maxRetries is 3', () {
      expect(ApiConfig.maxRetries, 3);
    });

    test('default base URL is set', () {
      expect(ApiConfig.defaultBaseUrl, isNotEmpty);
    });
  });

  group('ApiResponse', () {
    test('isSuccess for 2xx codes', () {
      expect(const ApiResponse(statusCode: 200).isSuccess, true);
      expect(const ApiResponse(statusCode: 201).isSuccess, true);
      expect(const ApiResponse(statusCode: 299).isSuccess, true);
    });

    test('isSuccess false for non-2xx', () {
      expect(const ApiResponse(statusCode: 199).isSuccess, false);
      expect(const ApiResponse(statusCode: 300).isSuccess, false);
      expect(const ApiResponse(statusCode: 500).isSuccess, false);
    });

    test('isClientError for 4xx codes', () {
      expect(const ApiResponse(statusCode: 400).isClientError, true);
      expect(const ApiResponse(statusCode: 404).isClientError, true);
      expect(const ApiResponse(statusCode: 499).isClientError, true);
    });

    test('isClientError false for non-4xx', () {
      expect(const ApiResponse(statusCode: 300).isClientError, false);
      expect(const ApiResponse(statusCode: 500).isClientError, false);
    });

    test('isServerError for 5xx codes', () {
      expect(const ApiResponse(statusCode: 500).isServerError, true);
      expect(const ApiResponse(statusCode: 503).isServerError, true);
    });

    test('isServerError false for non-5xx', () {
      expect(const ApiResponse(statusCode: 499).isServerError, false);
      expect(const ApiResponse(statusCode: 200).isServerError, false);
    });

    test('fold calls onSuccess when 2xx with data', () {
      final response = ApiResponse<String>(statusCode: 200, data: 'hello');
      final result = response.fold(
        (data) => 'got: $data',
        (_) => 'failure',
      );
      expect(result, 'got: hello');
    });

    test('fold calls onFailure when error', () {
      const response = ApiResponse<String>(statusCode: 500);
      final result = response.fold(
        (_) => 'success',
        (r) => 'error ${r.statusCode}',
      );
      expect(result, 'error 500');
    });

    test('fold calls onFailure when 2xx but no data', () {
      const response = ApiResponse<String>(statusCode: 200);
      final result = response.fold(
        (_) => 'success',
        (r) => 'no data',
      );
      expect(result, 'no data');
    });
  });

  group('HttpMethod', () {
    test('has all methods', () {
      expect(HttpMethod.values.length, 5);
      expect(HttpMethod.values, contains(HttpMethod.get));
      expect(HttpMethod.values, contains(HttpMethod.post));
      expect(HttpMethod.values, contains(HttpMethod.put));
      expect(HttpMethod.values, contains(HttpMethod.patch));
      expect(HttpMethod.values, contains(HttpMethod.delete));
    });
  });

  group('ApiService construction', () {
    test('constructs with defaults', () {
      final service = ApiService();
      expect(service.baseUrl, ApiConfig.defaultBaseUrl);
      expect(service.timeout, ApiConfig.defaultTimeout);
      service.dispose();
    });

    test('constructs with custom parameters', () {
      final service = ApiService(
        baseUrl: 'https://custom.api.com',
        timeout: const Duration(seconds: 10),
        maxRetries: 5,
      );
      expect(service.baseUrl, 'https://custom.api.com');
      expect(service.timeout, const Duration(seconds: 10));
      expect(service.maxRetries, 5);
      service.dispose();
    });

    test('setAuthToken stores token', () {
      final service = ApiService(client: mockClient);
      service.setAuthToken('my_token', refreshToken: 'refresh_123');
      service.dispose();
    });
  });

  group('ApiService GET', () {
    test('returns body on 200', () async {
      setupMockChain(statusCode: 200, body: '{"data":"test"}');

      final service = ApiService(
        client: mockClient,
        timeout: const Duration(seconds: 5),
      );
      final response = await service.get('/test');

      expect(response.statusCode, 200);
      expect(response.isSuccess, true);
      service.dispose();
    });

    test('returns error response on 500', () async {
      setupMockChain(statusCode: 500, body: '{"message":"Server error"}');

      final service = ApiService(
        client: mockClient,
        timeout: const Duration(seconds: 5),
        maxRetries: 0,
      );
      final response = await service.get('/test');

      expect(response.statusCode, 500);
      expect(response.isServerError, true);
      service.dispose();
    });

    test('with fromJson parser', () async {
      setupMockChain(statusCode: 200, body: '{"name":"Alice"}');

      final service = ApiService(
        client: mockClient,
        timeout: const Duration(seconds: 5),
      );
      final response = await service.get<Map<String, dynamic>>(
        '/user',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      expect(response.statusCode, 200);
      expect(response.data, isA<Map>());
      service.dispose();
    });
  });

  group('ApiService retry', () {
    test('retries on 500 up to maxRetries', () async {
      var callCount = 0;
      when(() => mockClient.openUrl(any(), any())).thenAnswer((_) async {
        callCount++;
        return mockRequest;
      });
      when(() => mockRequest.headers).thenReturn(mockHeaders);
      when(() => mockRequest.close()).thenAnswer((_) async {
        return FakeHttpClientResponse(
          statusCode: 500,
          body: '{"error":"fail"}',
        );
      });

      final service = ApiService(
        client: mockClient,
        timeout: const Duration(seconds: 5),
        maxRetries: 2,
      );
      final response = await service.get('/test');

      expect(response.statusCode, 500);
      expect(callCount, greaterThanOrEqualTo(2));
      service.dispose();
    });
  });

  group('ApiService timeout', () {
    test('returns error response on timeout', () async {
      when(() => mockClient.openUrl(any(), any()))
          .thenAnswer((_) async => mockRequest);
      when(() => mockRequest.headers).thenReturn(mockHeaders);
      when(() => mockRequest.close()).thenAnswer(
        (_) => Completer<HttpClientResponse>().future,
      );

      final service = ApiService(
        client: mockClient,
        timeout: const Duration(milliseconds: 1),
      );
      final response = await service.get('/test');

      expect(response.statusCode, 0);
      expect(response.errorMessage, contains('expiré'));
      service.dispose();
    });
  });

  group('ApiService post', () {
    test('sends POST request', () async {
      setupMockChain(statusCode: 201, body: '{"created":true}');

      final service = ApiService(
        client: mockClient,
        timeout: const Duration(seconds: 5),
      );
      final response = await service.post('/items', body: {'name': 'test'});

      expect(response.statusCode, 201);
      service.dispose();
    });
  });

  group('ApiService error parsing', () {
    test('returns parsed error message from JSON body', () async {
      setupMockChain(
          statusCode: 400, body: '{"message":"Invalid input"}');

      final service = ApiService(
        client: mockClient,
        timeout: const Duration(seconds: 5),
        maxRetries: 0,
      );
      final response = await service.get('/test');

      expect(response.statusCode, 400);
      expect(response.errorMessage, 'Invalid input');
      service.dispose();
    });

    test('returns fallback error for 404', () async {
      setupMockChain(statusCode: 404, body: 'not json');

      final service = ApiService(
        client: mockClient,
        timeout: const Duration(seconds: 5),
        maxRetries: 0,
      );
      final response = await service.get('/test');

      expect(response.statusCode, 404);
      expect(response.errorMessage, contains('Ressource introuvable'));
      service.dispose();
    });

    test('returns fallback error for 429', () async {
      setupMockChain(statusCode: 429, body: 'not json');

      final service = ApiService(
        client: mockClient,
        timeout: const Duration(seconds: 5),
        maxRetries: 0,
      );
      final response = await service.get('/test');

      expect(response.statusCode, 429);
      expect(response.errorMessage, contains('Trop de requêtes'));
      service.dispose();
    });
  });

  group('ApiService clearCache', () {
    test('clearCache does not throw', () {
      final service = ApiService(client: mockClient);
      service.clearCache();
      service.dispose();
    });
  });
}
