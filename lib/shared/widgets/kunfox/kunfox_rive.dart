// ============================================================================
// KUNFOX EN RIVE : la mascotte et les effets de jeu.
// ----------------------------------------------------------------------------
// Les fichiers .riv sont construits avec la Rive CLI depuis rive/ (dépôt,
// branche rive-splash) par rive/outils/generer_mascotte.py et generer_effets.py.
//
//   KunfoxMascotte(humeur: HumeurKunfox.joie)     machine « Kunfox », nombre `humeur`
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
import 'package:rive/rive.dart';

enum HumeurKunfox { attente, joie, courage, reflexion, fete, salut, dodo }

/// Pilote une entrée nombre d'une machine à états, et la tient à jour.
class _RiveNombre extends StatefulWidget {
  const _RiveNombre({
    required this.fichier,
    required this.machine,
    required this.entree,
    required this.valeur,
    required this.taille,
    required this.semantique,
  });

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

/// Le renard Kunfox, avec son humeur du moment.
class KunfoxMascotte extends StatelessWidget {
  const KunfoxMascotte({super.key, this.humeur = HumeurKunfox.attente, this.taille = 180});

  final HumeurKunfox humeur;
  final double taille;

  static const _libelles = {
    HumeurKunfox.attente: 'Kunfox te regarde',
    HumeurKunfox.joie: 'Kunfox saute de joie',
    HumeurKunfox.courage: 'Kunfox t\'encourage',
    HumeurKunfox.reflexion: 'Kunfox réfléchit',
    HumeurKunfox.fete: 'Kunfox fait la fête',
    HumeurKunfox.salut: 'Kunfox te salue',
    HumeurKunfox.dodo: 'Kunfox dort',
  };

  @override
  Widget build(BuildContext context) => _RiveNombre(
        fichier: 'assets/rive/kunfox_mascotte.riv',
        machine: 'Kunfox',
        entree: 'humeur',
        valeur: humeur.index.toDouble(),
        // l'artboard fait 600 × 700
        taille: Size(taille, taille * 7 / 6),
        semantique: _libelles[humeur]!,
      );
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
