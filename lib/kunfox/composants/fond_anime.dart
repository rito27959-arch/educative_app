// Le fond des grands moments (fin de leçon, duel, carte à partager) :
// des rayons de soleil qui tournent lentement derrière Kunfox, un halo qui
// respire et quelques étincelles qui montent.

import 'dart:math' as math;

import 'package:flutter/material.dart';

class FondRayons extends StatefulWidget {
  const FondRayons({
    super.key,
    required this.couleur,
    this.centre = const Alignment(0, -0.35),
    this.anime = true,
    this.intensite = 1,
  });

  final Color couleur;
  final Alignment centre;

  /// false : une image fixe (pour la carte à partager).
  final bool anime;
  final double intensite;

  @override
  State<FondRayons> createState() => _FondRayonsState();
}

class _FondRayonsState extends State<FondRayons> with SingleTickerProviderStateMixin {
  late final AnimationController _t =
      AnimationController(vsync: this, duration: const Duration(seconds: 40));

  @override
  void initState() {
    super.initState();
    if (widget.anime) _t.repeat();
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduit = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduit && _t.isAnimating) _t.stop();
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _t,
          builder: (context, _) => CustomPaint(
            size: Size.infinite,
            painter: _Rayons(widget.couleur, widget.centre, _t.value, widget.intensite),
          ),
        ),
      ),
    );
  }
}

class _Rayons extends CustomPainter {
  _Rayons(this.couleur, this.centre, this.t, this.intensite);
  final Color couleur;
  final Alignment centre;
  final double t;
  final double intensite;

  @override
  void paint(Canvas canvas, Size size) {
    final c = centre.alongSize(size);
    final r = size.longestSide * 1.1;

    // halo qui respire
    final souffle = 0.85 + 0.15 * math.sin(t * math.pi * 2 * 8);
    canvas.drawCircle(
      c,
      r * 0.55,
      Paint()
        ..shader = RadialGradient(colors: [
          couleur.withValues(alpha: 0.42 * intensite * souffle),
          couleur.withValues(alpha: 0),
        ]).createShader(Rect.fromCircle(center: c, radius: r * 0.55)),
    );

    // rayons
    const n = 14;
    final rayon = Paint()
      ..shader = RadialGradient(colors: [
        couleur.withValues(alpha: 0.30 * intensite),
        couleur.withValues(alpha: 0.0),
      ], stops: const [0.05, 1]).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(t * math.pi * 2);
    for (var i = 0; i < n; i++) {
      final a = i * math.pi * 2 / n;
      const demi = math.pi / n * 0.45;
      final chemin = Path()
        ..moveTo(0, 0)
        ..lineTo(math.cos(a - demi) * r, math.sin(a - demi) * r)
        ..lineTo(math.cos(a + demi) * r, math.sin(a + demi) * r)
        ..close();
      canvas.drawPath(chemin, rayon);
    }
    canvas.restore();

    // étincelles qui montent (positions pseudo-aléatoires mais stables)
    final etincelle = Paint()..color = Colors.white;
    for (var i = 0; i < 18; i++) {
      final h = (i * 7919) % 1000 / 1000;
      final v = ((i * 104729) % 1000) / 1000;
      final y = (v - t * (3 + h * 3)) % 1.0;
      final x = h * size.width + math.sin((t * 12 + h) * math.pi * 2) * 10;
      final vie = math.sin(y * math.pi);
      etincelle.color = Colors.white.withValues(alpha: 0.55 * vie * intensite);
      final taille = 1.5 + 2.5 * h;
      _etoile(canvas, Offset(x, y * size.height), taille * (0.6 + 0.4 * vie), etincelle);
    }
  }

  void _etoile(Canvas canvas, Offset o, double r, Paint p) {
    final chemin = Path()
      ..moveTo(o.dx, o.dy - r * 2)
      ..quadraticBezierTo(o.dx, o.dy, o.dx + r * 2, o.dy)
      ..quadraticBezierTo(o.dx, o.dy, o.dx, o.dy + r * 2)
      ..quadraticBezierTo(o.dx, o.dy, o.dx - r * 2, o.dy)
      ..quadraticBezierTo(o.dx, o.dy, o.dx, o.dy - r * 2)
      ..close();
    canvas.drawPath(chemin, p);
  }

  @override
  bool shouldRepaint(_Rayons ancien) => ancien.t != t || ancien.couleur != couleur;
}
