import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'mesh_transport_service.dart';
import 'ble_mesh_protocol.dart';

/// Types de message de signalisation d'appel (ajoutés au protocole BLE mesh).
const int kCallOffer = 0x10;
const int kCallAnswer = 0x11;
const int kCallIceCandidate = 0x12;
const int kCallHangUp = 0x13;

/// Exception lancée quand un appel n'est pas possible.
class CallTransportException implements Exception {
  final String message;
  CallTransportException(this.message);
  @override
  String toString() => 'CallTransportException: $message';
}

/// Message de signalisation décodé.
class SignalingMessage {
  final int type;
  final String peerId;
  final Map<String, dynamic> data;

  const SignalingMessage({
    required this.type,
    required this.peerId,
    required this.data,
  });
}

/// Service de signalisation d'appel via le transport mesh.
///
/// Envoie et reçoit des messages CALL_OFFER, CALL_ANSWER, CALL_ICE_CANDIDATE
/// et CALL_HANGUP en réutilisant le `MeshTransportService`.
///
/// Les appels ne sont autorisés que si le pair cible est joignable
/// via TransportKind.localWifi (le BLE seul n'a pas le débit suffisant
/// pour l'audio temps réel).
class CallSignalingService {
  final MeshTransportService _transport;
  final _incomingCtrl = StreamController<SignalingMessage>.broadcast();
  StreamSubscription? _subscription;

  Stream<SignalingMessage> get incomingMessages => _incomingCtrl.stream;

  CallSignalingService(this._transport);

  /// Écouter les messages de signalisation entrants.
  void startListening() {
    _subscription?.cancel();
    _subscription = _transport.incomingData.listen(_onIncomingData);
  }

  void stopListening() {
    _subscription?.cancel();
  }

  void _onIncomingData(MeshIncomingData data) {
    if (data.data.length < 2) return;
    // Format: [hopCount][type 0x10-0x13][json]
    final type = data.data[1];
    debugPrint('[Signaling] reçu type=0x${type.toRadixString(16)} peer=${data.peerId} len=${data.data.length}');
    if (type < kCallOffer || type > kCallHangUp) return;

    if (data.data.length < 3) return;
    try {
      final payload = utf8.decode(data.data.sublist(2));
      final json = jsonDecode(payload) as Map<String, dynamic>;
      debugPrint('[Signaling] routé vers incomingMessages');
      _incomingCtrl.add(SignalingMessage(
        type: type,
        peerId: data.peerId,
        data: json,
      ));
    } catch (e) { debugPrint('[Signaling] erreur décodage: $e'); }
  }

  /// Vérifier qu'un pair est joignable par Wi‑Fi direct (0 saut).
  void _requireDirectWifi(String peerId) {
    if (!canCallPeer(peerId)) {
      final peer = _transport.connectedPeers
          .where((p) => p.peerId == peerId);
      final platformInfo = peer.isNotEmpty
          ? ' (${peer.first.platform})'
          : '';
      throw CallTransportException(
        'Appel possible uniquement sur Wi‑Fi local ou Direct '
        '(0 saut). Le pair $peerId$platformInfo n\'est pas '
        'joignable.',
      );
    }
  }

  /// Vérifier si un pair est accessible par Wi‑Fi (local ou Direct).
  bool canCallPeer(String peerId) {
    final peers = _transport.connectedPeers.where((p) => p.peerId == peerId);
    if (peers.isEmpty) return false;
    final peer = peers.first;
    if (peer.hopCount != 0) return false;
    return peer.transports.contains(TransportKind.localWifi) ||
        peer.transports.contains(TransportKind.nativeP2P);
  }

  Uint8List _buildMessage(int type, Map<String, dynamic> data) {
    // Format : [hopCount=0][type][json] — hopCount=0 car appels jamais relayés
    final payload = utf8.encode(jsonEncode(data));
    return Uint8List.fromList([0, type, ...payload]);
  }

  /// Envoyer une offre d'appel (SDP offer).
  Future<void> sendOffer(String peerId, String sdp) async {
    _requireDirectWifi(peerId);
    await _transport.sendToPeer(
      peerId,
      _buildMessage(kCallOffer, {'sdp': sdp}),
    );
  }

  /// Répondre à une offre (SDP answer).
  Future<void> sendAnswer(String peerId, String sdp) async {
    _requireDirectWifi(peerId);
    await _transport.sendToPeer(
      peerId,
      _buildMessage(kCallAnswer, {'sdp': sdp}),
    );
  }

  /// Envoyer un candidat ICE.
  Future<void> sendIceCandidate(
    String peerId,
    String candidate,
    String sdpMid,
    int sdpMLineIndex,
  ) async {
    _requireDirectWifi(peerId);
    await _transport.sendToPeer(
      peerId,
      _buildMessage(kCallIceCandidate, {
        'candidate': candidate,
        'sdpMid': sdpMid,
        'sdpMLineIndex': sdpMLineIndex,
      }),
    );
  }

  /// Envoyer une demande de raccrochage.
  Future<void> sendHangUp(String peerId) async {
    try {
      await _transport.sendToPeer(
        peerId,
        _buildMessage(kCallHangUp, {}),
      );
    } catch (e) { debugPrint('[Signaling] $e'); }
  }

  void dispose() {
    stopListening();
    _incomingCtrl.close();
  }
}
