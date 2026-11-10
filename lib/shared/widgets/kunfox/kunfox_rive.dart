// ============================================================================
// KUNFOX EN RIVE : la mascotte et les effets de jeu.
// ----------------------------------------------------------------------------
// Les fichiers .riv sont construits avec la Rive CLI depuis rive/ (dépôt,
// branche rive-splash) par rive/outils/generer_mascotte.py et generer_effets.py.
//
//   KunfoxMascotte(humeur: HumeurKunfox.joie)     Kabi (kabi.riv), machine « Kabi »
//   KunfoxFlamme(allumee: true)                   machine « Flamme », nombre `allumee`
//   KunfoxCoeur(perdu: false)                     machine « Coeur », nombre `vide`
//   KunfoxEffet.reussite() / .erreur() / .niveau() jouent une fois
//
// Changer `humeur`, `allumee` ou `perdu` fait jouer la transition dans Rive
// (fondu de 180 ms entre humeurs, allumage, cœur qui se brise ou se recharge).
// « Réduire les animations » : on affiche le même fichier, figé sur sa
// première image, sans le faire avancer.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import '../../../core/services/storage_service.dart';

enum HumeurKunfox { attente, joie, courage, reflexion, fete, salut, dodo }

/// Les directions du regard (même ordre que l'entrée `regard` du .riv).
enum RegardKunfox { centre, gauche, droite, bas, haut }

/// Pilote une entrée nombre d'une machine à états, et la tient à jour.
class _RiveNombre extends StatefulWidget {
  const _RiveNombre({
    required this.fichier,
    required this.machine,
    required this.entree,
    required this.valeur,
    required this.taille,
    required this.semantique,
    this.autres = const {},
  });

  /// D'autres entrées nombre à tenir à jour (ex. `regard`).
  final Map<String, double> autres;

  final String fichier;
  final String machine;
  final String? entree;
  final double valeur;
  final Size taille;
  final String semantique;

  @override
  State<_RiveNombre> createState() => _RiveNombreState();
}

class _RiveNombreState extends State<_RiveNombre> {
  // Un fichier n'est lu et décodé qu'une fois pour toute l'app.
  static final Map<String, Future<RiveFile>> _fichiers = {};

  Artboard? _artboard;
  SMINumber? _entree;
  final Map<String, SMINumber> _autres = {};
  StateMachineController? _controleur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    try {
      final fichier = await _fichiers.putIfAbsent(widget.fichier, () => RiveFile.asset(widget.fichier));
      if (!mounted) return;
      final artboard = fichier.mainArtboard.instance();
      final c = StateMachineController.fromArtboard(artboard, widget.machine);
      if (c != null) {
        artboard.addController(c);
        if (widget.entree != null) {
          final e = c.findInput<double>(widget.entree!);
          if (e is SMINumber) _entree = e..value = widget.valeur;
        }
        widget.autres.forEach((nom, v) {
          final e = c.findInput<double>(nom);
          if (e is SMINumber) _autres[nom] = e..value = v;
        });
        if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) c.isActive = false;
      }
      setState(() {
        _artboard = artboard;
        _controleur = c;
      });
    } catch (e) {
      debugPrint('[Kunfox] ${widget.fichier} : $e');
    }
  }

  @override
  void didUpdateWidget(covariant _RiveNombre ancien) {
    super.didUpdateWidget(ancien);
    if (ancien.valeur != widget.valeur) _entree?.value = widget.valeur;
    widget.autres.forEach((nom, v) {
      if (ancien.autres[nom] != v) _autres[nom]?.value = v;
    });
  }

  @override
  void dispose() {
    _controleur?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = _artboard;
    return Semantics(
      label: widget.semantique,
      image: true,
      child: SizedBox.fromSize(
        size: widget.taille,
        child: a == null ? null : Rive(artboard: a, fit: BoxFit.contain),
      ),
    );
  }
}

/// Toutes les poses de kabi.riv (même ordre que l'entrée `pose`).
enum PoseKabi {
  repos, coucou, muscles, squat, jumpingJacks, course, halteres, victoire, fatigue, dodo,
  etirement, pret, pompes, gainage, fente, burpee, boxe, corde, genouxHauts, reflexion,
  hausseEpaules, presenteGauche, presenteDroite, mainsHanches, applaudit, coeur, ecoute, poingLeve, brasCroises,
}

/// Les expressions de kabi.riv (même ordre que l'entrée `mood`).
enum ExpressionKabi { neutre, joie, determine, fatigue, triste, surpris, sommeil, fier }

/// Les couleurs de Kabi (même ordre que l'entrée `color` de kabi.riv).
enum CouleurKabi {
  noir('Noir', Color(0xFF1F1F1F)),
  bleu('Bleu', Color(0xFF2F5FD6)),
  rouge('Rouge', Color(0xFFCF3434)),
  rose('Rose', Color(0xFFEF77A8)),
  vert('Vert', Color(0xFF2A9A64)),
  violet('Violet', Color(0xFF6A4BD0)),
  orange('Orange', Color(0xFFF07B2B)),
  marron('Marron', Color(0xFF7A4A2A));

  const CouleurKabi(this.nom, this.teinte);
  final String nom;
  final Color teinte;
}

/// La couleur de Kabi choisie par l'élève (Profil), gardée sur le téléphone.
class ChoixKabi {
  ChoixKabi._();

  static const _cle = 'kunfox.kabi.couleur';

  static final ValueNotifier<CouleurKabi> couleur = ValueNotifier(_lire());

  static CouleurKabi _lire() {
    final i = int.tryParse(StorageService.getString(_cle) ?? '');
    if (i == null || i < 0 || i >= CouleurKabi.values.length) return CouleurKabi.orange;
    return CouleurKabi.values[i];
  }

  /// À appeler une fois le stockage prêt (la valeur lue au démarrage peut
  /// précéder son chargement).
  static void relire() => couleur.value = _lire();

  static void choisir(CouleurKabi c) {
    couleur.value = c;
    StorageService.setString(_cle, '${c.index}');
  }
}

/// KABI, la mascotte de Kunfox (assets/rive/kabi.riv, machine « Kabi ») :
/// chaque humeur devient une pose et une expression du fichier, le regard
/// suit la question (entrées `lookX` / `lookY`, de −100 à 100), la couleur
/// est celle que l'élève a choisie. Un toucher le fait réagir (`poke`).
///
/// Si le fichier ne se lit pas (vieux moteur Rive), l'ancienne mascotte
/// s'affiche à la place : jamais de trou dans l'écran.
class KunfoxMascotte extends StatefulWidget {
  const KunfoxMascotte({super.key, this.humeur = HumeurKunfox.attente, this.taille = 180, this.regard = RegardKunfox.centre, this.couleur, this.pose, this.expression});

  /// Une pose précise de Kabi, à la place de celle de l'humeur (la carte des
  /// leçons en donne une à chaque type de leçon).
  final PoseKabi? pose;
  final ExpressionKabi? expression;

  final HumeurKunfox humeur;
  final double taille;

  /// Où Kabi pose les yeux.
  final RegardKunfox regard;

  /// Une couleur imposée (aperçu du choix) ; sinon celle de l'élève.
  final CouleurKabi? couleur;

  static const _libelles = {
    HumeurKunfox.attente: 'Kabi te regarde',
    HumeurKunfox.joie: 'Kabi saute de joie',
    HumeurKunfox.courage: 'Kabi t\'encourage',
    HumeurKunfox.reflexion: 'Kabi réfléchit',
    HumeurKunfox.fete: 'Kabi fait la fête',
    HumeurKunfox.salut: 'Kabi te salue',
    HumeurKunfox.dodo: 'Kabi dort',
  };

  /// Pose et expression de kabi.riv pour chaque humeur.
  /// Poses : 0 repos, 1 coucou, 7 victoire, 9 dodo, 19 réflexion,
  /// 24 applaudit, 27 poing levé. Expressions : 0 neutre, 1 joie,
  /// 2 détermination, 6 sommeil, 7 fierté.
  static const _poses = {
    HumeurKunfox.attente: (0, 0),
    HumeurKunfox.joie: (7, 1),
    HumeurKunfox.courage: (27, 2),
    HumeurKunfox.reflexion: (19, 0),
    HumeurKunfox.fete: (24, 7),
    HumeurKunfox.salut: (1, 1),
    HumeurKunfox.dodo: (9, 6),
  };

  static const _regards = {
    RegardKunfox.centre: (0.0, 0.0),
    RegardKunfox.gauche: (-80.0, 0.0),
    RegardKunfox.droite: (80.0, 0.0),
    RegardKunfox.bas: (0.0, 80.0),
    RegardKunfox.haut: (0.0, -80.0),
  };

  @override
  State<KunfoxMascotte> createState() => _KunfoxMascotteState();
}

class _KunfoxMascotteState extends State<KunfoxMascotte> {
  static Future<RiveFile>? _fichier;
  static bool _illisible = false;

  Artboard? _artboard;
  StateMachineController? _controleur;
  final Map<String, SMINumber> _nombres = {};
  SMITrigger? _poke, _saut, _coucou;

  @override
  void initState() {
    super.initState();
    ChoixKabi.couleur.addListener(_appliquer);
    if (!_illisible) _charger();
  }

  Future<void> _charger() async {
    try {
      final f = await (_fichier ??= RiveFile.asset('assets/rive/kabi.riv'));
      if (!mounted) return;
      final a = f.mainArtboard.instance();
      final c = StateMachineController.fromArtboard(a, 'Kabi');
      if (c == null) throw StateError('machine « Kabi » absente');
      a.addController(c);
      for (final n in ['pose', 'mood', 'color', 'lookX', 'lookY']) {
        final e = c.findInput<double>(n);
        if (e is SMINumber) _nombres[n] = e;
      }
      // Kabi sans lunettes de soleil : on veut voir ses yeux suivre la question.
      final lunettes = c.findInput<bool>('glasses');
      if (lunettes is SMIBool) lunettes.value = false;
      final poke = c.findInput<bool>('poke');
      final saut = c.findInput<bool>('jump');
      final coucou = c.findInput<bool>('hi');
      if (poke is SMITrigger) _poke = poke;
      if (saut is SMITrigger) _saut = saut;
      if (coucou is SMITrigger) _coucou = coucou;
      if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) c.isActive = false;
      _controleur = c;
      _artboard = a;
      _appliquer();
      setState(() {});
    } catch (e) {
      debugPrint('[Kunfox] kabi.riv : $e');
      _illisible = true;
      if (mounted) setState(() {});
    }
  }

  void _appliquer() {
    var (pose, mood) = KunfoxMascotte._poses[widget.humeur]!;
    if (widget.pose != null) pose = widget.pose!.index;
    if (widget.expression != null) mood = widget.expression!.index;
    final (x, y) = KunfoxMascotte._regards[widget.regard]!;
    _nombres['pose']?.value = pose.toDouble();
    _nombres['mood']?.value = mood.toDouble();
    _nombres['color']?.value = (widget.couleur ?? ChoixKabi.couleur.value).index.toDouble();
    _nombres['lookX']?.value = x;
    _nombres['lookY']?.value = y;
  }

  @override
  void didUpdateWidget(covariant KunfoxMascotte ancien) {
    super.didUpdateWidget(ancien);
    _appliquer();
    if (ancien.humeur != widget.humeur) {
      if (widget.humeur == HumeurKunfox.joie || widget.humeur == HumeurKunfox.fete) _saut?.fire();
      if (widget.humeur == HumeurKunfox.salut) _coucou?.fire();
    }
  }

  @override
  void dispose() {
    ChoixKabi.couleur.removeListener(_appliquer);
    _controleur?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_illisible) {
      return _RiveNombre(
        fichier: 'assets/rive/kunfox_mascotte.riv',
        machine: 'Kunfox',
        entree: 'humeur',
        valeur: widget.humeur.index.toDouble(),
        taille: Size(widget.taille, widget.taille * 7 / 6),
        semantique: KunfoxMascotte._libelles[widget.humeur]!,
        autres: {'regard': widget.regard.index.toDouble()},
      );
    }
    final a = _artboard;
    return Semantics(
      label: KunfoxMascotte._libelles[widget.humeur]!,
      image: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _poke?.fire(),
        child: SizedBox(
          // l'artboard de Kabi fait 1000 × 1200
          width: widget.taille,
          height: widget.taille * 1.2,
          child: a == null ? null : Rive(artboard: a, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

/// Le choix de la couleur de Kabi : un aperçu et huit pastilles.
class ChoixCouleurKabi extends StatelessWidget {
  const ChoixCouleurKabi({super.key, this.couleurTexte, this.couleurBord, this.pastillesSeules = false});

  /// Seulement les pastilles, centrées (l'accueil montre déjà Kabi en grand).
  final bool pastillesSeules;
  final Color? couleurTexte;
  final Color? couleurBord;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<CouleurKabi>(
        valueListenable: ChoixKabi.couleur,
        builder: (context, actuelle, _) => pastillesSeules
            ? Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: _pastilles(actuelle))
            : Row(children: [
          const KunfoxMascotte(humeur: HumeurKunfox.joie, taille: 84),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Ton Kabi', style: Theme.of(context).textTheme.titleMedium),
              Text(actuelle.nom, style: TextStyle(color: couleurTexte, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: _pastilles(actuelle)),
            ]),
          ),
        ]),
      );

  List<Widget> _pastilles(CouleurKabi actuelle) => [
                for (final c in CouleurKabi.values)
                  Semantics(
                    button: true,
                    selected: c == actuelle,
                    label: 'Kabi ${c.nom.toLowerCase()}',
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        ChoixKabi.choisir(c);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: c.teinte,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: c == actuelle ? (couleurTexte ?? Colors.black) : (couleurBord ?? Colors.transparent),
                            width: c == actuelle ? 3 : 1.5,
                          ),
                        ),
                        child: c == actuelle ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
                      ),
                    ),
                  ),
              ];
}

/// La flamme de série : grise si éteinte, s'allume quand `allumee` passe à vrai.
class KunfoxFlamme extends StatelessWidget {
  const KunfoxFlamme({super.key, required this.allumee, this.taille = 48});

  final bool allumee;
  final double taille;

  @override
  Widget build(BuildContext context) => _RiveNombre(
        fichier: 'assets/rive/kunfox_flamme.riv',
        machine: 'Flamme',
        entree: 'allumee',
        valeur: allumee ? 1 : 0,
        taille: Size(taille * 300 / 340, taille),
        semantique: allumee ? 'Série en cours' : 'Série éteinte',
      );
}

/// Un cœur de vie : se brise quand `perdu` passe à vrai, se recharge au retour.
class KunfoxCoeur extends StatelessWidget {
  const KunfoxCoeur({super.key, required this.perdu, this.taille = 32});

  final bool perdu;
  final double taille;

  @override
  Widget build(BuildContext context) => _RiveNombre(
        fichier: 'assets/rive/kunfox_coeur.riv',
        machine: 'Coeur',
        entree: 'vide',
        valeur: perdu ? 1 : 0,
        taille: Size.square(taille),
        semantique: perdu ? 'Vie perdue' : 'Vie',
      );
}

/// Effets qui jouent une fois à l'affichage : bonne réponse, erreur, niveau.
/// Pour rejouer, donner une nouvelle `key`.
class KunfoxEffet extends StatelessWidget {
  const KunfoxEffet._(this._nom, this._machine, this._libelle, {super.key, this.taille = 120});

  const KunfoxEffet.reussite({Key? key, double taille = 120})
      : this._('reussite', 'Reussite', 'Bonne réponse', key: key, taille: taille);
  const KunfoxEffet.erreur({Key? key, double taille = 120})
      : this._('erreur', 'Erreur', 'Mauvaise réponse', key: key, taille: taille);
  const KunfoxEffet.niveau({Key? key, double taille = 200})
      : this._('niveau', 'Niveau', 'Niveau supérieur', key: key, taille: taille);

  final String _nom;
  final String _machine;
  final String _libelle;
  final double taille;

  @override
  Widget build(BuildContext context) => _RiveNombre(
        fichier: 'assets/rive/kunfox_$_nom.riv',
        machine: _machine,
        entree: null,
        valeur: 0,
        taille: Size.square(taille),
        semantique: _libelle,
      );
}
