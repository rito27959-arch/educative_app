import 'package:flutter/foundation.dart';
import 'local_inference_service.dart';
import 'rag_service.dart';
import 'device_capability_service.dart';
import '../api_service.dart';

/// Résultat d'une requête au tuteur IA.
class LlmResult {
  final String response;
  final bool isOnline;
  final bool isFromCache;
  final String? errorMessage;
  final int contextTokens;

  const LlmResult({
    required this.response,
    this.isOnline = false,
    this.isFromCache = false,
    this.errorMessage,
    this.contextTokens = 0,
  });
}

/// Bascule automatique entre backend Claude (en ligne) et local (hors-ligne).
///
/// ## Ordre de priorité
/// 1. En ligne → API Claude (via backend)
/// 2. Hors-ligne + modèle local chargé → inférence locale (Qwen2.5 1.5B)
/// 3. Ni l'un ni l'autre → message clair
///
/// ## Mode batterie
/// L'inférence locale consomme significativement plus qu'une requête réseau.
/// Le mode économie limite la session à 1024 tokens.
enum LlmAvailability { online, localOnly, unavailable }

class LlmService {
  bool _online = false;
  LocalInferenceState _localState = LocalInferenceState.unloaded;
  LlmAvailability _availability = LlmAvailability.unavailable;

  final LocalInferenceService _local = LocalInferenceService();
  final ApiService _api = ApiService();

  LlmAvailability get availability => _availability;
  LocalInferenceService get local => _local;
  bool get isOnline => _online;
  bool get hasLocalModel => _localState == LocalInferenceState.ready;

  /// Vérifie les disponibilités au démarrage.
  Future<void> init({required bool hasInternet}) async {
    _online = hasInternet;
    _localState = _local.state;

    // Vérifier le modèle local
    if (DeviceCapabilityService.isCapable) {
      if (await LocalInferenceService.isModelDownloaded) {
        // Le modèle est téléchargé mais pas encore chargé (chargement à la demande)
        _localState = LocalInferenceState.unloaded;
      }
    } else {
      _localState = LocalInferenceState.unavailable;
    }

    _updateAvailability();
    debugPrint('[LlmService] init() → $_availability');
  }

  void _updateAvailability() {
    if (_online) {
      _availability = LlmAvailability.online;
    } else if (_local.state == LocalInferenceState.ready ||
               _localState == LocalInferenceState.unloaded) {
      _availability = LlmAvailability.localOnly;
    } else {
      _availability = LlmAvailability.unavailable;
    }
  }

  /// Met à jour le statut réseau.
  void setOnline(bool online) {
    _online = online;
    _updateAvailability();
  }

  /// Charge le modèle local (à faire une fois avant la première question).
  Future<bool> ensureLocalModelLoaded() async {
    if (_local.state == LocalInferenceState.ready) return true;
    return await _local.load();
  }

  /// Pose une question au tuteur IA.
  ///
  /// [question] : la question de l'élève en français.
  /// [courseId] : optionnel, pour contextualiser.
  /// Retourne toujours une réponse (jamais null en production).
  Future<LlmResult> ask({
    required String question,
    String? courseId,
  }) async {
    // 1. Contexte RAG
    final ragContext = RagService.buildContext(question);

    // 2. Construire le prompt final
    final prompt = _buildPrompt(question, ragContext);

    // 3. Online → Claude API
    if (_online) {
      try {
        final response = await _callClaudeApi(prompt);
        if (response != null) {
          return LlmResult(
            response: response,
            isOnline: true,
            contextTokens: RagService.estimateTokens(ragContext),
          );
        }
      } catch (e) {
        debugPrint('[LlmService] Claude API échoué, fallback local: $e');
      }
    }

    // 4. Hors-ligne → modèle local
    if (_local.state == LocalInferenceState.ready ||
        _localState == LocalInferenceState.unloaded) {
      if (_local.state != LocalInferenceState.ready) {
        await ensureLocalModelLoaded();
      }

      final response = await _local.generate(prompt: prompt);
      if (response != null) {
        return LlmResult(
          response: response,
          isOnline: false,
          contextTokens: RagService.estimateTokens(ragContext),
        );
      }
    }

    // 5. Aucun backend disponible
    return LlmResult(
      response: _buildUnavailableMessage(),
      isOnline: false,
      errorMessage: _local.lastError.isNotEmpty ? _local.lastError : null,
    );
  }

  String _buildPrompt(String question, String ragContext) {
    final buf = StringBuffer()
      ..writeln('Tu es un tuteur pédagogique pour des élèves de lycée '
          'francophones en Afrique. Réponds en français de façon claire '
          'et adaptée au niveau lycée.')
      ..writeln()
      ..writeln(ragContext)
      ..writeln()
      ..writeln('Question de l\'élève : $question')
      ..writeln()
      ..write('Réponse :');
    return buf.toString();
  }

  Future<String?> _callClaudeApi(String prompt) async {
    // Ici : appel réel à l'API Claude via le backend (Phase 5)
    // Pour l'instant, retourne null pour tester le fallback
    try {
      final res = await _api.post('/api/chat', body: {
        'model': 'claude-3-haiku',
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 1024,
      });
      if (res.isSuccess && res.data != null) {
        return res.data['content'] as String?;
      }
    } catch (_) {}
    return null;
  }

  String _buildUnavailableMessage() {
    if (DeviceCapabilityService.hasBeenChecked &&
        !DeviceCapabilityService.isCapable) {
      return 'Le tuteur IA hors-ligne n\'est pas disponible sur cet appareil '
          '(${DeviceCapabilityService.reason}). '
          'Connecte-toi à Internet pour utiliser le tuteur en ligne.';
    }
    return 'Aucun tuteur IA disponible actuellement. '
        'Connecte-toi à Internet ou vérifie que le modèle local '
        'est bien installé (Paramètres > Tuteur IA).';
  }

  void dispose() {
    _local.dispose();
  }
}
