import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../core/models/mesh_message.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/mesh_provider.dart';
import '../../core/providers/payment_provider.dart';
import '../../core/models/payment_model.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/ble_mesh_protocol.dart';
import '../../shared/widgets/ouro_bottom_nav.dart';
import '../../shared/widgets/voice_recorder.dart';
import '../../design_system/widgets/ouro_feedback.dart';
import '../../core/providers/gamification_provider.dart';

class ForumScreen extends ConsumerStatefulWidget {
  const ForumScreen({super.key});

  @override
  ConsumerState<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends ConsumerState<ForumScreen>
    with SingleTickerProviderStateMixin {
  final _messageController = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  late TabController _tabController;

  // Pagination
  static const int _pageSize = 50;
  int _loadedUpTo = 0;
  bool _isLoadingMore = false;

  // Reply
  MeshMessage? _replyToMsg;

  // Typing indicators
  final Map<String, Timer> _typingTimers = {};
  Timer? _typingDebounce;
  StreamSubscription<MeshIncomingData>? _meshSub;

  final _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  final List<String> _categories = [
    'Tous', 'Maths', 'Physique', 'Info', 'Entraide', 'Orientation',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadedUpTo = _pageSize;
    _scrollController.addListener(_onScroll);
    _meshSub = ref.read(meshRepositoryProvider).incomingData?.listen((data) {
      if (data.data.length < 3) return;
      final type = data.data[1];
      if (type == kTypingIndicator || type == kTypingStop) {
        final pseudo = utf8.decode(data.data.sublist(2));
        if (type == kTypingIndicator) {
          _typingTimers[pseudo]?.cancel();
          _typingTimers[pseudo] = Timer(const Duration(seconds: 4), () {
            if (mounted) setState(() => _typingTimers.remove(pseudo));
          });
        } else {
          _typingTimers[pseudo]?.cancel();
          _typingTimers.remove(pseudo);
        }
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    _searchController.dispose();
    _typingDebounce?.cancel();
    _meshSub?.cancel();
    for (final t in _typingTimers.values) t.cancel();
    super.dispose();
  }

  // ── Scroll helper ──────────────────────────────────────────────────────────

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_isLoadingMore) return;
    // Load more when within 200px of the "top" (oldest messages)
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    _isLoadingMore = true;
    final total = StorageService.getMessageCount();
    if (_loadedUpTo >= total) {
      _isLoadingMore = false;
      return;
    }
    _loadedUpTo = (_loadedUpTo + _pageSize).clamp(0, total);
    setState(() {});
    Future.delayed(100.ms, () => _isLoadingMore = false);
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: 200.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Typing indicator ───────────────────────────────────────────────────────

  void _onTypingChanged(String text) {
    _typingDebounce?.cancel();
    if (text.isEmpty) {
      _broadcastTyping(kTypingStop);
      return;
    }
    _broadcastTyping(kTypingIndicator);
    _typingDebounce = Timer(const Duration(seconds: 2), () {
      _broadcastTyping(kTypingStop);
    });
  }

  void _broadcastTyping(int type) {
    final repo = ref.read(meshRepositoryProvider);
    if (repo.transport.connectedPeerCount == 0) return;
    final pseudo = ref.read(authProvider).user?.pseudo ?? 'Anon';
    final pseudoBytes = utf8.encode(pseudo);
    final payload = Uint8List(2 + pseudoBytes.length);
    payload[0] = 0;
    payload[1] = type;
    payload.setRange(2, payload.length, pseudoBytes);
    repo.transport.broadcastToConnectedPeers(payload);
  }

  // ── Send ───────────────────────────────────────────────────────────────────

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    ref.read(gamificationStateProvider.notifier).recordDailyActivity();
    final pseudo = ref.read(authProvider).user?.pseudo ?? 'Anonymous';
    final content = _messageController.text.trim();
    final replyId = _replyToMsg?.id;
    ref.read(meshMessagesProvider.notifier).sendMessage(
      pseudo,
      content,
      replyToId: replyId,
    );
    _messageController.clear();
    _replyToMsg = null;
    _scrollToBottom();
  }

  Future<void> _pickAndSendFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.path == null) return;

    final pseudo = ref.read(authProvider).user?.pseudo ?? 'Anonymous';
    final bytes = await File(file.path!).readAsBytes();
    final mimeType = file.extension ?? '';

    await ref.read(meshMessagesProvider.notifier).sendFile(
      pseudo: pseudo,
      fileName: file.name,
      bytes: bytes,
      mimeType: mimeType,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fichier partagé: ${file.name}')),
      );
    }
  }

  Future<void> _recordAndSendAudio() async {
    final recorded = await VoiceRecorderSheet.show(context);
    if (recorded == null) return;

    final pseudo = ref.read(authProvider).user?.pseudo ?? 'Anonymous';
    await ref.read(meshMessagesProvider.notifier).sendFile(
      pseudo: pseudo,
      fileName: 'Message vocal.m4a',
      bytes: recorded.bytes,
      mimeType: 'audio/m4a',
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final pseudo = ref.watch(authProvider).user?.pseudo ?? 'Anonymous';

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                const SizedBox(height: 8),
                _buildCategoryFilter(),
                const SizedBox(height: 8),
                _buildTabs(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMessagesList(pseudo),
                      _buildPopularPosts(),
                      _buildMyPosts(pseudo),
                    ],
                  ),
                ),
                _buildInputBar(pseudo),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: OuroBottomNav(currentRoute: '/forum'),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    final peerCount = ref.watch(connectedPeerCountProvider);
    final peerText = peerCount == 0
        ? 'Aucun pair à portée'
        : peerCount == 1
            ? '1 pair connecté'
            : '$peerCount pairs connectés';
    final dotColor = peerCount > 0
        ? OuroColors.localGreen
        : OuroColors.textSecondary.withValues(alpha: 0.3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.grid3x, DesignTokens.gridSm, DesignTokens.grid3x, DesignTokens.gridSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: OuroColors.meshBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.forum, color: OuroColors.meshBlue, size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forum Mesh',
                    style: TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OuroColors.glassBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: dotColor, size: 6),
                const SizedBox(width: 4),
                Text(
                  peerText,
                  style: const TextStyle(color: OuroColors.textSecondary, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(
      begin: -20, end: 0, duration: 400.ms, curve: Curves.easeOutCubic,
    );
  }

  // ── Tabs ───────────────────────────────────────────────────────────────────

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      decoration: BoxDecoration(
        color: OuroColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OuroColors.glassBorder, width: 0.3),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: OuroColors.meshBlue.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: OuroColors.meshBlue,
        unselectedLabelColor: OuroColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Général'),
          Tab(text: 'Tendances'),
          Tab(text: 'Mes posts'),
        ],
      ),
    );
  }

  // ── Messages list ──────────────────────────────────────────────────────────

  Widget _buildMessagesList(String pseudo) {
    final allMessages = ref.watch(meshMessagesProvider);
    final sorted = List<MeshMessage>.from(allMessages)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final visible = sorted.take(_loadedUpTo).toList();

    if (visible.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: OuroColors.meshBlue.withValues(alpha: 0.05),
              ),
              child: const Icon(Icons.chat_bubble_outline, color: OuroColors.meshBlue, size: 48),
            ),
            const SizedBox(height: 16),
            const Text('Aucun message', style: TextStyle(color: OuroColors.textSecondary, fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'Sois le premier à partager!',
              style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5), fontSize: 13),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms).scaleXY(
        begin: 0.8, end: 1, duration: 500.ms, curve: Curves.easeOutBack,
      );
    }

    final items = _buildDisplayItems(visible);
    final typingPeers = _typingTimers.keys.toList();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      reverse: true,
      itemCount: items.length + (typingPeers.isNotEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (typingPeers.isNotEmpty && index == 0) {
          return _buildTypingIndicator(typingPeers);
        }
        final itemIndex = typingPeers.isNotEmpty ? index - 1 : index;
        if (itemIndex >= items.length) return const SizedBox.shrink();
        final item = items[itemIndex];
        if (item.dateLabel != null) {
          return _buildDateSeparator(item.dateLabel!);
        }
        return _buildMessageCard(item.message!, pseudo,
            isGroupStart: item.isGroupStart, isInsideGroup: item.isInsideGroup);
      },
    );
  }

  // ── Display items ──────────────────────────────────────────────────────────

  List<_DisplayItem> _buildDisplayItems(List<MeshMessage> messages) {
    // messages are newest-first. Process oldest-first for correct grouping.
    final oldestFirst = List<MeshMessage>.from(messages.reversed);

    final items = <_DisplayItem>[];
    String? lastDateLabel;

    for (int i = 0; i < oldestFirst.length; i++) {
      final msg = oldestFirst[i];
      final dateLabel = _formatDateLabel(msg.timestamp);

      if (dateLabel != lastDateLabel) {
        items.add(_DisplayItem.date(dateLabel));
        lastDateLabel = dateLabel;
      }

      final isGroupStart = i == 0 ||
          msg.authorPseudo != oldestFirst[i - 1].authorPseudo ||
          msg.timestamp.difference(oldestFirst[i - 1].timestamp).inMinutes.abs() > 2;

      final isInsideGroup = !isGroupStart &&
          i < oldestFirst.length - 1 &&
          msg.authorPseudo == oldestFirst[i + 1].authorPseudo &&
          oldestFirst[i + 1].timestamp.difference(msg.timestamp).inMinutes.abs() <= 2;

      items.add(_DisplayItem.message(msg, isGroupStart, isInsideGroup));
    }

    return items.reversed.toList();
  }

  // ── Date separator ─────────────────────────────────────────────────────────

  Widget _buildDateSeparator(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: OuroColors.glassBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: OuroColors.glassBorder, width: 0.3),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: OuroColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ── Typing indicator ───────────────────────────────────────────────────────

  Widget _buildTypingIndicator(List<String> peerPseudos) {
    final text = peerPseudos.length == 1
        ? '${peerPseudos.first} écrit...'
        : 'Plusieurs personnes écrivent...';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const SizedBox(width: 44),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _typingDots(),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: TextStyle(
                    color: OuroColors.textSecondary.withValues(alpha: 0.7), fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typingDots() {
    return SizedBox(
      width: 24, height: 12,
      child: Stack(
        children: List.generate(3, (i) => Positioned(
          left: i * 8.0,
          top: 2,
          child: Animate(
            onInit: (controller) => controller.repeat(reverse: true),
            effects: [
              ScaleEffect(
                begin: const Offset(1, 1),
                end: const Offset(0.4, 0.4),
                duration: 600.ms,
                delay: (i * 200).ms,
                curve: Curves.easeInOut,
              ),
            ],
            child: Container(
              width: 6, height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: OuroColors.textSecondary,
              ),
            ),
          ),
        )),
      ),
    );
  }

  // ── Message card ───────────────────────────────────────────────────────────

  Widget _buildMessageCard(
    MeshMessage msg,
    String pseudo, {
    required bool isGroupStart,
    required bool isInsideGroup,
  }) {
    final isOwn = msg.authorPseudo == pseudo;
    final isCompact = !isGroupStart && !isInsideGroup;

    return GestureDetector(
      onLongPress: () => _showMessageActions(msg, pseudo),
      onSecondaryTap: () => _showMessageActions(msg, pseudo),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: isCompact ? 2.0 : 10.0,
          left: isOwn ? 48.0 : 0,
          right: isOwn ? 0 : 48.0,
        ),
        child: Column(
          crossAxisAlignment: isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Avatar + name (only at group start)
            if (isGroupStart && !isOwn)
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 2),
                child: Row(
                  children: [
                    _buildAvatar(msg.authorPseudo, 26),
                    const SizedBox(width: 6),
                    Text(
                      msg.authorPseudo,
                      style: const TextStyle(
                        color: OuroColors.meshBlue, fontSize: 11, fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // Reply preview
            if (msg.replyToId != null)
              _buildReplyPreview(msg.replyToId!),

            // Bubble
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar at group start for own messages (right side)
                if (isGroupStart && isOwn)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: _buildAvatar(msg.authorPseudo, 22),
                  ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isOwn
                          ? OuroColors.meshBlue.withValues(alpha: 0.15)
                          : OuroColors.cardDark,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isOwn ? const Radius.circular(4) : null,
                        bottomLeft: !isOwn ? const Radius.circular(4) : null,
                      ),
                      border: Border.all(
                        color: isOwn
                            ? OuroColors.meshBlue.withValues(alpha: 0.2)
                            : OuroColors.glassBorder,
                        width: 0.3,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name for own messages at group start
                        if (isGroupStart && isOwn)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              msg.authorPseudo,
                              style: const TextStyle(
                                color: OuroColors.meshBlue, fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        // Content
                        if (isAudioMessage(msg))
                          _buildAudioAttachment(msg)
                        else if (msg.type == 'file')
                          _buildFileAttachment(msg)
                        else if (msg.imageUrl != null)
                          _buildImageContent(msg)
                        else
                          Text(
                            msg.content,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Reactions
            _buildReactionsRow(msg),
            // Footer: status + timestamp + route info
            Padding(
              padding: const EdgeInsets.only(top: 1, left: 4, right: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Timestamp
                  Text(
                    _formatTime(msg.timestamp),
                    style: TextStyle(
                      color: OuroColors.textSecondary.withValues(alpha: 0.4), fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Route info (received messages)
                  if (!isOwn && msg.routeInfo != null)
                    Text(
                      msg.routeInfo!,
                      style: TextStyle(
                        color: OuroColors.meshBlue.withValues(alpha: 0.4), fontSize: 9,
                      ),
                    ),
                  // Status (own messages)
                  if (isOwn) _buildStatusIcon(msg.status),
                  // Delivery count (ACK reçus)
                  if (isOwn && msg.status == MessageStatus.sent && msg.deliveryCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        '✓${msg.deliveryCount}',
                        style: TextStyle(
                          color: OuroColors.successGreen.withValues(alpha: 0.6),
                          fontSize: 9,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
      duration: 200.ms,
    ).moveY(begin: 6, end: 0, duration: 200.ms, curve: Curves.easeOut);
  }

  Widget _buildAvatar(String pseudo, double size) {
    return Container(
      width: size, height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [OuroColors.meshBlue, OuroColors.ouroOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          pseudo[0].toUpperCase(),
          style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: size * 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    IconData icon;
    Color color;
    switch (status) {
      case MessageStatus.sending:
        icon = Icons.access_time;
        color = OuroColors.textSecondary.withValues(alpha: 0.3);
      case MessageStatus.sent:
        icon = Icons.check_circle_outline;
        color = OuroColors.meshBlue.withValues(alpha: 0.5);
      case MessageStatus.pending:
        icon = Icons.schedule;
        color = OuroColors.ouroOrange;
      case MessageStatus.failed:
        icon = Icons.error_outline;
        color = OuroColors.errorRed;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Icon(icon, size: 12, color: color),
    );
  }

  // ── Reply preview ──────────────────────────────────────────────────────────

  Widget _buildReplyPreview(String replyToId) {
    final repliedMsg = ref.read(meshMessagesProvider).where(
      (m) => m.id == replyToId,
    ).firstOrNull;
    if (repliedMsg == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: OuroColors.meshBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: OuroColors.meshBlue.withValues(alpha: 0.4), width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            repliedMsg.authorPseudo,
            style: const TextStyle(
              color: OuroColors.meshBlue, fontSize: 10, fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            repliedMsg.content.length > 60
                ? '${repliedMsg.content.substring(0, 60)}...'
                : repliedMsg.content,
            style: TextStyle(
              color: OuroColors.textSecondary.withValues(alpha: 0.6), fontSize: 11,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── Image content ──────────────────────────────────────────────────────────

  Widget _buildImageContent(MeshMessage msg) {
    if (msg.imageUrl == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => _showImageFullScreen(msg.imageUrl!),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(msg.imageUrl!),
          width: 200,
          height: 160,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _showImageFullScreen(String path) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(File(path), fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  // ── File & audio attachments ──────────────────────────────────────────────

  Widget _buildFileAttachment(MeshMessage msg) {
    final icon = _fileIcon(msg.fileMimeType ?? msg.fileName ?? '');
    final sizeText = msg.fileSize != null ? _formatFileSize(msg.fileSize!) : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(msg.content, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: OuroColors.glassBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: OuroColors.glassBorder, width: 0.3),
          ),
          child: Row(
            children: [
              Icon(icon, color: OuroColors.ouroOrange, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      msg.fileName ?? msg.content,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (sizeText.isNotEmpty)
                      Text(
                        sizeText,
                        style: TextStyle(
                          color: OuroColors.textSecondary.withValues(alpha: 0.5), fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _openFile(msg),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OuroColors.meshBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.download, color: OuroColors.meshBlue, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioAttachment(MeshMessage msg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (msg.content.isNotEmpty && msg.content != msg.fileName)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(msg.content, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        AudioMessagePlayer(message: msg),
      ],
    );
  }

  // ── Context menu (long-press) ─────────────────────────────────────────────

  void _showMessageActions(MeshMessage msg, String pseudo) {
    final isOwn = msg.authorPseudo == pseudo;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MessageActionsSheet(
        message: msg,
        isOwn: isOwn,
        onReply: () {
          Navigator.pop(ctx);
          setState(() => _replyToMsg = msg);
          _focusNode.requestFocus();
        },
        onCopy: () {
          Navigator.pop(ctx);
          Clipboard.setData(ClipboardData(text: msg.content));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message copié')),
          );
        },
        onReact: (emoji) {
          Navigator.pop(ctx);
          ref.read(meshMessagesProvider.notifier).toggleReaction(msg.id, emoji);
        },
        onForward: () {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message transféré sur le mesh')),
          );
        },
        onDelete: isOwn
            ? () {
                Navigator.pop(ctx);
                ref.read(meshMessagesProvider.notifier).removeMessage(msg.id);
              }
            : null,
      ),
    );
  }

  // ── Reactions ───────────────────────────────────────────────────────────────

  Widget _buildReactionsRow(MeshMessage msg) {
    if (msg.reactions.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: OuroReactionBar(
        reactions: {for (final r in msg.reactions) r: 1},
        userReactions: msg.reactions.where((r) => r.length == 1).toSet(),
      ),
    );
  }

  // ── Input bar ──────────────────────────────────────────────────────────────

  Widget _buildInputBar(String pseudo) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: OuroColors.glassBorder, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: OuroColors.surface.withValues(alpha: 0.9),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Reply preview
                if (_replyToMsg != null)
                  _buildReplyBar(),
                // Input row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _pickAndSendFile,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: OuroColors.glassBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.attach_file, color: OuroColors.textSecondary, size: 20),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _recordAndSendAudio,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: OuroColors.glassBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.mic, color: OuroColors.textSecondary, size: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _messageController,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          decoration: const InputDecoration(
                            hintText: 'Écris ton message...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: OuroColors.textSecondary),
                          ),
                          onChanged: _onTypingChanged,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: OuroColors.meshBlue,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: DesignTokens.glow(OuroColors.meshBlue, radius: 10),
                          ),
                          child: const Icon(Icons.send, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReplyBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      decoration: BoxDecoration(
        color: OuroColors.meshBlue.withValues(alpha: 0.08),
        border: Border(
          top: BorderSide(
            color: OuroColors.meshBlue.withValues(alpha: 0.2), width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.reply, color: OuroColors.meshBlue, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _replyToMsg!.authorPseudo,
                  style: const TextStyle(
                    color: OuroColors.meshBlue, fontSize: 10, fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _replyToMsg!.content.length > 50
                      ? '${_replyToMsg!.content.substring(0, 50)}...'
                      : _replyToMsg!.content,
                  style: TextStyle(
                    color: OuroColors.textSecondary.withValues(alpha: 0.6), fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _replyToMsg = null),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.close, color: OuroColors.textSecondary, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  // ── Popular posts ──────────────────────────────────────────────────────────

  Widget _buildPopularPosts() {
    final popular = [
      _PopularPost('Limites: astuces', 'Maths', '👍 24', '💬 12', OuroColors.meshBlue),
      _PopularPost('Sujet BAC 2024', 'Physique', '👍 18', '💬 8', OuroColors.ouroOrange),
      _PopularPost('Python pour debutants', 'Info', '👍 15', '💬 10', OuroColors.localGreen),
      _PopularPost('Bourses études', 'Orientation', '👍 12', '💬 6', Colors.purple),
    ];

    return ListView(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      children: [
        const Text(
          'Tendances',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...popular.map((p) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: OuroColors.cardDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: OuroColors.glassBorder, width: 0.3),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: p.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.trending_up, color: p.color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      style: const TextStyle(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: p.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(p.category, style: TextStyle(color: p.color, fontSize: 9)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          p.reactions,
                          style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          p.replies,
                          style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  // ── My posts ───────────────────────────────────────────────────────────────

  Widget _buildMyPosts(String pseudo) {
    final allMessages = ref.watch(meshMessagesProvider);
    final myMessages = allMessages
        .where((m) => m.authorPseudo == pseudo)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (myMessages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, color: OuroColors.textSecondary.withValues(alpha: 0.3), size: 48),
            const SizedBox(height: 12),
            const Text('Tu n\'as pas encore posté', style: TextStyle(color: OuroColors.textSecondary)),
          ],
        ),
      );
    }

    final items = _buildDisplayItems(myMessages);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      reverse: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item.dateLabel != null) {
          return _buildDateSeparator(item.dateLabel!);
        }
        return _buildMessageCard(
          item.message!, pseudo,
          isGroupStart: item.isGroupStart,
          isInsideGroup: item.isInsideGroup,
        );
      },
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: OuroColors.glassBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: OuroColors.glassBorder),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Rechercher dans le forum...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5)),
            prefixIcon: Icon(Icons.search, color: OuroColors.textSecondary, size: 18),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    child: const Icon(Icons.close, color: OuroColors.textSecondary, size: 16),
                  )
                : null,
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  // ── Category filter ───────────────────────────────────────────────────────

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final isActive = _selectedCategory == _categories[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = _categories[index]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? OuroColors.meshBlue.withValues(alpha: 0.15)
                    : OuroColors.glassBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isActive
                      ? OuroColors.meshBlue.withValues(alpha: 0.3)
                      : OuroColors.glassBorder,
                ),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: isActive ? OuroColors.meshBlue : OuroColors.textSecondary,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(dateDay).inDays;

    if (diff == 0) return "Aujourd'hui";
    if (diff == 1) return 'Hier';
    if (diff < 7) {
      const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      return days[dt.weekday - 1];
    }
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  IconData _fileIcon(String ext) {
    final lower = ext.toLowerCase();
    if (lower.contains('pdf')) return Icons.picture_as_pdf;
    if (lower.contains('image') ||
        ['png', 'jpg', 'jpeg', 'gif', 'webp'].any((e) => lower.contains(e))) {
      return Icons.image;
    }
    if (lower.contains('audio') ||
        ['mp3', 'wav', 'ogg', 'aac', 'm4a'].any((e) => lower.contains(e))) {
      return Icons.audio_file;
    }
    if (lower.contains('video') ||
        ['mp4', 'avi', 'mkv', 'mov'].any((e) => lower.contains(e))) {
      return Icons.video_file;
    }
    if (['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt']
        .any((e) => lower.contains(e))) {
      return Icons.description;
    }
    return Icons.insert_drive_file;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes o';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} Ko';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Mo';
  }

  Future<void> _openFile(MeshMessage msg) async {
    if (msg.fileId == null || msg.fileName == null) return;
    final path = await StorageService.getSharedFilePath(msg.fileId!, msg.fileName!);
    if (path == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fichier non trouvé')),
        );
      }
      return;
    }
    final xFile = XFile(path);
    await Share.shareXFiles([xFile], text: msg.fileName);
    ref.read(walletProvider.notifier).earnReward(RewardType.contentShare);
  }
}

// ── Helper models ───────────────────────────────────────────────────────────

class _PopularPost {
  final String title;
  final String category;
  final String reactions;
  final String replies;
  final Color color;
  _PopularPost(this.title, this.category, this.reactions, this.replies, this.color);
}

class _DisplayItem {
  final MeshMessage? message;
  final String? dateLabel;
  final bool isGroupStart;
  final bool isInsideGroup;

  _DisplayItem.message(this.message, this.isGroupStart, this.isInsideGroup)
      : dateLabel = null;
  _DisplayItem.date(this.dateLabel)
      : message = null, isGroupStart = false, isInsideGroup = false;
}

// ── Bottom sheet actions ────────────────────────────────────────────────────

class _MessageActionsSheet extends StatelessWidget {
  final MeshMessage message;
  final bool isOwn;
  final VoidCallback onReply;
  final VoidCallback onCopy;
  final ValueChanged<String> onReact;
  final VoidCallback onForward;
  final VoidCallback? onDelete;

  static const _quickEmojis = ['👍', '❤️', '😂', '😮', '😢', '🙏'];

  const _MessageActionsSheet({
    required this.message,
    required this.isOwn,
    required this.onReply,
    required this.onCopy,
    required this.onReact,
    required this.onForward,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      decoration: const BoxDecoration(
        color: OuroColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: OuroColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Emoji row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _quickEmojis.map((emoji) {
                final isActive = message.reactions.contains(emoji);
                return GestureDetector(
                  onTap: () => onReact(emoji),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isActive
                          ? OuroColors.meshBlue.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isActive
                          ? Border.all(color: OuroColors.meshBlue.withValues(alpha: 0.3))
                          : null,
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(color: OuroColors.glassBorder, height: 1),
          // Actions
          _actionTile(Icons.reply, 'Répondre', onReply),
          _actionTile(Icons.copy, 'Copier le texte', onCopy),
          _actionTile(Icons.share_outlined, 'Transférer', onForward),
          if (onDelete != null)
            _actionTile(Icons.delete_outline, 'Supprimer', onDelete!, color: OuroColors.errorRed),
        ],
      ),
    );
  }

  Widget _actionTile(IconData icon, String label, VoidCallback onTap,
      {Color color = OuroColors.textSecondary}) {
    return ListTile(
      leading: Icon(icon, color: color, size: 20),
      title: Text(label, style: TextStyle(color: color, fontSize: 14)),
      onTap: onTap,
      dense: true,
    );
  }
}
