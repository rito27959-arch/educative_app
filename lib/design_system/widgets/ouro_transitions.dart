import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../design_tokens.dart';
import '../ouro_colors.dart';

// ─────────────────────────────────────────────────────────────
//  PAGE ROUTE  (Shared element feel — Netflix tap-to-open)
// ─────────────────────────────────────────────────────────────
class OuroPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final OuroTransitionType type;

  OuroPageRoute({
    required this.page,
    this.type = OuroTransitionType.slideUp,
    super.settings,
  }) : super(
          pageBuilder: (ctx, anim, _) => page,
          transitionDuration: DesignTokens.durationSlow,
          reverseTransitionDuration: DesignTokens.durationNormal,
          transitionsBuilder: (ctx, anim, secondary, child) =>
              _buildTransition(type, anim, secondary, child),
        );

  static Widget _buildTransition(
    OuroTransitionType type,
    Animation<double> anim,
    Animation<double> secondary,
    Widget child,
  ) {
    switch (type) {
      case OuroTransitionType.slideUp:
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: DesignTokens.curveSpring)),
          child: FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: const Interval(0, 0.4)),
            ),
            child: child,
          ),
        );

      case OuroTransitionType.slideRight:
        return SlideTransition(
          position: Tween(
            begin: const Offset(1.0, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: DesignTokens.curveEmphasis)),
          child: child,
        );

      case OuroTransitionType.zoom:
        return ScaleTransition(
          scale: Tween(begin: 0.92, end: 1.0).animate(
            CurvedAnimation(parent: anim, curve: DesignTokens.curveSpring),
          ),
          child: FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: const Interval(0, 0.5)),
            ),
            child: child,
          ),
        );

      case OuroTransitionType.fade:
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
          child: child,
        );
    }
  }
}

enum OuroTransitionType { slideUp, slideRight, zoom, fade }

// ─────────────────────────────────────────────────────────────
//  ANIMATED SWITCHER WRAPPERS
// ─────────────────────────────────────────────────────────────
class OuroFadeSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const OuroFadeSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: child,
      ),
      child: child,
    );
  }
}

class OuroSlideSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Axis axis;

  const OuroSlideSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 320),
    this.axis = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: DesignTokens.curveSpring,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) {
        final offset = axis == Axis.vertical
            ? const Offset(0, 0.1)
            : const Offset(0.1, 0);
        return SlideTransition(
          position: Tween(begin: offset, end: Offset.zero).animate(anim),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ANIMATED SIZE WRAPPER  (Smooth expand/collapse)
// ─────────────────────────────────────────────────────────────
class OuroExpandable extends StatelessWidget {
  final Widget child;
  final bool expanded;
  final Duration duration;

  const OuroExpandable({
    super.key,
    required this.child,
    required this.expanded,
    this.duration = const Duration(milliseconds: 320),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: duration,
      curve: DesignTokens.curveSpring,
      child: expanded ? child : const SizedBox(width: double.infinity, height: 0),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  PARALLAX SCROLL EFFECT
// ─────────────────────────────────────────────────────────────
class OuroParallaxImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final ScrollController scrollController;
  final double parallaxFactor;

  const OuroParallaxImage({
    super.key,
    required this.imageUrl,
    this.height = 200,
    required this.scrollController,
    this.parallaxFactor = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: scrollController,
          builder: (ctx, child) {
            double offset = 0;
            try { offset = scrollController.offset * parallaxFactor; }
            catch (e) { debugPrint('[Transitions] $e'); }
            return Transform.translate(
              offset: Offset(0, -offset),
              child: SizedBox(
                height: height * (1 + parallaxFactor),
                child: child,
              ),
            );
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SCROLL TO TOP  (YouTube-style floating button on scroll)
// ─────────────────────────────────────────────────────────────
class OuroScrollToTop extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;
  final double threshold;

  const OuroScrollToTop({
    super.key,
    required this.scrollController,
    required this.child,
    this.threshold = 400,
  });

  @override
  State<OuroScrollToTop> createState() => _OuroScrollToTopState();
}

class _OuroScrollToTopState extends State<OuroScrollToTop>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: DesignTokens.durationNormal);
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final show = widget.scrollController.offset > widget.threshold;
    if (show != _visible) {
      setState(() => _visible = show);
      show ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          right: 16,
          bottom: 100,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (ctx, child) {
              final v = CurvedAnimation(parent: _ctrl, curve: DesignTokens.curveSpring).value;
              return Transform.scale(
                scale: v,
                child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
              );
            },
            child: GestureDetector(
              onTap: () => widget.scrollController.animateTo(
                0,
                duration: DesignTokens.durationSlow,
                curve: DesignTokens.curveEmphasis,
              ),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: OuroColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: OuroColors.glassBorderStrong, width: 0.5),
                  boxShadow: DesignTokens.cardShadowStrong,
                ),
                child: const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: OuroColors.textSecondary,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
