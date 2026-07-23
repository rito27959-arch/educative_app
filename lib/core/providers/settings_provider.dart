import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

class SettingsState {
  final bool notificationsEnabled;
  final bool darkMode;
  final bool meshAutoConnect;
  final bool dataSaver;
  final bool autoDownload;
  final bool downloadOnWifiOnly;
  final String quality;
  final double storageLimit;
  final double fontSize;

  const SettingsState({
    this.notificationsEnabled = true,
    this.darkMode = true,
    this.meshAutoConnect = true,
    this.dataSaver = false,
    this.autoDownload = false,
    this.downloadOnWifiOnly = true,
    this.quality = 'auto',
    this.storageLimit = 2.0,
    this.fontSize = 1.0,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? darkMode,
    bool? meshAutoConnect,
    bool? dataSaver,
    bool? autoDownload,
    bool? downloadOnWifiOnly,
    String? quality,
    double? storageLimit,
    double? fontSize,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
      meshAutoConnect: meshAutoConnect ?? this.meshAutoConnect,
      dataSaver: dataSaver ?? this.dataSaver,
      autoDownload: autoDownload ?? this.autoDownload,
      downloadOnWifiOnly: downloadOnWifiOnly ?? this.downloadOnWifiOnly,
      quality: quality ?? this.quality,
      storageLimit: storageLimit ?? this.storageLimit,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  Map<String, dynamic> toJson() => {
    'notificationsEnabled': notificationsEnabled,
    'darkMode': darkMode,
    'meshAutoConnect': meshAutoConnect,
    'dataSaver': dataSaver,
    'autoDownload': autoDownload,
    'downloadOnWifiOnly': downloadOnWifiOnly,
    'quality': quality,
    'storageLimit': storageLimit,
    'fontSize': fontSize,
  };

  factory SettingsState.fromJson(Map<String, dynamic> json) => SettingsState(
    notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    darkMode: json['darkMode'] as bool? ?? true,
    meshAutoConnect: json['meshAutoConnect'] as bool? ?? true,
    dataSaver: json['dataSaver'] as bool? ?? false,
    autoDownload: json['autoDownload'] as bool? ?? false,
    downloadOnWifiOnly: json['downloadOnWifiOnly'] as bool? ?? true,
    quality: json['quality'] as String? ?? 'auto',
    storageLimit: (json['storageLimit'] as num?)?.toDouble() ?? 2.0,
    fontSize: (json['fontSize'] as num?)?.toDouble() ?? 1.0,
  );
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  void _load() {
    final data = StorageService.getSettings();
    if (data != null) {
      state = SettingsState.fromJson(data);
    }
  }

  Future<void> _persist() async {
    await StorageService.saveSettings(state.toJson());
  }

  Future<void> toggleNotifications() async {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
    await _persist();
  }

  Future<void> toggleDarkMode() async {
    state = state.copyWith(darkMode: !state.darkMode);
    await _persist();
  }

  Future<void> toggleMeshAutoConnect() async {
    state = state.copyWith(meshAutoConnect: !state.meshAutoConnect);
    await _persist();
  }

  Future<void> toggleDataSaver() async {
    state = state.copyWith(dataSaver: !state.dataSaver);
    await _persist();
  }

  Future<void> toggleAutoDownload() async {
    state = state.copyWith(autoDownload: !state.autoDownload);
    await _persist();
  }

  Future<void> toggleDownloadOnWifiOnly() async {
    state = state.copyWith(downloadOnWifiOnly: !state.downloadOnWifiOnly);
    await _persist();
  }

  Future<void> setQuality(String quality) async {
    state = state.copyWith(quality: quality);
    await _persist();
  }

  Future<void> setStorageLimit(double limit) async {
    state = state.copyWith(storageLimit: limit);
    await _persist();
  }

  Future<void> setFontSize(double size) async {
    state = state.copyWith(fontSize: size);
    await _persist();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
