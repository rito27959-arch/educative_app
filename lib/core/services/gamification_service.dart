import '../services/content_service.dart';

class ProgressionState {
  final Set<String> completedSections;
  final Set<String> passedChapterExams;
  final Set<String> passedSubjectExams;

  const ProgressionState({
    this.completedSections = const {},
    this.passedChapterExams = const {},
    this.passedSubjectExams = const {},
  });

  ProgressionState copyWith({
    Set<String>? completedSections,
    Set<String>? passedChapterExams,
    Set<String>? passedSubjectExams,
  }) => ProgressionState(
    completedSections: completedSections ?? this.completedSections,
    passedChapterExams: passedChapterExams ?? this.passedChapterExams,
    passedSubjectExams: passedSubjectExams ?? this.passedSubjectExams,
  );

  Map<String, dynamic> toJson() => {
    'completedSections': completedSections.toList(),
    'passedChapterExams': passedChapterExams.toList(),
    'passedSubjectExams': passedSubjectExams.toList(),
  };

  factory ProgressionState.fromJson(Map<String, dynamic> json) => ProgressionState(
    completedSections: (json['completedSections'] as List<dynamic>?)?.cast<String>().toSet() ?? {},
    passedChapterExams: (json['passedChapterExams'] as List<dynamic>?)?.cast<String>().toSet() ?? {},
    passedSubjectExams: (json['passedSubjectExams'] as List<dynamic>?)?.cast<String>().toSet() ?? {},
  );
}

class GamificationService {
  static ProgressionState _state = const ProgressionState();

  static ProgressionState get state => _state;

  static Map<String, dynamic>? getCourseData(String courseId) {
    final content = ContentService.cache;
    if (content == null) return null;
    return content[courseId] as Map<String, dynamic>?;
  }

  static List<Map<String, dynamic>> getChapters(String courseId) {
    final course = getCourseData(courseId);
    if (course == null) return [];
    return (course['chapters'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
  }

  static Map<String, dynamic>? getChapterData(String courseId, String chapterId) {
    final chapters = getChapters(courseId);
    try {
      return chapters.firstWhere((c) => c['id'] == chapterId);
    } catch (_) {
      return null;
    }
  }

  static List<Map<String, dynamic>> getSections(String courseId, String chapterId) {
    final chapter = getChapterData(courseId, chapterId);
    if (chapter == null) return [];
    return (chapter['sections'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
  }

  static Map<String, dynamic>? getIntroSection(String courseId, String chapterId) {
    final chapter = getChapterData(courseId, chapterId);
    return chapter?['introSection'] as Map<String, dynamic>?;
  }

  static Map<String, dynamic>? getChapterExam(String courseId, String chapterId) {
    final chapter = getChapterData(courseId, chapterId);
    return chapter?['chapterExam'] as Map<String, dynamic>?;
  }

  static Map<String, dynamic>? getSubjectExam(String courseId) {
    final course = getCourseData(courseId);
    return course?['subjectExam'] as Map<String, dynamic>?;
  }

  static bool isSectionUnlocked(String sectionId, String courseId, String chapterId) {
    if (_state.completedSections.contains(sectionId)) return true;
    final sections = getSections(courseId, chapterId);
    final intro = getIntroSection(courseId, chapterId);
    if (intro != null && sectionId == intro['id']) return true;
    final idx = sections.indexWhere((s) => s['id'] == sectionId);
    if (idx <= 0) return true;
    return _state.completedSections.contains(sections[idx - 1]['id']);
  }

  static bool isChapterUnlocked(String chapterId, String courseId) {
    final chapters = getChapters(courseId);
    final idx = chapters.indexWhere((c) => c['id'] == chapterId);
    if (idx <= 0) return true;
    final prevChapter = chapters[idx - 1];
    final prevExam = prevChapter['chapterExam'] as Map<String, dynamic>?;
    if (prevExam == null) return true;
    return _state.passedChapterExams.contains(prevExam['id']);
  }

  static bool isSubjectExamUnlocked(String courseId) {
    final chapters = getChapters(courseId);
    if (chapters.isEmpty) return false;
    for (final ch in chapters) {
      final exam = ch['chapterExam'] as Map<String, dynamic>?;
      if (exam != null && !_state.passedChapterExams.contains(exam['id'])) {
        return false;
      }
    }
    return true;
  }

  static void completeSection(String sectionId) {
    _state = _state.copyWith(
      completedSections: {..._state.completedSections, sectionId},
    );
  }

  static void passChapterExam(String examId) {
    _state = _state.copyWith(
      passedChapterExams: {..._state.passedChapterExams, examId},
    );
  }

  static void passSubjectExam(String examId) {
    _state = _state.copyWith(
      passedSubjectExams: {..._state.passedSubjectExams, examId},
    );
  }

  static double chapterProgress(String courseId, String chapterId) {
    final sections = getSections(courseId, chapterId);
    if (sections.isEmpty) return 0.0;
    int completed = 0;
    for (final s in sections) {
      if (_state.completedSections.contains(s['id'])) completed++;
    }
    return completed / sections.length;
  }

  static double courseProgress(String courseId) {
    final chapters = getChapters(courseId);
    if (chapters.isEmpty) return 0.0;
    int totalExams = 0;
    int passed = 0;
    for (final ch in chapters) {
      final exam = ch['chapterExam'] as Map<String, dynamic>?;
      if (exam != null) {
        totalExams++;
        if (_state.passedChapterExams.contains(exam['id'])) passed++;
      }
    }
    if (totalExams == 0) return 0.0;
    return passed / totalExams;
  }
}
