import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';
import '../glassmorphism.dart';

// ─────────────────────────────────────────────────────────────
//  SHOW BOTTOM SHEET HELPER
// ─────────────────────────────────────────────────────────────
Future<T?> showOuroBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool useRootNavigator = true,
  bool showDragHandle = true,
  double? maxHeight,
}) {
  HapticFeedback.mediumImpact();
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: true,
    useRootNavigator: useRootNavigator,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: maxHeight != null ? 0.6 : 0.5,
      minChildSize: 0.3,
      maxChildSize: maxHeight != null ? (maxHeight / MediaQuery.of(ctx).size.height) : 0.92,
      builder: (_, scrollCtrl) => FrostedSheet(
        child: Column(
          children: [
            if (showDragHandle) ...[
              Center(
                child: Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color: OuroColors.glassBorderStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: SingleChildScrollView(
                controller: scrollCtrl,
                child: child,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  ACTION SHEET  (iOS-style action list)
// ─────────────────────────────────────────────────────────────
class OuroActionSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<OuroAction> actions;
  final String cancelLabel;

  const OuroActionSheet({
    super.key,
    this.title,
    this.subtitle,
    required this.actions,
    this.cancelLabel = 'Annuler',
  });

  static Future<void> show({
    required BuildContext context,
    String? title,
    String? subtitle,
    required List<OuroAction> actions,
    String cancelLabel = 'Annuler',
  }) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => OuroActionSheet(
        title: title,
        subtitle: subtitle,
        actions: actions,
        cancelLabel: cancelLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Actions container
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: OuroColors.surfaceElevated.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: OuroColors.glassBorder, width: 0.5),
                ),
                child: Column(
                  children: [
                    // Header
                    if (title != null) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: Column(
                          children: [
                            Text(
                              title!,
                              style: const TextStyle(
                                color: OuroColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                subtitle!,
                                style: const TextStyle(
                                  color: OuroColors.textTertiary, fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Divider(color: OuroColors.glassBorder, thickness: 0.5),
                    ],
                    // Action rows
                    ...actions.asMap().entries.map((entry) {
                      final i = entry.key;
                      final action = entry.value;
                      return Column(
                        children: [
                          _ActionRow(action: action, index: i),
                          if (i < actions.length - 1)
                            const Divider(
                              color: OuroColors.glassBorder,
                              thickness: 0.5,
                              height: 0,
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Cancel button
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: OuroColors.surfaceElevated.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: OuroColors.glassBorder, width: 0.5),
                  ),
                  child: Text(
                    cancelLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: OuroColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _ActionRow extends StatefulWidget {
  final OuroAction action;
  final int index;
  const _ActionRow({required this.action, required this.index});

  @override
  State<_ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<_ActionRow>
    with SingleTickerProviderStateMixin {
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
    final color = widget.action.isDestructive
        ? OuroColors.errorRed
        : (widget.action.color ?? OuroColors.textPrimary);

    return GestureDetector(
      onTapDown: (_) { HapticFeedback.selectionClick(); _ctrl.forward(); },
      onTapUp:   (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: () {
        Navigator.of(context).pop();
        widget.action.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, child) => Transform.scale(
          scale: Tween(begin: 1.0, end: 0.97).evaluate(_ctrl),
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              if (widget.action.icon != null) ...[
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(widget.action.icon, color: color, size: 16),
                ),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.action.label,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (widget.action.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.action.subtitle!,
                        style: const TextStyle(
                          color: OuroColors.textTertiary, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.action.trailing != null) widget.action.trailing!
              else if (!widget.action.isDestructive)
                const Icon(Icons.chevron_right_rounded,
                  color: OuroColors.textTertiary, size: 18),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 250.ms, delay: Duration(milliseconds: widget.index * 40))
      .slideX(
        begin: 0.03, end: 0,
        duration: 250.ms,
        delay: Duration(milliseconds: widget.index * 40),
        curve: DesignTokens.curveSpring,
      );
  }
}

// ─────────────────────────────────────────────────────────────
//  ACTION MODEL
// ─────────────────────────────────────────────────────────────
class OuroAction {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isDestructive;
  final Color? color;
  final Widget? trailing;

  const OuroAction({
    required this.label,
    this.subtitle,
    this.icon,
    this.onTap,
    this.isDestructive = false,
    this.color,
    this.trailing,
  });
}
