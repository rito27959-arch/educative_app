// Captures d'écran des principaux écrans d'Ouro Prep (vérification seulement).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ouro_prep/core/providers/auth_provider.dart';
import 'package:ouro_prep/core/providers/settings_provider.dart';
import 'package:ouro_prep/core/data/quiz_data.dart';
import 'package:ouro_prep/kunfox/donnees/duels.dart';
import 'package:ouro_prep/kunfox/donnees/progression.dart';
import 'package:ouro_prep/kunfox/donnees/rappels.dart';
import 'package:ouro_prep/core/router.dart';
import 'package:ouro_prep/core/services/storage_service.dart';
import 'package:ouro_prep/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('captures', (tester) async {
    await StorageService.init();
    await Rappels.initialiser();
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
    Future<void> onglet(IconData icone) async {
      final f = find.byIcon(icone);
      if (f.evaluate().isEmpty) return;
      await tester.tap(f.last, warnIfMissed: false);
      await attendre(900);
    }

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
    await onglet(Icons.fitness_center_rounded);
    await capture('21_reviser');
    await onglet(Icons.emoji_events_rounded);
    await capture('22_quetes');
    await onglet(Icons.face_rounded);
    await capture('23_profil');
    await onglet(Icons.home_rounded);

    // ── une leçon : notions, exercice, vérification
    routeur.push('/k/lecon/maths_c_ch1_l1');
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
    await onglet(Icons.ios_share_rounded);
    await attendre(1200);
    await capture('29b_carte_partage');
    await tester.tapAt(const Offset(20, 60));
    await attendre(800);
    await taper('CONTINUER');
    await attendre(1500);
    await capture('30_serie');

    // ── thème clair « Aube »
    container.read(settingsProvider.notifier).toggleDarkMode();
    routeur.go('/k');
    await attendre(2500);
    await capture('31_parcours_aube');
    routeur.push('/k/lecon/maths_c_ch1_l2');
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
        leconId: 'maths_c_ch1_l1', bonnes: 5, total: 5, duree: const Duration(minutes: 2), meilleurCombo: 5);
    await attendre(1000);
    await capture('33_parcours_fete');
    await attendre(1400);
    await capture('34_parcours_suite');
    await onglet(Icons.emoji_events_rounded);
    await capture('35_quetes_aube');

    // ── duel : entrée « VS », séance avec le fantôme, résultat
    final qs = QuizData.getQuestionsForLesson('maths_c_ch1_l1', count: 6);
    final ami = Joueur(nom: 'Awa', traces: [for (var i = 0; i < qs.length; i++) (i != 2, 2500 + i * 300)]);
    final duelAmi = Duel(
      code: 'ABCD2345', lecon: 'maths_c_ch1_l1', titre: 'Les ensembles', matiere: 'Mathématiques',
      questions: qs, createur: ami, adversaires: const [],
    );
    final partieAmi = PartieDuel(lecon: duelAmi.lecon, titre: duelAmi.titre, matiere: duelAmi.matiere, questions: qs, duel: duelAmi);
    routeur.push('/k/duel/nouveau', extra: partieAmi);
    await attendre(500);
    await capture('36_duel_entree_vol');
    await attendre(1500);
    await capture('36b_duel_entree');
    await taper('RELEVER LE DÉFI');
    await attendre(200);
    await capture('37_duel_compte');
    await attendre(3500);
    await attendre(4000);
    await capture('37b_duel_fantome');
    routeur.go('/k/duel-fin', extra: (
      PartieDuel(lecon: duelAmi.lecon, titre: duelAmi.titre, matiere: duelAmi.matiere, questions: qs),
      Joueur(nom: 'Miguel', traces: [for (var i = 0; i < qs.length; i++) (true, 1800 + i * 200)]),
    ));
    await attendre(1000);
    await capture('38_duel_course');
    await attendre(3500);
    await capture('38b_duel_fin');
    await onglet(Icons.fitness_center_rounded);
    routeur.go('/k');
    await attendre(1200);
    await onglet(Icons.fitness_center_rounded);
    await attendre(2500);
    await capture('39_reviser_duels');

    // ── l'épreuve de l'unité (le grand boss) et la fiche d'unité
    final chap = chapitreDe('maths_c_ch1_l1')!.id;
    routeur.go('/k');
    await attendre(1500);
    await onglet(Icons.menu_book_rounded);
    await attendre(800);
    await capture('44_fiche_unite');
    await tester.tapAt(const Offset(20, 60));
    await attendre(800);
    routeur.push('/k/boss/$chap');
    await attendre(300);
    await capture('45_boss_chute');
    await attendre(2200);
    await capture('45b_boss_entree');
    await taper("COMMENCER L'ÉPREUVE");
    await attendre(1500);
    await taper('1');
    await taper('VÉRIFIER');
    await attendre(600);
    await capture('46_boss_seance');
    const bl = BilanLecon(xp: 10, precision: 80, duree: Duration(minutes: 4), serieAvant: 5, serieApres: 5,
        premiereDuJour: false, niveauAvant: 3, niveauApres: 3, chapitreFini: false);
    routeur.go('/k/boss-fin', extra: BilanBoss(chapitreId: chap, bonnes: 9, total: 10, reussi: true, dejaReussi: false,
        xp: 50, duree: const Duration(minutes: 4), lecon: bl));
    await attendre(700);
    await capture('47_boss_trophee');
    await attendre(2600);
    await capture('47b_boss_victoire');
    routeur.go('/k/boss-fin', extra: BilanBoss(chapitreId: chap, bonnes: 5, total: 10, reussi: false, dejaReussi: false,
        xp: 10, duree: const Duration(minutes: 4), lecon: bl));
    await attendre(2600);
    await capture('48_boss_echec');

    // ── deux rappels montrés tout de suite (capturés ensuite par adb)
    await Rappels.essai();
    // le script de l'émulateur guette la notification et la photographie
    await attendre(12000);

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
