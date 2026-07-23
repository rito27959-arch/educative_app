import 'dart:math';
import 'package:flutter/material.dart';

class MeshGradientShader extends StatelessWidget {
  final Animation<double> animation;
  final List<Color> colors;
  final double speed;

  const MeshGradientShader({
    super.key,
    required this.animation,
    this.colors = const [
      Color(0xFF00A8FF),
      Color(0xFF0066FF),
      Color(0xFF090909),
      Color(0xFF141414),
    ],
    this.speed = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _MeshGradientPainter(
            value: animation.value,
            colors: colors,
            speed: speed,
          ),
        );
      },
    );
  }
}

class _MeshGradientPainter extends CustomPainter {
  final double value;
  final List<Color> colors;
  final double speed;

  _MeshGradientPainter({
    required this.value,
    required this.colors,
    required this.speed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rng = Random(value.toInt());

    for (int i = 0; i < 6; i++) {
      final x = size.width * (0.1 + 0.8 * sin(value * speed + i * 1.2 + rng.nextDouble() * 0.5));
      final y = size.height * (0.1 + 0.8 * cos(value * speed * 0.7 + i * 0.9 + rng.nextDouble() * 0.5));
      final radius = size.width * 0.3 + size.width * 0.2 * sin(value * speed * 0.5 + i * 1.5);

      final color = colors[i % colors.length];
      final gradient = RadialGradient(
        center: Alignment(x / size.width * 2 - 1, y / size.height * 2 - 1),
        radius: radius / size.width,
        colors: [
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.0),
        ],
      );

      paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MeshGradientPainter oldDelegate) =>
      oldDelegate.value != value;
}

class GridShaderPainter extends CustomPainter {
  final Animation<double> animation;

  GridShaderPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    final double offsetX = animation.value * spacing;

    paint.color = const Color(0xFF00A8FF).withValues(alpha: 0.05);

    for (double x = offsetX % spacing; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    final double offsetY = animation.value * spacing * 0.7;
    for (double y = offsetY % spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridShaderPainter oldDelegate) => true;
}

class HolographicShaderPainter extends CustomPainter {
  final double time;
  final Color primaryColor;

  HolographicShaderPainter({required this.time, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 12; i++) {
      final phase = time * 2 + i * (pi / 6);
      final radius = 30 + 20 * sin(phase);
      final angle = time * 0.5 + i * (pi / 6);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      final paint = Paint()
        ..color = primaryColor.withValues(alpha: 0.3 - i * 0.02)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 - i * 0.1;

      canvas.drawCircle(Offset(x, y), 20 + 10 * sin(phase + i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant HolographicShaderPainter oldDelegate) =>
      oldDelegate.time != time;
}
