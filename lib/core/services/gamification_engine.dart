import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import '../models/gamification_models.dart';
import 'storage_service.dart';

/// Moteur de gamification central — gère XP, niveaux, séries, badges.
class GamificationEngine {
  static const _kStorageKey = 'gamification_state';
  static const _kXpLogKey = 'xp_actions';

  GamificationState _state = const GamificationState();
  GamificationState get state => _state;

  // Callbacks pour les célébrations
  void Function(NewBadgeUnlock)? onBadgeUnlocked;
  void Function(CelebrationData)? onCelebration;

  Future<void> load() async {
    final raw = StorageService.getString(_kStorageKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          _state = GamificationState.fromJson(
            Map<String, dynamic>.from(decoded),
          );
        }
      } catch (_) {
        _state = const GamificationState();
      }
    }
    await _checkStreak();
    await _refreshDailyChallenges();
    _save();
  }

  void _save() {
    StorageService.setString(_kStorageKey, jsonEncode(_state.toJson()));
  }

  Future<void> _checkStreak() async {
    final now = DateTime.now();
    final lastActive = _state.lastActiveDate;
    if (lastActive == null) {
      _state = _state.copyWith(currentStreak: 1, lastActiveDate: now);
    } else {
      final diff = now.difference(lastActive);
      final daysDiff = diff.inDays;
      if (daysDiff >= 4) {
        // Streak brisée — 4+ jours sans activité
        _state = _state.copyWith(currentStreak: 1, lastActiveDate: now, streakFreeze: 0);
        _checkComebackBonus(lastActive);
      } else if (daysDiff >= 2) {
        // Streak freeze — 2-3 jours, on garde la série
        _state = _state.copyWith(lastActiveDate: now, streakFreeze: _state.streakFreeze + 1);
      } else if (daysDiff == 1) {
        // Nouveau jour
        final newStreak = _state.currentStreak + 1;
        _state = _state.copyWith(
          currentStreak: newStreak,
          longestStreak: max(_state.longestStreak, newStreak),
          lastActiveDate: now,
          streakFreeze: 0,
        );
        _checkStreakMilestones(newStreak);
      }
    }
  }

  int saveStreakDays() {
    final now = DateTime.now();
    final lastActive = _state.lastActiveDate;
    if (lastActive == null) {
      _state = _state.copyWith(currentStreak: 1, lastActiveDate: now);
    } else {
      final diff = now.difference(lastActive);
      final daysDiff = diff.inDays;
      if (daysDiff >= 4) {
        _state = _state.copyWith(currentStreak: 1, lastActiveDate: now, streakFreeze: 0);
        _checkComebackBonus(lastActive);
      } else if (daysDiff >= 2) {
        _state = _state.copyWith(lastActiveDate: now, streakFreeze: _state.streakFreeze + 1);
      } else if (daysDiff == 1) {
        final newStreak = _state.currentStreak + 1;
        _state = _state.copyWith(
          currentStreak: newStreak,
          longestStreak: max(_state.longestStreak, newStreak),
          lastActiveDate: now,
          streakFreeze: 0,
        );
        _checkStreakMilestones(newStreak);
      }
    }
    _save();
    return _state.currentStreak;
  }

  void _checkComebackBonus(DateTime lastActive) {
    final daysAway = DateTime.now().difference(lastActive).inDays;
    if (daysAway >= 7) {
      addXp(XpAction(
        id: 'comeback_${DateTime.now().millisecondsSinceEpoch}',
        label: 'Retour après $daysAway jours',
        xpAmount: 150,
        timestamp: DateTime.now(),
      ));
      _tryUnlockBadge(BadgeType.comebackKing);
    }
  }

  void _checkStreakMilestones(int streak) {
    if (streak == 7) _tryUnlockBadge(BadgeType.streak7);
    if (streak == 30) _tryUnlockBadge(BadgeType.streak30);
    if (streak == 60) _tryUnlockBadge(BadgeType.streak60);
  }

  Future<void> refreshDailyChallengeProgress(String challengeId) async {
    final idx = _state.dailyChallenges.indexWhere((c) => c.id == challengeId);
    if (idx == -1) return;
    final challenge = _state.dailyChallenges[idx];
    if (challenge.isCompleted) return;
    final updated = challenge.copyWith(progress: challenge.progress + 1);
    final challenges = [..._state.dailyChallenges];
    challenges[idx] = updated;
    _state = _state.copyWith(dailyChallenges: challenges);
    if (updated.isCompleted) {
      addXp(XpAction(
        id: 'challenge_${challenge.id}_${DateTime.now().millisecondsSinceEpoch}',
        label: 'Défi quotidien : ${challenge.title}',
        xpAmount: challenge.xpReward,
        timestamp: DateTime.now(),
      ));
      _onCelebration(CelebrationData(
        title: 'Défi relevé !',
        subtitle: challenge.title,
        emoji: challenge.emoji,
        xpGained: challenge.xpReward,
        color: const Color(0xFFFF6B2B),
      ));
    }
    _save();
  }

  void recordLessonCompleted() {
    _state = _state.copyWith(
      lessonsCompleted: _state.lessonsCompleted + 1,
    );
    addXp(XpAction(
      id: 'lesson_${DateTime.now().millisecondsSinceEpoch}',
      label: 'Leçon terminée',
      xpAmount: 25,
      timestamp: DateTime.now(),
    ));
    if (_state.lessonsCompleted == 1) {
      _tryUnlockBadge(BadgeType.firstLesson);
    }
    if (_state.lessonsCompleted >= 100) {
      _tryUnlockBadge(BadgeType.centurion);
    }
  }

  void recordQuizPassed({required bool perfect, required bool wasFast}) {
    _state = _state.copyWith(
      quizzesPassed: _state.quizzesPassed + 1,
    );
    addXp(XpAction(
      id: 'quiz_${DateTime.now().millisecondsSinceEpoch}',
      label: perfect ? 'Quiz parfait' : 'Quiz réussi',
      xpAmount: perfect ? 50 : 25,
      timestamp: DateTime.now(),
    ));
    if (perfect) _tryUnlockBadge(BadgeType.perfectQuiz);
    if (wasFast) _tryUnlockBadge(BadgeType.speedDemon);
  }

  void recordP2pWin() {
    _state = _state.copyWith(
      p2pWins: _state.p2pWins + 1,
    );
    addXp(XpAction(
      id: 'p2p_${DateTime.now().millisecondsSinceEpoch}',
      label: 'Défi P2P gagné',
      xpAmount: 75,
      timestamp: DateTime.now(),
    ));
    if (_state.p2pWins >= 10) _tryUnlockBadge(BadgeType.p2pChampion);
  }

  void recordForumMessage() {
    _state = _state.copyWith(
      forumMessages: _state.forumMessages + 1,
    );
    if (_state.forumMessages >= 25) _tryUnlockBadge(BadgeType.socialButterfly);
  }

  void addXp(XpAction action) {
    final oldLevel = _state.currentLevel.level;
    _state = _state.copyWith(
      totalXp: _state.totalXp + action.xpAmount,
      actionsCount: {
        ..._state.actionsCount,
        action.id: (action.xpAmount),
      },
    );
    final newLevel = _state.currentLevel.level;
    if (newLevel > oldLevel) {
      _onCelebration(CelebrationData(
        title: 'Niveau supérieur !',
        subtitle: 'Tu es maintenant ${_state.currentLevel.title}',
        emoji: _state.currentLevel.emoji,
        xpGained: action.xpAmount,
        newLevel: newLevel,
        color: const Color(0xFF00E676),
      ));
    }
    _save();
  }

  void _tryUnlockBadge(BadgeType type) {
    if (_state.unlockedBadges.contains(type)) return;
    final definition = BadgeDefinition.fromType(type);
    _state = _state.copyWith(
      unlockedBadges: {..._state.unlockedBadges, type},
      totalXp: _state.totalXp + definition.xpReward,
    );
    final didLevelUp = _state.currentLevel.level > LevelDefinition.currentLevel(_state.totalXp - definition.xpReward).level;
    onBadgeUnlocked?.call(NewBadgeUnlock(
      badge: type,
      didLevelUp: didLevelUp,
      newLevel: _state.currentLevel.level,
      xpGained: definition.xpReward,
    ));
    _onCelebration(CelebrationData(
      title: 'Badge débloqué !',
      subtitle: definition.title,
      emoji: definition.emoji,
      xpGained: definition.xpReward,
    ));
    // Vérifier le badge "allRounder"
    if (_state.unlockedBadges.length >= 10) {
      _tryUnlockBadge(BadgeType.allRounder);
    }
    _save();
  }

  Future<void> _refreshDailyChallenges() async {
    final now = DateTime.now();
    final existing = _state.dailyChallenges;
    if (existing.isNotEmpty && existing.first.expiresAt.isAfter(now)) return;
    _state = _state.copyWith(
      dailyChallenges: DailyChallenge.generate(now),
    );
    _save();
  }

  void _onCelebration(CelebrationData data) {
    onCelebration?.call(data);
  }
}
