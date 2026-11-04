import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/ouro_colors.dart';
import '../kunfox/kunfox_rive.dart';

class StreakFlame extends StatefulWidget {
  final int streak;
  final double size;

  const StreakFlame({
    super.key,
    required this.streak,
    this.size = 48,
  });

  @override
  State<StreakFlame> createState() => _StreakFlameState();
}

class _StreakFlameState extends State<StreakFlame> {
  static const _milestones = [7, 14, 21, 30, 60, 90];

  Color get _flameColor {
    if (widget.streak >= 60) return const Color(0xFFFFD700);
    if (widget.streak >= 30) return OuroColors.ouroOrange;
    if (widget.streak >= 14) return Colors.orange;
    if (widget.streak >= 7) return Colors.deepOrange;
    return Colors.orange.withValues(alpha: 0.6);
  }

  String? get _milestoneLabel {
    for (final m in _milestones.reversed) {
      if (widget.streak >= m) return '$m';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Flamme Rive de Kunfox : grise sans série, elle s'allume (étincelle,
        // onde, braises) dès que la série démarre, puis vacille.
        KunfoxFlamme(allumee: widget.streak > 0, taille: widget.size * 1.2),
        if (widget.streak > 0)
          Container(
            margin: EdgeInsets.only(top: widget.size * 0.05),
            padding: EdgeInsets.symmetric(
              horizontal: widget.size * 0.2,
              vertical: widget.size * 0.05,
            ),
            decoration: BoxDecoration(
              color: _flameColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(widget.size * 0.15),
            ),
            child: Text(
              '${widget.streak}',
              style: TextStyle(
                color: _flameColor,
                fontSize: widget.size * 0.35,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        if (_milestoneLabel != null)
          Text(
            '🔥 x$_milestoneLabel',
            style: TextStyle(
              color: _flameColor.withValues(alpha: 0.6),
              fontSize: widget.size * 0.2,
              fontWeight: FontWeight.w600,
            ),
          ).animate(onPlay: (c) => c.repeat()).shake(duration: 2.seconds, hz: 0.5),
      ],
    );
  }
}
