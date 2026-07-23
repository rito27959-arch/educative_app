import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../core/providers/voice_coach_provider.dart';
import '../../core/models/african_language.dart';

class LiveVoiceCoachScreen extends ConsumerStatefulWidget {
  const LiveVoiceCoachScreen({super.key});

  @override
  ConsumerState<LiveVoiceCoachScreen> createState() => _LiveVoiceCoachScreenState();
}

class _LiveVoiceCoachScreenState extends ConsumerState<LiveVoiceCoachScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _ringCtrl;
  late AnimationController _particleCtrl;
  late AnimationController _breatheCtrl;

  final _scrollCtrl = ScrollController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: 2.seconds)..repeat(reverse: true);
    _ringCtrl = AnimationController(vsync: this, duration: 3.seconds)..repeat();
    _particleCtrl = AnimationController(vsync: this, duration: 4.seconds)..repeat();
    _breatheCtrl = AnimationController(vsync: this, duration: 4.seconds)..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(voiceCoachProvider.notifier).enterLiveMode();
      });
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _ringCtrl.dispose();
    _particleCtrl.dispose();
    _breatheCtrl.dispose();
    _scrollCtrl.dispose();
    ref.read(voiceCoachProvider.notifier).exitLiveMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceCoachProvider);
    final notifier = ref.read(voiceCoachProvider.notifier);

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: Stack(
        children: [
          _buildAnimatedBackground(state),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(state),
                const Spacer(flex: 2),
                _buildCenterSphere(state),
                _buildTranscription(state),
                const Spacer(flex: 1),
                _buildMessagePreview(state),
                _buildMicButton(state, notifier),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(VoiceCoachState state) {
    Color waveColor;
    switch (state.speakingState) {
      case CoachSpeakingState.listening:
        waveColor = OuroColors.meshBlue;
        break;
      case CoachSpeakingState.thinking:
        waveColor = OuroColors.accentPurple;
        break;
      case CoachSpeakingState.speaking:
        waveColor = OuroColors.localGreen;
        break;
      default:
        waveColor = OuroColors.meshBlue.withValues(alpha: 0.3);
    }

    return AnimatedBuilder(
      animation: _breatheCtrl,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              waveColor.withValues(alpha: 0.08 + _breatheCtrl.value * 0.04),
              OuroColors.background,
              OuroColors.background,
            ],
            radius: 1.2 + _breatheCtrl.value * 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(VoiceCoachState state) {
    String statusText;
    Color statusColor;
    switch (state.speakingState) {
      case CoachSpeakingState.listening:
        statusText = 'Écoute...';
        statusColor = OuroColors.meshBlue;
        break;
      case CoachSpeakingState.thinking:
        statusText = 'Réfléchit...';
        statusColor = OuroColors.accentPurple;
        break;
      case CoachSpeakingState.speaking:
        statusText = 'Parle...';
        statusColor = OuroColors.localGreen;
        break;
      default:
        statusText = 'Appuie pour parler';
        statusColor = OuroColors.textSecondary;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          const Spacer(),
          AnimatedContainer(
            duration: 400.ms,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, __) => Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor.withValues(
                        alpha: 0.6 + _pulseCtrl.value * 0.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildLanguageChip(state),
        ],
      ),
    );
  }

  Widget _buildLanguageChip(VoiceCoachState state) {
    return GestureDetector(
      onTap: () => _showLanguagePicker(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: OuroColors.glassBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: OuroColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, color: OuroColors.textSecondary, size: 14),
            const SizedBox(width: 4),
            Text(
              state.selectedLanguage.toUpperCase(),
              style: const TextStyle(
                color: OuroColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: OuroColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        final langs = AfricanLanguage.all;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: OuroColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Langue du coach',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ...langs.map((lang) => ListTile(
                leading: Icon(lang.icon, color: lang.color),
                title: Text(lang.nativeName, style: const TextStyle(color: Colors.white)),
                subtitle: Text(lang.region, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
                trailing: ref.watch(voiceCoachProvider).selectedLanguage == lang.code
                    ? const Icon(Icons.check_circle, color: OuroColors.meshBlue)
                    : null,
                onTap: () {
                  ref.read(voiceCoachProvider.notifier).setLanguage(lang.code);
                  context.pop();
                },
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCenterSphere(VoiceCoachState state) {
    Color primaryColor;
    switch (state.speakingState) {
      case CoachSpeakingState.listening:
        primaryColor = OuroColors.meshBlue;
        break;
      case CoachSpeakingState.thinking:
        primaryColor = OuroColors.accentPurple;
        break;
      case CoachSpeakingState.speaking:
        primaryColor = OuroColors.localGreen;
        break;
      default:
        primaryColor = OuroColors.meshBlue.withValues(alpha: 0.6);
    }

    return SizedBox(
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildRings(state, primaryColor),
          _buildGlow(state, primaryColor),
          _buildCoreSphere(state, primaryColor),
          if (state.speakingState == CoachSpeakingState.listening)
            _buildWaveformDots(primaryColor),
          if (state.speakingState == CoachSpeakingState.thinking)
            _buildThinkingDots(),
          if (state.speakingState == CoachSpeakingState.speaking)
            _buildSpeakingWaves(primaryColor),
        ],
      ),
    );
  }

  Widget _buildRings(VoiceCoachState state, Color color) {
    if (state.speakingState != CoachSpeakingState.listening &&
        state.speakingState != CoachSpeakingState.speaking) {
      return const SizedBox.shrink();
    }

    final ringCount = state.speakingState == CoachSpeakingState.listening ? 4 : 2;
    return AnimatedBuilder(
      animation: _ringCtrl,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(ringCount, (i) {
            final delay = i * 0.25;
            final phase = (_ringCtrl.value + delay) % 1.0;
            final scale = 0.6 + phase * 0.8;
            final opacity = (1.0 - phase) * 0.25;

            return Transform.scale(
              scale: scale,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withValues(alpha: opacity),
                    width: 1.5,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildGlow(VoiceCoachState state, Color color) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, __) {
        final pulse = _pulseCtrl.value;
        return Container(
          width: 180 + pulse * 40,
          height: 180 + pulse * 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15 + pulse * 0.15),
                blurRadius: 60 + pulse * 40,
                spreadRadius: 10 + pulse * 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCoreSphere(VoiceCoachState state, Color color) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, __) {
        final pulse = _pulseCtrl.value;
        return Container(
          width: 100 + pulse * (state.speakingState == CoachSpeakingState.listening ? 20 : 5),
          height: 100 + pulse * (state.speakingState == CoachSpeakingState.listening ? 20 : 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.9),
                color.withValues(alpha: 0.4),
                OuroColors.accentPurple.withValues(alpha: 0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3 + pulse * 0.2),
                blurRadius: 30 + pulse * 20,
              ),
            ],
          ),
          child: state.speakingState == CoachSpeakingState.idle
              ? Icon(Icons.mic, color: Colors.white.withValues(alpha: 0.6), size: 36)
              : null,
        );
      },
    );
  }

  Widget _buildWaveformDots(Color color) {
    return AnimatedBuilder(
      animation: _particleCtrl,
      builder: (_, __) {
        return CustomPaint(
          size: const Size(260, 260),
          painter: _WaveformPainter(
            phase: _particleCtrl.value,
            color: color,
          ),
        );
      },
    );
  }

  Widget _buildThinkingDots() {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final phase = (_pulseCtrl.value + delay) % 1.0;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 8 + phase * 6,
                height: 8 + phase * 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: OuroColors.accentPurple.withValues(alpha: 0.5 + phase * 0.5),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSpeakingWaves(Color color) {
    return AnimatedBuilder(
      animation: _particleCtrl,
      builder: (_, __) {
        return CustomPaint(
          size: const Size(260, 120),
          painter: _SpeakingWavePainter(
            phase: _particleCtrl.value,
            color: color,
          ),
        );
      },
    );
  }

  Widget _buildTranscription(VoiceCoachState state) {
    final text = state.interimText;
    if (text == null || text.isEmpty) return const SizedBox(height: 60);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: AnimatedSwitcher(
        duration: 300.ms,
        child: Text(
          text,
          key: ValueKey(text),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 16,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildMessagePreview(VoiceCoachState state) {
    final recentMsgs = state.messages.where((m) => !m.isUser).toList().reversed.take(2).toList().reversed.toList();
    if (recentMsgs.isEmpty) return const SizedBox.shrink();

    return Flexible(
      child: ListView.builder(
        controller: _scrollCtrl,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shrinkWrap: true,
        itemCount: recentMsgs.length,
        itemBuilder: (_, i) {
          final msg = recentMsgs[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: OuroColors.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.record_voice_over, color: OuroColors.meshBlue, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Coach',
                      style: TextStyle(color: OuroColors.textSecondary, fontSize: 11),
                    ),
                    if (msg.isStreaming) ...[
                      const SizedBox(width: 8),
                      _streamingIndicator(),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  msg.text,
                  style: TextStyle(color: OuroColors.textPrimary, fontSize: 14, height: 1.3),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _streamingIndicator() {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.15;
            final phase = (_pulseCtrl.value + delay) % 1.0;
            return Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: OuroColors.localGreen.withValues(alpha: 0.3 + phase * 0.7),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildMicButton(VoiceCoachState state, VoiceCoachNotifier notifier) {
    final isActive = state.speakingState == CoachSpeakingState.listening;

    return GestureDetector(
      onTap: () => notifier.toggleListening(),
      child: AnimatedBuilder(
        animation: _pulseCtrl,
        builder: (_, __) {
          final pulse = _pulseCtrl.value;
          return Container(
            width: 72 + (isActive ? pulse * 12 : 0),
            height: 72 + (isActive ? pulse * 12 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isActive
                  ? LinearGradient(
                      colors: [
                        OuroColors.meshBlue.withValues(alpha: 0.8),
                        OuroColors.meshBlue.withValues(alpha: 0.4),
                      ],
                    )
                  : OuroColors.brandGradient,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: OuroColors.meshBlue.withValues(alpha: 0.3 + pulse * 0.3),
                        blurRadius: 20 + pulse * 15,
                        spreadRadius: 5 + pulse * 10,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: OuroColors.meshBlue.withValues(alpha: 0.2),
                        blurRadius: 15,
                      ),
                    ],
            ),
            child: Icon(
              isActive ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: isActive ? 28 : 30,
            ),
          );
        },
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double phase;
  final Color color;

  _WaveformPainter({required this.phase, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = 20;
    final baseRadius = 55.0;

    for (var i = 0; i <= points; i++) {
      final angle = (i / points) * 2 * pi;
      final wave = sin(angle * 3 + phase * 2 * pi) * 15 +
          sin(angle * 5 + phase * 3 * pi) * 8;
      final radius = baseRadius + wave + 15 * sin(angle + phase * 2 * pi);

      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    final path2 = Path();
    for (var i = 0; i <= points; i++) {
      final angle = (i / points) * 2 * pi;
      final wave = sin(angle * 4 + phase * 2.5 * pi) * 12 +
          cos(angle * 6 + phase * 2 * pi) * 6;
      final radius = baseRadius + 25 + wave + 10 * cos(angle + phase * 1.5 * pi);

      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path2.moveTo(x, y);
      } else {
        path2.lineTo(x, y);
      }
    }
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter old) => old.phase != phase;
}

class _SpeakingWavePainter extends CustomPainter {
  final double phase;
  final Color color;

  _SpeakingWavePainter({required this.phase, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, centerY);

    for (var x = 0.0; x <= size.width; x++) {
      final wave = sin((x / size.width) * 4 * pi + phase * 2 * pi) * 20 +
          sin((x / size.width) * 8 * pi + phase * 3 * pi) * 10 +
          sin((x / size.width) * 2 * pi + phase * pi) * 5;
      path.lineTo(x, centerY + wave);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final path2 = Path();
    path2.moveTo(0, centerY + 15);
    for (var x = 0.0; x <= size.width; x++) {
      final wave = cos((x / size.width) * 3 * pi + phase * 1.8 * pi) * 15 +
          cos((x / size.width) * 7 * pi + phase * 2.5 * pi) * 8;
      path2.lineTo(x, centerY + 15 + wave);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _SpeakingWavePainter old) => old.phase != phase;
}
