import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';
import '../services/storage_service.dart';
import '../services/content_service.dart';
import '../repositories/course_repository.dart';

final seedingProvider = FutureProvider<void>((ref) async {
  final courses = StorageService.getCourses();
  if (courses.isNotEmpty) return;
  for (final course in CourseDataGenerator.generateSampleCourses()) {
    await StorageService.saveCourse(course);
  }
  final json = await ContentService.load();
  for (final entry in json.entries) {
    final courseId = entry.key;
    final chapters = entry.value['chapters'] as List<dynamic>? ?? [];
    for (final ch in chapters) {
      final chId = ch['id'] as String? ?? '';
      final chTitle = ch['title'] as String? ?? '';
      if (chId.isNotEmpty) {
        await StorageService.saveChapter(ChapterModel(
          id: chId,
          courseId: courseId,
          title: chTitle,
          type: 'PDF',
          availability: CourseAvailability.local,
        ));
      }
    }
  }
});

final coursesProvider = Provider<List<CourseModel>>((ref) {
  return StorageService.getCourses();
});
