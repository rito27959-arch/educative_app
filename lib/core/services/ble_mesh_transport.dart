import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:universal_ble/universal_ble.dart';
import 'ble_mesh_protocol.dart';

/// Transport BLE peer-to-peer pour OURO PREP.
///
/// Utilise `universal_ble` en mode central (GATT client) pour scanner et
/// se connecter aux pairs. `universal_ble` ne supporte PAS le mode périphérique
/// (advertising BLE), donc un appareil ne peut pas être découvert tant qu'il
/// n'a pas été scanné par un pair. Pour le mode périphérique, il faudrait
/// `flutter_blue_plus` ou une autre bibliothèque supportant BLE Peripheral.
/// Les pairs déjà connectés reçoivent des mises à jour périodiques de présence
/// via la caractéristique GATT kPresenceCharUuid (_advertisePresence).
class BleMeshTransport {
  /// Taille maximale d'un payload BLE (512 octets).
  /// Au-delà, le message est refusé : BLE ne porte que de la découverte,
  /// de la présence, et de petits messages de contrôle (poignée de main
  /// WebRTC, annonces mesh). Les fichiers et flux audio passent par le
  /// Wi‑Fi (localWifi ou nativeP2P).
  static const int _maxPayloadSize = 512;

  bool _isRunning = false;
  String _myId = '';
  String _myPseudo = '';

  final _peerEventsCtrl = StreamController<MeshPeerEvent>.broadcast();
  final _incomingDataCtrl = StreamController<MeshIncomingData>.broadcast();

  Stream<MeshPeerEvent> get peerEvents => _peerEventsCtrl.stream;
  Stream<MeshIncomingData> get incomingData => _incomingDataCtrl.stream;

  final Map<String, _BlePeerInfo> _connectedPeers = {};
  final List<_BlePeerInfo> _pendingPeers = [];
  static const int _maxConnections = 6;

  final Map<String, ChunkAssembly> _assemblies = {};
  Timer? _presenceTimer;

  Future<void> start(String myId, String myPseudo) async {
    if (_isRunning) return;
    _isRunning = true;
    _myId = myId;
    _myPseudo = myPseudo;

    try {
      await UniversalBle.enableBluetooth();
    } catch (e) { debugPrint('[BLE] $e'); }

    UniversalBle.onScanResult = _onDeviceDiscovered;
    UniversalBle.onValueChange = _onValueChange;

    await UniversalBle.startScan(
      scanFilter: ScanFilter(withServices: [kMeshServiceUuid]),
    );

    unawaited(_startPeripheralAdvertising());
    unawaited(_advertisePresence());
  }

  Future<void> stop() async {
    _isRunning = false;
    _presenceTimer?.cancel();
    UniversalBle.onScanResult = null;
    UniversalBle.onValueChange = null;
    await UniversalBle.stopScan();
    for (final peer in _connectedPeers.values) {
      try {
        await UniversalBle.disconnect(peer.deviceId);
      } catch (e) { debugPrint('[BLE] $e'); }
    }
    _connectedPeers.clear();
    _pendingPeers.clear();
    _assemblies.clear();
  }

  Future<void> _startPeripheralAdvertising() async {
    // `universal_ble` ne supporte pas le mode périphérique BLE.
    // Pour rendre l'appareil découvrable, remplacer par une bibliothèque
    // supportant BLE Peripheral (ex: flutter_blue_plus) et appeler :
    //   await FlutterBluePlus.instance.startAdvertising(
    //     name: _myPseudo,
    //     serviceUuid: kMeshServiceUuid,
    //   );
    debugPrint('[BLE] Advertising non disponible avec universal_ble');
  }

  Future<void> _advertisePresence() async {
    while (_isRunning) {
      for (final peer in _connectedPeers.values) {
        try {
          final presenceJson = json.encode({
            'peerId': _myId,
            'pseudo': _myPseudo,
            'hopCount': 0,
            'platform': Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'unknown'),
          });
          final chunks = BleMeshProtocol.encodeMessage(
            messageId: BleMeshProtocol.generateMessageId(),
            hopCount: 0,
            type: 0x01,
            payload: BleMeshProtocol.encodePayload(presenceJson),
          );
          for (final chunk in chunks) {
            await UniversalBle.writeValue(
              peer.deviceId,
              kMeshServiceUuid,
              kPresenceCharUuid,
              chunk,
              BleOutputProperty.withResponse,
            );
          }
        } catch (e) { debugPrint('[BLE] $e'); }
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void _onDeviceDiscovered(BleDevice result) {
    if (!_isRunning) return;
    if (!result.services.any((s) => s.toLowerCase() == kMeshServiceUuid.toLowerCase())) return;

    final deviceId = result.deviceId;
    if (_connectedPeers.containsKey(deviceId)) return;
    if (_pendingPeers.any((p) => p.deviceId == deviceId)) return;

    final info = _BlePeerInfo(deviceId: deviceId, name: result.name ?? 'Inconnu');

    if (_connectedPeers.length >= _maxConnections) {
      _pendingPeers.add(info);
      return;
    }

    _connectToDevice(info);
  }

  void _onValueChange(String deviceId, String characteristicId, Uint8List value) {
    if (characteristicId.toLowerCase() == kPresenceCharUuid.toLowerCase()) {
      _onPresenceData(deviceId, value);
    } else if (characteristicId.toLowerCase() == kInboxCharUuid.toLowerCase()) {
      _onInboxData(deviceId, value);
    }
  }

  Future<void> _connectToDevice(_BlePeerInfo info) async {
    try {
      await UniversalBle.connect(info.deviceId);

      final services = await UniversalBle.discoverServices(info.deviceId);
      final hasOurService = services.any(
        (s) => s.uuid.toLowerCase() == kMeshServiceUuid.toLowerCase(),
      );
      if (!hasOurService) {
        await UniversalBle.disconnect(info.deviceId);
        return;
      }

      await UniversalBle.setNotifiable(
        info.deviceId,
        kMeshServiceUuid,
        kPresenceCharUuid,
        BleInputProperty.notification,
      );

      try {
        final initial = await UniversalBle.readValue(
          info.deviceId,
          kMeshServiceUuid,
          kPresenceCharUuid,
        );
        _onPresenceData(info.deviceId, initial);
      } catch (e) { debugPrint('[BLE] $e'); }

      await UniversalBle.setNotifiable(
        info.deviceId,
        kMeshServiceUuid,
        kInboxCharUuid,
        BleInputProperty.notification,
      );

      _connectedPeers[info.deviceId] = info;
      _pendingPeers.removeWhere((p) => p.deviceId == info.deviceId);
    } catch (e) { debugPrint('[BLE] $e');
      _pendingPeers.removeWhere((p) => p.deviceId == info.deviceId);
    }
  }

  void _onPresenceData(String deviceId, Uint8List data) {
    final decoded = BleMeshProtocol.decodeChunk(data, _assemblies);
    if (decoded == null) return;

    try {
      final presenceJson = json.decode(BleMeshProtocol.decodePayload(decoded.payload)) as Map<String, dynamic>;
      final peerId = presenceJson['peerId'] as String;
      final pseudo = presenceJson['pseudo'] as String? ?? 'Inconnu';
      final hopCount = presenceJson['hopCount'] as int? ?? 0;
      final isGateway = presenceJson['isGateway'] as bool? ?? false;
      final platform = presenceJson['platform'] as String? ?? 'unknown';

      if (_connectedPeers.containsKey(deviceId)) {
        _connectedPeers[deviceId]!.peerId = peerId;
      }

      _peerEventsCtrl.add(MeshPeerEvent(
        peerId: peerId,
        pseudo: pseudo,
        hopCount: hopCount,
        isConnected: true,
        isGateway: isGateway,
        platform: platform,
      ));
    } catch (e) { debugPrint('[BLE] $e'); }
  }

  void _onInboxData(String deviceId, Uint8List data) {
    if (!_connectedPeers.containsKey(deviceId)) return;
    final info = _connectedPeers[deviceId]!;

    final decoded = BleMeshProtocol.decodeChunk(data, _assemblies);
    if (decoded == null) return;

    _incomingDataCtrl.add(MeshIncomingData(
      messageId: decoded.messageId,
      peerId: info.peerId ?? 'unknown',
      data: decoded.payload,
    ));
  }

  Future<void> sendToPeer(String peerId, Uint8List data, {int type = 0x00}) async {
    // ── Séparation stricte des rôles (A2.1) ──────────────────────────
    // BLE ne porte jamais de fichier ni de flux audio.
    // Seuls les messages de contrôle (type < 0x20) et les petits
    // payloads (≤ 512 o) sont autorisés.
    if (type >= 0x20) {
      debugPrint('[BLE] Refusé : type contenu 0x${type.toRadixString(2)} '
          'sur BLE — nécessite Wi‑Fi');
      return;
    }
    if (data.length > _maxPayloadSize) {
      debugPrint('[BLE] Refusé : payload ${data.length}o dépasse la '
          'limite BLE de $_maxPayloadSize o');
      return;
    }

    final msgId = BleMeshProtocol.generateMessageId();
    final chunks = BleMeshProtocol.encodeMessage(
      messageId: msgId,
      hopCount: 0,
      type: type,
      payload: data,
    );

    final entry = _connectedPeers.entries.firstWhere(
      (e) => e.value.peerId == peerId,
      orElse: () => MapEntry('', _BlePeerInfo(deviceId: '', name: '')),
    );
    if (entry.key.isEmpty) return;

    for (final chunk in chunks) {
      try {
        await UniversalBle.writeValue(
          entry.key,
          kMeshServiceUuid,
          kInboxCharUuid,
          chunk,
          BleOutputProperty.withoutResponse,
        );
      } catch (e) { debugPrint('[BLE] $e');
        break;
      }
    }
  }

  void dispose() {
    _presenceTimer?.cancel();
    _peerEventsCtrl.close();
    _incomingDataCtrl.close();
  }
}

class _BlePeerInfo {
  final String deviceId;
  final String name;
  String? peerId;

  _BlePeerInfo({required this.deviceId, required this.name});
}
