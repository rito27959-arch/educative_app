import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/gamification_service.dart';
import '../../core/services/storage_service.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';

class ChapterListScreen extends StatelessWidget {
  final String courseId;

  const ChapterListScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final course = StorageService.getCourseById(courseId);
    final chapters = GamificationService.getChapters(courseId);

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DesignTokens.grid2x, DesignTokens.gridBase,
                DesignTokens.grid2x, 0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: OuroColors.textSecondary, size: 22,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.grid2x),
                  Expanded(
                    child: Text(
                      course?.title ?? courseId,
                      style: const TextStyle(
                        color: OuroColors.textPrimary,
                        fontSize: DesignTokens.textLg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.grid2x),
            Expanded(
              child: chapters.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun chapitre disponible',
                        style: TextStyle(color: OuroColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      padding: DesignTokens.hPaddingLg,
                      itemCount: chapters.length,
                      separatorBuilder: (_, _) => const SizedBox(height: DesignTokens.gridBase),
                      itemBuilder: (context, index) {
                        final ch = chapters[index];
                        final locked = !GamificationService.isChapterUnlocked(
                          ch['id'] as String, courseId,
                        );
                        final exam = ch['chapterExam'] as Map<String, dynamic>?;
                        final examPassed = exam != null &&
                            GamificationService.state.passedChapterExams.contains(exam['id']);

                        return _buildChapterCard(ch, index, locked, examPassed, courseId, context);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterCard(
    Map<String, dynamic> ch, int index, bool locked,
    bool examPassed, String courseId, BuildContext context,
  ) {
    final title = ch['title'] as String? ?? 'Chapitre ${index + 1}';
    final subtitle = ch['subtitle'] as String? ?? '';

    return GestureDetector(
      onTap: locked ? null : () => context.go('/learn/$courseId/${ch['id']}'),
      child: AnimatedContainer(
        duration: DesignTokens.durationFast,
        padding: DesignTokens.paddingLg,
        decoration: BoxDecoration(
          color: locked
              ? OuroColors.glassBg.withValues(alpha: 0.4)
              : OuroColors.glassBg,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          border: Border.all(
            color: examPassed
                ? OuroColors.successGreen.withValues(alpha: 0.3)
                : OuroColors.glassBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: examPassed
                    ? OuroColors.successGreen.withValues(alpha: 0.12)
                    : (locked ? OuroColors.surfaceElevated : OuroColors.meshBlue.withValues(alpha: 0.12)),
                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              ),
              child: Center(
                child: Icon(
                  examPassed ? Icons.check_circle :
                  locked ? Icons.lock_outline : Icons.play_arrow_rounded,
                  color: examPassed ? OuroColors.successGreen :
                         locked ? OuroColors.textSecondary : OuroColors.meshBlue,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.grid2x),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: locked ? OuroColors.textSecondary : OuroColors.textPrimary,
                      fontSize: DesignTokens.textMd,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: OuroColors.textSecondary,
                        fontSize: DesignTokens.textSm,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: OuroColors.textSecondary, size: 20,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
      duration: DesignTokens.durationNormal,
      delay: (index * 60).ms,
    ).slideX(begin: 0.06, end: 0, duration: DesignTokens.durationNormal);
  }
}
