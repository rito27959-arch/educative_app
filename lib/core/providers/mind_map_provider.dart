import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/mind_map.dart';
import 'dart:typed_data';
import '../services/mesh_transport_service.dart';
import '../services/storage_service.dart';
import 'mesh_provider.dart';

final mindMapListProvider = StateNotifierProvider<MindMapListNotifier, List<MindMap>>((ref) {
  final repo = ref.watch(meshRepositoryProvider);
  return MindMapListNotifier(repo.transport);
});

final activeMindMapProvider = StateNotifierProvider.family<MindMapEditorNotifier, MindMap?, String>((ref, mindMapId) {
  final repo = ref.watch(meshRepositoryProvider);
  return MindMapEditorNotifier(mindMapId, repo.transport);
});

class MindMapListNotifier extends StateNotifier<List<MindMap>> {
  final MeshTransportService _mesh;
  StreamSubscription? _sub;

  MindMapListNotifier(this._mesh) : super([]) {
    _loadMaps();
    _listenForSync();
  }

  Future<void> _loadMaps() async {
    final stored = StorageService.getString('mind_maps');
    if (stored != null) {
      final list = (jsonDecode(stored) as List)
          .map((e) => MindMap.fromJson(e as Map<String, dynamic>))
          .toList();
      state = list;
    }
  }

  Future<void> _save() async {
    await StorageService.setString('mind_maps', jsonEncode(state.map((m) => m.toJson()).toList()));
  }

  void _listenForSync() {
    _sub = _mesh.incomingData.listen((data) {
      try {
        final payload = utf8.decode(data.data);
        final json = jsonDecode(payload) as Map<String, dynamic>;
        if (json['type'] == 'mindmap_sync') {
          final remote = MindMap.fromJson(json['mindmap'] as Map<String, dynamic>);
          final idx = state.indexWhere((m) => m.id == remote.id);
          if (idx >= 0 && remote.updatedAt.isAfter(state[idx].updatedAt)) {
            final updated = [...state];
            updated[idx] = remote;
            state = updated;
            _save();
          }
        }
      } catch (_) {}
    });
  }

  Future<String> createMap(String title, String ownerId) async {
    final id = const Uuid().v4();
    final map = MindMap(
      id: id,
      title: title,
      ownerId: ownerId,
    );
    state = [...state, map];
    await _save();
    _broadcastToPeers(map);
    return id;
  }

  void deleteMap(String id) {
    state = state.where((m) => m.id != id).toList();
    _save();
  }

  void _broadcastToPeers(MindMap map) {
    final msg = jsonEncode({'type': 'mindmap_sync', 'mindmap': map.toJson()});
    for (final peer in _mesh.connectedPeers) {
      _mesh.sendToPeer(peer.peerId, Uint8List.fromList(utf8.encode(msg)));
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

class MindMapEditorNotifier extends StateNotifier<MindMap?> {
  final String _mindMapId;
  final MeshTransportService _mesh;
  final _uuid = const Uuid();
  StreamSubscription? _sub;
  MindMapEditorNotifier(this._mindMapId, this._mesh) : super(null) {
    _load();
    _listenForUpdates();
  }

  void _load() {
    final stored = StorageService.getString('mind_maps');
    if (stored != null) {
      final list = (jsonDecode(stored) as List)
          .map((e) => MindMap.fromJson(e as Map<String, dynamic>));
      state = list.firstWhere((m) => m.id == _mindMapId);
    }
  }

  void _listenForUpdates() {
    _sub = _mesh.incomingData.listen((data) {
      try {
        final payload = utf8.decode(data.data);
        final json = jsonDecode(payload) as Map<String, dynamic>;
        if (json['type'] == 'mindmap_sync' && json['mindmap']['id'] == _mindMapId) {
          final remote = MindMap.fromJson(json['mindmap'] as Map<String, dynamic>);
          if (state != null && remote.updatedAt.isAfter(state!.updatedAt)) {
            state = remote;
            _persist();
          }
        }
      } catch (_) {}
    });
  }

  void addNode(String parentId) {
    if (state == null) return;
    final map = state!;
    final nodeId = _uuid.v4();
    final level = _nodeDepth(map, parentId);
    final color = MindMapNode.palette[level % MindMapNode.palette.length];

    final childCount = map.nodes.where((n) => n.parentId == parentId).length;
    final offsetX = 180.0;
    final offsetY = (childCount - 1) * 100.0;

    final parent = map.nodes.firstWhere((n) => n.id == parentId);
    final node = MindMapNode(
      id: nodeId,
      label: 'Idée ${map.nodes.length + 1}',
      x: parent.x + offsetX,
      y: parent.y + offsetY,
      parentId: parentId,
      color: color,
    );

    final updatedNodes = [
      ...map.nodes.map((n) => n.id == parentId
          ? MindMapNode(id: n.id, label: n.label, x: n.x, y: n.y, parentId: n.parentId, color: n.color,
              childrenIds: [...n.childrenIds, nodeId], isExpanded: n.isExpanded)
          : n),
      node,
    ];
    final updatedEdges = [...map.edges, MindMapEdge(fromId: parentId, toId: nodeId)];

    final updated = MindMap(
      id: map.id, title: map.title,
      nodes: updatedNodes, edges: updatedEdges,
      createdAt: map.createdAt, updatedAt: DateTime.now(),
      ownerId: map.ownerId, collaboratorIds: map.collaboratorIds,
    );

    state = updated;
    _persistAndSync();
  }

  void updateNodePosition(String nodeId, double x, double y) {
    if (state == null) return;
    final map = state!;
    final idx = map.nodes.indexWhere((n) => n.id == nodeId);
    if (idx < 0) return;

    final updatedNodes = [...map.nodes];
    updatedNodes[idx] = updatedNodes[idx].copyWith(x: x, y: y);
    final updated = MindMap(
      id: map.id, title: map.title,
      nodes: updatedNodes, edges: map.edges,
      createdAt: map.createdAt, updatedAt: DateTime.now(),
      ownerId: map.ownerId, collaboratorIds: map.collaboratorIds,
    );

    state = updated;
    _persistAndSync();
  }

  void updateNodeLabel(String nodeId, String label) {
    if (state == null) return;
    final map = state!;
    final idx = map.nodes.indexWhere((n) => n.id == nodeId);
    if (idx < 0) return;

    final updatedNodes = [...map.nodes];
    updatedNodes[idx] = updatedNodes[idx].copyWith(label: label);
    final updated = MindMap(
      id: map.id, title: map.title,
      nodes: updatedNodes, edges: map.edges,
      createdAt: map.createdAt, updatedAt: DateTime.now(),
      ownerId: map.ownerId, collaboratorIds: map.collaboratorIds,
    );

    state = updated;
    _persistAndSync();
  }

  void deleteNode(String nodeId) {
    if (state == null) return;
    final map = state!;
    final toRemove = _collectDescendants(map, nodeId);
    toRemove.add(nodeId);

    final updatedNodes = map.nodes
        .where((n) => !toRemove.contains(n.id))
        .map((n) => n.parentId == nodeId
            ? MindMapNode(id: n.id, label: n.label, x: n.x, y: n.y, parentId: n.parentId, color: n.color,
                childrenIds: n.childrenIds.where((c) => !toRemove.contains(c)).toList(), isExpanded: n.isExpanded)
            : n)
        .toList();
    final updatedEdges = map.edges
        .where((e) => !toRemove.contains(e.fromId) && !toRemove.contains(e.toId))
        .toList();

    final updated = MindMap(
      id: map.id, title: map.title,
      nodes: updatedNodes, edges: updatedEdges,
      createdAt: map.createdAt, updatedAt: DateTime.now(),
      ownerId: map.ownerId, collaboratorIds: map.collaboratorIds,
    );

    state = updated;
    _persistAndSync();
  }

  void updateTitle(String title) {
    if (state == null) return;
    final map = state!;
    final updated = MindMap(
      id: map.id, title: title,
      nodes: map.nodes, edges: map.edges,
      createdAt: map.createdAt, updatedAt: DateTime.now(),
      ownerId: map.ownerId, collaboratorIds: map.collaboratorIds,
    );
    state = updated;
    _persistAndSync();
  }

  int _nodeDepth(MindMap map, String nodeId, [int depth = 0]) {
    final node = map.nodes.firstWhereOrNull((n) => n.id == nodeId);
    if (node == null || node.parentId == null) return depth;
    return _nodeDepth(map, node.parentId!, depth + 1);
  }

  List<String> _collectDescendants(MindMap map, String nodeId) {
    final children = map.nodes.where((n) => n.parentId == nodeId).toList();
    final result = <String>[];
    for (final child in children) {
      result.addAll(_collectDescendants(map, child.id));
    }
    return result;
  }

  void _persistAndSync() {
    if (state == null) return;
    _persist();
    _syncToPeers();
  }

  void _persist() {
    if (state == null) return;
    final stored = StorageService.getString('mind_maps');
    if (stored != null) {
      final list = (jsonDecode(stored) as List)
          .map((e) => MindMap.fromJson(e as Map<String, dynamic>))
          .toList();
      final idx = list.indexWhere((m) => m.id == _mindMapId);
      if (idx >= 0) {
        list[idx] = state!;
      } else {
        list.add(state!);
      }
      StorageService.setString('mind_maps', jsonEncode(list.map((m) => m.toJson()).toList()));
    }
  }

  void _syncToPeers() {
    if (state == null) return;
    final msg = jsonEncode({'type': 'mindmap_sync', 'mindmap': state!.toJson()});
    for (final peer in _mesh.connectedPeers) {
      _mesh.sendToPeer(peer.peerId, Uint8List.fromList(utf8.encode(msg)));
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

extension _ListFirstWhereOrNull<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
