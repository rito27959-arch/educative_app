import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../core/providers/mesh_provider.dart';
import '../../core/models/mesh_message.dart';

class VoiceCallScreen extends ConsumerStatefulWidget {
  final String? peerId;
  final String? peerPseudo;

  const VoiceCallScreen({super.key, this.peerId, this.peerPseudo});

  @override
  ConsumerState<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends ConsumerState<VoiceCallScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late AnimationController _audioLevelController;
  final List<double> _audioLevels = List.generate(40, (_) => 0);

  bool _isRecording = false;
  bool _isScreenSharing = false;
  double _callDuration = 0;
  List<double> _recentLatencies = [];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(vsync: this, duration: 2.seconds)..repeat();
    _pulseController = AnimationController(vsync: this, duration: 3.seconds)..repeat(reverse: true);
    _audioLevelController = AnimationController(vsync: this, duration: 0.5.seconds)..repeat();
    _audioLevelController.addListener(() => _updateAudioLevels());
    _startCallTimer();

    // Démarrer l'appel si peerId fourni ET pas déjà actif (ex: destinataire)
    final peerId = widget.peerId;
    final peerPseudo = widget.peerPseudo;
    debugPrint('[VoiceCallScreen] initState peerId=$peerId peerPseudo=$peerPseudo');
    if (peerId != null && peerPseudo != null) {
      final call = ref.read(callProvider);
      if (!call.isCallActive) {
        Future.microtask(() {
          debugPrint('[VoiceCallScreen] startCall microtask');
          ref.read(callProvider.notifier).startCall(peerId, peerPseudo);
        });
      }
    }
  }

  void _updateAudioLevels() {
    if (!mounted) return;
    setState(() {
      final baseLevel = ref.read(callProvider).audioLevel;
      for (int i = 0; i < _audioLevels.length; i++) {
        _audioLevels[i] = baseLevel.clamp(0.0, 1.0) *
            (0.5 + 0.5 * sin(_audioLevelController.value * 4 * pi + i * 0.3));
      }
    });
  }

  void _startCallTimer() {
    Future.doWhile(() async {
      await Future.delayed(1.seconds);
      if (mounted) {
        setState(() => _callDuration += 1);
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    _audioLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final call = ref.watch(callProvider);
    final unreachable = widget.peerId != null &&
        !ref.read(callProvider.notifier).canCallPeer(widget.peerId!);

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(call, unreachable),
                _buildCallTimer(),
                const Spacer(),
                call.isVideoEnabled ? _buildVideoView() : _buildAvatar(call),
                const Spacer(),
                _buildAudioVisualizer(),
                const SizedBox(height: 16),
                _buildConnectionQuality(call),
                const SizedBox(height: 16),
                _buildCallInfo(call),
                const SizedBox(height: 16),
                _buildExtraControls(call),
                const SizedBox(height: 16),
                if (unreachable)
                  _buildUnreachableBanner()
                else
                  _buildControls(call),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnreachableBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: OuroColors.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: OuroColors.errorRed.withValues(alpha: 0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off, color: OuroColors.errorRed, size: 16),
          SizedBox(width: 8),
          Text(
            'Appel disponible uniquement sur le même Wi-Fi',
            style: TextStyle(color: OuroColors.errorRed, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _CallBackgroundPainter(
            pulse: _pulseController.value,
            primaryColor: OuroColors.meshBlue,
          ),
        );
      },
    );
  }

  Widget _buildHeader(CallState call, bool unreachable) {
    final isConnected = call.connectionState == CallConnectionState.connected;
    final qualityColor = isConnected ? OuroColors.localGreen : OuroColors.textSecondary;
    final hopCount = call.hopCount;

    return Padding(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              ref.read(callProvider.notifier).hangUp();
              context.go('/k');
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: OuroColors.glassBorder),
              ),
              child: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 22),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: qualityColor,
                      boxShadow: [
                        BoxShadow(
                          color: qualityColor.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${call.latencyMs}ms',
                    style: TextStyle(color: qualityColor, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (unreachable)
                const Text(
                  'Non joignable',
                  style: TextStyle(color: OuroColors.errorRed, fontSize: 12),
                )
              else
                Text(
                  '$hopCount sauts Mesh',
                  style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12),
                ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: OuroColors.localGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: OuroColors.localGreen.withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, color: OuroColors.localGreen, size: 12),
                SizedBox(width: 4),
                Text('Chiffré P2P', style: TextStyle(color: OuroColors.localGreen, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -20, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildAvatar(CallState call) {
    final connectionStatus = _connectionStatusText(call.connectionState);
    final statusColor = _connectionStatusColor(call.connectionState);

    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final isActive = call.isCallActive;
            return Container(
              width: 140 + _pulseController.value * 20,
              height: 140 + _pulseController.value * 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isActive
                      ? [OuroColors.meshBlue, OuroColors.meshBlueGradientEnd]
                      : [OuroColors.glassBg, OuroColors.cardDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: OuroColors.meshBlue.withValues(alpha: 0.3 + _pulseController.value * 0.2),
                          blurRadius: 60 + _pulseController.value * 30,
                          spreadRadius: 20 + _pulseController.value * 10,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  call.peerPseudo?.isNotEmpty == true ? call.peerPseudo![0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w700),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          call.peerPseudo ?? 'Appel P2P',
          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1 + _pulseController.value * 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    connectionStatus,
                    style: TextStyle(color: statusColor, fontSize: 13),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).scaleXY(begin: 0.7, end: 1, duration: 600.ms, delay: 200.ms, curve: Curves.easeOutBack);
  }

  Widget _buildVideoView() {
    final remoteRenderer = ref.read(callProvider.notifier).remoteRenderer;
    final localRenderer = ref.read(callProvider.notifier).localRenderer;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (remoteRenderer != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: RTCVideoView(
              remoteRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              mirror: false,
            ),
          )
        else
          _buildAvatar(ref.watch(callProvider)),
        if (localRenderer != null)
          Positioned(
            top: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 100,
                height: 140,
                child: RTCVideoView(
                  localRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  mirror: true,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _connectionStatusText(CallConnectionState state) {
    switch (state) {
      case CallConnectionState.connecting:
        return 'Connexion en cours...';
      case CallConnectionState.connected:
        return 'Appel actif • ${_formatDuration(_callDuration)}';
      case CallConnectionState.failed:
        return 'Échec de l\'appel';
      case CallConnectionState.disconnected:
        return 'Appel terminé';
    }
  }

  Color _connectionStatusColor(CallConnectionState state) {
    switch (state) {
      case CallConnectionState.connecting:
        return OuroColors.ouroOrange;
      case CallConnectionState.connected:
        return OuroColors.localGreen;
      case CallConnectionState.failed:
        return OuroColors.errorRed;
      case CallConnectionState.disconnected:
        return OuroColors.textSecondary;
    }
  }

  Widget _buildAudioVisualizer() {
    return SizedBox(
      height: 60,
      child: AnimatedBuilder(
        animation: _audioLevelController,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(double.infinity, 60),
            painter: _AudioVisualizerPainter(
              levels: _audioLevels,
              color: OuroColors.meshBlue,
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _buildCallInfo(CallState call) {
    final latency = call.latencyMs;
    final hopCount = call.hopCount;
    final bitrate = '${(20 + latency % 10).toStringAsFixed(1)} Mbps';

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      borderRadius: 24,
      opacity: 0.08,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _infoItem('Latence', '${latency}ms', OuroColors.meshBlue),
          Container(width: 1, height: 24, color: OuroColors.glassBorder),
          _infoItem('Sauts', '$hopCount', OuroColors.ouroOrange),
          Container(width: 1, height: 24, color: OuroColors.glassBorder),
          _infoItem('Débit', bitrate, OuroColors.localGreen),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 450.ms);
  }

  Widget _infoItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildControls(CallState call) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: OuroColors.cardDark,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: OuroColors.glassBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _controlButton(
            icon: call.isMuted ? Icons.mic_off : Icons.mic,
            color: call.isMuted ? OuroColors.errorRed : OuroColors.textSecondary,
            label: call.isMuted ? 'Unmute' : 'Mute',
            onTap: () => ref.read(callProvider.notifier).toggleMute(),
          ),
          _controlButton(
            icon: call.isSpeakerOn ? Icons.volume_up : Icons.volume_down,
            color: call.isSpeakerOn ? OuroColors.meshBlue : OuroColors.textSecondary,
            label: call.isSpeakerOn ? 'Speaker' : 'Casque',
            onTap: () => ref.read(callProvider.notifier).toggleSpeaker(),
          ),
          _controlButton(
            icon: Icons.call_end,
            color: OuroColors.errorRed,
            label: 'Raccrocher',
            isDestructive: true,
            onTap: () {
              ref.read(callProvider.notifier).hangUp();
              context.go('/k');
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 500.ms).slideY(begin: 30, end: 0, duration: 500.ms, delay: 500.ms, curve: Curves.easeOutCubic);
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isDestructive ? 18 : 14),
            decoration: BoxDecoration(
              color: isDestructive
                  ? color.withValues(alpha: 0.15)
                  : color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(isDestructive ? 24 : 18),
              border: Border.all(
                color: color.withValues(alpha: isDestructive ? 0.3 : 0.2),
                width: isDestructive ? 2 : 0.5,
              ),
              boxShadow: isDestructive
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ]
                  : [],
            ),
            child: Icon(icon, color: color, size: isDestructive ? 28 : 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 10)),
        ],
      ),
    );
  }

  String _formatDuration(double seconds) {
    final min = (seconds / 60).floor();
    final sec = (seconds % 60).floor();
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  Widget _buildCallTimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: OuroColors.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OuroColors.glassBorder, width: 0.3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, color: OuroColors.meshBlue.withValues(alpha: 0.6), size: 14),
                const SizedBox(width: 6),
                Text(
                  _formatDuration(_callDuration),
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildConnectionQuality(CallState call) {
    final avgLatency = _recentLatencies.isEmpty
        ? call.latencyMs.toDouble()
        : _recentLatencies.reduce((a, b) => a + b) / _recentLatencies.length;
    final isGood = avgLatency < 80;

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      borderRadius: 20,
      opacity: 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isGood ? Icons.wifi : Icons.wifi_off,
            color: isGood ? OuroColors.localGreen : OuroColors.ouroOrange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            isGood ? 'Excellente connexion' : 'Connexion instable',
            style: TextStyle(
              color: isGood ? OuroColors.localGreen : OuroColors.ouroOrange,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${avgLatency.toInt()}ms',
              style: const TextStyle(color: OuroColors.textSecondary, fontSize: 10),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 350.ms);
  }

  Widget _buildExtraControls(CallState call) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: OuroColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: OuroColors.glassBorder, width: 0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _extraButton(Icons.videocam, call.isVideoEnabled, OuroColors.meshBlue, () {
            ref.read(callProvider.notifier).toggleVideo();
          }),
          _extraButton(Icons.mic, _isRecording, OuroColors.ouroOrange, () {
            setState(() => _isRecording = !_isRecording);
          }),
          _extraButton(Icons.screen_share, _isScreenSharing, OuroColors.localGreen, () {
            setState(() => _isScreenSharing = !_isScreenSharing);
          }),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 480.ms);
  }

  Widget _extraButton(IconData icon, bool isActive, Color color, VoidCallback onTap, {bool enabled = true}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: enabled && isActive ? color.withValues(alpha: 0.15) : OuroColors.glassBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled && isActive ? color.withValues(alpha: 0.3) : OuroColors.glassBorder,
          ),
        ),
        child: Icon(
          icon,
          color: enabled
              ? (isActive ? color : OuroColors.textSecondary)
              : OuroColors.textSecondary.withValues(alpha: 0.3),
          size: 20,
        ),
      ),
    );
  }
}

class _CallBackgroundPainter extends CustomPainter {
  final double pulse;
  final Color primaryColor;

  _CallBackgroundPainter({required this.pulse, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 5; i++) {
      final radius = 80 + i * 50 + pulse * 30;
      final paint = Paint()
        ..color = primaryColor.withValues(alpha: 0.04 - i * 0.007)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 - i * 0.2;

      final dashPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
      canvas.drawPath(dashPath, paint);
    }

    for (int i = 0; i < 8; i++) {
      final angle = i * (2 * pi / 8) + pulse * 0.5;
      final linePaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.03)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;

      canvas.drawLine(
        center,
        Offset(
          center.dx + (80 + pulse * 20) * cos(angle),
          center.dy + (80 + pulse * 20) * sin(angle),
        ),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CallBackgroundPainter oldDelegate) =>
      oldDelegate.pulse != pulse;
}

class _AudioVisualizerPainter extends CustomPainter {
  final List<double> levels;
  final Color color;

  _AudioVisualizerPainter({required this.levels, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / levels.length;
    final centerY = size.height / 2;

    for (int i = 0; i < levels.length; i++) {
      final barHeight = levels[i] * size.height * 0.8;
      final x = i * barWidth;

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.4),
          ],
        ).createShader(Rect.fromLTWH(x, centerY - barHeight / 2, barWidth - 2, barHeight));

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, centerY - barHeight / 2, barWidth - 2, barHeight),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AudioVisualizerPainter oldDelegate) =>
      oldDelegate.levels != levels;
}
