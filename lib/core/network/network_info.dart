import 'dart:async';
import 'dart:io';
import '../errors/app_exceptions.dart';

class NetworkInfo {
  static final NetworkInfo _instance = NetworkInfo._();
  factory NetworkInfo() => _instance;
  NetworkInfo._();

  bool _isConnected = true;
  final _connectivityController = StreamController<bool>.broadcast();

  Stream<bool> get onConnectivityChanged => _connectivityController.stream;
  bool get isConnected => _isConnected;

  Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      _isConnected = false;
    } on TimeoutException catch (_) {
      _isConnected = false;
    }
    _connectivityController.add(_isConnected);
    return _isConnected;
  }

  Future<T> handleNetworkCall<T>(Future<T> Function() call) async {
    final connected = await checkConnectivity();
    if (!connected) {
      throw NetworkException(
        'Pas de connexion Internet. Utilisation du mode Mesh local.',
        code: 'NO_INTERNET',
      );
    }
    try {
      return await call();
    } on SocketException catch (e) {
      throw NetworkException(
        'Erreur de connexion au serveur',
        code: 'CONNECTION_ERROR',
        stackTrace: StackTrace.fromString(e.toString()),
      );
    } on HttpException catch (e) {
      throw NetworkException(
        'Erreur HTTP: ${e.message}',
        code: 'HTTP_ERROR',
        stackTrace: StackTrace.fromString(e.toString()),
      );
    }
  }

  void dispose() {
    _connectivityController.close();
  }
}

class MeshNetworkManager {
  static final MeshNetworkManager _instance = MeshNetworkManager._();
  factory MeshNetworkManager() => _instance;
  MeshNetworkManager._();

  final List<_MeshNode> _knownNodes = [];
  int _messageHopCount = 0;

  int get connectedPeers => _knownNodes.length;
  int get hopCount => _messageHopCount;

  void registerNode(String id, String pseudo) {
    _knownNodes.removeWhere((n) => n.id == id);
    _knownNodes.add(_MeshNode(id: id, pseudo: pseudo, signalStrength: 1.0));
  }

  void removeNode(String id) {
    _knownNodes.removeWhere((n) => n.id == id);
  }

  Future<bool> broadcastMessage(Map<String, dynamic> payload) async {
    _messageHopCount++;
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

  double get averageSignalStrength {
    if (_knownNodes.isEmpty) return 0;
    return _knownNodes.fold(0.0, (sum, n) => sum + n.signalStrength) /
        _knownNodes.length;
  }

  Map<String, dynamic> get topologyData {
    return {
      'nodes': _knownNodes.length,
      'hops': _messageHopCount,
      'signalAvg': averageSignalStrength,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

class _MeshNode {
  final String id;
  final String pseudo;
  final double signalStrength;

  _MeshNode({
    required this.id,
    required this.pseudo,
    required this.signalStrength,
  });
}

class CryptoService {
  static final CryptoService _instance = CryptoService._();
  factory CryptoService() => _instance;
  CryptoService._();

  final Map<String, String> _keyStore = {};

  String generateKeyPair(String identity) {
    final key = '${identity}_key_${DateTime.now().millisecondsSinceEpoch}';
    _keyStore[identity] = key;
    return key;
  }

  String signMessage(String message, String privateKey) {
    final bytes = message.codeUnits;
    return bytes.map((b) => (b ^ privateKey.codeUnitAt(b % privateKey.length)).toRadixString(16)).join('');
  }

  bool verifySignature(String message, String signature, String publicKey) {
    try {
      final expected = signMessage(message, publicKey);
      return expected == signature;
    } catch (_) {
      return false;
    }
  }

  String hashContent(String content) {
    final bytes = content.codeUnits;
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  bool hasKey(String identity) => _keyStore.containsKey(identity);
}
