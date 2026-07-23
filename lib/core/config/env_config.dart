/// Configuration par environnement via --dart-define.
///
/// Utilisation :
/// ```bash
/// flutter run --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=eyJ... \
///   --dart-define=SENTRY_DSN=https://xxx@sentry.io/xxx
/// ```
class EnvConfig {
  EnvConfig._();

  static String get supabaseUrl =>
    const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://placeholder.supabase.co');

  static String get supabaseAnonKey =>
    const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'placeholder-anon-key');

  static String get sentryDsn =>
    const String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  static String get apiUrl =>
    const String.fromEnvironment('API_URL', defaultValue: 'https://api.ouroprep.app/v1');

  static String get wsUrl =>
    const String.fromEnvironment('WS_URL', defaultValue: 'wss://api.ouroprep.app/ws');
}
