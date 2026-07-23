import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/payment_provider.dart';
import '../../core/models/payment_model.dart';
import '../../core/services/gamification_service.dart';
import '../../core/services/ouro_audio_service.dart';
import '../../core/providers/gamification_provider.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../shared/widgets/dialogs.dart';
import '../../design_system/widgets/ouro_animations.dart';

class ChapterExamScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String chapterId;

  const ChapterExamScreen({
    super.key,
    required this.courseId,
    required this.chapterId,
  });

  @override
  ConsumerState<ChapterExamScreen> createState() => _ChapterExamScreenState();
}

class _ChapterExamScreenState extends ConsumerState<ChapterExamScreen> {
  Map<String, dynamic>? _examData;
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  bool _showResults = false;
  bool _hasRecordedResult = false;

  int _currentIndex = 0;
  final Map<int, int> _answers = {};
  final Map<int, Duration> _timePerQuestion = {};
  DateTime? _questionStartTime;

  Timer? _timer;
  int _remainingSeconds = 0;

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
    final exam = GamificationService.getChapterExam(widget.courseId, widget.chapterId);
    if (exam == null) {
      setState(() => _isLoading = false);
      return;
    }
    final questions = (exam['questions'] as List<dynamic>?)
            ?.map((q) => Map<String, dynamic>.from(q as Map))
            .toList() ??
        [];
    final durationMinutes = (exam['durationMinutes'] as num?)?.toInt() ?? 30;
    setState(() {
      _examData = exam;
      _questions = questions;
      _remainingSeconds = durationMinutes * 60;
      _isLoading = false;
      _questionStartTime = DateTime.now();
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

  void _recordTimeForCurrentQuestion() {
    if (_questionStartTime != null) {
      _timePerQuestion[_currentIndex] = DateTime.now().difference(_questionStartTime!);
    }
  }

  void _nextQuestion() {
    _recordTimeForCurrentQuestion();
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _questionStartTime = DateTime.now();
      });
    }
  }

  void _previousQuestion() {
    _recordTimeForCurrentQuestion();
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _questionStartTime = DateTime.now();
      });
    }
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      _answers[_currentIndex] = optionIndex;
    });
  }

  void _submitExam() {
    _recordTimeForCurrentQuestion();
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
      final correctIdx = (q['correctIndex'] as num?)?.toInt() ?? 0;
      final userAnswer = _answers[i];
      final isCorrect = userAnswer == correctIdx;
      if (isCorrect) correct++;
      details.add({
        'question': q['question'] as String? ?? '',
        'options': (q['options'] as List<dynamic>?)?.cast<String>() ?? [],
        'correctIndex': correctIdx,
        'userAnswer': userAnswer,
        'isCorrect': isCorrect,
      });
    }
    final percentage = _questions.isEmpty ? 0.0 : (correct / _questions.length) * 100;
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

    if (_examData == null || _questions.isEmpty) {
      return Scaffold(
        backgroundColor: OuroColors.background,
        appBar: AppBar(
          backgroundColor: OuroColors.surface,
          leading: IconButton(
            icon: const Icon(Icons.close, color: OuroColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text('Examen', style: TextStyle(color: OuroColors.textPrimary)),
        ),
        body: const Center(
          child: Text('Aucun examen disponible', style: TextStyle(color: OuroColors.textSecondary)),
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
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x, vertical: DesignTokens.grid2x),
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
                color: _isTimerLow ? OuroColors.errorRed : OuroColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: _isTimerLow ? OuroColors.errorRed : OuroColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
                child: Text(_formattedTimer),
              ),
              const Spacer(),
              Text(
                '${_currentIndex + 1}/${_questions.length}',
                style: const TextStyle(color: OuroColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: _questions.isNotEmpty ? (_currentIndex + 1) / _questions.length : 0,
              ),
              duration: 400.ms,
              curve: DesignTokens.curveSpring,
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
    final options = (q['options'] as List<dynamic>?)?.cast<String>() ?? [];
    final selectedOption = _answers[_currentIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(DesignTokens.grid3x),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
              border: Border.all(color: OuroColors.glassBorder),
            ),
            child: Text(
              q['question'] as String? ?? '',
              style: const TextStyle(
                color: OuroColors.textPrimary,
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ).animate().fadeIn(duration: DesignTokens.durationNormal),
          const SizedBox(height: DesignTokens.grid3x),
          ...options.asMap().entries.map((entry) {
            final idx = entry.key;
            final option = entry.value;
            final isSelected = selectedOption == idx;
            final letters = ['A', 'B', 'C', 'D'];
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
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
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
                          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : OuroColors.textSecondary,
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
                            color: isSelected ? OuroColors.textPrimary : OuroColors.textSecondary,
                            fontSize: DesignTokens.textLg,
                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: OuroColors.meshBlue, size: 20),
                    ],
                  ),
                ),
                ).animate(target: isSelected ? 1 : 0)
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

  Widget _buildNavigationButtons() {
    final hasAnswer = _answers.containsKey(_currentIndex);
    final isLast = _currentIndex == _questions.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x, vertical: DesignTokens.grid2x),
      decoration: const BoxDecoration(
        color: OuroColors.surface,
        border: Border(top: BorderSide(color: OuroColors.glassBorder, width: 0.5)),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                ),
              ),
              child: const Text('Suivant', style: TextStyle(fontWeight: FontWeight.w600)),
            )
          else
            ElevatedButton(
              onPressed: hasAnswer ? _submitExam : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: OuroColors.ouroOrange,
                disabledBackgroundColor: OuroColors.surfaceElevated,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                ),
              ),
              child: const Text('Terminer', style: TextStyle(fontWeight: FontWeight.w600)),
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

    if (passed && !_hasRecordedResult) {
      _hasRecordedResult = true;
      OuroAudioService().playChapterComplete();
      GamificationService.passChapterExam(_examData!['id'] as String);
      ref.read(walletProvider.notifier).earnReward(RewardType.examPass);
      final hasSpeedAnswer = _timePerQuestion.values.any(
        (d) => d.inSeconds < 5,
      );
      if (hasSpeedAnswer) {
        ref.read(walletProvider.notifier).earnReward(RewardType.speedAnswer);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(gamificationStateProvider.notifier).recordQuiz(perfect: percentage >= 100, fast: false);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showOuroDialog(
          context: context,
          child: OuroSuccessDialog(
            title: 'Chapitre réussi !',
            message: 'Tu as obtenu ${percentage.toStringAsFixed(0)}%. Continue comme ça !',
            buttonLabel: 'Continuer',
          ),
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
                      if (passed) _buildSuccessHeader() else _buildFailureHeader(),
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
            .shimmer(duration: 800.ms, color: OuroColors.successGreen.withValues(alpha: 0.3)),
        const SizedBox(height: DesignTokens.grid3x),
        const Text(
          'Chapitre réussi !',
          style: TextStyle(
            color: OuroColors.textPrimary,
            fontSize: DesignTokens.text4xl,
            fontWeight: FontWeight.w700,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.2, end: 0, duration: 400.ms),
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
          child: const Icon(Icons.close, color: OuroColors.errorRed, size: 48),
        ).animate().fadeIn(duration: 400.ms).shake(hz: 3, duration: 500.ms),
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

  Widget _buildScoreCard(int correct, int total, double percentage, bool passed) {
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
              color: (passed ? OuroColors.successGreen : OuroColors.errorRed).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                color: passed ? OuroColors.successGreen : OuroColors.errorRed,
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
          final letters = ['A', 'B', 'C', 'D'];

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
                      color: isCorrect ? OuroColors.successGreen : OuroColors.errorRed,
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
          ).animate().fadeIn(delay: (idx * 60).ms, duration: DesignTokens.durationNormal);
        }),
      ],
    );
  }

  Widget _buildResultsButton(bool passed) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      decoration: const BoxDecoration(
        color: OuroColors.surface,
        border: Border(top: BorderSide(color: OuroColors.glassBorder, width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (passed) {
              context.go('/learn/${widget.courseId}/${widget.chapterId}/sections');
            } else {
              setState(() {
                _showResults = false;
                _currentIndex = 0;
                _answers.clear();
                _timePerQuestion.clear();
                _isLoading = true;
              });
              _loadExam();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: passed ? OuroColors.successGreen : OuroColors.meshBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            ),
          ),
          child: Text(
            passed ? 'Continuer' : 'Réessayer',
            style: const TextStyle(fontSize: DesignTokens.textLg, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
