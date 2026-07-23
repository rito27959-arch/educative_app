class CurriculumProgress {
  final Set<String> completedLessons;
  final Set<String> completedChapters;
  final Set<String> completedSubjects;
  final Map<String, int> lessonScores;
  final Map<String, int> chapterScores;
  final Map<String, int> subjectScores;
  final DateTime lastActivity;

  const CurriculumProgress({
    this.completedLessons = const {},
    this.completedChapters = const {},
    this.completedSubjects = const {},
    this.lessonScores = const {},
    this.chapterScores = const {},
    this.subjectScores = const {},
    required this.lastActivity,
  });

  CurriculumProgress copyWith({
    Set<String>? completedLessons,
    Set<String>? completedChapters,
    Set<String>? completedSubjects,
    Map<String, int>? lessonScores,
    Map<String, int>? chapterScores,
    Map<String, int>? subjectScores,
    DateTime? lastActivity,
  }) {
    return CurriculumProgress(
      completedLessons: completedLessons ?? this.completedLessons,
      completedChapters: completedChapters ?? this.completedChapters,
      completedSubjects: completedSubjects ?? this.completedSubjects,
      lessonScores: lessonScores ?? this.lessonScores,
      chapterScores: chapterScores ?? this.chapterScores,
      subjectScores: subjectScores ?? this.subjectScores,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  double get overallProgress {
    final total = 104; // total lessons across all subjects
    return completedLessons.length / total;
  }

  double subjectProgress(String subjectId) {
    // calculated from curriculum data provider
    return 0.0;
  }

  Map<String, dynamic> toJson() => {
    'completedLessons': completedLessons.toList(),
    'completedChapters': completedChapters.toList(),
    'completedSubjects': completedSubjects.toList(),
    'lessonScores': lessonScores.map((k, v) => MapEntry(k, v)),
    'chapterScores': chapterScores.map((k, v) => MapEntry(k, v)),
    'subjectScores': subjectScores.map((k, v) => MapEntry(k, v)),
    'lastActivity': lastActivity.toIso8601String(),
  };

  factory CurriculumProgress.fromJson(Map<String, dynamic> json) => CurriculumProgress(
    completedLessons: (json['completedLessons'] as List?)?.map((e) => e as String).toSet() ?? {},
    completedChapters: (json['completedChapters'] as List?)?.map((e) => e as String).toSet() ?? {},
    completedSubjects: (json['completedSubjects'] as List?)?.map((e) => e as String).toSet() ?? {},
    lessonScores: (json['lessonScores'] as Map?)?.map((k, v) => MapEntry(k as String, v as int)) ?? {},
    chapterScores: (json['chapterScores'] as Map?)?.map((k, v) => MapEntry(k as String, v as int)) ?? {},
    subjectScores: (json['subjectScores'] as Map?)?.map((k, v) => MapEntry(k as String, v as int)) ?? {},
    lastActivity: DateTime.tryParse(json['lastActivity'] as String? ?? '') ?? DateTime.now(),
  );

  static final empty = CurriculumProgress(lastActivity: DateTime(2000));
}
