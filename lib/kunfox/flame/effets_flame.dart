// ============================================================================
// LES EFFETS FLAME DE KUNFOX.
// ----------------------------------------------------------------------------
//   CielFlame      : le décor vivant derrière le parcours (étoiles qui
//                    scintillent la nuit, poussière dorée à l'aube), en
//                    parallaxe avec le défilement.
//   ConfettisFlame : la pluie de confettis et les étincelles des victoires,
//                    pilotée par un ConfettisControleur.
// Les deux sont transparents et laissent passer les touchers.
// ============================================================================

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

// --------------------------------------------------------------------- ciel
class _JeuCiel extends FlameGame {
  _JeuCiel({required this.sombre, required this.couleur});

  final bool sombre;
  final Color couleur;
  double decalage = 0;
  final _hasard = math.Random(7);
  late final List<_Astre> _astres;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    _astres = List.generate(46, (i) => _Astre(
          x: _hasard.nextDouble(),
          y: _hasard.nextDouble() * 3,
          profondeur: 0.15 + _hasard.nextDouble() * 0.6,
          taille: 0.8 + _hasard.nextDouble() * (sombre ? 1.8 : 2.6),
          phase: _hasard.nextDouble() * math.pi * 2,
          vitesse: 0.6 + _hasard.nextDouble() * 1.6,
        ));
  }

  double _t = 0;

  @override
  void update(double dt) {
    _t += dt;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final w = size.x, h = size.y;
    if (w <= 0 || h <= 0) return;
    final pinceau = Paint();
    for (final a in _astres) {
      // chaque astre glisse moins vite que le parcours : effet de profondeur
      final y = ((a.y * h - decalage * a.profondeur) % (h * 1.2) + h * 1.2) % (h * 1.2) - h * 0.1;
      final x = a.x * w + math.sin(_t * 0.3 * a.vitesse + a.phase) * 6;
      final eclat = 0.35 + 0.65 * (0.5 + 0.5 * math.sin(_t * a.vitesse + a.phase));
      if (sombre) {
        pinceau.color = Colors.white.withValues(alpha: 0.55 * eclat * a.profondeur + 0.08);
        canvas.drawCircle(Offset(x, y), a.taille * 0.6, pinceau);
        if (a.taille > 2.2) {
          pinceau.color = couleur.withValues(alpha: 0.18 * eclat);
          canvas.drawCircle(Offset(x, y), a.taille * 2.2, pinceau);
        }
      } else {
        pinceau.color = couleur.withValues(alpha: 0.10 + 0.14 * eclat);
        canvas.drawCircle(Offset(x, y), a.taille, pinceau);
      }
    }
  }
}

class _Astre {
  _Astre({required this.x, required this.y, required this.profondeur, required this.taille, required this.phase, required this.vitesse});
  final double x, y, profondeur, taille, phase, vitesse;
}

/// Décor animé, en parallaxe avec [defilement].
class CielFlame extends StatefulWidget {
  const CielFlame({super.key, required this.defilement, required this.sombre, required this.couleur});

  final ScrollController defilement;
  final bool sombre;
  final Color couleur;

  @override
  State<CielFlame> createState() => _CielFlameState();
}

class _CielFlameState extends State<CielFlame> {
  late _JeuCiel _jeu = _JeuCiel(sombre: widget.sombre, couleur: widget.couleur);

  void _suivre() {
    if (widget.defilement.hasClients) _jeu.decalage = widget.defilement.offset;
  }

  @override
  void initState() {
    super.initState();
    widget.defilement.addListener(_suivre);
  }

  @override
  void didUpdateWidget(covariant CielFlame ancien) {
    super.didUpdateWidget(ancien);
    if (ancien.sombre != widget.sombre) _jeu = _JeuCiel(sombre: widget.sombre, couleur: widget.couleur);
    if (ancien.defilement != widget.defilement) {
      ancien.defilement.removeListener(_suivre);
      widget.defilement.addListener(_suivre);
    }
  }

  @override
  void dispose() {
    widget.defilement.removeListener(_suivre);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return const SizedBox.expand();
    return IgnorePointer(child: GameWidget(game: _jeu));
  }
}

// --------------------------------------------------------------- confettis
class ConfettisControleur {
  _JeuConfettis? _jeu;

  /// Une pluie de confettis qui tombe du haut de l'écran.
  void pluie({int nombre = 90}) => _jeu?.pluie(nombre);

  /// Une gerbe d'étincelles à un endroit (coordonnées locales au widget).
  void gerbe(Offset ou, {Color? couleur, int nombre = 18}) => _jeu?.gerbe(ou, couleur, nombre);
}

class _JeuConfettis extends FlameGame {
  _JeuConfettis(this.couleurs);

  final List<Color> couleurs;
  final _hasard = math.Random();

  @override
  Color backgroundColor() => const Color(0x00000000);

  void pluie(int nombre) {
    final w = size.x;
    for (var i = 0; i < nombre; i++) {
      final c = couleurs[i % couleurs.length];
      final depart = Vector2(_hasard.nextDouble() * w, -20 - _hasard.nextDouble() * 160);
      final vie = 2.2 + _hasard.nextDouble() * 1.4;
      add(ParticleSystemComponent(
        position: depart,
        particle: AcceleratedParticle(
          lifespan: vie,
          speed: Vector2((_hasard.nextDouble() - 0.5) * 160, 120 + _hasard.nextDouble() * 160),
          acceleration: Vector2(0, 160),
          child: _Confetti(
            couleur: c,
            vie: vie,
            largeur: 6 + _hasard.nextDouble() * 6,
            hauteur: 10 + _hasard.nextDouble() * 6,
            tour: 4 + _hasard.nextDouble() * 8,
            rond: i % 5 == 0,
          ),
        ),
      ));
    }
  }

  void gerbe(Offset ou, Color? couleur, int nombre) {
    add(ParticleSystemComponent(
      position: Vector2(ou.dx, ou.dy),
      particle: Particle.generate(
        count: nombre,
        lifespan: 0.7,
        generator: (i) {
          final a = i / nombre * 2 * math.pi + _hasard.nextDouble() * 0.3;
          final v = 120 + _hasard.nextDouble() * 140;
          return AcceleratedParticle(
            speed: Vector2(math.cos(a) * v, math.sin(a) * v),
            acceleration: Vector2(0, 260),
            child: _Etincelle(couleur: couleur ?? couleurs[i % couleurs.length]),
          );
        },
      ),
    ));
  }
}

class _Confetti extends Particle {
  _Confetti({
    required this.couleur,
    required this.vie,
    required this.largeur,
    required this.hauteur,
    required this.tour,
    required this.rond,
  }) : super(lifespan: vie);

  final Color couleur;
  final double vie, largeur, hauteur, tour;
  final bool rond;

  @override
  void render(Canvas canvas) {
    final t = progress * vie;
    final fondu = progress > 0.8 ? (1 - progress) / 0.2 : 1.0;
    final p = Paint()..color = couleur.withValues(alpha: fondu);
    canvas.save();
    canvas.rotate(t * tour * 0.5);
    // le confetti « tourne sur lui-même » : sa largeur bat comme une pièce
    canvas.scale(math.cos(t * tour).abs() * 0.85 + 0.15, 1);
    if (rond) {
      canvas.drawCircle(Offset.zero, largeur * 0.5, p);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: largeur, height: hauteur), const Radius.circular(2)),
        p,
      );
    }
    canvas.restore();
  }
}

class _Etincelle extends Particle {
  _Etincelle({required this.couleur}) : super(lifespan: 0.7);
  final Color couleur;

  @override
  void render(Canvas canvas) {
    final r = 4.2 * (1 - progress * 0.75);
    final chemin = Path()
      ..moveTo(0, -r * 1.8)
      ..lineTo(r * 0.38, -r * 0.38)
      ..lineTo(r * 1.8, 0)
      ..lineTo(r * 0.38, r * 0.38)
      ..lineTo(0, r * 1.8)
      ..lineTo(-r * 0.38, r * 0.38)
      ..lineTo(-r * 1.8, 0)
      ..lineTo(-r * 0.38, -r * 0.38)
      ..close();
    canvas.drawPath(chemin, Paint()..color = couleur.withValues(alpha: 1 - progress * 0.6));
  }
}

/// Calque de confettis, transparent, au-dessus de l'écran.
class ConfettisFlame extends StatefulWidget {
  const ConfettisFlame({super.key, required this.controleur, this.couleurs});

  final ConfettisControleur controleur;
  final List<Color>? couleurs;

  @override
  State<ConfettisFlame> createState() => _ConfettisFlameState();
}

class _ConfettisFlameState extends State<ConfettisFlame> {
  late final _JeuConfettis _jeu = _JeuConfettis(widget.couleurs ??
      const [Color(0xFFFF6B2B), Color(0xFFFFC24B), Color(0xFF2BD48F), Color(0xFF5BB6FF), Color(0xFFFF7A93), Color(0xFFFFF4E8)]);

  @override
  void initState() {
    super.initState();
    widget.controleur._jeu = _jeu;
  }

  @override
  void dispose() {
    if (widget.controleur._jeu == _jeu) widget.controleur._jeu = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return const SizedBox.expand();
    return IgnorePointer(child: GameWidget(game: _jeu));
  }
}
