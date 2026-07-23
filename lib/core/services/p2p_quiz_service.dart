import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'mesh_transport_service.dart';
import 'ble_mesh_protocol.dart';
import '../models/course_model.dart';

/// Session de quiz pair-à-pair.
class P2PQuizSession {
  final String sessionId;
  final String peerId;
  final String peerPseudo;
  final String courseId;
  final String chapterId;
  final List<QuizModel> questions;
  final P2PQuizRole role;
  final P2PQuizState state;
  final Map<String, int> myAnswers; // questionId -> answerIndex
  final Map<String, int>? peerAnswers;
  final int? myScore;
  final int? peerScore;

  const P2PQuizSession({
    required this.sessionId,
    required this.peerId,
    required this.peerPseudo,
    required this.courseId,
    required this.chapterId,
    required this.questions,
    required this.role,
    required this.state,
    this.myAnswers = const {},
    this.peerAnswers,
    this.myScore,
    this.peerScore,
  });

  P2PQuizSession copyWith({
    String? sessionId,
    String? peerId,
    String? peerPseudo,
    String? courseId,
    String? chapterId,
    List<QuizModel>? questions,
    P2PQuizRole? role,
    P2PQuizState? state,
    Map<String, int>? myAnswers,
    Map<String, int>? peerAnswers,
    int? myScore,
    int? peerScore,
  }) => P2PQuizSession(
    sessionId: sessionId ?? this.sessionId,
    peerId: peerId ?? this.peerId,
    peerPseudo: peerPseudo ?? this.peerPseudo,
    courseId: courseId ?? this.courseId,
    chapterId: chapterId ?? this.chapterId,
    questions: questions ?? this.questions,
    role: role ?? this.role,
    state: state ?? this.state,
    myAnswers: myAnswers ?? this.myAnswers,
    peerAnswers: peerAnswers ?? this.peerAnswers,
    myScore: myScore ?? this.myScore,
    peerScore: peerScore ?? this.peerScore,
  );
}

enum P2PQuizRole { challenger, opponent }
enum P2PQuizState { waiting, inProgress, completed }

/// Résultat comparé question par question.
class P2PQuizComparison {
  final String question;
  final List<String> options;
  final int correctIndex;
  final int myAnswer;
  final int? peerAnswer;
  final bool iWasRight;
  final bool? peerWasRight;

  const P2PQuizComparison({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.myAnswer,
    this.peerAnswer,
    required this.iWasRight,
    this.peerWasRight,
  });
}

/// Service gérant les quiz pair-à-pair via le mesh.
class P2PQuizService {
  final MeshTransportService _transport;
  final StreamController<P2PQuizSession> _sessionCtrl = StreamController<P2PQuizSession>.broadcast();

  StreamSubscription<MeshIncomingData>? _sub;
  P2PQuizSession? _currentSession;

  Stream<P2PQuizSession> get sessionEvents => _sessionCtrl.stream;
  P2PQuizSession? get currentSession => _currentSession;

  P2PQuizService(this._transport) {
    _sub = _transport.incomingData.listen(_onIncomingData);
  }

  void _onIncomingData(MeshIncomingData data) {
    if (data.data.length < 2) return;
    final type = data.data[1];

    switch (type) {
      case kQuizChallenge:
        _handleChallenge(data);
      case kQuizAccept:
        _handleAccept(data);
      case kQuizAnswerSheet:
        _handleAnswerSheet(data);
      case kQuizResult:
        _handleResult(data);
    }
  }

  /// Envoyer un défi quiz à un pair.
  Future<void> sendChallenge({
    required String peerId,
    required String peerPseudo,
    required String courseId,
    required String chapterId,
    required List<QuizModel> questions,
  }) async {
    final sessionId = _generateId();
    final payload = json.encode({
      'sessionId': sessionId,
      'courseId': courseId,
      'chapterId': chapterId,
      'questions': questions.map((q) => q.toJson()).toList(),
    });

    final encoded = utf8.encode(payload);
    final packet = Uint8List(2 + encoded.length);
    packet[0] = 0;
    packet[1] = kQuizChallenge;
    packet.setRange(2, packet.length, encoded);

    await _transport.sendToPeer(peerId, packet);

    _currentSession = P2PQuizSession(
      sessionId: sessionId,
      peerId: peerId,
      peerPseudo: peerPseudo,
      courseId: courseId,
      chapterId: chapterId,
      questions: questions,
      role: P2PQuizRole.challenger,
      state: P2PQuizState.waiting,
    );
    _sessionCtrl.add(_currentSession!);
    debugPrint('[P2PQuiz] DÉFI envoyé à $peerPseudo ($peerId) session=$sessionId');
  }

  void _handleChallenge(MeshIncomingData data) {
    try {
      final jsonStr = utf8.decode(data.data.sublist(2));
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      final questions = (map['questions'] as List).map((q) => QuizModel.fromJson(q as Map<String, dynamic>)).toList();

      _currentSession = P2PQuizSession(
        sessionId: map['sessionId'] as String,
        peerId: data.peerId,
        peerPseudo: data.peerId,
        courseId: map['courseId'] as String,
        chapterId: map['chapterId'] as String,
        questions: questions,
        role: P2PQuizRole.opponent,
        state: P2PQuizState.waiting,
      );
      _sessionCtrl.add(_currentSession!);
      debugPrint('[P2PQuiz] DÉFI reçu de ${data.peerId} session=${_currentSession!.sessionId}');
    } catch (e) {
      debugPrint('[P2PQuiz] Erreur réception défi: $e');
    }
  }

  /// Accepter un défi.
  Future<void> acceptChallenge() async {
    if (_currentSession == null || _currentSession!.role != P2PQuizRole.opponent) return;

    final payload = json.encode({'sessionId': _currentSession!.sessionId});
    final encoded = utf8.encode(payload);
    final packet = Uint8List(2 + encoded.length);
    packet[0] = 0;
    packet[1] = kQuizAccept;
    packet.setRange(2, packet.length, encoded);

    await _transport.sendToPeer(_currentSession!.peerId, packet);

    _currentSession = _currentSession!.copyWith(state: P2PQuizState.inProgress);
    _sessionCtrl.add(_currentSession!);
    debugPrint('[P2PQuiz] DÉFI accepté');
  }

  void _handleAccept(MeshIncomingData data) {
    if (_currentSession == null || _currentSession!.peerId != data.peerId) return;

    _currentSession = _currentSession!.copyWith(state: P2PQuizState.inProgress);
    _sessionCtrl.add(_currentSession!);
    debugPrint('[P2PQuiz] L\'adversaire a accepté le défi');
  }

  /// Envoyer ses réponses à l'adversaire.
  Future<void> submitAnswers(Map<String, int> answers) async {
    if (_currentSession == null) return;

    final payload = json.encode({
      'sessionId': _currentSession!.sessionId,
      'answers': answers,
    });
    final encoded = utf8.encode(payload);
    final packet = Uint8List(2 + encoded.length);
    packet[0] = 0;
    packet[1] = kQuizAnswerSheet;
    packet.setRange(2, packet.length, encoded);

    await _transport.sendToPeer(_currentSession!.peerId, packet);

    _currentSession = _currentSession!.copyWith(
      myAnswers: answers,
      state: P2PQuizState.completed,
    );
    _sessionCtrl.add(_currentSession!);
    debugPrint('[P2PQuiz] Réponses soumises');
  }

  void _handleAnswerSheet(MeshIncomingData data) {
    if (_currentSession == null || _currentSession!.peerId != data.peerId) return;

    try {
      final jsonStr = utf8.decode(data.data.sublist(2));
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      final peerAnswers = (map['answers'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as num).toInt()),
      );

      _currentSession = _currentSession!.copyWith(
        peerAnswers: peerAnswers,
        state: P2PQuizState.completed,
      );

      // Si les deux ont soumis, calculer les scores
      if (_currentSession!.myAnswers.isNotEmpty && peerAnswers.isNotEmpty) {
        _computeAndSendResult();
      }

      _sessionCtrl.add(_currentSession!);
      debugPrint('[P2PQuiz] Réponses reçues de l\'adversaire');
    } catch (e) {
      debugPrint('[P2PQuiz] Erreur réception réponses: $e');
    }
  }

  void _computeAndSendResult() {
    final session = _currentSession!;
    int myScore = 0;
    int peerScore = 0;

    for (final q in session.questions) {
      if (session.myAnswers[q.id] == q.correctIndex) myScore++;
      if (session.peerAnswers?[q.id] == q.correctIndex) peerScore++;
    }

    final payload = json.encode({
      'sessionId': session.sessionId,
      'myScore': myScore,
      'peerScore': peerScore,
      'answers': session.myAnswers,
    });
    final encoded = utf8.encode(payload);
    final packet = Uint8List(2 + encoded.length);
    packet[0] = 0;
    packet[1] = kQuizResult;
    packet.setRange(2, packet.length, encoded);

    // Envoyer sans await pour ne pas bloquer
    _transport.sendToPeer(session.peerId, packet);

    _currentSession = session.copyWith(
      myScore: myScore,
      peerScore: peerScore,
    );
    _sessionCtrl.add(_currentSession!);
    debugPrint('[P2PQuiz] Résultat: moi=$myScore, adversaire=$peerScore');
  }

  void _handleResult(MeshIncomingData data) {
    if (_currentSession == null || _currentSession!.peerId != data.peerId) return;

    try {
      final jsonStr = utf8.decode(data.data.sublist(2));
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      final peerAnswers = (map['answers'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, (v as num).toInt()),
      );

      _currentSession = _currentSession!.copyWith(
        peerAnswers: peerAnswers,
        myScore: map['peerScore'] as int,
        peerScore: map['myScore'] as int,
        state: P2PQuizState.completed,
      );
      _sessionCtrl.add(_currentSession!);
      debugPrint('[P2PQuiz] Résultat reçu: moi=${_currentSession!.myScore}, adversaire=${_currentSession!.peerScore}');
    } catch (e) {
      debugPrint('[P2PQuiz] Erreur réception résultat: $e');
    }
  }

  /// Génère la comparaison question par question.
  List<P2PQuizComparison> getComparisons() {
    final session = _currentSession;
    if (session == null) return [];

    return session.questions.map((q) {
      final myAns = session.myAnswers[q.id] ?? -1;
      final peerAns = session.peerAnswers?[q.id];
      return P2PQuizComparison(
        question: q.question,
        options: q.options,
        correctIndex: q.correctIndex,
        myAnswer: myAns,
        peerAnswer: peerAns,
        iWasRight: myAns == q.correctIndex,
        peerWasRight: peerAns == q.correctIndex,
      );
    }).toList();
  }

  void reset() {
    _currentSession = null;
  }

  String _generateId() {
    final r = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${r.nextInt(99999)}';
  }

  void dispose() {
    _sub?.cancel();
    _sessionCtrl.close();
  }
}
