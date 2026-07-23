import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/curriculum_data.dart';
import '../../core/data/quiz_data.dart';
import '../../core/models/quiz_question.dart';
import '../../core/providers/curriculum_provider.dart';
import '../../core/providers/gamification_provider.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../design_system/widgets/ouro_animations.dart';

class CurriculumChapterExamScreen extends ConsumerStatefulWidget {
  final String subjectId;
  final String chapterId;

  const CurriculumChapterExamScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  @override
  ConsumerState<CurriculumChapterExamScreen> createState() =>
      _CurriculumChapterExamScreenState();
}

class _CurriculumChapterExamScreenState
    extends ConsumerState<CurriculumChapterExamScreen> {
  List<QuizQuestion> _questions = [];
  bool _isLoading = true;
  bool _showResults = false;
  bool _hasRecordedResult = false;

  int _currentIndex = 0;
  final Map<int, int> _answers = {};

  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _loadExam();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadExam() {
    final allQuestions = QuizData.getQuestionsForChapter(widget.chapterId);
    final shuffled = List<QuizQuestion>.from(allQuestions)..shuffle(Random());
    final selected = shuffled.take(10).toList();

    final chapter = CurriculumData.findChapterById(widget.chapterId);
    final durationMinutes = chapter?.examDurationMinutes ?? 30;

    setState(() {
      _questions = selected;
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
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get _isTimerLow => _remainingSeconds < 300 && _remainingSeconds > 0;

  double get _timerProgress =>
      _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0;

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      _answers[_currentIndex] = optionIndex;
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
          title: const Text('Examen de chapitre',
              style: TextStyle(color: OuroColors.textPrimary)),
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
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildTimerBar(),
              Expanded(child: _buildQuestionView()),
              _buildProgressDots(),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.grid3x, vertical: DesignTokens.grid2x),
      decoration: BoxDecoration(
        color: _isTimerLow
            ? OuroColors.errorRed.withValues(alpha: 0.08)
            : OuroColors.surface,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color:
                    _isTimerLow ? OuroColors.errorRed : OuroColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: _isTimerLow
                      ? OuroColors.errorRed
                      : OuroColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
                child: Text(_formattedTimer),
              ),
              const Spacer(),
              Text(
                '${_currentIndex + 1}/${_questions.length}',
                style: const TextStyle(
                    color: OuroColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: _timerProgress),
              duration: const Duration(seconds: 1),
              curve: Curves.linear,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                backgroundColor: OuroColors.glassBg,
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
    final letters = ['A', 'B', 'C', 'D'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${_currentIndex + 1}/${_questions.length}',
            style: const TextStyle(
              color: OuroColors.textSecondary,
              fontSize: DesignTokens.textSm,
              fontWeight: FontWeight.w600,
            ),
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
            final letter = idx < letters.length ? letters[idx] : '${idx + 1}';

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
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusSm),
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
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.normal,
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

  Widget _buildProgressDots() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.grid3x, vertical: DesignTokens.gridSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_questions.length, (i) {
          final isAnswered = _answers.containsKey(i);
          final isCurrent = i == _currentIndex;
          return GestureDetector(
            onTap: () => setState(() => _currentIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isCurrent ? 10 : 8,
              height: isCurrent ? 10 : 8,
              decoration: BoxDecoration(
                color: isAnswered
                    ? OuroColors.meshBlue
                    : isCurrent
                        ? OuroColors.textSecondary
                        : OuroColors.surfaceElevated,
                shape: BoxShape.circle,
                border: isCurrent
                    ? Border.all(color: OuroColors.meshBlue, width: 1.5)
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final hasAnswer = _answers.containsKey(_currentIndex);
    final isLast = _currentIndex == _questions.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.grid3x, vertical: DesignTokens.grid2x),
      decoration: const BoxDecoration(
        color: OuroColors.surface,
        border: Border(
            top: BorderSide(color: OuroColors.glassBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          if (_currentIndex > 0)
            TextButton.icon(
              onPressed: _previousQuestion,
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
              onPressed: hasAnswer ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: OuroColors.meshBlue,
                disabledBackgroundColor: OuroColors.surfaceElevated,
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
              onPressed: hasAnswer ? _submitExam : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: OuroColors.ouroOrange,
                disabledBackgroundColor: OuroColors.surfaceElevated,
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
            .recordChapterExamScore(widget.chapterId, percentage.toInt());
        ref.read(gamificationStateProvider.notifier).recordQuiz(
              perfect: percentage >= 100,
              fast: false,
            );
      });
    }

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(DesignTokens.grid3x),
                  child: Column(
                    children: [
                      const SizedBox(height: DesignTokens.grid4x),
                      if (passed)
                        _buildSuccessHeader()
                      else
                        _buildFailureHeader(),
                      const SizedBox(height: DesignTokens.grid3x),
                      _buildScoreCard(correct, total, percentage, passed),
                      const SizedBox(height: DesignTokens.grid3x),
                      _buildDetailsList(details),
                      const SizedBox(height: DesignTokens.grid4x),
                    ],
                  ),
                ),
              ),
              _buildResultsButton(passed),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        const Icon(
          Icons.check_circle,
          color: OuroColors.successGreen,
          size: 72,
        )
            .animate()
            .scale(
              duration: 600.ms,
              curve: DesignTokens.curveBounce,
            )
            .then()
            .shimmer(
                duration: 800.ms,
                color: OuroColors.successGreen.withValues(alpha: 0.3)),
        const SizedBox(height: DesignTokens.grid3x),
        const Text(
          'Chapitre réussi !',
          style: TextStyle(
            color: OuroColors.textPrimary,
            fontSize: DesignTokens.text4xl,
            fontWeight: FontWeight.w700,
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 400.ms),
        const SizedBox(height: DesignTokens.gridSm),
        Text(
          'Félicitations ! Tu as validé ce chapitre.',
          style: TextStyle(
            color: OuroColors.textSecondary.withValues(alpha: 0.8),
            fontSize: DesignTokens.textMd,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
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
            fontSize: DesignTokens.text4xl,
            fontWeight: FontWeight.w700,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: (passed ? OuroColors.successGreen : OuroColors.errorRed)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
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

  Widget _buildDetailsList(List<Map<String, dynamic>> details) {
    final letters = ['A', 'B', 'C', 'D'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détail des réponses',
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
              .fadeIn(delay: (idx * 60).ms, duration: DesignTokens.durationNormal);
        }),
      ],
    );
  }

  Widget _buildResultsButton(bool passed) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      decoration: const BoxDecoration(
        color: OuroColors.surface,
        border: Border(
            top: BorderSide(color: OuroColors.glassBorder, width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (passed) {
              final subject = CurriculumData.findById(widget.subjectId);
              final chapter = CurriculumData.findChapterById(widget.chapterId);
              if (subject != null && chapter != null) {
                final currentIdx = subject.chapters.indexWhere((c) => c.id == widget.chapterId);
                if (currentIdx < subject.chapters.length - 1) {
                  final nextChapter = subject.chapters[currentIdx + 1];
                  context.go(
                    '/curriculum/subject/${widget.subjectId}/chapter/${nextChapter.id}/unlock',
                  );
                } else {
                  context.go('/curriculum/subject/${widget.subjectId}');
                }
              } else {
                context.pop();
              }
            } else {
              setState(() {
                _showResults = false;
                _hasRecordedResult = false;
                _currentIndex = 0;
                _answers.clear();
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
            passed ? 'Continuer' : 'Réessayer',
            style: const TextStyle(
                fontSize: DesignTokens.textLg, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
