// Captures d'écran des principaux écrans d'Ouro Prep (vérification seulement).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ouro_prep/core/providers/auth_provider.dart';
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

    const routes = {
      '04_dashboard': '/dashboard',
      '05_curriculum': '/curriculum',
      '06_matiere': '/curriculum/subject/maths',
      '07_chapitre_intro': '/curriculum/subject/maths/chapter/maths_ch1/intro',
      '08_lecon': '/curriculum/subject/maths/chapter/maths_ch1/lesson/maths_ch1_l1/reader',
      '09_quiz_lecon': '/curriculum/subject/maths/chapter/maths_ch1/lesson/maths_ch1_l1/quiz',
      '10_chapitre_fini': '/curriculum/subject/maths/chapter/maths_ch1/complete',
      '11_gamification': '/gamification',
      '12_ligues': '/leagues',
      '13_profil': '/profile',
      '14_reglages': '/settings',
      '15_forum': '/forum',
      '16_quiz_p2p': '/p2p-quiz',
      '17_carte_mentale': '/mindmap',
      '18_coach_vocal': '/voice-coach',
      '19_cours': '/courses',
    };
    for (final e in routes.entries) {
      try {
        GoRouter.of(navigatorKey.currentContext!).go(e.value);
      } catch (err) {
        debugPrint('route ${e.value} : $err');
      }
      await attendre(2500);
      await capture(e.key);
    }
  });
}
