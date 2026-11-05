// Les tableaux du cours : tableau de variations (flèches dessinées),
// tableau de signes et tableau simple (valeurs, données…).
//
// ```variations
// x     | -∞   |   | 1    |   | +∞
// f'(x) |      | - | 0    | + |
// f(x)  | +∞ h |   | -1 b |   | +∞ h
// ```
// La ligne x donne n valeurs ; les autres lignes ont 2n − 1 cases :
// une case « sous » chaque valeur de x, une case « entre » deux valeurs.
// Dans une ligne de variations, chaque valeur porte h (en haut) ou b (en
// bas) ; les flèches se tracent toutes seules. « ‖ » : valeur interdite
// (ex. « -∞ b ‖ +∞ h » : limite à gauche en bas, à droite en haut).
//
// ```tableau
// x | 0 | 1 | 2
// f(x) | 1 | e | e^2
// ```

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../theme/palette.dart';

/// Une petite formule : LaTeX si possible, texte sinon.
class Formule extends StatelessWidget {
  const Formule(this.texte, {super.key, this.style});
  final String texte;
  final TextStyle? style;

  static String versTex(String t) => t
      .replaceAll('+∞', r'+\infty')
      .replaceAll('-∞', r'-\infty')
      .replaceAll('−∞', r'-\infty')
      .replaceAll('∞', r'\infty')
      .replaceAll('√', r'\sqrt ')
      .replaceAll('π', r'\pi ');

  @override
  Widget build(BuildContext context) {
    final st = style ?? TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Palette.of(context).texte);
    var t = texte.trim();
    if (t.isEmpty) return const SizedBox.shrink();
    final dollars = t.startsWith(r'$') && t.endsWith(r'$') && t.length > 1;
    if (dollars) t = t.replaceAll(r'$', '');
    // du texte ordinaire (mots, unités) reste du texte
    if (!dollars && !RegExp(r'[\\^_{}∞√π]').hasMatch(t)) return Text(t, style: st, textAlign: TextAlign.center);
    // FittedBox : la largeur intrinsèque d'une formule est parfois sous-estimée
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Math.tex(
        versTex(t),
        textStyle: st,
        mathStyle: MathStyle.text,
        onErrorFallback: (_) => Text(texte, style: st),
      ),
    );
  }
}

class _Valeur {
  const _Valeur(this.texte, this.haut);
  final String texte;
  final bool haut;
}

class _Case {
  const _Case({this.texte = '', this.interdit = false, this.gauche, this.droite, this.valeur});
  final String texte;
  final bool interdit;
  final _Valeur? gauche, droite, valeur;
}

class _Ligne {
  _Ligne(this.titre, this.cases, this.variations);
  final String titre;
  final List<_Case> cases;
  final bool variations;
}

_Valeur? _lireValeur(String t) {
  final m = RegExp(r'^(.*?)\s+([hb])$').firstMatch(t.trim());
  if (m == null) return null;
  return _Valeur(m[1]!.trim(), m[2] == 'h');
}

class TableauVariations extends StatelessWidget {
  const TableauVariations({super.key, required this.source});
  final String source;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final lignes = source.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    if (lignes.isEmpty) return const SizedBox.shrink();
    List<String> cellules(String l) {
      final c = l.split('|').map((e) => e.trim()).toList();
      return c;
    }

    final tete = cellules(lignes.first);
    final xs = tete.skip(1).where((e) => e.isNotEmpty).toList();
    final n = xs.length;
    final nbCases = 2 * n - 1;
    final autres = <_Ligne>[];
    for (final l in lignes.skip(1)) {
      final c = cellules(l);
      final titre = c.first;
      var cases = c.skip(1).toList();
      // tolère un | final
      if (cases.length > nbCases && cases.last.isEmpty) cases = cases.sublist(0, nbCases);
      while (cases.length < nbCases) {
        cases.add('');
      }
      final variations = cases.any((e) => _lireValeur(e.split('‖').first) != null || e.contains('‖') && e.contains(RegExp(r'\s[hb]\b')));
      autres.add(_Ligne(
        titre,
        [
          for (final e in cases.take(nbCases))
            if (e.contains('‖'))
              _Case(
                interdit: true,
                gauche: _lireValeur(e.split('‖').first),
                droite: _lireValeur(e.split('‖').last),
              )
            else if (e == '||')
              const _Case(interdit: true)
            else if (variations && _lireValeur(e) != null)
              _Case(valeur: _lireValeur(e))
            else
              _Case(texte: e),
        ],
        variations,
      ));
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.bord, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(builder: (context, c) {
        const titreL = 62.0;
        final largeur = c.maxWidth;
        final colL = (largeur - titreL) / nbCases;
        double centre(int k) => titreL + (k + 0.5) * colL;
        const hX = 40.0, hSigne = 40.0, hVar = 86.0;

        final enfants = <Widget>[];
        final hauteurs = <double>[hX, for (final l in autres) l.variations ? hVar : hSigne];
        final tops = <double>[0];
        for (final h in hauteurs) {
          tops.add(tops.last + h);
        }

        Widget place(Widget w, double cx, double cy, {double l = 80}) => Positioned(
              left: cx - l / 2,
              top: cy - 14,
              width: l,
              height: 28,
              child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: w)),
            );

        // titres
        Widget titre(String t, int i) => Positioned(
              left: 4,
              width: titreL - 8,
              top: tops[i],
              height: hauteurs[i],
              child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: Formule(t))),
            );
        enfants.add(titre(tete.first, 0));
        for (var k = 0; k < n; k++) {
          enfants.add(place(Formule(xs[k]), centre(2 * k), hX / 2, l: colL * 1.8));
        }
        final fleches = <(Offset, Offset)>[];
        final barres = <(double, double, double)>[]; // x, haut, bas (double barre)
        final pointilles = <(double, double, double)>[];
        for (var i = 0; i < autres.length; i++) {
          final ligne = autres[i];
          final top = tops[i + 1], h = hauteurs[i + 1];
          enfants.add(titre(ligne.titre, i + 1));
          if (!ligne.variations) {
            for (var k = 0; k < nbCases; k++) {
              final cs = ligne.cases[k];
              if (cs.interdit) {
                barres.add((centre(k), top, top + h));
              } else if (k.isEven && cs.texte.isEmpty && k != 0 && k != nbCases - 1) {
                pointilles.add((centre(k), top, top + h));
              }
              if (cs.texte.isNotEmpty) {
                enfants.add(place(
                  Formule(cs.texte.replaceAll('-', '−'),
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: cs.texte == '+' ? p.succes : (cs.texte == '-' || cs.texte == '−' ? p.erreur : p.texte))),
                  centre(k),
                  top + h / 2,
                  l: colL * 1.6,
                ));
              }
            }
          } else {
            // points d'ancrage des valeurs pour relier les flèches
            final ancres = <(double, double, bool)>[]; // x, y, côté droit d'une ‖
            final hautY = top + 18, basY = top + h - 18;
            void poser(_Valeur v, double cx) {
              enfants.add(place(Formule(v.texte), cx, v.haut ? hautY : basY, l: colL * 1.4));
            }

            for (var k = 0; k < nbCases; k++) {
              final cs = ligne.cases[k];
              final cx = centre(k);
              if (cs.interdit) {
                barres.add((cx, top, top + h));
                if (cs.gauche != null) {
                  poser(cs.gauche!, cx - colL * 0.42);
                  ancres.add((cx - colL * 0.42, cs.gauche!.haut ? hautY : basY, false));
                }
                if (cs.droite != null) {
                  poser(cs.droite!, cx + colL * 0.42);
                  ancres.add((cx + colL * 0.42, cs.droite!.haut ? hautY : basY, true));
                }
              } else if (cs.valeur != null) {
                poser(cs.valeur!, cx);
                ancres.add((cx, cs.valeur!.haut ? hautY : basY, false));
              }
            }
            for (var a = 0; a + 1 < ancres.length; a++) {
              final (x1, y1, _) = ancres[a];
              final (x2, y2, droite2) = ancres[a + 1];
              // pas de flèche qui traverse une valeur interdite
              if (droite2 || barres.any((b) => b.$2 == top && b.$1 > x1 + 1 && b.$1 < x2 - 1)) continue;
              final d = (Offset(x2, y2) - Offset(x1, y1));
              final u = d / d.distance;
              fleches.add((Offset(x1, y1) + u * 20, Offset(x2, y2) - u * 20));
            }
          }
        }

        return SizedBox(
          height: tops.last,
          child: Stack(children: [
            Positioned.fill(
              child: CustomPaint(painter: _Cadre(p, titreL, tops, fleches, barres, pointilles)),
            ),
            ...enfants,
          ]),
        );
      }),
    );
  }
}

class _Cadre extends CustomPainter {
  _Cadre(this.p, this.titreL, this.tops, this.fleches, this.barres, this.pointilles);
  final Palette p;
  final double titreL;
  final List<double> tops;
  final List<(Offset, Offset)> fleches;
  final List<(double, double, double)> barres, pointilles;

  @override
  void paint(Canvas canvas, Size size) {
    final trait = Paint()
      ..color = p.bord
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(titreL, 0), Offset(titreL, size.height), trait);
    for (final y in tops.skip(1).take(tops.length - 2)) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), trait);
    }
    final fort = Paint()
      ..color = p.texte
      ..strokeWidth = 1.6;
    for (final (x, a, b) in barres) {
      canvas.drawLine(Offset(x - 2.5, a), Offset(x - 2.5, b), fort);
      canvas.drawLine(Offset(x + 2.5, a), Offset(x + 2.5, b), fort);
    }
    final fin = Paint()
      ..color = p.doux.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    for (final (x, a, b) in pointilles) {
      for (var y = a + 3; y < b; y += 7) {
        canvas.drawLine(Offset(x, y), Offset(x, y + 3.5), fin);
      }
    }
    final fl = Paint()
      ..color = p.prim
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    for (final (a, b) in fleches) {
      canvas.drawLine(a, b, fl);
      final u = (b - a) / (b - a).distance;
      final n = Offset(-u.dy, u.dx);
      canvas.drawPath(
        Path()
          ..moveTo(b.dx, b.dy)
          ..lineTo((b - u * 9 + n * 4.5).dx, (b - u * 9 + n * 4.5).dy)
          ..lineTo((b - u * 9 - n * 4.5).dx, (b - u * 9 - n * 4.5).dy)
          ..close(),
        Paint()..color = p.prim,
      );
    }
  }

  @override
  bool shouldRepaint(_Cadre ancien) => true;
}

/// Un tableau simple : première ligne = en-têtes.
class TableauSimple extends StatelessWidget {
  const TableauSimple({super.key, required this.source});
  final String source;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final lignes = source
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && !RegExp(r'^\|?[\s:\-|]+\|?$').hasMatch(l))
        .map((l) {
      var t = l;
      if (t.startsWith('|')) t = t.substring(1);
      if (t.endsWith('|')) t = t.substring(0, t.length - 1);
      return t.split('|').map((e) => e.trim()).toList();
    }).toList();
    if (lignes.isEmpty) return const SizedBox.shrink();
    final nb = lignes.map((l) => l.length).reduce((a, b) => a > b ? a : b);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.bord, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          // la largeur « intrinsèque » d'une formule est sous-estimée : au moins 64 px
          defaultColumnWidth: const MaxColumnWidth(IntrinsicColumnWidth(), FixedColumnWidth(64)),
          border: TableBorder(
            horizontalInside: BorderSide(color: p.bord, width: 1.2),
            verticalInside: BorderSide(color: p.bord, width: 1.2),
          ),
          children: [
            for (final (i, l) in lignes.indexed)
              TableRow(
                decoration: BoxDecoration(color: i == 0 ? p.prim.withValues(alpha: 0.12) : p.surface),
                children: [
                  for (var k = 0; k < nb; k++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                      child: Center(
                        child: Formule(
                          k < l.length ? l[k] : '',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: i == 0 || k == 0 ? FontWeight.w800 : FontWeight.w600,
                            color: p.texte,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
