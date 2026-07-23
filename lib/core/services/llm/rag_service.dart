import '../storage_service.dart';

/// Couche RAG légère indexant le contenu stocké localement.
///
/// ## Principe
/// À partir des chapitres et notes déjà présents dans StorageService (Drift),
/// construit un contexte textuel qui sera passé au prompt du LLM.
/// Cela ancre les réponses dans le programme réel de l'élève plutôt que
/// dans la connaissance générale du modèle.
///
/// ## Stratégie d'indexation
/// - Pas de vector store coûteux (pas de embeddings on-device pour l'instant)
/// - Recherche par mot-clé simple sur les titres et contenus
/// - Limite de tokens contexte : 2048 tokens (~1500 mots)
class RagService {
  static const int _maxContextTokens = 2048;

  /// Construit le contexte RAG à partir du contenu local.
  ///
  /// [query] : la question de l'élève (utilisée pour le filtrage).
  /// Retourne une chaîne formatée pour le prompt.
  static String buildContext(String query) {
    final buffer = StringBuffer();
    int tokenCount = 0;

    buffer.writeln('Contexte pédagogique local :');
    buffer.writeln('---');
    tokenCount += 5;

    // 1. Parcourir les cours disponibles
    final courses = StorageService.getCourses();
    for (final course in courses) {
      if (tokenCount >= _maxContextTokens) break;

      // Vérifier la pertinence par mot-clé
      if (!_isRelevant(query, [course.title, course.subject, course.description])) {
        continue;
      }

      buffer.writeln('Cours: ${course.title} (${course.subject})');
      buffer.writeln('Description: ${course.description}');
      buffer.writeln('');
      tokenCount += estimateTokens(course.title) +
          estimateTokens(course.subject) +
          estimateTokens(course.description) + 5;

      // 2. Chapitres du cours
      final chapters = StorageService.getChapters(course.id);
      for (final chapter in chapters) {
        if (tokenCount >= _maxContextTokens) break;
        if (!_isRelevant(query, [chapter.title, chapter.type])) continue;

        buffer.writeln('  Chapitre: ${chapter.title} (${chapter.type})');
        tokenCount += estimateTokens(chapter.title) + 3;
      }
    }

    // 3. Notes personnelles
    final allCourses = StorageService.getCourses();
    for (final course in allCourses) {
      if (tokenCount >= _maxContextTokens) break;
      final chapters = StorageService.getChapters(course.id);
      for (final chapter in chapters) {
        if (tokenCount >= _maxContextTokens) break;
        final notes = StorageService.getNotes(chapter.id);
        for (final note in notes) {
          if (tokenCount >= _maxContextTokens) break;
          if (!_isRelevant(query, [note.content])) continue;

          buffer.writeln('Note personnelle: ${note.content}');
          tokenCount += estimateTokens(note.content) + 3;
        }
      }
    }

    buffer.writeln('---');
    buffer.writeln('Réponds à la question en français, en utilisant le contexte ci-dessus.');
    if (tokenCount >= _maxContextTokens) {
      buffer.writeln('(Contexte partiel — limite de tokens atteinte)');
    }

    return buffer.toString();
  }

  /// Vérifie si un texte est pertinent par rapport à la requête.
  static bool _isRelevant(String query, List<String> texts) {
    if (query.isEmpty) return true;
    final queryLower = query.toLowerCase();
    final queryWords = queryLower.split(RegExp(r'\s+'));

    for (final text in texts) {
      final textLower = text.toLowerCase();
      // Au moins un mot de la requête est présent dans le texte
      for (final word in queryWords) {
        if (word.length > 2 && textLower.contains(word)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Estimation grossière du nombre de tokens (1 token ≈ 4 caractères).
  static int estimateTokens(String text) => (text.length / 4).ceil();

  /// Retourne un résumé du contenu local (pour débogage / UI).
  static Map<String, int> getLocalContentSummary() {
    int courses = StorageService.getCourses().length;
    int chapters = 0;
    int notes = 0;

    for (final course in StorageService.getCourses()) {
      final chaps = StorageService.getChapters(course.id);
      chapters += chaps.length;
      for (final chap in chaps) {
        notes += StorageService.getNotes(chap.id).length;
      }
    }

    return {
      'courses': courses,
      'chapters': chapters,
      'notes': notes,
    };
  }
}
