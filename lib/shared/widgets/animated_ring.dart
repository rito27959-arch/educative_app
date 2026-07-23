import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  ANIMATED RING  (Progress ring with gradient + glow dot)
// ─────────────────────────────────────────────────────────────
class AnimatedRing extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color color;
  final Color? secondaryColor;
  final Widget? center;
  final bool showGlowDot;
  final bool animateIn;

  const AnimatedRing({
    super.key,
    this.progress = 0.72,
    this.size = 140,
    this.strokeWidth = 7,
    this.color = OuroColors.meshBlue,
    this.secondaryColor,
    this.center,
    this.showGlowDot = true,
    this.animateIn = true,
  });

  @override
  State<AnimatedRing> createState() => _AnimatedRingState();
}

class _AnimatedRingState extends State<AnimatedRing>
    with TickerProviderStateMixin {
  late AnimationController _progressCtrl;
  late AnimationController _rotateCtrl;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(vsync: this, duration: 1800.ms);
    _rotateCtrl   = AnimationController(vsync: this, duration: 12000.ms)..repeat();

    _progressAnim = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _progressCtrl, curve: DesignTokens.curveEmphasis),
    );

    if (widget.animateIn) _progressCtrl.forward();
  }

  @override
  void didUpdateWidget(AnimatedRing old) {
    super.didUpdateWidget(old);
    if (old.progress != widget.progress) {
      _progressAnim = Tween<double>(
        begin: _progressAnim.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _progressCtrl, curve: DesignTokens.curveEmphasis));
      _progressCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondary = widget.secondaryColor ?? Color.lerp(widget.color, OuroColors.accentPurple, 0.5)!;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Slow-rotating ambient ring
          AnimatedBuilder(
            animation: _rotateCtrl,
            builder: (ctx, _) => Transform.rotate(
              angle: _rotateCtrl.value * math.pi * 2,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _AmbientRingPainter(color: widget.color),
              ),
            ),
          ),
          // Main progress ring
          AnimatedBuilder(
            animation: _progressAnim,
            builder: (ctx, _) => CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _GradientRingPainter(
                progress: _progressAnim.value,
                color: widget.color,
                secondaryColor: secondary,
                strokeWidth: widget.strokeWidth,
                showGlowDot: widget.showGlowDot,
              ),
            ),
          ),
          // Center content
          if (widget.center != null) widget.center!,
        ],
      ),
    );
  }
}

class _AmbientRingPainter extends CustomPainter {
  final Color color;
  _AmbientRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width * 0.48;
    // 3 dashes
    for (int i = 0; i < 3; i++) {
      final startAngle = i * math.pi * 2 / 3;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startAngle, math.pi * 0.3, false,
        Paint()
          ..color = color.withValues(alpha: 0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_AmbientRingPainter old) => false;
}

class _GradientRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double strokeWidth;
  final bool showGlowDot;

  _GradientRingPainter({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.strokeWidth,
    required this.showGlowDot,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    const startAngle = -math.pi / 2;
    final sweepAngle = progress * 2 * math.pi;

    // Background track
    canvas.drawCircle(
      Offset(cx, cy), r,
      Paint()
        ..color = color.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (progress <= 0) return;

    // Gradient sweep
    canvas.drawArc(
      rect, startAngle, sweepAngle, false,
      Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: [color, secondaryColor],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Glow dot at end
    if (showGlowDot) {
      final endAngle = startAngle + sweepAngle;
      final dotX = cx + r * math.cos(endAngle);
      final dotY = cy + r * math.sin(endAngle);
      // Outer glow
      canvas.drawCircle(
        Offset(dotX, dotY), strokeWidth * 1.4,
        Paint()..color = secondaryColor.withValues(alpha: 0.3),
      );
      // Core
      canvas.drawCircle(
        Offset(dotX, dotY), strokeWidth * 0.65,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(_GradientRingPainter old) =>
      old.progress != progress || old.color != color;
}
