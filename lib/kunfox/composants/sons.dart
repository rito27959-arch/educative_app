// Les sons de Kunfox (assets/sons, synthétisés pour l'app : aucun son
// emprunté). Coupables depuis le profil ; réglage gardé sous `kunfox.sons`.

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../../core/services/storage_service.dart';

enum Son { juste, faux, fin, flamme, clic }

class Sons {
  Sons._();

  static final Map<Son, AudioPlayer> _lecteurs = {};

  static bool get actifs => StorageService.getString('kunfox.sons') != 'false';

  static Future<void> basculer(bool oui) => StorageService.setString('kunfox.sons', oui ? 'true' : 'false');

  static Future<void> jouer(Son s) async {
    if (!actifs) return;
    try {
      final l = _lecteurs.putIfAbsent(s, () => AudioPlayer()..setPlayerMode(PlayerMode.lowLatency));
      await l.stop();
      await l.play(AssetSource('sons/${s.name}.wav'), volume: s == Son.clic ? 0.35 : 0.7);
    } catch (e) {
      debugPrint('[Kunfox] son ${s.name} : $e');
    }
  }
}
