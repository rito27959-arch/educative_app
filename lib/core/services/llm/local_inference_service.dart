// ============================================================================
// TUTEUR IA SUR L'APPAREIL — RETIRÉ DE KUNFOX.
// ----------------------------------------------------------------------------
// Le moteur llama.cpp embarqué pesait plus de 100 Mo dans l'APK 64 bits.
// Kunfox s'adresse à des élèves aux petits forfaits et aux petits
// téléphones : le tuteur est retiré. Cette classe garde la même forme pour
// que le reste du code compile, mais se déclare toujours indisponible.
// ============================================================================

import 'dart:async';

enum BatteryMode { performance, powerSaver }

enum LocalInferenceState { unloaded, loading, ready, error, unavailable }

class LocalInferenceService {
  final _loadProgress = StreamController<double>.broadcast();
  BatteryMode _batteryMode = BatteryMode.performance;

  Stream<double> get loadProgress => _loadProgress.stream;
  LocalInferenceState get state => LocalInferenceState.unavailable;
  String get lastError => 'Le tuteur IA n\'est plus inclus dans Kunfox.';
  BatteryMode get batteryMode => _batteryMode;
  int get sessionTokens => 0;

  static const String modelDownloadUrl = '';
  static Future<String> get modelDirectory async => '';
  static Future<String> get modelFilePath async => '';
  static Future<bool> get isModelDownloaded async => false;
  static int get expectedModelSize => 0;

  Future<bool> load() async => false;
  Future<void> unload() async {}

  Future<String?> generate({required String prompt, int maxTokens = 512, double temperature = 0.7}) async => null;

  Stream<String> generateStream({required String prompt, int maxTokens = 512, double temperature = 0.7}) =>
      const Stream<String>.empty();

  void setBatteryMode(BatteryMode mode) => _batteryMode = mode;

  void dispose() => _loadProgress.close();
}
