// Captures d'écran des principaux écrans d'Ouro Prep (vérification seulement).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ouro_prep/core/providers/auth_provider.dart';
import 'package:ouro_prep/core/providers/settings_provider.dart';
import 'package:ouro_prep/kunfox/donnees/progression.dart';
import 'package:ouro_prep/core/router.dart';
import 'package:ouro_prep/core/services/storage_service.dart';
import 'package:ouro_prep/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('captures', (tester) async {
    await StorageService.init();
    await tester.pumpWidget(const ProviderScope(child: OuroPrepApp()));
    await binding.convertFlutterSurfaceToImage();

    Future<void> attendre(int ms) async {
      final fin = DateTime.now().add(Duration(milliseconds: ms));
      while (DateTime.now().isBefore(fin)) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    Future<void> capture(String nom) async {
      await tester.pump();
      try {
        await binding.takeScreenshot(nom);
      } catch (e) {
        debugPrint('capture $nom impossible : $e');
      }
    }

    // L'ouverture Rive, image par image.
    await attendre(250);
    await capture('01_ouverture_0250');
    await attendre(500);
    await capture('01_ouverture_0750');
    await attendre(500);
    await capture('01_ouverture_1250');
    await attendre(600);
    await capture('01_ouverture_1850');
    await attendre(500);
    await capture('01_ouverture_2350');
    await attendre(2500);
    await capture('03_apres_ouverture');

    // Onboarding fait et connexion, pour passer les redirections.
    await StorageService.setOnboardingComplete();
    final ctx = navigatorKey.currentContext!;
    final container = ProviderScope.containerOf(ctx, listen: false);
    try {
      await container.read(authProvider.notifier).login('Miguel', 'C');
    } catch (e) {
      debugPrint('connexion impossible : $e');
    }
    await attendre(1500);

    final routeur = GoRouter.of(navigatorKey.currentContext!);
    Future<void> taper(String texte) async {
      final f = find.text(texte);
      if (f.evaluate().isEmpty) {
        debugPrint('pas de « $texte » à l\'écran');
        return;
      }
      await tester.tap(f.first, warnIfMissed: false);
      await attendre(900);
    }

    // ── Kunfox : le parcours et les onglets (thème sombre « Nuit de renard »)
    routeur.go('/k');
    await attendre(3000);
    await capture('20_parcours');
    await taper('Réviser');
    await capture('21_reviser');
    await taper('Quêtes');
    await capture('22_quetes');
    await taper('Profil');
    await capture('23_profil');
    await taper('Parcours');

    // ── une leçon : notions, exercice, vérification
    routeur.push('/k/lecon/maths_ch1_l1');
    await attendre(2500);
    await capture('24_lecon_notion');
    for (var i = 0; i < 6; i++) {
      if (find.text('VÉRIFIER').evaluate().isNotEmpty) break;
      await taper('CONTINUER');
    }
    await capture('25_lecon_question');
    final tuiles = find.byType(Semantics);
    debugPrint('semantics : ${tuiles.evaluate().length}');
    await taper('1');
    await capture('26_lecon_choix');
    await taper('VÉRIFIER');
    await attendre(800);
    await capture('27_lecon_verifiee');
    await taper('CONTINUER');
    await capture('28_lecon_suivante');

    // ── fin de leçon et série
    routeur.go('/k/fin', extra: const BilanLecon(
      xp: 20, precision: 100, duree: Duration(minutes: 2, seconds: 14),
      serieAvant: 4, serieApres: 5, premiereDuJour: true, niveauAvant: 2, niveauApres: 2, chapitreFini: false,
    ));
    await attendre(1800);
    await capture('29_fin_lecon');
    await taper('CONTINUER');
    await attendre(1500);
    await capture('30_serie');

    // ── thème clair « Aube »
    container.read(settingsProvider.notifier).toggleDarkMode();
    routeur.go('/k');
    await attendre(2500);
    await capture('31_parcours_aube');
    routeur.push('/k/lecon/maths_ch1_l2');
    await attendre(2000);
    for (var i = 0; i < 6; i++) {
      if (find.text('VÉRIFIER').evaluate().isNotEmpty) break;
      await taper('CONTINUER');
    }
    await taper('2');
    await taper('VÉRIFIER');
    await attendre(800);
    await capture('32_lecon_aube');

    // ── retour d'une leçon : la pastille fête, la suivante s'ouvre
    routeur.go('/k');
    await attendre(1500);
    container.read(progressionProvider.notifier).terminer(
        leconId: 'maths_ch1_l1', bonnes: 5, total: 5, duree: const Duration(minutes: 2), meilleurCombo: 5);
    await attendre(1000);
    await capture('33_parcours_fete');
    await attendre(1400);
    await capture('34_parcours_suite');
    await taper('Quêtes');
    await capture('35_quetes_aube');

    // ── l'arrivée dans l'app (sans créer de profil)
    routeur.go('/onboarding');
    await attendre(2000);
    await capture('40_bienvenue');
    await taper("C'EST PARTI");
    await taper('BAC D');
    await capture('41_bienvenue_serie');
    await taper('CONTINUER');
    await taper('Sérieux');
    await capture('42_bienvenue_objectif');
    await taper('CONTINUER');
    await capture('43_bienvenue_profil');
  });
}
