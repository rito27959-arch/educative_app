import 'dart:math';
import 'package:flutter/material.dart';
import '../ouro_colors.dart';

class NeonShader extends StatelessWidget {
  final Animation<double> animation;
  final Color color;
  final double strokeWidth;

  const NeonShader({
    super.key,
    required this.animation,
    this.color = OuroColors.meshBlue,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _NeonPainter(
            value: animation.value,
            color: color,
            strokeWidth: strokeWidth,
          ),
        );
      },
    );
  }
}

class _NeonPainter extends CustomPainter {
  final double value;
  final Color color;
  final double strokeWidth;

  _NeonPainter({
    required this.value,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) * 0.35;

    for (int i = 0; i < 8; i++) {
      final phase = value * 2 + i * pi / 4;
      final radius = maxRadius * (0.6 + 0.4 * sin(phase));
      final angle = value * 0.3 + i * pi / 4;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.2 + 0.15 * sin(phase + i))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 4 + 2 * sin(phase), glowPaint);

      final corePaint = Paint()
        ..color = color.withValues(alpha: 0.5 + 0.3 * sin(phase + i))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 2, corePaint);
    }

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (int r = 0; r < 3; r++) {
      final ringPhase = value * 1.5 + r * pi / 3;
      final ringRadius = maxRadius * (0.5 + r * 0.2);
      final startAngle = ringPhase;
      final sweepAngle = pi * 1.5 + sin(ringPhase * 0.5) * pi * 0.5;

      final glowRingPaint = Paint()
        ..color = color.withValues(alpha: 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: ringRadius),
        startAngle,
        sweepAngle,
        false,
        glowRingPaint,
      );

      ringPaint.color = color.withValues(alpha: 0.3 + 0.2 * sin(ringPhase));
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: ringRadius),
        startAngle,
        sweepAngle,
        false,
        ringPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NeonPainter oldDelegate) =>
      oldDelegate.value != value;
}

class NeonGlowEffect extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double intensity;

  const NeonGlowEffect({
    super.key,
    required this.child,
    this.glowColor = OuroColors.meshBlue,
    this.intensity = 1.0,
  });

  @override
  State<NeonGlowEffect> createState() => _NeonGlowEffectState();
}

class _NeonGlowEffectState extends State<NeonGlowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glowValue = 0.5 + _controller.value * 0.5 * widget.intensity;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: 0.2 * glowValue),
                blurRadius: 8 * glowValue,
                spreadRadius: 1 * glowValue,
              ),
              BoxShadow(
                color: widget.glowColor.withValues(alpha: 0.1 * glowValue),
                blurRadius: 20 * glowValue,
                spreadRadius: 2 * glowValue,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

class NeonBorderPainter extends CustomPainter {
  final double value;
  final Color color;
  final double borderRadius;

  NeonBorderPainter({
    required this.value,
    required this.color,
    this.borderRadius = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    paint.color = color.withValues(alpha: 0.6);
    canvas.drawRRect(rect, paint);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
      ..color = color.withValues(alpha: 0.15);

    canvas.drawRRect(rect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant NeonBorderPainter oldDelegate) =>
      oldDelegate.value != value;
}
