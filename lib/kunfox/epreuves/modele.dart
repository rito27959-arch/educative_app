// Une épreuve type Bac (Office du Baccalauréat du Cameroun) :
// des exercices notés, chacun avec un énoncé riche (formules, courbes,
// tableaux) et des questions de plusieurs sortes.
//
// Correction :
//  - QCM, vrai/faux, nombre, expression, réponse courte : automatique ;
//  - rédaction (démonstration, justification, dissertation) : l'élève lit
//    le corrigé détaillé et coche les points du barème qu'il a obtenus.

import '../riche/expressions.dart';

enum GenreQuestion { qcm, vraiFaux, nombre, expression, courte, redaction }

class Critere {
  const Critere(this.texte, this.points);
  final String texte;
  final double points;
}

class QuestionEpreuve {
  const QuestionEpreuve._({
    required this.genre,
    required this.numero,
    required this.enonce,
    required this.points,
    required this.corrige,
    this.options = const [],
    this.bonne = 0,
    this.valeur,
    this.tolerance = 0.01,
    this.unite,
    this.expression,
    this.variable = 'x',
    this.acceptees = const [],
    this.bareme = const [],
    this.chapitre,
  });

  /// QCM : une seule bonne réponse.
  const QuestionEpreuve.qcm(String numero, String enonce,
      {required List<String> options, required int bonne, required double points, required String corrige, String? chapitre})
      : this._(
            genre: GenreQuestion.qcm,
            numero: numero,
            enonce: enonce,
            options: options,
            bonne: bonne,
            points: points,
            corrige: corrige,
            chapitre: chapitre);

  /// Vrai ou faux.
  const QuestionEpreuve.vraiFaux(String numero, String enonce,
      {required bool vrai, required double points, required String corrige, String? chapitre})
      : this._(
            genre: GenreQuestion.vraiFaux,
            numero: numero,
            enonce: enonce,
            options: const ['Vrai', 'Faux'],
            bonne: vrai ? 0 : 1,
            points: points,
            corrige: corrige,
            chapitre: chapitre);

  /// Une valeur numérique ; [tolerance] relative (1 % par défaut).
  const QuestionEpreuve.nombre(String numero, String enonce,
      {required double valeur,
      double tolerance = 0.01,
      String? unite,
      required double points,
      required String corrige,
      String? chapitre})
      : this._(
            genre: GenreQuestion.nombre,
            numero: numero,
            enonce: enonce,
            valeur: valeur,
            tolerance: tolerance,
            unite: unite,
            points: points,
            corrige: corrige,
            chapitre: chapitre);

  /// Une expression (dérivée, primitive, forme développée…), comparée en plusieurs points.
  const QuestionEpreuve.expression(String numero, String enonce,
      {required String attendue, String variable = 'x', required double points, required String corrige, String? chapitre})
      : this._(
            genre: GenreQuestion.expression,
            numero: numero,
            enonce: enonce,
            expression: attendue,
            variable: variable,
            points: points,
            corrige: corrige,
            chapitre: chapitre);

  /// Un mot ou une courte réponse ; plusieurs écritures acceptées.
  const QuestionEpreuve.courte(String numero, String enonce,
      {required List<String> acceptees, required double points, required String corrige, String? chapitre})
      : this._(
            genre: GenreQuestion.courte,
            numero: numero,
            enonce: enonce,
            acceptees: acceptees,
            points: points,
            corrige: corrige,
            chapitre: chapitre);

  /// Rédaction : corrigé détaillé et barème que l'élève coche.
  const QuestionEpreuve.redaction(String numero, String enonce,
      {required List<Critere> bareme, required String corrige, String? chapitre})
      : this._(
            genre: GenreQuestion.redaction,
            numero: numero,
            enonce: enonce,
            bareme: bareme,
            points: 0,
            corrige: corrige,
            chapitre: chapitre);

  final GenreQuestion genre;
  final String numero;
  final String enonce;
  final double points;
  final String corrige;
  final List<String> options;
  final int bonne;
  final double? valeur;
  final double tolerance;
  final String? unite;
  final String? expression;
  final String variable;
  final List<String> acceptees;
  final List<Critere> bareme;

  /// Le chapitre à revoir si la question est manquée (id du curriculum).
  final String? chapitre;

  double get bareMax => genre == GenreQuestion.redaction ? bareme.fold(0.0, (a, c) => a + c.points) : points;
  bool get auto => genre != GenreQuestion.redaction;

  /// La réponse attendue, lisible (pour la correction).
  String get reponseLisible => switch (genre) {
        GenreQuestion.qcm || GenreQuestion.vraiFaux => options[bonne],
        GenreQuestion.nombre => '${_fmt(valeur!)}${unite == null ? '' : ' $unite'}',
        GenreQuestion.expression => expression!,
        GenreQuestion.courte => acceptees.first,
        GenreQuestion.redaction => '',
      };

  static String _fmt(double v) {
    if (v == v.roundToDouble() && v.abs() < 1e9) return v.toInt().toString();
    var t = v.abs() >= 0.01 && v.abs() < 1e6 ? v.toStringAsPrecision(4) : v.toStringAsExponential(3);
    // 1,200 → 1,2 ; 3,790e-4 → 3,79e-4
    t = t.replaceAllMapped(RegExp(r'(\.\d*?)0+(?=$|e)'), (m) => m[1]!).replaceAll(RegExp(r'\.(?=$|e)'), '');
    return t.replaceAll('.', ',');
  }

  static String _simplifier(String s) {
    const accents = {'à': 'a', 'â': 'a', 'ä': 'a', 'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', 'î': 'i', 'ï': 'i', 'ô': 'o', 'ö': 'o', 'ù': 'u', 'û': 'u', 'ü': 'u', 'ç': 'c', 'œ': 'oe'};
    var t = s.toLowerCase().trim();
    accents.forEach((k, v) => t = t.replaceAll(k, v));
    return t.replaceAll(RegExp(r"[\s\-'’.]+"), ' ').trim();
  }

  /// Corrige automatiquement une réponse ; null pour une rédaction.
  bool? corriger(Object? reponse) {
    switch (genre) {
      case GenreQuestion.qcm:
      case GenreQuestion.vraiFaux:
        return reponse == bonne;
      case GenreQuestion.nombre:
        if (reponse is! String || reponse.trim().isEmpty) return false;
        final sans = unite == null ? reponse : reponse.replaceAll(unite!, '');
        final v = Expressions.nombre(sans);
        if (v == null) return false;
        final cible = valeur!;
        final ecart = (v - cible).abs();
        return cible == 0 ? ecart < 1e-9 + tolerance : ecart <= tolerance * cible.abs() + 1e-12;
      case GenreQuestion.expression:
        if (reponse is! String || reponse.trim().isEmpty) return false;
        var r = reponse.trim();
        // « f'(x) = … » : on garde la partie droite
        if (r.contains('=')) r = r.substring(r.lastIndexOf('=') + 1);
        return Expressions.equivalentes(r, expression!, variable: variable);
      case GenreQuestion.courte:
        if (reponse is! String || reponse.trim().isEmpty) return false;
        final r = _simplifier(reponse);
        return acceptees.any((a) => _simplifier(a) == r);
      case GenreQuestion.redaction:
        return null;
    }
  }
}

class ExerciceEpreuve {
  const ExerciceEpreuve({required this.titre, required this.enonce, required this.questions, this.sousTitre});
  final String titre;
  final String? sousTitre;
  final String enonce;
  final List<QuestionEpreuve> questions;

  double get bareMax => questions.fold(0.0, (a, q) => a + q.bareMax);
}

class Epreuve {
  const Epreuve({
    required this.id,
    required this.matiere,
    required this.serie,
    required this.titre,
    required this.dureeMinutes,
    required this.coefficient,
    required this.exercices,
    this.consignes = '',
    this.session = 'Sujet 1',
  });
  final String id;

  /// id de la matière du curriculum (maths, maths_c, physique_c…).
  final String matiere;
  final String serie;
  final String titre;
  final int dureeMinutes;
  final int coefficient;
  final String consignes;
  final String session;
  final List<ExerciceEpreuve> exercices;

  double get bareMax => exercices.fold(0.0, (a, e) => a + e.bareMax);
  int get nbQuestions => exercices.fold(0, (a, e) => a + e.questions.length);
}

/// La mention, comme au Bac.
String mention(double sur20) {
  if (sur20 >= 16) return 'Très bien';
  if (sur20 >= 14) return 'Bien';
  if (sur20 >= 12) return 'Assez bien';
  if (sur20 >= 10) return 'Passable';
  return 'Insuffisant';
}
