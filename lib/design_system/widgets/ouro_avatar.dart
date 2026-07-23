import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  AVATAR  (Profile picture with online ring & fallback)
// ─────────────────────────────────────────────────────────────
class OuroAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final bool isOnline;
  final bool showOnlineIndicator;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final bool showGlow;

  const OuroAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 44,
    this.isOnline = false,
    this.showOnlineIndicator = false,
    this.borderColor,
    this.borderWidth = 0,
    this.onTap,
    this.showGlow = false,
  });

  String get _initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  Color get _fallbackColor {
    if (name == null) return OuroColors.meshBlue;
    final colors = [
      OuroColors.meshBlue,
      OuroColors.ouroOrange,
      OuroColors.accentPurple,
      OuroColors.accentTeal,
      OuroColors.accentPink,
    ];
    final index = name!.codeUnits.fold(0, (sum, c) => sum + c) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final col = borderColor ?? _fallbackColor;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: borderWidth > 0
                  ? Border.all(color: col, width: borderWidth)
                  : null,
              boxShadow: showGlow
                  ? DesignTokens.glow(col, radius: size * 0.3)
                  : null,
            ),
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallbackWidget(),
                    )
                  : _fallbackWidget(),
            ),
          ),
          // Online dot
          if (showOnlineIndicator)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size * 0.26,
                height: size * 0.26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline ? OuroColors.localGreen : OuroColors.textTertiary,
                  border: Border.all(
                    color: OuroColors.background,
                    width: size * 0.04,
                  ),
                  boxShadow: isOnline
                      ? DesignTokens.glow(OuroColors.localGreen, radius: 4)
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _fallbackWidget() {
    final col = _fallbackColor;
    return Container(
      color: col.withValues(alpha: 0.15),
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            color: col,
            fontSize: size * 0.36,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  AVATAR STACK  (Group of overlapping avatars — TikTok duets)
// ─────────────────────────────────────────────────────────────
class OuroAvatarStack extends StatelessWidget {
  final List<String?> imageUrls;
  final List<String?> names;
  final double size;
  final int maxVisible;
  final int? totalCount;

  const OuroAvatarStack({
    super.key,
    required this.imageUrls,
    this.names = const [],
    this.size = 36,
    this.maxVisible = 3,
    this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final visible = imageUrls.take(maxVisible).toList();
    final remaining = (totalCount ?? imageUrls.length) - visible.length;
    final width = size + (visible.length - 1) * size * 0.55 + (remaining > 0 ? size * 0.55 : 0);

    return SizedBox(
      width: width,
      height: size,
      child: Stack(
        children: [
          ...visible.asMap().entries.map((e) => Positioned(
            left: e.key * size * 0.55,
            child: OuroAvatar(
              imageUrl: e.value,
              name: names.length > e.key ? names[e.key] : null,
              size: size,
              borderColor: OuroColors.background,
              borderWidth: 2,
            ).animate()
              .fadeIn(duration: 300.ms, delay: Duration(milliseconds: e.key * 60))
              .slideX(begin: -0.3, end: 0, duration: 300.ms,
                  delay: Duration(milliseconds: e.key * 60),
                  curve: DesignTokens.curveSpring),
          )),
          if (remaining > 0)
            Positioned(
              left: visible.length * size * 0.55,
              child: Container(
                width: size, height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: OuroColors.glassBgStrong,
                  border: Border.all(color: OuroColors.background, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: TextStyle(
                      color: OuroColors.textSecondary,
                      fontSize: size * 0.28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  STORY RING  (Instagram / TikTok story indicator)
// ─────────────────────────────────────────────────────────────
class OuroStoryRing extends StatefulWidget {
  final Widget child;
  final bool hasUnseenStory;
  final bool isLive;
  final VoidCallback? onTap;
  final double size;

  const OuroStoryRing({
    super.key,
    required this.child,
    this.hasUnseenStory = false,
    this.isLive = false,
    this.onTap,
    this.size = 64,
  });

  @override
  State<OuroStoryRing> createState() => _OuroStoryRingState();
}

class _OuroStoryRingState extends State<OuroStoryRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 2.seconds);
    if (widget.isLive) _ctrl.repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.hasUnseenStory || widget.isLive)
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: widget.isLive
                      ? OuroColors.energyGradient
                      : OuroColors.brandGradient,
                ),
              ),
            if (widget.isLive)
              AnimatedBuilder(
                animation: _ctrl,
                builder: (ctx, _) {
                  final v = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut).value;
                  return Container(
                    width: widget.size * (1 + v * 0.15),
                    height: widget.size * (1 + v * 0.15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: OuroColors.ouroOrange.withValues(alpha: (1 - v) * 0.6),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
            Container(
              width: widget.size - (widget.hasUnseenStory || widget.isLive ? 4 : 0),
              height: widget.size - (widget.hasUnseenStory || widget.isLive ? 4 : 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: OuroColors.background, width: 2),
              ),
              child: ClipOval(child: widget.child),
            ),
            if (widget.isLive)
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: OuroColors.energyGradient,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: OuroColors.background, width: 1.5),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
