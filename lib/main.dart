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
import 'core/providers/auth_provider.dart';
import 'design_system/ouro_colors.dart';
import 'core/services/app_lifecycle.dart';
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
    // Kunfox ne démarre plus le maillage (Bluetooth, Wi-Fi direct, appels) :
    // les échanges entre élèves se font sur Droplet. Plus de demande de
    // permissions Bluetooth ni de batterie consommée pour rien.

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
                const ToastHost(),
              ],
            ),
          ),
        );
      },
    );
  }
}
