import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/llm/llm_service.dart';
import '../services/stt_service.dart';
import '../models/african_language.dart';
import 'llm_provider.dart';

enum CoachSpeakingState { idle, listening, thinking, speaking }

class VoiceCoachMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String languageCode;
  final bool isStreaming;

  const VoiceCoachMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.languageCode = 'fr',
    this.isStreaming = false,
  });

  VoiceCoachMessage copyWith({String? text, bool? isStreaming}) {
    return VoiceCoachMessage(
      text: text ?? this.text,
      isUser: isUser,
      timestamp: timestamp,
      languageCode: languageCode,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

class VoiceCoachState {
  final List<VoiceCoachMessage> messages;
  final bool isLoading;
  final CoachSpeakingState speakingState;
  final String selectedLanguage;
  final String? error;
  final double audioLevel;
  final String? interimText;
  final bool isLiveMode;

  const VoiceCoachState({
    this.messages = const [],
    this.isLoading = false,
    this.speakingState = CoachSpeakingState.idle,
    this.selectedLanguage = 'fr',
    this.error,
    this.audioLevel = 0.0,
    this.interimText,
    this.isLiveMode = false,
  });

  VoiceCoachState copyWith({
    List<VoiceCoachMessage>? messages,
    bool? isLoading,
    CoachSpeakingState? speakingState,
    String? selectedLanguage,
    String? error,
    double? audioLevel,
    String? interimText,
    bool? isLiveMode,
  }) {
    return VoiceCoachState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      speakingState: speakingState ?? this.speakingState,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      error: error,
      audioLevel: audioLevel ?? this.audioLevel,
      interimText: interimText,
      isLiveMode: isLiveMode ?? this.isLiveMode,
    );
  }
}

final voiceCoachProvider =
    StateNotifierProvider<VoiceCoachNotifier, VoiceCoachState>((ref) {
  final llm = ref.watch(llmServiceProvider);
  return VoiceCoachNotifier(llm);
});

class VoiceCoachNotifier extends StateNotifier<VoiceCoachState> {
  final LlmService _llm;
  final FlutterTts _tts = FlutterTts();
  final SttService _stt = SttService();
  StreamSubscription<SttResult>? _sttSub;
  StreamSubscription<String>? _llmStream;

  VoiceCoachNotifier(this._llm) : super(const VoiceCoachState()) {
    _initTts();
    _stt.init();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('fr-FR');
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    _tts.setCompletionHandler(() {
      if (mounted) {
        state = state.copyWith(speakingState: CoachSpeakingState.idle);
      }
    });
  }

  void setLanguage(String code) {
    state = state.copyWith(selectedLanguage: code);
    final lang = AfricanLanguage.fromCode(code);
    _setTtsLanguage(lang);
  }

  Future<void> _setTtsLanguage(AfricanLanguage lang) async {
    switch (lang.code) {
      case 'fr':
        await _tts.setLanguage('fr-FR');
        break;
      case 'en':
        await _tts.setLanguage('en-US');
        break;
      default:
        await _tts.setLanguage('fr-FR');
    }
  }

  // ── Live Mode ──────────────────────────────────────────────────────

  Future<void> enterLiveMode() async {
    state = state.copyWith(isLiveMode: true, interimText: null);
    await _stt.init();
    await _startListening();
  }

  void exitLiveMode() {
    _stopListening();
    _cancelLlmStream();
    _tts.stop();
    state = state.copyWith(
      isLiveMode: false,
      speakingState: CoachSpeakingState.idle,
      interimText: null,
      audioLevel: 0.0,
    );
  }

  void toggleListening() {
    if (state.speakingState == CoachSpeakingState.listening) {
      _stopListeningAndProcess();
    } else if (state.speakingState == CoachSpeakingState.idle ||
        state.speakingState == CoachSpeakingState.speaking) {
      if (state.speakingState == CoachSpeakingState.speaking) {
        _tts.stop();
      }
      _startListening();
    }
  }

  Future<void> _startListening() async {
    _cancelLlmStream();
    await _stt.init();
    state = state.copyWith(
      speakingState: CoachSpeakingState.listening,
      interimText: null,
      audioLevel: 0.0,
    );

    final controller = StreamController<SttResult>();
    _sttSub = controller.stream.listen((result) {
      state = state.copyWith(
        interimText: result.text,
        audioLevel: result.confidence.clamp(0.0, 1.0),
      );
    });

    await _stt.startListening(controller: controller);
  }

  Future<void> _stopListeningAndProcess() async {
    await _stt.stopListening();
    final text = state.interimText ?? '';
    state = state.copyWith(interimText: null, audioLevel: 0.0);

    if (text.trim().isNotEmpty) {
      _processVoiceInput(text.trim());
    } else {
      state = state.copyWith(speakingState: CoachSpeakingState.idle);
    }
  }

  void _stopListening() {
    _sttSub?.cancel();
    _sttSub = null;
    _stt.cancel();
  }

  // ── Text Mode ──────────────────────────────────────────────────────

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.isLoading) return;

    final userMsg = VoiceCoachMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      languageCode: state.selectedLanguage,
    );
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      error: null,
    );

    final lang = AfricanLanguage.fromCode(state.selectedLanguage);
    final prompt = _buildCoachPrompt(text.trim(), lang);

    try {
      if (state.isLiveMode) {
        _streamLlmResponse(prompt);
      } else {
        final result = await _llm.ask(question: prompt);
        final coachMsg = VoiceCoachMessage(
          text: result.response,
          isUser: false,
          timestamp: DateTime.now(),
          languageCode: 'fr',
        );
        state = state.copyWith(
          messages: [...state.messages, coachMsg],
          isLoading: false,
          error: result.errorMessage,
        );
        _speak(result.response);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur: $e',
      );
    }
  }

  Future<void> _processVoiceInput(String text) async {
    final userMsg = VoiceCoachMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      languageCode: state.selectedLanguage,
    );
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      speakingState: CoachSpeakingState.thinking,
    );

    final lang = AfricanLanguage.fromCode(state.selectedLanguage);
    final prompt = _buildCoachPrompt(text, lang);
    _streamLlmResponse(prompt);
  }

  Future<void> _streamLlmResponse(String prompt) async {
    _cancelLlmStream();

    final placeholderMsg = VoiceCoachMessage(
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
      isStreaming: true,
    );
    state = state.copyWith(
      messages: [...state.messages, placeholderMsg],
      isLoading: false,
      speakingState: CoachSpeakingState.thinking,
      error: null,
    );

    final buf = StringBuffer();
    final llmStream = _llm.local.generateStream(prompt: prompt);
    _llmStream = llmStream.listen(
      (chunk) {
        buf.write(chunk);
        final msgs = [...state.messages];
        msgs[msgs.length - 1] = VoiceCoachMessage(
          text: buf.toString(),
          isUser: false,
          timestamp: DateTime.now(),
          isStreaming: true,
        );
        state = state.copyWith(messages: msgs);
      },
      onDone: () {
        final msgs = [...state.messages];
        msgs[msgs.length - 1] = VoiceCoachMessage(
          text: buf.toString(),
          isUser: false,
          timestamp: DateTime.now(),
          isStreaming: false,
        );
        state = state.copyWith(
          messages: msgs,
          speakingState: CoachSpeakingState.idle,
        );
        if (buf.toString().trim().isNotEmpty && state.isLiveMode) {
          _speak(buf.toString());
        }
      },
      onError: (e) {
        state = state.copyWith(
          error: 'Erreur: $e',
          speakingState: CoachSpeakingState.idle,
        );
      },
    );
  }

  void _cancelLlmStream() {
    _llmStream?.cancel();
    _llmStream = null;
  }

  String _buildCoachPrompt(String question, AfricanLanguage lang) {
    if (lang.code == 'fr') {
      return 'Tu es un coach vocal éducatif pour des élèves africains '
          'francophones. Réponds de façon chaleureuse et pédagogique, '
          'comme un vrai coach qui encourage et motive. '
          'Utilise un ton enthousiaste et des phrases courtes '
          'adaptées à la prononciation vocale.\n\n'
          'Question: $question';
    }
    return 'Tu es un coach éducatif multilingue. '
        'La question est posée en ${lang.nativeName} (${lang.name}). '
        'Réponds en français de façon claire et encourageante, '
        'en expliquant les concepts de manière simple. '
        'Commence par saluer l\'élève dans sa langue: '
        'dis "${_greetingIn(lang.code)}" puis réponds en français.\n\n'
        'Question: $question';
  }

  String _greetingIn(String code) {
    switch (code) {
      case 'wo': return 'Salam aleekum';
      case 'bm': return 'I ni ce';
      case 'ha': return 'Sannu';
      case 'sw': return 'Shikamoo';
      case 'ff': return 'A jaaraama';
      case 'ln': return 'Mbote';
      default: return 'Bonjour';
    }
  }

  Future<void> _speak(String text) async {
    try {
      state = state.copyWith(speakingState: CoachSpeakingState.speaking);
      await _tts.speak(text);
    } catch (e) {
      state = state.copyWith(speakingState: CoachSpeakingState.idle);
    }
  }

  void stopSpeaking() {
    _tts.stop();
    state = state.copyWith(speakingState: CoachSpeakingState.idle);
  }

  void clearChat() {
    _tts.stop();
    _cancelLlmStream();
    state = VoiceCoachState(
      selectedLanguage: state.selectedLanguage,
      isLiveMode: state.isLiveMode,
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _sttSub?.cancel();
    _cancelLlmStream();
    _stt.dispose();
    super.dispose();
  }
}
