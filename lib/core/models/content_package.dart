import 'package:crypto/crypto.dart';

/// Statut de possession d'un paquet de contenu.
enum PackageStatus { missing, downloading, complete, seeding }

/// Paquet de contenu versionné pour la propagation virale.
///
/// Un paquet encapsule un modèle existant (CourseModel, ChapterModel)
/// ou une mise à jour différentielle, avec métadonnées de distribution.
class ContentPackage {
  final String id;
  final int version;
  final String checksum;
  final int size;
  final List<String> dependencies;
  final String type;      // 'course' | 'chapter'
  final String modelId;   // identifiant du CourseModel/ChapterModel
  final int createdAt;
  final String? seederId;
  final String? prevVersion; // pour diff : id de la version précédente

  const ContentPackage({
    required this.id,
    required this.version,
    required this.checksum,
    required this.size,
    this.dependencies = const [],
    required this.type,
    required this.modelId,
    required this.createdAt,
    this.seederId,
    this.prevVersion,
  });

  ContentPackage copyWith({
    String? id,
    int? version,
    String? checksum,
    int? size,
    List<String>? dependencies,
    String? type,
    String? modelId,
    int? createdAt,
    String? seederId,
    String? prevVersion,
  }) => ContentPackage(
    id: id ?? this.id,
    version: version ?? this.version,
    checksum: checksum ?? this.checksum,
    size: size ?? this.size,
    dependencies: dependencies ?? this.dependencies,
    type: type ?? this.type,
    modelId: modelId ?? this.modelId,
    createdAt: createdAt ?? this.createdAt,
    seederId: seederId ?? this.seederId,
    prevVersion: prevVersion ?? this.prevVersion,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'version': version,
    'checksum': checksum,
    'size': size,
    'dependencies': dependencies,
    'type': type,
    'modelId': modelId,
    'createdAt': createdAt,
    'seederId': seederId,
    'prevVersion': prevVersion,
  };

  factory ContentPackage.fromJson(Map<String, dynamic> json) => ContentPackage(
    id: json['id'] as String,
    version: json['version'] as int? ?? 1,
    checksum: json['checksum'] as String? ?? '',
    size: json['size'] as int? ?? 0,
    dependencies: (json['dependencies'] as List<dynamic>?)?.cast<String>() ?? [],
    type: json['type'] as String? ?? 'chapter',
    modelId: json['modelId'] as String,
    createdAt: json['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
    seederId: json['seederId'] as String?,
    prevVersion: json['prevVersion'] as String?,
  );

  static String computeChecksum(List<int> bytes) =>
      sha256.convert(bytes).toString();
}

/// Manifeste de contenu : liste des paquets disponibles sur un appareil.
class ContentManifest {
  final String deviceId;
  final String pseudo;
  final List<ContentPackage> packages;
  final int createdAt;

  const ContentManifest({
    required this.deviceId,
    required this.pseudo,
    required this.packages,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'pseudo': pseudo,
    'packages': packages.map((p) => p.toJson()).toList(),
    'createdAt': createdAt,
  };

  factory ContentManifest.fromJson(Map<String, dynamic> json) => ContentManifest(
    deviceId: json['deviceId'] as String,
    pseudo: json['pseudo'] as String? ?? '',
    packages: (json['packages'] as List<dynamic>)
        .map((e) => ContentPackage.fromJson(e as Map<String, dynamic>))
        .toList(),
    createdAt: json['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
  );
}

/// Métadonnée de chunk pour transfert avec reprise.
class ContentChunkInfo {
  final int index;
  final int offset;
  final int size;
  final String checksum;

  const ContentChunkInfo({
    required this.index,
    required this.offset,
    required this.size,
    required this.checksum,
  });

  Map<String, dynamic> toJson() => {
    'index': index,
    'offset': offset,
    'size': size,
    'checksum': checksum,
  };

  factory ContentChunkInfo.fromJson(Map<String, dynamic> json) => ContentChunkInfo(
    index: json['index'] as int,
    offset: json['offset'] as int,
    size: json['size'] as int,
    checksum: json['checksum'] as String? ?? '',
  );
}

/// Paquet avec payload binaire (contenu réel).
class ContentPackagePayload {
  final ContentPackage metadata;
  final List<int> bytes;

  const ContentPackagePayload({
    required this.metadata,
    required this.bytes,
  });

  bool get isValid => ContentPackage.computeChecksum(bytes) == metadata.checksum;
}

/// Version courte annoncée dans les messages mesh (BLE).
class ContentAnnouncement {
  final String packageId;
  final String type;
  final String modelId;
  final int version;
  final int size;
  final int chunkCount;
  final String? seederId;

  const ContentAnnouncement({
    required this.packageId,
    required this.type,
    required this.modelId,
    required this.version,
    required this.size,
    this.chunkCount = 0,
    this.seederId,
  });

  Map<String, dynamic> toJson() => {
    'packageId': packageId,
    'type': type,
    'modelId': modelId,
    'version': version,
    'size': size,
    'chunkCount': chunkCount,
    'seederId': seederId,
  };

  factory ContentAnnouncement.fromJson(Map<String, dynamic> json) => ContentAnnouncement(
    packageId: json['packageId'] as String,
    type: json['type'] as String? ?? 'chapter',
    modelId: json['modelId'] as String,
    version: json['version'] as int? ?? 1,
    size: json['size'] as int? ?? 0,
    chunkCount: json['chunkCount'] as int? ?? 0,
    seederId: json['seederId'] as String?,
  );
}

/// Requête de chunks manquants (reprise sur interruption).
class ChunkResumeRequest {
  final String packageId;
  final List<int> missingIndexes;

  const ChunkResumeRequest({
    required this.packageId,
    required this.missingIndexes,
  });

  Map<String, dynamic> toJson() => {
    'packageId': packageId,
    'missingIndexes': missingIndexes,
  };

  factory ChunkResumeRequest.fromJson(Map<String, dynamic> json) => ChunkResumeRequest(
    packageId: json['packageId'] as String,
    missingIndexes: (json['missingIndexes'] as List<dynamic>).cast<int>(),
  );
}
