import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/glassmorphism.dart';
import '../../core/providers/mind_map_provider.dart';
import '../../core/models/mind_map.dart';

class MindMapListScreen extends ConsumerWidget {
  const MindMapListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maps = ref.watch(mindMapListProvider);
    return Scaffold(
      backgroundColor: OuroColors.background,
      appBar: AppBar(
        backgroundColor: OuroColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Cartes Mentales P2P',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: OuroColors.meshBlue),
            onPressed: () => _createMap(context, ref),
          ),
        ],
      ),
      body: maps.isEmpty
          ? _buildEmptyState(context, ref)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: maps.length,
              itemBuilder: (context, index) => _buildMapCard(context, ref, maps[index]),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: OuroColors.glassBg,
            ),
            child: const Icon(Icons.account_tree, color: Colors.white, size: 44),
          ).animate().fadeIn().scaleXY(begin: 0.6, end: 1, duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          const Text('Crée ta première carte mentale',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('Collabore en temps réel avec tes pairs P2P',
              style: TextStyle(color: OuroColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => _createMap(context, ref),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                gradient: OuroColors.brandGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text('Nouvelle carte', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard(BuildContext context, WidgetRef ref, MindMap map) {
    final peerCount = map.collaboratorIds.length;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        borderRadius: 16,
        opacity: 0.06,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/mindmap/${map.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: OuroColors.brandGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.account_tree, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(map.title,
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text('${map.nodes.length} nœuds · ${peerCount} collaborateur${peerCount > 1 ? 's' : ''}',
                          style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: OuroColors.textTertiary, size: 20),
                  onPressed: () => ref.read(mindMapListProvider.notifier).deleteMap(map.id),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 20, end: 0, duration: 300.ms);
  }

  void _createMap(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => _CreateMapDialog(
        onCreated: (title) {
          final ownerId = DateTime.now().millisecondsSinceEpoch.toString();
          ref.read(mindMapListProvider.notifier).createMap(title, ownerId);
        },
      ),
    );
  }
}

class _CreateMapDialog extends StatefulWidget {
  final Function(String) onCreated;
  const _CreateMapDialog({required this.onCreated});

  @override
  State<_CreateMapDialog> createState() => _CreateMapDialogState();
}

class _CreateMapDialogState extends State<_CreateMapDialog> {
  final _ctrl = TextEditingController(text: 'Ma carte mentale');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: OuroColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Nouvelle carte', style: TextStyle(color: Colors.white)),
      content: TextField(
        controller: _ctrl,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Titre de la carte',
          hintStyle: const TextStyle(color: OuroColors.textTertiary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: OuroColors.meshBlue),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler', style: TextStyle(color: OuroColors.textSecondary)),
        ),
        FilledButton(
          onPressed: () {
            widget.onCreated(_ctrl.text.trim().isEmpty ? 'Sans titre' : _ctrl.text.trim());
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(backgroundColor: OuroColors.meshBlue),
          child: const Text('Créer'),
        ),
      ],
    );
  }
}

class MindMapEditorScreen extends ConsumerStatefulWidget {
  final String mindMapId;
  const MindMapEditorScreen({super.key, required this.mindMapId});

  @override
  ConsumerState<MindMapEditorScreen> createState() => _MindMapEditorScreenState();
}

class _MindMapEditorScreenState extends ConsumerState<MindMapEditorScreen> {
  String? _editingNodeId;
  final _labelCtrl = TextEditingController();

  @override
  void dispose() {
    _labelCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final map = ref.watch(activeMindMapProvider(widget.mindMapId));
    final notifier = ref.read(activeMindMapProvider(widget.mindMapId).notifier);

    return Scaffold(
      backgroundColor: OuroColors.background,
      appBar: AppBar(
        backgroundColor: OuroColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: GestureDetector(
          onTap: () => _editTitle(context, notifier, map?.title ?? ''),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(map?.title ?? 'Carte mentale',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(width: 6),
              const Icon(Icons.edit, color: OuroColors.textTertiary, size: 14),
            ],
          ),
        ),
        actions: [
          if (map != null)
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: OuroColors.meshBlue),
              onPressed: () {
                final root = map.nodes.where((n) => n.parentId == null);
                if (root.isEmpty) {
                  notifier.addNode('root');
                } else {
                  notifier.addNode(root.first.id);
                }
              },
              tooltip: 'Ajouter un nœud',
            ),
        ],
      ),
      body: map == null
          ? const Center(child: CircularProgressIndicator(color: OuroColors.meshBlue))
          : map.nodes.isEmpty
              ? _buildEmptyEditor(notifier)
              : _buildCanvas(map, notifier),
    );
  }

  Widget _buildEmptyEditor(MindMapEditorNotifier notifier) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add_circle_outline, color: OuroColors.textTertiary, size: 64),
          const SizedBox(height: 16),
          const Text('Commence par ajouter un nœud central',
              style: TextStyle(color: OuroColors.textSecondary)),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              notifier.addNode('root');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: OuroColors.brandGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text('Ajouter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas(MindMap map, MindMapEditorNotifier notifier) {
    return Stack(
      children: [
        CustomPaint(
          size: Size.infinite,
          painter: _EdgePainter(nodes: map.nodes, edges: map.edges),
        ),
        ...map.nodes.map((node) => _buildNodeWidget(map, node, notifier)),
      ],
    );
  }

  Widget _buildNodeWidget(MindMap map, MindMapNode node, MindMapEditorNotifier notifier) {
    final isEditing = _editingNodeId == node.id;

    return Positioned(
      left: node.x,
      top: node.y,
      child: GestureDetector(
        onPanUpdate: (details) {
          notifier.updateNodePosition(node.id, node.x + details.delta.dx, node.y + details.delta.dy);
        },
        onDoubleTap: () {
          setState(() {
            _editingNodeId = node.id;
            _labelCtrl.text = node.label;
          });
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: OuroColors.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEditing ? OuroColors.meshBlue : node.color.withValues(alpha: 0.4),
              width: isEditing ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: node.color.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isEditing)
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _labelCtrl,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (v) {
                      notifier.updateNodeLabel(node.id, v.trim());
                      setState(() => _editingNodeId = null);
                    },
                  ),
                )
              else
                Text(
                  node.label,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => notifier.addNode(node.id),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: node.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.add, color: node.color, size: 12),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => notifier.deleteNode(node.id),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: OuroColors.errorRed.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.close, color: OuroColors.errorRed, size: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editTitle(BuildContext context, MindMapEditorNotifier notifier, String currentTitle) {
    final ctrl = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: OuroColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Titre', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: OuroColors.meshBlue),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: OuroColors.textSecondary)),
          ),
          FilledButton(
            onPressed: () {
              notifier.updateTitle(ctrl.text.trim());
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: OuroColors.meshBlue),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _EdgePainter extends CustomPainter {
  final List<MindMapNode> nodes;
  final List<MindMapEdge> edges;

  _EdgePainter({required this.nodes, required this.edges});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = OuroColors.glassBorder
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final edge in edges) {
      final from = nodes.where((n) => n.id == edge.fromId);
      final to = nodes.where((n) => n.id == edge.toId);
      if (from.isEmpty || to.isEmpty) continue;

      final fromNode = from.first;
      final toNode = to.first;
      final fromCenter = Offset(fromNode.x + 80, fromNode.y + 25);
      final toCenter = Offset(toNode.x + 80, toNode.y + 25);

      final midX = (fromCenter.dx + toCenter.dx) / 2;
      canvas.drawPath(
        Path()
          ..moveTo(fromCenter.dx, fromCenter.dy)
          ..quadraticBezierTo(midX, fromCenter.dy, toCenter.dx, toCenter.dy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EdgePainter oldDelegate) => true;
}
