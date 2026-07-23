import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:nearby_service/nearby_service.dart';
import 'ble_mesh_protocol.dart';

/// Stratégie de topologie Nearby Connections.
enum NearbyStrategy {
  /// Diffusion mesh à plusieurs pairs (M:N, débit plus faible).
  /// Utilisé pour la propagation de contenu en essaim.
  cluster,

  /// Lien direct entre deux appareils (débit maximal).
  /// Utilisé pour les appels et transferts ciblés.
  pointToPoint,
}

/// Transport P2P natif same-OS pour OURO PREP.
///
/// Encapsule `nearby_service` (Wi‑Fi Direct Android / Multipeer Connectivity
/// iOS) derrière la même interface que les autres transports.
///
/// ## Stratégie (A2.2)
/// - `cluster` (P2P_CLUSTER) pour la diffusion mesh à plusieurs pairs
/// - `pointToPoint` (P2P_POINT_TO_POINT) pour appels et transferts ciblés
///
/// ## Séparation des rôles
/// - Découverte BLE → négociation Wi-Fi → Nearby Connections pour le contenu
/// - BLE ne porte jamais de fichier ni flux audio
class NativeP2PTransport {
  bool _isRunning = false;
  bool get isRunning => _isRunning;
  String _myId = '';
  String? _myPseudo;

  /// Stratégie active : cluster (défaut) ou pointToPoint.
  NearbyStrategy _strategy = NearbyStrategy.cluster;

  final _peerEventsCtrl = StreamController<MeshPeerEvent>.broadcast();
  final _incomingDataCtrl = StreamController<MeshIncomingData>.broadcast();

  Stream<MeshPeerEvent> get peerEvents => _peerEventsCtrl.stream;
  Stream<MeshIncomingData> get incomingData => _incomingDataCtrl.stream;

  NearbyService? _service;
  final Map<String, _NativePeer> _connectedPeers = {};
  StreamSubscription<List<NearbyDevice>>? _peersSub;
  bool _hasPtpPeer = false;

  /// Définit la stratégie de topologie.
  ///
  /// - `cluster` (défaut) — accepte plusieurs pairs. Adapté à la
  ///   diffusion mesh M:N et au relais de contenu (débit plus faible).
  /// - `pointToPoint` — une seule connexion à la fois. Débit maximal
  ///   pour les appels et transferts ciblés.
  void setStrategy(NearbyStrategy strategy) {
    _strategy = strategy;
    if (strategy == NearbyStrategy.pointToPoint) {
      // En mode pointToPoint, on se déconnecte des pairs existants
      // sauf un (géré par l'appelant qui choisit la cible).
      _hasPtpPeer = false;
    }
  }

  Future<void> start(String myId, String myPseudo) async {
    if (_isRunning) return;
    _isRunning = true;
    _myId = myId;
    _myPseudo = myPseudo;

    debugPrint('[NativeP2P] start() called with id=$myId pseudo=$myPseudo');

    try {
      _service = NearbyService.getInstance();
      debugPrint('[NativeP2P] service instance created');

      if (Platform.isAndroid) {
        debugPrint('[NativeP2P] requesting permissions...');
        final ok = await _service!.android?.requestPermissions() ?? true;
        debugPrint('[NativeP2P] permissions result: $ok');
        if (!ok) {
          debugPrint('[NativeP2P] permissions denied');
          _isRunning = false;
          return;
        }
      }

      debugPrint('[NativeP2P] initializing...');
      final initialized = await _service!.initialize(
        data: NearbyInitializeData(darwinDeviceName: myPseudo),
      );
      debugPrint('[NativeP2P] initialize result: $initialized');
      if (!initialized) {
        _isRunning = false;
        return;
      }

      debugPrint('[NativeP2P] discovering...');
      final discovered = await _service!.discover();
      debugPrint('[NativeP2P] discover result: $discovered');
      if (!discovered) {
        _isRunning = false;
        return;
      }

      _peersSub?.cancel();
      _peersSub = _service!.getPeersStream().listen((peers) {
        debugPrint('[NativeP2P] peers updated: ${peers.length} devices');
        _onPeersUpdated(peers);
      });

      debugPrint('[NativeP2P] start() completed successfully');
    } catch (e, s) {
      debugPrint('[NativeP2P] start() error: $e\n$s');
      _isRunning = false;
    }
  }

  Future<void> stop() async {
    _isRunning = false;
    _peersSub?.cancel();

    if (_service != null) {
      try {
        for (final peer in _connectedPeers.values) {
          await _service!.disconnectById(peer.nearbyId);
        }
      } catch (e) { debugPrint('[NativeP2P] $e'); }
      await _service!.endCommunicationChannel();
      await _service!.stopDiscovery();
    }

    _connectedPeers.clear();
  }

  /// Retourne la plateforme actuelle sous forme de chaîne.
  static String get currentPlatform {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  void _onPeersUpdated(List<NearbyDevice> peers) {
    if (!_isRunning) return;

    final currentNearbyIds = peers.map(_extractNearbyId).toSet();

    // Pairs disparus
    final lost = _connectedPeers.keys
        .where((peerId) => !currentNearbyIds.contains(peerId))
        .toList();
    for (final peerId in lost) {
      final info = _connectedPeers.remove(peerId);
      if (info != null) {
        _peerEventsCtrl.add(MeshPeerEvent(
          peerId: peerId,
          pseudo: info.pseudo,
          isConnected: false,
          platform: currentPlatform,
        ));
      }
    }

    // Nouveaux pairs
    final connectedNearbyIds = _connectedPeers.keys.toSet();
    for (final device in peers) {
      final nearbyId = _extractNearbyId(device);
      if (nearbyId == _myId) continue;
      if (connectedNearbyIds.contains(nearbyId)) continue;
      _connectToDevice(nearbyId, device);
    }
  }

  String _extractNearbyId(NearbyDevice device) => device.info.id;

  Future<void> _connectToDevice(String nearbyId, NearbyDevice device) async {
    // ── Application de la stratégie de topologie (A2.2) ───────────
    if (_strategy == NearbyStrategy.pointToPoint && _hasPtpPeer) {
      debugPrint('[NativeP2P] Point‑to‑point actif, connexion '
          'refusée pour $nearbyId');
      return;
    }

    try {
      final connected = await _service!.connectById(nearbyId);
      if (!connected) return;

      // Démarrer le canal de communication pour ce pair
      final channelData = NearbyCommunicationChannelData(
        nearbyId,
        messagesListener: NearbyServiceMessagesListener(
          onData: (received) {
            _onMessageReceived(nearbyId, received);
          },
        ),
      );
      await _service!.startCommunicationChannel(channelData);

      final pseudo = _extractPseudo(device);
      _connectedPeers[nearbyId] = _NativePeer(
        nearbyId: nearbyId,
        pseudo: pseudo,
      );

      if (_strategy == NearbyStrategy.pointToPoint) {
        _hasPtpPeer = true;
      }

      _peerEventsCtrl.add(MeshPeerEvent(
        peerId: nearbyId,
        pseudo: pseudo,
        isConnected: true,
        platform: currentPlatform,
      ));
    } catch (e) { debugPrint('[NativeP2P] $e'); }
  }

  String _extractPseudo(NearbyDevice device) =>
      device.info.displayName;

  void _onMessageReceived(String deviceId, ReceivedNearbyMessage<NearbyMessageContent> message) {
    final content = message.content;
    if (content is! NearbyMessageTextRequest) return;

    final text = content.value;
    final data = Uint8List.fromList(utf8.encode(text));

    _incomingDataCtrl.add(MeshIncomingData(
      messageId: BleMeshProtocol.generateMessageId(),
      peerId: deviceId,
      data: data,
    ));
  }

  Future<void> sendToPeer(String peerId, Uint8List data) async {
    if (_service == null) return;

    final peer = _connectedPeers[peerId];
    if (peer == null) return;

    try {
      final msg = OutgoingNearbyMessage<NearbyMessageTextRequest>(
        content: NearbyMessageTextRequest.create(
          value: utf8.decode(data),
        ),
        receiver: NearbyDeviceInfo(
          id: peer.nearbyId,
          displayName: peer.pseudo,
        ),
      );
      await _service!.send(msg);
    } catch (e) { debugPrint('[NativeP2P] $e'); }
  }

  void dispose() {
    _peersSub?.cancel();
    _peerEventsCtrl.close();
    _incomingDataCtrl.close();
  }
}

class _NativePeer {
  final String nearbyId;
  final String pseudo;

  const _NativePeer({
    required this.nearbyId,
    required this.pseudo,
  });
}
