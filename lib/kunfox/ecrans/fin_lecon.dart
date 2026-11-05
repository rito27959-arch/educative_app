// ============================================================================
// FIN DE LEÇON, puis SÉRIE.
// ----------------------------------------------------------------------------
// 1. « Leçon terminée ! » : Kunfox fait la fête, pluie de confettis Flame,
//    trois cartes qui comptent (XP, précision, temps). Niveau supérieur :
//    le badge Rive et le nouveau niveau.
// 2. Si c'est la première leçon du jour : l'écran de série — la flamme Rive
//    s'allume, le chiffre de la série monte, la semaine se coche.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/kunfox/kunfox_rive.dart';
import '../composants/bouton.dart';
import '../composants/carte_partage.dart';
import '../composants/fond_anime.dart';
import '../composants/sons.dart';
import '../../core/services/storage_service.dart';
import '../donnees/progression.dart';
import '../donnees/rappels.dart';
import '../flame/effets_flame.dart';
import '../pub/publicites.dart';
import '../theme/palette.dart';

class FinLeconEcran extends ConsumerStatefulWidget {
  const FinLeconEcran({super.key, required this.bilan});
  final BilanLecon bilan;

  @override
  ConsumerState<FinLeconEcran> createState() => _FinLeconEcranState();
}

class _FinLeconEcranState extends ConsumerState<FinLeconEcran> with TickerProviderStateMixin {
  final _confettis = ConfettisControleur();
  late final AnimationController _entree = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..forward();
  bool _serie = false;
  bool _xpDouble = false;

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
    Sons.jouer(Son.fin);
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _confettis.pluie(nombre: widget.bilan.precision == 100 ? 130 : 80);
    });
  }

  @override
  void dispose() {
    _entree.dispose();
    super.dispose();
  }

  Future<void> _suite() async {
    if (!_serie && widget.bilan.premiereDuJour) {
      setState(() => _serie = true);
      return;
    }
    // Après la toute première leçon : Kunfox demande s'il peut rappeler
    // l'élève — au moment où l'envie est là, pas au lancement de l'app.
    if (!Rappels.demandeFaite) await _proposerRappels();
    // Pub plein écran éventuelle, en quittant (jamais au milieu d'un effort).
    await Publicites.apresLecon(premiereDuJour: widget.bilan.premiereDuJour);
    if (mounted) context.go('/k');
  }

  Future<void> _doublerXp() async {
    final gagne = await Publicites.regarderPourRecompense();
    if (!gagne || !mounted) return;
    ref.read(progressionProvider.notifier).bonusXp(widget.bilan.xp);
    setState(() => _xpDouble = true);
    HapticFeedback.mediumImpact();
    Sons.jouer(Son.juste);
    _confettis.pluie(nombre: 60);
  }

  void _partager() {
    final b = widget.bilan;
    final serie = ref.read(progressionProvider).serie;
    partagerCarte(
      context,
      CartePartage(
        bandeau: b.precision == 100 ? 'SANS FAUTE' : (b.chapitreFini ? 'CHAPITRE FINI' : null),
        titre: b.chapitreFini ? 'Chapitre terminé !' : (b.precision == 100 ? 'Sans faute !' : 'Leçon terminée !'),
        sousTitre: serie > 1 ? '$serie jours de série d\'affilée 🔥' : 'Une leçon de plus vers le bac',
        stats: [
          StatCarte(Icons.bolt_rounded, '+${b.xp}', 'XP'),
          StatCarte(Icons.track_changes_rounded, '${b.precision} %', 'PRÉCISION'),
          StatCarte(Icons.local_fire_department_rounded, '$serie', 'SÉRIE'),
        ],
      ),
      texte: 'Je révise le bac avec Kunfox : ${b.precision} % à ma dernière leçon. Viens réviser avec moi ! https://kunfox.dropletmesh.app',
    );
  }

  Future<void> _proposerRappels() async {
    final p = Palette.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const KunfoxMascotte(humeur: HumeurKunfox.salut, taille: 150),
            Text('Je te rappelle demain ?', style: Theme.of(ctx).textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Un petit mot à l\'heure où tu révises d\'habitude, et un rappel le soir si ta série est en danger. Jamais plus.',
              textAlign: TextAlign.center,
              style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, height: 1.4),
            ),
            const SizedBox(height: 20),
            BoutonKunfox(
              libelle: 'Oui, rappelle-moi',
              surAppui: () async {
                Navigator.of(ctx).pop();
                await Rappels.demanderAutorisation();
              },
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await StorageService.setString('kunfox.rappels.demande', '1');
                await Rappels.activer(false);
              },
              child: Text('PLUS TARD', style: TextStyle(color: p.doux, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final b = widget.bilan;
    final niveauSup = b.niveauApres > b.niveauAvant;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (fait, _) {
        if (!fait) context.go('/k');
      },
      child: Scaffold(
        body: Stack(children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: FondRayons(
                key: ValueKey(_serie),
                couleur: _serie ? p.prim : p.or,
                centre: Alignment(0, _serie ? -0.42 : -0.38),
              ),
            ),
          ),
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 420),
              child: _serie
                  ? _Serie(key: const ValueKey('serie'), bilan: b, surContinuer: _suite)
                  : Padding(
                      key: const ValueKey('fin'),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      child: Column(children: [
                        const Spacer(),
                        SizedBox(
                          height: 260,
                          child: Stack(alignment: Alignment.center, children: [
                            if (niveauSup || b.chapitreFini) const KunfoxEffet.niveau(taille: 280),
                            const KunfoxMascotte(humeur: HumeurKunfox.fete, taille: 200),
                          ]),
                        ),
                        const SizedBox(height: 8),
                        _Apparait(
                          controleur: _entree,
                          debut: 0.15,
                          child: Text(
                            b.chapitreFini
                                ? 'Chapitre terminé !'
                                : niveauSup
                                    ? 'Niveau ${b.niveauApres} !'
                                    : b.precision == 100
                                        ? 'Sans faute !'
                                        : 'Leçon terminée !',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 32, color: p.or),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(children: [
                          Expanded(
                            child: _Apparait(
                              controleur: _entree,
                              debut: 0.3,
                              child: _Carte(
                                key: ValueKey(_xpDouble),
                                titre: _xpDouble ? 'XP DOUBLÉS' : 'XP GAGNÉS',
                                couleur: p.or,
                                valeur: _xpDouble ? b.xp * 2 : b.xp,
                                format: (v) => '$v',
                                icone: Icons.bolt_rounded,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _Apparait(
                              controleur: _entree,
                              debut: 0.42,
                              child: _Carte(
                                titre: b.precision >= 90 ? 'IMPRESSIONNANT' : 'PRÉCISION',
                                couleur: p.succes,
                                valeur: b.precision,
                                format: (v) => '$v %',
                                icone: Icons.track_changes_rounded,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _Apparait(
                              controleur: _entree,
                              debut: 0.54,
                              child: _Carte(
                                titre: 'TEMPS',
                                couleur: p.info,
                                valeur: b.duree.inSeconds,
                                format: (v) => '${v ~/ 60}:${(v % 60).toString().padLeft(2, '0')}',
                                icone: Icons.timer_rounded,
                              ),
                            ),
                          ),
                        ]),
                        const Spacer(),
                        if (Publicites.configurees && !_xpDouble)
                          ValueListenableBuilder<bool>(
                            valueListenable: Publicites.recompensePrete,
                            builder: (_, prete, _) => !prete
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: BoutonKunfox(
                                      libelle: 'Doubler mes XP (+${b.xp}) avec une pub',
                                      icone: Icons.play_circle_fill_rounded,
                                      couleur: p.or,
                                      contour: true,
                                      surAppui: _doublerXp,
                                    ),
                                  ),
                          ),
                        Row(children: [
                          BoutonKunfox(
                            libelle: '',
                            etiquette: 'Partager mon résultat',
                            icone: Icons.ios_share_rounded,
                            contour: true,
                            largeurPleine: false,
                            surAppui: _partager,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: BoutonKunfox(libelle: 'Continuer', surAppui: _suite)),
                        ]),
                      ]),
                    ),
            ),
          ),
          Positioned.fill(child: ConfettisFlame(controleur: _confettis)),
        ]),
      ),
    );
  }
}

/// Glisse et apparaît à son tour, avec un léger rebond.
class _Apparait extends StatelessWidget {
  const _Apparait({required this.controleur, required this.debut, required this.child});
  final AnimationController controleur;
  final double debut;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final a = CurvedAnimation(parent: controleur, curve: Interval(debut, (debut + 0.35).clamp(0.0, 1.0), curve: const Cubic(0.34, 1.56, 0.64, 1)));
    return AnimatedBuilder(
      animation: a,
      builder: (context, enfant) => Opacity(
        opacity: a.value.clamp(0.0, 1.0),
        child: Transform.translate(offset: Offset(0, 24 * (1 - a.value)), child: enfant),
      ),
      child: child,
    );
  }
}

/// Carte de chiffre : le nombre compte depuis zéro.
class _Carte extends StatelessWidget {
  const _Carte({super.key, required this.titre, required this.couleur, required this.valeur, required this.format, required this.icone});
  final String titre;
  final Color couleur;
  final int valeur;
  final String Function(int) format;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      decoration: BoxDecoration(color: couleur, borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.all(3),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: FittedBox(
            child: Text(titre, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8, color: Colors.white)),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(15)),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: valeur.toDouble()),
            duration: const Duration(milliseconds: 1100),
            curve: const Cubic(0.16, 1, 0.3, 1),
            builder: (context, v, _) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icone, color: couleur, size: 20),
              const SizedBox(width: 4),
              Flexible(
                child: FittedBox(
                  child: Text(format(v.round()), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: couleur)),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ------------------------------------------------------------------ série
class _Serie extends ConsumerStatefulWidget {
  const _Serie({super.key, required this.bilan, required this.surContinuer});
  final BilanLecon bilan;
  final VoidCallback surContinuer;

  @override
  ConsumerState<_Serie> createState() => _SerieState();
}

class _SerieState extends ConsumerState<_Serie> {
  bool _allumee = false;

  @override
  void initState() {
    super.initState();
    // la flamme s'allume un instant après l'arrivée de l'écran
    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      Sons.jouer(Son.flamme);
      setState(() => _allumee = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final prog = ref.watch(progressionProvider);
    final b = widget.bilan;
    const jours = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final auj = DateTime.now();
    final lundi = auj.subtract(Duration(days: auj.weekday - 1));

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(children: [
        const Spacer(),
        KunfoxFlamme(allumee: _allumee, taille: 180),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: b.serieAvant.toDouble(), end: _allumee ? b.serieApres.toDouble() : b.serieAvant.toDouble()),
          duration: const Duration(milliseconds: 700),
          curve: const Cubic(0.34, 1.56, 0.64, 1),
          builder: (context, v, _) => Text('${v.round()}',
              style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 84, height: 1, color: p.prim)),
        ),
        Text(b.serieApres > 1 ? 'jours de série !' : 'jour de série !',
            style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 26, color: p.prim)),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: p.bord, width: 2),
          ),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              for (var i = 0; i < 7; i++)
                Builder(builder: (context) {
                  final d = lundi.add(Duration(days: i));
                  final cle = jourDe(d);
                  final fait = (prog.xpParJour[cle] ?? 0) > 0;
                  final estAuj = cle == jourDe(auj);
                  return Column(children: [
                    Text(jours[i], style: TextStyle(fontWeight: FontWeight.w800, color: estAuj ? p.prim : p.doux)),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300 + i * 60),
                      curve: const Cubic(0.34, 1.56, 0.64, 1),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: fait && (_allumee || !estAuj) ? p.prim : p.verrou,
                      ),
                      child: fait && (_allumee || !estAuj) ? const Icon(Icons.check_rounded, color: Colors.white, size: 20) : null,
                    ),
                  ]);
                }),
            ]),
            const SizedBox(height: 14),
            Text(
              'Reviens demain pour que ta flamme continue de brûler. Une leçon par jour suffit.',
              textAlign: TextAlign.center,
              style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, height: 1.4),
            ),
          ]),
        ),
        const Spacer(),
        BoutonKunfox(libelle: 'Continuer', surAppui: widget.surContinuer),
      ]),
    );
  }
}
