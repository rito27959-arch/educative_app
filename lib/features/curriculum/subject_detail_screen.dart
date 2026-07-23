import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/data/curriculum_data.dart';
import '../../core/models/curriculum_models.dart';
import '../../core/models/curriculum_progress.dart';
import '../../core/providers/curriculum_provider.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';

class SubjectDetailScreen extends ConsumerStatefulWidget {
  final String subjectId;

  const SubjectDetailScreen({super.key, required this.subjectId});

  @override
  ConsumerState<SubjectDetailScreen> createState() =>
      _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends ConsumerState<SubjectDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _scrolledToFirstUnfinished = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToFirstUnfinished(List<CurriculumChapter> chapters) {
    if (_scrolledToFirstUnfinished) return;
    final progress = ref.read(curriculumProgressProvider);
    for (int i = 0; i < chapters.length; i++) {
      if (!progress.completedChapters.contains(chapters[i].id)) {
        _scrolledToFirstUnfinished = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            final targetOffset = (i * 130.0) - 80.0;
            _scrollController.animateTo(
              max(0.0, targetOffset),
              duration: DesignTokens.durationSlow,
              curve: DesignTokens.curveEmphasis,
            );
          }
        });
        return;
      }
    }
    _scrolledToFirstUnfinished = true;
  }

  @override
  Widget build(BuildContext context) {
    final subject = CurriculumData.findById(widget.subjectId);
    if (subject == null) {
      return Scaffold(
        backgroundColor: OuroColors.background,
        body: Center(
          child: Text(
            'Mati\u00e8re introuvable',
            style: TextStyle(color: OuroColors.textSecondary),
          ),
        ),
      );
    }

    final progress = ref.watch(curriculumProgressProvider);
    final completedChapters = progress.completedChapters;
    final completedChapCount = subject.chapters
        .where((ch) => completedChapters.contains(ch.id))
        .length;
    final allChaptersComplete = completedChapCount == subject.chapters.length;

    _scrollToFirstUnfinished(subject.chapters);

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  DesignTokens.grid3x,
                  DesignTokens.gridBase,
                  DesignTokens.grid3x,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppBar(context, subject),
                      const SizedBox(height: DesignTokens.grid2x),
                      _buildSubjectInfo(subject),
                      const SizedBox(height: DesignTokens.grid3x),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.grid3x,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final chapter = subject.chapters[index];
                      final prevChapter =
                          index > 0 ? subject.chapters[index - 1] : null;
                      final prevCompleted = prevChapter == null ||
                          completedChapters.contains(prevChapter.id);
                      final chapterAccessible = prevCompleted;
                      final chapterDone =
                          completedChapters.contains(chapter.id);
                      final isFirst = index == 0;
                      final isLast = index == subject.chapters.length - 1;

                      return _DuolingoChapterNode(
                        chapter: chapter,
                        index: index,
                        progress: progress,
                        isAccessible: chapterAccessible,
                        isCompleted: chapterDone,
                        isFirst: isFirst,
                        isLast: isLast,
                      );
                    },
                    childCount: subject.chapters.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    DesignTokens.grid3x,
                    DesignTokens.grid3x,
                    DesignTokens.grid3x,
                    100,
                  ),
                  child: _buildBottomSection(
                    allChaptersComplete,
                    completedChapCount,
                    subject.chapters.length,
                    subject,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, SubjectCurriculum subject) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go('/curriculum'),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: OuroColors.textSecondary, size: 20),
          ),
        ),
        const SizedBox(width: 12),
        Text(subject.emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject.title,
                style: const TextStyle(
                  color: OuroColors.textPrimary,
                  fontSize: DesignTokens.textXl,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'S\u00e9rie ${subject.bacSeries}',
                style: TextStyle(
                  color: OuroColors.textSecondary.withValues(alpha: 0.5),
                  fontSize: DesignTokens.textSm,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: DesignTokens.durationNormal).slideX(begin: -0.06);
  }

  Widget _buildSubjectInfo(SubjectCurriculum subject) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoTile(Icons.star_outline_rounded, 'Coeff.', '${subject.coefficient}'),
          Container(width: 1, height: 36, color: OuroColors.glassBorder),
          _infoTile(Icons.timer_outlined, 'Dur\u00e9e', '${subject.examDurationMinutes} min'),
          Container(width: 1, height: 36, color: OuroColors.glassBorder),
          _infoTile(Icons.book_outlined, 'Chapitres', '${subject.chapters.length}'),
        ],
      ),
    ).animate().fadeIn(
      duration: DesignTokens.durationNormal,
      delay: 100.ms,
    ).slideY(begin: 0.08);
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: OuroColors.textSecondary, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: OuroColors.textPrimary,
            fontSize: DesignTokens.textLg,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: OuroColors.textSecondary.withValues(alpha: 0.5),
            fontSize: DesignTokens.textXs,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection(
    bool allComplete,
    int completedCount,
    int totalCount,
    SubjectCurriculum subject,
  ) {
    final double progressValue =
        totalCount > 0 ? completedCount / totalCount : 0.0;

    if (allComplete) {
      return Column(
        children: [
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: 20,
            child: Column(
              children: [
                Text(
                  '$completedCount/$totalCount chapitres compl\u00e9t\u00e9s',
                  style: const TextStyle(
                    color: OuroColors.textPrimary,
                    fontSize: DesignTokens.textMd,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 6,
                    backgroundColor: OuroColors.glassBorder,
                    valueColor: const AlwaysStoppedAnimation(OuroColors.localGreen),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.go(
              '/curriculum/subject/${subject.id}/bac-exam',
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    OuroColors.localGreen,
                    OuroColors.localGreen.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: OuroColors.localGreen.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events_rounded,
                      color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Pr\u00eat pour l\'examen Bac !',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: DesignTokens.textXl,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(
            duration: DesignTokens.durationNormal,
            delay: 200.ms,
          ).scale(
            begin: const Offset(0.95, 0.95),
            duration: DesignTokens.durationNormal,
            delay: 200.ms,
            curve: Curves.easeOutBack,
          ),
        ],
      );
    }

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.school_outlined,
                  color: OuroColors.ouroOrange, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$completedCount/$totalCount chapitres compl\u00e9t\u00e9s',
                  style: const TextStyle(
                    color: OuroColors.textPrimary,
                    fontSize: DesignTokens.textMd,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${(progressValue * 100).round()}%',
                style: const TextStyle(
                  color: OuroColors.ouroOrange,
                  fontSize: DesignTokens.textMd,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 5,
              backgroundColor: OuroColors.glassBorder,
              valueColor: const AlwaysStoppedAnimation(OuroColors.meshBlue),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: DesignTokens.durationNormal,
      delay: 300.ms,
    );
  }
}

class _DuolingoChapterNode extends ConsumerStatefulWidget {
  final CurriculumChapter chapter;
  final int index;
  final CurriculumProgress progress;
  final bool isAccessible;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;

  const _DuolingoChapterNode({
    required this.chapter,
    required this.index,
    required this.progress,
    required this.isAccessible,
    required this.isCompleted,
    required this.isFirst,
    required this.isLast,
  });

  @override
  ConsumerState<_DuolingoChapterNode> createState() =>
      _DuolingoChapterNodeState();
}

class _DuolingoChapterNodeState extends ConsumerState<_DuolingoChapterNode> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapter;
    final locked = !widget.isAccessible;
    final completed = widget.isCompleted;
    final totalLessons = chapter.lessons.length;
    final doneLessons = chapter.lessons
        .where((l) => widget.progress.completedLessons.contains(l.id))
        .length;
    final circleSize = 52.0;

    return Column(
      children: [
        if (!widget.isFirst) _buildConnectingLine(locked, completed),
        GestureDetector(
          onTapDown: (!locked) ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: (!locked) ? (_) => setState(() => _isPressed = false) : null,
          onTapCancel: (!locked) ? () => setState(() => _isPressed = false) : null,
          onTap: locked ? null : () => _onChapterTap(context),
          child: AnimatedScale(
            scale: _isPressed ? 1.05 : 1.0,
            duration: DesignTokens.durationFast,
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: DesignTokens.durationFast,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                border: Border.all(
                  color: completed
                      ? OuroColors.localGreen.withValues(alpha: 0.4)
                      : locked
                          ? OuroColors.glassBorder.withValues(alpha: 0.2)
                          : OuroColors.glassBorder,
                  width: completed ? 1.5 : 0.5,
                ),
                color: locked
                    ? OuroColors.glassBg.withValues(alpha: 0.02)
                    : completed
                        ? OuroColors.localGreen.withValues(alpha: 0.04)
                        : OuroColors.meshBlue.withValues(alpha: 0.03),
                boxShadow: locked
                    ? null
                    : [
                        BoxShadow(
                          color: (completed
                                  ? OuroColors.localGreen
                                  : OuroColors.meshBlue)
                              .withValues(alpha: _isPressed ? 0.15 : 0.06),
                          blurRadius: _isPressed ? 30 : 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  _buildNodeCircle(circleSize, locked, completed),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.title,
                          style: TextStyle(
                            color: locked
                                ? OuroColors.textSecondary.withValues(alpha: 0.35)
                                : OuroColors.textPrimary,
                            fontSize: DesignTokens.textLg,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$totalLessons le\u00e7ons${completed ? ' \u2014 Termin\u00e9' : ''}',
                          style: TextStyle(
                            color: locked
                                ? OuroColors.textSecondary.withValues(alpha: 0.25)
                                : completed
                                    ? OuroColors.localGreen.withValues(alpha: 0.7)
                                    : OuroColors.textSecondary.withValues(alpha: 0.5),
                            fontSize: DesignTokens.textSm,
                          ),
                        ),
                        if (!locked && !completed && doneLessons > 0) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: totalLessons > 0
                                  ? doneLessons / totalLessons
                                  : 0.0,
                              minHeight: 4,
                              backgroundColor: OuroColors.glassBorder,
                              valueColor: const AlwaysStoppedAnimation(
                                OuroColors.meshBlue,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!locked) ...[
                    const SizedBox(width: 8),
                    Icon(
                      completed
                          ? Icons.check_circle_rounded
                          : Icons.chevron_right_rounded,
                      color: completed
                          ? OuroColors.localGreen.withValues(alpha: 0.5)
                          : OuroColors.textSecondary.withValues(alpha: 0.25),
                      size: completed ? 24 : 22,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ).animate().fadeIn(
          duration: DesignTokens.durationNormal,
          delay: (200 + widget.index * 80).ms,
        ).slideY(
          begin: 0.12,
          end: 0,
          duration: DesignTokens.durationNormal,
          delay: (200 + widget.index * 80).ms,
          curve: Curves.easeOutCubic,
        ),
        if (widget.isLast) _buildEndCap(),
      ],
    );
  }

  void _onChapterTap(BuildContext context) {
    context.go(
      '/curriculum/subject/${widget.chapter.subjectId}/chapter/${widget.chapter.id}/intro',
    );
  }

  Widget _buildConnectingLine(bool locked, bool completed) {
    final color = completed
        ? OuroColors.localGreen.withValues(alpha: 0.3)
        : locked
            ? OuroColors.glassBorder.withValues(alpha: 0.15)
            : OuroColors.meshBlue.withValues(alpha: 0.3);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 3,
          height: 32,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color, color.withValues(alpha: 0.3)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildEndCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 3,
          height: 24,
          decoration: BoxDecoration(
            color: OuroColors.glassBorder.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildNodeCircle(double size, bool locked, bool completed) {
    if (completed) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: OuroColors.localGreen.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: OuroColors.localGreen.withValues(alpha: 0.5),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: OuroColors.localGreen.withValues(alpha: 0.2),
              blurRadius: 12,
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.check_rounded,
            color: OuroColors.localGreen,
            size: 26,
          ),
        ),
      );
    }

    if (locked) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: OuroColors.glassBg.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: OuroColors.glassBorder.withValues(alpha: 0.2),
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.lock_outline_rounded,
            color: OuroColors.textTertiary,
            size: 20,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: OuroColors.meshBlue.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(
          color: OuroColors.meshBlue.withValues(alpha: 0.5),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: OuroColors.meshBlue.withValues(alpha: 0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${widget.index + 1}',
          style: GoogleFonts.spaceGrotesk(
            color: OuroColors.meshBlueBright,
            fontSize: DesignTokens.textXl,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
