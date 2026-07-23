import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  MESH LOADER  (Signature rotating mesh — refined)
// ─────────────────────────────────────────────────────────────
class MeshLoader extends StatefulWidget {
  final String? message;
  final double size;
  const MeshLoader({super.key, this.message, this.size = 48});

  @override
  State<MeshLoader> createState() => _MeshLoaderState();
}

class _MeshLoaderState extends State<MeshLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 2.seconds)..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (ctx, _) => CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _MeshLoaderPainter(value: _ctrl.value),
            ),
          ),
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: const TextStyle(
              color: OuroColors.textSecondary,
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
            .fadeIn(duration: 800.ms)
            .then().fadeOut(duration: 800.ms),
        ],
      ],
    );
  }
}

class _MeshLoaderPainter extends CustomPainter {
  final double value;
  _MeshLoaderPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width * 0.38;

    // 3 orbiting nodes connected by lines
    final positions = List.generate(3, (i) {
      final angle = value * math.pi * 2 + i * math.pi * 2 / 3;
      return Offset(cx + r * math.cos(angle), cy + r * math.sin(angle));
    });

    // Draw connections with gradient-like alpha
    for (int i = 0; i < 3; i++) {
      for (int j = i + 1; j < 3; j++) {
        canvas.drawLine(
          positions[i], positions[j],
          Paint()
            ..color = OuroColors.meshBlue.withValues(alpha: 0.35)
            ..strokeWidth = 1.5
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // Center node
    canvas.drawCircle(
      Offset(cx, cy), 4,
      Paint()
        ..color = OuroColors.meshBlue.withValues(alpha: 0.5)
        ..style = PaintingStyle.fill,
    );

    // Outer nodes — pulsing
    for (int i = 0; i < positions.length; i++) {
      final pulse = math.sin(value * math.pi * 4 + i * math.pi * 2 / 3) * 0.3 + 0.7;
      // Glow ring
      canvas.drawCircle(
        positions[i], 7 * pulse,
        Paint()
          ..color = OuroColors.meshBlue.withValues(alpha: 0.15 * pulse)
          ..style = PaintingStyle.fill,
      );
      // Core dot
      canvas.drawCircle(
        positions[i], 4,
        Paint()
          ..color = OuroColors.meshBlueBright
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_MeshLoaderPainter old) => old.value != value;
}

// ─────────────────────────────────────────────────────────────
//  DOTS LOADER  (Staggered bounce — WhatsApp/iMessage style)
// ─────────────────────────────────────────────────────────────
class OuroDotsLoader extends StatefulWidget {
  final Color? color;
  final double dotSize;
  const OuroDotsLoader({super.key, this.color, this.dotSize = 8});

  @override
  State<OuroDotsLoader> createState() => _OuroDotsLoaderState();
}

class _OuroDotsLoaderState extends State<OuroDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 1200.ms)..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final col = widget.color ?? OuroColors.meshBlue;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_ctrl.value - i * 0.2).clamp(0.0, 1.0);
            final dy = math.sin(phase * math.pi) * -8;
            final scale = 0.7 + math.sin(phase * math.pi) * 0.45;
            return Transform.translate(
              offset: Offset(0, dy),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: widget.dotSize * 0.25),
                width:  widget.dotSize * scale,
                height: widget.dotSize * scale,
                decoration: BoxDecoration(
                  color: col.withValues(alpha: 0.5 + scale * 0.5),
                  shape: BoxShape.circle,
                  boxShadow: scale > 0.9 ? DesignTokens.glow(col, radius: 6) : null,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SKELETON CARD  (Content placeholder — Instagram/TikTok)
// ─────────────────────────────────────────────────────────────
class SkeletonCard extends StatefulWidget {
  final double height;
  final double borderRadius;
  const SkeletonCard({super.key, this.height = 120, this.borderRadius = 20});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 1600.ms)..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Widget _block(double w, double h, {double radius = 8}) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, _) {
        final pos = _ctrl.value * 1.4 - 0.2;
        return Container(
          width: w, height: h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (pos - 0.3).clamp(0.0, 1.0),
                pos.clamp(0.0, 1.0),
                (pos + 0.3).clamp(0.0, 1.0),
              ],
              colors: [
                OuroColors.glassBg,
                OuroColors.glassBgStrong,
                OuroColors.glassBg,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OuroColors.cardDark,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: OuroColors.glassBorder, width: 0.5),
      ),
      child: Row(
        children: [
          _block(50, 50, radius: 12),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _block(double.infinity, 14),
                const SizedBox(height: 8),
                _block(160, 11),
                const SizedBox(height: 12),
                _block(double.infinity, 6, radius: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FULL PAGE LOADER  (Center with brand animation)
// ─────────────────────────────────────────────────────────────
class OuroFullPageLoader extends StatelessWidget {
  final String? message;
  const OuroFullPageLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OuroColors.background,
      body: Center(
        child: MeshLoader(
          message: message ?? 'CHARGEMENT',
          size: 56,
        ),
      ),
    );
  }
}
