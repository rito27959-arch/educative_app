// La barre d'onglets « carton » de Kunfox : des icônes pleines et
// colorées qui ont du relief (une ombre décalée dessous, comme un objet
// découpé), l'onglet choisi posé dans une case arrondie bordée de sa
// couleur, qui rebondit au toucher.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/palette.dart';

class OngletCarton {
  const OngletCarton({required this.icone, required this.libelle, required this.couleur});
  final IconData icone;
  final String libelle;
  final Color couleur;
}

class BarreCarton extends StatelessWidget {
  const BarreCarton({super.key, required this.onglets, required this.actif, required this.surChoix});

  final List<OngletCarton> onglets;
  final int actif;
  final ValueChanged<int> surChoix;

  static double hauteur(double basSur) => 68 + basSur;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: p.fond,
        border: Border(top: BorderSide(color: p.bord, width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(children: [
            for (var i = 0; i < onglets.length; i++)
              Expanded(child: _Case(onglet: onglets[i], choisi: i == actif, surAppui: () => surChoix(i))),
          ]),
        ),
      ),
    );
  }
}

class _Case extends StatefulWidget {
  const _Case({required this.onglet, required this.choisi, required this.surAppui});
  final OngletCarton onglet;
  final bool choisi;
  final VoidCallback surAppui;

  @override
  State<_Case> createState() => _CaseState();
}

class _CaseState extends State<_Case> with SingleTickerProviderStateMixin {
  late final AnimationController _rebond =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
  bool _enfonce = false;

  @override
  void didUpdateWidget(covariant _Case ancien) {
    super.didUpdateWidget(ancien);
    if (widget.choisi && !ancien.choisi) _rebond.forward(from: 0);
  }

  @override
  void dispose() {
    _rebond.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final c = widget.onglet.couleur;
    final terne = Color.lerp(c, p.sombre ? const Color(0xFF6E7898) : const Color(0xFFB9B2AA), 0.45)!;
    final couleur = widget.choisi ? c : terne;

    // l'icône « découpée » : une copie plus sombre, décalée dessous
    final icone = Stack(clipBehavior: Clip.none, children: [
      Transform.translate(
        offset: const Offset(0, 2.5),
        child: Icon(widget.onglet.icone, size: 32, color: Palette.fonce(couleur, 0.3)),
      ),
      Icon(widget.onglet.icone, size: 32, color: couleur),
    ]);

    return Semantics(
      button: true,
      selected: widget.choisi,
      label: widget.onglet.libelle,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _enfonce = true),
        onTapCancel: () => setState(() => _enfonce = false),
        onTapUp: (_) {
          setState(() => _enfonce = false);
          HapticFeedback.selectionClick();
          widget.surAppui();
        },
        child: Center(
          child: AnimatedBuilder(
            animation: _rebond,
            builder: (context, enfant) {
              final t = _rebond.value;
              // petit ressort qui s'amortit
              final s = 1 + 0.16 * math.sin(t * math.pi * 2.2) * (1 - t);
              return Transform.scale(scale: _enfonce ? 0.92 : s, child: enfant);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 62,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.choisi ? c.withValues(alpha: p.sombre ? 0.16 : 0.10) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: widget.choisi ? c.withValues(alpha: 0.75) : Colors.transparent, width: 2),
              ),
              child: icone,
            ),
          ),
        ),
      ),
    );
  }
}
