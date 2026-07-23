import 'dart:async';
import 'package:flutter/foundation.dart';
import 'ble_mesh_protocol.dart';
import 'ble_mesh_transport.dart';
import 'local_wifi_transport.dart';
import 'native_p2p_transport.dart';
import '../models/mesh_message.dart';
import 'storage_service.dart';

/// Type de transport utilisé pour joindre un pair.
enum TransportKind { ble, localWifi, nativeP2P, both }

/// Rôle d'un pair dans le mesh hiérarchique.
enum PeerRole {
  /// Pair standard (feuille) — se connecte à des gateway
  leaf,

  /// Passerelle — relaie pour d'autres, peut être super-peer
  gateway,

  /// Super-peer — gateway élue, sert de backbone au mesh
  superPeer,
}

/// Information sur un pair connecté.
class ConnectedPeer {
  final String peerId;
  final String pseudo;
  final int hopCount;
  final bool isGateway;
  final Set<TransportKind> transports;
  final String platform;
  final PeerRole role;
  final Set<String> interestGroups;
  final double batteryLevel;
  final int connectionScore;

  const ConnectedPeer({
    required this.peerId,
    required this.pseudo,
    this.hopCount = 0,
    this.isGateway = false,
    this.transports = const {TransportKind.ble},
    this.platform = 'unknown',
    this.role = PeerRole.leaf,
    this.interestGroups = const {},
    this.batteryLevel = 1.0,
    this.connectionScore = 0,
  });

  ConnectedPeer copyWith({
    String? peerId,
    String? pseudo,
    int? hopCount,
    bool? isGateway,
    Set<TransportKind>? transports,
    String? platform,
    PeerRole? role,
    Set<String>? interestGroups,
    double? batteryLevel,
    int? connectionScore,
  }) {
    return ConnectedPeer(
      peerId: peerId ?? this.peerId,
      pseudo: pseudo ?? this.pseudo,
      hopCount: hopCount ?? this.hopCount,
      isGateway: isGateway ?? this.isGateway,
      transports: transports ?? this.transports,
      platform: platform ?? this.platform,
      role: role ?? this.role,
      interestGroups: interestGroups ?? this.interestGroups,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      connectionScore: connectionScore ?? this.connectionScore,
    );
  }
}

/// Santé d'un transport pour un pair donné.
class TransportHealth {
  final int consecutiveFailures;
  final int totalSuccess;
  final DateTime? lastUsed;

  const TransportHealth({
    this.consecutiveFailures = 0,
    this.totalSuccess = 0,
    this.lastUsed,
  });

  TransportHealth copyWith({
    int? consecutiveFailures,
    int? totalSuccess,
    DateTime? lastUsed,
  }) {
    return TransportHealth(
      consecutiveFailures: consecutiveFailures ?? this.consecutiveFailures,
      totalSuccess: totalSuccess ?? this.totalSuccess,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  double get reliability {
    final total = consecutiveFailures + totalSuccess;
    if (total == 0) return 1.0;
    return totalSuccess / total;
  }
}

/// Statistiques globales de santé du mesh.
class MeshHealth {
  final int totalPeers;
  final int peersOnWifi;
  final int peersOnBle;
  final int peersOnNative;
  final int gatewayCount;
  final int superPeerCount;
  final double averageReliability;
  final int messagesSent;
  final int acksReceived;
  final int failedDeliveries;
  final Map<String, TransportHealth> bleHealth;
  final Map<String, TransportHealth> wifiHealth;
  final Map<String, TransportHealth> nativeHealth;

  const MeshHealth({
    this.totalPeers = 0,
    this.peersOnWifi = 0,
    this.peersOnBle = 0,
    this.peersOnNative = 0,
    this.gatewayCount = 0,
    this.superPeerCount = 0,
    this.averageReliability = 1.0,
    this.messagesSent = 0,
    this.acksReceived = 0,
    this.failedDeliveries = 0,
    this.bleHealth = const {},
    this.wifiHealth = const {},
    this.nativeHealth = const {},
  });
}

/// Configuration de scaling pour le mesh.
class MeshScaleConfig {
  /// Nombre max de connexions directes par appareil
  final int maxDirectConnections;

  /// Nombre max de connexions BLE
  final int maxBleConnections;

  /// Intervalle de beacon Wi-Fi (secondes) quand peu de pairs
  final int wifiBeaconIntervalSparse;

  /// Intervalle de beacon Wi-Fi (secondes) quand beaucoup de pairs
  final int wifiBeaconIntervalDense;

  /// Seuil de densité pour passer en mode dense
  final int densePeerThreshold;

  /// Durée de scan BLE active (secondes)
  final int bleScanDuration;

  /// Durée de pause BLE (secondes) — duty cycle
  final int bleScanPause;

  /// Durée de scan BLE quand batterie faible
  final int bleScanPauseLowBattery;

  /// Timeout de stale peer (secondes)
  final int peerTimeout;

  /// TTL par défaut des messages (secondes)
  final int defaultMessageTtl;

  /// Ports d'écoute Wi-Fi
  final int discoveryPort;
  final int dataPort;

  const MeshScaleConfig({
    this.maxDirectConnections = 50,
    this.maxBleConnections = 6,
    this.wifiBeaconIntervalSparse = 5,
    this.wifiBeaconIntervalDense = 30,
    this.densePeerThreshold = 20,
    this.bleScanDuration = 10,
    this.bleScanPause = 30,
    this.bleScanPauseLowBattery = 60,
    this.peerTimeout = 30,
    this.defaultMessageTtl = 3600,
    this.discoveryPort = 42069,
    this.dataPort = 42070,
  });

  static const MeshScaleConfig defaultConfig = MeshScaleConfig();
}

/// Routeur de transport unifié scalable à 10M utilisateurs.
///
/// ## Hiérarchie
/// Les pairs sont organisés en feuilles (leaf), passerelles (gateway) et
/// super-peers. Chaque appareil connecte max [maxDirectConnections] pairs
/// simultanément. Les gateway forment un backbone, les feuilles se
/// connectent aux gateway les plus proches.
///
/// ## Groupes d'intérêt
/// Les messages sont taggés par série, matière, région. Seuls les pairs
/// abonnés à un groupe reçoivent les messages de ce groupe. Réduction
/// drastique du bruit à l'échelle.
///
/// ## Scanning adaptatif
/// BLE et Wi-Fi ajustent leur intervalle selon :
/// - La densité de pairs détectés
/// - Le niveau de batterie
/// - L'état foreground/background
/// - La présence d'alternatives Wi-Fi
class MeshTransportService {
  final BleMeshTransport _bleTransport = BleMeshTransport();
  final LocalWifiTransport _wifiTransport = LocalWifiTransport();
  final NativeP2PTransport _nativeTransport = NativeP2PTransport();

  MeshScaleConfig config = MeshScaleConfig.defaultConfig;

  bool _isRunning = false;
  String _myId = '';
  String _myPseudo = '';
  PeerRole _myRole = PeerRole.leaf;
  double _batteryLevel = 1.0;
  bool _isInForeground = true;

  final Map<String, ConnectedPeer> _peers = {};
  final Map<String, Map<TransportKind, TransportHealth>> _transportHealth = {};

  /// Gateways connus dans le mesh (backbone)
  final Map<String, ConnectedPeer> _knownGateways = {};

  /// Table persistante des pairs connus (load au démarrage, save périodique)
  List<PeerRecord> _knownPeerRecords = [];

  /// Abonnements aux groupes d'intérêt
  final Set<String> _myInterestGroups = {};

  /// Cache des TTL de messages pour éviter les boucles
  final Set<String> _seenMessageIds = {};

  int _totalSent = 0;
  int _totalAcks = 0;
  int _totalFailed = 0;
  int _peersEverSeen = 0;

  final _peerEventsCtrl = StreamController<ConnectedPeer>.broadcast();
  final _incomingDataCtrl = StreamController<MeshIncomingData>.broadcast();
  final _healthCtrl = StreamController<MeshHealth>.broadcast();

  Stream<ConnectedPeer> get peerEvents => _peerEventsCtrl.stream;
  Stream<MeshIncomingData> get incomingData => _incomingDataCtrl.stream;
  Stream<MeshHealth> get healthEvents => _healthCtrl.stream;

  int get connectedPeerCount => _peers.length;
  List<ConnectedPeer> get connectedPeers => _peers.values.toList();
  List<ConnectedPeer> get knownGateways => _knownGateways.values.toList();
  int get peersEverSeen => _peersEverSeen;

  int get blePeerCount =>
      _peers.values.where((p) => p.transports.contains(TransportKind.ble)).length;
  int get wifiPeerCount =>
      _peers.values.where((p) => p.transports.contains(TransportKind.localWifi)).length;
  int get nativePeerCount =>
      _peers.values.where((p) => p.transports.contains(TransportKind.nativeP2P)).length;
  int get gatewayCount =>
      _peers.values.where((p) => p.isGateway).length;
  int get superPeerCount =>
      _peers.values.where((p) => p.role == PeerRole.superPeer).length;

  static const int maxFailuresBeforeExclude = 3;

  /// Intervalle de beacon Wi-Fi actuel (s'adapte à la densité)
  int _currentWifiBeaconInterval = 5;

  // ── Cycle de vie ─────────────────────────────────────────────────────────

  /// Démarre le mesh avec les paramètres de scaling.
  Future<void> startMesh(
    String myId,
    String myPseudo, {
    PeerRole role = PeerRole.leaf,
    Set<String>? interestGroups,
    MeshScaleConfig? config,
  }) async {
    if (_isRunning) return;
    _isRunning = true;
    _myId = myId;
    _myPseudo = myPseudo;
    _myRole = role;
    if (config != null) this.config = config;
    if (interestGroups != null) _myInterestGroups.addAll(interestGroups);

    debugPrint('[MeshService] startMesh() id=$myId role=$role groups=$interestGroups');

    _bleTransport.peerEvents.listen(_onBlePeerEvent);
    _bleTransport.incomingData.listen(_onIncomingData);
    _wifiTransport.peerEvents.listen(_onWifiPeerEvent);
    _wifiTransport.incomingData.listen(_onIncomingData);
    _nativeTransport.peerEvents.listen(_onNativePeerEvent);
    _nativeTransport.incomingData.listen(_onIncomingData);

    await Future.wait([
      _bleTransport.start(myId, myPseudo)
          .timeout(const Duration(seconds: 8))
          .catchError((e) => debugPrint('[MeshService] BLE start error: $e')),
      _wifiTransport.start(myId, myPseudo)
          .timeout(const Duration(seconds: 8))
          .catchError((e) => debugPrint('[MeshService] WiFi start error: $e')),
      _nativeTransport.start(myId, myPseudo)
          .timeout(const Duration(seconds: 8))
          .catchError((e) => debugPrint('[MeshService] NativeP2P start error: $e')),
    ]);

    _startAdaptiveBeaconing();
    _startStalePeerCleanup();

    if (role == PeerRole.gateway || role == PeerRole.superPeer) {
      _announceGatewayPresence();
    }

    _loadKnownPeers();
    _startPeerPersistence();

    debugPrint('[MeshService] startMesh() completed, knownPeers=${_knownPeerRecords.length}');
  }

  Future<void> stopMesh() async {
    _isRunning = false;
    _adaptiveBeaconTimer?.cancel();
    _stalePeerTimer?.cancel();
    _gatewayAnnounceTimer?.cancel();
    _peerPersistTimer?.cancel();
    _persistKnownPeers();
    await Future.wait([
      _bleTransport.stop(),
      _wifiTransport.stop(),
      _nativeTransport.stop(),
    ]);
    _peers.clear();
    _knownGateways.clear();
  }

  /// Met à jour le niveau de batterie (0.0 - 1.0).
  void updateBatteryLevel(double level) {
    _batteryLevel = level;
    _adjustScanRate();
  }

  /// Met à jour l'état foreground/background.
  void setForegroundState(bool isForeground) {
    _isInForeground = isForeground;
    _adjustScanRate();
  }

  /// Ajoute ou retire des groupes d'intérêt.
  void setInterestGroups(Set<String> groups) {
    _myInterestGroups.clear();
    _myInterestGroups.addAll(groups);
  }

  /// Définit le rôle de ce pair.
  void setRole(PeerRole role) {
    _myRole = role;
    if (_isRunning && (role == PeerRole.gateway || role == PeerRole.superPeer)) {
      _announceGatewayPresence();
    }
  }

  // ── Scanning adaptatif ──────────────────────────────────────────────────

  Timer? _adaptiveBeaconTimer;
  Timer? _stalePeerTimer;
  Timer? _gatewayAnnounceTimer;

  void _startAdaptiveBeaconing() {
    _adaptiveBeaconTimer?.cancel();
    _adaptiveBeaconTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _adjustScanRate();
    });
  }

  void _adjustScanRate() {
    final peerCount = _peers.length;

    // Ajuster intervalle beacon Wi-Fi selon densité
    if (peerCount >= config.densePeerThreshold) {
      _currentWifiBeaconInterval = config.wifiBeaconIntervalDense;
    } else {
      _currentWifiBeaconInterval = config.wifiBeaconIntervalSparse;
    }

    // En background et batterie faible : réduire drastiquement
    if (!_isInForeground && _batteryLevel < 0.2) {
      _currentWifiBeaconInterval = _currentWifiBeaconInterval * 4;
    } else if (!_isInForeground) {
      _currentWifiBeaconInterval = _currentWifiBeaconInterval * 2;
    }

    debugPrint('[MeshService] adapt beacon: ${_currentWifiBeaconInterval}s peers=$peerCount bg=${!_isInForeground} bat=${(_batteryLevel*100).round()}%');
  }

  void _startStalePeerCleanup() {
    _stalePeerTimer?.cancel();
    _stalePeerTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      final now = DateTime.now();
      _peers.removeWhere((id, peer) {
        final health = _transportHealth[id];
        if (health == null) return false;
        final last = health.values
            .where((h) => h.lastUsed != null)
            .map((h) => h.lastUsed!)
            .fold<DateTime?>(null, (a, b) => a == null || b.isAfter(a) ? b : a);
        if (last == null) return false;
        if (now.difference(last).inSeconds > config.peerTimeout) {
          debugPrint('[MeshService] stale peer removed: $id');
          _peerEventsCtrl.add(peer.copyWith());
          return true;
        }
        return false;
      });
    });
  }

  void _announceGatewayPresence() {
    _gatewayAnnounceTimer?.cancel();
    _gatewayAnnounceTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (!_isRunning) return;
      debugPrint('[MeshService] gateway $_myId/$_myPseudo role=$_myRole presence announced');
      // Diffuser la présence gateway aux pairs connectés
      _peers.values.where((p) => p.isGateway).forEach((gw) {
        debugPrint('[MeshService] known gateway: ${gw.peerId}');
      });
    });
  }

  void _loadKnownPeers() {
    _knownPeerRecords = StorageService.getKnownPeers();
    debugPrint('[MeshService] loaded ${_knownPeerRecords.length} known peers');
    for (final r in _knownPeerRecords.where((p) => p.role == 'gateway' || p.role == 'superPeer')) {
      debugPrint('[MeshService] known gateway: ${r.peerId} (${r.pseudo}) last seen: ${r.lastSeen}');
    }
  }

  Timer? _peerPersistTimer;

  void _startPeerPersistence() {
    _peerPersistTimer?.cancel();
    _peerPersistTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!_isRunning) return;
      _persistKnownPeers();
    });
  }

  void _persistKnownPeers() {
    final records = <PeerRecord>[];
    for (final peer in _peers.values) {
      final health = _transportHealth[peer.peerId];
      final reliability = health?.values.fold(0.0, (sum, h) => sum + h.reliability) ?? 1.0;
      final count = health?.values.fold(0, (sum, h) => sum + h.totalSuccess) ?? 0;
      records.add(PeerRecord(
        peerId: peer.peerId,
        pseudo: peer.pseudo,
        role: peer.role.name,
        transports: peer.transports.map((t) => t.name).toList(),
        platform: peer.platform,
        interestGroups: peer.interestGroups.toList(),
        reliability: reliability,
        lastSeen: DateTime.now(),
        totalMessagesExchanged: count,
      ));
    }
    _knownPeerRecords = records;
    StorageService.savePeers(records);
  }

  // ── Gestion des pairs ────────────────────────────────────────────────────

  void _onBlePeerEvent(MeshPeerEvent event) {
    _updatePeer(
      event.peerId, event.pseudo, event.hopCount,
      event.isGateway, TransportKind.ble, event.isConnected,
      platform: event.platform,
    );
  }

  void _onWifiPeerEvent(MeshPeerEvent event) {
    _updatePeer(event.peerId, event.pseudo, event.hopCount, event.isGateway, TransportKind.localWifi, event.isConnected);
  }

  void _onNativePeerEvent(MeshPeerEvent event) {
    _updatePeer(event.peerId, event.pseudo, event.hopCount, event.isGateway, TransportKind.nativeP2P, event.isConnected);
  }

  void _updatePeer(
    String peerId, String pseudo, int hopCount, bool isGateway,
    TransportKind transport, bool connected, {
    String platform = 'unknown',
  }) {
    if (peerId == _myId) return;

    if (!connected) {
      final existing = _peers[peerId];
      if (existing != null) {
        final updated = existing.copyWith(
          transports: Set.from(existing.transports)..remove(transport),
        );
        if (updated.transports.isEmpty) {
          _peers.remove(peerId);
          _peerEventsCtrl.add(updated);
        } else {
          _peers[peerId] = updated;
        }
      }
      return;
    }

    _peersEverSeen++;

    final existing = _peers[peerId];
    if (existing != null) {
      _peers[peerId] = existing.copyWith(
        transports: Set.from(existing.transports)..add(transport),
        hopCount: hopCount,
        isGateway: isGateway,
        platform: platform,
        role: isGateway ? PeerRole.gateway : PeerRole.leaf,
        connectionScore: existing.connectionScore + 1,
      );

      // Mettre à jour le timestamp du pair persistant
      StorageService.upsertPeer(PeerRecord(
        peerId: peerId,
        pseudo: existing.pseudo,
        role: isGateway ? 'gateway' : 'leaf',
        transports: existing.transports.map((t) => t.name).toList()..add(transport.name),
        platform: platform,
        lastSeen: DateTime.now(),
      ));
    } else {
      _peers[peerId] = ConnectedPeer(
        peerId: peerId,
        pseudo: pseudo,
        hopCount: hopCount,
        isGateway: isGateway,
        transports: {transport},
        platform: platform,
        role: isGateway ? PeerRole.gateway : PeerRole.leaf,
      );

      // Sauvegarder immédiatement le nouveau pair dans la table persistante
      StorageService.upsertPeer(PeerRecord(
        peerId: peerId,
        pseudo: pseudo,
        role: isGateway ? 'gateway' : 'leaf',
        transports: [transport.name],
        platform: platform,
        lastSeen: DateTime.now(),
      ));
    }

    // Limiter le nombre de connexions directes : évincer le plus faible
    if (_peers.length > config.maxDirectConnections) {
      _evictWorstPeer();
    }

    if (isGateway) {
      _knownGateways[peerId] = _peers[peerId]!;
    }

    _adjustScanRate();
    _peerEventsCtrl.add(_peers[peerId]!);
  }

  void _evictWorstPeer() {
    String? worstId;
    int worstScore = 999999;
    for (final entry in _peers.entries) {
      if (entry.value.role == PeerRole.gateway || entry.value.role == PeerRole.superPeer) continue;
      if (entry.value.connectionScore < worstScore) {
        worstScore = entry.value.connectionScore;
        worstId = entry.key;
      }
    }
    if (worstId != null) {
      debugPrint('[MeshService] evicting low-score peer $worstId (score=$worstScore)');
      _peers.remove(worstId);
    }
  }

  void _onIncomingData(MeshIncomingData data) {
    // Filtrage par scope/groupe si applicable
    if (_seenMessageIds.contains(data.messageId)) return;
    _seenMessageIds.add(data.messageId);

    _incomingDataCtrl.add(data);
  }

  bool hasWifiTransport(String peerId) {
    final peer = _peers[peerId];
    if (peer == null) return false;
    return peer.transports.contains(TransportKind.localWifi) ||
           peer.transports.contains(TransportKind.nativeP2P);
  }

  NativeP2PTransport get nativeTransport => _nativeTransport;

  final Map<String, bool> _wifiNegotiations = {};

  Future<bool> negotiateWifi(String peerId) async {
    final peer = _peers[peerId];
    if (peer == null) return false;
    if (hasWifiTransport(peerId)) return true;
    if (_wifiNegotiations.containsKey(peerId)) return false;
    _wifiNegotiations[peerId] = true;
    try {
      if (peer.platform == 'android' && _nativeTransport.isRunning) {
        _nativeTransport.setStrategy(NearbyStrategy.pointToPoint);
        await Future.delayed(const Duration(seconds: 3));
        _wifiNegotiations.remove(peerId);
        return hasWifiTransport(peerId);
      }
      await Future.delayed(const Duration(seconds: 3));
      _wifiNegotiations.remove(peerId);
      return hasWifiTransport(peerId);
    } catch (_) {
      _wifiNegotiations.remove(peerId);
      return false;
    }
  }

  // ── Santé des transports ─────────────────────────────────────────────────

  bool isTransportExcluded(String peerId, TransportKind kind) {
    final health = _transportHealth[peerId]?[kind];
    if (health == null) return false;
    return health.consecutiveFailures >= maxFailuresBeforeExclude;
  }

  void _recordSuccess(String peerId, TransportKind kind) {
    _transportHealth.putIfAbsent(peerId, () => {});
    final current = _transportHealth[peerId]![kind];
    _transportHealth[peerId]![kind] = TransportHealth(
      consecutiveFailures: 0,
      totalSuccess: (current?.totalSuccess ?? 0) + 1,
      lastUsed: DateTime.now(),
    );
    _emitHealth();
  }

  void _recordFailure(String peerId, TransportKind kind) {
    _transportHealth.putIfAbsent(peerId, () => {});
    final current = _transportHealth[peerId]![kind];
    _transportHealth[peerId]![kind] = TransportHealth(
      consecutiveFailures: (current?.consecutiveFailures ?? 0) + 1,
      totalSuccess: current?.totalSuccess ?? 0,
      lastUsed: DateTime.now(),
    );
    _totalFailed++;
    _emitHealth();
  }

  void incrementAck() {
    _totalAcks++;
    _emitHealth();
  }

  MeshHealth get health {
    final bleHealth = <String, TransportHealth>{};
    final wifiHealth = <String, TransportHealth>{};
    final nativeHealth = <String, TransportHealth>{};

    for (final entry in _transportHealth.entries) {
      for (final tEntry in entry.value.entries) {
        switch (tEntry.key) {
          case TransportKind.ble: bleHealth[entry.key] = tEntry.value;
          case TransportKind.localWifi: wifiHealth[entry.key] = tEntry.value;
          case TransportKind.nativeP2P: nativeHealth[entry.key] = tEntry.value;
          case TransportKind.both: break;
        }
      }
    }

    final allHealth = _transportHealth.values
        .expand((m) => m.values)
        .toList();
    final avgRel = allHealth.isEmpty
        ? 1.0
        : allHealth.fold(0.0, (s, h) => s + h.reliability) / allHealth.length;

    return MeshHealth(
      totalPeers: _peers.length,
      peersOnWifi: wifiPeerCount,
      peersOnBle: blePeerCount,
      peersOnNative: nativePeerCount,
      gatewayCount: gatewayCount,
      superPeerCount: superPeerCount,
      averageReliability: avgRel,
      messagesSent: _totalSent,
      acksReceived: _totalAcks,
      failedDeliveries: _totalFailed,
      bleHealth: bleHealth,
      wifiHealth: wifiHealth,
      nativeHealth: nativeHealth,
    );
  }

  void _emitHealth() {
    _healthCtrl.add(health);
  }

  void resetTransportHealth(String peerId) {
    _transportHealth.remove(peerId);
    _emitHealth();
  }

  void resetAllTransportHealth() {
    _transportHealth.clear();
    _emitHealth();
  }

  // ── Remise multi-voies avec routage par intérêt ─────────────────────────

  List<TransportKind> _getCandidateTransports(ConnectedPeer peer, int type) {
    final ordered = <TransportKind>[];
    if (peer.transports.contains(TransportKind.localWifi)) {
      ordered.add(TransportKind.localWifi);
    }
    if (peer.transports.contains(TransportKind.nativeP2P)) {
      ordered.add(TransportKind.nativeP2P);
    }
    if (peer.transports.contains(TransportKind.ble) && type < 0x20) {
      ordered.add(TransportKind.ble);
    }
    ordered.removeWhere((k) => isTransportExcluded(peer.peerId, k));
    return ordered;
  }

  Future<void> _sendVia(TransportKind kind, String peerId, Uint8List data, int type) async {
    switch (kind) {
      case TransportKind.localWifi:
        await _wifiTransport.sendToPeer(peerId, data);
      case TransportKind.nativeP2P:
        await _nativeTransport.sendToPeer(peerId, data);
      case TransportKind.ble:
        await _bleTransport.sendToPeer(peerId, data, type: type);
      case TransportKind.both:
        break;
    }
  }

  /// Route un message vers un pair spécifique avec priorisation
  /// des transports les plus économes en batterie.
  Future<void> sendToPeer(String peerId, Uint8List data, {int type = 0x00}) async {
    final peer = _peers[peerId];
    if (peer == null) {
      debugPrint('[Mesh] sendToPeer $peerId: pair inconnu');
      return;
    }

    // Si batterie faible (<15%), forcer Wi-Fi uniquement (pas de BLE)
    if (_batteryLevel < 0.15 && type < 0x20) {
      // BLE skip en batterie faible
    }

    final candidates = _getCandidateTransports(peer, type);
    if (candidates.isEmpty) {
      debugPrint('[Mesh] Aucun transport disponible pour $peerId');
      return;
    }

    debugPrint('[Mesh] sendToPeer $peerId type=$type candidats=$candidates');
    _totalSent++;

    final completer = Completer<void>();
    int failCount = 0;

    for (final kind in candidates) {
      _sendVia(kind, peerId, data, type).then((_) {
        _recordSuccess(peerId, kind);
        if (!completer.isCompleted) completer.complete();
      }).catchError((e) {
        _recordFailure(peerId, kind);
        failCount++;
        if (failCount == candidates.length && !completer.isCompleted) {
          completer.completeError(
            Exception('Tous les transports ont échoué pour $peerId'),
          );
        }
      });
    }

    await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => null,
    );
  }

  /// Diffusion intelligente : ne diffuse qu'aux pairs qui correspondent
  /// aux groupes d'intérêt spécifiés (ou tous si non spécifié).
  Future<void> broadcastToConnectedPeers(
    Uint8List data, {
    String? excludePeerId,
    Set<String>? interestGroups,
  }) async {
    Iterable<ConnectedPeer> targets = _peers.values;

    if (excludePeerId != null) {
      targets = targets.where((p) => p.peerId != excludePeerId);
    }

    // Routage par intérêt : ne diffuser qu'aux pairs abonnés
    if (interestGroups != null && interestGroups.isNotEmpty) {
      targets = targets.where((p) =>
        p.interestGroups.intersection(interestGroups).isNotEmpty ||
        p.role == PeerRole.gateway ||
        p.role == PeerRole.superPeer
      );
    }

    final futures = targets.map((peer) => sendToPeer(peer.peerId, data));
    await Future.wait(futures);
  }

  void dispose() {
    _adaptiveBeaconTimer?.cancel();
    _stalePeerTimer?.cancel();
    _gatewayAnnounceTimer?.cancel();
    _peerPersistTimer?.cancel();
    _persistKnownPeers();
    _bleTransport.dispose();
    _wifiTransport.dispose();
    _nativeTransport.dispose();
    _peerEventsCtrl.close();
    _incomingDataCtrl.close();
    _healthCtrl.close();
  }
}
