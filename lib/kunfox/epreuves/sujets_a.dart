// Épreuves de la série A (format Office du Bac) : français, anglais,
// philosophie, histoire-géographie, mathématiques.

import 'modele.dart';

const _baremeDissertation = [
  Critere("Introduction : amorce, problématique claire, annonce du plan", 3),
  Critere("Première partie argumentée, avec exemples précis", 4.5),
  Critere("Deuxième partie (nuance, dépassement ou thèse adverse)", 4.5),
  Critere("Transitions et cohérence de l'ensemble", 1.5),
  Critere("Conclusion : bilan et ouverture", 1.5),
];

const epreuveFrancaisA = Epreuve(
  id: 'bac_a_francais_1',
  matiere: 'francais_a',
  serie: 'A',
  titre: 'Français',
  dureeMinutes: 240,
  coefficient: 5,
  consignes: "Traite la partie I (connaissances et étude de texte) puis le sujet de dissertation de la partie II.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Connaissances littéraires',
      enonce: r'''Réponds aux questions sur la littérature française et africaine étudiée en classe.''',
      questions: [
        QuestionEpreuve.qcm('1', "Qui a écrit « Une vie de boy » (1956) ?",
            options: ['Ferdinand Oyono', 'Mongo Beti', 'Camara Laye', 'Cheikh Hamidou Kane'],
            bonne: 0,
            points: 1,
            chapitre: 'francais_a_ch2',
            corrige: r'''**Ferdinand Oyono**, écrivain camerounais : le journal de Toundi, boy chez le commandant, dénonce l'hypocrisie coloniale.'''),
        QuestionEpreuve.qcm('2', "« Le pauvre Christ de Bomba » est un roman de :",
            options: ['Mongo Beti', 'Ferdinand Oyono', 'Ahmadou Kourouma', 'Léopold Sédar Senghor'],
            bonne: 0,
            points: 1,
            chapitre: 'francais_a_ch2',
            corrige: r'''**Mongo Beti** (1956) : la tournée d'un missionnaire révèle les contradictions de l'évangélisation coloniale.'''),
        QuestionEpreuve.courte('3', "Quel mouvement littéraire et culturel ont fondé Aimé Césaire, Léopold Sédar Senghor et Léon-Gontran Damas ?",
            acceptees: ['la négritude', 'négritude', 'negritude', 'la negritude'],
            points: 1,
            chapitre: 'francais_a_ch2',
            corrige: r'''La **négritude**, née à Paris dans les années 1930 : revendication de l'identité et de la culture noires.'''),
        QuestionEpreuve.qcm('4', "Dans une argumentation, la concession consiste à :",
            options: ["reconnaître en partie la thèse adverse avant de la réfuter", "répéter sa thèse", "citer une autorité", "conclure le texte"],
            bonne: 0,
            points: 1,
            chapitre: 'francais_a_ch4',
            corrige: r'''Concéder, c'est admettre une part de vérité à l'adversaire (« certes… mais… ») pour mieux défendre sa propre thèse.'''),
        QuestionEpreuve.qcm('5', "« Ce cœur qui haïssait la guerre voilà qui bat pour le combat et la bataille » (Desnos) : la figure dominante est :",
            options: ['une antithèse', 'une litote', 'une métonymie', 'une hyperbole'],
            bonne: 0,
            points: 1,
            chapitre: 'francais_a_ch3',
            corrige: r'''L'**antithèse** oppose « haïssait la guerre » et « bat pour le combat ».'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Dissertation',
      enonce: r'''**Sujet.** « Le roman africain n'est pas seulement un récit : c'est un combat. »

Commente et discute cette affirmation en t'appuyant sur les œuvres que tu as étudiées.''',
      questions: [
        QuestionEpreuve.redaction('1', "Rédige ta dissertation (plan détaillé accepté au brouillon).",
            chapitre: 'francais_a_ch4',
            bareme: _baremeDissertation,
            corrige: r'''## Pistes de corrigé
**Problématique** : le roman africain est-il d'abord une arme de combat, ou aussi une œuvre d'art et un témoignage plus large ?

**I. Un roman de combat**
- Contre la colonisation : *Une vie de boy* (Oyono), *Le pauvre Christ de Bomba* (Mongo Beti).
- Contre les dérives des indépendances : *Les Soleils des indépendances* (Kourouma).
- Pour la dignité et l'identité : héritage de la négritude.

**II. Mais pas seulement un combat**
- Un récit d'apprentissage et de mémoire : *L'Enfant noir* (Camara Laye).
- Une réflexion philosophique : *L'Aventure ambiguë* (Cheikh Hamidou Kane), le dilemme entre deux cultures.
- Une recherche esthétique : humour, ironie, oralité, travail de la langue.

**Conclusion** : le roman africain combat, mais il le fait en artiste ; son engagement passe par la force du récit.'''),
      ],
    ),
  ],
);

const epreuvePhilosophieA = Epreuve(
  id: 'bac_a_philosophie_1',
  matiere: 'philosophie_a',
  serie: 'A',
  titre: 'Philosophie',
  dureeMinutes: 240,
  coefficient: 3,
  consignes: "Partie I : questions de cours. Partie II : dissertation.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Questions de cours',
      enonce: r'''Réponds aux questions suivantes.''',
      questions: [
        QuestionEpreuve.qcm('1', "« Je pense, donc je suis » est une formule de :",
            options: ['Descartes', 'Kant', 'Platon', 'Nietzsche'],
            bonne: 0,
            points: 1,
            chapitre: 'philosophie_a_ch1',
            corrige: r'''**René Descartes** (*Discours de la méthode*, 1637) : le cogito, première certitude qui résiste au doute.'''),
        QuestionEpreuve.qcm('2', "Le concept d'inconscient psychique est associé surtout à :",
            options: ['Sigmund Freud', 'Aristote', 'Auguste Comte', 'John Locke'],
            bonne: 0,
            points: 1,
            chapitre: 'philosophie_a_ch1',
            corrige: r'''**Freud** : une part de notre vie psychique (désirs refoulés) échappe à la conscience et la détermine.'''),
        QuestionEpreuve.qcm('3', "« L'homme est par nature un animal politique » :",
            options: ['Aristote', 'Hobbes', 'Rousseau', 'Sartre'],
            bonne: 0,
            points: 1,
            chapitre: 'philosophie_a_ch3',
            corrige: r'''**Aristote** (*Politique*) : l'homme ne réalise pleinement sa nature que dans la cité.'''),
        QuestionEpreuve.qcm('4', "Le philosophe camerounais Marcien Towa est connu pour sa critique de :",
            options: ["l'ethnophilosophie", "la physique moderne", "la démocratie athénienne", "l'existentialisme"],
            bonne: 0,
            points: 1,
            chapitre: 'philosophie_a_ch2',
            corrige: r'''**Marcien Towa** (*Essai sur la problématique philosophique dans l'Afrique actuelle*, 1971) refuse de réduire la philosophie africaine aux croyances collectives (ethnophilosophie, cf. Tempels) et appelle à une pensée critique.'''),
        QuestionEpreuve.redaction('5', "Définis la conscience morale en deux ou trois phrases.",
            chapitre: 'philosophie_a_ch3',
            bareme: [
              Critere("Faculté de juger le bien et le mal", 0.5),
              Critere("Appliquée à nos propres actes (remords, approbation)", 0.5),
            ],
            corrige: r'''La **conscience morale** est la faculté par laquelle nous jugeons le bien et le mal, en particulier dans nos propres actes : elle nous approuve ou nous fait éprouver des remords. Rousseau l'appelle un « instinct divin ».'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Dissertation',
      enonce: r'''**Sujet.** Peut-on être libre sans obéir aux lois ?''',
      questions: [
        QuestionEpreuve.redaction('1', "Rédige ta dissertation.",
            chapitre: 'philosophie_a_ch3',
            bareme: [
              Critere("Analyse des termes (liberté, loi, obéir) et problématique", 3),
              Critere("Thèse : la liberté comme absence de contrainte (la loi limite)", 4),
              Critere("Antithèse/dépassement : la loi condition de la liberté (Rousseau, Montesquieu)", 4),
              Critere("Références précises et exemples", 3),
              Critere("Conclusion et qualité de l'expression", 1),
            ],
            corrige: r'''## Pistes de corrigé
**Problème** : la loi semble limiter ma liberté ; pourtant, sans loi, ma liberté n'est-elle pas à la merci du plus fort ?

**I. La loi apparaît comme une contrainte**
- Être libre, ce serait faire ce que l'on veut (liberté naturelle).
- Les lois injustes oppriment : la désobéissance civile (Thoreau, Gandhi).

**II. Mais la loi rend la liberté possible**
- Sans loi, règne la force : « l'homme est un loup pour l'homme » (Hobbes).
- Montesquieu : « La liberté est le droit de faire tout ce que les lois permettent. »
- Rousseau : « L'obéissance à la loi qu'on s'est prescrite est liberté » — l'autonomie.

**Conclusion** : on n'est pas libre *contre* toute loi, mais *par* des lois justes que l'on reconnaît comme siennes ; la désobéissance reste légitime face à l'injustice.'''),
      ],
    ),
  ],
);

const epreuveHistoireGeoA = Epreuve(
  id: 'bac_a_histgeo_1',
  matiere: 'histoire_geo_a',
  serie: 'A',
  titre: 'Histoire-Géographie',
  dureeMinutes: 180,
  coefficient: 3,
  consignes: "Traite les questions d'histoire puis de géographie.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Histoire',
      enonce: r'''Le Cameroun, de la tutelle à l'indépendance, dans le contexte de la décolonisation.''',
      questions: [
        QuestionEpreuve.qcm('1', "Le Cameroun sous tutelle française accède à l'indépendance le :",
            options: ['1ᵉʳ janvier 1960', '1ᵉʳ octobre 1961', '20 mai 1972', '13 août 1960'],
            bonne: 0,
            points: 1.5,
            chapitre: 'histoire_geo_a_ch2',
            corrige: r'''**1ᵉʳ janvier 1960**. La réunification avec le Southern Cameroons a lieu le 1ᵉʳ octobre 1961 ; le 20 mai 1972 naît la République unie.'''),
        QuestionEpreuve.courte('2', "Quel parti nationaliste, fondé en 1948, a réclamé l'indépendance et la réunification ?",
            acceptees: ['UPC', "l'UPC", "Union des populations du Cameroun", "l'Union des populations du Cameroun"],
            points: 1.5,
            chapitre: 'histoire_geo_a_ch2',
            corrige: r'''L'**UPC** (Union des populations du Cameroun), dirigée notamment par Ruben Um Nyobè.'''),
        QuestionEpreuve.qcm('3', "La conférence qui marque l'entrée des pays du tiers-monde sur la scène internationale (1955) est celle de :",
            options: ['Bandung', 'Yalta', 'Berlin', 'Brazzaville'],
            bonne: 0,
            points: 1.5,
            chapitre: 'histoire_geo_a_ch1',
            corrige: r'''**Bandung** (Indonésie, 1955) : les pays d'Afrique et d'Asie condamnent le colonialisme ; naissance du non-alignement.'''),
        QuestionEpreuve.nombre('4', "En quelle année l'Organisation de l'unité africaine (OUA) est-elle créée à Addis-Abeba ?",
            valeur: 1963, tolerance: 0, points: 1.5, chapitre: 'histoire_geo_a_ch2',
            corrige: r'''L'OUA est créée le 25 mai **1963** ; elle est remplacée par l'Union africaine en 2002.'''),
        QuestionEpreuve.redaction('5', "Explique en un paragraphe les facteurs de la décolonisation de l'Afrique après 1945.",
            chapitre: 'histoire_geo_a_ch1',
            bareme: [
              Critere("Affaiblissement des métropoles après la Seconde Guerre mondiale", 1.25),
              Critere("Rôle de l'ONU et des deux Grands (anticolonialistes)", 1.25),
              Critere("Montée des nationalismes et élites africaines", 1.25),
              Critere("Exemples précis (Bandung, UPC, Ghana 1957…)", 1.25),
            ],
            corrige: r'''- **Facteurs externes** : les puissances coloniales sortent affaiblies de la guerre ; l'ONU (Charte de 1945) affirme le droit des peuples à disposer d'eux-mêmes ; États-Unis et URSS sont hostiles au colonialisme ; Bandung (1955).
- **Facteurs internes** : participation des Africains à la guerre, essor des partis nationalistes (UPC au Cameroun, CPP de Nkrumah), formation d'élites ; indépendance du Ghana en 1957, puis vague de 1960.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Géographie',
      enonce: r'''Le document donne la production de cacao de quelques pays (milliers de tonnes, ordre de grandeur récent) :

```tableau
Pays | Côte d'Ivoire | Ghana | Cameroun | Nigeria
Production | 2 200 | 800 | 290 | 280
```''',
      questions: [
        QuestionEpreuve.qcm('1', "Quel est le premier producteur mondial de cacao ?",
            options: ["la Côte d'Ivoire", 'le Ghana', 'le Cameroun', 'le Brésil'],
            bonne: 0,
            points: 1.5,
            chapitre: 'histoire_geo_a_ch4',
            corrige: r'''La **Côte d'Ivoire**, loin devant le Ghana.'''),
        QuestionEpreuve.courte('2', "Quelle est la capitale politique du Cameroun ?",
            acceptees: ['Yaoundé', 'Yaounde'],
            points: 1.5,
            chapitre: 'histoire_geo_a_ch4',
            corrige: r'''**Yaoundé** ; Douala est la capitale économique et le principal port.'''),
        QuestionEpreuve.courte('3', "Quel est le plus long fleuve du Cameroun ?",
            acceptees: ['Sanaga', 'la Sanaga', 'le Sanaga'],
            points: 1.5,
            chapitre: 'histoire_geo_a_ch3',
            corrige: r'''La **Sanaga**, qui alimente les barrages d'Edéa et de Song Loulou.'''),
        QuestionEpreuve.redaction('4', "Présente deux atouts et deux difficultés de l'agriculture d'exportation au Cameroun.",
            chapitre: 'histoire_geo_a_ch4',
            bareme: [
              Critere("Atouts : climats variés, sols volcaniques, main-d'œuvre, port de Douala…", 2.25),
              Critere("Difficultés : prix mondiaux instables, enclavement, vieillissement des plantations, faible transformation locale…", 2.25),
            ],
            corrige: r'''**Atouts** : diversité des climats et des sols (sols volcaniques de l'Ouest et du Littoral), grandes cultures (cacao, café, banane, coton), port de Douala ouvert sur l'Atlantique.

**Difficultés** : dépendance aux cours mondiaux, faible transformation sur place (peu de valeur ajoutée), routes rurales insuffisantes, vieillissement des vergers et des planteurs.'''),
      ],
    ),
  ],
);

const epreuveMathsA = Epreuve(
  id: 'bac_a_maths_1',
  matiere: 'maths_a',
  serie: 'A',
  titre: 'Mathématiques',
  dureeMinutes: 120,
  coefficient: 2,
  consignes: "Calculatrice autorisée.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Statistiques',
      enonce: r'''Les notes de français de 20 élèves d'une classe de Terminale A :

```tableau
Note | 6 | 8 | 10 | 12 | 14 | 16
Effectif | 2 | 3 | 5 | 6 | 3 | 1
```''',
      questions: [
        QuestionEpreuve.nombre('1', "Calcule la moyenne de la classe.",
            valeur: 11, tolerance: 0.001, points: 2, chapitre: 'maths_a_ch2',
            corrige: r'''$$\bar x = \frac{6\times2 + 8\times3 + 10\times5 + 12\times6 + 14\times3 + 16\times1}{20} = \frac{220}{20} = 11$$'''),
        QuestionEpreuve.nombre('2', "Quel est le mode de cette série ?",
            valeur: 12, tolerance: 0, points: 1.5, chapitre: 'maths_a_ch2',
            corrige: r'''La note la plus fréquente est **12** (6 élèves).'''),
        QuestionEpreuve.nombre('3', "Quelle est la médiane ?",
            valeur: 11, tolerance: 0, points: 2, chapitre: 'maths_a_ch2',
            corrige: r'''20 valeurs : la médiane est la moyenne des 10ᵉ et 11ᵉ valeurs. Effectifs cumulés : 2, 5, 10, 16… La 10ᵉ vaut 10 et la 11ᵉ vaut 12 : médiane $= \dfrac{10+12}{2} = 11$.'''),
        QuestionEpreuve.nombre('4', "Quel pourcentage d'élèves a la moyenne (note ≥ 10) ?",
            valeur: 75, tolerance: 0.001, unite: '%', points: 1.5, chapitre: 'maths_a_ch2',
            corrige: r'''$5 + 6 + 3 + 1 = 15$ élèves sur 20 : $\dfrac{15}{20} = 75\ \%$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Pourcentages et fonctions',
      enonce: r'''Un commerçant de Bafoussam vend un sac de riz à $20\,000$ FCFA. Il augmente son prix de $10\ \%$, puis accorde une remise de $10\ \%$ sur le nouveau prix.

Un taxi facture $f(x) = 300x + 500$ FCFA pour $x$ kilomètres.''',
      questions: [
        QuestionEpreuve.nombre('1', "Quel est le prix final du sac (FCFA) ?",
            valeur: 19800, tolerance: 0, points: 2, chapitre: 'maths_a_ch1',
            corrige: r'''$20\,000\times1{,}1 = 22\,000$, puis $22\,000\times0{,}9 = 19\,800$ FCFA. Une hausse puis une baisse de 10 % ne se compensent pas : $1{,}1\times0{,}9 = 0{,}99$.'''),
        QuestionEpreuve.nombre('2', "Combien paie-t-on pour 12 km en taxi ?",
            valeur: 4100, tolerance: 0, unite: 'FCFA', points: 1.5, chapitre: 'maths_a_ch4',
            corrige: r'''$f(12) = 300\times12 + 500 = 4\,100$ FCFA.'''),
        QuestionEpreuve.nombre('3', "Avec 2 600 FCFA, combien de kilomètres peut-on parcourir ?",
            valeur: 7, tolerance: 0, unite: 'km', points: 2, chapitre: 'maths_a_ch4',
            corrige: r'''$300x + 500 = 2\,600 \iff 300x = 2\,100 \iff x = 7$ km.'''),
        QuestionEpreuve.qcm('4', r"La représentation graphique de $f$ est :",
            options: ["une droite de coefficient directeur 300", "une parabole", "une droite passant par l'origine", "une droite horizontale"],
            bonne: 0,
            points: 1.5,
            chapitre: 'maths_a_ch4',
            corrige: r'''$f$ est affine ($ax + b$ avec $a = 300$, $b = 500$) : c'est une droite qui coupe l'axe des ordonnées en 500.

```graphe
f(x) = 300x + 500 | bleu
x: 0 .. 15
y: 0 .. 5000
point: (12, 4100)
```'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Probabilités',
      enonce: r'''On lance un dé cubique équilibré dont les faces sont numérotées de 1 à 6.''',
      questions: [
        QuestionEpreuve.nombre('1', "Quelle est la probabilité d'obtenir un nombre pair ?",
            valeur: 0.5, tolerance: 0.001, points: 1.5, chapitre: 'maths_a_ch3',
            corrige: r'''3 issues favorables (2, 4, 6) sur 6 : $\dfrac36 = \dfrac12$.'''),
        QuestionEpreuve.nombre('2', "Quelle est la probabilité d'obtenir un multiple de 3 ?",
            valeur: 1 / 3, tolerance: 0.01, points: 1.5, chapitre: 'maths_a_ch3',
            corrige: r'''3 et 6 : $\dfrac26 = \dfrac13$.'''),
        QuestionEpreuve.nombre('3', "On lance le dé deux fois. Probabilité d'obtenir deux fois 6 ?",
            valeur: 1 / 36, tolerance: 0.01, points: 1.5, chapitre: 'maths_a_ch3',
            corrige: r'''Lancers indépendants : $\dfrac16\times\dfrac16 = \dfrac{1}{36}$.'''),
        QuestionEpreuve.redaction('4', "Explique pourquoi la probabilité de « ne pas obtenir 6 » vaut 5/6.",
            chapitre: 'maths_a_ch3',
            bareme: [Critere(r"Événement contraire : $P(\bar A) = 1 - P(A) = 1 - \frac16 = \frac56$", 1.5)],
            corrige: r'''« Ne pas obtenir 6 » est l'événement contraire de « obtenir 6 » : $P = 1 - \dfrac16 = \dfrac56$ (ou : 5 issues favorables sur 6).'''),
      ],
    ),
  ],
);

const epreuveAnglaisA = Epreuve(
  id: 'bac_a_anglais_1',
  matiere: 'anglais_a',
  serie: 'A',
  titre: 'Anglais',
  dureeMinutes: 180,
  coefficient: 3,
  consignes: "Read the text carefully, then answer all the questions in English.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Reading comprehension',
      enonce: r'''**The Market Day**

Every Saturday, Ngozi wakes up before dawn to help her mother at the market in Limbe. They sell fresh fish that her father catches during the night. Ngozi enjoys talking with the customers, but she worries about her exams. "If I study hard, I will become a doctor," she often says. Her mother smiles: she never went to secondary school, and she wants a better life for her daughter. In the evening, tired but happy, Ngozi opens her books by the light of a small lamp.''',
      questions: [
        QuestionEpreuve.vraiFaux('1', "Ngozi's father sells fish at the market.",
            vrai: false, points: 1, chapitre: 'anglais_a_ch3',
            corrige: r'''False: her father **catches** the fish at night; Ngozi and her mother **sell** it.'''),
        QuestionEpreuve.vraiFaux('2', "Ngozi wants to become a doctor.",
            vrai: true, points: 1, chapitre: 'anglais_a_ch3',
            corrige: r'''True: "If I study hard, I will become a doctor."'''),
        QuestionEpreuve.courte('3', "In which town is the market?",
            acceptees: ['Limbe', 'in Limbe'],
            points: 1,
            chapitre: 'anglais_a_ch3',
            corrige: r'''In **Limbe**.'''),
        QuestionEpreuve.qcm('4', "The word « dawn » means:",
            options: ['the beginning of the day', 'the middle of the night', 'the evening', 'a holiday'],
            bonne: 0,
            points: 1,
            chapitre: 'anglais_a_ch2',
            corrige: r'''**Dawn** = the first light of the day, sunrise.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Grammar',
      enonce: r'''Choose the correct answer.''',
      questions: [
        QuestionEpreuve.qcm('1', "If I ___ rich, I would build a school in my village.",
            options: ['were', 'am', 'will be', 'have been'],
            bonne: 0,
            points: 1,
            chapitre: 'anglais_a_ch1',
            corrige: r'''Second conditional: **if + past (were) … would + verb**.'''),
        QuestionEpreuve.qcm('2', "She has lived in Douala ___ 2015.",
            options: ['since', 'for', 'during', 'ago'],
            bonne: 0,
            points: 1,
            chapitre: 'anglais_a_ch1',
            corrige: r'''**Since** + a starting point (2015); **for** + a duration (for ten years).'''),
        QuestionEpreuve.qcm('3', "Passive voice: « They build a new bridge. » becomes:",
            options: ['A new bridge is built.', 'A new bridge built.', 'A new bridge was building.', 'A new bridge has build.'],
            bonne: 0,
            points: 1,
            chapitre: 'anglais_a_ch1',
            corrige: r'''Present simple passive: **is + past participle** → "A new bridge is built."'''),
        QuestionEpreuve.courte('4', "Give the past tense of « to teach ».",
            acceptees: ['taught'],
            points: 1,
            chapitre: 'anglais_a_ch1',
            corrige: r'''teach – **taught** – taught (irregular verb).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Essay writing',
      enonce: r'''**Topic.** "Education is the key to success." Do you agree? Write about 200 words.''',
      questions: [
        QuestionEpreuve.redaction('1', "Write your essay.",
            chapitre: 'anglais_a_ch4',
            bareme: [
              Critere("Clear introduction stating your opinion", 2),
              Critere("At least two well-developed arguments with examples", 4),
              Critere("Grammar, spelling and vocabulary", 3),
              Critere("Conclusion and linking words (firstly, moreover, however…)", 3),
            ],
            corrige: r'''## Sample plan
**Introduction**: education opens doors; I largely agree.

**Body 1**: education gives knowledge and skills for good jobs (doctors, engineers, teachers).
**Body 2**: it develops critical thinking and citizenship.
**Nuance**: success also needs hard work, opportunities and character; some succeed without diplomas.

**Conclusion**: education is *a* key — perhaps the most important one — but not the only one.

Useful words: *firstly, moreover, however, in conclusion, to sum up*.'''),
      ],
    ),
  ],
);
