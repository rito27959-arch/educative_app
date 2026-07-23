import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gamification_models.dart';
import '../services/gamification_engine.dart';

final gamificationStateProvider = StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier();
});

class GamificationNotifier extends StateNotifier<GamificationState> {
  final GamificationEngine _engine;

  GamificationNotifier()
      : _engine = GamificationEngine(),
        super(GamificationState()) {
    _engine.onBadgeUnlocked = (badge) {
      state = _engine.state;
    };
    _engine.onCelebration = (data) {
      state = _engine.state;
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _engine.load().then((_) => state = _engine.state);
    });
  }

  void recordLesson() {
    _engine.recordLessonCompleted();
    state = _engine.state;
  }

  void recordQuiz({bool perfect = false, bool fast = false}) {
    _engine.recordQuizPassed(perfect: perfect, wasFast: fast);
    state = _engine.state;
  }

  void recordP2pWin() {
    _engine.recordP2pWin();
    state = _engine.state;
  }

  void recordForumMessage() {
    _engine.recordForumMessage();
    state = _engine.state;
  }

  void advanceDailyChallenge(String challengeId) {
    _engine.refreshDailyChallengeProgress(challengeId);
    state = _engine.state;
  }

  void recordDailyActivity() {
    _engine.saveStreakDays();
    state = _engine.state;
  }
}

final xpProgressProvider = Provider<double>((ref) {
  return ref.watch(gamificationStateProvider).levelProgress;
});

final currentLevelProvider = Provider<LevelDefinition>((ref) {
  return ref.watch(gamificationStateProvider).currentLevel;
});

final unlockedBadgesProvider = Provider<List<BadgeDefinition>>((ref) {
  final unlocked = ref.watch(gamificationStateProvider).unlockedBadges;
  return unlocked.map(BadgeDefinition.fromType).toList();
});

final dailyChallengesProvider = Provider<List<DailyChallenge>>((ref) {
  return ref.watch(gamificationStateProvider).dailyChallenges;
});
