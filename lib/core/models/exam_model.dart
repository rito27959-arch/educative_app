import 'exam_question.dart';

class ExamModel {
  final String id;
  final String title;
  final int durationMinutes;
  final List<ExamQuestion> questions;

  const ExamModel({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.questions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'durationMinutes': durationMinutes,
    'questions': questions.map((q) => q.toJson()).toList(),
  };

  factory ExamModel.fromJson(Map<String, dynamic> json) => ExamModel(
    id: json['id'] as String,
    title: json['title'] as String,
    durationMinutes: json['durationMinutes'] as int,
    questions: (json['questions'] as List<dynamic>)
        .map((e) => ExamQuestion.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
