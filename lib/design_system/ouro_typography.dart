import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OuroTypography {
  OuroTypography._();

  static TextTheme get textTheme {
    final sora = GoogleFonts.sora();
    final inter = GoogleFonts.inter();

    return TextTheme(
      displayLarge: sora.copyWith(fontSize: 57, fontWeight: FontWeight.w700),
      displayMedium: sora.copyWith(fontSize: 45, fontWeight: FontWeight.w700),
      displaySmall: sora.copyWith(fontSize: 36, fontWeight: FontWeight.w600),
      headlineLarge: sora.copyWith(fontSize: 32, fontWeight: FontWeight.w600),
      headlineMedium: sora.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: sora.copyWith(fontSize: 24, fontWeight: FontWeight.w500),
      titleLarge: sora.copyWith(fontSize: 22, fontWeight: FontWeight.w500),
      titleMedium: inter.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: inter.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: inter.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: inter.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: inter.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: inter.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: inter.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: inter.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
    );
  }
}
