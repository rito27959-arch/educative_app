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

class ChapterIntroScreen extends ConsumerWidget {
  final String subjectId;
  final String chapterId;

  const ChapterIntroScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  static const _chapterEmojis = [
    '📐', '🔬', '🧪', '🧬', '⚡', '🌿', '💻', '🎯', '🔢', '📡',
    '🧮', '🔭', '💊', '🌍', '🔋',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = CurriculumData.findById(subjectId);
    final chapter = CurriculumData.findChapterById(chapterId);
    if (subject == null || chapter == null) {
      return Scaffold(
        backgroundColor: OuroColors.background,
        body: Center(
          child: Text(
            'Chapitre introuvable',
            style: TextStyle(color: OuroColors.textSecondary),
          ),
        ),
      );
    }

    final progress = ref.watch(curriculumProgressProvider);
    final firstUnfinished =
        ref.read(curriculumProgressProvider.notifier).firstUnfinishedLesson(chapterId);
    final allLessonsDone = firstUnfinished == null;
    final doneCount = chapter.lessons
        .where((l) => progress.completedLessons.contains(l.id))
        .length;

    final chapterEmoji =
        _chapterEmojis[chapter.order % _chapterEmojis.length];

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBackButton(context),
                      _buildHeroSection(chapter, chapterEmoji, subject),
                      const SizedBox(height: DesignTokens.grid3x),
                      _buildLessonListCard(chapter, progress),
                      const SizedBox(height: DesignTokens.grid2x),
                      _buildObjectivesCard(chapter),
                      const SizedBox(height: DesignTokens.grid2x),
                      _buildPrerequisCard(chapter),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(
                context,
                ref,
                allLessonsDone,
                firstUnfinished,
                doneCount,
                chapter.lessons.length,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.grid3x,
        DesignTokens.gridBase,
        DesignTokens.grid3x,
        0,
      ),
      child: GestureDetector(
        onTap: () => context.go('/curriculum/subject/$subjectId'),
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
    ).animate().fadeIn(duration: DesignTokens.durationNormal).slideX(begin: -0.06);
  }

  Widget _buildHeroSection(
    CurriculumChapter chapter,
    String emoji,
    SubjectCurriculum subject,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: DesignTokens.grid3x),
          Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 56),
            ),
          )
              .animate()
              .scale(
                duration: 600.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 600.ms),
          const SizedBox(height: DesignTokens.grid2x),
          Center(
            child: Text(
              'Chapitre ${chapter.order}',
              style: TextStyle(
                color: OuroColors.meshBlue.withValues(alpha: 0.7),
                fontSize: DesignTokens.textMd,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
          const SizedBox(height: DesignTokens.gridSm),
          Center(
            child: Text(
              chapter.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                color: OuroColors.textPrimary,
                fontSize: DesignTokens.text4xl,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.1),
          if (chapter.subtitle.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.gridSm),
            Center(
              child: Text(
                chapter.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: OuroColors.textSecondary.withValues(alpha: 0.6),
                  fontSize: DesignTokens.textMd,
                  height: 1.4,
                ),
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
          ],
        ],
      ),
    );
  }

  Widget _buildLessonListCard(CurriculumChapter chapter, CurriculumProgress progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OuroColors.meshBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.list_alt_rounded,
                      color: OuroColors.meshBlue, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  'Dans ce chapitre',
                  style: GoogleFonts.spaceGrotesk(
                    color: OuroColors.textPrimary,
                    fontSize: DesignTokens.textLg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...chapter.lessons.asMap().entries.map((entry) {
              final i = entry.key;
              final lesson = entry.value;
              final isDone =
                  progress.completedLessons.contains(lesson.id);
              return Padding(
                padding: EdgeInsets.only(
                  bottom: i < chapter.lessons.length - 1 ? 12 : 0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isDone
                            ? OuroColors.localGreen.withValues(alpha: 0.12)
                            : OuroColors.glassBg.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDone
                              ? OuroColors.localGreen.withValues(alpha: 0.3)
                              : OuroColors.glassBorder.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Center(
                        child: isDone
                            ? const Icon(Icons.check_rounded,
                                color: OuroColors.localGreen, size: 14)
                            : Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: OuroColors.textSecondary
                                      .withValues(alpha: 0.5),
                                  fontSize: DesignTokens.textXs,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: TextStyle(
                              color: isDone
                                  ? OuroColors.localGreen.withValues(alpha: 0.7)
                                  : OuroColors.textPrimary,
                              fontSize: DesignTokens.textMd,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (lesson.subtitle.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              lesson.subtitle,
                              style: TextStyle(
                                color: OuroColors.textSecondary
                                    .withValues(alpha: 0.4),
                                fontSize: DesignTokens.textXs,
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
            }),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: DesignTokens.durationSlow, delay: 300.ms)
        .slideY(begin: 0.1);
  }

  Widget _buildObjectivesCard(CurriculumChapter chapter) {
    final objectives = _generateObjectives(chapter);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OuroColors.ouroOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.flag_outlined,
                      color: OuroColors.ouroOrange, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  'Objectifs p\u00e9dagogiques',
                  style: GoogleFonts.spaceGrotesk(
                    color: OuroColors.textPrimary,
                    fontSize: DesignTokens.textLg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...objectives.map((obj) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: OuroColors.ouroOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      obj,
                      style: TextStyle(
                        color: OuroColors.textPrimary.withValues(alpha: 0.8),
                        fontSize: DesignTokens.textMd,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: DesignTokens.durationSlow, delay: 400.ms)
        .slideY(begin: 0.1);
  }

  Widget _buildPrerequisCard(CurriculumChapter chapter) {
    final prerequis = _generatePrerequis(chapter);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OuroColors.accentPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.help_outline_rounded,
                      color: OuroColors.accentPurple, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  'Pr\u00e9requis',
                  style: GoogleFonts.spaceGrotesk(
                    color: OuroColors.textPrimary,
                    fontSize: DesignTokens.textLg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...prerequis.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline_rounded,
                      color: OuroColors.accentPurple.withValues(alpha: 0.5),
                      size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      p,
                      style: TextStyle(
                        color: OuroColors.textPrimary.withValues(alpha: 0.7),
                        fontSize: DesignTokens.textMd,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: DesignTokens.durationSlow, delay: 500.ms)
        .slideY(begin: 0.1);
  }

  Widget _buildBottomBar(
    BuildContext context,
    WidgetRef ref,
    bool allLessonsDone,
    String? firstUnfinished,
    int doneCount,
    int totalLessons,
  ) {
    if (allLessonsDone) {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: OuroColors.surface.withValues(alpha: 0.9),
          border: Border(
            top: BorderSide(
              color: OuroColors.glassBorder.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => context.go(
              '/curriculum/subject/$subjectId/chapter/$chapterId/boss-exam',
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    OuroColors.localGreen,
                    OuroColors.localGreen.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: OuroColors.localGreen.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Chapitre d\u00e9j\u00e0 compl\u00e9t\u00e9 \u2713',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: DesignTokens.textLg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: DesignTokens.durationNormal, delay: 600.ms)
              .slideY(begin: 0.15),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: OuroColors.surface.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
            color: OuroColors.glassBorder.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (doneCount > 0) ...[
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: totalLessons > 0 ? doneCount / totalLessons : 0,
                        minHeight: 5,
                        backgroundColor: OuroColors.glassBorder,
                        valueColor: const AlwaysStoppedAnimation(
                          OuroColors.meshBlue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$doneCount/$totalLessons',
                    style: TextStyle(
                      color: OuroColors.textSecondary.withValues(alpha: 0.5),
                      fontSize: DesignTokens.textSm,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            GestureDetector(
              onTap: firstUnfinished != null
                  ? () => context.go(
                      '/curriculum/subject/$subjectId/chapter/$chapterId/lesson/$firstUnfinished/transition',
                    )
                  : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [OuroColors.meshBlue, Color(0xFF1E40AF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: OuroColors.meshBlue.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      doneCount > 0
                          ? Icons.play_arrow_rounded
                          : Icons.rocket_launch_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      doneCount > 0
                          ? 'Continuer ($doneCount/$totalLessons)'
                          : 'Commencer',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: DesignTokens.textLg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: DesignTokens.durationNormal, delay: 600.ms)
          .slideY(begin: 0.15),
    );
  }

  static List<String> _generateObjectives(CurriculumChapter chapter) {
    final seed = chapter.title.hashCode;
    final rng = Random(seed);

    final prefixes = [
      'Comprendre',
      'Ma\u00eetriser',
      'Analyser',
      'Appr\u00e9hender',
      'D\u00e9couvrir',
    ];

    final suffixes = [
      'les concepts fondamentaux de ${chapter.title.toLowerCase()}',
      'les m\u00e9thodes et applications pratiques',
      'les r\u00e9soudre des exercices types du Bac',
    ];

    final count = min(3, max(2, chapter.lessons.length));
    final objectives = <String>[];
    for (int i = 0; i < count; i++) {
      final p = prefixes[rng.nextInt(prefixes.length)];
      final s = suffixes[i % suffixes.length];
      objectives.add('$p $s');
    }
    return objectives;
  }

  static List<String> _generatePrerequis(CurriculumChapter chapter) {
    final seed = chapter.title.hashCode;
    final rng = Random(seed);

    final allPrerequis = [
      'Notions de base du programme pr\u00e9c\u00e9dent',
      'Avoir compl\u00e9t\u00e9 le chapitre pr\u00e9c\u00e9dent',
      'Connaissances de math\u00e9matiques de Terminale',
      'M\u00e9thodes de raisonnement scientifique',
      'Culture scientifique g\u00e9n\u00e9rale',
      'Capacit\u00e9 d\'analyse et de synth\u00e8se',
    ];

    final count = min(3, max(2, chapter.order));
    final shuffled = [...allPrerequis]..shuffle(rng);
    return shuffled.take(count).toList();
  }
}
