import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/content_package.dart';
import 'content_transfer_protocol.dart';
import 'mesh_transport_service.dart';
import 'ble_mesh_protocol.dart';

/// Gestionnaire de téléchargement en essaim (swarm download).
///
/// ## Principe
/// Si plusieurs pairs à portée détiennent des chunks différents d'un même
/// contenu, on les récupère en parallèle depuis plusieurs sources.
/// Cela maximise le débit agrégé et la résilience (un pair qui s'éloigne
/// ne bloque pas tout le transfert).
///
/// ## Limites
/// - `kMaxConcurrentChunks` = 6 chunks maximum en parallèle
/// - Chaque chunk = 64 KB (kContentChunkSize)
/// - Répartition round-robin entre les sources disponibles
class SwarmDownloadManager {
  final MeshTransportService _transport;

  /// Sources disponibles : peerId → ensemble des indexes de chunks qu'il a
  final Map<String, Set<int>> _sources = {};

  StreamSubscription<MeshIncomingData>? _sub;

  SwarmDownloadManager(this._transport);

  /// Démarre l'écoute des annonces de chunks.
  void start() {
    _sub?.cancel();
    _sub = _transport.incomingData.listen(_onIncomingData);
  }

  void stop() {
    _sub?.cancel();
    for (final ctrl in _activeDownloads.values) {
      ctrl.completer.complete(null);
    }
    _activeDownloads.clear();
  }

  /// Enregistre une source de chunks.
  void addSource(String peerId, List<int> chunkIndexes) {
    _sources.putIfAbsent(peerId, () => {});
    _sources[peerId]!.addAll(chunkIndexes);
  }

  void removeSource(String peerId) {
    _sources.remove(peerId);
  }

  // ---------------------------------------------------------------------------
  // Téléchargement actif
  // ---------------------------------------------------------------------------

  final Map<String, _SwarmControl> _activeDownloads = {};

  /// Télécharge un contenu depuis toutes les sources disponibles.
  Future<Uint8List?> download({
    required String packageId,
    required int totalSize,
    required int chunkCount,
    required List<ContentChunkInfo> chunkInfos,
  }) async {
    if (_activeDownloads.containsKey(packageId)) {
      debugPrint('[Swarm] Téléchargement déjà actif: $packageId');
      return null;
    }

    final state = TransferState(
      packageId: packageId,
      chunkCount: chunkCount,
      totalSize: totalSize,
    );

    final completer = Completer<Uint8List?>();
    _activeDownloads[packageId] = _SwarmControl(
      state: state,
      completer: completer,
      chunkInfos: chunkInfos,
    );

    _scheduleNextChunks(packageId);

    return completer.future;
  }

  /// Planifie les prochains chunks à demander (round-robin).
  void _scheduleNextChunks(String packageId) {
    final ctrl = _activeDownloads[packageId];
    if (ctrl == null) return;

    final missing = ctrl.state.missingIndexes;
    if (missing.isEmpty) {
      // Terminé
      final data = ctrl.state.assemble();
      ctrl.completer.complete(data);
      _activeDownloads.remove(packageId);
      return;
    }

    // Prendre les kMaxConcurrentChunks prochains chunks manquants
    final toRequest = missing.take(kMaxConcurrentChunks).toList();

    // Répartition round-robin entre les sources
    final sourceList = _sources.keys.toList();
    if (sourceList.isEmpty) {
      debugPrint('[Swarm] Aucune source disponible pour $packageId');
      return;
    }

    for (int i = 0; i < toRequest.length; i++) {
      final source = sourceList[i % sourceList.length];
      _requestChunk(source, packageId, toRequest[i], ctrl);
    }
  }

  Future<void> _requestChunk(
    String sourcePeerId,
    String packageId,
    int chunkIndex,
    _SwarmControl ctrl,
  ) async {
    try {
      // Format binaire : [type(1)][pkgIdLen(1)][pkgId][chunkIndex(4)]
      final idBytes = utf8.encode(packageId);
      final msg = Uint8List(1 + 1 + idBytes.length + 4);
      msg[0] = 0x23; // kContentTypeChunkRequest
      msg[1] = idBytes.length;
      msg.setRange(2, 2 + idBytes.length, idBytes);
      msg[2 + idBytes.length] = (chunkIndex >> 24) & 0xFF;
      msg[2 + idBytes.length + 1] = (chunkIndex >> 16) & 0xFF;
      msg[2 + idBytes.length + 2] = (chunkIndex >> 8) & 0xFF;
      msg[2 + idBytes.length + 3] = chunkIndex & 0xFF;
      await _transport.sendToPeer(sourcePeerId, msg);
    } catch (e) {
      debugPrint('[Swarm] Erreur requête chunk $chunkIndex depuis $sourcePeerId: $e');
      _scheduleNextChunks(packageId);
    }
  }

  // ---------------------------------------------------------------------------
  // Réception de chunks
  // ---------------------------------------------------------------------------

  void _onIncomingData(MeshIncomingData data) {
    if (data.data.isEmpty) return;
    final type = data.data[0];

    if (type == 0x24) {
      // kContentTypeChunkData — chunk reçu
      _handleChunkData(data);
    }
  }

  void _handleChunkData(MeshIncomingData data) {
    try {
      final bytes = data.data;
      if (bytes.length < 6) return;

      // Format binaire : [type(1)][pkgIdLen(1)][pkgId][chunkIndex(4)][chunkData]
      final pkgIdLen = bytes[1];
      final headerSize = 1 + 1 + pkgIdLen + 4;
      if (bytes.length < headerSize) return;

      final packageId = utf8.decode(bytes.sublist(2, 2 + pkgIdLen));
      final chunkIndex = (bytes[2 + pkgIdLen] << 24) |
          (bytes[2 + pkgIdLen + 1] << 16) |
          (bytes[2 + pkgIdLen + 2] << 8) |
          bytes[2 + pkgIdLen + 3];
      final chunkBytes = bytes.sublist(headerSize);

      final ctrl = _activeDownloads[packageId];
      if (ctrl == null) return;

      if (chunkIndex >= 0 && chunkIndex < ctrl.chunkInfos.length) {
        final info = ctrl.chunkInfos[chunkIndex];
        if (ContentTransferProtocol.verifyChunk(chunkBytes, info)) {
          ctrl.state.markReceived(chunkIndex, chunkBytes);
          _scheduleNextChunks(packageId);
        } else {
          debugPrint('[Swarm] Échec checksum chunk $chunkIndex de $packageId');
          _scheduleNextChunks(packageId);
        }
      }
    } catch (e) {
      debugPrint('[Swarm] Erreur réception chunk: $e');
    }
  }

  void dispose() {
    stop();
  }
}

/// Contrôle d'un téléchargement en essaim actif.
class _SwarmControl {
  final TransferState state;
  final Completer<Uint8List?> completer;
  final List<ContentChunkInfo> chunkInfos;

  _SwarmControl({
    required this.state,
    required this.completer,
    required this.chunkInfos,
  });
}
