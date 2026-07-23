import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/ouro_colors.dart';

class CelebrationOverlay extends StatefulWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final int? xpGained;
  final int? newLevel;
  final Color color;
  final VoidCallback? onDismiss;

  const CelebrationOverlay({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    this.xpGained,
    this.newLevel,
    this.color = OuroColors.meshBlue,
    this.onDismiss,
  });

  static void show(BuildContext context, {
    required String title,
    required String subtitle,
    required String emoji,
    int? xpGained,
    int? newLevel,
    Color color = OuroColors.meshBlue,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (_) => CelebrationOverlay(
        title: title,
        subtitle: subtitle,
        emoji: emoji,
        xpGained: xpGained,
        newLevel: newLevel,
        color: color,
      ),
    );
  }

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 3.seconds,
    )..forward();
    _particles = List.generate(60, (_) => _Particle());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => CustomPaint(
                size: Size.infinite,
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onDismiss?.call();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.emoji, style: const TextStyle(fontSize: 80))
                        .animate()
                        .scale(begin: const Offset(0, 0), duration: 600.ms, curve: Curves.elasticOut)
                        .then()
                        .shake(duration: 400.ms, hz: 2),
                    const SizedBox(height: 24),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 20, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: 12),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: widget.color,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                    const SizedBox(height: 24),
                    if (widget.xpGained != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.color.withValues(alpha: 0.2),
                              widget.color.withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: widget.color.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              '+${widget.xpGained} XP',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 700.ms).scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut),
                    if (widget.newLevel != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: OuroColors.localGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Niveau ${widget.newLevel}',
                          style: const TextStyle(
                            color: OuroColors.localGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 900.ms),
                    ],
                    const SizedBox(height: 40),
                    Text(
                      'Tape pour continuer',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 13,
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 1200.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Particle {
  double x = Random().nextDouble();
  double y = -0.1 - Random().nextDouble() * 0.3;
  double speed = 0.3 + Random().nextDouble() * 0.7;
  double size = 4 + Random().nextDouble() * 8;
  double rotation = Random().nextDouble() * 6.28;
  double rotSpeed = (Random().nextDouble() - 0.5) * 6;
  Color color = [
    OuroColors.meshBlue,
    OuroColors.ouroOrange,
    OuroColors.localGreen,
    Colors.purple,
    Colors.amber,
    Colors.cyan,
  ][Random().nextInt(6)];
  double wobble = Random().nextDouble() * 2;
  double wobbleSpeed = (Random().nextDouble() - 0.5) * 4;
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.y + progress * p.speed * 1.5) % 1.1;
      final wobbleX = sin(progress * p.wobbleSpeed + p.wobble) * 15;
      final x = (p.x * size.width + wobbleX) % size.width;
      final alpha = y > 1.0 ? (1.0 - (y - 1.0) * 10).clamp(0.0, 1.0) : 1.0;
      final s = p.size * (0.5 + 0.5 * sin(progress * p.rotSpeed + p.rotation));
      canvas.save();
      canvas.translate(x, y * size.height);
      canvas.rotate(progress * p.rotSpeed + p.rotation);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: s, height: s * 0.6),
        Paint()..color = p.color.withValues(alpha: alpha * 0.85),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.progress != progress;
}
