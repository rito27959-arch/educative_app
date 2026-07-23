enum AppLifecycle { initial, loading, ready, error }

class AppState {
  final AppLifecycle lifecycle;
  final String? errorMessage;
  final bool isOnline;
  final int launchCount;
  final DateTime? lastSyncAt;

  const AppState({
    this.lifecycle = AppLifecycle.initial,
    this.errorMessage,
    this.isOnline = false,
    this.launchCount = 0,
    this.lastSyncAt,
  });

  AppState copyWith({
    AppLifecycle? lifecycle,
    String? errorMessage,
    bool? isOnline,
    int? launchCount,
    DateTime? lastSyncAt,
  }) {
    return AppState(
      lifecycle: lifecycle ?? this.lifecycle,
      errorMessage: errorMessage ?? this.errorMessage,
      isOnline: isOnline ?? this.isOnline,
      launchCount: launchCount ?? this.launchCount,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  bool get isInitial => lifecycle == AppLifecycle.initial;
  bool get isLoading => lifecycle == AppLifecycle.loading;
  bool get isReady => lifecycle == AppLifecycle.ready;
  bool get hasError => lifecycle == AppLifecycle.error;
}
