import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/ouro_colors.dart';

class StreakFlame extends StatefulWidget {
  final int streak;
  final double size;

  const StreakFlame({
    super.key,
    required this.streak,
    this.size = 48,
  });

  @override
  State<StreakFlame> createState() => _StreakFlameState();
}

class _StreakFlameState extends State<StreakFlame>
    with SingleTickerProviderStateMixin {
  late AnimationController _flickerController;
  static const _milestones = [7, 14, 21, 30, 60, 90];

  @override
  void initState() {
    super.initState();
    _flickerController = AnimationController(
      vsync: this,
      duration: 1.seconds,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _flickerController.dispose();
    super.dispose();
  }

  Color get _flameColor {
    if (widget.streak >= 60) return const Color(0xFFFFD700);
    if (widget.streak >= 30) return OuroColors.ouroOrange;
    if (widget.streak >= 14) return Colors.orange;
    if (widget.streak >= 7) return Colors.deepOrange;
    return Colors.orange.withValues(alpha: 0.6);
  }

  String? get _milestoneLabel {
    for (final m in _milestones.reversed) {
      if (widget.streak >= m) return '$m';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _flickerController,
          builder: (_, __) => CustomPaint(
            size: Size(widget.size, widget.size * 1.2),
            painter: _FlamePainter(
              progress: _flickerController.value,
              color: _flameColor,
              intensity: (widget.streak / 90).clamp(0.3, 1.0),
            ),
          ),
        ),
        if (widget.streak > 0)
          Container(
            margin: EdgeInsets.only(top: widget.size * 0.05),
            padding: EdgeInsets.symmetric(
              horizontal: widget.size * 0.2,
              vertical: widget.size * 0.05,
            ),
            decoration: BoxDecoration(
              color: _flameColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(widget.size * 0.15),
            ),
            child: Text(
              '${widget.streak}',
              style: TextStyle(
                color: _flameColor,
                fontSize: widget.size * 0.35,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        if (_milestoneLabel != null)
          Text(
            '🔥 x$_milestoneLabel',
            style: TextStyle(
              color: _flameColor.withValues(alpha: 0.6),
              fontSize: widget.size * 0.2,
              fontWeight: FontWeight.w600,
            ),
          ).animate(onPlay: (c) => c.repeat()).shake(duration: 2.seconds, hz: 0.5),
      ],
    );
  }
}

class _FlamePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double intensity;

  _FlamePainter({
    required this.progress,
    required this.color,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final baseY = size.height * 0.85;
    final flameHeight = size.height * 0.8 * intensity;

    // Outer glow
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.15 * intensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(
      Offset(centerX, baseY - flameHeight * 0.5),
      size.width * 0.5,
      glowPaint,
    );

    // Main flame body
    final flamePath = Path();
    flamePath.moveTo(centerX - size.width * 0.25, baseY);
    flamePath.quadraticBezierTo(
      centerX - size.width * 0.3,
      baseY - flameHeight * 0.3,
      centerX - size.width * 0.15 + sin(progress * 3) * 3,
      baseY - flameHeight * 0.5,
    );
    flamePath.quadraticBezierTo(
      centerX - size.width * 0.1 + sin(progress * 4 + 1) * 4,
      baseY - flameHeight * 0.7,
      centerX + sin(progress * 5 + 2) * 5,
      baseY - flameHeight,
    );
    flamePath.quadraticBezierTo(
      centerX + size.width * 0.1 + sin(progress * 4 + 3) * 4,
      baseY - flameHeight * 0.7,
      centerX + size.width * 0.15 + sin(progress * 3 + 4) * 3,
      baseY - flameHeight * 0.5,
    );
    flamePath.quadraticBezierTo(
      centerX + size.width * 0.3,
      baseY - flameHeight * 0.3,
      centerX + size.width * 0.25,
      baseY,
    );
    flamePath.close();

    final flameGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          color,
          color.withValues(alpha: 0.6),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(centerX, baseY - flameHeight * 0.5),
        radius: size.width * 0.5,
      ));
    canvas.drawPath(flamePath, flameGradient);

    // Inner core (white-hot)
    final corePath = Path();
    corePath.moveTo(centerX - size.width * 0.1, baseY - size.height * 0.05);
    corePath.quadraticBezierTo(
      centerX - size.width * 0.05 + sin(progress * 6) * 2,
      baseY - flameHeight * 0.6,
      centerX + sin(progress * 7) * 2,
      baseY - flameHeight * 0.85,
    );
    corePath.quadraticBezierTo(
      centerX + size.width * 0.05 + sin(progress * 6 + 1) * 2,
      baseY - flameHeight * 0.6,
      centerX + size.width * 0.1,
      baseY - size.height * 0.05,
    );
    corePath.close();
    canvas.drawPath(corePath, Paint()..color = Colors.white.withValues(alpha: 0.8 * intensity));

    // Embers
    final emberPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 6; i++) {
      final angle = progress * 4 + i * 1.2;
      final dist = 10 + sin(angle) * 8;
      final ex = centerX + cos(angle + i) * dist;
      final ey = baseY - flameHeight * 0.8 - 5 + sin(angle * 2 + i) * 10;
      emberPaint.color = color.withValues(alpha: (0.3 + sin(angle) * 0.2).clamp(0.0, 0.5));
      canvas.drawCircle(Offset(ex, ey), 1.5 + sin(angle) * 0.8, emberPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FlamePainter old) => old.progress != progress || old.color != color;
}
