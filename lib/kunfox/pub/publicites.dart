// ============================================================================
// LES PUBLICITÉS (AdMob), À LA DUOLINGO — DISCRÈTES ET JAMAIS EN PLEIN EFFORT.
// ----------------------------------------------------------------------------
// Règles :
//   • JAMAIS pendant une leçon, un quiz, un grand boss, une épreuve type Bac
//     ou un duel. Une pub ne coupe jamais une réflexion.
//   • Pub plein écran (interstitielle) seulement en QUITTANT l'écran de fin
//     de leçon, et seulement si :
//       – l'élève a déjà fini au moins 3 leçons depuis l'installation,
//       – ce n'est pas la première leçon du jour (le moment de la série),
//       – une leçon sur deux au plus,
//       – au moins 4 minutes depuis la dernière pub,
//       – 6 pubs plein écran par jour au maximum.
//   • Pub « récompensée » TOUJOURS au choix de l'élève : regagner un cœur
//     quand il n'en a plus, ou doubler ses XP en fin de leçon.
//   • Contenu des pubs limité à « PG » (tout public accompagné) : les élèves
//     sont souvent mineurs.
//   • Hors connexion, pas de pub : rien ne bloque, l'app continue.
//
// Les identifiants AdMob viennent de la construction (--dart-define) :
//   ADMOB_INTERSTITIEL, ADMOB_RECOMPENSE  → identifiants de blocs d'annonces
//   ADMOB_TEST=true                         → pubs de test de Google
// Sans identifiant, les pubs sont simplement ÉTEINTES.
// ============================================================================

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/services/storage_service.dart';

class Publicites {
  Publicites._();

  static const _idInterstitiel = String.fromEnvironment('ADMOB_INTERSTITIEL');
  static const _idRecompense = String.fromEnvironment('ADMOB_RECOMPENSE');
  static const _test = bool.fromEnvironment('ADMOB_TEST');

  // Blocs de test officiels de Google (Android).
  static const _testInterstitiel = 'ca-app-pub-3940256099942544/1033173712';
  static const _testRecompense = 'ca-app-pub-3940256099942544/5224354917';

  static String get _blocInterstitiel => _test ? _testInterstitiel : _idInterstitiel;
  static String get _blocRecompense => _test ? _testRecompense : _idRecompense;

  /// Les pubs sont-elles prévues dans cette construction ?
  static bool get configurees =>
      !kIsWeb && Platform.isAndroid && (_test || _idInterstitiel.isNotEmpty || _idRecompense.isNotEmpty);

  static bool _pret = false;
  static InterstitialAd? _interstitiel;
  static RewardedAd? _recompense;
  static bool _chargeInterstitiel = false, _chargeRecompense = false;

  /// Une pub récompensée est-elle prête à être montrée ?
  static final recompensePrete = ValueNotifier<bool>(false);

  // ── règles de fréquence (paramètres publics pour les tests) ──────────────
  static const leconsAvantPremierePub = 3;
  static const ecartMinimum = Duration(minutes: 4);
  static const maxParJour = 6;

  /// La règle « faut-il une pub plein écran maintenant ? », sans effet de
  /// bord, pour pouvoir la tester.
  static bool interstitielAutorise({
    required int leconsTotales,
    required bool premiereDuJour,
    required int leconsDepuisDernierePub,
    required DateTime? dernierePub,
    required int pubsAujourdhui,
    required DateTime maintenant,
  }) {
    if (leconsTotales < leconsAvantPremierePub) return false;
    if (premiereDuJour) return false;
    if (leconsDepuisDernierePub < 2) return false;
    if (pubsAujourdhui >= maxParJour) return false;
    if (dernierePub != null && maintenant.difference(dernierePub) < ecartMinimum) return false;
    return true;
  }

  /// À appeler une fois au démarrage. Ne bloque jamais le lancement.
  static Future<void> initialiser() async {
    if (!configurees || _pret) return;
    try {
      await _consentement();
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(maxAdContentRating: MaxAdContentRating.pg),
      );
      await MobileAds.instance.initialize();
      _pret = true;
      _chargerInterstitiel();
      _chargerRecompense();
    } catch (e) {
      debugPrint('[Publicites] initialisation : $e');
    }
  }

  /// Formulaire de consentement de Google (affiché seulement là où la loi
  /// l'exige, par exemple en Europe).
  static Future<void> _consentement() {
    final fini = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () {
        ConsentForm.loadAndShowConsentFormIfRequired((_) {
          if (!fini.isCompleted) fini.complete();
        });
      },
      (_) {
        if (!fini.isCompleted) fini.complete();
      },
    );
    return fini.future.timeout(const Duration(seconds: 8), onTimeout: () {});
  }

  static void _chargerInterstitiel() {
    if (!_pret || _blocInterstitiel.isEmpty || _interstitiel != null || _chargeInterstitiel) return;
    _chargeInterstitiel = true;
    InterstitialAd.load(
      adUnitId: _blocInterstitiel,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _chargeInterstitiel = false;
          _interstitiel = ad;
        },
        onAdFailedToLoad: (e) {
          _chargeInterstitiel = false;
          debugPrint('[Publicites] interstitiel : ${e.message}');
        },
      ),
    );
  }

  static void _chargerRecompense() {
    if (!_pret || _blocRecompense.isEmpty || _recompense != null || _chargeRecompense) return;
    _chargeRecompense = true;
    RewardedAd.load(
      adUnitId: _blocRecompense,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _chargeRecompense = false;
          _recompense = ad;
          recompensePrete.value = true;
        },
        onAdFailedToLoad: (e) {
          _chargeRecompense = false;
          recompensePrete.value = false;
          debugPrint('[Publicites] récompense : ${e.message}');
        },
      ),
    );
  }

  /// Fin de leçon : compte la leçon, et montre une pub plein écran si les
  /// règles le permettent. Rend la main quand la pub est fermée.
  static Future<void> apresLecon({required bool premiereDuJour}) async {
    if (!configurees) return;
    final total = (int.tryParse(StorageService.getString('kunfox.pub.lecons') ?? '') ?? 0) + 1;
    final depuis = (int.tryParse(StorageService.getString('kunfox.pub.depuis') ?? '') ?? 0) + 1;
    await StorageService.setString('kunfox.pub.lecons', '$total');
    await StorageService.setString('kunfox.pub.depuis', '$depuis');

    final maintenant = DateTime.now();
    final jour = '${maintenant.year}-${maintenant.month}-${maintenant.day}';
    final jourPubs = StorageService.getString('kunfox.pub.jour');
    final pubsAuj = jourPubs == jour ? (int.tryParse(StorageService.getString('kunfox.pub.nbjour') ?? '') ?? 0) : 0;
    final derniere = DateTime.tryParse(StorageService.getString('kunfox.pub.derniere') ?? '');

    final ok = interstitielAutorise(
      leconsTotales: total,
      premiereDuJour: premiereDuJour,
      leconsDepuisDernierePub: depuis,
      dernierePub: derniere,
      pubsAujourdhui: pubsAuj,
      maintenant: maintenant,
    );
    final ad = _interstitiel;
    if (!ok || ad == null) {
      _chargerInterstitiel();
      return;
    }
    _interstitiel = null;
    final ferme = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        if (!ferme.isCompleted) ferme.complete();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        if (!ferme.isCompleted) ferme.complete();
      },
    );
    await StorageService.setString('kunfox.pub.depuis', '0');
    await StorageService.setString('kunfox.pub.derniere', maintenant.toIso8601String());
    await StorageService.setString('kunfox.pub.jour', jour);
    await StorageService.setString('kunfox.pub.nbjour', '${pubsAuj + 1}');
    await ad.show();
    await ferme.future.timeout(const Duration(minutes: 2), onTimeout: () {});
    _chargerInterstitiel();
  }

  /// Montre une pub récompensée. Rend `true` si l'élève l'a regardée
  /// jusqu'au bout (et mérite donc sa récompense).
  static Future<bool> regarderPourRecompense() async {
    final ad = _recompense;
    if (!configurees || ad == null) {
      _chargerRecompense();
      return false;
    }
    _recompense = null;
    recompensePrete.value = false;
    var gagne = false;
    final ferme = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        if (!ferme.isCompleted) ferme.complete();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        if (!ferme.isCompleted) ferme.complete();
      },
    );
    await ad.show(onUserEarnedReward: (_, _) => gagne = true);
    await ferme.future.timeout(const Duration(minutes: 3), onTimeout: () {});
    _chargerRecompense();
    return gagne;
  }
}
