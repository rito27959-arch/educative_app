import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/widgets/ouro_buttons.dart';

// ─────────────────────────────────────────────────────────────
//  EMPTY STATE  (Animated icon + CTA — Duolingo style)
// ─────────────────────────────────────────────────────────────
class OuroEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? color;

  const OuroEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final col = color ?? OuroColors.meshBlue;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with pulsing glow ring
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: col.withValues(alpha: 0.06),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2000.ms)
                    .fadeIn(duration: 600.ms),
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: col.withValues(alpha: 0.1),
                    border: Border.all(color: col.withValues(alpha: 0.2), width: 1),
                  ),
                  child: Icon(icon, color: col, size: 32),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      duration: 500.ms,
                      curve: DesignTokens.curveBounce,
                    )
                    .fadeIn(duration: 300.ms),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                color: OuroColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms)
                .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 200.ms,
                    curve: DesignTokens.curveSpring),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: OuroColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms),
            if (actionLabel != null) ...[
              const SizedBox(height: 28),
              OuroButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: OuroButtonVariant.primary,
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 400.ms)
                  .slideY(begin: 0.3, end: 0, duration: 400.ms, delay: 400.ms,
                      curve: DesignTokens.curveSpring),
            ],
          ],
        ),
      ),
    );
  }
}
