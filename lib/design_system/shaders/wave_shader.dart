import 'dart:math';
import 'package:flutter/material.dart';
import '../ouro_colors.dart';

class WaveShader extends StatelessWidget {
  final Animation<double> animation;
  final Color color;
  final double amplitude;
  final double frequency;
  final int waveCount;

  const WaveShader({
    super.key,
    required this.animation,
    this.color = OuroColors.meshBlue,
    this.amplitude = 20,
    this.frequency = 0.02,
    this.waveCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _WavePainter(
            value: animation.value,
            color: color,
            amplitude: amplitude,
            frequency: frequency,
            waveCount: waveCount,
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double value;
  final Color color;
  final double amplitude;
  final double frequency;
  final int waveCount;

  _WavePainter({
    required this.value,
    required this.color,
    required this.amplitude,
    required this.frequency,
    required this.waveCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int w = 0; w < waveCount; w++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 - w * 0.3
        ..strokeCap = StrokeCap.round;

      final path = Path();
      final baseY = size.height * (0.3 + w * 0.15);
      final phaseShift = w * pi / 3;
      final waveAlpha = 0.15 - w * 0.04;

      paint.color = color.withValues(alpha: waveAlpha.clamp(0.0, 1.0));

      for (double x = 0; x <= size.width; x += 2) {
        final adjustedAmplitude = amplitude * (0.5 + w * 0.25);
        final y = baseY +
            sin(x * frequency + value * 4 + phaseShift) * adjustedAmplitude +
            sin(x * frequency * 0.5 + value * 2 + phaseShift) * adjustedAmplitude * 0.5;

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: (waveAlpha * 0.3).clamp(0.0, 1.0)),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      final fillPath = Path.from(path);
      fillPath.lineTo(size.width, size.height);
      fillPath.lineTo(0, size.height);
      fillPath.close();
      canvas.drawPath(fillPath, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.value != value;
}

class WaveAnimation extends StatefulWidget {
  final Color color;
  final double amplitude;
  final int waveCount;

  const WaveAnimation({
    super.key,
    this.color = OuroColors.meshBlue,
    this.amplitude = 25,
    this.waveCount = 3,
  });

  @override
  State<WaveAnimation> createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WaveShader(
      animation: _controller,
      color: widget.color,
      amplitude: widget.amplitude,
      waveCount: widget.waveCount,
    );
  }
}

class WaveProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  WaveProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * 0.15;
    final baseY = size.height * (1 - progress);

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x += 2) {
      final y = baseY + sin(x * 0.05 + progress * 10) * waveHeight * 0.3;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withValues(alpha: 0.4),
        color.withValues(alpha: 0.1),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WaveProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
