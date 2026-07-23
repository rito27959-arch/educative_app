import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  TOGGLE / SWITCH  (iOS-style with spring thumb)
// ─────────────────────────────────────────────────────────────
class OuroToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final double width;
  final double height;

  const OuroToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.width  = 50,
    this.height = 28,
  });

  @override
  State<OuroToggle> createState() => _OuroToggleState();
}

class _OuroToggleState extends State<OuroToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _thumbAnim;
  late Animation<Color?> _trackAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: 280.ms, value: widget.value ? 1.0 : 0.0);

    final col = widget.activeColor ?? OuroColors.meshBlue;

    _thumbAnim = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: DesignTokens.curveSpring));

    _trackAnim = ColorTween(
      begin: OuroColors.glassBg,
      end: col,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(OuroToggle old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      widget.value ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final thumbSize  = widget.height - 4;
    final travelDist = widget.width - thumbSize - 4;
    final col        = widget.activeColor ?? OuroColors.meshBlue;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onChanged?.call(!widget.value);
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, _) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height),
              color: _trackAnim.value,
              border: Border.all(
                color: Color.lerp(OuroColors.glassBorder, col, _ctrl.value)!,
                width: 0.5,
              ),
              boxShadow: _ctrl.value > 0.5
                  ? DesignTokens.glow(col, radius: 8 * _ctrl.value)
                  : null,
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration.zero,
                  left: 2 + travelDist * _thumbAnim.value,
                  top: 2,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SETTINGS ROW  (Toggle with label and optional subtitle)
// ─────────────────────────────────────────────────────────────
class OuroSettingToggle extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final IconData? icon;
  final Color? iconColor;

  const OuroSettingToggle({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: OuroColors.glassBorder, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: (iconColor ?? OuroColors.meshBlue).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: iconColor ?? OuroColors.meshBlue, size: 16),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(
                  color: OuroColors.textPrimary, fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: const TextStyle(
                    color: OuroColors.textSecondary, fontSize: 12)),
                ],
              ],
            ),
          ),
          OuroToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
