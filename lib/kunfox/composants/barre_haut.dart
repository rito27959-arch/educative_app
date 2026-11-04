// La barre du haut du parcours : matière en cours (touchez pour changer),
// flamme de série, XP, cœurs. Les icônes vivantes sont des animations Rive.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/kunfox/kunfox_rive.dart';
import '../donnees/matieres.dart';
import '../donnees/progression.dart';
import '../theme/palette.dart';

class BarreHaut extends ConsumerWidget {
  const BarreHaut({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = Palette.of(context);
    final prog = ref.watch(progressionProvider);
    final matiere = ref.watch(matiereActiveProvider);
    final serie = prog.serieActuelle;
    final coeurs = prog.coeursActuels;

    Widget pastille({required Widget icone, required String texte, required Color couleur, String? semantique, VoidCallback? surAppui}) {
      return Semantics(
        label: semantique,
        button: surAppui != null,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: surAppui,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              icone,
              const SizedBox(width: 4),
              Text(texte, style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800, fontSize: 16, color: couleur)),
            ]),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      decoration: BoxDecoration(
        color: p.fond,
        border: Border(bottom: BorderSide(color: p.bord, width: 2)),
      ),
      child: Row(children: [
        pastille(
          icone: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: p.fond2, borderRadius: BorderRadius.circular(10), border: Border.all(color: p.bord, width: 2)),
            child: Text(matiere?.emoji.isNotEmpty == true ? matiere!.emoji : '📘', style: const TextStyle(fontSize: 16)),
          ),
          texte: '',
          couleur: p.texte,
          semantique: 'Matière : ${matiere?.title ?? ''}. Changer de matière',
          surAppui: () => choisirMatiere(context, ref),
        ),
        const Spacer(),
        pastille(
          icone: KunfoxFlamme(allumee: prog.serieFaiteAujourdhui, taille: 28),
          texte: '$serie',
          couleur: prog.serieFaiteAujourdhui ? p.prim : p.doux,
          semantique: 'Série : $serie jours',
        ),
        const SizedBox(width: 6),
        pastille(
          icone: Icon(Icons.bolt_rounded, color: p.or, size: 26),
          texte: '${prog.xp}',
          couleur: p.or,
          semantique: '${prog.xp} XP',
        ),
        const SizedBox(width: 6),
        pastille(
          icone: KunfoxCoeur(perdu: coeurs == 0, taille: 28),
          texte: '$coeurs',
          couleur: coeurs == 0 ? p.doux : p.erreur,
          semantique: '$coeurs cœurs',
          surAppui: () => montrerCoeurs(context, ref),
        ),
      ]),
    );
  }
}

/// Feuille du bas pour changer de matière.
Future<void> choisirMatiere(BuildContext context, WidgetRef ref) async {
  final p = Palette.of(context);
  final matieres = ref.read(matieresProvider);
  final actuelle = ref.read(matiereActiveProvider);
  HapticFeedback.selectionClick();
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: p.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('Tes matières', style: Theme.of(ctx).textTheme.headlineSmall),
          ),
          for (final m in matieres)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: m.id == actuelle?.id ? p.prim.withValues(alpha: 0.10) : p.fond,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: m.id == actuelle?.id ? p.prim : p.bord, width: 2),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    ref.read(progressionProvider.notifier).choisirMatiere(m.id);
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      Text(m.emoji.isNotEmpty ? m.emoji : '📘', style: const TextStyle(fontSize: 26)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(m.title, style: Theme.of(ctx).textTheme.titleMedium),
                          const SizedBox(height: 2),
                          Text('${m.chapters.length} chapitres · coef. ${m.coefficient}',
                              style: TextStyle(color: p.doux, fontSize: 13, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                      if (m.id == actuelle?.id) Icon(Icons.check_circle_rounded, color: p.prim),
                    ]),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

/// Feuille du bas qui explique les cœurs et leur recharge.
Future<void> montrerCoeurs(BuildContext context, WidgetRef ref) async {
  final p = Palette.of(context);
  final prog = ref.read(progressionProvider);
  final dans = prog.prochainCoeurDans;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: p.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 0; i < kCoeursMax; i++)
              Padding(padding: const EdgeInsets.all(2), child: KunfoxCoeur(perdu: i >= prog.coeursActuels, taille: 40)),
          ]),
          const SizedBox(height: 14),
          Text(
            prog.coeursActuels >= kCoeursMax ? 'Tous tes cœurs sont là' : 'Tu as ${prog.coeursActuels} cœur${prog.coeursActuels > 1 ? 's' : ''}',
            style: Theme.of(ctx).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            dans == null
                ? 'Chaque erreur en leçon coûte un cœur. Réviser t\'en rend un.'
                : 'Prochain cœur dans ${dans.inMinutes + 1} min. Réviser t\'en rend un tout de suite.',
            textAlign: TextAlign.center,
            style: TextStyle(color: p.doux, fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
          ),
        ]),
      ),
    ),
  );
}
