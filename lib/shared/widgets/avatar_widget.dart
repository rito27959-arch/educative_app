import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../design_system/ouro_colors.dart';

class AvatarWidget extends StatelessWidget {
  final String pseudo;
  final String? imageUrl;
  final double size;
  final bool showGlow;

  const AvatarWidget({
    super.key,
    required this.pseudo,
    this.imageUrl,
    this.size = 48,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final initial = pseudo.isNotEmpty ? pseudo[0].toUpperCase() : '?';

    Widget avatar;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatar = CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
      );
    } else {
      avatar = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [OuroColors.meshBlue, OuroColors.ouroOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            initial,
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    if (!showGlow) return avatar;

    return avatar
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 3.seconds, color: OuroColors.meshBlue.withValues(alpha: 0.2));
  }
}
