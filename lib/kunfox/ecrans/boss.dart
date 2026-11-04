// ============================================================================
// L'ÉPREUVE DE L'UNITÉ — le « grand boss » au bout de chaque unité.
// ----------------------------------------------------------------------------
// 1. L'entrée : le trophée tombe du ciel, rebondit et brille ; les règles
//    (10 questions, 3 vies, 70 % pour gagner) en cartes.
// 2. L'épreuve (seance.dart, mode boss) : 3 vies, la barre en or.
// 3. Le verdict : le trophée se remplit d'or, tourne et s'illumine, les XP
//    comptent, confettis — ou Kunfox encourage et propose de réessayer.
// Et la fiche d'une unité (le bouton livre de la bannière), en feuille iOS.
// ============================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/curriculum_data.dart';
import '../../core/data/quiz_data.dart';
import '../../core/models/curriculum_models.dart';
import '../../shared/widgets/kunfox/kunfox_rive.dart';
import '../composants/bouton.dart';
import '../composants/carte_partage.dart';
import '../composants/fond_anime.dart';
import '../composants/sons.dart';
import '../donnees/progression.dart';
import '../flame/effets_flame.dart';
import '../theme/palette.dart';

const _ressort = Cubic(0.34, 1.56, 0.64, 1);
const _doux = Cubic(0.16, 1, 0.3, 1);
const _or = Color(0xFFFFC24B);
const _orFonce = Color(0xFFE59A12);
const _pourpre = Color(0xFF2A1240);

// ===================================================================== trophée
/// Le trophée de l'épreuve : or brillant (gagné), couleur de l'unité
/// (ouvert) ou gris. Un reflet passe dessus de temps en temps.
class TropheeBoss extends StatefulWidget {
  const TropheeBoss({super.key, required this.taille, this.dore = true, this.reflet = true, this.couleur});
  final double taille;
  final bool dore;
  final bool reflet;
  final Color? couleur;

  @override
  State<TropheeBoss> createState() => _TropheeBossState();
}

class _TropheeBossState extends State<TropheeBoss> with SingleTickerProviderStateMixin {
  late final AnimationController _t = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200));

  @override
  void initState() {
    super.initState();
    if (widget.reflet) _t.repeat();
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.taille;
    final haut = widget.dore ? const Color(0xFFFFE08A) : (widget.couleur ?? const Color(0xFF9AA3B5));
    final bas = widget.dore ? _orFonce : Palette.fonce(widget.couleur ?? const Color(0xFF9AA3B5), 0.25);
    return AnimatedBuilder(
      animation: _t,
      builder: (context, _) {
        // le reflet traverse pendant le premier tiers, puis se repose
        final x = (_t.value * 3).clamp(0.0, 1.0) * 3 - 1.5;
        return SizedBox(
          width: t,
          height: t,
          child: Stack(alignment: Alignment.center, children: [
            // socle « carton » : une ombre pleine décalée dessous
            Transform.translate(
              offset: Offset(0, t * 0.05),
              child: Icon(Icons.emoji_events_rounded, size: t * 0.92, color: Palette.fonce(bas, 0.3)),
            ),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (r) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.reflet
                    ? [haut, bas, Colors.white.withValues(alpha: 0.95), bas, bas]
                    : [haut, bas],
                stops: widget.reflet ? [0, (x + 0.35).clamp(0.0, 1.0), (x + 0.45).clamp(0.0, 1.0), (x + 0.55).clamp(0.0, 1.0), 1] : null,
              ).createShader(r),
              child: Icon(Icons.emoji_events_rounded, size: t * 0.92, color: Colors.white),
            ),
          ]),
        );
      },
    );
  }
}

// ===================================================================== entrée
class BossEntreeEcran extends ConsumerStatefulWidget {
  const BossEntreeEcran({super.key, required this.chapitreId});
  final String chapitreId;

  @override
  ConsumerState<BossEntreeEcran> createState() => _BossEntreeEcranState();
}

class _BossEntreeEcranState extends ConsumerState<BossEntreeEcran> with SingleTickerProviderStateMixin {
  late final AnimationController _entree = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
    ..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 520), () {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      Sons.jouer(Son.flamme);
    });
  }

  @override
  void dispose() {
    _entree.dispose();
    super.dispose();
  }

  Animation<double> _iv(double a, double b, [Curve c = _doux]) =>
      CurvedAnimation(parent: _entree, curve: Interval(a, b, curve: c));

  @override
  Widget build(BuildContext context) {
    final prog = ref.watch(progressionProvider);
    final chapitre = CurriculumData.findChapterById(widget.chapitreId);
    final nb = math.min(10, QuizData.getQuestionsForChapter(widget.chapitreId).length);
    final record = prog.scoreBoss(widget.chapitreId);
    final gagne = prog.bossReussi(widget.chapitreId);

    return Scaffold(
      backgroundColor: _pourpre,
      body: Stack(children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4A1D5E), _pourpre, Palette.nuit],
              ),
            ),
          ),
        ),
        const Positioned.fill(child: FondRayons(couleur: _or, centre: Alignment(0, -0.3))),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Fermer',
                  onPressed: () => context.canPop() ? context.pop() : context.go('/k'),
                  icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 30),
                ),
              ),
              const Spacer(),
              // le trophée tombe, écrase, rebondit
              AnimatedBuilder(
                animation: _entree,
                builder: (context, enfant) {
                  final chute = _iv(0, 0.42, Curves.bounceOut).value;
                  final apparu = _iv(0, 0.12).value;
                  return Opacity(
                    opacity: apparu,
                    child: Transform.translate(offset: Offset(0, -260 * (1 - chute)), child: enfant),
                  );
                },
                child: const _Flottant(child: TropheeBoss(taille: 168)),
              ),
              const SizedBox(height: 10),
              _Monte(
                a: _iv(0.35, 0.75),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(color: _or, borderRadius: BorderRadius.circular(99)),
                    child: const Text('ÉPREUVE DE L\'UNITÉ',
                        style: TextStyle(fontWeight: FontWeight.w800, color: Palette.nuit, letterSpacing: 1.6, fontSize: 12)),
                  ),
                  const SizedBox(height: 12),
                  Text(chapitre?.title ?? 'Unité',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 28, height: 1.1, color: Colors.white)),
                  if (record != null) ...[
                    const SizedBox(height: 6),
                    Text(gagne ? 'Remportée · meilleur score $record %' : 'Meilleur score : $record %',
                        style: TextStyle(fontWeight: FontWeight.w700, color: gagne ? _or : Colors.white60)),
                  ],
                ]),
              ),
              const SizedBox(height: 22),
              Row(children: [
                Expanded(child: _Monte(a: _iv(0.5, 0.85, _ressort), child: _Regle(icone: Icons.quiz_rounded, valeur: '$nb', libelle: 'questions'))),
                const SizedBox(width: 10),
                Expanded(child: _Monte(a: _iv(0.56, 0.9, _ressort), child: const _Regle(icone: Icons.favorite_rounded, valeur: '3', libelle: 'vies', couleur: Color(0xFFFF5A5F)))),
                const SizedBox(width: 10),
                Expanded(child: _Monte(a: _iv(0.62, 0.96, _ressort), child: const _Regle(icone: Icons.bolt_rounded, valeur: '+50', libelle: 'XP'))),
              ]),
              const SizedBox(height: 14),
              _Monte(
                a: _iv(0.7, 1),
                child: Text(
                  'Tout ce que tu as vu dans l\'unité. $kSeuilBoss % de bonnes réponses pour remporter le trophée d\'or.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, height: 1.4),
                ),
              ),
              const Spacer(),
              _Monte(
                a: _iv(0.78, 1),
                child: BoutonKunfox(
                  libelle: gagne ? 'Rejouer l\'épreuve' : 'Commencer l\'épreuve',
                  couleur: _or,
                  couleurTexte: Palette.nuit,
                  surAppui: nb == 0
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          context.pushReplacement('/k/boss-seance/${widget.chapitreId}');
                        },
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _Flottant extends StatefulWidget {
  const _Flottant({required this.child});
  final Widget child;
  @override
  State<_Flottant> createState() => _FlottantState();
}

class _FlottantState extends State<_Flottant> with SingleTickerProviderStateMixin {
  late final AnimationController _t = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))
    ..repeat(reverse: true);
  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _t,
        builder: (context, enfant) =>
            Transform.translate(offset: Offset(0, -6 * Curves.easeInOut.transform(_t.value)), child: enfant),
        child: widget.child,
      );
}

class _Monte extends StatelessWidget {
  const _Monte({required this.a, required this.child});
  final Animation<double> a;
  final Widget child;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: a,
        builder: (context, enfant) => Opacity(
          opacity: a.value.clamp(0.0, 1.0),
          child: Transform.translate(offset: Offset(0, 22 * (1 - a.value)), child: enfant),
        ),
        child: child,
      );
}

class _Regle extends StatelessWidget {
  const _Regle({required this.icone, required this.valeur, required this.libelle, this.couleur = _or});
  final IconData icone;
  final String valeur, libelle;
  final Color couleur;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14), width: 2),
        ),
        child: Column(children: [
          Icon(icone, color: couleur, size: 24),
          const SizedBox(height: 4),
          Text(valeur, style: const TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 22, color: Colors.white)),
          Text(libelle.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.8, color: Colors.white60)),
        ]),
      );
}

// ===================================================================== verdict
class BossFinEcran extends ConsumerStatefulWidget {
  const BossFinEcran({super.key, required this.bilan});
  final BilanBoss bilan;

  @override
  ConsumerState<BossFinEcran> createState() => _BossFinEcranState();
}

class _BossFinEcranState extends ConsumerState<BossFinEcran> with TickerProviderStateMixin {
  final _confettis = ConfettisControleur();
  late final AnimationController _t = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))
    ..forward();

  @override
  void initState() {
    super.initState();
    final b = widget.bilan;
    if (b.reussi) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        HapticFeedback.heavyImpact();
        Sons.jouer(Son.fin);
        _confettis.pluie(nombre: 160);
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) _confettis.pluie(nombre: 80);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        HapticFeedback.mediumImpact();
        Sons.jouer(Son.faux);
      });
    }
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  void _partager() {
    final b = widget.bilan;
    final ch = CurriculumData.findChapterById(b.chapitreId);
    partagerCarte(
      context,
      CartePartage(
        bandeau: 'TROPHÉE D\'OR',
        titre: 'Unité remportée !',
        sousTitre: ch?.title ?? 'Épreuve de l\'unité',
        stats: [
          StatCarte(Icons.check_circle_rounded, '${b.bonnes}/${b.total}', 'BONNES'),
          StatCarte(Icons.track_changes_rounded, '${b.precision} %', 'PRÉCISION'),
          StatCarte(Icons.bolt_rounded, '+${b.xp}', 'XP'),
        ],
      ),
      texte: 'J\'ai remporté l\'épreuve « ${ch?.title ?? 'de l\'unité'} » sur Kunfox avec ${b.precision} % ! https://kunfox.dropletmesh.app',
    );
  }

  Future<void> _continuer() async {
    final b = widget.bilan;
    if (b.lecon.premiereDuJour) {
      // la flamme de série, comme après une leçon
      context.pushReplacement('/k/fin', extra: b.lecon);
      return;
    }
    context.go('/k');
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final b = widget.bilan;
    final ch = CurriculumData.findChapterById(b.chapitreId);
    Animation<double> iv(double a, double z, [Curve c = _doux]) => CurvedAnimation(parent: _t, curve: Interval(a, z, curve: c));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (fait, _) {
        if (!fait) context.go('/k');
      },
      child: Scaffold(
        backgroundColor: b.reussi ? _pourpre : p.fond,
        body: Stack(children: [
          if (b.reussi)
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF4A1D5E), _pourpre, Palette.nuit],
                  ),
                ),
              ),
            ),
          Positioned.fill(child: FondRayons(couleur: b.reussi ? _or : p.info, intensite: b.reussi ? 1.2 : 0.6)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(children: [
                const Spacer(),
                if (b.reussi)
                  // le trophée grandit en tournant, puis l'or s'allume
                  AnimatedBuilder(
                    animation: _t,
                    builder: (context, _) {
                      final e = iv(0, 0.45, _ressort).value;
                      final tour = iv(0, 0.45).value;
                      final dore = _t.value > 0.32;
                      return Transform.rotate(
                        angle: (1 - tour) * math.pi * 2,
                        child: Transform.scale(
                          scale: 0.2 + 0.8 * e,
                          child: Stack(alignment: Alignment.center, children: [
                            if (dore)
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: _or.withValues(alpha: 0.45), blurRadius: 60, spreadRadius: 6)],
                                ),
                              ),
                            const KunfoxEffet.niveau(taille: 260),
                            TropheeBoss(taille: 180, dore: dore, couleur: const Color(0xFF8B5CF6)),
                          ]),
                        ),
                      );
                    },
                  )
                else
                  const KunfoxMascotte(humeur: HumeurKunfox.courage, taille: 200),
                const SizedBox(height: 8),
                _Monte(
                  a: iv(0.4, 0.7, _ressort),
                  child: Text(
                    b.reussi ? (b.dejaReussi ? 'Encore gagné !' : 'Unité remportée !') : 'Presque !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 34, color: b.reussi ? _or : p.prim),
                  ),
                ),
                const SizedBox(height: 6),
                _Monte(
                  a: iv(0.48, 0.78),
                  child: Text(
                    b.reussi
                        ? (b.dejaReussi
                            ? '« ${ch?.title ?? ''} » : tu tiens toujours la distance.'
                            : 'Le trophée de « ${ch?.title ?? 'l\'unité'} » est à toi. Il brille désormais sur ton parcours.')
                        : 'Il fallait $kSeuilBoss % : tu en as eu ${b.precision}. Revois une ou deux leçons, puis retente ta chance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: b.reussi ? Colors.white70 : p.doux, fontWeight: FontWeight.w600, fontSize: 15, height: 1.4),
                  ),
                ),
                const SizedBox(height: 22),
                Row(children: [
                  Expanded(
                    child: _Monte(
                      a: iv(0.55, 0.85, _ressort),
                      child: _Chiffre(sombre: b.reussi, couleur: _or, icone: Icons.bolt_rounded, titre: 'XP', fin: b.xp, format: (v) => '+$v'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Monte(
                      a: iv(0.62, 0.92, _ressort),
                      child: _Chiffre(
                          sombre: b.reussi,
                          couleur: p.succes,
                          icone: Icons.check_circle_rounded,
                          titre: 'BONNES',
                          fin: b.bonnes,
                          format: (v) => '$v/${b.total}'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Monte(
                      a: iv(0.69, 0.99, _ressort),
                      child: _Chiffre(
                          sombre: b.reussi,
                          couleur: p.info,
                          icone: Icons.track_changes_rounded,
                          titre: 'PRÉCISION',
                          fin: b.precision,
                          format: (v) => '$v %'),
                    ),
                  ),
                ]),
                const Spacer(),
                if (b.reussi)
                  Row(children: [
                    BoutonKunfox(
                      libelle: '',
                      etiquette: 'Partager ma victoire',
                      icone: Icons.ios_share_rounded,
                      contour: true,
                      largeurPleine: false,
                      surAppui: _partager,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: BoutonKunfox(libelle: 'Continuer', couleur: _or, couleurTexte: Palette.nuit, surAppui: _continuer)),
                  ])
                else ...[
                  BoutonKunfox(
                    libelle: 'Réessayer',
                    surAppui: () => context.pushReplacement('/k/boss/${b.chapitreId}'),
                  ),
                  const SizedBox(height: 10),
                  BoutonKunfox(libelle: 'Revoir les leçons', contour: true, surAppui: _continuer),
                ],
              ]),
            ),
          ),
          Positioned.fill(child: ConfettisFlame(controleur: _confettis)),
        ]),
      ),
    );
  }
}

class _Chiffre extends StatelessWidget {
  const _Chiffre({
    required this.sombre,
    required this.couleur,
    required this.icone,
    required this.titre,
    required this.fin,
    required this.format,
  });
  final bool sombre;
  final Color couleur;
  final IconData icone;
  final String titre;
  final int fin;
  final String Function(int) format;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      decoration: BoxDecoration(color: couleur, borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.all(3),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(titre,
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.8, color: couleur == _or ? Palette.nuit : Colors.white)),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: sombre ? const Color(0xFF1E1530) : p.surface, borderRadius: BorderRadius.circular(15)),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: fin.toDouble()),
            duration: const Duration(milliseconds: 1300),
            curve: _doux,
            builder: (context, v, _) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icone, color: couleur, size: 18),
              const SizedBox(width: 3),
              Flexible(
                child: FittedBox(
                  child: Text(format(v.round()), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19, color: couleur)),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ============================================================ fiche d'unité
/// La fiche d'une unité, en feuille iOS : ce qu'on y apprend, les leçons
/// (faites ou non) et l'épreuve.
Future<void> montrerFicheUnite(BuildContext context, {required CurriculumChapter chapitre, required int numero}) {
  final p = Palette.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: p.fond,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (ctx, defile) => Consumer(builder: (ctx, ref, _) {
        final prog = ref.watch(progressionProvider);
        final lecons = [...chapitre.lessons]..sort((a, b) => a.order.compareTo(b.order));
        final faites = lecons.where((l) => prog.leconsFaites.contains(l.id)).length;
        final gagne = prog.bossReussi(chapitre.id);
        return ListView(controller: defile, padding: const EdgeInsets.fromLTRB(20, 10, 20, 28), children: [
          Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: p.bord, borderRadius: BorderRadius.circular(9)))),
          const SizedBox(height: 16),
          Text('UNITÉ $numero', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2, color: p.prim, fontSize: 13)),
          const SizedBox(height: 4),
          Text(chapitre.title, style: const TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 28, height: 1.1)),
          if (chapitre.subtitle.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(chapitre.subtitle, style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, fontSize: 15, height: 1.4)),
          ],
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: LinearProgressIndicator(
              value: lecons.isEmpty ? 0 : faites / lecons.length,
              minHeight: 12,
              backgroundColor: p.verrou,
              color: p.succes,
            ),
          ),
          const SizedBox(height: 6),
          Text('$faites leçon${faites > 1 ? 's' : ''} sur ${lecons.length}', style: TextStyle(color: p.doux, fontWeight: FontWeight.w700)),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: p.bord, width: 2),
            ),
            child: Column(children: [
              for (final (i, l) in lecons.indexed) ...[
                if (i > 0) Divider(height: 1, indent: 56, color: p.bord),
                ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: prog.leconsFaites.contains(l.id) ? p.succes : p.verrou,
                    child: prog.leconsFaites.contains(l.id)
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                        : Text('${i + 1}', style: TextStyle(fontWeight: FontWeight.w800, color: p.doux)),
                  ),
                  title: Text(l.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  trailing: prog.scores[l.id] != null
                      ? Text('${prog.scores[l.id]} %', style: TextStyle(color: p.doux, fontWeight: FontWeight.w700))
                      : null,
                ),
              ],
            ]),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: gagne ? _or.withValues(alpha: 0.16) : p.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: gagne ? _or : p.bord, width: 2),
            ),
            child: Row(children: [
              TropheeBoss(taille: 44, dore: gagne, reflet: gagne),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Épreuve de l\'unité', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  Text(
                    gagne
                        ? 'Remportée · ${prog.scoreBoss(chapitre.id)} %'
                        : 'Ouverte à la moitié des leçons · $kSeuilBoss % pour gagner',
                    style: TextStyle(color: p.doux, fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
            ]),
          ),
        ]);
      }),
    ),
  );
}
