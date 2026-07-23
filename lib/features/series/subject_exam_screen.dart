import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/payment_provider.dart';
import '../../core/models/payment_model.dart';
import '../../core/services/gamification_service.dart';
import '../../core/providers/gamification_provider.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';

class SubjectExamScreen extends ConsumerStatefulWidget {
  final String courseId;

  const SubjectExamScreen({
    super.key,
    required this.courseId,
  });

  @override
  ConsumerState<SubjectExamScreen> createState() => _SubjectExamScreenState();
}

class _SubjectExamScreenState extends ConsumerState<SubjectExamScreen>
    with TickerProviderStateMixin {
  Map<String, dynamic>? _examData;
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  bool _showResults = false;
  bool _showCelebration = false;
  bool _hasRecordedResult = false;

  int _currentIndex = 0;
  final Map<int, int> _answers = {};

  Timer? _timer;
  int _remainingSeconds = 0;

  late AnimationController _confettiController;
  final List<_ParticleData> _particles = [];

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
    for (int i = 0; i < 40; i++) {
      _particles.add(_ParticleData(
        angle: rng.nextDouble() * 2 * pi,
        distance: 80 + rng.nextDouble() * 180,
        size: 6 + rng.nextDouble() * 10,
        color: colors[rng.nextInt(colors.length)],
        delay: rng.nextDouble() * 400,
        rotation: rng.nextDouble() * 360,
      ));
    }
  }

  void _loadExam() {
    final exam = GamificationService.getSubjectExam(widget.courseId);
    if (exam == null) {
      setState(() => _isLoading = false);
      return;
    }
    final questions = (exam['questions'] as List<dynamic>?)
            ?.map((q) => Map<String, dynamic>.from(q as Map))
            .toList() ??
        [];
    final durationMinutes = (exam['durationMinutes'] as num?)?.toInt() ?? 240;
    setState(() {
      _examData = exam;
      _questions = questions;
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
    double totalPoints = 0;
    double earnedPoints = 0;
    final Map<String, _SubjectBreakdown> breakdowns = {};
    final List<Map<String, dynamic>> details = [];

    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final correctIdx = (q['correctIndex'] as num?)?.toInt() ?? 0;
      final userAnswer = _answers[i];
      final isCorrect = userAnswer == correctIdx;
      final points = (q['points'] as num?)?.toDouble() ?? 1.0;
      final subject = (q['subject'] as String?) ?? 'Général';

      totalPoints += points;
      if (isCorrect) earnedPoints += points;

      breakdowns.putIfAbsent(subject, () => _SubjectBreakdown(subject: subject));
      breakdowns[subject]!.totalPoints += points;
      if (isCorrect) breakdowns[subject]!.earnedPoints += points;

      details.add({
        'question': q['question'] as String? ?? '',
        'options': (q['options'] as List<dynamic>?)?.cast<String>() ?? [],
        'correctIndex': correctIdx,
        'userAnswer': userAnswer,
        'isCorrect': isCorrect,
        'subject': subject,
        'points': points,
      });
    }

    final percentage = totalPoints > 0 ? (earnedPoints / totalPoints) * 100 : 0.0;
    return {
      'earnedPoints': earnedPoints,
      'totalPoints': totalPoints,
      'percentage': percentage,
      'passed': percentage >= 60,
      'breakdowns': breakdowns,
      'details': details,
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
          title: const Text('Examen final', style: TextStyle(color: OuroColors.textPrimary)),
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
              _buildCoefficientInfo(),
              Expanded(child: _buildQuestionView()),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerBar() {
    return Container(
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
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
                child: Text(_formattedTimer),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: OuroColors.meshBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                ),
                child: Text(
                  '${_currentIndex + 1}/${_questions.length}',
                  style: const TextStyle(
                    color: OuroColors.meshBlue,
                    fontSize: DesignTokens.textSm,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            child: LinearProgressIndicator(
              value: _questions.isNotEmpty ? (_currentIndex + 1) / _questions.length : 0,
              backgroundColor: OuroColors.glassBg,
              valueColor: AlwaysStoppedAnimation(
                _isTimerLow ? OuroColors.errorRed : OuroColors.meshBlue,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: DesignTokens.durationFast);
  }

  Widget _buildCoefficientInfo() {
    final Map<String, double> coefficients = {};
    for (final q in _questions) {
      final subject = (q['subject'] as String?) ?? 'Général';
      final points = (q['points'] as num?)?.toDouble() ?? 1.0;
      coefficients[subject] = (coefficients[subject] ?? 0) + points;
    }

    if (coefficients.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x, vertical: DesignTokens.gridSm),
      padding: const EdgeInsets.all(DesignTokens.grid2x),
      decoration: BoxDecoration(
        color: OuroColors.glassBg,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        border: Border.all(color: OuroColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Coefficients officiels',
            style: TextStyle(
              color: OuroColors.textSecondary,
              fontSize: DesignTokens.textSm,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: coefficients.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: OuroColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                ),
                child: Text(
                  '${e.key} : ${e.value.toStringAsFixed(e.value.truncateToDouble() == e.value ? 0 : 1)}',
                  style: const TextStyle(
                    color: OuroColors.textPrimary,
                    fontSize: DesignTokens.textSm,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: DesignTokens.durationNormal);
  }

  Widget _buildQuestionView() {
    final q = _questions[_currentIndex];
    final options = (q['options'] as List<dynamic>?)?.cast<String>() ?? [];
    final selectedOption = _answers[_currentIndex];
    final subject = q['subject'] as String?;
    final points = (q['points'] as num?)?.toDouble();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (subject != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: OuroColors.accentPurple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                  ),
                  child: Text(
                    subject,
                    style: const TextStyle(
                      color: OuroColors.accentPurple,
                      fontSize: DesignTokens.textSm,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (subject != null && points != null) const SizedBox(width: 8),
              if (points != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: OuroColors.ouroOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                  ),
                  child: Text(
                    '${points.toStringAsFixed(points.truncateToDouble() == points ? 0 : 1)} pt${points > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: OuroColors.ouroOrange,
                      fontSize: DesignTokens.textSm,
                      fontWeight: FontWeight.w500,
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
              ).animate().fadeIn(
                    duration: DesignTokens.durationNormal,
                    delay: (idx * 80).ms,
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
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: OuroColors.meshBlue,
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
    final earnedPoints = results['earnedPoints'] as double;
    final totalPoints = results['totalPoints'] as double;
    final percentage = results['percentage'] as double;
    final passed = results['passed'] as bool;
    final breakdowns = results['breakdowns'] as Map<String, _SubjectBreakdown>;
    final details = results['details'] as List<Map<String, dynamic>>;

    if (passed && !_hasRecordedResult) {
      _hasRecordedResult = true;
      GamificationService.passSubjectExam(_examData!['id'] as String);
      ref.read(walletProvider.notifier).earnReward(RewardType.examPass);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(gamificationStateProvider.notifier).recordQuiz(perfect: percentage >= 100, fast: false);
      });
    }

    return Scaffold(
      backgroundColor: OuroColors.background,
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
                          _buildSubjectFailureHeader(),
                        const SizedBox(height: DesignTokens.grid3x),
                        _buildWeightedScoreCard(earnedPoints, totalPoints, percentage, passed),
                        const SizedBox(height: DesignTokens.grid3x),
                        if (passed) _buildBreakdownSection(breakdowns),
                        const SizedBox(height: DesignTokens.grid3x),
                        _buildSubjectDetailsList(details),
                        const SizedBox(height: DesignTokens.grid8x),
                      ],
                    ),
                  ),
                ),
                _buildResultsButton(passed),
              ],
            ),
          ),
          if (_showCelebration) ..._buildConfettiOverlay(),
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
          'Examen réussi !',
          style: TextStyle(
            color: OuroColors.textPrimary,
            fontSize: DesignTokens.text5xl,
            fontWeight: FontWeight.w800,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.3, end: 0, duration: 500.ms),
        const SizedBox(height: DesignTokens.gridSm),
        Text(
          'Bravo ! Tu as validé l\'examen final.',
          style: TextStyle(
            color: OuroColors.textSecondary.withValues(alpha: 0.8),
            fontSize: DesignTokens.textMd,
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildSubjectFailureHeader() {
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
                .animate(
                  onPlay: (c) => c.repeat(reverse: true),
                )
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

  Widget _buildWeightedScoreCard(double earned, double total, double percentage, bool passed) {
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
          Text(
            '${earned.toStringAsFixed(1)} / ${total.toStringAsFixed(1)}',
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
              color: (passed ? OuroColors.successGreen : OuroColors.errorRed).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: Text(
              '${percentage.toStringAsFixed(1)}%',
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

  Widget _buildBreakdownSection(Map<String, _SubjectBreakdown> breakdowns) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      decoration: BoxDecoration(
        color: OuroColors.glassBg,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        border: Border.all(color: OuroColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Détail par matière',
            style: TextStyle(
              color: OuroColors.textPrimary,
              fontSize: DesignTokens.textLg,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: DesignTokens.grid2x),
          ...breakdowns.values.toList().asMap().entries.map((entry) {
            final idx = entry.key;
            final b = entry.value;
            final pct = b.totalPoints > 0 ? (b.earnedPoints / b.totalPoints) * 100 : 0.0;
            final passed = pct >= 60;

            return Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.gridSm),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          b.subject,
                          style: const TextStyle(
                            color: OuroColors.textPrimary,
                            fontSize: DesignTokens.textMd,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${b.earnedPoints.toStringAsFixed(1)}/${b.totalPoints.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: passed ? OuroColors.successGreen : OuroColors.errorRed,
                          fontSize: DesignTokens.textMd,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (passed ? OuroColors.successGreen : OuroColors.errorRed).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                        ),
                        child: Text(
                          '${pct.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: passed ? OuroColors.successGreen : OuroColors.errorRed,
                            fontSize: DesignTokens.textSm,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                    child: LinearProgressIndicator(
                      value: pct / 100,
                      backgroundColor: OuroColors.surfaceElevated,
                      valueColor: AlwaysStoppedAnimation(
                        passed ? OuroColors.successGreen : OuroColors.errorRed,
                      ),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (idx * 100).ms, duration: DesignTokens.durationNormal);
          }),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildSubjectDetailsList(List<Map<String, dynamic>> details) {
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
          final subject = detail['subject'] as String?;
          final points = detail['points'] as double;
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
                    if (subject != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: OuroColors.accentPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                        ),
                        child: Text(
                          subject,
                          style: const TextStyle(
                            color: OuroColors.accentPurple,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    const SizedBox(width: 6),
                    Text(
                      '${points.toStringAsFixed(points.truncateToDouble() == points ? 0 : 1)} pt',
                      style: const TextStyle(
                        color: OuroColors.ouroOrange,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
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
          ).animate().fadeIn(delay: (idx * 50).ms, duration: DesignTokens.durationNormal);
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
              context.pop();
            } else {
              setState(() {
                _showResults = false;
                _showCelebration = false;
                _currentIndex = 0;
                _answers.clear();
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
            passed ? 'Retour au tableau de bord' : 'Réessayer',
            style: const TextStyle(fontSize: DesignTokens.textLg, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildConfettiOverlay() {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height * 0.35;

    _confettiController.forward();

    return _particles.map((p) {
      final anim = Tween<double>(begin: 0, end: p.distance).animate(
        CurvedAnimation(
          parent: _confettiController,
          curve: Interval(
            p.delay / 2000,
            min(1.0, (p.delay + 800) / 2000),
            curve: Curves.easeOut,
          ),
        ),
      );

      final fadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _confettiController,
          curve: Interval(
            (p.delay + 600) / 2000,
            min(1.0, (p.delay + 1200) / 2000),
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
                    borderRadius: BorderRadius.circular(p.size > 10 ? 2 : p.size / 2),
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

class _SubjectBreakdown {
  final String subject;
  double totalPoints = 0;
  double earnedPoints = 0;

  _SubjectBreakdown({required this.subject});
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
