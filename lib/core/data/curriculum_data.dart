import '../models/curriculum_models.dart';

extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class CurriculumData {
  static final Map<String, List<SubjectCurriculum>> _bySeries = {};
  static bool _loaded = false;

  static void init() {
    if (_loaded) return;
    _loaded = true;

    _bySeries['D'] = [..._bacDSubjects];
    _bySeries['C'] = [..._bacCSubjects];
    _bySeries['A'] = [..._bacASubjects];
    _bySeries['TI'] = [..._bacTISubjects];
  }

  static List<SubjectCurriculum> forSeries(String series) {
    init();
    final key = series.replaceAll('BAC ', '').trim().toUpperCase();
    return _bySeries[key] ?? [];
  }

  static List<String> get availableSeries {
    init();
    return _bySeries.keys.toList();
  }

  static List<SubjectCurriculum> get all {
    init();
    return _bySeries.values.expand((e) => e).toList();
  }

  static SubjectCurriculum? findById(String id) {
    init();
    return all.firstWhereOrNull((s) => s.id == id);
  }

  static CurriculumChapter? findChapterById(String id) {
    init();
    for (final subject in all) {
      for (final chapter in subject.chapters) {
        if (chapter.id == id) return chapter;
      }
    }
    return null;
  }

  static Lesson? findLessonById(String id) {
    init();
    for (final subject in all) {
      for (final chapter in subject.chapters) {
        for (final lesson in chapter.lessons) {
          if (lesson.id == id) return lesson;
        }
      }
    }
    return null;
  }

  // ═══════════════════════════════════════════
  //  BAC D — Sciences Expérimentales
  // ═══════════════════════════════════════════

  static final List<SubjectCurriculum> _bacDSubjects = [
    SubjectCurriculum(
      id: 'maths',
      title: 'Mathématiques',
      emoji: '🔢',
      bacSeries: 'D',
      coefficient: 4,
      examDurationMinutes: 240,
      examQuestionCount: 5,
      chapters: [
        CurriculumChapter(
          id: 'maths_ch1',
          title: 'Nombres complexes',
          subtitle: 'Forme algébrique, trigonométrique, équations',
          order: 1,
          subjectId: 'maths',
          lessons: [
            Lesson(id: 'maths_ch1_l1', title: 'Forme algébrique d\'un nombre complexe', subtitle: 'Partie réelle, partie imaginaire, conjugué', order: 1),
            Lesson(id: 'maths_ch1_l2', title: 'Module et argument', subtitle: 'Forme trigonométrique, notation exponentielle', order: 2),
            Lesson(id: 'maths_ch1_l3', title: 'Équations dans ℂ', subtitle: 'Équations du second degré, racines complexes', order: 3),
            Lesson(id: 'maths_ch1_l4', title: 'Applications géométriques', subtitle: 'Similitudes, rotations, translations', order: 4),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ch2',
          title: 'Limites et continuité',
          subtitle: 'Calcul de limites, continuité, TVI',
          order: 2,
          subjectId: 'maths',
          lessons: [
            Lesson(id: 'maths_ch2_l1', title: 'Limites de fonctions', subtitle: 'Limites finies, infinies, asymptotes', order: 1),
            Lesson(id: 'maths_ch2_l2', title: 'Continuité sur un intervalle', subtitle: 'Fonctions continues, TVI', order: 2),
            Lesson(id: 'maths_ch2_l3', title: 'Fonctions trigonométriques', subtitle: 'Limites usuelles, continuité', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ch3',
          title: 'Dérivation et études de fonctions',
          subtitle: 'Dérivée, variations, extremums',
          order: 3,
          subjectId: 'maths',
          lessons: [
            Lesson(id: 'maths_ch3_l1', title: 'Nombre dérivé et fonction dérivée', subtitle: 'Taux d\'accroissement, dérivées usuelles', order: 1),
            Lesson(id: 'maths_ch3_l2', title: 'Variations et extremums', subtitle: 'Tableau de variation, optimisation', order: 2),
            Lesson(id: 'maths_ch3_l3', title: 'Théorème des accroissements finis', subtitle: 'Formule de Taylor', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ch4',
          title: 'Fonctions logarithmes et exponentielles',
          subtitle: 'Propriétés, équations, inéquations',
          order: 4,
          subjectId: 'maths',
          lessons: [
            Lesson(id: 'maths_ch4_l1', title: 'Fonction logarithme népérien', subtitle: 'Définition, propriétés, représentation', order: 1),
            Lesson(id: 'maths_ch4_l2', title: 'Fonction exponentielle', subtitle: 'Réciproque du ln, propriétés', order: 2),
            Lesson(id: 'maths_ch4_l3', title: 'Croissances comparées', subtitle: 'Limites et variations', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ch5',
          title: 'Suites numériques',
          subtitle: 'Suites arithmétiques, géométriques, récurrentes',
          order: 5,
          subjectId: 'maths',
          lessons: [
            Lesson(id: 'maths_ch5_l1', title: 'Généralités sur les suites', subtitle: 'Monotonie, bornes, convergence', order: 1),
            Lesson(id: 'maths_ch5_l2', title: 'Suites arithmético-géométriques', subtitle: 'Expression du terme général', order: 2),
            Lesson(id: 'maths_ch5_l3', title: 'Suites récurrentes linéaires', subtitle: 'Suite de Fibonacci', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ch6',
          title: 'Calcul intégral',
          subtitle: 'Primitives, intégrales, aires',
          order: 6,
          subjectId: 'maths',
          lessons: [
            Lesson(id: 'maths_ch6_l1', title: 'Primitives d\'une fonction', subtitle: 'Primitives usuelles, linéarité', order: 1),
            Lesson(id: 'maths_ch6_l2', title: 'Intégrale définie', subtitle: 'Propriétés, calcul d\'aires', order: 2),
            Lesson(id: 'maths_ch6_l3', title: 'Intégration par parties', subtitle: 'Méthodes de calcul', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ch7',
          title: 'Équations différentielles',
          subtitle: 'Équations linéaires du 1er et 2nd ordre',
          order: 7,
          subjectId: 'maths',
          lessons: [
            Lesson(id: 'maths_ch7_l1', title: 'Équations du premier ordre', subtitle: 'y\'+ay=0, y\'+ay=b', order: 1),
            Lesson(id: 'maths_ch7_l2', title: 'Équations du second ordre', subtitle: 'y\'\'+ω²y=0', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ch8',
          title: 'Probabilités',
          subtitle: 'Variable aléatoire, loi binomiale, normale',
          order: 8,
          subjectId: 'maths',
          lessons: [
            Lesson(id: 'maths_ch8_l1', title: 'Variable aléatoire discrète', subtitle: 'Loi de probabilité, espérance, variance', order: 1),
            Lesson(id: 'maths_ch8_l2', title: 'Loi binomiale', subtitle: 'Schéma de Bernoulli, formule', order: 2),
            Lesson(id: 'maths_ch8_l3', title: 'Loi normale', subtitle: 'Courbe de Gauss, calculs de probabilités', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ch9',
          title: 'Géométrie dans l\'espace',
          subtitle: 'Vecteurs, droites, plans',
          order: 9,
          subjectId: 'maths',
          lessons: [
            Lesson(id: 'maths_ch9_l1', title: 'Vecteurs de l\'espace', subtitle: 'Combinaisons linéaires, bases', order: 1),
            Lesson(id: 'maths_ch9_l2', title: 'Droites et plans', subtitle: 'Équations paramétriques, intersection', order: 2),
            Lesson(id: 'maths_ch9_l3', title: 'Produit scalaire', subtitle: 'Orthogonalité, distances', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ch10',
          title: 'Arithmétique',
          subtitle: 'Divisibilité, PGCD, congruences',
          order: 10,
          subjectId: 'maths',
          lessons: [
            Lesson(id: 'maths_ch10_l1', title: 'Divisibilité dans ℤ', subtitle: 'Multiples, diviseurs, division euclidienne', order: 1),
            Lesson(id: 'maths_ch10_l2', title: 'PGCD et PPCM', subtitle: 'Algorithme d\'Euclide, nombres premiers', order: 2),
            Lesson(id: 'maths_ch10_l3', title: 'Congruences', subtitle: 'Classes modulo n, équations diophantiennes', order: 3),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'physique',
      title: 'Physique',
      emoji: '⚡',
      bacSeries: 'D',
      coefficient: 4,
      examDurationMinutes: 240,
      examQuestionCount: 5,
      chapters: [
        CurriculumChapter(
          id: 'physique_ch1',
          title: 'Mécanique : Cinématique',
          subtitle: 'Mouvements rectilignes et circulaires',
          order: 1,
          subjectId: 'physique',
          lessons: [
            Lesson(id: 'physique_ch1_l1', title: 'Vecteurs position, vitesse, accélération', subtitle: 'Dérivation vectorielle', order: 1),
            Lesson(id: 'physique_ch1_l2', title: 'Mouvement rectiligne uniforme', subtitle: 'MRU, équations horaires', order: 2),
            Lesson(id: 'physique_ch1_l3', title: 'Mouvement rectiligne uniformément varié', subtitle: 'MRUV, chute libre', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'physique_ch2',
          title: 'Dynamique newtonienne',
          subtitle: 'Lois de Newton, forces',
          order: 2,
          subjectId: 'physique',
          lessons: [
            Lesson(id: 'physique_ch2_l1', title: 'Les trois lois de Newton', subtitle: 'Principe d\'inertie, dynamique, action-réaction', order: 1),
            Lesson(id: 'physique_ch2_l2', title: 'Force gravitationnelle', subtitle: 'Poids, attraction universelle', order: 2),
            Lesson(id: 'physique_ch2_l3', title: 'Travail et énergie', subtitle: 'Énergie cinétique, potentielle, mécanique', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'physique_ch3',
          title: 'Électricité : Courant continu',
          subtitle: 'Lois de Kirchhoff, dipôles',
          order: 3,
          subjectId: 'physique',
          lessons: [
            Lesson(id: 'physique_ch3_l1', title: 'Loi d\'Ohm et résistance', subtitle: 'Caractéristique d\'un dipôle', order: 1),
            Lesson(id: 'physique_ch3_l2', title: 'Lois des mailles et des nœuds', subtitle: 'Analyse de circuits', order: 2),
            Lesson(id: 'physique_ch3_l3', title: 'Pont de Wheatstone', subtitle: 'Mesure de résistance', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'physique_ch4',
          title: 'Électrocinétique : Régimes transitoires',
          subtitle: 'Circuit RC, RL, RLC',
          order: 4,
          subjectId: 'physique',
          lessons: [
            Lesson(id: 'physique_ch4_l1', title: 'Charge et décharge d\'un condensateur', subtitle: 'Circuit RC, constante de temps', order: 1),
            Lesson(id: 'physique_ch4_l2', title: 'Bobine et circuit RL', subtitle: 'Établissement du courant', order: 2),
            Lesson(id: 'physique_ch4_l3', title: 'Oscillations électriques RLC', subtitle: 'Régime libre, amortissement', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'physique_ch5',
          title: 'Ondes mécaniques',
          subtitle: 'Ondes progressives, sonores',
          order: 5,
          subjectId: 'physique',
          lessons: [
            Lesson(id: 'physique_ch5_l1', title: 'Ondes progressives périodiques', subtitle: 'Célérité, longueur d\'onde', order: 1),
            Lesson(id: 'physique_ch5_l2', title: 'Ondes sonores', subtitle: 'Intensité, effet Doppler', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'physique_ch6',
          title: 'Physique nucléaire',
          subtitle: 'Radioactivité, fission, fusion',
          order: 6,
          subjectId: 'physique',
          lessons: [
            Lesson(id: 'physique_ch6_l1', title: 'Noyau atomique et radioactivité', subtitle: 'Types de désintégration, loi de décroissance', order: 1),
            Lesson(id: 'physique_ch6_l2', title: 'Fission et fusion nucléaire', subtitle: 'Énergie nucléaire, applications', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'physique_ch7',
          title: 'Optique géométrique',
          subtitle: 'Lentilles, miroirs, instruments',
          order: 7,
          subjectId: 'physique',
          lessons: [
            Lesson(id: 'physique_ch7_l1', title: 'Lentilles minces', subtitle: 'Convergentes, divergentes, relations de conjugaison', order: 1),
            Lesson(id: 'physique_ch7_l2', title: 'Instruments d\'optique', subtitle: 'Loupe, microscope, lunette', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'physique_ch8',
          title: 'Magnétisme',
          subtitle: 'Champ magnétique, induction',
          order: 8,
          subjectId: 'physique',
          lessons: [
            Lesson(id: 'physique_ch8_l1', title: 'Champ magnétique', subtitle: 'Sources, lignes de champ', order: 1),
            Lesson(id: 'physique_ch8_l2', title: 'Induction électromagnétique', subtitle: 'Loi de Faraday, auto-induction', order: 2),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'chimie',
      title: 'Chimie',
      emoji: '🧪',
      bacSeries: 'D',
      coefficient: 2,
      examDurationMinutes: 180,
      examQuestionCount: 4,
      chapters: [
        CurriculumChapter(
          id: 'chimie_ch1',
          title: 'Acides et bases',
          subtitle: 'pH, pKa, indicateurs',
          order: 1,
          subjectId: 'chimie',
          lessons: [
            Lesson(id: 'chimie_ch1_l1', title: 'Définition selon Brönsted', subtitle: 'Couple acide-base, réaction acido-basique', order: 1),
            Lesson(id: 'chimie_ch1_l2', title: 'pH et pKa', subtitle: 'Échelle de pH, force des acides', order: 2),
            Lesson(id: 'chimie_ch1_l3', title: 'Dosages acido-basiques', subtitle: 'Méthodes, courbe de titrage', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'chimie_ch2',
          title: 'Oxydoréduction',
          subtitle: 'Piles, électrolyse',
          order: 2,
          subjectId: 'chimie',
          lessons: [
            Lesson(id: 'chimie_ch2_l1', title: 'Nombre d\'oxydation et réactions redox', subtitle: 'Demi-équations, équilibrage', order: 1),
            Lesson(id: 'chimie_ch2_l2', title: 'Piles électrochimiques', subtitle: 'Force électromotrice, potentiel standard', order: 2),
            Lesson(id: 'chimie_ch2_l3', title: 'Électrolyse', subtitle: 'Applications industrielles', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'chimie_ch3',
          title: 'Chimie organique',
          subtitle: 'Fonctions, réactions, mécanismes',
          order: 3,
          subjectId: 'chimie',
          lessons: [
            Lesson(id: 'chimie_ch3_l1', title: 'Alcanes, alcènes, alcynes', subtitle: 'Nomenclature, isomérie', order: 1),
            Lesson(id: 'chimie_ch3_l2', title: 'Fonctions oxygénées', subtitle: 'Alcools, aldéhydes, cétones, acides', order: 2),
            Lesson(id: 'chimie_ch3_l3', title: 'Réactions en chimie organique', subtitle: 'Substitution, addition, élimination', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'chimie_ch4',
          title: 'Cinétique chimique',
          subtitle: 'Vitesse de réaction, catalyse',
          order: 4,
          subjectId: 'chimie',
          lessons: [
            Lesson(id: 'chimie_ch4_l1', title: 'Vitesse de réaction', subtitle: 'Facteurs cinétiques, loi de vitesse', order: 1),
            Lesson(id: 'chimie_ch4_l2', title: 'Catalyse', subtitle: 'Catalyseur, types de catalyse', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'chimie_ch5',
          title: 'Thermodynamique chimique',
          subtitle: 'Enthalpie, entropie, équilibre',
          order: 5,
          subjectId: 'chimie',
          lessons: [
            Lesson(id: 'chimie_ch5_l1', title: 'Enthalpie de réaction', subtitle: 'Loi de Hess, calorimétrie', order: 1),
            Lesson(id: 'chimie_ch5_l2', title: 'Équilibre chimique', subtitle: 'Loi d\'action de masse, constante d\'équilibre', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'chimie_ch6',
          title: 'Chimie des solutions',
          subtitle: 'Solubilité, précipitation',
          order: 6,
          subjectId: 'chimie',
          lessons: [
            Lesson(id: 'chimie_ch6_l1', title: 'Solubilité et produit de solubilité', subtitle: 'Ks, critère de précipitation', order: 1),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'svt',
      title: 'SVTEEHB',
      emoji: '🌿',
      bacSeries: 'D',
      coefficient: 4,
      examDurationMinutes: 240,
      examQuestionCount: 5,
      chapters: [
        CurriculumChapter(
          id: 'svt_ch1',
          title: 'Génétique',
          subtitle: 'ADN, chromosomes, hérédité',
          order: 1,
          subjectId: 'svt',
          lessons: [
            Lesson(id: 'svt_ch1_l1', title: 'Structure de l\'ADN', subtitle: 'Double hélice, réplication', order: 1),
            Lesson(id: 'svt_ch1_l2', title: 'Transcription et traduction', subtitle: 'ARN, synthèse des protéines', order: 2),
            Lesson(id: 'svt_ch1_l3', title: 'Mutations et brassage génétique', subtitle: 'Méiose, crossing-over', order: 3),
            Lesson(id: 'svt_ch1_l4', title: 'Hérédité humaine', subtitle: 'Maladies génétiques, arbres généalogiques', order: 4),
          ],
        ),
        CurriculumChapter(
          id: 'svt_ch2',
          title: 'Immunologie',
          subtitle: 'Système immunitaire, défenses',
          order: 2,
          subjectId: 'svt',
          lessons: [
            Lesson(id: 'svt_ch2_l1', title: 'Immunité innée', subtitle: 'Barrières naturelles, phagocytose', order: 1),
            Lesson(id: 'svt_ch2_l2', title: 'Immunité adaptative', subtitle: 'Lymphocytes, anticorps, mémoire', order: 2),
            Lesson(id: 'svt_ch2_l3', title: 'Vaccination et sérothérapie', subtitle: 'Principes, applications', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'svt_ch3',
          title: 'Écologie',
          subtitle: 'Écosystèmes, chaînes alimentaires',
          order: 3,
          subjectId: 'svt',
          lessons: [
            Lesson(id: 'svt_ch3_l1', title: 'Structure des écosystèmes', subtitle: 'Facteurs biotiques et abiotiques', order: 1),
            Lesson(id: 'svt_ch3_l2', title: 'Flux d\'énergie et cycles de la matière', subtitle: 'Photosynthèse, respiration', order: 2),
            Lesson(id: 'svt_ch3_l3', title: 'Dynamique des populations', subtitle: 'Croissance, régulation', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'svt_ch4',
          title: 'Géologie',
          subtitle: 'Structure terrestre, tectonique',
          order: 4,
          subjectId: 'svt',
          lessons: [
            Lesson(id: 'svt_ch4_l1', title: 'Structure interne de la Terre', subtitle: 'Croûte, manteau, noyau', order: 1),
            Lesson(id: 'svt_ch4_l2', title: 'Tectonique des plaques', subtitle: 'Divergence, convergence, subduction', order: 2),
            Lesson(id: 'svt_ch4_l3', title: 'Roches et minéraux', subtitle: 'Classification, cycle des roches', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'svt_ch5',
          title: 'Biologie cellulaire',
          subtitle: 'Cellule, organites, respiration',
          order: 5,
          subjectId: 'svt',
          lessons: [
            Lesson(id: 'svt_ch5_l1', title: 'Organisation de la cellule', subtitle: 'Membrane, noyau, organites', order: 1),
            Lesson(id: 'svt_ch5_l2', title: 'Respiration cellulaire', subtitle: 'Glycolyse, cycle de Krebs', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'svt_ch6',
          title: 'Reproduction',
          subtitle: 'Reproduction humaine, régulations',
          order: 6,
          subjectId: 'svt',
          lessons: [
            Lesson(id: 'svt_ch6_l1', title: 'Appareil reproducteur', subtitle: 'Anatomie, gamétogenèse', order: 1),
            Lesson(id: 'svt_ch6_l2', title: 'Régulation hormonale', subtitle: 'Cycle menstruel, ovulation', order: 2),
            Lesson(id: 'svt_ch6_l3', title: 'Fécondation et développement', subtitle: 'Embryogenèse, nidation', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'svt_ch7',
          title: 'Neurobiologie',
          subtitle: 'Système nerveux, transmission synaptique',
          order: 7,
          subjectId: 'svt',
          lessons: [
            Lesson(id: 'svt_ch7_l1', title: 'Neurone et influx nerveux', subtitle: 'Potentiel de repos, d\'action', order: 1),
            Lesson(id: 'svt_ch7_l2', title: 'Synapse et neurotransmetteurs', subtitle: 'Transmission chimique', order: 2),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'info',
      title: 'Informatique',
      emoji: '💻',
      bacSeries: 'D',
      coefficient: 2,
      examDurationMinutes: 180,
      examQuestionCount: 4,
      chapters: [
        CurriculumChapter(
          id: 'info_ch1',
          title: 'Algorithmique fondamentale',
          subtitle: 'Variables, structures, fonctions',
          order: 1,
          subjectId: 'info',
          lessons: [
            Lesson(id: 'info_ch1_l1', title: 'Introduction à l\'algorithmique', subtitle: 'Définition, organigramme, pseudo-code', order: 1),
            Lesson(id: 'info_ch1_l2', title: 'Structures de contrôle', subtitle: 'Conditionnelles, boucles', order: 2),
            Lesson(id: 'info_ch1_l3', title: 'Fonctions et procédures', subtitle: 'Paramètres, récursivité', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'info_ch2',
          title: 'Structures de données',
          subtitle: 'Tableaux, listes, piles, files',
          order: 2,
          subjectId: 'info',
          lessons: [
            Lesson(id: 'info_ch2_l1', title: 'Tableaux et listes', subtitle: 'Opérations, parcours', order: 1),
            Lesson(id: 'info_ch2_l2', title: 'Piles et files', subtitle: 'LIFO, FIFO, implémentation', order: 2),
            Lesson(id: 'info_ch2_l3', title: 'Arbres et graphes', subtitle: 'Parcours, arbres binaires', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'info_ch3',
          title: 'Programmation Python',
          subtitle: 'Syntaxe, modules, projets',
          order: 3,
          subjectId: 'info',
          lessons: [
            Lesson(id: 'info_ch3_l1', title: 'Bases de Python', subtitle: 'Variables, types, entrées/sorties', order: 1),
            Lesson(id: 'info_ch3_l2', title: 'Fonctions et modules', subtitle: 'Bibliothèque standard, import', order: 2),
            Lesson(id: 'info_ch3_l3', title: 'Programmation orientée objet', subtitle: 'Classes, héritage', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'info_ch4',
          title: 'Bases de données',
          subtitle: 'SQL, requêtes, conception',
          order: 4,
          subjectId: 'info',
          lessons: [
            Lesson(id: 'info_ch4_l1', title: 'Modèle relationnel', subtitle: 'Tables, clés primaires/étrangères', order: 1),
            Lesson(id: 'info_ch4_l2', title: 'Requêtes SQL', subtitle: 'SELECT, INSERT, UPDATE, DELETE', order: 2),
            Lesson(id: 'info_ch4_l3', title: 'Conception de bases de données', subtitle: 'MERISE, MLD/MPD', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'info_ch5',
          title: 'Réseaux et Internet',
          subtitle: 'Protocoles, IP, routage',
          order: 5,
          subjectId: 'info',
          lessons: [
            Lesson(id: 'info_ch5_l1', title: 'Architecture des réseaux', subtitle: 'Modèle OSI, TCP/IP', order: 1),
            Lesson(id: 'info_ch5_l2', title: 'Protocoles et services', subtitle: 'HTTP, DNS, DHCP', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'info_ch6',
          title: 'Sécurité informatique',
          subtitle: 'Cryptographie, cyber sécurité',
          order: 6,
          subjectId: 'info',
          lessons: [
            Lesson(id: 'info_ch6_l1', title: 'Menaces et vulnérabilités', subtitle: 'Virus, phishing, attaques', order: 1),
            Lesson(id: 'info_ch6_l2', title: 'Cryptographie', subtitle: 'Chiffrement symétrique/asymétrique', order: 2),
          ],
        ),
      ],
    ),
  ];

  // ═══════════════════════════════════════════
  //  BAC C — Mathématiques et Sciences Physiques
  // ═══════════════════════════════════════════

  static final List<SubjectCurriculum> _bacCSubjects = [
    SubjectCurriculum(
      id: 'maths_c',
      title: 'Mathématiques',
      emoji: '🔢',
      bacSeries: 'C',
      coefficient: 5,
      examDurationMinutes: 300,
      examQuestionCount: 7,
      chapters: [
        CurriculumChapter(
          id: 'maths_c_ch1',
          title: 'Nombres complexes',
          subtitle: 'Formes algébrique, trigonométrique, exponentielle',
          order: 1,
          subjectId: 'maths_c',
          lessons: [
            Lesson(id: 'maths_c_ch1_l1', title: 'Forme algébrique et conjugué', subtitle: 'Partie réelle, imaginaire, opérations', order: 1),
            Lesson(id: 'maths_c_ch1_l2', title: 'Module, argument et forme exponentielle', subtitle: 'Notation e^{iθ}, applications', order: 2),
            Lesson(id: 'maths_c_ch1_l3', title: 'Équations complexes', subtitle: 'Second degré, racines n-ièmes', order: 3),
            Lesson(id: 'maths_c_ch1_l4', title: 'Transformations du plan', subtitle: 'Rotation, similitude, homothétie', order: 4),
          ],
        ),
        CurriculumChapter(
          id: 'maths_c_ch2',
          title: 'Limites et continuité',
          subtitle: 'Calculs, TVI, fonctions trigonométriques',
          order: 2,
          subjectId: 'maths_c',
          lessons: [
            Lesson(id: 'maths_c_ch2_l1', title: 'Limites de fonctions', subtitle: 'Limites finies, infinies, asymptotes', order: 1),
            Lesson(id: 'maths_c_ch2_l2', title: 'Continuité et TVI', subtitle: 'Fonctions continues, théorème des valeurs intermédiaires', order: 2),
            Lesson(id: 'maths_c_ch2_l3', title: 'Branches infinies', subtitle: 'Asymptotes obliques, courbes paramétrées', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_c_ch3',
          title: 'Dérivation et études',
          subtitle: 'Dérivée, variations, bijections',
          order: 3,
          subjectId: 'maths_c',
          lessons: [
            Lesson(id: 'maths_c_ch3_l1', title: 'Dérivée et différentielle', subtitle: 'Taux d\'accroissement, formules', order: 1),
            Lesson(id: 'maths_c_ch3_l2', title: 'Variations et extremums', subtitle: 'Tableaux de variation, optimisation', order: 2),
            Lesson(id: 'maths_c_ch3_l3', title: 'Bijections et fonctions réciproques', subtitle: 'Théorème de la bijection, Arcsin, Arccos', order: 3),
            Lesson(id: 'maths_c_ch3_l4', title: 'Théorème des accroissements finis', subtitle: 'Formule de Taylor, applications', order: 4),
          ],
        ),
        CurriculumChapter(
          id: 'maths_c_ch4',
          title: 'Fonctions logarithmes et exponentielles',
          subtitle: 'Propriétés, équations, limites',
          order: 4,
          subjectId: 'maths_c',
          lessons: [
            Lesson(id: 'maths_c_ch4_l1', title: 'Logarithme népérien', subtitle: 'Définition, propriétés, représentation', order: 1),
            Lesson(id: 'maths_c_ch4_l2', title: 'Exponentielle réciproque', subtitle: 'Fonction exp, propriétés', order: 2),
            Lesson(id: 'maths_c_ch4_l3', title: 'Croissances comparées', subtitle: 'Limites fondamentales', order: 3),
            Lesson(id: 'maths_c_ch4_l4', title: 'Logarithme décimal', subtitle: 'Définition, applications en sciences', order: 4),
          ],
        ),
        CurriculumChapter(
          id: 'maths_c_ch5',
          title: 'Suites numériques',
          subtitle: 'Suites récurrentes, convergence',
          order: 5,
          subjectId: 'maths_c',
          lessons: [
            Lesson(id: 'maths_c_ch5_l1', title: 'Généralités et convergence', subtitle: 'Monotonie, bornes, théorèmes de convergence', order: 1),
            Lesson(id: 'maths_c_ch5_l2', title: 'Suites récurrentes', subtitle: 'u_{n+1}=f(u_n), points fixes', order: 2),
            Lesson(id: 'maths_c_ch5_l3', title: 'Suites arithmético-géométriques', subtitle: 'Expression explicite, limite', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_c_ch6',
          title: 'Calcul intégral',
          subtitle: 'Primitives, intégrales, aires',
          order: 6,
          subjectId: 'maths_c',
          lessons: [
            Lesson(id: 'maths_c_ch6_l1', title: 'Primitives', subtitle: 'Primitives usuelles, linéarité', order: 1),
            Lesson(id: 'maths_c_ch6_l2', title: 'Intégrale de Riemann', subtitle: 'Propriétés, somme de Riemann', order: 2),
            Lesson(id: 'maths_c_ch6_l3', title: 'Techniques d\'intégration', subtitle: 'IPP, changement de variable', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_c_ch7',
          title: 'Équations différentielles',
          subtitle: '1er et 2nd ordre, systèmes',
          order: 7,
          subjectId: 'maths_c',
          lessons: [
            Lesson(id: 'maths_c_ch7_l1', title: 'Équations linéaires du 1er ordre', subtitle: 'y\'+ay=0, y\'+ay=b(x)', order: 1),
            Lesson(id: 'maths_c_ch7_l2', title: 'Équations du 2nd ordre', subtitle: 'y\'\'+ω²y=0, avec second membre', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'maths_c_ch8',
          title: 'Probabilités',
          subtitle: 'Variables aléatoires, lois',
          order: 8,
          subjectId: 'maths_c',
          lessons: [
            Lesson(id: 'maths_c_ch8_l1', title: 'Probabilités conditionnelles', subtitle: 'Formule de Bayes, indépendance', order: 1),
            Lesson(id: 'maths_c_ch8_l2', title: 'Variable aléatoire discrète', subtitle: 'Loi, espérance, variance', order: 2),
            Lesson(id: 'maths_c_ch8_l3', title: 'Lois binomiale et normale', subtitle: 'Approximation, théorème de Moivre-Laplace', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_c_ch9',
          title: 'Géométrie vectorielle',
          subtitle: 'Vecteurs, droites, plans de l\'espace',
          order: 9,
          subjectId: 'maths_c',
          lessons: [
            Lesson(id: 'maths_c_ch9_l1', title: 'Vecteurs dans l\'espace', subtitle: 'Combinaisons linéaires, produit scalaire', order: 1),
            Lesson(id: 'maths_c_ch9_l2', title: 'Droites et plans', subtitle: 'Équations paramétriques, intersection', order: 2),
            Lesson(id: 'maths_c_ch9_l3', title: 'Produit vectoriel et mixte', subtitle: 'Déterminant, volume', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_c_ch10',
          title: 'Arithmétique',
          subtitle: 'Divisibilité, PGCD, congruences',
          order: 10,
          subjectId: 'maths_c',
          lessons: [
            Lesson(id: 'maths_c_ch10_l1', title: 'Divisibilité dans ℤ', subtitle: 'Division euclidienne, nombres premiers', order: 1),
            Lesson(id: 'maths_c_ch10_l2', title: 'PGCD et PPCM', subtitle: 'Algorithme d\'Euclide, Bézout', order: 2),
            Lesson(id: 'maths_c_ch10_l3', title: 'Congruences', subtitle: 'Classes modulo n, équations diophantiennes', order: 3),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'physique_c',
      title: 'Physique',
      emoji: '⚡',
      bacSeries: 'C',
      coefficient: 5,
      examDurationMinutes: 300,
      examQuestionCount: 7,
      chapters: [
        CurriculumChapter(
          id: 'physique_c_ch1',
          title: 'Cinématique',
          subtitle: 'Mouvements rectilignes, circulaires, paraboliques',
          order: 1,
          subjectId: 'physique_c',
          lessons: [
            Lesson(id: 'physique_c_ch1_l1', title: 'Vecteurs cinématiques', subtitle: 'Position, vitesse, accélération', order: 1),
            Lesson(id: 'physique_c_ch1_l2', title: 'Mouvements rectilignes', subtitle: 'MRU, MRUV, chute libre', order: 2),
            Lesson(id: 'physique_c_ch1_l3', title: 'Mouvement circulaire uniforme', subtitle: 'Accélération centripète, période', order: 3),
            Lesson(id: 'physique_c_ch1_l4', title: 'Mouvement parabolique', subtitle: 'Composition des vitesses', order: 4),
          ],
        ),
        CurriculumChapter(
          id: 'physique_c_ch2',
          title: 'Dynamique et énergie',
          subtitle: 'Lois de Newton, travail, énergie',
          order: 2,
          subjectId: 'physique_c',
          lessons: [
            Lesson(id: 'physique_c_ch2_l1', title: 'Les trois lois de Newton', subtitle: 'Inertie, dynamique, action-réaction', order: 1),
            Lesson(id: 'physique_c_ch2_l2', title: 'Travail et puissance', subtitle: 'Travail d\'une force, puissance', order: 2),
            Lesson(id: 'physique_c_ch2_l3', title: 'Énergies cinétique et potentielle', subtitle: 'Théorème de l\'énergie cinétique', order: 3),
            Lesson(id: 'physique_c_ch2_l4', title: 'Énergie mécanique', subtitle: 'Conservation, forces non conservatives', order: 4),
          ],
        ),
        CurriculumChapter(
          id: 'physique_c_ch3',
          title: 'Oscillations mécaniques',
          subtitle: ' Pendule, ressort, oscillateur harmonique',
          order: 3,
          subjectId: 'physique_c',
          lessons: [
            Lesson(id: 'physique_c_ch3_l1', title: 'Oscillateur harmonique', subtitle: 'Équation différentielle, solution', order: 1),
            Lesson(id: 'physique_c_ch3_l2', title: 'Pendule simple', subtitle: 'Période, isochronisme', order: 2),
            Lesson(id: 'physique_c_ch3_l3', title: 'Oscillations amorties', subtitle: 'Amortissement, régime critique', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'physique_c_ch4',
          title: 'Électricité : Courant continu',
          subtitle: 'Lois de Kirchhoff, dipôles',
          order: 4,
          subjectId: 'physique_c',
          lessons: [
            Lesson(id: 'physique_c_ch4_l1', title: 'Loi d\'Ohm et associations', subtitle: 'Résistances série/parallèle', order: 1),
            Lesson(id: 'physique_c_ch4_l2', title: 'Lois des mailles et nœuds', subtitle: 'Analyse de circuits complexes', order: 2),
            Lesson(id: 'physique_c_ch4_l3', title: 'Générateurs et récepteurs', subtitle: 'Force électromotrice, rendement', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'physique_c_ch5',
          title: 'Régimes transitoires',
          subtitle: 'Circuit RC, RL, RLC',
          order: 5,
          subjectId: 'physique_c',
          lessons: [
            Lesson(id: 'physique_c_ch5_l1', title: 'Circuit RC', subtitle: 'Charge/décharge, constante de temps', order: 1),
            Lesson(id: 'physique_c_ch5_l2', title: 'Circuit RL', subtitle: 'Établissement et rupture du courant', order: 2),
            Lesson(id: 'physique_c_ch5_l3', title: 'Circuit RLC série', subtitle: 'Régime libre, oscillations amorties', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'physique_c_ch6',
          title: 'Ondes mécaniques',
          subtitle: 'Ondes progressives, sonores, effet Doppler',
          order: 6,
          subjectId: 'physique_c',
          lessons: [
            Lesson(id: 'physique_c_ch6_l1', title: 'Ondes progressives', subtitle: 'Périodiques, célérité, longueur d\'onde', order: 1),
            Lesson(id: 'physique_c_ch6_l2', title: 'Ondes sonores', subtitle: 'Intensité, niveau sonore', order: 2),
            Lesson(id: 'physique_c_ch6_l3', title: 'Effet Doppler', subtitle: 'Formule, applications', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'physique_c_ch7',
          title: 'Optique',
          subtitle: 'Lentilles, miroirs, diffraction',
          order: 7,
          subjectId: 'physique_c',
          lessons: [
            Lesson(id: 'physique_c_ch7_l1', title: 'Lentilles minces', subtitle: 'Convergentes, divergentes, formule de Descartes', order: 1),
            Lesson(id: 'physique_c_ch7_l2', title: 'Miroirs sphériques', subtitle: 'Foyers, construction d\'images', order: 2),
            Lesson(id: 'physique_c_ch7_l3', title: 'Diffraction et interférences', subtitle: 'Fentes d\'Young, réseau', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'physique_c_ch8',
          title: 'Physique nucléaire',
          subtitle: 'Radioactivité, fission, fusion',
          order: 8,
          subjectId: 'physique_c',
          lessons: [
            Lesson(id: 'physique_c_ch8_l1', title: 'Radioactivité', subtitle: 'Types, loi de décroissance, période', order: 1),
            Lesson(id: 'physique_c_ch8_l2', title: 'Réactions nucléaires', subtitle: 'Fission, fusion, énergie', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'physique_c_ch9',
          title: 'Magnétisme',
          subtitle: 'Champ magnétique, induction',
          order: 9,
          subjectId: 'physique_c',
          lessons: [
            Lesson(id: 'physique_c_ch9_l1', title: 'Champ magnétique', subtitle: 'Sources, lignes, spectres', order: 1),
            Lesson(id: 'physique_c_ch9_l2', title: 'Induction électromagnétique', subtitle: 'Loi de Faraday, auto-induction', order: 2),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'chimie_c',
      title: 'Chimie',
      emoji: '🧪',
      bacSeries: 'C',
      coefficient: 3,
      examDurationMinutes: 180,
      examQuestionCount: 4,
      chapters: [
        CurriculumChapter(
          id: 'chimie_c_ch1',
          title: 'Acides et bases',
          subtitle: 'pH, pKa, dosages',
          order: 1,
          subjectId: 'chimie_c',
          lessons: [
            Lesson(id: 'chimie_c_ch1_l1', title: 'Couple acide-base', subtitle: 'Brönsted, réactions', order: 1),
            Lesson(id: 'chimie_c_ch1_l2', title: 'pH et pKa', subtitle: 'Échelle, force des acides', order: 2),
            Lesson(id: 'chimie_c_ch1_l3', title: 'Dosages acido-basiques', subtitle: 'Titrage, indicateurs, courbe', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'chimie_c_ch2',
          title: 'Oxydoréduction',
          subtitle: 'Piles, potentiels, électrolyse',
          order: 2,
          subjectId: 'chimie_c',
          lessons: [
            Lesson(id: 'chimie_c_ch2_l1', title: 'Réactions redox', subtitle: 'Nombre d\'oxydation, équilibrage', order: 1),
            Lesson(id: 'chimie_c_ch2_l2', title: 'Piles et potentiels', subtitle: 'FEM, pile Daniell, Nernst', order: 2),
            Lesson(id: 'chimie_c_ch2_l3', title: 'Électrolyse', subtitle: 'Applications industrielles', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'chimie_c_ch3',
          title: 'Chimie organique',
          subtitle: 'Fonctions, mécanismes réactionnels',
          order: 3,
          subjectId: 'chimie_c',
          lessons: [
            Lesson(id: 'chimie_c_ch3_l1', title: 'Hydrocarbures', subtitle: 'Alcanes, alcènes, alcynes', order: 1),
            Lesson(id: 'chimie_c_ch3_l2', title: 'Fonctions oxygénées', subtitle: 'Alcools, aldéhydes, acides', order: 2),
            Lesson(id: 'chimie_c_ch3_l3', title: 'Mécanismes réactionnels', subtitle: 'Substitution, addition, élimination', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'chimie_c_ch4',
          title: 'Cinétique et équilibre',
          subtitle: 'Vitesse, catalyse, constante d\'équilibre',
          order: 4,
          subjectId: 'chimie_c',
          lessons: [
            Lesson(id: 'chimie_c_ch4_l1', title: 'Cinétique chimique', subtitle: 'Facteurs, loi de vitesse', order: 1),
            Lesson(id: 'chimie_c_ch4_l2', title: 'Équilibre chimique', subtitle: 'Loi d\'action de masse, Kc', order: 2),
            Lesson(id: 'chimie_c_ch4_l3', title: 'Thermodynamique', subtitle: 'Enthalpie, entropie', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'chimie_c_ch5',
          title: 'Solutions et solubilité',
          subtitle: 'Ks, précipitation',
          order: 5,
          subjectId: 'chimie_c',
          lessons: [
            Lesson(id: 'chimie_c_ch5_l1', title: 'Solubilité', subtitle: 'Produit de solubilité, critère', order: 1),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'svt_c',
      title: 'SVTEEHB',
      emoji: '🌿',
      bacSeries: 'C',
      coefficient: 2,
      examDurationMinutes: 120,
      examQuestionCount: 3,
      chapters: [
        CurriculumChapter(
          id: 'svt_c_ch1',
          title: 'Génétique',
          subtitle: 'ADN, gènes, hérédité',
          order: 1,
          subjectId: 'svt_c',
          lessons: [
            Lesson(id: 'svt_c_ch1_l1', title: 'Structure et réplication ADN', subtitle: 'Double hélice, réplication', order: 1),
            Lesson(id: 'svt_c_ch1_l2', title: 'Transcription et traduction', subtitle: 'ARN, code génétique', order: 2),
            Lesson(id: 'svt_c_ch1_l3', title: 'Hérédité', subtitle: 'Lois de Mendel, arbres', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'svt_c_ch2',
          title: 'Immunologie',
          subtitle: 'Système immunitaire',
          order: 2,
          subjectId: 'svt_c',
          lessons: [
            Lesson(id: 'svt_c_ch2_l1', title: 'Immunité innée et adaptative', subtitle: 'Barrières, phagocytose, lymphocytes', order: 1),
            Lesson(id: 'svt_c_ch2_l2', title: 'Vaccination', subtitle: 'Principes, types de vaccins', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'svt_c_ch3',
          title: 'Écologie',
          subtitle: 'Écosystèmes, cycles',
          order: 3,
          subjectId: 'svt_c',
          lessons: [
            Lesson(id: 'svt_c_ch3_l1', title: 'Structure des écosystèmes', subtitle: 'Facteurs biotiques/abiotiques', order: 1),
            Lesson(id: 'svt_c_ch3_l2', title: 'Flux d\'énergie', subtitle: 'Photosynthèse, chaînes', order: 2),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'info_c',
      title: 'Informatique',
      emoji: '💻',
      bacSeries: 'C',
      coefficient: 2,
      examDurationMinutes: 180,
      examQuestionCount: 4,
      chapters: [
        CurriculumChapter(
          id: 'info_c_ch1',
          title: 'Algorithmique',
          subtitle: 'Structures, fonctions, récursivité',
          order: 1,
          subjectId: 'info_c',
          lessons: [
            Lesson(id: 'info_c_ch1_l1', title: 'Introduction à l\'algorithmique', subtitle: 'Définitions, organigrammes', order: 1),
            Lesson(id: 'info_c_ch1_l2', title: 'Structures de contrôle', subtitle: 'Conditionnelles, boucles', order: 2),
            Lesson(id: 'info_c_ch1_l3', title: 'Fonctions récursives', subtitle: 'Récursivité, complexité', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'info_c_ch2',
          title: 'Structures de données',
          subtitle: 'Tableaux, listes, piles',
          order: 2,
          subjectId: 'info_c',
          lessons: [
            Lesson(id: 'info_c_ch2_l1', title: 'Tableaux et listes chaînées', subtitle: 'Opérations, parcours', order: 1),
            Lesson(id: 'info_c_ch2_l2', title: 'Piles et files', subtitle: 'LIFO, FIFO', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'info_c_ch3',
          title: 'Programmation Python',
          subtitle: 'Bases, modules, POO',
          order: 3,
          subjectId: 'info_c',
          lessons: [
            Lesson(id: 'info_c_ch3_l1', title: 'Syntaxe Python', subtitle: 'Variables, boucles, entrées/sorties', order: 1),
            Lesson(id: 'info_c_ch3_l2', title: 'Fonctions et modules', subtitle: 'Import, bibliothèques', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'info_c_ch4',
          title: 'Bases de données',
          subtitle: 'SQL, MERISE',
          order: 4,
          subjectId: 'info_c',
          lessons: [
            Lesson(id: 'info_c_ch4_l1', title: 'Modèle relationnel', subtitle: 'Tables, clés', order: 1),
            Lesson(id: 'info_c_ch4_l2', title: 'Requêtes SQL', subtitle: 'SELECT, jointures', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'info_c_ch5',
          title: 'Réseaux',
          subtitle: 'Modèle OSI, TCP/IP',
          order: 5,
          subjectId: 'info_c',
          lessons: [
            Lesson(id: 'info_c_ch5_l1', title: 'Architecture réseau', subtitle: 'OSI, TCP/IP', order: 1),
            Lesson(id: 'info_c_ch5_l2', title: 'Protocoles', subtitle: 'HTTP, DNS', order: 2),
          ],
        ),
      ],
    ),
  ];

  // ═══════════════════════════════════════════
  //  BAC A — Littéraire
  // ═══════════════════════════════════════════

  static final List<SubjectCurriculum> _bacASubjects = [
    SubjectCurriculum(
      id: 'francais_a',
      title: 'Français',
      emoji: '📖',
      bacSeries: 'A',
      coefficient: 5,
      examDurationMinutes: 240,
      examQuestionCount: 3,
      chapters: [
        CurriculumChapter(
          id: 'francais_a_ch1',
          title: 'Littérature française',
          subtitle: 'Mouvements littéraires, auteurs',
          order: 1,
          subjectId: 'francais_a',
          lessons: [
            Lesson(id: 'francais_a_ch1_l1', title: 'Le classicisme', subtitle: 'XVIIe siècle, Corneille, Racine, Molière', order: 1),
            Lesson(id: 'francais_a_ch1_l2', title: 'Le romantisme', subtitle: 'XIXe siècle, Hugo, Lamartine', order: 2),
            Lesson(id: 'francais_a_ch1_l3', title: 'Le réalisme et le naturalisme', subtitle: 'Balzac, Flaubert, Zola', order: 3),
            Lesson(id: 'francais_a_ch1_l4', title: 'Littérature contemporaine', subtitle: 'XXe siècle, Camus, Sartre', order: 4),
          ],
        ),
        CurriculumChapter(
          id: 'francais_a_ch2',
          title: 'Littérature africaine',
          subtitle: 'Auteurs et œuvres francophones',
          order: 2,
          subjectId: 'francais_a',
          lessons: [
            Lesson(id: 'francais_a_ch2_l1', title: 'La négritude', subtitle: 'Senghor, Césaire, Damas', order: 1),
            Lesson(id: 'francais_a_ch2_l2', title: 'Roman africain moderne', subtitle: 'Oyono, Beti, Kourouma', order: 2),
            Lesson(id: 'francais_a_ch2_l3', title: 'Poésie et théâtre africains', subtitle: 'Auteurs contemporains', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'francais_a_ch3',
          title: 'Grammaire et expression',
          subtitle: 'Syntaxe, conjugaison, rédaction',
          order: 3,
          subjectId: 'francais_a',
          lessons: [
            Lesson(id: 'francais_a_ch3_l1', title: 'Analyse grammaticale', subtitle: 'Nature et fonction des mots', order: 1),
            Lesson(id: 'francais_a_ch3_l2', title: 'Conjugaison et modes', subtitle: 'Temps, modes, concordance', order: 2),
            Lesson(id: 'francais_a_ch3_l3', title: 'Techniques d\'expression', subtitle: 'Dissertation, commentaire, résumé', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'francais_a_ch4',
          title: 'Textes et argumentation',
          subtitle: 'Lecture méthodique, argumentation',
          order: 4,
          subjectId: 'francais_a',
          lessons: [
            Lesson(id: 'francais_a_ch4_l1', title: 'Lecture méthodique', subtitle: 'Démarche, outils d\'analyse', order: 1),
            Lesson(id: 'francais_a_ch4_l2', title: 'Argumentation', subtitle: 'Thèse, arguments, exemples', order: 2),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'anglais_a',
      title: 'Anglais',
      emoji: '🌍',
      bacSeries: 'A',
      coefficient: 3,
      examDurationMinutes: 180,
      examQuestionCount: 3,
      chapters: [
        CurriculumChapter(
          id: 'anglais_a_ch1',
          title: 'Grammar',
          subtitle: 'Tenses, modals, conditionals',
          order: 1,
          subjectId: 'anglais_a',
          lessons: [
            Lesson(id: 'anglais_a_ch1_l1', title: 'Verb tenses', subtitle: 'Present, past, future, perfect', order: 1),
            Lesson(id: 'anglais_a_ch1_l2', title: 'Modals and conditionals', subtitle: 'Can, must, should, if-clauses', order: 2),
            Lesson(id: 'anglais_a_ch1_l3', title: 'Passive voice', subtitle: 'Formation, usage', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'anglais_a_ch2',
          title: 'Vocabulary',
          subtitle: 'Thematic vocabulary, idioms',
          order: 2,
          subjectId: 'anglais_a',
          lessons: [
            Lesson(id: 'anglais_a_ch2_l1', title: 'Daily life vocabulary', subtitle: 'Family, work, education', order: 1),
            Lesson(id: 'anglais_a_ch2_l2', title: 'Idioms and phrasal verbs', subtitle: 'Common expressions', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'anglais_a_ch3',
          title: 'Comprehension',
          subtitle: 'Reading, listening, translation',
          order: 3,
          subjectId: 'anglais_a',
          lessons: [
            Lesson(id: 'anglais_a_ch3_l1', title: 'Reading comprehension', subtitle: 'Texts, questions, analysis', order: 1),
            Lesson(id: 'anglais_a_ch3_l2', title: 'Translation techniques', subtitle: 'French-English, English-French', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'anglais_a_ch4',
          title: 'Essay writing',
          subtitle: 'Structure, style, topics',
          order: 4,
          subjectId: 'anglais_a',
          lessons: [
            Lesson(id: 'anglais_a_ch4_l1', title: 'Essay structure', subtitle: 'Introduction, body, conclusion', order: 1),
            Lesson(id: 'anglais_a_ch4_l2', title: 'Argumentative essays', subtitle: 'Thesis, arguments, counterpoints', order: 2),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'philosophie_a',
      title: 'Philosophie',
      emoji: '🧠',
      bacSeries: 'A',
      coefficient: 3,
      examDurationMinutes: 240,
      examQuestionCount: 1,
      chapters: [
        CurriculumChapter(
          id: 'philosophie_a_ch1',
          title: 'La conscience et l\'inconscient',
          subtitle: 'Sujet, liberté, déterminisme',
          order: 1,
          subjectId: 'philosophie_a',
          lessons: [
            Lesson(id: 'philosophie_a_ch1_l1', title: 'La conscience', subtitle: 'Descartes, Sartre', order: 1),
            Lesson(id: 'philosophie_a_ch1_l2', title: 'L\'inconscient', subtitle: 'Freud, psychanalyse', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'philosophie_a_ch2',
          title: 'La raison et le réel',
          subtitle: 'Vérité, démonstration, science',
          order: 2,
          subjectId: 'philosophie_a',
          lessons: [
            Lesson(id: 'philosophie_a_ch2_l1', title: 'La vérité', subtitle: 'Platon, Descartes, Nietzsche', order: 1),
            Lesson(id: 'philosophie_a_ch2_l2', title: 'La démonstration', subtitle: 'Raisonnement, logique', order: 2),
            Lesson(id: 'philosophie_a_ch2_l3', title: 'La science', subtitle: 'Épistémologie, Popper, Kuhn', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'philosophie_a_ch3',
          title: 'La morale et la politique',
          subtitle: 'Devoir, justice, État',
          order: 3,
          subjectId: 'philosophie_a',
          lessons: [
            Lesson(id: 'philosophie_a_ch3_l1', title: 'Le devoir et la liberté', subtitle: 'Kant, utilitarisme', order: 1),
            Lesson(id: 'philosophie_a_ch3_l2', title: 'L\'État et la justice', subtitle: 'Rousseau, Hobbes, Rawls', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'philosophie_a_ch4',
          title: 'L\'esthétique et la culture',
          subtitle: 'Art, technique, langage',
          order: 4,
          subjectId: 'philosophie_a',
          lessons: [
            Lesson(id: 'philosophie_a_ch4_l1', title: 'L\'art', subtitle: 'Beauté, création, perception', order: 1),
            Lesson(id: 'philosophie_a_ch4_l2', title: 'La technique', subtitle: 'Heidegger, Ellul', order: 2),
            Lesson(id: 'philosophie_a_ch4_l3', title: 'Le langage', subtitle: 'Saussure, Wittgenstein', order: 3),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'histoire_geo_a',
      title: 'Histoire-Géographie',
      emoji: '🌍',
      bacSeries: 'A',
      coefficient: 3,
      examDurationMinutes: 180,
      examQuestionCount: 3,
      chapters: [
        CurriculumChapter(
          id: 'histoire_geo_a_ch1',
          title: 'Histoire : Monde contemporain',
          subtitle: 'Colonisation, décolonisation, guerres',
          order: 1,
          subjectId: 'histoire_geo_a',
          lessons: [
            Lesson(id: 'histoire_geo_a_ch1_l1', title: 'La colonisation européenne', subtitle: 'Empires, administration, impact', order: 1),
            Lesson(id: 'histoire_geo_a_ch1_l2', title: 'Les deux guerres mondiales', subtitle: 'Causes, déroulement, conséquences', order: 2),
            Lesson(id: 'histoire_geo_a_ch1_l3', title: 'La décolonisation', subtitle: 'Indépendances africaines, figures', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'histoire_geo_a_ch2',
          title: 'Histoire : Afrique',
          subtitle: 'Civilisations, royaumes, indépendances',
          order: 2,
          subjectId: 'histoire_geo_a',
          lessons: [
            Lesson(id: 'histoire_geo_a_ch2_l1', title: 'Civilisations précoloniales', subtitle: 'Ghana, Mali, Songhai', order: 1),
            Lesson(id: 'histoire_geo_a_ch2_l2', title: 'Résistances africaines', subtitle: 'Samori, Béhanzin, El Hadj Omar', order: 2),
            Lesson(id: 'histoire_geo_a_ch2_l3', title: 'Afrique indépendante', subtitle: 'États post-coloniaux, défis', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'histoire_geo_a_ch3',
          title: 'Géographie : Générale',
          subtitle: 'Climat, population, développement',
          order: 3,
          subjectId: 'histoire_geo_a',
          lessons: [
            Lesson(id: 'histoire_geo_a_ch3_l1', title: 'Climats et biomes', subtitle: 'Zones climatiques, végétation', order: 1),
            Lesson(id: 'histoire_geo_a_ch3_l2', title: 'Population et urbanisation', subtitle: 'Démographie, villes', order: 2),
            Lesson(id: 'histoire_geo_a_ch3_l3', title: 'Développement durable', subtitle: 'Enjeux, ODD', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'histoire_geo_a_ch4',
          title: 'Géographie : Afrique',
          subtitle: 'Ressources, intégration régionale',
          order: 4,
          subjectId: 'histoire_geo_a',
          lessons: [
            Lesson(id: 'histoire_geo_a_ch4_l1', title: 'Ressources naturelles', subtitle: 'Mines, agriculture, eau', order: 1),
            Lesson(id: 'histoire_geo_a_ch4_l2', title: 'Intégration régionale', subtitle: 'UA, CEDEAO, zones économiques', order: 2),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'maths_a',
      title: 'Mathématiques',
      emoji: '🔢',
      bacSeries: 'A',
      coefficient: 2,
      examDurationMinutes: 120,
      examQuestionCount: 3,
      chapters: [
        CurriculumChapter(
          id: 'maths_a_ch1',
          title: 'Calcul de base',
          subtitle: 'Opérations, fractions, puissances',
          order: 1,
          subjectId: 'maths_a',
          lessons: [
            Lesson(id: 'maths_a_ch1_l1', title: 'Opérations fondamentales', subtitle: 'Addition, soustraction, multiplication, division', order: 1),
            Lesson(id: 'maths_a_ch1_l2', title: 'Fractions et pourcentages', subtitle: 'Simplification, calculs', order: 2),
            Lesson(id: 'maths_a_ch1_l3', title: 'Puissances et racines', subtitle: 'Exposants, racines carrées', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_a_ch2',
          title: 'Statistiques',
          subtitle: 'Moyenne, médiane, diagrammes',
          order: 2,
          subjectId: 'maths_a',
          lessons: [
            Lesson(id: 'maths_a_ch2_l1', title: 'Série statistique', subtitle: 'Effectifs, fréquences, classes', order: 1),
            Lesson(id: 'maths_a_ch2_l2', title: 'Indicateurs de tendance', subtitle: 'Moyenne, médiane, mode', order: 2),
            Lesson(id: 'maths_a_ch2_l3', title: 'Représentations graphiques', subtitle: 'Diagrammes, histogrammes', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_a_ch3',
          title: 'Probabilités simples',
          subtitle: 'Dénombrement, probabilité',
          order: 3,
          subjectId: 'maths_a',
          lessons: [
            Lesson(id: 'maths_a_ch3_l1', title: 'Dénombrement', subtitle: 'Arrangements, combinaisons', order: 1),
            Lesson(id: 'maths_a_ch3_l2', title: 'Probabilité d\'un événement', subtitle: 'Définition, calculs', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'maths_a_ch4',
          title: 'Fonctions linéaires',
          subtitle: 'Fonctions affines, proportionnalité',
          order: 4,
          subjectId: 'maths_a',
          lessons: [
            Lesson(id: 'maths_a_ch4_l1', title: 'Fonction affine', subtitle: 'Coefficient directeur, ordonnée', order: 1),
            Lesson(id: 'maths_a_ch4_l2', title: 'Proportionnalité', subtitle: 'Règle de trois, échelles', order: 2),
          ],
        ),
      ],
    ),
  ];

  // ═══════════════════════════════════════════
  //  BAC TI — Techniques de l'Informatique
  // ═══════════════════════════════════════════

  static final List<SubjectCurriculum> _bacTISubjects = [
    SubjectCurriculum(
      id: 'info_ti',
      title: 'Informatique',
      emoji: '💻',
      bacSeries: 'TI',
      coefficient: 5,
      examDurationMinutes: 300,
      examQuestionCount: 6,
      chapters: [
        CurriculumChapter(
          id: 'info_ti_ch1',
          title: 'Algorithmique avancée',
          subtitle: 'Complexité, récursivité, optimisation',
          order: 1,
          subjectId: 'info_ti',
          lessons: [
            Lesson(id: 'info_ti_ch1_l1', title: 'Complexité algorithmique', subtitle: 'O(n), O(n²), O(log n)', order: 1),
            Lesson(id: 'info_ti_ch1_l2', title: 'Algorithmes de tri', subtitle: 'Tri à bulles, rapide, fusion', order: 2),
            Lesson(id: 'info_ti_ch1_l3', title: 'Algorithmes de recherche', subtitle: 'Recherche dichotomique, interpolation', order: 3),
            Lesson(id: 'info_ti_ch1_l4', title: 'Récursivité avancée', subtitle: 'Diviser pour régner, backtracking', order: 4),
          ],
        ),
        CurriculumChapter(
          id: 'info_ti_ch2',
          title: 'Structures de données avancées',
          subtitle: 'Arbres, graphes, tables de hachage',
          order: 2,
          subjectId: 'info_ti',
          lessons: [
            Lesson(id: 'info_ti_ch2_l1', title: 'Arbres binaires', subtitle: 'ABR, parcours, équilibrage', order: 1),
            Lesson(id: 'info_ti_ch2_l2', title: 'Graphes', subtitle: 'Représentation, parcours BFS/DFS', order: 2),
            Lesson(id: 'info_ti_ch2_l3', title: 'Tables de hachage', subtitle: 'Fonction de hachage, collisions', order: 3),
            Lesson(id: 'info_ti_ch2_l4', title: 'Files de priorité', subtitle: 'Tas binaire, implémentation', order: 4),
          ],
        ),
        CurriculumChapter(
          id: 'info_ti_ch3',
          title: 'Programmation Python',
          subtitle: 'POO, modules, projets',
          order: 3,
          subjectId: 'info_ti',
          lessons: [
            Lesson(id: 'info_ti_ch3_l1', title: 'Classes et objets', subtitle: 'Attributs, méthodes, héritage', order: 1),
            Lesson(id: 'info_ti_ch3_l2', title: 'Modules et packages', subtitle: 'Organisation, import', order: 2),
            Lesson(id: 'info_ti_ch3_l3', title: 'Gestion des fichiers', subtitle: 'Lecture, écriture, formats', order: 3),
            Lesson(id: 'info_ti_ch3_l4', title: 'Exceptions et tests', subtitle: 'Try/except, débogage', order: 4),
          ],
        ),
        CurriculumChapter(
          id: 'info_ti_ch4',
          title: 'Bases de données',
          subtitle: 'SQL avancé, conception, administration',
          order: 4,
          subjectId: 'info_ti',
          lessons: [
            Lesson(id: 'info_ti_ch4_l1', title: 'SQL avancé', subtitle: 'Sous-requêtes, jointures multiples, vues', order: 1),
            Lesson(id: 'info_ti_ch4_l2', title: 'Conception MERISE', subtitle: 'MCD, MLD, MPD, dictionnaire', order: 2),
            Lesson(id: 'info_ti_ch4_l3', title: 'Administration SGBD', subtitle: 'Utilisateurs, permissions, sauvegardes', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'info_ti_ch5',
          title: 'Développement Web',
          subtitle: 'HTML, CSS, JavaScript, PHP',
          order: 5,
          subjectId: 'info_ti',
          lessons: [
            Lesson(id: 'info_ti_ch5_l1', title: 'HTML et CSS', subtitle: 'Structure, styles, mise en page', order: 1),
            Lesson(id: 'info_ti_ch5_l2', title: 'JavaScript', subtitle: 'DOM, événements, formulaires', order: 2),
            Lesson(id: 'info_ti_ch5_l3', title: 'PHP et MySQL', subtitle: 'Serveur, sessions, CRUD', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'info_ti_ch6',
          title: 'Réseaux et sécurité',
          subtitle: 'Architecture réseau, protocoles, sécurité',
          order: 6,
          subjectId: 'info_ti',
          lessons: [
            Lesson(id: 'info_ti_ch6_l1', title: 'Architecture des réseaux', subtitle: 'Modèle OSI, TCP/IP, adressage', order: 1),
            Lesson(id: 'info_ti_ch6_l2', title: 'Protocoles applicatifs', subtitle: 'HTTP, FTP, SMTP, DNS', order: 2),
            Lesson(id: 'info_ti_ch6_l3', title: 'Sécurité informatique', subtitle: 'Cryptographie, pare-feu, VPN', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'info_ti_ch7',
          title: 'Génie logiciel',
          subtitle: 'Méthodologies, UML, tests',
          order: 7,
          subjectId: 'info_ti',
          lessons: [
            Lesson(id: 'info_ti_ch7_l1', title: 'Cycle de vie du logiciel', subtitle: 'Analyse, conception, réalisation', order: 1),
            Lesson(id: 'info_ti_ch7_l2', title: 'UML', subtitle: 'Diagrammes de cas, classes, séquence', order: 2),
            Lesson(id: 'info_ti_ch7_l3', title: 'Méthodes agiles', subtitle: 'Scrum, Kanban, itérations', order: 3),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'maths_ti',
      title: 'Mathématiques',
      emoji: '🔢',
      bacSeries: 'TI',
      coefficient: 4,
      examDurationMinutes: 240,
      examQuestionCount: 5,
      chapters: [
        CurriculumChapter(
          id: 'maths_ti_ch1',
          title: 'Logique et algèbre',
          subtitle: 'Logique booléenne, calcul propositionnel',
          order: 1,
          subjectId: 'maths_ti',
          lessons: [
            Lesson(id: 'maths_ti_ch1_l1', title: 'Logique mathématique', subtitle: 'Propositions, connecteurs, tables de vérité', order: 1),
            Lesson(id: 'maths_ti_ch1_l2', title: 'Algèbre de Boole', subtitle: 'Fonctions booléennes, simplification', order: 2),
            Lesson(id: 'maths_ti_ch1_l3', title: 'Matrices', subtitle: 'Opérations, déterminant, inverse', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ti_ch2',
          title: 'Suites et séries',
          subtitle: 'Suites numériques, convergence',
          order: 2,
          subjectId: 'maths_ti',
          lessons: [
            Lesson(id: 'maths_ti_ch2_l1', title: 'Suites numériques', subtitle: 'Monotonie, convergence', order: 1),
            Lesson(id: 'maths_ti_ch2_l2', title: 'Suites récurrentes', subtitle: 'Expression, limite', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ti_ch3',
          title: 'Fonctions numériques',
          subtitle: 'Dérivation, intégration',
          order: 3,
          subjectId: 'maths_ti',
          lessons: [
            Lesson(id: 'maths_ti_ch3_l1', title: 'Fonctions dérivées', subtitle: 'Dérivée, variations', order: 1),
            Lesson(id: 'maths_ti_ch3_l2', title: 'Fonctions exponentielles et log', subtitle: 'Propriétés, limites', order: 2),
            Lesson(id: 'maths_ti_ch3_l3', title: 'Calcul intégral', subtitle: 'Primitives, intégrales', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'maths_ti_ch4',
          title: 'Probabilités et statistiques',
          subtitle: 'Dénombrement, probabilités, statistiques',
          order: 4,
          subjectId: 'maths_ti',
          lessons: [
            Lesson(id: 'maths_ti_ch4_l1', title: 'Dénombrement', subtitle: 'Arrangements, combinaisons', order: 1),
            Lesson(id: 'maths_ti_ch4_l2', title: 'Probabilités', subtitle: 'Variable aléatoire, loi binomiale', order: 2),
            Lesson(id: 'maths_ti_ch4_l3', title: 'Statistiques', subtitle: 'Moyenne, variance, écart-type', order: 3),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'physique_ti',
      title: 'Physique',
      emoji: '⚡',
      bacSeries: 'TI',
      coefficient: 3,
      examDurationMinutes: 180,
      examQuestionCount: 4,
      chapters: [
        CurriculumChapter(
          id: 'physique_ti_ch1',
          title: 'Électricité de base',
          subtitle: 'Courant, tension, résistance',
          order: 1,
          subjectId: 'physique_ti',
          lessons: [
            Lesson(id: 'physique_ti_ch1_l1', title: 'Grandeurs électriques', subtitle: 'Tension, courant, puissance', order: 1),
            Lesson(id: 'physique_ti_ch1_l2', title: 'Composants passifs', subtitle: 'Résistance, condensateur, bobine', order: 2),
            Lesson(id: 'physique_ti_ch1_l3', title: 'Circuits élémentaires', subtitle: 'Lois de Kirchhoff, diviseurs', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'physique_ti_ch2',
          title: 'Électronique',
          subtitle: 'Semi-conducteurs, transistors',
          order: 2,
          subjectId: 'physique_ti',
          lessons: [
            Lesson(id: 'physique_ti_ch2_l1', title: 'Semi-conducteurs', subtitle: 'Dopage, diode, jonction PN', order: 1),
            Lesson(id: 'physique_ti_ch2_l2', title: 'Transistors', subtitle: 'Bipolaire, FET, amplification', order: 2),
            Lesson(id: 'physique_ti_ch2_l3', title: 'Portes logiques', subtitle: 'ET, OU, NON, NAND, NOR', order: 3),
          ],
        ),
        CurriculumChapter(
          id: 'physique_ti_ch3',
          title: 'Circuits numériques',
          subtitle: 'Bascules, compteurs, registres',
          order: 3,
          subjectId: 'physique_ti',
          lessons: [
            Lesson(id: 'physique_ti_ch3_l1', title: 'Bascules RS et D', subtitle: 'Fonctionnement, tables', order: 1),
            Lesson(id: 'physique_ti_ch3_l2', title: 'Compteurs et registres', subtitle: 'Synchrone/asynchrone', order: 2),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'anglais_ti',
      title: 'Anglais Technique',
      emoji: '🌍',
      bacSeries: 'TI',
      coefficient: 2,
      examDurationMinutes: 120,
      examQuestionCount: 2,
      chapters: [
        CurriculumChapter(
          id: 'anglais_ti_ch1',
          title: 'Technical English',
          subtitle: 'IT vocabulary, documentation',
          order: 1,
          subjectId: 'anglais_ti',
          lessons: [
            Lesson(id: 'anglais_ti_ch1_l1', title: 'IT vocabulary', subtitle: 'Hardware, software, networking', order: 1),
            Lesson(id: 'anglais_ti_ch1_l2', title: 'Reading documentation', subtitle: 'Manuals, API docs', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'anglais_ti_ch2',
          title: 'English communication',
          subtitle: 'Emails, reports, presentations',
          order: 2,
          subjectId: 'anglais_ti',
          lessons: [
            Lesson(id: 'anglais_ti_ch2_l1', title: 'Professional writing', subtitle: 'Emails, reports', order: 1),
            Lesson(id: 'anglais_ti_ch2_l2', title: 'Oral communication', subtitle: 'Presentations, meetings', order: 2),
          ],
        ),
      ],
    ),
    SubjectCurriculum(
      id: 'francais_ti',
      title: 'Français',
      emoji: '📖',
      bacSeries: 'TI',
      coefficient: 2,
      examDurationMinutes: 120,
      examQuestionCount: 2,
      chapters: [
        CurriculumChapter(
          id: 'francais_ti_ch1',
          title: 'Communication écrite',
          subtitle: 'Rédaction, compte rendu',
          order: 1,
          subjectId: 'francais_ti',
          lessons: [
            Lesson(id: 'francais_ti_ch1_l1', title: 'Techniques rédactionnelles', subtitle: 'Synthèse, compte rendu', order: 1),
            Lesson(id: 'francais_ti_ch1_l2', title: 'Correspondance', subtitle: 'Lettres formelles, emails', order: 2),
          ],
        ),
        CurriculumChapter(
          id: 'francais_ti_ch2',
          title: 'Culture et société',
          subtitle: 'Textes, débats, citoyenneté',
          order: 2,
          subjectId: 'francais_ti',
          lessons: [
            Lesson(id: 'francais_ti_ch2_l1', title: 'Analyse de textes', subtitle: 'Lecture, compréhension', order: 1),
            Lesson(id: 'francais_ti_ch2_l2', title: 'Citoyenneté et éthique', subtitle: 'Droits, devoirs, numérique', order: 2),
          ],
        ),
      ],
    ),
  ];
}
