import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/ouro_colors.dart';
import '../../../design_system/glassmorphism.dart';
import '../../../core/models/gamification_models.dart';
import '../../widgets/gamification/celebration_overlay.dart';

class AnimatedLevelBadge extends StatefulWidget {
  final GamificationState state;
  final double size;

  const AnimatedLevelBadge({
    super.key,
    required this.state,
    this.size = 120,
  });

  @override
  State<AnimatedLevelBadge> createState() => _AnimatedLevelBadgeState();
}

class _AnimatedLevelBadgeState extends State<AnimatedLevelBadge>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: 2.seconds,
    )..repeat(reverse: true);
    _glowController = AnimationController(
      vsync: this,
      duration: 3.seconds,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = widget.state.currentLevel;
    final progress = widget.state.levelProgress;
    final xpInLevel = widget.state.xpInCurrentLevel;
    final xpForNext = widget.state.xpNeededForNext;
    final isMaxLevel = level.level >= LevelDefinition.all.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => CelebrationOverlay.show(
            context,
            title: 'Niveau ${level.level}',
            subtitle: '${level.emoji} ${level.title}',
            emoji: level.emoji,
            color: OuroColors.meshBlue,
          ),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow ring
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (_, __) => Container(
                    width: widget.size * 1.15,
                    height: widget.size * 1.15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: OuroColors.meshBlue.withValues(
                            alpha: 0.15 + _glowController.value * 0.15,
                          ),
                          blurRadius: 20 + _glowController.value * 15,
                          spreadRadius: 5 + _glowController.value * 10,
                        ),
                      ],
                    ),
                  ),
                ),
                // Circular progress
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (_, __) => SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: CustomPaint(
                      painter: _LevelRingPainter(
                        progress: isMaxLevel ? 1.0 : progress.clamp(0.0, 1.0),
                        glowIntensity: _glowController.value,
                        isMaxLevel: isMaxLevel,
                      ),
                    ),
                  ),
                ),
                // Level circle
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, __) => Container(
                    width: widget.size * 0.7,
                    height: widget.size * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [OuroColors.meshBlue, OuroColors.meshBlueGradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: OuroColors.meshBlue.withValues(alpha: 0.3 + _pulseController.value * 0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          level.emoji,
                          style: TextStyle(fontSize: widget.size * 0.22),
                        ),
                        Text(
                          '${level.level}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.size * 0.25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${level.emoji} ${level.title}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ).animate(onPlay: (c) => c.repeat()).shake(duration: 3.seconds, hz: 0.3),
        const SizedBox(height: 8),
        if (!isMaxLevel) ...[
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            borderRadius: 12,
            opacity: 0.1,
            child: SizedBox(
              width: 200,
              height: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, __) => Stack(
                    children: [
                      Container(color: OuroColors.glassBg),
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                OuroColors.meshBlue.withValues(alpha: 0.6),
                                OuroColors.meshBlue,
                                OuroColors.localGreen,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: OuroColors.meshBlue.withValues(alpha: 0.3 + _pulseController.value * 0.2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$xpInLevel / $xpForNext XP',
            style: TextStyle(
              color: OuroColors.textSecondary.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ] else
          const Text(
            '🌟 Niveau max atteint !',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ).animate(onPlay: (c) => c.repeat()).shake(duration: 2.seconds, hz: 1),
      ],
    );
  }
}

class _LevelRingPainter extends CustomPainter {
  final double progress;
  final double glowIntensity;
  final bool isMaxLevel;

  _LevelRingPainter({
    required this.progress,
    required this.glowIntensity,
    required this.isMaxLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 4.0;

    // Background ring
    final bgPaint = Paint()
      ..color = OuroColors.glassBg.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: isMaxLevel
            ? [const Color(0xFFFFD700), const Color(0xFFFF6B2B), const Color(0xFFFFD700)]
            : [OuroColors.meshBlue, OuroColors.localGreen, OuroColors.meshBlue],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + glowIntensity * 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );

    // Glow dots at the tip
    if (progress > 0 && progress < 1) {
      final angle = -pi / 2 + 2 * pi * progress;
      final dotX = center.dx + radius * cos(angle);
      final dotY = center.dy + radius * sin(angle);
      final dotPaint = Paint()
        ..color = OuroColors.meshBlue.withValues(alpha: 0.3 + glowIntensity * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(dotX, dotY), 4 + glowIntensity * 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LevelRingPainter old) =>
      old.progress != progress || old.glowIntensity != glowIntensity;
}
