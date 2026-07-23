import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/widgets/ouro_buttons.dart';

// ─────────────────────────────────────────────────────────────
//  SHOW DIALOG HELPER
// ─────────────────────────────────────────────────────────────
Future<T?> showOuroDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
}) {
  HapticFeedback.mediumImpact();
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: DesignTokens.durationNormal,
    pageBuilder: (ctx, anim, _) => child,
    transitionBuilder: (ctx, anim, _, child) {
      final v = CurvedAnimation(parent: anim, curve: DesignTokens.curveSpring).value;
      return Transform.scale(
        scale: 0.88 + v * 0.12,
        child: Opacity(opacity: anim.value.clamp(0.0, 1.0), child: child),
      );
    },
  );
}

// ─────────────────────────────────────────────────────────────
//  CONFIRM DIALOG  (Destructive + confirm — iOS alert style)
// ─────────────────────────────────────────────────────────────
class OuroConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final bool isDestructive;
  final IconData? icon;

  const OuroConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirmer',
    this.cancelLabel  = 'Annuler',
    this.onConfirm,
    this.isDestructive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: OuroColors.surfaceElevated.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: OuroColors.glassBorderStrong, width: 0.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 40),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (isDestructive ? OuroColors.errorRed : OuroColors.meshBlue)
                            .withValues(alpha: 0.12),
                      ),
                      child: Icon(
                        icon,
                        color: isDestructive ? OuroColors.errorRed : OuroColors.meshBlue,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      color: OuroColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    style: const TextStyle(
                      color: OuroColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OuroButton(
                          label: cancelLabel,
                          onPressed: () => Navigator.of(context).pop(false),
                          variant: OuroButtonVariant.secondary,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OuroButton(
                          label: confirmLabel,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            onConfirm?.call();
                          },
                          variant: isDestructive
                              ? OuroButtonVariant.danger
                              : OuroButtonVariant.primary,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SUCCESS DIALOG  (Duolingo level-up celebration)
// ─────────────────────────────────────────────────────────────
class OuroSuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback? onDone;
  final IconData icon;

  const OuroSuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonLabel = 'Super !',
    this.onDone,
    this.icon = Icons.check_circle_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: OuroColors.surfaceElevated.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: OuroColors.localGreen.withValues(alpha: 0.3), width: 0.5),
                boxShadow: [
                  ...DesignTokens.glow(OuroColors.localGreen, radius: 30),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: OuroColors.successGradient,
                      boxShadow: DesignTokens.glow(OuroColors.localGreen, radius: 20),
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        duration: 500.ms,
                        curve: DesignTokens.curveBounce,
                      ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      color: OuroColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 350.ms, delay: 200.ms)
                      .slideY(begin: 0.2, end: 0, duration: 350.ms, delay: 200.ms,
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
                      .fadeIn(duration: 350.ms, delay: 300.ms),
                  const SizedBox(height: 28),
                  OuroButton(
                    label: buttonLabel,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDone?.call();
                    },
                    variant: OuroButtonVariant.success,
                    width: double.infinity,
                  )
                      .animate()
                      .fadeIn(duration: 350.ms, delay: 400.ms)
                      .slideY(begin: 0.3, end: 0, duration: 350.ms, delay: 400.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
