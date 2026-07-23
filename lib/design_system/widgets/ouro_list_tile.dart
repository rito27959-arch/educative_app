import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  LIST TILE  (Settings / profile row — iOS feel)
// ─────────────────────────────────────────────────────────────
class OuroListTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Color? leadingColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final int index;
  final bool dangerous;

  const OuroListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.leadingColor,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.index = 0,
    this.dangerous = false,
  });

  @override
  State<OuroListTile> createState() => _OuroListTileState();
}

class _OuroListTileState extends State<OuroListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 80.ms);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final iconCol = widget.dangerous
        ? OuroColors.errorRed
        : (widget.leadingColor ?? OuroColors.meshBlue);
    final titleCol = widget.dangerous
        ? OuroColors.errorRed
        : OuroColors.textPrimary;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onTap == null) return;
        HapticFeedback.selectionClick();
        setState(() => _pressed = true);
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: 80.ms,
        color: _pressed
            ? OuroColors.glassBg.withValues(alpha: 0.5)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            // Leading icon
            if (widget.leadingIcon != null) ...[
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: iconCol.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: iconCol.withValues(alpha: 0.15), width: 0.5),
                ),
                child: Icon(widget.leadingIcon, color: iconCol, size: 17),
              ),
              const SizedBox(width: 12),
            ],
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: titleCol,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle!,
                      style: const TextStyle(
                        color: OuroColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            // Trailing
            if (widget.trailing != null)
              widget.trailing!
            else if (widget.showChevron && widget.onTap != null)
              const Icon(
                Icons.chevron_right_rounded,
                color: OuroColors.textTertiary,
                size: 18,
              ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(
        duration: 300.ms,
        delay: Duration(milliseconds: widget.index * 40),
        curve: Curves.easeOut,
      )
      .slideX(
        begin: 0.04, end: 0,
        duration: 300.ms,
        delay: Duration(milliseconds: widget.index * 40),
        curve: DesignTokens.curveSpring,
      );
  }
}

// ─────────────────────────────────────────────────────────────
//  LIST GROUP  (Grouped section with glass bg — iOS settings)
// ─────────────────────────────────────────────────────────────
class OuroListGroup extends StatelessWidget {
  final String? header;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;

  const OuroListGroup({
    super.key,
    this.header,
    required this.children,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                header!.toUpperCase(),
                style: const TextStyle(
                  color: OuroColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
          Container(
            decoration: BoxDecoration(
              color: OuroColors.cardDark,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: OuroColors.glassBorder, width: 0.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Column(
                children: children.asMap().entries.map((e) {
                  final isLast = e.key == children.length - 1;
                  return Column(
                    children: [
                      e.value,
                      if (!isLast)
                        const Padding(
                          padding: EdgeInsets.only(left: 64),
                          child: Divider(
                            color: OuroColors.glassBorder,
                            thickness: 0.5,
                            height: 0,
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
