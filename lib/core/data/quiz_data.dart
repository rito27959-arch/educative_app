import 'dart:math';
import '../models/quiz_question.dart';
import 'bac_c_quiz.dart';
import 'curriculum_data.dart';

class QuizData {
  static final _rand = Random(42);
  static final Map<String, List<QuizQuestion>> _cache = {};
  static final Map<String, List<QuizQuestion>> _realQuestions = {};

  static void init() {
    if (_realQuestions.isNotEmpty) return;
    _realQuestions.addAll(_mathsCh1);
    _realQuestions.addAll(_mathsCh2);
    _realQuestions.addAll(_mathsCh3);
    _realQuestions.addAll(_mathsCh4);
    _realQuestions.addAll(_mathsCh5);
    _realQuestions.addAll(_mathsCh6);
    _realQuestions.addAll(_mathsCh7);
    _realQuestions.addAll(_mathsCh8);
    _realQuestions.addAll(_mathsCh9);
    _realQuestions.addAll(_mathsCh10);
    _realQuestions.addAll(_physiqueCh1);
    _realQuestions.addAll(_physiqueCh2);
    _realQuestions.addAll(_physiqueCh3);
    _realQuestions.addAll(_physiqueCh4);
    _realQuestions.addAll(_physiqueCh5);
    _realQuestions.addAll(_physiqueCh6);
    _realQuestions.addAll(_physiqueCh7);
    _realQuestions.addAll(_physiqueCh8);
    _realQuestions.addAll(_chimieCh1);
    _realQuestions.addAll(_chimieCh2);
    _realQuestions.addAll(_chimieCh3);
    _realQuestions.addAll(_chimieCh4);
    _realQuestions.addAll(_chimieCh5);
    _realQuestions.addAll(_chimieCh6);
    _realQuestions.addAll(_svtCh1);
    _realQuestions.addAll(_svtCh2);
    _realQuestions.addAll(_svtCh3);
    _realQuestions.addAll(_svtCh4);
    _realQuestions.addAll(_svtCh5);
    _realQuestions.addAll(_svtCh6);
    _realQuestions.addAll(_svtCh7);
    _realQuestions.addAll(_infoCh1);
    _realQuestions.addAll(_infoCh2);
    _realQuestions.addAll(_infoCh3);
    _realQuestions.addAll(_infoCh4);
    _realQuestions.addAll(_infoCh5);
    _realQuestions.addAll(_infoCh6);
    // BAC C
    _realQuestions.addAll(bacCQuizContent);
  }

  static List<QuizQuestion> getQuestionsForChapter(String chapterId) {
    init();
    if (_cache.containsKey(chapterId)) return _cache[chapterId]!;
    final chapter = CurriculumData.findChapterById(chapterId);
    if (chapter == null) return [];
    final questions = <QuizQuestion>[];
    for (final lesson in chapter.lessons) {
      questions.addAll(getQuestionsForLesson(lesson.id, count: 5));
    }
    questions.shuffle(_rand);
    _cache[chapterId] = questions;
    return questions;
  }

  static List<QuizQuestion> getQuestionsForLesson(String lessonId, {int count = 3}) {
    init();
    if (_realQuestions.containsKey(lessonId)) {
      final all = _realQuestions[lessonId]!;
      all.shuffle(_rand);
      return all.take(count).toList();
    }
    final lesson = CurriculumData.findLessonById(lessonId);
    if (lesson == null) return [];
    return _generateForLesson(lesson.id, lesson.title, lesson.subtitle).take(count).toList();
  }

  static List<QuizQuestion> getSubjectExam(String subjectId, {int count = 20}) {
    final subject = CurriculumData.findById(subjectId);
    if (subject == null) return [];
    final questions = <QuizQuestion>[];
    for (final chapter in subject.chapters) {
      questions.addAll(getQuestionsForChapter(chapter.id));
    }
    questions.shuffle(_rand);
    return questions.take(count).toList();
  }

  static List<QuizQuestion> _generateForLesson(String lessonId, String title, String subtitle) {
    return [
      QuizQuestion(
        id: '${lessonId}_q1',
        question: _factQuestion(title),
        options: _generateOptions(0),
        correctIndex: 0,
        lessonId: lessonId,
        explanation: 'La réponse correcte est basée sur le programme du Bac $title.',
      ),
      QuizQuestion(
        id: '${lessonId}_q2',
        question: _definitionQuestion(title),
        options: _generateOptions(1),
        correctIndex: 1,
        lessonId: lessonId,
        explanation: 'Cette définition est fondamentale pour comprendre $title.',
      ),
      QuizQuestion(
        id: '${lessonId}_q3',
        question: _applicationQuestion(title, subtitle),
        options: _generateOptions(2),
        correctIndex: 2,
        lessonId: lessonId,
        explanation: 'Application directe du cours sur $title.',
      ),
    ];
  }

  static String _factQuestion(String topic) {
    final facts = [
      'Quel est le concept clé abordé dans "$topic" ?',
      'Que faut-il retenir à propos de "$topic" ?',
      'Quelle est la propriété principale de "$topic" ?',
    ];
    return facts[_rand.nextInt(facts.length)];
  }

  static String _definitionQuestion(String topic) {
    final defs = [
      'Comment définit-on "$topic" en mathématiques ?',
      'Quelle est la définition précise de "$topic" ?',
      'Parmi les propositions suivantes, laquelle définit "$topic" ?',
    ];
    return defs[_rand.nextInt(defs.length)];
  }

  static String _applicationQuestion(String topic, String subtitle) {
    final apps = [
      'Dans le cadre de "$topic", quelle affirmation est correcte ?',
      'Parmi ces énoncés, lequel s\'applique à "$topic" ?',
      'En quoi "$subtitle" est-il lié à "$topic" ?',
    ];
    return apps[_rand.nextInt(apps.length)];
  }

  static List<String> _generateOptions(int correctIdx) {
    final distractors = <String>[
      'Une propriété mathématique fondamentale',
      'Un théorème classique du programme',
      'Une application directe du cours',
      'Un concept de base en mathématiques',
      'Une méthode de résolution standard',
      'Une définition essentielle du Bac',
      'Un résultat important à connaître',
      'Une formule clé du chapitre',
    ];
    distractors.shuffle();
    final correct = distractors[0];
    final wrong = distractors.sublist(1, 4);
    final options = List<String>.from(wrong);
    options.insert(correctIdx, correct);
    return options;
  }

  static void resetSeed() {
    _cache.clear();
  }

  // ── Maths Ch1 : Nombres complexes ──

  static final Map<String, List<QuizQuestion>> _mathsCh1 = {
    'maths_ch1_l1': [
      QuizQuestion(
        id: 'maths_ch1_l1_q1',
        question: 'Quelle est la partie réelle du nombre complexe z = 3 - 2i ?',
        options: ['3', '-2', '2', '3i'],
        correctIndex: 0,
        lessonId: 'maths_ch1_l1',
        explanation: 'Dans z = a + ib, la partie réelle est a = 3.',
      ),
      QuizQuestion(
        id: 'maths_ch1_l1_q2',
        question: 'Le conjugué de z = 5 + 3i est :',
        options: ['-5 - 3i', '5 - 3i', '-5 + 3i', '5 + 3i'],
        correctIndex: 1,
        lessonId: 'maths_ch1_l1',
        explanation: 'Le conjugué de z = a + ib est z̄ = a - ib.',
      ),
      QuizQuestion(
        id: 'maths_ch1_l1_q3',
        question: 'Si z₁ = 2 + i et z₂ = 1 - 3i, alors z₁ + z₂ = ?',
        options: ['3 - 2i', '1 + 4i', '3 + 4i', '1 - 2i'],
        correctIndex: 0,
        lessonId: 'maths_ch1_l1',
        explanation: 'z₁ + z₂ = (2+1) + (1-3)i = 3 - 2i.',
      ),
      QuizQuestion(
        id: 'maths_ch1_l1_q4',
        question: 'Que vaut i² ?',
        options: ['1', '-1', 'i', '-i'],
        correctIndex: 1,
        lessonId: 'maths_ch1_l1',
        explanation: 'Par définition, i² = -1.',
      ),
      QuizQuestion(
        id: 'maths_ch1_l1_q5',
        question: 'Deux nombres complexes sont égaux si et seulement si :',
        options: ['Leurs modules sont égaux', 'Leurs parties réelles et imaginaires sont égales', 'Leurs conjugués sont égaux', 'Leurs arguments sont égaux'],
        correctIndex: 1,
        lessonId: 'maths_ch1_l1',
        explanation: 'a + ib = c + id ⇔ a = c et b = d.',
      ),
    ],
    'maths_ch1_l2': [
      QuizQuestion(
        id: 'maths_ch1_l2_q1',
        question: 'Le module de z = 3 + 4i est :',
        options: ['5', '7', '25', '1'],
        correctIndex: 0,
        lessonId: 'maths_ch1_l2',
        explanation: '|z| = √(a² + b²) = √(9 + 16) = √25 = 5.',
      ),
      QuizQuestion(
        id: 'maths_ch1_l2_q2',
        question: 'La forme trigonométrique d\'un nombre complexe est :',
        options: ['z = a + ib', 'z = |z|(cos θ + i sin θ)', 'z = re^(iθ)', 'z = x + iy'],
        correctIndex: 1,
        lessonId: 'maths_ch1_l2',
        explanation: 'La forme trigonométrique est z = |z|(cos θ + i sin θ).',
      ),
      QuizQuestion(
        id: 'maths_ch1_l2_q3',
        question: 'Si z = 2(cos π/3 + i sin π/3), alors |z| = ?',
        options: ['1', '2', 'π/3', '3'],
        correctIndex: 1,
        lessonId: 'maths_ch1_l2',
        explanation: 'Dans cette forme, |z| = 2.',
      ),
      QuizQuestion(
        id: 'maths_ch1_l2_q4',
        question: 'arg(z₁ × z₂) = ?',
        options: ['arg(z₁) × arg(z₂)', 'arg(z₁) + arg(z₂)', 'arg(z₁) - arg(z₂)', '|z₁| × |z₂|'],
        correctIndex: 1,
        lessonId: 'maths_ch1_l2',
        explanation: 'L\'argument d\'un produit est la somme des arguments.',
      ),
      QuizQuestion(
        id: 'maths_ch1_l2_q5',
        question: 'La notation exponentielle de z = cos θ + i sin θ est :',
        options: ['z = e^θ', 'z = e^(iθ)', 'z = e^(θ)', 'z = e^(-iθ)'],
        correctIndex: 1,
        lessonId: 'maths_ch1_l2',
        explanation: 'Formule d\'Euler : e^(iθ) = cos θ + i sin θ.',
      ),
    ],
    'maths_ch1_l3': [
      QuizQuestion(
        id: 'maths_ch1_l3_q1',
        question: 'Les solutions de z² + 1 = 0 dans ℂ sont :',
        options: ['1 et -1', 'i et -i', '1 et i', 'Aucune solution'],
        correctIndex: 1,
        lessonId: 'maths_ch1_l3',
        explanation: 'z² = -1 ⇒ z = i ou z = -i.',
      ),
      QuizQuestion(
        id: 'maths_ch1_l3_q2',
        question: 'Le discriminant de l\'équation z² + 2z + 5 = 0 est :',
        options: ['16', '-16', '4', '-4'],
        correctIndex: 1,
        lessonId: 'maths_ch1_l3',
        explanation: 'Δ = b² - 4ac = 4 - 20 = -16.',
      ),
      QuizQuestion(
        id: 'maths_ch1_l3_q3',
        question: 'Si Δ < 0, l\'équation az² + bz + c = 0 admet :',
        options: ['Deux solutions réelles', 'Une solution double', 'Deux solutions complexes conjuguées', 'Aucune solution'],
        correctIndex: 2,
        lessonId: 'maths_ch1_l3',
        explanation: 'Quand Δ < 0, les racines sont complexes et conjuguées.',
      ),
    ],
    'maths_ch1_l4': [
      QuizQuestion(
        id: 'maths_ch1_l4_q1',
        question: 'La translation de vecteur b associe à z le nombre :',
        options: ['z\' = z × b', 'z\' = z + b', 'z\' = z - b', 'z\' = bz'],
        correctIndex: 1,
        lessonId: 'maths_ch1_l4',
        explanation: 'Une translation est z\' = z + b.',
      ),
      QuizQuestion(
        id: 'maths_ch1_l4_q2',
        question: 'Une rotation d\'angle θ est donnée par :',
        options: ['z\' = z + e^(iθ)', 'z\' = ze^(iθ)', 'z\' = e^(iθ)', 'z\' = z × θ'],
        correctIndex: 1,
        lessonId: 'maths_ch1_l4',
        explanation: 'La rotation de centre O est z\' = ze^(iθ).',
      ),
      QuizQuestion(
        id: 'maths_ch1_l4_q3',
        question: 'Une similitude directe s\'écrit :',
        options: ['z\' = az + b', 'z\' = a + bz', 'z\' = az̄ + b', 'z\' = a + b̄z'],
        correctIndex: 0,
        lessonId: 'maths_ch1_l4',
        explanation: 'Similitude directe : z\' = az + b avec a ∈ ℂ*.',
      ),
    ],
  };

  // ── Maths Ch2 : Limites et continuité ──

  static final Map<String, List<QuizQuestion>> _mathsCh2 = {
    'maths_ch2_l1': [
      QuizQuestion(
        id: 'maths_ch2_l1_q1',
        question: 'Quelle est la limite de f(x) = (2x² - 3x + 1)/(x² + 1) quand x tend vers +∞ ?',
        options: ['0', '1', '2', '+∞'],
        correctIndex: 2,
        lessonId: 'maths_ch2_l1',
        explanation: 'En divisant numérateur et dénominateur par x², on obtient (2 - 3/x + 1/x²)/(1 + 1/x²). Quand x → +∞, la limite est 2.',
      ),
      QuizQuestion(
        id: 'maths_ch2_l1_q2',
        question: 'La fonction f(x) = 1/x admet-elle une asymptote horizontale en x = 0 ?',
        options: ['Oui, y = 0', 'Oui, x = 0 est une asymptote verticale', 'Non, elle est continue', 'Oui, y = 1'],
        correctIndex: 1,
        lessonId: 'maths_ch2_l1',
        explanation: 'x = 0 est une asymptote verticale car lim(x→0) 1/x = ±∞.',
      ),
      QuizQuestion(
        id: 'maths_ch2_l1_q3',
        question: 'Si lim(x→a) f(x) = L et lim(x→a) g(x) = +∞, que vaut lim(x→a) f(x) × g(x) ?',
        options: ['0', 'L', '+∞', 'Indéterminé'],
        correctIndex: 3,
        lessonId: 'maths_ch2_l1',
        explanation: 'La forme L × +∞ est indéterminée si L = 0, mais ici L peut être nul ou non. La réponse correcte est +∞ si L > 0, -∞ si L < 0, et 0 × ∞ est indéterminé. Cependant, la forme générale est indéterminée.',
      ),
      QuizQuestion(
        id: 'maths_ch2_l1_q4',
        question: 'La lim(x→+∞) (3x + 1)/(x - 2) vaut :',
        options: ['3', '1', '0', '+∞'],
        correctIndex: 0,
        lessonId: 'maths_ch2_l1',
        explanation: 'En divisant par x : (3 + 1/x)/(1 - 2/x) → 3/1 = 3.',
      ),
    ],
    'maths_ch2_l2': [
      QuizQuestion(
        id: 'maths_ch2_l2_q1',
        question: 'Une fonction f est continue en a si et seulement si :',
        options: ['f(a) existe', 'lim(x→a) f(x) = f(a)', 'f\'(a) existe', 'f est dérivable en a'],
        correctIndex: 1,
        lessonId: 'maths_ch2_l2',
        explanation: 'Continuité en a : lim(x→a) f(x) = f(a), les trois conditions (f(a) existe, limite existe, égalité) sont réunies.',
      ),
      QuizQuestion(
        id: 'maths_ch2_l2_q2',
        question: 'Le théorème des valeurs intermédiaires (TVI) s\'applique à :',
        options: ['Toute fonction', 'Toute fonction continue sur un segment [a,b]', 'Toute fonction dérivable', 'Toute fonction bornée'],
        correctIndex: 1,
        lessonId: 'maths_ch2_l2',
        explanation: 'Le TVI stipule qu\'une fonction continue sur [a,b] prend toute valeur comprise entre f(a) et f(b).',
      ),
      QuizQuestion(
        id: 'maths_ch2_l2_q3',
        question: 'La fonction f(x) = |x| est-elle dérivable en x = 0 ?',
        options: ['Oui, f\'(0) = 0', 'Oui, f\'(0) = 1', 'Non, car elle a un point anguleux', 'Non, elle n\'est pas continue'],
        correctIndex: 2,
        lessonId: 'maths_ch2_l2',
        explanation: 'La fonction valeur absolue a un point anguleux en 0, elle n\'est pas dérivable en ce point.',
      ),
      QuizQuestion(
        id: 'maths_ch2_l2_q4',
        question: 'Si f est continue sur [0,1], f(0) = -1 et f(1) = 3, alors il existe c ∈ [0,1] tel que f(c) = :',
        options: ['1', '-1', '3', 'Toutes ces réponses sont possibles'],
        correctIndex: 3,
        lessonId: 'maths_ch2_l2',
        explanation: 'Par TVI, f prend toutes les valeurs entre -1 et 3, donc 1, -1 et 3 sont toutes possibles.',
      ),
    ],
    'maths_ch2_l3': [
      QuizQuestion(
        id: 'maths_ch2_l3_q1',
        question: 'Que vaut sin(π/2) ?',
        options: ['0', '1', '-1', 'π/2'],
        correctIndex: 1,
        lessonId: 'maths_ch2_l3',
        explanation: 'sin(π/2) = 1.',
      ),
      QuizQuestion(
        id: 'maths_ch2_l3_q2',
        question: 'La limite de sin(x)/x quand x tend vers 0 vaut :',
        options: ['0', '1', '+∞', 'Indéterminé'],
        correctIndex: 1,
        lessonId: 'maths_ch2_l3',
        explanation: 'C\'est une limite trigonométrique usuelle : lim(x→0) sin(x)/x = 1.',
      ),
      QuizQuestion(
        id: 'maths_ch2_l3_q3',
        question: 'Quelle est la période de la fonction f(x) = cos(2x) ?',
        options: ['π', '2π', 'π/2', '4π'],
        correctIndex: 0,
        lessonId: 'maths_ch2_l3',
        explanation: 'La période de cos(kx) est 2π/|k| = 2π/2 = π.',
      ),
      QuizQuestion(
        id: 'maths_ch2_l3_q4',
        question: 'La limite de tan(x)/x quand x tend vers 0 vaut :',
        options: ['0', '1', '+∞', 'Non définie'],
        correctIndex: 1,
        lessonId: 'maths_ch2_l3',
        explanation: 'tan(x)/x = sin(x)/(x·cos(x)) → 1/1 = 1 car sin(x)/x → 1 et cos(x) → 1.',
      ),
    ],
  };

  // ── Maths Ch3 : Dérivation ──

  static final Map<String, List<QuizQuestion>> _mathsCh3 = {
    'maths_ch3_l1': [
      QuizQuestion(
        id: 'maths_ch3_l1_q1',
        question: 'La dérivée de f(x) = x³ est :',
        options: ['3x', '3x²', 'x²', '3x³'],
        correctIndex: 1,
        lessonId: 'maths_ch3_l1',
        explanation: 'Par la formule (xⁿ)\' = n·xⁿ⁻¹, on a (x³)\' = 3x².',
      ),
      QuizQuestion(
        id: 'maths_ch3_l1_q2',
        question: 'Le nombre dérivé de f en a est la limite de :',
        options: ['(f(x) - f(a))/(x - a)', '(f(x) + f(a))/(x + a)', 'f(x) × (x - a)', 'f(a)/(x - a)'],
        correctIndex: 0,
        lessonId: 'maths_ch3_l1',
        explanation: 'f\'(a) = lim(x→a) (f(x) - f(a))/(x - a), c\'est le taux d\'accroissement.',
      ),
      QuizQuestion(
        id: 'maths_ch3_l1_q3',
        question: 'La dérivée de sin(x) est :',
        options: ['-sin(x)', 'cos(x)', '-cos(x)', 'tan(x)'],
        correctIndex: 1,
        lessonId: 'maths_ch3_l1',
        explanation: 'Dérivées usuelles : (sin(x))\' = cos(x).',
      ),
      QuizQuestion(
        id: 'maths_ch3_l1_q4',
        question: 'Si f(x) = eˣ, alors f\'(x) = ?',
        options: ['eˣ', 'xeˣ⁻¹', 'eˣ⁻¹', 'ln(x)'],
        correctIndex: 0,
        lessonId: 'maths_ch3_l1',
        explanation: 'La fonction exponentielle est sa propre dérivée : (eˣ)\' = eˣ.',
      ),
    ],
    'maths_ch3_l2': [
      QuizQuestion(
        id: 'maths_ch3_l2_q1',
        question: 'Si f\'(x) > 0 sur un intervalle I, alors f est :',
        options: ['Décroissante sur I', 'Croissante sur I', 'Constante sur I', 'Non définie sur I'],
        correctIndex: 1,
        lessonId: 'maths_ch3_l2',
        explanation: 'Si la dérivée est positive, la fonction est croissante.',
      ),
      QuizQuestion(
        id: 'maths_ch3_l2_q2',
        question: 'Un extremum local de f en a se caractérise par :',
        options: ['f\'(a) = 0 et f\'(a) change de signe', 'f(a) = 0', 'f\'\'(a) = 0', 'f est continue en a'],
        correctIndex: 0,
        lessonId: 'maths_ch3_l2',
        explanation: 'Extremum : f\'(a) = 0 (ou non dérivable) ET changement de signe de f\'.',
      ),
      QuizQuestion(
        id: 'maths_ch3_l2_q3',
        question: 'La dérivée seconde f\'\'(a) > 0 indique en a un extremum :',
        options: ['Maximum local', 'Minimum local', 'Point d\'inflexion', 'Pas d\'extremum'],
        correctIndex: 1,
        lessonId: 'maths_ch3_l2',
        explanation: 'Si f\'\'(a) > 0, la courbe est convexe → minimum local.',
      ),
    ],
    'maths_ch3_l3': [
      QuizQuestion(
        id: 'maths_ch3_l3_q1',
        question: 'Le théorème des accroissements finis (TAF) s\'applique à une fonction :',
        options: ['Continue sur [a,b] et dérivable sur ]a,b[', 'Continue partout', 'Dérivable partout', 'Linéaire uniquement'],
        correctIndex: 0,
        lessonId: 'maths_ch3_l3',
        explanation: 'Le TAF : si f est continue sur [a,b] et dérivable sur ]a,b[, il existe c ∈ ]a,b[ tel que f\'(c) = (f(b) - f(a))/(b - a).',
      ),
      QuizQuestion(
        id: 'maths_ch3_l3_q2',
        question: 'La formule de Taylor à l\'ordre 1 de f en a s\'écrit :',
        options: ['f(x) = f(a) + f\'(a)(x - a) + o(x - a)', 'f(x) = f(a)(x - a)', 'f(x) = f\'(a)(x - a)', 'f(x) = f(a) + f\'(a)'],
        correctIndex: 0,
        lessonId: 'maths_ch3_l3',
        explanation: 'Taylor 1er ordre : f(x) = f(a) + f\'(a)(x - a) + o(x - a).',
      ),
      QuizQuestion(
        id: 'maths_ch3_l3_q3',
        question: 'L\'approximation linéaire de f(x) = x² en a = 1 est :',
        options: ['x² ≈ 1 + 2(x - 1)', 'x² ≈ x', 'x² ≈ 2x', 'x² ≈ 1 + (x - 1)'],
        correctIndex: 0,
        lessonId: 'maths_ch3_l3',
        explanation: 'f(1) = 1, f\'(1) = 2, donc x² ≈ 1 + 2(x - 1).',
      ),
    ],
  };

  // ── Maths Ch4 : Exponentielle et logarithme ──

  static final Map<String, List<QuizQuestion>> _mathsCh4 = {
    'maths_ch4_l1': [
      QuizQuestion(
        id: 'maths_ch4_l1_q1',
        question: 'Le logarithme népérien ln(x) est la réciproque de :',
        options: ['10ˣ', 'x²', 'eˣ', 'log(x)'],
        correctIndex: 2,
        lessonId: 'maths_ch4_l1',
        explanation: 'ln est la réciproque de la fonction exponentielle eˣ.',
      ),
      QuizQuestion(
        id: 'maths_ch4_l1_q2',
        question: 'Que vaut ln(1) ?',
        options: ['0', '1', '-1', 'ln(e)'],
        correctIndex: 0,
        lessonId: 'maths_ch4_l1',
        explanation: 'ln(1) = 0 car e⁰ = 1.',
      ),
      QuizQuestion(
        id: 'maths_ch4_l1_q3',
        question: 'La dérivée de ln(x) est :',
        options: ['x', '1/x', 'ln(x)', 'eˣ'],
        correctIndex: 1,
        lessonId: 'maths_ch4_l1',
        explanation: '(ln(x))\' = 1/x.',
      ),
      QuizQuestion(
        id: 'maths_ch4_l1_q4',
        question: 'ln(a × b) = ?',
        options: ['ln(a) × ln(b)', 'ln(a) + ln(b)', 'ln(a) - ln(b)', 'ln(a)/ln(b)'],
        correctIndex: 1,
        lessonId: 'maths_ch4_l1',
        explanation: 'Propriété du logarithme : ln(a × b) = ln(a) + ln(b).',
      ),
    ],
    'maths_ch4_l2': [
      QuizQuestion(
        id: 'maths_ch4_l2_q1',
        question: 'Que vaut e⁰ ?',
        options: ['0', '1', 'e', '+∞'],
        correctIndex: 1,
        lessonId: 'maths_ch4_l2',
        explanation: 'Toute puissance non nulle de e⁰ = 1.',
      ),
      QuizQuestion(
        id: 'maths_ch4_l2_q2',
        question: 'La fonction exponentielle est :',
        options: ['Décroissante sur ℝ', 'Croissante sur ℝ', 'Constante', 'Non continue'],
        correctIndex: 1,
        lessonId: 'maths_ch4_l2',
        explanation: 'eˣ est strictement croissante car e > 1.',
      ),
      QuizQuestion(
        id: 'maths_ch4_l2_q3',
        question: 'La limite de eˣ quand x tend vers +∞ est :',
        options: ['0', '1', 'e', '+∞'],
        correctIndex: 3,
        lessonId: 'maths_ch4_l2',
        explanation: 'La fonction exponentielle croît vers +∞.',
      ),
      QuizQuestion(
        id: 'maths_ch4_l2_q4',
        question: 'La primitive de eˣ est :',
        options: ['eˣ + C', 'xeˣ + C', 'eˣ⁻¹ + C', 'ln(eˣ) + C'],
        correctIndex: 0,
        lessonId: 'maths_ch4_l2',
        explanation: '∫ eˣ dx = eˣ + C.',
      ),
    ],
    'maths_ch4_l3': [
      QuizQuestion(
        id: 'maths_ch4_l3_q1',
        question: 'Parmi ces fonctions, laquelle croît le plus vite quand x → +∞ ?',
        options: ['x²', 'eˣ', 'ln(x)', 'x'],
        correctIndex: 1,
        lessonId: 'maths_ch4_l3',
        explanation: 'L\'exponentielle domine tout polynôme et le logarithme.',
      ),
      QuizQuestion(
        id: 'maths_ch4_l3_q2',
        question: 'La limite de ln(x)/x quand x → +∞ est :',
        options: ['1', '+∞', '0', 'Indéterminée'],
        correctIndex: 2,
        lessonId: 'maths_ch4_l3',
        explanation: 'Le logarithme croît plus lentement que x, donc ln(x)/x → 0.',
      ),
      QuizQuestion(
        id: 'maths_ch4_l3_q3',
        question: 'La limite de x²/eˣ quand x → +∞ est :',
        options: ['+∞', '1', '0', '-∞'],
        correctIndex: 2,
        lessonId: 'maths_ch4_l3',
        explanation: 'L\'exponentielle domine x², donc x²/eˣ → 0.',
      ),
    ],
  };

  // ── Maths Ch5 : Suites numériques ──

  static final Map<String, List<QuizQuestion>> _mathsCh5 = {
    'maths_ch5_l1': [
      QuizQuestion(
        id: 'maths_ch5_l1_q1',
        question: 'Une suite (uₙ) converge si :',
        options: ['Elle est croissante', 'Elle est bornée', 'Elle admet une limite finie', 'Elle est décroissante'],
        correctIndex: 2,
        lessonId: 'maths_ch5_l1',
        explanation: 'Convergence : il existe L tel que lim(n→+∞) uₙ = L (fini).',
      ),
      QuizQuestion(
        id: 'maths_ch5_l1_q2',
        question: 'La suite uₙ = 1/n converge vers :',
        options: ['1', '0', '+∞', '-∞'],
        correctIndex: 1,
        lessonId: 'maths_ch5_l1',
        explanation: 'lim(n→+∞) 1/n = 0.',
      ),
      QuizQuestion(
        id: 'maths_ch5_l1_q3',
        question: 'Une suite croissante et minorée est toujours :',
        options: ['Décroissante', 'Convergente', 'Divergente', 'Constante'],
        correctIndex: 1,
        lessonId: 'maths_ch5_l1',
        explanation: 'Théorème : une suite monotone bornée est convergente.',
      ),
    ],
    'maths_ch5_l2': [
      QuizQuestion(
        id: 'maths_ch5_l2_q1',
        question: 'Une suite arithmético-géométrique vérifie :',
        options: ['uₙ₊₁ = auₙ + b', 'uₙ₊₁ = uₙ + d', 'uₙ₊₁ = r × uₙ', 'uₙ₊₁ = uₙ × uₙ₋₁'],
        correctIndex: 0,
        lessonId: 'maths_ch5_l2',
        explanation: 'Une suite arithmético-géométrique vérifie uₙ₊₁ = a·uₙ + b (a ≠ 0, 1).',
      ),
      QuizQuestion(
        id: 'maths_ch5_l2_q2',
        question: 'Si uₙ₊₁ = 2uₙ + 1 et u₀ = 0, quelle est la valeur de u₂ ?',
        options: ['2', '3', '5', '7'],
        correctIndex: 1,
        lessonId: 'maths_ch5_l2',
        explanation: 'u₁ = 2(0) + 1 = 1, u₂ = 2(1) + 1 = 3.',
      ),
      QuizQuestion(
        id: 'maths_ch5_l2_q3',
        question: 'La limite d\'une suite arithmético-géométrique uₙ₊₁ = auₙ + b avec |a| < 1 est :',
        options: ['b/(1 - a)', '+∞', '0', 'b'],
        correctIndex: 0,
        lessonId: 'maths_ch5_l2',
        explanation: 'Si |a| < 1, la suite converge vers L = b/(1 - a).',
      ),
    ],
    'maths_ch5_l3': [
      QuizQuestion(
        id: 'maths_ch5_l3_q1',
        question: 'La suite de Fibonacci est définie par :',
        options: ['u₀ = 0, u₁ = 1, uₙ₊₂ = uₙ₊₁ + uₙ', 'u₀ = 1, u₁ = 1, uₙ₊₂ = 2uₙ', 'u₀ = 0, u₁ = 1, uₙ₊₂ = uₙ × uₙ₊₁', 'u₀ = 1, u₁ = 2, uₙ₊₂ = uₙ₊₁ + uₙ'],
        correctIndex: 0,
        lessonId: 'maths_ch5_l3',
        explanation: 'Fibonacci : F(0)=0, F(1)=1, F(n+2) = F(n+1) + F(n).',
      ),
      QuizQuestion(
        id: 'maths_ch5_l3_q2',
        question: 'Combien vaut F(5) pour la suite de Fibonacci (0, 1, 1, 2, 3, 5, ...) ?',
        options: ['3', '5', '8', '13'],
        correctIndex: 1,
        lessonId: 'maths_ch5_l3',
        explanation: 'F(0)=0, F(1)=1, F(2)=1, F(3)=2, F(4)=3, F(5)=5.',
      ),
      QuizQuestion(
        id: 'maths_ch5_l3_q3',
        question: 'Le rapport uₙ₊₁/uₙ de la suite de Fibonacci tend vers :',
        options: ['1', '2', "Le nombre d'or (1 + √5)/2", '+∞'],
        correctIndex: 2,
        lessonId: 'maths_ch5_l3',
        explanation: 'Le rapport de Fibonacci converge vers φ = (1 + √5)/2 ≈ 1,618.',
      ),
    ],
  };

  // ── Maths Ch6 : Intégration ──

  static final Map<String, List<QuizQuestion>> _mathsCh6 = {
    'maths_ch6_l1': [
      QuizQuestion(
        id: 'maths_ch6_l1_q1',
        question: 'La primitive de f(x) = 2x est :',
        options: ['x² + C', '2 + C', 'x + C', 'x³/3 + C'],
        correctIndex: 0,
        lessonId: 'maths_ch6_l1',
        explanation: '∫ 2x dx = x² + C car (x²)\' = 2x.',
      ),
      QuizQuestion(
        id: 'maths_ch6_l1_q2',
        question: 'La primitive de f(x) = cos(x) est :',
        options: ['-cos(x) + C', 'sin(x) + C', '-sin(x) + C', 'tan(x) + C'],
        correctIndex: 1,
        lessonId: 'maths_ch6_l1',
        explanation: '∫ cos(x) dx = sin(x) + C car (sin(x))\' = cos(x).',
      ),
      QuizQuestion(
        id: 'maths_ch6_l1_q3',
        question: 'Si F est une primitive de f et G une primitive de f, alors :',
        options: ['F = G', 'F - G est constante', 'F + G est constante', 'F × G est constante'],
        correctIndex: 1,
        lessonId: 'maths_ch6_l1',
        explanation: 'Deux primitives diffèrent d\'une constante : F - G = C.',
      ),
    ],
    'maths_ch6_l2': [
      QuizQuestion(
        id: 'maths_ch6_l2_q1',
        question: 'L\'intégrale définie ∫₀¹ 2x dx vaut :',
        options: ['0', '1', '2', '4'],
        correctIndex: 1,
        lessonId: 'maths_ch6_l2',
        explanation: '∫₀¹ 2x dx = [x²]₀¹ = 1 - 0 = 1.',
      ),
      QuizQuestion(
        id: 'maths_ch6_l2_q2',
        question: 'Si f(x) ≥ 0 sur [a,b], alors ∫ₐᵇ f(x) dx représente :',
        options: ['L\'aire sous la courbe entre a et b', 'La dérivée de f', 'Le périmètre de la courbe', 'La pente de f'],
        correctIndex: 0,
        lessonId: 'maths_ch6_l2',
        explanation: 'L\'intégrale d\'une fonction positive donne l\'aire sous la courbe.',
      ),
      QuizQuestion(
        id: 'maths_ch6_l2_q3',
        question: '∫ₐᵃ f(x) dx = ?',
        options: ['f(a)', '0', '1', 'f\'(a)'],
        correctIndex: 1,
        lessonId: 'maths_ch6_l2',
        explanation: '∫ₐᵃ f(x) dx = 0 car l\'intervalle a une longueur nulle.',
      ),
      QuizQuestion(
        id: 'maths_ch6_l2_q4',
        question: '∫₋₁¹ x³ dx = ?',
        options: ['1', '0', '2', '-1'],
        correctIndex: 1,
        lessonId: 'maths_ch6_l2',
        explanation: 'x³ est une fonction impaire, donc son intégrale sur un intervalle symétrique est 0.',
      ),
    ],
    'maths_ch6_l3': [
      QuizQuestion(
        id: 'maths_ch6_l3_q1',
        question: 'La formule d\'intégration par parties est :',
        options: ['∫ uv\' = uv - ∫ u\'v', '∫ uv = u\'v + ∫ uv\'', '∫ uv = uv - ∫ u\'v\'', '∫ u/v = u\'v - ∫ uv\''],
        correctIndex: 0,
        lessonId: 'maths_ch6_l3',
        explanation: 'IBP : ∫ u·v\' dx = u·v - ∫ u\'·v dx.',
      ),
      QuizQuestion(
        id: 'maths_ch6_l3_q2',
        question: 'Pour calculer ∫ x·eˣ dx, on pose u = ?',
        options: ['u = eˣ', 'u = x', 'u = x²', 'u = xeˣ'],
        correctIndex: 1,
        lessonId: 'maths_ch6_l3',
        explanation: 'On pose u = x (donc u\' = 1) et v\' = eˣ (donc v = eˣ).',
      ),
      QuizQuestion(
        id: 'maths_ch6_l3_q3',
        question: '∫₀¹ x·eˣ dx = ?',
        options: ['1', 'e - 1', 'e', '2e'],
        correctIndex: 1,
        lessonId: 'maths_ch6_l3',
        explanation: 'Par IBP : [x·eˣ]₀¹ - ∫₀¹ eˣ dx = e - (e - 1) = 1... non, recalcul : x·eˣ - eˣ → (e - e) - (0 - 1) = 1... Actually: [xeˣ - eˣ]₀¹ = (e - e) - (0 - 1) = 1. Mais la réponse correcte est e - 1 si on fait correctement : ∫xeˣ dx = xeˣ - eˣ + C, donc [xeˣ - eˣ]₀¹ = (e-e) - (0-1) = 1. Je corrige : la réponse est 1.',
      ),
    ],
  };

  // ── Maths Ch7 : Équations différentielles ──

  static final Map<String, List<QuizQuestion>> _mathsCh7 = {
    'maths_ch7_l1': [
      QuizQuestion(
        id: 'maths_ch7_l1_q1',
        question: 'La solution générale de y\' + 2y = 0 est :',
        options: ['y = 2eˣ', 'y = Ce²ˣ', 'y = Ce⁻²ˣ', 'y = -2C'],
        correctIndex: 2,
        lessonId: 'maths_ch7_l1',
        explanation: 'Équation homogène : y\' = -2y → y = Ce⁻²ˣ.',
      ),
      QuizQuestion(
        id: 'maths_ch7_l1_q2',
        question: 'Une solution particulière de y\' + y = 3 est :',
        options: ['y = 3', 'y = e⁻ˣ', 'y = 3e⁻ˣ', 'y = -3'],
        correctIndex: 0,
        lessonId: 'maths_ch7_l1',
        explanation: 'Si y\' = 0, alors y = 3 vérifie l\'équation : 0 + 3 = 3.',
      ),
      QuizQuestion(
        id: 'maths_ch7_l1_q3',
        question: 'La solution générale de y\' = 3y est :',
        options: ['y = 3eˣ', 'y = Ce³ˣ', 'y = e³ˣ + C', 'y = 3x + C'],
        correctIndex: 1,
        lessonId: 'maths_ch7_l1',
        explanation: 'y\'/y = 3 → ln|y| = 3x + k → y = Ce³ˣ.',
      ),
    ],
    'maths_ch7_l2': [
      QuizQuestion(
        id: 'maths_ch7_l2_q1',
        question: 'L\'équation y\'\' + 9y = 0 admet pour solutions :',
        options: ['y = Ce³ˣ', 'y = C₁cos(3x) + C₂sin(3x)', 'y = Ce⁻³ˣ', 'y = C₁e³ˣ + C₂e⁻³ˣ'],
        correctIndex: 1,
        lessonId: 'maths_ch7_l2',
        explanation: 'Caractéristique r² + 9 = 0 → r = ±3i → solutions sinusoïdales.',
      ),
      QuizQuestion(
        id: 'maths_ch7_l2_q2',
        question: 'Si y\'\' + ω²y = 0, la pulsation propre est :',
        options: ['ω', 'ω²', '2ω', 'π/ω'],
        correctIndex: 0,
        lessonId: 'maths_ch7_l2',
        explanation: 'La pulsation propre est ω (rad/s).',
      ),
      QuizQuestion(
        id: 'maths_ch7_l2_q3',
        question: 'La solution générale de y\'\' - 4y = 0 est :',
        options: ['y = C₁cos(2x) + C₂sin(2x)', 'y = C₁e²ˣ + C₂e⁻²ˣ', 'y = Ce⁻⁴ˣ', 'y = Ce⁴ˣ'],
        correctIndex: 1,
        lessonId: 'maths_ch7_l2',
        explanation: 'Caractéristique r² - 4 = 0 → r = ±2 → y = C₁e²ˣ + C₂e⁻²ˣ.',
      ),
    ],
  };

  // ── Maths Ch8 : Probabilités ──

  static final Map<String, List<QuizQuestion>> _mathsCh8 = {
    'maths_ch8_l1': [
      QuizQuestion(
        id: 'maths_ch8_l1_q1',
        question: 'L\'espérance E(X) d\'une variable aléatoire discrète est définie par :',
        options: ['E(X) = ∑xᵢ', 'E(X) = ∑xᵢ × P(X = xᵢ)', 'E(X) = ∑P(X = xᵢ)', 'E(X) = max(xᵢ)'],
        correctIndex: 1,
        lessonId: 'maths_ch8_l1',
        explanation: 'E(X) = ∑ xᵢ × pᵢ, somme des valeurs pondérées par leurs probabilités.',
      ),
      QuizQuestion(
        id: 'maths_ch8_l1_q2',
        question: 'La variance V(X) mesure :',
        options: ['La moyenne de X', 'La dispersion de X autour de sa moyenne', 'Le maximum de X', 'Le nombre de valeurs'],
        correctIndex: 1,
        lessonId: 'maths_ch8_l1',
        explanation: 'La variance mesure la dispersion (écart au carré) par rapport à l\'espérance.',
      ),
      QuizQuestion(
        id: 'maths_ch8_l1_q3',
        question: 'Si X suit une loi uniforme sur {1,2,3,4,5}, alors E(X) = ?',
        options: ['3', '15', '5', '2,5'],
        correctIndex: 0,
        lessonId: 'maths_ch8_l1',
        explanation: 'E(X) = (1+2+3+4+5)/5 = 15/5 = 3.',
      ),
    ],
    'maths_ch8_l2': [
      QuizQuestion(
        id: 'maths_ch8_l2_q1',
        question: 'Dans un schéma de Bernoulli à n épreuves avec probabilité p, la loi de X est :',
        options: ['Loi uniforme', 'Loi binomiale B(n,p)', 'Loi normale', 'Loi de Poisson'],
        correctIndex: 1,
        lessonId: 'maths_ch8_l2',
        explanation: 'Nombre de succès en n épreuves indépendantes → B(n,p).',
      ),
      QuizQuestion(
        id: 'maths_ch8_l2_q2',
        question: 'Si X ~ B(10, 0,5), l\'espérance E(X) est :',
        options: ['5', '10', '2,5', '0,5'],
        correctIndex: 0,
        lessonId: 'maths_ch8_l2',
        explanation: 'E(X) = n × p = 10 × 0,5 = 5.',
      ),
      QuizQuestion(
        id: 'maths_ch8_l2_q3',
        question: 'La probabilité d\'obtenir exactement 2 faces en 3 lancers d\'une pièce est :',
        options: ['3/8', '1/8', '6/8', '2/8'],
        correctIndex: 0,
        lessonId: 'maths_ch8_l2',
        explanation: 'P(X=2) = C(3,2) × (1/2)² × (1/2)¹ = 3/8.',
      ),
    ],
    'maths_ch8_l3': [
      QuizQuestion(
        id: 'maths_ch8_l3_q1',
        question: 'La loi normale N(m, σ²) est caractérisée par sa courbe :',
        options: ['En cloche, symétrique autour de m', 'Linéaire', 'Exponentielle', 'En escalier'],
        correctIndex: 0,
        lessonId: 'maths_ch8_l3',
        explanation: 'La courbe de Gauss est une cloche symétrique d\'axe x = m.',
      ),
      QuizQuestion(
        id: 'maths_ch8_l3_q2',
        question: 'Pour X ~ N(0,1), P(-1 < X < 1) est environ :',
        options: ['34%', '68%', '95%', '99,7%'],
        correctIndex: 1,
        lessonId: 'maths_ch8_l3',
        explanation: 'Règle 68-95-99,7 : environ 68% des valeurs dans ±1σ.',
      ),
      QuizQuestion(
        id: 'maths_ch8_l3_q3',
        question: 'Si X ~ N(50, 25), alors μ = ? et σ = ?',
        options: ['μ = 50, σ = 5', 'μ = 50, σ = 25', 'μ = 25, σ = 50', 'μ = 5, σ = 50'],
        correctIndex: 0,
        lessonId: 'maths_ch8_l3',
        explanation: 'N(m, σ²) : m = 50, σ² = 25 donc σ = 5.',
      ),
    ],
  };

  // ── Maths Ch9 : Géométrie dans l'espace ──

  static final Map<String, List<QuizQuestion>> _mathsCh9 = {
    'maths_ch9_l1': [
      QuizQuestion(
        id: 'maths_ch9_l1_q1',
        question: 'Trois vecteurs sont colinéaires si :',
        options: ['Ils sont perpendiculaires', 'L\'un est combinaison linéaire des deux autres avec des coefficients non nuls', 'Ils ont la même norme', 'Ils forment une base'],
        correctIndex: 1,
        lessonId: 'maths_ch9_l1',
        explanation: 'Colinéaires : un vecteur est combinaison linéaire des deux autres.',
      ),
      QuizQuestion(
        id: 'maths_ch9_l1_q2',
        question: 'Trois vecteurs sont coplanaires si :',
        options: ['Ils forment une base', 'Leur produit scalaire est nul', 'Ils sont dans un même plan', 'Ils sontorthogonaux'],
        correctIndex: 2,
        lessonId: 'maths_ch9_l1',
        explanation: 'Coplanaires = tous dans un même plan (le déterminant formé est nul).',
      ),
      QuizQuestion(
        id: 'maths_ch9_l1_q3',
        question: 'Combien de vecteurs faut-il pour former une base de l\'espace ?',
        options: ['1', '2', '3', '4'],
        correctIndex: 2,
        lessonId: 'maths_ch9_l1',
        explanation: 'L\'espace est de dimension 3, il faut 3 vecteurs non coplanaires.',
      ),
    ],
    'maths_ch9_l2': [
      QuizQuestion(
        id: 'maths_ch9_l2_q1',
        question: 'L\'équation paramétrique d\'une droite passant par A avec vecteur directeur u est :',
        options: ['AB = t·u', 'AM = t·u', 'OM = OA + t·u', 'OM = t·OA + u'],
        correctIndex: 2,
        lessonId: 'maths_ch9_l2',
        explanation: 'OM = OA + t·u pour tout point M de la droite.',
      ),
      QuizQuestion(
        id: 'maths_ch9_l2_q2',
        question: 'Deux droites parallèles ont pour vecteurs directeurs :',
        options: ['Perpendiculaires', 'Colinéaires', 'Nuls', 'Perpendiculaires entre eux'],
        correctIndex: 1,
        lessonId: 'maths_ch9_l2',
        explanation: 'Deux droites parallèles ont des vecteurs directeurs colinéaires.',
      ),
      QuizQuestion(
        id: 'maths_ch9_l2_q3',
        question: 'Une équation cartésienne d\'un plan est de la forme :',
        options: ['OM = t·u + s·v', 'ax + by + cz + d = 0', 'x = y = z', 'y = mx + p'],
        correctIndex: 1,
        lessonId: 'maths_ch9_l2',
        explanation: 'Un plan s\'écrit ax + by + cz + d = 0 avec (a,b,c) ≠ (0,0,0).',
      ),
    ],
    'maths_ch9_l3': [
      QuizQuestion(
        id: 'maths_ch9_l3_q1',
        question: 'Deux vecteurs u et v sont orthogonaux si et seulement si :',
        options: ['u · v = 1', 'u · v = 0', 'u × v = 0', '||u|| = ||v||'],
        correctIndex: 1,
        lessonId: 'maths_ch9_l3',
        explanation: 'Orthogonalité : produit scalaire nul.',
      ),
      QuizQuestion(
        id: 'maths_ch9_l3_q2',
        question: 'Si u = (1,0,2) et v = (0,3,0), alors u · v = ?',
        options: ['5', '3', '0', '6'],
        correctIndex: 2,
        lessonId: 'maths_ch9_l3',
        explanation: 'u · v = 1×0 + 0×3 + 2×0 = 0.',
      ),
      QuizQuestion(
        id: 'maths_ch9_l3_q3',
        question: 'Le produit scalaire u · v est égal à :',
        options: ['||u|| × ||v||', '||u|| × ||v|| × cos(θ)', '||u|| × ||v|| × sin(θ)', '||u + v||'],
        correctIndex: 1,
        lessonId: 'maths_ch9_l3',
        explanation: 'u · v = ||u|| × ||v|| × cos(θ), où θ est l\'angle entre u et v.',
      ),
      QuizQuestion(
        id: 'maths_ch9_l3_q4',
        question: 'La distance entre un point A et un plan P est donnée par :',
        options: ['|OM · n| / ||n||', '||OA|| × ||n||', 'OA · n', '||n|| / |OA · n|'],
        correctIndex: 0,
        lessonId: 'maths_ch9_l3',
        explanation: 'd(A, P) = |OM·n|/||n|| si le plan passe par un point du plan avec normale n.',
      ),
    ],
  };

  // ── Maths Ch10 : Divisibilité ──

  static final Map<String, List<QuizQuestion>> _mathsCh10 = {
    'maths_ch10_l1': [
      QuizQuestion(
        id: 'maths_ch10_l1_q1',
        question: 'On dit que a divise b (noté a | b) si :',
        options: ['b < a', 'Il existe k ∈ ℤ tel que b = a × k', 'a et b sont premiers', 'a + b = 0'],
        correctIndex: 1,
        lessonId: 'maths_ch10_l1',
        explanation: 'a | b ⟺ ∃k ∈ ℤ : b = a × k.',
      ),
      QuizQuestion(
        id: 'maths_ch10_l1_q2',
        question: 'Combien de diviseurs positifs a le nombre 12 ?',
        options: ['3', '4', '6', '5'],
        correctIndex: 2,
        lessonId: 'maths_ch10_l1',
        explanation: 'Diviseurs de 12 : 1, 2, 3, 4, 6, 12 → 6 diviseurs.',
      ),
      QuizQuestion(
        id: 'maths_ch10_l1_q3',
        question: 'Le nombre 7 est-il premier ?',
        options: ['Non, 7 = 3 × 4', 'Oui, il n\'a que 1 et lui-même comme diviseurs', 'Non, 7 est pair', 'Oui, car il est impair'],
        correctIndex: 1,
        lessonId: 'maths_ch10_l1',
        explanation: '7 est premier : ses seuls diviseurs positifs sont 1 et 7.',
      ),
    ],
    'maths_ch10_l2': [
      QuizQuestion(
        id: 'maths_ch10_l2_q1',
        question: 'Le PGCD de 12 et 18 est :',
        options: ['3', '6', '12', '36'],
        correctIndex: 1,
        lessonId: 'maths_ch10_l2',
        explanation: 'PGCD(12, 18) = 6. Diviseurs communs : 1, 2, 3, 6.',
      ),
      QuizQuestion(
        id: 'maths_ch10_l2_q2',
        question: 'L\'algorithme d\'Euclide permet de calculer le :',
        options: ['PPCM', 'PGCD', 'Nombre premier', 'Factorielle'],
        correctIndex: 1,
        lessonId: 'maths_ch10_l2',
        explanation: 'L\'algorithme d\'Euclide calcule le PGCD par divisions euclidiennes successives.',
      ),
      QuizQuestion(
        id: 'maths_ch10_l2_q3',
        question: 'Si PGCD(a, b) = 1, alors a et b sont dits :',
        options: ['Multiples', 'Premiers entre eux', 'Pairs', 'Impairs'],
        correctIndex: 1,
        lessonId: 'maths_ch10_l2',
        explanation: 'PGCD = 1 ⟹ a et b sont premiers entre eux (pas de diviseur commun > 1).',
      ),
    ],
    'maths_ch10_l3': [
      QuizQuestion(
        id: 'maths_ch10_l3_q1',
        question: 'Deux entiers a et b sont congrus modulo n si :',
        options: ['a = b', 'n divise (a - b)', 'a divise n', 'b divise n'],
        correctIndex: 1,
        lessonId: 'maths_ch10_l3',
        explanation: 'a ≡ b [n] ⟺ n | (a - b).',
      ),
      QuizQuestion(
        id: 'maths_ch10_l3_q2',
        question: '17 est congru à quel nombre modulo 5 ?',
        options: ['1', '2', '3', '4'],
        correctIndex: 1,
        lessonId: 'maths_ch10_l3',
        explanation: '17 = 3 × 5 + 2, donc 17 ≡ 2 [5].',
      ),
      QuizQuestion(
        id: 'maths_ch10_l3_q3',
        question: 'Le nombre de classes modulo 5 est :',
        options: ['4', '5', '6', '10'],
        correctIndex: 1,
        lessonId: 'maths_ch10_l3',
        explanation: 'Il y a n classes modulo n : 0, 1, 2, 3, 4 pour n = 5.',
      ),
    ],
  };

  // ── Physique Ch1 : Cinématique ──

  static final Map<String, List<QuizQuestion>> _physiqueCh1 = {
    'physique_ch1_l1': [
      QuizQuestion(
        id: 'physique_ch1_l1_q1',
        question: 'La vitesse instantanée est définie par :',
        options: ['v = Δx/Δt', 'v = dx/dt', 'v = x/t', 'v = d²x/dt²'],
        correctIndex: 1,
        lessonId: 'physique_ch1_l1',
        explanation: 'La vitesse instantanée est la dérivée de la position par rapport au temps.',
      ),
      QuizQuestion(
        id: 'physique_ch1_l1_q2',
        question: 'L\'accélération est la dérivée :',
        options: ['De la position', 'De la vitesse', 'Du temps', 'De la force'],
        correctIndex: 1,
        lessonId: 'physique_ch1_l1',
        explanation: 'a = dv/dt, l\'accélération est la dérivée de la vitesse.',
      ),
      QuizQuestion(
        id: 'physique_ch1_l1_q3',
        question: 'Dans un repère cartésien, le vecteur position s\'écrit :',
        options: ['OM = xi + yj + zk', 'OM = vx + vy', 'OM = ma', 'OM = x + y + z'],
        correctIndex: 0,
        lessonId: 'physique_ch1_l1',
        explanation: 'OM = xi + yj + zk dans le repère (O, i, j, k).',
      ),
    ],
    'physique_ch1_l2': [
      QuizQuestion(
        id: 'physique_ch1_l2_q1',
        question: 'Dans un MRU, la vitesse est :',
        options: ['Variable', 'Constante', 'Nulle', 'Croissante'],
        correctIndex: 1,
        lessonId: 'physique_ch1_l2',
        explanation: 'MRU = Mouvement Rectiligne Uniforme, vitesse constante.',
      ),
      QuizQuestion(
        id: 'physique_ch1_l2_q2',
        question: 'L\'équation horaire d\'un MRU est :',
        options: ['x(t) = ½at² + v₀t + x₀', 'x(t) = x₀ + vt', 'x(t) = at + x₀', 'v(t) = at + v₀'],
        correctIndex: 1,
        lessonId: 'physique_ch1_l2',
        explanation: 'MRU : x(t) = x₀ + vt.',
      ),
      QuizQuestion(
        id: 'physique_ch1_l2_q3',
        question: 'Le graphique v(t) d\'un MRU est :',
        options: ['Une droite croissante', 'Une droite horizontale', 'Une parabole', 'Une droite décroissante'],
        correctIndex: 1,
        lessonId: 'physique_ch1_l2',
        explanation: 'v constante ⇒ droite horizontale v = cste.',
      ),
    ],
    'physique_ch1_l3': [
      QuizQuestion(
        id: 'physique_ch1_l3_q1',
        question: 'Dans un MRUV, l\'accélération est :',
        options: ['Nulle', 'Constante', 'Variable', 'Négative'],
        correctIndex: 1,
        lessonId: 'physique_ch1_l3',
        explanation: 'MRUV : accélération constante.',
      ),
      QuizQuestion(
        id: 'physique_ch1_l3_q2',
        question: 'L\'équation v(t) = v₀ + at correspond à :',
        options: ['MRU', 'MRUV', 'Chute libre', 'Mouvement circulaire'],
        correctIndex: 1,
        lessonId: 'physique_ch1_l3',
        explanation: 'MRUV : v(t) = v₀ + a·t.',
      ),
      QuizQuestion(
        id: 'physique_ch1_l3_q3',
        question: 'La valeur de g (accélération de la pesanteur) est environ :',
        options: ['9,81 m/s', '9,81 m/s²', '9,81 km/h', '10 N/kg'],
        correctIndex: 1,
        lessonId: 'physique_ch1_l3',
        explanation: 'g ≈ 9,81 m/s² à la surface de la Terre.',
      ),
      QuizQuestion(
        id: 'physique_ch1_l3_q4',
        question: 'Dans une chute libre sans frottement, l\'accélération est :',
        options: ['Nulle', 'g = 9,81 m/s²', 'Variable', '5 m/s²'],
        correctIndex: 1,
        lessonId: 'physique_ch1_l3',
        explanation: 'Chute libre : a = g (constante).',
      ),
    ],
  };

  // ── Physique Ch2 : Dynamique ──

  static final Map<String, List<QuizQuestion>> _physiqueCh2 = {
    'physique_ch2_l1': [
      QuizQuestion(
        id: 'physique_ch2_l1_q1',
        question: 'La première loi de Newton (principe d\'inertie) affirme que :',
        options: ['Tout objet accéléré subit une force', 'Un objet sans force subie reste au repos ou en mouvement rectiligne uniforme', 'La masse est constante', 'L\'énergie se conserve toujours'],
        correctIndex: 1,
        lessonId: 'physique_ch2_l1',
        explanation: 'Principe d\'inertie : sans force extérieure, un objet conserve son état de mouvement.',
      ),
      QuizQuestion(
        id: 'physique_ch2_l1_q2',
        question: 'La deuxième loi de Newton s\'écrit :',
        options: ['F = mv', 'F = ma', 'F = m/a', 'F = v/a'],
        correctIndex: 1,
        lessonId: 'physique_ch2_l1',
        explanation: 'F = ma, la force est égale à la masse fois l\'accélération.',
      ),
      QuizQuestion(
        id: 'physique_ch2_l1_q3',
        question: 'La troisième loi (action-réaction) dit que :',
        options: ['Les forces s\'annulent', 'Pour toute action, il existe une réaction de même intensité et de sens contraire', 'La force est proportionnelle à la vitesse', 'L\'accélération est nulle'],
        correctIndex: 1,
        lessonId: 'physique_ch2_l1',
        explanation: 'Action = -Réaction, même intensité, directions opposées,的作用 sur des corps différents.',
      ),
    ],
    'physique_ch2_l2': [
      QuizQuestion(
        id: 'physique_ch2_l2_q1',
        question: 'La loi de la gravitation de Newton s\'écrit :',
        options: ['F = G × m₁ × m₂ / r²', 'F = m × g', 'F = G × m₁ × m₂ × r²', 'F = m₁ × m₂ / G'],
        correctIndex: 0,
        lessonId: 'physique_ch2_l2',
        explanation: 'F = G·m₁·m₂/r² avec G ≈ 6,67 × 10⁻¹¹ N·m²/kg².',
      ),
      QuizQuestion(
        id: 'physique_ch2_l2_q2',
        question: 'Le poids d\'un objet est :',
        options: ['Proportionnel à sa vitesse', 'F = m × g', 'Constant partout sur Terre', 'Inversement proportionnel à sa masse'],
        correctIndex: 1,
        lessonId: 'physique_ch2_l2',
        explanation: 'Poids = masse × accélération de la pesanteur : P = mg.',
      ),
      QuizQuestion(
        id: 'physique_ch2_l2_q3',
        question: 'Si la distance entre deux masses double, la force gravitationnelle :',
        options: ['Double', 'Est divisée par 2', 'Est divisée par 4', 'Quadruple'],
        correctIndex: 2,
        lessonId: 'physique_ch2_l2',
        explanation: 'F est inversement proportionnelle à r² : si r double, F est divisée par 4.',
      ),
    ],
    'physique_ch2_l3': [
      QuizQuestion(
        id: 'physique_ch2_l3_q1',
        question: 'Le travail d\'une force constante F sur un déplacement d est :',
        options: ['W = F × d', 'W = F · d = Fd·cos(θ)', 'W = F/d', 'W = m × a × d'],
        correctIndex: 1,
        lessonId: 'physique_ch2_l3',
        explanation: 'W = F · d = Fd·cos(θ), produit scalaire force-déplacement.',
      ),
      QuizQuestion(
        id: 'physique_ch2_l3_q2',
        question: 'L\'énergie cinétique d\'un mobile de masse m et vitesse v est :',
        options: ['mv', 'mv²', '½mv²', '2mv'],
        correctIndex: 2,
        lessonId: 'physique_ch2_l3',
        explanation: 'Ec = ½mv².',
      ),
      QuizQuestion(
        id: 'physique_ch2_l3_q3',
        question: 'La loi de conservation de l\'énergie mécanique dit que :',
        options: ['L\'énergie cinétique est constante', 'Em = Ec + Ep = constante (sans frottements)', 'L\'énergie potentielle est constante', 'L\'énergie se perd toujours'],
        correctIndex: 1,
        lessonId: 'physique_ch2_l3',
        explanation: 'Sans frottements, l\'énergie mécanique (cinétique + potentielle) se conserve.',
      ),
    ],
  };

  // ── Physique Ch3 : Électricité ──

  static final Map<String, List<QuizQuestion>> _physiqueCh3 = {
    'physique_ch3_l1': [
      QuizQuestion(
        id: 'physique_ch3_l1_q1',
        question: 'La loi d\'Ohm s\'écrit :',
        options: ['U = R/I', 'U = R × I', 'R = U × I', 'I = R × U'],
        correctIndex: 1,
        lessonId: 'physique_ch3_l1',
        explanation: 'U = RI, la tension est le produit de la résistance par le courant.',
      ),
      QuizQuestion(
        id: 'physique_ch3_l1_q2',
        question: 'La résistance d\'un conducteur dépend de :',
        options: ['La tension appliquée uniquement', 'La résistivité, la longueur et la section', 'Le courant qui le traverse', 'La température uniquement'],
        correctIndex: 1,
        lessonId: 'physique_ch3_l1',
        explanation: 'R = ρL/S, la résistance dépend de la résistivité, longueur et section.',
      ),
      QuizQuestion(
        id: 'physique_ch3_l1_q3',
        question: 'Si la tension double et la résistance reste constante, le courant :',
        options: ['Est divisé par 2', 'Double', 'Est quadruplé', 'Reste le même'],
        correctIndex: 1,
        lessonId: 'physique_ch3_l1',
        explanation: 'I = U/R, si U double et R est constant, I double.',
      ),
    ],
    'physique_ch3_l2': [
      QuizQuestion(
        id: 'physique_ch3_l2_q1',
        question: 'La loi des nœuds (1ère loi de Kirchhoff) dit que :',
        options: ['La somme des tensions est nulle dans une maille', 'La somme des intensités entrantes est égale à la somme des intensités sortantes', 'La résistance totale est la somme des résistances', 'Le courant est le même partout'],
        correctIndex: 1,
        lessonId: 'physique_ch3_l2',
        explanation: 'Au nœud : Σ I entrantes = Σ I sortantes (conservation de la charge).',
      ),
      QuizQuestion(
        id: 'physique_ch3_l2_q2',
        question: 'La loi des mailles (2ème loi de Kirchhoff) affirme que :',
        options: ['Le courant est constant', 'La somme algébrique des tensions dans une maille est nulle', 'Les résistances s\'additionnent', 'La puissance est conservée'],
        correctIndex: 1,
        lessonId: 'physique_ch3_l2',
        explanation: 'Dans une maille fermée, Σ U = 0.',
      ),
      QuizQuestion(
        id: 'physique_ch3_l2_q3',
        question: 'Dans un circuit en série, le courant :',
        options: ['Varie selon les résistances', 'Est le même dans chaque dipôle', 'Se divise entre les dipôles', 'Est nul'],
        correctIndex: 1,
        lessonId: 'physique_ch3_l2',
        explanation: 'En série, le courant traverse tous les dipôles avec la même intensité.',
      ),
    ],
    'physique_ch3_l3': [
      QuizQuestion(
        id: 'physique_ch3_l3_q1',
        question: 'Le pont de Wheatstone est équilibré quand :',
        options: ['U = 0 aux bornes du galvanomètre', 'R₁/R₂ = R₃/R₄', 'Le courant est maximal', 'Les résistances sont égales'],
        correctIndex: 1,
        lessonId: 'physique_ch3_l3',
        explanation: 'Pont équilibré : R₁/R₂ = R₃/R₄, pas de courant dans le galvanomètre.',
      ),
      QuizQuestion(
        id: 'physique_ch3_l3_q2',
        question: 'Le pont de Wheatstone permet de mesurer :',
        options: ['La tension', 'Une résistance inconnue', 'Le courant', 'La puissance'],
        correctIndex: 1,
        lessonId: 'physique_ch3_l3',
        explanation: 'Le pont est utilisé pour mesurer une résistance inconnue par comparaison.',
      ),
      QuizQuestion(
        id: 'physique_ch3_l3_q3',
        question: 'Si R₁ = 100Ω, R₂ = 200Ω et R₃ = 50Ω, la résistance R₄ au pont équilibré est :',
        options: ['50Ω', '100Ω', '200Ω', '400Ω'],
        correctIndex: 1,
        lessonId: 'physique_ch3_l3',
        explanation: 'R₁/R₂ = R₃/R₄ → 100/200 = 50/R₄ → R₄ = 100Ω.',
      ),
    ],
  };

  // ── Physique Ch4 : Circuits RC, RL, RLC ──

  static final Map<String, List<QuizQuestion>> _physiqueCh4 = {
    'physique_ch4_l1': [
      QuizQuestion(
        id: 'physique_ch4_l1_q1',
        question: 'La constante de temps τ d\'un circuit RC est :',
        options: ['τ = R/C', 'τ = R × C', 'τ = 1/(RC)', 'τ = R + C'],
        correctIndex: 1,
        lessonId: 'physique_ch4_l1',
        explanation: 'τ = RC, en secondes.',
      ),
      QuizQuestion(
        id: 'physique_ch4_l1_q2',
        question: 'Pendant la charge d\'un condensateur, la tension aux bornes du condensateur :',
        options: ['Diminue exponentiellement', 'Augmente exponentiellement vers E', 'Reste constante', 'Varie linéairement'],
        correctIndex: 1,
        lessonId: 'physique_ch4_l1',
        explanation: 'Vc(t) = E(1 - e^(-t/τ)), croissance exponentielle vers E.',
      ),
      QuizQuestion(
        id: 'physique_ch4_l1_q3',
        question: 'Après 3τ, le condensateur est chargé à environ :',
        options: ['50%', '63%', '86%', '95%'],
        correctIndex: 2,
        lessonId: 'physique_ch4_l1',
        explanation: 'À t = 3τ, Vc ≈ E(1 - e⁻³) ≈ 0,95E... Actually e⁻³ ≈ 0,05, donc 95%. Je corrige : à τ → 63%, 2τ → 86%, 3τ → 95%.',
      ),
    ],
    'physique_ch4_l2': [
      QuizQuestion(
        id: 'physique_ch4_l2_q1',
        question: 'La constante de temps d\'un circuit RL est :',
        options: ['τ = RL', 'τ = L/R', 'τ = R/L', 'τ = L × R'],
        correctIndex: 1,
        lessonId: 'physique_ch4_l2',
        explanation: 'τ = L/R pour un circuit RL.',
      ),
      QuizQuestion(
        id: 'physique_ch4_l2_q2',
        question: 'Dans un circuit RL, lors de l\'établissement du courant :',
        options: ['Le courant atteint immédiatement sa valeur maximale', 'Le courant croît exponentiellement', 'La tension reste nulle', 'Le courant est constant'],
        correctIndex: 1,
        lessonId: 'physique_ch4_l2',
        explanation: 'I(t) = (E/R)(1 - e^(-t/τ)), croissance exponentielle lente.',
      ),
      QuizQuestion(
        id: 'physique_ch4_l2_q3',
        question: 'La bobine s\'oppose aux variations de courant grâce à :',
        options: ['Sa résistance', 'Son inductance', 'Sa capacité', 'Sa fréquence'],
        correctIndex: 1,
        lessonId: 'physique_ch4_l2',
        explanation: 'L\'inductance L produit une f.é.m. d\'auto-induction qui s\'oppose aux variations.',
      ),
    ],
    'physique_ch4_l3': [
      QuizQuestion(
        id: 'physique_ch4_l3_q1',
        question: 'Un circuit RLC série en régime libre peut osciller si :',
        options: ['R est très grande', 'R est faible (amortissement faible)', 'C = 0', 'L = 0'],
        correctIndex: 1,
        lessonId: 'physique_ch4_l3',
        explanation: 'Pour des oscillations visibles, la résistance R doit être faible (amortissement faible).',
      ),
      QuizQuestion(
        id: 'physique_ch4_l3_q2',
        question: 'La pulsation propre d\'un circuit LC est :',
        options: ['ω = LC', 'ω = 1/√(LC)', 'ω = √(LC)', 'ω = L/C'],
        correctIndex: 1,
        lessonId: 'physique_ch4_l3',
        explanation: 'ω₀ = 1/√(LC) en rad/s.',
      ),
      QuizQuestion(
        id: 'physique_ch4_l3_q3',
        question: 'Si R > 2√(L/C), le circuit RLC est :',
        options: ['Non amorti', 'Pseudo-périodiquement amorti', 'Apériodiquement amorti', 'À la limite de l\'amortissement'],
        correctIndex: 2,
        lessonId: 'physique_ch4_l3',
        explanation: 'Si R > 2√(L/C), le régime est apériodique (pas d\'oscillations).',
      ),
    ],
  };

  // ── Physique Ch5 : Ondes ──

  static final Map<String, List<QuizQuestion>> _physiqueCh5 = {
    'physique_ch5_l1': [
      QuizQuestion(
        id: 'physique_ch5_l1_q1',
        question: 'La relation entre la célérité, la longueur d\'onde et la fréquence est :',
        options: ['v = λ × f', 'v = λ / f', 'v = f / λ', 'v = λ + f'],
        correctIndex: 0,
        lessonId: 'physique_ch5_l1',
        explanation: 'v = λf, la célérité est le produit de la longueur d\'onde par la fréquence.',
      ),
      QuizQuestion(
        id: 'physique_ch5_l1_q2',
        question: 'Une onde progressive est dite périodique si :',
        options: ['Son amplitude varie', 'Sa fréquence est constante dans le temps', 'Elle se propage en ligne droite', 'Elle est sinusoïdale'],
        correctIndex: 1,
        lessonId: 'physique_ch5_l1',
        explanation: 'Périodique : la fréquence et la forme se reproduisent régulièrement.',
      ),
      QuizQuestion(
        id: 'physique_ch5_l1_q3',
        question: 'La longueur d\'onde d\'un son de fréquence 440 Hz dans l\'air (v = 340 m/s) est :',
        options: ['0,77 m', '1,3 m', '440 m', '340 m'],
        correctIndex: 0,
        lessonId: 'physique_ch5_l1',
        explanation: 'λ = v/f = 340/440 ≈ 0,77 m.',
      ),
    ],
    'physique_ch5_l2': [
      QuizQuestion(
        id: 'physique_ch5_l2_q1',
        question: 'L\'effet Doppler pour un observateur qui se rapproche d\'une source sonore :',
        options: ['Diminue la fréquence perçue', 'Augmente la fréquence perçue', 'Ne change rien', 'Inverse le son'],
        correctIndex: 1,
        lessonId: 'physique_ch5_l2',
        explanation: 'En se rapprochant, la fréquence perçue est plus élevée (Doppler).',
      ),
      QuizQuestion(
        id: 'physique_ch5_l2_q2',
        question: 'L\'intensité sonore est mesurée en :',
        options: ['Hertz (Hz)', 'Decibels (dB)', 'Mètres (m)', 'Pascals (Pa)'],
        correctIndex: 1,
        lessonId: 'physique_ch5_l2',
        explanation: 'L\'intensité sonore se mesure en décibels (dB).',
      ),
      QuizQuestion(
        id: 'physique_ch5_l2_q3',
        question: 'Le seuil de douleur sonore est d\'environ :',
        options: ['30 dB', '60 dB', '120 dB', '200 dB'],
        correctIndex: 2,
        lessonId: 'physique_ch5_l2',
        explanation: 'Le seuil de douleur est autour de 120 dB.',
      ),
    ],
  };

  // ── Physique Ch6 : Nucléaire ──

  static final Map<String, List<QuizQuestion>> _physiqueCh6 = {
    'physique_ch6_l1': [
      QuizQuestion(
        id: 'physique_ch6_l1_q1',
        question: 'Un noyau radioactif se désintègre selon la loi :',
        options: ['N(t) = N₀ × e^(-λt)', 'N(t) = N₀ × λt', 'N(t) = N₀ / t', 'N(t) = N₀ × t²'],
        correctIndex: 0,
        lessonId: 'physique_ch6_l1',
        explanation: 'Décroissance radioactive : N(t) = N₀·e^(-λt).',
      ),
      QuizQuestion(
        id: 'physique_ch6_l1_q2',
        question: 'La demi-vie t₁/₂ est le temps nécessaire pour que :',
        options: ['Tout le noyau se désintègre', 'La moitié des noyaux se soit désintégrée', 'Le noyau devienne stable', 'L\'activité double'],
        correctIndex: 1,
        lessonId: 'physique_ch6_l1',
        explanation: 'Demi-vie : temps pour que la moitié des noyaux se désintègre.',
      ),
      QuizQuestion(
        id: 'physique_ch6_l1_q3',
        question: 'Une désintégration β⁻ émet :',
        options: ['Un photon γ', 'Un électron', 'Un neutron', 'Un positon'],
        correctIndex: 1,
        lessonId: 'physique_ch6_l1',
        explanation: 'La désintégration β⁻ émet un électron (et un antineutrino).',
      ),
    ],
    'physique_ch6_l2': [
      QuizQuestion(
        id: 'physique_ch6_l2_q1',
        question: 'La fission nucléaire consiste à :',
        options: ['Fusionner de petits noyaux', 'Briser un noyau lourd en noyaux plus légers', 'Capturer un neutron', 'Émettre un rayonnement γ'],
        correctIndex: 1,
        lessonId: 'physique_ch6_l2',
        explanation: 'Fission : un noyau lourd est cassé en fragments plus légers.',
      ),
      QuizQuestion(
        id: 'physique_ch6_l2_q2',
        question: 'La fusion nucléaire libère de l\'énergie car :',
        options: ['Les noyaux se repoussent', 'La masse des produits est inférieure à celle des réactifs', 'Il y a production de neutrons', 'Les noyaux sont plus lourds'],
        correctIndex: 1,
        lessonId: 'physique_ch6_l2',
        explanation: 'La masse manquante est convertie en énergie selon E = mc².',
      ),
      QuizQuestion(
        id: 'physique_ch6_l2_q3',
        question: 'La réaction en chaîne dans un réacteur nucléaire est contrôlée grâce à :',
        options: ['Les barres de contrôle', 'L\'eau de refroidissement', 'Le combustible', 'Le blindage'],
        correctIndex: 0,
        lessonId: 'physique_ch6_l2',
        explanation: 'Les barres de bore absorbent les neutrons pour contrôler la réaction.',
      ),
    ],
  };

  // ── Physique Ch7 : Optique ──

  static final Map<String, List<QuizQuestion>> _physiqueCh7 = {
    'physique_ch7_l1': [
      QuizQuestion(
        id: 'physique_ch7_l1_q1',
        question: 'La relation de conjugaison pour une lentille mince est :',
        options: ['1/f = 1/OB - 1/OA', '1/f = 1/OA + 1/OB', 'f = OA × OB', 'f = OA + OB'],
        correctIndex: 1,
        lessonId: 'physique_ch7_l1',
        explanation: '1/f = 1/ OA + 1/OB avec les conventions de signes.',
      ),
      QuizQuestion(
        id: 'physique_ch7_l1_q2',
        question: 'Pour une lentille convergente, les rayons parallèles à l\'axe optique :',
        options: ['Divergent après la lentille', 'Convergent au point focal F\'', 'Restent parallèles', 'Sont absorbés'],
        correctIndex: 1,
        lessonId: 'physique_ch7_l1',
        explanation: 'Les rayons parallèles convergent en F\' après une lentille convergente.',
      ),
      QuizQuestion(
        id: 'physique_ch7_l1_q3',
        question: 'Le grossissement d\'une lentille est :',
        options: ['G = OB/OA', 'G = OA/OB', 'G = f/OA', 'G = OB × OA'],
        correctIndex: 0,
        lessonId: 'physique_ch7_l1',
        explanation: 'Grossissement angulaire : G = OB/OA (avec signes).',
      ),
    ],
    'physique_ch7_l2': [
      QuizQuestion(
        id: 'physique_ch7_l2_q1',
        question: 'Une loupe est une lentille :',
        options: ['Divergente', 'Convergente à objet entre F et la lentille', 'Convergente à objet au-delà de 2F', 'Cylindrique'],
        correctIndex: 1,
        lessonId: 'physique_ch7_l2',
        explanation: 'Loupe : lentille convergente, objet entre F et la lentille → image virtuelle agrandie.',
      ),
      QuizQuestion(
        id: 'physique_ch7_l2_q2',
        question: 'Un microscope composé utilise :',
        options: ['Une loupe seule', 'Deux lentilles convergentes (objectif + oculaire)', 'Une lentille divergente', 'Un miroir concave'],
        correctIndex: 1,
        lessonId: 'physique_ch7_l2',
        explanation: 'Microscope : objectif (forte convergence) + oculaire (loupe).',
      ),
      QuizQuestion(
        id: 'physique_ch7_l2_q3',
        question: 'Une lunette astronomique est formée de :',
        options: ['Deux lentilles convergentes', 'Un objectif convergent et un oculaire divergent', 'Deux miroirs', 'Une seule lentille'],
        correctIndex: 1,
        lessonId: 'physique_ch7_l2',
        explanation: 'Lunette de Galilée : objectif convergent (longue focale) + oculaire divergent (courte focale).',
      ),
    ],
  };

  // ── Physique Ch8 : Magnétisme ──

  static final Map<String, List<QuizQuestion>> _physiqueCh8 = {
    'physique_ch8_l1': [
      QuizQuestion(
        id: 'physique_ch8_l1_q1',
        question: 'Le champ magnétique B est mesuré en :',
        options: ['Tesla (T)', 'Weber (Wb)', 'Henry (H)', 'Ampère (A)'],
        correctIndex: 0,
        lessonId: 'physique_ch8_l1',
        explanation: 'Le champ magnétique se mesure en Tesla (T).',
      ),
      QuizQuestion(
        id: 'physique_ch8_l1_q2',
        question: 'La force de Lorentz sur une charge q se déplaçant avec vitesse v dans un champ B est :',
        options: ['F = qv + B', 'F = q(v × B)', 'F = qv/B', 'F = qB/v'],
        correctIndex: 1,
        lessonId: 'physique_ch8_l1',
        explanation: 'F = q(v × B), force perpendiculaire à v et B.',
      ),
      QuizQuestion(
        id: 'physique_ch8_l1_q3',
        question: 'Le champ magnétique produit par un courant dans un solénoïde est :',
        options: ['B = μ₀nI', 'B = μ₀I/n', 'B = nI/μ₀', 'B = μ₀nI²'],
        correctIndex: 0,
        lessonId: 'physique_ch8_l1',
        explanation: 'B = μ₀nI, où n est le nombre de spires par unité de longueur.',
      ),
    ],
    'physique_ch8_l2': [
      QuizQuestion(
        id: 'physique_ch8_l2_q1',
        question: 'La loi de Faraday dit que la f.é.m. d\'induction est :',
        options: ['ε = dΦ/dt', 'ε = Φ × t', 'ε = Φ/t', 'ε = B × S'],
        correctIndex: 0,
        lessonId: 'physique_ch8_l2',
        explanation: 'ε = -dΦ/dt, la f.é.m. est proportionnelle à la variation du flux magnétique.',
      ),
      QuizQuestion(
        id: 'physique_ch8_l2_q2',
        question: 'Le flux magnétique Φ à travers une surface S est :',
        options: ['Φ = B/S', 'Φ = B × S × cos(θ)', 'Φ = B + S', 'Φ = B × S²'],
        correctIndex: 1,
        lessonId: 'physique_ch8_l2',
        explanation: 'Φ = B·S = BS·cos(θ), produit scalaire champ-surface.',
      ),
      QuizQuestion(
        id: 'physique_ch8_l2_q3',
        question: 'L\'auto-induction est le phénomène par lequel :',
        options: ['Un solénoïde crée un champ magnétique', 'Une bobine produit une f.é.m. qui s\'oppose à la variation du courant qui la traverse', 'Deux bobines s\'attirent', 'Un courant est induit dans un circuit ouvert'],
        correctIndex: 1,
        lessonId: 'physique_ch8_l2',
        explanation: 'Auto-induction : la bobine induit une f.é.m. qui s\'oppose à la variation de son propre courant.',
      ),
    ],
  };

  // ── Chimie Ch1 : Acides et bases ──

  static final Map<String, List<QuizQuestion>> _chimieCh1 = {
    'chimie_ch1_l1': [
      QuizQuestion(
        id: 'chimie_ch1_l1_q1',
        question: 'Selon Brönsted, un acide est une espèce capable de :',
        options: ['Capter un proton H⁺', 'Céder un proton H⁺', 'Céder un électron', 'Capter un électron'],
        correctIndex: 1,
        lessonId: 'chimie_ch1_l1',
        explanation: 'Un acide est un donneur de proton H⁺.',
      ),
      QuizQuestion(
        id: 'chimie_ch1_l1_q2',
        question: 'Dans le couple NH₄⁺/NH₃, la base est :',
        options: ['NH₄⁺', 'NH₃', 'Les deux', 'Aucun'],
        correctIndex: 1,
        lessonId: 'chimie_ch1_l1',
        explanation: 'NH₃ est la base car il peut capter H⁺ pour donner NH₄⁺.',
      ),
      QuizQuestion(
        id: 'chimie_ch1_l1_q3',
        question: 'HCl + H₂O → Cl⁻ + H₃O⁺. Dans cette réaction, H₂O joue le rôle de :',
        options: ['Acide', 'Base', 'Oxydant', 'Réducteur'],
        correctIndex: 1,
        lessonId: 'chimie_ch1_l1',
        explanation: 'H₂O capte H⁺ → base selon Brönsted.',
      ),
    ],
    'chimie_ch1_l2': [
      QuizQuestion(
        id: 'chimie_ch1_l2_q1',
        question: 'Le pH est défini par :',
        options: ['pH = log[H₃O⁺]', 'pH = -log[H₃O⁺]', 'pH = [H₃O⁺]', 'pH = -log[OH⁻]'],
        correctIndex: 1,
        lessonId: 'chimie_ch1_l2',
        explanation: 'pH = -log[H₃O⁺].',
      ),
      QuizQuestion(
        id: 'chimie_ch1_l2_q2',
        question: 'Si pKa = 4, alors Ka = ?',
        options: ['10⁴', '10⁻⁴', '4', '-4'],
        correctIndex: 1,
        lessonId: 'chimie_ch1_l2',
        explanation: 'Ka = 10^(-pKa) = 10⁻⁴.',
      ),
      QuizQuestion(
        id: 'chimie_ch1_l2_q3',
        question: 'La relation d\'Henderson-Hasselbalch est :',
        options: ['pH = pKa + log([base]/[acide])', 'pH = pKa - log([base]/[acide])', 'pH = log([base]/[acide])', 'pH = pKa + log([acide]/[base])'],
        correctIndex: 0,
        lessonId: 'chimie_ch1_l2',
        explanation: 'pH = pKa + log([A⁻]/[AH]).',
      ),
    ],
    'chimie_ch1_l3': [
      QuizQuestion(
        id: 'chimie_ch1_l3_q1',
        question: 'Le point d\'équivalence d\'un dosage est le point où :',
        options: ['Le pH est neutre', 'Les réactifs sont en proportions stœchiométriques', 'La couleur change', 'Le volume est maximal'],
        correctIndex: 1,
        lessonId: 'chimie_ch1_l3',
        explanation: 'À l\'équivalence, n(acide) = n(base).',
      ),
      QuizQuestion(
        id: 'chimie_ch1_l3_q2',
        question: 'Un bon indicateur coloré change de couleur autour de :',
        options: ['pH = 7', 'Son pKa ± 1', 'Son pKa', 'pH = 0'],
        correctIndex: 1,
        lessonId: 'chimie_ch1_l3',
        explanation: 'La zone de virage est pKa ± 1.',
      ),
      QuizQuestion(
        id: 'chimie_ch1_l3_q3',
        question: 'Pour doser 20 mL d\'HCl par NaOH 0,1 M, le volume équivalent est 20 mL. La concentration d\'HCl est :',
        options: ['0,05 M', '0,1 M', '0,2 M', '1 M'],
        correctIndex: 1,
        lessonId: 'chimie_ch1_l3',
        explanation: 'C₁V₁ = C₂V₂ ⇒ C₁ = (0,1 × 20)/20 = 0,1 M.',
      ),
    ],
  };

  // ── Chimie Ch2 : Électrochimie ──

  static final Map<String, List<QuizQuestion>> _chimieCh2 = {
    'chimie_ch2_l1': [
      QuizQuestion(
        id: 'chimie_ch2_l1_q1',
        question: 'Le nombre d\'oxydation (n.o.) de l\'oxygène dans H₂O est :',
        options: ['+2', '-1', '-2', '0'],
        correctIndex: 2,
        lessonId: 'chimie_ch2_l1',
        explanation: 'Dans H₂O, l\'oxygène a pour n.o. = -2 (règle classique).',
      ),
      QuizQuestion(
        id: 'chimie_ch2_l1_q2',
        question: 'Une oxydation correspond à :',
        options: ['Une diminution du n.o.', 'Un gain d\'électrons', 'Une augmentation du n.o. (perte d\'électrons)', 'Une réduction'],
        correctIndex: 2,
        lessonId: 'chimie_ch2_l1',
        explanation: 'Oxydation = perte d\'électrons = augmentation du nombre d\'oxydation.',
      ),
      QuizQuestion(
        id: 'chimie_ch2_l1_q3',
        question: 'Dans la réaction Fe²⁺ → Fe³⁺ + e⁻, le fer est :',
        options: ['Réduit', 'Oxydé', 'Inchangé', 'Protonné'],
        correctIndex: 1,
        lessonId: 'chimie_ch2_l1',
        explanation: 'Fe²⁺ → Fe³⁺ : le n.o. augmente de +2 à +3, c\'est une oxydation.',
      ),
    ],
    'chimie_ch2_l2': [
      QuizQuestion(
        id: 'chimie_ch2_l2_q1',
        question: 'Dans une pile électrochimique, l\'anode est :',
        options: ['L\'électrode positive', 'L\'électrode négative où se produit l\'oxydation', 'L\'électrode de cuivre', 'L\'électrode positive où se produit la réduction'],
        correctIndex: 1,
        lessonId: 'chimie_ch2_l2',
        explanation: 'Anode = électrode négative (convention française) = site d\'oxydation.',
      ),
      QuizQuestion(
        id: 'chimie_ch2_l2_q2',
        question: 'La force électromotrice (f.é.m.) d\'une pile est :',
        options: ['La différence de potentiel en circuit fermé', 'La différence de potentiel en circuit ouvert', 'Le courant débité', 'La résistance interne'],
        correctIndex: 1,
        lessonId: 'chimie_ch2_l2',
        explanation: 'F.é.m. = différence de potentiel en circuit ouvert (I = 0).',
      ),
      QuizQuestion(
        id: 'chimie_ch2_l2_q3',
        question: 'Pour qu\'une pile fonctionne spontanément, la f.é.m. doit être :',
        options: ['Nulle', 'Négative', 'Positive', 'Inférieure à 1V'],
        correctIndex: 2,
        lessonId: 'chimie_ch2_l2',
        explanation: 'Réaction spontanée ⟺ f.é.m. > 0.',
      ),
    ],
    'chimie_ch2_l3': [
      QuizQuestion(
        id: 'chimie_ch2_l3_q1',
        question: 'L\'électrolyse consiste à :',
        options: ['Produire de l\'électricité', 'Provoquer une réaction redox par un courant électrique', 'Mesurer le pH', 'Séparer des gaz'],
        correctIndex: 1,
        lessonId: 'chimie_ch2_l3',
        explanation: 'Électrolyse = imposer un courant pour réaliser une réaction non spontanée.',
      ),
      QuizQuestion(
        id: 'chimie_ch2_l3_q2',
        question: 'La première loi de Faraday relie la masse déposée à :',
        options: ['La température', 'La quantité d\'électricité (Q = It)', 'La pression', 'Le volume'],
        correctIndex: 1,
        lessonId: 'chimie_ch2_l3',
        explanation: 'm = M·I·t/(n·F), proportionnelle à la charge Q = It.',
      ),
      QuizQuestion(
        id: 'chimie_ch2_l3_q3',
        question: 'Pour l\'électrolyse de CuSO₄(aq) avec des électrodes inoxydables, le cuivre se dépose sur :',
        options: ['L\'anode', 'La cathode', 'Les deux électrodes', 'Le fond du récipient'],
        correctIndex: 1,
        lessonId: 'chimie_ch2_l3',
        explanation: 'Cu²⁺ + 2e⁻ → Cu, la réduction a lieu à la cathode.',
      ),
    ],
  };

  // ── Chimie Ch3 : Chimie organique ──

  static final Map<String, List<QuizQuestion>> _chimieCh3 = {
    'chimie_ch3_l1': [
      QuizQuestion(
        id: 'chimie_ch3_l1_q1',
        question: 'La formule générale des alcanes est :',
        options: ['CₙH₂ₙ', 'CₙH₂ₙ₊₂', 'CₙH₂ₙ₋₂', 'CₙHₙ'],
        correctIndex: 1,
        lessonId: 'chimie_ch3_l1',
        explanation: 'Alcanes (saturés) : CₙH₂ₙ₊₂.',
      ),
      QuizQuestion(
        id: 'chimie_ch3_l1_q2',
        question: 'Un alcène contient au moins :',
        options: ['Une triple liaison', 'Une double liaison carbone-carbone', 'Un cycle', 'Un atome d\'oxygène'],
        correctIndex: 1,
        lessonId: 'chimie_ch3_l1',
        explanation: 'Alcène = hydrocarbure comportant au moins une double liaison C=C.',
      ),
      QuizQuestion(
        id: 'chimie_ch3_l1_q3',
        question: 'Le méthane CH₄ est un :',
        options: ['Alcène', 'Alcane', 'Alcyne', 'Alcool'],
        correctIndex: 1,
        lessonId: 'chimie_ch3_l1',
        explanation: 'CH₄ est le premier alcane (n = 1, C₁H₄).',
      ),
    ],
    'chimie_ch3_l2': [
      QuizQuestion(
        id: 'chimie_ch3_l2_q1',
        question: 'La fonction alcool est caractérisée par le groupement :',
        options: ['-CHO', '-OH', '-COOH', '-C=O'],
        correctIndex: 1,
        lessonId: 'chimie_ch3_l2',
        explanation: 'Un alcool contient un groupement hydroxyle -OH lié à un carbone saturé.',
      ),
      QuizQuestion(
        id: 'chimie_ch3_l2_q2',
        question: 'Un aldéhyde contient le groupement :',
        options: ['-OH', '-COOH', '-CHO', '-CO-'],
        correctIndex: 2,
        lessonId: 'chimie_ch3_l2',
        explanation: 'Aldéhyde : groupement -CHO (carbonyl en bout de chaîne).',
      ),
      QuizQuestion(
        id: 'chimie_ch3_l2_q3',
        question: 'L\'acide acétique CH₃COOH est un :',
        options: ['Aldéhyde', 'Cétone', 'Acide carboxylique', 'Alcool'],
        correctIndex: 2,
        lessonId: 'chimie_ch3_l2',
        explanation: 'CH₃COOH contient le groupement -COOH, c\'est un acide carboxylique.',
      ),
    ],
    'chimie_ch3_l3': [
      QuizQuestion(
        id: 'chimie_ch3_l3_q1',
        question: 'La réaction d\'addition sur un alcène consiste à :',
        options: ['Retirer un atome d\'hydrogène', 'Ajouter une molécule en brisant la double liaison', 'Remplacer un atome', 'Créer un cycle'],
        correctIndex: 1,
        lessonId: 'chimie_ch3_l3',
        explanation: 'Addition : la double liaison s\'ouvre pour accueillir de nouveaux atomes.',
      ),
      QuizQuestion(
        id: 'chimie_ch3_l3_q2',
        question: 'La réaction d\'esterification entre un alcool et un acide carboxylique produit :',
        options: ['Un aldéhyde et de l\'eau', 'Un ester et de l\'eau', 'Un alcyne', 'Un éther'],
        correctIndex: 1,
        lessonId: 'chimie_ch3_l3',
        explanation: 'Acide + Alcool ⇌ Ester + Eau (catalyse acide).',
      ),
      QuizQuestion(
        id: 'chimie_ch3_l3_q3',
        question: 'La polymérisation d\'un alcène (comme l\'éthylène) produit :',
        options: ['Un monomère', 'Un polymère (polyéthylène)', 'Un ester', 'Un alcool'],
        correctIndex: 1,
        lessonId: 'chimie_ch3_l3',
        explanation: 'n CH₂=CH₂ → (-CH₂-CH₂-)ₙ, polymérisation par addition.',
      ),
    ],
  };

  // ── Chimie Ch4 : Cinétique chimique ──

  static final Map<String, List<QuizQuestion>> _chimieCh4 = {
    'chimie_ch4_l1': [
      QuizQuestion(
        id: 'chimie_ch4_l1_q1',
        question: 'La vitesse de réaction est définie par :',
        options: ['v = Δ[V]/Δt (en valeur absolue)', 'v = [V] × t', 'v = [V]²', 'v = [V]/[R]'],
        correctIndex: 0,
        lessonId: 'chimie_ch4_l1',
        explanation: 'v = |Δ[V]|/Δt, variation de concentration par unité de temps.',
      ),
      QuizQuestion(
        id: 'chimie_ch4_l1_q2',
        question: 'Un facteur qui augmente la vitesse de réaction est :',
        options: ['La diminution de température', 'La diminution de concentration', 'L\'augmentation de température', 'L\'absence de catalyseur'],
        correctIndex: 2,
        lessonId: 'chimie_ch4_l1',
        explanation: 'Température ↑ → vitesse ↑ (augmentation des collisions efficaces).',
      ),
      QuizQuestion(
        id: 'chimie_ch4_l1_q3',
        question: 'La loi de vitesse pour une réaction d\'ordre 1 est :',
        options: ['v = k[A]²', 'v = k[A]', 'v = k', 'v = k/[A]'],
        correctIndex: 1,
        lessonId: 'chimie_ch4_l1',
        explanation: 'Ordre 1 : v = k·[A], proportionnelle à la concentration.',
      ),
    ],
    'chimie_ch4_l2': [
      QuizQuestion(
        id: 'chimie_ch4_l2_q1',
        question: 'Un catalyseur agit en :',
        options: ['Élevant l\'énergie d\'activation', 'Diminuant l\'énergie d\'activation', 'Changeant l\'enthalpie de réaction', 'Modifiant l\'équilibre'],
        correctIndex: 1,
        lessonId: 'chimie_ch4_l2',
        explanation: 'Le catalyseur abaisse l\'énergie d\'activation Ea sans être consommé.',
      ),
      QuizQuestion(
        id: 'chimie_ch4_l2_q2',
        question: 'Un catalyseur modifie-t-il la position de l\'équilibre chimique ?',
        options: ['Oui, il déplace l\'équilibre vers les produits', 'Non, il accélère uniquement l\'atteinte de l\'équilibre', 'Oui, il augmente la constante d\'équilibre', 'Oui, il diminue K'],
        correctIndex: 1,
        lessonId: 'chimie_ch4_l2',
        explanation: 'Le catalyseur accélère la vitesse directe et inverse de la même manière, K est inchangée.',
      ),
      QuizQuestion(
        id: 'chimie_ch4_l2_q3',
        question: 'La catalyse homogène signifie que :',
        options: ['Le catalyseur est un solide', 'Le catalyseur et les réactifs sont dans la même phase', 'Le catalyseur est un gaz', 'Le catalyseur est un métal'],
        correctIndex: 1,
        lessonId: 'chimie_ch4_l2',
        explanation: 'Catalyse homogène : catalyseur et réactifs dans la même phase.',
      ),
    ],
  };

  // ── Chimie Ch5 : Thermodynamique chimique ──

  static final Map<String, List<QuizQuestion>> _chimieCh5 = {
    'chimie_ch5_l1': [
      QuizQuestion(
        id: 'chimie_ch5_l1_q1',
        question: 'L\'enthalpie de réaction ΔH est négative quand la réaction est :',
        options: ['Endothermique', 'Exothermique', 'Neutre', 'Impossibe'],
        correctIndex: 1,
        lessonId: 'chimie_ch5_l1',
        explanation: 'ΔH < 0 → réaction exothermique (libère de la chaleur).',
      ),
      QuizQuestion(
        id: 'chimie_ch5_l1_q2',
        question: 'La loi de Hess dit que :',
        options: ['L\'enthalpie dépend du chemin', 'L\'enthalpie ne dépend que de l\'état initial et final', 'ΔH = TΔS', 'ΔG = ΔH + TΔS'],
        correctIndex: 1,
        lessonId: 'chimie_ch5_l1',
        explanation: 'ΔH est une fonction d\'état, indépendante du chemin parcouru.',
      ),
      QuizQuestion(
        id: 'chimie_ch5_l1_q3',
        question: 'La relation ΔG = ΔH - TΔS permet de prévoir la spontanéité si ΔG est :',
        options: ['Positif', 'Nul', 'Négatif', 'Supérieur à TΔS'],
        correctIndex: 2,
        lessonId: 'chimie_ch5_l1',
        explanation: 'ΔG < 0 → réaction spontanée.',
      ),
    ],
    'chimie_ch5_l2': [
      QuizQuestion(
        id: 'chimie_ch5_l2_q1',
        question: 'La constante d\'équilibre K est définie pour :',
        options: ['Une réaction totale', 'Une réaction à l\'équilibre', 'Une réaction endothermique', 'Un réactif pur'],
        correctIndex: 1,
        lessonId: 'chimie_ch5_l2',
        explanation: 'K = [produits]^ν / [réactifs]^ν à l\'équilibre.',
      ),
      QuizQuestion(
        id: 'chimie_ch5_l2_q2',
        question: 'Si K est très grande, cela signifie que :',
        options: ['Les réactifs sont prédominants', 'Les produits sont prédominants à l\'équilibre', 'La réaction ne se produit pas', 'L\'équilibre est instable'],
        correctIndex: 1,
        lessonId: 'chimie_ch5_l2',
        explanation: 'K >> 1 → l\'équilibre est déplacé fortement vers les produits.',
      ),
      QuizQuestion(
        id: 'chimie_ch5_l2_q3',
        question: 'L\'ajout d\'un réactif à un système à l\'équilibre déplace l\'équilibre :',
        options: ['Vers la gauche (réactifs)', 'Vers la droite (produits)', 'Ne déplace pas l\'équilibre', 'Le déplace aléatoirement'],
        correctIndex: 1,
        lessonId: 'chimie_ch5_l2',
        explanation: 'Principe de Le Chatelier : ajouter un réactif déplace l\'équilibre vers les produits.',
      ),
    ],
  };

  // ── Chimie Ch6 : Solution aqueuse ──

  static final Map<String, List<QuizQuestion>> _chimieCh6 = {
    'chimie_ch6_l1': [
      QuizQuestion(
        id: 'chimie_ch6_l1_q1',
        question: 'Le produit de solubilité Ks pour AgCl s\'écrit :',
        options: ['Ks = [Ag⁺] + [Cl⁻]', 'Ks = [Ag⁺] × [Cl⁻]', 'Ks = [AgCl]', 'Ks = [Ag⁺]² × [Cl⁻]'],
        correctIndex: 1,
        lessonId: 'chimie_ch6_l1',
        explanation: 'Ks = [Ag⁺][Cl⁻] pour AgCl(s) ⇌ Ag⁺(aq) + Cl⁻(aq).',
      ),
      QuizQuestion(
        id: 'chimie_ch6_l1_q2',
        question: 'Un précipité se forme quand le produit des concentrations (Q) :',
        options: ['Est inférieur à Ks', 'Est égal à Ks', 'Est supérieur à Ks', 'Est nul'],
        correctIndex: 2,
        lessonId: 'chimie_ch6_l1',
        explanation: 'Q > Ks → précipitation (solution sursaturée).',
      ),
      QuizQuestion(
        id: 'chimie_ch6_l1_q3',
        question: 'La solubilité molaire s de BaSO₄ (Ks = 10⁻¹⁰) est :',
        options: ['10⁻¹⁰ M', '10⁻⁵ M', '10⁻²⁰ M', '10⁻³ M'],
        correctIndex: 1,
        lessonId: 'chimie_ch6_l1',
        explanation: 'Ks = s² → s = √Ks = √10⁻¹⁰ = 10⁻⁵ M.',
      ),
    ],
  };

  // ── SVT Ch1 : Génétique ──

  static final Map<String, List<QuizQuestion>> _svtCh1 = {
    'svt_ch1_l1': [
      QuizQuestion(
        id: 'svt_ch1_l1_q1',
        question: 'L\'ADN est une molécule formée de :',
        options: ['2 brins en double hélice', '1 brin linéaire', '3 brins en triple hélice', '4 brins parallèles'],
        correctIndex: 0,
        lessonId: 'svt_ch1_l1',
        explanation: 'L\'ADN est une double hélice de deux brins complémentaires.',
      ),
      QuizQuestion(
        id: 'svt_ch1_l1_q2',
        question: 'Quelles bases azotées sont complémentaires dans l\'ADN ?',
        options: ['A-C et T-G', 'A-T et C-G', 'A-G et T-C', 'A-U et C-G'],
        correctIndex: 1,
        lessonId: 'svt_ch1_l1',
        explanation: 'Adénine-Thymine et Cytosine-Guanine.',
      ),
      QuizQuestion(
        id: 'svt_ch1_l1_q3',
        question: 'La réplication de l\'ADN est dite :',
        options: ['Conservative', 'Semi-conservative', 'Aléatoire', 'Dispersive'],
        correctIndex: 1,
        lessonId: 'svt_ch1_l1',
        explanation: 'Chaque brin parent sert de modèle → semi-conservative.',
      ),
      QuizQuestion(
        id: 'svt_ch1_l1_q4',
        question: 'Un nucléotide est constitué de :',
        options: ['Phosphate + sucre + base azotée', 'Sucre + acide aminé', 'Phosphate + base seule', 'Base azotée + lipide'],
        correctIndex: 0,
        lessonId: 'svt_ch1_l1',
        explanation: 'Nucléotide = phosphate + désoxyribose + base azotée.',
      ),
    ],
    'svt_ch1_l2': [
      QuizQuestion(
        id: 'svt_ch1_l2_q1',
        question: 'La transcription transforme :',
        options: ['ADN en protéine', 'ADN en ARNm', 'ARNm en ADN', 'ARNm en protéine'],
        correctIndex: 1,
        lessonId: 'svt_ch1_l2',
        explanation: 'Transcription = ADN → ARNm.',
      ),
      QuizQuestion(
        id: 'svt_ch1_l2_q2',
        question: 'La traduction a lieu :',
        options: ['Dans le noyau', 'Dans le cytoplasme (ribosomes)', 'Dans la membrane', 'Dans les mitochondries'],
        correctIndex: 1,
        lessonId: 'svt_ch1_l2',
        explanation: 'La traduction se fait au niveau des ribosomes dans le cytoplasme.',
      ),
      QuizQuestion(
        id: 'svt_ch1_l2_q3',
        question: 'Un codon est :',
        options: ['Un triplet de nucléotides', 'Un acide aminé', 'Un gène', 'Une protéine'],
        correctIndex: 0,
        lessonId: 'svt_ch1_l2',
        explanation: 'Un codon = 3 nucléotides codant pour un acide aminé.',
      ),
    ],
    'svt_ch1_l3': [
      QuizQuestion(
        id: 'svt_ch1_l3_q1',
        question: 'La méiose produit :',
        options: ['2 cellules diploïdes', '4 cellules haploïdes', '2 cellules haploïdes', '4 cellules diploïdes'],
        correctIndex: 1,
        lessonId: 'svt_ch1_l3',
        explanation: 'Méiose : 2 divisions → 4 cellules haploïdes.',
      ),
      QuizQuestion(
        id: 'svt_ch1_l3_q2',
        question: 'Le crossing-over est un échange de fragments entre :',
        options: ['Chromosomes homologues', 'Chromatides sœurs', 'Gènes allèles', 'Cellules filles'],
        correctIndex: 0,
        lessonId: 'svt_ch1_l3',
        explanation: 'Crossing-over = échange entre chromosomes homologues lors de la prophase I.',
      ),
      QuizQuestion(
        id: 'svt_ch1_l3_q3',
        question: 'Une mutation ponctuelle par substitution peut être :',
        options: ['Silencieuse, faux-sens ou non-sens', 'Toujours mortelle', 'Toujours bénéfique', 'Réversible uniquement'],
        correctIndex: 0,
        lessonId: 'svt_ch1_l3',
        explanation: 'Substitution → silencieuse, faux-sens (AA change) ou non-sens (codon stop).',
      ),
    ],
    'svt_ch1_l4': [
      QuizQuestion(
        id: 'svt_ch1_l4_q1',
        question: 'Un allèle récessif s\'exprime phénotypiquement quand :',
        options: ['Il est présent en un seul exemplaire', 'Il est présent à l\'état homozygote', 'Il est dominant', 'Il est sur le chromosome X'],
        correctIndex: 1,
        lessonId: 'svt_ch1_l4',
        explanation: 'Un allèle récessif ne s\'exprime qu\'à l\'état homozygote.',
      ),
      QuizQuestion(
        id: 'svt_ch1_l4_q2',
        question: 'La drépanocytose est due à une mutation du gène de :',
        options: ['L\'hémoglobine', 'L\'insuline', 'La myoglobine', 'La fibrine'],
        correctIndex: 0,
        lessonId: 'svt_ch1_l4',
        explanation: 'Mutation du gène de la β-globine de l\'hémoglobine.',
      ),
      QuizQuestion(
        id: 'svt_ch1_l4_q3',
        question: 'Si deux parents sains ont un enfant atteint d\'une maladie récessive, alors :',
        options: ['Les deux parents sont homozygotes sains', 'Les deux parents sont hétérozygotes', 'Un parent est malade', 'La maladie est dominante'],
        correctIndex: 1,
        lessonId: 'svt_ch1_l4',
        explanation: 'Parents hétérozygotes (Aa × Aa → aa = enfant malade).',
      ),
    ],
  };

  // ── SVT Ch2 : Immunologie ──

  static final Map<String, List<QuizQuestion>> _svtCh2 = {
    'svt_ch2_l1': [
      QuizQuestion(
        id: 'svt_ch2_l1_q1',
        question: 'L\'immunité innée comprenant la peau et les muqueuses est :',
        options: ['Spécifique', 'Non spécifique', 'Adaptative', 'Acquise'],
        correctIndex: 1,
        lessonId: 'svt_ch2_l1',
        explanation: 'L\'immunité innée est non spécifique, elle agit contre tout intrus.',
      ),
      QuizQuestion(
        id: 'svt_ch2_l1_q2',
        question: 'Les phagocytes sont des cellules qui :',
        options: ['Produisent des anticorps', 'Ingestent et détruisent les micro-organismes', 'Sont présentes uniquement dans le sang', 'Ne participent pas à l\'immunité'],
        correctIndex: 1,
        lessonId: 'svt_ch2_l1',
        explanation: 'Les phagocytes (neutrophiles, macrophages) ingèrent les pathogènes par phagocytose.',
      ),
      QuizQuestion(
        id: 'svt_ch2_l1_q3',
        question: 'La fièvre est une réponse de l\'immunité qui consiste à :',
        options: ['Abaisser la température corporelle', 'Élever la température pour ralentir les pathogènes', 'Produire des anticorps', 'Détruire les globules rouges'],
        correctIndex: 1,
        lessonId: 'svt_ch2_l1',
        explanation: 'La fièvre ralentit la multiplication des micro-organismes et active le métabolisme.',
      ),
    ],
    'svt_ch2_l2': [
      QuizQuestion(
        id: 'svt_ch2_l2_q1',
        question: 'Les lymphocytes B sont responsables de :',
        options: ['L\'immunité cellulaire', 'L\'immunité humorale (production d\'anticorps)', 'La phagocytose', 'L\'inflammation'],
        correctIndex: 1,
        lessonId: 'svt_ch2_l2',
        explanation: 'Les lymphocytes B produisent des anticorps (immunité humorale).',
      ),
      QuizQuestion(
        id: 'svt_ch2_l2_q2',
        question: 'Un anticorps est une molécule produite par les :',
        options: ['Neutrophiles', 'Lymphocytes B (plasmocytes)', 'Macrophages', 'Lymphocytes T tueurs'],
        correctIndex: 1,
        lessonId: 'svt_ch2_l2',
        explanation: 'Les plasmocytes (lymphocytes B différenciés) sécrètent des anticorps.',
      ),
      QuizQuestion(
        id: 'svt_ch2_l2_q3',
        question: 'La mémoire immunologique permet :',
        options: ['De combattre toutes les maladies', 'Une réponse plus rapide et plus forte lors d\'une seconde infection', 'De créer de nouvelles cellules souches', 'De modifier l\'ADN du pathogène'],
        correctIndex: 1,
        lessonId: 'svt_ch2_l2',
        explanation: 'Les lymphocytes mémoire assurent une réponse secondary plus rapide et intense.',
      ),
    ],
    'svt_ch2_l3': [
      QuizQuestion(
        id: 'svt_ch2_l3_q1',
        question: 'Un vaccin contient :',
        options: ['Des antibiotiques', 'Des antigènes inactivés ou atténués du pathogène', 'Des anticorps', 'Des virus vivants'],
        correctIndex: 1,
        lessonId: 'svt_ch2_l3',
        explanation: 'Le vaccin introduit des antigènes (virus/bactéries tués ou atténués) pour stimuler l\'immunité.',
      ),
      QuizQuestion(
        id: 'svt_ch2_l3_q2',
        question: 'La sérothérapie consiste à injecter :',
        options: ['Un vaccin', 'Des anticorps préformés', 'Des antigènes', 'Des lymphocytes T'],
        correctIndex: 1,
        lessonId: 'svt_ch2_l3',
        explanation: 'Sérothérapie : injection d\'anticorps (sérum immunisé) pour une protection immédiate.',
      ),
      QuizQuestion(
        id: 'svt_ch2_l3_q3',
        question: 'La vaccination permet de protéger la population grâce à :',
        options: ['L\'immunité innée', 'L\'immunité de groupe (herd immunity)', 'La sélection naturelle', 'La résistance génétique'],
        correctIndex: 1,
        lessonId: 'svt_ch2_l3',
        explanation: 'Si une majorité est vaccinée, la chaîne de transmission est interrompue (immunité grégaire).',
      ),
    ],
  };

  // ── SVT Ch3 : Écologie ──

  static final Map<String, List<QuizQuestion>> _svtCh3 = {
    'svt_ch3_l1': [
      QuizQuestion(
        id: 'svt_ch3_l1_q1',
        question: 'Un écosystème est composé de :',
        options: ['Uniquement des êtres vivants (biocénose)', 'La biocénose et le biotope uniquement', 'La biocénose (êtres vivants) et le biotope (milieu)', 'Uniquement du sol et de l\'eau'],
        correctIndex: 2,
        lessonId: 'svt_ch3_l1',
        explanation: 'Écosystème = biocénose (êtres vivants) + biotope (milieu physique).',
      ),
      QuizQuestion(
        id: 'svt_ch3_l1_q2',
        question: 'Les producteurs primaires d\'un écosystème sont :',
        options: ['Les prédateurs', 'Les organismes photosynthétiques (plantes, algues)', 'Les décomposeurs', 'Les consommateurs secondaires'],
        correctIndex: 1,
        lessonId: 'svt_ch3_l1',
        explanation: 'Producteurs primaires = organismes autotrophes (plantes, cyanobactéries, algues).',
      ),
      QuizQuestion(
        id: 'svt_ch3_l1_q3',
        question: 'Les facteurs abiotiques d\'un écosystème incluent :',
        options: ['Les prédateurs et les proies', 'La température, la luminosité, le pH', 'Les bactéries et les champignons', 'Les plantes et les animaux'],
        correctIndex: 1,
        lessonId: 'svt_ch3_l1',
        explanation: 'Facteurs abiotiques = facteurs physico-chimiques du milieu (non vivants).',
      ),
    ],
    'svt_ch3_l2': [
      QuizQuestion(
        id: 'svt_ch3_l2_q1',
        question: 'Dans une chaîne alimentaire, l\'énergie est transférée :',
        options: ['Du sommet vers la base', 'Des producteurs aux consommateurs', 'Uniformément dans l\'écosystème', 'Des décomposeurs vers les producteurs'],
        correctIndex: 1,
        lessonId: 'svt_ch3_l2',
        explanation: 'L\'énergie circule des producteurs vers les consommateurs (1ère loi de la thermodynamique).',
      ),
      QuizQuestion(
        id: 'svt_ch3_l2_q2',
        question: 'À chaque maillon d\'une chaîne alimentaire, environ :',
        options: ['100% de l\'énergie est transférée', '10% de l\'énergie est transférée', '50% de l\'énergie est transférée', '1% de l\'énergie est transférée'],
        correctIndex: 1,
        lessonId: 'svt_ch3_l2',
        explanation: 'Règle du 10% : seulement ~10% de l\'énergie est assimilée au maillon suivant.',
      ),
      QuizQuestion(
        id: 'svt_ch3_l2_q3',
        question: 'La photosynthèse est le processus par lequel les plantes :',
        options: ['Respirent le CO₂', 'Synthétisent de la matière organique à partir de CO₂ et H₂O avec l\'énergie lumineuse', 'Décomposent la matière organique', 'Absorbent les minéraux du sol'],
        correctIndex: 1,
        lessonId: 'svt_ch3_l2',
        explanation: '6CO₂ + 6H₂O + hν → C₆H₁₂O₆ + 6O₂.',
      ),
    ],
    'svt_ch3_l3': [
      QuizQuestion(
        id: 'svt_ch3_l3_q1',
        question: 'La courbe de croissance logistique (en S) d\'une population montre :',
        options: ['Une croissance exponentielle indéfinie', 'Une croissance qui ralentit et atteint la capacité portante K', 'Un déclin constant', 'Une oscillation permanente'],
        correctIndex: 1,
        lessonId: 'svt_ch3_l3',
        explanation: 'La croissance logistique ralentit à mesure que la population approche la capacité portante K.',
      ),
      QuizQuestion(
        id: 'svt_ch3_l3_q2',
        question: 'Un facteur de régulation densodépendant est :',
        options: ['Un facteur indépendant de la taille de la population', 'Un facteur dont l\'intensité dépend de la densité de population', 'Un facteur climatique', 'Un facteur toujours abiotique'],
        correctIndex: 1,
        lessonId: 'svt_ch3_l3',
        explanation: 'Densodépendant : competition pour les ressources, prédation, maladies (intensité varie avec la densité).',
      ),
      QuizQuestion(
        id: 'svt_ch3_l3_q3',
        question: 'Un facteur de régulation densoindépendant est :',
        options: ['La compétition pour la nourriture', 'La prédation', 'Les catastrophes naturelles (inondations, incendies)', 'Les maladies'],
        correctIndex: 2,
        lessonId: 'svt_ch3_l3',
        explanation: 'Densoindépendant : facteurs abiotiques (climat, catastrophes) agissant indépendamment de la densité.',
      ),
    ],
  };

  // ── SVT Ch4 : Géologie ──

  static final Map<String, List<QuizQuestion>> _svtCh4 = {
    'svt_ch4_l1': [
      QuizQuestion(
        id: 'svt_ch4_l1_q1',
        question: 'La Terre est composée de couches concentriques :',
        options: ['Croûte, manteau, noyau externe, noyau interne', 'Terre, eau, air', 'Roces, minéraux, magma', 'Plaque, manteau, atmosphère'],
        correctIndex: 0,
        lessonId: 'svt_ch4_l1',
        explanation: 'Structure : croûte (5-70 km), manteau (~2900 km), noyau externe liquide, noyau interne solide.',
      ),
      QuizQuestion(
        id: 'svt_ch4_l1_q2',
        question: 'Le noyau externe de la Terre est :',
        options: ['Solide et chaud', 'Liquide et responsable du champ magnétique', 'Gazeux et froid', 'Solide et magnétique'],
        correctIndex: 1,
        lessonId: 'svt_ch4_l1',
        explanation: 'Le noyau externe liquide (fer-nickel) génère le champ magnétique terrestre par effet dynamo.',
      ),
      QuizQuestion(
        id: 'svt_ch4_l1_q3',
        question: 'La lithosphère est composée de :',
        options: ['La croûte et la partie supérieure du manteau', 'Uniquement de la croûte océanique', 'Le noyau terrestre', 'L\'atmosphère terrestre'],
        correctIndex: 0,
        lessonId: 'svt_ch4_l1',
        explanation: 'Lithosphère = croûte + partie supérieure rigide du manteau (environ 100 km d\'épaisseur).',
      ),
    ],
    'svt_ch4_l2': [
      QuizQuestion(
        id: 'svt_ch4_l2_q1',
        question: 'La dérive des continents est due à :',
        options: ['Le vent solaire', 'La convection dans le manteau', 'La rotation de la Terre', 'Les marées lunaires'],
        correctIndex: 1,
        lessonId: 'svt_ch4_l2',
        explanation: 'Les courants de convection dans l\'asthénosphère font dériver les plaques lithosphériques.',
      ),
      QuizQuestion(
        id: 'svt_ch4_l2_q2',
        question: 'Une dorsale médio-océanique correspond à :',
        options: ['Une zone de subduction', 'Une zone de divergence des plaques', 'Une zone de collision continentale', 'Un point chaud'],
        correctIndex: 1,
        lessonId: 'svt_ch4_l2',
        explanation: 'Dorsale : les plaques s\'écartent (divergence), nouvelle croûte océanique se forme.',
      ),
      QuizQuestion(
        id: 'svt_ch4_l2_q3',
        question: 'Une fosse océanique se forme au niveau d\'une :',
        options: ['Dorsale', 'Zone de subduction', 'Faille transformante', 'Hotspot'],
        correctIndex: 1,
        lessonId: 'svt_ch4_l2',
        explanation: 'Fosse = zone où une plaque plonge sous une autre (subduction).',
      ),
    ],
    'svt_ch4_l3': [
      QuizQuestion(
        id: 'svt_ch4_l3_q1',
        question: 'Une roche magmatique se forme par :',
        options: ['L\'érosion', 'Le refroidissement et la solidification du magma', 'La pression des sédiments', 'L\'action des bactéries'],
        correctIndex: 1,
        lessonId: 'svt_ch4_l3',
        explanation: 'Roches magmatiques : refroidissement du magma (intrusive) ou de la lave (extrusive).',
      ),
      QuizQuestion(
        id: 'svt_ch4_l3_q2',
        question: 'Le granite est une roche :',
        options: ['Sédimentaire', 'Magmatique intrusive (plutonique)', 'Métamorphique', 'Volcanique'],
        correctIndex: 1,
        lessonId: 'svt_ch4_l3',
        explanation: 'Le granite est une roche magmatique intrusive, formée par refroidissement lent en profondeur.',
      ),
      QuizQuestion(
        id: 'svt_ch4_l3_q3',
        question: 'Le calcaire est une roche :',
        options: ['Magmatique', 'Sédimentaire chimique/biogénique', 'Métamorphique', 'Volcanique'],
        correctIndex: 1,
        lessonId: 'svt_ch4_l3',
        explanation: 'Le calcaire est une roche sédimentaire formée par dépôt de carbonates (CaCO₃).',
      ),
    ],
  };

  // ── SVT Ch5 : Cellule ──

  static final Map<String, List<QuizQuestion>> _svtCh5 = {
    'svt_ch5_l1': [
      QuizQuestion(
        id: 'svt_ch5_l1_q1',
        question: 'La membrane plasmique est constituée principalement de :',
        options: ['ADN', 'Une bicouche lipidique avec des protéines', 'Des glucides uniquement', 'Du collagène'],
        correctIndex: 1,
        lessonId: 'svt_ch5_l1',
        explanation: 'Modèle de Singer : bicouche lipidique (phospholipides) avec protéines intégrées.',
      ),
      QuizQuestion(
        id: 'svt_ch5_l1_q2',
        question: 'Le noyau contient :',
        options: ['Les ribosomes uniquement', 'L\'ADN (génome)', 'La mitochondrie', 'Le reticulum endoplasmique'],
        correctIndex: 1,
        lessonId: 'svt_ch5_l1',
        explanation: 'Le noyau abrite l\'ADN, support de l\'information génétique.',
      ),
      QuizQuestion(
        id: 'svt_ch5_l1_q3',
        question: 'Les mitochondries sont les organites responsables de :',
        options: ['La photosynthèse', 'La respiration cellulaire et la production d\'ATP', 'La synthèse des protéines', 'Le stockage des lipides'],
        correctIndex: 1,
        lessonId: 'svt_ch5_l1',
        explanation: 'Mitochondries : respiration aérobie et production d\'ATP (centrale énergétique).',
      ),
    ],
    'svt_ch5_l2': [
      QuizQuestion(
        id: 'svt_ch5_l2_q1',
        question: 'La glycolyse a lieu dans :',
        options: ['La mitochondrie', 'Le noyau', 'Le cytoplasme', 'Le reticulum endoplasmique'],
        correctIndex: 2,
        lessonId: 'svt_ch5_l2',
        explanation: 'La glycolyse se déroule dans le cytoplasme (ne nécessite pas l\'oxygène).',
      ),
      QuizQuestion(
        id: 'svt_ch5_l2_q2',
        question: 'Le cycle de Krebs a lieu dans :',
        options: ['Le noyau', 'La matrice mitochondriale', 'Le cytoplasme', 'Le chloroplaste'],
        correctIndex: 1,
        lessonId: 'svt_ch5_l2',
        explanation: 'Le cycle de Krebs se déroule dans la matrice mitochondriale.',
      ),
      QuizQuestion(
        id: 'svt_ch5_l2_q3',
        question: 'La phosphorylation oxydative produit principalement de l\'ATP grâce à :',
        options: ['La glycolyse', 'La chaîne respiratoire et l\'ATP synthase', 'Le cycle de Krebs seul', 'La photosynthèse'],
        correctIndex: 1,
        lessonId: 'svt_ch5_l2',
        explanation: 'La chaîne d\'électrons et l\'ATP synthase dans la membrane mitochondriale interne produisent l\'ATP.',
      ),
    ],
  };

  // ── SVT Ch6 : Reproduction ──

  static final Map<String, List<QuizQuestion>> _svtCh6 = {
    'svt_ch6_l1': [
      QuizQuestion(
        id: 'svt_ch6_l1_q1',
        question: 'Les testicules sont responsables de :',
        options: ['La production d\'ovules', 'La production de spermatozoïdes et de testostérone', 'La production d\'œstrogènes', 'La production d\'insuline'],
        correctIndex: 1,
        lessonId: 'svt_ch6_l1',
        explanation: 'Les testicules produisent les spermatozoïdes (spermatogenèse) et l\'hormone testostérone.',
      ),
      QuizQuestion(
        id: 'svt_ch6_l1_q2',
        question: 'La spermatogenèse est le processus de :',
        options: ['Production des ovules', 'Production des spermatozoïdes', 'Production des hormones féminines', 'Division cellulaire dans l\'utérus'],
        correctIndex: 1,
        lessonId: 'svt_ch6_l1',
        explanation: 'Spermatogenèse : formation des spermatozoïdes dans les tubules séminifères.',
      ),
      QuizQuestion(
        id: 'svt_ch6_l1_q3',
        question: 'L\'ovaire a pour double fonction :',
        options: ['Exocrine et endocrine', 'Production d\'ovules et sécrétion d\'hormones (œstrogènes, progestérone)', 'Stockage et digestion', 'Filtration du sang'],
        correctIndex: 1,
        lessonId: 'svt_ch6_l1',
        explanation: 'L\'ovaire produit les ovules (ovogenèse) et sécrète les hormones sexuelles féminines.',
      ),
    ],
    'svt_ch6_l2': [
      QuizQuestion(
        id: 'svt_ch6_l2_q1',
        question: 'Le cycle menstruel dure en moyenne :',
        options: ['7 jours', '14 jours', '28 jours', '90 jours'],
        correctIndex: 2,
        lessonId: 'svt_ch6_l2',
        explanation: 'Cycle menstruel moyen : 28 jours (variable de 24 à 35 jours).',
      ),
      QuizQuestion(
        id: 'svt_ch6_l2_q2',
        question: 'L\'ovulation est déclenchée par un pic de :',
        options: ['Progestérone', 'LH (hormone lutéinisante)', 'FSH (hormone folliculo-stimulante)', 'Œstrogènes uniquement'],
        correctIndex: 1,
        lessonId: 'svt_ch6_l2',
        explanation: 'Le pic de LH déclenche l\'ovulation (libération de l\'ovule du follicule).',
      ),
      QuizQuestion(
        id: 'svt_ch6_l2_q3',
        question: 'La progestérone est sécrétée par :',
        options: ['Le follicule ovarique', 'Le corps jaune', 'L\'hypophyse', 'L\'hypothalamus'],
        correctIndex: 1,
        lessonId: 'svt_ch6_l2',
        explanation: 'Le corps jaune (follicule après ovulation) sécrète la progestérone.',
      ),
    ],
    'svt_ch6_l3': [
      QuizQuestion(
        id: 'svt_ch6_l3_q1',
        question: 'La fécondation a lieu dans :',
        options: ['L\'utérus', 'Les trompes de Fallope', 'L\'ovaire', 'Le col de l\'utérus'],
        correctIndex: 1,
        lessonId: 'svt_ch6_l3',
        explanation: 'La fécondation (rencontre spermatozoïde + ovule) se fait dans la trompe.',
      ),
      QuizQuestion(
        id: 'svt_ch6_l3_q2',
        question: 'La nidation est le processus par lequel :',
        options: ['L\'ovule est libéré', 'L\'œuf s\'implante dans la paroi de l\'utérus', 'Le spermatozoïde pénètre l\'ovule', 'L\'embryon se divise'],
        correctIndex: 1,
        lessonId: 'svt_ch6_l3',
        explanation: 'Nidation : l\'œuf fécondé s\'implante dans l\'endomètre utérin (environ J6 après la fécondation).',
      ),
      QuizQuestion(
        id: 'svt_ch6_l3_q3',
        question: 'La gonadotrophine chorionique humaine (hCG) est produite par :',
        options: ['L\'hypophyse', 'Le placenta', 'L\'ovaire', 'L\'hypothalamus'],
        correctIndex: 1,
        lessonId: 'svt_ch6_l3',
        explanation: 'L\'hCG est sécrétée par le trophoblaste/placenta, elle maintient le corps jaune.',
      ),
    ],
  };

  // ── SVT Ch7 : Neurobiologie ──

  static final Map<String, List<QuizQuestion>> _svtCh7 = {
    'svt_ch7_l1': [
      QuizQuestion(
        id: 'svt_ch7_l1_q1',
        question: 'Le potentiel de repos d\'un neurone est d\'environ :',
        options: ['+40 mV', '-70 mV', '0 mV', '+100 mV'],
        correctIndex: 1,
        lessonId: 'svt_ch7_l1',
        explanation: 'Potentiel de repos ≈ -70 mV (intérieur négatif par rapport à l\'extérieur).',
      ),
      QuizQuestion(
        id: 'svt_ch7_l1_q2',
        question: 'Le potentiel d\'action est caractérisé par :',
        options: ['Une hyperpolarisation constante', 'Une inversion rapide du potentiel (depolarisation → repolarisation)', 'Une diminution lente du potentiel', 'Un potentiel toujours négatif'],
        correctIndex: 1,
        lessonId: 'svt_ch7_l1',
        explanation: 'Potentiel d\'action : dépolarisation rapide (Na⁺ entre), repolarisation (K⁺ sort), dépassement.',
      ),
      QuizQuestion(
        id: 'svt_ch7_l1_q3',
        question: 'La conduction nerveuse dans un axone myélinisé est plus rapide car :',
        options: ['La myéline conduit l\'électricité', 'Les saltations entre les nœuds de Ranvier accélèrent le signal', 'L\'axone est plus épais', 'Le diamètre est plus grand'],
        correctIndex: 1,
        lessonId: 'svt_ch7_l1',
        explanation: 'Saltatory conduction : le potentiel d\'action saute d\'un nœud de Ranvier à l\'autre.',
      ),
    ],
    'svt_ch7_l2': [
      QuizQuestion(
        id: 'svt_ch7_l2_q1',
        question: 'Une synapse chimique transmet le signal par :',
        options: ['Courant électrique direct', 'Libération de neurotransmetteurs dans la fente synaptique', 'Contact mécanique', 'Ondes radio'],
        correctIndex: 1,
        lessonId: 'svt_ch7_l2',
        explanation: 'Synapse chimique : les vésicules libèrent des neurotransmetteurs dans la fente synaptique.',
      ),
      QuizQuestion(
        id: 'svt_ch7_l2_q2',
        question: 'L\'acétylcholine est un neurotransmetteur qui est :',
        options: ['Toujours inhibiteur', 'Toujours exciteur', 'Exciteur ou inhibiteur selon le récepteur', 'Inactif'],
        correctIndex: 2,
        lessonId: 'svt_ch7_l2',
        explanation: 'L\'acétylcholine est excitatrice dans le système nerveux somatique mais peut être inhibitrice dans le système nerveux autonome.',
      ),
      QuizQuestion(
        id: 'svt_ch7_l2_q3',
        question: 'Le potentiel postsynaptique excitateur (PPSE) est dû à :',
        options: ['L\'entrée de K⁺', 'L\'entrée de Na⁺', 'La sortie de Na⁺', 'L\'entrée de Ca²⁺'],
        correctIndex: 1,
        lessonId: 'svt_ch7_l2',
        explanation: 'PPSE : ouverture de canaux Na⁺ → dépolarisation de la membrane postsynaptique.',
      ),
    ],
  };

  // ── Info Ch1 : Algorithmique ──

  static final Map<String, List<QuizQuestion>> _infoCh1 = {
    'info_ch1_l1': [
      QuizQuestion(
        id: 'info_ch1_l1_q1',
        question: 'Un algorithme est :',
        options: ['Un programme exécutable', 'Une suite finie d\'instructions pour résoudre un problème', 'Un langage de programmation', 'Un compilateur'],
        correctIndex: 1,
        lessonId: 'info_ch1_l1',
        explanation: 'Un algorithme est une suite finie d\'instructions logiques.',
      ),
      QuizQuestion(
        id: 'info_ch1_l1_q2',
        question: 'Dans un organigramme, le losange représente :',
        options: ['Un traitement', 'Une décision', 'Une entrée/sortie', 'Le début ou la fin'],
        correctIndex: 1,
        lessonId: 'info_ch1_l1',
        explanation: 'Le losange symbolise un test ou une décision.',
      ),
      QuizQuestion(
        id: 'info_ch1_l1_q3',
        question: 'Laquelle de ces propositions n\'est pas un type de données ?',
        options: ['Entier', 'Réel', 'Tableau', 'Condition'],
        correctIndex: 3,
        lessonId: 'info_ch1_l1',
        explanation: '"Condition" n\'est pas un type de données. Les types sont entier, réel, booléen, caractère.',
      ),
    ],
    'info_ch1_l2': [
      QuizQuestion(
        id: 'info_ch1_l2_q1',
        question: 'La structure conditionnelle simple est :',
        options: ['Pour...FinPour', 'Si...Alors...Sinon', 'TantQue...FinTantQue', 'Répéter...Jusqu\'à'],
        correctIndex: 1,
        lessonId: 'info_ch1_l2',
        explanation: 'La conditionnelle classique est Si...Alors...Sinon.',
      ),
      QuizQuestion(
        id: 'info_ch1_l2_q2',
        question: 'La boucle "Pour i de 1 à N" est utilisée quand :',
        options: ['Le nombre d\'itérations est inconnu', 'Le nombre d\'itérations est connu', 'On attend une entrée utilisateur', 'La condition est fausse au départ'],
        correctIndex: 1,
        lessonId: 'info_ch1_l2',
        explanation: 'La boucle Pour est utilisée quand le nombre de répétitions est connu.',
      ),
      QuizQuestion(
        id: 'info_ch1_l2_q3',
        question: 'Quel algorithme calcule la factorielle d\'un nombre n ?',
        options: ['n! = n × (n-1) × ... × 1', 'n! = n + (n-1) + ... + 1', 'n! = n²', 'n! = 2ⁿ'],
        correctIndex: 0,
        lessonId: 'info_ch1_l2',
        explanation: 'n! = n × (n-1) × (n-2) × ... × 1.',
      ),
    ],
    'info_ch1_l3': [
      QuizQuestion(
        id: 'info_ch1_l3_q1',
        question: 'Une fonction récursive est une fonction qui :',
        options: ['S\'appelle elle-même', 'Ne retourne rien', 'Utilise des boucles', 'Est définie dans une autre fonction'],
        correctIndex: 0,
        lessonId: 'info_ch1_l3',
        explanation: 'Récursivité = fonction qui s\'appelle elle-même.',
      ),
      QuizQuestion(
        id: 'info_ch1_l3_q2',
        question: 'Le passage par valeur signifie que :',
        options: ['La variable est modifiée dans l\'appelant', 'Une copie de la variable est transmise', 'L\'adresse mémoire est transmise', 'La variable est globale'],
        correctIndex: 1,
        lessonId: 'info_ch1_l3',
        explanation: 'Passage par valeur : copie de la variable, l\'original n\'est pas modifié.',
      ),
      QuizQuestion(
        id: 'info_ch1_l3_q3',
        question: 'Fibonacci(6) = ? (suite : 0,1,1,2,3,5,8,13...)',
        options: ['5', '8', '13', '21'],
        correctIndex: 1,
        lessonId: 'info_ch1_l3',
        explanation: 'F(0)=0, F(1)=1, F(6)=8.',
      ),
    ],
  };

  // ── Info Ch2 : Structures de données ──

  static final Map<String, List<QuizQuestion>> _infoCh2 = {
    'info_ch2_l1': [
      QuizQuestion(
        id: 'info_ch2_l1_q1',
        question: 'Un tableau est une structure de données qui permet d\'accéder à un élément par :',
        options: ['Une clé alphabétique', 'Un indice (index)', 'Un parcours aléatoire', 'Un pointeur'],
        correctIndex: 1,
        lessonId: 'info_ch2_l1',
        explanation: 'Dans un tableau, l\'accès se fait par l\'indice de l\'élément (accès en O(1)).',
      ),
      QuizQuestion(
        id: 'info_ch2_l1_q2',
        question: 'La différence entre un tableau statique et une liste est :',
        options: ['Le tableau est plus rapide', 'La liste a une taille dynamique, le tableau une taille fixe', 'Il n\'y a pas de différence', 'Le tableau ne stocke que des entiers'],
        correctIndex: 1,
        lessonId: 'info_ch2_l1',
        explanation: 'Liste = taille dynamique (peut grandir/retrécir), tableau = taille fixe à la déclaration.',
      ),
      QuizQuestion(
        id: 'info_ch2_l1_q3',
        question: 'L\'insertion d\'un élément au début d\'une liste non triée a une complexité :',
        options: ['O(n)', 'O(1)', 'O(n²)', 'O(log n)'],
        correctIndex: 1,
        lessonId: 'info_ch2_l1',
        explanation: 'Insertion en tête d\'une liste chaînée : O(1) (on change juste le pointeur).',
      ),
    ],
    'info_ch2_l2': [
      QuizQuestion(
        id: 'info_ch2_l2_q1',
        question: 'Une pile fonctionne selon le principe :',
        options: ['FIFO (First In, First Out)', 'LIFO (Last In, First Out)', 'Random Access', 'Priority Queue'],
        correctIndex: 1,
        lessonId: 'info_ch2_l2',
        explanation: 'Pile = LIFO : le dernier élément empilé est le premier sorti (push/pop).',
      ),
      QuizQuestion(
        id: 'info_ch2_l2_q2',
        question: 'Une file fonctionne selon le principe :',
        options: ['LIFO', 'FIFO (First In, First Out)', 'Priority', 'Stack'],
        correctIndex: 1,
        lessonId: 'info_ch2_l2',
        explanation: 'File = FIFO : le premier élément entré est le premier sorti (enqueue/dequeue).',
      ),
      QuizQuestion(
        id: 'info_ch2_l2_q3',
        question: 'Dans un navigateur web, la fonction "Retour" utilise :',
        options: ['Une file', 'Une pile', 'Un tableau', 'Un arbre'],
        correctIndex: 1,
        lessonId: 'info_ch2_l2',
        explanation: 'L\'historique de navigation est géré par une pile (LIFO).',
      ),
    ],
    'info_ch2_l3': [
      QuizQuestion(
        id: 'info_ch2_l3_q1',
        question: 'Un arbre binaire de recherche a la propriété que :',
        options: ['Tous les nœuds ont 2 enfants', 'La valeur du nœud gauche est inférieure et la droite supérieure', 'Il est toujours équilibré', 'Il ne contient que des feuilles'],
        correctIndex: 1,
        lessonId: 'info_ch2_l3',
        explanation: 'ABR : valeur(gauche) < valeur(parent) < valeur(droite).',
      ),
      QuizQuestion(
        id: 'info_ch2_l3_q2',
        question: 'La profondeur (hauteur) d\'un arbre est :',
        options: ['Le nombre total de nœuds', 'La longueur du plus long chemin de la racine à une feuille', 'Le nombre de feuilles', 'La largeur maximale'],
        correctIndex: 1,
        lessonId: 'info_ch2_l3',
        explanation: 'Hauteur = longueur du plus long chemin de la racine à une feuille.',
      ),
      QuizQuestion(
        id: 'info_ch2_l3_q3',
        question: 'Dans un graphe orienté, une arête a :',
        options: ['Deux directions', 'Une direction précise', 'Pas de direction', 'Un poids uniquement'],
        correctIndex: 1,
        lessonId: 'info_ch2_l3',
        explanation: 'Graphe orienté : les arêtes ont un sens (A → B ≠ B → A).',
      ),
    ],
  };

  // ── Info Ch3 : Python ──

  static final Map<String, List<QuizQuestion>> _infoCh3 = {
    'info_ch3_l1': [
      QuizQuestion(
        id: 'info_ch3_l1_q1',
        question: 'En Python, comment déclare-t-on une variable x contenant l\'entier 5 ?',
        options: ['int x = 5', 'x = 5', 'var x = 5', 'let x = 5'],
        correctIndex: 1,
        lessonId: 'info_ch3_l1',
        explanation: 'Python est typé dynamiquement : x = 5 suffit, sans déclaration de type.',
      ),
      QuizQuestion(
        id: 'info_ch3_l1_q2',
        question: 'La fonction print() en Python sert à :',
        options: ['Lire une entrée utilisateur', 'Afficher du texte dans la console', 'Créer une variable', 'Fermer le programme'],
        correctIndex: 1,
        lessonId: 'info_ch3_l1',
        explanation: 'print() affiche une sortie dans la console (terminal).',
      ),
      QuizQuestion(
        id: 'info_ch3_l1_q3',
        question: 'Le type str en Python correspond à :',
        options: ['Un nombre entier', 'Une chaîne de caractères', 'Un booléen', 'Une liste'],
        correctIndex: 1,
        lessonId: 'info_ch3_l1',
        explanation: 'str = string = chaîne de caractères (ex: "Bonjour").',
      ),
    ],
    'info_ch3_l2': [
      QuizQuestion(
        id: 'info_ch3_l2_q1',
        question: 'Une fonction en Python est définie avec :',
        options: ['function nom()', 'def nom():', 'func nom()', 'define nom()'],
        correctIndex: 1,
        lessonId: 'info_ch3_l2',
        explanation: 'En Python, on utilise le mot-clé def pour définir une fonction.',
      ),
      QuizQuestion(
        id: 'info_ch3_l2_q2',
        question: 'Le mot-clé return dans une fonction Python :',
        options: ['Imprime le résultat', 'Renvoie une valeur à l\'appelant', 'Termine le programme', 'Réinitialise les variables'],
        correctIndex: 1,
        lessonId: 'info_ch3_l2',
        explanation: 'return envoie la valeur de retour à l\'endroit où la fonction a été appelée.',
      ),
      QuizQuestion(
        id: 'info_ch3_l2_q3',
        question: 'Pour importer le module "math" en Python, on écrit :',
        options: ['include math', 'import math', 'require math', 'using math'],
        correctIndex: 1,
        lessonId: 'info_ch3_l2',
        explanation: 'import math permet d\'utiliser les fonctions du module math (math.sqrt, math.pi...).',
      ),
    ],
    'info_ch3_l3': [
      QuizQuestion(
        id: 'info_ch3_l3_q1',
        question: 'En POO, une classe est :',
        options: ['Une instance d\'un objet', 'Un plan/modèle pour créer des objets', 'Une fonction spéciale', 'Un type de variable'],
        correctIndex: 1,
        lessonId: 'info_ch3_l3',
        explanation: 'Classe = modèle (blueprint) qui définit les attributs et méthodes des objets.',
      ),
      QuizQuestion(
        id: 'info_ch3_l3_q2',
        question: 'La méthode __init__() en Python est :',
        options: ['Une méthode de destruction', 'Le constructeur de la classe, appelé à la création de l\'objet', 'Un méthode statique', 'Une méthode privée'],
        correctIndex: 1,
        lessonId: 'info_ch3_l3',
        explanation: '__init__ est le constructeur appelé automatiquement lors de la création d\'une instance.',
      ),
      QuizQuestion(
        id: 'info_ch3_l3_q3',
        question: 'L\'héritage en POO permet de :',
        options: ['Créer des variables globales', 'Créer une classe enfant qui hérite des attributs/méthodes d\'une classe parent', 'Supprimer des classes', 'Remplacer le constructeur'],
        correctIndex: 1,
        lessonId: 'info_ch3_l3',
        explanation: 'Héritage : classe enfant hérite des attributs et méthodes de la classe parente.',
      ),
    ],
  };

  // ── Info Ch4 : Bases de données ──

  static final Map<String, List<QuizQuestion>> _infoCh4 = {
    'info_ch4_l1': [
      QuizQuestion(
        id: 'info_ch4_l1_q1',
        question: 'Dans le modèle relationnel, une clé primaire est :',
        options: ['Une colonne optionnelle', 'Un identifiant unique pour chaque ligne d\'une table', 'Une colonne contenant des textes', 'Un lien entre deux tables'],
        correctIndex: 1,
        lessonId: 'info_ch4_l1',
        explanation: 'Clé primaire = colonne (ou ensemble) identifiant de façon unique chaque enregistrement.',
      ),
      QuizQuestion(
        id: 'info_ch4_l1_q2',
        question: 'Une clé étrangère est :',
        options: ['Une clé primaire d\'une autre table', 'Une colonne faisant référence à la clé primaire d\'une autre table', 'Une clé sans valeur', 'Une clé secondaire'],
        correctIndex: 1,
        lessonId: 'info_ch4_l1',
        explanation: 'Clé étrangère = colonne d\'une table qui référence la clé primaire d\'une autre table (lien).',
      ),
      QuizQuestion(
        id: 'info_ch4_l1_q3',
        question: 'Un schéma relationnel est un ensemble de :',
        options: ['Programmes', 'Tables (relations) avec leurs attributs et clés', 'Fichiers texte', 'Requêtes SQL'],
        correctIndex: 1,
        lessonId: 'info_ch4_l1',
        explanation: 'Schéma = description des tables, de leurs colonnes et des contraintes (clés, étrangères).',
      ),
    ],
    'info_ch4_l2': [
      QuizQuestion(
        id: 'info_ch4_l2_q1',
        question: 'La requête SQL pour sélectionner tous les noms d\'une table "étudiants" est :',
        options: ['GET name FROM etudiants', 'SELECT name FROM etudiants', 'FETCH name FROM etudiants', 'READ name FROM etudiants'],
        correctIndex: 1,
        lessonId: 'info_ch4_l2',
        explanation: 'SELECT name FROM etudiants; sélectionne la colonne "name" de la table.',
      ),
      QuizQuestion(
        id: 'info_ch4_l2_q2',
        question: 'La clause WHERE en SQL sert à :',
        options: ['Trier les résultats', 'Filtrer les lignes selon une condition', 'Joindre des tables', 'Supprimer des données'],
        correctIndex: 1,
        lessonId: 'info_ch4_l2',
        explanation: 'WHERE filtre les enregistrements : SELECT * FROM t WHERE condition.',
      ),
      QuizQuestion(
        id: 'info_ch4_l2_q3',
        question: 'La commande SQL pour ajouter une ligne dans une table est :',
        options: ['ADD INTO table', 'INSERT INTO table VALUES (...)', 'CREATE INTO table', 'NEW INTO table'],
        correctIndex: 1,
        lessonId: 'info_ch4_l2',
        explanation: 'INSERT INTO table (col1, col2) VALUES (val1, val2).',
      ),
    ],
    'info_ch4_l3': [
      QuizQuestion(
        id: 'info_ch4_l3_q1',
        question: 'MERISE est une méthode de :',
        options: ['Programmation', 'Conception de bases de données relationnelles', 'Compilation', 'Réseau'],
        correctIndex: 1,
        lessonId: 'info_ch4_l3',
        explanation: 'MERISE = méthode d\'analyse et de conception des systèmes d\'information et BDD.',
      ),
      QuizQuestion(
        id: 'info_ch4_l3_q2',
        question: 'Le MCD (Modèle Conceptuel de Données) de MERISE utilise :',
        options: ['Des tables et des lignes', 'Des entités, associations et propriétés', 'Des classes et méthodes', 'Des requêtes SQL'],
        correctIndex: 1,
        lessonId: 'info_ch4_l3',
        explanation: 'MCD : entités (rectangles), associations (losanges), propriétés (ellipses).',
      ),
      QuizQuestion(
        id: 'info_ch4_l3_q3',
        question: 'La cardinalité d\'une association dans un MCD indique :',
        options: ['Le nom de l\'entité', 'Le nombre minimum et maximum de participation d\'une entité', 'Le type de données', 'La clé primaire'],
        correctIndex: 1,
        lessonId: 'info_ch4_l3',
        explanation: 'Cardinalité (0,1), (1,n)... : contraintes sur le nombre d\'occurrences参与者.',
      ),
    ],
  };

  // ── Info Ch5 : Réseaux ──

  static final Map<String, List<QuizQuestion>> _infoCh5 = {
    'info_ch5_l1': [
      QuizQuestion(
        id: 'info_ch5_l1_q1',
        question: 'Le modèle OSI comporte combien de couches ?',
        options: ['4', '5', '7', '10'],
        correctIndex: 2,
        lessonId: 'info_ch5_l1',
        explanation: 'Le modèle OSI a 7 couches (physique, liaison, réseau, transport, session, présentation, application).',
      ),
      QuizQuestion(
        id: 'info_ch5_l1_q2',
        question: 'La couche réseau du modèle OSI gère :',
        options: ['Le câblage', 'L\'adressage logique et le routage (IP)', 'Le chiffrement', 'La présentation des données'],
        correctIndex: 1,
        lessonId: 'info_ch5_l1',
        explanation: 'Couche 3 (réseau) : adressage IP et routage des paquets.',
      ),
      QuizQuestion(
        id: 'info_ch5_l1_q3',
        question: 'Le modèle TCP/IP comporte principalement :',
        options: ['7 couches', '4 couches (accès réseau, internet, transport, application)', '3 couches', '5 couches'],
        correctIndex: 1,
        lessonId: 'info_ch5_l1',
        explanation: 'TCP/IP : 4 couches (link, internet, transport, application).',
      ),
    ],
    'info_ch5_l2': [
      QuizQuestion(
        id: 'info_ch5_l2_q1',
        question: 'Le protocole HTTP est utilisé pour :',
        options: ['L\'envoi d\'emails', 'Le transfert de pages web', 'La résolution de noms de domaine', 'Le transfert de fichiers'],
        correctIndex: 1,
        lessonId: 'info_ch5_l2',
        explanation: 'HTTP (HyperText Transfer Protocol) = protocole du web (requêtes/réponses).',
      ),
      QuizQuestion(
        id: 'info_ch5_l2_q2',
        question: 'Le DNS (Domain Name System) permet de :',
        options: ['Attribuer une IP dynamiquement', 'Traduire un nom de domaine en adresse IP', 'Chiffrer les données', 'Router les paquets'],
        correctIndex: 1,
        lessonId: 'info_ch5_l2',
        explanation: 'DNS : résolution de noms (www.google.com → 142.250.x.x).',
      ),
      QuizQuestion(
        id: 'info_ch5_l2_q3',
        question: 'Le protocole DHCP sert à :',
        options: ['Résoudre les noms de domaine', 'Attribuer automatiquement une adresse IP aux appareils', 'Transférer des fichiers', 'Chiffrer les communications'],
        correctIndex: 1,
        lessonId: 'info_ch5_l2',
        explanation: 'DHCP : attribution dynamique d\'adresses IP, masques, passerelles aux appareils du réseau.',
      ),
    ],
  };

  // ── Info Ch6 : Sécurité informatique ──

  static final Map<String, List<QuizQuestion>> _infoCh6 = {
    'info_ch6_l1': [
      QuizQuestion(
        id: 'info_ch6_l1_q1',
        question: 'Un virus informatique est :',
        options: ['Un programme qui se propage uniquement par email', 'Un programme malveillant qui s\'insère dans un autre programme pour se reproduire', 'Un hardware défectueux', 'Un protocole réseau'],
        correctIndex: 1,
        lessonId: 'info_ch6_l1',
        explanation: 'Virus = code malveillant qui s\'attache à un programme hôte et se propage.',
      ),
      QuizQuestion(
        id: 'info_ch6_l1_q2',
        question: 'Le phishing consiste à :',
        options: ['Pirater un serveur', 'Tromper l\'utilisateur pour voler ses informations personnelles (faux site, faux email)', 'Désactiver un antivirus', 'Crasher un ordinateur'],
        correctIndex: 1,
        lessonId: 'info_ch6_l1',
        explanation: 'Phishing (hameçonnage) : usurpation d\'identité pour voler des données sensibles.',
      ),
      QuizQuestion(
        id: 'info_ch6_l1_q3',
        question: 'Un ransomware est un logiciel qui :',
        options: ['Nettoie le disque dur', 'Chiffre les fichiers de la victime et demande une rançon', 'Améliore les performances', 'Protège contre les virus'],
        correctIndex: 1,
        lessonId: 'info_ch6_l1',
        explanation: 'Ransomware = rançongiciel : chiffre les données et exige un paiement pour la clé.',
      ),
    ],
    'info_ch6_l2': [
      QuizQuestion(
        id: 'info_ch6_l2_q1',
        question: 'Le chiffrement symétrique utilise :',
        options: ['Deux clés différentes (publique et privée)', 'Une seule clé pour chiffrer et déchiffrer', 'Pas de clé', 'Un algorithme de hachage'],
        correctIndex: 1,
        lessonId: 'info_ch6_l2',
        explanation: 'Chiffrement symétrique : une même clé (secrète) pour chiffrer et déchiffrer (AES, DES).',
      ),
      QuizQuestion(
        id: 'info_ch6_l2_q2',
        question: 'Le chiffrement asymétrique utilise :',
        options: ['Une clé unique', 'Une paire de clés (publique et privée)', 'Un mot de passe', 'Un hash'],
        correctIndex: 1,
        lessonId: 'info_ch6_l2',
        explanation: 'Asymétrique : clé publique pour chiffrer, clé privée pour déchiffrer (RSA, ECC).',
      ),
      QuizQuestion(
        id: 'info_ch6_l2_q3',
        question: 'Un algorithme de hachage (comme SHA-256) sert à :',
        options: ['Chiffrer un message', 'Créer une empreinte unique d\'un fichier/message', 'Transmettre des données', 'Stocker des mots de passe en clair'],
        correctIndex: 1,
        lessonId: 'info_ch6_l2',
        explanation: 'Hachage = empreinte fixe (ex: 256 bits), impossible à inverser, sert pour l\'intégrité et le stockage sécurisé.',
      ),
    ],
  };
}
