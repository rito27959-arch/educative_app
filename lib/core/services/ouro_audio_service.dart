import 'package:flutter/services.dart';
import 'storage_service.dart';

/// Service audio et haptique centralisé.
/// Son désactivable dans les réglages (contexte salle de classe).
/// Haptique toujours actif sauf si désactivé.
class OuroAudioService {
  static final OuroAudioService _instance = OuroAudioService._();
  factory OuroAudioService() => _instance;
  OuroAudioService._();

  static const _kSoundsEnabled = 'audio_sounds_enabled';
  static const _kHapticEnabled = 'audio_haptic_enabled';

  bool get soundsEnabled => StorageService.getString(_kSoundsEnabled) != 'false';
  bool get hapticEnabled => StorageService.getString(_kHapticEnabled) != 'false';

  set soundsEnabled(bool v) => StorageService.setString(_kSoundsEnabled, v.toString());
  set hapticEnabled(bool v) => StorageService.setString(_kHapticEnabled, v.toString());

  void playCorrect() {
    if (soundsEnabled) SystemSound.play(SystemSoundType.click);
    if (hapticEnabled) HapticFeedback.lightImpact();
  }

  void playWrong() {
    if (soundsEnabled) SystemSound.play(SystemSoundType.click);
    if (hapticEnabled) HapticFeedback.heavyImpact();
  }

  void playStreakMilestone() {
    if (soundsEnabled) SystemSound.play(SystemSoundType.click);
    if (hapticEnabled) HapticFeedback.mediumImpact();
  }

  void playLevelUp() {
    if (soundsEnabled) SystemSound.play(SystemSoundType.click);
    if (hapticEnabled) HapticFeedback.heavyImpact();
  }

  void playChapterComplete() {
    if (soundsEnabled) SystemSound.play(SystemSoundType.click);
    if (hapticEnabled) HapticFeedback.mediumImpact();
  }
}
