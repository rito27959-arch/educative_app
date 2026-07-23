import 'package:flutter_test/flutter_test.dart';
import 'package:ouro_prep/core/services/storage_service.dart';
import 'package:ouro_prep/core/models/course_model.dart';

void main() {
  group('StorageService.getString / setString', () {
    test('returns null for nonexistent key', () {
      expect(StorageService.getString('nonexistent_key_xyz'), isNull);
    });

    test('round-trip setString then getString', () async {
      await StorageService.setString('test_key', 'test_value');
      expect(StorageService.getString('test_key'), 'test_value');
    });

    test('overwrites existing value', () async {
      await StorageService.setString('overwritten', 'first');
      await StorageService.setString('overwritten', 'second');
      expect(StorageService.getString('overwritten'), 'second');
    });

    test('stores empty string', () async {
      await StorageService.setString('empty_key', '');
      expect(StorageService.getString('empty_key'), '');
    });

    test('stores various types as strings', () async {
      await StorageService.setString('num_str', '42');
      expect(StorageService.getString('num_str'), '42');

      await StorageService.setString('bool_str', 'true');
      expect(StorageService.getString('bool_str'), 'true');
    });

    tearDown(() async {
      await StorageService.remove('test_key');
      await StorageService.remove('overwritten');
      await StorageService.remove('empty_key');
      await StorageService.remove('num_str');
      await StorageService.remove('bool_str');
    });
  });

  group('StorageService.remove', () {
    test('removes a key', () async {
      await StorageService.setString('to_remove', 'value');
      expect(StorageService.getString('to_remove'), 'value');
      await StorageService.remove('to_remove');
      expect(StorageService.getString('to_remove'), isNull);
    });

    test('removing nonexistent key does not throw', () async {
      await StorageService.remove('never_existed');
    });
  });

  group('StorageService.getCourses', () {
    test('returns a List<CourseModel> (empty without DB)', () {
      final courses = StorageService.getCourses();
      expect(courses, isA<List>());
    });
  });

  group('StorageService.saveChapter', () {
    test('completes without error when no DB', () async {
      final chapter = ChapterModel(
        id: 'ch-test-1',
        courseId: 'course-test-1',
        title: 'Chapitre Test',
      );
      await StorageService.saveChapter(chapter);
    });

    test('getChapters returns empty for unknown course without DB', () {
      final chapters = StorageService.getChapters('nonexistent_course');
      expect(chapters, isEmpty);
    });
  });

  group('StorageService.setOnboardingComplete', () {
    test('marks onboarding as complete', () async {
      await StorageService.setOnboardingComplete();
      expect(StorageService.isOnboardingComplete(), true);
    });

    test('isOnboardingComplete returns false initially (after cleanup)', () async {
      await StorageService.remove('onboarding_complete');
      expect(StorageService.isOnboardingComplete(), false);
    });
  });

  group('StorageService settings', () {
    test('getSettings returns null when empty', () async {
      await StorageService.remove('setting_a');
      await StorageService.remove('setting_b');
      final s = StorageService.getSettings();
      expect(s, isNull);
    });

    test('saveSettings persists key-value pairs', () async {
      await StorageService.saveSettings({'key_a': 'val_a', 'key_b': 'val_b'});
      final s = StorageService.getSettings();
      expect(s, isNotNull);
      expect(s!['key_a'], 'val_a');
    });

    tearDown(() async {
      await StorageService.remove('key_a');
      await StorageService.remove('key_b');
    });
  });

  group('StorageService streak', () {
    test('getStreakDays returns 0 initially', () async {
      await StorageService.remove('streak_days');
      expect(StorageService.getStreakDays(), 0);
    });

    test('recordStudyActivity returns 1 on first call', () async {
      await StorageService.remove('streak_days');
      await StorageService.remove('last_study_date');
      final result = await StorageService.recordStudyActivity();
      expect(result, 1);
    });
  });

  group('StorageService quiz score', () {
    test('getQuizScore returns 0 initially', () async {
      await StorageService.remove('quiz_score');
      expect(StorageService.getQuizScore(), 0);
    });

    test('saveQuizScore persists score', () async {
      await StorageService.saveQuizScore(85);
      expect(StorageService.getQuizScore(), 85);
      await StorageService.remove('quiz_score');
    });
  });

  group('StorageService outbox', () {
    test('getOutbox returns empty initially', () async {
      await StorageService.clearOutbox();
      expect(StorageService.getOutbox(), isEmpty);
    });

    test('saveOutbox adds entry', () async {
      await StorageService.clearOutbox();
      await StorageService.saveOutbox({'id': 'msg-1', 'content': 'hello'});
      final outbox = StorageService.getOutbox();
      expect(outbox.length, 1);
      expect(outbox[0]['id'], 'msg-1');
    });

    test('clearOutbox removes all entries', () async {
      await StorageService.saveOutbox({'id': 'msg-2'});
      await StorageService.clearOutbox();
      expect(StorageService.getOutbox(), isEmpty);
    });
  });

  group('StorageService generateId', () {
    test('generates unique IDs', () {
      final id1 = StorageService.generateId();
      final id2 = StorageService.generateId();
      expect(id1, isNot(equals(id2)));
      expect(id1.isNotEmpty, true);
    });
  });

  group('StorageService study sessions', () {
    test('getStudySessions returns empty initially', () async {
      await StorageService.remove('study_sessions');
      expect(StorageService.getStudySessions(), isEmpty);
    });
  });

  group('StorageService messages', () {
    test('getMessages returns a list', () {
      final msgs = StorageService.getMessages();
      expect(msgs, isA<List>());
    });

    test('getMessageCount returns count', () {
      final count = StorageService.getMessageCount();
      expect(count, isA<int>());
      expect(count, greaterThanOrEqualTo(0));
    });
  });

  group('StorageService getMessagesPaginated', () {
    test('returns empty list when offset exceeds messages', () {
      final result = StorageService.getMessagesPaginated(offset: 9999);
      expect(result, isEmpty);
    });
  });

  group('StorageService contribution events', () {
    test('addContributionEvent and getContributionEvents', () async {
      final before = StorageService.getContributionEvents().length;
      await StorageService.addContributionEvent(type: 'relay', points: 10);
      final after = StorageService.getContributionEvents().length;
      expect(after, greaterThan(before));
    });

    test('getContributionPoints aggregates correctly', () async {
      await StorageService.addContributionEvent(type: 'relay', points: 10);
      final points = StorageService.getContributionPoints();
      expect(points.total, greaterThanOrEqualTo(10));
    });
  });
}
