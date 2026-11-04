// Thèmes Material de Kunfox, construits sur la palette du site et la police
// Inter (embarquée dans assets/fonts : aucun téléchargement au lancement).

import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'palette.dart';

class KunfoxTheme {
  static const police = 'Inter';
  static const titres = 'InterTight';

  static ThemeData clair() => _theme(Palette.aube, Brightness.light);
  static ThemeData sombre() => _theme(Palette.nuitDeRenard, Brightness.dark);

  static ThemeData _theme(Palette p, Brightness b) {
    final base = ThemeData(brightness: b, useMaterial3: true, fontFamily: police);
    TextStyle t(double taille, FontWeight poids, {String? famille, double? hauteur, double? espace}) => TextStyle(
          fontFamily: famille ?? police,
          fontSize: taille,
          fontWeight: poids,
          height: hauteur,
          letterSpacing: espace,
          color: p.texte,
        );
    return base.copyWith(
      scaffoldBackgroundColor: p.fond,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Palette.orange,
        brightness: b,
        primary: p.prim,
        onPrimary: Colors.white,
        secondary: p.sec,
        onSecondary: p.surSec,
        surface: p.surface,
        onSurface: p.texte,
        error: p.erreur,
      ),
      extensions: [p],
      splashFactory: InkSparkle.splashFactory,
      textTheme: base.textTheme.copyWith(
        displaySmall: t(34, FontWeight.w800, famille: titres, hauteur: 1.1, espace: -0.8),
        headlineMedium: t(28, FontWeight.w800, famille: titres, hauteur: 1.15, espace: -0.6),
        headlineSmall: t(22, FontWeight.w800, famille: titres, hauteur: 1.2, espace: -0.3),
        titleLarge: t(19, FontWeight.w700, hauteur: 1.25),
        titleMedium: t(16, FontWeight.w700, hauteur: 1.3),
        bodyLarge: t(17, FontWeight.w500, hauteur: 1.45),
        bodyMedium: t(15, FontWeight.w500, hauteur: 1.45),
        labelLarge: t(15, FontWeight.w800, espace: 0.4),
        labelMedium: t(13, FontWeight.w700),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
      dividerColor: p.bord,
    );
  }
}
