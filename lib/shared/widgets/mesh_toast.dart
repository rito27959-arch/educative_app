import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Types de toast ──────────────────────────────────────────────────────────

enum ToastType { success, error, warning, info }

// ── Modèle ──────────────────────────────────────────────────────────────────

class MeshToast {
  final String id;
  final String message;
  final ToastType type;
  MeshToast({
    required this.id,
    required this.message,
    required this.type,
  });
}

// ── Provider ────────────────────────────────────────────────────────────────

final toastProvider = StateNotifierProvider<ToastNotifier, List<MeshToast>>((ref) {
  return ToastNotifier();
});

// ── Notifier ────────────────────────────────────────────────────────────────

class ToastNotifier extends StateNotifier<List<MeshToast>> {
  ToastNotifier() : super([]);

  void show(String message, {ToastType type = ToastType.info, Duration? duration}) {
    final id = _generateId();
    state = [...state, MeshToast(id: id, message: message, type: type)];
    final d = duration ?? _defaultDuration(type);
    Timer(d, () => dismiss(id));
  }

  void dismiss(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  String _generateId() => DateTime.now().microsecondsSinceEpoch.toRadixString(16) + Random().nextInt(9999).toString();

  Duration _defaultDuration(ToastType type) {
    switch (type) {
      case ToastType.error:
        return const Duration(seconds: 5);
      case ToastType.warning:
        return const Duration(seconds: 4);
      case ToastType.success:
        return const Duration(seconds: 3);
      case ToastType.info:
        return const Duration(seconds: 3);
    }
  }
}

// ── Widget hôte ─────────────────────────────────────────────────────────────

class ToastHost extends ConsumerWidget {
  const ToastHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toasts = ref.watch(toastProvider);
    if (toasts.isEmpty) return const SizedBox.shrink();

    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: toasts.map((t) => _ToastBar(
          key: ValueKey(t.id),
          toast: t,
          onDismiss: (id) => ref.read(toastProvider.notifier).dismiss(id),
        )).toList(),
      ),
    );
  }
}

class _ToastBar extends StatefulWidget {
  final MeshToast toast;
  final void Function(String) onDismiss;
  const _ToastBar({super.key, required this.toast, required this.onDismiss});

  @override
  State<_ToastBar> createState() => _ToastBarState();
}

class _ToastBarState extends State<_ToastBar> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _slide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _fade = Tween<double>(begin: 0, end: 1).animate(_ctrl);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toast = widget.toast;
    final (Color bg, IconData icon) = switch (toast.type) {
      ToastType.success => (const Color(0xFF00E676), Icons.check_circle),
      ToastType.error => (const Color(0xFFFF3B30), Icons.error),
      ToastType.warning => (const Color(0xFFFF6B2B), Icons.warning_amber),
      ToastType.info => (const Color(0xFF2563FF), Icons.info),
    };

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bg.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: bg.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Icon(icon, color: bg, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(toast.message,
                      style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 13, height: 1.3),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onDismiss(toast.id),
                    child: const Icon(Icons.close, color: Color(0xFF8888A0), size: 18),
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
