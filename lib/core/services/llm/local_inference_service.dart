import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:llamadart/llamadart.dart';
import 'package:path_provider/path_provider.dart';

enum BatteryMode { performance, powerSaver }

enum LocalInferenceState { unloaded, loading, ready, error, unavailable }

class LocalInferenceService {
  LocalInferenceState _state = LocalInferenceState.unloaded;
  BatteryMode _batteryMode = BatteryMode.performance;
  String _lastError = '';
  int _sessionTokens = 0;
  Timer? _sessionTimer;

  LlamaEngine? _engine;
  ChatSession? _session;
  bool _modelPrepared = false;

  final StreamController<double> _loadProgress =
      StreamController<double>.broadcast();
  Stream<double> get loadProgress => _loadProgress.stream;

  LocalInferenceState get state => _state;
  String get lastError => _lastError;
  BatteryMode get batteryMode => _batteryMode;
  int get sessionTokens => _sessionTokens;

  static const String _modelFilename = 'Llama-3.2-1B-Instruct-Q4_K_M.gguf';
  static const String _modelSource =
      'hf://bartowski/Llama-3.2-1B-Instruct-GGUF/Llama-3.2-1B-Instruct-Q4_K_M.gguf';
  static const String modelDownloadUrl =
      'https://huggingface.co/bartowski/Llama-3.2-1B-Instruct-GGUF/resolve/main/Llama-3.2-1B-Instruct-Q4_K_M.gguf';

  static Future<String> get modelDirectory async {
    final dir = await getApplicationDocumentsDirectory();
    final modelDir = Directory('${dir.path}/models');
    if (!await modelDir.exists()) {
      await modelDir.create(recursive: true);
    }
    return modelDir.path;
  }

  static Future<String> get modelFilePath async {
    final dir = await modelDirectory;
    return '$dir/$_modelFilename';
  }

  static Future<bool> get isModelDownloaded async {
    final path = await modelFilePath;
    return File(path).exists();
  }

  static int get expectedModelSize => 700 * 1024 * 1024;

  Future<bool> load() async {
    if (_state == LocalInferenceState.ready) return true;

    _state = LocalInferenceState.loading;
    _loadProgress.add(0);

    try {
      if (!_modelPrepared) {
        _engine = LlamaEngine(LlamaBackend());
        _modelPrepared = true;
      }

      if (await isModelDownloaded) {
        final path = await modelFilePath;
        await _engine!.loadModel(
          path,
          modelParams: ModelParams(
            contextSize: 2048,
            gpuLayers: _batteryMode == BatteryMode.performance ? -1 : 0,
          ),
        );
      } else {
        await _engine!.loadModelSource(
          ModelSource.parse(_modelSource),
          modelParams: ModelParams(
            contextSize: 2048,
            gpuLayers: _batteryMode == BatteryMode.performance ? -1 : 0,
          ),
          onProgress: (progress) {
            final fraction = progress.fraction;
            if (fraction != null) {
              _loadProgress.add(fraction);
            }
          },
        );
      }

      final systemPrompt = "Tu es un tuteur pédagogique pour des élèves "
          "de lycée francophones en Afrique. Réponds en français de façon "
          "claire et adaptée au niveau lycée. Sois précis et pédagogique.";

      _session = ChatSession(
        _engine!,
        systemPrompt: systemPrompt,
      );
      _state = LocalInferenceState.ready;
      _sessionTokens = 0;
      _startSessionTimer();
      _loadProgress.add(1);
      debugPrint('[LocalInference] Modèle chargé avec succès');
      return true;
    } catch (e) {
      _state = LocalInferenceState.error;
      _lastError = 'Erreur de chargement du modèle: $e';
      debugPrint('[LocalInference] $_lastError');
      _loadProgress.addError(e);
      return false;
    }
  }

  Future<void> unload() async {
    await _engine?.dispose();
    _engine = null;
    _session = null;
    _modelPrepared = false;
    _state = LocalInferenceState.unloaded;
    _sessionTimer?.cancel();
  }

  Future<String?> generate({
    required String prompt,
    int maxTokens = 512,
  }) async {
    if (_state != LocalInferenceState.ready || _session == null) {
      debugPrint('[LocalInference] Modèle non prêt');
      return null;
    }

    final maxSessionTokens = _maxSessionTokens();
    if (_sessionTokens >= maxSessionTokens) {
      debugPrint('[LocalInference] Limite de session atteinte ($maxSessionTokens tokens)');
      return null;
    }

    try {
      final output = StringBuffer();
      await for (final chunk in _session!.create(
        [LlamaTextContent(prompt)],
        params: GenerationParams(
          maxTokens: maxTokens.clamp(0, maxSessionTokens - _sessionTokens),
          temp: 0.7,
        ),
      )) {
        final text = chunk.choices.first.delta.content;
        if (text != null) {
          output.write(text);
          _sessionTokens += (text.length ~/ 4);
        }
      }
      return output.toString();
    } catch (e) {
      _lastError = 'Erreur de génération: $e';
      debugPrint('[LocalInference] $_lastError');
      return null;
    }
  }

  Stream<String> generateStream({
    required String prompt,
    int maxTokens = 512,
  }) async* {
    if (_state != LocalInferenceState.ready || _session == null) {
      yield 'Modèle non chargé. Veuille réessayer.';
      return;
    }

    try {
      await for (final chunk in _session!.create(
        [LlamaTextContent(prompt)],
        params: GenerationParams(
          maxTokens: maxTokens.clamp(0, _maxSessionTokens() - _sessionTokens),
          temp: 0.7,
        ),
      )) {
        final text = chunk.choices.first.delta.content;
        if (text != null) {
          yield text;
          _sessionTokens += (text.length ~/ 4);
        }
      }
    } catch (e) {
      _lastError = 'Erreur de génération: $e';
      yield '\n\n_Erreur: $_lastError';
    }
  }

  void setBatteryMode(BatteryMode mode) {
    _batteryMode = mode;
    debugPrint('[LocalInference] Mode batterie: $mode');
  }

  int _maxSessionTokens() {
    switch (_batteryMode) {
      case BatteryMode.performance:
        return 4096;
      case BatteryMode.powerSaver:
        return 1024;
    }
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(const Duration(minutes: 30), () {
      debugPrint('[LocalInference] Session expirée, déchargement...');
      unload();
    });
  }

  void dispose() {
    _sessionTimer?.cancel();
    _loadProgress.close();
    _engine?.dispose();
  }
}
