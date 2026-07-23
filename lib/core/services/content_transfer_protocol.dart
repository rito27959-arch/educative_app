import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../models/content_package.dart';

/// Types de messages de contrôle pour le transfert de contenu.
/// Ces messages transitent par BLE (petite taille, contrôle).
/// Les payloads réels transitent par Wi-Fi (TCP / Nearby Connections).
class ContentMessageType {
  static const int announcement = 0x20;
  static const int request = 0x21;
  static const int chunkOffer = 0x22;
  static const int chunkRequest = 0x23;
  static const int chunkData = 0x24;
  static const int resumeRequest = 0x25;
  static const int resumeOffer = 0x26;
  static const int manifest = 0x27;
  static const int diffOffer = 0x28;
  static const int complete = 0x29;
}

/// Taille de chunk recommandée pour le transfert Wi-Fi.
/// Les chunks BLE font 20 bytes max ; les chunks Wi-Fi peuvent être
/// beaucoup plus gros. On choisit 64 KB pour un bon équilibre entre
/// overhead de signalisation et reprise granulaire.
const int kContentChunkSize = 64 * 1024; // 64 KB

/// Nombre max de chunks demandés en parallèle (swarm).
const int kMaxConcurrentChunks = 6;

/// Protocole de transfert de contenu à gros volume.
///
/// Assure :
/// - chunking en blocs de 64 KB
/// - reprise sur interruption (suivi des chunks reçus)
/// - vérification par checksum SHA256 par chunk + global
class ContentTransferProtocol {
  /// Découpe un payload en chunks avec leurs métadonnées.
  static ContentTransferManifest chunkContent({
    required String packageId,
    required List<int> bytes,
  }) {
    final chunks = <Uint8List>[];
    final infos = <ContentChunkInfo>[];
    int offset = 0;
    int index = 0;

    while (offset < bytes.length) {
      final end = (offset + kContentChunkSize).clamp(0, bytes.length);
      final chunk = Uint8List.fromList(bytes.sublist(offset, end));
      final checksum = sha256.convert(chunk).toString();
      chunks.add(chunk);
      infos.add(ContentChunkInfo(
        index: index,
        offset: offset,
        size: chunk.length,
        checksum: checksum,
      ));
      offset = end;
      index++;
    }

    return ContentTransferManifest(
      packageId: packageId,
      totalSize: bytes.length,
      chunkCount: infos.length,
      chunkInfos: infos,
      chunks: chunks,
    );
  }

  /// Réassemble les chunks dans l'ordre.
  static Uint8List reassemble(List<Uint8List> chunks, int totalSize) {
    final result = Uint8List(totalSize);
    int offset = 0;
    for (final chunk in chunks) {
      result.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return result;
  }

  /// Vérifie l'intégrité d'un chunk.
  static bool verifyChunk(Uint8List chunk, ContentChunkInfo info) {
    return sha256.convert(chunk).toString() == info.checksum;
  }

  /// Construit un message de contrôle pour annonce (passe par BLE).
  static Uint8List encodeAnnouncement(ContentAnnouncement ann) {
    final json = utf8.encode(jsonEncode(ann.toJson()));
    return Uint8List.fromList([ContentMessageType.announcement, ...json]);
  }

  /// Construit une requête de chunks manquants (reprise).
  static Uint8List encodeResumeRequest(ChunkResumeRequest req) {
    final json = utf8.encode(jsonEncode(req.toJson()));
    return Uint8List.fromList([ContentMessageType.resumeRequest, ...json]);
  }
}

/// Résultat du chunking.
class ContentTransferManifest {
  final String packageId;
  final int totalSize;
  final int chunkCount;
  final List<ContentChunkInfo> chunkInfos;
  final List<Uint8List> chunks;

  const ContentTransferManifest({
    required this.packageId,
    required this.totalSize,
    required this.chunkCount,
    required this.chunkInfos,
    required this.chunks,
  });
}

/// État d'un transfert en cours (suivi des chunks reçus).
class TransferState {
  final String packageId;
  final int chunkCount;
  final Set<int> receivedChunks;
  final Map<int, Uint8List> chunkData;
  final int totalSize;

  TransferState({
    required this.packageId,
    required this.chunkCount,
    required this.totalSize,
    Set<int>? receivedChunks,
    Map<int, Uint8List>? chunkData,
  }) : receivedChunks = receivedChunks ?? {},
       chunkData = chunkData ?? {};

  bool get isComplete => receivedChunks.length == chunkCount;
  double get progress => chunkCount > 0 ? receivedChunks.length / chunkCount : 0;

  void markReceived(int index, Uint8List data) {
    receivedChunks.add(index);
    chunkData[index] = data;
  }

  List<int> get missingIndexes {
    final all = List.generate(chunkCount, (i) => i);
    return all.where((i) => !receivedChunks.contains(i)).toList();
  }

  Uint8List assemble() {
    final sorted = receivedChunks.toList()..sort();
    final chunks = sorted.map((i) => chunkData[i]!).toList();
    return ContentTransferProtocol.reassemble(chunks, totalSize);
  }
}
