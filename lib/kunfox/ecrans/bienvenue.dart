// ============================================================================
// BIENVENUE — l'arrivée dans Kunfox, en quatre pas.
// ----------------------------------------------------------------------------
//   0. Kunfox salue : « Révise ton BAC, 5 minutes par jour. »
//   1. Ta série (C, D, TI, A)
//   2. Ton objectif du jour
//   3. Ton pseudo et les conditions → création du profil (sur l'appareil)
// Remplace l'ancienne présentation technique (maillage, P2P...) et l'ancien
// écran de connexion : les deux routes mènent ici.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/services/storage_service.dart';
import '../../shared/widgets/kunfox/kunfox_rive.dart';
import '../composants/bouton.dart';
import '../donnees/compte_droplet.dart';
import '../flame/effets_flame.dart';
import '../theme/palette.dart';

class BienvenueEcran extends ConsumerStatefulWidget {
  const BienvenueEcran({super.key, this.depuisDroplet = false});

  /// Revenu de Droplet sans sauvegarde : le pseudo est connu, on reprend
  /// à la série.
  final bool depuisDroplet;

  @override
  ConsumerState<BienvenueEcran> createState() => _BienvenueEcranState();
}

class _BienvenueEcranState extends ConsumerState<BienvenueEcran> {
  final _pseudo = TextEditingController();
  final _confettis = ConfettisControleur();
  int _pas = 0;
  String? _serie;
  int? _objectif;
  bool _conditions = false;
  bool _enCours = false;
  String? _erreur;

  static const _objectifs = [
    (5, 'Détendu', '5 min par jour'),
    (10, 'Régulier', '10 min par jour'),
    (15, 'Sérieux', '15 min par jour'),
    (20, 'Intense', '20 min par jour'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.depuisDroplet) {
      _pas = 1;
      _pseudo.text = CompteDroplet.pseudo ?? '';
      _conditions = false;
    }
  }

  Future<void> _avecDroplet() async {
    HapticFeedback.selectionClick();
    final ouvert = await CompteDroplet.demarrer();
    if (!ouvert && mounted) {
      final p = Palette.of(context);
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: p.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Droplet n\'est pas installé', style: Theme.of(ctx).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Installe Droplet pour sauvegarder ta progression et la retrouver sur un autre téléphone.',
                  textAlign: TextAlign.center, style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, height: 1.4)),
              const SizedBox(height: 18),
              BoutonKunfox(libelle: 'Obtenir Droplet', couleur: _bleuDroplet, surAppui: () {
                Navigator.of(ctx).pop();
                CompteDroplet.obtenirDroplet();
              }),
            ]),
          ),
        ),
      );
    }
  }

  static const _bleuDroplet = Color(0xFF2F6BFF);

  @override
  void dispose() {
    _pseudo.dispose();
    super.dispose();
  }

  void _suivant() {
    HapticFeedback.selectionClick();
    setState(() => _pas++);
  }

  Future<void> _creer() async {
    final pseudo = _pseudo.text.trim();
    if (pseudo.length < 2 || pseudo.length > 20) {
      setState(() => _erreur = 'Ton pseudo doit faire entre 2 et 20 caractères.');
      return;
    }
    if (!_conditions) {
      setState(() => _erreur = 'Accepte les conditions pour continuer.');
      return;
    }
    setState(() {
      _erreur = null;
      _enCours = true;
    });
    try {
      if (_objectif != null) await StorageService.setString('kunfox.objectif', '$_objectif');
      await StorageService.setOnboardingComplete();
      await ref.read(authProvider.notifier).login(pseudo, _serie ?? BacSeries.all.first);
      if (!mounted) return;
      _confettis.pluie(nombre: 70);
      HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (mounted) context.go('/k');
    } catch (_) {
      if (mounted) {
        setState(() {
          _enCours = false;
          _erreur = 'La création du profil a échoué. Réessaie.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final pas = [_accueil, _choixSerie, _choixObjectif, _profil][_pas];

    return Scaffold(
      body: Stack(children: [
        SafeArea(
          child: Column(children: [
            if (_pas > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(children: [
                  IconButton(
                    tooltip: 'Retour',
                    onPressed: _enCours ? null : () => setState(() => _pas--),
                    icon: Icon(Icons.arrow_back_rounded, color: p.doux),
                  ),
                  Expanded(child: BarreProgres(valeur: _pas / 3, couleur: p.prim)),
                ]),
              ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 380),
                switchInCurve: const Cubic(0.16, 1, 0.3, 1),
                transitionBuilder: (e, a) => SlideTransition(
                  position: Tween(begin: const Offset(0.2, 0), end: Offset.zero).animate(a),
                  child: FadeTransition(opacity: a, child: e),
                ),
                child: KeyedSubtree(key: ValueKey(_pas), child: pas(p)),
              ),
            ),
          ]),
        ),
        Positioned.fill(child: ConfettisFlame(controleur: _confettis)),
      ]),
    );
  }

  /// Kunfox qui parle dans une bulle, en tête de chaque pas.
  Widget _parle(Palette p, String texte, HumeurKunfox humeur) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          KunfoxMascotte(humeur: humeur, taille: 96),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: p.surface,
                border: Border.all(color: p.bord, width: 2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: Text(texte, style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
        ]),
      );

  Widget _accueil(Palette p) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const Spacer(),
          const KunfoxMascotte(humeur: HumeurKunfox.salut, taille: 220),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: 'Kun', style: TextStyle(color: p.texte)),
              TextSpan(text: 'fox', style: TextStyle(color: p.prim)),
            ]),
            style: const TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 44, letterSpacing: -1.2),
          ),
          const SizedBox(height: 8),
          Text('Révise ton BAC, cinq minutes par jour.\nEt progresse pour de vrai.',
              textAlign: TextAlign.center,
              style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, fontSize: 17, height: 1.4)),
          const Spacer(),
          BoutonKunfox(libelle: 'C\'est parti', surAppui: _suivant),
          const SizedBox(height: 12),
          // Avoir déjà un profil, c'est le retrouver : par Droplet.
          BoutonKunfox(
            libelle: 'Continuer avec Droplet',
            icone: Icons.water_drop_rounded,
            couleur: _bleuDroplet,
            surAppui: _avecDroplet,
          ),
          const SizedBox(height: 10),
          Text('Déjà un profil ? Continue avec Droplet pour le retrouver.',
              textAlign: TextAlign.center, style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, fontSize: 13)),
        ]),
      );

  Widget _choixSerie(Palette p) => Column(children: [
        _parle(p, 'Salut ! Tu prépares quelle série ?', HumeurKunfox.salut),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 12), children: [
            for (final s in BacSeries.all)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _Choix(
                  titre: s,
                  sousTitre: BacSeries.getDescription(s),
                  choisi: _serie == s,
                  surAppui: () => setState(() => _serie = s),
                ),
              ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: BoutonKunfox(libelle: 'Continuer', surAppui: _serie == null ? null : _suivant),
        ),
      ]);

  Widget _choixObjectif(Palette p) => Column(children: [
        _parle(p, 'Combien de temps veux-tu réviser chaque jour ?', HumeurKunfox.reflexion),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 12), children: [
            for (final o in _objectifs)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _Choix(
                  titre: o.$2,
                  sousTitre: o.$3,
                  choisi: _objectif == o.$1,
                  surAppui: () => setState(() => _objectif = o.$1),
                ),
              ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: BoutonKunfox(libelle: 'Continuer', surAppui: _objectif == null ? null : _suivant),
        ),
      ]);

  Widget _profil(Palette p) => Column(children: [
        _parle(
          p,
          _enCours ? 'Je prépare ton parcours…' : 'Dernière chose : comment je t\'appelle ?',
          _enCours ? HumeurKunfox.reflexion : HumeurKunfox.joie,
        ),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 12), children: [
            TextField(
              controller: _pseudo,
              enabled: !_enCours,
              maxLength: 20,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: p.texte),
              decoration: InputDecoration(
                hintText: 'Ton pseudo',
                counterText: '',
                filled: true,
                fillColor: p.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: p.bord, width: 2)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: p.info, width: 2)),
                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: p.bord, width: 2)),
              ),
              onSubmitted: (_) => _creer(),
            ),
            if (_serie == null) ...[
              const SizedBox(height: 16),
              Text('TA SÉRIE', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1, color: p.doux, fontSize: 12)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final s in BacSeries.all)
                  ChoiceChip(
                    label: Text(s),
                    selected: (_serie ?? BacSeries.all.first) == s,
                    onSelected: (_) => setState(() => _serie = s),
                  ),
              ]),
            ],
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _conditions,
              onChanged: _enCours ? null : (v) => setState(() => _conditions = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: p.prim,
              title: Text('J\'accepte les conditions d\'utilisation et la politique de confidentialité (kunfox.dropletmesh.app).',
                  style: TextStyle(color: p.doux, fontWeight: FontWeight.w600, fontSize: 14, height: 1.35)),
            ),
            if (_erreur != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(_erreur!, style: TextStyle(color: p.erreur, fontWeight: FontWeight.w700)),
              ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: _enCours
              ? SizedBox(height: 58, child: Center(child: CircularProgressIndicator(color: p.prim)))
              : BoutonKunfox(libelle: 'Créer mon profil', surAppui: _creer),
        ),
      ]);
}

class _Choix extends StatelessWidget {
  const _Choix({required this.titre, required this.sousTitre, required this.choisi, required this.surAppui});
  final String titre, sousTitre;
  final bool choisi;
  final VoidCallback surAppui;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final c = choisi ? p.info : p.bord;
    return Semantics(
      button: true,
      selected: choisi,
      label: '$titre, $sousTitre',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          surAppui();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: choisi ? p.info.withValues(alpha: p.sombre ? 0.16 : 0.10) : p.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              top: BorderSide(color: c, width: 2),
              left: BorderSide(color: c, width: 2),
              right: BorderSide(color: c, width: 2),
              bottom: BorderSide(color: c, width: choisi ? 2 : 4),
            ),
          ),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(titre, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: choisi ? p.info : p.texte)),
                const SizedBox(height: 2),
                Text(sousTitre, style: TextStyle(color: p.doux, fontWeight: FontWeight.w600)),
              ]),
            ),
            AnimatedScale(
              scale: choisi ? 1 : 0,
              duration: const Duration(milliseconds: 240),
              curve: const Cubic(0.34, 1.56, 0.64, 1),
              child: Icon(Icons.check_circle_rounded, color: p.info),
            ),
          ]),
        ),
      ),
    );
  }
}
