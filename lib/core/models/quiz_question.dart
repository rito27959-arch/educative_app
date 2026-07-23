enum QuizType { multipleChoice, trueFalse, fillBlank }

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String lessonId;
  final String explanation;
  final QuizType type;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.lessonId,
    this.explanation = '',
    this.type = QuizType.multipleChoice,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'options': options,
    'correctIndex': correctIndex,
    'lessonId': lessonId,
    'explanation': explanation,
    'type': type.name,
  };

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
    id: json['id'] as String,
    question: json['question'] as String,
    options: (json['options'] as List).cast<String>(),
    correctIndex: json['correctIndex'] as int,
    lessonId: json['lessonId'] as String,
    explanation: json['explanation'] as String? ?? '',
    type: QuizType.values.firstWhere((t) => t.name == json['type'], orElse: () => QuizType.multipleChoice),
  );
}
