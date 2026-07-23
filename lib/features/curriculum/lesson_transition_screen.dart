import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/data/curriculum_data.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';

class LessonTransitionScreen extends ConsumerStatefulWidget {
  final String subjectId;
  final String chapterId;
  final String lessonId;

  const LessonTransitionScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
    required this.lessonId,
  });

  int get lessonIndex {
    final chapter = CurriculumData.findChapterById(chapterId);
    if (chapter == null) return 0;
    return chapter.lessons.indexWhere((l) => l.id == lessonId);
  }

  int get totalLessons {
    final chapter = CurriculumData.findChapterById(chapterId);
    return chapter?.lessons.length ?? 1;
  }

  @override
  ConsumerState<LessonTransitionScreen> createState() =>
      _LessonTransitionScreenState();
}

class _LessonTransitionScreenState
    extends ConsumerState<LessonTransitionScreen> {
  Timer? _autoAdvanceTimer;
  Timer? _countdownTimer;
  double _countdownProgress = 1.0;
  bool _navigated = false;

  static const _lessonEmojis = [
    '📖', '✏️', '🧠', '💡', '📝', '🔬', '📐', '🧪', '🎯', '🔢',
    '⚡', '🌿', '💻', '📡', '🧮',
  ];

  static const _motivationalMessages = [
    'Tu assures ! 💪',
    'Continue comme ça ! ⭐',
    'Chaque jour, un pas de plus vers la réussite ! 🚀',
    'Le savoir est la clé du succès ! 🔑',
    'Persévère, la victoire est proche ! 🏆',
    'Encore un effort et c\'est dans la poche ! 🎯',
  ];

  String get _readerRoute =>
      '/curriculum/subject/${widget.subjectId}'
      '/chapter/${widget.chapterId}'
      '/lesson/${widget.lessonId}/reader';

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _autoAdvanceTimer = Timer(const Duration(milliseconds: 2500), () {
      _navigateToReader();
    });
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    const totalMs = 2500;
    const tickMs = 50;
    _countdownTimer = Timer.periodic(const Duration(milliseconds: tickMs), (t) {
      if (!mounted) return;
      setState(() {
        _countdownProgress -= tickMs / totalMs;
        if (_countdownProgress <= 0) {
          _countdownProgress = 0;
          t.cancel();
        }
      });
    });
  }

  void _navigateToReader() {
    if (_navigated || !mounted) return;
    _navigated = true;
    context.go(_readerRoute);
  }

  @override
  Widget build(BuildContext context) {
    final chapter = CurriculumData.findChapterById(widget.chapterId);
    final lesson = CurriculumData.findLessonById(widget.lessonId);
    final chapterTitle = chapter?.title ?? '';
    final lessonTitle = lesson?.title ?? '';
    final emoji = _lessonEmojis[widget.lessonIndex % _lessonEmojis.length];
    final message =
        _motivationalMessages[widget.lessonIndex % _motivationalMessages.length];

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        colors: const [
          Color(0xFF0A1628),
          Color(0xFF060612),
          Color(0xFF080818),
        ],
        child: SafeArea(
          child: Stack(
            children: [
              _buildSkipButton(),
              _buildCountdownIndicator(),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 72))
                          .animate()
                          .scale(
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          )
                          .fadeIn(duration: 400.ms),
                      const SizedBox(height: DesignTokens.grid3x),
                      Text(
                        lessonTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          color: OuroColors.textPrimary,
                          fontSize: DesignTokens.text6xl,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: 400.ms,
                            delay: 200.ms,
                          )
                          .slideY(
                            begin: 0.15,
                            end: 0,
                            duration: 400.ms,
                            delay: 200.ms,
                          ),
                      const SizedBox(height: DesignTokens.gridSm),
                      Text(
                        'Leçon ${widget.lessonIndex + 1} sur ${widget.totalLessons}',
                        style: TextStyle(
                          color: OuroColors.textSecondary,
                          fontSize: DesignTokens.textLg,
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fadeIn(
                            duration: 300.ms,
                            delay: 500.ms,
                          ),
                      const SizedBox(height: DesignTokens.grid2x),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: OuroColors.textSecondary.withValues(alpha: 0.8),
                          fontSize: DesignTokens.textMd,
                          height: 1.5,
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: 300.ms,
                            delay: 700.ms,
                          )
                          .slideY(
                            begin: 0.08,
                            end: 0,
                            duration: 300.ms,
                            delay: 700.ms,
                          ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: DesignTokens.grid4x,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    chapterTitle.isNotEmpty ? 'Chapitre $chapterTitle' : '',
                    style: TextStyle(
                      color: OuroColors.textTertiary,
                      fontSize: DesignTokens.textSm,
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 900.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Positioned(
      top: DesignTokens.gridBase,
      right: DesignTokens.gridBase,
      child: GestureDetector(
        onTap: _navigateToReader,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Passer →',
            style: TextStyle(
              color: OuroColors.textSecondary.withValues(alpha: 0.6),
              fontSize: DesignTokens.textSm,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 400.ms);
  }

  Widget _buildCountdownIndicator() {
    return Positioned(
      bottom: DesignTokens.grid8x,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            value: _countdownProgress,
            strokeWidth: 2.5,
            backgroundColor: OuroColors.glassBorder,
            valueColor:
                const AlwaysStoppedAnimation<Color>(OuroColors.meshBlue),
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: 1000.ms),
    );
  }
}
