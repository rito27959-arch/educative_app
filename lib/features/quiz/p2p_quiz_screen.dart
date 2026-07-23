import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../core/providers/p2p_quiz_provider.dart';
import '../../core/providers/payment_provider.dart';
import '../../core/providers/gamification_provider.dart';
import '../../core/models/payment_model.dart';
import '../../core/services/p2p_quiz_service.dart';

class P2PQuizScreen extends ConsumerStatefulWidget {
  const P2PQuizScreen({super.key});

  @override
  ConsumerState<P2PQuizScreen> createState() => _P2PQuizScreenState();
}

class _P2PQuizScreenState extends ConsumerState<P2PQuizScreen> {
  final Map<String, int> _answers = {};
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<P2PQuizSession?>(p2pQuizProvider, (_, session) {
      if (session == null || session.state != P2PQuizState.completed) return;
      final myScore = session.myScore ?? 0;
      final peerScore = session.peerScore ?? 0;
      if (myScore > peerScore) {
        ref.read(walletProvider.notifier).earnReward(RewardType.p2pChallenge);
        ref.read(gamificationStateProvider.notifier).recordP2pWin();
      }
    });
    final session = ref.watch(p2pQuizProvider);

    if (session == null) {
      return Scaffold(
        backgroundColor: OuroColors.background,
        appBar: _buildAppBar(),
        body: const Center(
          child: Text(
            'Aucune session de quiz active',
            style: TextStyle(color: OuroColors.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: OuroColors.background,
      appBar: _buildAppBar(),
      body: AnimatedGradientBackground(
        child: _buildBody(session),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: OuroColors.surface,
      leading: IconButton(
        icon: const Icon(Icons.close, color: OuroColors.textPrimary),
        onPressed: () {
          ref.read(p2pQuizProvider.notifier).reset();
          context.pop();
        },
      ),
      title: const Text(
        'Quiz P2P',
        style: TextStyle(color: OuroColors.textPrimary),
      ),
      actions: [
        if (_submitted)
          TextButton(
            onPressed: () {
              ref.read(p2pQuizProvider.notifier).reset();
              context.pop();
            },
            child: const Text(
              'Quitter',
              style: TextStyle(color: OuroColors.textSecondary),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(P2PQuizSession session) {
    if (session.state == P2PQuizState.waiting) {
      return _buildWaiting(session);
    }
    if (session.state == P2PQuizState.completed) {
      return _buildResults(session);
    }
    return _buildQuiz(session);
  }

  Widget _buildWaiting(P2PQuizSession session) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: OuroColors.meshBlue),
          const SizedBox(height: 24),
          Text(
            session.role == P2PQuizRole.challenger
                ? 'En attente que ${session.peerPseudo} accepte\u2026'
                : '${session.peerPseudo} te défie !',
            style: const TextStyle(
              color: OuroColors.textPrimary,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${session.questions.length} question${session.questions.length > 1 ? 's' : ''}',
            style: const TextStyle(
              color: OuroColors.textSecondary,
              fontSize: 14,
            ),
          ),
          if (session.role == P2PQuizRole.opponent) ...[
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () =>
                  ref.read(p2pQuizProvider.notifier).acceptChallenge(),
              style: ElevatedButton.styleFrom(
                backgroundColor: OuroColors.localGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Relever le défi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuiz(P2PQuizSession session) {
    final q = session.questions[_currentIndex];
    final progress = (_currentIndex + 1) / session.questions.length;

    return Padding(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Question ${_currentIndex + 1}/${session.questions.length}',
                style: const TextStyle(
                  color: OuroColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: OuroColors.meshBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: OuroColors.meshBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: OuroColors.glassBg,
              valueColor: const AlwaysStoppedAnimation(OuroColors.meshBlue),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            q.question,
            style: const TextStyle(
              color: OuroColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ...q.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final option = entry.value;
            final isSelected = _selectedAnswer == idx;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: _selectedAnswer == null
                    ? () => setState(() => _selectedAnswer = idx)
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? OuroColors.meshBlue.withValues(alpha: 0.15)
                        : OuroColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? OuroColors.meshBlue.withValues(alpha: 0.6)
                          : OuroColors.glassBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? OuroColors.meshBlue
                              : OuroColors.glassBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + idx),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : OuroColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(
                            color: OuroColors.textPrimary,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _selectedAnswer != null ? _nextOrSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: OuroColors.meshBlue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: OuroColors.glassBg,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _currentIndex < session.questions.length - 1
                    ? 'Suivant'
                    : 'Terminer',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextOrSubmit() {
    final session = ref.read(p2pQuizProvider);
    if (session == null || _selectedAnswer == null) return;

    _answers[session.questions[_currentIndex].id] = _selectedAnswer!;

    if (_currentIndex < session.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
    } else {
      _submitted = true;
      ref.read(p2pQuizProvider.notifier).submitAnswers(Map.from(_answers));
    }
  }

  Widget _buildResults(P2PQuizSession session) {
    if (session.myScore == null && session.peerScore == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: OuroColors.meshBlue),
            SizedBox(height: 24),
            Text(
              'En attente des réponses de l\'adversaire\u2026',
              style: TextStyle(
                color: OuroColors.textPrimary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    final myScore = session.myScore ?? 0;
    final peerScore = session.peerScore ?? 0;
    final won = myScore > peerScore;
    final comparisons =
        ref.read(p2pQuizProvider.notifier).getComparisons();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(
            won ? Icons.emoji_events : Icons.trending_flat,
            color: won ? OuroColors.ouroOrange : OuroColors.textSecondary,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            won
                ? 'Tu as gagné !'
                : myScore == peerScore
                    ? 'Égalité !'
                    : '${session.peerPseudo} a gagné',
            style: TextStyle(
              color: won
                  ? OuroColors.textPrimary
                  : OuroColors.textSecondary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _scoreCard('Toi', myScore, won, session.questions.length),
              const SizedBox(width: 24),
              _scoreCard(
                session.peerPseudo,
                peerScore,
                !won && myScore != peerScore,
                session.questions.length,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Comparaison',
              style: TextStyle(
                color: OuroColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...comparisons.map((c) => _comparisonTile(c)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(p2pQuizProvider.notifier).reset();
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: OuroColors.meshBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Terminer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreCard(
    String label,
    int score,
    bool highlight,
    int total,
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: highlight
            ? OuroColors.localGreen.withValues(alpha: 0.1)
            : OuroColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight
              ? OuroColors.localGreen.withValues(alpha: 0.4)
              : OuroColors.glassBorder,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: OuroColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$score/$total',
            style: TextStyle(
              color: highlight
                  ? OuroColors.localGreen
                  : OuroColors.textPrimary,
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _comparisonTile(P2PQuizComparison c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: OuroColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OuroColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            c.question,
            style: const TextStyle(
              color: OuroColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _chip('Toi', c.iWasRight),
              const SizedBox(width: 8),
              if (c.peerAnswer != null)
                _chip('Adversaire', c.peerWasRight ?? false),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Bonne réponse: ${c.options[c.correctIndex]}',
            style: const TextStyle(
              color: OuroColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool correct) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: correct
            ? OuroColors.localGreen.withValues(alpha: 0.15)
            : OuroColors.errorRed.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            correct ? Icons.check_circle : Icons.cancel,
            color: correct
                ? OuroColors.localGreen
                : OuroColors.errorRed,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: correct
                  ? OuroColors.localGreen
                  : OuroColors.errorRed,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
