import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/ouro_colors.dart';
import '../../core/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _logoController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: 4.seconds,
    )..repeat();
    _logoController = AnimationController(
      vsync: this,
      duration: 1.5.seconds,
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: 2.seconds,
    )..repeat(reverse: true);
    _startSequence();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _logoController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startSequence() async {
    await Future.delayed(800.ms);
    _logoController.forward();
    await Future.delayed(2.2.seconds);
    if (!mounted) return;
    if (!StorageService.isOnboardingComplete()) {
      context.go('/onboarding');
    } else {
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OuroColors.background,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          _buildParticleField(),
          _buildDecorativeRing(),
          _buildDecorativeRing2(),
          _buildGlowDots(),
          _buildTagline(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNexoraLogo(),
                const SizedBox(height: 24),
                _buildOuroLogo(),
                const SizedBox(height: 40),
                _buildLoader(),
                const SizedBox(height: 24),
                _buildSecondLoader(),
              ],
            ),
          ),
          _buildVersionBadge(),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: _SplashNetworkNodes(controller: _logoController).animate().fadeIn(duration: 1000.ms, delay: 400.ms),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: _buildBottomInfo(),
          ),
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: _SplashFooterWidget(),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: _SplashVersionInfo().animate().fadeIn(duration: 1000.ms, delay: 1500.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return _TechCreditsWidget().animate().fadeIn(
      duration: 800.ms,
      delay: 1200.ms,
    );
  }

  Widget _buildSecondLoader() {
    return _SplashLoadingBar(controller: _logoController);
  }

  Widget _buildDecorativeRing() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          right: -30,
          child: Container(
            width: 80 + _pulseController.value * 20,
            height: 80 + _pulseController.value * 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: OuroColors.meshBlue.withValues(alpha: 0.04),
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDecorativeRing2() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Positioned(
          bottom: MediaQuery.of(context).size.height * 0.15,
          left: -40,
          child: Container(
            width: 120 + _pulseController.value * 30,
            height: 120 + _pulseController.value * 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: OuroColors.ouroOrange.withValues(alpha: 0.03),
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlowDots() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          children: List.generate(6, (i) {
            final angle = (i / 6) * 2 * pi;
            final dist = 120 + _pulseController.value * 30;
            final x = MediaQuery.of(context).size.width / 2 + dist * cos(angle) - 3;
            final y = MediaQuery.of(context).size.height / 2 + dist * sin(angle) - 3;
            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: OuroColors.meshBlue.withValues(
                    alpha: 0.1 + _pulseController.value * 0.1,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildTagline() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 0,
      right: 0,
      child: Text(
        'APPRENDRE • PARTAGER • GRANDIR',
        style: TextStyle(
          color: OuroColors.textSecondary.withValues(alpha: 0.15),
          fontSize: 9,
          letterSpacing: 4,
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _SplashBackgroundPainter(
            pulse: _pulseController.value,
          ),
        );
      },
    );
  }

  Widget _buildParticleField() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticleFieldPainter(
            time: _particleController.value,
          ),
        );
      },
    );
  }

  Widget _buildNexoraLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoController.value < 0.6
              ? 1 - _logoController.value / 0.6
              : 0,
          child: Transform.scale(
            scale: _logoController.value < 0.6
                ? 1
                : 1 + (_logoController.value - 0.6) * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: OuroColors.meshBlue.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: OuroColors.meshBlue.withValues(alpha: 0.15),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.change_history_rounded,
                      color: OuroColors.meshBlue,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'NEXORA STUDIO',
                  style: TextStyle(
                    color: OuroColors.textSecondary.withValues(alpha: 0.6),
                    fontSize: 11,
                    letterSpacing: 8,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOuroLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        final show = _logoController.value >= 0.6;
        final opacity = show
            ? ((_logoController.value - 0.6) / 0.4).clamp(0.0, 1.0)
            : 0.0;
        final offset = show
            ? 20 * (1 - ((_logoController.value - 0.6) / 0.4))
            : 20.0;

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, offset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'OURO',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: opacity),
                    fontSize: 52,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PREP',
                  style: TextStyle(
                    color: OuroColors.meshBlue.withValues(alpha: opacity),
                    fontSize: 18,
                    letterSpacing: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Éducation Mesh P2P',
                  style: TextStyle(
                    color: OuroColors.textSecondary.withValues(alpha: opacity * 0.6),
                    fontSize: 12,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoader() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        final show = _logoController.value >= 0.8;
        final opacity = show
            ? ((_logoController.value - 0.8) / 0.2).clamp(0.0, 1.0)
            : 0.0;

        return Opacity(
          opacity: opacity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    OuroColors.meshBlue.withValues(alpha: 0.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Initializing Mesh Kernel...',
                style: TextStyle(
                  color: OuroColors.textSecondary.withValues(alpha: opacity * 0.7),
                  fontSize: 12,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'v1.0.0-alpha',
                style: TextStyle(
                  color: OuroColors.textSecondary.withValues(alpha: opacity * 0.3),
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVersionBadge() {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
        child: Text(
          'OURO PREP v1.0.0 • Propulsé par Nexora Studio',
          style: TextStyle(
            color: OuroColors.textSecondary.withValues(alpha: 0.2),
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
    );
  }
}

class _SplashBackgroundPainter extends CustomPainter {
  final double pulse;

  _SplashBackgroundPainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 3; i++) {
      final radius = 100 + pulse * 50 + i * 60;
      final paint = Paint()
        ..color = OuroColors.meshBlue.withValues(alpha: 0.03 - i * 0.01)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawCircle(center, radius, paint);
    }

    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          OuroColors.meshBlue.withValues(alpha: 0.06 + pulse * 0.03),
          OuroColors.meshBlue.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 200));

    canvas.drawCircle(center, 200, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant _SplashBackgroundPainter oldDelegate) =>
      oldDelegate.pulse != pulse;
}

class _ParticleFieldPainter extends CustomPainter {
  final double time;

  _ParticleFieldPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 40; i++) {
      final baseX = (i * 137.5) % size.width;
      final baseY = (i * 97.3) % size.height;
      final driftX = sin(time * 2 + i * 0.7) * 20;
      final driftY = cos(time * 1.5 + i * 0.5) * 15;
      final x = baseX + driftX;
      final y = baseY + driftY;
      final r = (i % 3 + 1).toDouble();

      paint.color = OuroColors.meshBlue.withValues(
        alpha: 0.04 + (i % 5) * 0.015 + sin(time + i) * 0.02,
      );
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    final connectionPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3;
    for (int i = 0; i < 20; i++) {
      for (int j = i + 1; j < 20; j++) {
        final xi = (i * 137.5) % size.width + sin(time * 2 + i * 0.7) * 20;
        final yi = (i * 97.3) % size.height + cos(time * 1.5 + i * 0.5) * 15;
        final xj = (j * 137.5) % size.width + sin(time * 2 + j * 0.7) * 20;
        final yj = (j * 97.3) % size.height + cos(time * 1.5 + j * 0.5) * 15;
        final dist = Offset(xi, yi) - Offset(xj, yj);
        if (dist.distance < 80) {
          connectionPaint.color = OuroColors.meshBlue.withValues(
            alpha: 0.02 * (1 - dist.distance / 80),
          );
          canvas.drawLine(Offset(xi, yi), Offset(xj, yj), connectionPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleFieldPainter oldDelegate) =>
      oldDelegate.time != time;
}

class _TechCreditsWidget extends StatelessWidget {
  const _TechCreditsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: OuroColors.glassBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: OuroColors.glassBorder, width: 0.3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_tethering, size: 14, color: OuroColors.meshBlue.withValues(alpha: 0.6)),
              const SizedBox(width: 8),
              Text(
                'P2P Mesh Network • WebRTC',
                style: TextStyle(
                  color: OuroColors.textSecondary.withValues(alpha: 0.5),
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Librairie éducative décentralisée',
          style: TextStyle(
            color: OuroColors.textSecondary.withValues(alpha: 0.3),
            fontSize: 9,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _SplashLoadingBar extends StatelessWidget {
  final AnimationController controller;

  const _SplashLoadingBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final show = controller.value >= 0.85;
        final opacity = show ? ((controller.value - 0.85) / 0.15).clamp(0.0, 1.0) : 0.0;
        return Opacity(
          opacity: opacity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                height: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: opacity),
                    duration: 500.ms,
                    builder: (context, val, _) {
                      return LinearProgressIndicator(
                        value: val,
                        backgroundColor: OuroColors.glassBg,
                        valueColor: AlwaysStoppedAnimation(
                          OuroColors.meshBlue.withValues(alpha: 0.6),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Chargement du contenu local...',
                style: TextStyle(
                  color: OuroColors.textSecondary.withValues(alpha: opacity * 0.5),
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SplashFooterWidget extends StatelessWidget {
  const _SplashFooterWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: OuroColors.meshBlue.withValues(alpha: 0.2 + index * 0.1),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Sécurisé • Hors ligne • Pair à pair',
          style: TextStyle(
            color: OuroColors.textSecondary.withValues(alpha: 0.15),
            fontSize: 9,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _SplashNetworkNodes extends StatelessWidget {
  final AnimationController controller;

  const _SplashNetworkNodes({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(120, 60),
          painter: _NodePainter(
            value: controller.value,
            nodeCount: 6,
            color: OuroColors.meshBlue,
          ),
        );
      },
    );
  }
}

class _NodePainter extends CustomPainter {
  final double value;
  final int nodeCount;
  final Color color;

  _NodePainter({required this.value, required this.nodeCount, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final spacing = size.width / (nodeCount + 1);

    for (int i = 0; i < nodeCount; i++) {
      final x = spacing * (i + 1);
      final y = centerY + 8 * sin((value * 2 * pi) + i * 0.8);
      final alpha = (0.3 + 0.7 * (0.5 + 0.5 * sin(value * pi + i))).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 2.5 + 1.5 * (0.5 + 0.5 * sin(value * pi + i)), paint);

      if (i > 0) {
        final prevX = spacing * i;
        final prevY = centerY + 8 * sin((value * 2 * pi) + (i - 1) * 0.8);
        final linePaint = Paint()
          ..color = color.withValues(alpha: alpha * 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
        canvas.drawLine(Offset(prevX, prevY), Offset(x, y), linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NodePainter oldDelegate) => oldDelegate.value != value;
}

class _SplashVersionInfo extends StatelessWidget {
  const _SplashVersionInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'v1.0.0-alpha',
          style: TextStyle(
            color: OuroColors.textSecondary.withValues(alpha: 0.2),
            fontSize: 9,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Nexora Studio © 2026',
          style: TextStyle(
            color: OuroColors.textSecondary.withValues(alpha: 0.15),
            fontSize: 8,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
