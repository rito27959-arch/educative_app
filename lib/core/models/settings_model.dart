class SettingsModel {
  final bool notificationsEnabled;
  final bool darkMode;
  final bool meshAutoConnect;
  final bool dataSaver;
  final bool autoDownload;
  final bool downloadOnWifiOnly;
  final String videoQuality;
  final double storageLimitGB;
  final double fontSizeMultiplier;

  const SettingsModel({
    this.notificationsEnabled = true,
    this.darkMode = true,
    this.meshAutoConnect = true,
    this.dataSaver = false,
    this.autoDownload = false,
    this.downloadOnWifiOnly = true,
    this.videoQuality = 'auto',
    this.storageLimitGB = 2.0,
    this.fontSizeMultiplier = 1.0,
  });

  SettingsModel copyWith({
    bool? notificationsEnabled,
    bool? darkMode,
    bool? meshAutoConnect,
    bool? dataSaver,
    bool? autoDownload,
    bool? downloadOnWifiOnly,
    String? videoQuality,
    double? storageLimitGB,
    double? fontSizeMultiplier,
  }) {
    return SettingsModel(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
      meshAutoConnect: meshAutoConnect ?? this.meshAutoConnect,
      dataSaver: dataSaver ?? this.dataSaver,
      autoDownload: autoDownload ?? this.autoDownload,
      downloadOnWifiOnly: downloadOnWifiOnly ?? this.downloadOnWifiOnly,
      videoQuality: videoQuality ?? this.videoQuality,
      storageLimitGB: storageLimitGB ?? this.storageLimitGB,
      fontSizeMultiplier: fontSizeMultiplier ?? this.fontSizeMultiplier,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'darkMode': darkMode,
      'meshAutoConnect': meshAutoConnect,
      'dataSaver': dataSaver,
      'autoDownload': autoDownload,
      'downloadOnWifiOnly': downloadOnWifiOnly,
      'videoQuality': videoQuality,
      'storageLimitGB': storageLimitGB,
      'fontSizeMultiplier': fontSizeMultiplier,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      darkMode: json['darkMode'] as bool? ?? true,
      meshAutoConnect: json['meshAutoConnect'] as bool? ?? true,
      dataSaver: json['dataSaver'] as bool? ?? false,
      autoDownload: json['autoDownload'] as bool? ?? false,
      downloadOnWifiOnly: json['downloadOnWifiOnly'] as bool? ?? true,
      videoQuality: json['videoQuality'] as String? ?? 'auto',
      storageLimitGB: (json['storageLimitGB'] as num?)?.toDouble() ?? 2.0,
      fontSizeMultiplier: (json['fontSizeMultiplier'] as num?)?.toDouble() ?? 1.0,
    );
  }

  static const List<String> qualityOptions = ['low', 'medium', 'high', 'auto'];
}
