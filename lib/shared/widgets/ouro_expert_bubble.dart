import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/llm_provider.dart';

class OuroExpertBubble extends ConsumerStatefulWidget {
  const OuroExpertBubble({super.key});

  @override
  ConsumerState<OuroExpertBubble> createState() => _OuroExpertBubbleState();
}

class _OuroExpertBubbleState extends ConsumerState<OuroExpertBubble>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _panelCtrl;
  late Animation<Offset> _panelSlide;
  late Animation<double> _panelFade;

  Offset _bubblePos = const Offset(0, 0);
  bool _isDragging = false;
  bool _isPanelOpen = false;

  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  static const _suggestions = [
    'Résume mon cours',
    'Génère un quiz',
    'Explique ce concept',
    'Fiche de révision',
    'Exercice type BAC',
  ];

  bool get _isLoading =>
      ref.watch(llmChatProvider).isLoading;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: 2400.ms)..repeat(reverse: true);
    _panelCtrl = AnimationController(vsync: this, duration: 400.ms);
    _panelSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic));
    _panelFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _panelCtrl.dispose();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _togglePanel() {
    if (_isPanelOpen) {
      _panelCtrl.reverse().then((_) => setState(() => _isPanelOpen = false));
    } else {
      setState(() => _isPanelOpen = true);
      _panelCtrl.forward();
      _scrollToBottom();
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _inputCtrl.clear();
    ref.read(llmChatProvider.notifier).sendMessage(text.trim());
    _scrollToBottom();
  }

  void _onSuggestionTap(String text) {
    _sendMessage(text);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bubbleX = _bubblePos.dx == 0 && _bubblePos.dy == 0
        ? size.width - 80
        : _bubblePos.dx;
    final bubbleY = _bubblePos.dy == 0 && _bubblePos.dx == 0
        ? size.height - 200
        : _bubblePos.dy;

    return Stack(
      children: [
        if (_isPanelOpen)
          Positioned.fill(
            child: FadeTransition(
              opacity: _panelFade,
                child: GestureDetector(
                  onTap: _togglePanel,
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        if (_isPanelOpen)
          Positioned.fill(
            child: SlideTransition(
              position: _panelSlide,
              child: FadeTransition(
                opacity: _panelFade,
                child: _buildPanel(context),
              ),
            ),
          ),
        Positioned(
          left: bubbleX.clamp(0, size.width - 72),
          top: bubbleY.clamp(80, size.height - 120),
          child: GestureDetector(
            onPanStart: (_) => setState(() => _isDragging = true),
            onPanUpdate: (d) {
              setState(() {
                _bubblePos = Offset(
                  (_bubblePos.dx + d.delta.dx).clamp(0, size.width - 72),
                  (_bubblePos.dy + d.delta.dy).clamp(80, size.height - 120),
                );
              });
            },
            onPanEnd: (_) => setState(() => _isDragging = false),
            onTap: _isDragging ? null : _togglePanel,
            child: _buildBubble(),
          ),
        ),
      ],
    );
  }

  Widget _buildBubble() {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (ctx, _) {
        final pulse = _pulseCtrl.value;
        final glowOpacity = 0.25 + pulse * 0.25;
        final scale = _isPanelOpen ? 0.85 : (1.0 + pulse * 0.04);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF2563FF), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563FF).withValues(alpha: glowOpacity * 0.6),
                  blurRadius: 12 + pulse * 8,
                  spreadRadius: 1 + pulse * 3,
                ),
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: glowOpacity * 0.3),
                  blurRadius: 24 + pulse * 12,
                  spreadRadius: 2 + pulse * 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: _isPanelOpen
                        ? const Color(0xFF2563FF).withValues(alpha: 0.2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15 + pulse * 0.1),
                      width: 1.5,
                    ),
                  ),
                  child: _isPanelOpen
                      ? const Icon(Icons.close, color: Colors.white, size: 22)
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                            if (pulse > 0.7)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00E676),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF060608), width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPanel(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final chatState = ref.watch(llmChatProvider);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border.all(color: const Color(0x33FFFFFF), width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F14).withValues(alpha: 0.92),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    _buildHandle(),
                    _buildHeader(),
                    const Divider(height: 1, color: Color(0x33FFFFFF)),
                    _buildSuggestions(),
                    const Divider(height: 1, color: Color(0x33FFFFFF)),
                    Expanded(child: _buildMessageList(chatState)),
                    _buildInputBar(bottom),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF8888A0),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF2563FF), Color(0xFF7C3AED)],
              ),
            ),
            child: const Center(child: Icon(Icons.auto_awesome, color: Colors.white, size: 20)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('OURO Expert', style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                )),
                Text('En ligne • Pose ta question', style: TextStyle(
                  color: Color(0xFF8888A0),
                  fontSize: 12,
                )),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF8888A0), size: 22),
            onPressed: _togglePanel,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          return GestureDetector(
            onTap: () => _onSuggestionTap(_suggestions[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0x1AFFFFFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x33FFFFFF), width: 0.5),
              ),
              child: Text(_suggestions[i], style: const TextStyle(
                color: Color(0xFF8888A0),
                fontSize: 12,
              )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageList(LlmChatState chatState) {
    if (chatState.messages.isEmpty) {
      return const Center(
        child: Text(
          'Pose ta question sur tes cours !',
          style: TextStyle(color: Color(0xFF8888A0)),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == chatState.messages.length && chatState.isLoading) {
          return _buildWaitingBubble();
        }
        final msg = chatState.messages[i];
        final isUser = msg.isUser;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2563FF).withValues(alpha: 0.2),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Color(0xFF5B8BFF), size: 14),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color(0xFF2563FF).withValues(alpha: 0.2)
                        : const Color(0x1AFFFFFF),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: Border.all(
                      color: isUser
                          ? const Color(0xFF2563FF).withValues(alpha: 0.15)
                          : const Color(0x33FFFFFF),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(msg.text, style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      )),
                      if (!isUser)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            children: [
                              Icon(
                                msg.isOnline ? Icons.cloud_done : Icons.phone_android,
                                size: 12,
                                color: msg.isOnline
                                    ? const Color(0xFF2563FF)
                                    : const Color(0xFF00E676),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                msg.isOnline ? 'En ligne' : 'Local',
                                style: TextStyle(
                                  color: msg.isOnline
                                      ? const Color(0xFF8888A0)
                                      : const Color(0xFF00E676),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: 4),
            ],
          ),
        ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.15, end: 0, duration: 250.ms);
      },
    );
  }

  Widget _buildWaitingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2563FF).withValues(alpha: 0.2),
            ),
            child: const Icon(Icons.auto_awesome, color: Color(0xFF5B8BFF), size: 14),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: const Color(0x33FFFFFF), width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563FF).withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: 0, end: -6, duration: 500.ms, delay: (i * 150).ms);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(double bottomInset) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8 + bottomInset),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x33FFFFFF), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x1AFFFFFF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0x33FFFFFF), width: 0.5),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.auto_awesome, color: Color(0xFF2563FF), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _inputCtrl,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Pose ta question...',
                        hintStyle: TextStyle(color: Color(0xFF8888A0), fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: _isLoading ? null : _sendMessage,
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isLoading ? null : () => _sendMessage(_inputCtrl.text),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563FF), Color(0xFF7C3AED)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563FF).withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
