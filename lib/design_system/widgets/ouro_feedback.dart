import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  LIKE BUTTON  (TikTok heart with burst particles)
// ─────────────────────────────────────────────────────────────
class OuroLikeButton extends StatefulWidget {
  final bool liked;
  final int count;
  final ValueChanged<bool>? onChanged;
  final Color? color;

  const OuroLikeButton({
    super.key,
    this.liked = false,
    this.count = 0,
    this.onChanged,
    this.color,
  });

  @override
  State<OuroLikeButton> createState() => _OuroLikeButtonState();
}

class _OuroLikeButtonState extends State<OuroLikeButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late AnimationController _particleCtrl;
  late bool _liked;
  late int  _count;
  final _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _liked = widget.liked;
    _count = widget.count;
    _scaleCtrl    = AnimationController(vsync: this, duration: 300.ms);
    _particleCtrl = AnimationController(vsync: this, duration: 600.ms);
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.mediumImpact();
    setState(() {
      _liked = !_liked;
      _count += _liked ? 1 : -1;
    });
    _scaleCtrl.forward(from: 0).then((_) => _scaleCtrl.reverse());
    if (_liked) _particleCtrl.forward(from: 0);
    widget.onChanged?.call(_liked);
  }

  @override
  Widget build(BuildContext context) {
    final col = widget.color ?? OuroColors.accentPink;

    return GestureDetector(
      onTap: _toggle,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Burst particles
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (ctx, _) {
              final v = CurvedAnimation(
                  parent: _particleCtrl, curve: Curves.easeOut).value;
              return Stack(
                alignment: Alignment.center,
                children: List.generate(8, (i) {
                  final angle = i * math.pi * 2 / 8 + math.pi / 8;
                  final dist  = 24 * v;
                  return Transform.translate(
                    offset: Offset(
                      math.cos(angle) * dist,
                      math.sin(angle) * dist,
                    ),
                    child: Opacity(
                      opacity: (1 - v).clamp(0.0, 1.0),
                      child: Container(
                        width: 4 + _rng.nextDouble() * 3,
                        height: 4 + _rng.nextDouble() * 3,
                        decoration: BoxDecoration(
                          color: col,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          // Heart + count
          AnimatedBuilder(
            animation: _scaleCtrl,
            builder: (ctx, child) {
              final s = 1.0 +
                  math.sin(_scaleCtrl.value * math.pi) * 0.45;
              return Transform.scale(scale: s, child: child);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: _liked ? col : OuroColors.textSecondary,
                  size: 26,
                ),
                if (_count > 0) ...[
                  const SizedBox(height: 2),
                  AnimatedSwitcher(
                    duration: DesignTokens.durationFast,
                    transitionBuilder: (child, anim) => SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(anim),
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: Text(
                      '$_count',
                      key: ValueKey(_count),
                      style: TextStyle(
                        color: _liked ? col : OuroColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  REACTION BAR  (Forum / social — quick emoji reactions)
// ─────────────────────────────────────────────────────────────
class OuroReactionBar extends StatefulWidget {
  final Map<String, int> reactions;
  final Set<String> userReactions;
  final ValueChanged<String>? onReact;

  const OuroReactionBar({
    super.key,
    required this.reactions,
    this.userReactions = const {},
    this.onReact,
  });

  @override
  State<OuroReactionBar> createState() => _OuroReactionBarState();
}

class _OuroReactionBarState extends State<OuroReactionBar> {
  late Map<String, int>  _reactions;
  late Set<String> _myReactions;

  @override
  void initState() {
    super.initState();
    _reactions   = Map.from(widget.reactions);
    _myReactions = Set.from(widget.userReactions);
  }

  void _tap(String emoji) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_myReactions.contains(emoji)) {
        _myReactions.remove(emoji);
        _reactions[emoji] = (_reactions[emoji] ?? 1) - 1;
        if (_reactions[emoji]! <= 0) _reactions.remove(emoji);
      } else {
        _myReactions.add(emoji);
        _reactions[emoji] = (_reactions[emoji] ?? 0) + 1;
      }
    });
    widget.onReact?.call(emoji);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _reactions.entries.map((e) {
        final active = _myReactions.contains(e.key);
        return GestureDetector(
          onTap: () => _tap(e.key),
          child: AnimatedContainer(
            duration: DesignTokens.durationNormal,
            curve: DesignTokens.curveSpring,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: active
                  ? OuroColors.meshBlue.withValues(alpha: 0.15)
                  : OuroColors.glassBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: active
                    ? OuroColors.meshBlue.withValues(alpha: 0.4)
                    : OuroColors.glassBorder,
                width: 0.5,
              ),
              boxShadow: active
                  ? DesignTokens.glow(OuroColors.meshBlue, radius: 6)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.key, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 5),
                AnimatedSwitcher(
                  duration: DesignTokens.durationFast,
                  child: Text(
                    '${e.value}',
                    key: ValueKey(e.value),
                    style: TextStyle(
                      color: active
                          ? OuroColors.meshBlueBright
                          : OuroColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  RATING STARS  (Course rating — animated fill)
// ─────────────────────────────────────────────────────────────
class OuroStarRating extends StatefulWidget {
  final double value;
  final int maxStars;
  final bool interactive;
  final ValueChanged<int>? onRated;
  final double size;
  final Color? color;

  const OuroStarRating({
    super.key,
    this.value = 0,
    this.maxStars = 5,
    this.interactive = false,
    this.onRated,
    this.size = 22,
    this.color,
  });

  @override
  State<OuroStarRating> createState() => _OuroStarRatingState();
}

class _OuroStarRatingState extends State<OuroStarRating> {
  late double _current;

  @override
  void initState() {
    super.initState();
    _current = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final col = widget.color ?? OuroColors.warningAmber;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxStars, (i) {
        final filled  = i < _current.floor();
        final partial = !filled && i < _current;
        final frac    = partial ? _current - _current.floor() : 0.0;

        return GestureDetector(
          onTap: widget.interactive
              ? () {
                  HapticFeedback.selectionClick();
                  setState(() => _current = i + 1.0);
                  widget.onRated?.call(i + 1);
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: (filled || partial
                ? (partial
                    ? ShaderMask(
                        shaderCallback: (b) => LinearGradient(
                          stops: [frac, frac],
                          colors: [col, col.withValues(alpha: 0.2)],
                        ).createShader(b),
                        child: Icon(Icons.star_rounded,
                            color: Colors.white, size: widget.size),
                      )
                    : Icon(Icons.star_rounded, color: col, size: widget.size))
                : Icon(Icons.star_rounded,
                    color: col.withValues(alpha: 0.2), size: widget.size))
                .animate(target: filled ? 1 : 0)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                  duration: 200.ms,
                  curve: DesignTokens.curveSpring,
                ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  VOTE BUTTONS  (Forum up/down — Reddit-style)
// ─────────────────────────────────────────────────────────────
class OuroVoteButtons extends StatefulWidget {
  final int score;
  final int? userVote; // 1, -1, or null
  final ValueChanged<int>? onVote;

  const OuroVoteButtons({
    super.key,
    required this.score,
    this.userVote,
    this.onVote,
  });

  @override
  State<OuroVoteButtons> createState() => _OuroVoteButtonsState();
}

class _OuroVoteButtonsState extends State<OuroVoteButtons> {
  late int  _score;
  late int? _vote;

  @override
  void initState() {
    super.initState();
    _score = widget.score;
    _vote  = widget.userVote;
  }

  void _cast(int dir) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_vote == dir) {
        _score -= dir;
        _vote  = null;
      } else {
        if (_vote != null) _score -= _vote!;
        _score += dir;
        _vote  = dir;
      }
    });
    widget.onVote?.call(dir);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: OuroColors.glassBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: OuroColors.glassBorder, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _VoteArrow(
            direction: 1,
            active: _vote == 1,
            onTap: () => _cast(1),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: DesignTokens.durationFast,
            transitionBuilder: (child, anim) => SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: Text(
              '$_score',
              key: ValueKey(_score),
              style: TextStyle(
                color: _vote == 1
                    ? OuroColors.ouroOrange
                    : _vote == -1
                        ? OuroColors.meshBlue
                        : OuroColors.textSecondary,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _VoteArrow(
            direction: -1,
            active: _vote == -1,
            onTap: () => _cast(-1),
          ),
        ],
      ),
    );
  }
}

class _VoteArrow extends StatefulWidget {
  final int direction;
  final bool active;
  final VoidCallback onTap;
  const _VoteArrow({required this.direction, required this.active, required this.onTap});

  @override
  State<_VoteArrow> createState() => _VoteArrowState();
}

class _VoteArrowState extends State<_VoteArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 80.ms);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final col = widget.direction == 1 ? OuroColors.ouroOrange : OuroColors.meshBlue;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp:   (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, child) => Transform.scale(
          scale: Tween(begin: 1.0, end: 0.75).evaluate(_ctrl),
          child: child,
        ),
        child: Icon(
          widget.direction == 1
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          color: widget.active ? col : OuroColors.textSecondary,
          size: 22,
        ),
      ),
    );
  }
}
