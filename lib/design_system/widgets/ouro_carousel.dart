import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  CARD CAROUSEL  (Netflix/TikTok horizontal swipeable cards)
// ─────────────────────────────────────────────────────────────
class OuroCarousel extends StatefulWidget {
  final List<Widget> items;
  final double itemWidth;
  final double itemHeight;
  final double viewportFraction;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final bool showDots;
  final EdgeInsetsGeometry? padding;

  const OuroCarousel({
    super.key,
    required this.items,
    this.itemWidth  = 280,
    this.itemHeight = 180,
    this.viewportFraction = 0.88,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.showDots = true,
    this.padding,
  });

  @override
  State<OuroCarousel> createState() => _OuroCarouselState();
}

class _OuroCarouselState extends State<OuroCarousel> {
  late PageController _ctrl;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: widget.viewportFraction);
    if (widget.autoPlay) _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.doWhile(() async {
      await Future.delayed(widget.autoPlayInterval);
      if (!mounted) return false;
      final next = (_currentPage + 1) % widget.items.length;
      _ctrl.animateToPage(
        next,
        duration: DesignTokens.durationSlow,
        curve: DesignTokens.curveEmphasis,
      );
      return true;
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.itemHeight,
          child: PageView.builder(
            controller: _ctrl,
            itemCount: widget.items.length,
            onPageChanged: (p) => setState(() => _currentPage = p),
            itemBuilder: (ctx, i) {
              return AnimatedBuilder(
                animation: _ctrl,
                builder: (ctx, child) {
                  double page = 0;
                  try { page = _ctrl.page ?? i.toDouble(); } catch (_) { page = i.toDouble(); }
                  final diff   = (page - i).abs();
                  final scale  = (1 - diff * 0.06).clamp(0.88, 1.0);
                  final opacity = (1 - diff * 0.35).clamp(0.55, 1.0);

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(opacity: opacity, child: child),
                  );
                },
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 6),
                  child: widget.items[i],
                ),
              );
            },
          ),
        ),
        if (widget.showDots && widget.items.length > 1) ...[
          const SizedBox(height: 12),
          _DotsIndicator(
            count: widget.items.length,
            current: _currentPage,
          ),
        ],
      ],
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _DotsIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: DesignTokens.durationNormal,
          curve: DesignTokens.curveSpring,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: isActive
                ? OuroColors.meshBlue
                : OuroColors.meshBlue.withValues(alpha: 0.25),
            boxShadow: isActive
                ? DesignTokens.glow(OuroColors.meshBlue, radius: 5)
                : null,
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SCROLL LIST (Horizontal tile row — Netflix category row)
// ─────────────────────────────────────────────────────────────
class OuroScrollRow extends StatelessWidget {
  final List<Widget> children;
  final double height;
  final EdgeInsetsGeometry padding;
  final double spacing;

  const OuroScrollRow({
    super.key,
    required this.children,
    this.height = 160,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: children.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing),
        itemBuilder: (ctx, i) => children[i]
            .animate()
            .fadeIn(
              duration: 350.ms,
              delay: Duration(milliseconds: 60 + i * 50),
              curve: Curves.easeOut,
            )
            .slideX(
              begin: 0.08, end: 0,
              duration: 350.ms,
              delay: Duration(milliseconds: 60 + i * 50),
              curve: DesignTokens.curveSpring,
            ),
      ),
    );
  }
}
