// Lire et évaluer des expressions mathématiques écrites « comme au lycée »
// (2x² + 3x − 1, e^(−x), ln(x), √(x+1), 3,5…). Sert au tracé des courbes
// et à la correction automatique des réponses.

import 'dart:math' as math;

import 'package:math_expressions/math_expressions.dart';

abstract final class Expressions {
  static final _parseur = GrammarParser();
  static final _cache = <String, Expression?>{};

  static const _exposants = {
    '⁰': '0', '¹': '1', '²': '2', '³': '3', '⁴': '4', '⁵': '5', '⁶': '6', '⁷': '7', '⁸': '8', '⁹': '9', '⁻': '-',
  };

  /// Remet une écriture d'élève dans la syntaxe du parseur.
  static String normaliser(String brut, {String variable = 'x'}) {
    var s = brut.trim().toLowerCase();
    s = s
        .replaceAll('−', '-')
        .replaceAll('–', '-')
        .replaceAll('×', '*')
        .replaceAll('·', '*')
        .replaceAll('÷', '/')
        .replaceAll('π', '(pi)')
        .replaceAll(' ', '');
    // exposants unicode : x² → x^(2)
    s = s.replaceAllMapped(RegExp('[⁰¹²³⁴⁵⁶⁷⁸⁹⁻]+'), (m) => '^(${m[0]!.split('').map((c) => _exposants[c]).join()})');
    // √(…) et √x
    s = s.replaceAllMapped(RegExp(r'√\('), (_) => 'sqrt(');
    s = s.replaceAllMapped(RegExp(r'√([0-9a-z.]+)'), (m) => 'sqrt(${m[1]})');
    // virgule décimale : 3,5 → 3.5 (pas entre deux lettres)
    s = s.replaceAllMapped(RegExp(r'(\d),(\d)'), (m) => '${m[1]}.${m[2]}');
    s = s.replaceAll('exp(', 'e^(');
    // e (Euler) isolé et pi
    s = s.replaceAllMapped(RegExp(r'(?<![a-z])e(?![a-z(])'), (_) => '(${math.e})');
    s = s.replaceAll('pi', '(${math.pi})');
    // multiplication implicite : 2x, 2(…), )(, x(, )x, 3sqrt
    final v = RegExp.escape(variable);
    s = s.replaceAllMapped(RegExp(r'(\d|\))(?=[a-z(])'), (m) => '${m[1]}*');
    s = s.replaceAllMapped(RegExp('($v)(?=[0-9(])'), (m) => '${m[1]}*');
    // les fonctions collées ne doivent pas être coupées : s*qrt → sqrt
    for (final f in ['sqrt', 'ln', 'log', 'sin', 'cos', 'tan', 'exp', 'abs', 'arctan', 'arcsin', 'arccos']) {
      final coupe = f.split('').join(r'\*?');
      s = s.replaceAll(RegExp(coupe), f);
    }
    return s;
  }

  static Expression? lire(String brut, {String variable = 'x'}) {
    final cle = '$variable|$brut';
    return _cache.putIfAbsent(cle, () {
      try {
        return _parseur.parse(normaliser(brut, variable: variable));
      } catch (_) {
        return null;
      }
    });
  }

  /// Évalue une expression lue ; NaN si impossible.
  static double valeur(Expression e, Map<String, double> variables) {
    try {
      final ctx = ContextModel();
      variables.forEach((k, v) => ctx.bindVariableName(k, Number(v)));
      final r = RealEvaluator(ctx).evaluate(e);
      return r.toDouble();
    } catch (_) {
      return double.nan;
    }
  }

  /// Une fonction d'une variable, prête à tracer.
  static double Function(double)? fonction(String brut, {String variable = 'x'}) {
    final e = lire(brut, variable: variable);
    if (e == null) return null;
    return (x) => valeur(e, {variable: x});
  }

  /// Deux expressions sont-elles égales ? On les compare en plusieurs points.
  static bool equivalentes(String eleve, String attendue, {String variable = 'x'}) {
    final a = lire(eleve, variable: variable), b = lire(attendue, variable: variable);
    if (a == null || b == null) return false;
    const essais = [0.37, 1.21, 2.53, -0.81, 3.97, 0.5, 5.3];
    var compares = 0;
    for (final t in essais) {
      final va = valeur(a, {variable: t}), vb = valeur(b, {variable: t});
      if (vb.isNaN || vb.isInfinite) continue; // hors domaine : on n'en tient pas compte
      if (va.isNaN || va.isInfinite) return false;
      if ((va - vb).abs() > 1e-6 * math.max(1, vb.abs())) return false;
      compares++;
    }
    return compares >= 3;
  }

  /// Un nombre écrit par l'élève (3,5 ; 1/4 ; 2√3 ; 1.2e-3 ; π/2…).
  static double? nombre(String brut) {
    final t = brut.trim().replaceAllMapped(RegExp(r'(\d)\s*[eE]\s*([-+]?\d+)$'), (m) => '${m[1]}*10^(${m[2]})');
    final e = lire(t, variable: '_');
    if (e == null) return null;
    final v = valeur(e, const {});
    return v.isNaN || v.isInfinite ? null : v;
  }
}
