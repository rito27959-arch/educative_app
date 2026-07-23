import 'dart:math';
import 'package:flutter/material.dart';
import '../ouro_colors.dart';

class ParticleShader extends StatelessWidget {
  final Animation<double> animation;
  final Color color;
  final int particleCount;

  const ParticleShader({
    super.key,
    required this.animation,
    this.color = OuroColors.meshBlue,
    this.particleCount = 40,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(
            value: animation.value,
            color: color,
            particleCount: particleCount,
          ),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double value;
  final Color color;
  final int particleCount;

  _ParticlePainter({
    required this.value,
    required this.color,
    required this.particleCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(value.toInt());
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < particleCount; i++) {
      final seed = i * 7.3;
      final xBase = rng.nextDouble() * size.width;
      final yBase = rng.nextDouble() * size.height;
      final dx = sin(value * 0.5 + seed) * 30;
      final dy = cos(value * 0.7 + seed) * 30;
      final x = (xBase + dx).clamp(0.0, size.width);
      final y = (yBase + dy).clamp(0.0, size.height);
      final radius = 1.5 + sin(value + seed) * 0.8;
      final alpha = 0.1 + (sin(value * 0.3 + seed) + 1) * 0.15;

      paint.color = color.withValues(alpha: alpha.clamp(0.0, 1.0));
      canvas.drawCircle(Offset(x, y), radius.clamp(0.5, 4.0), paint);

      for (int j = i + 1; j < particleCount; j++) {
        final jSeed = j * 7.3;
        final jxBase = rng.nextDouble() * size.width;
        final jyBase = rng.nextDouble() * size.height;
        final jdx = sin(value * 0.5 + jSeed) * 30;
        final jdy = cos(value * 0.7 + jSeed) * 30;
        final jx = (jxBase + jdx).clamp(0.0, size.width);
        final jy = (jyBase + jdy).clamp(0.0, size.height);
        final dist = sqrt(pow(x - jx, 2) + pow(y - jy, 2));

        if (dist < 80) {
          paint.color = color.withValues(alpha: (1 - dist / 80) * 0.08);
          paint.style = PaintingStyle.stroke;
          paint.strokeWidth = 0.5;
          canvas.drawLine(Offset(x, y), Offset(jx, jy), paint);
          paint.style = PaintingStyle.fill;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.value != value;
}

class ParticleField extends StatefulWidget {
  final Color color;
  final int particleCount;

  const ParticleField({
    super.key,
    this.color = OuroColors.meshBlue,
    this.particleCount = 30,
  });

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ParticleShader(
      animation: _controller,
      color: widget.color,
      particleCount: widget.particleCount,
    );
  }
}
