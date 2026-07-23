import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:nsd/nsd.dart' as nsd;
import 'ble_mesh_protocol.dart';

/// Transport Wi-Fi local pour OURO PREP.
///
/// ## Découverte
/// - **mDNS** (via `nsd`) — enregistre un service `_ouroprep._tcp`
/// - **UDP broadcast** (fallback) — envoie des beacons toutes les 3s sur
///   `OURO_DISCOVERY_PORT` et écoute les beacons entrants
///
/// ## Communication
/// Sockets TCP bruts (`dart:io`) avec framing `[longueur 4 bytes][payload]`.
class LocalWifiTransport {
  static const int _discoveryPort = 42069;
  static const Duration _beaconInterval = Duration(seconds: 3);
  static const Duration _peerTimeout = Duration(seconds: 15);

  bool _isRunning = false;
  String _myId = '';
  String _myPseudo = '';
  int _listenPort = 0;
  int _beaconCount = 0;

  final _peerEventsCtrl = StreamController<MeshPeerEvent>.broadcast();
  final _incomingDataCtrl = StreamController<MeshIncomingData>.broadcast();

  Stream<MeshPeerEvent> get peerEvents => _peerEventsCtrl.stream;
  Stream<MeshIncomingData> get incomingData => _incomingDataCtrl.stream;

  ServerSocket? _serverSocket;
  RawDatagramSocket? _udpSocket;
  nsd.Discovery? _discovery;

  final Map<String, _TcpPeerInfo> _connectedPeers = {};
  final Map<String, DateTime> _lastBeaconSeen = {};
  Timer? _beaconTimer;
  Timer? _cleanupTimer;
  Timer? _discoveryTimer;

  Future<void> start(String myId, String myPseudo) async {
    if (_isRunning) return;
    _isRunning = true;
    _myId = myId;
    _myPseudo = myPseudo;

    await _startServer();
    await _resolveBroadcastAddress();
    await _startUdpDiscovery();
    await _startMdnsDiscovery();

    _cleanupTimer = Timer.periodic(const Duration(seconds: 5), (_) => _cleanupStalePeers());
    _beaconTimer = Timer.periodic(_beaconInterval, (_) => _sendBeacon());

    debugPrint('[LocalWifi] started on port $_listenPort id=$myId');
  }

  Future<void> stop() async {
    _isRunning = false;
    _beaconTimer?.cancel();
    _cleanupTimer?.cancel();
    _discoveryTimer?.cancel();

    if (_discovery != null) {
      await nsd.stopDiscovery(_discovery!);
    }

    _udpSocket?.close();
    _udpSocket = null;

    if (_serverSocket != null) {
      for (final peer in _connectedPeers.values) {
        try { peer.socket.close(); } catch (e) { debugPrint('[WiFi] $e'); }
      }
      _connectedPeers.clear();
      _lastBeaconSeen.clear();
      await _serverSocket!.close();
      _serverSocket = null;
    }
  }

  // ── TCP Server ──────────────────────────────────────────────────────

  Future<void> _startServer() async {
    for (int attempt = 0; attempt < 10; attempt++) {
      try {
        _serverSocket = await ServerSocket.bind(
          InternetAddress.anyIPv4,
          0,
          shared: true,
        );
        _listenPort = _serverSocket!.port;
        _serverSocket!.listen(_onIncomingConnection, onError: (e) {
          debugPrint('[LocalWifi] server error: $e');
        });
        break;
      } catch (e) {
        debugPrint('[LocalWifi] server bind attempt $attempt failed: $e');
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    if (_serverSocket == null) {
      throw Exception('Impossible d\'ouvrir un port d\'écoute TCP');
    }
  }

  void _onIncomingConnection(Socket socket) {
    final remoteAddr = '${socket.remoteAddress.address}:${socket.remotePort}';
    final info = _TcpPeerInfo(address: remoteAddr, socket: socket);
    _connectedPeers[remoteAddr] = info;
    _receiveLoop(socket, info);
  }

  // ── UDP Broadcast Discovery ─────────────────────────────────────────

  Future<void> _startUdpDiscovery() async {
    try {
      _udpSocket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        _discoveryPort,
        reuseAddress: true,
      );
      _udpSocket!.broadcastEnabled = true;
      _udpSocket!.listen(_onUdpEvent);
      debugPrint('[LocalWifi] UDP listener on port $_discoveryPort');
    } catch (e) {
      debugPrint('[LocalWifi] UDP bind failed: $e');
    }
  }

  InternetAddress? _subnetBroadcast;

  Future<void> _resolveBroadcastAddress() async {
    try {
      final interfaces = await NetworkInterface.list();
      for (final iface in interfaces) {
        final hasPrivateIp = iface.addresses.any((a) =>
            a.address.startsWith('192.168.') ||
            a.address.startsWith('10.') ||
            a.address.startsWith('172.'));
        if (!hasPrivateIp) { continue; }
        for (final addr in iface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            final parts = addr.address.split('.');
            final broadcast = '${parts[0]}.${parts[1]}.${parts[2]}.255';
            _subnetBroadcast = InternetAddress(broadcast);
            debugPrint('[LocalWifi] resolved broadcast: $broadcast');
            return;
          }
        }
      }
    } catch (e) { debugPrint('[WiFi] $e'); }
    _subnetBroadcast = InternetAddress('255.255.255.255');
  }

  void _sendBeacon() {
    if (!_isRunning || _udpSocket == null) return;
    try {
      final payload = utf8.encode(json.encode({
        'peerId': _myId,
        'pseudo': _myPseudo,
        'port': _listenPort,
      }));
      final targets = [
        InternetAddress('255.255.255.255'),
        ?_subnetBroadcast,
      ];
      for (final target in targets) {
        _udpSocket!.send(payload, target, _discoveryPort);
      }
      _beaconCount++;
      if (_beaconCount % 10 == 0) {
        debugPrint('[LocalWifi] beacon #$_beaconCount sent');
      }
    } catch (e) {
      debugPrint('[LocalWifi] beacon send error: $e');
    }
  }

  void _onUdpEvent(RawSocketEvent event) {
    if (!_isRunning || _udpSocket == null) return;
    if (event != RawSocketEvent.read) return;

    final datagram = _udpSocket!.receive();
    if (datagram == null) return;

    try {
      final msg = json.decode(utf8.decode(datagram.data)) as Map<String, dynamic>;
      final peerId = msg['peerId'] as String?;
      if (peerId == null || peerId == _myId) return;

      final pseudo = msg['pseudo'] as String? ?? peerId;
      final port = msg['port'] as int? ?? 0;

      _lastBeaconSeen[peerId] = DateTime.now();

      if (_connectedPeers.values.any((p) => p.peerId == peerId)) return;
      if (port == 0) return;

      _connectToPeer(peerId, pseudo, datagram.address, port);
    } catch (e) {
      debugPrint('[LocalWifi] UDP parse error: $e');
    }
  }

  void _cleanupStalePeers() {
    final now = DateTime.now();
    final stale = _lastBeaconSeen.entries
        .where((e) => now.difference(e.value) > _peerTimeout)
        .map((e) => e.key)
        .toList();

    for (final peerId in stale) {
      _lastBeaconSeen.remove(peerId);
      final existing = _connectedPeers.values.where(
        (p) => p.peerId == peerId,
      );
      if (existing.isEmpty) continue;
      final peer = existing.first;

      debugPrint('[LocalWifi] peer stale: $peerId');
      _peerEventsCtrl.add(MeshPeerEvent(
        peerId: peerId,
        pseudo: peer.pseudo ?? peerId,
        isConnected: false,
      ));
      _connectedPeers.removeWhere((k, v) => v.peerId == peerId);
      try { peer.socket.close(); } catch (e) { debugPrint('[WiFi] $e'); }
    }
  }

  // ── mDNS Discovery (secondary) ──────────────────────────────────────

  Future<void> _startMdnsDiscovery() async {
    try {
      final service = nsd.Service(
        name: _myId,
        type: '_ouroprep._tcp',
        port: _listenPort,
        txt: {
          'pseudo': Uint8List.fromList(utf8.encode(_myPseudo)),
        },
      );
      await nsd.register(service).timeout(const Duration(seconds: 4));
      debugPrint('[LocalWifi] mDNS registered');
    } catch (e) {
      debugPrint('[LocalWifi] mDNS register failed: $e');
    }

    try {
      _discovery = await nsd.startDiscovery(
        '_ouroprep._tcp',
        autoResolve: true,
      ).timeout(const Duration(seconds: 4));
      _discovery!.addServiceListener(_onServiceEvent);
      debugPrint('[LocalWifi] mDNS discovery started');
    } catch (e) {
      debugPrint('[LocalWifi] mDNS discovery failed: $e');
    }
  }

  void _onServiceEvent(nsd.Service service, nsd.ServiceStatus status) {
    if (!_isRunning) return;
    if (service.name == _myId) return;
    if (status == nsd.ServiceStatus.found) {
      _onServiceFound(service);
    } else {
      _onServiceLost(service);
    }
  }

  void _onServiceFound(nsd.Service service) {
    if (_connectedPeers.values.any((p) => p.peerId == service.name)) return;

    final peerId = service.name ?? '';
    final pseudoBytes = service.txt?['pseudo'];
    final pseudo = pseudoBytes != null ? utf8.decode(pseudoBytes) : peerId;

    final address = service.addresses?.isNotEmpty == true
        ? service.addresses!.first
        : InternetAddress.loopbackIPv4;

    _connectToPeer(peerId, pseudo, address, service.port ?? 0);
  }

  void _onServiceLost(nsd.Service service) {
    final peerId = service.name ?? '';
    final existing = _connectedPeers.values.where(
      (p) => p.peerId == peerId,
    );
    if (existing.isEmpty) return;
    final peer = existing.first;

    _peerEventsCtrl.add(MeshPeerEvent(
      peerId: peerId,
      pseudo: peer.pseudo ?? peerId,
      isConnected: false,
    ));
    _connectedPeers.removeWhere((k, v) => v.peerId == peerId);
    try { peer.socket.close(); } catch (e) { debugPrint('[WiFi] $e'); }
  }

  // ── TCP Connection ──────────────────────────────────────────────────

  Future<void> _connectToPeer(
    String peerId, String pseudo, InternetAddress address, int port,
  ) async {
    if (_connectedPeers.values.any((p) => p.peerId == peerId)) return;

    try {
      debugPrint('[LocalWifi] connecting to $peerId at $address:$port');
      final socket = await Socket.connect(
        address,
        port,
        timeout: const Duration(seconds: 5),
      );

      final remoteAddr = '${socket.remoteAddress.address}:${socket.remotePort}';
      final info = _TcpPeerInfo(
        address: remoteAddr,
        socket: socket,
        peerId: peerId,
        pseudo: pseudo,
      );
      _connectedPeers[remoteAddr] = info;

      final handshake = json.encode({'peerId': _myId, 'pseudo': _myPseudo});
      _sendRaw(socket, Uint8List.fromList(utf8.encode(handshake)));

      _peerEventsCtrl.add(MeshPeerEvent(
        peerId: peerId,
        pseudo: pseudo,
        hopCount: 0,
        isConnected: true,
      ));

      debugPrint('[LocalWifi] connected to $peerId');

      _receiveLoop(socket, info);
    } catch (e) {
      debugPrint('[LocalWifi] connect to $peerId failed: $e');
    }
  }

  // ── Receive Loop ────────────────────────────────────────────────────

  void _receiveLoop(Socket socket, _TcpPeerInfo info) {
    final buffer = <int>[];
    bool readingLength = true;
    int expectedLength = 0;

    socket.listen(
      (Uint8List data) {
        buffer.addAll(data);

        while (true) {
          if (readingLength) {
            if (buffer.length < 4) break;
            expectedLength = (buffer[0] << 24) |
                (buffer[1] << 16) |
                (buffer[2] << 8) |
                buffer[3];
            buffer.removeRange(0, 4);
            readingLength = false;
          }

          if (buffer.length < expectedLength) break;

          final payload = Uint8List.fromList(buffer.sublist(0, expectedLength));
          buffer.removeRange(0, expectedLength);
          readingLength = true;

          if (info.peerId == null) {
            try {
              final handshake = json.decode(utf8.decode(payload))
                  as Map<String, dynamic>;
              info.peerId = handshake['peerId'] as String?;
              info.pseudo = handshake['pseudo'] as String?;
              if (info.peerId != null) {
                _lastBeaconSeen[info.peerId!] = DateTime.now();
                _peerEventsCtrl.add(MeshPeerEvent(
                  peerId: info.peerId!,
                  pseudo: info.pseudo ?? info.peerId!,
                  hopCount: 0,
                  isConnected: true,
                ));
              }
              debugPrint('[LocalWifi] handshake from ${info.peerId}');
            } catch (e) { debugPrint('[WiFi] $e'); }
          } else {
            debugPrint('[LocalWifi] ← ${info.peerId} payload=${payload.length}o');
            _incomingDataCtrl.add(MeshIncomingData(
              messageId: BleMeshProtocol.generateMessageId(),
              peerId: info.peerId ?? 'unknown',
              data: payload,
            ));
          }
        }
      },
      onDone: () {
        _onPeerDisconnected(socket, info);
      },
      onError: (e) {
        debugPrint('[LocalWifi] socket error: $e');
        _onPeerDisconnected(socket, info);
      },
    );
  }

  void _onPeerDisconnected(Socket socket, _TcpPeerInfo info) {
    if (info.peerId != null) {
      _peerEventsCtrl.add(MeshPeerEvent(
        peerId: info.peerId!,
        pseudo: info.pseudo ?? info.peerId!,
        isConnected: false,
      ));
    }
    _connectedPeers.removeWhere((k, v) => v.socket == socket);
  }

  // ── Send ────────────────────────────────────────────────────────────

  Future<void> sendToPeer(String peerId, Uint8List data) async {
    final peer = _connectedPeers.values.where(
      (p) => p.peerId == peerId,
    );
    if (peer.isEmpty) return;
    _sendRaw(peer.first.socket, data);
  }

  void _sendRaw(Socket socket, Uint8List data) {
    try {
      final lengthBytes = Uint8List.fromList([
        (data.length >> 24) & 0xFF,
        (data.length >> 16) & 0xFF,
        (data.length >> 8) & 0xFF,
        data.length & 0xFF,
      ]);
      socket.add(Uint8List.fromList([...lengthBytes, ...data]));
    } catch (e) { debugPrint('[WiFi] $e'); }
  }

  void dispose() {
    _beaconTimer?.cancel();
    _cleanupTimer?.cancel();
    _discoveryTimer?.cancel();
    _peerEventsCtrl.close();
    _incomingDataCtrl.close();
  }
}

class _TcpPeerInfo {
  final String address;
  final Socket socket;
  String? peerId;
  String? pseudo;

  _TcpPeerInfo({
    required this.address,
    required this.socket,
    this.peerId,
    this.pseudo,
  });
}
