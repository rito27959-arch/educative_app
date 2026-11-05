// Épreuves de SVTEEHB, séries D et C (format Office du Bac).

import 'modele.dart';

const _genetique = ExerciceEpreuve(
  titre: 'Génétique : transmission de deux caractères',
  enonce: r'''Chez le pois, on croise deux lignées pures : l'une à graines **lisses et jaunes**, l'autre à graines **ridées et vertes**. Toutes les graines de la génération F1 sont lisses et jaunes.

Les F1 sont ensuite croisées avec des plantes à graines ridées et vertes (croisement-test). On obtient :

```tableau
Phénotype | lisses jaunes | lisses vertes | ridées jaunes | ridées vertes
Nombre de graines | 251 | 248 | 253 | 249
```

On utilisera les symboles L/r (forme) et J/v (couleur).''',
  questions: [
    QuestionEpreuve.qcm('1', 'Pour la forme de la graine, l\'allèle dominant est :',
        options: ['lisse (L)', 'ridé (r)', 'aucun : codominance', 'on ne peut pas savoir'],
        bonne: 0,
        points: 1,
        chapitre: 'svt_ch1',
        corrige: r'''Les F1, issues de lignées pures, sont toutes lisses : le phénotype « ridé » est masqué, **lisse est dominant**.'''),
    QuestionEpreuve.qcm('2', 'Le croisement-test donne quatre phénotypes en proportions égales. On en conclut que :',
        options: ['les deux gènes sont indépendants', 'les deux gènes sont liés', 'il y a eu une mutation', 'les F1 sont homozygotes'],
        bonne: 0,
        points: 1,
        chapitre: 'svt_ch1',
        corrige: r'''Quatre phénotypes équiprobables (≈ 25 % chacun) : la F1 produit quatre types de gamètes équiprobables, ce qui traduit un **brassage interchromosomique** — gènes indépendants.'''),
    QuestionEpreuve.redaction('3', 'Interprète le croisement-test à l\'aide d\'un échiquier de croisement.',
        chapitre: 'svt_ch1',
        bareme: [
          Critere(r"Génotypes : F1 $\frac{L}{r}\frac{J}{v}$ et testeur $\frac{r}{r}\frac{v}{v}$", 0.5),
          Critere('Quatre gamètes F1 équiprobables : LJ, Lv, rJ, rv', 0.5),
          Critere('Échiquier correct et résultats 1/4 chacun', 1),
        ],
        corrige: r'''F1 : $\dfrac{L}{r}\,\dfrac{J}{v}$ ; testeur double récessif : $\dfrac{r}{r}\,\dfrac{v}{v}$, qui ne donne que des gamètes $rv$.

```tableau
Gamètes F1 → | LJ (¼) | Lv (¼) | rJ (¼) | rv (¼)
rv (testeur) | [L J] lisse jaune | [L v] lisse verte | [r J] ridée jaune | [r v] ridée verte
```

Les phénotypes des descendants reflètent directement les gamètes de la F1.'''),
    QuestionEpreuve.nombre('4', 'En croisant les F1 entre elles, quelle proportion de graines lisses et jaunes attend-on en F2 ? (fraction ou décimal)',
        valeur: 0.5625, tolerance: 0.005, points: 1, chapitre: 'svt_ch1',
        corrige: r'''Gènes indépendants : F2 en $\frac{9}{16}$, $\frac{3}{16}$, $\frac{3}{16}$, $\frac{1}{16}$. Les doubles dominants : $\frac{9}{16} = 0{,}5625$.'''),
    QuestionEpreuve.nombre('5', 'Et quelle proportion de graines ridées et vertes en F2 ?',
        valeur: 0.0625, tolerance: 0.005, points: 1, chapitre: 'svt_ch1',
        corrige: r'''Seul le double récessif $\frac{r}{r}\frac{v}{v}$ : $\frac14\times\frac14 = \frac{1}{16}$.'''),
    QuestionEpreuve.nombre('6', r"Le daltonisme est récessif, lié au chromosome X. Une femme conductrice ($X^DX^d$) et un homme non daltonien ($X^DY$) ont un garçon. Quelle est la probabilité qu'il soit daltonien ?",
        valeur: 0.5, tolerance: 0.001, points: 1, chapitre: 'svt_ch1',
        corrige: r'''Un garçon reçoit le $Y$ du père et l'un des deux $X$ de la mère : $X^d$ avec une probabilité $\frac12$.'''),
    QuestionEpreuve.nombre('7', 'Pour une fille de ce couple, quelle est la probabilité d\'être daltonienne ?',
        valeur: 0, tolerance: 0, points: 1, chapitre: 'svt_ch1',
        corrige: r'''Une fille reçoit $X^D$ de son père : elle est au pire conductrice ($X^DX^d$), jamais daltonienne. Probabilité : $0$.'''),
  ],
);

const _immunologie = ExerciceEpreuve(
  titre: 'Immunologie',
  enonce: r'''Le document ci-dessous montre l'évolution du taux d'anticorps anti-tétaniques chez une personne vaccinée (1ʳᵉ injection à $t = 0$, rappel à 8 semaines) :

```graphe
a(x) = 2e^(-((x-3)^2)/2) + 8e^(-((x-11)^2)/4) | violet
x: 0 .. 18
y: 0 .. 9
titre: anticorps (u.a.), temps en semaines
```''',
  questions: [
    QuestionEpreuve.qcm('1', 'Les anticorps sont produits par :',
        options: ['les plasmocytes', 'les lymphocytes T4', 'les macrophages', 'les globules rouges'],
        bonne: 0,
        points: 1,
        chapitre: 'svt_ch2',
        corrige: r'''Les lymphocytes B activés se différencient en **plasmocytes**, qui sécrètent les anticorps.'''),
    QuestionEpreuve.qcm('2', 'Après le rappel, la réponse est plus rapide et plus ample grâce :',
        options: ['aux cellules mémoire', 'aux globules rouges', 'au complément seul', 'à la fièvre'],
        bonne: 0,
        points: 1,
        chapitre: 'svt_ch2',
        corrige: r'''La première injection a formé des **lymphocytes mémoire** : la réponse secondaire est plus rapide, plus intense et plus durable.'''),
    QuestionEpreuve.courte('3', 'Quelles cellules le VIH infecte-t-il principalement ?',
        acceptees: ['LT4', 'lymphocytes T4', 'lymphocyte T4', 'T4', 'lymphocytes T CD4', 'LT CD4'],
        points: 1,
        chapitre: 'svt_ch2',
        corrige: r'''Les **lymphocytes T4** (porteurs du récepteur CD4), qui coordonnent la réponse immunitaire : leur destruction mène au SIDA.'''),
    QuestionEpreuve.redaction('4', 'Décris les étapes de la réponse immunitaire à médiation humorale.',
        chapitre: 'svt_ch2',
        bareme: [
          Critere('Reconnaissance de l\'antigène par les LB (sélection clonale)', 0.5),
          Critere('Activation par les LT4 (interleukines)', 0.5),
          Critere('Multiplication (amplification clonale) et différenciation en plasmocytes', 0.5),
          Critere('Production d\'anticorps, complexes immuns et élimination par phagocytose', 0.5),
        ],
        corrige: r'''1. **Induction** : l'antigène est reconnu par les lymphocytes B porteurs d'anticorps membranaires spécifiques (sélection clonale).
2. **Amplification** : activés par les interleukines des LT4, les LB se multiplient.
3. **Différenciation** : ils deviennent plasmocytes (et cellules mémoire).
4. **Effection** : les anticorps circulants neutralisent l'antigène (complexes immuns), éliminés par phagocytose.'''),
    QuestionEpreuve.qcm('5', 'La vaccination confère une immunité :',
        options: ['active et acquise', 'passive', 'innée', 'définitive dès la 1ʳᵉ injection'],
        bonne: 0,
        points: 1,
        chapitre: 'svt_ch2',
        corrige: r'''L'organisme fabrique lui-même ses anticorps et ses cellules mémoire : immunité **active**, **acquise** ; les rappels l'entretiennent.'''),
  ],
);

const epreuveSvtD = Epreuve(
  id: 'bac_d_svt_1',
  matiere: 'svt',
  serie: 'D',
  titre: 'SVTEEHB',
  dureeMinutes: 240,
  coefficient: 4,
  consignes: 'Lis attentivement les documents. Les réponses doivent être justifiées à partir des documents et de tes connaissances.',
  exercices: [
    _genetique,
    _immunologie,
    ExerciceEpreuve(
      titre: 'Neurophysiologie',
      enonce: r'''On enregistre l'activité électrique d'un axone géant de calmar. Une électrode réceptrice placée dans l'axone donne, au repos puis après une stimulation efficace :

```graphe
v(x) = -70 + 100e^(-((x-2)^2)/0.08) | rouge
x: 0 .. 5
y: -90 .. 45
titre: potentiel en mV, temps en ms
```

Deux électrodes réceptrices R₁ et R₂ sont distantes de $4\ \text{cm}$ ; le potentiel d'action arrive en R₂ avec un retard de $2\ \text{ms}$ sur R₁.''',
      questions: [
        QuestionEpreuve.nombre('1', 'Quelle est la valeur du potentiel de repos ?',
            valeur: -70, tolerance: 0.02, unite: 'mV', points: 1, chapitre: 'svt_ch7',
            corrige: r'''Avant la stimulation, la membrane est polarisée : $-70\ \text{mV}$ (intérieur négatif par rapport à l'extérieur).'''),
        QuestionEpreuve.nombre('2', 'Quelle est l\'amplitude du potentiel d\'action ?',
            valeur: 100, tolerance: 0.02, unite: 'mV', points: 1, chapitre: 'svt_ch7',
            corrige: r'''Le potentiel passe de $-70$ à $+30\ \text{mV}$ : amplitude de $100\ \text{mV}$.'''),
        QuestionEpreuve.nombre('3', 'Calcule la vitesse de propagation de l\'influx nerveux.',
            valeur: 20, tolerance: 0.01, unite: 'm/s', points: 1, chapitre: 'svt_ch7',
            corrige: r'''$v = \dfrac{d}{\Delta t} = \dfrac{0{,}04}{0{,}002} = 20\ \text{m·s}^{-1}$.'''),
        QuestionEpreuve.qcm('4', 'Si on augmente l\'intensité de la stimulation au-delà du seuil, l\'amplitude du potentiel d\'action d\'une fibre isolée :',
            options: ['reste la même (loi du tout ou rien)', 'augmente', 'diminue', 'devient nulle'],
            bonne: 0,
            points: 1,
            chapitre: 'svt_ch7',
            corrige: r'''Une fibre isolée obéit à la **loi du tout ou rien** : au-dessus du seuil, l'amplitude est constante ; c'est la fréquence des potentiels qui code l'intensité.'''),
        QuestionEpreuve.redaction('5', 'Explique la transmission du message nerveux au niveau d\'une synapse chimique.',
            chapitre: 'svt_ch7',
            bareme: [
              Critere('Arrivée du PA, entrée de Ca²⁺ et exocytose du neurotransmetteur', 0.75),
              Critere('Fixation sur les récepteurs postsynaptiques, ouverture de canaux', 0.75),
              Critere('Naissance d\'un potentiel postsynaptique, puis élimination du neurotransmetteur', 0.5),
            ],
            corrige: r'''1. Le potentiel d'action arrive dans la terminaison présynaptique : des ions $\text{Ca}^{2+}$ entrent.
2. Les vésicules libèrent le **neurotransmetteur** (ex. acétylcholine) dans la fente par exocytose.
3. Il se fixe sur des **récepteurs** de la membrane postsynaptique, ce qui ouvre des canaux ioniques : naissance d'un potentiel postsynaptique (excitateur ou inhibiteur).
4. Le neurotransmetteur est ensuite dégradé (acétylcholinestérase) ou recapté : le message est bref.'''),
      ],
    ),
  ],
);

const epreuveSvtC = Epreuve(
  id: 'bac_c_svt_1',
  matiere: 'svt_c',
  serie: 'C',
  titre: 'SVTEEHB',
  dureeMinutes: 120,
  coefficient: 2,
  consignes: 'Lis attentivement les documents. Justifie tes réponses.',
  exercices: [
    _genetique,
    _immunologie,
    ExerciceEpreuve(
      titre: 'Écologie : flux d\'énergie',
      enonce: r'''Dans une savane camerounaise, on a mesuré l'énergie (en kJ·m⁻²·an⁻¹) contenue à chaque niveau trophique :

```tableau
Niveau trophique | Producteurs (herbes) | Herbivores (antilopes) | Carnivores (lions)
Énergie | 20 000 | 2 000 | 150
```''',
      questions: [
        QuestionEpreuve.nombre('1', 'Calcule le rendement écologique entre producteurs et herbivores (en %).',
            valeur: 10, tolerance: 0.01, unite: '%', points: 1, chapitre: 'svt_c_ch3',
            corrige: r'''$R = \dfrac{2\,000}{20\,000}\times100 = 10\ \%$.'''),
        QuestionEpreuve.nombre('2', 'Calcule le rendement entre herbivores et carnivores (en %).',
            valeur: 7.5, tolerance: 0.01, unite: '%', points: 1, chapitre: 'svt_c_ch3',
            corrige: r'''$R = \dfrac{150}{2\,000}\times100 = 7{,}5\ \%$.'''),
        QuestionEpreuve.qcm('3', 'L\'énergie « perdue » d\'un niveau à l\'autre correspond surtout :',
            options: ['à la respiration et aux déchets non consommés', 'à la photosynthèse', 'à une erreur de mesure', 'à la reproduction seule'],
            bonne: 0,
            points: 1,
            chapitre: 'svt_c_ch3',
            corrige: r'''Une grande partie de l'énergie est dissipée sous forme de chaleur (respiration) ou reste dans la matière non consommée ou non assimilée (excréments, cadavres).'''),
        QuestionEpreuve.redaction('4', 'Explique pourquoi les chaînes alimentaires comptent rarement plus de 4 ou 5 maillons.',
            chapitre: 'svt_c_ch3',
            bareme: [
              Critere('Rendement d\'environ 10 % à chaque passage', 0.5),
              Critere('L\'énergie disponible devient trop faible pour un niveau supplémentaire', 0.5),
            ],
            corrige: r'''À chaque niveau, seule une petite fraction (souvent ≈ 10 %) de l'énergie est transmise au suivant. Après 4 ou 5 niveaux, l'énergie restante ne suffit plus à entretenir une population viable de consommateurs.'''),
        QuestionEpreuve.nombre('5', 'Avec un rendement de 10 %, quelle énergie serait disponible pour un 4ᵉ niveau (kJ·m⁻²·an⁻¹) ?',
            valeur: 15, tolerance: 0.01, points: 1, chapitre: 'svt_c_ch3',
            corrige: r'''$150\times0{,}10 = 15\ \text{kJ·m}^{-2}\text{·an}^{-1}$ : très peu pour nourrir un super-prédateur.'''),
        QuestionEpreuve.qcm('6', 'Une pyramide des énergies :',
            options: ['n\'est jamais renversée', 'peut être renversée', 'est toujours carrée', 'ne concerne que les végétaux'],
            bonne: 0,
            points: 1,
            chapitre: 'svt_c_ch3',
            corrige: r'''L'énergie ne peut que diminuer d'un niveau au suivant : la pyramide des énergies a toujours une base plus large que son sommet.'''),
      ],
    ),
  ],
);
