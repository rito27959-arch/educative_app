// ============================================================================
// L'ACCUEIL DE KUNFOX : quatre onglets, comme une app d'apprentissage
// moderne — Parcours, Réviser, Quêtes, Profil — et la barre du bas.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../shared/widgets/kunfox/kunfox_rive.dart';
import '../composants/barre_carton.dart';
import '../composants/bouton.dart';
import '../donnees/compte_droplet.dart';
import '../donnees/rappels.dart';
import 'package:share_plus/share_plus.dart';
import '../composants/page_ios.dart';
import '../composants/sons.dart';
import '../donnees/matieres.dart';
import '../donnees/progression.dart';
import '../theme/palette.dart';
import 'duel.dart';
import 'examen.dart' show CarteUltimeBoss;
import '../epreuves/sujets.dart';
import 'parcours.dart';

class AccueilKunfox extends StatefulWidget {
  const AccueilKunfox({super.key, this.onglet = 0});
  final int onglet;

  @override
  State<AccueilKunfox> createState() => _AccueilKunfoxState();
}

class _AccueilKunfoxState extends State<AccueilKunfox> {
  late int _onglet = widget.onglet;
  // Sur le parcours, la barre s'efface quand on descend pour ne rien cacher,
  // et revient dès qu'on remonte ou qu'on touche le haut.
  bool _barreVisible = true;

  bool _surDefilement(UserScrollNotification n) {
    if (_onglet != 0 || n.depth != 0) return false;
    final visible = switch (n.direction) {
      ScrollDirection.reverse => false,
      ScrollDirection.forward => true,
      ScrollDirection.idle => _barreVisible || n.metrics.pixels <= n.metrics.minScrollExtent + 4,
    };
    if (visible != _barreVisible) setState(() => _barreVisible = visible);
    return false;
  }

  static const _items = [
    OngletCarton(icone: Icons.home_rounded, libelle: 'Parcours', couleur: Color(0xFFFF6B2B)),
    OngletCarton(icone: Icons.fitness_center_rounded, libelle: 'Réviser', couleur: Color(0xFF2F80ED)),
    OngletCarton(icone: Icons.emoji_events_rounded, libelle: 'Quêtes', couleur: Color(0xFFF5A623)),
    OngletCarton(icone: Icons.face_rounded, libelle: 'Profil', couleur: Color(0xFF8B5CF6)),
  ];

  @override
  Widget build(BuildContext context) {
    // La barre de Droplet flotte au-dessus du contenu, qui défile dessous.
    // Placée comme dans Droplet : collée en bas, par-dessus le contenu.
    return Scaffold(
      body: Stack(children: [
        SafeArea(
          bottom: false,
          child: NotificationListener<UserScrollNotification>(
            onNotification: _surDefilement,
            child: IndexedStack(index: _onglet, children: const [
              ParcoursEcran(),
              _Reviser(),
              _Quetes(),
              _Profil(),
            ]),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedSlide(
            offset: _barreVisible ? Offset.zero : const Offset(0, 1.4),
            duration: const Duration(milliseconds: 340),
            curve: const Cubic(0.16, 1, 0.3, 1),
            child: AnimatedOpacity(
              opacity: _barreVisible ? 1 : 0,
              duration: const Duration(milliseconds: 220),
              child: IgnorePointer(
                ignoring: !_barreVisible,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  BarreCarton(
                    onglets: _items,
                    actif: _onglet,
                    surChoix: (i) => setState(() {
                      _onglet = i;
                      _barreVisible = true;
                    }),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

/// Marge du bas des listes pour finir au-dessus de la barre flottante.
double margeBas(BuildContext context) => BarreCarton.hauteur(MediaQuery.paddingOf(context).bottom) + 16;

// ------------------------------------------------------------------ réviser
class _Reviser extends ConsumerWidget {
  const _Reviser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = Palette.of(context);
    final prog = ref.watch(progressionProvider);
    final matiere = ref.watch(matiereActiveProvider);
    final faites = matiere == null ? 0 : leconsDe(matiere).where((l) => prog.leconsFaites.contains(l.id)).length;
    return PageIOS(titre: 'Réviser', sousTitre: 'Ce qu\'on revoit, on le garde.', margeBas: margeBas(context), enfants: [
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
      const SizedBox(height: 14),
      // ── duel : le même sujet, les mêmes questions, contre un ami
      _CarteAction(
        couleur: violetDuel,
        icone: Icons.sports_kabaddi_rounded,
        titre: 'Défier un ami',
        texte: 'Mêmes questions, même chrono. Le meilleur score gagne.',
        bouton: 'Lancer un duel',
        surAppui: () => lancerNouveauDuel(context, ref),
        secondaire: ('J\'ai un code', () => saisirCodeDuel(context)),
      ),
      const SizedBox(height: 12),
      // ── Droplet : réviser ensemble, discuter
      _CarteAction(
        couleur: const Color(0xFF2F80ED),
        icone: Icons.water_drop_rounded,
        titre: 'Réviser ensemble sur Droplet',
        texte: 'Crée un groupe avec ta classe, partage tes fiches et discute des exercices.',
        bouton: 'Ouvrir Droplet',
        surAppui: CompteDroplet.ouvrirDroplet,
      ),
      // l'épreuve type Bac de la matière en cours
      if (matiere != null)
        for (final e in epreuvesDe(matiere.id)) ...[
        const SizedBox(height: 12),
        CarteUltimeBoss(epreuve: e, compacte: true),
      ],
      const MesDuels(),
      const SizedBox(height: 16),
      _Ligne(icone: Icons.check_circle_rounded, couleur: p.succes, titre: '$faites leçons faites dans cette matière'),
      _Ligne(icone: Icons.local_fire_department_rounded, couleur: p.prim, titre: 'Meilleur combo : ${prog.meilleurCombo} d\'affilée'),
      _Ligne(icone: Icons.favorite_rounded, couleur: p.erreur, titre: '${prog.coeursActuels} cœurs sur $kCoeursMax'),
    ]);
  }
}

/// Une carte « carton » colorée : titre, phrase, bouton.
class _CarteAction extends StatelessWidget {
  const _CarteAction({
    required this.couleur,
    required this.icone,
    required this.titre,
    required this.texte,
    required this.bouton,
    required this.surAppui,
    this.secondaire,
  });
  final Color couleur;
  final IconData icone;
  final String titre;
  final String texte;
  final String bouton;
  final VoidCallback surAppui;
  final (String, VoidCallback)? secondaire;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.bord, width: 2),
        boxShadow: [BoxShadow(color: p.bord, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: couleur.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(14)),
            child: Icon(icone, color: couleur, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(titre, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(texte, style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, height: 1.3)),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: BoutonKunfox(libelle: bouton, couleur: couleur, hauteur: 46, surAppui: surAppui)),
          if (secondaire != null) ...[
            const SizedBox(width: 10),
            BoutonKunfox(
              libelle: secondaire!.$1,
              contour: true,
              hauteur: 46,
              largeurPleine: false,
              couleur: couleur,
              surAppui: secondaire!.$2,
            ),
          ],
        ]),
      ]),
    );
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

    return PageIOS(titre: 'Quêtes du jour', sousTitre: 'Elles se renouvellent chaque matin.', margeBas: margeBas(context), enfants: [
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

    return PageIOS(titre: 'Profil', margeBas: margeBas(context), enfants: [
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
            builder: (context, majour) {
              final h = Rappels.heureChoisie;
              return Column(children: [
                SwitchListTile(
                  value: Rappels.actifs,
                  onChanged: (v) async {
                    if (v && !Rappels.demandeFaite) {
                      await Rappels.demanderAutorisation();
                    }
                    await Rappels.activer(v);
                    majour(() {});
                  },
                  title: const Text('Rappels de Kunfox'),
                  subtitle: Text('Ta leçon du jour, et ta série quand elle est en danger', style: TextStyle(color: p.doux)),
                  secondary: Icon(Icons.notifications_active_rounded, color: p.doux),
                  activeThumbColor: p.prim,
                ),
                if (Rappels.actifs)
                  ListTile(
                    leading: const SizedBox(width: 24),
                    title: Text(h == null ? 'Heure : Kunfox choisit pour toi' : 'Heure : ${h.split(':')[0]} h ${h.split(':')[1].padLeft(2, '0')}'),
                    trailing: Icon(Icons.schedule_rounded, color: p.doux),
                    onTap: () async {
                      final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 18, minute: 30));
                      if (t != null) {
                        await Rappels.choisirHeure(t.hour, t.minute);
                        majour(() {});
                      }
                    },
                  ),
              ]);
            },
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
          StatefulBuilder(
            builder: (context, majour) => ListTile(
              leading: Icon(Icons.water_drop_rounded, color: const Color(0xFF2F6BFF)),
              title: Text(CompteDroplet.connecte ? 'Connecté avec Droplet' : 'Se connecter avec Droplet'),
              subtitle: Text(
                CompteDroplet.connecte
                    ? 'Ta progression est sauvegardée, chiffrée. Tu la retrouves sur un autre téléphone.'
                    : 'Pour sauvegarder ta progression et la retrouver sur un autre téléphone.',
                style: TextStyle(color: p.doux),
              ),
              trailing: CompteDroplet.connecte
                  ? Icon(Icons.check_circle_rounded, color: p.succes)
                  : Icon(Icons.chevron_right_rounded, color: p.doux),
              onTap: CompteDroplet.connecte
                  ? () async {
                      await CompteDroplet.envoyer();
                      majour(() {});
                    }
                  : () => CompteDroplet.demarrer(),
            ),
          ),
          Divider(height: 1, color: p.bord),
          ListTile(
            leading: Icon(Icons.groups_rounded, color: p.info),
            title: const Text('Réviser ensemble sur Droplet'),
            subtitle: Text('Discute et révise avec tes amis dans Droplet', style: TextStyle(color: p.doux)),
            trailing: Icon(Icons.open_in_new_rounded, color: p.doux, size: 20),
            onTap: CompteDroplet.ouvrirDroplet,
          ),
          Divider(height: 1, color: p.bord),
          ListTile(
            leading: Icon(Icons.ios_share_rounded, color: p.prim),
            title: const Text('Partager ma progression'),
            onTap: () => Share.share(
              '🔥 ${prog.serieActuelle} jour${prog.serieActuelle > 1 ? 's' : ''} de série et ${prog.xp} XP sur Kunfox ! '
              'Viens réviser ton BAC avec moi : https://kunfox.dropletmesh.app',
            ),
          ),
        ]),
      ),
    ]);
  }
}
