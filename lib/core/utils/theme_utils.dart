import 'package:flutter/material.dart';
import '../../design_system/ouro_colors.dart';

class ThemeUtils {
  ThemeUtils._();

  static Color primaryColor = OuroColors.meshBlue;

  static Color getStatusColor(double progress) {
    if (progress >= 0.8) return OuroColors.localGreen;
    if (progress >= 0.4) return OuroColors.ouroOrange;
    return OuroColors.errorRed;
  }

  static Color getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathématiques':
      case 'maths':
        return const Color(0xFF00A8FF);
      case 'physique':
        return const Color(0xFFFF7A00);
      case 'informatique':
        return const Color(0xFF00E676);
      case 'littérature':
      case 'français':
        return const Color(0xFF9C27B0);
      case 'svt':
      case 'sciences':
        return const Color(0xFF4CAF50);
      case 'philosophie':
        return const Color(0xFFFF9800);
      case 'histoire':
      case 'géographie':
        return const Color(0xFF795548);
      default:
        return OuroColors.meshBlue;
    }
  }

  static IconData getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathématiques':
      case 'maths':
        return Icons.functions;
      case 'physique':
        return Icons.science;
      case 'informatique':
        return Icons.computer;
      case 'littérature':
      case 'français':
        return Icons.menu_book;
      case 'svt':
      case 'sciences':
        return Icons.biotech;
      case 'philosophie':
        return Icons.psychology;
      case 'histoire':
      case 'géographie':
        return Icons.public;
      default:
        return Icons.school;
    }
  }

  static double lerp(double a, double b, double t) {
    return a + (b - a) * t.clamp(0.0, 1.0);
  }

  static Color lerpColor(Color a, Color b, double t) {
    return Color.lerp(a, b, t.clamp(0.0, 1.0)) ?? a;
  }

  static bool isLight(Color color) {
    return color.computeLuminance() > 0.5;
  }

  static Color textOnBackground(Color bg) {
    return isLight(bg) ? OuroColors.background : OuroColors.textPrimary;
  }

  static Brightness brightnessForColor(Color bg) {
    return isLight(bg) ? Brightness.light : Brightness.dark;
  }
}
