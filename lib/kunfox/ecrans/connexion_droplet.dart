// L'écran de retour de Droplet (kunfox://kunfox/connexion?…) : on déchiffre
// la réponse, on cherche une sauvegarde, et on rend à l'élève sa progression
// — ou on termine son inscription avec le pseudo de Droplet.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/services/storage_service.dart';
import '../../shared/widgets/kunfox/kunfox_rive.dart';
import '../composants/bouton.dart';
import '../donnees/compte_droplet.dart';
import '../donnees/progression.dart';
import '../theme/palette.dart';

class ConnexionDropletEcran extends ConsumerStatefulWidget {
  const ConnexionDropletEcran({super.key, required this.parametres});
  final Map<String, String> parametres;

  @override
  ConsumerState<ConnexionDropletEcran> createState() => _ConnexionDropletEcranState();
}

class _ConnexionDropletEcranState extends ConsumerState<ConnexionDropletEcran> {
  String _message = 'Connexion avec Droplet…';
  HumeurKunfox _humeur = HumeurKunfox.reflexion;
  bool _echec = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _traiter());
  }

  Future<void> _traiter() async {
    final reponse = await CompteDroplet.recevoir(widget.parametres);
    if (!mounted) return;
    if (reponse == null) {
      setState(() {
        _echec = true;
        _humeur = HumeurKunfox.courage;
        _message = widget.parametres['refus'] == '1'
            ? 'Connexion refusée dans Droplet.'
            : 'Cette connexion n\'a pas abouti. Réessaie depuis Kunfox.';
      });
      return;
    }
    setState(() => _message = 'Je cherche ta progression…');
    final sauvegarde = await CompteDroplet.recuperer();
    if (!mounted) return;
    final dejaInscrit = ref.read(authProvider).isLoggedIn;

    if (sauvegarde != null) {
      // Un autre téléphone avait sauvegardé : on reprend tout.
      if (!dejaInscrit) {
        final pseudo = (sauvegarde['pseudo'] as String?) ?? reponse.pseudo;
        final serie = (sauvegarde['serie'] as String?) ?? 'BAC D';
        await StorageService.setOnboardingComplete();
        await ref.read(authProvider.notifier).login(pseudo.isEmpty ? 'Élève' : pseudo, serie);
      }
      final p = sauvegarde['progression'];
      if (p is Map<String, dynamic>) ref.read(progressionProvider.notifier).remplacer(p);
      HapticFeedback.heavyImpact();
      setState(() {
        _humeur = HumeurKunfox.fete;
        _message = 'Te revoilà ! Ta progression est de retour.';
      });
      await Future<void>.delayed(const Duration(milliseconds: 1800));
      if (mounted) context.go('/k');
      return;
    }

    if (dejaInscrit) {
      // Premier rattachement : on envoie la progression actuelle.
      await CompteDroplet.envoyer();
      setState(() {
        _humeur = HumeurKunfox.joie;
        _message = 'C\'est fait : ta progression est sauvegardée avec Droplet.';
      });
      await Future<void>.delayed(const Duration(milliseconds: 1600));
      if (mounted) context.go('/k');
    } else {
      // Nouvel élève : on termine l'inscription, pseudo déjà connu.
      if (mounted) context.go('/onboarding?droplet=1');
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Spacer(),
            KunfoxMascotte(humeur: _humeur, taille: 200),
            const SizedBox(height: 16),
            Text(_message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (!_echec) CircularProgressIndicator(color: p.prim),
            const Spacer(),
            if (_echec) BoutonKunfox(libelle: 'Continuer', surAppui: () => context.go('/k')),
          ]),
        ),
      ),
    );
  }
}
