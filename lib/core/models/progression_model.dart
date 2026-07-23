/// Session d'étude individuelle.
class StudySession {
  final String id;
  final DateTime date;
  final int durationMinutes;
  final int chaptersCompleted;
  final int quizzesPassed;

  const StudySession({
    required this.id,
    required this.date,
    this.durationMinutes = 0,
    this.chaptersCompleted = 0,
    this.quizzesPassed = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'durationMinutes': durationMinutes,
    'chaptersCompleted': chaptersCompleted,
    'quizzesPassed': quizzesPassed,
  };

  static StudySession fromJson(Map<String, dynamic> json) => StudySession(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    durationMinutes: json['durationMinutes'] as int? ?? 0,
    chaptersCompleted: json['chaptersCompleted'] as int? ?? 0,
    quizzesPassed: json['quizzesPassed'] as int? ?? 0,
  );
}

/// Progression agrégée visible par l'utilisateur.
class ProgressionSnapshot {
  final int streakDays;
  final double globalProgress; // 0.0 – 1.0
  final int totalChaptersCompleted;
  final int totalChapters;
  final int totalQuizzesPassed;
  final int studyMinutesToday;
  final int studyMinutesThisWeek;
  final int totalStudyMinutes;

  const ProgressionSnapshot({
    required this.streakDays,
    required this.globalProgress,
    required this.totalChaptersCompleted,
    required this.totalChapters,
    required this.totalQuizzesPassed,
    required this.studyMinutesToday,
    required this.studyMinutesThisWeek,
    required this.totalStudyMinutes,
  });

  bool get isPerfectWeek => studyMinutesThisWeek >= 600;
  bool get hasStreak => streakDays >= 1;
  bool get isStreakOnFire => streakDays >= 7;
}
