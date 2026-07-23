import 'lesson_content_model.dart';

final Map<String, LessonContent> bacCChimieContent = {
  'chimie_c_ch1_l1': LessonContent(
    introText:
        'La chimie acido-basique est au coeur de nombreux phénomènes naturels et industriels. '
        'Comprendre le couple acide-base et les définitions de Brønsted-Lowry et Lewis '
        'permet d\'analyser et de prévoir les réactions d\'échange de protons.',
    lessonBody:
        'Un acide est une espèce chimique capable de céder un proton (H⁺) lors d\'une réaction, '
        'tandis qu\'une base est capable d\'accepter un proton. Cette définition, proposée par '
        'Brønsted et Lowry en 1923, a révolutionné la compréhension des réactions acido-basiques.\n\n'
        'On définit un couple acide-base comme un ensemble de deux espèces chimiques qui ne '
        'diffèrent que par un proton : un acide et sa base conjuguée. Par exemple, l\'acide '
        'acétique (CH₃COOH) forme le couple CH₃COOH/CH₃COO⁻ avec sa base conjuguée, l\'ion '
        'acétate. Lorsqu\'un acide cède son proton, il se transforme en sa base conjuguée, et '
        'réciproquement.\n\n'
        'La théorie de Lewis élargit encore ces concepts : un acide de Lewis est une espèce '
        'capable d\'accepter un doublet d\'électrons, tandis qu\'une base de Lewis est capable '
        'de donner un doublet d\'électrons. Ainsi, BF₃ est un acide de Lewis car le bore '
        'possède un orbital vide, tandis que NH₃ est une base de Lewis grâce au doublet '
        'non liant de l\'azote.\n\n'
        'Le principe de réaction acido-basique s\'énonce simplement : une réaction acido-basique '
        'est un échange de proton(s) entre un acide et une base. L\'acide cède un proton à la '
        'base, qui le capture. Ce processus est toujours réversible et conduit à un équilibre '
        'dans le cas d\'acides et bases faibles.\n\n'
        'L\'amphotérisme désigne la capacité d\'une espèce à jouer le rôle d\'acide ou de base '
        'selon le partenaire auquel elle réagit. L\'eau (H₂O) est l\'exemple classique : elle '
        'agit comme base avec HCl (qui est un acide fort) et comme acide avec NH₃ (qui est une '
        'base faible). De même, l\'ion hydrogénocarbonate (HCO₃⁻) peut céder ou accepter un '
        'proton selon les conditions.\n\n'
        'Enfin, l\'ion hydronium (H₃O⁺) est l\'espèce qui représente les protons en solution '
        'aqueuse. Quand on dit qu\'une solution contient des ions H⁺, il s\'agit en réalité '
        'd\'ions H₃O⁺, car le proton se solvate immédiatement par interaction avec les '
        'molécules d\'eau environnantes.',
    example:
        'Identifier les couples acide-base dans la réaction :\n'
        'CH₃COOH + H₂O ⇌ CH₃COO⁻ + H₃O⁺\n\n'
        'Étape 1 : Identifier les acides (celui qui cède un proton).\n'
        '→ CH₃COOH cède un proton : c\'est l\'acide du couple CH₃COOH/CH₃COO⁻.\n'
        '→ H₂O cède un proton (vers la réaction inverse) : c\'est l\'acide du couple H₃O⁺/H₂O.\n\n'
        'Étape 2 : Identifier les bases (celles qui acceptent un proton).\n'
        '→ H₂O accepte un proton : c\'est la base du couple H₃O⁺/H₂O.\n'
        '→ CH₃COO⁻ accepte un proton (réaction inverse) : c\'est la base du couple CH₃COOH/CH₃COO⁻.\n\n'
        'Étape 3 : Vérifier la cohérence.\n'
        'L\'acide CH₃COOH est plus fort que H₃O⁺ ? Non, H₃O⁺ est plus fort. '
        'La réaction va donc se déplacer vers la gauche, ce qui confirme que CH₃COOH '
        'est un acide faible.',
    takeaways: [
      'Un acide Brønsted-Lowry cède un proton ; une base l\'accepte.',
      'Un couple acide-base est formé d\'une espèce et de sa conjuguée (différant d\'un H⁺).',
      'L\'eau est amphotère : elle joue le rôle d\'acide ou de base selon le partenaire.',
      'L\'ion hydronium (H₃O⁺) représente les protons en solution aqueuse.',
    ],
  ),

  'chimie_c_ch1_l2': LessonContent(
    introText:
        'Le pH est l\'indicateur fondamental de l\'acidité ou de la basicité d\'une solution. '
        'Comprendre les échelles pH et pKa, ainsi que leur relation mathématique, '
        'permet de quantifier précisément le comportement des acides et bases faibles.',
    lessonBody:
        'Le pH est défini comme le logarithme décimal négatif de la concentration en ions '
        'hydrogène (H₃O⁺) dans une solution aqueuse : pH = -log[H₃O⁺]. Une solution est '
        'neutre à 25 °C quand pH = 7, acide quand pH < 7, et basique (alcaline) quand pH > 7.\n\n'
        'L\'échelle pH va généralement de 0 à 14, mais des valeurs extrêmes sont possibles. '
        'Chaque unité de pH correspond à un facteur 10 en concentration d\'ions H⁺. Une '
        'solution de pH 3 est donc 10 fois plus acide qu\'une solution de pH 4, et 100 fois '
        'plus acide qu\'une solution de pH 5.\n\n'
        'Le pKa est le logarithme décimal négatif de la constante d\'acidité Ka d\'un acide '
        'faible : pKa = -log(Ka). La constante Ka caractérise la force d\'un acide dans '
        'l\'eau : plus Ka est grand, plus l\'acide est fort. Plus pKa est petit, plus '
        'l\'acide est fort.\n\n'
        'La relation fondamentale reliant pH et pKa est donnée par l\'équation de Henderson-'
        'Hasselbalch : pH = pKa + log([A⁻]/[HA]), où [A⁻] est la concentration de la base '
        'conjuguée et [HA] la concentration de l\'acide non dissocié. Cette équation est '
        'indispensable pour calculer le pH des solutions tampons.\n\n'
        'Une solution tampon est un mélange d\'un acide faible et de sa base conjuguée (ou '
        'inversement) qui résiste aux variations de pH lorsqu\'on y ajoute de petites '
        'quantités d\'acide ou de base. Le pH d\'une solution tampon est maximal quand '
        '[A⁻] = [HA], c\'est-à-dire quand pH = pKa.\n\n'
        'Le rendement de dissociation α d\'un acide faible indique la fraction de molécules '
        'qui ont cédé leur proton : α = [A⁻]/([HA] + [A⁻]). Pour un acide faible, α est '
        'très petit ; pour un acide fort, α ≈ 1. Le pH d\'une solution d\'acide faible de '
        'concentration C et de rendement α vaut : pH = -log(C × α).\n\n'
        'En pratique, on détermine le pH d\'une solution par des méthodes expérimentales : '
        'indicateurs colorés, pH-mètre, ou calcul à partir de Ka et de la concentration.',
    example:
        'Calculer le pH d\'une solution d\'acide acétique 0,1 mol/L (Ka = 1,8 × 10⁻⁵).\n\n'
        'Étape 1 : Écrire l\'équation d\'équilibre.\n'
        'CH₃COOH ⇌ CH₃COO⁻ + H⁺\n\n'
        'Étape 2 : Exprimer Ka.\n'
        'Ka = [CH₃COO⁻][H⁺] / [CH₃COOH]\n'
        'Si α est le rendement de dissociation : Ka = Cα²/(1 - α)\n\n'
        'Étape 3 : Approximation (acide faible, α << 1).\n'
        'Ka ≈ Cα² → α² = Ka/C = 1,8 × 10⁻⁵ / 0,1 = 1,8 × 10⁻⁴\n'
        'α = √(1,8 × 10⁻⁴) ≈ 0,0134\n\n'
        'Étape 4 : Calculer la concentration en H⁺.\n'
        '[H⁺] = Cα = 0,1 × 0,0134 = 1,34 × 10⁻³ mol/L\n\n'
        'Étape 5 : Calculer le pH.\n'
        'pH = -log(1,34 × 10⁻³) = 3 - log(1,34) ≈ 3 - 0,13 ≈ 2,87',
    takeaways: [
      'pH = -log[H₃O⁺] : chaque unité de pH correspond à un facteur 10.',
      'pKa = -log(Ka) : plus pKa est petit, plus l\'acide est fort.',
      'Henderson-Hasselbalch : pH = pKa + log([A⁻]/[HA]) pour les solutions tampons.',
      'Le rendement de dissociation α mesure la fraction d\'acide dissocié.',
      'Pour un acide faible, l\'approximation α << 1 simplifie les calculs.',
    ],
  ),

  'chimie_c_ch1_l3': LessonContent(
    introText:
        'Les dosages acido-basiques permettent de déterminer la concentration inconnue '
        'd\'un acide ou d\'une base par réaction avec un réactif de concentration connue. '
        'Le choix de l\'indicateur et l\'interprétation du pH sont essentiels pour la précision du dosage.',
    lessonBody:
        'Un dosage acido-basique consiste à ajouter progressivement une solution de '
        'concentration connue (le titrant) à une solution de volume connu mais de concentration '
        'inconnue (l\'analyte) jusqu\'à atteindre l\'équivalence, le point où les quantités '
        'de matière d\'acide et de base sont stoœchiométriquement égales.\n\n'
        'Il existe deux types principaux de dosages : le dosage d\'un acide fort par une base '
        'forte, et le dosage d\'un acide faible par une base forte (ou inversement). Le choix '
        'de l\'indicateur pH dépend du type de dosage.\n\n'
        'L\'équivalence est le point théorique où la réaction est complète : n(acide) = n(base) '
        'selon la stoœchiométrie. Le virage est la variation brutale du pH autour de '
        'l\'équivalence. Le domaine de virage est la plage de pH sur laquelle l\'indicateur '
        'change de couleur. Le point de virage est la valeur de pH au milieu du domaine de '
        'virage.\n\n'
        'L\'eau faiblement ionisée (ionisation de l\'eau : H₂O ⇌ H⁺ + OH⁻ avec Kw = 10⁻¹⁴ à '
        '25 °C) joue un rôle fondamental dans ces dosages car elle définit la neutrality '
        '(pH = 7 à 25 °C) et influence le pH des solutions.\n\n'
        'Pour le dosage d\'un acide fort par une base forte, le pH à l\'équivalence est 7 '
        '(à 25 °C). On utilise un indicateur qui vire dans cette plage, comme le bleu de '
        'bromothymol (pH 6,0 - 7,6).\n\n'
        'Pour le dosage d\'un acide faible par une base forte, le pH à l\'équivalence est '
        'supérieur à 7 car la base conjuguée formée hydrolyse l\'eau. On utilise un '
        'indicateur virement dans la zone basique, comme la phénolphtaléine (pH 8,2 - 10,0).\n\n'
        'Le dosage d\'une base faible par un acide fort donne un pH d\'équivalence inférieur '
        'à 7. Le méthyl orange (pH 3,1 - 4,4) convient bien.\n\n'
        'L\'exactitude du dosage dépend de la précision des mesures de volume (burette '
        'graduée), de la pureté du titrant, et du bon choix de l\'indicateur. Les erreurs '
        'courantes incluent le dépassement du volume d\'équivalence et le choix inadapté '
        'de l\'indicateur.',
    example:
        'Dosage de 25,0 mL d\'acide chlorhydrique (HCl) par une solution de NaOH 0,100 mol/L.\n'
        'Volume de NaOH à l\'équivalence : 22,5 mL.\n\n'
        'Étape 1 : Écrire la réaction.\n'
        'HCl + NaOH → NaCl + H₂O\n'
        'Stoœchiométrie 1:1.\n\n'
        'Étape 2 : Calculer n(NaOH) à l\'équivalence.\n'
        'n(NaOH) = C × V = 0,100 × 22,5 × 10⁻³ = 2,25 × 10⁻³ mol\n\n'
        'Étape 3 : En déduire n(HCl).\n'
        'n(HCl) = n(NaOH) = 2,25 × 10⁻³ mol\n\n'
        'Étape 4 : Calculer la concentration de HCl.\n'
        'C(HCl) = n/V = 2,25 × 10⁻³ / (25,0 × 10⁻³) = 0,0900 mol/L\n\n'
        'Vérification : le pH de départ était ~1 (acide fort, 0,09 mol/L), '
        'et le pH à l\'équivalence est 7 (dosage acide fort / base forte).',
    takeaways: [
      'Le dosage acido-basique repose sur n(acide) = n(base) à l\'équivalence.',
      'Le choix de l\'indicateur dépend du pH à l\'équivalence (acide/base fort ou faible).',
      'Le virage est la variation brutale du pH autour de l\'équivalence.',
      'Une burette graduée précise est indispensable pour un dosage exact.',
    ],
  ),

  'chimie_c_ch2_l1': LessonContent(
    introText:
        'Les réactions d\'oxydo-réduction (redox) impliquent un transfert d\'électrons '
        'entre les espèces chimiques. Elles sont à la base du fonctionnement des piles, '
        'de l\'électrolyse et de nombreux processus industriels.',
    lessonBody:
        'Une réaction redox est une réaction au cours de laquelle il y a transfert d\'électrons '
        'entre un agent réducteur (qui s\'oxyde, c\'est-à-dire cède des électrons) et un agent '
        'oxydant (qui se réduit, c\'est-à-dire capture des électrons). On dit qu\'une espèce '
        's\'oxyde quand elle perd des électrons (son nombre d\'oxydation augmente) et qu\'une '
        'espèce se réduit quand elle gagne des électrons (son nombre d\'oxydation diminue).\n\n'
        'Les nombres d\'oxydation (état d\'oxydation) sont attribués à chaque atome dans une '
        'molécule selon des règles précises. Les principes sont : l\'état d\'oxydation d\'un '
        'atome libre est 0 ; celui d\'un ion monoatomique est égal à sa charge ; l\'oxygène est '
        'généralement -2 (sauf dans les peroxydes où il est -1) ; l\'hydrogène est +1 avec les '
        'métaux et -1 avec les non-métaux ; la somme des états d\'oxydation dans une molécule '
        'neutre est nulle.\n\n'
        'Le bilan complet d\'une réaction redox s\'écrit en séparant les demi-réactions '
        'd\'oxydation et de réduction. Le nombre d\'électrons perdus par l\'agent réducteur '
        'doit être égal au nombre d\'électrons gagnés par l\'agent oxydant.\n\n'
        'Le couple redox est noté Oxydant/Réducteur. Par exemple, Fe³⁺/Fe²⁺, Zn²⁺/Zn, '
        'ou Cu²⁺/Cu. Chaque couple possède un potentiel standard E° (en volts) mesuré par '
        'rapport à l\'électrode standard d\'hydrogène (E° = 0 V).\n\n'
        'La réaction globale est spontanée quand le potentiel de la réaction E°(réaction) > 0, '
        'ce qui correspond à une variation d\'énergie libre négative (ΔG° < 0). '
        'E°(réaction) = E°(oxydant) - E°(réducteur) avec les conventions de signe appropriées.\n\n'
        'Les applications sont innombrables : production d\'énergie (piles à combustible), '
        'corrosion des métaux (oxydation du fer), traitement des eaux, soudure, et '
        'l\'électrométallurgie.',
    example:
        'Bilans d\'oxydation et de réduction pour la réaction :\n'
        'Zn(s) + Cu²⁺(aq) → Zn²⁺(aq) + Cu(s)\n\n'
        'Étape 1 : Déterminer les états d\'oxydation.\n'
        'Zn(s) : état d\'oxydation = 0\n'
        'Cu²⁺(aq) : état d\'oxydation = +2\n'
        'Zn²⁺(aq) : état d\'oxydation = +2\n'
        'Cu(s) : état d\'oxydation = 0\n\n'
        'Étape 2 : Identifier les transformations.\n'
        'Zn : 0 → +2 (oxydation, perte de 2 électrons)\n'
        'Cu : +2 → 0 (réduction, gain de 2 électrons)\n\n'
        'Étape 3 : Écrire les demi-réactions.\n'
        'Oxydation : Zn(s) → Zn²⁺(aq) + 2e⁻\n'
        'Réduction : Cu²⁺(aq) + 2e⁻ → Cu(s)\n\n'
        'Étape 4 : Vérifier l\'équilibre électronique.\n'
        '2 électrons perdus = 2 électrons gagnés ✓\n\n'
        'Étape 5 : Calculer E°(réaction).\n'
        'E°(Zn²⁺/Zn) = -0,76 V (réducteur)\n'
        'E°(Cu²⁺/Cu) = +0,34 V (oxydant)\n'
        'E°(réaction) = +0,34 - (-0,76) = +1,10 V > 0 → spontanée ✓',
    takeaways: [
      'L\'oxydation est la perte d\'électrons ; la réduction en est le gain.',
      'Les nombres d\'oxydation suivent des règles précises pour chaque atome.',
      'Le bilan redox s\'écrit en séparant les demi-réactions d\'oxydation et de réduction.',
      'E°(réaction) > 0 implique une réaction spontanée (ΔG° < 0).',
    ],
  ),

  'chimie_c_ch2_l2': LessonContent(
    introText:
        'Les piles électrochimiques convertissent l\'énergie chimique en énergie électrique '
        'grâce à des réactions redox spontanées. Comprendre leur fonctionnement et calculer '
        'leurs caractéristiques est essentiel en électrochimie.',
    lessonBody:
        'Une pile est un dispositif qui transforme l\'énergie chimique en énergie électrique '
        'grâce à une réaction redox séparée en deux demi-réactions dans deux compartiments '
        'distincts, reliés par un circuit externe et un pont salin.\n\n'
        'Une pile est composée de deux demi-éléments : chaque demi-élément comprend une '
        'électrode (conducteur métallique) et une solution contenant les ions du couple redox '
        'correspondant. L\'anode est l\'électrode où se produit l\'oxydation (électrode négative '
        'dans une pile galvanique). La cathode est l\'électrode où se produit la réduction '
        '(électrode positive).\n\n'
        'Le potentiel de pile E est donné par la différence de potentiel entre les deux '
        'électrodes : E = E(cathode) - E(anode). Le potentiel standard E° se mesure dans les '
        'conditions standard : température 25 °C, pression 1 bar, concentrations 1 mol/L.\n\n'
        'La force électromotrice (f.é.m.) est la différence de potentiel maximale que peut '
        'fournir la pile quand aucun courant ne circule. Elle est égale au potentiel de la '
        'pile quand elle est en circuit ouvert.\n\n'
        'L\'énergie de la pile est liée à l\'enthalpie libre : ΔG = -nFE, où n est le nombre '
        'd\'électrons échangés, F est la constante de Faraday (F ≈ 96 485 C/mol), et E le '
        'potentiel de la pile. Si ΔG < 0, la pile fonctionne de manière spontanée.\n\n'
        'Le diagramme de tension caractérise une pile : on trace E en fonction de l\'intensité '
        'du courant I. La f.é.m. correspond au point où I = 0. La tension de court-circuit '
        '(E = 0) donne le courant maximal. La puissance maximale est obtenue quand E = f.é.m./2.\n\n'
        'Une pile rechargeable (accumulateur) peut fonctionner dans les deux sens : en '
        'décharge, elle produit de l\'énergie ; en charge, l\'énergie électrique est convertie '
        'en énergie chimique inversement.',
    example:
        'Calculer la f.é.m. de la pile Daniel : Zn/Zn²⁺(1 mol/L)//Cu²⁺(1 mol/L)/Cu\n\n'
        'Étape 1 : Identifier les demi-réactions.\n'
        'Anode (oxydation) : Zn(s) → Zn²⁺(aq) + 2e⁻\n'
        'Cathode (réduction) : Cu²⁺(aq) + 2e⁻ → Cu(s)\n\n'
        'Étape 2 : Consulter les potentiels standard.\n'
        'E°(Zn²⁺/Zn) = -0,76 V\n'
        'E°(Cu²⁺/Cu) = +0,34 V\n\n'
        'Étape 3 : Calculer la f.é.m.\n'
        'f.é.m. = E°(cathode) - E°(anode) = +0,34 - (-0,76) = +1,10 V\n\n'
        'Étape 4 : Vérifier la spontanéité.\n'
        'ΔG° = -nFE° = -2 × 96 485 × 1,10 = -212 267 J/mol ≈ -212 kJ/mol\n'
        'ΔG° < 0 : la réaction est spontanée, la pile fonctionne ✓\n\n'
        'La f.é.m. de la pile Daniel est donc de 1,10 V dans les conditions standard.',
    takeaways: [
      'L\'anode est où se produit l\'oxydation ; la cathode où se produit la réduction.',
      'La f.é.m. = E(cathode) - E(anode) en conditions standard.',
      'ΔG = -nFE lie l\'énergie libre au potentiel de la pile.',
      'Une pile rechargeable peut fonctionner en charge et en décharge.',
    ],
  ),

  'chimie_c_ch2_l3': LessonContent(
    introText:
        'L\'électrolyse est le processus inverse d\'une pile : on impose un courant électrique '
        'pour provoquer une réaction chimique non spontanée. Elle est utilisée pour extraire '
        'des métaux, déposer des revêtements et produire des gaz.',
    lessonBody:
        'L\'électrolyse consiste à faire passer un courant continu à travers un conducteur '
        'ionique (électrolyte) pour provoquer des réactions d\'oxydo-réduction aux électrodes. '
        'Contrairement à la pile, la réaction globale n\'est pas spontanée : c\'est l\'énergie '
        'électrique fournie qui force la réaction.\n\n'
        'On distingue deux types d\'électrolyse : l\'électrolyse de l\'eau (ou d\'une solution) '
        'et l\'électrolyse de sels fondus (pour l\'extraction de métaux comme l\'aluminium). '
        'Dans l\'électrolyse de l\'eau, l\'oxygène est produit à l\'anode (oxydation de H₂O) '
        'et l\'hydrogène à la cathode (réduction de H⁺).\n\n'
        'La loi de Faraday établit que la quantité de matière.transformée à une électrode est '
        'proportionnelle à la quantité d\'électricité fournie : n = Q/(zF), où Q est la charge '
        'en coulombs, z le nombre d\'électrons échangés par atome ou molécule, et F la constante '
        'de Faraday.\n\n'
        'Le rendement de Faraday η est le rapport entre la quantité de matière réellement '
        'produite et la quantité théorique : η = n(réel)/n(théorique) × 100 %. Des réactions '
        'parasites ou des fuites de courant réduisent ce rendement.\n\n'
        'L\'énergie nécessaire à l\'électrolyse est : W = U × Q = U × n × z × F, où U est la '
        'tension appliquée. Cette tension doit dépasser la tension de décomposition (f.é.m. '
        'inverse) pour que la réaction se produise.\n\n'
        'L\'électrolyse de sels fondus permet d\'extraire des métaux réactifs comme l\'aluminium '
        '(procédé Hall-Héroult). Le fluor est produit par électrolyse de HF fondu. Le chlore '
        'et la soude caustique (NaOH) sont obtenus par électrolyse de NaCl en solution (procédé '
        'chlor-alkali).',
    example:
        'Électrolyse de l\'eau : quelle quantité d\'hydrogène est produite quand on fait '
        'passer un courant de 2,0 A pendant 10 minutes ?\n\n'
        'Étape 1 : Identifier la demi-réaction à la cathode.\n'
        '2H₂O(l) + 2e⁻ → H₂(g) + 2OH⁻(aq)\n'
        'z = 2 électrons par molécule de H₂.\n\n'
        'Étape 2 : Calculer la charge Q.\n'
        'Q = I × t = 2,0 × (10 × 60) = 1 200 C\n\n'
        'Étape 3 : Appliquer la loi de Faraday.\n'
        'n(H₂) = Q / (z × F) = 1 200 / (2 × 96 485) = 6,22 × 10⁻³ mol\n\n'
        'Étape 4 : Convertir en volume (conditions normales, 22,4 L/mol).\n'
        'V(H₂) = n × 22,4 = 6,22 × 10⁻³ × 22,4 ≈ 0,14 L = 140 mL\n\n'
        'Étape 5 : Vérifier la cohérence.\n'
        'Le volume d\'oxygène produit serait la moitié (≈ 70 mL), ce qui est cohérent '
        'avec la réaction globale 2H₂O → 2H₂ + O₂.',
    takeaways: [
      'L\'électrolyse provoque une réaction non spontanée par un courant imposé.',
      'La loi de Faraday : n = Q/(zF) relie la matière produite à la charge électrique.',
      'Le rendement de Faraday mesure l\'efficacité réelle par rapport à la théorie.',
      'L\'énergie consommée est W = U × Q, où U doit dépasser la tension de décomposition.',
      'L\'électrolyse de sels fondus permet l\'extraction de métaux réactifs.',
    ],
  ),

  'chimie_c_ch3_l1': LessonContent(
    introText:
        'Les hydrocarbures sont les composés organiques les plus simples, constitués uniquement '
        'de carbone et d\'hydrogène. Ils constituent la base de la chimie organique et sont les '
        'principaux composants des combustibles fossiles.',
    lessonBody:
        'Les hydrocarbures sont des composés organiques ne contenant que du carbone et de '
        'l\'hydrogène. On les classe en plusieurs familles selon la nature des liaisons '
        'entre les atomes de carbone.\n\n'
        'Les alcanes sont des hydrocarbures saturés, ne contenant que des liaisons simples '
        'C-C et C-H. Leur formule générale est CₙH₂ₙ₊₂. Ils sont dits saturés car ils '
        'contiennent le maximum d\'hydrogène possible. Les plus simples sont le méthane '
        '(CH₄), l\'éthane (C₂H₆), le propane (C₃H₈) et le butane (C₄H₁₀). Les alcanes '
        'sont les composants principaux du gaz naturel.\n\n'
        'Les alcènes sont des hydrocarbures insaturés possédant au moins une double liaison '
        'C=C. Leur formule générale est CₙH₂ₙ. L\'éthylène (CH₂=CH₂) est le plus simple. '
        'Les alcènes sont très réactifs grâce à leur double liaison, qui peut subir des '
        'additions (hydrogénation, halogénation, hydratation).\n\n'
        'Les alcynes possèdent au moins une triple liaison C≡C. Leur formule générale est '
        'CₙH₂ₙ₋₂. L\'acétylène (HC≡CH) est le plus simple et est utilisé en soudage.\n\n'
        'Les hydrocarbures aromatiques contiennent au moins un cycle benzénique. Le benzène '
        '(C₆H₆) est le représentant type. Les liaisons dans le noyau benzénique sont '
        'd\'égale longueur, intermédiaires entre simples et doubles, ce qui confère une grande '
        'stabilité.\n\n'
        'La nomenclature IUPAC permet de nommer systématiquement chaque hydrocarbure. On '
        'identifie la chaîne principale, on numberote pour donner les substituants les '
        'positions les plus basses, puis on assemble le nom.\n\n'
        'Les hydrocarbures sont principalement utilisés comme combustibles (essence, gazole, '
        'gaz), comme matières premières pétrochimiques (production de plastiques, solvants) '
        'et comme sources d\'énergie dans les moteurs à combustion interne.',
    example:
        'Nommer selon la nomenclature IUPAC : CH₃-CH₂-CH(CH₃)-CH₂-CH₃\n\n'
        'Étape 1 : Identifier la chaîne principale.\n'
        'La plus longue chaîne continue de carbones est 5 atomes : penta-\n\n'
        'Étape 2 : Numberoter la chaîne.\n'
        'En donnant le numéro le plus bas au substituant :\n'
        'C¹H₃-C²H₂-C³H(CH₃)-C⁴H₂-C⁵H₃\n'
        'Le méthyle (-CH₃) est en position 3.\n\n'
        'Étape 3 : Assembler le nom.\n'
        '3-méthylpentane\n\n'
        'Vérification : la chaîne principale pentane (5 carbones) avec un groupe méthyle '
        'en position 3 est correcte. Le nom est 3-méthylpentane.\n\n'
        'Formule moléculaire : C₆H₁₄ (6 carbones, 14 hydrogènes, '
        'soit C₆H₂₍₆₎₊₂ = C₆H₁₄, un alcane saturé).',
    takeaways: [
      'Les alcanes (saturés) : CₙH₂ₙ₊₂, ne contiennent que des liaisons simples.',
      'Les alcènes (insaturés) : CₙH₂ₙ, contiennent au moins une double liaison.',
      'Les alcynes : CₙH₂ₙ₋₂, contiennent au moins une triple liaison.',
      'Le benzène et les composés aromatiques sont particulièrement stables.',
      'La nomenclature IUPAC identifie la chaîne principale et numberote les substituants.',
    ],
  ),

  'chimie_c_ch3_l2': LessonContent(
    introText:
        'Les fonctions oxygénées regroupent les composés organiques contenant de l\'oxygène, '
        'tels que les alcools, aldéhydes, cétones, acides carboxyliques et esters. '
        'Chaque fonction possède des propriétés réactionnelles spécifiques.',
    lessonBody:
        'Les fonctions oxygénées sont des familles de composés organiques caractérisés par '
        'un groupe fonctionnel contenant un ou plusieurs atomes d\'oxygène. Chaque fonction '
        'détermine les propriétés chimiques et physiques du composé.\n\n'
        'Les alcools contiennent un groupe hydroxyle (-OH) lié à un atome de carbone saturé. '
        'On les classe en monoalcools, dialcools ou polyalcools selon le nombre de groupes OH. '
        'Les alcools primaires (R-CH₂OH) s\'oxydent en aldéhydes puis en acides carboxyliques. '
        'Les alcools secondaires (R₂CHOH) s\'oxydent en cétones. Les alcools tertiaires '
        '(R₃COH) résistent à l\'oxydation.\n\n'
        'Les aldéhydes possèdent un groupe formyle (-CHO) en bout de chaîne. Le formaldéhyde '
        '(HCHO) et l\'acétaldéhyde (CH₃CHO) sont les plus courants. Les aldéhydes s\'oxydent '
        'facilement en acides carboxyliques.\n\n'
        'Les cétones contiennent un groupe carbonyle (C=O) au milieu de la chaîne carbonée. '
        'L\'acétone (CH₃COCH₃) est la plus simple. Les cétones sont moins oxydables que les '
        'aldéhydes.\n\n'
        'Les acides carboxyliques possèdent le groupe carboxyle (-COOH). L\'acide acétique '
        '(CH₃COOH) est l\'acide du vinaigre. Ce sont des acides faibles qui cèdent un proton '
        'en solution aqueuse.\n\n'
        'Les esters sont formés par réaction d\'un acide carboxylique avec un alcool '
        '(estersification de Fischer). Ils possèdent le groupe -COO-. Les esters ont une '
        'odeur fruitée caractéristique et sont utilisés dans les parfums et arômes.\n\n'
        'La réaction d\'estersification est une réaction d\'équilibre : acide + alcool ⇌ ester '
        '+ eau. L\'acidocatalyse (H₂SO₄ concentré) et l\'excès d\'un des réactifs déplacent '
        'l\'équilibre vers la formation d\'ester. L\'hydrolyse est la réaction inverse.',
    example:
        'Prévoir le(s) produit(s) d\'oxydation de CH₃CH₂OH (alcool éthylique).\n\n'
        'Étape 1 : Classifier l\'alcool.\n'
        'CH₃CH₂OH : le carbone portant OH n\'est lié qu\'à un autre carbone.\n'
        'C\'est un alcool primaire.\n\n'
        'Étape 2 : Prévoir l\'oxydation douce.\n'
        'Alcool primaire → aldéhyde : CH₃CHO (acétaldéhyde)\n\n'
        'Étape 3 : Prévoir l\'oxydation forte.\n'
        'Alcool primaire → acide carboxylique : CH₃COOH (acide acétique)\n\n'
        'Étape 4 : Vérifier les règles d\'oxydation.\n'
        '→ Alcool primaire : OH sur C lié à 1 C → aldéhyde → acide carboxylique ✓\n'
        '(Si c\'était un alcool secondaire, on obtiendrait une cétone ; si tertiaire, '
        'pas d\'oxydation sous conditions normales.)',
    takeaways: [
      'Les alcools ont un groupe -OH ; leur oxydation dépend de leur degré de substitution.',
      'Les aldéhydes (-CHO) s\'oxydent facilement en acides carboxyliques.',
      'Les cétones sont moins oxydables que les aldéhydes.',
      'L\'estersification est une réaction d\'équilibre catalysée par un acide.',
      'Les acides carboxyliques sont des acides faibles en solution aqueuse.',
    ],
  ),

  'chimie_c_ch3_l3': LessonContent(
    introText:
        'Les mécanismes réactionnels décrivent les étapes élémentaires par lesquelles une '
        'réaction chimique se déroule. Comprendre ces mécanismes permet de prévoir les '
        'produits, optimiser les conditions et comprendre la stéréochimie.',
    lessonBody:
        'Un mécanisme réactionnel est la description détaillée des étapes élémentaires qui '
        'transforment les réactifs en produits. Chaque étape élémentaire implique la rupture '
        'et/ou la formation de liaisons chimiques.\n\n'
        'La polarité des liaisons joue un rôle fondamental. Une liaison est polaire quand '
        'les deux atomes ont des électronégativités différentes : l\'électronégatif attire '
        'les électrons, créant une séparation de charge partielle (δ- et δ+). Cette polarité '
        'oriente l\'attaque des réactifs sur les sites réactifs de la molécule.\n\n'
        'Les réactions d\'addition sur une double liaison C=C se produisent par un mécanisme '
        'en deux temps. Dans le premier temps, le réactif (électrophile) est attiré par les '
        'électrons π de la double liaison, formant un intermédiaire carbocation. Dans le '
        'deuxième temps, un nucléophile attaque le carbocation pour former le produit final.\n\n'
        'Les réactions de substitution (SN1 et SN2) concernent le remplacement d\'un groupe '
        'partant par un nucléophile. Le mécanisme SN2 se produit en une seule étape avec '
        'inversion de configuration. Le mécanisme SN1 passe par un intermédiaire carbocation '
        'et peut conduire à un mélange de stéréoisomères.\n\n'
        'L\'élimination (E1 ou E2) consiste à retirer deux atomes ou groupes d\'atomes pour '
        'former une double liaison. L\'élimination E2 est concertée (une seule étape) tandis '
        'que E1 passe par un carbocation.\n\n'
        'Les diagrammes de profil énergétique illustrent l\'énergie des intermédiaires et des '
        'états de transition le long de la coordonnée de réaction. L\'énergie d\'activation '
        '(Ea) est la barrière énergétique à franchir pour que la réaction se produise. '
        'Plus Ea est faible, plus la réaction est rapide.\n\n'
        'La cinétique chimique est intimement liée au mécanisme : le terme le plus lent '
        '(étape déterminante) contrôle la vitesse globale de la réaction.',
    example:
        'Mécanisme d\'addition HBr sur le propène CH₃-CH=CH₂ (règle de Markovnikov).\n\n'
        'Étape 1 : Polarité de HBr et de la double liaison.\n'
        'HBr : Hδ⁺-Brδ⁻ (brome plus électronégatif)\n'
        'La double liaison C=C est riche en électrons (nucléophile).\n\n'
        'Étape 2 : Première étape - attaque de HBr (électrophile) sur la double liaison.\n'
        'Hδ⁺ de HBr est attiré par les électrons π.\n'
        'Deux carbocations possibles :\n'
        '• CH₃-C⁺H-CH₃ (secondaire, plus stable) ← privilégié\n'
        '• CH₃-CH₂-C⁺H₂ (primaire, moins stable)\n\n'
        'Étape 3 : Deuxième étape - attaque de Br⁻ (nucléophile).\n'
        'Br⁻ attaque le carbocation secondaire :\n'
        'CH₃-C⁺H-CH₃ + Br⁻ → CH₃-CHBr-CH₃\n\n'
        'Produit principal : 2-bromopropane (règle de Markovnikov : H s\'ajoute sur le C '
        'le plus riche en H, Br sur le C le moins substitué).\n\n'
        'Le produit secondaire (1-bromopropane) est minoritaire car le carbocation '
        'primaire est moins stable.',
    takeaways: [
      'La polarité des liaisons détermine l\'orientation des attaques nucléophiles.',
      'L\'addition sur C=C passe par un intermédiaire carbocation.',
      'La règle de Markovnikov prédit le produit principal d\'addition sur les alcènes.',
      'Le profil énergétique montre les états de transition et l\'énergie d\'activation.',
      'La cinétique est contrôlée par l\'étape la plus lente (étape déterminante).',
    ],
  ),

  'chimie_c_ch4_l1': LessonContent(
    introText:
        'La cinétique chimique étudie les vitesses des réactions et les facteurs qui les '
        'influencent. Comprendre comment la concentration, la température et les catalyseurs '
        'affectent la vitesse est essentiel pour optimiser les procédés chimiques.',
    lessonBody:
        'La cinétique chimique est l\'étude de la vitesse des réactions chimiques et des '
        'facteurs qui la contrôlent. La vitesse de réaction v est définie comme la variation '
        'de la concentration d\'un réactif ou d\'un produit par unité de temps.\n\n'
        'La vitesse moyenne entre les instants t₁ et t₂ est v̄ = Δ[Produit]/Δt = -Δ[Réactif]/Δt. '
        'La vitesse instantanée est la dérivée de la concentration par rapport au temps : '
        'v = d[Produit]/dt.\n\n'
        'L\'ordre de réaction par rapport à un réactif est l\'exposant de sa concentration '
        'dans l\'expression de la vitesse. L\'ordre total est la somme des exposants. '
        'Par exemple, si v = k[A]²[B], la réaction est du second ordre en A, du premier '
        'ordre en B, et du troisième ordre total.\n\n'
        'La constante de vitesse k dépend de la température selon la loi d\'Arrhenius : '
        'k = A × exp(-Ea/RT), où A est le facteur pré-exponentiel, Ea l\'énergie d\'activation, '
        'R la constante des gaz parfaits (8,314 J/(mol·K)) et T la température en kelvins.\n\n'
        'L\'énergie d\'activation Ea est la barrière énergétique minimale que doivent '
        'franchir les réactifs pour se transformer en produits. Plus Ea est grande, plus '
        'la réaction est lente.\n\n'
        'Les catalyseurs augmentent la vitesse de réaction en diminuant l\'énergie d\'activation, '
        'mais ne sont pas consommés. Ils fournissent un chemin de réaction alternatif avec '
        'une barrière énergétique plus faible. Il existe des catalyseurs homogènes (même phase '
        'que les réactifs) et hétérogènes (phase différente).\n\n'
        'Les facteurs influençant la vitesse sont : la concentration des réactifs, la '
        'température (augmente k exponentiellement), le catalyseur, la surface de contact '
        '(pour les solides), et la nature des réactifs.',
    example:
        'Une réaction est du premier ordre avec k = 2,0 × 10⁻³ s⁻¹ à 25 °C.\n'
        'Calculer le temps nécessaire pour que la concentration chute à 10 % de sa valeur initiale.\n\n'
        'Étape 1 : Écrire la loi de vitesse intégrée du 1er ordre.\n'
        '[A] = [A]₀ × exp(-kt)\n\n'
        'Étape 2 : Poser la condition.\n'
        'On veut [A] = 0,10 × [A]₀ (10 % de la concentration initiale)\n\n'
        'Étape 3 : Résoudre pour t.\n'
        '0,10 × [A]₀ = [A]₀ × exp(-kt)\n'
        '0,10 = exp(-kt)\n'
        'ln(0,10) = -kt\n'
        't = -ln(0,10) / k = -(-2,303) / (2,0 × 10⁻³)\n'
        't = 2,303 / 2,0 × 10⁻³ = 1 151 s ≈ 19,2 minutes\n\n'
        'Étape 4 : Vérification.\n'
        'La demi-vie d\'une réaction du 1er ordre est t½ = ln(2)/k = 0,693/(2,0 × 10⁻³) = 346,5 s.\n'
        'Il faut environ 3,32 demi-vies pour arriver à 10 % : 3,32 × 346,5 ≈ 1 150 s ✓',
    takeaways: [
      'La vitesse de réaction dépend de la concentration, la température et les catalyseurs.',
      'L\'ordre de réaction est déterminé expérimentalement, pas par la stoœchiométrie.',
      'La loi d\'Arrhenius (k = A·exp(-Ea/RT)) relie la constante de vitesse à la température.',
      'Les catalyseurs diminuent Ea sans être consommés.',
    ],
  ),

  'chimie_c_ch4_l2': LessonContent(
    introText:
        'L\'équilibre chimique est l\'état dans lequel les vitesses des réactions directe et '
        'inverse sont égales. Le principe de Le Chatelier permet de prévoir l\'effet des '
        'variations de conditions sur la position d\'équilibre.',
    lessonBody:
        'Un système chimique est à l\'équilibre quand les vitesses de la réaction directe et '
        'de la réaction inverse sont égales. À l\'équilibre, les concentrations des réactifs '
        'et des produits ne varient plus, bien que les réactions continuent de se produire '
        'à la même vitesse dans les deux sens.\n\n'
        'La constante d\'équilibre K caractérise la position de l\'équilibre à une température '
        'donnée. Pour une réaction aA + bB ⇌ cC + dD, K = ([C]ᶜ[D]ᵈ)/([A]ᵃ[B]ᵇ) à '
        'l\'équilibre. K ne dépend que de la température, pas des concentrations initiales.\n\n'
        'Si K >> 1, l\'équilibre est déplacé vers les produits (réaction quasi complète). '
        'Si K << 1, l\'équilibre est déplacé vers les réactifs (réaction très peu avancée).\n\n'
        'Le quotient réactionnel Q a la même expression que K, mais avec les concentrations '
        'quelconques (pas nécessairement à l\'équilibre). Si Q < K, la réaction évolue vers '
        'la droite (vers les produits). Si Q > K, elle évolue vers la gauche (vers les '
        'réactifs). Si Q = K, le système est à l\'équilibre.\n\n'
        'Le principe de Le Chatelier stipule que si l\'on perturbe un système à l\'équilibre, '
        'celui-ci évolue pour diminuer l\'effet de la perturbation.\n\n'
        'L\'effet de la température dépend du signe de ΔH. Si la réaction est exothermique '
        '(ΔH < 0), un accroissement de T déplace l\'équilibre vers les réactifs. Si la '
        'réaction est endothermique (ΔH > 0), un accroissement de T déplace l\'équilibre '
        'vers les produits.\n\n'
        'Les catalyseurs n\'influencent pas la position d\'équilibre mais accélèrent '
        'l\'atteinte de l\'équilibre. Ils augmentent simultanément les vitesses directe '
        'et inverse.',
    example:
        'Réaction : N₂(g) + 3H₂(g) ⇌ 2NH₃(g)    ΔH = -92 kJ/mol\n'
        'K = 4,3 × 10⁻³ à 500 °C.\n\n'
        'Prévoir l\'effet de chaque perturbation :\n\n'
        'a) Augmentation de la pression :\n'
        '→ Réaction avec diminution du nombre de moles de gaz (4 → 2).\n'
        '→ Le Chatelier : le système compense la hausse de P en diminuant le volume → déplacement '
        'vers la droite (plus de NH₃). ✓\n\n'
        'b) Augmentation de la température :\n'
        '→ ΔH < 0 (exothermique) : la chaleur est un "produit".\n'
        '→ Augmenter T déplace l\'équilibre vers les réactifs (vers la gauche). Moins de NH₃. ✓\n\n'
        'c) Ajout de N₂ :\n'
        '→ Augmente [N₂], donc Q < K.\n'
        '→ L\'équilibre se déplace vers la droite pour consommer le N₂ ajouté. ✓\n\n'
        'd) Ajout d\'un catalyseur :\n'
        '→ Aucun déplacement de l\'équilibre, mais l\'équilibre est atteint plus rapidement. ✓',
    takeaways: [
      'La constante K ne dépend que de la température.',
      'Q < K : réaction évolue vers la droite ; Q > K : vers la gauche.',
      'Le Chatelier : le système compense une perturbation en s\'y opposant.',
      'L\'effet de T sur l\'équilibre dépend du signe de ΔH (endothermique ou exothermique).',
      'Les catalyseurs accélèrent l\'atteinte de l\'équilibre sans le déplacer.',
    ],
  ),

  'chimie_c_ch4_l3': LessonContent(
    introText:
        'La thermodynamique chimique étudie les échanges d\'énergie lors des transformations '
        'chimiques. L\'enthalpie libre (ΔG) permet de prévoir la spontanéité des réactions, '
        'tandis que l\'enthalpie (ΔH) caractérise les échanges de chaleur.',
    lessonBody:
        'La thermodynamique chimique décrit les conditions sous lesquelles une réaction '
        'chimique est spontanée, c\'est-à-dire capable de se produire sans apport extérieur '
        'd\'énergie.\n\n'
        'L\'énergie interne U est l\'énergie totale d\'un système. L\'enthalpie H = U + PV '
        'caractérise l\'énergie échangeée lors d\'une transformation à pression constante. '
        'La variation d\'enthalpie ΔH mesure la chaleur échangée : si ΔH < 0, la réaction '
        'est exothermique (dégage de chaleur) ; si ΔH > 0, elle est endothermique (absorption '
        'de chaleur).\n\n'
        'L\'entropie S mesure le désordre d\'un système. La variation d\'entropie ΔS est '
        'positive quand le désordre augmente (augmentation du nombre de molécules de gaz, '
        'par exemple) et négative quand il diminue.\n\n'
        'L\'énergie libre de Gibbs ΔG est le critère ultime de spontanéité : ΔG = ΔH - TΔS.\n'
        '• Si ΔG < 0 : la réaction est spontanée.\n'
        '• Si ΔG = 0 : le système est à l\'équilibre.\n'
        '• Si ΔG > 0 : la réaction n\'est pas spontanée (elle est spontanée en sens inverse).\n\n'
        'La relation entre ΔG et la constante d\'équilibre est : ΔG° = -RT ln(K). '
        'Cette équation fondamentale relie la thermodynamique à l\'équilibre chimique.\n\n'
        'La relation de van\'t Hoff relie la variation de K à la température : '
        'ln(K₂/K₁) = -ΔH°/R × (1/T₂ - 1/T₁). Pour une réaction exothermique, '
        'K diminue quand T augmente ; pour une endothermique, K augmente.\n\n'
        'La chaleur de réaction peut être calculée à partir des énergies de formation '
        'standard : ΔH°(réaction) = Σ ΔH°f(produits) - Σ ΔH°f(réactifs).',
    example:
        'Pour la réaction : 2SO₂(g) + O₂(g) ⇌ 2SO₃(g)\n'
        'ΔH° = -198 kJ/mol et ΔS° = -187 J/(mol·K).\n\n'
        'Étape 1 : Calculer ΔG° à 25 °C (298 K).\n'
        'ΔG° = ΔH° - TΔS° = -198 000 - 298 × (-187)\n'
        'ΔG° = -198 000 + 55 726 = -142 274 J/mol ≈ -142 kJ/mol\n\n'
        'Étape 2 : Interpréter.\n'
        'ΔG° < 0 : la réaction est spontanée à 25 °C. ✓\n\n'
        'Étape 3 : Calculer K à 25 °C.\n'
        'ΔG° = -RT ln(K)\n'
        '-142 274 = -8,314 × 298 × ln(K)\n'
        'ln(K) = 142 274 / 2 477,6 = 57,4\n'
        'K = e⁵⁷·⁴ ≈ 10²⁴·⁹\n\n'
        'K est très grande : l\'équilibre est très fortement déplacé vers les produits. ✓\n\n'
        'Étape 4 : Vérifier la cohérence avec le signe de ΔS.\n'
        'ΔS° < 0 : le désordre diminue (3 moles de gaz → 2 moles). '
        'La réaction reste spontanée grâce à la forte exothermie (ΔH° très négatif).',
    takeaways: [
      'ΔG = ΔH - TΔS est le critère de spontanéité d\'une réaction.',
      'ΔG < 0 : spontanée ; ΔG = 0 : équilibre ; ΔG > 0 : non spontanée.',
      'ΔG° = -RT ln(K) relie l\'énergie libre à la constante d\'équilibre.',
      'L\'enthalpie et l\'entropie s\'opposent : leur balance détermine la spontanéité.',
      'La relation de van\'t Hoff décrit l\'effet de la température sur K.',
    ],
  ),

  'chimie_c_ch5_l1': LessonContent(
    introText:
        'La solubilité d\'une espèce chimique dans un solvant détermine sa capacité à se '
        'dissoudre. Comprendre l\'équilibre de solubilité et le produit de solubilité est '
        'essentiel pour les applications analytiques et industrielles.',
    lessonBody:
        'La solubilité d\'un solide dans un liquide est la masse maximale de soluté que l\'on '
        'peut dissoudre dans une masse donnée de solvant à une température donnée pour '
        'obtenir une solution saturée. Une solution est dite diluée quand la concentration '
        'est bien inférieure à la solubilité, et saturée quand elle est égale à la '
        'solubilité.\n\n'
        'L\'équilibre de solubilité s\'écrit pour un solide ionique comme : AB(s) ⇌ A⁺(aq) + B⁻(aq). '
        'Le produit de solubilité Ks (ou Ksp) est l\'expression de l\'équilibre : '
        'Ks = [A⁺][B⁻], où les concentrations sont celles de l\'équilibre de saturation. '
        'Ks ne dépend que de la température.\n\n'
        'Le produit ionique Q a la même expression que Ks mais avec des concentrations '
        'quelconques. Si Q < Ks, la solution est non saturée (pas de précipité). Si Q = Ks, '
        'la solution est saturée. Si Q > Ks, la solution est sursaturée et un précipité '
        'se forme jusqu\'à ce que Q = Ks.\n\n'
        'La solubilité molaire s est la concentration en soluté dans une solution saturée. '
        'Pour un sel AB : Ks = s², donc s = √Ks. Pour un sel A₂B : Ks = 4s³, donc '
        's = ∛(Ks/4).\n\n'
        'Le facteur de solubilité f = Ks/(C(A⁺) × C(B⁻)) permet de juger si un précipité '
        'se formera lors du mélange de deux solutions. Si f < 1, pas de précipité. Si f > 1, '
        'un précipité se forme.\n\n'
        'L\'influence de la température sur Ks dépend du signe de l\'enthalpie de dissolution. '
        'Pour une dissolution endothermique, Ks augmente avec T. Pour une dissolution '
        'exothermique, Ks diminue avec T.',
    example:
        'Calculer la solubilité du chlorure d\'argent (AgCl) dans l\'eau à 25 °C.\n'
        'Ks(AgCl) = 1,0 × 10⁻¹⁰ à 25 °C.\n\n'
        'Étape 1 : Écrire l\'équilibre de solubilité.\n'
        'AgCl(s) ⇌ Ag⁺(aq) + Cl⁻(aq)\n\n'
        'Étape 2 : Exprimer Ks en fonction de la solubilité molaire s.\n'
        '[Ag⁺] = s et [Cl⁻] = s\n'
        'Ks = [Ag⁺][Cl⁻] = s × s = s²\n\n'
        'Étape 3 : Résoudre pour s.\n'
        's = √Ks = √(1,0 × 10⁻¹⁰) = 1,0 × 10⁻⁵ mol/L\n\n'
        'Étape 4 : Convertir en g/L (M(AgCl) = 143,3 g/mol).\n'
        's = 1,0 × 10⁻⁵ × 143,3 = 1,4 × 10⁻³ g/L = 1,4 mg/L\n\n'
        'Étape 5 : Vérifier avec le facteur Q.\n'
        'Si on mélange 10 mL de AgNO₃ 0,01 M avec 10 mL de NaCl 0,01 M :\n'
        '[Ag⁺] = [Cl⁻] = 0,01 × 10/(10+10) = 0,005 M\n'
        'Q = [Ag⁺][Cl⁻] = 0,005 × 0,005 = 2,5 × 10⁻⁵\n'
        'Q > Ks (1,0 × 10⁻¹⁰) : un précipité d\'AgCl se forme bien. ✓',
    takeaways: [
      'Ks = [A⁺][B⁻] caractérise la solubilité d\'un sel à l\'équilibre.',
      'Q < Ks : pas de précipité ; Q > Ks : précipité se forme.',
      'La solubilité molaire s se déduit de Ks selon la stoœchiométrie du sel.',
      'Le facteur f = Ks/(Q) prédit la formation d\'un précipité lors d\'un mélange.',
      'Ks ne dépend que de la température, pas des concentrations initiales.',
    ],
  ),
};
