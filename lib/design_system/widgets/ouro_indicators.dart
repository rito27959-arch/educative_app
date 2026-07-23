import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  BADGE  (Pill badge with color variants)
// ─────────────────────────────────────────────────────────────
class OuroBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final double fontSize;
  final EdgeInsets padding;
  final bool glow;

  const OuroBadge({
    super.key,
    required this.label,
    this.color,
    this.fontSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    this.glow = false,
  });

  @override
  Widget build(BuildContext context) {
    final col = color ?? OuroColors.meshBlue;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: col.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        border: Border.all(color: col.withValues(alpha: 0.35), width: 0.5),
        boxShadow: glow ? DesignTokens.glow(col, radius: 8) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: col,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  STATUS DOT  (Live indicator with pulse ring)
// ─────────────────────────────────────────────────────────────
class OuroStatusDot extends StatefulWidget {
  final Color color;
  final double size;
  final bool pulse;

  const OuroStatusDot({
    super.key,
    this.color = OuroColors.localGreen,
    this.size = 8,
    this.pulse = true,
  });

  @override
  State<OuroStatusDot> createState() => _OuroStatusDotState();
}

class _OuroStatusDotState extends State<OuroStatusDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 1600.ms);
    if (widget.pulse) _ctrl.repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2.4,
      height: widget.size * 2.4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.pulse)
            AnimatedBuilder(
              animation: _ctrl,
              builder: (ctx, _) {
                final v = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut).value;
                return Container(
                  width: widget.size * (1 + v * 1.4),
                  height: widget.size * (1 + v * 1.4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: (1 - v) * 0.4),
                  ),
                );
              },
            ),
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              boxShadow: DesignTokens.glow(widget.color, radius: widget.size),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  COUNT INDICATOR  (Notification bubble — TikTok/YouTube)
// ─────────────────────────────────────────────────────────────
class OuroCountIndicator extends StatelessWidget {
  final int count;
  final Color? color;

  const OuroCountIndicator({super.key, required this.count, this.color});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final col = color ?? OuroColors.errorRed;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: DesignTokens.durationNormal,
      curve: DesignTokens.curveBounce,
      builder: (ctx, v, child) => Transform.scale(scale: v, child: child),
      child: Container(
        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: col,
          borderRadius: BorderRadius.circular(9),
          boxShadow: DesignTokens.glow(col, radius: 8),
        ),
        child: Text(
          count > 99 ? '99+' : '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SCORE CHIP  (XP / points — Duolingo-style)
// ─────────────────────────────────────────────────────────────
class OuroScoreChip extends StatelessWidget {
  final int score;
  final Color color;
  final IconData icon;
  final String suffix;

  const OuroScoreChip({
    super.key,
    required this.score,
    this.color = OuroColors.ouroOrange,
    this.icon = Icons.bolt_rounded,
    this.suffix = 'XP',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.08)],
        ),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 0.5),
        boxShadow: DesignTokens.glow(color, radius: 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: score),
            duration: const Duration(milliseconds: 900),
            curve: DesignTokens.curveEmphasis,
            builder: (ctx, v, _) => Text(
              '$v $suffix',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                shadows: [Shadow(color: color.withValues(alpha: 0.6), blurRadius: 6)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  STREAK INDICATOR  (Duolingo-style flame streak)
// ─────────────────────────────────────────────────────────────
class OuroStreak extends StatelessWidget {
  final int days;
  final bool active;

  const OuroStreak({super.key, required this.days, this.active = true});

  @override
  Widget build(BuildContext context) {
    final col = active ? OuroColors.ouroOrange : OuroColors.textTertiary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_fire_department_rounded, color: col, size: 18)
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 2000.ms, color: Colors.orangeAccent.withValues(alpha: 0.5)),
        const SizedBox(width: 4),
        Text(
          '$days',
          style: TextStyle(
            color: col,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SIGNAL BARS  (WiFi-style signal strength indicator)
// ─────────────────────────────────────────────────────────────
class OuroSignalBars extends StatelessWidget {
  final int bars;
  final Color? activeColor;
  final Color? inactiveColor;

  const OuroSignalBars({
    super.key,
    this.bars = 2,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? OuroColors.meshBlue;
    final inactive = inactiveColor ?? OuroColors.textTertiary;
    return SizedBox(
      width: 28,
      height: 16,
      child: CustomPaint(
        size: const Size(28, 16),
        painter: _SignalBarsPainter(bars: bars, activeColor: active, inactiveColor: inactive),
      ),
    );
  }
}

class _SignalBarsPainter extends CustomPainter {
  final int bars;
  final Color activeColor;
  final Color inactiveColor;

  _SignalBarsPainter({
    required this.bars,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 4.0;
    final gap = 3.0;
    final heights = [6.0, 10.0, 14.0, 16.0];

    for (int i = 0; i < 4; i++) {
      final x = i * (barWidth + gap);
      final y = size.height - heights[i];
      final isActive = i < bars;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, heights[i]),
          const Radius.circular(1.5),
        ),
        Paint()
          ..color = isActive ? activeColor : inactiveColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_SignalBarsPainter old) =>
      old.bars != bars || old.activeColor != activeColor || old.inactiveColor != inactiveColor;
}
