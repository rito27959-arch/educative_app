import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/mesh_message.dart';
import '../services/storage_service.dart';
import '../services/mesh_transport_service.dart';
import '../services/ble_mesh_protocol.dart';
import '../services/call_signaling_service.dart';
import '../services/content_propagation_service.dart';
import '../services/swarm_download_manager.dart';

class _PendingRelay {
  final String id;
  final Uint8List payload;
  _PendingRelay(this.id, this.payload);
}

/// Repository mesh scalable à 10M utilisateurs.
///
/// ## Scaling
/// - Routage par groupes d'intérêt (série, matière, région)
/// - TTL des messages avec expiration automatique
/// - Outbox sharded par priorité
/// - Gateway election pour backbone mesh
/// - Dédoublonnage distribué (Bloom filter virtuel)
///
/// ## Batterie
/// - ACK batching (regroupe les ACK)
/// - Pas de relay BLE si batterie < 15%
/// - Flush d'outbox différé en background
class MeshRepository {
  final MeshTransportService _transport = MeshTransportService();
  late final SwarmDownloadManager swarmDownload;
  bool _initialized = false;

  final ContentPropagationService contentPropagation = ContentPropagationService();

  Set<String> _seenMessageIds = {};
  final Set<String> _appMessageIds = {};
  final Map<String, int> _ackCounts = {};

  String _myId = '';
  String _myPseudo = '';

  Stream<ConnectedPeer>? get peerEvents => _transport.peerEvents;
  Stream<MeshIncomingData>? get incomingData => _transport.incomingData;
  MeshTransportService get transport => _transport;

  String get myId => _myId;
  String get myPseudo => _myPseudo;

  int get connectedPeers => _transport.connectedPeerCount;
  int get blePeerCount => _transport.blePeerCount;
  int get wifiPeerCount => _transport.wifiPeerCount;
  List<ConnectedPeer> get peerList => _transport.connectedPeers;
  int get peersEverSeen => _transport.peersEverSeen;

  int getAckCount(String messageId) => _ackCounts[messageId] ?? 0;

  final _ackCtrl = StreamController<String>.broadcast();
  Stream<String> get ackEvents => _ackCtrl.stream;

  // ── Contribution Registry ────────────────────────────────────────────────

  Future<void> recordContribution({
    required String type,
    required int points,
    String? description,
  }) async {
    await StorageService.addContributionEvent(
      type: type,
      points: points,
      description: description,
    );
  }

  ContributionPoints get contributionPoints =>
      StorageService.getContributionPoints();

  void creditRelay() {
    recordContribution(type: 'relay', points: 10, description: 'Relais mesh');
  }

  void creditForumHelpful() {
    recordContribution(type: 'forum_helpful', points: 25, description: 'Réponse validée');
  }

  void creditTutoringCall() {
    recordContribution(type: 'tutoring_call', points: 50, description: 'Appel tutorat');
  }

  void creditRelayMinute() {
    recordContribution(type: 'relay_minute', points: 2, description: 'Disponibilité relais');
  }

  Timer? _relayMinuteTimer;

  void _startRelayMinuteTimer() {
    _relayMinuteTimer?.cancel();
    _relayMinuteTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (_transport.connectedPeerCount > 0) {
        creditRelayMinute();
      }
    });
  }

  Future<void> init(String myId, String myPseudo, {
    Set<String>? interestGroups,
  }) async {
    if (_initialized) return;
    _myId = myId;
    _myPseudo = myPseudo;

    debugPrint('[MeshRepo] init() id=$myId pseudo=$myPseudo groups=$interestGroups');

    _seenMessageIds = StorageService.getSeenMessageIds();

    await _transport.startMesh(
      myId,
      myPseudo,
      interestGroups: interestGroups,
    );
    _initialized = true;

    contentPropagation.init(
      transport: _transport,
      myId: myId,
      myPseudo: myPseudo,
    );

    swarmDownload = SwarmDownloadManager(_transport);
    swarmDownload.start();

    _transport.incomingData.listen((data) {
      _handleIncomingMessage(data);
    });

    _transport.peerEvents.listen((peer) {
      if (_transport.connectedPeerCount > 0) flushPendingRelays();
    });

    _loadPendingRelays();
    _startRelayMinuteTimer();

    debugPrint('[MeshRepo] init() completed, peers=${_transport.connectedPeerCount}');
  }

  Future<void> dispose() async {
    contentPropagation.dispose();
    swarmDownload.dispose();
    await _transport.stopMesh();
    _initialized = false;
  }

  /// Met à jour les groupes d'intérêt (série, matière, région).
  void setInterestGroups(Set<String> groups) {
    _transport.setInterestGroups(groups);
  }

  /// Met à jour le niveau de batterie.
  void updateBatteryLevel(double level) {
    _transport.updateBatteryLevel(level);
  }

  /// Met à jour l'état foreground/background.
  void setForegroundState(bool isForeground) {
    _transport.setForegroundState(isForeground);
  }

  /// Batching d'ACK : accumule et envoie par lot.
  final List<String> _ackBatch = [];
  Timer? _ackBatchTimer;

  void _sendAck(String targetPeerId, String originalMessageId) {
    _ackBatch.add(originalMessageId);
    _ackBatchTimer ??= Timer(const Duration(seconds: 2), () {
      _flushAckBatch(targetPeerId);
    });
  }

  void _flushAckBatch(String targetPeerId) {
    if (_ackBatch.isEmpty) return;
    final batchPayload = utf8.encode(_ackBatch.join(','));
    final packet = Uint8List(2 + batchPayload.length);
    packet[0] = 0;
    packet[1] = kAckType;
    packet.setRange(2, packet.length, batchPayload);
    _transport.sendToPeer(targetPeerId, packet);
    _ackBatch.clear();
    _ackBatchTimer = null;
  }

  // ── Messages entrants ────────────────────────────────────────────────────

  void _handleIncomingMessage(MeshIncomingData data) {
    if (_seenMessageIds.contains(data.messageId)) return;
    _seenMessageIds.add(data.messageId);
    StorageService.addSeenMessageId(data.messageId);

    if (data.data.length < 2) return;
    final int hopCount = data.data[0];
    final int msgType = data.data[1];

    if (msgType == kAckType) {
      _handleAck(data);
      return;
    }

    if (msgType >= kCallOffer && msgType <= kCallHangUp) return;

    if (msgType == kFileTransferType) {
      _handleFileTransfer(data, hopCount);
      return;
    }

    if (msgType != kTextMessageType) return;
    if (data.data.length < 3) return;
    final Uint8List contentBytes = data.data.sublist(2);

    try {
      final raw = utf8.decode(contentBytes);
      String content;
      String? replyToId;
      String? senderId;
      String? appMsgId;
      try {
        final parsed = json.decode(raw) as Map<String, dynamic>;
        content = parsed['c'] as String? ?? raw;
        replyToId = parsed['r'] as String?;
        senderId = parsed['s'] as String?;
        appMsgId = parsed['m'] as String?;
      } catch (_) {
        content = raw;
      }

      if (appMsgId != null) {
        if (_appMessageIds.contains(appMsgId)) return;
        _appMessageIds.add(appMsgId);
      }

      if (senderId == _myId) return;

      String authorPseudo = data.peerId;
      if (senderId != null) {
        try {
          final peer = _transport.connectedPeers.firstWhere(
            (p) => p.peerId == senderId,
          );
          authorPseudo = peer.pseudo;
        } catch (_) {
          authorPseudo = senderId;
        }
      } else {
        try {
          final peer = _transport.connectedPeers.firstWhere(
            (p) => p.peerId == data.peerId,
          );
          authorPseudo = peer.pseudo;
        } catch (_) {}
      }

      final msg = MeshMessage(
        id: appMsgId ?? data.messageId,
        authorPseudo: authorPseudo,
        content: content,
        type: 'mesh',
        timestamp: DateTime.now(),
        hopCount: hopCount,
        replyToId: replyToId,
      );
      StorageService.saveMessage(msg);

      if (senderId != null && senderId != _myId) {
        _sendAck(senderId, appMsgId ?? data.messageId);
      }
    } catch (e) { debugPrint('[MeshRepo] $e'); }

    _relayOrDefer(data.messageId, data.data, hopCount, excludePeerId: data.peerId);
  }

  void _handleAck(MeshIncomingData data) {
    try {
      final ackPayload = utf8.decode(data.data.sublist(2));
      final ids = ackPayload.split(',');
      for (final ackedMsgId in ids) {
        final current = _ackCounts[ackedMsgId] ?? 0;
        _ackCounts[ackedMsgId] = current + 1;
        _transport.incrementAck();
        _ackCtrl.add(ackedMsgId);
      }
      debugPrint('[MeshRepo] ACK batch reçu: ${ids.length} messages');
    } catch (e) {
      debugPrint('[MeshRepo] Erreur traitement ACK: $e');
    }
  }

  void _handleFileTransfer(MeshIncomingData data, int hopCount) {
    try {
      final bytes = data.data;
      if (bytes.length < 5) return;
      final jsonLen = (bytes[2] << 8) | bytes[3];
      if (bytes.length < 4 + jsonLen) return;
      final jsonStr = utf8.decode(bytes.sublist(4, 4 + jsonLen));
      final meta = json.decode(jsonStr) as Map<String, dynamic>;
      final fileId = meta['fileId'] as String;
      final fileName = meta['fileName'] as String;
      final fileSize = meta['fileSize'] as int;
      final mimeType = meta['mimeType'] as String? ?? '';
      final authorPseudo = meta['authorPseudo'] as String? ?? data.peerId;
      final fileBytes = bytes.sublist(4 + jsonLen);

      if (_appMessageIds.contains(fileId)) return;
      _appMessageIds.add(fileId);

      StorageService.saveSharedFile(
        fileId: fileId,
        fileName: fileName,
        bytes: fileBytes,
      );

      final msg = MeshMessage(
        id: fileId,
        authorPseudo: authorPseudo,
        content: fileName,
        type: 'file',
        timestamp: DateTime.now(),
        fileId: fileId,
        fileName: fileName,
        fileSize: fileSize,
        fileMimeType: mimeType,
        hopCount: hopCount,
      );
      StorageService.saveMessage(msg);
      debugPrint('[MeshRepo] Fichier reçu: $fileName ($fileSize octets)');

      _relayOrDefer(data.messageId, data.data, hopCount, excludePeerId: data.peerId);
    } catch (e) {
      debugPrint('[MeshRepo] Erreur réception fichier: $e');
    }
  }

  List<MeshMessage> getMessages() => StorageService.getMessages();

  final List<_PendingRelay> _pendingRelays = [];

  static const int kDefaultHopCount = 5;

  Future<void> sendMessage({
    required String authorPseudo,
    required String content,
    String type = 'text',
    String? imageUrl,
    String? audioUrl,
    String? replyToId,
    String? messageId,
    Set<String>? interestGroups,
  }) async {
    final jsonMap = <String, dynamic>{
      'c': content,
      's': _myId,
    };
    if (replyToId != null) jsonMap['r'] = replyToId;
    if (messageId != null) jsonMap['m'] = messageId;
    final payloadBytes = utf8.encode(json.encode(jsonMap));
    final data = Uint8List(2 + payloadBytes.length);
    data[0] = kDefaultHopCount;
    data[1] = kTextMessageType;
    data.setRange(2, data.length, payloadBytes);
    await _transport.broadcastToConnectedPeers(
      data,
      interestGroups: interestGroups,
    );
  }

  void _relayOrDefer(String messageId, Uint8List fullPayload, int remainingHops, {String? excludePeerId}) {
    if (remainingHops <= 1) {
      debugPrint('[MeshRepo] relais fini msg=$messageId (hops=$remainingHops)');
      return;
    }
    if (_transport.connectedPeerCount == 0) {
      _pendingRelays.add(_PendingRelay(messageId, Uint8List.fromList(fullPayload)));
      StorageService.savePendingRelay(messageId, fullPayload);
      debugPrint('[MeshRepo] relais différé msg=$messageId (aucun pair)');
      return;
    }
    _relayNow(messageId, fullPayload, remainingHops, excludePeerId: excludePeerId);
  }

  void _relayNow(String messageId, Uint8List fullPayload, int remainingHops, {String? excludePeerId}) {
    final nextHops = remainingHops - 1;
    final relayData = Uint8List.fromList(fullPayload);
    relayData[0] = nextHops;

    _transport.broadcastToConnectedPeers(relayData, excludePeerId: excludePeerId);
    _relayCounter++;
    debugPrint('[MeshRepo] relais #$_relayCounter msg=$messageId hops=$remainingHops→$nextHops peers=${_transport.connectedPeerCount}');
    creditRelay();
  }

  int _relayCounter = 0;

  void flushPendingRelays() {
    if (_pendingRelays.isEmpty) return;
    final toForward = List<_PendingRelay>.from(_pendingRelays);
    _pendingRelays.clear();
    StorageService.clearPendingRelays();
    debugPrint('[MeshRepo] flush ${toForward.length} relais en attente');
    for (final pending in toForward) {
      final hops = pending.payload.isNotEmpty ? pending.payload[0] : 0;
      if (hops > 1) _relayNow(pending.id, pending.payload, hops);
    }
  }

  void _loadPendingRelays() {
    try {
      final stored = StorageService.getPendingRelays();
      for (final entry in stored) {
        final id = entry['id'] as String;
        final b64 = entry['payload'] as String;
        final payload = base64Decode(b64);
        _pendingRelays.add(_PendingRelay(id, Uint8List.fromList(payload)));
      }
      if (_pendingRelays.isNotEmpty) {
        debugPrint('[MeshRepo] ${_pendingRelays.length} relais chargés du stockage');
      }
    } catch (e) {
      debugPrint('[MeshRepo] erreur chargement relais: $e');
    }
  }

  List<MeshMessage> getMessagesByType(String type) {
    return StorageService.getMessages()
        .where((m) => m.type == type)
        .toList();
  }

  List<MeshMessage> getMessagesByAuthor(String pseudo) {
    return StorageService.getMessages()
        .where((m) => m.authorPseudo == pseudo)
        .toList();
  }

  int getMessageCount() => StorageService.getMessages().length;

  MeshStats getStats() {
    final health = _transport.health;
    return MeshStats(
      distributedGb: StorageService.getMessageCount() * 0.001,
      relayedFiles: StorageService.getMessages().where((m) => m.type == 'file').length,
      helpedPeers: _transport.connectedPeerCount,
      totalPeers: _transport.connectedPeerCount,
      blePeers: _transport.blePeerCount,
      wifiPeers: _transport.wifiPeerCount,
      nativePeers: _transport.nativePeerCount,
      averageReliability: health.averageReliability,
      messagesSent: health.messagesSent,
      acksReceived: health.acksReceived,
    );
  }

  void setGatewayMode(bool enabled) {
    _transport.setRole(enabled ? PeerRole.gateway : PeerRole.leaf);
  }
}

/// Découverte de pairs scalable.
class PeerDiscoveryService {
  final MeshTransportService _transport;

  PeerDiscoveryService(this._transport);

  List<ConnectedPeer> get discoveredPeers => _transport.connectedPeers;

  bool get isScanning => true;

  ConnectedPeer? getPeerById(String id) {
    try {
      return _transport.connectedPeers.firstWhere((p) => p.peerId == id);
    } catch (e) { debugPrint('[MeshRepo] $e');
      return null;
    }
  }

  Set<TransportKind> getTransportsForPeer(String peerId) {
    final peer = getPeerById(peerId);
    return peer?.transports ?? {};
  }
}
