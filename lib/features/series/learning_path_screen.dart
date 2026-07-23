import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/gamification_service.dart';
import '../../core/services/storage_service.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';

/// Chemin d'apprentissage visuel — style Duolingo.
/// Remplace la liste plate de chapitres par un chemin sinueux de nœuds
/// (verrouillé/grisé, en cours, terminé).
class LearningPathScreen extends StatelessWidget {
  final String courseId;

  const LearningPathScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final course = StorageService.getCourseById(courseId);
    final chapters = GamificationService.getChapters(courseId);

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, course?.title ?? courseId, chapters),
            const SizedBox(height: 12),
            Expanded(
              child: chapters.isEmpty
                  ? const Center(child: Text('Aucun chapitre', style: TextStyle(color: OuroColors.textSecondary)))
                  : _buildPath(context, chapters, courseId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title, List<Map<String, dynamic>> chapters) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        DesignTokens.grid3x, DesignTokens.gridSm, DesignTokens.grid3x, 0,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: OuroColors.brandGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${chapters.where((c) => GamificationService.state.passedChapterExams
                .contains((c['chapterExam'] as Map?)?['id'])).length}/${chapters.length}',
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -20, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildPath(BuildContext context, List<Map<String, dynamic>> chapters, String courseId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          for (int i = 0; i < chapters.length; i++) ...[
            _buildNode(context, chapters[i], i, chapters.length, courseId),
            if (i < chapters.length - 1) _buildConnector(i, chapters, courseId),
          ],
        ],
      ),
    );
  }

  Widget _buildNode(BuildContext context, Map<String, dynamic> ch, int index, int total, String courseId) {
    final locked = !GamificationService.isChapterUnlocked(ch['id'] as String, courseId);
    final exam = ch['chapterExam'] as Map<String, dynamic>?;
    final examPassed = exam != null && GamificationService.state.passedChapterExams.contains(exam['id']);
    final isCurrent = !locked && !examPassed;
    final title = ch['title'] as String? ?? 'Chapitre ${index + 1}';

    final offsetX = (index.isEven ? 1.0 : -1.0) * 20.0;

    return Padding(
      padding: EdgeInsets.only(left: math.max(0, offsetX + 20), right: math.max(0, -offsetX + 20)),
      child: GestureDetector(
        onTap: locked ? null : () => context.go('/learn/$courseId/${ch['id']}'),
        child: AnimatedContainer(
          duration: 400.ms,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: examPassed
                ? OuroColors.successGreen.withValues(alpha: 0.08)
                : isCurrent
                    ? OuroColors.meshBlue.withValues(alpha: 0.08)
                    : OuroColors.glassBg.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: examPassed
                  ? OuroColors.successGreen.withValues(alpha: 0.4)
                  : isCurrent
                      ? OuroColors.meshBlue.withValues(alpha: 0.4)
                      : OuroColors.glassBorder,
              width: isCurrent ? 1.5 : 1,
            ),
            boxShadow: isCurrent
                ? DesignTokens.glow(OuroColors.meshBlue, radius: 12)
                : null,
          ),
          child: Row(
            children: [
              // Node circle
              AnimatedContainer(
                duration: 400.ms,
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: examPassed
                      ? OuroColors.successGreen
                      : isCurrent
                          ? OuroColors.meshBlue
                          : OuroColors.surfaceElevated,
                  boxShadow: isCurrent
                      ? DesignTokens.glow(OuroColors.meshBlue, radius: 14)
                      : null,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: 300.ms,
                    child: examPassed
                        ? const Icon(Icons.check, color: Colors.white, size: 22, key: ValueKey('done'))
                        : locked
                            ? const Icon(Icons.lock_outline, color: OuroColors.textSecondary, size: 18, key: ValueKey('locked'))
                            : Text(
                                '${index + 1}',
                                key: const ValueKey('active'),
                                style: const TextStyle(
                                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800,
                                ),
                              ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chapitre ${index + 1}',
                      style: TextStyle(
                        color: examPassed
                            ? OuroColors.successGreen
                            : locked
                                ? OuroColors.textSecondary
                                : OuroColors.meshBlueBright,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: TextStyle(
                        color: locked ? OuroColors.textSecondary : Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OuroColors.meshBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: OuroColors.meshBlue, size: 20),
                ),
              if (examPassed)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OuroColors.successGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check_circle, color: OuroColors.successGreen, size: 20),
                ),
            ],
          ),
        ).animate().fadeIn(
          duration: 400.ms,
          delay: (index * 80).ms,
        ).slideX(
          begin: offsetX > 0 ? 30 : -30,
          end: 0,
          duration: 400.ms,
          delay: (index * 80).ms,
          curve: DesignTokens.curveSpring,
        ),
      ),
    );
  }

  Widget _buildConnector(int index, List<Map<String, dynamic>> chapters, String courseId) {
    final nextLocked = !GamificationService.isChapterUnlocked(chapters[index + 1]['id'] as String, courseId);
    final exam = chapters[index]['chapterExam'] as Map<String, dynamic>?;
    final passed = exam != null && GamificationService.state.passedChapterExams.contains(exam['id']);

    final offsetX = (index.isEven ? 1.0 : -1.0) * 20.0;
    final nextOffsetX = ((index + 1).isEven ? 1.0 : -1.0) * 20.0;

    return SizedBox(
      height: 48,
      child: CustomPaint(
        painter: _PathConnectorPainter(
          color: passed ? OuroColors.successGreen : OuroColors.glassBorder,
          isLocked: nextLocked,
          startX: offsetX,
          endX: nextOffsetX,
        ),
      ),
    );
  }
}

class _PathConnectorPainter extends CustomPainter {
  final Color color;
  final bool isLocked;
  final double startX;
  final double endX;

  _PathConnectorPainter({
    required this.color,
    required this.isLocked,
    this.startX = 0,
    this.endX = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isLocked ? color.withValues(alpha: 0.3) : color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width / 2 + startX, 0);
    path.cubicTo(
      size.width / 2 + startX, size.height * 0.3,
      size.width / 2 + endX, size.height * 0.7,
      size.width / 2 + endX, size.height,
    );
    canvas.drawPath(path, paint);

    // Cercle directionnel
    if (!isLocked) {
      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.width / 2 + endX, size.height - 4), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PathConnectorPainter old) => old.color != color || old.isLocked != isLocked;
}
