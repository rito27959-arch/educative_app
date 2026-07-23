import 'dart:math';
import 'dart:ui';

/// Niveaux de progression utilisateur
class LevelDefinition {
  final int level;
  final int xpRequired;
  final String title;
  final String emoji;

  const LevelDefinition({
    required this.level,
    required this.xpRequired,
    required this.title,
    required this.emoji,
  });

  static const all = [
    LevelDefinition(level: 1, xpRequired: 0, title: 'Apprenti', emoji: '🌱'),
    LevelDefinition(level: 2, xpRequired: 100, title: 'Étudiant', emoji: '📚'),
    LevelDefinition(level: 3, xpRequired: 300, title: 'Sérieux', emoji: '🎯'),
    LevelDefinition(level: 4, xpRequired: 600, title: 'Déterminé', emoji: '🔥'),
    LevelDefinition(level: 5, xpRequired: 1000, title: 'Érudit', emoji: '🧠'),
    LevelDefinition(level: 6, xpRequired: 1500, title: 'Expert', emoji: '⚡'),
    LevelDefinition(level: 7, xpRequired: 2100, title: 'Master', emoji: '💎'),
    LevelDefinition(level: 8, xpRequired: 2800, title: 'Prodige', emoji: '🌟'),
    LevelDefinition(level: 9, xpRequired: 3600, title: 'Génie', emoji: '👑'),
    LevelDefinition(level: 10, xpRequired: 5000, title: 'Légende', emoji: '🏆'),
  ];

  static LevelDefinition forLevel(int level) =>
      all.firstWhere((l) => l.level == level, orElse: () => all.last);

  static LevelDefinition currentLevel(int totalXp) {
    LevelDefinition current = all.first;
    for (final lvl in all) {
      if (totalXp >= lvl.xpRequired) current = lvl;
    }
    return current;
  }

  static int xpForNextLevel(int totalXp) {
    final current = currentLevel(totalXp);
    final next = all.length > current.level ? all[current.level] : null;
    return next?.xpRequired ?? current.xpRequired;
  }

  static double progressInLevel(int totalXp) {
    final current = currentLevel(totalXp);
    final nextXp = all.length > current.level ? all[current.level].xpRequired : totalXp;
    final prevXp = current.xpRequired;
    if (nextXp <= prevXp) return 1.0;
    return (totalXp - prevXp) / (nextXp - prevXp);
  }
}

/// Types de badges
enum BadgeType {
  firstLesson,
  perfectQuiz,
  streak7,
  streak30,
  streak60,
  meshContributor,
  p2pChampion,
  subjectExplorer,
  earlyAdopter,
  centurion,
  speedDemon,
  socialButterfly,
  offlineHero,
  comebackKing,
  allRounder,
}

/// Définition d'un badge
class BadgeDefinition {
  final BadgeType type;
  final String title;
  final String description;
  final String emoji;
  final int xpReward;
  final int coinReward;
  final bool isSecret;

  const BadgeDefinition({
    required this.type,
    required this.title,
    required this.description,
    required this.emoji,
    required this.xpReward,
    this.coinReward = 0,
    this.isSecret = false,
  });

  static const all = [
    BadgeDefinition(
      type: BadgeType.firstLesson,
      title: 'Premier pas',
      description: 'Termine ta première leçon',
      emoji: '🐣',
      xpReward: 50,
      coinReward: 10,
    ),
    BadgeDefinition(
      type: BadgeType.perfectQuiz,
      title: 'Without fault',
      description: '100% à un quiz',
      emoji: '💯',
      xpReward: 100,
      coinReward: 25,
    ),
    BadgeDefinition(
      type: BadgeType.streak7,
      title: '7 jours de feu',
      description: '7 jours d\'étude consécutifs',
      emoji: '🔥',
      xpReward: 200,
      coinReward: 50,
    ),
    BadgeDefinition(
      type: BadgeType.streak30,
      title: 'Mois de braise',
      description: '30 jours d\'étude consécutifs',
      emoji: '🌋',
      xpReward: 500,
      coinReward: 150,
    ),
    BadgeDefinition(
      type: BadgeType.streak60,
      title: 'Légende vivante',
      description: '60 jours d\'étude consécutifs',
      emoji: '👑',
      xpReward: 1000,
      coinReward: 500,
    ),
    BadgeDefinition(
      type: BadgeType.meshContributor,
      title: 'Nœud actif',
      description: 'Relai P2P actif pendant 10h',
      emoji: '📡',
      xpReward: 150,
      coinReward: 60,
    ),
    BadgeDefinition(
      type: BadgeType.p2pChampion,
      title: 'Champion P2P',
      description: 'Gagne 10 défis P2P',
      emoji: '⚔️',
      xpReward: 300,
      coinReward: 100,
    ),
    BadgeDefinition(
      type: BadgeType.subjectExplorer,
      title: 'Explorateur',
      description: 'Étudie dans 5 matières',
      emoji: '🧭',
      xpReward: 150,
      coinReward: 80,
    ),
    BadgeDefinition(
      type: BadgeType.earlyAdopter,
      title: 'Pionnier',
      description: 'Fais partie des premiers',
      emoji: '🚀',
      xpReward: 500,
      coinReward: 200,
    ),
    BadgeDefinition(
      type: BadgeType.centurion,
      title: 'Centurion',
      description: '100 leçons complétées',
      emoji: '🏛️',
      xpReward: 1000,
      coinReward: 300,
    ),
    BadgeDefinition(
      type: BadgeType.speedDemon,
      title: 'Éclair',
      description: '10 réponses en moins de 5s',
      emoji: '⚡',
      xpReward: 100,
      coinReward: 30,
    ),
    BadgeDefinition(
      type: BadgeType.socialButterfly,
      title: 'Papillon social',
      description: '25 messages sur le forum',
      emoji: '🦋',
      xpReward: 100,
      coinReward: 40,
    ),
    BadgeDefinition(
      type: BadgeType.offlineHero,
      title: 'Héros hors-ligne',
      description: '10h d\'étude sans connexion',
      emoji: '📴',
      xpReward: 200,
      coinReward: 90,
    ),
    BadgeDefinition(
      type: BadgeType.comebackKing,
      title: 'Roi du retour',
      description: 'Reviens après 7 jours d\'absence',
      emoji: '👑',
      xpReward: 150,
      coinReward: 150,
      isSecret: true,
    ),
    BadgeDefinition(
      type: BadgeType.allRounder,
      title: 'Touche-à-tout',
      description: 'Débloque 10 badges différents',
      emoji: '🌟',
      xpReward: 500,
      coinReward: 200,
    ),
  ];

  static BadgeDefinition fromType(BadgeType type) =>
      all.firstWhere((b) => b.type == type);
}

/// Action qui rapporte de l'XP
class XpAction {
  final String id;
  final String label;
  final int xpAmount;
  final DateTime timestamp;

  const XpAction({
    required this.id,
    required this.label,
    required this.xpAmount,
    required this.timestamp,
  });
}

/// Défi quotidien
class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int xpReward;
  final int coinReward;
  final int targetCount;
  final int progress;
  final DateTime expiresAt;

  const DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.xpReward,
    this.coinReward = 0,
    required this.targetCount,
    this.progress = 0,
    required this.expiresAt,
  });

  bool get isCompleted => progress >= targetCount;
  Duration get remaining => expiresAt.difference(DateTime.now());
  double get progressFraction => (progress / targetCount).clamp(0.0, 1.0);

  DailyChallenge copyWith({int? progress}) => DailyChallenge(
    id: id,
    title: title,
    description: description,
    emoji: emoji,
    xpReward: xpReward,
    coinReward: coinReward,
    targetCount: targetCount,
    progress: progress ?? this.progress,
    expiresAt: expiresAt,
  );

  static List<DailyChallenge> generate(DateTime now) {
    final seed = now.day + now.month * 31 + now.year * 365;
    final rng = Random(seed);
    final challenges = [
      DailyChallenge(
        id: 'daily_quiz_$seed',
        title: 'Quiz express',
        description: 'Réponds correctement à ${5 + rng.nextInt(6)} questions',
        emoji: '🎯',
        xpReward: 80 + rng.nextInt(40),
        coinReward: 10 + rng.nextInt(20),
        targetCount: 5 + rng.nextInt(6),
        expiresAt: DateTime(now.year, now.month, now.day + 1),
      ),
      DailyChallenge(
        id: 'daily_lessons_$seed',
        title: 'Leçons du jour',
        description: 'Termine ${2 + rng.nextInt(4)} leçons',
        emoji: '📖',
        xpReward: 100 + rng.nextInt(50),
        coinReward: 15 + rng.nextInt(15),
        targetCount: 2 + rng.nextInt(4),
        expiresAt: DateTime(now.year, now.month, now.day + 1),
      ),
      DailyChallenge(
        id: 'daily_streak_$seed',
        title: 'Maintiens ta série',
        description: 'Connecte-toi demain aussi !',
        emoji: '🔥',
        xpReward: 50,
        coinReward: 10,
        targetCount: 1,
        expiresAt: DateTime(now.year, now.month, now.day + 1),
      ),
    ];
    return challenges;
  }
}

/// État complet de la gamification
class GamificationState {
  final int totalXp;
  final Map<String, int> actionsCount;
  final Set<BadgeType> unlockedBadges;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActiveDate;
  final List<DailyChallenge> dailyChallenges;
  final int p2pWins;
  final int lessonsCompleted;
  final int quizzesPassed;
  final int forumMessages;
  final int streakFreeze;

  const GamificationState({
    this.totalXp = 0,
    this.actionsCount = const {},
    this.unlockedBadges = const {},
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActiveDate,
    this.dailyChallenges = const [],
    this.p2pWins = 0,
    this.lessonsCompleted = 0,
    this.quizzesPassed = 0,
    this.forumMessages = 0,
    this.streakFreeze = 0,
  });

  LevelDefinition get currentLevel => LevelDefinition.currentLevel(totalXp);
  double get levelProgress => LevelDefinition.progressInLevel(totalXp);
  int get xpForNext => LevelDefinition.xpForNextLevel(totalXp);
  int get xpInCurrentLevel => totalXp - (LevelDefinition.currentLevel(totalXp).xpRequired);
  int get xpNeededForNext => xpForNext - LevelDefinition.currentLevel(totalXp).xpRequired;

  GamificationState copyWith({
    int? totalXp,
    Map<String, int>? actionsCount,
    Set<BadgeType>? unlockedBadges,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActiveDate,
    List<DailyChallenge>? dailyChallenges,
    int? p2pWins,
    int? lessonsCompleted,
    int? quizzesPassed,
    int? forumMessages,
    int? streakFreeze,
  }) => GamificationState(
    totalXp: totalXp ?? this.totalXp,
    actionsCount: actionsCount ?? this.actionsCount,
    unlockedBadges: unlockedBadges ?? this.unlockedBadges,
    currentStreak: currentStreak ?? this.currentStreak,
    longestStreak: longestStreak ?? this.longestStreak,
    lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    dailyChallenges: dailyChallenges ?? this.dailyChallenges,
    p2pWins: p2pWins ?? this.p2pWins,
    lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
    quizzesPassed: quizzesPassed ?? this.quizzesPassed,
    forumMessages: forumMessages ?? this.forumMessages,
    streakFreeze: streakFreeze ?? this.streakFreeze,
  );

  Map<String, dynamic> toJson() => {
    'totalXp': totalXp,
    'actionsCount': actionsCount,
    'unlockedBadges': unlockedBadges.map((b) => b.name).toList(),
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'lastActiveDate': lastActiveDate?.toIso8601String(),
    'dailyChallenges': dailyChallenges.map((c) => ({
      'id': c.id,
      'progress': c.progress,
    })).toList(),
    'p2pWins': p2pWins,
    'lessonsCompleted': lessonsCompleted,
    'quizzesPassed': quizzesPassed,
    'forumMessages': forumMessages,
    'streakFreeze': streakFreeze,
  };

  factory GamificationState.fromJson(Map<String, dynamic> json) => GamificationState(
    totalXp: json['totalXp'] as int? ?? 0,
    actionsCount: (json['actionsCount'] as Map<String, dynamic>?)?.map(
      (k, v) => MapEntry(k, v as int),
    ) ?? {},
    unlockedBadges: (json['unlockedBadges'] as List<dynamic>?)
        ?.map((e) => BadgeType.values.firstWhere(
          (b) => b.name == e,
          orElse: () => BadgeType.firstLesson,
        ))
        .toSet() ?? {},
    currentStreak: json['currentStreak'] as int? ?? 0,
    longestStreak: json['longestStreak'] as int? ?? 0,
    lastActiveDate: json['lastActiveDate'] != null
        ? DateTime.parse(json['lastActiveDate'] as String)
        : null,
    p2pWins: json['p2pWins'] as int? ?? 0,
    lessonsCompleted: json['lessonsCompleted'] as int? ?? 0,
    quizzesPassed: json['quizzesPassed'] as int? ?? 0,
    forumMessages: json['forumMessages'] as int? ?? 0,
    streakFreeze: json['streakFreeze'] as int? ?? 0,
  );
}

/// Nouveaux badges débloqués (pour animations)
class NewBadgeUnlock {
  final BadgeType badge;
  final bool didLevelUp;
  final int newLevel;
  final int xpGained;

  const NewBadgeUnlock({
    required this.badge,
    this.didLevelUp = false,
    this.newLevel = 1,
    this.xpGained = 0,
  });
}

/// Entrée du leaderboard
class LeaderboardEntry {
  final String pseudo;
  final int totalXp;
  final int level;
  final int streak;
  final int rank;
  final bool isMe;

  const LeaderboardEntry({
    required this.pseudo,
    required this.totalXp,
    required this.level,
    this.streak = 0,
    required this.rank,
    this.isMe = false,
  });
}

/// État d'une célébration en cours
class CelebrationData {
  final String title;
  final String subtitle;
  final String emoji;
  final int? xpGained;
  final int? newLevel;
  final Color color;

  const CelebrationData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    this.xpGained,
    this.newLevel,
    this.color = const Color(0xFF2563FF),
  });
}
