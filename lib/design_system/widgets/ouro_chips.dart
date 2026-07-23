import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  FILTER CHIP  (TikTok hashtag / YouTube category pill)
// ─────────────────────────────────────────────────────────────
class OuroFilterChip extends StatefulWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;
  final Color? color;

  const OuroFilterChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.icon,
    this.color,
  });

  @override
  State<OuroFilterChip> createState() => _OuroFilterChipState();
}

class _OuroFilterChipState extends State<OuroFilterChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 120.ms);
    if (widget.selected) _ctrl.forward();
  }

  @override
  void didUpdateWidget(OuroFilterChip old) {
    super.didUpdateWidget(old);
    if (widget.selected != old.selected) {
      widget.selected ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final col = widget.color ?? OuroColors.meshBlue;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onSelected?.call(!widget.selected);
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, _) {
          final v = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut).value;
          return AnimatedContainer(
            duration: 200.ms,
            padding: EdgeInsets.symmetric(
              horizontal: widget.icon != null ? 12 : 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color.lerp(OuroColors.glassBg, col.withValues(alpha: 0.15), v),
              border: Border.all(
                color: Color.lerp(
                  OuroColors.glassBorder,
                  col.withValues(alpha: 0.5),
                  v,
                )!,
                width: 1,
              ),
              boxShadow: v > 0.5
                  ? DesignTokens.glow(col, radius: 10 * v)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 13,
                    color: Color.lerp(OuroColors.textSecondary, col, v),
                  ),
                  const SizedBox(width: 5),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    color: Color.lerp(OuroColors.textSecondary, col, v),
                    fontSize: 12,
                    fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.1,
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
//  CHIP SCROLL ROW  (Horizontal scrolling category bar)
// ─────────────────────────────────────────────────────────────
class OuroChipRow extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;
  final List<IconData>? icons;
  final List<Color>? colors;
  final EdgeInsetsGeometry padding;

  const OuroChipRow({
    super.key,
    required this.labels,
    this.selectedIndex = 0,
    this.onSelected,
    this.icons,
    this.colors,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: List.generate(labels.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: OuroFilterChip(
              label: labels[i],
              selected: selectedIndex == i,
              icon: icons != null && i < icons!.length ? icons![i] : null,
              color: colors != null && i < colors!.length
                  ? colors![i]
                  : OuroColors.meshBlue,
              onSelected: (_) => onSelected?.call(i),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  TAG CHIP  (Read-only info tag)
// ─────────────────────────────────────────────────────────────
class OuroTagChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;

  const OuroTagChip({super.key, required this.label, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    final col = color ?? OuroColors.meshBlue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: col.withValues(alpha: 0.1),
        border: Border.all(color: col.withValues(alpha: 0.25), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: col),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: col,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
