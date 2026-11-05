// ============================================================================
// L'ULTIME BOSS : l'épreuve type Bac de la matière.
// ----------------------------------------------------------------------------
//  Entrée    → la couronne, la matière, durée, coefficient, exercices.
//  Copie     → exercice par exercice : énoncé (formules, courbes, tableaux),
//              réponses (choix, nombres, expressions, mots, rédactions),
//              chrono si on veut, brouillon gardé si on quitte.
//  Correction→ corrigé de chaque question ; les rédactions se notent avec
//              le barème (l'élève coche ce qu'il a juste).
//  Note      → la note sur 20 qui monte, la mention, le détail par
//              exercice et le plan de réussite (chapitres à revoir).
// ============================================================================

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' show FontFeature;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/curriculum_data.dart';
import '../../core/services/storage_service.dart';
import '../composants/bouton.dart';
import '../composants/carte_partage.dart';
import '../composants/fond_anime.dart';
import '../composants/sons.dart';
import '../donnees/progression.dart';
import '../epreuves/modele.dart';
import '../epreuves/sujets.dart';
import '../flame/effets_flame.dart';
import '../riche/contenu_riche.dart';
import '../riche/expressions.dart';
import '../riche/tableaux.dart' show Formule;
import '../theme/palette.dart';

const _or = Color(0xFFFFC24B);
const _encre = Color(0xFF101A33);
const _royal = Color(0xFF1B2A6B);
const _ressort = Cubic(0.34, 1.56, 0.64, 1);
const _doux = Cubic(0.16, 1, 0.3, 1);

String _duree(int minutes) {
  final h = minutes ~/ 60, m = minutes % 60;
  if (h == 0) return '$m min';
  return m == 0 ? '$h h' : '$h h ${m.toString().padLeft(2, '0')}';
}

String _note(double n) => (n == n.roundToDouble() ? n.toStringAsFixed(0) : n.toStringAsFixed(2).replaceFirst(RegExp(r'0$'), ''))
    .replaceAll('.', ',');

// ================================================================ brouillon
/// La copie en cours, gardée sur le téléphone tant qu'elle n'est pas remise.
class Copie {
  Copie({required this.epreuveId, Map<String, Object?>? reponses, Map<String, Set<int>>? coches, DateTime? debut, this.chrono = false})
      : reponses = reponses ?? {},
        coches = coches ?? {},
        debut = debut ?? DateTime.now();
  final String epreuveId;
  final Map<String, Object?> reponses;
  final Map<String, Set<int>> coches;
  final DateTime debut;
  final bool chrono;

  static String cle(int exo, int q) => '$exo.$q';
  static String _cleStock(String id) => 'kunfox.examen.$id';

  Map<String, dynamic> versJson() => {
        'reponses': reponses,
        'coches': coches.map((k, v) => MapEntry(k, v.toList())),
        'debut': debut.toIso8601String(),
        'chrono': chrono,
      };

  static Copie? charger(String id) {
    try {
      final brut = StorageService.getString(_cleStock(id));
      if (brut == null || brut.isEmpty) return null;
      final j = jsonDecode(brut) as Map<String, dynamic>;
      return Copie(
        epreuveId: id,
        reponses: Map<String, Object?>.from(j['reponses'] as Map? ?? {}),
        coches: (j['coches'] as Map? ?? {}).map((k, v) => MapEntry(k as String, (v as List).cast<int>().toSet())),
        debut: DateTime.tryParse(j['debut'] as String? ?? ''),
        chrono: j['chrono'] == true,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> sauver() => StorageService.setString(_cleStock(epreuveId), jsonEncode(versJson()));
  static Future<void> effacer(String id) => StorageService.remove(_cleStock(id));
}

// ==================================================================== entrée
class ExamenEntreeEcran extends ConsumerStatefulWidget {
  const ExamenEntreeEcran({super.key, required this.epreuveId});
  final String epreuveId;

  @override
  ConsumerState<ExamenEntreeEcran> createState() => _ExamenEntreeEcranState();
}

class _ExamenEntreeEcranState extends ConsumerState<ExamenEntreeEcran> with SingleTickerProviderStateMixin {
  late final AnimationController _t = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..forward();
  bool _chrono = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 550), () {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      Sons.jouer(Son.flamme);
    });
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  Animation<double> _iv(double a, double b, [Curve c = _doux]) => CurvedAnimation(parent: _t, curve: Interval(a, b, curve: c));

  @override
  Widget build(BuildContext context) {
    final e = epreuveParId(widget.epreuveId);
    if (e == null) {
      return Scaffold(body: Center(child: TextButton(onPressed: () => context.go('/k'), child: const Text('Épreuve introuvable'))));
    }
    final prog = ref.watch(progressionProvider);
    final record = prog.noteExamen(e.id);
    final brouillon = Copie.charger(e.id);
    final matiere = CurriculumData.findById(e.matiere);

    return Scaffold(
      backgroundColor: _encre,
      body: Stack(children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_royal, _encre]),
            ),
          ),
        ),
        const Positioned.fill(child: FondRayons(couleur: _or, centre: Alignment(0, -0.62), intensite: 0.9)),
        SafeArea(
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Fermer',
                  onPressed: () => context.canPop() ? context.pop() : context.go('/k'),
                  icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 30),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList.list(children: [
                // la couronne descend, se pose, brille
                AnimatedBuilder(
                  animation: _t,
                  builder: (context, enfant) {
                    final a = _iv(0, 0.4, Curves.bounceOut).value;
                    return Opacity(
                      opacity: _iv(0, 0.1).value,
                      child: Transform.translate(offset: Offset(0, -200 * (1 - a)), child: enfant),
                    );
                  },
                  child: const Center(child: _Couronne(taille: 132)),
                ),
                const SizedBox(height: 8),
                _Monte(
                  a: _iv(0.3, 0.7),
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(color: _or, borderRadius: BorderRadius.circular(99)),
                      child: Text('ÉPREUVE FINALE · BAC ${e.serie}',
                          style: const TextStyle(fontWeight: FontWeight.w800, color: _encre, letterSpacing: 1.4, fontSize: 12)),
                    ),
                    const SizedBox(height: 12),
                    Text(e.titre,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 28, height: 1.1, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Bac ${e.serie} · ${e.session} · ${matiere?.title ?? ''}',
                        style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w700)),
                    if (record != null) ...[
                      const SizedBox(height: 8),
                      Text('Meilleure note : ${_note(record)}/20 · ${mention(record)}',
                          style: const TextStyle(color: _or, fontWeight: FontWeight.w800)),
                    ],
                  ]),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: _Monte(a: _iv(0.42, 0.8, _ressort), child: _Info(Icons.schedule_rounded, _duree(e.dureeMinutes), 'durée'))),
                  const SizedBox(width: 10),
                  Expanded(child: _Monte(a: _iv(0.48, 0.86, _ressort), child: _Info(Icons.scale_rounded, '${e.coefficient}', 'coef.'))),
                  const SizedBox(width: 10),
                  Expanded(child: _Monte(a: _iv(0.54, 0.92, _ressort), child: const _Info(Icons.grade_rounded, '/20', 'note'))),
                ]),
                const SizedBox(height: 16),
                _Monte(
                  a: _iv(0.6, 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 2),
                    ),
                    child: Column(children: [
                      for (final (i, x) in e.exercices.indexed) ...[
                        if (i > 0) Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(children: [
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: _or.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(9)),
                              child: Text('${i + 1}', style: const TextStyle(color: _or, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(x.titre,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                            ),
                            Text('${_note(x.bareMax)} pts', style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w700)),
                          ]),
                        ),
                      ],
                    ]),
                  ),
                ),
                const SizedBox(height: 14),
                _Monte(
                  a: _iv(0.7, 1),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 6, 8, 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(children: [
                      const Icon(Icons.timer_outlined, color: Colors.white70),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text('Conditions réelles : chrono',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                      CupertinoSwitch(
                        value: _chrono,
                        activeTrackColor: _or,
                        onChanged: (v) {
                          HapticFeedback.selectionClick();
                          setState(() => _chrono = v);
                        },
                      ),
                    ]),
                  ),
                ),
                if (e.consignes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(e.consignes, style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w600, height: 1.4)),
                ],
                const SizedBox(height: 22),
                _Monte(
                  a: _iv(0.78, 1),
                  child: Column(children: [
                    if (brouillon != null) ...[
                      BoutonKunfox(
                        libelle: 'Reprendre ma copie',
                        couleur: _or,
                        couleurTexte: _encre,
                        surAppui: () => context.pushReplacement('/k/examen-copie/${e.id}', extra: brouillon),
                      ),
                      const SizedBox(height: 10),
                    ],
                    BoutonKunfox(
                      libelle: brouillon != null ? 'Nouvelle copie' : 'Commencer l\'épreuve',
                      couleur: brouillon != null ? null : _or,
                      couleurTexte: brouillon != null ? Colors.white : _encre,
                      contour: brouillon != null,
                      surAppui: () async {
                        HapticFeedback.mediumImpact();
                        await Copie.effacer(e.id);
                        final c = Copie(epreuveId: e.id, chrono: _chrono);
                        await c.sauver();
                        if (context.mounted) context.pushReplacement('/k/examen-copie/${e.id}', extra: c);
                      },
                    ),
                  ]),
                ),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

/// La couronne de l'ultime boss, avec un reflet qui passe.
class _Couronne extends StatefulWidget {
  const _Couronne({required this.taille});
  final double taille;
  @override
  State<_Couronne> createState() => _CouronneState();
}

class _CouronneState extends State<_Couronne> with SingleTickerProviderStateMixin {
  late final AnimationController _t = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat();
  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.taille;
    return AnimatedBuilder(
      animation: _t,
      builder: (context, _) {
        final x = (_t.value * 3).clamp(0.0, 1.0) * 3 - 1.5;
        final flotte = math.sin(_t.value * math.pi * 2) * 4;
        return Transform.translate(
          offset: Offset(0, flotte),
          child: Container(
            width: s,
            height: s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(colors: [Color(0xFF2D3F8F), _royal]),
              border: Border.all(color: _or, width: 4),
              boxShadow: [BoxShadow(color: _or.withValues(alpha: 0.45), blurRadius: 40, spreadRadius: 2)],
            ),
            alignment: Alignment.center,
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (r) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [Color(0xFFFFE08A), Color(0xFFE59A12), Colors.white, Color(0xFFE59A12), Color(0xFFE59A12)],
                stops: [0, (x + 0.35).clamp(0.0, 1.0), (x + 0.45).clamp(0.0, 1.0), (x + 0.55).clamp(0.0, 1.0), 1],
              ).createShader(r),
              child: Icon(Icons.workspace_premium_rounded, size: s * 0.62, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
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

class _Info extends StatelessWidget {
  const _Info(this.icone, this.valeur, this.libelle);
  final IconData icone;
  final String valeur, libelle;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14), width: 2),
        ),
        child: Column(children: [
          Icon(icone, color: _or, size: 22),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(valeur,
                style: const TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 21, color: Colors.white)),
          ),
          Text(libelle.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.8, color: Colors.white60)),
        ]),
      );
}

// ===================================================================== copie
class ExamenCopieEcran extends StatefulWidget {
  const ExamenCopieEcran({super.key, required this.epreuveId, this.copie});
  final String epreuveId;
  final Copie? copie;

  @override
  State<ExamenCopieEcran> createState() => _ExamenCopieEcranState();
}

class _ExamenCopieEcranState extends State<ExamenCopieEcran> {
  late final Epreuve _e = epreuveParId(widget.epreuveId)!;
  late final Copie _copie = widget.copie ?? Copie.charger(widget.epreuveId) ?? Copie(epreuveId: widget.epreuveId);
  final _pages = PageController();
  int _exo = 0;
  Timer? _horloge;
  Timer? _sauvegarde;

  Duration get _reste => Duration(minutes: _e.dureeMinutes) - DateTime.now().difference(_copie.debut);

  @override
  void initState() {
    super.initState();
    if (_copie.chrono) {
      _horloge = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        if (_reste <= Duration.zero) {
          _horloge?.cancel();
          _remettre(force: true);
        } else {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _horloge?.cancel();
    _sauvegarde?.cancel();
    _copie.sauver();
    _pages.dispose();
    super.dispose();
  }

  void _repondre(String cle, Object? valeur) {
    setState(() => _copie.reponses[cle] = valeur);
    _sauvegarde?.cancel();
    _sauvegarde = Timer(const Duration(milliseconds: 600), _copie.sauver);
  }

  int get _repondues => _copie.reponses.values.where((v) => v != null && (v is! String || v.trim().isNotEmpty)).length;

  Future<void> _remettre({bool force = false}) async {
    if (!force) {
      final manque = _e.nbQuestions - _repondues;
      final ok = await showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Remettre ta copie ?'),
          content: Text(manque > 0
              ? 'Il reste $manque question${manque > 1 ? 's' : ''} sans réponse. Tu verras ensuite le corrigé complet.'
              : 'Tu verras ensuite le corrigé complet et ta note.'),
          actions: [
            CupertinoDialogAction(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Continuer')),
            CupertinoDialogAction(isDefaultAction: true, onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Remettre')),
          ],
        ),
      );
      if (ok != true) return;
    }
    await _copie.sauver();
    HapticFeedback.heavyImpact();
    if (mounted) context.pushReplacement('/k/examen-correction/${_e.id}', extra: _copie);
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final reste = _reste;
    final urgent = _copie.chrono && reste.inMinutes < 10;
    return Scaffold(
      backgroundColor: p.fond,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 12, 0),
            child: Row(children: [
              IconButton(
                tooltip: 'Quitter (ta copie est gardée)',
                onPressed: () async {
                  await _copie.sauver();
                  if (context.mounted) context.canPop() ? context.pop() : context.go('/k');
                },
                icon: Icon(Icons.close_rounded, color: p.doux, size: 28),
              ),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_e.titre, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
                  Text('$_repondues/${_e.nbQuestions} réponses', style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, fontSize: 12.5)),
                ]),
              ),
              if (_copie.chrono)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: urgent ? p.erreur : p.surface,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: urgent ? p.erreur : p.bord, width: 2),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.timer_rounded, size: 16, color: urgent ? Colors.white : p.texte),
                    const SizedBox(width: 4),
                    Text(
                      '${reste.inHours}:${(reste.inMinutes % 60).toString().padLeft(2, '0')}:${(reste.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                          fontFeatures: const [FontFeature.tabularFigures()],
                          fontWeight: FontWeight.w800,
                          color: urgent ? Colors.white : p.texte),
                    ),
                  ]),
                ),
            ]),
          ),
          // les exercices, en onglets
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _e.exercices.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final x = _e.exercices[i];
                final choisi = i == _exo;
                final faites = List.generate(x.questions.length, (q) => _copie.reponses[Copie.cle(i, q)])
                    .where((v) => v != null && (v is! String || v.trim().isNotEmpty))
                    .length;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _pages.animateToPage(i, duration: const Duration(milliseconds: 380), curve: _doux);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: choisi ? p.prim : p.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: choisi ? p.prim : p.bord, width: 2),
                    ),
                    child: Text('Ex. ${i + 1} · $faites/${x.questions.length}',
                        style: TextStyle(fontWeight: FontWeight.w800, color: choisi ? Colors.white : p.texte)),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pages,
              itemCount: _e.exercices.length,
              onPageChanged: (i) => setState(() => _exo = i),
              itemBuilder: (context, i) => _PageExercice(
                exo: _e.exercices[i],
                index: i,
                copie: _copie,
                surReponse: _repondre,
                dernier: i == _e.exercices.length - 1,
                surSuivant: () => i == _e.exercices.length - 1
                    ? _remettre()
                    : _pages.animateToPage(i + 1, duration: const Duration(milliseconds: 380), curve: _doux),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _PageExercice extends StatelessWidget {
  const _PageExercice({
    required this.exo,
    required this.index,
    required this.copie,
    required this.surReponse,
    required this.dernier,
    required this.surSuivant,
  });
  final ExerciceEpreuve exo;
  final int index;
  final Copie copie;
  final void Function(String, Object?) surReponse;
  final bool dernier;
  final VoidCallback surSuivant;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        Row(children: [
          Expanded(
            child: Text('Exercice ${index + 1} · ${exo.titre}',
                style: const TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 21)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(color: p.prim.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(99)),
            child: Text('${_note(exo.bareMax)} pts', style: TextStyle(color: p.prim, fontWeight: FontWeight.w800)),
          ),
        ]),
        if (exo.sousTitre != null) Text(exo.sousTitre!, style: TextStyle(color: p.doux, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: p.bord, width: 2),
          ),
          child: ContenuRiche(exo.enonce),
        ),
        for (final (q, question) in exo.questions.indexed) ...[
          const SizedBox(height: 14),
          _CarteQuestion(
            question: question,
            reponse: copie.reponses[Copie.cle(index, q)],
            surReponse: (v) => surReponse(Copie.cle(index, q), v),
          ),
        ],
        const SizedBox(height: 22),
        BoutonKunfox(
          libelle: dernier ? 'Remettre ma copie' : 'Exercice suivant',
          icone: dernier ? Icons.send_rounded : Icons.arrow_forward_rounded,
          couleur: dernier ? p.succes : null,
          surAppui: surSuivant,
        ),
      ],
    );
  }
}

class _CarteQuestion extends StatelessWidget {
  const _CarteQuestion({required this.question, required this.reponse, required this.surReponse});
  final QuestionEpreuve question;
  final Object? reponse;
  final ValueChanged<Object?> surReponse;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final q = question;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.bord, width: 2),
        boxShadow: [BoxShadow(color: p.bord, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: p.texte, borderRadius: BorderRadius.circular(8)),
            child: Text(q.numero, style: TextStyle(color: p.fond, fontWeight: FontWeight.w800, fontSize: 13)),
          ),
          const SizedBox(width: 10),
          Expanded(child: ContenuRiche(q.enonce, espacement: 8)),
          const SizedBox(width: 6),
          Text('${_note(q.bareMax)} pt${q.bareMax > 1 ? 's' : ''}',
              style: TextStyle(color: p.doux, fontWeight: FontWeight.w700, fontSize: 12.5)),
        ]),
        const SizedBox(height: 12),
        switch (q.genre) {
          GenreQuestion.qcm || GenreQuestion.vraiFaux => Column(children: [
              for (final (i, o) in q.options.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _Option(
                    lettre: q.genre == GenreQuestion.vraiFaux ? null : String.fromCharCode(65 + i),
                    texte: o,
                    choisi: reponse == i,
                    surAppui: () {
                      HapticFeedback.selectionClick();
                      surReponse(i);
                    },
                  ),
                ),
            ]),
          GenreQuestion.nombre => _Champ(
              valeur: reponse as String? ?? '',
              indice: 'Ta valeur${q.unite == null ? '' : ' (en ${q.unite})'}',
              clavier: const TextInputType.numberWithOptions(decimal: true, signed: true),
              suffixe: q.unite,
              surChange: surReponse,
            ),
          GenreQuestion.expression => _ChampExpression(valeur: reponse as String? ?? '', variable: q.variable, surChange: surReponse),
          GenreQuestion.courte => _Champ(valeur: reponse as String? ?? '', indice: 'Ta réponse', surChange: surReponse),
          GenreQuestion.redaction => _Champ(
              valeur: reponse as String? ?? '',
              indice: 'Rédige ta réponse ici (ou sur ta feuille de brouillon)',
              lignes: 5,
              surChange: surReponse,
            ),
        },
      ]),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({required this.lettre, required this.texte, required this.choisi, required this.surAppui});
  final String? lettre;
  final String texte;
  final bool choisi;
  final VoidCallback surAppui;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return GestureDetector(
      onTap: surAppui,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: choisi ? p.info.withValues(alpha: 0.12) : p.fond,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: choisi ? p.info : p.bord, width: 2),
        ),
        child: Row(children: [
          if (lettre != null) ...[
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: choisi ? p.info : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: choisi ? p.info : p.bord, width: 2),
              ),
              child: Text(lettre!, style: TextStyle(fontWeight: FontWeight.w800, color: choisi ? Colors.white : p.doux)),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(child: TexteRiche(texte, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.5, color: p.texte))),
        ]),
      ),
    );
  }
}

class _Champ extends StatefulWidget {
  const _Champ({
    required this.valeur,
    required this.indice,
    required this.surChange,
    this.clavier,
    this.suffixe,
    this.lignes = 1,
  });
  final String valeur;
  final String indice;
  final ValueChanged<String> surChange;
  final TextInputType? clavier;
  final String? suffixe;
  final int lignes;

  @override
  State<_Champ> createState() => _ChampState();
}

class _ChampState extends State<_Champ> {
  late final _ctrl = TextEditingController(text: widget.valeur);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return TextField(
      controller: _ctrl,
      keyboardType: widget.lignes > 1 ? TextInputType.multiline : widget.clavier,
      minLines: widget.lignes,
      maxLines: widget.lignes > 1 ? 14 : 1,
      onChanged: widget.surChange,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: p.texte),
      decoration: InputDecoration(
        hintText: widget.indice,
        suffixText: widget.suffixe,
        filled: true,
        fillColor: p.fond,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: p.bord, width: 2)),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: p.bord, width: 2)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: p.info, width: 2)),
      ),
    );
  }
}

/// Une expression : champ + touches maths + aperçu de ce que Kunfox a compris.
class _ChampExpression extends StatefulWidget {
  const _ChampExpression({required this.valeur, required this.variable, required this.surChange});
  final String valeur;
  final String variable;
  final ValueChanged<String> surChange;

  @override
  State<_ChampExpression> createState() => _ChampExpressionState();
}

class _ChampExpressionState extends State<_ChampExpression> {
  late final _ctrl = TextEditingController(text: widget.valeur);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _inserer(String t, {int recul = 0}) {
    final sel = _ctrl.selection;
    final debut = sel.isValid ? sel.start : _ctrl.text.length;
    final fin = sel.isValid ? sel.end : _ctrl.text.length;
    final nouveau = _ctrl.text.replaceRange(debut, fin, t);
    _ctrl.value = TextEditingValue(text: nouveau, selection: TextSelection.collapsed(offset: debut + t.length - recul));
    HapticFeedback.selectionClick();
    widget.surChange(nouveau);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final v = widget.variable;
    // libellés en TeX : toutes les polices n'ont pas ⁿ, ˣ ou √
    final touches = <(String, String, int)>[
      (v, v, 0),
      ('\\square^{2}', '^2', 0),
      ('\\square^{n}', '^()', 1),
      ('( )', '()', 1),
      ('\\frac{a}{b}', '/', 0),
      ('\\sqrt{\\square}', '√()', 1),
      ('e^{\\square}', 'e^()', 1),
      ('\\ln', 'ln()', 1),
      ('\\pi', 'π', 0),
    ];
    final t = _ctrl.text.trim();
    final lisible = t.isEmpty ? null : Expressions.lire(t.contains('=') ? t.substring(t.lastIndexOf('=') + 1) : t, variable: v) != null;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextField(
        controller: _ctrl,
        onChanged: (s) {
          widget.surChange(s);
          setState(() {});
        },
        autocorrect: false,
        enableSuggestions: false,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: p.texte),
        decoration: InputDecoration(
          hintText: 'Ex. : (1 − x)e^(−x)',
          filled: true,
          fillColor: p.fond,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: p.bord, width: 2)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: p.info, width: 2)),
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: touches.length,
          separatorBuilder: (_, _) => const SizedBox(width: 6),
          itemBuilder: (context, i) {
            final (libelle, texte, recul) = touches[i];
            return GestureDetector(
              onTap: () => _inserer(texte, recul: recul),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.fond,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: p.bord, width: 2),
                  boxShadow: [BoxShadow(color: p.bord, offset: const Offset(0, 2))],
                ),
                child: Formule(libelle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: p.texte)),
              ),
            );
          },
        ),
      ),
      if (lisible != null) ...[
        const SizedBox(height: 6),
        Row(children: [
          Icon(lisible ? Icons.check_circle_rounded : Icons.info_rounded, size: 16, color: lisible ? p.succes : p.or),
          const SizedBox(width: 5),
          Text(lisible ? 'Expression lisible' : 'Vérifie les parenthèses : Kunfox ne lit pas encore cette écriture',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: lisible ? p.succes : p.doux)),
        ]),
      ],
    ]);
  }
}

// ================================================================ correction
class ExamenCorrectionEcran extends ConsumerStatefulWidget {
  const ExamenCorrectionEcran({super.key, required this.epreuveId, required this.copie});
  final String epreuveId;
  final Copie copie;

  @override
  ConsumerState<ExamenCorrectionEcran> createState() => _ExamenCorrectionEcranState();
}

class _ExamenCorrectionEcranState extends ConsumerState<ExamenCorrectionEcran> {
  late final Epreuve _e = epreuveParId(widget.epreuveId)!;

  double _pointsQuestion(int x, int q) {
    final question = _e.exercices[x].questions[q];
    final cle = Copie.cle(x, q);
    if (question.auto) return question.corriger(widget.copie.reponses[cle]) == true ? question.points : 0;
    final coches = widget.copie.coches[cle] ?? const <int>{};
    return coches.fold(0.0, (a, i) => a + question.bareme[i].points);
  }

  double _pointsExo(int x) => List.generate(_e.exercices[x].questions.length, (q) => _pointsQuestion(x, q)).fold(0.0, (a, b) => a + b);
  double get _total => List.generate(_e.exercices.length, _pointsExo).fold(0.0, (a, b) => a + b);
  double get _sur20 => _e.bareMax == 0 ? 0 : (_total / _e.bareMax * 20 * 4).round() / 4;

  void _voirNote() {
    final resultat = ResultatExamen(
      epreuveId: _e.id,
      note: _sur20,
      parExercice: [for (var x = 0; x < _e.exercices.length; x++) (_pointsExo(x), _e.exercices[x].bareMax)],
      aRevoir: {
        for (var x = 0; x < _e.exercices.length; x++)
          for (var q = 0; q < _e.exercices[x].questions.length; q++)
            if (_pointsQuestion(x, q) < _e.exercices[x].questions[q].bareMax * 0.5 && _e.exercices[x].questions[q].chapitre != null)
              _e.exercices[x].questions[q].chapitre!,
      }.toList(),
      duree: DateTime.now().difference(widget.copie.debut),
    );
    ref.read(progressionProvider.notifier).enregistrerExamen(epreuveId: _e.id, note: resultat.note, duree: resultat.duree);
    Copie.effacer(_e.id);
    context.pushReplacement('/k/examen-note', extra: resultat);
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final aCocher = [
      for (var x = 0; x < _e.exercices.length; x++)
        for (var q = 0; q < _e.exercices[x].questions.length; q++)
          if (!_e.exercices[x].questions[q].auto) Copie.cle(x, q),
    ];
    return Scaffold(
      backgroundColor: p.fond,
      body: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: const Text('Correction', style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800)),
          backgroundColor: p.fond.withValues(alpha: 0.92),
          border: null,
          automaticallyImplyLeading: false,
          trailing: Text('${_note(_sur20)}/20', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800, color: p.prim, fontSize: 17)),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          sliver: SliverToBoxAdapter(
            child: aCocher.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: p.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(children: [
                      Icon(Icons.fact_check_rounded, color: p.info),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Les réponses courtes sont corrigées. Pour chaque rédaction, compare avec le corrigé et coche honnêtement les points obtenus : c\'est comme ça qu\'on progresse.',
                          style: TextStyle(fontWeight: FontWeight.w600, color: p.texte, height: 1.35),
                        ),
                      ),
                    ]),
                  ),
          ),
        ),
        for (var x = 0; x < _e.exercices.length; x++) ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 6),
            sliver: SliverToBoxAdapter(
              child: Row(children: [
                Expanded(
                  child: Text('Exercice ${x + 1} · ${_e.exercices[x].titre}',
                      style: const TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 19)),
                ),
                Text('${_note(_pointsExo(x))}/${_note(_e.exercices[x].bareMax)}',
                    style: TextStyle(fontWeight: FontWeight.w800, color: p.prim)),
              ]),
            ),
          ),
          SliverList.builder(
            itemCount: _e.exercices[x].questions.length,
            itemBuilder: (context, q) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: _CarteCorrection(
                question: _e.exercices[x].questions[q],
                reponse: widget.copie.reponses[Copie.cle(x, q)],
                coches: widget.copie.coches[Copie.cle(x, q)] ?? const {},
                surCoche: (i, v) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    final s = widget.copie.coches.putIfAbsent(Copie.cle(x, q), () => <int>{});
                    v ? s.add(i) : s.remove(i);
                  });
                  widget.copie.sauver();
                },
              ),
            ),
          ),
        ],
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          sliver: SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              child: BoutonKunfox(libelle: 'Voir ma note', icone: Icons.emoji_events_rounded, couleur: p.succes, surAppui: _voirNote),
            ),
          ),
        ),
      ]),
    );
  }
}

class _CarteCorrection extends StatefulWidget {
  const _CarteCorrection({required this.question, required this.reponse, required this.coches, required this.surCoche});
  final QuestionEpreuve question;
  final Object? reponse;
  final Set<int> coches;
  final void Function(int, bool) surCoche;

  @override
  State<_CarteCorrection> createState() => _CarteCorrectionState();
}

class _CarteCorrectionState extends State<_CarteCorrection> {
  late bool _ouvert = !widget.question.auto || widget.question.corriger(widget.reponse) != true;

  String _lireReponse() {
    final q = widget.question, r = widget.reponse;
    if (r == null || (r is String && r.trim().isEmpty)) return 'Pas de réponse';
    if (r is int && r >= 0 && r < q.options.length) return q.options[r];
    return r.toString();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final q = widget.question;
    final juste = q.corriger(widget.reponse);
    final couleur = juste == null ? p.info : (juste ? p.succes : p.erreur);
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: couleur.withValues(alpha: 0.7), width: 2),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(
            juste == null ? Icons.edit_note_rounded : (juste ? Icons.check_circle_rounded : Icons.cancel_rounded),
            color: couleur,
          ),
          const SizedBox(width: 8),
          Text(q.numero, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(width: 8),
          Expanded(child: ContenuRiche(q.enonce, espacement: 6, style: TextStyle(fontSize: 14.5, height: 1.4, color: p.texte, fontWeight: FontWeight.w500))),
        ]),
        const SizedBox(height: 10),
        if (q.auto) ...[
          _Ligne(titre: 'Ta réponse', texte: _lireReponse(), couleur: juste == true ? p.succes : p.erreur),
          if (juste != true) _Ligne(titre: 'Réponse attendue', texte: q.reponseLisible, couleur: p.succes),
        ] else ...[
          if (widget.reponse is String && (widget.reponse as String).trim().isNotEmpty)
            _Ligne(titre: 'Ta rédaction', texte: widget.reponse as String, couleur: p.texte),
        ],
        GestureDetector(
          onTap: () => setState(() => _ouvert = !_ouvert),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(children: [
              Text(_ouvert ? 'Masquer le corrigé' : 'Voir le corrigé',
                  style: TextStyle(color: p.info, fontWeight: FontWeight.w800)),
              Icon(_ouvert ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: p.info),
            ]),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: _doux,
          child: _ouvert
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: p.fond, borderRadius: BorderRadius.circular(14)),
                  child: ContenuRiche(q.corrige, espacement: 8, style: TextStyle(fontSize: 15, height: 1.45, color: p.texte, fontWeight: FontWeight.w500)),
                )
              : const SizedBox(width: double.infinity),
        ),
        if (!q.auto) ...[
          const SizedBox(height: 10),
          Text('Barème : coche ce que tu as obtenu', style: TextStyle(color: p.doux, fontWeight: FontWeight.w800, fontSize: 12.5)),
          for (final (i, c) in q.bareme.indexed)
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => widget.surCoche(i, !widget.coches.contains(i)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: widget.coches.contains(i) ? p.succes : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: widget.coches.contains(i) ? p.succes : p.bord, width: 2),
                    ),
                    child: widget.coches.contains(i) ? const Icon(Icons.check_rounded, size: 18, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: TexteRiche(c.texte, style: TextStyle(fontSize: 14.5, height: 1.35, color: p.texte, fontWeight: FontWeight.w600))),
                  Text('${_note(c.points)} pt', style: TextStyle(color: p.doux, fontWeight: FontWeight.w800)),
                ]),
              ),
            ),
        ],
      ]),
    );
  }
}

class _Ligne extends StatelessWidget {
  const _Ligne({required this.titre, required this.texte, required this.couleur});
  final String titre, texte;
  final Color couleur;
  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 128, child: Text(titre, style: TextStyle(color: p.doux, fontWeight: FontWeight.w700))),
        Expanded(child: TexteRiche(texte, style: TextStyle(color: couleur, fontWeight: FontWeight.w800, fontSize: 15))),
      ]),
    );
  }
}

// ====================================================================== note
class ResultatExamen {
  const ResultatExamen({
    required this.epreuveId,
    required this.note,
    required this.parExercice,
    required this.aRevoir,
    required this.duree,
  });
  final String epreuveId;
  final double note;
  final List<(double, double)> parExercice;
  final List<String> aRevoir;
  final Duration duree;
}

class ExamenNoteEcran extends StatefulWidget {
  const ExamenNoteEcran({super.key, required this.resultat});
  final ResultatExamen resultat;

  @override
  State<ExamenNoteEcran> createState() => _ExamenNoteEcranState();
}

class _ExamenNoteEcranState extends State<ExamenNoteEcran> with SingleTickerProviderStateMixin {
  final _confettis = ConfettisControleur();
  late final AnimationController _t = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))..forward();

  bool get _admis => widget.resultat.note >= 10;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1900), () {
      if (!mounted) return;
      if (_admis) {
        HapticFeedback.heavyImpact();
        Sons.jouer(Son.fin);
        _confettis.pluie(nombre: widget.resultat.note >= 14 ? 200 : 120);
      } else {
        HapticFeedback.mediumImpact();
        Sons.jouer(Son.juste);
      }
    });
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  void _partager(Epreuve e) {
    final r = widget.resultat;
    partagerCarte(
      context,
      CartePartage(
        bandeau: 'BAC ${e.serie} BLANC',
        content: _admis,
        titre: '${_note(r.note)}/20 · ${mention(r.note)}',
        sousTitre: e.titre,
        stats: [
          StatCarte(Icons.grade_rounded, _note(r.note), 'SUR 20'),
          StatCarte(Icons.schedule_rounded, '${r.duree.inMinutes} min', 'DURÉE'),
          StatCarte(Icons.scale_rounded, '${e.coefficient}', 'COEF.'),
        ],
      ),
      texte: 'J\'ai eu ${_note(r.note)}/20 à l\'épreuve « ${e.titre} » sur Kunfox. À ton tour ! https://kunfox.dropletmesh.app',
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final r = widget.resultat;
    final e = epreuveParId(r.epreuveId)!;
    final aRevoir = r.aRevoir.where((id) => CurriculumData.findChapterById(id) != null).toList();
    Animation<double> iv(double a, double b, [Curve c = _doux]) => CurvedAnimation(parent: _t, curve: Interval(a, b, curve: c));
    final couleur = r.note >= 14 ? _or : (_admis ? p.succes : p.prim);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (fait, _) {
        if (!fait) context.go('/k');
      },
      child: Scaffold(
        backgroundColor: _encre,
        body: Stack(children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_royal, _encre]),
              ),
            ),
          ),
          Positioned.fill(child: FondRayons(couleur: couleur, centre: const Alignment(0, -0.55))),
          SafeArea(
            child: ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 28), children: [
              Center(
                child: AnimatedBuilder(
                  animation: _t,
                  builder: (context, _) {
                    final remplir = iv(0.1, 0.72, Curves.easeOutCubic).value;
                    final pop = iv(0.7, 0.9, _ressort).value;
                    return Transform.scale(
                      scale: 0.9 + 0.1 * pop,
                      child: SizedBox(
                        width: 210,
                        height: 210,
                        child: Stack(alignment: Alignment.center, children: [
                          CustomPaint(size: const Size(210, 210), painter: _Jauge(remplir * r.note / 20, couleur)),
                          Column(mainAxisSize: MainAxisSize.min, children: [
                            Text(_note((remplir * r.note * 4).round() / 4),
                                style: const TextStyle(
                                    fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 60, height: 1, color: Colors.white)),
                            const Text('/ 20', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w800, fontSize: 18)),
                          ]),
                        ]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              _Monte(
                a: iv(0.72, 0.95, _ressort),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(color: couleur, borderRadius: BorderRadius.circular(99)),
                    child: Text(mention(r.note).toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.4, color: couleur == _or ? _encre : Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    r.note >= 16
                        ? 'Magistral. Tu es prêt pour le jour J.'
                        : r.note >= 12
                            ? 'Très solide ! Encore un peu de régularité et la mention est à toi.'
                            : _admis
                                ? 'Admis ! Consolide les chapitres ci-dessous pour viser plus haut.'
                                : 'Pas encore. Chaque correction lue est un point gagné le jour du Bac : suis ton plan.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16, height: 1.4),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              _Monte(
                a: iv(0.78, 1),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(children: [
                    for (final (i, (pts, max)) in r.parExercice.indexed)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(
                              child: Text('Ex. ${i + 1} · ${e.exercices[i].titre}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                            Text('${_note(pts)}/${_note(max)}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
                          ]),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: AnimatedBuilder(
                              animation: _t,
                              builder: (context, _) => LinearProgressIndicator(
                                value: max == 0 ? 0 : iv(0.8, 1).value * pts / max,
                                minHeight: 10,
                                backgroundColor: Colors.white.withValues(alpha: 0.12),
                                color: pts >= max / 2 ? p.succes : p.prim,
                              ),
                            ),
                          ),
                        ]),
                      ),
                  ]),
                ),
              ),
              if (aRevoir.isNotEmpty) ...[
                const SizedBox(height: 18),
                const Text('Ton plan de réussite',
                    style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white)),
                const SizedBox(height: 4),
                const Text('Les chapitres où tu as perdu le plus de points. Refais leurs leçons, puis retente l\'épreuve.',
                    style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w600, height: 1.35)),
                const SizedBox(height: 10),
                for (final ch in aRevoir.map((id) => CurriculumData.findChapterById(id)!))
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 2),
                      ),
                      child: Row(children: [
                        const Icon(Icons.flag_rounded, color: _or),
                        const SizedBox(width: 10),
                        Expanded(child: Text(ch.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                        const Icon(Icons.chevron_right_rounded, color: Colors.white38),
                      ]),
                    ),
              ],
              const SizedBox(height: 22),
              Row(children: [
                BoutonKunfox(
                  libelle: '',
                  etiquette: 'Partager ma note',
                  icone: Icons.ios_share_rounded,
                  contour: true,
                  largeurPleine: false,
                  surAppui: () => _partager(e),
                ),
                const SizedBox(width: 10),
                Expanded(child: BoutonKunfox(libelle: 'Terminer', couleur: _or, couleurTexte: _encre, surAppui: () => context.go('/k'))),
              ]),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => context.pushReplacement('/k/examen/${e.id}'),
                  child: const Text('RETENTER L\'ÉPREUVE',
                      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                ),
              ),
            ]),
          ),
          Positioned.fill(child: ConfettisFlame(controleur: _confettis)),
        ]),
      ),
    );
  }
}

class _Jauge extends CustomPainter {
  _Jauge(this.part, this.couleur);
  final double part;
  final Color couleur;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 12;
    final fond = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), math.pi * 0.75, math.pi * 1.5, false, fond);
    final arc = Paint()
      ..shader = SweepGradient(
        startAngle: math.pi * 0.75,
        endAngle: math.pi * 2.25,
        colors: [couleur.withValues(alpha: 0.7), couleur],
      ).createShader(Rect.fromCircle(center: c, radius: r))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
    if (part > 0) canvas.drawArc(Rect.fromCircle(center: c, radius: r), math.pi * 0.75, math.pi * 1.5 * part.clamp(0, 1), false, arc);
  }

  @override
  bool shouldRepaint(_Jauge ancien) => ancien.part != part || ancien.couleur != couleur;
}

// ======================================================== carte ultime boss
/// La carte de l'épreuve finale, au bout du parcours et dans Réviser.
class CarteUltimeBoss extends ConsumerWidget {
  const CarteUltimeBoss({super.key, required this.epreuve, this.compacte = false});
  final Epreuve epreuve;
  final bool compacte;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prog = ref.watch(progressionProvider);
    final note = prog.noteExamen(epreuve.id);
    final matiere = CurriculumData.findById(epreuve.matiere);
    final lecons = matiere?.chapters.expand((c) => c.lessons).toList() ?? const [];
    final faites = lecons.where((l) => prog.leconsFaites.contains(l.id)).length;
    final enCours = Copie.charger(epreuve.id) != null;
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        context.push('/k/examen/${epreuve.id}');
      },
      child: Container(
        margin: compacte ? EdgeInsets.zero : const EdgeInsets.fromLTRB(20, 24, 20, 0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_royal, _encre]),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _or, width: 2.5),
          boxShadow: [
            const BoxShadow(color: Color(0xFF0A1024), offset: Offset(0, 6)),
            BoxShadow(color: _or.withValues(alpha: 0.25), blurRadius: 24),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(children: [
          const Positioned.fill(child: FondRayons(couleur: _or, centre: Alignment(-0.7, -0.2), intensite: 0.6)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                _Couronne(taille: compacte ? 58 : 72),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('ÉPREUVE FINALE · BAC ${epreuve.serie}',
                        style: const TextStyle(color: _or, fontWeight: FontWeight.w800, letterSpacing: 1.2, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text('Le grand Bac blanc de ${matiere?.title ?? epreuve.titre}',
                        style: const TextStyle(
                            fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 19, height: 1.15, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('${epreuve.session} · ${_duree(epreuve.dureeMinutes)} · coef. ${epreuve.coefficient}',
                        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 13)),
                  ]),
                ),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                if (note != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: _or, borderRadius: BorderRadius.circular(99)),
                    child: Text('Record ${_note(note)}/20',
                        style: const TextStyle(color: _encre, fontWeight: FontWeight.w800, fontSize: 12.5)),
                  )
                else
                  Expanded(
                    child: Text(
                      lecons.isEmpty || faites >= lecons.length
                          ? 'Tu es prêt : à toi de jouer.'
                          : 'Conseillé après le parcours ($faites/${lecons.length} leçons), mais tu peux t\'y essayer dès maintenant.',
                      style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w600, fontSize: 12.5, height: 1.3),
                    ),
                  ),
                if (note != null) const Spacer(),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: _or,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(color: Color(0xFFB7800F), offset: Offset(0, 3))],
                  ),
                  child: Text(enCours ? 'REPRENDRE' : (note != null ? 'REJOUER' : 'COMMENCER'),
                      style: const TextStyle(color: _encre, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
