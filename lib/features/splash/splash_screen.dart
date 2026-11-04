// ============================================================================
// L'ÉCRAN D'OUVERTURE DE KUNFOX.
// ----------------------------------------------------------------------------
// Le renard est une animation Rive (`assets/rive/kunfox_splash.riv`, construite
// avec la Rive CLI depuis `rive/kunfox_splash/scene.rml`) : il surgit avec un
// rebond, sa toque tombe sur son oreille, il cligne des yeux, des étincelles
// s'allument, puis il respire doucement tant que l'app se prépare.
//
// Sous lui, le nom « Kunfox » arrive lettre par lettre, puis la devise.
// L'écran part au bout de 2,6 s (ou dès qu'on le touche, une fois
// l'animation d'entrée jouée). « Réduire les animations » : tout est posé
// d'emblée et l'écran part plus vite.
// ============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

import '../../core/services/storage_service.dart';

/// Le bleu nuit de Kunfox, le même que le fond de l'animation Rive.
const Color kNuitKunfox = Color(0xFF0E1730);
const Color _creme = Color(0xFFFFF4E8);
const Color _orange = Color(0xFFFF6B2B);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _texte = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  Timer? _depart;
  bool _parti = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: kNuitKunfox,
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reduit = MediaQuery.of(context).disableAnimations;
      if (reduit) {
        _texte.value = 1;
        _depart = Timer(const Duration(milliseconds: 900), _partir);
      } else {
        Future.delayed(const Duration(milliseconds: 1050), () {
          if (mounted) _texte.forward();
        });
        _depart = Timer(const Duration(milliseconds: 2600), _partir);
      }
    });
  }

  void _partir() {
    if (_parti || !mounted) return;
    _parti = true;
    context.go(StorageService.isOnboardingComplete() ? '/auth' : '/onboarding');
  }

  @override
  void dispose() {
    _depart?.cancel();
    _texte.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNuitKunfox,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Un toucher écourte l'attente, mais jamais l'entrée du renard.
          if (_texte.value > 0.5) _partir();
        },
        child: Stack(
          children: [
            // L'animation occupe l'écran ; son artboard (400 × 800) est
            // centré et garde ses proportions.
            const Positioned.fill(
              child: RiveAnimation.asset(
                'assets/rive/kunfox_splash.riv',
                fit: BoxFit.cover,
                stateMachines: ['Ouverture'],
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.32),
              child: AnimatedBuilder(
                animation: _texte,
                builder: (context, _) => _Marque(t: _texte.value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// « Kunfox » lettre par lettre, puis la devise.
class _Marque extends StatelessWidget {
  const _Marque({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    const mot = 'Kunfox';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < mot.length; i++)
              Builder(builder: (context) {
                final debut = i * 0.07;
                final p = Curves.easeOutBack.transform(((t - debut) / 0.45).clamp(0.0, 1.0));
                return Opacity(
                  opacity: p.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, 26 * (1 - p)),
                    child: Text(
                      mot[i],
                      style: TextStyle(
                        fontSize: 52,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                        color: i >= 3 ? _orange : _creme,
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
        const SizedBox(height: 14),
        Opacity(
          opacity: Curves.easeOut.transform(((t - 0.55) / 0.45).clamp(0.0, 1.0)),
          child: Text(
            'Révise. Progresse. Monte.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _creme.withValues(alpha: 0.7), letterSpacing: 0.2),
          ),
        ),
      ],
    );
  }
}
