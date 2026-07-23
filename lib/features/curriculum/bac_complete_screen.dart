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
import '../../design_system/widgets/ouro_animations.dart';

class BacCompleteScreen extends ConsumerStatefulWidget {
  final String subjectId;
  final int score;
  final int totalQuestions;

  const BacCompleteScreen({
    super.key,
    required this.subjectId,
    required this.score,
    required this.totalQuestions,
  });

  @override
  ConsumerState<BacCompleteScreen> createState() => _BacCompleteScreenState();
}

class _BacCompleteScreenState extends ConsumerState<BacCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _confettiController;
  late List<_ConfettiDot> _confettiDots;
  final _rng = Random();

  static const _confettiColors = [
    OuroColors.meshBlue,
    OuroColors.ouroOrange,
    OuroColors.localGreen,
    OuroColors.accentPurple,
    OuroColors.accentPink,
    Color(0xFFFFD700),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _confettiDots = List.generate(28, (_) {
      return _ConfettiDot(
        color: _confettiColors[_rng.nextInt(_confettiColors.length)],
        startX: _rng.nextDouble(),
        startY: -0.1 - _rng.nextDouble() * 0.4,
        fallSpeed: 0.015 + _rng.nextDouble() * 0.02,
        drift: (_rng.nextDouble() - 0.5) * 0.012,
        size: 3 + _rng.nextDouble() * 5,
        wobbleAmp: 0.005 + _rng.nextDouble() * 0.01,
        wobbleFreq: 2 + _rng.nextInt(3),
      );
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  double get _percentage =>
      widget.totalQuestions > 0
          ? (widget.score / widget.totalQuestions) * 100
          : 0;

  String get _mention {
    if (_percentage >= 90) return 'Très Bien 🏆';
    if (_percentage >= 75) return 'Bien 🌟';
    if (_percentage >= 60) return 'Assez Bien 👍';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final subject = CurriculumData.findById(widget.subjectId);
    final subjectName = subject?.title ?? '';
    final coefficient = subject?.coefficient ?? 0;

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        colors: const [
          Color(0xFF0E0A1A),
          Color(0xFF060814),
          Color(0xFF0A061A),
        ],
        child: SafeArea(
          child: Stack(
            children: [
              _buildConfettiRain(),
              Column(
                children: [
                  const Spacer(flex: 3),
                  _buildGradIcon(),
                  const SizedBox(height: DesignTokens.grid3x),
                  _buildFelicitationTitle(),
                  const SizedBox(height: DesignTokens.gridSm),
                  _buildSubjectText(subjectName),
                  const SizedBox(height: DesignTokens.grid3x),
                  _buildScoreCard(),
                  if (_mention.isNotEmpty) ...[
                    const SizedBox(height: DesignTokens.grid2x),
                    _buildMentionBadge(),
                  ],
                  if (coefficient > 0) ...[
                    const SizedBox(height: DesignTokens.gridSm),
                    _buildCoefficientBadge(coefficient),
                  ],
                  const Spacer(flex: 2),
                  _buildContinueButton(),
                  const SizedBox(height: DesignTokens.grid4x),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfettiRain() {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(
            dots: _confettiDots,
            progress: _confettiController.value,
          ),
        );
      },
    );
  }

  Widget _buildGradIcon() {
    return const Text('🎓', style: TextStyle(fontSize: 80))
        .animate()
        .scale(
          duration: 800.ms,
          curve: Curves.elasticOut,
          delay: 100.ms,
        )
        .fadeIn(duration: 500.ms);
  }

  Widget _buildFelicitationTitle() {
    return Text(
      'FÉLICITATIONS !',
      textAlign: TextAlign.center,
      style: GoogleFonts.spaceGrotesk(
        color: OuroColors.textPrimary,
        fontSize: DesignTokens.text7xl,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
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

  Widget _buildSubjectText(String subjectName) {
    return Text(
      'Tu as réussi l\'examen de $subjectName !',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: OuroColors.textSecondary,
        fontSize: DesignTokens.textLg,
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 500.ms);
  }

  Widget _buildScoreCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignTokens.grid4x),
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      decoration: BoxDecoration(
        color: OuroColors.glassBgStrong,
        borderRadius: BorderRadius.circular(DesignTokens.radius2xl),
        border: Border.all(
          color: OuroColors.localGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          OuroCountUp(
            value: widget.score,
            suffix: ' / ${widget.totalQuestions}',
            style: GoogleFonts.spaceGrotesk(
              color: OuroColors.localGreen,
              fontSize: DesignTokens.text8xl,
              fontWeight: FontWeight.w800,
            ),
          ).animate().scale(
                duration: 600.ms,
                delay: 400.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: DesignTokens.gridSm),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: OuroColors.localGreen.withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: Text(
              '${_percentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: OuroColors.localGreen,
                fontSize: DesignTokens.text2xl,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildMentionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.3),
            blurRadius: 16,
          ),
        ],
      ),
      child: Text(
        'Mention $_mention',
        style: GoogleFonts.spaceGrotesk(
          color: Colors.white,
          fontSize: DesignTokens.textLg,
          fontWeight: FontWeight.w700,
        ),
      ),
    )
        .animate()
        .scale(
          duration: 600.ms,
          delay: 800.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 400.ms, delay: 800.ms);
  }

  Widget _buildCoefficientBadge(int coefficient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: OuroColors.meshBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        border: Border.all(
          color: OuroColors.meshBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        'Coefficient $coefficient',
        style: const TextStyle(
          color: OuroColors.meshBlue,
          fontSize: DesignTokens.textSm,
          fontWeight: FontWeight.w600,
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 1000.ms);
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GestureDetector(
        onTap: () => context.go('/curriculum'),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: OuroColors.successGradient,
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            boxShadow: [
              BoxShadow(
                color: OuroColors.localGreen.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(
                'Continuer',
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
    ).animate().fadeIn(duration: 400.ms, delay: 1200.ms).slideY(begin: 0.1);
  }
}

class _ConfettiDot {
  final Color color;
  final double startX;
  final double startY;
  final double fallSpeed;
  final double drift;
  final double size;
  final double wobbleAmp;
  final int wobbleFreq;

  const _ConfettiDot({
    required this.color,
    required this.startX,
    required this.startY,
    required this.fallSpeed,
    required this.drift,
    required this.size,
    required this.wobbleAmp,
    required this.wobbleFreq,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiDot> dots;
  final double progress;

  _ConfettiPainter({required this.dots, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final d in dots) {
      final t = progress;
      final y = (d.startY + t * d.fallSpeed * 10) % 1.2;
      final wobble = sin(t * pi * d.wobbleFreq) * d.wobbleAmp;
      final x = (d.startX + t * d.drift * 10 + wobble) % 1.0;

      final paint = Paint()..color = d.color.withValues(alpha: 0.5);
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        d.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
