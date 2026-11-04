// ============================================================================
// DUELS : défier un ami sur la même leçon.
// ----------------------------------------------------------------------------
// 1. L'entrée : les deux joueurs arrivent de chaque côté, « VS » claque au
//    milieu, puis le compte à rebours 3, 2, 1, C'EST PARTI !
// 2. La séance (seance.dart) : les mêmes questions pour tous ; quand on relève
//    un défi, le « fantôme » de l'ami avance en même temps que soi.
// 3. Le résultat : les deux barres font la course, la couronne tombe sur le
//    gagnant, confettis. Le créateur reçoit le lien à partager.
// ============================================================================

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/data/quiz_data.dart';
import '../../core/models/quiz_question.dart';
import '../../shared/widgets/kunfox/kunfox_rive.dart';
import '../composants/bouton.dart';
import '../composants/carte_partage.dart';
import '../composants/fond_anime.dart';
import '../composants/sons.dart';
import '../donnees/compte_droplet.dart';
import '../donnees/duels.dart';
import '../donnees/matieres.dart';
import '../donnees/progression.dart';
import '../flame/effets_flame.dart';
import '../theme/palette.dart';

const violetDuel = Color(0xFF8B5CF6);
const _ressort = Cubic(0.34, 1.56, 0.64, 1);
const _doux = Cubic(0.16, 1, 0.3, 1);

String _secondes(int ms) => '${(ms / 1000).toStringAsFixed(ms < 10000 ? 1 : 0)} s';

/// Prépare un nouveau duel sur la matière en cours et ouvre l'écran d'entrée.
void lancerNouveauDuel(BuildContext context, WidgetRef ref) {
  final matiere = ref.read(matiereActiveProvider);
  if (matiere == null) return;
  final prog = ref.read(progressionProvider);
  final lecons = leconsDe(matiere);
  if (lecons.isEmpty) return;
  final faites = lecons.where((l) => prog.leconsFaites.contains(l.id)).toList();
  // la dernière leçon faite : on se bat sur ce qu'on vient d'apprendre
  final lecon = faites.isNotEmpty ? faites.last : lecons.first;
  final questions = <QuizQuestion>[...QuizData.getQuestionsForLesson(lecon.id, count: 6)];
  for (final l in [...faites.reversed, ...lecons]) {
    if (questions.length >= 6) break;
    if (l.id == lecon.id) continue;
    for (final q in QuizData.getQuestionsForLesson(l.id, count: 2)) {
      if (questions.length < 6 && !questions.any((x) => x.question == q.question)) questions.add(q);
    }
  }
  if (questions.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pas encore de questions pour un duel ici.')));
    return;
  }
  context.push('/k/duel/nouveau',
      extra: PartieDuel(lecon: lecon.id, titre: lecon.title, matiere: matiere.title, questions: questions));
}

// ===================================================================== entrée
class DuelEntreeEcran extends StatefulWidget {
  const DuelEntreeEcran({super.key, this.code, this.partie});

  /// Relever le défi d'un ami…
  final String? code;

  /// …ou lancer le sien.
  final PartieDuel? partie;

  @override
  State<DuelEntreeEcran> createState() => _DuelEntreeEcranState();
}

class _DuelEntreeEcranState extends State<DuelEntreeEcran> with TickerProviderStateMixin {
  late final AnimationController _entree = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  PartieDuel? _partie;
  String? _erreur;
  int? _compte; // 3, 2, 1, 0 = « C'est parti ! »

  @override
  void initState() {
    super.initState();
    if (widget.partie != null) {
      _partie = widget.partie;
      _demarrerEntree();
    } else {
      _charger();
    }
  }

  Future<void> _charger() async {
    setState(() => _erreur = null);
    try {
      final d = await Duels.lire(widget.code!);
      if (!mounted) return;
      setState(() => _partie = PartieDuel(lecon: d.lecon, titre: d.titre, matiere: d.matiere, questions: d.questions, duel: d));
      _demarrerEntree();
    } catch (e) {
      if (mounted) setState(() => _erreur = e.toString());
    }
  }

  void _demarrerEntree() {
    _entree.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 620), () {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      Sons.jouer(Son.flamme);
    });
  }

  Future<void> _partir() async {
    for (final n in [3, 2, 1, 0]) {
      if (!mounted) return;
      setState(() => _compte = n);
      n == 0 ? HapticFeedback.heavyImpact() : HapticFeedback.selectionClick();
      Sons.jouer(n == 0 ? Son.juste : Son.clic);
      await Future<void>.delayed(Duration(milliseconds: n == 0 ? 650 : 720));
    }
    if (mounted) context.pushReplacement('/k/duel-seance', extra: _partie);
  }

  @override
  void dispose() {
    _entree.dispose();
    super.dispose();
  }

  Animation<double> _iv(double a, double b, [Curve c = _ressort]) =>
      CurvedAnimation(parent: _entree, curve: Interval(a, b, curve: c));

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final partie = _partie;
    final adversaire = partie?.duel?.createur;

    return Scaffold(
      backgroundColor: Palette.nuit,
      body: Stack(children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF241A4F), Palette.nuit],
              ),
            ),
          ),
        ),
        const Positioned.fill(child: FondRayons(couleur: violetDuel, centre: Alignment(0, -0.2))),
        SafeArea(
          child: partie == null
              ? _chargement(p)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        tooltip: 'Fermer',
                        onPressed: _compte == null ? () => context.canPop() ? context.pop() : context.go('/k') : null,
                        icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 30),
                      ),
                    ),
                    _Apparition(
                      a: _iv(0, 0.4, _doux),
                      decalage: const Offset(0, -20),
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(color: violetDuel, borderRadius: BorderRadius.circular(99)),
                          child: const Text('DUEL',
                              style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 2, fontSize: 13)),
                        ),
                        const SizedBox(height: 10),
                        Text(partie.titre,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 24, color: Colors.white)),
                        Text('${partie.matiere} · ${partie.questions.length} questions',
                            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white60)),
                      ]),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 230,
                      child: Stack(alignment: Alignment.center, children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _Apparition(
                            a: _iv(0.1, 0.55),
                            decalage: const Offset(-220, 0),
                            child: _CarteJoueur(nom: Duels.monNom(), moi: true),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _Apparition(
                            a: _iv(0.18, 0.62),
                            decalage: const Offset(220, 0),
                            child: adversaire == null
                                ? const _CarteJoueur(nom: 'Tes amis', moi: false, inconnu: true)
                                : _CarteJoueur(nom: adversaire.nom, moi: false, avatar: adversaire.avatar),
                          ),
                        ),
                        _Tampon(a: _iv(0.42, 0.78)),
                      ]),
                    ),
                    const Spacer(),
                    _Apparition(
                      a: _iv(0.6, 1, _doux),
                      decalage: const Offset(0, 24),
                      child: Text(
                        adversaire == null
                            ? 'Joue d\'abord. Ensuite, envoie le lien : tes amis auront exactement les mêmes questions.'
                            : '${adversaire.nom} a eu ${adversaire.bonnes}/${partie.questions.length} en ${_secondes(adversaire.ms)}. À toi de faire mieux !',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16, height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _Apparition(
                      a: _iv(0.7, 1, _doux),
                      decalage: const Offset(0, 24),
                      child: BoutonKunfox(
                        libelle: adversaire == null ? 'C\'est parti' : 'Relever le défi',
                        couleur: violetDuel,
                        surAppui: _compte == null ? _partir : null,
                      ),
                    ),
                  ]),
                ),
        ),
        if (_compte != null) Positioned.fill(child: _CompteARebours(n: _compte!)),
      ]),
    );
  }

  Widget _chargement(Palette p) {
    if (_erreur == null) {
      return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        KunfoxMascotte(humeur: HumeurKunfox.reflexion, taille: 150),
        SizedBox(height: 8),
        Text('On prépare le duel…', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ]));
    }
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const Spacer(),
        const KunfoxMascotte(humeur: HumeurKunfox.courage, taille: 150),
        Text(_erreur!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
        const Spacer(),
        BoutonKunfox(libelle: 'Réessayer', couleur: violetDuel, surAppui: _charger),
        const SizedBox(height: 10),
        BoutonKunfox(libelle: 'Retour', contour: true, surAppui: () => context.go('/k')),
      ]),
    );
  }
}

class _Apparition extends StatelessWidget {
  const _Apparition({required this.a, required this.decalage, required this.child});
  final Animation<double> a;
  final Offset decalage;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: a,
        builder: (context, enfant) => Opacity(
          opacity: a.value.clamp(0.0, 1.0),
          child: Transform.translate(offset: decalage * (1 - a.value), child: enfant),
        ),
        child: child,
      );
}

/// « VS » qui claque : arrive de très gros, écrase, rebondit, tremble.
class _Tampon extends StatelessWidget {
  const _Tampon({required this.a});
  final Animation<double> a;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: a,
        builder: (context, _) {
          final t = a.value;
          if (t <= 0) return const SizedBox.shrink();
          final echelle = 3.2 - 2.2 * t;
          final tremble = t > 0.9 ? 0.0 : math.sin(t * 40) * 4 * (1 - t);
          return Transform.translate(
            offset: Offset(tremble, 0),
            child: Transform.rotate(
              angle: -0.12,
              child: Transform.scale(
                scale: echelle,
                child: Opacity(
                  opacity: t.clamp(0.0, 1.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC24B),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [BoxShadow(color: Color(0xFFB7800F), offset: Offset(0, 5))],
                    ),
                    child: const Text('VS',
                        style: TextStyle(
                            fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 34, color: Palette.nuit, height: 1)),
                  ),
                ),
              ),
            ),
          );
        },
      );
}

class _CarteJoueur extends StatelessWidget {
  const _CarteJoueur({required this.nom, required this.moi, this.avatar = 0, this.inconnu = false});
  final String nom;
  final bool moi;
  final int avatar;
  final bool inconnu;

  @override
  Widget build(BuildContext context) {
    final couleur = moi ? Palette.orange : violetDuel;
    return SizedBox(
      width: 140,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(color: couleur, width: 4),
            boxShadow: [BoxShadow(color: couleur.withValues(alpha: 0.5), blurRadius: 24)],
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: moi
              ? const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: KunfoxMascotte(humeur: HumeurKunfox.joie, taille: 120),
                )
              : inconnu
                  ? const Icon(Icons.question_mark_rounded, color: Colors.white, size: 56)
                  : Text(nom.characters.first.toUpperCase(),
                      style: const TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 54, color: Colors.white)),
        ),
        const SizedBox(height: 10),
        Text(moi ? 'Toi' : nom,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 17)),
      ]),
    );
  }
}

class _CompteARebours extends StatelessWidget {
  const _CompteARebours({required this.n});
  final int n;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Palette.nuit.withValues(alpha: 0.72),
      child: Center(
        child: TweenAnimationBuilder<double>(
          key: ValueKey(n),
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 520),
          curve: _ressort,
          builder: (context, t, _) => Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: 2.4 - 1.4 * t,
              child: Text(
                n == 0 ? 'C\'EST PARTI !' : '$n',
                style: TextStyle(
                  fontFamily: 'InterTight',
                  fontWeight: FontWeight.w800,
                  fontSize: n == 0 ? 44 : 120,
                  color: n == 0 ? const Color(0xFFFFC24B) : Colors.white,
                  shadows: const [Shadow(color: violetDuel, blurRadius: 30)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================== fantôme
/// Pendant la séance : ma barre et celle de l'ami, qui avance au rythme où
/// il avait répondu (le chrono ne tourne que pendant qu'on réfléchit).
class FantomeDuel extends StatefulWidget {
  const FantomeDuel({
    super.key,
    required this.adversaire,
    required this.mesReponses,
    required this.total,
    required this.enCourse,
  });
  final Joueur adversaire;
  final int mesReponses;
  final int total;
  final bool enCourse;

  @override
  State<FantomeDuel> createState() => _FantomeDuelState();
}

class _FantomeDuelState extends State<FantomeDuel> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _avant = Duration.zero, _cumul = Duration.zero;
  int _sesReponses = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((ecoule) {
      final d = ecoule - _avant;
      _avant = ecoule;
      if (!widget.enCourse) return;
      _cumul += d;
      var somme = 0, n = 0;
      for (final t in widget.adversaire.traces) {
        somme += t.$2;
        if (somme <= _cumul.inMilliseconds) n++;
      }
      if (n != _sesReponses) {
        setState(() => _sesReponses = n);
        HapticFeedback.selectionClick();
      }
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    Widget couloir(String nom, int fait, Color c) => Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(children: [
            SizedBox(
              width: 64,
              child: Text(nom,
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: c)),
            ),
            Expanded(
              child: Container(
                height: 10,
                decoration: BoxDecoration(color: p.verrou, borderRadius: BorderRadius.circular(9)),
                alignment: Alignment.centerLeft,
                child: AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 450),
                  curve: _ressort,
                  widthFactor: (fait / math.max(1, widget.total)).clamp(0.0, 1.0),
                  child: Container(decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(9))),
                ),
              ),
            ),
            SizedBox(
              width: 34,
              child: Text('$fait/${widget.total}',
                  textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: p.doux)),
            ),
          ]),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      child: Column(children: [
        couloir('Toi', widget.mesReponses, p.prim),
        couloir(widget.adversaire.nom, _sesReponses, violetDuel),
      ]),
    );
  }
}

// ================================================================= résultat
class DuelFinEcran extends ConsumerStatefulWidget {
  const DuelFinEcran({super.key, required this.partie, required this.moi});
  final PartieDuel partie;
  final Joueur moi;

  @override
  ConsumerState<DuelFinEcran> createState() => _DuelFinEcranState();
}

enum _Issue { victoire, defaite, egalite, enAttente }

class _DuelFinEcranState extends ConsumerState<DuelFinEcran> with TickerProviderStateMixin {
  final _confettis = ConfettisControleur();
  late final AnimationController _course = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
  String? _code;
  String? _erreur;
  bool _envoi = true;

  Joueur? get _adversaire => widget.partie.duel?.createur;

  _Issue get _issue {
    final a = _adversaire;
    if (a == null) return _Issue.enAttente;
    final c = widget.moi.comparer(a);
    return c > 0 ? _Issue.victoire : (c < 0 ? _Issue.defaite : _Issue.egalite);
  }

  @override
  void initState() {
    super.initState();
    _envoyer();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _course.forward();
    });
    // la couronne tombe à la fin de la course
    Future.delayed(const Duration(milliseconds: 2300), () {
      if (!mounted) return;
      if (_issue == _Issue.victoire || (_issue == _Issue.enAttente && widget.moi.bonnes == widget.partie.questions.length)) {
        _confettis.pluie(nombre: 140);
        Sons.jouer(Son.fin);
        HapticFeedback.heavyImpact();
      } else {
        Sons.jouer(_issue == _Issue.defaite ? Son.faux : Son.juste);
        HapticFeedback.mediumImpact();
      }
    });
  }

  Future<void> _envoyer() async {
    setState(() {
      _envoi = true;
      _erreur = null;
    });
    try {
      final d = widget.partie.duel;
      if (d == null) {
        _code = await Duels.creer(widget.partie, widget.moi);
      } else {
        await Duels.repondre(d.code, widget.partie.titre, widget.moi);
        _code = d.code;
      }
    } catch (e) {
      _erreur = e.toString();
    }
    if (mounted) setState(() => _envoi = false);
  }

  @override
  void dispose() {
    _course.dispose();
    super.dispose();
  }

  String get _texteInvitation =>
      'Je te défie sur Kunfox : « ${widget.partie.titre} » (${widget.partie.matiere}). '
      'J\'ai eu ${widget.moi.bonnes}/${widget.partie.questions.length} en ${_secondes(widget.moi.ms)}. Tu fais mieux ? ${lienDuel(_code!)}';

  Future<void> _inviter() async {
    HapticFeedback.mediumImpact();
    await Share.share(_texteInvitation);
  }

  Future<void> _surDroplet() async {
    await Clipboard.setData(ClipboardData(text: _texteInvitation));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Défi copié : colle-le dans ta discussion Droplet.')),
    );
    await CompteDroplet.ouvrirDroplet();
  }

  void _carte() {
    final a = _adversaire;
    final n = widget.partie.questions.length;
    partagerCarte(
      context,
      CartePartage(
        bandeau: 'DUEL',
        content: _issue != _Issue.defaite,
        titre: switch (_issue) {
          _Issue.victoire => 'J\'ai battu ${a!.nom} !',
          _Issue.defaite => '${a!.nom} m\'a battu…',
          _Issue.egalite => 'Égalité parfaite !',
          _Issue.enAttente => 'Qui me bat ?',
        },
        sousTitre: '${widget.partie.titre} · ${widget.partie.matiere}',
        stats: [
          StatCarte(Icons.check_circle_rounded, '${widget.moi.bonnes}/$n', 'BONNES'),
          StatCarte(Icons.timer_rounded, _secondes(widget.moi.ms), 'TEMPS'),
          if (a != null) StatCarte(Icons.sports_kabaddi_rounded, '${a.bonnes}/$n', a.nom.toUpperCase()),
        ],
      ),
      texte: _code == null
          ? 'Je révise le bac avec Kunfox. https://kunfox.dropletmesh.app'
          : 'Duel Kunfox : ${widget.partie.titre}. Tente ta chance : ${lienDuel(_code!)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final n = widget.partie.questions.length;
    final a = _adversaire;
    final issue = _issue;
    final titre = switch (issue) {
      _Issue.victoire => 'Victoire !',
      _Issue.defaite => 'Presque !',
      _Issue.egalite => 'Égalité !',
      _Issue.enAttente => widget.moi.bonnes == n ? 'Sans faute !' : 'Bien joué !',
    };
    final couleurTitre = issue == _Issue.defaite ? violetDuel : p.or;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (fait, _) {
        if (!fait) context.go('/k');
      },
      child: Scaffold(
        body: Stack(children: [
          Positioned.fill(child: FondRayons(couleur: issue == _Issue.defaite ? violetDuel : p.or)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(children: [
                const SizedBox(height: 8),
                KunfoxMascotte(
                  humeur: issue == _Issue.defaite ? HumeurKunfox.courage : HumeurKunfox.fete,
                  taille: 170,
                ),
                AnimatedBuilder(
                  animation: _course,
                  builder: (context, _) {
                    final t = CurvedAnimation(parent: _course, curve: const Interval(0.85, 1, curve: _ressort)).value;
                    return Opacity(
                      opacity: t.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 0.6 + 0.4 * t,
                        child: Text(titre,
                            style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 34, color: couleurTitre)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                _Couloir(
                  course: _course,
                  nom: 'Toi',
                  joueur: widget.moi,
                  total: n,
                  couleur: p.prim,
                  couronne: issue == _Issue.victoire || issue == _Issue.enAttente,
                  retard: 0,
                ),
                const SizedBox(height: 12),
                if (a != null)
                  _Couloir(
                    course: _course,
                    nom: a.nom,
                    joueur: a,
                    total: n,
                    couleur: violetDuel,
                    couronne: issue == _Issue.defaite,
                    retard: 0.06,
                  )
                else
                  _AttenteAmis(code: _code, envoi: _envoi),
                if (a != null && (widget.partie.duel?.adversaires.isNotEmpty ?? false)) ...[
                  const SizedBox(height: 10),
                  Text(
                    '${widget.partie.duel!.adversaires.length} autre${widget.partie.duel!.adversaires.length > 1 ? 's' : ''} ami${widget.partie.duel!.adversaires.length > 1 ? 's ont' : ' a'} aussi relevé ce défi.',
                    style: TextStyle(color: p.doux, fontWeight: FontWeight.w700),
                  ),
                ],
                if (_erreur != null) ...[
                  const SizedBox(height: 12),
                  Text(_erreur!, textAlign: TextAlign.center, style: TextStyle(color: p.erreur, fontWeight: FontWeight.w700)),
                  TextButton(onPressed: _envoyer, child: const Text('Réessayer')),
                ],
                const Spacer(),
                if (a == null && _code != null) ...[
                  BoutonKunfox(libelle: 'Défier mes amis', icone: Icons.send_rounded, couleur: violetDuel, surAppui: _inviter),
                  const SizedBox(height: 10),
                  BoutonKunfox(libelle: 'Envoyer sur Droplet', icone: Icons.water_drop_rounded, contour: true, surAppui: _surDroplet),
                  const SizedBox(height: 10),
                ],
                Row(children: [
                  BoutonKunfox(
                    libelle: '',
                    etiquette: 'Partager mon résultat',
                    icone: Icons.ios_share_rounded,
                    contour: true,
                    largeurPleine: false,
                    surAppui: _carte,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: a == null
                        ? BoutonKunfox(libelle: 'Terminer', surAppui: () => context.go('/k'))
                        : BoutonKunfox(
                            libelle: 'Défier un autre ami',
                            couleur: violetDuel,
                            surAppui: () {
                              context.go('/k');
                              Future.microtask(() {
                                if (mounted) lancerNouveauDuel(context, ref);
                              });
                            },
                          ),
                  ),
                ]),
                if (a != null)
                  TextButton(
                    onPressed: () => context.go('/k'),
                    child: Text('TERMINER', style: TextStyle(color: p.doux, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                  ),
              ]),
            ),
          ),
          Positioned.fill(child: ConfettisFlame(controleur: _confettis)),
        ]),
      ),
    );
  }
}

/// Un couloir de la course : la barre se remplit selon les bonnes réponses,
/// le chiffre compte, la couronne tombe sur le gagnant.
class _Couloir extends StatelessWidget {
  const _Couloir({
    required this.course,
    required this.nom,
    required this.joueur,
    required this.total,
    required this.couleur,
    required this.couronne,
    required this.retard,
  });
  final AnimationController course;
  final String nom;
  final Joueur joueur;
  final int total;
  final Color couleur;
  final bool couronne;
  final double retard;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final remplir = CurvedAnimation(parent: course, curve: Interval(retard, 0.78 + retard, curve: _doux));
    final tombe = CurvedAnimation(parent: course, curve: const Interval(0.82, 1, curve: Curves.bounceOut));
    return AnimatedBuilder(
      animation: course,
      builder: (context, _) {
        final f = remplir.value * joueur.bonnes / math.max(1, total);
        return Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: couronne && tombe.value > 0.5 ? couleur : p.bord, width: 2),
          ),
          child: Column(children: [
            Row(children: [
              Text(nom, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: couleur)),
              if (couronne)
                Opacity(
                  opacity: tombe.value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, -30 * (1 - tombe.value)),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(Icons.emoji_events_rounded, color: Color(0xFFFFC24B), size: 22),
                    ),
                  ),
                ),
              const Spacer(),
              Text('${(remplir.value * joueur.bonnes).round()}/$total',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: p.texte)),
              const SizedBox(width: 10),
              Icon(Icons.timer_rounded, size: 16, color: p.doux),
              Text(' ${_secondes((remplir.value * joueur.ms).round())}',
                  style: TextStyle(fontWeight: FontWeight.w700, color: p.doux)),
            ]),
            const SizedBox(height: 8),
            Container(
              height: 14,
              decoration: BoxDecoration(color: p.verrou, borderRadius: BorderRadius.circular(9)),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: f.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: couleur,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [BoxShadow(color: couleur.withValues(alpha: 0.5), blurRadius: 10)],
                  ),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}

class _AttenteAmis extends StatelessWidget {
  const _AttenteAmis({required this.code, required this.envoi});
  final String? code;
  final bool envoi;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: violetDuel.withValues(alpha: p.sombre ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: violetDuel.withValues(alpha: 0.6), width: 2),
      ),
      child: Column(children: [
        Text(
          envoi ? 'On crée ton duel…' : (code == null ? 'Le duel n\'a pas pu être créé.' : 'Ton défi est prêt !'),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: violetDuel),
        ),
        if (code != null) ...[
          const SizedBox(height: 6),
          SelectableText(code!,
              style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 28, letterSpacing: 4, color: p.texte)),
          Text('Tes amis ont 30 jours pour te battre. Tu verras leurs scores dans Réviser.',
              textAlign: TextAlign.center, style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, height: 1.35)),
        ],
      ]),
    );
  }
}

// ============================================================ mes duels
/// La liste de mes duels (onglet Réviser), avec les scores des amis.
class MesDuels extends StatefulWidget {
  const MesDuels({super.key});

  @override
  State<MesDuels> createState() => _MesDuelsState();
}

class _MesDuelsState extends State<MesDuels> {
  late Future<List<Duel?>> _duels = _charger();

  Future<List<Duel?>> _charger() async {
    final codes = Duels.mesDuels().take(5).map((d) => d['code'] as String).toList();
    return Future.wait(codes.map((c) => Duels.lire(c).then<Duel?>((d) => d).catchError((_) => null)));
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    if (Duels.mesDuels().isEmpty) return const SizedBox.shrink();
    return FutureBuilder<List<Duel?>>(
      future: _duels,
      builder: (context, snap) {
        final duels = (snap.data ?? const <Duel?>[]).whereType<Duel>().toList();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 22),
          Row(children: [
            Text('Mes duels', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            if (snap.connectionState == ConnectionState.waiting)
              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.5))
            else
              IconButton(
                tooltip: 'Actualiser',
                onPressed: () => setState(() => _duels = _charger()),
                icon: Icon(Icons.refresh_rounded, color: p.doux),
              ),
          ]),
          if (snap.hasData && duels.isEmpty)
            Text('Hors ligne : les scores reviendront avec internet.', style: TextStyle(color: p.doux, fontWeight: FontWeight.w600)),
          for (final d in duels) _LigneDuel(duel: d),
        ]);
      },
    );
  }
}

class _LigneDuel extends StatelessWidget {
  const _LigneDuel({required this.duel});
  final Duel duel;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final n = duel.questions.length;
    final moi = Duels.monNom();
    final tous = [duel.createur, ...duel.adversaires]..sort((a, b) => b.comparer(a));
    final premier = tous.first;
    final jeSuisCreateur = duel.createur.nom == moi;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: p.bord, width: 2)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.sports_kabaddi_rounded, color: violetDuel),
          const SizedBox(width: 8),
          Expanded(child: Text(duel.titre, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium)),
          if (jeSuisCreateur)
            IconButton(
              tooltip: 'Partager ce duel',
              visualDensity: VisualDensity.compact,
              onPressed: () => Share.share('Je te défie sur Kunfox : « ${duel.titre} ». ${lienDuel(duel.code)}'),
              icon: Icon(Icons.ios_share_rounded, color: p.doux, size: 20),
            ),
        ]),
        const SizedBox(height: 4),
        if (duel.adversaires.isEmpty)
          Text('Personne n\'a encore relevé ton défi.', style: TextStyle(color: p.doux, fontWeight: FontWeight.w600))
        else
          for (final (i, j) in tous.take(4).indexed)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(children: [
                SizedBox(
                  width: 22,
                  child: i == 0
                      ? const Icon(Icons.emoji_events_rounded, size: 18, color: Color(0xFFFFC24B))
                      : Text('${i + 1}', style: TextStyle(fontWeight: FontWeight.w800, color: p.doux)),
                ),
                Expanded(
                  child: Text(j.nom,
                      style: TextStyle(fontWeight: FontWeight.w800, color: j == premier ? p.texte : p.doux)),
                ),
                Text('${j.bonnes}/$n · ${_secondes(j.ms)}', style: TextStyle(fontWeight: FontWeight.w700, color: p.doux)),
              ]),
            ),
      ]),
    );
  }
}

/// Le code d'un duel tapé à la main (si le lien ne s'ouvre pas).
Future<void> saisirCodeDuel(BuildContext context) async {
  final ctrl = TextEditingController();
  final code = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Rejoindre un duel'),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        textCapitalization: TextCapitalization.characters,
        maxLength: 8,
        decoration: const InputDecoration(hintText: 'Code à 8 caractères'),
        onSubmitted: (v) => Navigator.of(ctx).pop(v),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Annuler')),
        TextButton(onPressed: () => Navigator.of(ctx).pop(ctrl.text), child: const Text('Rejoindre')),
      ],
    ),
  );
  ctrl.dispose();
  final propre = (code ?? '').trim().toUpperCase();
  if (propre.length == 8 && context.mounted) unawaited(context.push('/k/duel/$propre'));
}

/// Pour les liens « kunfox.dropletmesh.app/d/CODE » et « kunfox://kunfox/duel/CODE ».
final codeDuelValide = RegExp(r'^[A-HJ-NP-Z2-9]{8}$');
