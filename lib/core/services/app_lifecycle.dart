import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mesh_provider.dart';

/// Observateur du cycle de vie de l'application.
///
/// ## Problème résolu
/// Sans cette gestion, le mesh reste actif en arrière-plan : les connexions
/// BLE drainent la batterie, les sockets Wi‑Fi expirent, et le mesh peut
/// crasher au retour au premier plan.
///
/// ## Comportement
/// - **Pause** : arrête les transports mesh (BLE + Wi‑Fi + nativeP2P)
/// - **Resume** : redémarre le mesh et vide la file de relais en attente
class AppLifecycleObserver extends ConsumerStatefulWidget {
  final Widget child;
  const AppLifecycleObserver({super.key, required this.child});

  @override
  ConsumerState<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends ConsumerState<AppLifecycleObserver>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final repo = ref.read(meshRepositoryProvider);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        debugPrint('[Lifecycle] pause — arrêt des transports');
        repo.transport.stopMesh();
      case AppLifecycleState.resumed:
        debugPrint('[Lifecycle] resume — redémarrage du mesh');
        repo.init(repo.myId, repo.myPseudo);
        repo.flushPendingRelays();
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
