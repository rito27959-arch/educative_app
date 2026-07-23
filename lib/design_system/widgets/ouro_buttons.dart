import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

enum OuroButtonVariant { primary, secondary, ghost, danger, success }
enum OuroButtonSize    { sm, md, lg }

// ─────────────────────────────────────────────────────────────
//  OURO BUTTON  — TikTok/Duolingo-style tactile press
// ─────────────────────────────────────────────────────────────
class OuroButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final OuroButtonVariant variant;
  final OuroButtonSize size;
  final double? width;

  const OuroButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.variant = OuroButtonVariant.primary,
    this.size = OuroButtonSize.md,
    this.width,
  });

  @override
  State<OuroButton> createState() => _OuroButtonState();
}

class _OuroButtonState extends State<OuroButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: 100.ms);
    _scale = Tween(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _glow  = Tween(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  bool get _isEnabled => widget.onPressed != null && !widget.isDisabled;

  void _down(_) {
    if (!_isEnabled) return;
    HapticFeedback.lightImpact();
    _ctrl.forward();
  }
  void _up(_)   { if (_isEnabled) _ctrl.reverse(); }
  void _cancel(){ _ctrl.reverse(); }

  @override
  Widget build(BuildContext context) {
    final cfg = _sizeConfig();
    final col = _colorConfig();

    return GestureDetector(
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: _cancel,
      onTap: _isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: AnimatedContainer(
              duration: 200.ms,
              width: widget.width,
              padding: cfg.padding,
              decoration: BoxDecoration(
                gradient: col.gradient,
                color: col.gradient == null ? col.bg : null,
                borderRadius: BorderRadius.circular(cfg.radius),
                border: Border.all(color: col.border, width: col.borderWidth),
                boxShadow: _isEnabled && !widget.isLoading
                    ? col.shadow?.map((s) => BoxShadow(
                        color: s.color.withValues(alpha: s.color.a * _glow.value),
                        blurRadius: s.blurRadius,
                        spreadRadius: s.spreadRadius,
                        offset: s.offset,
                      )).toList()
                    : null,
              ),
              child: child,
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isLoading)
              SizedBox(
                width: cfg.iconSize,
                height: cfg.iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(col.text),
                ),
              )
            else ...[
              if (widget.icon != null) ...[
                Icon(widget.icon, color: col.text, size: cfg.iconSize),
                SizedBox(width: cfg.gap),
              ],
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  clipBehavior: Clip.none,
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: col.text,
                      fontSize: cfg.fontSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _SizeConfig _sizeConfig() {
    switch (widget.size) {
      case OuroButtonSize.sm:
        return _SizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          radius: 12, fontSize: 13, iconSize: 15, gap: 6,
        );
      case OuroButtonSize.md:
        return _SizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          radius: 16, fontSize: 15, iconSize: 19, gap: 8,
        );
      case OuroButtonSize.lg:
        return _SizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          radius: 20, fontSize: 17, iconSize: 22, gap: 10,
        );
    }
  }

  _ColorConfig _colorConfig() {
    final enabled = _isEnabled;

    switch (widget.variant) {
      case OuroButtonVariant.primary:
        return _ColorConfig(
          gradient: enabled
              ? const LinearGradient(
                  colors: [OuroColors.meshBlue, Color(0xFF6B38FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          bg: OuroColors.meshBlue.withValues(alpha: 0.3),
          text: enabled ? OuroColors.textPrimary : OuroColors.textSecondary,
          border: Colors.transparent,
          borderWidth: 0,
          shadow: enabled ? DesignTokens.glow(OuroColors.meshBlue, radius: 20) : null,
        );

      case OuroButtonVariant.secondary:
        return _ColorConfig(
          bg: OuroColors.glassBg,
          text: enabled ? OuroColors.textPrimary : OuroColors.textSecondary,
          border: OuroColors.glassBorderStrong,
          borderWidth: 1,
          shadow: null,
        );

      case OuroButtonVariant.ghost:
        return _ColorConfig(
          bg: Colors.transparent,
          text: enabled ? OuroColors.meshBlueBright : OuroColors.textSecondary,
          border: Colors.transparent,
          borderWidth: 0,
          shadow: null,
        );

      case OuroButtonVariant.danger:
        return _ColorConfig(
          gradient: enabled
              ? const LinearGradient(
                  colors: [OuroColors.errorRed, OuroColors.accentPink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          bg: OuroColors.errorRed.withValues(alpha: 0.3),
          text: enabled ? OuroColors.textPrimary : OuroColors.textSecondary,
          border: Colors.transparent,
          borderWidth: 0,
          shadow: enabled ? DesignTokens.glow(OuroColors.errorRed, radius: 16) : null,
        );

      case OuroButtonVariant.success:
        return _ColorConfig(
          gradient: enabled
              ? const LinearGradient(
                  colors: [OuroColors.accentTeal, OuroColors.localGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          bg: OuroColors.accentTeal.withValues(alpha: 0.3),
          text: enabled ? OuroColors.background : OuroColors.textSecondary,
          border: Colors.transparent,
          borderWidth: 0,
          shadow: enabled ? DesignTokens.glow(OuroColors.accentTeal, radius: 16) : null,
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  ICON BUTTON  — TikTok action button
// ─────────────────────────────────────────────────────────────
class OuroIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final double size;
  final bool showGlow;
  final String? badge;

  const OuroIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
    this.size = 44,
    this.showGlow = false,
    this.badge,
  });

  @override
  State<OuroIconButton> createState() => _OuroIconButtonState();
}

class _OuroIconButtonState extends State<OuroIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 80.ms);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final col = widget.color ?? OuroColors.textSecondary;
    return GestureDetector(
      onTapDown: (_) { HapticFeedback.selectionClick(); _ctrl.forward(); },
      onTapUp:   (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, child) => Transform.scale(
          scale: Tween(begin: 1.0, end: 0.85).evaluate(_ctrl),
          child: child,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: OuroColors.glassBg,
                border: Border.all(color: OuroColors.glassBorder, width: 0.5),
                boxShadow: widget.showGlow
                    ? DesignTokens.glow(col, radius: 12)
                    : null,
              ),
              child: Icon(widget.icon, color: col, size: widget.size * 0.45),
            ),
            if (widget.badge != null)
              Positioned(
                top: -2, right: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: OuroColors.errorRed,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: OuroColors.background, width: 1.5),
                  ),
                  child: Text(
                    widget.badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FAB  — Morphing FAB (YouTube-style)
// ─────────────────────────────────────────────────────────────
class OuroFAB extends StatefulWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onTap;
  final Color? color;

  const OuroFAB({
    super.key,
    required this.icon,
    this.label,
    this.onTap,
    this.color,
  });

  @override
  State<OuroFAB> createState() => _OuroFABState();
}

class _OuroFABState extends State<OuroFAB> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 100.ms);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final col = widget.color ?? OuroColors.meshBlue;
    return GestureDetector(
      onTapDown: (_) { HapticFeedback.mediumImpact(); _ctrl.forward(); },
      onTapUp:   (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, child) => Transform.scale(
          scale: Tween(begin: 1.0, end: 0.92).evaluate(_ctrl),
          child: child,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.label != null ? 20 : 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [col, Color.lerp(col, OuroColors.accentPurple, 0.5)!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(widget.label != null ? 20 : 50),
            boxShadow: DesignTokens.glow(col, radius: 24, spread: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.white, size: 22),
              if (widget.label != null) ...[
                const SizedBox(width: 10),
                Text(
                  widget.label!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Internal helpers ─────────────────────────────────────────
class _SizeConfig {
  final EdgeInsets padding;
  final double radius;
  final double fontSize;
  final double iconSize;
  final double gap;
  _SizeConfig({required this.padding, required this.radius,
    required this.fontSize, required this.iconSize, required this.gap});
}

class _ColorConfig {
  final LinearGradient? gradient;
  final Color bg;
  final Color text;
  final Color border;
  final double borderWidth;
  final List<BoxShadow>? shadow;
  _ColorConfig({this.gradient, required this.bg, required this.text,
    required this.border, required this.borderWidth, this.shadow});
}
