import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../errors/app_exceptions.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

const _kAccessToken = 'supabase_access_token';
const _kRefreshToken = 'supabase_refresh_token';

class AuthCredentials {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final DateTime expiresAt;

  const AuthCredentials({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'user': user.toJson(),
    'expiresAt': expiresAt.toIso8601String(),
  };

  factory AuthCredentials.fromJson(Map<String, dynamic> json) => AuthCredentials(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
    user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    expiresAt: DateTime.parse(json['expiresAt'] as String),
  );
}

enum AuthProvider { email, google, apple, phone, anonymous }

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  AuthCredentials? _credentials;
  AuthStatus _status = AuthStatus.uninitialized;
  final List<void Function(AuthStatus status)> _listeners = [];

  AuthStatus get status => _status;
  AuthCredentials? get credentials => _credentials;
  bool get isAuthenticated => _status == AuthStatus.authenticated && _credentials != null && !_credentials!.isExpired;
  UserModel? get currentUser => _credentials?.user;
  String? get accessToken => _credentials?.accessToken;

  GoTrueClient get _supabaseAuth => SupabaseService.instance.supabaseAuth;

  void addListener(void Function(AuthStatus status) listener) => _listeners.add(listener);
  void removeListener(void Function(AuthStatus status) listener) => _listeners.remove(listener);

  void _notify(AuthStatus status) {
    _status = status;
    for (final l in _listeners) {
      l(status);
    }
  }

  Future<void> init() async {
    try {
      final savedAccessToken = await _secureStorage.read(key: _kAccessToken);
      final savedRefreshToken = await _secureStorage.read(key: _kRefreshToken);

      if (savedAccessToken != null && savedRefreshToken != null) {
        try {
          await _supabaseAuth.setSession(savedRefreshToken);
          final session = _supabaseAuth.currentSession;
          if (session != null) {
            await _restoreCredentials(session);
            _notify(AuthStatus.authenticated);
            return;
          }
        } catch (e) {
          debugPrint('[Auth] Session restore failed: $e');
        }
      }

      final currentSession = _supabaseAuth.currentSession;
      if (currentSession != null) {
        await _restoreCredentials(currentSession);
        _notify(AuthStatus.authenticated);
        return;
      }
    } catch (e) {
      debugPrint('[Auth] Init error: $e');
    }
    _notify(AuthStatus.unauthenticated);
  }

  Future<Result<UserModel>> loginWithEmail(String email, String password) async {
    _notify(AuthStatus.loading);
    try {
      final response = await _supabaseAuth.signInWithPassword(
        email: email,
        password: password,
      );

      final session = response.session;
      final user = response.user;
      if (session == null || user == null) {
        _notify(AuthStatus.unauthenticated);
        return Result.failure(AuthException('Email ou mot de passe incorrect'));
      }

      return _buildCredentials(session, user);
    } catch (e) {
      _notify(AuthStatus.unauthenticated);
      final msg = e is AuthException ? e.message : 'Erreur réseau. Vérifiez votre connexion.';
      return Result.failure(AuthException(msg));
    }
  }

  Future<Result<UserModel>> signUp({
    required String email,
    required String password,
    required String pseudo,
    required String bacSeries,
  }) async {
    _notify(AuthStatus.loading);
    try {
      final response = await _supabaseAuth.signUp(
        email: email,
        password: password,
        data: {'pseudo': pseudo, 'bacSeries': bacSeries},
      );

      final session = response.session;
      final user = response.user;
      if (session == null || user == null) {
        _notify(AuthStatus.unauthenticated);
        return Result.failure(AuthException("Échec de l'inscription"));
      }

      try {
        await SupabaseService.instance.client.from('users').insert({
          'id': user.id,
          'pseudo': pseudo,
          'bacSeries': bacSeries,
          'cryptoIdentity': pseudo,
        });
      } catch (_) {}

      return _buildCredentials(session, user);
    } catch (e) {
      _notify(AuthStatus.unauthenticated);
      final msg = e is AuthException ? e.message : "Erreur réseau. Vérifiez votre connexion.";
      return Result.failure(AuthException(msg));
    }
  }

  Future<Result<UserModel>> _buildCredentials(Session session, User user) async {
    await _persistTokens(session.accessToken, session.refreshToken);

    UserModel userModel;
    try {
      final data = await SupabaseService.instance.client
          .from('users')
          .select()
          .eq('id', user.id)
          .single();
      userModel = UserModel.fromJson(data);
    } catch (_) {
      userModel = UserModel(
        pseudo: user.userMetadata?['pseudo'] as String? ?? 'Utilisateur',
        bacSeries: user.userMetadata?['bacSeries'] as String? ?? 'Scientifique',
        cryptoIdentity: user.id,
      );
    }

    final token = session.accessToken;
    final refresh = session.refreshToken ?? '';
    _credentials = AuthCredentials(
      accessToken: token,
      refreshToken: refresh,
      user: userModel,
      expiresAt: session.expiresAt != null
          ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
          : DateTime.now().add(const Duration(hours: 1)),
    );

    _notify(AuthStatus.authenticated);
    return Result.success(userModel);
  }

  Future<void> _restoreCredentials(Session session) async {
    final user = session.user;

    UserModel userModel;
    try {
      final data = await SupabaseService.instance.client
          .from('users')
          .select()
          .eq('id', user.id)
          .single();
      userModel = UserModel.fromJson(data);
    } catch (_) {
      userModel = UserModel(
        pseudo: user.userMetadata?['pseudo'] as String? ?? 'Utilisateur',
        bacSeries: user.userMetadata?['bacSeries'] as String? ?? 'Scientifique',
        cryptoIdentity: user.id,
      );
    }

    final token = session.accessToken;
    final refresh = session.refreshToken ?? '';
    _credentials = AuthCredentials(
      accessToken: token,
      refreshToken: refresh,
      user: userModel,
      expiresAt: session.expiresAt != null
          ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
          : DateTime.now().add(const Duration(hours: 1)),
    );
  }

  Future<void> logout() async {
    try {
      await _supabaseAuth.signOut();
    } catch (e) {
      debugPrint('[Auth] Logout error: $e');
    }
    _credentials = null;
    await _secureStorage.delete(key: _kAccessToken);
    await _secureStorage.delete(key: _kRefreshToken);
    _notify(AuthStatus.unauthenticated);
  }

  Future<Result<UserModel>> updateProfile(Map<String, dynamic> updates) async {
    final user = _supabaseAuth.currentUser;
    if (user == null) {
      return Result.failure(AuthException('Utilisateur non connecté'));
    }
    try {
      final data = await SupabaseService.instance.client
          .from('users')
          .update(updates)
          .eq('id', user.id)
          .select()
          .single();
      _credentials = AuthCredentials(
        accessToken: _credentials!.accessToken,
        refreshToken: _credentials!.refreshToken,
        user: UserModel.fromJson(data),
        expiresAt: _credentials!.expiresAt,
      );
      return Result.success(_credentials!.user);
    } catch (e) {
      return Result.failure(AuthException('Erreur de mise à jour'));
    }
  }

  Future<void> _persistTokens(String? accessToken, String? refreshToken) async {
    if (accessToken != null) {
      await _secureStorage.write(key: _kAccessToken, value: accessToken);
    }
    if (refreshToken != null) {
      await _secureStorage.write(key: _kRefreshToken, value: refreshToken);
    }
  }
}
