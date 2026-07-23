import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/data/curriculum_data.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/curriculum_provider.dart';
import '../../core/repositories/user_repository.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';

class CurriculumOverviewScreen extends ConsumerWidget {
  const CurriculumOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(curriculumProgressProvider);
    final user = ref.watch(authProvider).user;
    final bacSeries = user?.bacSeries ?? 'BAC D';
    final seriesCode = BacSeries.toSeriesId(bacSeries).toUpperCase();
    final subjects = CurriculumData.forSeries(seriesCode);

    final completedCount = progress.completedSubjects.length;
    final totalCount = subjects.length;

    int totalLessons = 0;
    int completedLessons = 0;
    for (final subject in subjects) {
      for (final chapter in subject.chapters) {
        totalLessons += chapter.lessons.length;
      }
    }
    completedLessons = progress.completedLessons.length;
    final accurateProgress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  DesignTokens.grid3x, DesignTokens.gridBase,
                  DesignTokens.grid3x, 0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppBar(context, bacSeries),
                      const SizedBox(height: DesignTokens.grid2x),
                      _buildHeader(bacSeries),
                      const SizedBox(height: DesignTokens.grid3x),
                      _buildGlobalProgress(accurateProgress, completedLessons, totalLessons),
                      const SizedBox(height: DesignTokens.grid3x),
                      _buildSeriesBadge(bacSeries),
                      const SizedBox(height: DesignTokens.grid3x),
                      _buildSubjectCount(completedCount, totalCount),
                      const SizedBox(height: DesignTokens.grid2x),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.grid3x,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: DesignTokens.gridBase,
                    crossAxisSpacing: DesignTokens.gridBase,
                    childAspectRatio: 0.82,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _SubjectCard(
                      subject: subjects[index],
                      index: index,
                    ),
                    childCount: subjects.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, String bacSeries) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.close_rounded, color: OuroColors.textSecondary, size: 20),
          ),
        ),
        const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Programme $bacSeries',
              style: const TextStyle(
                color: OuroColors.textPrimary,
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    ).animate().fadeIn(duration: DesignTokens.durationNormal).slideX(begin: -0.08);
  }

  Widget _buildHeader(String bacSeries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
            '\ud83d\udcda Baccalaur\u00e9at ${bacSeries.replaceAll('BAC ', '')}',
            style: GoogleFonts.spaceGrotesk(
              fontSize: DesignTokens.text6xl,
              fontWeight: FontWeight.w700,
              color: OuroColors.textPrimary,
              height: 1.1,
            ),
          ).animate().fadeIn(duration: DesignTokens.durationSlow).slideY(begin: 0.15),
        const SizedBox(height: 8),
        Text(
          'Ma\u00eetriser tout le programme officiel',
          style: TextStyle(
            color: OuroColors.textSecondary.withValues(alpha: 0.7),
            fontSize: DesignTokens.textLg,
          ),
        ).animate().fadeIn(
          duration: DesignTokens.durationSlow,
          delay: 80.ms,
        ),
      ],
    );
  }

  Widget _buildGlobalProgress(double overallProgress, int completedLessons, int totalLessons) {
    return GlassContainer(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      borderRadius: 24,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: overallProgress,
                    strokeWidth: 6,
                    backgroundColor: OuroColors.glassBorder,
                    valueColor: AlwaysStoppedAnimation(
                      overallProgress > 0 ? OuroColors.meshBlue : OuroColors.textTertiary,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '${(overallProgress * 100).round()}%',
                  style: const TextStyle(
                    color: OuroColors.textPrimary,
                    fontSize: DesignTokens.textLg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: DesignTokens.grid3x),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progression globale',
                  style: TextStyle(
                    color: OuroColors.textPrimary,
                    fontSize: DesignTokens.textMd,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: overallProgress,
                    minHeight: 5,
                    backgroundColor: OuroColors.glassBorder,
                    valueColor: AlwaysStoppedAnimation(
                      overallProgress > 0.6 ? OuroColors.localGreen : OuroColors.meshBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$completedLessons/$totalLessons le\u00e7ons compl\u00e9t\u00e9es',
                  style: TextStyle(
                    color: OuroColors.textSecondary.withValues(alpha: 0.6),
                    fontSize: DesignTokens.textSm,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: DesignTokens.durationSlow,
      delay: 150.ms,
    ).slideY(begin: 0.1);
  }

  Widget _buildSeriesBadge(String bacSeries) {
    final desc = BacSeries.getDescription(bacSeries);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: OuroColors.accentPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OuroColors.accentPurple.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.school_rounded, color: OuroColors.accentPurple, size: 18),
          const SizedBox(width: 8),
          Text(
            '${bacSeries.replaceAll('BAC ', 'S\u00e9rie ')} \u2014 $desc',
            style: GoogleFonts.spaceGrotesk(
              color: OuroColors.accentPurple,
              fontSize: DesignTokens.textSm,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: DesignTokens.durationNormal,
      delay: 200.ms,
    );
  }

  Widget _buildSubjectCount(int completed, int total) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 16,
          color: completed == total
              ? OuroColors.localGreen
              : OuroColors.textSecondary.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 6),
        Text(
          '$completed/$total mati\u00e8res valid\u00e9es',
          style: TextStyle(
            color: completed == total
                ? OuroColors.localGreen
                : OuroColors.textSecondary.withValues(alpha: 0.6),
            fontSize: DesignTokens.textSm,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ).animate().fadeIn(
      duration: DesignTokens.durationNormal,
      delay: 250.ms,
    );
  }
}

class _SubjectCard extends ConsumerWidget {
  final dynamic subject;
  final int index;

  const _SubjectCard({required this.subject, required this.index});

  Color get _cardColor {
    if (subject.id.startsWith('maths')) return OuroColors.meshBlue;
    if (subject.id.startsWith('physique')) return OuroColors.ouroOrange;
    if (subject.id.startsWith('chimie')) return OuroColors.localGreen;
    if (subject.id.startsWith('svt')) return OuroColors.accentTeal;
    if (subject.id.startsWith('info')) return OuroColors.accentPurple;
    if (subject.id.startsWith('francais')) return OuroColors.errorRed;
    if (subject.id.startsWith('anglais')) return OuroColors.accentPink;
    if (subject.id.startsWith('philosophie')) return OuroColors.accentPurple;
    if (subject.id.startsWith('histoire_geo')) return OuroColors.meshBlue;
    return OuroColors.meshBlue;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectProgress = ref.watch(subjectProgressProvider(subject.id));
    final chapterCount = subject.chapters.length;
    final color = _cardColor;

    return GestureDetector(
      onTap: () => context.go('/curriculum/subject/${subject.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          border: Border.all(
            color: subjectProgress > 0
                ? color.withValues(alpha: 0.4)
                : OuroColors.glassBorder,
            width: subjectProgress > 0 ? 1.0 : 0.5,
          ),
          gradient: subjectProgress > 0
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.06),
                    OuroColors.glassBg.withValues(alpha: 0.04),
                  ],
                )
              : null,
          color: subjectProgress <= 0 ? OuroColors.glassBg.withValues(alpha: 0.06) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  subject.emoji,
                  style: const TextStyle(fontSize: 40),
                ),
                const Spacer(),
                if (subjectProgress > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${(subjectProgress * 100).round()}%',
                      style: TextStyle(
                        color: color,
                        fontSize: DesignTokens.textXs,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              subject.title,
              style: GoogleFonts.spaceGrotesk(
                color: OuroColors.textPrimary,
                fontSize: DesignTokens.textMd,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Coeff. ${subject.coefficient}',
              style: TextStyle(
                color: OuroColors.textSecondary.withValues(alpha: 0.6),
                fontSize: DesignTokens.textXs,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.book_outlined, size: 11, color: OuroColors.textTertiary),
                const SizedBox(width: 3),
                Text(
                  '$chapterCount chapitres',
                  style: TextStyle(
                    color: OuroColors.textSecondary.withValues(alpha: 0.5),
                    fontSize: DesignTokens.textXs,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: subjectProgress.clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: OuroColors.glassBorder,
                valueColor: AlwaysStoppedAnimation(
                  subjectProgress > 0 ? color : OuroColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
      duration: DesignTokens.durationNormal,
      delay: (300 + index * 80).ms,
    ).slideY(
      begin: 0.12,
      end: 0,
      duration: DesignTokens.durationNormal,
      delay: (300 + index * 80).ms,
      curve: Curves.easeOutCubic,
    );
  }
}
