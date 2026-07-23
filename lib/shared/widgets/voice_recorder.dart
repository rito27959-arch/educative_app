import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../core/models/mesh_message.dart';
import '../../core/services/storage_service.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/widgets/ouro_buttons.dart';

// ─────────────────────────────────────────────────────────────
//  VOICE RECORDER — bottom sheet d'enregistrement
// ─────────────────────────────────────────────────────────────

class RecordedAudio {
  final String path;
  final Uint8List bytes;
  final int durationSeconds;
  RecordedAudio({
    required this.path,
    required this.bytes,
    required this.durationSeconds,
  });
}

class VoiceRecorderSheet extends StatefulWidget {
  const VoiceRecorderSheet({super.key});

  static Future<RecordedAudio?> show(BuildContext context) {
    return showModalBottomSheet<RecordedAudio>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const VoiceRecorderSheet(),
    );
  }

  @override
  State<VoiceRecorderSheet> createState() => _VoiceRecorderSheetState();
}

class _VoiceRecorderSheetState extends State<VoiceRecorderSheet>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  String? _recordedPath;
  bool _isRecording = false;
  bool _isRecorded = false;
  bool _isPlaying = false;
  int _elapsedSeconds = 0;
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: 800.ms,
    )..repeat(reverse: true);
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    _player.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final min = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  Future<void> _startRecording() async {
    final ok = await _recorder.hasPermission();
    if (!ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission micro nécessaire')),
        );
      }
      return;
    }
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(
      RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
        numChannels: 1,
        autoGain: true,
        echoCancel: true,
        noiseSuppress: true,
      ),
      path: path,
    );
    setState(() {
      _isRecording = true;
      _recordedPath = path;
      _elapsedSeconds = 0;
    });
    _timer = Timer.periodic(1.seconds, (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
      _isRecorded = true;
      _recordedPath = path ?? _recordedPath;
    });
  }

  Future<void> _togglePlayback() async {
    if (_recordedPath == null) return;
    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      await _player.play(DeviceFileSource(_recordedPath!));
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _send() async {
    if (_recordedPath == null) return;
    final file = File(_recordedPath!);
    if (!await file.exists()) return;
    final bytes = await file.readAsBytes();
    if (mounted) {
      Navigator.of(context).pop(RecordedAudio(
        path: _recordedPath!,
        bytes: bytes,
        durationSeconds: _elapsedSeconds,
      ));
    }
  }

  void _cancel() {
    if (_recordedPath != null) {
      File(_recordedPath!).delete().ignore();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            decoration: BoxDecoration(
              color: OuroColors.surface.withValues(alpha: 0.95),
              border: Border(
                top: BorderSide(color: OuroColors.glassBorder, width: 0.5),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color: OuroColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enregistrement vocal',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: 200.ms,
                  child: Text(
                    _formattedTime,
                    key: ValueKey('timer_${_isRecorded}_$_elapsedSeconds'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _isRecorded ? 32 : 48,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _isRecorded
                      ? _togglePlayback
                      : (_isRecording ? _stopRecording : _startRecording),
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = _isRecording ? (1.0 + _pulseController.value * 0.2) : 1.0;
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecorded
                                ? (_isPlaying ? OuroColors.meshBlue : OuroColors.accentTeal)
                                : (_isRecording ? OuroColors.errorRed : OuroColors.meshBlue),
                            boxShadow: DesignTokens.glow(
                              _isRecorded
                                  ? (_isPlaying ? OuroColors.meshBlue : OuroColors.accentTeal)
                                  : (_isRecording ? OuroColors.errorRed : OuroColors.meshBlue),
                              radius: 20,
                            ),
                          ),
                          child: Icon(
                            _isRecorded
                                ? (_isPlaying ? Icons.pause : Icons.play_arrow)
                                : (_isRecording ? Icons.stop : Icons.mic),
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isRecorded
                      ? (_isPlaying ? 'Lecture en cours...' : 'Appuyez pour écouter')
                      : (_isRecording ? 'Appuyez pour arrêter' : 'Appuyez pour enregistrer'),
                  style: TextStyle(color: OuroColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 24),
                if (_isRecorded)
                  Row(
                    children: [
                      Expanded(
                        child: OuroButton(
                          label: 'Annuler',
                          variant: OuroButtonVariant.ghost,
                          onPressed: _cancel,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OuroButton(
                          label: 'Envoyer',
                          variant: OuroButtonVariant.primary,
                          onPressed: _send,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  AUDIO PLAYER WIDGET — pour les messages audio reçus
// ─────────────────────────────────────────────────────────────

class AudioMessagePlayer extends StatefulWidget {
  final MeshMessage message;
  const AudioMessagePlayer({super.key, required this.message});

  @override
  State<AudioMessagePlayer> createState() => _AudioMessagePlayerState();
}

class _AudioMessagePlayerState extends State<AudioMessagePlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _hasError = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initPlayer();
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
    _player.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });
    _player.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _duration = dur);
    });
  }

  Future<void> _initPlayer() async {
    try {
      final msg = widget.message;
      if (msg.fileId == null || msg.fileName == null) {
        setState(() { _isLoading = false; _hasError = true; });
        return;
      }
      final path = await StorageService.getSharedFilePath(msg.fileId!, msg.fileName!);
      if (path == null || !await File(path).exists()) {
        setState(() { _isLoading = false; _hasError = true; });
        return;
      }
      setState(() { _isLoading = false; });
    } catch (_) {
      setState(() { _isLoading = false; _hasError = true; });
    }
  }

  Future<void> _togglePlay() async {
    final msg = widget.message;
    if (msg.fileId == null || msg.fileName == null) return;

    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      final path = await StorageService.getSharedFilePath(msg.fileId!, msg.fileName!);
      if (path == null) return;
      await _player.play(DeviceFileSource(path));
      setState(() => _isPlaying = true);
    }
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes.toString().padLeft(2, '0');
    final sec = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 48,
        child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: OuroColors.meshBlue))),
      );
    }
    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: OuroColors.errorRed.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: OuroColors.errorRed, size: 18),
            const SizedBox(width: 8),
            const Text('Audio non disponible', style: TextStyle(color: OuroColors.errorRed, fontSize: 12)),
          ],
        ),
      );
    }
    final display = _isPlaying ? _position : _duration;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: OuroColors.glassBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OuroColors.glassBorder, width: 0.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: OuroColors.meshBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: OuroColors.meshBlue,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _formatDuration(display),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

bool isAudioMessage(MeshMessage msg) {
  if (msg.type == 'audio') return true;
  if (msg.type == 'file' && msg.fileMimeType != null) {
    final mime = msg.fileMimeType!.toLowerCase();
    return mime.contains('audio') || ['mp3', 'wav', 'ogg', 'aac', 'm4a'].any((e) => mime.contains(e));
  }
  return false;
}
