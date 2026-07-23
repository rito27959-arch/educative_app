import 'course_model.dart';

enum SectionType { lesson, quiz, exercise }

class SectionModel {
  final String id;
  final String title;
  final String content;
  final SectionType type;
  final List<QuizModel>? quiz;
  final ExerciseModel? exercise;
  final bool isIntro;

  const SectionModel({
    required this.id,
    required this.title,
    this.content = '',
    this.type = SectionType.lesson,
    this.quiz,
    this.exercise,
    this.isIntro = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'type': type.index,
    'quiz': quiz?.map((q) => q.toJson()).toList(),
    'exercise': exercise?.toJson(),
    'isIntro': isIntro,
  };

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String? ?? '',
    type: SectionType.values[json['type'] as int? ?? 0],
    quiz: (json['quiz'] as List<dynamic>?)
        ?.map((e) => QuizModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    exercise: json['exercise'] != null
        ? ExerciseModel.fromJson(json['exercise'] as Map<String, dynamic>)
        : null,
    isIntro: json['isIntro'] as bool? ?? false,
  );
}

class ExerciseModel {
  final String question;
  final String expectedAnswer;
  final String? hint;

  const ExerciseModel({
    required this.question,
    required this.expectedAnswer,
    this.hint,
  });

  Map<String, dynamic> toJson() => {
    'question': question,
    'expectedAnswer': expectedAnswer,
    'hint': hint,
  };

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
    question: json['question'] as String,
    expectedAnswer: json['expectedAnswer'] as String,
    hint: json['hint'] as String?,
  );
}
