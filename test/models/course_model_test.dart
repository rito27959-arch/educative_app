import 'package:flutter_test/flutter_test.dart';
import 'package:ouro_prep/core/models/course_model.dart';

void main() {
  final sampleJson = <String, dynamic>{
    'id': 'course-1',
    'title': 'Maths Terminale',
    'subject': 'Mathématiques',
    'description': 'Cours complet',
    'type': 'PDF',
    'availability': 0,
    'progress': 0.75,
    'imageUrl': 'https://example.com/img.png',
    'lessonCount': 12,
    'durationMinutes': 360,
  };

  group('CourseModel.fromJson', () {
    test('parses all fields correctly', () {
      final course = CourseModel.fromJson(sampleJson);
      expect(course.id, 'course-1');
      expect(course.title, 'Maths Terminale');
      expect(course.subject, 'Mathématiques');
      expect(course.description, 'Cours complet');
      expect(course.type, 'PDF');
      expect(course.availability, CourseAvailability.local);
      expect(course.progress, 0.75);
      expect(course.imageUrl, 'https://example.com/img.png');
      expect(course.lessonCount, 12);
      expect(course.durationMinutes, 360);
    });

    test('handles missing optional fields with defaults', () {
      final minimal = {
        'id': 'c1',
        'title': 'Title',
        'subject': 'Subject',
      };
      final course = CourseModel.fromJson(minimal);
      expect(course.description, '');
      expect(course.type, 'PDF');
      expect(course.availability, CourseAvailability.cloud);
      expect(course.progress, 0.0);
      expect(course.imageUrl, '');
      expect(course.lessonCount, 0);
      expect(course.durationMinutes, 0);
    });

    test('parses all availability values', () {
      for (var i = 0; i < CourseAvailability.values.length; i++) {
        final json = {...minimalJson, 'availability': i};
        final course = CourseModel.fromJson(json);
        expect(course.availability, CourseAvailability.values[i]);
      }
    });
  });

  group('CourseModel.toJson', () {
    test('serializes all fields', () {
      final course = CourseModel.fromJson(sampleJson);
      final json = course.toJson();
      expect(json['id'], 'course-1');
      expect(json['title'], 'Maths Terminale');
      expect(json['subject'], 'Mathématiques');
      expect(json['description'], 'Cours complet');
      expect(json['type'], 'PDF');
      expect(json['availability'], 0);
      expect(json['progress'], 0.75);
      expect(json['imageUrl'], 'https://example.com/img.png');
      expect(json['lessonCount'], 12);
      expect(json['durationMinutes'], 360);
    });

    test('round-trip fromJson → toJson preserves data', () {
      final course = CourseModel.fromJson(sampleJson);
      final roundTripped = CourseModel.fromJson(course.toJson());
      expect(roundTripped.id, course.id);
      expect(roundTripped.title, course.title);
      expect(roundTripped.progress, course.progress);
    });
  });

  group('CourseModel.copyWith', () {
    test('copies with no changes', () {
      final original = CourseModel.fromJson(sampleJson);
      final copy = original.copyWith();
      expect(copy.id, original.id);
      expect(copy.title, original.title);
      expect(copy.progress, original.progress);
    });

    test('copies with specific field changes', () {
      final original = CourseModel.fromJson(sampleJson);
      final copy = original.copyWith(title: 'New Title', progress: 1.0);
      expect(copy.title, 'New Title');
      expect(copy.progress, 1.0);
      expect(copy.id, original.id);
      expect(copy.subject, original.subject);
    });
  });

  group('CourseModel equality', () {
    test('two models with same data have identical toJson', () {
      final a = CourseModel.fromJson(sampleJson);
      final b = CourseModel.fromJson(sampleJson);
      expect(a.toJson(), equals(b.toJson()));
    });

    test('two models with different data have different toJson', () {
      final a = CourseModel.fromJson(sampleJson);
      final b = a.copyWith(title: 'Different');
      expect(a.toJson(), isNot(equals(b.toJson())));
    });
  });

  group('ChapterModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'ch-1',
        'courseId': 'course-1',
        'title': 'Chapitre 1',
        'contentUrl': 'https://example.com/ch1.pdf',
        'type': 'PDF',
        'availability': 1,
        'progress': 0.5,
      };
      final ch = ChapterModel.fromJson(json);
      expect(ch.id, 'ch-1');
      expect(ch.courseId, 'course-1');
      expect(ch.title, 'Chapitre 1');
      expect(ch.availability, CourseAvailability.mesh);
      expect(ch.progress, 0.5);
    });

    test('toJson round-trips correctly', () {
      final ch = ChapterModel(
        id: 'ch-1',
        courseId: 'c1',
        title: 'Test',
      );
      final roundTripped = ChapterModel.fromJson(ch.toJson());
      expect(roundTripped.id, ch.id);
      expect(roundTripped.title, ch.title);
    });

    test('copyWith works', () {
      final ch = ChapterModel(id: 'ch-1', courseId: 'c1', title: 'Old');
      final copy = ch.copyWith(title: 'New');
      expect(copy.title, 'New');
      expect(copy.id, 'ch-1');
    });
  });

  group('NoteModel', () {
    test('fromJson parses correctly', () {
      final now = DateTime(2026, 7, 15, 10, 30);
      final json = {
        'id': 'n-1',
        'chapterId': 'ch-1',
        'content': 'My note',
        'createdAt': now.toIso8601String(),
      };
      final note = NoteModel.fromJson(json);
      expect(note.id, 'n-1');
      expect(note.chapterId, 'ch-1');
      expect(note.content, 'My note');
      expect(note.createdAt, now);
    });

    test('toJson round-trips correctly', () {
      final note = NoteModel(
        id: 'n-1',
        chapterId: 'ch-1',
        content: 'Note content',
        createdAt: DateTime(2026, 7, 15),
      );
      final roundTripped = NoteModel.fromJson(note.toJson());
      expect(roundTripped.id, note.id);
      expect(roundTripped.content, note.content);
    });
  });

  group('QuizModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'q-1',
        'chapterId': 'ch-1',
        'question': '2+2=?',
        'options': ['3', '4', '5'],
        'correctIndex': 1,
      };
      final quiz = QuizModel.fromJson(json);
      expect(quiz.id, 'q-1');
      expect(quiz.question, '2+2=?');
      expect(quiz.options, ['3', '4', '5']);
      expect(quiz.correctIndex, 1);
    });

    test('toJson round-trips correctly', () {
      final quiz = QuizModel(
        id: 'q-1',
        chapterId: 'ch-1',
        question: 'Test?',
        options: ['A', 'B'],
        correctIndex: 0,
      );
      final roundTripped = QuizModel.fromJson(quiz.toJson());
      expect(roundTripped.id, quiz.id);
      expect(roundTripped.options, quiz.options);
    });

    test('copyWith works', () {
      final quiz = QuizModel(
        id: 'q-1',
        chapterId: 'ch-1',
        question: 'Old?',
        options: ['A', 'B'],
        correctIndex: 0,
      );
      final copy = quiz.copyWith(question: 'New?');
      expect(copy.question, 'New?');
      expect(copy.options, quiz.options);
    });
  });
}

const minimalJson = <String, dynamic>{
  'id': 'c1',
  'title': 'T',
  'subject': 'S',
};
