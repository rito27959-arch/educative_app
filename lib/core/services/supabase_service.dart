import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../config/env_config.dart';
import '../errors/app_exceptions.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../services/storage_service.dart';
import 'auth_service.dart';
import 'analytics_service.dart';
import 'websocket_service.dart';

class BackendConfig {
  static bool enableAnalytics = true;
  static bool enableSync = true;
  static const Duration syncInterval = Duration(minutes: 5);
}

class SupabaseService {
  static SupabaseService? _instance;

  late final AuthService auth;
  late final AnalyticsService analytics;
  late final WebSocketService ws;

  bool _initialized = false;
  final List<void Function()> _onReadyCallbacks = [];

  SupabaseService._() {
    auth = AuthService();
    analytics = AnalyticsService();
    ws = WebSocketService(url: EnvConfig.wsUrl);
  }

  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  SupabaseClient get client => Supabase.instance.client;
  GoTrueClient get supabaseAuth => client.auth;

  bool get isReady => _initialized;

  void onReady(void Function() callback) {
    if (_initialized) {
      callback();
    } else {
      _onReadyCallbacks.add(callback);
    }
  }

  bool get _hasValidKeys =>
      !EnvConfig.supabaseUrl.contains('placeholder') &&
      !EnvConfig.supabaseAnonKey.contains('placeholder');

  Future<void> init() async {
    if (_initialized) return;

    await StorageService.init();

    if (_hasValidKeys) {
      await Supabase.initialize(
        url: EnvConfig.supabaseUrl,
        anonKey: EnvConfig.supabaseAnonKey,
      );
      await auth.init();
      if (BackendConfig.enableAnalytics) analytics.init();
      if (auth.isAuthenticated) {
        ws.setAuthToken(auth.accessToken);
      }
      supabaseAuth.onAuthStateChange.listen((data) {
        final session = data.session;
        if (session != null) {
          ws.setAuthToken(session.accessToken);
          ws.connect();
          ws.sendPresence(true);
        } else {
          ws.disconnect();
        }
      });
      if (auth.isAuthenticated) {
        ws.connect();
        ws.sendPresence(true);
      }
    }

    _initialized = true;
    for (final cb in _onReadyCallbacks) {
      cb();
    }
    _onReadyCallbacks.clear();
  }

  Future<Result<List<CourseModel>>> getCourses() async {
    try {
      final data = await client.from('courses').select() as List<dynamic>;
      final courses = data.map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
      return Result.success(courses);
    } catch (e) {
      return Result.failure(NetworkException('Erreur de chargement des cours', code: 'COURSES_FETCH'));
    }
  }

  Future<Result<UserModel>> login(String email, String password) =>
      auth.loginWithEmail(email, password);

  Future<Result<UserModel>> signUp(String email, String password, String pseudo, String bacSeries) =>
      auth.signUp(email: email, password: password, pseudo: pseudo, bacSeries: bacSeries);

  Future<void> logout() async {
    await auth.logout();
    await ws.disconnect();
  }

  Future<Result<UserModel>> updateProfile(Map<String, dynamic> updates) async {
    final user = supabaseAuth.currentUser;
    if (user == null) {
      return Result.failure(AuthException('Utilisateur non connecté'));
    }
    try {
      final data = await client.from('users').update(updates).eq('id', user.id).select().single();
      return Result.success(UserModel.fromJson(data));
    } catch (e) {
      return Result.failure(AuthException('Erreur de mise à jour du profil'));
    }
  }

  void trackScreen(String screen) => analytics.trackScreen(screen);

  void trackEvent(String name, {Map<String, dynamic> properties = const {}}) =>
      analytics.trackEvent(name, properties: properties);

  void trackError(String error, {String? stackTrace, bool isFatal = false}) =>
      analytics.trackError(error, stackTrace: stackTrace, isFatal: isFatal);

  void trackMeshPerformance(int peers, int messages, double latency) =>
      analytics.trackMeshPerformance(peers, messages, latency);

  void trackCallQuality(double bitrate, double audioLevel, int duration) =>
      analytics.trackCallQuality(bitrate, audioLevel, duration);

  void sendMessageOverWs(String recipientId, String content) => ws.sendMessage(recipientId, content);

  void handlePushNotification(Map<String, dynamic> payload) {}

  Future<void> dispose() async {
    await analytics.dispose();
    ws.dispose();
  }
}
