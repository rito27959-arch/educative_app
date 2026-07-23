enum CourseAvailability { local, mesh, cloud }

class CourseModel {
  final String id;
  final String title;
  final String subject;
  final String description;
  final String type;
  final CourseAvailability availability;
  final double progress;
  final String imageUrl;
  final int lessonCount;
  final int durationMinutes;

  const CourseModel({
    required this.id,
    required this.title,
    required this.subject,
    this.description = '',
    this.type = 'PDF',
    this.availability = CourseAvailability.cloud,
    this.progress = 0.0,
    this.imageUrl = '',
    this.lessonCount = 0,
    this.durationMinutes = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subject': subject,
    'description': description,
    'type': type,
    'availability': availability.index,
    'progress': progress,
    'imageUrl': imageUrl,
    'lessonCount': lessonCount,
    'durationMinutes': durationMinutes,
  };

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
    id: json['id'] as String,
    title: json['title'] as String,
    subject: json['subject'] as String,
    description: json['description'] as String? ?? '',
    type: json['type'] as String? ?? 'PDF',
    availability: CourseAvailability.values[json['availability'] as int? ?? 2],
    progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    imageUrl: json['imageUrl'] as String? ?? '',
    lessonCount: json['lessonCount'] as int? ?? 0,
    durationMinutes: json['durationMinutes'] as int? ?? 0,
  );

  CourseModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? description,
    String? type,
    CourseAvailability? availability,
    double? progress,
    String? imageUrl,
    int? lessonCount,
    int? durationMinutes,
  }) => CourseModel(
    id: id ?? this.id,
    title: title ?? this.title,
    subject: subject ?? this.subject,
    description: description ?? this.description,
    type: type ?? this.type,
    availability: availability ?? this.availability,
    progress: progress ?? this.progress,
    imageUrl: imageUrl ?? this.imageUrl,
    lessonCount: lessonCount ?? this.lessonCount,
    durationMinutes: durationMinutes ?? this.durationMinutes,
  );
}

class ChapterModel {
  final String id;
  final String courseId;
  final String title;
  final String contentUrl;
  final String type;
  final CourseAvailability availability;
  final double progress;

  const ChapterModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.contentUrl = '',
    this.type = 'PDF',
    this.availability = CourseAvailability.cloud,
    this.progress = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'title': title,
    'contentUrl': contentUrl,
    'type': type,
    'availability': availability.index,
    'progress': progress,
  };

  factory ChapterModel.fromJson(Map<String, dynamic> json) => ChapterModel(
    id: json['id'] as String,
    courseId: json['courseId'] as String,
    title: json['title'] as String,
    contentUrl: json['contentUrl'] as String? ?? '',
    type: json['type'] as String? ?? 'PDF',
    availability: CourseAvailability.values[json['availability'] as int? ?? 2],
    progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
  );

  ChapterModel copyWith({
    String? id,
    String? courseId,
    String? title,
    String? contentUrl,
    String? type,
    CourseAvailability? availability,
    double? progress,
  }) => ChapterModel(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    contentUrl: contentUrl ?? this.contentUrl,
    type: type ?? this.type,
    availability: availability ?? this.availability,
    progress: progress ?? this.progress,
  );
}

class NoteModel {
  final String id;
  final String chapterId;
  final String content;
  final DateTime createdAt;

  const NoteModel({
    required this.id,
    required this.chapterId,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'chapterId': chapterId,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
  };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'] as String,
    chapterId: json['chapterId'] as String,
    content: json['content'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

class QuizModel {
  final String id;
  final String chapterId;
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizModel({
    required this.id,
    required this.chapterId,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'chapterId': chapterId,
    'question': question,
    'options': options,
    'correctIndex': correctIndex,
  };

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
    id: json['id'] as String,
    chapterId: json['chapterId'] as String? ?? '',
    question: json['question'] as String,
    options: (json['options'] as List).cast<String>(),
    correctIndex: json['correctIndex'] as int,
  );

  QuizModel copyWith({
    String? id,
    String? chapterId,
    String? question,
    List<String>? options,
    int? correctIndex,
  }) => QuizModel(
    id: id ?? this.id,
    chapterId: chapterId ?? this.chapterId,
    question: question ?? this.question,
    options: options ?? this.options,
    correctIndex: correctIndex ?? this.correctIndex,
  );
}
