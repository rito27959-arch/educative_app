import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';
import '../services/storage_service.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository();
});

class CourseRepository {
  List<CourseModel> getAllCourses() => StorageService.getCourses();

  List<CourseModel> getCoursesBySubject(String subject) {
    return StorageService.getCourses()
        .where((c) => c.subject == subject)
        .toList();
  }

  List<CourseModel> getCoursesByType(String type) {
    if (type == 'Tous') return StorageService.getCourses();
    return StorageService.getCourses()
        .where((c) => c.type == type)
        .toList();
  }

  List<CourseModel> searchCourses(String query) {
    if (query.isEmpty) return StorageService.getCourses();
    return StorageService.getCourses()
        .where((c) =>
            c.title.toLowerCase().contains(query.toLowerCase()) ||
            c.subject.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<ChapterModel> getChapters(String courseId) =>
      StorageService.getChapters(courseId);

  Future<void> saveCourse(CourseModel course) =>
      StorageService.saveCourse(course);

  Future<void> saveChapter(ChapterModel chapter) =>
      StorageService.saveChapter(chapter);

  List<NoteModel> getNotes(String chapterId) =>
      StorageService.getNotes(chapterId);

  Future<void> saveNote(NoteModel note) => StorageService.saveNote(note);

  double calculateGlobalProgress() {
    final courses = StorageService.getCourses();
    if (courses.isEmpty) return 0;
    return courses.fold(0.0, (sum, c) => sum + c.progress) / courses.length;
  }

  Map<String, double> getProgressBySubject() {
    final courses = StorageService.getCourses();
    final subjects = <String, List<double>>{};

    for (final course in courses) {
      subjects.putIfAbsent(course.subject, () => []);
      subjects[course.subject]!.add(course.progress);
    }

    return subjects.map(
      (key, value) => MapEntry(
        key,
        value.isEmpty ? 0 : value.fold(0.0, (a, b) => a + b) / value.length,
      ),
    );
  }

  int getTotalLessonCount() {
    return StorageService.getCourses()
        .fold(0, (sum, c) => sum + c.lessonCount);
  }

  int getCompletedLessonCount() {
    return StorageService.getCourses()
        .where((c) => c.progress >= 1.0)
        .length;
  }

  /// Marque un chapitre comme terminé et met à jour le streak.
  Future<void> markChapterComplete(String chapterId, String courseId) =>
      StorageService.markChapterComplete(chapterId, courseId);
}

class CourseDataGenerator {
  static List<CourseModel> generateSampleCourses() {
    return [
      // ═══════════════════════════════════════════
      // SÉRIE C — Mathématiques et Sciences Physiques
      // ═══════════════════════════════════════════
      CourseModel(
        id: 'c_maths',
        title: 'Mathématiques Série C',
        subject: 'Mathématiques',
        description: 'Programme officiel complet : nombres complexes, espaces vectoriels, matrices, analyse, suites, probabilités, géométrie. Coef 7.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 24,
        durationMinutes: 480,
      ),
      CourseModel(
        id: 'c_physique',
        title: 'Physique Série C',
        subject: 'Physique',
        description: 'Mécanique, électricité, optique, thermodynamique, physique nucléaire. Coef 5 (4 th + 1 pr).',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 18,
        durationMinutes: 360,
      ),
      CourseModel(
        id: 'c_chimie',
        title: 'Chimie Théorique et Pratique',
        subject: 'Chimie',
        description: 'Chimie générale, organique, solutions acido-basiques, thermochimie. Coef 2 (1.5 th + 0.5 pr).',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 12,
        durationMinutes: 240,
      ),
      CourseModel(
        id: 'c_svt',
        title: 'SVTEEHB Série C/TI',
        subject: 'SVTEEHB',
        description: 'Génétique, immunologie, écologie, biotechnologies. Coef 2.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 10,
        durationMinutes: 180,
      ),

      // ═══════════════════════════════════════════
      // SÉRIE D — Mathématiques et SVTEEHB
      // ═══════════════════════════════════════════
      CourseModel(
        id: 'd_svt',
        title: 'SVTEEHB Série D',
        subject: 'SVTEEHB',
        description: 'Programme complet : cellule, reproduction, évolution, physiologie humaine, immunologie, génétique, écosystèmes, biotechnologie. Coef 6 (4 th + 2 pr).',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 22,
        durationMinutes: 420,
      ),
      CourseModel(
        id: 'd_maths',
        title: 'Mathématiques Série D/TI',
        subject: 'Mathématiques',
        description: 'Suites numériques, nombres complexes, analyse, probabilités et statistiques, géométrie. Coef 4.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 18,
        durationMinutes: 360,
      ),
      CourseModel(
        id: 'd_physique',
        title: 'Physique Série D/TI',
        subject: 'Physique',
        description: 'Mécanique fondamentale, électricité, optique, thermodynamique. Coef 2.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 10,
        durationMinutes: 200,
      ),

      // ═══════════════════════════════════════════
      // SÉRIE TI — Technologies de l'Information
      // ═══════════════════════════════════════════
      CourseModel(
        id: 'ti_info',
        title: 'Informatique Série TI',
        subject: 'Informatique',
        description: 'Programme officiel complet : systèmes d\'information, bases de données SQL, réseaux TCP/IP, algorithmique et langage C, maintenance, infographie. Coef 5.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 20,
        durationMinutes: 400,
      ),

      // ═══════════════════════════════════════════
      // SÉRIE A — Lettres et Philosophie
      // ═══════════════════════════════════════════
      CourseModel(
        id: 'a_litterature',
        title: 'Littérature Série A',
        subject: 'Littérature',
        description: 'Contraction de texte, dissertation littéraire, commentaire composé, analyse de discours. Coef 3.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 14,
        durationMinutes: 280,
      ),
      CourseModel(
        id: 'a_philosophie',
        title: 'Philosophie Série A',
        subject: 'Philosophie',
        description: 'Existentialisme, morale, politique, logique, métaphysique, philosophie du langage, esthétique. Coef 2-3.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 16,
        durationMinutes: 320,
      ),
      CourseModel(
        id: 'a_histoire',
        title: 'Histoire Série A',
        subject: 'Histoire',
        description: 'Histoire contemporaine (XIXe-XXIe siècles), histoire du Cameroun et de l\'Afrique. Coef 3.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 12,
        durationMinutes: 240,
      ),
      CourseModel(
        id: 'a_francais',
        title: 'Français Série A',
        subject: 'Français',
        description: 'Expression écrite et orale, grammaire, vocabulaire, compréhension de texte. Coef 2.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 8,
        durationMinutes: 160,
      ),

      // ═══════════════════════════════════════════
      // TRONC COMMUN — Toutes séries scientifiques (C, D, E, TI)
      // ═══════════════════════════════════════════
      CourseModel(
        id: 'tc_philosophie',
        title: 'Philosophie Séries C, D, E, TI',
        subject: 'Philosophie',
        description: 'Programme tronc commun : le sujet, la culture, la raison et le réel, la morale et la politique. Coef 2.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 12,
        durationMinutes: 240,
      ),
      CourseModel(
        id: 'tc_litterature',
        title: 'Littérature ou Culture Générale',
        subject: 'Littérature',
        description: 'Dissertation, contraction de texte et discussion. Épreuve commune séries C, D, E, TI. Coef 2.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 10,
        durationMinutes: 200,
      ),
      CourseModel(
        id: 'tc_francais',
        title: 'Langue Française',
        subject: 'Français',
        description: 'Grammaire, orthographe, conjugaison, expression écrite. Épreuve commune toutes séries. Coef 2-3.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 8,
        durationMinutes: 160,
      ),
      CourseModel(
        id: 'tc_anglais',
        title: 'Anglais Tronc Commun',
        subject: 'Anglais',
        description: 'Grammar, vocabulary, reading comprehension, written expression. Commun aux séries C, D, E, TI. Coef 2-3.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 10,
        durationMinutes: 200,
      ),
      CourseModel(
        id: 'tc_ecm',
        title: 'Éducation à la Citoyenneté et à la Morale',
        subject: 'ECM',
        description: 'Valeurs civiques, droits de l\'homme, institutions camerounaises, développement durable. Coef 2.',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 8,
        durationMinutes: 160,
      ),
      CourseModel(
        id: 'tc_informatique',
        title: 'Informatique Tronc Commun',
        subject: 'Informatique',
        description: 'Généralités systèmes, algorithmique, programmation C, réseaux, infographie. Coef 2 (th) + 1 (pr).',
        type: 'PDF',
        availability: CourseAvailability.local,
        progress: 0.0,
        lessonCount: 12,
        durationMinutes: 240,
      ),
    ];
  }
}
