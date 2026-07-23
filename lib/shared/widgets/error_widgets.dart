import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/widgets/ouro_buttons.dart';

// ─────────────────────────────────────────────────────────────
//  INLINE ERROR BANNER
// ─────────────────────────────────────────────────────────────
class OuroErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const OuroErrorBanner({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: OuroColors.errorRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OuroColors.errorRed.withValues(alpha: 0.25), width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_rounded, color: OuroColors.errorRed, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: OuroColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onRetry,
              child: const Text(
                'Réessayer',
                style: TextStyle(
                  color: OuroColors.errorRed,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 250.ms)
        .slideY(begin: -0.2, end: 0, duration: 250.ms, curve: DesignTokens.curveSpring);
  }
}

// ─────────────────────────────────────────────────────────────
//  FULL-PAGE ERROR  (Retry CTA)
// ─────────────────────────────────────────────────────────────
class OuroErrorPage extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const OuroErrorPage({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: OuroColors.errorRed.withValues(alpha: 0.1),
                border: Border.all(
                  color: OuroColors.errorRed.withValues(alpha: 0.3), width: 1),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: OuroColors.errorRed,
                size: 32,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  duration: 500.ms,
                  curve: DesignTokens.curveBounce,
                ),
            const SizedBox(height: 20),
            const Text(
              'Oups, une erreur',
              style: TextStyle(
                color: OuroColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            const SizedBox(height: 8),
            Text(
              message ?? 'Impossible de charger les données.',
              style: const TextStyle(
                color: OuroColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            if (onRetry != null) ...[
              const SizedBox(height: 28),
              OuroButton(
                label: 'Réessayer',
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
                variant: OuroButtonVariant.secondary,
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
            ],
          ],
        ),
      ),
    );
  }
}
