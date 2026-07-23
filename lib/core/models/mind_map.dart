import 'dart:ui';

class MindMapNode {
  final String id;
  String label;
  double x, y;
  final String? parentId;
  final Color color;
  final List<String> childrenIds;
  bool isExpanded;

  MindMapNode({
    required this.id,
    required this.label,
    this.x = 0,
    this.y = 0,
    this.parentId,
    this.color = const Color(0xFF2563FF),
    this.childrenIds = const [],
    this.isExpanded = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'x': x,
    'y': y,
    'parentId': parentId,
    'color': color.value,
    'childrenIds': childrenIds,
    'isExpanded': isExpanded,
  };

  factory MindMapNode.fromJson(Map<String, dynamic> json) => MindMapNode(
    id: json['id'] as String,
    label: json['label'] as String,
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
    parentId: json['parentId'] as String?,
    color: Color(json['color'] as int),
    childrenIds: List<String>.from(json['childrenIds'] as List),
    isExpanded: json['isExpanded'] as bool? ?? true,
  );

  MindMapNode copyWith({
    String? label,
    double? x,
    double? y,
    bool? isExpanded,
  }) {
    return MindMapNode(
      id: id,
      label: label ?? this.label,
      x: x ?? this.x,
      y: y ?? this.y,
      parentId: parentId,
      color: color,
      childrenIds: childrenIds,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  static const List<Color> palette = [
    Color(0xFF2563FF),
    Color(0xFFFF6B2B),
    Color(0xFF00E676),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF06D6A0),
    Color(0xFFFFB400),
    Color(0xFFFF3B30),
  ];
}

class MindMapEdge {
  final String fromId;
  final String toId;
  final String? label;

  const MindMapEdge({
    required this.fromId,
    required this.toId,
    this.label,
  });

  Map<String, dynamic> toJson() => {
    'fromId': fromId,
    'toId': toId,
    'label': label,
  };

  factory MindMapEdge.fromJson(Map<String, dynamic> json) => MindMapEdge(
    fromId: json['fromId'] as String,
    toId: json['toId'] as String,
    label: json['label'] as String?,
  );
}

class MindMap {
  final String id;
  String title;
  final List<MindMapNode> nodes;
  final List<MindMapEdge> edges;
  final DateTime createdAt;
  DateTime updatedAt;
  final String ownerId;
  final List<String> collaboratorIds;

  MindMap({
    required this.id,
    this.title = 'Carte mentale',
    this.nodes = const [],
    this.edges = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.ownerId,
    this.collaboratorIds = const [],
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'nodes': nodes.map((n) => n.toJson()).toList(),
    'edges': edges.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'ownerId': ownerId,
    'collaboratorIds': collaboratorIds,
  };

  factory MindMap.fromJson(Map<String, dynamic> json) => MindMap(
    id: json['id'] as String,
    title: json['title'] as String? ?? 'Carte mentale',
    nodes: (json['nodes'] as List?)?.map((n) => MindMapNode.fromJson(n as Map<String, dynamic>)).toList() ?? [],
    edges: (json['edges'] as List?)?.map((e) => MindMapEdge.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    ownerId: json['ownerId'] as String,
    collaboratorIds: List<String>.from(json['collaboratorIds'] as List? ?? []),
  );
}
