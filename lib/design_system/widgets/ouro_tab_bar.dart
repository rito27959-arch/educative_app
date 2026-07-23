import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  SEGMENTED TAB BAR  (TikTok / YouTube top tabs)
// ─────────────────────────────────────────────────────────────
class OuroTabBar extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;
  final List<Color>? colors;
  final bool glassBackground;
  final EdgeInsetsGeometry? padding;

  const OuroTabBar({
    super.key,
    required this.tabs,
    this.selectedIndex = 0,
    this.onChanged,
    this.colors,
    this.glassBackground = true,
    this.padding,
  });

  @override
  State<OuroTabBar> createState() => _OuroTabBarState();
}

class _OuroTabBarState extends State<OuroTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideCtrl;
  int _prev = 0;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
        vsync: this, duration: DesignTokens.durationNormal, value: 1.0);
    _prev = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(OuroTabBar old) {
    super.didUpdateWidget(old);
    if (old.selectedIndex != widget.selectedIndex) {
      _prev = old.selectedIndex;
      _slideCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() { _slideCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      height: 42,
      decoration: BoxDecoration(
        color: widget.glassBackground
            ? OuroColors.glassBg
            : OuroColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OuroColors.glassBorder, width: 0.5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / widget.tabs.length;
          final col = widget.colors != null && widget.selectedIndex < widget.colors!.length
              ? widget.colors![widget.selectedIndex]
              : OuroColors.meshBlue;

          return Stack(
            children: [
              // Sliding pill indicator
              AnimatedBuilder(
                animation: _slideCtrl,
                builder: (ctx, _) {
                  final v = CurvedAnimation(
                      parent: _slideCtrl, curve: DesignTokens.curveSpring).value;
                  final fromX = _prev * tabWidth;
                  final toX   = widget.selectedIndex * tabWidth;
                  final x     = fromX + (toX - fromX) * v;

                  return Positioned(
                    left: x + 3,
                    top: 3,
                    width: tabWidth - 6,
                    height: 36,
                    child: Container(
                      decoration: BoxDecoration(
                        color: col.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: col.withValues(alpha: 0.35), width: 0.5),
                        boxShadow: DesignTokens.glow(col, radius: 8),
                      ),
                    ),
                  );
                },
              ),
              // Tab labels
              Row(
                children: widget.tabs.asMap().entries.map((e) {
                  final i = e.key;
                  final isSelected = i == widget.selectedIndex;
                  final tabColor = widget.colors != null && i < widget.colors!.length
                      ? widget.colors![i]
                      : OuroColors.meshBlue;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        widget.onChanged?.call(i);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedDefaultTextStyle(
                        duration: DesignTokens.durationFast,
                        style: TextStyle(
                          color: isSelected ? tabColor : OuroColors.textSecondary,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          letterSpacing: isSelected ? 0.1 : 0,
                        ),
                        child: Center(child: Text(e.value)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  UNDERLINE TAB BAR  (YouTube / Twitter top tabs)
// ─────────────────────────────────────────────────────────────
class OuroUnderlineTabBar extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;
  final Color? activeColor;

  const OuroUnderlineTabBar({
    super.key,
    required this.tabs,
    this.selectedIndex = 0,
    this.onChanged,
    this.activeColor,
  });

  @override
  State<OuroUnderlineTabBar> createState() => _OuroUnderlineTabBarState();
}

class _OuroUnderlineTabBarState extends State<OuroUnderlineTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _prev = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: DesignTokens.durationNormal, value: 1.0);
    _prev = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(OuroUnderlineTabBar old) {
    super.didUpdateWidget(old);
    if (old.selectedIndex != widget.selectedIndex) {
      _prev = old.selectedIndex;
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final col = widget.activeColor ?? OuroColors.meshBlue;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = constraints.maxWidth / widget.tabs.length;

        return SizedBox(
          height: 44,
          child: Stack(
            children: [
              // Bottom border full width
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(height: 0.5, color: OuroColors.glassBorder),
              ),
              // Animated underline
              AnimatedBuilder(
                animation: _ctrl,
                builder: (ctx, _) {
                  final v = CurvedAnimation(
                      parent: _ctrl, curve: DesignTokens.curveSpring).value;
                  final fromX = _prev * tabWidth;
                  final toX   = widget.selectedIndex * tabWidth;
                  final x     = fromX + (toX - fromX) * v;

                  return Positioned(
                    bottom: 0,
                    left: x + tabWidth * 0.2,
                    width: tabWidth * 0.6,
                    height: 2.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: col,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: DesignTokens.glow(col, radius: 6),
                      ),
                    ),
                  );
                },
              ),
              // Labels
              Row(
                children: widget.tabs.asMap().entries.map((e) {
                  final isSelected = e.key == widget.selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        widget.onChanged?.call(e.key);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedDefaultTextStyle(
                        duration: DesignTokens.durationFast,
                        style: TextStyle(
                          color: isSelected ? col : OuroColors.textSecondary,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        child: Center(child: Text(e.value)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
