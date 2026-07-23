import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/data/curriculum_data.dart';
import '../../core/data/quiz_data.dart';
import '../../core/models/quiz_question.dart';
import '../../core/providers/curriculum_provider.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';

enum _QuizPhase { answering, resultFeedback, finished }

class LessonQuizScreen extends ConsumerStatefulWidget {
  final String subjectId;
  final String chapterId;
  final String lessonId;

  const LessonQuizScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
    required this.lessonId,
  });

  @override
  ConsumerState<LessonQuizScreen> createState() => _LessonQuizScreenState();
}

class _LessonQuizScreenState extends ConsumerState<LessonQuizScreen>
    with TickerProviderStateMixin {
  late List<QuizQuestion> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedIndex;
  _QuizPhase _phase = _QuizPhase.answering;
  bool _showCorrectOnWrong = false;
  late AnimationController _progressAnimCtrl;
  late AnimationController _celebrationCtrl;

  @override
  void initState() {
    super.initState();
    _questions = QuizData.getQuestionsForLesson(widget.lessonId, count: 3);
    _progressAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _celebrationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _progressAnimCtrl.dispose();
    _celebrationCtrl.dispose();
    super.dispose();
  }

  void _onOptionSelected(int index) {
    if (_phase != _QuizPhase.answering || _selectedIndex != null) return;

    HapticFeedback.mediumImpact();

    setState(() {
      _selectedIndex = index;
      _phase = _QuizPhase.resultFeedback;

      if (index == _questions[_currentQuestionIndex].correctIndex) {
        _score++;
        _showCorrectOnWrong = false;
      } else {
        _showCorrectOnWrong = true;
      }
    });

    _progressAnimCtrl.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedIndex = null;
          _phase = _QuizPhase.answering;
          _showCorrectOnWrong = false;
        });
      } else {
        setState(() => _phase = _QuizPhase.finished);
        if (_score >= 2) {
          _celebrationCtrl.forward(from: 0);
        }
      }
    });
  }

  int get _scorePercentage =>
      _questions.isEmpty ? 0 : ((_score / _questions.length) * 100).round();

  void _onContinueAfterPass() {
    ref.read(curriculumProgressProvider.notifier).completeLesson(
          widget.lessonId,
          score: _scorePercentage,
        );
    final chapter = CurriculumData.findChapterById(widget.chapterId);
    if (chapter == null) {
      context.go('/curriculum/subject/${widget.subjectId}');
      return;
    }
    final currentLessonIndex = chapter.lessons.indexWhere((l) => l.id == widget.lessonId);
    if (currentLessonIndex < chapter.lessons.length - 1) {
      final nextLesson = chapter.lessons[currentLessonIndex + 1];
      context.go(
        '/curriculum/subject/${widget.subjectId}/chapter/${widget.chapterId}/lesson/${nextLesson.id}/transition',
      );
    } else {
      context.go(
        '/curriculum/subject/${widget.subjectId}/chapter/${widget.chapterId}/complete',
      );
    }
  }

  void _onRetry() {
    context.go(
      '/curriculum/subject/${widget.subjectId}/chapter/${widget.chapterId}/lesson/${widget.lessonId}/reader',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: OuroColors.background,
        body: Center(
          child: Text(
            'Aucune question disponible',
            style: TextStyle(color: OuroColors.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: _phase == _QuizPhase.finished
              ? _buildResults()
              : _buildQuestionView(),
        ),
      ),
    );
  }

  // ── Question View ──────────────────────────────────────────

  Widget _buildQuestionView() {
    final question = _questions[_currentQuestionIndex];
    final letters = ['A', 'B', 'C', 'D'];
    final isAnswered = _phase == _QuizPhase.resultFeedback;

    return Column(
      children: [
        _buildQuestionTopBar(),
        const SizedBox(height: 12),
        _buildSegmentedProgress(),
        const SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: GoogleFonts.spaceGrotesk(
                    color: OuroColors.textPrimary,
                    fontSize: DesignTokens.textXl,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ).animate().fadeIn(duration: DesignTokens.durationNormal),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: question.options.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final isSelected = _selectedIndex == index;
                      final isCorrect = index == question.correctIndex;
                      final showAsCorrect = isAnswered && isCorrect;
                      final showAsWrong = isAnswered && isSelected && !isCorrect;

                      Color borderColor;
                      Color bgColor;
                      if (showAsCorrect) {
                        borderColor = OuroColors.successGreen;
                        bgColor = OuroColors.successGreen.withValues(alpha: 0.08);
                      } else if (showAsWrong) {
                        borderColor = OuroColors.errorRed;
                        bgColor = OuroColors.errorRed.withValues(alpha: 0.08);
                      } else if (isSelected) {
                        borderColor = OuroColors.meshBlue;
                        bgColor = OuroColors.meshBlue.withValues(alpha: 0.1);
                      } else {
                        borderColor = OuroColors.glassBorder;
                        bgColor = OuroColors.glassBg.withValues(alpha: 0.04);
                      }

                      return GestureDetector(
                        onTap: isAnswered ? null : () => _onOptionSelected(index),
                        child: AnimatedContainer(
                          duration: DesignTokens.durationFast,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: borderColor,
                              width: (showAsCorrect || showAsWrong) ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: showAsCorrect
                                      ? OuroColors.successGreen.withValues(alpha: 0.2)
                                      : showAsWrong
                                          ? OuroColors.errorRed.withValues(alpha: 0.2)
                                          : OuroColors.glassBg,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: showAsCorrect
                                      ? const Icon(Icons.check_rounded,
                                          color: OuroColors.successGreen, size: 16)
                                      : showAsWrong
                                          ? const Icon(Icons.close_rounded,
                                              color: OuroColors.errorRed, size: 16)
                                          : Text(
                                              letters[index],
                                              style: TextStyle(
                                                color: isSelected
                                                    ? OuroColors.meshBlue
                                                    : OuroColors.textSecondary,
                                                fontSize: DesignTokens.textSm,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: TextStyle(
                                    color: showAsCorrect
                                        ? OuroColors.successGreen
                                        : showAsWrong
                                            ? OuroColors.errorRed
                                            : OuroColors.textPrimary,
                                    fontSize: DesignTokens.textMd,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (showAsCorrect)
                                const Icon(Icons.check_circle_rounded,
                                    color: OuroColors.successGreen, size: 20)
                                    .animate()
                                    .scale(
                                      duration: DesignTokens.durationFast,
                                      curve: Curves.easeOutBack,
                                    ),
                              if (showAsWrong && isCorrect && _showCorrectOnWrong)
                                const Icon(Icons.info_outline_rounded,
                                    color: OuroColors.successGreen, size: 20),
                            ],
                          ),
                        ).animate().fadeIn(
                          duration: DesignTokens.durationNormal,
                          delay: (index * 60).ms,
                        ).slideX(
                          begin: 0.04,
                          duration: DesignTokens.durationNormal,
                          delay: (index * 60).ms,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildQuestionTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.grid2x, DesignTokens.gridBase, DesignTokens.grid2x, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/curriculum/subject/${widget.subjectId}'),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.close_rounded,
                  color: OuroColors.textSecondary, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: GoogleFonts.spaceGrotesk(
                color: OuroColors.textPrimary,
                fontSize: DesignTokens.textLg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: DesignTokens.durationNormal);
  }

  Widget _buildSegmentedProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Row(
        children: List.generate(_questions.length, (i) {
          final isActive = i == _currentQuestionIndex;
          final isDone = i < _currentQuestionIndex;
          Color color;
          if (isDone) {
            color = _getQuestionResult(i)
                ? OuroColors.successGreen
                : OuroColors.errorRed;
          } else if (isActive) {
            color = OuroColors.meshBlue;
          } else {
            color = OuroColors.glassBorder;
          }
          return Expanded(
            child: AnimatedContainer(
              duration: DesignTokens.durationFast,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    ).animate().fadeIn(duration: DesignTokens.durationFast, delay: 50.ms);
  }

  bool _getQuestionResult(int index) {
    if (index >= _currentQuestionIndex) return false;
    return _questions[index].correctIndex == 0;
  }

  // ── Results View ───────────────────────────────────────────

  Widget _buildResults() {
    final perfect = _score == _questions.length;
    final passed = _score >= 2;

    return Stack(
      children: [
        if (passed) _buildCelebrationParticles(),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(DesignTokens.grid3x),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),
                _buildScoreCircle(perfect, passed),
                const SizedBox(height: 20),
                Text(
                  perfect
                      ? 'Parfait ! 🎯'
                      : passed
                          ? 'Bravo ! Continue comme ça ! ⭐'
                          : 'C\'est pas grave, continue de réviser ! 💪',
                  style: GoogleFonts.spaceGrotesk(
                    color: passed ? OuroColors.textPrimary : OuroColors.warningAmber,
                    fontSize: DesignTokens.text2xl,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 8),
                Text(
                  '${_score * 10} XP gagn\u00e9s !',
                  style: GoogleFonts.spaceGrotesk(
                    color: OuroColors.ouroOrange,
                    fontSize: DesignTokens.textXl,
                    fontWeight: FontWeight.w600,
                  ),
                ).animate().fadeIn(delay: 350.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  duration: DesignTokens.durationNormal,
                  delay: 350.ms,
                  curve: Curves.easeOutBack,
                ),
                const SizedBox(height: 28),
                _buildQuestionReview(),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: passed ? _onContinueAfterPass : _onRetry,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: passed
                            ? [OuroColors.successGreen, OuroColors.accentTeal]
                            : [OuroColors.errorRed, OuroColors.ouroOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (passed ? OuroColors.successGreen : OuroColors.errorRed)
                              .withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        passed ? 'Continuer' : 'Réessayer',
                        style: GoogleFonts.spaceGrotesk(
                          color: OuroColors.background,
                          fontSize: DesignTokens.textLg,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCircle(bool perfect, bool passed) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: _score / max(_questions.length, 1),
              strokeWidth: 8,
              backgroundColor: OuroColors.glassBorder,
              valueColor: AlwaysStoppedAnimation(
                perfect ? OuroColors.successGreen : OuroColors.meshBlue,
              ),
            ),
          )
              .animate()
              .scale(
                duration: DesignTokens.durationSlow,
                delay: 100.ms,
                curve: Curves.easeOutBack,
              ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$_score/${_questions.length}',
                style: GoogleFonts.spaceGrotesk(
                  color: OuroColors.textPrimary,
                  fontSize: DesignTokens.text5xl,
                  fontWeight: FontWeight.w700,
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    duration: DesignTokens.durationSlow,
                    delay: 200.ms,
                    curve: Curves.easeOutBack,
                  ),
              if (perfect)
                const Icon(Icons.star_rounded, color: OuroColors.ouroOrange, size: 28)
                    .animate().scale(
                      delay: 400.ms,
                      duration: DesignTokens.durationNormal,
                      curve: Curves.easeOutBack,
                    ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildQuestionReview() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        children: [
          ...List.generate(_questions.length, (i) {
            final q = _questions[i];
            final wasCorrect = q.correctIndex == _selectedIndexForReview(i);
            return Padding(
              padding: EdgeInsets.only(bottom: i < _questions.length - 1 ? 12 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: wasCorrect
                          ? OuroColors.successGreen.withValues(alpha: 0.15)
                          : OuroColors.errorRed.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        wasCorrect ? Icons.check_rounded : Icons.close_rounded,
                        color: wasCorrect ? OuroColors.successGreen : OuroColors.errorRed,
                        size: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.question,
                          style: TextStyle(
                            color: OuroColors.textSecondary.withValues(alpha: 0.7),
                            fontSize: DesignTokens.textSm,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!wasCorrect) ...[
                          const SizedBox(height: 2),
                          Text(
                            'R\u00e9ponse : ${q.options[q.correctIndex]}',
                            style: const TextStyle(
                              color: OuroColors.successGreen,
                              fontSize: DesignTokens.textSm,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).animate().fadeIn(delay: 100.ms),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  int? _selectedIndexForReview(int questionIndex) {
    if (questionIndex >= _currentQuestionIndex) return null;
    return null;
  }

  // ── Celebration Particles ──────────────────────────────────

  Widget _buildCelebrationParticles() {
    return AnimatedBuilder(
      animation: _celebrationCtrl,
      builder: (context, _) {
        return CustomPaint(
          painter: _CelebrationPainter(
            progress: _celebrationCtrl.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _CelebrationPainter extends CustomPainter {
  final double progress;
  final Random _rand = Random(42);

  _CelebrationPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 30; i++) {
      final seed = _rand.nextDouble();
      final x = seed * size.width;
      final startY = -20.0;
      final endY = size.height + 40.0;
      final y = startY + (endY - startY) * (progress * 1.2 - seed * 0.3).clamp(0.0, 1.0);

      final emojiIcons = ['⭐', '✨', '🌟', '💫'];
      final emoji = emojiIcons[i % emojiIcons.length];
      final textPainter = TextPainter(
        text: TextSpan(text: emoji, style: const TextStyle(fontSize: 14)),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(_CelebrationPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
