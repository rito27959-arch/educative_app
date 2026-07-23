import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../design_system/widgets/ouro_inputs.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/repositories/user_repository.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with TickerProviderStateMixin {
  final _pseudoController = TextEditingController();
  String _selectedBac = BacSeries.all.first;
  String? _errorMessage;
  late AnimationController _bgController;

  bool _termsAccepted = false;
  late AnimationController _shieldController;
  late AnimationController _featureController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: 6.seconds,
    )..repeat();
    _shieldController = AnimationController(
      vsync: this,
      duration: 3.seconds,
    )..repeat(reverse: true);
    _featureController = AnimationController(
      vsync: this,
      duration: 4.seconds,
    )..repeat();
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    _bgController.dispose();
    _shieldController.dispose();
    _featureController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final pseudo = _pseudoController.text.trim();

    if (pseudo.isEmpty) {
      setState(() => _errorMessage = 'Veuillez entrer un pseudo');
      return;
    }
    if (pseudo.length < 2) {
      setState(() => _errorMessage = 'Le pseudo doit contenir au moins 2 caractères');
      return;
    }
    if (pseudo.length > 20) {
      setState(() => _errorMessage = 'Le pseudo est trop long (max 20)');
      return;
    }
    if (!_termsAccepted) {
      setState(() => _errorMessage = 'Veuillez accepter les conditions d\'utilisation');
      return;
    }

    setState(() => _errorMessage = null);

    try {
      await ref.read(authProvider.notifier).login(pseudo, _selectedBac);
      if (mounted) context.go('/dashboard');
    } catch (e) {
      setState(() => _errorMessage = 'Erreur lors de la connexion');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OuroColors.background,
      body: Stack(
        children: [
          _buildAnimatedMeshBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DesignTokens.grid4x),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildIdentityForm(),
                    const SizedBox(height: 24),
                    if (_errorMessage != null) _buildErrorBanner(),
                    const SizedBox(height: 16),
                    _buildTermsSection(),
                    const SizedBox(height: 16),
                    _buildSubmitButton(),
                    const SizedBox(height: 16),
                    _buildBacInfoSection(),
                    const SizedBox(height: 16),
                    _buildFeatureCarousel(),
                    const SizedBox(height: 16),
                    _buildSecurityInfo(),
                    const SizedBox(height: 16),
                    _buildDecorativeDivider(),
                    const SizedBox(height: 16),
                    _buildCommunityTeaser(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMeshBackground() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _AuthBackgroundPainter(time: _bgController.value),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [OuroColors.meshBlue, OuroColors.meshBlueGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: OuroColors.meshBlue.withValues(alpha: 0.3),
                blurRadius: 60,
                spreadRadius: 20,
              ),
              BoxShadow(
                color: OuroColors.meshBlue.withValues(alpha: 0.15),
                blurRadius: 100,
                spreadRadius: 40,
              ),
            ],
          ),
          child: const Icon(Icons.wifi_tethering, color: Colors.white, size: 44),
        ),
        const SizedBox(height: 24),
        const Text(
          'Rejoins le Maillage',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Crée ton identité cryptographique locale',
          style: TextStyle(
            color: OuroColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(
          begin: 30,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildIdentityForm() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OuroTextField(
            controller: _pseudoController,
            label: 'Pseudo Anime',
            hint: 'Entre ton pseudo unique...',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          GlassContainer(
            padding: const EdgeInsets.all(4),
            borderRadius: 16,
            child: DropdownButtonFormField<String>(
              value: _selectedBac,
              decoration: InputDecoration(
                labelText: 'Série BAC',
                prefixIcon: const Icon(Icons.school_outlined, color: OuroColors.meshBlue, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: OuroColors.glassBorder.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: OuroColors.meshBlue),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              dropdownColor: OuroColors.surface,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              items: BacSeries.all.map((bac) => DropdownMenuItem(value: bac, child: Text(bac))).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedBac = v);
              },
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            padding: const EdgeInsets.all(12),
            borderRadius: 12,
            opacity: 0.05,
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: OuroColors.meshBlue, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Une identité cryptographique unique sera créée localement',
                    style: TextStyle(
                      color: OuroColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(
          begin: 20,
          end: 0,
          duration: 600.ms,
          delay: 200.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildErrorBanner() {
    final authState = ref.watch(authProvider);
    final message = authState.errorMessage ?? _errorMessage;
    if (message == null) return const SizedBox.shrink();
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: 12,
      opacity: 0.15,
      border: Border.all(color: OuroColors.errorRed.withValues(alpha: 0.3)),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: OuroColors.errorRed, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: OuroColors.errorRed, fontSize: 13),
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(authProvider.notifier).clearError(),
            child: const Icon(Icons.close, color: OuroColors.errorRed, size: 18),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).shake(duration: 400.ms, hz: 3);
  }

  Widget _buildSubmitButton() {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    return GlowContainer(
      glowColor: OuroColors.meshBlue,
      radius: 16,
      opacity: 0.25,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: isLoading ? null : _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: OuroColors.meshBlue,
            foregroundColor: Colors.white,
            disabledBackgroundColor: OuroColors.meshBlue.withValues(alpha: 0.3),
            disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vérification anti-bot ${(authState.powProgress * 100).toInt()}%',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 10,
                      ),
                    ),
                  ],
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_tethering, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Entrer dans le Maillage',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(
          begin: 20,
          end: 0,
          duration: 600.ms,
          delay: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildSecurityInfo() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      borderRadius: 20,
      opacity: 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, color: OuroColors.localGreen, size: 14),
          const SizedBox(width: 6),
          Text(
            'Chiffré de bout en bout • Identité locale',
            style: TextStyle(
              color: OuroColors.textSecondary.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms);
  }

  Widget _buildTermsSection() {
    return _TermsCheckbox(
      accepted: _termsAccepted,
      onChanged: (v) => setState(() => _termsAccepted = v),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slideX(
      begin: 20, end: 0, duration: 500.ms, delay: 300.ms, curve: Curves.easeOutCubic,
    );
  }

  Widget _buildBacInfoSection() {
    return _BacSeriesInfoWidget(selectedBac: _selectedBac)
        .animate().fadeIn(duration: 500.ms, delay: 350.ms).slideY(
      begin: 15, end: 0, duration: 500.ms, delay: 350.ms, curve: Curves.easeOutCubic,
    );
  }

  Widget _buildFeatureCarousel() {
    final features = [
      _AuthFeatureRow(icon: Icons.wifi_tethering, title: 'Réseau Mesh P2P', subtitle: 'Connecte-toi directement sans serveur central'),
      _AuthFeatureRow(icon: Icons.lock_outline, title: 'Chiffrement local', subtitle: 'Tes données restent sur ton appareil'),
      _AuthFeatureRow(icon: Icons.school, title: 'Cours hors ligne', subtitle: 'Accède à tes cours même sans connexion'),
    ];

    return AnimatedBuilder(
      animation: _featureController,
      builder: (context, child) {
        final idx = (_featureController.value * 3).floor() % 3;
        return Column(
          children: [
            features[idx],
            const SizedBox(height: 8),
            _AuthCarouselIndicator(currentPage: idx, pageCount: 3),
          ],
        );
      },
    ).animate().fadeIn(duration: 600.ms, delay: 500.ms);
  }

  Widget _buildDecorativeDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: OuroColors.glassBorder.withValues(alpha: 0.2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _AnimatedShieldIcon(controller: _shieldController),
        ),
        Expanded(child: Divider(color: OuroColors.glassBorder.withValues(alpha: 0.2))),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 700.ms);
  }

  Widget _buildCommunityTeaser() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      opacity: 0.04,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Déjà ${(1200 + DateTime.now().millisecondsSinceEpoch % 500)} étudiants',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rejoins la communauté éducative décentralisée',
                  style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.6), fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OuroColors.meshBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.group_add, color: OuroColors.meshBlue, size: 18),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 800.ms).slideY(
      begin: 15, end: 0, duration: 600.ms, delay: 800.ms, curve: Curves.easeOutCubic,
    );
  }
}

class _AuthBackgroundPainter extends CustomPainter {
  final double time;

  _AuthBackgroundPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final nodes = <Offset>[];
    for (int i = 0; i < 15; i++) {
      final angle = time + i * (2 * pi / 15);
      final dist = 80 + 60 * sin(time * 0.5 + i);
      nodes.add(Offset(
        size.width / 2 + dist * cos(angle),
        size.height / 2 + dist * sin(angle),
      ));
    }

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final dist = (nodes[i] - nodes[j]).distance;
        if (dist < 150) {
          paintLine.color = OuroColors.meshBlue.withValues(alpha: 0.06 * (1 - dist / 150));
          canvas.drawLine(nodes[i], nodes[j], paintLine);
        }
      }
    }

    for (final node in nodes) {
      final paint = Paint()
        ..color = OuroColors.meshBlue.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(node, 2.5, paint);
    }

    for (int i = 0; i < 3; i++) {
      final ringPaint = Paint()
        ..color = OuroColors.meshBlue.withValues(alpha: 0.03 - i * 0.008)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      final ringRadius = 100 + i * 40 + 20 * sin(time * 2 + i);
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        ringRadius,
        ringPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AuthBackgroundPainter oldDelegate) =>
      oldDelegate.time != time;
}

class _TermsCheckbox extends StatelessWidget {
  final bool accepted;
  final ValueChanged<bool> onChanged;

  const _TermsCheckbox({
    required this.accepted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!accepted),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: accepted
                  ? OuroColors.meshBlue.withValues(alpha: 0.2)
                  : OuroColors.glassBg,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: accepted ? OuroColors.meshBlue : OuroColors.glassBorder,
                width: 1,
              ),
            ),
            child: accepted
                ? const Icon(Icons.check, color: OuroColors.meshBlue, size: 14)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'J\'accepte les conditions d\'utilisation et la politique de confidentialité',
              style: TextStyle(
                color: OuroColors.textSecondary.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedShieldIcon extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedShieldIcon({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: sin(controller.value * 2 * pi) * 0.05,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: OuroColors.localGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shield_outlined,
              color: OuroColors.localGreen.withValues(
                alpha: 0.5 + controller.value * 0.5,
              ),
              size: 14,
            ),
          ),
        );
      },
    );
  }
}

class _AuthCarouselIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const _AuthCarouselIndicator({
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (i) {
        final isActive = i == currentPage;
        return AnimatedContainer(
          duration: 300.ms,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive
                ? OuroColors.meshBlue
                : OuroColors.meshBlue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _AuthFeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AuthFeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OuroColors.meshBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: OuroColors.meshBlue, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: OuroColors.textSecondary.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BacSeriesInfoWidget extends StatelessWidget {
  final String selectedBac;

  const _BacSeriesInfoWidget({required this.selectedBac});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      opacity: 0.06,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: OuroColors.meshBlue, size: 16),
              const SizedBox(width: 8),
              Text(
                'Série $selectedBac',
                style: const TextStyle(
                  color: OuroColors.meshBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Les cours seront adaptés à ta série. '
            'Tu pourras aussi accéder aux ressources des autres séries.',
            style: TextStyle(
              color: OuroColors.textSecondary.withValues(alpha: 0.7),
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
