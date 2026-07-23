import 'package:flutter_test/flutter_test.dart';
import 'package:ouro_prep/core/services/gamification_service.dart';

void main() {
  group('ProgressionState', () {
    test('default state has empty sets', () {
      const state = ProgressionState();
      expect(state.completedSections, isEmpty);
      expect(state.passedChapterExams, isEmpty);
      expect(state.passedSubjectExams, isEmpty);
    });

    test('copyWith creates modified copy', () {
      const state = ProgressionState();
      final modified = state.copyWith(
        completedSections: {'sec-1'},
        passedChapterExams: {'exam-1'},
      );
      expect(modified.completedSections, {'sec-1'});
      expect(modified.passedChapterExams, {'exam-1'});
      expect(modified.passedSubjectExams, isEmpty);
    });

    test('copyWith preserves original', () {
      const original = ProgressionState();
      original.copyWith(completedSections: {'sec-1'});
      expect(original.completedSections, isEmpty);
    });

    test('toJson serializes correctly', () {
      const state = ProgressionState(
        completedSections: {'s1', 's2'},
        passedChapterExams: {'e1'},
        passedSubjectExams: {'se1'},
      );
      final json = state.toJson();
      expect(json['completedSections'], containsAll(['s1', 's2']));
      expect(json['passedChapterExams'], ['e1']);
      expect(json['passedSubjectExams'], ['se1']);
    });

    test('fromJson parses correctly', () {
      final json = {
        'completedSections': ['a', 'b'],
        'passedChapterExams': ['c'],
        'passedSubjectExams': ['d'],
      };
      final state = ProgressionState.fromJson(json);
      expect(state.completedSections, {'a', 'b'});
      expect(state.passedChapterExams, {'c'});
      expect(state.passedSubjectExams, {'d'});
    });

    test('fromJson handles missing fields', () {
      final state = ProgressionState.fromJson({});
      expect(state.completedSections, isEmpty);
      expect(state.passedChapterExams, isEmpty);
      expect(state.passedSubjectExams, isEmpty);
    });

    test('toJson → fromJson round-trip', () {
      const original = ProgressionState(
        completedSections: {'s1'},
        passedChapterExams: {'e1'},
        passedSubjectExams: {'se1'},
      );
      final roundTripped = ProgressionState.fromJson(original.toJson());
      expect(roundTripped.completedSections, original.completedSections);
      expect(roundTripped.passedChapterExams, original.passedChapterExams);
      expect(roundTripped.passedSubjectExams, original.passedSubjectExams);
    });
  });

  group('GamificationService state', () {
    test('completeSection adds to completedSections', () {
      final before = GamificationService.state.completedSections.length;
      GamificationService.completeSection('test-sec-${before + 100}');
      expect(
        GamificationService.state.completedSections.length,
        greaterThan(before),
      );
    });

    test('passChapterExam adds to passedChapterExams', () {
      final before = GamificationService.state.passedChapterExams.length;
      GamificationService.passChapterExam('test-ch-exam-${before + 100}');
      expect(
        GamificationService.state.passedChapterExams.length,
        greaterThan(before),
      );
    });

    test('passSubjectExam adds to passedSubjectExams', () {
      final before = GamificationService.state.passedSubjectExams.length;
      GamificationService.passSubjectExam('test-subj-exam-${before + 100}');
      expect(
        GamificationService.state.passedSubjectExams.length,
        greaterThan(before),
      );
    });

    test('passSubjectExam does not affect other sets', () {
      final sectionsBefore = GamificationService.state.completedSections.length;
      final chaptersBefore = GamificationService.state.passedChapterExams.length;
      GamificationService.passSubjectExam('unique-subj-exam-x');
      expect(
        GamificationService.state.completedSections.length,
        sectionsBefore,
      );
      expect(
        GamificationService.state.passedChapterExams.length,
        chaptersBefore,
      );
    });
  });

  group('GamificationService progress', () {
    test('chapterProgress returns 0.0 with no chapters (empty content)', () {
      expect(GamificationService.chapterProgress('nonexistent', 'nonexistent'), 0.0);
    });

    test('courseProgress returns 0.0 with no chapters', () {
      expect(GamificationService.courseProgress('nonexistent'), 0.0);
    });
  });

  group('GamificationService content access', () {
    test('getCourseData returns null for unknown course', () {
      expect(GamificationService.getCourseData('nonexistent'), isNull);
    });

    test('getChapters returns empty for unknown course', () {
      expect(GamificationService.getChapters('nonexistent'), isEmpty);
    });

    test('getChapterData returns null for unknown', () {
      expect(
        GamificationService.getChapterData('nonexistent', 'nonexistent'),
        isNull,
      );
    });

    test('getSections returns empty for unknown', () {
      expect(
        GamificationService.getSections('nonexistent', 'nonexistent'),
        isEmpty,
      );
    });

    test('getSubjectExam returns null for unknown course', () {
      expect(GamificationService.getSubjectExam('nonexistent'), isNull);
    });

    test('getChapterExam returns null for unknown', () {
      expect(
        GamificationService.getChapterExam('nonexistent', 'nonexistent'),
        isNull,
      );
    });
  });

  group('GamificationService unlock logic', () {
    test('isSectionUnlocked returns true for nonexistent content', () {
      expect(
        GamificationService.isSectionUnlocked('sec', 'course', 'ch'),
        true,
      );
    });

    test('isChapterUnlocked returns true for nonexistent content', () {
      expect(
        GamificationService.isChapterUnlocked('ch', 'course'),
        true,
      );
    });

    test('isSubjectExamUnlocked returns false for nonexistent course', () {
      expect(
        GamificationService.isSubjectExamUnlocked('nonexistent'),
        false,
      );
    });
  });
}
