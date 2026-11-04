// Le bouton Kunfox : un pavé arrondi avec une tranche plus foncée dessous,
// qui s'enfonce réellement sous le doigt (la tranche disparaît), avec un
// retour haptique léger. Utilisé partout : « Commencer », « Vérifier »...

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/palette.dart';

class BoutonKunfox extends StatefulWidget {
  const BoutonKunfox({
    super.key,
    required this.libelle,
    required this.surAppui,
    this.couleur,
    this.couleurTexte = Colors.white,
    this.contour = false,
    this.icone,
    this.hauteur = 54,
    this.largeurPleine = true,
  });

  final String libelle;
  final VoidCallback? surAppui;
  final Color? couleur;
  final Color couleurTexte;
  final bool contour;
  final IconData? icone;
  final double hauteur;
  final bool largeurPleine;

  @override
  State<BoutonKunfox> createState() => _BoutonKunfoxState();
}

class _BoutonKunfoxState extends State<BoutonKunfox> {
  bool _enfonce = false;
  static const _tranche = 4.0;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final actif = widget.surAppui != null;
    final base = !actif ? p.verrou : (widget.contour ? p.surface : (widget.couleur ?? p.prim));
    final tranche = !actif ? Palette.fonce(p.verrou, 0.12) : (widget.contour ? p.bord : Palette.fonce(base));
    final texte = !actif ? p.doux : (widget.contour ? (widget.couleur ?? p.texte) : widget.couleurTexte);
    final decalage = _enfonce ? _tranche : 0.0;

    final contenu = Row(
      mainAxisSize: widget.largeurPleine ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icone != null) ...[Icon(widget.icone, color: texte, size: 20), const SizedBox(width: 8)],
        Flexible(
          child: Text(
            widget.libelle.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.8, color: texte),
          ),
        ),
      ],
    );

    return Semantics(
      button: true,
      enabled: actif,
      label: widget.libelle,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: actif ? (_) => setState(() => _enfonce = true) : null,
        onTapCancel: actif ? () => setState(() => _enfonce = false) : null,
        onTapUp: actif
            ? (_) {
                setState(() => _enfonce = false);
                HapticFeedback.lightImpact();
                widget.surAppui!();
              }
            : null,
        child: SizedBox(
          height: widget.hauteur + _tranche,
          child: Stack(
            children: [
              Positioned.fill(
                top: _tranche,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: tranche, borderRadius: BorderRadius.circular(16)),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 70),
                curve: Curves.easeOut,
                left: 0,
                right: 0,
                top: decalage,
                height: widget.hauteur,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(16),
                    border: widget.contour ? Border.all(color: p.bord, width: 2) : null,
                  ),
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: contenu),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Barre de progression arrondie, avec un reflet clair sur le dessus.
class BarreProgres extends StatelessWidget {
  const BarreProgres({super.key, required this.valeur, this.couleur, this.hauteur = 16});

  final double valeur;
  final Color? couleur;
  final double hauteur;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final c = couleur ?? p.succes;
    return ClipRRect(
      borderRadius: BorderRadius.circular(hauteur),
      child: SizedBox(
        height: hauteur,
        child: Stack(children: [
          Positioned.fill(child: ColoredBox(color: p.verrou)),
          TweenAnimationBuilder<double>(
            tween: Tween(end: valeur.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 520),
            curve: const Cubic(0.16, 1, 0.3, 1),
            builder: (context, v, _) => FractionallySizedBox(
              widthFactor: v,
              child: DecoratedBox(
                decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(hauteur)),
                child: Align(
                  alignment: const Alignment(0, -0.45),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: hauteur * 0.5),
                    child: Container(
                      height: hauteur * 0.24,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(hauteur),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
