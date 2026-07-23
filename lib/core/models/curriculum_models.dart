/// Represents a single lesson within a chapter
class Lesson {
  final String id;
  final String title;
  final String subtitle;
  final int order;
  final String content;

  const Lesson({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.order,
    this.content = '',
  });

  Lesson copyWith({String? content}) => Lesson(
        id: id,
        title: title,
        subtitle: subtitle,
        order: order,
        content: content ?? this.content,
      );
}

/// Represents a chapter containing multiple lessons
class CurriculumChapter {
  final String id;
  final String title;
  final String subtitle;
  final int order;
  final String subjectId;
  final List<Lesson> lessons;
  final int examDurationMinutes;
  final int examQuestionCount;

  const CurriculumChapter({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.order,
    required this.subjectId,
    this.lessons = const [],
    this.examDurationMinutes = 30,
    this.examQuestionCount = 10,
  });
}

/// Represents a subject/course with its chapters
class SubjectCurriculum {
  final String id;
  final String title;
  final String emoji;
  final String bacSeries;
  final int coefficient;
  final int examDurationMinutes;
  final int examQuestionCount;
  final List<CurriculumChapter> chapters;

  const SubjectCurriculum({
    required this.id,
    required this.title,
    this.emoji = '',
    this.bacSeries = 'D',
    this.coefficient = 4,
    this.examDurationMinutes = 240,
    this.examQuestionCount = 20,
    this.chapters = const [],
  });
}
