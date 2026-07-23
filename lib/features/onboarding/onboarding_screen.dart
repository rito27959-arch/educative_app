import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/glassmorphism.dart';
import '../../core/services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _page = 0;

  static const _slides = [
    _SlideData(
      icon: Icons.wifi_tethering,
      title: 'Connecté sans Internet',
      desc: 'Le maillage OURO PREP relie les appareils en P2P via BLE, Wi‑Fi local et Bluetooth. Pas de serveur, pas de forfait, juste la puissance du groupe.',
    ),
    _SlideData(
      icon: Icons.forum,
      title: 'Forum décentralisé',
      desc: 'Discutez, partagez fichiers et audios, posez des questions. Chaque message est relayé de pair en pair sans passer par le cloud.',
    ),
    _SlideData(
      icon: Icons.school,
      title: 'Apprenez, partout',
      desc: 'Cours, quiz, appels vocaux, tutorat IA. Tout fonctionne hors ligne. Le mesh s\'adapte à votre environnement, pas l\'inverse.',
    ),
  ];

  void _next() {
    if (_page < _slides.length - 1) {
      _pageCtrl.nextPage(duration: 300.ms, curve: Curves.easeOut);
    } else {
      _complete();
    }
  }

  void _complete() {
    StorageService.setOnboardingComplete();
    context.go('/auth');
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: GestureDetector(
                  onTap: _complete,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, right: 24),
                    child: Text(
                      'Passer',
                      style: TextStyle(
                        color: OuroColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlideCard(slide: _slides[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: 300.ms,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _page ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _page
                              ? OuroColors.meshBlue
                              : OuroColors.textSecondary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OuroColors.meshBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: Text(
                        _page < _slides.length - 1 ? 'Suivant' : 'Commencer',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  final IconData icon;
  final String title;
  final String desc;
  const _SlideData({required this.icon, required this.title, required this.desc});
}

class _SlideCard extends StatelessWidget {
  final _SlideData slide;
  const _SlideCard({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [OuroColors.meshBlue, Colors.transparent],
              ),
            ),
            child: Icon(slide.icon, color: OuroColors.meshBlue, size: 48),
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 40),
          Text(
            slide.title,
            style: const TextStyle(
              color: OuroColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms).moveY(begin: 20),
          const SizedBox(height: 16),
          Text(
            slide.desc,
            style: const TextStyle(
              color: OuroColors.textSecondary,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 400.ms, delay: 400.ms).moveY(begin: 20),
        ],
      ),
    );
  }
}
