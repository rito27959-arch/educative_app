/// Statut d'un message dans le mesh.
enum MessageStatus { sending, sent, pending, failed }

/// Enregistrement persistant d'un pair connu.
///
/// Stocké dans StorageService pour reconnecter rapidement après un
/// redémarrage de l'application.
class PeerRecord {
  final String peerId;
  final String pseudo;
  final String role;
  final List<String> transports;
  final String platform;
  final List<String> interestGroups;
  final double reliability;
  final DateTime lastSeen;
  final int totalMessagesExchanged;

  const PeerRecord({
    required this.peerId,
    required this.pseudo,
    this.role = 'leaf',
    this.transports = const [],
    this.platform = 'unknown',
    this.interestGroups = const [],
    this.reliability = 1.0,
    required this.lastSeen,
    this.totalMessagesExchanged = 0,
  });

  Map<String, dynamic> toJson() => {
    'peerId': peerId,
    'pseudo': pseudo,
    'role': role,
    'transports': transports,
    'platform': platform,
    'interestGroups': interestGroups,
    'reliability': reliability,
    'lastSeen': lastSeen.toIso8601String(),
    'totalMessagesExchanged': totalMessagesExchanged,
  };

  factory PeerRecord.fromJson(Map<String, dynamic> json) => PeerRecord(
    peerId: json['peerId'] as String,
    pseudo: json['pseudo'] as String,
    role: json['role'] as String? ?? 'leaf',
    transports: (json['transports'] as List?)?.cast<String>() ?? [],
    platform: json['platform'] as String? ?? 'unknown',
    interestGroups: (json['interestGroups'] as List?)?.cast<String>() ?? [],
    reliability: (json['reliability'] as num?)?.toDouble() ?? 1.0,
    lastSeen: DateTime.parse(json['lastSeen'] as String),
    totalMessagesExchanged: json['totalMessagesExchanged'] as int? ?? 0,
  );
}

class MeshMessage {
  final String id;
  final String authorPseudo;
  final String content;
  final String type;
  final List<String> reactions;
  final DateTime timestamp;
  final String? imageUrl;
  final String? audioUrl;
  final int hopCount;
  final String? fileId;
  final String? fileName;
  final int? fileSize;
  final String? fileMimeType;
  final String? replyToId;
  final MessageStatus status;
  final String? routeInfo;

  /// Nombre de pairs ayant confirmé la réception (ACK).
  final int deliveryCount;

  const MeshMessage({
    required this.id,
    required this.authorPseudo,
    required this.content,
    this.type = 'text',
    this.reactions = const [],
    required this.timestamp,
    this.imageUrl,
    this.audioUrl,
    this.hopCount = 0,
    this.fileId,
    this.fileName,
    this.fileSize,
    this.fileMimeType,
    this.replyToId,
    this.status = MessageStatus.sent,
    this.routeInfo,
    this.deliveryCount = 0,
  });

  MeshMessage copyWith({
    String? id,
    String? authorPseudo,
    String? content,
    String? type,
    List<String>? reactions,
    DateTime? timestamp,
    String? imageUrl,
    String? audioUrl,
    int? hopCount,
    String? fileId,
    String? fileName,
    int? fileSize,
    String? fileMimeType,
    String? replyToId,
    MessageStatus? status,
    String? routeInfo,
    int? deliveryCount,
  }) {
    return MeshMessage(
      id: id ?? this.id,
      authorPseudo: authorPseudo ?? this.authorPseudo,
      content: content ?? this.content,
      type: type ?? this.type,
      reactions: reactions ?? this.reactions,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      hopCount: hopCount ?? this.hopCount,
      fileId: fileId ?? this.fileId,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      fileMimeType: fileMimeType ?? this.fileMimeType,
      replyToId: replyToId ?? this.replyToId,
      status: status ?? this.status,
      routeInfo: routeInfo ?? this.routeInfo,
      deliveryCount: deliveryCount ?? this.deliveryCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'authorPseudo': authorPseudo,
    'content': content,
    'type': type,
    'reactions': reactions,
    'timestamp': timestamp.toIso8601String(),
    'imageUrl': imageUrl,
    'audioUrl': audioUrl,
    'hopCount': hopCount,
    'fileId': fileId,
    'fileName': fileName,
    'fileSize': fileSize,
    'fileMimeType': fileMimeType,
    'replyToId': replyToId,
    'status': status.name,
    'routeInfo': routeInfo,
    'deliveryCount': deliveryCount,
  };

  factory MeshMessage.fromJson(Map<String, dynamic> json) => MeshMessage(
    id: json['id'] as String,
    authorPseudo: json['authorPseudo'] as String,
    content: json['content'] as String,
    type: json['type'] as String? ?? 'text',
    reactions: (json['reactions'] as List?)?.cast<String>() ?? [],
    timestamp: DateTime.parse(json['timestamp'] as String),
    imageUrl: json['imageUrl'] as String?,
    audioUrl: json['audioUrl'] as String?,
    hopCount: json['hopCount'] as int? ?? 0,
    fileId: json['fileId'] as String?,
    fileName: json['fileName'] as String?,
    fileSize: json['fileSize'] as int?,
    fileMimeType: json['fileMimeType'] as String?,
    replyToId: json['replyToId'] as String?,
    status: MessageStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => MessageStatus.sent,
    ),
    routeInfo: json['routeInfo'] as String?,
    deliveryCount: json['deliveryCount'] as int? ?? 0,
  );
}

class MeshPeer {
  final String id;
  final String pseudo;
  final String? avatarUrl;
  final int hopCount;
  final double signalStrength;
  final bool isGateway;

  const MeshPeer({
    required this.id,
    required this.pseudo,
    this.avatarUrl,
    this.hopCount = 0,
    this.signalStrength = 1.0,
    this.isGateway = false,
  });
}

/// Direction de l'appel.
enum CallDirection { outgoing, incoming }

/// État de connexion WebRTC.
enum CallConnectionState { connecting, connected, failed, disconnected }

class CallState {
  final bool isMuted;
  final bool isSpeakerOn;
  final bool isCallActive;
  final int latencyMs;
  final int hopCount;
  final String? peerPseudo;
  final String? peerId;
  final CallDirection direction;
  final CallConnectionState connectionState;
  final double audioLevel;
  final bool isVideoEnabled;
  final bool isRemoteVideoActive;

  const CallState({
    this.isMuted = false,
    this.isSpeakerOn = false,
    this.isCallActive = false,
    this.latencyMs = 0,
    this.hopCount = 0,
    this.peerPseudo,
    this.peerId,
    this.direction = CallDirection.outgoing,
    this.connectionState = CallConnectionState.disconnected,
    this.audioLevel = 0.0,
    this.isVideoEnabled = false,
    this.isRemoteVideoActive = false,
  });

  CallState copyWith({
    bool? isMuted,
    bool? isSpeakerOn,
    bool? isCallActive,
    int? latencyMs,
    int? hopCount,
    String? peerPseudo,
    String? peerId,
    CallDirection? direction,
    CallConnectionState? connectionState,
    double? audioLevel,
    bool? isVideoEnabled,
    bool? isRemoteVideoActive,
  }) {
    return CallState(
      isMuted: isMuted ?? this.isMuted,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isCallActive: isCallActive ?? this.isCallActive,
      latencyMs: latencyMs ?? this.latencyMs,
      hopCount: hopCount ?? this.hopCount,
      peerPseudo: peerPseudo ?? this.peerPseudo,
      peerId: peerId ?? this.peerId,
      direction: direction ?? this.direction,
      connectionState: connectionState ?? this.connectionState,
      audioLevel: audioLevel ?? this.audioLevel,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isRemoteVideoActive: isRemoteVideoActive ?? this.isRemoteVideoActive,
    );
  }
}

/// Registre de points de contribution mesh.
///
/// ## Événements qui rapportent des points
/// | Événement | Points | Condition |
/// |-----------|--------|-----------|
/// | Relais de contenu | +10 | chunk relayé à un pair |
/// | Réponse forum validée | +25 | 3+ réactions "👍" d'autres pairs |
/// | Appel de tutorat terminé | +50 | appel > 2 min |
/// | Disponibilité relais | +2/min | temps passé en mode gateway |
///
/// ## Anti‑triche (validation croisée)
/// Les points ne sont définitivement accordés qu'après confirmation
/// par au moins un pair : le receveur du relais ou l'autre participant
/// à l'appel doit envoyer un accusé de réception signé. Sans accusé,
/// le point reste en attente (« pending »).
class ContributionPoints {
  final int total;
  final int relaysCount;
  final int forumHelpfulCount;
  final int tutoringCallCount;
  final int relayMinutes;
  final int pendingPoints; // en attente de validation croisée

  const ContributionPoints({
    this.total = 0,
    this.relaysCount = 0,
    this.forumHelpfulCount = 0,
    this.tutoringCallCount = 0,
    this.relayMinutes = 0,
    this.pendingPoints = 0,
  });
}

/// Niveau débloqué selon le total de points.
///
/// - Bronze (0–99)   : accès de base au tuteur IA (5 questions/jour)
/// - Argent (100–499) : 20 questions/jour, badges
/// - Or (500–1999)    : tuteur IA illimité, priorités de téléchargement
/// - Diamant (2000+)  : partenaire opérateur (données offertes)
enum ContributionRank { bronze, argent, or, diamant }

class MeshStats {
  final double distributedGb;
  final int relayedFiles;
  final int helpedPeers;
  final int totalPeers;
  final int blePeers;
  final int wifiPeers;
  final int nativePeers;

  /// Points de contribution (Phase C).
  final ContributionPoints contribution;

  /// Fiabilité moyenne des transports (0.0 – 1.0).
  final double averageReliability;

  /// Nombre de messages envoyés depuis le démarrage.
  final int messagesSent;

  /// Nombre d'ACK reçus (total).
  final int acksReceived;

  const MeshStats({
    this.distributedGb = 4.2,
    this.relayedFiles = 12,
    this.helpedPeers = 8,
    this.totalPeers = 42,
    this.blePeers = 0,
    this.wifiPeers = 0,
    this.nativePeers = 0,
    this.contribution = const ContributionPoints(),
    this.averageReliability = 1.0,
    this.messagesSent = 0,
    this.acksReceived = 0,
  });
}
