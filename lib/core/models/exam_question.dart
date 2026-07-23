class ExamQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? subject;
  final double points;

  const ExamQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.subject,
    this.points = 1.0,
  });

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correctIndex': correctIndex,
    'subject': subject,
    'points': points,
  };

  factory ExamQuestion.fromJson(Map<String, dynamic> json) => ExamQuestion(
    question: json['question'] as String,
    options: (json['options'] as List<dynamic>).cast<String>(),
    correctIndex: json['correctIndex'] as int,
    subject: json['subject'] as String?,
    points: (json['points'] as num?)?.toDouble() ?? 1.0,
  );
}
