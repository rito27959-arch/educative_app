import 'package:flutter/material.dart';

class DesignTokens {
  DesignTokens._();

  // === GRID ===
  static const double gridBase = 8;
  static const double gridSm   = 6;
  static const double gridMd   = 14;
  static const double grid2x   = 16;
  static const double grid3x   = 24;
  static const double grid4x   = 32;
  static const double grid5x   = 40;
  static const double grid6x   = 48;
  static const double grid8x   = 64;
  static const double grid10x  = 80;
  static const double grid12x  = 96;

  // === TEXT SCALE ===
  static const double textXs  = 10;
  static const double textSm  = 12;
  static const double textMd  = 14;
  static const double textLg  = 16;
  static const double textXl  = 18;
  static const double text2xl = 20;
  static const double text3xl = 24;
  static const double text4xl = 28;
  static const double text5xl = 32;
  static const double text6xl = 36;
  static const double text7xl = 45;
  static const double text8xl = 57;

  // === RADIUS ===
  static const double radiusXs   = 4;
  static const double radiusSm   = 8;
  static const double radiusMd   = 12;
  static const double radiusLg   = 16;
  static const double radiusXl   = 20;
  static const double radius2xl  = 24;
  static const double radius3xl  = 32;
  static const double radiusFull = 9999;

  // === ICONS ===
  static const double iconXs  = 12;
  static const double iconSm  = 16;
  static const double iconMd  = 20;
  static const double iconLg  = 24;
  static const double iconXl  = 28;
  static const double icon2xl = 32;
  static const double icon3xl = 40;
  static const double icon4xl = 48;

  // === DURATIONS — Netflix/Duolingo feel ===
  static const Duration durationInstant = Duration(milliseconds: 80);
  static const Duration durationFast    = Duration(milliseconds: 150);
  static const Duration durationNormal  = Duration(milliseconds: 280);
  static const Duration durationSlow    = Duration(milliseconds: 450);
  static const Duration durationXSlow   = Duration(milliseconds: 650);
  static const Duration durationXXSlow  = Duration(milliseconds: 1000);
  static const Duration durationBeat    = Duration(milliseconds: 1600);

  // === CURVES — spring-physics inspired ===
  /// Snappy default — feels like iOS
  static const Curve curveDefault   = Curves.easeInOut;
  /// Smooth deceleration — cards sliding in
  static const Curve curveEmphasis  = Curves.easeOutCubic;
  /// Overshoot spring — like Duolingo streaks
  static const Curve curveSpring    = Curves.easeOutBack;
  /// Heavy bounce — celebration moments
  static const Curve curveBounce   = Curves.elasticOut;
  /// Linear — progress bars
  static const Curve curveLinear    = Curves.linear;
  /// Fast in, slow out — button presses
  static const Curve curveFastOut   = Curves.fastOutSlowIn;

  // === PADDING ===
  static const EdgeInsets paddingXs  = EdgeInsets.all(4);
  static const EdgeInsets paddingSm  = EdgeInsets.all(8);
  static const EdgeInsets paddingMd  = EdgeInsets.all(16);
  static const EdgeInsets paddingLg  = EdgeInsets.all(24);
  static const EdgeInsets paddingXl  = EdgeInsets.all(32);

  static const EdgeInsets hPaddingSm  = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets hPaddingMd  = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets hPaddingLg  = EdgeInsets.symmetric(horizontal: 24);

  static const EdgeInsets vPaddingSm  = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets vPaddingMd  = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets vPaddingLg  = EdgeInsets.symmetric(vertical: 24);

  // === SHADOWS / GLOW ===
  /// Multi-layer glow — neon effect like TikTok CTAs
  static List<BoxShadow> glow(Color color, {double radius = 20, double spread = 2}) {
    return [
      BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: radius * 0.6, spreadRadius: spread * 0.5),
      BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: radius,       spreadRadius: spread),
      BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: radius * 2,   spreadRadius: 0),
    ];
  }

  /// Subtle card depth
  static List<BoxShadow> cardShadow = [
    BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 20, offset: const Offset(0, 8)),
    BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 6,  offset: const Offset(0, 2)),
  ];

  /// Strong card pop
  static List<BoxShadow> cardShadowStrong = [
    BoxShadow(color: Colors.black.withValues(alpha: 0.7), blurRadius: 40, offset: const Offset(0, 16)),
    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
  ];
}
