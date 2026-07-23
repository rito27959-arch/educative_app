import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'ouro_colors.dart';
import 'design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  GLASS CONTAINER  (True iOS-style, layered backdrop)
// ─────────────────────────────────────────────────────────────
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.blur = 16,
    this.opacity = 0.08,
    this.border,
    this.boxShadow,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(color: OuroColors.glassBorder, width: 0.5),
        boxShadow: boxShadow ?? DesignTokens.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null
                  ? OuroColors.glassBg.withValues(alpha: opacity)
                  : null,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  GLOW CONTAINER  (Neon glow border)
// ─────────────────────────────────────────────────────────────
class GlowContainer extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double radius;
  final double opacity;
  final double borderRadius;

  const GlowContainer({
    super.key,
    required this.child,
    this.glowColor = OuroColors.meshBlue,
    this.radius = 20,
    this.opacity = 0.3,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: DesignTokens.glow(glowColor, radius: radius),
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FROSTED SHEET  (Bottom sheet / dialog backdrop)
// ─────────────────────────────────────────────────────────────
class FrostedSheet extends StatelessWidget {
  final Widget child;
  final double topRadius;
  final EdgeInsetsGeometry? padding;

  const FrostedSheet({
    super.key,
    required this.child,
    this.topRadius = 32,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius)),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: OuroColors.surface.withValues(alpha: 0.92),
            borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius)),
            border: Border(
              top:   const BorderSide(color: OuroColors.glassBorderStrong, width: 0.5),
              left:  const BorderSide(color: OuroColors.glassBorder, width: 0.5),
              right: const BorderSide(color: OuroColors.glassBorder, width: 0.5),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  GRADIENT OVERLAY  (Hero image fade — Netflix)
// ─────────────────────────────────────────────────────────────
class GradientOverlay extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientOverlay({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topCenter,
    this.end   = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors: colors ?? [
                  Colors.transparent,
                  OuroColors.background.withValues(alpha: 0.6),
                  OuroColors.background,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ANIMATED GRADIENT BG  (Ambient background — TikTok style)
// ─────────────────────────────────────────────────────────────
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors = const [OuroColors.background, Color(0xFF0A0A1A), Color(0xFF060610)],
    this.duration = const Duration(seconds: 6),
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                -0.5 + _ctrl.value * 1.0,
                -0.5 + _ctrl.value * 0.5,
              ),
              radius: 1.2,
              colors: [
                OuroColors.meshBlue.withValues(alpha: 0.04 + _ctrl.value * 0.02),
                OuroColors.background,
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
