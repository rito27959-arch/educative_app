import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import 'dart:ui' as import_ui;

final notificationCountProvider = StateProvider<int>((ref) => 0);
final notificationListProvider  = StateProvider<List<NotificationItem>>((ref) => []);

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    DateTime? createdAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now();

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
    id: id, title: title, body: body, type: type,
    createdAt: createdAt, isRead: isRead ?? this.isRead,
  );
}

// ─────────────────────────────────────────────────────────────
//  NOTIFICATION CARD  (Swipe-to-dismiss, TikTok/iOS style)
// ─────────────────────────────────────────────────────────────
class NotificationCard extends StatefulWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final int index;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
    this.index = 0,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(vsync: this, duration: 100.ms);
  }

  @override
  void dispose() { _pressCtrl.dispose(); super.dispose(); }

  Color get _typeColor {
    switch (widget.notification.type) {
      case 'course':      return OuroColors.meshBlue;
      case 'message':     return OuroColors.accentPurple;
      case 'mesh':        return OuroColors.accentTeal;
      case 'update':      return OuroColors.ouroOrange;
      case 'achievement': return OuroColors.ouroOrange;
      default:            return OuroColors.textSecondary;
    }
  }

  IconData get _typeIcon {
    switch (widget.notification.type) {
      case 'course':      return Icons.menu_book_rounded;
      case 'message':     return Icons.chat_bubble_rounded;
      case 'mesh':        return Icons.wifi_tethering_rounded;
      case 'update':      return Icons.update_rounded;
      case 'achievement': return Icons.emoji_events_rounded;
      default:            return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final col = _typeColor;

    return Dismissible(
      key: Key(widget.notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        widget.onDismiss?.call();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: OuroColors.errorRed.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_rounded, color: OuroColors.errorRed),
      ),
      child: GestureDetector(
        onTapDown: (_) { HapticFeedback.lightImpact(); _pressCtrl.forward(); },
        onTapUp:   (_) => _pressCtrl.reverse(),
        onTapCancel: () => _pressCtrl.reverse(),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _pressCtrl,
          builder: (ctx, child) => Transform.scale(
            scale: Tween(begin: 1.0, end: 0.97).evaluate(_pressCtrl),
            child: child,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: widget.notification.isRead
                  ? OuroColors.cardDark
                  : OuroColors.cardDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.notification.isRead
                    ? OuroColors.glassBorder
                    : col.withValues(alpha: 0.25),
                width: 0.5,
              ),
              boxShadow: widget.notification.isRead
                  ? DesignTokens.cardShadow
                  : [...DesignTokens.cardShadow, ...DesignTokens.glow(col, radius: 10)],
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: col.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: col.withValues(alpha: 0.2), width: 0.5),
                  ),
                  child: Icon(_typeIcon, color: col, size: 18),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.notification.title,
                              style: TextStyle(
                                color: OuroColors.textPrimary,
                                fontSize: 13,
                                fontWeight: widget.notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!widget.notification.isRead)
                            Container(
                              width: 7, height: 7,
                              decoration: BoxDecoration(
                                color: col, shape: BoxShape.circle,
                                boxShadow: DesignTokens.glow(col, radius: 4),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.notification.body,
                        style: const TextStyle(
                          color: OuroColors.textSecondary, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate()
        .fadeIn(duration: 350.ms, delay: Duration(milliseconds: widget.index * 50))
        .slideX(begin: 0.05, end: 0, duration: 350.ms,
            delay: Duration(milliseconds: widget.index * 50),
            curve: DesignTokens.curveSpring);
  }
}

// ─────────────────────────────────────────────────────────────
//  TOAST  (Snackbar-style — Duolingo-style pop)
// ─────────────────────────────────────────────────────────────
class OuroToast extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? color;
  final bool isError;

  const OuroToast({
    super.key,
    required this.message,
    this.icon,
    this.color,
    this.isError = false,
  });

  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    Color? color,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    HapticFeedback.lightImpact();
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _ToastOverlay(
        message: message,
        icon: icon,
        color: color,
        isError: isError,
        onDone: () => entry.remove(),
        duration: duration,
      ),
    );
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final col = isError ? OuroColors.errorRed : (color ?? OuroColors.localGreen);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: _blur(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: OuroColors.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: col.withValues(alpha: 0.3), width: 0.5),
            boxShadow: DesignTokens.glow(col, radius: 16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null || isError) ...[
                Icon(
                  icon ?? (isError ? Icons.error_rounded : Icons.check_circle_rounded),
                  color: col, size: 18,
                ),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: OuroColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic _blur() {
    try {
      import_ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16);
    } catch (_) { return null; }
  }
}



class _ToastOverlay extends StatefulWidget {
  final String message;
  final IconData? icon;
  final Color? color;
  final bool isError;
  final VoidCallback onDone;
  final Duration duration;

  const _ToastOverlay({
    required this.message,
    this.icon,
    this.color,
    required this.isError,
    required this.onDone,
    required this.duration,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 350.ms);
    _ctrl.forward();
    Future.delayed(widget.duration, () {
      if (mounted) _ctrl.reverse().then((_) => widget.onDone());
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 24, right: 24,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, child) {
          final v = CurvedAnimation(parent: _ctrl, curve: DesignTokens.curveSpring).value;
          return Transform.translate(
            offset: Offset(0, -20 * (1 - v)),
            child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: OuroToast(
              message: widget.message,
              icon: widget.icon,
              color: widget.color,
              isError: widget.isError,
            ),
          ),
        ),
      ),
    );
  }
}
