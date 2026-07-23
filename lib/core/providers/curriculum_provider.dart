import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/curriculum_data.dart';
import '../models/curriculum_progress.dart';
import 'gamification_provider.dart';

final curriculumProgressProvider = StateNotifierProvider<CurriculumNotifier, CurriculumProgress>((ref) {
  return CurriculumNotifier(ref);
});

final subjectProgressProvider = Provider.family<double, String>((ref, subjectId) {
  final progress = ref.watch(curriculumProgressProvider);
  final subject = CurriculumData.findById(subjectId);
  if (subject == null || subject.chapters.isEmpty) return 0.0;
  int total = 0, done = 0;
  for (final chapter in subject.chapters) {
    for (final lesson in chapter.lessons) {
      total++;
      if (progress.completedLessons.contains(lesson.id)) done++;
    }
  }
  return total > 0 ? done / total : 0.0;
});

final isLessonCompletedProvider = Provider.family<bool, String>((ref, lessonId) {
  return ref.watch(curriculumProgressProvider).completedLessons.contains(lessonId);
});

final isChapterCompletedProvider = Provider.family<bool, String>((ref, chapterId) {
  return ref.watch(curriculumProgressProvider).completedChapters.contains(chapterId);
});

final nextLessonProvider = Provider.family<String?, String>((ref, chapterId) {
  final progress = ref.watch(curriculumProgressProvider);
  final chapter = CurriculumData.findChapterById(chapterId);
  if (chapter == null) return null;
  for (final lesson in chapter.lessons) {
    if (!progress.completedLessons.contains(lesson.id)) return lesson.id;
  }
  return null;
});

class CurriculumNotifier extends StateNotifier<CurriculumProgress> {
  final Ref _ref;
  final _rand = Random();

  CurriculumNotifier(this._ref) : super(CurriculumProgress.empty);

  void completeLesson(String lessonId, {int score = 100}) {
    final updated = state.copyWith(
      completedLessons: {...state.completedLessons, lessonId},
      lessonScores: {...state.lessonScores, lessonId: max(state.lessonScores[lessonId] ?? 0, score)},
      lastActivity: DateTime.now(),
    );
    state = updated;
    _ref.read(gamificationStateProvider.notifier).recordLesson();
    _checkChapterComplete(lessonId);
  }

  void _checkChapterComplete(String lessonId) {
    final lesson = CurriculumData.findLessonById(lessonId);
    if (lesson == null) return;
    final chapter = CurriculumData.findChapterById(lesson.id);
    if (chapter == null) return;
    final allDone = chapter.lessons.every((l) => state.completedLessons.contains(l.id));
    if (allDone) {
      state = state.copyWith(completedChapters: {...state.completedChapters, chapter.id});
      _checkSubjectComplete(chapter.subjectId);
    }
  }

  void _checkSubjectComplete(String subjectId) {
    final subject = CurriculumData.findById(subjectId);
    if (subject == null) return;
    final allDone = subject.chapters.every((c) => state.completedChapters.contains(c.id));
    if (allDone && !state.completedSubjects.contains(subjectId)) {
      state = state.copyWith(completedSubjects: {...state.completedSubjects, subjectId});
    }
  }

  void recordChapterExamScore(String chapterId, int score) {
    state = state.copyWith(
      chapterScores: {...state.chapterScores, chapterId: max(state.chapterScores[chapterId] ?? 0, score)},
      lastActivity: DateTime.now(),
    );
  }

  void recordSubjectExamScore(String subjectId, int score) {
    state = state.copyWith(
      subjectScores: {...state.subjectScores, subjectId: max(state.subjectScores[subjectId] ?? 0, score)},
      lastActivity: DateTime.now(),
    );
  }

  String? firstUnfinishedLesson(String chapterId) {
    final chapter = CurriculumData.findChapterById(chapterId);
    if (chapter == null) return null;
    for (final lesson in chapter.lessons) {
      if (!state.completedLessons.contains(lesson.id)) return lesson.id;
    }
    return null;
  }

  String? firstUnfinishedChapter(String subjectId) {
    final subject = CurriculumData.findById(subjectId);
    if (subject == null) return null;
    for (final chapter in subject.chapters) {
      if (!state.completedChapters.contains(chapter.id)) return chapter.id;
    }
    return null;
  }
}
