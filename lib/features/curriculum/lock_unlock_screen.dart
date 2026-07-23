import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/data/curriculum_data.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';

enum LockUnlockPhase { initial, keyApproach, shatter, unlocked, transitioning }

class LockUnlockScreen extends ConsumerStatefulWidget {
  final String subjectId;
  final String chapterId;

  const LockUnlockScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  String get chapterTitle {
    final chapter = CurriculumData.findChapterById(chapterId);
    return chapter?.title ?? 'Chapitre';
  }

  @override
  ConsumerState<LockUnlockScreen> createState() => _LockUnlockScreenState();
}

class _LockUnlockScreenState extends ConsumerState<LockUnlockScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  LockUnlockPhase _phase = LockUnlockPhase.initial;
  final _rng = Random();
  late List<_ShatterPiece> _pieces;
  late List<_Sparkle> _sparkles;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _pieces = List.generate(8, (i) {
      final angle = (i / 8) * 2 * pi + _rng.nextDouble() * 0.5;
      return _ShatterPiece(
        endOffset: Offset(cos(angle) * (150 + _rng.nextDouble() * 100), sin(angle) * (150 + _rng.nextDouble() * 100)),
        rotation: _rng.nextDouble() * 4 - 2,
        color: [
          Color(0xFF8A8A9A),
          Color(0xFF6E6E82),
          Color(0xFF9E9EB0),
          Color(0xFF7A7A8E),
        ][i % 4],
      );
    });

    _sparkles = List.generate(16, (i) {
      final angle = _rng.nextDouble() * 2 * pi;
      final dist = 60 + _rng.nextDouble() * 120;
      return _Sparkle(
        endOffset: Offset(cos(angle) * dist, sin(angle) * dist),
        delay: _rng.nextDouble() * 300,
        size: 4 + _rng.nextDouble() * 6,
        color: [
          OuroColors.localGreen,
          OuroColors.meshBlue,
          const Color(0xFFFFD700),
        ][_rng.nextInt(3)],
      );
    });

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // Phase 1: initial (0-0.5s)
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _phase = LockUnlockPhase.keyApproach);

    // Phase 2: key approach (0.5-1.5s)
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    _shakeController.forward(from: 0);
    setState(() => _phase = LockUnlockPhase.shatter);

    // Phase 3: shatter (1.5-3s)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    _pulseController.repeat(reverse: true);
    setState(() => _phase = LockUnlockPhase.unlocked);

    // Phase 4: unlocked (3-4s)
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _phase = LockUnlockPhase.transitioning);

    // Phase 5: transition (4-5s)
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    context.go('/curriculum/subject/${widget.subjectId}/chapter/${widget.chapterId}/intro');
  }

  @override
  void dispose() {
    _mainController.dispose();
    _shakeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        colors: const [
          Color(0xFF0A0812),
          Color(0xFF080614),
          Color(0xFF0A0A1A),
        ],
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLockArea(),
                    const SizedBox(height: DesignTokens.grid4x),
                    _buildUnlockedText(),
                  ],
                ),
              ),
              if (_phase == LockUnlockPhase.shatter ||
                  _phase == LockUnlockPhase.unlocked)
                ..._buildSparkles(),
              _buildFlashOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockArea() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Chapter node icon
          _buildChapterNode(),

          // Padlock (before shatter)
          if (_phase == LockUnlockPhase.initial ||
              _phase == LockUnlockPhase.keyApproach)
            _buildPadlock(),

          // Key (during keyApproach)
          if (_phase == LockUnlockPhase.keyApproach)
            _buildKey(),

          // Shatter pieces
          if (_phase == LockUnlockPhase.shatter)
            ..._buildShatterPieces(),
        ],
      ),
    );
  }

  Widget _buildChapterNode() {
    final glowIntensity = _phase == LockUnlockPhase.unlocked ? 0.8 : 0.3;
    final nodeColor = _phase == LockUnlockPhase.unlocked
        ? OuroColors.localGreen
        : OuroColors.meshBlue;

    return AnimatedBuilder(
      animation: _phase == LockUnlockPhase.unlocked ? _pulseController : AlwaysStoppedAnimation(0),
      builder: (context, child) {
        final pulse = _phase == LockUnlockPhase.unlocked
            ? 1.0 + _pulseController.value * 0.08
            : 1.0;
        final glow = _phase == LockUnlockPhase.unlocked
            ? glowIntensity + _pulseController.value * 0.3
            : glowIntensity;

        return Transform.scale(
          scale: pulse,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  nodeColor.withValues(alpha: 0.3),
                  nodeColor.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: nodeColor.withValues(alpha: glow),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: nodeColor,
              size: 48,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPadlock() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      top: _phase == LockUnlockPhase.keyApproach ? 10 : 20,
      child: Container(
        width: 80,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFB0B0C0), Color(0xFF808090), Color(0xFFA0A0B0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Lock shackle
            Positioned(
              top: 8,
              child: Container(
                width: 40,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF909098),
                    width: 8,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
              ),
            ),
            // Lock body
            Positioned(
              bottom: 15,
              child: Container(
                width: 36,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF606070),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock,
                    color: Color(0xFFD0D0D8),
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate(
        onPlay: (c) => _phase == LockUnlockPhase.initial ? c.repeat(reverse: true) : null,
      ).then(delay: 2000.ms).fadeIn(duration: 400.ms).scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1.0, 1.0),
        duration: 400.ms,
        curve: Curves.easeOutBack,
      ),
    );
  }

  Widget _buildKey() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      right: -20,
      top: 40,
      child: const Icon(
        Icons.key,
        color: Color(0xFFFFD700),
        size: 50,
      ).animate().fadeIn(duration: 200.ms).then(delay: 600.ms).slideX(
        begin: 1.5,
        end: -0.8,
        duration: 600.ms,
        curve: Curves.easeInBack,
      ),
    );
  }

  List<Widget> _buildShatterPieces() {
    return _pieces.asMap().entries.map((entry) {
      final i = entry.key;
      final piece = entry.value;
      return AnimatedPositioned(
        duration: Duration(milliseconds: 600 + i * 50),
        curve: Curves.easeOutCubic,
        left: 60 + piece.endOffset.dx * 0.3,
        top: 40 + piece.endOffset.dy * 0.3,
        child: AnimatedOpacity(
          opacity: 0.0,
          duration: Duration(milliseconds: 800 + i * 50),
          child: Transform.rotate(
            angle: piece.rotation,
            child: Container(
              width: 16 + _rng.nextDouble() * 12,
              height: 16 + _rng.nextDouble() * 12,
              decoration: BoxDecoration(
                color: piece.color,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: piece.color.withValues(alpha: 0.3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildSparkles() {
    return _sparkles.map((s) {
      return Positioned(
        left: 100 + s.endOffset.dx,
        top: 80 + s.endOffset.dy,
        child: Icon(
          Icons.star,
          color: s.color,
          size: s.size,
        ).animate(
          delay: Duration(milliseconds: s.delay.toInt()),
        ).fadeIn(duration: 200.ms).then(delay: 300.ms).fadeOut(duration: 400.ms),
      );
    }).toList();
  }

  Widget _buildFlashOverlay() {
    return AnimatedOpacity(
      opacity: _phase == LockUnlockPhase.shatter ? 0.5 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget _buildUnlockedText() {
    if (_phase != LockUnlockPhase.unlocked &&
        _phase != LockUnlockPhase.transitioning) {
      return const SizedBox(height: 80);
    }

    return Column(
      children: [
        Text(
          'Chapitre débloqué ! ✨',
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            color: OuroColors.textPrimary,
            fontSize: DesignTokens.text3xl,
            fontWeight: FontWeight.w800,
          ),
        ).animate().scale(
          duration: 600.ms,
          curve: Curves.elasticOut,
        ).fadeIn(duration: 300.ms),
        const SizedBox(height: DesignTokens.gridSm),
        Text(
          widget.chapterTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: OuroColors.textSecondary,
            fontSize: DesignTokens.textLg,
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
      ],
    );
  }
}

class _ShatterPiece {
  final Offset endOffset;
  final double rotation;
  final Color color;

  const _ShatterPiece({
    required this.endOffset,
    required this.rotation,
    required this.color,
  });
}

class _Sparkle {
  final Offset endOffset;
  final double delay;
  final double size;
  final Color color;

  const _Sparkle({
    required this.endOffset,
    required this.delay,
    required this.size,
    required this.color,
  });
}
