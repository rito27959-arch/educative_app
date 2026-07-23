import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/curriculum_data.dart';
import '../../core/data/quiz_data.dart';
import '../../core/models/curriculum_models.dart';
import '../../core/models/quiz_question.dart';
import '../../core/providers/curriculum_provider.dart';
import '../../core/providers/gamification_provider.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../design_system/widgets/ouro_animations.dart';

class BacExamScreen extends ConsumerStatefulWidget {
  final String subjectId;

  const BacExamScreen({
    super.key,
    required this.subjectId,
  });

  @override
  ConsumerState<BacExamScreen> createState() => _BacExamScreenState();
}

class _BacExamScreenState extends ConsumerState<BacExamScreen>
    with TickerProviderStateMixin {
  List<QuizQuestion> _questions = [];
  SubjectCurriculum? _subject;
  bool _isLoading = true;
  bool _showResults = false;
  bool _hasRecordedResult = false;

  int _currentIndex = 0;
  final Map<int, int> _answers = {};
  final Set<int> _flaggedQuestions = {};

  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;

  late AnimationController _confettiController;
  final List<_ParticleData> _particles = [];

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _generateParticles();
    _loadExam();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  void _generateParticles() {
    final rng = Random();
    const colors = [
      OuroColors.meshBlue,
      OuroColors.ouroOrange,
      OuroColors.localGreen,
      OuroColors.accentPurple,
      OuroColors.accentPink,
      OuroColors.accentTeal,
    ];
    _particles.clear();
    for (int i = 0; i < 60; i++) {
      _particles.add(_ParticleData(
        angle: rng.nextDouble() * 2 * pi,
        distance: 100 + rng.nextDouble() * 200,
        size: 6 + rng.nextDouble() * 12,
        color: colors[rng.nextInt(colors.length)],
        delay: rng.nextDouble() * 500,
        rotation: rng.nextDouble() * 360,
      ));
    }
  }

  void _loadExam() {
    _subject = CurriculumData.findById(widget.subjectId);
    final count = _subject?.examQuestionCount ?? 20;
    final allQuestions =
        QuizData.getSubjectExam(widget.subjectId, count: count);
    final durationMinutes = _subject?.examDurationMinutes ?? 240;

    setState(() {
      _questions = allQuestions;
      _totalSeconds = durationMinutes * 60;
      _remainingSeconds = durationMinutes * 60;
      _isLoading = false;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
          _timer?.cancel();
          _submitExam();
        }
      });
    });
  }

  String get _formattedTimer {
    final h = _remainingSeconds ~/ 3600;
    final m = (_remainingSeconds % 3600) ~/ 60;
    final s = _remainingSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get _isTimerLow => _remainingSeconds < 600 && _remainingSeconds > 0;

  void _selectAnswer(int optionIndex) {
    setState(() {
      _answers[_currentIndex] = optionIndex;
    });
  }

  void _toggleFlag() {
    setState(() {
      if (_flaggedQuestions.contains(_currentIndex)) {
        _flaggedQuestions.remove(_currentIndex);
      } else {
        _flaggedQuestions.add(_currentIndex);
      }
    });
  }

  void _submitExam() {
    _timer?.cancel();
    setState(() {
      _showResults = true;
    });
  }

  Map<String, dynamic> _calculateResults() {
    int correct = 0;
    final List<Map<String, dynamic>> details = [];
    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final userAnswer = _answers[i];
      final isCorrect = userAnswer == q.correctIndex;
      if (isCorrect) correct++;
      details.add({
        'question': q.question,
        'options': q.options,
        'correctIndex': q.correctIndex,
        'userAnswer': userAnswer,
        'isCorrect': isCorrect,
        'isFlagged': _flaggedQuestions.contains(i),
      });
    }
    final percentage =
        _questions.isEmpty ? 0.0 : (correct / _questions.length) * 100;
    return {
      'correct': correct,
      'total': _questions.length,
      'percentage': percentage,
      'details': details,
      'passed': percentage >= 60,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: OuroColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: OuroColors.meshBlue),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: OuroColors.background,
        appBar: AppBar(
          backgroundColor: OuroColors.surface,
          leading: IconButton(
            icon: const Icon(Icons.close, color: OuroColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Text('Examen Blanc - Bac ${_subject?.bacSeries ?? 'D'}',
              style: const TextStyle(color: OuroColors.textPrimary)),
        ),
        body: const Center(
          child: Text('Aucune question disponible',
              style: TextStyle(color: OuroColors.textSecondary)),
        ),
      );
    }

    if (_showResults) {
      return _buildResultsScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF040406),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTimerDisplay(),
              Expanded(child: _buildQuestionView()),
              _buildQuestionPalette(),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.grid3x, vertical: DesignTokens.gridSm),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0F),
        border: Border(
            bottom: BorderSide(
                color: OuroColors.glassBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Examen Blanc - Bac ${_subject?.bacSeries ?? 'D'}',
                  style: TextStyle(
                    color: OuroColors.textPrimary,
                    fontSize: DesignTokens.textLg,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                if (_subject != null)
                  Text(
                    '${_subject!.emoji} ${_subject!.title}',
                    style: const TextStyle(
                      color: OuroColors.textSecondary,
                      fontSize: DesignTokens.textSm,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: OuroColors.ouroOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
              border: Border.all(
                  color: OuroColors.ouroOrange.withValues(alpha: 0.3)),
            ),
            child: Text(
              'Coeff. ${_subject?.coefficient ?? 1}',
              style: const TextStyle(
                color: OuroColors.ouroOrange,
                fontSize: DesignTokens.textSm,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: DesignTokens.durationFast);
  }

  Widget _buildTimerDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.grid3x, vertical: DesignTokens.grid2x),
      decoration: BoxDecoration(
        color: _isTimerLow
            ? OuroColors.errorRed.withValues(alpha: 0.06)
            : const Color(0xFF08080C),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer_outlined,
                color: _isTimerLow
                    ? OuroColors.errorRed
                    : OuroColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 10),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: _isTimerLow
                      ? OuroColors.errorRed
                      : OuroColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  letterSpacing: 2,
                ),
                child: Text(_formattedTimer),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 1.0,
                end: _totalSeconds > 0
                    ? _remainingSeconds / _totalSeconds
                    : 0,
              ),
              duration: const Duration(seconds: 1),
              curve: Curves.linear,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                backgroundColor: OuroColors.surfaceElevated,
                valueColor: AlwaysStoppedAnimation(
                  _isTimerLow ? OuroColors.errorRed : OuroColors.meshBlue,
                ),
                minHeight: 4,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: DesignTokens.durationFast);
  }

  Widget _buildQuestionView() {
    final q = _questions[_currentIndex];
    final selectedOption = _answers[_currentIndex];
    final isFlagged = _flaggedQuestions.contains(_currentIndex);
    final letters = ['A', 'B', 'C', 'D'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: OuroColors.meshBlue.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(DesignTokens.radiusFull),
                ),
                child: Text(
                  'Question ${_currentIndex + 1}/${_questions.length}',
                  style: const TextStyle(
                    color: OuroColors.meshBlue,
                    fontSize: DesignTokens.textSm,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _toggleFlag,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isFlagged
                        ? OuroColors.ouroOrange.withValues(alpha: 0.15)
                        : OuroColors.glassBg,
                    borderRadius:
                        BorderRadius.circular(DesignTokens.radiusSm),
                    border: Border.all(
                      color: isFlagged
                          ? OuroColors.ouroOrange.withValues(alpha: 0.4)
                          : OuroColors.glassBorder,
                    ),
                  ),
                  child: Icon(
                    isFlagged ? Icons.flag : Icons.flag_outlined,
                    color: isFlagged
                        ? OuroColors.ouroOrange
                        : OuroColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.grid2x),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(DesignTokens.grid3x),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
              border: Border.all(color: OuroColors.glassBorder),
            ),
            child: Text(
              q.question,
              style: const TextStyle(
                color: OuroColors.textPrimary,
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ).animate().fadeIn(duration: DesignTokens.durationNormal),
          const SizedBox(height: DesignTokens.grid3x),
          ...q.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final option = entry.value;
            final isSelected = selectedOption == idx;
            final letter =
                idx < letters.length ? letters[idx] : '${idx + 1}';

            return Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.gridSm),
              child: GestureDetector(
                onTap: () => _selectAnswer(idx),
                child: AnimatedContainer(
                  duration: DesignTokens.durationNormal,
                  curve: DesignTokens.curveDefault,
                  padding: const EdgeInsets.all(DesignTokens.grid2x),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? OuroColors.meshBlue.withValues(alpha: 0.12)
                        : OuroColors.glassBg,
                    borderRadius:
                        BorderRadius.circular(DesignTokens.radiusLg),
                    border: Border.all(
                      color: isSelected
                          ? OuroColors.meshBlue.withValues(alpha: 0.5)
                          : OuroColors.glassBorder,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? OuroColors.meshBlue
                              : OuroColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(
                              DesignTokens.radiusSm),
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : OuroColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: DesignTokens.textSm,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.grid2x),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected
                                ? OuroColors.textPrimary
                                : OuroColors.textSecondary,
                            fontSize: DesignTokens.textLg,
                            fontWeight: isSelected
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle,
                            color: OuroColors.meshBlue, size: 20),
                    ],
                  ),
                ),
              )
                  .animate(target: isSelected ? 1 : 0)
                  .fadeIn(
                    duration: DesignTokens.durationNormal,
                    delay: (idx * 80).ms,
                  )
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.02, 1.02),
                    duration: 200.ms,
                    curve: DesignTokens.curveSpring,
                  ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionPalette() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.grid2x, vertical: DesignTokens.gridSm),
      decoration: const BoxDecoration(
        color: Color(0xFF08080C),
        border: Border(
            top: BorderSide(color: OuroColors.glassBorder, width: 0.5)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _questions.length,
        itemBuilder: (context, i) {
          final isCurrent = i == _currentIndex;
          final isAnswered = _answers.containsKey(i);
          final isFlagged = _flaggedQuestions.contains(i);

          Color bgColor;
          Color borderColor;
          Color textColor;

          if (isCurrent) {
            bgColor = OuroColors.meshBlue.withValues(alpha: 0.2);
            borderColor = OuroColors.meshBlue;
            textColor = OuroColors.meshBlue;
          } else if (isAnswered) {
            bgColor = OuroColors.meshBlue.withValues(alpha: 0.12);
            borderColor = OuroColors.meshBlue.withValues(alpha: 0.3);
            textColor = OuroColors.meshBlue;
          } else {
            bgColor = OuroColors.surfaceElevated;
            borderColor = OuroColors.glassBorder;
            textColor = OuroColors.textSecondary;
          }

          return GestureDetector(
            onTap: () => setState(() => _currentIndex = i),
            child: Container(
              width: 38,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                border: Border.all(color: borderColor, width: isCurrent ? 1.5 : 1),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: textColor,
                      fontSize: DesignTokens.textSm,
                      fontWeight:
                          isCurrent ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                  if (isFlagged)
                    const Positioned(
                      top: 2,
                      right: 2,
                      child: Icon(
                        Icons.flag,
                        size: 8,
                        color: OuroColors.ouroOrange,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final isLast = _currentIndex == _questions.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.grid3x, vertical: DesignTokens.grid2x),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0F),
        border: Border(
            top: BorderSide(color: OuroColors.glassBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          if (_currentIndex > 0)
            TextButton.icon(
              onPressed: () => setState(() => _currentIndex--),
              icon: const Icon(Icons.arrow_back_ios, size: 16),
              label: const Text('Précédent'),
              style: TextButton.styleFrom(
                foregroundColor: OuroColors.textSecondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            )
          else
            const SizedBox.shrink(),
          const Spacer(),
          if (!isLast)
            ElevatedButton(
              onPressed: () => setState(() => _currentIndex++),
              style: ElevatedButton.styleFrom(
                backgroundColor: OuroColors.meshBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DesignTokens.radiusLg),
                ),
              ),
              child: const Text('Suivant',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            )
          else
            ElevatedButton(
              onPressed: _submitExam,
              style: ElevatedButton.styleFrom(
                backgroundColor: OuroColors.ouroOrange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DesignTokens.radiusLg),
                ),
              ),
              child: const Text('Terminer',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen() {
    final results = _calculateResults();
    final correct = results['correct'] as int;
    final total = results['total'] as int;
    final percentage = results['percentage'] as double;
    final passed = results['passed'] as bool;
    final details = results['details'] as List<Map<String, dynamic>>;

    if (!_hasRecordedResult) {
      _hasRecordedResult = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(curriculumProgressProvider.notifier)
            .recordSubjectExamScore(widget.subjectId, percentage.toInt());
        ref.read(gamificationStateProvider.notifier).recordQuiz(
              perfect: percentage >= 100,
              fast: false,
            );
        if (passed) {
          ref
              .read(gamificationStateProvider.notifier)
              .recordP2pWin();
        }
      });
      if (passed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _confettiController.forward();
        });
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF040406),
      body: Stack(
        children: [
          const AnimatedGradientBackground(child: SizedBox.expand()),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(DesignTokens.grid3x),
                    child: Column(
                      children: [
                        const SizedBox(height: DesignTokens.grid4x),
                        if (passed) ...[
                          _buildCelebrationHeader(),
                          const SizedBox(height: DesignTokens.grid2x),
                          _buildParticleEffect(),
                        ] else
                          _buildFailureHeader(),
                        const SizedBox(height: DesignTokens.grid3x),
                        _buildScoreCard(correct, total, percentage, passed),
                        const SizedBox(height: DesignTokens.grid3x),
                        _buildShareableCard(correct, total, percentage, passed),
                        const SizedBox(height: DesignTokens.grid3x),
                        _buildDetailsList(details),
                        const SizedBox(height: DesignTokens.grid8x),
                      ],
                    ),
                  ),
                ),
                _buildResultsButton(passed),
              ],
            ),
          ),
          if (passed && _showResults) ..._buildConfettiOverlay(),
        ],
      ),
    );
  }

  Widget _buildCelebrationHeader() {
    return Column(
      children: [
        const Icon(
          Icons.emoji_events,
          color: OuroColors.ouroOrange,
          size: 80,
        )
            .animate()
            .scale(duration: 600.ms, curve: DesignTokens.curveBounce)
            .then()
            .rotate(begin: -0.1, end: 0.1, duration: 600.ms, curve: Curves.easeInOut)
            .then()
            .rotate(begin: 0.1, end: 0, duration: 400.ms),
        const SizedBox(height: DesignTokens.grid3x),
        const Text(
          'Bravo !',
          style: TextStyle(
            color: OuroColors.textPrimary,
            fontSize: DesignTokens.text5xl,
            fontWeight: FontWeight.w800,
          ),
        )
            .animate()
            .fadeIn(delay: 300.ms, duration: 500.ms)
            .slideY(begin: 0.3, end: 0, duration: 500.ms),
        const SizedBox(height: DesignTokens.gridSm),
        Text(
          'Tu as réussi l\'examen blanc !',
          style: TextStyle(
            color: OuroColors.textSecondary.withValues(alpha: 0.8),
            fontSize: DesignTokens.textMd,
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildFailureHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(DesignTokens.grid3x),
          decoration: BoxDecoration(
            color: OuroColors.errorRed.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child:
              const Icon(Icons.close, color: OuroColors.errorRed, size: 48),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .shake(hz: 3, duration: 500.ms),
        const SizedBox(height: DesignTokens.grid3x),
        const Text(
          'Échec',
          style: TextStyle(
            color: OuroColors.textPrimary,
            fontSize: DesignTokens.text5xl,
            fontWeight: FontWeight.w800,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        const SizedBox(height: DesignTokens.gridSm),
        Text(
          'Tu dois obtenir au moins 60% pour réussir.',
          style: TextStyle(
            color: OuroColors.textSecondary.withValues(alpha: 0.8),
            fontSize: DesignTokens.textMd,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildParticleEffect() {
    return SizedBox(
      height: 20,
      width: double.infinity,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(8, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: [
                  OuroColors.meshBlue,
                  OuroColors.ouroOrange,
                  OuroColors.localGreen,
                  OuroColors.accentPurple,
                ][i % 4],
                shape: BoxShape.circle,
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.5, 1.5),
                  duration: Duration(milliseconds: 600 + i * 100),
                  delay: (i * 80).ms,
                  curve: Curves.easeInOut,
                )
                .fade(
                  begin: 0.4,
                  end: 1.0,
                  duration: Duration(milliseconds: 600 + i * 100),
                );
          }),
        ),
      ),
    );
  }

  Widget _buildScoreCard(
      int correct, int total, double percentage, bool passed) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      decoration: BoxDecoration(
        color: OuroColors.glassBgStrong,
        borderRadius: BorderRadius.circular(DesignTokens.radius2xl),
        border: Border.all(
          color: passed
              ? OuroColors.successGreen.withValues(alpha: 0.3)
              : OuroColors.errorRed.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          OuroCountUp(
            value: correct,
            suffix: ' / $total',
            style: TextStyle(
              color: passed ? OuroColors.successGreen : OuroColors.errorRed,
              fontSize: DesignTokens.text7xl,
              fontWeight: FontWeight.w800,
            ),
          ).animate().scale(
                duration: 500.ms,
                delay: 300.ms,
                curve: DesignTokens.curveBounce,
              ),
          const SizedBox(height: DesignTokens.gridSm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: (passed ? OuroColors.successGreen : OuroColors.errorRed)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color:
                    passed ? OuroColors.successGreen : OuroColors.errorRed,
                fontSize: DesignTokens.text2xl,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildShareableCard(
      int correct, int total, double percentage, bool passed) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            OuroColors.meshBlue.withValues(alpha: 0.15),
            OuroColors.ouroOrange.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radius2xl),
        border: Border.all(color: OuroColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _subject?.emoji ?? '',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Text(
                '${_subject?.title ?? ''} - Examen Blanc',
                style: const TextStyle(
                  color: OuroColors.textPrimary,
                  fontSize: DesignTokens.textLg,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.grid2x),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: OuroColors.ouroOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: Text(
              'Coeff. ${_subject?.coefficient ?? 1}',
              style: const TextStyle(
                color: OuroColors.ouroOrange,
                fontSize: DesignTokens.textSm,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.grid2x),
          Text(
            '$correct / $total',
            style: TextStyle(
              color: passed ? OuroColors.successGreen : OuroColors.errorRed,
              fontSize: DesignTokens.text4xl,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${percentage.toStringAsFixed(1)}% — ${passed ? 'Admis' : 'Non admis'}',
            style: TextStyle(
              color: passed ? OuroColors.successGreen : OuroColors.errorRed,
              fontSize: DesignTokens.textMd,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: DesignTokens.grid2x),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, color: OuroColors.textSecondary, size: 14),
              const SizedBox(width: 6),
              Text(
                'Bac ${_subject?.bacSeries ?? 'D'}',
                style: const TextStyle(
                  color: OuroColors.textSecondary,
                  fontSize: DesignTokens.textSm,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildDetailsList(List<Map<String, dynamic>> details) {
    final letters = ['A', 'B', 'C', 'D'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Réponses détaillées',
          style: TextStyle(
            color: OuroColors.textPrimary,
            fontSize: DesignTokens.textLg,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: DesignTokens.grid2x),
        ...details.asMap().entries.map((entry) {
          final idx = entry.key;
          final detail = entry.value;
          final isCorrect = detail['isCorrect'] as bool;
          final userAnswer = detail['userAnswer'] as int?;
          final correctIndex = detail['correctIndex'] as int;
          final options = detail['options'] as List<String>;
          final isFlagged = detail['isFlagged'] as bool;

          return Container(
            margin: const EdgeInsets.only(bottom: DesignTokens.gridSm),
            padding: const EdgeInsets.all(DesignTokens.grid2x),
            decoration: BoxDecoration(
              color: isCorrect
                  ? OuroColors.successGreen.withValues(alpha: 0.06)
                  : OuroColors.errorRed.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              border: Border.all(
                color: isCorrect
                    ? OuroColors.successGreen.withValues(alpha: 0.2)
                    : OuroColors.errorRed.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect
                          ? OuroColors.successGreen
                          : OuroColors.errorRed,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Q${idx + 1}',
                        style: const TextStyle(
                          color: OuroColors.textPrimary,
                          fontSize: DesignTokens.textSm,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isFlagged)
                      const Icon(Icons.flag,
                          size: 14, color: OuroColors.ouroOrange),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  detail['question'] as String,
                  style: const TextStyle(
                    color: OuroColors.textSecondary,
                    fontSize: DesignTokens.textSm,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isCorrect) ...[
                  const SizedBox(height: 6),
                  if (userAnswer != null && userAnswer < options.length)
                    Text(
                      'Ta réponse : ${letters[userAnswer]}. ${options[userAnswer]}',
                      style: TextStyle(
                        color: OuroColors.errorRed.withValues(alpha: 0.8),
                        fontSize: DesignTokens.textSm,
                      ),
                    ),
                  Text(
                    'Bonne réponse : ${letters[correctIndex]}. ${options[correctIndex]}',
                    style: const TextStyle(
                      color: OuroColors.successGreen,
                      fontSize: DesignTokens.textSm,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          )
              .animate()
              .fadeIn(
                  delay: (idx * 50).ms, duration: DesignTokens.durationNormal);
        }),
      ],
    );
  }

  Widget _buildResultsButton(bool passed) {
    final results = _calculateResults();
    final correct = results['correct'] as int;
    final total = results['total'] as int;
    return Container(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0F),
        border: Border(
            top: BorderSide(color: OuroColors.glassBorder, width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (passed) {
              context.go(
                '/curriculum/subject/${widget.subjectId}/bac-complete?score=$correct&total=$total',
              );
            } else {
              setState(() {
                _showResults = false;
                _hasRecordedResult = false;
                _currentIndex = 0;
                _answers.clear();
                _flaggedQuestions.clear();
                _isLoading = true;
              });
              _loadExam();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                passed ? OuroColors.successGreen : OuroColors.meshBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            ),
          ),
          child: Text(
            passed ? 'Voir les résultats 🎓' : 'Réessayer',
            style: const TextStyle(
                fontSize: DesignTokens.textLg, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildConfettiOverlay() {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height * 0.35;

    return _particles.map((p) {
      final anim = Tween<double>(begin: 0, end: p.distance).animate(
        CurvedAnimation(
          parent: _confettiController,
          curve: Interval(
            p.delay / 2500,
            min(1.0, (p.delay + 900) / 2500),
            curve: Curves.easeOut,
          ),
        ),
      );

      final fadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _confettiController,
          curve: Interval(
            (p.delay + 700) / 2500,
            min(1.0, (p.delay + 1400) / 2500),
            curve: Curves.easeIn,
          ),
        ),
      );

      return AnimatedBuilder(
        animation: _confettiController,
        builder: (context, _) {
          final val = anim.value;
          final fade = fadeAnim.value;
          final x = centerX + cos(p.angle) * val - p.size / 2;
          final y = centerY + sin(p.angle) * val + val * 0.3 - p.size / 2;
          return Positioned(
            left: x,
            top: y,
            child: Opacity(
              opacity: fade.clamp(0.0, 1.0),
              child: Transform.rotate(
                angle: p.rotation * pi / 180 + val * 0.02,
                child: Container(
                  width: p.size,
                  height: p.size,
                  decoration: BoxDecoration(
                    color: p.color,
                    borderRadius:
                        BorderRadius.circular(p.size > 10 ? 2 : p.size / 2),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }
}

class _ParticleData {
  final double angle;
  final double distance;
  final double size;
  final Color color;
  final double delay;
  final double rotation;

  const _ParticleData({
    required this.angle,
    required this.distance,
    required this.size,
    required this.color,
    required this.delay,
    required this.rotation,
  });
}
