import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';
import '../services/storage_service.dart';

final coursesProvider = Provider<List<CourseModel>>((ref) {
  return StorageService.getCourses();
});

final chaptersProvider =
    Provider.family<List<ChapterModel>, String>((ref, courseId) {
  return StorageService.getChapters(courseId);
});

final notesProvider =
    Provider.family<List<NoteModel>, String>((ref, chapterId) {
  return StorageService.getNotes(chapterId);
});

final filteredCoursesProvider =
    Provider.family<List<CourseModel>, String>((ref, filter) {
  final courses = ref.watch(coursesProvider);
  if (filter == 'Tous') return courses;
  return courses.where((c) => c.type == filter).toList();
});
