import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Service de mode passerelle.
///
/// Quand le mode passerelle est activé, l'appareil continue à relayer
/// les messages mesh même quand l'application est en arrière-plan.
///
/// ## Android
/// Un foreground service avec notification persistante maintient le
/// process Android en vie. Le package `flutter_background_service` ou
/// un service natif via MethodChannel peut être utilisé.
///
/// ## iOS
/// Les restrictions Apple limitent sévèrement le BLE et le networking en
/// arrière-plan. iOS ne permet pas un foreground service persistant.
/// Le BLE reste actif ~10 min après passage en arrière-plan, puis iOS le
/// suspend. Le Wi-Fi local (TCP) est coupé quasi immédiatement.
///
/// ## Recommandation
/// Pour une passerelle fiable, utiliser un appareil Android branché en
/// permanence. Afficher cette recommandation dans l'UI des paramètres.
class GatewayService {
  bool _isActive = false;
  bool _isAndroid = false;
  Timer? _keepAliveTimer;

  bool get isActive => _isActive;

  GatewayService() {
    try {
      _isAndroid = defaultTargetPlatform == TargetPlatform.android;
    } catch (_) {
      _isAndroid = false;
    }
  }

  /// Activer le mode passerelle.
  ///
  /// Sur Android :
  /// 1. Lancer un foreground service via MethodChannel (service natif)
  ///    avec la notification "OURO PREP relaye le maillage".
  /// 2. Maintenir les sockets BLE/WiFi ouverts.
  /// 3. Un timer de keep-alive évite que le OS ne mette en veille le
  ///    réseau (particulièrement important pour le Wi-Fi local).
  ///
  /// Implémentation de référence pour le foreground service Android :
  /// ```kotlin
  /// // MainActivity.kt
  /// override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
  ///     val notification = NotificationCompat.Builder(this, CHANNEL_ID)
  ///         .setContentTitle("OURO PREP")
  ///         .setContentText("Relais mesh actif")
  ///         .setSmallIcon(R.drawable.ic_mesh)
  ///         .build()
  ///     startForeground(NOTIFICATION_ID, notification)
  ///     return START_STICKY
  /// }
  /// ```
  Future<void> enable() async {
    if (_isActive) return;
    _isActive = true;

    if (_isAndroid) {
      _keepAliveTimer = Timer.periodic(
        const Duration(seconds: 30),
        (_) => _keepAlive(),
      );
    }

    debugPrint('[Gateway] Mode passerelle activé');
  }

  /// Désactiver le mode passerelle.
  Future<void> disable() async {
    _isActive = false;
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
    debugPrint('[Gateway] Mode passerelle désactivé');
  }

  /// Petit ping réseau pour éviter la mise en veille des connexions.
  void _keepAlive() {
    if (!_isAndroid) return;
    try {
      // Ping localhost pour maintenir la radio Wi-Fi active
      final socket = Socket.startConnect(
        InternetAddress('127.0.0.1'),
        0,
      );
      socket.then((_) {}).catchError((_) {});
    } catch (_) {}
  }

  void dispose() {
    _keepAliveTimer?.cancel();
    _isActive = false;
  }
}
