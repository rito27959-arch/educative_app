import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import '../features/splash/splash_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/courses/course_explorer_screen.dart';
import '../features/reader/reader_screen.dart';
import '../features/forum/forum_screen.dart';
import '../features/calls/voice_call_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/quiz/p2p_quiz_screen.dart';
import 'services/storage_service.dart';
import '../features/series/chapter_intro_screen.dart';
import '../features/series/section_player_screen.dart';
import '../features/series/chapter_exam_screen.dart';
import '../features/series/subject_exam_screen.dart';
import '../features/gamification/gamification_screen.dart';
import '../features/gamification/leagues_screen.dart';
import '../features/series/learning_path_screen.dart';
import '../features/voice_coach/voice_coach_screen.dart';
import '../features/voice_coach/live_voice_coach_screen.dart';
import '../features/mindmap/mind_map_screen.dart';
import '../features/curriculum/curriculum_overview_screen.dart';
import '../features/curriculum/subject_detail_screen.dart';
import '../features/curriculum/chapter_intro_screen.dart' as curriculum_intro;
import '../features/curriculum/lesson_transition_screen.dart';
import '../features/curriculum/lesson_screen.dart';
import '../features/curriculum/lesson_quiz_screen.dart';
import '../features/curriculum/chapter_complete_screen.dart';
import '../features/curriculum/chapter_exam_screen.dart' as curriculum_exam;
import '../features/curriculum/lock_unlock_screen.dart';
import '../features/curriculum/bac_exam_screen.dart';
import '../kunfox/donnees/progression.dart' show BilanLecon, BilanBoss;
import '../kunfox/ecrans/bienvenue.dart';
import '../kunfox/donnees/duels.dart' show PartieDuel, Joueur;
import '../kunfox/ecrans/boss.dart';
import '../kunfox/ecrans/connexion_droplet.dart';
import '../kunfox/ecrans/examen.dart';
import '../kunfox/ecrans/duel.dart';
import '../kunfox/ecrans/fin_lecon.dart';
import '../kunfox/ecrans/onglets.dart';
import '../kunfox/ecrans/seance.dart';
import '../features/curriculum/bac_complete_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();
const _duelEnAttente = 'kunfox.duel.attente';

final routerProvider = Provider<GoRouter>((ref) {
  // Le routeur est créé UNE fois. Avant, il était recréé à chaque changement
  // d'état de connexion — l'app repartait alors de l'ouverture, et l'écran
  // d'inscription s'affichait une deuxième fois pendant la création du profil.
  final rafraichir = ValueNotifier<int>(0);
  ref.listen(authProvider, (_, _) => rafraichir.value++);
  ref.onDispose(rafraichir.dispose);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/splash',
    refreshListenable: rafraichir,
    routes: [
      GoRoute(path: '/splash', name: 'splash', builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (_, state) => BienvenueEcran(depuisDroplet: state.uri.queryParameters['droplet'] == '1'),
      ),
      // Retour de « Se connecter avec Droplet » : kunfox://kunfox/connexion?…
      GoRoute(path: '/connexion', builder: (_, state) => ConnexionDropletEcran(parametres: state.uri.queryParameters)),
      // Invitation à une leçon : kunfox://kunfox/lecon/<id>
      GoRoute(path: '/lecon/:leconId', redirect: (_, state) => '/k/lecon/${state.pathParameters['leconId']}'),
      GoRoute(path: '/auth', name: 'auth', builder: (_, _) => const BienvenueEcran()),
      GoRoute(path: '/dashboard', name: 'dashboard', builder: (_, _) => const DashboardScreen()),
      // ── Kunfox : parcours, séances, fin de leçon ──
      GoRoute(path: '/k', name: 'kunfox', builder: (_, _) => const AccueilKunfox()),
      GoRoute(path: '/k/revision', name: 'kunfox-revision', pageBuilder: (_, state) => _monte(state, const SeanceEcran())),
      GoRoute(
        path: '/k/lecon/:leconId',
        name: 'kunfox-lecon',
        pageBuilder: (_, state) => _monte(state, SeanceEcran(leconId: state.pathParameters['leconId'])),
      ),
      GoRoute(
        path: '/k/fin',
        name: 'kunfox-fin',
        pageBuilder: (_, state) {
          final bilan = state.extra;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 420),
            transitionsBuilder: (_, a, _, enfant) => FadeTransition(
              opacity: a,
              child: ScaleTransition(
                scale: Tween(begin: 0.94, end: 1.0).animate(CurvedAnimation(parent: a, curve: const Cubic(0.16, 1, 0.3, 1))),
                child: enfant,
              ),
            ),
            child: bilan is BilanLecon ? FinLeconEcran(bilan: bilan) : const AccueilKunfox(),
          );
        },
      ),
      // ── L'ultime boss : épreuve type Bac
      GoRoute(path: '/k/examen/:id', pageBuilder: (_, state) => _monte(state, ExamenEntreeEcran(epreuveId: state.pathParameters['id']!))),
      GoRoute(
        path: '/k/examen-copie/:id',
        pageBuilder: (_, state) => _monte(
          state,
          ExamenCopieEcran(epreuveId: state.pathParameters['id']!, copie: state.extra is Copie ? state.extra as Copie : null),
        ),
      ),
      GoRoute(
        path: '/k/examen-correction/:id',
        pageBuilder: (_, state) {
          final id = state.pathParameters['id']!;
          final copie = state.extra is Copie ? state.extra as Copie : (Copie.charger(id) ?? Copie(epreuveId: id));
          return _monte(state, ExamenCorrectionEcran(epreuveId: id, copie: copie));
        },
      ),
      GoRoute(
        path: '/k/examen-note',
        pageBuilder: (_, state) {
          final r = state.extra;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 420),
            transitionsBuilder: (_, a, _, enfant) => FadeTransition(opacity: a, child: enfant),
            child: r is ResultatExamen ? ExamenNoteEcran(resultat: r) : const AccueilKunfox(),
          );
        },
      ),
      // ── Épreuve d'unité (le grand boss)
      GoRoute(path: '/k/boss/:chapitre', pageBuilder: (_, state) => _monte(state, BossEntreeEcran(chapitreId: state.pathParameters['chapitre']!))),
      GoRoute(
        path: '/k/boss-seance/:chapitre',
        pageBuilder: (_, state) => _monte(state, SeanceEcran(boss: state.pathParameters['chapitre'])),
      ),
      GoRoute(
        path: '/k/boss-fin',
        pageBuilder: (_, state) {
          final b = state.extra;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 420),
            transitionsBuilder: (_, a, _, enfant) => FadeTransition(opacity: a, child: enfant),
            child: b is BilanBoss ? BossFinEcran(bilan: b) : const AccueilKunfox(),
          );
        },
      ),
      // ── Duels : kunfox://kunfox/duel/<CODE> ou le lien du site /d/<CODE>
      GoRoute(path: '/duel/:code', redirect: (_, state) => '/k/duel/${state.pathParameters['code']!.toUpperCase()}'),
      GoRoute(path: '/d/:code', redirect: (_, state) => '/k/duel/${state.pathParameters['code']!.toUpperCase()}'),
      GoRoute(
        path: '/k/duel/nouveau',
        pageBuilder: (_, state) => _monte(state, DuelEntreeEcran(partie: state.extra as PartieDuel?)),
      ),
      GoRoute(
        path: '/k/duel/:code',
        pageBuilder: (_, state) => _monte(state, DuelEntreeEcran(code: state.pathParameters['code'])),
      ),
      GoRoute(
        path: '/k/duel-seance',
        pageBuilder: (_, state) {
          final partie = state.extra;
          return _monte(state, partie is PartieDuel ? SeanceEcran(duel: partie) : const AccueilKunfox());
        },
      ),
      GoRoute(
        path: '/k/duel-fin',
        pageBuilder: (_, state) {
          final x = state.extra;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 420),
            transitionsBuilder: (_, a, _, enfant) => FadeTransition(opacity: a, child: enfant),
            child: x is (PartieDuel, Joueur) ? DuelFinEcran(partie: x.$1, moi: x.$2) : const AccueilKunfox(),
          );
        },
      ),
      GoRoute(path: '/courses', name: 'courses', builder: (_, _) => const CourseExplorerScreen()),
      GoRoute(
        path: '/reader/:courseId/:chapterId',
        name: 'reader',
        builder: (_, state) {
          final courseId = state.pathParameters['courseId']!;
          final chapterId = state.pathParameters['chapterId']!;
          return ReaderScreen(courseId: courseId, chapterId: chapterId);
        },
      ),
      GoRoute(path: '/forum', name: 'forum', builder: (_, _) => const ForumScreen()),
      GoRoute(
        path: '/call',
        name: 'call',
        builder: (_, state) {
          final peerId = state.uri.queryParameters['peerId'];
          final peerPseudo = state.uri.queryParameters['peerPseudo'];
          return VoiceCallScreen(peerId: peerId, peerPseudo: peerPseudo);
        },
      ),
      GoRoute(path: '/profile', name: 'profile', builder: (_, _) => const ProfileScreen()),
      GoRoute(path: '/settings', name: 'settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(path: '/p2p-quiz', name: 'p2p-quiz', builder: (_, _) => const P2PQuizScreen()),
      GoRoute(
        path: '/chapter-list/:courseId',
        name: 'chapter-list',
        builder: (_, state) {
          final courseId = state.pathParameters['courseId']!;
          return LearningPathScreen(courseId: courseId);
        },
      ),
      GoRoute(
        path: '/learning-path/:courseId',
        name: 'learning-path',
        builder: (_, state) {
          final courseId = state.pathParameters['courseId']!;
          return LearningPathScreen(courseId: courseId);
        },
      ),
      GoRoute(path: '/leagues', name: 'leagues', builder: (_, _) => const LeaguesScreen()),
      GoRoute(
        path: '/learn/:courseId/:chapterId',
        name: 'chapter-intro',
        builder: (_, state) {
          final courseId = state.pathParameters['courseId']!;
          final chapterId = state.pathParameters['chapterId']!;
          return ChapterIntroScreen(courseId: courseId, chapterId: chapterId);
        },
      ),
      GoRoute(
        path: '/learn/:courseId/:chapterId/sections',
        name: 'section-player',
        builder: (_, state) {
          final courseId = state.pathParameters['courseId']!;
          final chapterId = state.pathParameters['chapterId']!;
          return SectionPlayerScreen(courseId: courseId, chapterId: chapterId);
        },
      ),
      GoRoute(
        path: '/exam/:courseId/:chapterId',
        name: 'chapter-exam',
        builder: (_, state) {
          final courseId = state.pathParameters['courseId']!;
          final chapterId = state.pathParameters['chapterId']!;
          return ChapterExamScreen(courseId: courseId, chapterId: chapterId);
        },
      ),
      GoRoute(
        path: '/exam/:courseId',
        name: 'subject-exam',
        builder: (_, state) {
          final courseId = state.pathParameters['courseId']!;
          return SubjectExamScreen(courseId: courseId);
        },
      ),
      GoRoute(path: '/gamification', name: 'gamification', builder: (_, _) => const GamificationScreen()),
      GoRoute(path: '/voice-coach', name: 'voice-coach', builder: (_, _) => const VoiceCoachScreen()),
      GoRoute(path: '/voice-coach/live', name: 'voice-coach-live', builder: (_, _) => const LiveVoiceCoachScreen()),
      GoRoute(path: '/mindmap', name: 'mindmap-list', builder: (_, _) => const MindMapListScreen()),
      GoRoute(
        path: '/mindmap/:mindMapId',
        name: 'mindmap-editor',
        builder: (_, state) {
          final id = state.pathParameters['mindMapId']!;
          return MindMapEditorScreen(mindMapId: id);
        },
      ),
      // ── Curriculum Bac D routes ──
      GoRoute(path: '/curriculum', name: 'curriculum', builder: (_, _) => const CurriculumOverviewScreen()),
      GoRoute(
        path: '/curriculum/subject/:subjectId',
        name: 'curriculum-subject',
        builder: (_, state) {
          final subjectId = state.pathParameters['subjectId']!;
          return SubjectDetailScreen(subjectId: subjectId);
        },
      ),
      GoRoute(
        path: '/curriculum/subject/:subjectId/chapter/:chapterId/intro',
        name: 'curriculum-chapter-intro',
        builder: (_, state) {
          final subjectId = state.pathParameters['subjectId']!;
          final chapterId = state.pathParameters['chapterId']!;
          return curriculum_intro.ChapterIntroScreen(subjectId: subjectId, chapterId: chapterId);
        },
      ),
      GoRoute(
        path: '/curriculum/subject/:subjectId/chapter/:chapterId/lesson/:lessonId/transition',
        name: 'curriculum-lesson-transition',
        builder: (_, state) {
          final subjectId = state.pathParameters['subjectId']!;
          final chapterId = state.pathParameters['chapterId']!;
          final lessonId = state.pathParameters['lessonId']!;
          return LessonTransitionScreen(subjectId: subjectId, chapterId: chapterId, lessonId: lessonId,);
        },
      ),
      GoRoute(
        path: '/curriculum/subject/:subjectId/chapter/:chapterId/lesson/:lessonId/reader',
        name: 'curriculum-lesson-reader',
        builder: (_, state) {
          final subjectId = state.pathParameters['subjectId']!;
          final chapterId = state.pathParameters['chapterId']!;
          final lessonId = state.pathParameters['lessonId']!;
          return LessonScreen(subjectId: subjectId, chapterId: chapterId, lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/curriculum/subject/:subjectId/chapter/:chapterId/lesson/:lessonId/quiz',
        name: 'curriculum-lesson-quiz',
        builder: (_, state) {
          final subjectId = state.pathParameters['subjectId']!;
          final chapterId = state.pathParameters['chapterId']!;
          final lessonId = state.pathParameters['lessonId']!;
          return LessonQuizScreen(subjectId: subjectId, chapterId: chapterId, lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/curriculum/subject/:subjectId/chapter/:chapterId/complete',
        name: 'curriculum-chapter-complete',
        builder: (_, state) {
          final subjectId = state.pathParameters['subjectId']!;
          final chapterId = state.pathParameters['chapterId']!;
          return ChapterCompleteScreen(subjectId: subjectId, chapterId: chapterId);
        },
      ),
      GoRoute(
        path: '/curriculum/subject/:subjectId/chapter/:chapterId/boss-exam',
        name: 'curriculum-boss-exam',
        builder: (_, state) {
          final subjectId = state.pathParameters['subjectId']!;
          final chapterId = state.pathParameters['chapterId']!;
          return curriculum_exam.CurriculumChapterExamScreen(subjectId: subjectId, chapterId: chapterId);
        },
      ),
      GoRoute(
        path: '/curriculum/subject/:subjectId/chapter/:chapterId/unlock',
        name: 'curriculum-unlock',
        builder: (_, state) {
          final subjectId = state.pathParameters['subjectId']!;
          final chapterId = state.pathParameters['chapterId']!;
          return LockUnlockScreen(subjectId: subjectId, chapterId: chapterId,);
        },
      ),
      GoRoute(
        path: '/curriculum/subject/:subjectId/bac-exam',
        name: 'curriculum-bac-exam',
        builder: (_, state) {
          final subjectId = state.pathParameters['subjectId']!;
          return BacExamScreen(subjectId: subjectId);
        },
      ),
      GoRoute(
        path: '/curriculum/subject/:subjectId/bac-complete',
        name: 'curriculum-bac-complete',
        builder: (_, state) {
          final subjectId = state.pathParameters['subjectId']!;
          final score = int.tryParse(state.uri.queryParameters['score'] ?? '') ?? 0;
          final total = int.tryParse(state.uri.queryParameters['total'] ?? '') ?? 0;
          return BacCompleteScreen(subjectId: subjectId, score: score, totalQuestions: total);
        },
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = ref.read(authProvider).isLoggedIn;
      final path = state.uri.path;
      final onboardingDone = StorageService.isOnboardingComplete();
      // Le retour de Droplet doit passer même avant l'inscription.
      if (path == '/splash' || path == '/connexion') return null;
      // Un lien de duel ouvert avant l'inscription : on le garde pour après.
      final duel = RegExp(r'^/k/duel/([A-Za-z0-9]{8})$').firstMatch(path);
      if (duel != null && (!onboardingDone || !isLoggedIn)) {
        StorageService.setString(_duelEnAttente, duel.group(1)!);
        return onboardingDone ? '/auth' : '/onboarding';
      }
      if (isLoggedIn && path == '/k') {
        final code = StorageService.getString(_duelEnAttente);
        if (code != null && code.isNotEmpty) {
          StorageService.remove(_duelEnAttente);
          return '/k/duel/$code';
        }
      }
      if (!onboardingDone) {
        if (path != '/onboarding') return '/onboarding';
        return null;
      }
      if (!isLoggedIn && path != '/auth' && path != '/onboarding') return '/auth';
      if (isLoggedIn && path == '/auth') {
        return '/k';
      }
      return null;
    },
  );
});


/// Une séance monte du bas, comme une feuille iOS plein écran.
CustomTransitionPage<void> _monte(GoRouterState state, Widget enfant) => CustomTransitionPage<void>(
      key: state.pageKey,
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 480),
      reverseTransitionDuration: const Duration(milliseconds: 360),
      transitionsBuilder: (_, a, _, e) => SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: a, curve: const Cubic(0.16, 1, 0.3, 1), reverseCurve: Curves.easeInCubic)),
        child: e,
      ),
      child: enfant,
    );
