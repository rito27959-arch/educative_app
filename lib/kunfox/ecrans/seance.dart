// ============================================================================
// LA SÉANCE — une leçon (ou une révision), exercice par exercice.
// ----------------------------------------------------------------------------
//   1. Les cartes « notion » de la leçon (intro, cours, exemple, à retenir)
//   2. Les exercices : QCM, vrai/faux, phrase à compléter
//   3. Après « Vérifier » : le panneau vert ou rouge monte du bas, Kunfox
//      saute de joie ou encourage, coche ou croix Rive, étincelles Flame.
//   Chaque erreur coûte un cœur (pas en révision) et la question revient à
//   la fin de la séance. 3 bonnes réponses d'affilée : le compteur de combo.
// ============================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/curriculum_data.dart';
import '../../core/data/lesson_content_data.dart';
import '../../core/data/quiz_data.dart';
import '../../core/models/quiz_question.dart';
import '../../core/providers/curriculum_provider.dart';
import '../../shared/widgets/kunfox/kunfox_rive.dart';
import '../composants/bouton.dart';
import '../composants/sons.dart';
import '../donnees/matieres.dart';
import '../donnees/progression.dart';
import '../donnees/rappels.dart';
import '../flame/effets_flame.dart';
import '../theme/palette.dart';
import '../riche/contenu_riche.dart';
import '../riche/illustrations.dart';
import '../donnees/duels.dart';
import '../pub/publicites.dart';
import 'duel.dart' show FantomeDuel;

sealed class _Etape {}

class _Notion extends _Etape {
  _Notion(this.titre, this.texte, {this.puces = const []});
  final String titre;
  final String texte;
  final List<String> puces;
}

class _Exercice extends _Etape {
  _Exercice(this.q, {this.reprise = false});
  final QuizQuestion q;
  final bool reprise;
  bool get vraiFaux =>
      q.options.length == 2 && q.options.map((o) => o.toLowerCase().trim()).toSet().containsAll({'vrai', 'faux'});
  bool get aTrous => q.question.contains('___') || q.question.contains('…') || q.question.contains('...');
}

class SeanceEcran extends ConsumerStatefulWidget {
  const SeanceEcran({super.key, this.leconId, this.duel, this.boss});

  /// null : révision de la matière en cours.
  final String? leconId;

  /// Une séance de duel : les questions sont fixées, pas de cœurs perdus.
  final PartieDuel? duel;

  /// L'épreuve d'une unité (le « grand boss ») : l'id du chapitre.
  final String? boss;

  @override
  ConsumerState<SeanceEcran> createState() => _SeanceEcranState();
}

enum _Phase { reponse, verifiee }

class _SeanceEcranState extends ConsumerState<SeanceEcran> {
  final _confettis = ConfettisControleur();
  final _cleBouton = GlobalKey();
  final _hasard = math.Random();
  final List<_Etape> _file = [];
  int _index = 0;
  int _totalInitial = 1;
  int? _choix;
  _Phase _phase = _Phase.reponse;
  bool _juste = false;
  int _bonnes = 0, _reponses = 0, _combo = 0, _meilleurCombo = 0;
  final _debut = DateTime.now();
  final Set<String> _deja = {}; // questions déjà remises en fin de file
  int _pertes = 0; // compte les cœurs perdus, pour rejouer l'animation
  bool _coeurSeBrise = false;

  bool get _revision => widget.leconId == null && widget.duel == null && widget.boss == null;
  bool get _boss => widget.boss != null;
  int _vies = 3; // l'épreuve : trois vies, pas les cœurs du jour
  bool get _duel => widget.duel != null;

  // duel : juste/faux et temps de chaque réponse
  final List<(bool, int)> _traces = [];
  DateTime _debutQuestion = DateTime.now();

  @override
  void initState() {
    super.initState();
    _preparer();
  }

  void _preparer() {
    LessonContentData.init();
    final questions = <QuizQuestion>[];
    if (_boss) {
      final toutes = [...QuizData.getQuestionsForChapter(widget.boss!)]..shuffle(_hasard);
      final vues = <String>{};
      _file.addAll(toutes.where((q) => vues.add(q.question)).take(10).map(_Exercice.new));
      _totalInitial = math.max(1, _file.length);
      return;
    }
    if (_duel) {
      _file.addAll(widget.duel!.questions.map(_Exercice.new));
      _totalInitial = math.max(1, _file.length);
      return;
    }
    if (!_revision) {
      // Les leçons des séries C et TI reprennent souvent celles de la série D :
      // à défaut de fiche propre, on prend la fiche jumelle (maths_c_ch1_l1 → maths_ch1_l1).
      final contenu = LessonContentData.get(widget.leconId!) ??
          LessonContentData.get(widget.leconId!.replaceFirst(RegExp(r'_(c|ti)_'), '_'));
      if (contenu != null) {
        if (contenu.introText.trim().isNotEmpty) _file.add(_Notion('Découverte', contenu.introText.trim()));
        if (contenu.lessonBody.trim().isNotEmpty) _file.add(_Notion('L\'essentiel', contenu.lessonBody.trim()));
        final image = illustrationsLecons[widget.leconId];
        if (image != null) _file.add(_Notion('En image', image));
        if (contenu.example.trim().isNotEmpty) _file.add(_Notion('Exemple', contenu.example.trim()));
        if (contenu.takeaways.isNotEmpty) _file.add(_Notion('À retenir', '', puces: contenu.takeaways));
      } else {
        final l = CurriculumData.findLessonById(widget.leconId!);
        if (l != null && l.content.trim().isNotEmpty) _file.add(_Notion(l.title, l.content.trim()));
        final image = illustrationsLecons[widget.leconId];
        if (image != null) _file.add(_Notion('En image', image));
      }
      questions.addAll(QuizData.getQuestionsForLesson(widget.leconId!, count: 5));
    } else {
      final matiere = ref.read(matiereActiveProvider);
      final prog = ref.read(progressionProvider);
      final lecons = matiere == null ? <String>[] : leconsDe(matiere).map((l) => l.id).toList();
      final faites = lecons.where(prog.leconsFaites.contains).toList();
      final source = (faites.isNotEmpty ? faites : lecons.take(3).toList())..shuffle(_hasard);
      for (final id in source) {
        questions.addAll(QuizData.getQuestionsForLesson(id, count: 2));
        if (questions.length >= 6) break;
      }
    }
    _file.addAll(questions.take(_revision ? 6 : 5).map(_Exercice.new));
    _totalInitial = math.max(1, _file.length);
  }

  _Etape? get _etape => _index < _file.length ? _file[_index] : null;

  double get _avancement => (_index + (_phase == _Phase.verifiee ? 1 : 0)) / math.max(_file.length, _totalInitial);

  void _verifier() {
    final e = _etape;
    if (e is! _Exercice || _choix == null) return;
    final juste = _choix == e.q.correctIndex;
    if (_duel) _traces.add((juste, DateTime.now().difference(_debutQuestion).inMilliseconds));
    setState(() {
      _phase = _Phase.verifiee;
      _juste = juste;
      _reponses++;
      if (juste) {
        _bonnes++;
        _combo++;
        _meilleurCombo = math.max(_meilleurCombo, _combo);
      } else {
        _combo = 0;
        // la question reviendra en fin de séance (une seule fois)
        if (!_duel && !_boss && _deja.add(e.q.id)) _file.add(_Exercice(e.q, reprise: true));
      }
    });
    Sons.jouer(juste ? Son.juste : Son.faux);
    if (juste) {
      HapticFeedback.mediumImpact();
      final boite = _cleBouton.currentContext?.findRenderObject() as RenderBox?;
      final racine = context.findRenderObject() as RenderBox?;
      if (boite != null && racine != null) {
        final c = boite.localToGlobal(boite.size.center(Offset.zero), ancestor: racine);
        _confettis.gerbe(c, nombre: _combo >= 3 ? 26 : 16);
      }
    } else {
      HapticFeedback.heavyImpact();
      if (_boss) {
        setState(() {
          _vies--;
          _pertes++;
          _coeurSeBrise = true;
        });
        Future.delayed(const Duration(milliseconds: 1100), () {
          if (mounted) setState(() => _coeurSeBrise = false);
        });
      } else if (!_revision && !_duel) {
        ref.read(progressionProvider.notifier).perdreCoeur();
        // un cœur se brise au-dessus du compteur, puis s'efface
        setState(() {
          _pertes++;
          _coeurSeBrise = true;
        });
        Future.delayed(const Duration(milliseconds: 1100), () {
          if (mounted) setState(() => _coeurSeBrise = false);
        });
      }
    }
  }

  void _continuer() {
    if (!_revision && !_duel && ref.read(progressionProvider).coeursActuels <= 0 && _phase == _Phase.verifiee && !_juste) {
      _plusDeCoeurs();
      return;
    }
    if (_index + 1 >= _file.length || (_boss && _vies <= 0)) {
      _terminer();
      return;
    }
    setState(() {
      _index++;
      _choix = null;
      _phase = _Phase.reponse;
      _debutQuestion = DateTime.now();
    });
  }

  void _terminer() {
    if (_boss) {
      final bilan = ref.read(progressionProvider.notifier).terminerBoss(
            chapitreId: widget.boss!,
            bonnes: _bonnes,
            total: math.max(_reponses, _file.length),
            duree: DateTime.now().difference(_debut),
            meilleurCombo: _meilleurCombo,
          );
      if (bilan.reussi) {
        ref.read(curriculumProgressProvider.notifier).recordChapterExamScore(widget.boss!, bilan.precision);
      }
      Rappels.noterLecon();
      context.pushReplacement('/k/boss-fin', extra: bilan);
      return;
    }
    if (_duel) {
      // un duel compte comme une révision : XP et série
      ref.read(progressionProvider.notifier).terminer(
            leconId: null,
            bonnes: _bonnes,
            total: _reponses,
            duree: DateTime.now().difference(_debut),
            meilleurCombo: _meilleurCombo,
          );
      Rappels.noterLecon();
      context.pushReplacement('/k/duel-fin',
          extra: (widget.duel!, Joueur(nom: Duels.monNom(), traces: List.of(_traces))));
      return;
    }
    final bilan = ref.read(progressionProvider.notifier).terminer(
          leconId: widget.leconId,
          bonnes: _bonnes,
          total: _reponses,
          duree: DateTime.now().difference(_debut),
          meilleurCombo: _meilleurCombo,
        );
    if (!_revision) {
      // garde aussi à jour les écrans historiques (programme, statistiques)
      ref.read(curriculumProgressProvider.notifier).completeLesson(widget.leconId!, score: bilan.precision);
    }
    Rappels.noterLecon();
    context.pushReplacement('/k/fin', extra: bilan);
  }

  Future<void> _plusDeCoeurs() async {
    final p = Palette.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const KunfoxMascotte(humeur: HumeurKunfox.courage, taille: 130),
            Text('Plus de cœurs !', style: Theme.of(ctx).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Révise ce que tu as déjà vu pour regagner un cœur, ou reviens dans 30 minutes.',
                textAlign: TextAlign.center, style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, height: 1.4)),
            const SizedBox(height: 20),
            // Comme chez Duolingo : une courte pub, au choix, rend un cœur
            // et la leçon continue là où elle s'était arrêtée.
            if (Publicites.configurees) ...[
              ValueListenableBuilder<bool>(
                valueListenable: Publicites.recompensePrete,
                builder: (_, prete, _) => BoutonKunfox(
                  libelle: prete ? 'Regarder une pub : +1 cœur' : 'Pub en chargement…',
                  icone: Icons.play_circle_fill_rounded,
                  couleur: p.or,
                  surAppui: !prete
                      ? null
                      : () async {
                          final gagne = await Publicites.regarderPourRecompense();
                          if (!gagne || !mounted) return;
                          ref.read(progressionProvider.notifier).gagnerCoeur();
                          if (ctx.mounted) Navigator.of(ctx).pop();
                          _continuer();
                        },
                ),
              ),
              const SizedBox(height: 10),
            ],
            BoutonKunfox(
              libelle: 'Réviser pour un cœur',
              couleur: p.info,
              surAppui: () {
                Navigator.of(ctx).pop();
                context.pushReplacement('/k/revision');
              },
            ),
            const SizedBox(height: 10),
            BoutonKunfox(
              libelle: 'Quitter',
              contour: true,
              surAppui: () {
                Navigator.of(ctx).pop();
                context.pop();
              },
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _quitter() async {
    final p = Palette.of(context);
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const KunfoxMascotte(humeur: HumeurKunfox.courage, taille: 120),
            Text('Attends, tu y es presque !', style: Theme.of(ctx).textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Si tu quittes maintenant, ta progression dans cette leçon sera perdue.',
                textAlign: TextAlign.center, style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, height: 1.4)),
            const SizedBox(height: 20),
            BoutonKunfox(libelle: 'Continuer la leçon', surAppui: () => Navigator.of(ctx).pop(false)),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('QUITTER', style: TextStyle(color: p.erreur, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
            ),
          ]),
        ),
      ),
    );
    if (ok == true && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final coeurs = ref.watch(progressionProvider.select((x) => x.coeursActuels));
    final etape = _etape;

    if (_file.isEmpty || etape == null) {
      return Scaffold(
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const KunfoxMascotte(humeur: HumeurKunfox.reflexion, taille: 160),
            Text('Cette leçon arrive bientôt.', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextButton(onPressed: () => context.pop(), child: const Text('Retour')),
          ]),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (fait, _) {
        if (!fait) _quitter();
      },
      child: Scaffold(
        body: Stack(children: [
          SafeArea(
            child: Column(children: [
              // haut : quitter, progression, cœurs
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
                child: Row(children: [
                  IconButton(
                    tooltip: 'Quitter',
                    onPressed: _quitter,
                    icon: Icon(Icons.close_rounded, color: p.doux, size: 30),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _combo >= 3
                            ? [BoxShadow(color: p.or.withValues(alpha: 0.55), blurRadius: 14, spreadRadius: 1)]
                            : const [],
                      ),
                      child: BarreProgres(valeur: _avancement, couleur: _combo >= 3 || _boss ? p.or : p.succes),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_boss)
                    _Vies(vies: _vies, pertes: _pertes, brise: _coeurSeBrise)
                  else if (_duel)
                    const Icon(Icons.sports_kabaddi_rounded, color: Color(0xFF8B5CF6))
                  else if (_revision)
                    Icon(Icons.fitness_center_rounded, color: p.info)
                  else ...[
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
                        KunfoxCoeur(perdu: coeurs == 0, taille: 30),
                        if (_coeurSeBrise)
                          Positioned(
                            left: -21,
                            top: -21,
                            child: IgnorePointer(child: KunfoxCoeur(key: ValueKey(_pertes), perdu: true, taille: 72)),
                          ),
                      ]),
                    ),
                    const SizedBox(width: 2),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      transitionBuilder: (e, a) => SlideTransition(
                        position: Tween(begin: const Offset(0, -0.8), end: Offset.zero)
                            .animate(CurvedAnimation(parent: a, curve: const Cubic(0.34, 1.56, 0.64, 1))),
                        child: FadeTransition(opacity: a, child: e),
                      ),
                      child: Text('$coeurs',
                          key: ValueKey(coeurs),
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: coeurs == 0 ? p.doux : p.erreur)),
                    ),
                  ],
                ]),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                transitionBuilder: (c, a) => ScaleTransition(scale: a, child: FadeTransition(opacity: a, child: c)),
                child: _combo >= 3 && etape is _Exercice
                    ? Padding(
                        key: ValueKey(_combo),
                        padding: const EdgeInsets.only(top: 2),
                        child: Text('🔥 $_combo D\'AFFILÉE',
                            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1, color: p.prim, fontSize: 13)),
                      )
                    : const SizedBox(height: 18),
              ),
              if (widget.duel?.duel != null)
                FantomeDuel(
                  adversaire: widget.duel!.duel!.createur,
                  mesReponses: _traces.length,
                  total: widget.duel!.questions.length,
                  enCourse: _phase == _Phase.reponse,
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 380),
                  switchInCurve: const Cubic(0.16, 1, 0.3, 1),
                  // L'ancien exercice part à gauche pendant que le nouveau arrive
                  // de droite, côte à côte : rien ne se superpose.
                  layoutBuilder: (actuel, anciens) => ClipRect(child: Stack(children: [...anciens, if (actuel != null) actuel])),
                  transitionBuilder: (enfant, a) {
                    final entrant = enfant.key == ValueKey(_index);
                    return SlideTransition(
                      position: Tween(begin: Offset(entrant ? 1 : -1, 0), end: Offset.zero).animate(a),
                      child: enfant,
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(_index),
                    child: etape is _Notion ? _VueNotion(etape) : _VueExercice(
                      exo: etape as _Exercice,
                      choix: _choix,
                      verrouille: _phase == _Phase.verifiee,
                      humeur: _phase == _Phase.reponse
                          ? HumeurKunfox.reflexion
                          : _juste
                              ? HumeurKunfox.joie
                              : HumeurKunfox.courage,
                      surChoix: (i) {
                        HapticFeedback.selectionClick();
                        Sons.jouer(Son.clic);
                        setState(() => _choix = i);
                      },
                    ),
                  ),
                ),
              ),
              // bas : Vérifier / Continuer, ou le panneau de résultat
              _Bas(
                cleBouton: _cleBouton,
                etape: etape,
                phase: _phase,
                juste: _juste,
                choixFait: _choix != null,
                surVerifier: _verifier,
                surContinuer: _continuer,
              ),
            ]),
          ),
          Positioned.fill(child: ConfettisFlame(controleur: _confettis)),
        ]),
      ),
    );
  }
}

// ------------------------------------------------------------------ notion
class _VueNotion extends StatelessWidget {
  const _VueNotion(this.n);
  final _Notion n;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        Row(children: [
          const KunfoxMascotte(humeur: HumeurKunfox.salut, taille: 84),
          const SizedBox(width: 8),
          Expanded(
            child: Text(n.titre, style: Theme.of(context).textTheme.headlineMedium),
          ),
        ]),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: p.bord, width: 2),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (n.texte.isNotEmpty) ContenuRiche(n.texte, style: Theme.of(context).textTheme.bodyLarge),
            for (final puce in n.puces)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3, right: 10),
                    child: Icon(Icons.check_circle_rounded, color: p.succes, size: 20),
                  ),
                  Expanded(child: TexteRiche(puce, style: Theme.of(context).textTheme.bodyLarge)),
                ]),
              ),
          ]),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------ exercice
class _VueExercice extends StatelessWidget {
  const _VueExercice({
    required this.exo,
    required this.choix,
    required this.verrouille,
    required this.humeur,
    required this.surChoix,
  });

  final _Exercice exo;
  final int? choix;
  final bool verrouille;
  final HumeurKunfox humeur;
  final ValueChanged<int> surChoix;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final consigne = exo.reprise
        ? 'ERREUR PRÉCÉDENTE'
        : exo.vraiFaux
            ? 'VRAI OU FAUX ?'
            : exo.aTrous
                ? 'COMPLÈTE LA PHRASE'
                : 'CHOISIS LA BONNE RÉPONSE';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      children: [
        Text(consigne,
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1.2, color: exo.reprise ? p.erreur : p.prim)),
        const SizedBox(height: 10),
        // Kunfox « pose » la question dans une bulle
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          // il lit la question (à droite), suit ton choix (en bas), puis te regarde
          KunfoxMascotte(
            humeur: humeur,
            taille: 92,
            regard: verrouille ? RegardKunfox.centre : (choix == null ? RegardKunfox.droite : RegardKunfox.bas),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(color: p.bord, width: 2),
              ),
              child: _Enonce(exo: exo, choix: choix),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        if (exo.vraiFaux)
          Row(children: [
            for (var i = 0; i < exo.q.options.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(
                child: _Tuile(
                  texte: exo.q.options[i],
                  grand: true,
                  icone: exo.q.options[i].toLowerCase().trim() == 'vrai' ? Icons.check_rounded : Icons.close_rounded,
                  choisi: choix == i,
                  etat: _etatTuile(i),
                  surAppui: verrouille ? null : () => surChoix(i),
                ),
              ),
            ],
          ])
        else if (exo.aTrous)
          Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: [
            for (var i = 0; i < exo.q.options.length; i++)
              _Tuile(
                texte: exo.q.options[i],
                compact: true,
                choisi: choix == i,
                etat: _etatTuile(i),
                surAppui: verrouille ? null : () => surChoix(i),
              ),
          ])
        else
          for (var i = 0; i < exo.q.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _Tuile(
                texte: exo.q.options[i],
                numero: i + 1,
                choisi: choix == i,
                etat: _etatTuile(i),
                surAppui: verrouille ? null : () => surChoix(i),
              ),
            ),
      ],
    );
  }

  int _etatTuile(int i) {
    if (!verrouille) return 0;
    if (i == exo.q.correctIndex) return 1;
    if (i == choix) return -1;
    return 0;
  }
}

class _Enonce extends StatelessWidget {
  const _Enonce({required this.exo, required this.choix});
  final _Exercice exo;
  final int? choix;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final style = Theme.of(context).textTheme.titleLarge;
    if (!exo.aTrous) return TexteRiche(exo.q.question, style: style);
    // la phrase à trous : le mot choisi vient se loger dans le trou
    final motif = RegExp(r'_{3,}|…|\.\.\.');
    final m = motif.firstMatch(exo.q.question)!;
    final avant = exo.q.question.substring(0, m.start);
    final apres = exo.q.question.substring(m.end);
    return Text.rich(
      TextSpan(style: style, children: [
        TextSpan(text: avant),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            constraints: const BoxConstraints(minWidth: 60),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: choix == null ? p.doux : p.info, width: 3)),
            ),
            child: Text(choix == null ? ' ' : exo.q.options[choix!],
                style: style?.copyWith(color: p.info, fontWeight: FontWeight.w800)),
          ),
        ),
        TextSpan(text: apres),
      ]),
    );
  }
}

/// Une réponse possible : tuile à tranche, bleue quand elle est choisie,
/// verte ou rouge une fois vérifiée.
class _Tuile extends StatefulWidget {
  const _Tuile({
    required this.texte,
    required this.choisi,
    required this.etat,
    required this.surAppui,
    this.numero,
    this.icone,
    this.grand = false,
    this.compact = false,
  });

  final String texte;
  final bool choisi;
  final int etat; // 1 juste, -1 faux, 0 neutre
  final VoidCallback? surAppui;
  final int? numero;
  final IconData? icone;
  final bool grand, compact;

  @override
  State<_Tuile> createState() => _TuileState();
}

class _TuileState extends State<_Tuile> {
  bool _enfonce = false;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final accent = widget.etat == 1
        ? p.succes
        : widget.etat == -1
            ? p.erreur
            : widget.choisi
                ? p.info
                : null;
    final bord = accent ?? p.bord;
    final fond = accent == null ? p.surface : accent.withValues(alpha: p.sombre ? 0.16 : 0.10);
    final texte = accent ?? p.texte;
    final descendu = _enfonce || widget.choisi;

    return Semantics(
      button: true,
      selected: widget.choisi,
      label: widget.texte,
      child: GestureDetector(
        onTapDown: widget.surAppui == null ? null : (_) => setState(() => _enfonce = true),
        onTapCancel: () => setState(() => _enfonce = false),
        onTapUp: widget.surAppui == null
            ? null
            : (_) {
                setState(() => _enfonce = false);
                widget.surAppui!();
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          margin: EdgeInsets.only(top: descendu ? 2 : 0),
          padding: EdgeInsets.symmetric(horizontal: widget.compact ? 16 : 16, vertical: widget.grand ? 26 : (widget.compact ? 10 : 15)),
          decoration: BoxDecoration(
            color: fond,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              top: BorderSide(color: bord, width: 2),
              left: BorderSide(color: bord, width: 2),
              right: BorderSide(color: bord, width: 2),
              bottom: BorderSide(color: bord, width: descendu ? 2 : 4),
            ),
          ),
          child: widget.grand
              ? Column(children: [
                  if (widget.icone != null) Icon(widget.icone, size: 34, color: texte),
                  const SizedBox(height: 6),
                  Text(widget.texte, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: texte)),
                ])
              : Row(mainAxisSize: widget.compact ? MainAxisSize.min : MainAxisSize.max, children: [
                  if (widget.numero != null) ...[
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: accent ?? p.bord, width: 2),
                      ),
                      child: Text('${widget.numero}', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: accent ?? p.doux)),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Flexible(
                    child: TexteRiche(widget.texte,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, height: 1.3, color: texte)),
                  ),
                ]),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ bas
class _Bas extends StatelessWidget {
  const _Bas({
    required this.cleBouton,
    required this.etape,
    required this.phase,
    required this.juste,
    required this.choixFait,
    required this.surVerifier,
    required this.surContinuer,
  });

  final GlobalKey cleBouton;
  final _Etape etape;
  final _Phase phase;
  final bool juste;
  final bool choixFait;
  final VoidCallback surVerifier;
  final VoidCallback surContinuer;

  static const _bravos = ['Excellent !', 'Bravo !', 'Parfait !', 'Bien joué !', 'Exact !'];

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final verifiee = phase == _Phase.verifiee;
    final couleur = juste ? p.succes : p.erreur;
    final exo = etape is _Exercice ? etape as _Exercice : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: const Cubic(0.16, 1, 0.3, 1),
      width: double.infinity,
      decoration: BoxDecoration(
        color: verifiee ? couleur.withValues(alpha: p.sombre ? 0.18 : 0.12) : p.fond,
        border: Border(top: BorderSide(color: verifiee ? Colors.transparent : p.bord, width: 2)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 320),
          curve: const Cubic(0.16, 1, 0.3, 1),
          child: verifiee && exo != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    juste
                        ? KunfoxEffet.reussite(key: ValueKey('ok${exo.q.id}${exo.reprise}'), taille: 56)
                        : KunfoxEffet.erreur(key: ValueKey('ko${exo.q.id}${exo.reprise}'), taille: 56),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          juste ? _bravos[exo.q.id.hashCode.abs() % _bravos.length] : 'Bonne réponse :',
                          style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 22, color: couleur),
                        ),
                        if (!juste)
                          Text(exo.q.options[exo.q.correctIndex],
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: couleur)),
                        if (exo.q.explanation.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          TexteRiche(exo.q.explanation.trim(),
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, height: 1.35, color: couleur.withValues(alpha: 0.9))),
                        ],
                      ]),
                    ),
                  ]),
                )
              : const SizedBox(width: double.infinity),
        ),
        KeyedSubtree(
          key: cleBouton,
          child: exo == null
              ? BoutonKunfox(libelle: 'Continuer', couleur: p.prim, surAppui: surContinuer)
              : verifiee
                  ? BoutonKunfox(libelle: 'Continuer', couleur: couleur, surAppui: surContinuer)
                  : BoutonKunfox(libelle: 'Vérifier', couleur: p.succes, surAppui: choixFait ? surVerifier : null),
        ),
      ]),
    );
  }
}


/// Les trois vies de l'épreuve : la dernière perdue se brise.
class _Vies extends StatelessWidget {
  const _Vies({required this.vies, required this.pertes, required this.brise});
  final int vies, pertes;
  final bool brise;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      for (var i = 0; i < 3; i++)
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
              AnimatedScale(
                scale: i < vies ? 1 : 0.8,
                duration: const Duration(milliseconds: 300),
                curve: const Cubic(0.34, 1.56, 0.64, 1),
                child: Icon(Icons.favorite_rounded, size: 24, color: i < vies ? p.erreur : p.verrou),
              ),
              if (brise && i == vies)
                Positioned(
                  left: -24,
                  top: -24,
                  child: IgnorePointer(child: KunfoxCoeur(key: ValueKey(pertes), perdu: true, taille: 72)),
                ),
            ]),
          ),
        ),
    ]);
  }
}
