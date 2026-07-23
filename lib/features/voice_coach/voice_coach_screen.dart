import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/ouro_colors.dart';
import '../../core/providers/voice_coach_provider.dart';
import '../../core/models/african_language.dart';

class VoiceCoachScreen extends ConsumerStatefulWidget {
  const VoiceCoachScreen({super.key});

  @override
  ConsumerState<VoiceCoachScreen> createState() => _VoiceCoachScreenState();
}

class _VoiceCoachScreenState extends ConsumerState<VoiceCoachScreen>
    with TickerProviderStateMixin {
  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: 2.seconds)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceCoachProvider);
    final notifier = ref.read(voiceCoachProvider.notifier);

    return Scaffold(
      backgroundColor: OuroColors.background,
      appBar: _buildAppBar(state),
      body: Column(
        children: [
          _buildLanguageStrip(state),
          Expanded(
            child: state.messages.isEmpty
                ? _buildEmptyState(state)
                : _buildMessages(state),
          ),
          _buildSpeakingIndicator(state),
          _buildInputBar(state, notifier),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(VoiceCoachState state) {
    return AppBar(
      backgroundColor: OuroColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (context, child) => Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: state.speakingState == CoachSpeakingState.speaking
                    ? OuroColors.localGreen
                    : OuroColors.meshBlue,
                boxShadow: [
                  BoxShadow(
                    color: (state.speakingState == CoachSpeakingState.speaking
                            ? OuroColors.localGreen
                            : OuroColors.meshBlue)
                        .withValues(alpha: 0.5 + _pulseCtrl.value * 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Coach Vocal',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                state.speakingState == CoachSpeakingState.speaking
                    ? 'Parle...'
                    : state.isLoading
                        ? 'Réfléchit...'
                        : 'Prêt',
                style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.mic, color: OuroColors.meshBlue, size: 20),
          tooltip: 'Mode live',
          onPressed: () => context.push('/voice-coach/live'),
        ),
        if (state.messages.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: OuroColors.textSecondary, size: 20),
            onPressed: () => ref.read(voiceCoachProvider.notifier).clearChat(),
          ),
      ],
    );
  }

  Widget _buildLanguageStrip(VoiceCoachState state) {
    return Container(
      height: 60,
      color: OuroColors.surfaceElevated,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: AfricanLanguage.all.length,
        itemBuilder: (context, index) {
          final lang = AfricanLanguage.all[index];
          final isSelected = lang.code == state.selectedLanguage;
          return GestureDetector(
            onTap: () => ref.read(voiceCoachProvider.notifier).setLanguage(lang.code),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [lang.color.withValues(alpha: 0.3), lang.color.withValues(alpha: 0.1)],
                      )
                    : null,
                color: isSelected ? null : OuroColors.glassBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? lang.color.withValues(alpha: 0.5) : OuroColors.glassBorder,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(lang.icon, color: lang.color, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    lang.nativeName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : OuroColors.textSecondary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(VoiceCoachState state) {
    final lang = AfricanLanguage.fromCode(state.selectedLanguage);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [lang.color.withValues(alpha: 0.3), lang.color.withValues(alpha: 0.05)],
              ),
            ),
            child: Icon(Icons.record_voice_over, color: lang.color, size: 36),
          ),
          const SizedBox(height: 24),
          Text(
            'Coach ${lang.name}',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Pose ta question ou parle-moi de ton cours.\nJe suis là pour t\'aider !',
            textAlign: TextAlign.center,
            style: const TextStyle(color: OuroColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _suggestionChip('Explique ce concept'),
              _suggestionChip('Aide-moi à réviser'),
              _suggestionChip('Donne un exemple'),
              _suggestionChip('Résume mon cours'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _suggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        _textCtrl.text = text;
        ref.read(voiceCoachProvider.notifier).sendMessage(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: OuroColors.glassBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: OuroColors.glassBorder),
        ),
        child: Text(
          text,
          style: const TextStyle(color: OuroColors.textSecondary, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildMessages(VoiceCoachState state) {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(16),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final msg = state.messages[index];
        return _buildMessageBubble(msg, index == state.messages.length - 1);
      },
    );
  }

  Widget _buildMessageBubble(VoiceCoachMessage msg, bool isLast) {
    final isUser = msg.isUser;
    final lang = AfricanLanguage.fromCode(msg.languageCode);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    OuroColors.meshBlue.withValues(alpha: 0.8),
                    OuroColors.accentPurple.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: const Icon(Icons.record_voice_over, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: isUser
                    ? LinearGradient(
                        colors: [
                          lang.color.withValues(alpha: 0.3),
                          lang.color.withValues(alpha: 0.1),
                        ],
                      )
                    : null,
                color: isUser ? null : OuroColors.cardDark,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: Border.all(
                  color: isUser
                      ? lang.color.withValues(alpha: 0.3)
                      : OuroColors.glassBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isUser && lang.code != 'fr')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        lang.nativeName,
                        style: TextStyle(color: lang.color, fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    ),
                  Text(
                    msg.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : OuroColors.textPrimary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: OuroColors.glassBg,
              ),
              child: const Icon(Icons.person, color: OuroColors.textSecondary, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpeakingIndicator(VoiceCoachState state) {
    if (state.speakingState != CoachSpeakingState.speaking) {
      return const SizedBox(height: 8);
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: OuroColors.localGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: OuroColors.localGreen.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.volume_up, color: OuroColors.localGreen, size: 16),
          const SizedBox(width: 8),
          const Text('Lecture en cours...', style: TextStyle(color: OuroColors.localGreen, fontSize: 12)),
          const Spacer(),
          GestureDetector(
            onTap: () => ref.read(voiceCoachProvider.notifier).stopSpeaking(),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.stop, color: OuroColors.textSecondary, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(VoiceCoachState state, VoiceCoachNotifier notifier) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: OuroColors.surface,
        border: Border(top: BorderSide(color: OuroColors.glassBorder, width: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: OuroColors.cardDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: OuroColors.glassBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textCtrl,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (v) => _sendMessage(notifier),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Pose ta question...',
                        hintStyle: TextStyle(color: OuroColors.textTertiary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _sendMessage(notifier),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: OuroColors.brandGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                state.isLoading ? Icons.hourglass_top : Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(VoiceCoachNotifier notifier) {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    _textCtrl.clear();
    notifier.sendMessage(text);
    Future.delayed(100.ms, () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }
}
