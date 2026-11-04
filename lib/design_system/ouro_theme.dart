import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ouro_colors.dart';
import 'ouro_typography.dart';

class OuroTheme {
  OuroTheme._();

  static ThemeData get dark {
    // Full dark + transparent status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: OuroColors.background,
      colorScheme: const ColorScheme.dark(
        primary:   OuroColors.meshBlue,
        secondary: OuroColors.ouroOrange,
        surface:   OuroColors.surface,
        error:     OuroColors.errorRed,
        onPrimary: OuroColors.textPrimary,
        onSurface: OuroColors.textPrimary,
      ),
      textTheme: OuroTypography.textTheme,
      // App bar — transparent, no elevation
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: OuroColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: OuroColors.textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      // Cards
      cardTheme: CardThemeData(
        color: OuroColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: OuroColors.glassBorder, width: 0.5),
        ),
      ),
      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OuroColors.glassBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: OuroColors.glassBorder, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: OuroColors.glassBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: OuroColors.meshBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: OuroColors.errorRed, width: 1),
        ),
        hintStyle: const TextStyle(color: OuroColors.textTertiary, fontSize: 14),
        labelStyle: const TextStyle(color: OuroColors.textSecondary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: OuroColors.glassBg,
        selectedColor: OuroColors.meshBlue.withValues(alpha: 0.2),
        labelStyle: const TextStyle(color: OuroColors.textPrimary, fontSize: 12),
        side: const BorderSide(color: OuroColors.glassBorder, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      // Divider
      dividerTheme: DividerThemeData(
        color: OuroColors.glassBorder,
        thickness: 0.5,
        space: 0,
      ),
      // Bottom nav — no default bottom nav (custom)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Page transitions — slide + fade
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS:     CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
