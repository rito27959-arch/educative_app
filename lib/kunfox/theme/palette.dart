// ============================================================================
// LES COULEURS DE KUNFOX — les mêmes que le site (kunfox.dropletmesh.app).
//   « Aube »           : thème clair
//   « Nuit de renard » : thème sombre
// ============================================================================

import 'package:flutter/material.dart';

@immutable
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.fond,
    required this.fond2,
    required this.surface,
    required this.bord,
    required this.texte,
    required this.doux,
    required this.prim,
    required this.primFonce,
    required this.sec,
    required this.surSec,
    required this.succes,
    required this.erreur,
    required this.info,
    required this.or,
    required this.verrou,
    required this.sombre,
  });

  final Color fond, fond2, surface, bord, texte, doux;
  final Color prim, primFonce, sec, surSec;
  final Color succes, erreur, info, or, verrou;
  final bool sombre;

  static const creme = Color(0xFFFFF4E8);
  static const nuit = Color(0xFF14213D);
  static const orange = Color(0xFFFF6B2B);

  static const aube = Palette(
    fond: Color(0xFFFFF8F1),
    fond2: Color(0xFFFFF1E4),
    surface: Color(0xFFFFFFFF),
    bord: Color(0xFFF1E3D3),
    texte: Color(0xFF14213D),
    doux: Color(0xFF5E6782),
    prim: Color(0xFFFF6B2B),
    primFonce: Color(0xFFE04E14),
    sec: Color(0xFF14213D),
    surSec: Color(0xFFFFF4E8),
    succes: Color(0xFF1FA971),
    erreur: Color(0xFFE5484D),
    info: Color(0xFF2F80ED),
    or: Color(0xFFFFB020),
    verrou: Color(0xFFE6DCD0),
    sombre: false,
  );

  static const nuitDeRenard = Palette(
    fond: Color(0xFF0E1730),
    fond2: Color(0xFF111C3A),
    surface: Color(0xFF16213F),
    bord: Color(0xFF24305A),
    texte: Color(0xFFFFF4E8),
    doux: Color(0xFFA9B3CF),
    prim: Color(0xFFFF6B2B),
    primFonce: Color(0xFFE04E14),
    sec: Color(0xFFFFC24B),
    surSec: Color(0xFF14213D),
    succes: Color(0xFF2BD48F),
    erreur: Color(0xFFFF5A5F),
    info: Color(0xFF5BB6FF),
    or: Color(0xFFFFC24B),
    verrou: Color(0xFF26325C),
    sombre: true,
  );

  /// Couleurs des unités du parcours, une par chapitre, en boucle.
  List<Color> get unites => sombre
      ? const [Color(0xFFFF6B2B), Color(0xFF5BB6FF), Color(0xFF2BD48F), Color(0xFFC08BFF), Color(0xFFFFC24B), Color(0xFFFF7A93)]
      : const [Color(0xFFFF6B2B), Color(0xFF2F80ED), Color(0xFF1FA971), Color(0xFF8B5CF6), Color(0xFFF59E0B), Color(0xFFE5486F)];

  static Palette of(BuildContext context) =>
      Theme.of(context).extension<Palette>() ?? (Theme.of(context).brightness == Brightness.dark ? nuitDeRenard : aube);

  /// La teinte foncée d'une couleur, pour l'épaisseur « 3D » des boutons.
  static Color fonce(Color c, [double t = 0.22]) => Color.lerp(c, const Color(0xFF000000), t)!;

  @override
  Palette copyWith() => this;

  @override
  Palette lerp(ThemeExtension<Palette>? other, double t) => t < 0.5 || other is! Palette ? this : other;
}
