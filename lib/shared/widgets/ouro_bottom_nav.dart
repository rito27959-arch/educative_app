import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';

class OuroBottomNav extends StatefulWidget {
  final String currentRoute;
  const OuroBottomNav({super.key, required this.currentRoute});

  @override
  State<OuroBottomNav> createState() => _OuroBottomNavState();
}

class _OuroBottomNavState extends State<OuroBottomNav>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<AnimationController> _iconCtrl;

  static const _routes = ['/dashboard', '/courses', '/forum', '/gamification', '/profile'];
  static const _icons  = [
    Icons.home_rounded,
    Icons.school_rounded,
    Icons.forum_rounded,
    Icons.workspace_premium_rounded,
    Icons.person_rounded,
  ];
  static const _labels = ['Home', 'Cours', 'Forum', 'Progrès', 'Profil'];
  static const _colors = [
    OuroColors.meshBlue,
    OuroColors.ouroOrange,
    OuroColors.accentPurple,
    OuroColors.accentTeal,
    OuroColors.accentPink,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = _routes.indexOf(widget.currentRoute).clamp(0, _routes.length - 1);
    _iconCtrl = List.generate(
      _routes.length,
      (_) => AnimationController(vsync: this, duration: 300.ms),
    );
    // Animate initial selection
    _iconCtrl[_selectedIndex].forward();
  }

  @override
  void dispose() {
    for (final c in _iconCtrl) c.dispose();
    super.dispose();
  }

  void _select(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.selectionClick();
    _iconCtrl[_selectedIndex].reverse();
    setState(() => _selectedIndex = index);
    _iconCtrl[index].forward(from: 0);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: OuroColors.glassBorder, width: 0.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 32, offset: const Offset(0, 8)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: OuroColors.surface.withValues(alpha: 0.85),
              ),
              child: Row(
                children: List.generate(_routes.length, (i) => _NavItem(
                  icon: _icons[i],
                  label: _labels[i],
                  color: _colors[i],
                  isSelected: _selectedIndex == i,
                  controller: _iconCtrl[i],
                  onTap: () => _select(i),
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final AnimationController controller;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final v = CurvedAnimation(parent: controller, curve: DesignTokens.curveSpring).value;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon container — morphs from circle to pill
                AnimatedContainer(
                  duration: 300.ms,
                  curve: DesignTokens.curveSpring,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected ? DesignTokens.glow(color, radius: 10) : null,
                  ),
                  child: Transform.scale(
                    scale: 1.0 + v * 0.15,
                    child: Icon(
                      icon,
                      color: Color.lerp(OuroColors.textSecondary, color, v),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                // Label — fades in when selected
                AnimatedDefaultTextStyle(
                  duration: 200.ms,
                  style: TextStyle(
                    color: isSelected ? color : Colors.transparent,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                  child: Text(label.toUpperCase()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
