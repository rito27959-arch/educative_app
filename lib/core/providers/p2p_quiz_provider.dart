import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';
import '../services/p2p_quiz_service.dart';
import 'mesh_provider.dart';

/// Provider pour le quiz pair-à-pair.
final p2pQuizProvider = StateNotifierProvider<P2PQuizNotifier, P2PQuizSession?>((ref) {
  final repo = ref.watch(meshRepositoryProvider);
  final service = P2PQuizService(repo.transport);
  return P2PQuizNotifier(service);
});

class P2PQuizNotifier extends StateNotifier<P2PQuizSession?> {
  final P2PQuizService _service;
  StreamSubscription<P2PQuizSession>? _sub;

  P2PQuizNotifier(this._service) : super(null) {
    _sub = _service.sessionEvents.listen((session) {
      state = session;
    });
  }

  P2PQuizService get service => _service;

  Future<void> sendChallenge({
    required String peerId,
    required String peerPseudo,
    required String courseId,
    required String chapterId,
    required List<QuizModel> questions,
  }) async {
    await _service.sendChallenge(
      peerId: peerId,
      peerPseudo: peerPseudo,
      courseId: courseId,
      chapterId: chapterId,
      questions: questions,
    );
  }

  Future<void> acceptChallenge() => _service.acceptChallenge();

  Future<void> submitAnswers(Map<String, int> answers) => _service.submitAnswers(answers);

  List<P2PQuizComparison> getComparisons() => _service.getComparisons();

  void reset() {
    _service.reset();
    state = null;
  }

  @override
  void dispose() {
    _sub?.cancel();
    _service.dispose();
    super.dispose();
  }
}
