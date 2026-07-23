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

class ChapterCompleteScreen extends ConsumerStatefulWidget {
  final String subjectId;
  final String chapterId;

  const ChapterCompleteScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  @override
  ConsumerState<ChapterCompleteScreen> createState() =>
      _ChapterCompleteScreenState();
}

class _ChapterCompleteScreenState
    extends ConsumerState<ChapterCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleController;
  late List<_FloatingParticle> _particles;
  final _rng = Random();

  static const _particleColors = [
    OuroColors.meshBlue,
    OuroColors.ouroOrange,
    OuroColors.localGreen,
    OuroColors.accentPurple,
    OuroColors.accentPink,
  ];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _particles = List.generate(14, (_) {
      return _FloatingParticle(
        color: _particleColors[_rng.nextInt(_particleColors.length)],
        x: _rng.nextDouble(),
        startY: 1.0 + _rng.nextDouble() * 0.3,
        speed: 0.012 + _rng.nextDouble() * 0.018,
        drift: (_rng.nextDouble() - 0.5) * 0.008,
        size: 4 + _rng.nextDouble() * 6,
      );
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  String get _bossRoute =>
      '/curriculum/subject/${widget.subjectId}'
      '/chapter/${widget.chapterId}/boss-exam';

  @override
  Widget build(BuildContext context) {
    final chapter = CurriculumData.findChapterById(widget.chapterId);
    final chapterTitle = chapter?.title ?? '';

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        colors: const [
          Color(0xFF120A18),
          Color(0xFF080614),
          Color(0xFF0A0A1A),
        ],
        child: SafeArea(
          child: Stack(
            children: [
              _buildFloatingParticles(),
              Column(
                children: [
                  const Spacer(flex: 3),
                  _buildTrophy(),
                  const SizedBox(height: DesignTokens.grid3x),
                  _buildTitle(),
                  const SizedBox(height: DesignTokens.gridSm),
                  _buildChapterTitle(chapterTitle),
                  const SizedBox(height: DesignTokens.grid4x),
                  _buildBossFinalText(),
                  const SizedBox(height: DesignTokens.gridSm),
                  _buildBossSubtitle(),
                  const Spacer(flex: 2),
                  _buildLaunchButton(),
                  const SizedBox(height: DesignTokens.grid4x),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(
            particles: _particles,
            progress: _particleController.value,
          ),
        );
      },
    );
  }

  Widget _buildTrophy() {
    return const Text('🏆', style: TextStyle(fontSize: 80))
        .animate()
        .scale(
          duration: 800.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 400.ms);
  }

  Widget _buildTitle() {
    return Text(
      'CHAPITRE TERMINÉ !',
      textAlign: TextAlign.center,
      style: GoogleFonts.spaceGrotesk(
        color: OuroColors.textPrimary,
        fontSize: DesignTokens.text5xl,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 300.ms)
        .slideY(
          begin: 0.3,
          end: 0,
          duration: 600.ms,
          delay: 300.ms,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildChapterTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: OuroColors.textSecondary,
        fontSize: DesignTokens.textLg,
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 500.ms);
  }

  Widget _buildBossFinalText() {
    return _PulsingGlowText(
      text: 'BOSS FINAL DU CHAPITRE',
      style: GoogleFonts.spaceGrotesk(
        color: OuroColors.ouroOrange,
        fontSize: DesignTokens.text2xl,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 700.ms);
  }

  Widget _buildBossSubtitle() {
    return Text(
      'Prépare-toi pour le défi final !',
      style: TextStyle(
        color: OuroColors.textSecondary.withValues(alpha: 0.7),
        fontSize: DesignTokens.textMd,
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 900.ms);
  }

  Widget _buildLaunchButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: _PulsingGlowButton(
        onPressed: () => context.go(_bossRoute),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [OuroColors.ouroOrange, Color(0xFFFF1A6C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                'Lancer le Boss Final',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: DesignTokens.textXl,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 1100.ms).slideY(begin: 0.1);
  }
}

class _FloatingParticle {
  final Color color;
  final double x;
  final double startY;
  final double speed;
  final double drift;
  final double size;

  const _FloatingParticle({
    required this.color,
    required this.x,
    required this.startY,
    required this.speed,
    required this.drift,
    required this.size,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_FloatingParticle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.startY - progress * p.speed * 10) % 1.3;
      final x = (p.x + progress * p.drift * 10) % 1.0;
      final paint = Paint()..color = p.color.withValues(alpha: 0.35);
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _PulsingGlowText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _PulsingGlowText({required this.text, required this.style});

  @override
  State<_PulsingGlowText> createState() => _PulsingGlowTextState();
}

class _PulsingGlowTextState extends State<_PulsingGlowText>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final glow = 0.3 + _ctrl.value * 0.4;
        return Text(
          widget.text,
          textAlign: TextAlign.center,
          style: widget.style.copyWith(
            shadows: [
              Shadow(
                color: OuroColors.ouroOrange.withValues(alpha: glow),
                blurRadius: 20,
              ),
              Shadow(
                color: OuroColors.ouroOrange.withValues(alpha: glow * 0.5),
                blurRadius: 40,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PulsingGlowButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _PulsingGlowButton({required this.onPressed, required this.child});

  @override
  State<_PulsingGlowButton> createState() => _PulsingGlowButtonState();
}

class _PulsingGlowButtonState extends State<_PulsingGlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final glow = 0.2 + _ctrl.value * 0.25;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            boxShadow: [
              BoxShadow(
                color: OuroColors.ouroOrange.withValues(alpha: glow),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: GestureDetector(
            onTap: widget.onPressed,
            child: widget.child,
          ),
        );
      },
    );
  }
}
