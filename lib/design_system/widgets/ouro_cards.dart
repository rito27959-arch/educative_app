import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  BASE CARD  (press-to-scale, tilt on tap — like iOS Springboard)
// ─────────────────────────────────────────────────────────────
class OuroCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final Border? border;
  final Gradient? gradient;

  const OuroCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = 20,
    this.backgroundColor,
    this.boxShadow,
    this.onTap,
    this.margin,
    this.border,
    this.gradient,
  });

  @override
  State<OuroCard> createState() => _OuroCardState();
}

class _OuroCardState extends State<OuroCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  Offset _tilt = Offset.zero;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: 120.ms);
    _scale = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) {
        if (widget.onTap == null) return;
        HapticFeedback.lightImpact();
        _ctrl.forward();
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final local = box.globalToLocal(d.globalPosition);
          final w = box.size.width;
          final h = box.size.height;
          setState(() {
            _tilt = Offset(
              (local.dx / w - 0.5) * 0.04,
              (local.dy / h - 0.5) * 0.04,
            );
          });
        }
      },
      onTapUp: (_) {
        _ctrl.reverse();
        setState(() => _tilt = Offset.zero);
      },
      onTapCancel: () {
        _ctrl.reverse();
        setState(() => _tilt = Offset.zero);
      },
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (ctx, child) => Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(-_tilt.dy)
            ..rotateY(_tilt.dx)
            ..scale(_scale.value),
          child: child,
        ),
        child: Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          padding: widget.padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.gradient == null ? (widget.backgroundColor ?? OuroColors.cardDark) : null,
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.border ?? Border.all(color: OuroColors.glassBorder, width: 0.5),
            boxShadow: widget.boxShadow ?? DesignTokens.cardShadow,
          ),
          child: widget.child,
        ),
      ),
    ).animate()
        .fadeIn(duration: 380.ms, curve: Curves.easeOut)
        .slideY(begin: 0.06, end: 0, duration: 380.ms, curve: DesignTokens.curveSpring);
  }
}

// ─────────────────────────────────────────────────────────────
//  STAT CARD  (Dashboard — Netflix info cards)
// ─────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final int index;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 0.5),
        boxShadow: DesignTokens.glow(color, radius: 14),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              boxShadow: DesignTokens.glow(color, radius: 8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 700 + index * 120),
            curve: DesignTokens.curveEmphasis,
            builder: (ctx, v, _) => Opacity(
              opacity: v,
              child: Transform.translate(
                offset: Offset(0, (1 - v) * 8),
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    shadows: [Shadow(color: color.withValues(alpha: 0.5), blurRadius: 10)],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(color: OuroColors.textSecondary, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: 450.ms,
          delay: Duration(milliseconds: 160 + index * 80),
          curve: Curves.easeOut,
        ).slideY(
          begin: 0.2,
          end: 0,
          duration: 450.ms,
          delay: Duration(milliseconds: 160 + index * 80),
          curve: DesignTokens.curveSpring,
        );
  }
}

// ─────────────────────────────────────────────────────────────
//  PROGRESS CARD  (Course card — with fill animation)
// ─────────────────────────────────────────────────────────────
class ProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final Color color;
  final Widget? leading;
  final VoidCallback? onTap;

  const ProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    this.color = OuroColors.meshBlue,
    this.leading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OuroCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 14)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                  color: OuroColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                )),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(
                  color: OuroColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
                      duration: DesignTokens.durationSlow,
                      curve: DesignTokens.curveEmphasis,
                      builder: (ctx, v, _) => FractionallySizedBox(
                        widthFactor: v,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: LinearGradient(colors: [color, Color.lerp(color, Colors.white, 0.3)!]),
                            boxShadow: DesignTokens.glow(color, radius: 5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
            duration: DesignTokens.durationSlow,
            curve: DesignTokens.curveEmphasis,
            builder: (ctx, v, _) => Text(
              '${(v * 100).round()}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                shadows: [Shadow(color: color.withValues(alpha: 0.5), blurRadius: 8)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FEATURED CARD  (Hero card — YouTube/Netflix thumbnail feel)
// ─────────────────────────────────────────────────────────────
class FeaturedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? tag;
  final Gradient gradient;
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const FeaturedCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.tag,
    this.gradient = OuroColors.brandGradient,
    this.icon,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return OuroCard(
      gradient: gradient,
      borderRadius: 24,
      border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            right: -20, top: -20,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 20, bottom: -30,
            child: Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag!.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              if (tag != null) const SizedBox(height: 10),
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        )),
                        const SizedBox(height: 4),
                        Text(subtitle, style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 13,
                        )),
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
