import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/payment_provider.dart';
import '../../core/models/payment_model.dart';
import '../../core/services/gamification_service.dart';
import '../../core/services/reasoning_engine.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';

class SectionPlayerScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String chapterId;

  const SectionPlayerScreen({
    super.key,
    required this.courseId,
    required this.chapterId,
  });

  @override
  ConsumerState<SectionPlayerScreen> createState() => _SectionPlayerScreenState();
}

class _SectionPlayerScreenState extends ConsumerState<SectionPlayerScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _sections = [];
  bool _loading = true;
  bool _allComplete = false;

  // Quiz state
  int _quizQuestionIndex = 0;
  int _quizCorrectCount = 0;
  int? _quizSelectedOption;
  bool _quizAnswered = false;
  bool _quizFinished = false;

  // Exercise state
  final TextEditingController _exerciseController = TextEditingController();
  ReasoningEvaluationResult? _exerciseResult;
  int _exerciseAttempts = 0;

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    super.dispose();
  }

  void _loadSections() {
    final sections = GamificationService.getSections(widget.courseId, widget.chapterId);
    _sections = sections;
    for (int i = 0; i < _sections.length; i++) {
      if (!GamificationService.state.completedSections.contains(_sections[i]['id'])) {
        _currentIndex = i;
        break;
      }
    }
    setState(() => _loading = false);
  }

  Map<String, dynamic> get _currentSection => _sections[_currentIndex];

  bool get _isCurrentSectionUnlocked =>
      GamificationService.isSectionUnlocked(
        _currentSection['id'] as String,
        widget.courseId,
        widget.chapterId,
      );

  void _onLessonContinue() {
    GamificationService.completeSection(_currentSection['id'] as String);
    _advance();
  }

  void _onQuizAnswer(int optionIndex) {
    if (_quizAnswered) return;
    final options = List<String>.from(_currentSection['quiz'][_quizQuestionIndex]['options']);
    final correctAnswer = _currentSection['quiz'][_quizQuestionIndex]['correctAnswer'] as String;
    setState(() {
      _quizSelectedOption = optionIndex;
      _quizAnswered = true;
      if (options[optionIndex] == correctAnswer) {
        _quizCorrectCount++;
      }
    });
  }

  void _onQuizNext() {
    final questions = _currentSection['quiz'] as List;
    if (_quizQuestionIndex < questions.length - 1) {
      setState(() {
        _quizQuestionIndex++;
        _quizSelectedOption = null;
        _quizAnswered = false;
      });
    } else {
      setState(() => _quizFinished = true);
    }
  }

  void _onQuizFinish() {
    final questions = _currentSection['quiz'] as List;
    final score = _quizCorrectCount / questions.length;
    if (score >= 0.8) {
      GamificationService.completeSection(_currentSection['id'] as String);
      if (score == 1.0) {
        ref.read(walletProvider.notifier).earnReward(RewardType.perfectLesson);
      }
      _advance();
    } else {
      setState(() {
        _quizQuestionIndex = 0;
        _quizCorrectCount = 0;
        _quizSelectedOption = null;
        _quizAnswered = false;
        _quizFinished = false;
      });
    }
  }

  void _onExerciseSubmit() {
    final answer = _exerciseController.text.trim();
    if (answer.isEmpty) return;
    final expected = (_currentSection['exercise'] as Map<String, dynamic>)['expectedAnswer'] as String;
    final result = ReasoningEngine.evaluate(studentAnswer: answer, expectedAnswer: expected);
    setState(() {
      _exerciseAttempts++;
      _exerciseResult = result;
    });
    if (result.passed) {
      GamificationService.completeSection(_currentSection['id'] as String);
    }
  }

  void _onExerciseContinue() {
    _exerciseController.clear();
    _exerciseResult = null;
    _exerciseAttempts = 0;
    _advance();
  }

  void _advance() {
    if (_currentIndex < _sections.length - 1) {
      setState(() {
        _currentIndex++;
        _resetSectionState();
      });
    } else {
      setState(() => _allComplete = true);
    }
  }

  void _resetSectionState() {
    _quizQuestionIndex = 0;
    _quizCorrectCount = 0;
    _quizSelectedOption = null;
    _quizAnswered = false;
    _quizFinished = false;
    _exerciseController.clear();
    _exerciseResult = null;
    _exerciseAttempts = 0;
  }

  void _goBack() {
    context.go('/learn/${widget.courseId}/${widget.chapterId}');
  }

  int _sectionType(Map<String, dynamic> s) => s['type'] as int? ?? 0;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: OuroColors.background,
        body: Center(child: CircularProgressIndicator(color: OuroColors.meshBlue)),
      );
    }

    if (_allComplete) return _buildCompletionScreen();

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              _buildProgressBar(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: DesignTokens.durationSlow,
                  switchInCurve: DesignTokens.curveEmphasis,
                  switchOutCurve: DesignTokens.curveEmphasis,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.15, 0),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey<int>(_currentIndex),
                    child: _buildCurrentSection(),
                  ),
                ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  // ─── TOP BAR ──────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.grid2x, DesignTokens.gridBase, DesignTokens.grid2x, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: _goBack,
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: OuroColors.textSecondary, size: 22),
          ),
          SizedBox(width: DesignTokens.grid2x),
          Expanded(
            child: Text(
              'Section ${_currentIndex + 1}/${_sections.length}',
              style: const TextStyle(
                color: OuroColors.textPrimary,
                fontSize: DesignTokens.textLg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── PROGRESS BAR ─────────────────────────────────────────────────

  Widget _buildProgressBar() {
    final progress = (_currentIndex + 1) / _sections.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.grid3x, DesignTokens.gridMd, DesignTokens.grid3x, DesignTokens.gridBase),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          backgroundColor: OuroColors.glassBg,
          valueColor: const AlwaysStoppedAnimation<Color>(OuroColors.meshBlue),
        ),
      ),
    );
  }

  // ─── SECTION ROUTER ───────────────────────────────────────────────

  Widget _buildCurrentSection() {
    if (!_isCurrentSectionUnlocked) return _buildLockedOverlay();

    final type = _sectionType(_currentSection);
    switch (type) {
      case 0:
        return _buildLessonView();
      case 1:
        return _buildQuizView();
      case 2:
        return _buildExerciseView();
      default:
        return _buildLessonView();
    }
  }

  // ─── LOCKED ───────────────────────────────────────────────────────

  Widget _buildLockedOverlay() {
    return Center(
      key: const ValueKey('locked'),
      child: Padding(
        padding: DesignTokens.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: OuroColors.textSecondary)
                .animate()
                .fadeIn(duration: DesignTokens.durationNormal, curve: DesignTokens.curveEmphasis),
            SizedBox(height: DesignTokens.grid3x),
            const Text(
              'Section verrouillée',
              style: TextStyle(
                color: OuroColors.textPrimary,
                fontSize: DesignTokens.text3xl,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: DesignTokens.grid2x),
            const Text(
              'Terminez la section précédente',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: OuroColors.textSecondary,
                fontSize: DesignTokens.textMd,
              ),
            ),
            SizedBox(height: DesignTokens.grid4x),
            _glassButton(
              label: 'Retour',
              icon: Icons.arrow_back,
              onTap: () {
                if (_currentIndex > 0) {
                  setState(() {
                    _currentIndex--;
                    _resetSectionState();
                  });
                } else {
                  _goBack();
                }
              },
            ),
          ],
        ),
      ).animate().fadeIn(duration: DesignTokens.durationSlow, curve: DesignTokens.curveEmphasis),
    );
  }

  // ─── LESSON ───────────────────────────────────────────────────────

  Widget _buildLessonView() {
    final title = _currentSection['title'] as String? ?? '';
    final content = _currentSection['content'] as String? ?? '';

    return Padding(
      key: const ValueKey('lesson'),
      padding: DesignTokens.hPaddingLg,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: DesignTokens.grid2x, bottom: DesignTokens.grid3x),
              child: _glassCard(
                child: Padding(
                  padding: DesignTokens.paddingLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: OuroColors.textPrimary,
                          fontSize: DesignTokens.text2xl,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: DesignTokens.grid2x),
                      Text(
                        content,
                        style: const TextStyle(
                          color: OuroColors.textSecondary,
                          fontSize: DesignTokens.textMd,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.grid3x),
            child: _brandButton(label: 'Continuer', onTap: _onLessonContinue),
          ),
        ],
      ),
    );
  }

  // ─── QUIZ ─────────────────────────────────────────────────────────

  Widget _buildQuizView() {
    if (_quizFinished) return _buildQuizScore();

    final questions = (_currentSection['quiz'] as List).cast<Map<String, dynamic>>();
    final q = questions[_quizQuestionIndex];
    final options = List<String>.from(q['options'] as List);
    final correctAnswer = q['correctAnswer'] as String;

    return Padding(
      key: const ValueKey('quiz'),
      padding: DesignTokens.hPaddingLg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: DesignTokens.gridBase, bottom: DesignTokens.gridBase),
            child: Text(
              'Question ${_quizQuestionIndex + 1}/${questions.length}',
              style: const TextStyle(
                color: OuroColors.textSecondary,
                fontSize: DesignTokens.textSm,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: DesignTokens.grid2x),
              child: _glassCard(
                child: Padding(
                  padding: DesignTokens.paddingLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q['question'] as String,
                        style: const TextStyle(
                          color: OuroColors.textPrimary,
                          fontSize: DesignTokens.textXl,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: DesignTokens.grid3x),
                      ...List.generate(options.length, (i) {
                        final option = options[i];
                        final isSelected = _quizSelectedOption == i;
                        final isCorrect = option == correctAnswer;
                        Color borderColor = OuroColors.glassBorder;
                        Color bg = OuroColors.glassBg;

                        if (_quizAnswered && isSelected) {
                          borderColor = isCorrect ? OuroColors.successGreen : OuroColors.errorRed;
                          bg = isCorrect
                              ? OuroColors.successGreen.withValues(alpha: 0.12)
                              : OuroColors.errorRed.withValues(alpha: 0.12);
                        } else if (_quizAnswered && isCorrect) {
                          borderColor = OuroColors.successGreen.withValues(alpha: 0.5);
                        }

                        return GestureDetector(
                          onTap: () => _onQuizAnswer(i),
                          child: AnimatedContainer(
                            duration: DesignTokens.durationFast,
                            margin: const EdgeInsets.only(bottom: DesignTokens.gridBase + 2),
                            padding: DesignTokens.paddingMd,
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                              border: Border.all(color: borderColor, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _quizAnswered && isSelected
                                        ? (isCorrect ? OuroColors.successGreen : OuroColors.errorRed)
                                        : OuroColors.glassBg,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    String.fromCharCode(65 + i),
                                    style: TextStyle(
                                      color: _quizAnswered && isSelected
                                          ? Colors.white
                                          : OuroColors.textSecondary,
                                      fontSize: DesignTokens.textSm,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(width: DesignTokens.gridBase + 6),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: _quizAnswered && isCorrect
                                          ? OuroColors.successGreen
                                          : OuroColors.textPrimary,
                                      fontSize: DesignTokens.textMd,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_quizAnswered)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.grid3x),
              child: _brandButton(
                label: _quizQuestionIndex < questions.length - 1 ? 'Suivant' : 'Voir le score',
                onTap: _onQuizNext,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuizScore() {
    final questions = (_currentSection['quiz'] as List).cast<Map<String, dynamic>>();
    final score = _quizCorrectCount / questions.length;
    final passed = score >= 0.8;

    return Center(
      key: const ValueKey('quiz-score'),
      child: Padding(
        padding: DesignTokens.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed ? Icons.check_circle : Icons.cancel,
              size: 72,
              color: passed ? OuroColors.successGreen : OuroColors.errorRed,
            ).animate().scale(
              duration: DesignTokens.durationSlow,
              curve: DesignTokens.curveSpring,
            ),
            SizedBox(height: DesignTokens.grid3x),
            Text(
              passed ? 'Bravo !' : 'Pas assez...',
              style: const TextStyle(
                color: OuroColors.textPrimary,
                fontSize: DesignTokens.text3xl,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: DesignTokens.grid2x),
            Text(
              '$_quizCorrectCount/${questions.length} correct (${(score * 100).round()}%)',
              style: TextStyle(
                color: passed ? OuroColors.successGreen : OuroColors.errorRed,
                fontSize: DesignTokens.textLg,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!passed) ...[
              SizedBox(height: DesignTokens.grid2x),
              const Text(
                '80% minimum requis. Réessayez !',
                style: TextStyle(color: OuroColors.textSecondary, fontSize: DesignTokens.textMd),
              ),
            ],
            SizedBox(height: DesignTokens.grid4x),
            _brandButton(
              label: passed ? 'Continuer' : 'Réessayer',
              onTap: _onQuizFinish,
            ),
          ],
        ),
      ).animate().fadeIn(duration: DesignTokens.durationSlow, curve: DesignTokens.curveEmphasis),
    );
  }

  // ─── EXERCISE ─────────────────────────────────────────────────────

  Widget _buildExerciseView() {
    final ex = _currentSection['exercise'] as Map<String, dynamic>;
    final title = _currentSection['title'] as String? ?? '';
    final question = ex['question'] as String;
    final hint = ex['hint'] as String?;
    final passed = _exerciseResult?.passed ?? false;

    return Padding(
      key: const ValueKey('exercise'),
      padding: DesignTokens.hPaddingLg,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: DesignTokens.grid2x, bottom: DesignTokens.grid3x),
              child: Column(
                children: [
                  _glassCard(
                    child: Padding(
                      padding: DesignTokens.paddingLg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: OuroColors.textPrimary,
                              fontSize: DesignTokens.text2xl,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: DesignTokens.grid2x),
                          Text(
                            question,
                            style: const TextStyle(
                              color: OuroColors.textSecondary,
                              fontSize: DesignTokens.textLg,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: DesignTokens.grid2x),
                  _glassCard(
                    child: Padding(
                      padding: DesignTokens.paddingLg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Votre réponse',
                            style: TextStyle(
                              color: OuroColors.textSecondary,
                              fontSize: DesignTokens.textSm,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: DesignTokens.gridBase + 2),
                          TextField(
                            controller: _exerciseController,
                            enabled: _exerciseResult == null,
                            maxLines: null,
                            style: const TextStyle(
                              color: OuroColors.textPrimary,
                              fontSize: DesignTokens.textMd,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Tapez votre raisonnement ici...',
                              hintStyle: const TextStyle(color: OuroColors.textSecondary),
                              filled: true,
                              fillColor: OuroColors.glassBg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                                borderSide: const BorderSide(color: OuroColors.glassBorder),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                                borderSide: const BorderSide(color: OuroColors.glassBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                                borderSide: const BorderSide(color: OuroColors.meshBlue, width: 1.5),
                              ),
                            ),
                          ),
                          if (_exerciseResult != null) ...[
                            SizedBox(height: DesignTokens.grid2x),
                            _buildReasoningScore(),
                          ],
                          if (_exerciseAttempts >= 1 && !passed && hint != null) ...[
                            SizedBox(height: DesignTokens.gridBase + 4),
                            Container(
                              padding: DesignTokens.paddingMd,
                              decoration: BoxDecoration(
                                color: OuroColors.accentPurple.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                                border: Border.all(color: OuroColors.accentPurple.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.lightbulb_outline, size: 18, color: OuroColors.accentPurple),
                                  SizedBox(width: DesignTokens.gridBase + 2),
                                  Expanded(
                                    child: Text(
                                      'Indice : $hint',
                                      style: const TextStyle(
                                        color: OuroColors.accentPurple,
                                        fontSize: DesignTokens.textSm,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.grid3x),
            child: passed
                ? _brandButton(label: 'Continuer', onTap: _onExerciseContinue)
                : _brandButton(
                    label: 'Valider',
                    onTap: _onExerciseSubmit,
                    color: OuroColors.accentPurple,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasoningScore() {
    final r = _exerciseResult!;
    final passColor = r.passed ? OuroColors.successGreen : OuroColors.ouroOrange;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              r.passed ? Icons.check_circle : Icons.info_outline,
              size: 20,
              color: passColor,
            ),
            SizedBox(width: DesignTokens.gridBase + 2),
            Text(
              r.passed ? 'Raisonnement validé' : 'Raisonnement à améliorer',
              style: TextStyle(
                color: passColor,
                fontSize: DesignTokens.textMd,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: DesignTokens.gridBase + 4),
        _buildScoreBar('Concepts', r.conceptScore, OuroColors.meshBlue),
        SizedBox(height: DesignTokens.gridBase),
        _buildScoreBar('Raisonnement', r.reasoningScore, OuroColors.accentPurple),
        SizedBox(height: DesignTokens.gridBase),
        _buildScoreBar('Pertinence', r.relevanceScore, OuroColors.ouroOrange),
        SizedBox(height: DesignTokens.gridBase + 4),
        Container(
          width: double.infinity,
          padding: DesignTokens.paddingMd,
          decoration: BoxDecoration(
            color: (r.passed ? OuroColors.successGreen : OuroColors.glassBg).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            border: Border.all(
              color: (r.passed ? OuroColors.successGreen : OuroColors.glassBorder).withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            r.feedback,
            style: TextStyle(
              color: r.passed ? OuroColors.successGreen : OuroColors.textSecondary,
              fontSize: DesignTokens.textSm,
              height: 1.4,
            ),
          ),
        ),
        if (!r.passed && r.conceptsMissing.isNotEmpty) ...[
          SizedBox(height: DesignTokens.gridBase + 4),
          Text(
            'Concepts à approfondir : ${r.conceptsMissing.join(', ')}',
            style: const TextStyle(
              color: OuroColors.textSecondary,
              fontSize: DesignTokens.textSm,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScoreBar(String label, double score, Color color) {
    final pct = (score / 100).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: OuroColors.textSecondary,
                fontSize: DesignTokens.textSm,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${score.round()}%',
              style: TextStyle(
                color: color,
                fontSize: DesignTokens.textSm,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: DesignTokens.gridBase - 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 5,
            backgroundColor: OuroColors.glassBg,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // ─── COMPLETION ───────────────────────────────────────────────────

  Widget _buildCompletionScreen() {
    final subjectExamReady = GamificationService.isSubjectExamUnlocked(widget.courseId);

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: SafeArea(
        child: Padding(
          padding: DesignTokens.paddingXl,
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.celebration, size: 80, color: OuroColors.successGreen)
                  .animate()
                  .scale(duration: DesignTokens.durationXXSlow, curve: DesignTokens.curveBounce)
                  .then(delay: DesignTokens.durationFast)
                  .shimmer(color: OuroColors.successGreen.withValues(alpha: 0.3)),
              SizedBox(height: DesignTokens.grid3x),
              const Text(
                'Félicitations !',
                style: TextStyle(
                  color: OuroColors.textPrimary,
                  fontSize: DesignTokens.text3xl,
                  fontWeight: FontWeight.w800,
                ),
              ).animate().fadeIn(delay: DesignTokens.durationNormal, duration: DesignTokens.durationSlow),
              SizedBox(height: DesignTokens.grid2x),
              Text(
                subjectExamReady
                    ? 'Vous avez terminé toutes les sections et épreuves du chapitre.'
                    : 'Toutes les sections du chapitre sont terminées.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: OuroColors.textSecondary,
                  fontSize: DesignTokens.textMd,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: DesignTokens.durationSlow, duration: DesignTokens.durationSlow),
              const Spacer(),
              if (subjectExamReady)
                Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.gridBase + 4),
                  child: _brandButton(
                    label: 'Épreuve finale disponible',
                    icon: Icons.workspace_premium,
                    onTap: () => context.go('/exam/${widget.courseId}'),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.gridBase + 4),
                  child: _brandButton(
                    label: "Passer l'épreuve du chapitre",
                    icon: Icons.quiz_outlined,
                    onTap: () => context.go('/exam/${widget.courseId}/${widget.chapterId}'),
                  ),
                ),
              _glassButton(
                label: 'Retour à la liste des chapitres',
                icon: Icons.list,
                onTap: _goBack,
              ),
              SizedBox(height: DesignTokens.grid2x),
            ],
          ),
        ).animate().fadeIn(duration: DesignTokens.durationSlow),
      ),
    );
  }

  // ─── SHARED WIDGETS ──────────────────────────────────────────────

  Widget _glassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: OuroColors.glassBg,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        border: Border.all(color: OuroColors.glassBorder),
      ),
      child: child,
    );
  }

  Widget _brandButton({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    Color? color,
  }) {
    final c = color ?? OuroColors.meshBlue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: DesignTokens.grid2x),
        decoration: BoxDecoration(
          gradient: color == null ? OuroColors.brandGradient : null,
          color: color,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          boxShadow: DesignTokens.glow(c),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: DesignTokens.iconMd),
              SizedBox(width: DesignTokens.gridBase + 2),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: DesignTokens.textLg,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: DesignTokens.durationFast),
    );
  }

  Widget _glassButton({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: DesignTokens.gridBase + 6),
        decoration: BoxDecoration(
          color: OuroColors.glassBg,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          border: Border.all(color: OuroColors.glassBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: OuroColors.textSecondary, size: DesignTokens.iconSm),
              SizedBox(width: DesignTokens.grid2x - 4),
            ],
            Text(
              label,
              style: const TextStyle(
                color: OuroColors.textSecondary,
                fontSize: DesignTokens.textMd,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
