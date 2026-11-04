import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/config/env_config.dart';
import 'core/services/storage_service.dart';
import 'core/services/supabase_service.dart';
import 'core/services/sync_service.dart';
import 'core/router.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/ui_provider.dart';
import 'core/providers/mesh_provider.dart';
import 'core/providers/auth_provider.dart';
import 'design_system/ouro_colors.dart';
import 'core/services/app_lifecycle.dart';
import 'core/models/mesh_message.dart';
import 'core/providers/courses_provider.dart';
import 'kunfox/donnees/compte_droplet.dart';
import 'kunfox/donnees/progression.dart';
import 'kunfox/donnees/rappels.dart';
import 'kunfox/donnees/matieres.dart';
import 'kunfox/theme/kunfox_theme.dart';
import 'shared/widgets/mesh_toast.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final sentryDsn = EnvConfig.sentryDsn;
    if (sentryDsn.isNotEmpty) {
      await SentryFlutter.init(
        (options) {
          options.dsn = sentryDsn;
          options.tracesSampleRate = 0.2;
        },
        appRunner: () async {
          await _runApp();
        },
      );
    } else {
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        return false;
      };
      await _runApp();
    }
  }, (error, stack) {
    if (EnvConfig.sentryDsn.isNotEmpty) {
      Sentry.captureException(error, stackTrace: stack);
    }
  });
}

Future<void> _runApp() async {
  FlutterError.onError = (details) {
    Sentry.captureException(details.exception, stackTrace: details.stack);
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    Sentry.captureException(error, stackTrace: stack);
    return true;
  };

  try {
    await StorageService.init();
    await CompteDroplet.charger();
    try {
      await Rappels.initialiser();
    } catch (e) {
      debugPrint('[Rappels] $e');
    }
    await SupabaseService.instance.init();
    SyncService.instance.init();
  } catch (e, s) {
    Sentry.captureException(e, stackTrace: s);
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: OuroColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
    ));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ErrorBoundary(
      child: const AppLifecycleObserver(
        child: ProviderScope(child: OuroPrepApp()),
      ),
    ),
  );
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  const ErrorBoundary({super.key, required this.child});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  String? _error;

  @override
  void initState() {
    super.initState();
    ErrorWidget.builder = (details) {
      return Material(
        color: const Color(0xFF090909),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Color(0xFFFF3B30), size: 48),
              const SizedBox(height: 16),
              Text(
                'Oups, Kunfox a trébuché',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                '${details.exception}',
                style: const TextStyle(color: Color(0xFF888888), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Material(
        color: const Color(0xFF090909),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_error!, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ),
      );
    }
    return widget.child;
  }
}

class OuroPrepApp extends ConsumerWidget {
  const OuroPrepApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);
    final ui = ref.watch(uiProvider);
    final auth = ref.watch(authProvider);
    ref.watch(meshRepositoryProvider);

    if (auth.isLoggedIn && auth.user != null) {
      Future.microtask(() async {
        final repo = ref.read(meshRepositoryProvider);
        await repo.init(auth.user!.cryptoIdentity, auth.user!.pseudo);
        ref.read(callProvider.notifier).init(repo.transport);
      });
    }

    Future.microtask(() => ref.read(seedingProvider));

    // Les rappels : ce qu'il faut savoir pour les écrire, et où mène un toucher.
    Rappels.lireProgression = () => ref.read(progressionProvider);
    Rappels.surOuverture = (route) => router.go(route);
    Rappels.contexte(pseudo: auth.user?.pseudo ?? '', matiere: ref.read(matiereActiveProvider)?.title);
    Future.microtask(Rappels.programmer);

    // Ce qui accompagne la progression dans la sauvegarde Droplet.
    ProgressionNotifier.profil = () => {
          'pseudo': auth.user?.pseudo,
          'serie': auth.user?.bacSeries,
          'objectif': StorageService.getString('kunfox.objectif'),
        };

    return MaterialApp.router(
      title: 'Kunfox',
      debugShowCheckedModeBanner: false,
      theme: KunfoxTheme.clair(),
      darkTheme: KunfoxTheme.sombre(),
      themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(settings.fontSize),
          ),
          child: GestureDetector(
            onTap: () {
              final focus = FocusScope.of(context);
              if (focus.hasFocus) {
                focus.unfocus();
              }
            },
            child: Stack(
              children: [
                if (child != null) child,
                if (ui.currentOverlay != null)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => ref.read(uiProvider.notifier).hideOverlay(),
                      child: Container(color: Colors.black54),
                    ),
                  ),
                // (Le coach IA a été retiré de Kunfox avec le tuteur sur l'appareil.)
                const _IncomingCallDetector(),
                const ToastHost(),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Écoute les appels entrants et affiche un dialogue.
class _IncomingCallDetector extends ConsumerStatefulWidget {
  const _IncomingCallDetector();
  @override
  ConsumerState<_IncomingCallDetector> createState() => _IncomingCallDetectorState();
}

class _IncomingCallDetectorState extends ConsumerState<_IncomingCallDetector> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<CallState>(callProvider, (prev, next) {
      if (next.isCallActive &&
          next.direction == CallDirection.incoming &&
          next.connectionState == CallConnectionState.connecting &&
          !_dialogShown) {
        _dialogShown = true;
        _showIncomingDialog(next.peerId ?? '');
      }
      if (!next.isCallActive) {
        _dialogShown = false;
      }
    });
    return const SizedBox.shrink();
  }

  void _showIncomingDialog(String peerId) {
    final navContext = navigatorKey.currentContext;
    if (navContext == null) {
      debugPrint('[IncomingCallDetector] navigatorKey not ready yet');
      return;
    }
    try {
      showDialog(
        context: navContext,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF0F0F14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.phone_in_talk, color: Color(0xFF2563FF), size: 24),
              SizedBox(width: 12),
              Text('Appel entrant', style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          content: Text('Pair $peerId vous appelle…',
              style: const TextStyle(color: Color(0xFF8888A0), fontSize: 14)),
          actions: [
            TextButton.icon(
              onPressed: () {
                ref.read(callProvider.notifier).hangUp();
                Navigator.of(ctx).pop();
              },
              icon: const Icon(Icons.call_end, color: Color(0xFFFF3B30)),
              label: const Text('Refuser', style: TextStyle(color: Color(0xFFFF3B30))),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                Future.microtask(() {
                  ref.read(callProvider.notifier).answerCall();
                  final c = ref.read(callProvider);
                  final peers = ref.read(meshPeerListProvider);
                  final peer = peers.where((p) => p.peerId == c.peerId).firstOrNull;
                  final pseudo = peer?.pseudo ?? c.peerPseudo ?? '';
                  ref.read(routerProvider).go(
                    '/call?peerId=${c.peerId ?? ''}&peerPseudo=${Uri.encodeComponent(pseudo)}',
                  );
                });
              },
              icon: const Icon(Icons.phone, color: Color(0xFF00E676)),
              label: const Text('Répondre', style: TextStyle(color: Color(0xFF00E676))),
            ),
          ],
        ),
      );
    } catch (e, s) {
      debugPrint('[IncomingCallDetector] showDialog error: $e\n$s');
    }
  }
}
