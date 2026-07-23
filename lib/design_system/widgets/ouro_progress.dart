import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';
import '../glassmorphism.dart';

// ─────────────────────────────────────────────────────────────
//  LINEAR PROGRESS  (Duolingo-style with shimmer fill)
// ─────────────────────────────────────────────────────────────
class OuroLinearProgress extends StatefulWidget {
  final double value;
  final Color? color;
  final double height;
  final bool animated;
  final bool showShimmer;

  const OuroLinearProgress({
    super.key,
    required this.value,
    this.color,
    this.height = 8,
    this.animated = true,
    this.showShimmer = true,
  });

  @override
  State<OuroLinearProgress> createState() => _OuroLinearProgressState();
}

class _OuroLinearProgressState extends State<OuroLinearProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimCtrl;

  @override
  void initState() {
    super.initState();
    _shimCtrl = AnimationController(vsync: this, duration: 1800.ms)..repeat();
  }

  @override
  void dispose() { _shimCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final col = widget.color ?? OuroColors.meshBlue;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final fillWidth = widget.value.clamp(0.0, 1.0) * maxWidth;

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: col.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(widget.height),
          ),
          child: Stack(
            children: [
              // Fill
              AnimatedContainer(
                duration: widget.animated ? DesignTokens.durationSlow : Duration.zero,
                curve: DesignTokens.curveEmphasis,
                width: fillWidth,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.height),
                  gradient: LinearGradient(
                    colors: [col, Color.lerp(col, Colors.white, 0.3)!],
                  ),
                  boxShadow: DesignTokens.glow(col, radius: 6, spread: 0),
                ),
              ),
              // Shimmer overlay
              if (widget.showShimmer)
                AnimatedBuilder(
                  animation: _shimCtrl,
                  builder: (ctx, _) {
                    final pos = _shimCtrl.value * 1.4 - 0.2;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(widget.height),
                      child: Container(
                        width: fillWidth,
                        height: widget.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [
                              (pos - 0.15).clamp(0.0, 1.0),
                              pos.clamp(0.0, 1.0),
                              (pos + 0.15).clamp(0.0, 1.0),
                            ],
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.25),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              // Rounded end cap dot
              if (widget.value > 0.02)
                Positioned(
                  left: fillWidth - widget.height / 2,
                  top: 0,
                  child: Container(
                    width: widget.height,
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  CIRCULAR PROGRESS  (Custom arc with gradient)
// ─────────────────────────────────────────────────────────────
class OuroCircularProgress extends StatelessWidget {
  final double value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final Widget? center;

  const OuroCircularProgress({
    super.key,
    required this.value,
    this.size = 64,
    this.strokeWidth = 5,
    this.color,
    this.backgroundColor,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    final col = color ?? OuroColors.meshBlue;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: DesignTokens.durationSlow,
      curve: DesignTokens.curveEmphasis,
      builder: (context, v, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _ArcPainter(
                  progress: v,
                  color: col,
                  backgroundColor: backgroundColor ?? col.withValues(alpha: 0.1),
                  strokeWidth: strokeWidth,
                ),
              ),
              center ?? Text(
                '${(v * 100).round()}%',
                style: TextStyle(
                  color: col,
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;
  _ArcPainter({required this.progress, required this.color,
    required this.backgroundColor, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -90 * (3.14159 / 180.0);

    // Background ring
    canvas.drawCircle(
      center, radius,
      Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc with gradient shader
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect, startAngle, progress * 2 * 3.14159, false,
      Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + 2 * 3.14159,
          colors: [color, Color.lerp(color, Colors.white, 0.4)!, color],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────
//  STEP DOTS  (Onboarding / quiz — Duolingo)
// ─────────────────────────────────────────────────────────────
class OuroStepProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? activeColor;
  final Color? inactiveColor;

  const OuroStepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final col = activeColor ?? OuroColors.meshBlue;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (i) {
        final isActive  = i < currentStep;
        final isCurrent = i == currentStep;
        return AnimatedContainer(
          duration: DesignTokens.durationNormal,
          curve: DesignTokens.curveSpring,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width:  isCurrent ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive || isCurrent
                ? col
                : (inactiveColor ?? col.withValues(alpha: 0.2)),
            boxShadow: isCurrent ? DesignTokens.glow(col, radius: 6) : null,
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  PROGRESS BAR CARD  (Stats card with glow fill)
// ─────────────────────────────────────────────────────────────
class OuroProgressBarCard extends StatelessWidget {
  final String label;
  final double value;
  final String? suffix;
  final Color? color;

  const OuroProgressBarCard({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final col = color ?? OuroColors.meshBlue;
    return GlassContainer(
      padding: DesignTokens.paddingMd,
      borderRadius: DesignTokens.radiusLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(
                color: OuroColors.textSecondary, fontSize: 12)),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
                duration: DesignTokens.durationSlow,
                curve: DesignTokens.curveEmphasis,
                builder: (ctx, v, _) => Text(
                  '${(v * 100).round()}%${suffix != null ? ' $suffix' : ''}',
                  style: TextStyle(
                    color: col,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    shadows: [Shadow(color: col.withValues(alpha: 0.5), blurRadius: 8)],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          OuroLinearProgress(value: value, color: col),
        ],
      ),
    );
  }
}
