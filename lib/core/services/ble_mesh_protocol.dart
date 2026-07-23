import 'dart:convert';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';

/// UUID de service BLE dédié à OURO PREP.
/// Généré une fois, doit être identique sur tous les appareils de l'app.
const String kMeshServiceUuid = '3c0a1234-5678-4abc-9def-0123456789ab';

/// Characteristic "presence" : en notify/read, chaque pair annonce
/// {peerId, pseudo, hopCount} au format JSON.
const String kPresenceCharUuid = '3c0a1234-5678-4abc-9def-0123456789ac';

/// Characteristic "inbox" : en write (sans réponse), réception des messages
/// entrants. Les messages sont envoyés en chunks si nécessaire.
const String kInboxCharUuid = '3c0a1234-5678-4abc-9def-0123456789ad';

/// Taille max d'une écriture BLE sans négociation MTU.
/// En pratique, on peut écrire 20 bytes sans MTU, mais certains OS
/// supportent plus. On reste conservateur pour la compatibilité max.
const int kMaxBleWriteSize = 20;

/// Type pour le transfert de fichiers dans le forum.
const int kFileTransferType = 0x30;
const int kTextMessageType = 0x01;
const int kTypingIndicator = 0x02;
const int kTypingStop = 0x03;
const int kAckType = 0x04;

/// Types pour les quiz pair-à-pair.
const int kQuizChallenge = 0x05;
const int kQuizAccept = 0x06;
const int kQuizAnswerSheet = 0x07;
const int kQuizResult = 0x08;

/// Types de messages de contrôle pour le transfert de contenu viral.
/// Ces messages transitent par BLE (contrôle), les payloads par Wi-Fi.
const int kContentTypeAnnouncement = 0x20;
const int kContentTypeRequest = 0x21;
const int kContentTypeChunkOffer = 0x22;
const int kContentTypeChunkRequest = 0x23;
const int kContentTypeChunkData = 0x24;
const int kContentTypeResumeRequest = 0x25;
const int kContentTypeResumeOffer = 0x26;
const int kContentTypeManifest = 0x27;
const int kContentTypeDiffOffer = 0x28;
const int kContentTypeComplete = 0x29;

// Les constantes kContentChunkSize et kMaxConcurrentChunks
// sont définies dans content_transfer_protocol.dart

/// En-tête de chunk : 1 byte d'identifiant de chunk.
/// 0x00 = message complet tient dans ce chunk unique
/// 0x01 = premier chunk d'un message multi-chunk
/// 0x02 = chunk intermédiaire
/// 0x03 = dernier chunk
const int kChunkHeaderComplete = 0x00;
const int kChunkHeaderFirst = 0x01;
const int kChunkHeaderMiddle = 0x02;
const int kChunkHeaderLast = 0x03;

/// Message binaire format :
/// [messageId 16 bytes][hopCount 1 byte][type 1 byte][payloadLen 2 bytes][payload]
///
/// type :
///   0x00 = text/utf8
///   0x01 = json
///   0x02 = file metadata
///   0x03 = ping (keep-alive)
///   0x04 = pong
class BleMeshProtocol {
  /// Taille maximale du payload dans un chunk unique (hors chunk header).
  /// Chunk header = 1 byte, message header = 20 bytes (16+1+1+2)
  /// Reste : 20 - 1 = 19 bytes par chunk pour les data brutes
  /// Message header = 20 bytes → un chunk peut contenir header + payload si
  /// payload ≤ (20 - 1 - 20) = -1 → impossible.
  /// Donc on envoie TOUJOURS le header dans le premier chunk, payload dans
  /// les chunks suivants. Un message d'au plus 19 bytes tient dans un chunk
  /// unique (header uniquement, pas de payload, c'est un message de contrôle).
  /// Pour simplifier, on traite tout message comme multi-chunk potentiel.

  /// Taille de payload par chunk (hors header de chunk).
  static const int _payloadPerChunk = kMaxBleWriteSize - 1;

  /// Encode un message en chunks BLE.
  /// Retourne une liste de Uint8List, chaque élément fait au plus
  /// kMaxBleWriteSize bytes.
  static List<Uint8List> encodeMessage({
    required String messageId,
    required int hopCount,
    required int type,
    required Uint8List payload,
  }) {
    final msgIdBytes = _hexToBytes(messageId.replaceAll('-', ''));
    final hopByte = Uint8List.fromList([hopCount.clamp(0, 255)]);
    final typeByte = Uint8List.fromList([type.clamp(0, 255)]);
    final payloadLen = Uint8List.fromList([
      (payload.length >> 8) & 0xFF,
      payload.length & 0xFF,
    ]);

    final header = Uint8List.fromList([
      ...msgIdBytes,
      ...hopByte,
      ...typeByte,
      ...payloadLen,
    ]);

    final totalPayload = Uint8List.fromList([...header, ...payload]);
    final chunks = <Uint8List>[];

    if (totalPayload.length <= _payloadPerChunk) {
      chunks.add(Uint8List.fromList([kChunkHeaderComplete, ...totalPayload]));
    } else {
      int offset = 0;
      chunks.add(Uint8List.fromList([
        kChunkHeaderFirst,
        ...totalPayload.sublist(offset, (offset + _payloadPerChunk).clamp(0, totalPayload.length)),
      ]));
      offset += _payloadPerChunk;

      while (offset < totalPayload.length) {
        final remaining = totalPayload.length - offset;
        final isLast = remaining <= _payloadPerChunk;
        final chunkSize = isLast ? remaining : _payloadPerChunk;
        chunks.add(Uint8List.fromList([
          isLast ? kChunkHeaderLast : kChunkHeaderMiddle,
          ...totalPayload.sublist(offset, offset + chunkSize),
        ]));
        offset += chunkSize;
      }
    }

    return chunks;
  }

  /// Décode et reassemble un message depuis un flux de chunks.
  /// Retourne null si le reassemblage n'est pas complet.
  static BleDecodedMessage? decodeChunk(Uint8List chunk, Map<String, ChunkAssembly> assemblies) {
    if (chunk.isEmpty) return null;

    final header = chunk[0];
    final data = chunk.sublist(1);

    switch (header) {
      case kChunkHeaderComplete:
        return _parseMessageData(data);

      case kChunkHeaderFirst:
        final msgId = _extractMsgId(data);
        if (msgId == null) return null;
        assemblies[msgId] = ChunkAssembly(buffer: Uint8List.fromList(data));
        return null;

      case kChunkHeaderMiddle:
        if (data.length < 16) return null;
        final msgId = _extractMsgId(data);
        if (msgId == null || !assemblies.containsKey(msgId)) return null;
        assemblies[msgId]!.buffer = Uint8List.fromList([...assemblies[msgId]!.buffer, ...data]);
        return null;

      case kChunkHeaderLast:
        if (data.length < 16) return null;
        final msgId = _extractMsgId(data);
        if (msgId == null || !assemblies.containsKey(msgId)) return null;
        assemblies[msgId]!.buffer = Uint8List.fromList([...assemblies[msgId]!.buffer, ...data]);
        final full = assemblies.remove(msgId)!.buffer;
        return _parseMessageData(full);

      default:
        return null;
    }
  }

  static BleDecodedMessage? _parseMessageData(Uint8List data) {
    if (data.length < 20) return null;
    final msgId = _bytesToHex(data.sublist(0, 16));
    final hopCount = data[16];
    final type = data[17];
    final payloadLen = (data[18] << 8) | data[19];
    final payload = data.length > 20 ? data.sublist(20, (20 + payloadLen).clamp(20, data.length)) : Uint8List(0);

    return BleDecodedMessage(
      messageId: _formatUuid(msgId),
      hopCount: hopCount,
      type: type,
      payload: payload,
    );
  }

  static String? _extractMsgId(Uint8List data) {
    if (data.length < 16) return null;
    return _bytesToHex(data.sublist(0, 16));
  }

  static String _bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  static Uint8List _hexToBytes(String hex) {
    final result = Uint8List(hex.length ~/ 2);
    for (int i = 0; i < result.length; i++) {
      result[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return result;
  }

  static String _formatUuid(String hex) {
    if (hex.length < 32) return hex;
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }

  static String generateMessageId() => const Uuid().v4();

  static Uint8List encodePayload(String content) => Uint8List.fromList(utf8.encode(content));

  static String decodePayload(Uint8List bytes) => utf8.decode(bytes);
}

class BleDecodedMessage {
  final String messageId;
  final int hopCount;
  final int type;
  final Uint8List payload;

  const BleDecodedMessage({
    required this.messageId,
    required this.hopCount,
    required this.type,
    required this.payload,
  });
}

/// État d'assemblage d'un message multi-chunk.
class ChunkAssembly {
  Uint8List buffer;
  ChunkAssembly({required this.buffer});
}

/// Événements de pair dérivés des découvertes BLE.
class MeshPeerEvent {
  final String peerId;
  final String pseudo;
  final int hopCount;
  final bool isConnected;
  final bool isGateway;
  final String platform;

  const MeshPeerEvent({
    required this.peerId,
    required this.pseudo,
    this.hopCount = 0,
    this.isConnected = true,
    this.isGateway = false,
    this.platform = 'unknown',
  });
}

/// Données reçues après réassemblage BLE.
class MeshIncomingData {
  final String messageId;
  final String peerId;
  final Uint8List data;

  const MeshIncomingData({
    required this.messageId,
    required this.peerId,
    required this.data,
  });
}
