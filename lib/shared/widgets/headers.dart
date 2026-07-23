import 'dart:ui';
import 'package:flutter/material.dart';
import '../../design_system/ouro_colors.dart';

// ─────────────────────────────────────────────────────────────
//  APP HEADER  (Floating glass — Netflix / YouTube)
// ─────────────────────────────────────────────────────────────
class OuroHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool blur;
  final Widget? subtitle;

  const OuroHeader({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.blur = true,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final header = Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 8,
        16,
        12,
      ),
      decoration: blur
          ? null
          : const BoxDecoration(color: OuroColors.background),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: OuroColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  subtitle!,
                ],
              ],
            ),
          ),
          if (actions != null)
            Row(mainAxisSize: MainAxisSize.min, children: actions!),
        ],
      ),
    );

    if (!blur) return header;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: OuroColors.background.withValues(alpha: 0.8),
            border: const Border(
              bottom: BorderSide(color: OuroColors.glassBorder, width: 0.5),
            ),
          ),
          child: header,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SECTION HEADER  (Labeled divider with action)
// ─────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: OuroColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: const TextStyle(
                  color: OuroColors.meshBlueBright,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
