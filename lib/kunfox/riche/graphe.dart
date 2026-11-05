// Le tracé de courbes : repère gradué, quadrillage, une ou plusieurs
// fonctions, points remarquables, asymptotes. La courbe se dessine de
// gauche à droite à l'apparition (comme au tableau), et on peut zoomer.
//
// Syntaxe d'un bloc ```graphe :
//   f(x) = x^2 - 2x            ← une courbe (nom optionnel)
//   g(x) = e^(-x) | bleu        ← couleur : orange, bleu, vert, violet, rouge, gris
//   x: -2 .. 4                  ← fenêtre
//   y: -2 .. 5
//   point: (1, -1) A            ← point remarquable avec étiquette
//   asymptote: x = 0            ← droite en pointillés (x = a ou y = b)
//   droite: y = 2x - 1          ← droite tracée (tangente…)
//   titre: Courbe de f

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/palette.dart';
import 'expressions.dart';
import 'tableaux.dart' show Formule;

class _Courbe {
  _Courbe(this.nom, this.f, this.couleur, {this.pointille = false});
  final String nom;
  final double Function(double) f;
  final Color couleur;
  final bool pointille;
}

class SpecGraphe {
  SpecGraphe({
    required this.courbes,
    required this.xMin,
    required this.xMax,
    required this.yMin,
    required this.yMax,
    required this.points,
    required this.asymptotesX,
    required this.asymptotesY,
    this.titre,
  });
  final List<_Courbe> courbes;
  final double xMin, xMax, yMin, yMax;
  final List<(double, double, String)> points;
  final List<double> asymptotesX, asymptotesY;
  final String? titre;

  static const _couleurs = {
    'orange': Color(0xFFFF6B2B),
    'bleu': Color(0xFF2F80ED),
    'vert': Color(0xFF22A06B),
    'violet': Color(0xFF8B5CF6),
    'rouge': Color(0xFFE5484D),
    'gris': Color(0xFF8A8F98),
  };

  static SpecGraphe lire(String source) {
    final courbes = <_Courbe>[];
    var xMin = -5.0, xMax = 5.0, yMin = -5.0, yMax = 5.0;
    final points = <(double, double, String)>[];
    final ax = <double>[], ay = <double>[];
    String? titre;
    final palette = _couleurs.values.toList();

    double? n(String t) => Expressions.nombre(t);

    for (final brut in source.split('\n')) {
      final ligne = brut.trim();
      if (ligne.isEmpty || ligne.startsWith('#')) continue;
      final deux = ligne.indexOf(':');
      final cle = deux > 0 ? ligne.substring(0, deux).trim().toLowerCase() : '';
      final reste = deux > 0 ? ligne.substring(deux + 1).trim() : '';
      if (cle == 'x' || cle == 'y') {
        final b = reste.split('..');
        if (b.length == 2) {
          final a = n(b[0]), z = n(b[1]);
          if (a != null && z != null && z > a) {
            if (cle == 'x') {
              xMin = a;
              xMax = z;
            } else {
              yMin = a;
              yMax = z;
            }
          }
        }
      } else if (cle == 'titre') {
        titre = reste;
      } else if (cle == 'point') {
        final m = RegExp(r'\(([^,]+),([^)]+)\)\s*(.*)').firstMatch(reste);
        final a = m == null ? null : n(m[1]!), b = m == null ? null : n(m[2]!);
        if (a != null && b != null) points.add((a, b, m![3]!.trim()));
      } else if (cle == 'asymptote') {
        final m = RegExp(r'^([xy])\s*=\s*(.+)$').firstMatch(reste);
        final v = m == null ? null : n(m[2]!);
        if (v != null) (m![1] == 'x' ? ax : ay).add(v);
      } else if (cle == 'droite') {
        final m = RegExp(r'^y\s*=\s*(.+)$').firstMatch(reste);
        final f = m == null ? null : Expressions.fonction(m[1]!.split('|').first);
        if (f != null) {
          final c = reste.contains('|') ? _couleurs[reste.split('|').last.trim()] : null;
          courbes.add(_Courbe('', f, c ?? const Color(0xFF8A8F98), pointille: true));
        }
      } else {
        // f(x) = … | couleur
        final m = RegExp(r'^([A-Za-z][\w′’]*)\s*\(\s*([a-z])\s*\)\s*=\s*([^|]+)(\|\s*(\w+))?$').firstMatch(ligne);
        if (m != null) {
          final f = Expressions.fonction(m[3]!, variable: m[2]!);
          if (f != null) {
            courbes.add(_Courbe(m[1]!, f, _couleurs[m[5]?.trim()] ?? palette[courbes.length % palette.length]));
          }
        }
      }
    }
    return SpecGraphe(
      courbes: courbes,
      xMin: xMin,
      xMax: xMax,
      yMin: yMin,
      yMax: yMax,
      points: points,
      asymptotesX: ax,
      asymptotesY: ay,
      titre: titre,
    );
  }
}

class Graphe extends StatefulWidget {
  const Graphe({super.key, required this.source, this.hauteur = 260});
  final String source;
  final double hauteur;

  @override
  State<Graphe> createState() => _GrapheState();
}

class _GrapheState extends State<Graphe> with SingleTickerProviderStateMixin {
  late SpecGraphe _spec = SpecGraphe.lire(widget.source);
  late final AnimationController _trace =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..forward();

  @override
  void didUpdateWidget(covariant Graphe ancien) {
    super.didUpdateWidget(ancien);
    if (ancien.source != widget.source) {
      _spec = SpecGraphe.lire(widget.source);
      _trace.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _trace.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final s = _spec;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.bord, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (s.titre != null || s.courbes.any((c) => c.nom.isNotEmpty))
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Wrap(spacing: 12, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
              if (s.titre != null) Text(s.titre!, style: const TextStyle(fontWeight: FontWeight.w800)),
              for (final c in s.courbes.where((c) => c.nom.isNotEmpty))
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 14, height: 4, decoration: BoxDecoration(color: c.couleur, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 5),
                  Formule('\\mathcal{C}_{${c.nom}}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.couleur)),
                ]),
            ]),
          ),
        SizedBox(
          height: widget.hauteur,
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 5,
            child: AnimatedBuilder(
              animation: _trace,
              builder: (context, _) => CustomPaint(
                size: Size.infinite,
                painter: _Peintre(s, Curves.easeInOutCubic.transform(_trace.value), p),
              ),
            ),
          ),
        ),
      ]),
    );
  }

}

class _Peintre extends CustomPainter {
  _Peintre(this.s, this.t, this.p);
  final SpecGraphe s;
  final double t;
  final Palette p;

  @override
  void paint(Canvas canvas, Size size) {
    const marge = 10.0;
    final w = size.width - 2 * marge, h = size.height - 2 * marge;
    Offset pt(double x, double y) =>
        Offset(marge + (x - s.xMin) / (s.xMax - s.xMin) * w, marge + (s.yMax - y) / (s.yMax - s.yMin) * h);

    // pas des graduations : 1, 2, 5, 10…
    double pas(double etendue) {
      final brut = etendue / 8;
      final e = math.pow(10, (math.log(brut) / math.ln10).floor()).toDouble();
      for (final m in [1, 2, 5, 10]) {
        if (m * e >= brut) return m * e;
      }
      return 10 * e;
    }

    final px = pas(s.xMax - s.xMin), py = pas(s.yMax - s.yMin);
    final grille = Paint()
      ..color = p.bord.withValues(alpha: 0.7)
      ..strokeWidth = 1;
    final texte = TextStyle(fontFamily: 'Inter', fontSize: 10, color: p.doux, fontWeight: FontWeight.w600);

    void ecrire(String t, Offset o, {bool droite = false}) {
      final tp = TextPainter(text: TextSpan(text: t, style: texte), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, droite ? o.translate(-tp.width - 3, -tp.height / 2) : o.translate(-tp.width / 2, 3));
    }

    String fmt(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1).replaceAll('.', ',');

    for (var x = (s.xMin / px).ceil() * px; x <= s.xMax + 1e-9; x += px) {
      canvas.drawLine(pt(x, s.yMin), pt(x, s.yMax), grille);
    }
    for (var y = (s.yMin / py).ceil() * py; y <= s.yMax + 1e-9; y += py) {
      canvas.drawLine(pt(s.xMin, y), pt(s.xMax, y), grille);
    }

    // axes
    final axe = Paint()
      ..color = p.texte.withValues(alpha: 0.75)
      ..strokeWidth = 1.6;
    final y0 = s.yMin <= 0 && s.yMax >= 0 ? 0.0 : s.yMin;
    final x0 = s.xMin <= 0 && s.xMax >= 0 ? 0.0 : s.xMin;
    canvas.drawLine(pt(s.xMin, y0), pt(s.xMax, y0), axe);
    canvas.drawLine(pt(x0, s.yMin), pt(x0, s.yMax), axe);
    // flèches
    final fx = pt(s.xMax, y0), fy = pt(x0, s.yMax);
    canvas.drawPath(Path()..moveTo(fx.dx, fx.dy)..lineTo(fx.dx - 7, fx.dy - 4)..lineTo(fx.dx - 7, fx.dy + 4)..close(), axe);
    canvas.drawPath(Path()..moveTo(fy.dx, fy.dy)..lineTo(fy.dx - 4, fy.dy + 7)..lineTo(fy.dx + 4, fy.dy + 7)..close(), axe);
    for (var x = (s.xMin / px).ceil() * px; x <= s.xMax - px / 2; x += px) {
      if (x.abs() < 1e-9) continue;
      ecrire(fmt(x), pt(x, y0));
    }
    for (var y = (s.yMin / py).ceil() * py; y <= s.yMax - py / 2; y += py) {
      if (y.abs() < 1e-9) continue;
      ecrire(fmt(y), pt(x0, y), droite: true);
    }
    ecrire('O', pt(x0, y0).translate(-8, 0));

    // asymptotes
    final tirets = Paint()
      ..color = p.erreur.withValues(alpha: 0.8)
      ..strokeWidth = 1.4;
    for (final a in s.asymptotesX) {
      _pointilles(canvas, pt(a, s.yMin), pt(a, s.yMax), tirets);
    }
    for (final a in s.asymptotesY) {
      _pointilles(canvas, pt(s.xMin, a), pt(s.xMax, a), tirets);
    }

    // courbes : on échantillonne finement, on coupe aux discontinuités,
    // et on n'en montre qu'une fraction t (le tracé « à la craie »).
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(marge, marge, w, h));
    final xFin = s.xMin + (s.xMax - s.xMin) * t;
    for (final c in s.courbes) {
      final trait = Paint()
        ..color = c.couleur
        ..strokeWidth = c.pointille ? 1.8 : 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final n = (w * 1.5).clamp(200, 900).toInt();
      final chemin = Path();
      var ouvert = false;
      double? yAvant;
      final hautMax = (s.yMax - s.yMin) * 4;
      for (var i = 0; i <= n; i++) {
        final x = s.xMin + (s.xMax - s.xMin) * i / n;
        if (x > xFin) break;
        final y = c.f(x);
        final valide = y.isFinite && y > s.yMin - hautMax && y < s.yMax + hautMax;
        final saut = yAvant != null && valide && (y - yAvant).abs() > (s.yMax - s.yMin) * 1.5;
        if (!valide || saut) {
          ouvert = false;
          yAvant = valide ? y : null;
          if (!valide) continue;
        }
        final o = pt(x, y);
        if (!ouvert) {
          chemin.moveTo(o.dx, o.dy);
          ouvert = true;
        } else {
          chemin.lineTo(o.dx, o.dy);
        }
        yAvant = y;
      }
      if (c.pointille) {
        for (final m in chemin.computeMetrics()) {
          for (var d = 0.0; d < m.length; d += 12) {
            canvas.drawPath(m.extractPath(d, math.min(d + 7, m.length)), trait);
          }
        }
      } else {
        canvas.drawPath(chemin, trait);
      }
    }
    canvas.restore();

    // points remarquables (après le tracé)
    if (t > 0.95) {
      for (final (x, y, nom) in s.points) {
        final o = pt(x, y);
        canvas.drawCircle(o, 5.5, Paint()..color = p.surface);
        canvas.drawCircle(o, 4.5, Paint()..color = p.texte);
        if (nom.isNotEmpty) {
          final tp = TextPainter(
            text: TextSpan(text: nom, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w800, color: p.texte)),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, o.translate(6, -tp.height - 2));
        }
      }
    }
  }

  void _pointilles(Canvas canvas, Offset a, Offset b, Paint pinceau) {
    final l = (b - a).distance;
    final dir = (b - a) / l;
    for (var d = 0.0; d < l; d += 10) {
      canvas.drawLine(a + dir * d, a + dir * math.min(d + 6, l), pinceau);
    }
  }

  @override
  bool shouldRepaint(_Peintre ancien) => ancien.t != t || ancien.s != s || ancien.p != p;
}
