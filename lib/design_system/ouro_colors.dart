import 'package:flutter/material.dart';

class OuroColors {
  OuroColors._();

  // === BASE PALETTE ===
  static const Color background    = Color(0xFF060608);
  static const Color surface       = Color(0xFF0F0F14);
  static const Color surfaceElevated = Color(0xFF16161E);
  static const Color cardDark      = Color(0xFF12121A);

  // === BRAND ===
  static const Color meshBlue      = Color(0xFF2563FF);
  static const Color meshBlueBright = Color(0xFF4D8AFF);
  static const Color ouroOrange    = Color(0xFFFF6B2B);
  static const Color localGreen    = Color(0xFF00E676);
  static const Color accentPurple  = Color(0xFF8B5CF6);
  static const Color accentPink    = Color(0xFFEC4899);
  static const Color accentTeal    = Color(0xFF06D6A0);

  // === TEXT ===
  static const Color textPrimary   = Color(0xFFF0F0F8);
  static const Color textSecondary = Color(0xFF8888A0);
  static const Color textTertiary  = Color(0xFF55556A);

  // === GLASS ===
  static const Color glassBg       = Color(0x14FFFFFF);
  static const Color glassBgStrong = Color(0x22FFFFFF);
  static const Color glassBorder   = Color(0x1AFFFFFF);
  static const Color glassBorderStrong = Color(0x33FFFFFF);

  // === STATE ===
  static const Color errorRed      = Color(0xFFFF3B30);
  static const Color warningAmber  = Color(0xFFFFB400);
  static const Color successGreen  = Color(0xFF00E676);

  // === GRADIENTS HELPERS ===
  static const Color meshBlueGradientStart = Color(0xFF2563FF);
  static const Color meshBlueGradientEnd   = Color(0xFF7C3AED);
  static const Color ouroOrangeGradientStart = Color(0xFFFF6B2B);
  static const Color ouroOrangeGradientEnd   = Color(0xFFFF1A6C);

  // === GRADIENT PRESETS ===
  static const LinearGradient brandGradient = LinearGradient(
    colors: [meshBlue, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient energyGradient = LinearGradient(
    colors: [ouroOrange, accentPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [accentTeal, localGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
