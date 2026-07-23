import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/llm/llm_service.dart';
import '../services/llm/local_inference_service.dart';
import '../services/llm/device_capability_service.dart';

/// Instance unique du service LLM (orchestrateur).
final llmServiceProvider = Provider<LlmService>((ref) {
  final service = LlmService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Disponibilité courante du tuteur IA (online / localOnly / unavailable).
final llmAvailabilityProvider = Provider<LlmAvailability>((ref) {
  return ref.watch(llmServiceProvider).availability;
});

/// État du modèle local (unloaded / loading / ready / error / unavailable).
final localInferenceStateProvider = Provider<LocalInferenceState>((ref) {
  return ref.watch(llmServiceProvider).local.state;
});

/// Progression du chargement du modèle (0.0 → 1.0).
final localModelLoadProgressProvider = StreamProvider<double>((ref) {
  return ref.watch(llmServiceProvider).local.loadProgress;
});

/// Résultat de la vérification des capacités matérielles.
final deviceCapabilityProvider = Provider<DeviceCapabilityResult>((ref) {
  return DeviceCapabilityResult(
    isCapable: DeviceCapabilityService.isCapable,
    reason: DeviceCapabilityService.reason,
    hasBeenChecked: DeviceCapabilityService.hasBeenChecked,
    score: DeviceCapabilityService.capabilityScore(),
    quality: DeviceCapabilityService.suggestedQuality(),
  );
});

/// État du téléchargement du modèle local.
final modelDownloadProvider = StateNotifierProvider<ModelDownloadNotifier, ModelDownloadState>((ref) {
  return ModelDownloadNotifier();
});

/// État du chat avec le tuteur IA.
final llmChatProvider = StateNotifierProvider<LlmChatNotifier, LlmChatState>((ref) {
  final llm = ref.watch(llmServiceProvider);
  return LlmChatNotifier(llm);
});

// -- Value classes -----------------------------------------------------------

class DeviceCapabilityResult {
  final bool isCapable;
  final String reason;
  final bool hasBeenChecked;
  final int score;
  final String quality;

  const DeviceCapabilityResult({
    required this.isCapable,
    required this.reason,
    required this.hasBeenChecked,
    required this.score,
    required this.quality,
  });
}

class ModelDownloadState {
  final bool isDownloading;
  final double progress; // 0.0 → 1.0
  final String? error;
  final bool isDownloaded;
  final int bytesDownloaded;
  final int totalBytes;

  const ModelDownloadState({
    this.isDownloading = false,
    this.progress = 0.0,
    this.error,
    this.isDownloaded = false,
    this.bytesDownloaded = 0,
    this.totalBytes = 0,
  });

  ModelDownloadState copyWith({
    bool? isDownloading,
    double? progress,
    String? error,
    bool? isDownloaded,
    int? bytesDownloaded,
    int? totalBytes,
  }) {
    return ModelDownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      progress: progress ?? this.progress,
      error: error,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      bytesDownloaded: bytesDownloaded ?? this.bytesDownloaded,
      totalBytes: totalBytes ?? this.totalBytes,
    );
  }
}

class LlmChatState {
  final List<LlmChatMessage> messages;
  final bool isLoading;
  final String? error;

  const LlmChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  LlmChatState copyWith({
    List<LlmChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return LlmChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class LlmChatMessage {
  final String text;
  final bool isUser; // true = élève, false = tuteur
  final DateTime timestamp;
  final bool isOnline;

  const LlmChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isOnline = false,
  });
}

// -- Notifiers ---------------------------------------------------------------

class ModelDownloadNotifier extends StateNotifier<ModelDownloadState> {
  ModelDownloadNotifier() : super(const ModelDownloadState());

  Future<void> startDownload() async {
    if (state.isDownloading) return;

    state = state.copyWith(isDownloading: true, progress: 0.0, error: null);

    try {
      await DeviceCapabilityService.check();
      if (!DeviceCapabilityService.isCapable) {
        state = state.copyWith(
          isDownloading: false,
          error: DeviceCapabilityService.reason,
        );
        return;
      }

      final url = Uri.parse(LocalInferenceService.modelDownloadUrl);
      final client = HttpClient();
      client.userAgent = 'OURO-PREP/1.0';
      final request = await client.getUrl(url);
      final response = await request.close();

      if (response.statusCode != 200) {
        state = state.copyWith(
          isDownloading: false,
          error: 'Erreur HTTP ${response.statusCode}',
        );
        return;
      }

      final total = response.contentLength > 0 ? response.contentLength : LocalInferenceService.expectedModelSize;
      state = state.copyWith(totalBytes: total);

      final modelPath = await LocalInferenceService.modelFilePath;
      final file = File(modelPath);
      await file.create(recursive: true);
      final sink = file.openWrite();

      var received = 0;
      await for (final chunk in response) {
        if (!mounted) {
          await sink.close();
          await file.delete();
          return;
        }
        sink.add(chunk);
        received += chunk.length;
        state = state.copyWith(
          progress: total > 0 ? received / total : 0.0,
          bytesDownloaded: received,
        );
      }

      await sink.flush();
      await sink.close();

      state = state.copyWith(
        isDownloading: false,
        isDownloaded: true,
        progress: 1.0,
        bytesDownloaded: received,
      );
    } catch (e) {
      state = state.copyWith(
        isDownloading: false,
        error: 'Erreur de téléchargement: $e',
      );
    }
  }

  /// Vérifie si le modèle est déjà présent.
  Future<void> checkDownloaded() async {
    final downloaded = await LocalInferenceService.isModelDownloaded;
    state = state.copyWith(isDownloaded: downloaded);
  }
}

class LlmChatNotifier extends StateNotifier<LlmChatState> {
  final LlmService _llm;

  LlmChatNotifier(this._llm) : super(const LlmChatState());

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.isLoading) return;

    // Message utilisateur
    final userMsg = LlmChatMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      error: null,
    );

    // Requête au LLM
    final result = await _llm.ask(question: text.trim());

    // Réponse du tuteur
    final tutorMsg = LlmChatMessage(
      text: result.response,
      isUser: false,
      timestamp: DateTime.now(),
      isOnline: result.isOnline,
    );
    state = state.copyWith(
      messages: [...state.messages, tutorMsg],
      isLoading: false,
      error: result.errorMessage,
    );
  }

  void clearChat() {
    state = const LlmChatState();
  }
}
