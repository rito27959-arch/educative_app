// ============================================================================
// L'ACCUEIL DE KUNFOX : quatre onglets, comme une app d'apprentissage
// moderne — Parcours, Réviser, Quêtes, Profil — et la barre du bas.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../shared/widgets/kunfox/kunfox_rive.dart';
import '../composants/barre_onglets.dart';
import '../composants/bouton.dart';
import '../composants/sons.dart';
import '../donnees/matieres.dart';
import '../donnees/progression.dart';
import '../theme/palette.dart';
import 'parcours.dart';

class AccueilKunfox extends StatefulWidget {
  const AccueilKunfox({super.key, this.onglet = 0});
  final int onglet;

  @override
  State<AccueilKunfox> createState() => _AccueilKunfoxState();
}

class _AccueilKunfoxState extends State<AccueilKunfox> {
  late int _onglet = widget.onglet;

  static const _items = [
    OngletKunfox(icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded, label: 'Parcours'),
    OngletKunfox(icon: Icons.fitness_center_outlined, activeIcon: Icons.fitness_center_rounded, label: 'Réviser'),
    OngletKunfox(icon: Icons.flag_outlined, activeIcon: Icons.flag_rounded, label: 'Quêtes'),
    OngletKunfox(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    // La barre de Droplet flotte au-dessus du contenu, qui défile dessous.
    // Placée comme dans Droplet : collée en bas, par-dessus le contenu.
    return Scaffold(
      body: Stack(children: [
        SafeArea(
          bottom: false,
          child: IndexedStack(index: _onglet, children: const [
            ParcoursEcran(),
            _Reviser(),
            _Quetes(),
            _Profil(),
          ]),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            BarreOnglets(
              items: _items,
              currentIndex: _onglet,
              onTap: (i) => setState(() => _onglet = i),
            ),
          ]),
        ),
      ]),
    );
  }
}

/// Marge du bas des listes pour finir au-dessus de la barre flottante.
double margeBas(BuildContext context) => BarreOnglets.reservedHeight(MediaQuery.paddingOf(context).bottom) + 16;

// ------------------------------------------------------------------ réviser
class _Reviser extends ConsumerWidget {
  const _Reviser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = Palette.of(context);
    final prog = ref.watch(progressionProvider);
    final matiere = ref.watch(matiereActiveProvider);
    final faites = matiere == null ? 0 : leconsDe(matiere).where((l) => prog.leconsFaites.contains(l.id)).length;
    return ListView(padding: EdgeInsets.fromLTRB(20, 20, 20, margeBas(context)), children: [
      Text('Réviser', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 4),
      Text('Ce qu\'on revoit, on le garde.', style: TextStyle(color: p.doux, fontWeight: FontWeight.w600)),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: p.info, borderRadius: BorderRadius.circular(22)),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Révision express',
                  style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 22, color: Colors.white)),
              const SizedBox(height: 6),
              Text(
                '6 questions sur ${matiere?.title ?? 'ta matière'}. Rapporte 10 XP et un cœur.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w600, height: 1.35),
              ),
              const SizedBox(height: 14),
              BoutonKunfox(
                libelle: 'C\'est parti',
                couleur: Colors.white,
                couleurTexte: p.info,
                hauteur: 46,
                largeurPleine: false,
                surAppui: () => context.push('/k/revision'),
              ),
            ]),
          ),
          const KunfoxMascotte(humeur: HumeurKunfox.reflexion, taille: 110),
        ]),
      ),
      const SizedBox(height: 16),
      _Ligne(icone: Icons.check_circle_rounded, couleur: p.succes, titre: '$faites leçons faites dans cette matière'),
      _Ligne(icone: Icons.local_fire_department_rounded, couleur: p.prim, titre: 'Meilleur combo : ${prog.meilleurCombo} d\'affilée'),
      _Ligne(icone: Icons.favorite_rounded, couleur: p.erreur, titre: '${prog.coeursActuels} cœurs sur $kCoeursMax'),
    ]);
  }
}

class _Ligne extends StatelessWidget {
  const _Ligne({required this.icone, required this.couleur, required this.titre});
  final IconData icone;
  final Color couleur;
  final String titre;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: p.bord, width: 2)),
      child: Row(children: [
        Icon(icone, color: couleur),
        const SizedBox(width: 12),
        Expanded(child: Text(titre, style: Theme.of(context).textTheme.titleMedium)),
      ]),
    );
  }
}

// ------------------------------------------------------------------ quêtes
class _Quetes extends ConsumerWidget {
  const _Quetes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = Palette.of(context);
    final prog = ref.watch(progressionProvider);
    final memeJour = prog.jourCompteurs == jourDe(DateTime.now());
    final quetes = [
      ('Gagner $kObjectifJour XP', prog.xpAujourdhui, kObjectifJour, Icons.bolt_rounded, p.or),
      ('Terminer 2 leçons', memeJour ? prog.leconsDuJour : 0, 2, Icons.menu_book_rounded, p.prim),
      ('Faire une leçon sans faute', memeJour ? prog.sansFauteDuJour : 0, 1, Icons.track_changes_rounded, p.succes),
    ];
    final toutes = quetes.every((q) => q.$2 >= q.$3);

    return ListView(padding: EdgeInsets.fromLTRB(20, 20, 20, margeBas(context)), children: [
      Text('Quêtes du jour', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 4),
      Text('Elles se renouvellent chaque matin.', style: TextStyle(color: p.doux, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Center(
        child: SizedBox(
          height: 170,
          child: toutes
              ? const Stack(alignment: Alignment.center, children: [
                  KunfoxEffet.niveau(taille: 170),
                ])
              : const KunfoxMascotte(humeur: HumeurKunfox.salut, taille: 140),
        ),
      ),
      if (toutes)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('Toutes les quêtes sont faites. Bravo !',
              textAlign: TextAlign.center, style: TextStyle(color: p.or, fontWeight: FontWeight.w800, fontSize: 17)),
        ),
      for (final q in quetes)
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: p.bord, width: 2)),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: q.$5.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
              child: Icon(q.$4, color: q.$5),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(q.$1, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: BarreProgres(valeur: q.$2 / q.$3, couleur: q.$5, hauteur: 14)),
                  const SizedBox(width: 10),
                  Text('${q.$2 > q.$3 ? q.$3 : q.$2}/${q.$3}', style: TextStyle(color: p.doux, fontWeight: FontWeight.w800)),
                ]),
              ]),
            ),
            if (q.$2 >= q.$3) ...[const SizedBox(width: 10), Icon(Icons.check_circle_rounded, color: p.succes)],
          ]),
        ),
    ]);
  }
}

// ------------------------------------------------------------------ profil
class _Profil extends ConsumerWidget {
  const _Profil();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = Palette.of(context);
    final prog = ref.watch(progressionProvider);
    final user = ref.watch(authProvider).user;
    final reglages = ref.watch(settingsProvider);
    final auj = DateTime.now();
    final semaine = [for (var i = 6; i >= 0; i--) auj.subtract(Duration(days: i))];
    final maxXp = semaine.map((d) => prog.xpParJour[jourDe(d)] ?? 0).fold<int>(kObjectifJour, (a, b) => a > b ? a : b);
    const initiales = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    Widget chiffre(IconData i, Color c, String v, String l) => Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: p.bord, width: 2)),
            child: Row(children: [
              Icon(i, color: c),
              const SizedBox(width: 8),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(v, style: Theme.of(context).textTheme.titleLarge),
                  Text(l, style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, fontSize: 12)),
                ]),
              ),
            ]),
          ),
        );

    return ListView(padding: EdgeInsets.fromLTRB(20, 20, 20, margeBas(context)), children: [
      Row(children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: p.prim, shape: BoxShape.circle),
          child: Text(
            (user?.pseudo.isNotEmpty == true ? user!.pseudo[0] : 'K').toUpperCase(),
            style: const TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 32, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user?.pseudo ?? 'Élève', style: Theme.of(context).textTheme.headlineSmall),
            Text('${nomSerie(user?.bacSeries ?? 'D')} · niveau ${prog.niveau}',
                style: TextStyle(color: p.doux, fontWeight: FontWeight.w700)),
          ]),
        ),
      ]),
      const SizedBox(height: 20),
      Row(children: [
        chiffre(Icons.local_fire_department_rounded, p.prim, '${prog.serieActuelle}', 'jours de série'),
        const SizedBox(width: 10),
        chiffre(Icons.bolt_rounded, p.or, '${prog.xp}', 'XP au total'),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        chiffre(Icons.menu_book_rounded, p.succes, '${prog.leconsFaites.length}', 'leçons faites'),
        const SizedBox(width: 10),
        chiffre(Icons.emoji_events_rounded, p.info, '${prog.meilleureSerie}', 'meilleure série'),
      ]),
      const SizedBox(height: 20),
      Text('Cette semaine', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 10),
      Container(
        height: 170,
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
        decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: p.bord, width: 2)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          for (final d in semaine)
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text('${prog.xpParJour[jourDe(d)] ?? 0}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: p.doux)),
                const SizedBox(height: 4),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: (prog.xpParJour[jourDe(d)] ?? 0) / maxXp),
                  duration: const Duration(milliseconds: 700),
                  curve: const Cubic(0.16, 1, 0.3, 1),
                  builder: (context, v, _) => Container(
                    width: 20,
                    height: 4 + 90 * v,
                    decoration: BoxDecoration(
                      color: jourDe(d) == jourDe(auj) ? p.prim : p.prim.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(initiales[d.weekday - 1], style: TextStyle(fontWeight: FontWeight.w800, color: p.doux)),
              ]),
            ),
        ]),
      ),
      const SizedBox(height: 20),
      Material(
        color: p.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: p.bord, width: 2)),
        child: Column(children: [
          SwitchListTile(
            value: reglages.darkMode,
            onChanged: (_) => ref.read(settingsProvider.notifier).toggleDarkMode(),
            title: const Text('Nuit de renard (thème sombre)'),
            secondary: Icon(Icons.dark_mode_rounded, color: p.doux),
            activeThumbColor: p.prim,
          ),
          Divider(height: 1, color: p.bord),
          StatefulBuilder(
            builder: (context, majour) => SwitchListTile(
              value: Sons.actifs,
              onChanged: (v) async {
                await Sons.basculer(v);
                majour(() {});
              },
              title: const Text('Sons'),
              secondary: Icon(Icons.volume_up_rounded, color: p.doux),
              activeThumbColor: p.prim,
            ),
          ),
          Divider(height: 1, color: p.bord),
          ListTile(
            leading: Icon(Icons.groups_rounded, color: p.info),
            title: const Text('Réviser ensemble sur Droplet'),
            subtitle: Text('Les discussions entre élèves se font sur Droplet', style: TextStyle(color: p.doux)),
          ),
          Divider(height: 1, color: p.bord),
          ListTile(
            leading: Icon(Icons.settings_rounded, color: p.doux),
            title: const Text('Réglages'),
            trailing: Icon(Icons.chevron_right_rounded, color: p.doux),
            onTap: () => context.push('/settings'),
          ),
        ]),
      ),
    ]);
  }
}
