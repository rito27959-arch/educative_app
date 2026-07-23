import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  FADE + SLIDE IN  (Duolingo-style stagger)
// ─────────────────────────────────────────────────────────────
class OuroFadeIn extends StatelessWidget {
  final Widget child;
  final int delay;
  final Duration duration;
  final Offset slideFrom;

  const OuroFadeIn({
    super.key,
    required this.child,
    this.delay = 0,
    this.duration = const Duration(milliseconds: 320),
    this.slideFrom = const Offset(0, 18),
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(duration: duration, delay: Duration(milliseconds: delay), curve: Curves.easeOut)
        .slideY(
          begin: slideFrom.dy / 100,
          end: 0,
          duration: duration,
          delay: Duration(milliseconds: delay),
          curve: DesignTokens.curveSpring,
        );
  }
}

// ─────────────────────────────────────────────────────────────
//  SEQUENTIAL STAGGER  (Netflix card rows)
// ─────────────────────────────────────────────────────────────
class OuroSequentialFadeIn extends StatelessWidget {
  final List<Widget> children;
  final int baseDelay;
  final int staggerDelay;
  final Axis axis;

  const OuroSequentialFadeIn({
    super.key,
    required this.children,
    this.baseDelay = 80,
    this.staggerDelay = 60,
    this.axis = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final items = children.asMap().entries.map((entry) {
      return OuroFadeIn(
        delay: baseDelay + entry.key * staggerDelay,
        child: entry.value,
      );
    }).toList();

    return axis == Axis.vertical
        ? Column(children: items)
        : Row(children: items);
  }
}

// ─────────────────────────────────────────────────────────────
//  SCALE IN  (spring bounce — Duolingo XP pop)
// ─────────────────────────────────────────────────────────────
class OuroScaleIn extends StatelessWidget {
  final Widget child;
  final int delay;
  final double beginScale;

  const OuroScaleIn({
    super.key,
    required this.child,
    this.delay = 0,
    this.beginScale = 0.72,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .scale(
          duration: DesignTokens.durationSlow,
          delay: Duration(milliseconds: delay),
          begin: Offset(beginScale, beginScale),
          end: const Offset(1, 1),
          curve: DesignTokens.curveBounce,
        )
        .fadeIn(
          duration: DesignTokens.durationNormal,
          delay: Duration(milliseconds: delay),
        );
  }
}

// ─────────────────────────────────────────────────────────────
//  POP IN  (celebration — like TikTok likes / Duolingo streak)
// ─────────────────────────────────────────────────────────────
class OuroPopIn extends StatelessWidget {
  final Widget child;
  final int delay;

  const OuroPopIn({super.key, required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .scale(
          duration: DesignTokens.durationNormal,
          delay: Duration(milliseconds: delay),
          begin: const Offset(0, 0),
          end: const Offset(1.12, 1.12),
          curve: Curves.easeOut,
        )
        .then()
        .scale(
          duration: DesignTokens.durationFast,
          begin: const Offset(1.12, 1.12),
          end: const Offset(1, 1),
          curve: Curves.easeIn,
        )
        .fadeIn(
          duration: DesignTokens.durationFast,
          delay: Duration(milliseconds: delay),
        );
  }
}

// ─────────────────────────────────────────────────────────────
//  SHIMMER LOADER  (Content-aware, like Instagram/TikTok)
// ─────────────────────────────────────────────────────────────
class OuroShimmerLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const OuroShimmerLoader({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
  });

  @override
  State<OuroShimmerLoader> createState() => _OuroShimmerLoaderState();
}

class _OuroShimmerLoaderState extends State<OuroShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: DesignTokens.durationBeat)..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final shimmerPos = _anim.value * 1.4 - 0.2;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (shimmerPos - 0.3).clamp(0.0, 1.0),
                shimmerPos.clamp(0.0, 1.0),
                (shimmerPos + 0.3).clamp(0.0, 1.0),
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
}

// ─────────────────────────────────────────────────────────────
//  HOVER/PRESS SCALE  (Tactile — iOS/TikTok button feel)
// ─────────────────────────────────────────────────────────────
class OuroHoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  final VoidCallback? onTap;
  final bool haptic;
  final Duration duration;

  const OuroHoverScale({
    super.key,
    required this.child,
    this.scale = 0.94,
    this.onTap,
    this.haptic = true,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<OuroHoverScale> createState() => _OuroHoverScaleState();
}

class _OuroHoverScaleState extends State<OuroHoverScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _down(_) {
    if (widget.haptic) HapticFeedback.lightImpact();
    _ctrl.forward();
  }
  void _up(_) => _ctrl.reverse();
  void _cancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: _cancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) => Transform.scale(scale: _anim.value, child: child),
        child: widget.child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  PULSE  (live dot, streaming indicator — like YouTube live)
// ─────────────────────────────────────────────────────────────
class OuroPulse extends StatefulWidget {
  final Widget child;
  final Color color;
  final double maxRadius;

  const OuroPulse({
    super.key,
    required this.child,
    this.color = OuroColors.localGreen,
    this.maxRadius = 12,
  });

  @override
  State<OuroPulse> createState() => _OuroPulseState();
}

class _OuroPulseState extends State<OuroPulse> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 1800.ms)..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final v = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut).value;
            return Container(
              width: widget.maxRadius * 2 * v,
              height: widget.maxRadius * 2 * v,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withValues(alpha: (1 - v) * 0.4),
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  CONFETTI BURST  (Achievement — Duolingo level up)
// ─────────────────────────────────────────────────────────────
class OuroConfettiBurst extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final List<Color> colors;

  const OuroConfettiBurst({
    super.key,
    required this.child,
    required this.trigger,
    this.colors = const [
      OuroColors.meshBlue,
      OuroColors.ouroOrange,
      OuroColors.accentPurple,
      OuroColors.localGreen,
      OuroColors.accentPink,
    ],
  });

  @override
  State<OuroConfettiBurst> createState() => _OuroConfettiBurstState();
}

class _OuroConfettiBurstState extends State<OuroConfettiBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<_Particle> _particles;
  final _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 900.ms);
    _particles = List.generate(18, (_) => _Particle(
      color: widget.colors[_rng.nextInt(widget.colors.length)],
      angle: _rng.nextDouble() * math.pi * 2,
      speed: 60 + _rng.nextDouble() * 80,
      size: 4 + _rng.nextDouble() * 5,
    ));
  }

  @override
  void didUpdateWidget(OuroConfettiBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      HapticFeedback.mediumImpact();
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final v = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut).value;
            return Stack(
              alignment: Alignment.center,
              children: _particles.map((p) {
                final dx = math.cos(p.angle) * p.speed * v;
                final dy = math.sin(p.angle) * p.speed * v - 30 * v * v;
                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: Opacity(
                    opacity: (1 - v).clamp(0, 1),
                    child: Container(
                      width: p.size,
                      height: p.size,
                      decoration: BoxDecoration(
                        color: p.color,
                        borderRadius: BorderRadius.circular(p.size * 0.3),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _Particle {
  final Color color;
  final double angle;
  final double speed;
  final double size;
  _Particle({required this.color, required this.angle, required this.speed, required this.size});
}

// ─────────────────────────────────────────────────────────────
//  COUNT UP ANIMATION  (Stats — like Duolingo XP counter)
// ─────────────────────────────────────────────────────────────
class OuroCountUp extends StatelessWidget {
  final int value;
  final Duration duration;
  final TextStyle? style;
  final String suffix;

  const OuroCountUp({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 800),
    this.style,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: DesignTokens.curveEmphasis,
      builder: (context, v, _) {
        return Text('$v$suffix', style: style);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SKELETON SCREEN  (Full-page placeholder — Instagram/TikTok)
// ─────────────────────────────────────────────────────────────
class OuroSkeletonBlock extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const OuroSkeletonBlock({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return OuroShimmerLoader(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SLIDE TRANSITION  (Screen-level — like TikTok navigation)
// ─────────────────────────────────────────────────────────────
class OuroSlideTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final AxisDirection direction;

  const OuroSlideTransition({
    super.key,
    required this.child,
    required this.animation,
    this.direction = AxisDirection.up,
  });

  @override
  Widget build(BuildContext context) {
    Offset begin;
    switch (direction) {
      case AxisDirection.up:    begin = const Offset(0, 1);  break;
      case AxisDirection.down:  begin = const Offset(0, -1); break;
      case AxisDirection.left:  begin = const Offset(1, 0);  break;
      case AxisDirection.right: begin = const Offset(-1, 0); break;
    }

    return SlideTransition(
      position: Tween(begin: begin, end: Offset.zero).animate(
        CurvedAnimation(parent: animation, curve: DesignTokens.curveSpring),
      ),
      child: FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: const Interval(0, 0.5)),
        ),
        child: child,
      ),
    );
  }
}
