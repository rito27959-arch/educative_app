import 'dart:math';

class ReasoningEvaluationResult {
  final double score;
  final bool passed;
  final double conceptScore;
  final double reasoningScore;
  final double relevanceScore;
  final String feedback;
  final List<String> conceptsFound;
  final List<String> conceptsMissing;
  final List<String> reasoningIndicatorsFound;

  const ReasoningEvaluationResult({
    required this.score,
    required this.passed,
    required this.conceptScore,
    required this.reasoningScore,
    required this.relevanceScore,
    required this.feedback,
    required this.conceptsFound,
    required this.conceptsMissing,
    required this.reasoningIndicatorsFound,
  });
}

class ReasoningEngine {
  ReasoningEngine._();

  static const double _passThreshold = 0.6;

  static final Set<String> _frenchStopWords = {
    'le', 'la', 'les', 'un', 'une', 'des', 'du', 'de', 'ce', 'ces', 'cet',
    'et', 'ou', 'mais', 'donc', 'car', 'ni', 'or',
    'dans', 'sur', 'sous', 'avec', 'pour', 'par', 'sans', 'chez', 'vers',
    'je', 'tu', 'il', 'elle', 'nous', 'vous', 'ils', 'elles',
    'mon', 'ton', 'son', 'ma', 'ta', 'sa', 'mes', 'tes', 'ses',
    'notre', 'votre', 'leur', 'nos', 'vos', 'leurs',
    'ai', 'as', 'a', 'avons', 'avez', 'ont', 'avais', 'avait',
    'suis', 'es', 'est', 'sommes', 'etes', 'sont', 'etais', 'etait',
    'que', 'qui', 'dont',
    'ne', 'pas', 'plus', 'peu', 'tres', 'bien', 'mal',
    'en', 'y', 'se', 'me', 'te',
    'cela', 'ca', 'ceci',
    'quoi', 'quel', 'quelle', 'quels', 'quelles',
    'lui', 'eux',
    'non', 'oui', 'si', 'aussi', 'alors',
    'tous', 'toute', 'toutes', 'tout',
    'chaque', 'certains', 'plusieurs', 'quelques',
    'autre', 'dautre', 'dautres', 'autres',
    'premier', 'second', 'dernier',
    'avoir', 'etre', 'faire', 'dire', 'aller',
    'voir', 'savoir', 'pouvoir', 'vouloir', 'devoir',
    'falloir', 'valoir', 'mieux', 'moins',
    'trop', 'assez', 'tellement', 'autant',
    'encore', 'jamais', 'toujours', 'parfois', 'souvent',
    'comme', 'ainsi', 'puis', 'ensuite', 'enfin',
    'voici', 'voila', 'cest',
  };

  static final Set<String> _reasoningIndicators = {
    'donc', 'parce que', 'car', 'puisque', 'etant donne', 'vu que',
    'si', 'alors', 'par consequent', 'ainsi', 'c\'est pourquoi',
    'en effet', 'effectivement', 'notamment',
    'd\'abord', 'ensuite', 'en premier lieu', 'en second lieu',
    'premièrement', 'deuxièmement', 'troisièmement',
    'd\'une part', 'd\'autre part',
    'par ailleurs', 'de plus', 'en outre', 'supplément',
    'or', 'cependant', 'néanmoins', 'toutefois', 'pourtant',
    'bien que', 'malgré', 'quoique', 'en dépit de',
    'conclusion', 'en conclusion', 'pour conclure', 'finalement',
    'en résumé', 'bref', 'en somme',
    'cela implique', 'il en résulte', 'il s\'ensuit',
    'supposons', 'considérons', 'admettons',
    'on a', 'nous avons', 'on obtient', 'on trouve',
    'calculons', 'déterminons', 'résolvons',
    'étape', 'etape', 'step',
    'raison', 'raisonnement', 'logique',
    'hypothèse', 'hypothese', 'hypothèses',
    'théorème', 'theoreme', 'propriété', 'propriete',
    'démonstration', 'demonstration', 'preuve',
  };

  static ReasoningEvaluationResult evaluate({
    required String studentAnswer,
    required String expectedAnswer,
  }) {
    final studentNorm = _normalize(studentAnswer);
    final expectedNorm = _normalize(expectedAnswer);

    final studentTokens = _tokenize(studentNorm);
    final expectedTokens = _tokenize(expectedNorm);

    final expectedConcepts = _extractKeyConcepts(expectedTokens);

    final conceptScore = _computeConceptScore(
      expectedConcepts, studentNorm, studentTokens,
    );

    final reasoningScore = _computeReasoningScore(studentNorm);

    final relevanceScore = _computeRelevanceScore(
      studentTokens, expectedTokens,
    );

    final conceptsFound = expectedConcepts.where(
      (c) => studentNorm.contains(c),
    ).toList();

    final conceptsMissing = expectedConcepts.where(
      (c) => !studentNorm.contains(c),
    ).toList();

    final reasoningIndicatorsFound = _reasoningIndicators.where(
      (ind) => studentNorm.contains(ind),
    ).toList();

    final score = (conceptScore * 0.45 + reasoningScore * 0.30 + relevanceScore * 0.25)
        .clamp(0.0, 1.0);

    final passed = score >= _passThreshold;

    final feedback = _generateFeedback(
      score, conceptScore, reasoningScore, relevanceScore,
      conceptsFound, conceptsMissing, reasoningIndicatorsFound,
      passed,
    );

    return ReasoningEvaluationResult(
      score: (score * 100).roundToDouble(),
      passed: passed,
      conceptScore: (conceptScore * 100).roundToDouble(),
      reasoningScore: (reasoningScore * 100).roundToDouble(),
      relevanceScore: (relevanceScore * 100).roundToDouble(),
      feedback: feedback,
      conceptsFound: conceptsFound,
      conceptsMissing: conceptsMissing,
      reasoningIndicatorsFound: reasoningIndicatorsFound,
    );
  }

  static String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r"[^\w\sàâäéèêëîïôöùûüçÀÂÄÉÈÊËÎÏÔÖÙÛÜÇ'\-]"), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static List<String> _tokenize(String text) {
    return text.split(' ').where((t) => t.isNotEmpty).toList();
  }

  static List<String> _extractKeyConcepts(List<String> tokens) {
    final filtered = tokens.where((t) {
      return t.length > 2 && !_frenchStopWords.contains(t);
    }).toList();

    final freq = <String, int>{};
    for (final t in filtered) {
      freq[t] = (freq[t] ?? 0) + 1;
    }

    final sorted = freq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxKeep = max(3, (sorted.length * 0.5).ceil());
    return sorted.take(maxKeep).map((e) => e.key).toList();
  }

  static double _computeConceptScore(
    List<String> expectedConcepts,
    String studentNorm,
    List<String> studentTokens,
  ) {
    if (expectedConcepts.isEmpty) return 1.0;

    int found = 0;
    for (final concept in expectedConcepts) {
      if (studentNorm.contains(concept)) {
        found++;
      }
    }

    final ratio = found / expectedConcepts.length;
    final lengthFactor = (studentTokens.length / 5.0).clamp(0.0, 1.0);
    return (ratio * 0.7 + lengthFactor * 0.3).clamp(0.0, 1.0);
  }

  static double _computeReasoningScore(String studentNorm) {
    int count = 0;
    for (final indicator in _reasoningIndicators) {
      if (studentNorm.contains(indicator)) {
        count++;
      }
    }

    final indicatorScore = (count / 3.0).clamp(0.0, 1.0);

    final sentences = studentNorm.split(RegExp(r'[.!?]')).where((s) => s.trim().isNotEmpty).toList();
    final structureScore = (sentences.length / 3.0).clamp(0.0, 1.0);

    return (indicatorScore * 0.6 + structureScore * 0.4).clamp(0.0, 1.0);
  }

  static double _computeRelevanceScore(
    List<String> studentTokens,
    List<String> expectedTokens,
  ) {
    if (studentTokens.isEmpty || expectedTokens.isEmpty) return 0.0;

    final studentFiltered = studentTokens
        .where((t) => t.length > 2 && !_frenchStopWords.contains(t))
        .toSet();
    final expectedFiltered = expectedTokens
        .where((t) => t.length > 2 && !_frenchStopWords.contains(t))
        .toSet();

    if (expectedFiltered.isEmpty) return 1.0;
    if (studentFiltered.isEmpty) return 0.0;

    final intersection = studentFiltered.intersection(expectedFiltered).length;
    final union = studentFiltered.union(expectedFiltered).length;

    if (union == 0) return 0.0;
    final jaccard = intersection / union;

    final coverage = intersection / expectedFiltered.length;

    return (jaccard * 0.5 + coverage * 0.5).clamp(0.0, 1.0);
  }

  static String _generateFeedback(
    double score,
    double conceptScore,
    double reasoningScore,
    double relevanceScore,
    List<String> conceptsFound,
    List<String> conceptsMissing,
    List<String> reasoningIndicatorsFound,
    bool passed,
  ) {
    final parts = <String>[];

    if (passed) {
      parts.add('Bonne démonstration de ton raisonnement.');
    } else {
      parts.add('Ton raisonnement peut être approfondi.');
    }

    if (conceptScore < 0.5 && conceptsMissing.isNotEmpty) {
      final few = conceptsMissing.take(3).join(', ');
      parts.add('Concepts à développer : $few.');
    } else if (conceptScore >= 0.8) {
      parts.add('Bonne couverture des concepts clés.');
    }

    if (reasoningScore < 0.4) {
      parts.add('Structure ton raisonnement (utilise des connecteurs logiques : donc, par conséquent, si...alors).');
    } else if (reasoningScore >= 0.7) {
      parts.add('Raisonnement bien structuré.');
    }

    if (relevanceScore < 0.4) {
      parts.add('Recentrage sur le sujet demandé.');
    }

    if (parts.length > 1) {
      return parts.join(' ');
    }
    return parts.isEmpty ? 'Réponse soumise.' : parts.first;
  }
}
