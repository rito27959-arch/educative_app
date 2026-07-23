import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/content_package.dart';
import 'storage_service.dart';
import 'mesh_transport_service.dart';
import 'content_transfer_protocol.dart';
import 'ble_mesh_protocol.dart';

/// Service de propagation virale de contenu (gossip protocol).
///
/// ## Algorithme
/// 1. Un appareil qui détient un contenu complet émet une annonce
///    `ContentAnnouncement` via BLE (message de contrôle court).
/// 2. Les pairs qui ne possèdent pas encore ce contenu répondent
///    par une requête `ContentMessageType.request`.
/// 3. Le pair source transfère le contenu par chunks via Wi-Fi
///    (TCP / Nearby Connections), avec suivi des chunks reçus pour
///    permettre la reprise sur interruption.
/// 4. Une fois complet, le destinataire devient à son tour annonceur
///    (gossip — tout appareil peut redistribuer).
///
/// ## Priorisation
/// Les semeurs (premiers détenteurs) sont prioritaires comme sources.
/// Les pairs sans le contenu sont prioritaires pour la réception.
class ContentPropagationService {
  MeshTransportService? _transport;
  String _myId = '';
  bool _isRunning = false;
  StreamSubscription<MeshIncomingData>? _incomingSub;
  StreamSubscription<ConnectedPeer>? _peerSub;

  /// Paquets complets détenus localement.
  final Map<String, ContentPackage> _localPackages = {};

  /// Paquets en cours de téléchargement.
  final Map<String, TransferState> _activeDownloads = {};

  /// Index inverse : par modelId, quel paquet local le contient.
  final Map<String, String> _modelToPackage = {};

  /// Dernière annonce reçue par pair (anti-spam).
  final Map<String, Set<String>> _seenAnnouncements = {};

  /// Callback appelé quand un paquet est complètement reçu.
  final List<void Function(ContentPackage, List<int>)> _onPackageComplete = [];

  /// État de propagation (pour UI).
  final Set<String> _seenOnNetwork = {};

  StreamController<ContentPropagationEvent> _events = StreamController<ContentPropagationEvent>.broadcast();

  Stream<ContentPropagationEvent> get events => _events.stream;
  List<ContentPackage> get localPackages => _localPackages.values.toList();
  Set<String> get seenOnNetwork => _seenOnNetwork;

  void onPackageComplete(void Function(ContentPackage, List<int>) cb) {
    _onPackageComplete.add(cb);
  }

  // ---------------------------------------------------------------------------
  // Cycle de vie
  // ---------------------------------------------------------------------------

  void init({
    required MeshTransportService transport,
    required String myId,
    required String myPseudo,
  }) {
    _transport = transport;
    _myId = myId;
    _isRunning = true;

    _incomingSub = transport.incomingData.listen(_onIncomingData);
    _peerSub = transport.peerEvents.listen(_onPeerEvent);

    // Charger les paquets locaux depuis StorageService (Drift)
    _loadLocalPackages();

    debugPrint('[ContentProp] init() prêt, ${_localPackages.length} paquets locaux');
  }

  void dispose() {
    _isRunning = false;
    _incomingSub?.cancel();
    _peerSub?.cancel();
    _events.close();
  }

  // ---------------------------------------------------------------------------
  // Gestion des paquets locaux
  // ---------------------------------------------------------------------------

  void _loadLocalPackages() {
    final raw = StorageService.getString('content_packages');
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      for (final e in list) {
        final pkg = ContentPackage.fromJson(e as Map<String, dynamic>);
        _localPackages[pkg.id] = pkg;
        _modelToPackage[pkg.modelId] = pkg.id;
      }
    } catch (e) {
      debugPrint('[ContentProp] Erreur chargement paquets: $e');
    }
  }

  void _persistPackages() {
    final list = _localPackages.values.map((p) => p.toJson()).toList();
    StorageService.setString('content_packages', jsonEncode(list));
  }

  /// Enregistre un paquet comme complété localement.
  void markComplete(ContentPackage pkg) {
    _localPackages[pkg.id] = pkg;
    _modelToPackage[pkg.modelId] = pkg.id;
    _persistPackages();
    _broadcastAnnouncement(pkg);
    _events.add(ContentPropagationEvent('local_complete', pkgId: pkg.id));
  }

  /// Vérifie si un contenu est détenu localement.
  bool hasContent(String modelId) => _modelToPackage.containsKey(modelId);

  ContentPackage? getPackage(String modelId) {
    final id = _modelToPackage[modelId];
    if (id == null) return null;
    return _localPackages[id];
  }

  // ---------------------------------------------------------------------------
  // Annonce (broadcast via BLE / contrôle)
  // ---------------------------------------------------------------------------

  void broadcastManifest() {
    if (_transport == null) return;
    final data = ContentTransferProtocol.encodeAnnouncement(
      ContentAnnouncement(
        packageId: 'manifest',
        type: 'manifest',
        modelId: _myId,
        version: 0,
        size: 0,
      ),
    );
    _transport!.broadcastToConnectedPeers(data);
  }

  void _broadcastAnnouncement(ContentPackage pkg) {
    if (_transport == null) return;
    final ann = ContentAnnouncement(
      packageId: pkg.id,
      type: pkg.type,
      modelId: pkg.modelId,
      version: pkg.version,
      size: pkg.size,
      chunkCount: (pkg.size / kContentChunkSize).ceil(),
      seederId: pkg.seederId,
    );
    final data = ContentTransferProtocol.encodeAnnouncement(ann);
    _transport!.broadcastToConnectedPeers(data);
  }

  // ---------------------------------------------------------------------------
  // Réception de messages entrants
  // ---------------------------------------------------------------------------

  void _onIncomingData(MeshIncomingData data) {
    if (!_isRunning || data.data.isEmpty) return;

    final msgType = data.data[0];
    final payload = data.data.sublist(1);

    switch (msgType) {
      case ContentMessageType.announcement:
        _handleAnnouncement(payload, data.peerId);
      case ContentMessageType.request:
        _handleRequest(payload, data.peerId);
      case ContentMessageType.chunkRequest:
        _handleChunkRequest(payload, data.peerId);
      case ContentMessageType.resumeRequest:
        _handleResumeRequest(payload, data.peerId);
      case ContentMessageType.complete:
        _handleComplete(payload);
    }
  }

  void _onPeerEvent(ConnectedPeer peer) {
    // À la connexion d'un nouveau pair, on lui envoie notre manifeste
    if (peer.transports.isNotEmpty && _localPackages.isNotEmpty) {
      broadcastManifest();
    }
  }

  // ---------------------------------------------------------------------------
  // Handler : annonce reçue
  // ---------------------------------------------------------------------------

  void _handleAnnouncement(Uint8List payload, String peerId) {
    try {
      final json = jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
      final ann = ContentAnnouncement.fromJson(json);

      // Anti-spam
      _seenAnnouncements.putIfAbsent(peerId, () => {});
      if (_seenAnnouncements[peerId]!.contains(ann.packageId)) return;
      _seenAnnouncements[peerId]!.add(ann.packageId);

      _seenOnNetwork.add(ann.modelId);
      _events.add(ContentPropagationEvent('announcement', pkgId: ann.packageId));

      // Si on a déjà ce contenu, pas besoin de le demander
      if (hasContent(ann.modelId)) return;

      // Demander le contenu
      _requestContent(ann, peerId);
    } catch (e) {
      debugPrint('[ContentProp] Erreur annonce: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Demande de contenu
  // ---------------------------------------------------------------------------

  void _requestContent(ContentAnnouncement ann, String peerId) {
    if (_transport == null) return;

    // Vérifier si déjà en cours de téléchargement
    if (_activeDownloads.containsKey(ann.packageId)) {
      // Envoyer une demande de reprise
      final state = _activeDownloads[ann.packageId]!;
      final req = ChunkResumeRequest(
        packageId: ann.packageId,
        missingIndexes: state.missingIndexes,
      );
      final data = ContentTransferProtocol.encodeResumeRequest(req);
      _transport!.sendToPeer(peerId, data);
      return;
    }

    // Nouveau téléchargement
    final chunkCount = ann.chunkCount > 0 ? ann.chunkCount : (ann.size / kContentChunkSize).ceil();
    _activeDownloads[ann.packageId] = TransferState(
      packageId: ann.packageId,
      chunkCount: chunkCount,
      totalSize: ann.size,
    );

    // Envoyer la requête
    final req = ChunkResumeRequest(
      packageId: ann.packageId,
      missingIndexes: List.generate(chunkCount, (i) => i),
    );
    final data = ContentTransferProtocol.encodeResumeRequest(req);
    _transport!.sendToPeer(peerId, data);

    _events.add(ContentPropagationEvent('download_start', pkgId: ann.packageId));
    debugPrint('[ContentProp] Demande $ann.packageId à $peerId');
  }

  // ---------------------------------------------------------------------------
  // Handler : requête reçue → envoi des chunks
  // ---------------------------------------------------------------------------

  void _handleRequest(Uint8List payload, String peerId) {
    // Une requête simple (sans liste de chunks) — on envoie la liste
    try {
      final json = jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
      final req = ChunkResumeRequest.fromJson(json);
      _offerChunks(req, peerId);
    } catch (e) {
      debugPrint('[ContentProp] Erreur requête: $e');
    }
  }

  void _handleChunkRequest(Uint8List payload, String peerId) {
    // Demande spécifique de chunks
    try {
      final json = jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
      final req = ChunkResumeRequest.fromJson(json);
      _sendChunks(req, peerId);
    } catch (e) {
      debugPrint('[ContentProp] Erreur chunkRequest: $e');
    }
  }

  void _handleResumeRequest(Uint8List payload, String peerId) {
    try {
      final json = jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
      final req = ChunkResumeRequest.fromJson(json);
      _offerChunks(req, peerId);
    } catch (e) {
      debugPrint('[ContentProp] Erreur resumeRequest: $e');
    }
  }

  void _offerChunks(ChunkResumeRequest req, String peerId) {
    // Vérifier qu'on a bien ce paquet
    final pkg = _localPackages[req.packageId];
    if (pkg == null) return;

    // Envoyer les chunks demandés (limité à kMaxConcurrentChunks)
    final toSend = req.missingIndexes.take(kMaxConcurrentChunks).toList();
    for (final idx in toSend) {
      _sendSingleChunk(req.packageId, idx, peerId);
    }
  }

  void _sendChunks(ChunkResumeRequest req, String peerId) {
    _offerChunks(req, peerId); // même logique
  }

  void _sendSingleChunk(String packageId, int chunkIndex, String peerId) {
    if (_transport == null) return;

    // Construire le chunk payload
    final data = Uint8List.fromList([
      ContentMessageType.chunkData,
      ...utf8.encode(jsonEncode({
        'packageId': packageId,
        'index': chunkIndex,
      })),
    ]);
    // Le chunk réel doit transiter par Wi-Fi, on envoie une notification
    // pour que le pair sache qu'il peut le récupérer via TCP
    _transport!.sendToPeer(peerId, data);
  }

  // ---------------------------------------------------------------------------
  // Handler : chunk reçu
  // ---------------------------------------------------------------------------

  void _handleComplete(Uint8List payload) {
    // Un pair annonce qu'il a terminé la réception
    try {
      final json = jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
      final pkg = ContentPackage.fromJson(json);
      _seenOnNetwork.add(pkg.modelId);

      // Si le paquet est dans nos téléchargements, le marquer complet
      _activeDownloads.remove(pkg.id);

      _events.add(ContentPropagationEvent('network_complete', pkgId: pkg.id));
      debugPrint('[ContentProp] Paquet ${pkg.id} complet sur le réseau');
    } catch (e) {
      debugPrint('[ContentProp] Erreur complete: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Statistiques de propagation
  // ---------------------------------------------------------------------------

  /// Ratio de propagation : combien de pairs visibles ont ce contenu.
  double propagationRatio(String modelId, int totalPeers) {
    if (totalPeers <= 0) return hasContent(modelId) ? 1.0 : 0.0;
    int count = 0;
    if (hasContent(modelId)) count++;
    if (_seenOnNetwork.contains(modelId)) count++;
    return count / totalPeers;
  }

  /// Nombre de pairs qui ont annoncé ce contenu.
  int peersWithContent(String modelId) {
    int count = 0;
    if (hasContent(modelId)) count++;
    if (_seenOnNetwork.contains(modelId)) count++;
    return count;
  }
}

/// Événement de propagation (pour UI / Riverpod).
class ContentPropagationEvent {
  final String type; // announcement | local_complete | download_start | network_complete
  final String? pkgId;
  final String? modelId;

  const ContentPropagationEvent(this.type, {this.pkgId, this.modelId});
}
