import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/progression_model.dart';
import '../services/storage_service.dart';

/// État réactif de la progression de l'utilisateur.
final progressionProvider = StreamProvider<ProgressionSnapshot>((ref) {
  final ctrl = StreamController<ProgressionSnapshot>.broadcast();

  void emit() {
    ctrl.add(ProgressionSnapshot(
      streakDays: StorageService.getStreakDays(),
      globalProgress: StorageService.getGlobalProgress(),
      totalChaptersCompleted: StorageService.getChaptersCompletedCount(),
      totalChapters: totalChaptersCount(),
      totalQuizzesPassed: 0,
      studyMinutesToday: StorageService.getStudyMinutesToday(),
      studyMinutesThisWeek: StorageService.getStudyMinutesThisWeek(),
      totalStudyMinutes: totalStudyMinutes(),
    ));
  }

  emit();
  // Rafraîchir périodiquement
  final timer = Timer.periodic(const Duration(seconds: 5), (_) => emit());
  ref.onDispose(() {
    timer.cancel();
    ctrl.close();
  });
  return ctrl.stream;
});

/// Compte total de chapitres tous cours confondus.
int totalChaptersCount() {
  // Approximation : la somme des lessonCount de chaque cours
  return StorageService.getCourses().fold<int>(0, (sum, c) => sum + c.lessonCount);
}

/// Total des minutes d'étude depuis le début.
int totalStudyMinutes() {
  return StorageService.getStudySessions().fold<int>(0, (sum, s) => sum + (s['durationMinutes'] as int? ?? 0));
}

/// Enregistre une session d'étude.
final recordStudySessionProvider = Provider<void Function(int)>((ref) {
  return (int minutes) async {
    final id = StorageService.generateId();
    final session = {
      'id': id,
      'date': DateTime.now().toIso8601String(),
      'durationMinutes': minutes,
      'chaptersCompleted': 0,
      'quizzesPassed': 0,
    };
    await StorageService.saveStudySession(session);
    await StorageService.recordStudyActivity();
  };
});
