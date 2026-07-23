import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum SttState { idle, listening, processing, error }

class SttResult {
  final String text;
  final bool isFinal;
  final double confidence;

  const SttResult({
    required this.text,
    this.isFinal = false,
    this.confidence = 0.0,
  });
}

class SttService {
  final SpeechToText _speech = SpeechToText();
  SttState _state = SttState.idle;
  String _lastError = '';
  bool _available = false;
  StreamController<SttResult>? _controller;

  SttState get state => _state;
  bool get available => _available;
  String get lastError => _lastError;
  Stream<SttResult>? get stream => _controller?.stream;

  Future<bool> init() async {
    if (_available) return true;
    try {
      _available = await _speech.initialize(
        onError: (e) {
          _lastError = e.errorMsg;
          debugPrint('[SttService] Error: $e');
        },
        onStatus: (status) {
          debugPrint('[SttService] Status: $status');
        },
      );
      if (_available) {
        _state = SttState.idle;
        debugPrint('[SttService] Initialized');
      }
      return _available;
    } catch (e) {
      _lastError = 'Failed to init: $e';
      _state = SttState.error;
      return false;
    }
  }

  Future<void> startListening({StreamController<SttResult>? controller}) async {
    if (!_available && !await init()) return;

    _controller = controller;
    _state = SttState.listening;

    try {
      await _speech.listen(
        onResult: (result) {
          final sttResult = SttResult(
            text: result.recognizedWords,
            isFinal: result.finalResult,
            confidence: result.confidence,
          );
          _controller?.add(sttResult);
          if (result.finalResult) {
            _state = SttState.idle;
          }
        },
        listenOptions: SpeechListenOptions(
          listenFor: const Duration(seconds: 60),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          localeId: 'fr_FR',
          onDevice: true,
        ),
      );
      debugPrint('[SttService] Listening started');
    } catch (e) {
      _lastError = 'Listen error: $e';
      _state = SttState.error;
    }
  }

  Future<void> stopListening() async {
    try {
      await _speech.stop();
      _state = SttState.idle;
      debugPrint('[SttService] Stopped');
    } catch (e) {
      _lastError = 'Stop error: $e';
    }
  }

  Future<void> cancel() async {
    try {
      await _speech.cancel();
      _state = SttState.idle;
      await _controller?.close();
      _controller = null;
    } catch (e) {
      _lastError = 'Cancel error: $e';
    }
  }

  void dispose() {
    _speech.stop();
    _controller?.close();
  }
}
