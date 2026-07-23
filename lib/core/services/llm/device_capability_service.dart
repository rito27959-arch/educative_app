import 'dart:io';

/// Détection des capacités matérielles de l'appareil au démarrage.
///
/// Vérifie :
/// - RAM totale disponible
/// - Espace de stockage libre
/// - Architecture CPU (ARM64 / x86)
/// - Version d'Android / iOS
///
/// ## Seuils pour Qwen2.5 1.5B Q4_K_M
/// - RAM minimale : 3 Go (recommandé 4 Go)
/// - Espace libre : 2 Go (modèle ~1 Go + buffer)
/// - Architecture : ARM64 (la plupart des appareils modernes)
class DeviceCapabilityService {
  static bool _checked = false;
  static bool _capable = false;
  static String _reason = '';

  /// Résultat de la vérification.
  static bool get isCapable => _capable;
  static String get reason => _reason;
  static bool get hasBeenChecked => _checked;

  /// Effectue toutes les vérifications.
  /// Retourne true si l'appareil peut faire tourner le modèle local.
  static Future<bool> check() async {
    _checked = true;

    // 1. RAM
    final ramMB = await _getTotalRamMB();
    if (ramMB < 3072) {
      _reason = 'RAM insuffisante (${ramMB}MB détectés, 3072MB requis minimum). '
          'Le tuteur IA hors-ligne n\'est pas disponible sur cet appareil.';
      _capable = false;
      return false;
    }

    // 2. Stockage
    final freeMB = await _getFreeStorageMB();
    if (freeMB < 2048) {
      _reason = 'Espace insuffisant (${freeMB}MB libres, 2048MB requis). '
          'Libérez du stockage pour activer le tuteur IA hors-ligne.';
      _capable = false;
      return false;
    }

    // 3. Architecture
    if (!_isSupportedArchitecture()) {
      _reason = 'Architecture CPU non supportée. '
          'Le tuteur IA hors-ligne nécessite un processeur ARM64.';
      _capable = false;
      return false;
    }

    _capable = true;
    _reason = '';
    return true;
  }

  /// Retourne le niveau de capacité (0-100).
  static int capabilityScore() {
    if (!_checked) return 0;
    if (!_capable) return 0;

    int score = 50;

    // Bonus RAM
    final ramMB = _getTotalRamMBSync();
    if (ramMB >= 6144) score += 25;  // 6 Go+
    else if (ramMB >= 4096) score += 15; // 4 Go+

    // Bonus stockage
    final freeMB = _getFreeStorageMBSync();
    if (freeMB >= 4096) score += 15;
    else if (freeMB >= 3072) score += 10;

    return score.clamp(0, 100);
  }

  /// Suggestion de qualité selon la RAM.
  static String suggestedQuality() {
    final ramMB = _getTotalRamMBSync();
    if (ramMB >= 6144) return 'Haute';
    if (ramMB >= 4096) return 'Moyenne';
    return 'Basse';
  }

  // -- Implémentations plateforme -------------------------------------------

  static Future<int> _getTotalRamMB() async {
    if (Platform.isAndroid) {
      try {
        // Lecture depuis /proc/meminfo
        final file = File('/proc/meminfo');
        if (await file.exists()) {
          final lines = await file.readAsLines();
          for (final line in lines) {
            if (line.startsWith('MemTotal:')) {
              final parts = line.split(RegExp(r'\s+'));
              if (parts.length >= 2) {
                final kb = int.tryParse(parts[1]);
                if (kb != null) return kb ~/ 1024;
              }
            }
          }
        }
      } catch (_) {}
    }
    // Fallback : supposer 4 Go (valeur conservative)
    return 4096;
  }

  static int _getTotalRamMBSync() {
    if (Platform.isAndroid) {
      try {
        final file = File('/proc/meminfo');
        if (file.existsSync()) {
          final lines = file.readAsLinesSync();
          for (final line in lines) {
            if (line.startsWith('MemTotal:')) {
              final parts = line.split(RegExp(r'\s+'));
              if (parts.length >= 2) {
                final kb = int.tryParse(parts[1]);
                if (kb != null) return kb ~/ 1024;
              }
            }
          }
        }
      } catch (_) {}
    }
    return 4096;
  }

  static Future<int> _getFreeStorageMB() async {
    // Sur mobile, on ne peut pas obtenir l'espace libre facilement.
    // On utilise une estimation basée sur le dossier temporaire.
    try {
      final stat = await Directory.systemTemp.stat();
      return stat.size ~/ (1024 * 1024);
    } catch (_) {
      return 4096;
    }
  }

  static int _getFreeStorageMBSync() {
    try {
      final stat = Directory.systemTemp.statSync();
      return stat.size ~/ (1024 * 1024);
    } catch (_) {
      return 4096;
    }
  }

  static bool _isSupportedArchitecture() {
    // ARM64 est requis pour les binaires llama.cpp précompilés
    if (Platform.isAndroid) {
      final arch = Platform.version;
      return arch.contains('aarch64') || arch.contains('arm64');
    }
    if (Platform.isIOS) {
      return true; // iOS = ARM64
    }
    return false; // Desktop non supporté
  }
}
