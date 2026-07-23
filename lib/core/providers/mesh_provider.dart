export '../models/mesh_message.dart' show ContributionPoints, ContributionRank;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mesh_message.dart';
import '../services/storage_service.dart';
import '../services/mesh_transport_service.dart';
import '../services/ble_mesh_protocol.dart';
import '../services/call_signaling_service.dart';
import '../services/webrtc_call_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../services/content_propagation_service.dart';
import '../repositories/mesh_repository.dart';
import 'auth_provider.dart';
import '../../shared/widgets/mesh_toast.dart';

final meshRepositoryProvider = Provider<MeshRepository>((ref) {
  final repo = MeshRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});

final meshMessagesProvider =
    StateNotifierProvider<MeshNotifier, List<MeshMessage>>((ref) {
  final repo = ref.watch(meshRepositoryProvider);
  final showToast = (String msg, {ToastType type = ToastType.info}) =>
      ref.read(toastProvider.notifier).show(msg, type: type);
  return MeshNotifier(repo, showToast);
});

final meshStatsProvider = Provider<MeshStats>((ref) {
  final peers = ref.watch(meshPeerListProvider);
  return _buildRealStats(peers: peers);
});

final meshBlePeersProvider = Provider<int>((ref) {
  final peers = ref.watch(meshPeerListProvider);
  return _buildRealStats(peers: peers).blePeers;
});

final meshWifiPeersProvider = Provider<int>((ref) {
  final peers = ref.watch(meshPeerListProvider);
  return _buildRealStats(peers: peers).wifiPeers;
});

MeshStats _buildRealStats({List<ConnectedPeer> peers = const []}) {
  final messages = StorageService.getMessages();
  final relayedFiles = messages.where((m) => m.type == 'file').length;
  final totalMessages = messages.length;
  final estimatedGb = totalMessages * 0.001;
  final uniqueAuthors = messages.map((m) => m.authorPseudo).toSet().length;
  final bleCount = peers.where((p) => p.transports.contains(TransportKind.ble)).length;
  final wifiCount = peers.where((p) => p.transports.contains(TransportKind.localWifi)).length;
  final nativeCount = peers.where((p) => p.transports.contains(TransportKind.nativeP2P)).length;

  return MeshStats(
    distributedGb: double.parse(estimatedGb.toStringAsFixed(2)),
    relayedFiles: relayedFiles,
    helpedPeers: uniqueAuthors,
    totalPeers: peers.length > 0 ? peers.length : (uniqueAuthors > 0 ? uniqueAuthors : 1),
    blePeers: bleCount,
    wifiPeers: wifiCount,
    nativePeers: nativeCount,
  );
}

/// Santé en temps réel du mesh (multi‑transport, fiabilité, ACK).
final meshHealthProvider = StreamProvider<MeshHealth>((ref) {
  final repo = ref.watch(meshRepositoryProvider);
  return repo.transport.healthEvents;
});

/// ACK d'un message spécifique.
final messageAckProvider = Provider.family<int, String>((ref, messageId) {
  final repo = ref.watch(meshRepositoryProvider);
  return repo.getAckCount(messageId);
});

class MeshNotifier extends StateNotifier<List<MeshMessage>> {
  final MeshRepository _repo;
  final void Function(String, {ToastType type}) _showToast;
  StreamSubscription<MeshIncomingData>? _incomingSub;
  StreamSubscription<void>? _peerSub;
  StreamSubscription<String>? _ackSub;

  /// Messages en attente d'envoi (0 pair connecté au moment du tap).
  final List<_OutboxEntry> _outbox = [];

  MeshNotifier(this._repo, this._showToast) : super(StorageService.getMessages()) {
    _incomingSub = _repo.incomingData?.listen(_onIncomingData);
    _peerSub = _repo.peerEvents?.listen((_) => _flushOutbox());
    _ackSub = _repo.ackEvents.listen((messageId) {
      // Forcer le rebuild des messages qui ont reçu un ACK
      state = state.map((m) {
        if (m.id != messageId) return m;
        return m.copyWith(deliveryCount: _repo.getAckCount(messageId));
      }).toList();
    });
    _loadOutbox();
  }

  /// Charge la file d'attente persistée au démarrage.
  void _loadOutbox() {
    final stored = StorageService.getOutbox();
    for (final entry in stored) {
      final kind = entry['kind'] as String?;
      if (kind == 'text') {
        _outbox.add(_OutboxEntry(messageId: entry['id'] as String, kind: _OutboxKind.text));
      } else if (kind == 'file') {
        final bytesStr = entry['bytes'] as String?;
        final bytes = bytesStr != null ? base64Decode(bytesStr) : null;
        _outbox.add(_OutboxEntry(
          messageId: entry['id'] as String,
          kind: _OutboxKind.file,
          fileBytes: bytes,
        ));
      }
    }
    if (_outbox.isNotEmpty) {
      debugPrint('[MeshNotifier] ${_outbox.length} messages en attente chargés');
      if (_repo.transport.connectedPeerCount > 0) _flushOutbox();
    }
  }

  void _onIncomingData(MeshIncomingData data) {
    if (data.data.length < 2) return;
    final int msgType = data.data[1];
    if (msgType >= kCallOffer && msgType <= kCallHangUp) return;
    // ACK traité par MeshRepository, on rebuild juste si besoin
    if (msgType == kAckType) return;
    if (msgType == kFileTransferType) {
      _handleIncomingFile(data);
      return;
    }
    if (msgType != kTextMessageType || data.data.length < 3) return;
    if (state.any((m) => m.id == data.messageId)) return;
    try {
      final raw = utf8.decode(data.data.sublist(2));
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

      // Dédoublonnage applicatif (inchangé par les relais)
      if (appMsgId != null && state.any((m) => m.id == appMsgId)) return;

      final peer = _repo.peerList.cast<ConnectedPeer?>().firstWhere(
        (p) => p?.peerId == (senderId ?? data.peerId),
        orElse: () => null,
      );
      final remainingHops = data.data[0];
      final hopsTraveled = MeshRepository.kDefaultHopCount - remainingHops;
      final routeInfo = hopsTraveled == 0 ? 'Direct' : '↗ $hopsTraveled saut${hopsTraveled > 1 ? 's' : ''}';
      final msg = MeshMessage(
        id: appMsgId ?? data.messageId,
        authorPseudo: peer?.pseudo ?? senderId ?? 'Inconnu',
        content: content,
        type: 'text',
        timestamp: DateTime.now(),
        hopCount: remainingHops,
        replyToId: replyToId,
        routeInfo: routeInfo,
      );
      state = [...state, msg];
    } catch (e) {
      debugPrint('[MeshNotifier] Erreur message entrant: $e');
      _showToast('Erreur de lecture d\'un message reçu', type: ToastType.warning);
    }
  }

  void _handleIncomingFile(MeshIncomingData data) {
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
      final remainingHops = bytes[0];
      final hopsTraveled = MeshRepository.kDefaultHopCount - remainingHops;
      final routeInfo = hopsTraveled == 0 ? 'Direct' : '↗ $hopsTraveled saut${hopsTraveled > 1 ? 's' : ''}';

      if (state.any((m) => m.fileId == fileId)) return;

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
        hopCount: remainingHops,
        routeInfo: routeInfo,
      );
      state = [...state, msg];
    } catch (e) {
      debugPrint('[MeshNotifier] Erreur fichier entrant: $e');
    }
  }

  Future<void> sendMessage(String pseudo, String content,
      {String type = 'text', String? imageUrl, String? audioUrl, String? replyToId}) async {
    final msg = MeshMessage(
      id: BleMeshProtocol.generateMessageId(),
      authorPseudo: pseudo,
      content: content,
      type: type,
      timestamp: DateTime.now(),
      imageUrl: imageUrl,
      audioUrl: audioUrl,
      hopCount: MeshRepository.kDefaultHopCount,
      replyToId: replyToId,
      status: MessageStatus.sending,
    );

    await StorageService.saveMessage(msg);
    state = [...state, msg];

    if (_repo.transport.connectedPeerCount > 0) {
      try {
        await _repo.sendMessage(
          authorPseudo: pseudo,
          content: content,
          type: type,
          imageUrl: imageUrl,
          audioUrl: audioUrl,
          replyToId: replyToId,
          messageId: msg.id,
        );
        _setStatus(msg.id, MessageStatus.sent);
      } catch (_) {
        _setStatus(msg.id, MessageStatus.failed);
        _showToast('Échec de l\'envoi du message', type: ToastType.error);
      }
    } else {
      _setStatus(msg.id, MessageStatus.pending);
      _outbox.add(_OutboxEntry(messageId: msg.id, kind: _OutboxKind.text));
      unawaited(StorageService.saveOutbox({
        'id': msg.id, 'kind': 'text',
      }));
    }
  }

  Future<void> sendFile({
    required String pseudo,
    required String fileName,
    required Uint8List bytes,
    String mimeType = '',
  }) async {
    final fileId = const Uuid().v4();
    const int hopCount = MeshRepository.kDefaultHopCount;

    final msg = MeshMessage(
      id: fileId,
      authorPseudo: pseudo,
      content: fileName,
      type: 'file',
      timestamp: DateTime.now(),
      fileId: fileId,
      fileName: fileName,
      fileSize: bytes.length,
      fileMimeType: mimeType,
      status: MessageStatus.sending,
    );

    await StorageService.saveMessage(msg);
    state = [...state, msg];

    final meta = json.encode({
      'fileId': fileId,
      'fileName': fileName,
      'fileSize': bytes.length,
      'mimeType': mimeType,
      'authorPseudo': pseudo,
    });
    final metaBytes = utf8.encode(meta);
    final data = Uint8List(2 + 2 + metaBytes.length + bytes.length);
    data[0] = hopCount;
    data[1] = kFileTransferType;
    data[2] = (metaBytes.length >> 8) & 0xFF;
    data[3] = metaBytes.length & 0xFF;
    data.setRange(4, 4 + metaBytes.length, metaBytes);
    data.setRange(4 + metaBytes.length, data.length, bytes);

    if (_repo.transport.connectedPeerCount > 0) {
      try {
        await _repo.transport.broadcastToConnectedPeers(data);
        _setStatus(msg.id, MessageStatus.sent);
      } catch (_) {
        _setStatus(msg.id, MessageStatus.failed);
        _showToast('Échec de l\'envoi du fichier', type: ToastType.error);
      }
    } else {
      _setStatus(msg.id, MessageStatus.pending);
      _outbox.add(_OutboxEntry(messageId: fileId, kind: _OutboxKind.file, fileBytes: data));
      unawaited(StorageService.saveOutbox({
        'id': fileId, 'kind': 'file', 'bytes': base64Encode(data),
      }));
    }

    await StorageService.saveSharedFile(
      fileId: fileId,
      fileName: fileName,
      bytes: bytes,
    );
  }

  void removeMessage(String messageId) {
    state = state.where((msg) => msg.id != messageId).toList();
  }

  void toggleReaction(String messageId, String reaction) {
    state = state.map((msg) {
      if (msg.id != messageId) return msg;
      final reactions = List<String>.from(msg.reactions);
      if (reactions.contains(reaction)) {
        reactions.remove(reaction);
      } else {
        reactions.add(reaction);
      }
      return msg.copyWith(reactions: reactions);
    }).toList();
  }

  void _flushOutbox() {
    if (_outbox.isEmpty) return;
    if (_repo.transport.connectedPeerCount == 0) return;

    final toFlush = List<_OutboxEntry>.from(_outbox);
    _outbox.clear();

    _showToast('${toFlush.length} message${toFlush.length > 1 ? 's' : ''} en attente envoyé${toFlush.length > 1 ? 's' : ''}', type: ToastType.success);

    for (final entry in toFlush) {
      _setStatus(entry.messageId, MessageStatus.sending);
      _doSendOutboxEntry(entry);
    }
  }

  Future<void> _doSendOutboxEntry(_OutboxEntry entry) async {
    try {
      if (entry.kind == _OutboxKind.text) {
        final msg = state.where((m) => m.id == entry.messageId).firstOrNull;
        if (msg != null) {
          await _repo.sendMessage(
            authorPseudo: msg.authorPseudo,
            content: msg.content,
            type: msg.type,
            imageUrl: msg.imageUrl,
            audioUrl: msg.audioUrl,
            replyToId: msg.replyToId,
            messageId: msg.id,
          );
        }
      } else if (entry.kind == _OutboxKind.file && entry.fileBytes != null) {
        await _repo.transport.broadcastToConnectedPeers(entry.fileBytes!);
      }
      _setStatus(entry.messageId, MessageStatus.sent);
    } catch (_) {
      _setStatus(entry.messageId, MessageStatus.failed);
      _showToast('Échec d\'envoi d\'un message en attente', type: ToastType.error);
    }
  }

  void _setStatus(String messageId, MessageStatus status) {
    state = state.map((m) {
      if (m.id != messageId) return m;
      return m.copyWith(status: status);
    }).toList();
    StorageService.updateMessageStatus(messageId, status);
  }

  @override
  void dispose() {
    _incomingSub?.cancel();
    _peerSub?.cancel();
    _ackSub?.cancel();
    super.dispose();
  }
}

enum _OutboxKind { text, file }

class _OutboxEntry {
  final String messageId;
  final _OutboxKind kind;
  final Uint8List? fileBytes;
  const _OutboxEntry({
    required this.messageId,
    required this.kind,
    this.fileBytes,
  });
}

final callProvider = StateNotifierProvider<CallNotifier, CallState>((ref) {
  return CallNotifier();
});

class CallNotifier extends StateNotifier<CallState> {
  CallSignalingService? _signaling;
  WebRtcCallService? _webrtc;
  StreamSubscription<CallEvent>? _eventSub;
  StreamSubscription<SignalingMessage>? _incomingCallSub;

  String? _pendingOfferSdp;

  CallNotifier() : super(const CallState());

  bool _initialized = false;

  void init(MeshTransportService transport) {
    if (_initialized) return;
    _initialized = true;
    _signaling = CallSignalingService(transport);
    _signaling!.startListening();
    _webrtc = WebRtcCallService(_signaling!);
    _incomingCallSub = _signaling!.incomingMessages.listen(_onIncomingCall);
  }

  void _onIncomingCall(SignalingMessage msg) {
    debugPrint('[CallNotifier] _onIncomingCall type=0x${msg.type.toRadixString(16)} peer=${msg.peerId} sdpPresent=${msg.data.containsKey('sdp')}');
    if (msg.type == kCallOffer) {
      final sdp = msg.data['sdp'] as String?;
      if (sdp == null) return;
      _pendingOfferSdp = sdp;
      state = state.copyWith(
        isCallActive: true,
        peerId: msg.peerId,
        direction: CallDirection.incoming,
        connectionState: CallConnectionState.connecting,
      );
    }
  }

  Future<void> startCall(String peerId, String peerPseudo) async {
    if (_signaling == null || _webrtc == null) return;

    state = state.copyWith(
      isCallActive: true,
      peerId: peerId,
      peerPseudo: peerPseudo,
      direction: CallDirection.outgoing,
      connectionState: CallConnectionState.connecting,
    );

    try {
      _eventSub?.cancel();
      _eventSub = _webrtc!.events.listen(_onWebrtcEvent);
      await _webrtc!.startCall(peerId);
    } catch (e) {
      state = state.copyWith(
        isCallActive: false,
        connectionState: CallConnectionState.failed,
      );
    }
  }

  Future<void> answerCall() async {
    if (_signaling == null || _webrtc == null) return;
    final peerId = state.peerId;
    final sdp = _pendingOfferSdp;
    if (peerId == null || sdp == null) return;

    state = state.copyWith(
      isCallActive: true,
      connectionState: CallConnectionState.connecting,
    );

    try {
      _eventSub?.cancel();
      _eventSub = _webrtc!.events.listen(_onWebrtcEvent);
      await _webrtc!.answerCall(peerId, sdp);
    } catch (e) {
      state = state.copyWith(
        isCallActive: false,
        connectionState: CallConnectionState.failed,
      );
    }
  }

  RTCVideoRenderer? get remoteRenderer => _webrtc?.remoteRenderer;
  RTCVideoRenderer? get localRenderer => _webrtc?.localRenderer;

  void _onWebrtcEvent(CallEvent event) {
    if (event is CallConnecting) {
      state = state.copyWith(connectionState: CallConnectionState.connecting);
    } else if (event is CallConnected) {
      state = state.copyWith(connectionState: CallConnectionState.connected);
    } else if (event is CallFailed) {
      state = state.copyWith(
        isCallActive: false,
        connectionState: CallConnectionState.failed,
      );
    } else if (event is CallDisconnected) {
      state = state.copyWith(
        isCallActive: false,
        connectionState: CallConnectionState.disconnected,
      );
    } else if (event is CallRemoteHangUp) {
      state = state.copyWith(
        isCallActive: false,
        connectionState: CallConnectionState.disconnected,
      );
    } else if (event is CallStatsUpdated) {
      state = state.copyWith(
        latencyMs: event.latencyMs,
        audioLevel: event.audioLevel,
      );
    } else if (event is VideoAdded) {
      state = state.copyWith(
        isRemoteVideoActive: true,
        isVideoEnabled: state.isVideoEnabled || true,
      );
    } else if (event is VideoRemoved) {
      state = state.copyWith(isRemoteVideoActive: false);
    }
  }

  void toggleMute() {
    if (_webrtc == null) return;
    final wasMuted = state.isMuted;
    _webrtc!.toggleMute();
    state = state.copyWith(isMuted: !wasMuted);
  }

  void toggleSpeaker() {
    if (_webrtc == null) return;
    _webrtc!.toggleSpeaker();
    state = state.copyWith(isSpeakerOn: !state.isSpeakerOn);
  }

  void toggleVideo() {
    if (_webrtc == null) return;
    _webrtc!.toggleVideo();
    state = state.copyWith(isVideoEnabled: !state.isVideoEnabled);
  }

  void hangUp() {
    if (_webrtc != null) {
      _webrtc!.hangUp();
    }
    _eventSub?.cancel();
    state = const CallState();
  }

  bool canCallPeer(String peerId) {
    return _signaling?.canCallPeer(peerId) ?? false;
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _incomingCallSub?.cancel();
    _webrtc?.dispose();
    _signaling?.dispose();
    super.dispose();
  }
}

final meshPeerListProvider = StateNotifierProvider<MeshPeerListNotifier, List<ConnectedPeer>>((ref) {
  final repo = ref.watch(meshRepositoryProvider);
  return MeshPeerListNotifier(repo);
});

class MeshPeerListNotifier extends StateNotifier<List<ConnectedPeer>> {
  final MeshRepository _repo;
  StreamSubscription<ConnectedPeer>? _sub;

  MeshPeerListNotifier(this._repo) : super(_repo.peerList) {
    _sub = _repo.peerEvents?.listen((_) {
      state = _repo.peerList;
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final connectedPeerCountProvider = Provider<int>((ref) {
  return ref.watch(meshPeerListProvider).length;
});

final contentPropagationProvider = Provider<ContentPropagationService>((ref) {
  final service = ContentPropagationService();
  ref.onDispose(() => service.dispose());
  return service;
});

final contentPropagationStatsProvider = Provider<ContentPropagationStats>((ref) {
  final propagation = ref.watch(contentPropagationProvider);
  final peerCount = ref.watch(connectedPeerCountProvider);
  return ContentPropagationStats(
    localPackageCount: propagation.localPackages.length,
    seenOnNetworkCount: propagation.seenOnNetwork.length,
    peerCount: peerCount,
  );
});

class ContentPropagationStats {
  final int localPackageCount;
  final int seenOnNetworkCount;
  final int peerCount;

  const ContentPropagationStats({
    required this.localPackageCount,
    required this.seenOnNetworkCount,
    required this.peerCount,
  });
}

// ── Contribution Points (Phase C) ─────────────────────────────────────────

final contributionPointsProvider = Provider<ContributionPoints>((ref) {
  final repo = ref.watch(meshRepositoryProvider);
  return repo.contributionPoints;
});

final contributionRankProvider = Provider<ContributionRank>((ref) {
  final points = ref.watch(contributionPointsProvider);
  if (points.total >= 2000) return ContributionRank.diamant;
  if (points.total >= 500) return ContributionRank.or;
  if (points.total >= 100) return ContributionRank.argent;
  return ContributionRank.bronze;
});

final contributionEventsProvider = Provider<List<ContributionEvent>>((ref) {
  return StorageService.getContributionEvents();
});

final localLeaderboardProvider = Provider<List<_LeaderboardEntry>>((ref) {
  final points = ref.watch(contributionPointsProvider);
  final user = ref.watch(authProvider).user;
  final pseudo = user?.pseudo ?? 'Moi';
  return [
    _LeaderboardEntry(pseudo: pseudo, points: points.total, rank: 1),
  ];
});

class _LeaderboardEntry {
  final String pseudo;
  final int points;
  final int rank;
  const _LeaderboardEntry({
    required this.pseudo,
    required this.points,
    required this.rank,
  });
}
