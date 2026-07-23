import 'lesson_content_model.dart';

final Map<String, LessonContent> bacCSvtContent = {
  // =========================================================================
  // Chapitre 1 — L\'ADN et son expression
  // =========================================================================

  'svt_c_ch1_l1': const LessonContent(
    introText:
        'L\'ADN (acide désoxyribonucléique) est la molécule porteuse de l\'information héréditaire '
        'chez la plupart des êtres vivants. Sa capacité à se répliquer fidèlement et à stocker '
        'les instructions de construction des protéines est au cœur de la biologie moléculaire.',
    lessonBody:
        'L\'ADN est un acide nucléique constitué de deux brins enroulés en double hélice. '
        'Chaque brin est un polymère de nucléotides. Un nucléotide est formé d\'un groupe phosphate, '
        'd\'un sucre (le désoxyribose) et d\'une base azotée. Il existe quatre bases azotées dans l\'ADN : '
        'l\'adénine (A), la guanine (G), la cytosine (C) et la thymine (T).\n\n'
        'Les deux brins sont complémentaires : l\'adénine s\'apparie toujours avec la thymine (A-T) '
        'et la guanine avec la cytosine (G-C), selon les règles de Chargaff. Ces appariements '
        'sont maintenus par des liaisons hydrogène : deux liaisons pour A-T et trois pour G-C. '
        'Les brins sont antiparallèles : l\'un est orienté dans le sens 5\' → 3\' et l\'autre '
        'dans le sens 3\' → 5\'.\n\n'
        'La réplication de l\'ADN est le processus par lequel une molécule d\'ADN produit deux '
        'molécules identiques. Elle est dite semi-conservative : chaque molécule fille contient '
        'un brin parent et un brin néoformé. La réplication commence à des séquences appelées '
        'origines de réplication. L\'hélicase déroule la double hélice, créant une fourche de réplication. '
        'L\'ADN polymérase III synthétise le brinLeader dans le sens 5\' → 3\' de façon continue, '
        'et le brin retardé (fragments d\'Okazaki) de façon discontinue. L\'ADN polymérase I remplace '
        'les amorces d\'ARN par de l\'ADN, puis l\'ADN ligase relie les fragments.\n\n'
        'La fidélité de la réplication est assurée par le système de correction (proofreading) '
        'de l\'ADN polymérase, qui vérifie chaque nucléotide ajouté. Le taux d\'erreur est d\'environ '
        'une mutation pour 10⁹ nucléotides répliqués.',
    example:
        'Exemple — Démarche de la réplication :\n\n'
        'Étape 1 : Reconnaissance de l\'origine de réplication\n'
        'L\'hélicase se fixe sur la séquence et déroule la double hélice.\n\n'
        'Étape 2 : Formation de la fourche\n'
        'Des protéines SSB stabilisent les brins séparés. La topoisomérase soulage la tension.\n\n'
        'Étape 3 : Synthèse du brin leader\n'
        'L\'ADN polymérase III lit le brin matrice dans le sens 3\' → 5\' et synthétise '
        'le brin nouveau dans le sens 5\' → 3\' de façon continue.\n\n'
        'Étape 4 : Synthèse du brin retardé\n'
        'L\'amorase pose des amorces d\'ARN sur le brin matrice. L\'ADN polymérase III synthétise '
        'des fragments d\'Okazaki (environ 1000-2000 nucléotides chez les bactéries).\n\n'
        'Étape 5 : Maturation\n'
        'L\'ADN polymérase I retire les amorces d\'ARN et les remplace par de l\'ADN. '
        'L\'ADN ligase relie les fragments par des liaisons phosphodiester.\n\n'
        'Résultat : deux molécules d\'ADN identiques, chacune constituée d\'un brin ancien '
        'et d\'un brin nouveau (réplication semi-conservative).',
    takeaways: [
      'L\'ADN est constitué de deux brins complémentaires (A-T, G-C) antiparallèles',
      'La réplication est semi-conservative et begin par les origines de réplication',
      'Le brin leader est synthétisé de façon continue, le brin retardé par fragments d\'Okazaki',
      'L\'ADN polymérase assure la synthèse et la correction (proofreading)',
    ],
  ),

  'svt_c_ch1_l2': const LessonContent(
    introText:
        'L\'expression des gènes est le processus par lequel l\'information codée dans l\'ADN '
        'est utilisée pour produire des protéines fonctionnelles. Ce processus comprend deux '
        'étapes majeures : la transcription (ADN → ARN) et la traduction (ARN → protéine).',
    lessonBody:
        'La transcription est la synthèse d\'une molécule d\'ARN messager (ARNm) à partir d\'un '
        'gène de l\'ADN. Elle est catalysée par l\'ARN polymérase. Chez les procaryotes, une seule '
        'ARN polymérase synthétise tous les ARN. Chez les eucaryotes, l\'ARN polymérase II transcrit '
        'les gènes codant des protéines. La transcription comprend trois étapes : l\'initiation '
        '(l\'ARN polymérase se fixe au promoteur), l\'élongation (synthèse de l\'ARNm dans le sens '
        '5\' → 3\') et la terminaison (arrêt de la transcription au site de terminaison).\n\n'
        'Chez les eucaryotes, l\'ARNm subit des modifications post-transcriptionnelles : ajout d\'une '
        'coiffe en 5\' (7-méthylguanosine), ajout d\'une queue poly(A) en 3\', et épissage (excision '
        'des introns, assemblage des exons). L\'ARNm mature quitte le noyau pour atteindre le ribosome.\n\n'
        'La traduction est la synthèse d\'une chaîne polypeptidique à partir de l\'ARNm. Elle a lieu '
        'sur les ribosomes, dans le cytoplasme. Le code génétique est constitué de codons (triplets '
        'de nucléotides). Il y a 64 codons dont 61 codent des acides aminés et 3 sont des codons '
        'stop (UAA, UAG, UGA). Le codon AUG code la méthionine et sert de codon d\'amorce (start).\n\n'
        'La traduction comprend trois étapes : l\'initiation (assemblage du complexe ribosomal sur '
        'le codon AUG), l\'élongation (ajout successif des acides aminés par les ARN de transfert) '
        'et la terminaison (arrivée à un codon stop, libération du polypeptide). Les ARNt transportent '
        'les acides aminés et portent un anticodon complémentaire du codon de l\'ARNm.',
    example:
        'Exemple — Démarche complète ADN → protéine :\n\n'
        'Séquence ADN (brin sens) : 5\'- ATG GCT TAA -3\'\n\n'
        'Étape 1 : Transcription\n'
        'L\'ARN polymérase lit le brin antisens (3\'-TAC CGA ATT-5\')\n'
        '→ ARNm : 5\'- AUG GCU UAA -3\'\n\n'
        'Étape 2 : Traduction\n'
        'Le ribosome lit l\'ARNm de 5\' vers 3\' :\n'
        '- AUG → codon start → méthionine (Met)\n'
        '- GCU → alanine (Ala)\n'
        '- UAA → codon stop → fin de la traduction\n\n'
        'Étape 3 : Résultat\n'
        'Polypeptide : Met-Ala (dipeptide)\n\n'
        'Note : si l\'on substitue le 3ᵉ nucléotide du deuxième codon :\n'
        'GCU → GCC, GCA ou GCG codent aussi l\'alanine (de-générescence du code). '
        'Cela montre que des mutations silencieuses sont possibles.',
    takeaways: [
      'La transcription (ADN → ARNm) est catalysée par l\'ARN polymérase',
      'Chez les eucaryotes, l\'ARNm subit coiffage, polyadénylation et épissage',
      'Le code génétique est constitué de codons (triplets de nucléotides)',
      'La traduction (ARNm → protéine) utilise les ARNt comme adaptateurs',
      'Le code est dégénéré : plusieurs codons peuvent coder le même acide aminé',
    ],
  ),

  'svt_c_ch1_l3': const LessonContent(
    introText:
        'L\'hérédité est la transmission des caractères d\'un individu à sa descendance. '
        'Gregor Mendel, au XIXᵉ siècle, a découvert les lois fondamentales de l\'héritage '
        'en étudiant la transmission de caractères chez le pois.',
    lessonBody:
        'Un gène est un segment d\'ADN codant pour un caractère héréditaire. Les gènes sont '
        'situés sur les chromosomes, au niveau de loci (positions fixes). Un individu diploïde '
        'possède deux allèles pour chaque gène, l\'un hérité du père, l\'autre de la mère. '
        'On dit qu\'il est homozygote (AA ou aa) ou hétérozygote (Aa) pour ce gène.\n\n'
        'La première loi de Mendel (loi de l\'uniformité) stipule que le croisement de deux '
        'homozygotes différents (AA × aa) produit une génération F1 entièrement hétérozygote (Aa), '
        'montrant tous le même phénotype. La deuxième loi (loi de la ségrégation) dit que lors de '
        'la formation des gamètes, les deux allèles d\'un couple se séparent et n\'entrent que un '
        'dans chaque gamète. La troisième loi (loi de l\'indépendance) concerne des gènes sur '
        'des chromosomes différents : les allèles de gènes différents se combinent de façon indépendante.\n\n'
        'La dominance complète : un allèle dominant (A) masque l\'effet de l\'allèle récessif (a) '
        'chez l\'hétérozygote (Aa). Le phénotype de Aa est identique à celui de AA. La dominance '
        'incomplète : les deux allèles s\'expriment partiellement (ex. : croisement de roses rouges '
        'et blanches → roses roses). La codominance : les deux allèles s\'expriment pleinement '
        '(ex. : groupe sanguin AB).\n\n'
        'Le phenotype est le résultat de l\'interaction entre le génotype et l\'environnement. '
        'Certaines maladies génétiques suivent un mode de transmission récessif (mucoviscidose, '
        'drépanocytose) ou dominant (maladie de Huntington, polykystose rénale). Le caryotype '
        'permet de visualiser les chromosomes et de détecter des anomalies numériques ou structurales.',
    example:
        'Exemple — Croisement monohybride (loi de la ségrégation) :\n\n'
        'P : AA (jaune) × aa (vert)\n'
        'Gamètes P : A et a\n\n'
        'F1 : 100 % Aa (jaune) — tous les individus montrent le phenotype dominant\n\n'
        'Croisement F1 × F1 : Aa × Aa\n'
        'Gamètes : A, a × A, a\n\n'
        'Tableau de Punnett :\n'
        '         A         a\n'
        'A     AA (jaune)  Aa (jaune)\n'
        'a     Aa (jaune)  aa (vert)\n\n'
        'F2 : 3 jaunes : 1 vert (rapport 3:1)\n\n'
        'Génotypes : 1/4 AA, 1/2 Aa, 1/4 aa\n'
        'Phénotypes : 3/4 jaune, 1/4 vert\n\n'
        'Vérification : si on étudie 200 plantes F2,\n'
        'on attend 150 jaunes et 50 verts, soit 75% et 25%.',
    takeaways: [
      'Un gène possède deux allèles situés au même locus sur les chromosomes homologues',
      'La loi de la ségrégation : les deux allèles se séparent lors de la méiose',
      'Le rapport phénotypique 3:1 en F2 caractérise la dominance complète',
      'Le phénotype résulte de l\'interaction génotype × environnement',
    ],
  ),

  // =========================================================================
  // Chapitre 2 — Évolution et biodiversité
  // =========================================================================

  'svt_c_ch2_l1': const LessonContent(
    introText:
        'La génétique des populations (génétique des pools) étudie la fréquence des allèles '
        'dans une population et les facteurs qui les modifient. L\'équilibre de Hardy-Weinberg '
        'fournit un modèle de référence pour analyser l\'évolution génétique.',
    lessonBody:
        'Un pool génétique est l\'ensemble des allèles présents dans une population pour un locus donné. '
        'Soit p la fréquence de l\'allèle A et q la fréquence de l\'allèle a, avec p + q = 1. '
        'Si la population est à l\'équilibre de Hardy-Weinberg, les fréquences génotypiques sont : '
        'AA : p², Aa : 2pq, aa : q², avec p² + 2pq + q² = 1.\n\n'
        'L\'équilibre de Hardy-Weinberg suppose cinq conditions idéales : population de grande taille, '
        'panmixie (accouplement aléatoire), aucune mutation, aucune sélection naturelle et aucune '
        'migration. Si l\'une de ces conditions n\'est pas respectée, les fréquences alléliques '
        'changent d\'une génération à l\'autre, ce qui constitue une évolution génétique.\n\n'
        'La dérive génétique est une fluctuation aléatoire des fréquences alléliques, particulièrement '
        'marquée dans les petites populations. Elle peut conduire à la fixation d\'un allèle et à la '
        'disparition de l\'autre. L\'effet fondateur se produit lorsqu\'une petite population colonise '
        'un nouveau territoire : la diversité génétique est réduite par rapport à la population d\'origine.\n\n'
        'Le brassage intrachromosomique (en crossing-over lors de la méiose) et le brassage '
        'interchromosomique (répartition aléatoire des chromosomes) augmentent la diversité génétique '
        'des gamètes. La combinaison de ces brassages avec la reproduction sexuée génère une grande '
        'diversité génétique au sein des populations.\n\n'
        'L\'index de diversité génétique mesure la variabilité d\'une population. Un indice élevé '
        'indique une forte diversité, ce qui renforce la capacité d\'adaptation de la population '
        'aux changements environnementaux.',
    example:
        'Exemple — Application de Hardy-Weinberg :\n\n'
        'Dans une population de 1000 individus, on observe 360 individus blancs et 640 roux.\n'
        'Le caractère roux est récessif (aa).\n\n'
        'Étape 1 : Calcul de q²\n'
        'q² = 640/1000 = 0,64\n\n'
        'Étape 2 : Calcul de q\n'
        'q = √0,64 = 0,8\n\n'
        'Étape 3 : Calcul de p\n'
        'p = 1 - q = 1 - 0,8 = 0,2\n\n'
        'Étape 4 : Fréquences génotypiques attendues\n'
        'AA = p² = (0,2)² = 0,04 → 40 individus\n'
        'Aa = 2pq = 2 × 0,2 × 0,8 = 0,32 → 320 individus\n'
        'aa = q² = 0,64 → 640 individus\n\n'
        'Étape 5 : Vérification\n'
        '40 + 320 + 640 = 1000 ✓\n\n'
        'Conclusion : 20 % de l\'allèle A et 80 % de l\'allèle a dans le pool génétique.',
    takeaways: [
      'p + q = 1 (fréquences alléliques) et p² + 2pq + q² = 1 (fréquences génotypiques)',
      'L\'équilibre de Hardy-Weinberg nécessite 5 conditions idéales',
      'La dérive génétique modifie les fréquences aléatoirement (surtout en petite population)',
      'Le brassage génétique (crossing-over + méiose) augmente la diversité',
    ],
  ),

  'svt_c_ch2_l2': const LessonContent(
    introText:
        'L\'évolution biologique est la modification des caractéristiques d\'une population '
        'au fil du temps. Théorisée par Darwin, elle repose sur la sélection naturelle, '
        'la dérive génétique et les mécanismes de spéciation.',
    lessonBody:
        'Charles Darwin et Alfred Russel Wallace ont proposé la théorie de l\'évolution par '
        'sélection naturelle. Le principe est le suivant : dans toute population, il existe '
        'une variation individuelle des caractères. Certains individus possèdent des caractères '
        'qui leur confèrent un avantage pour la survie et la reproduction dans un environnement '
        'donné. Ces individus auront plus de descendants, transmettant leurs caractères avantageux. '
        'Au fil des générations, les caractères favorables se fixent dans la population.\n\n'
        'La spéciation allopatrique se produit lorsque l\'isolement géographique sépare deux '
        'sous-populations. Sans échanges génétiques, des mutations et une sélection différente '
        'conduisent à la formation de deux espèces distinctes. La spéciation sympatrique se produit '
        'sans barrière géographique, par exemple par polyploïdie (doublage du nombre de chromosomes) '
        'chez les plantes.\n\n'
        'Les preuves de l\'évolution sont multiples : les fossiles montrent des formes transitionnelles '
        'entre groupes (ex. : Archaeopteryx entre reptiles et oiseaux), l\'anatomie comparée révèle '
        'des organes homologues (même structure, fonction différente) et vestigiaux (ex. : appendice '
        'vermiculaire chez l\'homme). L\'embryologie comparative montre des stades communs aux '
        'vertébrés. La biogéographie distribue les espèces en fonction de l\'histoire géologique. '
        'La biochimie comparée (ADN, protéines) fournit des preuves moléculaires de la parenté '
        'entre espèces.\n\n'
        'L\'évolution n\'est pas linéaire mais arborescente : les espèces actuelles descendent '
        'd\'ancêtres communs. Les cladogrammes (arbres phylogénétiques) représentent ces relations '
        'de parenté, fondées sur des caractères dérivés partagés.',
    example:
        'Exemple — Démarche de sélection naturelle :\n\n'
        'Population de papillons avant industrialisation :\n'
        '80 % de papillons clairs (camouflage sur lichen clair)\n'
        '20 % de papillons foncés (visibles par les oiseaux)\n\n'
        'Industrialisation : les troncs d\'arbres sont noircis par la pollution.\n\n'
        'Étape 1 : Pression de sélection\n'
        'Les papillons clairs sont désormais visibles sur les troncs noircis.\n'
        'Les oiseaux les capturent plus facilement.\n\n'
        'Étape 2 : Survie et reproduction\n'
        'Les papillons foncés survivent mieux et se reproduisent davantage.\n'
        'Leur descendance hérite de la couleur foncée.\n\n'
        'Étape 3 : Changement de fréquence\n'
        'Après plusieurs générations :\n'
        'Avant : 80 % clairs, 20 % foncés\n'
        'Après : 20 % clairs, 80 % foncés\n\n'
        'Étape 4 : Conclusion\n'
        'La fréquence de l\'allèle pour la couleur foncée a augmenté.\n'
        'C\'est un exemple de sélection directionnelle.',
    takeaways: [
      'La sélection naturelle agit sur la variation individuelle existante dans une population',
      'La spéciation allopatrique nécessite une barrière géographique',
      'Les preuves de l\'évolution : fossiles, anatomie, embryologie, biogéographie, biochimie',
      'Les arbres phylogénétiques représentent les relations de parenté entre espèces',
    ],
  ),

  // =========================================================================
  // Chapitre 3 — Dynamique interne de la Terre
  // =========================================================================

  'svt_c_ch3_l1': const LessonContent(
    introText:
        'La structure interne de la Terre résulte de sa différenciation en couches concentriques. '
        'L\'étude des ondes sismiques, les propriétés magnétiques et la densité nous permettent '
        'de comprendre la composition et le comportement de ces couches.',
    lessonBody:
        'La Terre est composée de trois grandes couches : la croûte, le manteau et le noyau. '
        'La croûte continentale (30-70 km d\'épaisseur) est composée de roches riches en silice '
        'et aluminium (roches feldspathiques, densité ~2,7). La croûte océanique (5-10 km) est '
        'plus mince, plus dense (densité ~3,0) et composée de roches basaltiques.\n\n'
        'Le manteau s\'étend de la base de la croûte (discontinuité de Mohorovičić) jusqu\'à '
        'environ 2 900 km de profondeur (discontinuité de Gutenberg). Il est constitué de roches '
        'silicatées riches en fer et magnésium (péridotite). Le manteau supérieur rigide et la '
        'croûte forment la lithosphère. Sous la lithosphère, l\'asthénosphère (entre ~100 et '
        '350 km) est partiellement fondue et se déforme plastiquement.\n\n'
        'Le noyau externe (liquide, 2 900 – 5 150 km) est composé de fer et nickel en fusion. '
        'Son mouvement de convection génère le champ magnétique terrestre (dynamo). Le noyau interne '
        '(solide, 5 150 – 6 371 km) est un cristal de fer-nickel à très haute pression et température.\n\n'
        'La chaleur interne de la Terre provient de trois sources : la chaleur résiduelle de '
        'l\'accrétion, la désintégration radioactive d\'éléments lourds (uranium, thorium, potassium) '
        'et la cristallisation du noyau. Cette chaleur se dissipe par conduction (à travers la croûte) '
        'et par convection (dans le manteau et le noyau). Les mouvements de convection dans le manteau '
        'sont le moteur de la tectonique des plaques.',
    example:
        'Exemple — Identification des couches par les ondes sismiques :\n\n'
        'Lors d\'un séisme, deux types d\'ondes se propagent :\n'
        '- Les ondes P (primaires) : se propagent dans les solides ET les liquides.\n'
        '- Les ondes S (secondaires) : ne se propagent que dans les solides.\n\n'
        'Observation :\n'
        'À l\'opposé du foyer (zone d\'ombre), les ondes S ne sont pas détectées.\n'
        '→ Le noyau externe est LIQUIDE (il bloque les ondes S).\n\n'
        'Les ondes P sont plus rapides dans le noyau interne → il est SOLIDE.\n\n'
        'Profondeurs des discontinuités :\n'
        'Mohorovičić (Moho) : ~35 km (croûte → manteau)\n'
        'Gutenberg : ~2 900 km (manteau → noyau externe)\n'
        'Lehmann : ~5 150 km (noyau externe → noyau interne)\n\n'
        'Conclusion : les ondes sismiques révèlent la structure interne de la Terre.',
    takeaways: [
      'La Terre est différenciée en croûte, manteau et noyau (externe liquide, interne solide)',
      'La lithosphère (croûte + manteau supérieur rigide) repose sur l\'asthénosphère plastique',
      'Les mouvements de convection dans le manteau sont le moteur de la tectonique des plaques',
      'Les ondes P et S permettent de déterminer l\'état (solide/liquide) des couches internes',
    ],
  ),

  'svt_c_ch3_l2': const LessonContent(
    introText:
        'La tectonique des plaques est le modèle unificateur de la géologie. '
        'Il explique la répartition des séismes, des volcans, la formation des montagnes '
        'et l\'évolution des bassins sédimentaires par le mouvement de fragments de lithosphère.',
    lessonBody:
        'La lithosphère terrestre est fragmentée en une dizaine de plaques rigides qui se déplacent '
        'les unes par rapport aux autres à une vitesse de quelques centimètres par an. Ce mouvement '
        'est rendu possible par la plasticité de l\'asthénosphère sous-jacente, entraînée par les '
        'courants de convection mantelliques.\n\n'
        'Les bords de plaques sont de trois types. Les bords divergents (rides médio-océaniques) '
        'sont des zones d\'étalement où de nouvelle croûte océanique se forme par magmatisme. '
        'L\'expansion océanique crée de nouveaux planchers océaniques qui s\'écartent de la ride. '
        'Les bords convergents sont des zones de subduction (une plaque plonge sous l\'autre '
        'dans le manteau, créant une fosse océanique et un arc volcanique) ou de collision '
        '(deux plaques continentales entrent en contact, formant une chaîne de montagnes comme '
        'l\'Himalaya). Les bords transformants sont des zones de cisaillement latéral où les plaques '
        'glissent l\'une le long de l\'autre (faille transformante).\n\n'
        'Les séismes et les volcans sont concentrés aux bords de plaques. Les séismes de subduction '
        'sont les plus puissants (jusqu\'à magnitude 9+) car la zone de contact est très étendue. '
        'Les volcans de subduction produisent des magmas visqueux et explosifs (andésitiques), '
        'tandis que les volcans de dorsale produisent des basaltes fluides.\n\n'
        'La continental drift (dérive des continents), proposé par Wegener en 1912, a été confirmé '
        'par les preuves de l\'expansion océanique (anomalies magnétiques symétriques autour des '
        'dorsales), la distribution des séismes et volcans, et la concordance des côtes et des '
        'fossiles entre continents autrefois réunis (Pangée).',
    example:
        'Exemple — Formation d\'une chaîne de montagnes par collision :\n\n'
        'Étape 1 : Subduction\n'
        'La plaque indo-australienne plonge sous la plaque eurasienne.\n'
        '→ Fosse océanique + arc volcanique + séismes de profondeur croissante.\n\n'
        'Étape 2 : Fermeture de l\'océan\n'
        'L\'océan Téthys se réduit progressivement.\n'
        'Les sédiments marins sont comprimés et plissés.\n\n'
        'Étape 3 : Collision continentale\n'
        'L\'Inde entre en collision avec l\'Eurasie (il y a ~50 Ma).\n'
        'Les croûtes continentales, trop légères pour plonger, se chevauchent.\n'
        '→ Plissement et soulèvement : naissance de l\'Himalaya.\n\n'
        'Étape 4 : Phénomènes associés\n'
        '- Séismes crustaux (jusqu\'à 700 km de profondeur)\n'
        '- Metamorphisme de collision (haute pression et température)\n'
        '- Soulèvement du plateau tibétain\n'
        '- L\'Inde continue de pousser vers le nord (~4 cm/an)\n\n'
        'Conclusion : la tectonique des plaques explique la formation des grandes chaînes.',
    takeaways: [
      'La lithosphère est fragmentée en plaques qui se déplacent sur l\'asthénosphère',
      'Bords divergents (dorsales), convergents (subduction/collision), transformants (cisaillement)',
      'Les séismes et volcans sont concentrés aux bords de plaques',
      'L\'Himalaya résulte de la collision entre la plaque indo-australienne et la plaque eurasienne',
    ],
  ),
};
