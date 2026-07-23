import 'lesson_content_model.dart';

final Map<String, LessonContent> bacCPhysiqueContent = {
  // =========================================================================
  // Chapitre 1 — Cinématique
  // =========================================================================

  'physique_c_ch1_l1': const LessonContent(
    introText:
        'La cinématique est la branche de la mécanique qui décrit le mouvement des corps sans '
        'chercher à en comprendre les causes. Elle fait appel à des vecteurs fondamentaux : '
        'la position, la vitesse et l\'accélération, qui permettent de caractériser complètement '
        'un mouvement dans l\'espace.',
    lessonBody:
        'Le vecteur position \u20D7r (O, M) définit la position d\'un point M par rapport à un '
        'repère (O, \u20D7i, \u20D7j, \u20D7k). Ses coordonnées sont (x, y, z) dans un repère '
        'cartésien. Le vecteur déplacement est défini par \u20D7r\u2082 - \u20D7r\u2081, '
        'il ne dépend que des positions initiale et finale, pas du chemin suivi.\n\n'
        'Le vecteur vitesse instantanée est la dérivée du vecteur position par rapport au temps : '
        '\u20D7v = d\u20D7r/dt. Ses composantes sont (dx/dt, dy/dt, dz/dt). La vitesse est tangente '
        'à la trajectoire en chaque point. Sa norme (la vitesse instantanée) est v = ds/dt, où s '
        'est l\'abscisse curviligne.\n\n'
        'Le vecteur accélération est la dérivée du vecteur vitesse : \u20D7a = d\u20D7v/dt = d²\u20D7r/dt². '
        'Dans un mouvement rectiligne, \u20D7a est colinéaire à \u20D7v. Dans un mouvement courbe, '
        '\u20D7a se décompose en une composante tangentielle a\u209C = dv/dt (modification de la vitesse) '
        'et une composante normale a\u2099 = v²/R (modification de la direction, avec R le rayon de courbure).\n\n'
        'La vitesse moyenne entre deux instants t\u2081 et t\u2082 est \u20D7v_m = (\u20D7r\u2082 - \u20D7r\u2081)/(t\u2082 - t\u2081). '
        'L\'accélération moyenne est \u20D7a_m = (\u20D7v\u2082 - \u20D7v\u2081)/(t\u2082 - t\u2081). '
        'Le vecteur vitesse moyenne est toujours dirigé dans le sens du mouvement, tandis que le vecteur '
        'accélération moyenne peut avoir n\'importe quelle orientation.\n\n'
        'Dans un repère à une dimension (axe Ox), on note simplement v = dx/dt et a = d²x/dt². '
        'Si v et a sont de même signe, le mouvement est accéléré. Si sont de signes opposés, '
        'le mouvement est ralenti.',
    example:
        'Exemple — Mouvement rectiligne d\'une voiture :\n\n'
        'Une voiture part de l\'origine (x\u2080 = 0) à t = 0. Sa position est donnée par '
        'x(t) = 3t² + 2t (en mètres).\n\n'
        'Étape 1 : Calcul de la vitesse\n'
        'v(t) = dx/dt = 6t + 2\n'
        'À t = 0 : v(0) = 2 m/s\n'
        'À t = 3 s : v(3) = 6(3) + 2 = 20 m/s\n\n'
        'Étape 2 : Calcul de l\'accélération\n'
        'a(t) = dv/dt = 6 m/s²\n'
        'L\'accélération est constante, le mouvement est uniformément accéléré.\n\n'
        'Étape 3 : Vérification\n'
        'À t = 3 s, x(3) = 3(9) + 2(3) = 33 m\n'
        'Vérifions avec la formule x = x\u2080 + v\u2080t + ½at² :\n'
        'x = 0 + 2(3) + ½(6)(9) = 6 + 27 = 33 m ✓\n\n'
        'Résultat : la voiture a une accélération constante de 6 m/s² et atteint 20 m/s après 3 secondes.',
    takeaways: [
      'Le vecteur position \u20D7r définit la position d\'un point dans un repère donné',
      'La vitesse \u20D7v = d\u20D7r/dt est tangente à la trajectoire',
      'L\'accélération \u20D7a = d\u20D7v/dt se décompose en composante tangentielle et normale',
      'Un mouvement accéléré signifie v et a de même signe',
    ],
  ),

  'physique_c_ch1_l2': const LessonContent(
    introText:
        'Les mouvements rectilignes uniformes et uniformément accélérés sont les cas les plus '
        'courants en cinématique. Le mouvement rectiligne uniforme (MRU) caractérise un déplacement '
        'à vitesse constante, tandis que le mouvement uniformément accéléré (MUA) décrit un '
        'accroissement régulier de la vitesse.',
    lessonBody:
        'Dans un mouvement rectiligne uniforme (MRU), la vitesse est constante : v(t) = v\u2080. '
        'La position est alors une fonction linéaire du temps : x(t) = x\u2080 + v\u2080 · t. '
        'Le graphique x(t) est une droite de pente v\u2080. L\'accélération est nulle : a = 0.\n\n'
        'Dans un mouvement rectiligne uniformément accéléré (MUA), l\'accélération est constante : '
        'a(t) = a\u2080. En intégrant, on obtient la vitesse : v(t) = v\u2080 + a\u2080 · t, '
        'et la position : x(t) = x\u2080 + v\u2080 · t + ½ · a\u2080 · t². Ces équations sont '
        'les formules fondamentales de la cinématique.\n\n'
        'La relation de Torricelli relie vitesse, accélération et déplacement sans faire '
        'intervenir le temps : v² = v\u2080² + 2 · a\u2080 · (x - x\u2080). Cette formule '
        'est très utile lorsqu\'on ne connaît pas la durée du mouvement.\n\n'
        'Le cas particulier de la chute libre verticale correspond à un MUA avec a = -g (vers le bas), '
        'où g ≈ 9,81 m/s². Les formules deviennent : v(t) = v\u2080 - g·t et '
        'h(t) = h\u2080 + v\u2080·t - ½·g·t².\n\n'
        'Le temps de montée (pour un lancer vertical ascendant) se calcule en posant v = 0 : '
        't_montée = v\u2080/g. La hauteur maximale est h_max = h\u2080 + v\u2080²/(2g). '
        'Le temps de chute totale est le temps nécessaire pour revenir au point de départ.',
    example:
        'Exemple — Chute libre d\'une pierre :\n\n'
        'Une pierre est lâchée du sommet d\'un immeuble de 80 m avec une vitesse initiale '
        'verticale descendante de 5 m/s. (g = 10 m/s²)\n\n'
        'Étape 1 : Identification des données\n'
        'h\u2080 = 80 m, v\u2080 = 5 m/s (vers le bas), g = 10 m/s²\n\n'
        'Étape 2 : Temps de chute\n'
        'h(t) = h\u2080 + v\u2080·t + ½·g·t² = 0 (sol)\n'
        '80 + 5t + 5t² = 0\n'
        't² + t - 16 = 0\n'
        'Δ = 1 + 64 = 65 → t = (-1 + √65)/2 ≈ 3,53 s\n\n'
        'Étape 3 : Vitesse au sol\n'
        'v = v\u2080 + g·t = 5 + 10(3,53) = 40,3 m/s\n\n'
        'Vérification avec Torricelli : v² = v\u2080² + 2·g·h = 25 + 1600 = 1625\n'
        'v = √1625 ≈ 40,3 m/s ✓\n\n'
        'Résultat : la pierre touche le sol après 3,53 s à environ 40,3 m/s.',
    takeaways: [
      'Le MRU a une vitesse constante : x = x\u2080 + v\u2080·t',
      'Le MUA a une accélération constante : v = v\u2080 + a·t et x = x\u2080 + v\u2080·t + ½·a·t²',
      'La relation de Torricelli : v² = v\u2080² + 2a(x - x\u2080) permet de ne pas utiliser le temps',
      'La chute libre est un MUA avec a = g ≈ 9,81 m/s² vers le bas',
    ],
  ),

  'physique_c_ch1_l3': const LessonContent(
    introText:
        'Le mouvement circulaire uniforme est un cas fondamental de mouvement curviligne. '
        'Un corps se déplace sur une trajectoire circulaire à vitesse constante. Malgré l\'absence '
        'de variation de vitesse, le mouvement circulaire uniforme implique une accélération '
        'non nulle dirigée vers le centre.',
    lessonBody:
        'Le mouvement circulaire uniforme (MCU) est un mouvement curviligne dont la trajectoire '
        'est un cercle de rayon R et dont la vitesse instantanée a une norme constante. '
        'La vitesse est toujours tangente au cercle.\n\n'
        'L\'accélération centripète (ou向心加速度) est dirigée vers le centre du cercle et sa norme est : '
        'a\u2099 = v²/R = ω²·R, où ω est la vitesse angulaire (en rad/s). La vitesse angulaire '
        'est liée à la vitesse linéaire par v = ω·R.\n\n'
        'La période T est le temps nécessaire pour effectuer un tour complet : T = 2π/ω = 2πR/v. '
        'La fréquence f est l\'inverse de la période : f = 1/T = ω/(2π). L\'unité de fréquence '
        'est le hertz (Hz).\n\n'
        'L\'accélération centripète n\'est pas une force : elle est le résultat de forces '
        'réellement appliquées sur le corps. Pour un corps en MCU, la force nette dirigée vers le '
        'centre est appelée force centripète : F\u2099 = m·a\u2099 = m·v²/R.\n\n'
        'L\'accélération tangentielle est nulle dans un MCU car la vitesse est constante. '
        'L\'accélération totale est donc uniquement centripète. Si la vitesse varie, '
        'on a un mouvement circulaire non uniforme avec une accélération tangentielle '
        'a\u209C = dv/dt.\n\n'
        'La vitesse angulaire peut aussi s\'exprimer en tours par minute (tr/min ou rpm). '
        'La conversion est : ω (rad/s) = 2π · f (Hz) = 2π · n/60 (si n est en tr/min).',
    example:
        'Exemple — Une pierre attachée à une ficelle :\n\n'
        'Une pierre de masse 200 g est attachée à une ficelle de longueur 80 cm et tourne '
        'dans un plan horizontal à 3 tours par seconde.\n\n'
        'Étape 1 : Conversion des données\n'
        'm = 0,2 kg, R = 0,8 m, f = 3 Hz\n'
        'ω = 2π·f = 6π rad/s ≈ 18,85 rad/s\n'
        'v = ω·R = 6π × 0,8 = 4,8π m/s ≈ 15,08 m/s\n\n'
        'Étape 2 : Accélération centripète\n'
        'a\u2099 = ω²·R = (6π)² × 0,8 = 36π² × 0,8 ≈ 284,1 m/s²\n\n'
        'Étape 3 : Force centripète (tension de la ficelle)\n'
        'T = m·a\u2099 = 0,2 × 284,1 ≈ 56,8 N\n\n'
        'Étape 4 : Période\n'
        'T = 1/f = 1/3 ≈ 0,33 s\n\n'
        'Résultat : la pierre subit une accélération centripète de 284,1 m/s² et la tension '
        'de la ficelle est d\'environ 56,8 N.',
    takeaways: [
      'Le MCU a une vitesse constante mais une accélération centripète non nulle',
      'a\u2099 = v²/R = ω²·R, dirigée vers le centre du cercle',
      'La période T = 2πR/v et la fréquence f = 1/T',
      'La force centripète est la force nette réelle qui maintient le corps en MCU',
    ],
  ),

  'physique_c_ch1_l4': const LessonContent(
    introText:
        'Le mouvement parabolique est le mouvement d\'un corps soumis uniquement à la pesanteur, '
        'après un lancer oblique. C\'est la superposition d\'un mouvement rectiligne uniforme '
        'horizontalement et d\'un mouvement uniformément accéléré verticalement.',
    lessonBody:
        'Le mouvement parabolique est issu du principe de superposition. On décompose le mouvement '
        'en deux directions indépendantes : horizontale (Ox) et verticale (Oy).\n\n'
        'Sur l\'axe horizontal, il n\'y a aucune force (on néglige la résistance de l\'air). '
        'Le mouvement est rectiligne uniforme : x(t) = v₀·cos(α)·t, où v₀ est la vitesse initiale '
        'et α l\'angle de lancement.\n\n'
        'Sur l\'axe vertical, seul le poids agit (vers le bas). Le mouvement est uniformément '
        'accéléré : y(t) = v₀·sin(α)·t - ½·g·t². La vitesse verticale est '
        'v\u2099(t) = v₀·sin(α) - g·t.\n\n'
        'L\'équation de la trajectoire s\'obtient en éliminant t entre les deux équations. '
        'On obtient : y = x·tan(α) - g·x²/(2·v₀²·cos²(α)). C\'est l\'équation d\'une parabole '
        'dirigée vers le bas.\n\n'
        'La portée (distance horizontale maximale) est atteinte lorsque y = 0 (retour au sol) : '
        'P = v₀²·sin(2α)/g. La portée est maximale pour α = 45°.\n\n'
        'La hauteur maximale est atteinte lorsque v\u2099 = 0 : '
        'h_max = v₀²·sin²(α)/(2g). Le temps de vol total est T = 2·v₀·sin(α)/g.\n\n'
        'Le point le plus haut de la trajectoire s\'appelle le sommet. Au sommet, la vitesse '
        'verticale est nulle et la vitesse totale est horizontale, égale à v₀·cos(α).',
    example:
        'Exemple — Lancer de ballon :\n\n'
        'Un ballon est lancé avec v₀ = 20 m/s à α = 30° par rapport à l\'horizontale. '
        'g = 10 m/s².\n\n'
        'Étape 1 : Composantes de la vitesse initiale\n'
        'v₀ₓ = 20·cos(30°) = 20 × (√3/2) ≈ 17,32 m/s\n'
        'v₀ᵧ = 20·sin(30°) = 20 × 0,5 = 10 m/s\n\n'
        'Étape 2 : Hauteur maximale\n'
        'h_max = v₀ᵧ²/(2g) = 10²/(2×10) = 5 m\n\n'
        'Étape 3 : Temps de vol\n'
        'T = 2·v₀ᵧ/g = 2×10/10 = 2 s\n\n'
        'Étape 4 : Portée\n'
        'P = v₀ₓ × T = 17,32 × 2 = 34,64 m\n'
        'Vérification : P = v₀²·sin(2α)/g = 400·sin(60°)/10 = 400 × 0,866/10 ≈ 34,64 m ✓\n\n'
        'Résultat : le ballon atteint 5 m de haut et parcourt 34,64 m en 2 secondes.',
    takeaways: [
      'Le mouvement parabolique combine MRU horizontal et MUA vertical',
      'L\'équation de la trajectoire est une parabole : y = x·tan(α) - gx²/(2v₀²·cos²α)',
      'La portée est maximale pour un angle de 45°',
      'Au sommet de la trajectoire, la vitesse est purement horizontale',
    ],
  ),

  // =========================================================================
  // Chapitre 2 — Dynamique
  // =========================================================================

  'physique_c_ch2_l1': const LessonContent(
    introText:
        'La dynamique étudie les relations entre les forces et le mouvement des corps. '
        'Les trois lois de Newton, formulées au XVIIe siècle, constituent les fondements '
        'de la mécanique classique et permettent de prédire le mouvement de tout objet '
        'soumis à des forces connues.',
    lessonBody:
        'La première loi de Newton (principe d\'inertie) énonce qu\'un corps isolé '
        '(sans force nette) est au repos ou en mouvement rectiligne uniforme. '
        'C\'est le principe d\'inertie : un corps conserve son état de mouvement tant '
        'qu\'une force extérieure ne s\'exerce pas sur lui.\n\n'
        'La deuxième loi de Newton (principe fondamental de la dynamique) lie la force nette '
        'appliquée à un corps à son accélération : \u20D7F\u2091ₓₜ = m·\u20D7a. '
        'Le vecteur accélération est dans la même direction que le vecteur force nette. '
        'Plus la masse est grande, plus il faut de force pour produire la même accélération.\n\n'
        'La troisième loi de Newton (action-réaction) stipule que si un corps A exerce une '
        'force sur un corps B, alors B exerce une force de même intensité mais de sens '
        'opposé sur A : \u20D7F\u2091\u2091\u2081₂ = -\u20D7F\u2091\u2091\u2082₁. '
        'Ces deux forces agissent sur des objets différents et ne s\'annulent pas.\n\n'
        'Le poids est la force exercée par la pesanteur : \u20D7P = m·\u20D7g. '
        'Sa norme est P = m·g (avec g ≈ 9,81 m/s²). La réaction d\'appui est la force '
        'exercée par une surface sur un corps qui l\'appuie.\n\n'
        'La traction (T) et la tension (dT) sont des forces s\'exerçant le long d\'un câble '
        'ou d\'une corde. Le frottement s\'oppose au mouvement relatif entre deux surfaces.',
    example:
        'Exemple — Bloc sur plan incliné :\n\n'
        'Un bloc de 5 kg est posé sur un plan incliné à 30°. Le coefficient de frottement '
        'cinétique est μ = 0,2. Calculer l\'accélération.\n\n'
        'Étape 1 : Décomposition du poids\n'
        'P = m·g = 5 × 9,81 = 49,05 N\n'
        'P\u2099 = P·sin(30°) = 49,05 × 0,5 = 24,53 N (parallèle au plan)\n'
        'P\u209C = P·cos(30°) = 49,05 × 0,866 = 42,48 N (perpendiculaire au plan)\n\n'
        'Étape 2 : Force de frottement\n'
        'f = μ·N = μ·P\u209C = 0,2 × 42,48 = 8,50 N\n\n'
        'Étape 3 : Application de la 2e loi de Newton (parallèle au plan)\n'
        'P\u2099 - f = m·a\n'
        '24,53 - 8,50 = 5·a\n'
        'a = 16,03/5 = 3,21 m/s²\n\n'
        'Résultat : le bloc accélère à 3,21 m/s² le long du plan.',
    takeaways: [
      '1ère loi : un corps isolé reste au repos ou en MRU (inertie)',
      '2ème loi : \u20D7F\u2091ₓₜ = m·\u20D7a, relation fondamentale de la dynamique',
      '3ème loi : les forces d\'action-réaction sont égales et opposées, mais sur des objets différents',
      'Le poids P = m·g et la force de frottement f = μ·N',
    ],
  ),

  'physique_c_ch2_l2': const LessonContent(
    introText:
        'Le travail et la puissance sont des grandeurs scalaires qui caractérisent l\'effet '
        'mécanique d\'une force. Le travail mesure l\'énergie transférée par une force when un '
        'déplacement a lieu, tandis que la puissance mesure la rapidité de ce transfert.',
    lessonBody:
        'Le travail d\'une force constante \u20D7F lors d\'un déplacement \u20D7d est le produit '
        'scalaire : W = \u20D7F · \u20D7d = F·d·cos(θ), où θ est l\'angle entre le vecteur force '
        'et le vecteur déplacement. Le travail est un scalaire (valeur algébique) : il peut être '
        'positif, négatif ou nul.\n\n'
        'Si θ = 0° (force dans le sens du déplacement), le travail est maximal : W = F·d. '
        'Si θ = 90° (force perpendiculaire au déplacement), le travail est nul. '
        'Si θ = 180° (force opposée au déplacement), le travail est négatif : W = -F·d.\n\n'
        'Le travail d\'une force variable s\'intègre : W = ∫F·ds sur le chemin. '
        'L\'unité de travail est le joule (J) : 1 J = 1 N·m.\n\n'
        'Le théorème de l\'énergie cinétique lie le travail de la force nette à la variation '
        'd\'énergie cinétique : W\u2091ₓₜ = ΔE\u209C = ½m·v² - ½m·v\u2080².\n\n'
        'La puissance est la dérivée du travail par rapport au temps : P = dW/dt = \u20D7F · \u20D7v. '
        'C\'est la vitesse à laquelle l\'énergie est transférée. L\'unité de puissance est le watt (W) : '
        '1 W = 1 J/s. La puissance mécanique est aussi P = F·v·cos(θ).\n\n'
        'La puissance moyenne est P_m = W/Δt, et la puissance instantanée est la limite de '
        'P_m lorsque Δt tend vers zéro.',
    example:
        'Exemple — Force de traction :\n\n'
        'Un camion de 2000 kg remonte une pente à 15° à vitesse constante de 10 m/s. '
        'La résistance au roulement est f = 500 N. Calculer la puissance du moteur.\n\n'
        'Étape 1 : Bilan des forces (vitesse constante → a = 0)\n'
        'F\u2091ₓₜ = 0 → F_moteur = P·sin(15°) + f\n'
        'P = m·g = 2000 × 9,81 = 19 620 N\n'
        'F_moteur = 19 620 × sin(15°) + 500\n'
        'F_moteur = 19 620 × 0,2588 + 500 = 5078 + 500 = 5578 N\n\n'
        'Étape 2 : Puissance\n'
        'P = F_moteur × v = 5578 × 10 = 55 780 W ≈ 55,8 kW\n\n'
        'Résultat : la puissance nécessaire au moteur est d\'environ 55,8 kW.',
    takeaways: [
      'Le travail W = F·d·cos(θ) est un scalaire mesuré en joules (J)',
      'Le travail peut être positif, négatif ou nul selon l\'angle θ',
      'Le théorème de l\'énergie cinétique : W\u2091ₓₜ = Δ(½mv²)',
      'La puissance P = dW/dt = F·v·cos(θ) est mesurée en watts (W)',
    ],
  ),

  'physique_c_ch2_l3': const LessonContent(
    introText:
        'L\'énergie cinétique et l\'énergie potentielle sont les deux formes principales '
        'd\'énergie en mécanique. L\'énergie cinétique dépend du mouvement, tandis que '
        'l\'énergie potentielle dépend de la position dans un champ de force.',
    lessonBody:
        'L\'énergie cinétique (E\u209C) est l\'énergie liée au mouvement d\'un corps. '
        'Elle est donnée par la formule : E\u209C = ½·m·v², où m est la masse et v la vitesse. '
        'L\'énergie cinétique est toujours positive ou nulle. Elle est nulle si le corps est au repos '
        'et augmente avec le carré de la vitesse.\n\n'
        'L\'énergie potentielle de pesanteur (E\u209Cp) est l\'énergie potentielle liée à la position '
        'd\'un corps dans le champ de pesanteur : E\u209Cp = m·g·h, où h est la hauteur par rapport '
        'à un niveau de référence choisi. Le choix du niveau de référence est arbitraire, seul '
        'l\'énergie potentielle comptant pour les calculs.\n\n'
        'L\'énergie potentielle élastique est l\'énergie stockée dans un ressort déformé : '
        'E\u209Cp_el = ½·k·x², où k est la raideur du ressort et x l\'allongement ou la compression.\n\n'
        'Le travail des forces conservatives (poids, force élastique) est égal à l\'opposé '
        'de la variation d\'énergie potentielle : W = -ΔE\u209Cp. Si le travail est positif, '
        'l\'énergie potentielle diminue (le corps descend). Si le travail est négatif, '
        'l\'énergie potentielle augmente (le corps monte).\n\n'
        'L\'énergie potentielle ne correspond à un stockage d\'énergie réel que pour les forces '
        'conservatives. Les forces de frottement dissipent de l\'énergie sous forme de chaleur '
        'et ne peuvent pas être associées à une énergie potentielle.',
    example:
        'Exemple — Chute d\'un objet :\n\n'
        'Un objet de 2 kg est lâché du sommet d\'une falaise de 45 m (sans vitesse initiale). '
        'Calculer l\'énergie potentielle initiale, cinétique au sol et vérifier la conservation.\n\n'
        'Étape 1 : Énergie potentielle initiale\n'
        'E\u209Cp\u2080 = m·g·h = 2 × 9,81 × 45 = 882,9 J\n\n'
        'Étape 2 : Énergie cinétique au sol\n'
        'Par conservation de l\'énergie mécanique (pas de frottements) :\n'
        'E\u209C(sol) = E\u209Cp\u2080 = 882,9 J\n\n'
        'Étape 3 : Vitesse au sol\n'
        '½·m·v² = 882,9\n'
        'v² = 882,9 / (½ × 2) = 882,9\n'
        'v = √882,9 ≈ 29,7 m/s\n\n'
        'Vérification avec Torricelli : v² = 2·g·h = 2 × 9,81 × 45 = 882,9 → v ≈ 29,7 m/s ✓\n\n'
        'Résultat : toute l\'énergie potentielle est transformée en énergie cinétique au sol.',
    takeaways: [
      'L\'énergie cinétique E\u209C = ½·m·v² est liée au mouvement',
      'L\'énergie potentielle de pesanteur E\u209Cp = m·g·h dépend de la hauteur',
      'Le travail des forces conservatives : W = -ΔE\u209Cp',
      'En l\'absence de frottements, l\'énergie mécanique est conservée',
    ],
  ),

  'physique_c_ch2_l4': const LessonContent(
    introText:
        'L\'énergie mécanique est la somme de l\'énergie cinétique et de l\'énergie potentielle. '
        'Le principe de conservation de l\'énergie mécanique est un outil puissant pour résoudre '
        'des problèmes de dynamique sans avoir à intégrer les équations du mouvement.',
    lessonBody:
        'L\'énergie mécanique d\'un système est définie par : E_m = E\u209C + E\u209Cp. '
        'Elle représente le total d\'énergie « mécanique » disponible dans un système.\n\n'
        'Le principe de conservation de l\'énergie mécanique énonce que si seules des forces '
        'conservatives agissent (ou si le travail des forces non conservatives est nul), '
        'l\'énergie mécanique est conservée : E_m = constante, soit E\u209C₁ + E\u209Cp₁ = '
        'E\u209C₂ + E\u209Cp₂.\n\n'
        'Les forces conservatives sont celles dont le travail ne dépend pas du chemin suivi, '
        'mais uniquement des positions initiale et finale. Exemples : le poids, la force '
        'élastique d\'un ressort idéal, la force électrostatique.\n\n'
        'Lorsque des forces non conservatives (frottements, résistance de l\'air) sont présentes, '
        'le travail de ces forces est égal à la variation d\'énergie mécanique : '
        'W_non-cons = ΔE_m = E_m(final) - E_m(initial). Ce travail est toujours négatif '
        'pour les forces dissipatives, entraînant une diminution de l\'énergie mécanique.\n\n'
        'L\'énergie mécanique peut être convertie en d\'autres formes (thermique, électrique) '
        'mais l\'énergie totale (mécanique + autres formes) est toujours conservée '
        '(premier principe de la thermodynamique).\n\n'
        'Le diagramme énergétique (barres d\'énergie) est un outil visuel pour représenter '
        'les transformations d\'énergie dans un système. Il permet de vérifier la conservation '
        'et de comprendre les échanges entre énergie cinétique et potentielle.',
    example:
        'Exemple — Ressort et masse :\n\n'
        'Une masse de 0,5 kg est fixée à un ressort de raideur k = 200 N/m. '
        'Le ressort est comprimé de 10 cm puis relâché. (On néglige les frottements.)\n\n'
        'Étape 1 : Énergie potentielle élastique initiale\n'
        'E\u209Cp = ½·k·x² = ½ × 200 × (0,1)² = 1 J\n\n'
        'Étape 2 : Énergie mécanique conservée\n'
        'Au point d\'équilibre (x = 0), toute l\'énergie potentielle est cinétique :\n'
        'E\u209C = 1 J\n\n'
        'Étape 3 : Vitesse maximale\n'
        '½·m·v² = 1\n'
        '½ × 0,5 × v² = 1\n'
        'v² = 4 → v = 2 m/s\n\n'
        'Étape 4 : Diagramme énergétique\n'
        'x = 10 cm : E\u209Cp = 1 J, E\u209C = 0 J, E_m = 1 J\n'
        'x = 0 cm : E\u209Cp = 0 J, E\u209C = 1 J, E_m = 1 J\n'
        'x = -10 cm : E\u209Cp = 1 J, E\u209C = 0 J, E_m = 1 J\n\n'
        'Résultat : la vitesse maximale est 2 m/s et l\'énergie mécanique reste constante.',
    takeaways: [
      'L\'énergie mécanique E_m = E\u209C + E\u209Cp est conservée si seules des forces conservatives agissent',
      'Les forces conservatives (poids, ressort) ont un travail indépendant du chemin',
      'Les forces non conservatives diminuent E_m (travail négatif)',
      'Le diagramme énergétique visualise les conversions d\'énergie',
    ],
  ),

  // =========================================================================
  // Chapitre 3 — Oscillations
  // =========================================================================

  'physique_c_ch3_l1': const LessonContent(
    introText:
        'L\'oscillateur harmonique simple est un système fondamental en physique. Il modélise '
        'tout système soumis à une force de rappel proportionnel au déplacement. Ce modèle '
        'est applicable à de nombreux phénomènes physiques, des vibrations mécaniques aux circuits '
        'électriques.',
    lessonBody:
        'Un oscillateur harmonique est un système soumis à une force de rappel \u20D7F = -k·\u20D7x, '
        'où k est la constante de raideur (en N/m) et x le déplacement par rapport à la position '
        'd\'équilibre. Cette loi est appelée loi de Hooke.\n\n'
        'L\'équation du mouvement est : m·d²x/dt² = -k·x, soit d²x/dt² + ω₀²·x = 0, '
        'où ω₀ = √(k/m) est la pulsation propre du système. Cette équation différentielle '
        'admet pour solution : x(t) = A·cos(ω₀·t + φ₀), où A est l\'amplitude (en m) '
        'et φ₀ la phase initiale (en rad).\n\n'
        'La période d\'oscillation est T = 2π/ω₀ = 2π·√(m/k). La fréquence est f = 1/T. '
        'On remarque que la période ne dépend ni de l\'amplitude ni de la vitesse initiale : '
        'c\'est une propriété caractéristique de l\'oscillateur harmonique.\n\n'
        'La vitesse est v(t) = -A·ω₀·sin(ω₀·t + φ₀). Sa valeur maximale est v_max = A·ω₀. '
        'L\'accélération est a(t) = -A·ω₀²·cos(ω₀·t + φ₀). Sa valeur maximale est '
        'a_max = A·ω₀².\n\n'
        'L\'énergie cinétique est E\u209C = ½·m·v², et l\'énergie potentielle élastique est '
        'E\u209Cp = ½·k·x². L\'énergie mécanique totale est E_m = ½·k·A² = constante. '
        'L\'énergie cinétique et potentielle oscillent en opposition de phase.',
    example:
        'Exemple — Masse sur ressort :\n\n'
        'Une masse de 0,4 kg est fixée à un ressort de raideur k = 100 N/m. '
        'Le système est déplacé de 5 cm puis relâché.\n\n'
        'Étape 1 : Pulsation et période\n'
        'ω₀ = √(k/m) = √(100/0,4) = √250 ≈ 15,81 rad/s\n'
        'T = 2π/ω₀ = 2π/15,81 ≈ 0,398 s\n\n'
        'Étape 2 : Vitesse et accélération maximales\n'
        'v_max = A·ω₀ = 0,05 × 15,81 ≈ 0,79 m/s\n'
        'a_max = A·ω₀² = 0,05 × 250 = 12,5 m/s²\n\n'
        'Étape 3 : Énergie mécanique\n'
        'E_m = ½·k·A² = ½ × 100 × (0,05)² = 0,125 J\n'
        'Au point d\'équilibre : E\u209C = 0,125 J et E\u209Cp = 0 J\n'
        'À l\'amplitude : E\u209C = 0 J et E\u209Cp = 0,125 J\n\n'
        'Résultat : la période est 0,398 s, v_max = 0,79 m/s et E_m = 0,125 J.',
    takeaways: [
      'L\'oscillateur harmonique est soumis à F = -k·x (loi de Hooke)',
      'La pulsation propre ω₀ = √(k/m) ne dépend pas de l\'amplitude',
      'La solution est x(t) = A·cos(ω₀t + φ₀)',
      'L\'énergie mécanique E_m = ½kA² est constante, oscillant entre cinétique et potentielle',
    ],
  ),

  'physique_c_ch3_l2': const LessonContent(
    introText:
        'Le pendule simple est un modèle idéal d\'oscillation : une masse ponctuelle attachée '
        'à un fil inextensible de longueur L. Pour de petites amplitudes, il se comporte comme '
        'un oscillateur harmonique, ce qui en fait un outil classique de mesure du temps.',
    lessonBody:
        'Le pendule simple est constitué d\'une masse ponctuelle m suspendue à un fil de longueur L '
        'fixé en un point O. Le système oscille sous l\'effet du poids dans un plan vertical.\n\n'
        'L\'angle θ est mesuré par rapport à la verticale descendante. Le mouvement est décrit par '
        'l\'équation : d²θ/dt² + (g/L)·sin(θ) = 0, où g est l\'accélération de la pesanteur.\n\n'
        'Pour de petites amplitudes (θ < 5° ou θ < 0,1 rad), on peut utiliser l\'approximation '
        'sin(θ) ≈ θ. L\'équation devient alors : d²θ/dt² + (g/L)·θ = 0. C\'est l\'équation '
        'd\'un oscillateur harmonique de pulsation propre ω₀ = √(g/L).\n\n'
        'La période du pendule simple est alors : T = 2π/ω₀ = 2π·√(L/g). Cette formule '
        'montre que la période ne dépend ni de la masse, ni de l\'amplitude (pour de petites '
        'oscillations), mais uniquement de la longueur du fil et de la pesanteur.\n\n'
        'La fréquence est f = 1/T = (1/2π)·√(g/L). Un pendule d\'une longueur d\'environ '
        '1 m a une période d\'environ 2 secondes (le « secondes pendulum »).\n\n'
        'L\'énergie potentielle du pendule est E\u209Cp = m·g·L·(1 - cos(θ)). '
        'Pour de petites oscillations, on peut écrire E\u209Cp ≈ ½·m·g·L·θ². '
        'L\'énergie mécanique est conservée (en l\'absence de frottements).',
    example:
        'Exemple — Horloge à pendule :\n\n'
        'Une horloge a un pendule de longueur 0,248 m. Calculer la période et la fréquence. '
        '(g = 9,81 m/s²)\n\n'
        'Étape 1 : Vérification de la petitesse des oscillations\n'
        'On suppose θ_max < 5°, donc l\'approximation sin(θ) ≈ θ est valide.\n\n'
        'Étape 2 : Période\n'
        'T = 2π·√(L/g) = 2π·√(0,248/9,81)\n'
        'T = 2π·√(0,02528)\n'
        'T = 2π × 0,1590 ≈ 1,00 s\n\n'
        'Étape 3 : Fréquence\n'
        'f = 1/T = 1/1,00 = 1 Hz\n\n'
        'Étape 4 : Longueur pour T = 2 s (horloge à secondes)\n'
        'T = 2π·√(L/g) → L = g·(T/(2π))²\n'
        'L = 9,81 × (2/(2π))² = 9,81 × (0,3183)² ≈ 0,994 m\n\n'
        'Résultat : la période est 1,00 s et la fréquence est 1 Hz. '
        'Pour un pendule à secondes, il faudrait L ≈ 1 m.',
    takeaways: [
      'La période du pendule simple est T = 2π·√(L/g)',
      'La période ne dépend ni de la masse ni de l\'amplitude (petites oscillations)',
      'L\'approximation sin(θ) ≈ θ est valable pour θ < 5°',
      'Un pendule de ~1 m a une période d\'environ 2 secondes',
    ],
  ),

  'physique_c_ch3_l3': const LessonContent(
    introText:
        'Les oscillations amorties surviennent lorsque des forces de frottement dissipent l\'énergie '
        'du système oscillant. L\'amplitude décroît exponentiellement au fil du temps, et le système '
        'finit par revenir à l\'équilibre. Ce phénomène est omniprésent dans la nature.',
    lessonBody:
        'L\'oscillateur harmonique avec amortissement est décrit par l\'équation : '
        'm·d²x/dt² + b·dx/dt + k·x = 0, où b est le coefficient d\'amortissement (en kg/s). '
        'On divise par m pour obtenir : d²x/dt² + 2γ·dx/dt + ω₀²·x = 0, où γ = b/(2m) est '
        'le taux d\'amortissement.\n\n'
        'Trois cas se présentent selon la valeur de γ par rapport à ω₀ :\n'
        '• Sous-amorti (γ < ω₀) : le système oscille avec une amplitude décroissante. '
        'Solution : x(t) = A·e^(-γt)·cos(ω·t + φ), avec ω = √(ω₀² - γ²). '
        'La pulsation est légèrement inférieure à la pulsation propre.\n'
        '• Critique (γ = ω₀) : le système revient à l\'équilibre sans osciller, le plus rapidement '
        'possible. Solution : x(t) = (A + B·t)·e^(-γt).\n'
        '• Sur-amorti (γ > ω₀) : le système revient lentement à l\'équilibre sans osciller.\n\n'
        'Le temps de relaxation τ = 1/γ est le temps nécessaire pour que l\'amplitude diminue '
        'd\'un facteur e. Le facteur de qualité Q = ω₀/(2γ) mesure le nombre d\'oscillations '
        'avant que l\'amplitude ne soit considérablement réduite. Un Q élevé signifie un '
        'amortissement faible.\n\n'
        'L\'énergie mécanique décroît exponentiellement : E(t) = E₀·e^(-2γt). L\'énergie '
        'dissipée est transformée en chaleur.',
    example:
        'Exemple — Ressort amorti :\n\n'
        'Un système masse-ressort (m = 0,5 kg, k = 200 N/m) a un coefficient d\'amortissement '
        'b = 2 kg/s.\n\n'
        'Étape 1 : Paramètres du système\n'
        'ω₀ = √(k/m) = √(200/0,5) = 20 rad/s\n'
        'γ = b/(2m) = 2/(2×0,5) = 2 s⁻¹\n'
        'γ < ω₀ → sous-amorti ✓\n\n'
        'Étape 2 : Pulsation effective\n'
        'ω = √(ω₀² - γ²) = √(400 - 4) = √396 ≈ 19,9 rad/s\n\n'
        'Étape 3 : Facteur de qualité\n'
        'Q = ω₀/(2γ) = 20/(2×2) = 5\n'
        'Le système effectue environ 5 oscillations avant amortissement significatif.\n\n'
        'Étape 4 : Temps de relaxation\n'
        'τ = 1/γ = 1/2 = 0,5 s\n'
        'Après 0,5 s, l\'amplitude est réduite d\'un facteur e ≈ 2,718.\n\n'
        'Résultat : le système oscille à 19,9 rad/s avec un facteur de qualité de 5.',
    takeaways: [
      'L\'amortissement provoque une décroissance exponentielle de l\'amplitude',
      'Trois cas : sous-amorti (oscillations), critique (retour le plus rapide), sur-amorti',
      'Le facteur de qualité Q = ω₀/(2γ) mesure la durée des oscillations',
      'L\'énergie mécanique décroît comme e^(-2γt)',
    ],
  ),

  // =========================================================================
  // Chapitre 4 — Électricité
  // =========================================================================

  'physique_c_ch4_l1': const LessonContent(
    introText:
        'La loi d\'Ohm est la loi fondamentale de l\'électricité en courant continu. Elle établit '
        'une relation linéaire entre la tension aux bornes d\'un conducteur et le courant qui le '
        'traverse. Les associations de résistances permettent de modéliser des circuits plus complexes.',
    lessonBody:
        'La loi d\'Ohm établit que la tension U aux bornes d\'un conducteur ohmique est proportionnelle '
        'au courant I qui le traverse : U = R·I, où R est la résistance (en ohms, Ω). Un conducteur '
        'est dit ohmique si sa résistance reste constante quelle que soit la tension appliquée.\n\n'
        'La résistance d\'un conducteur dépend de ses caractéristiques physiques : '
        'R = ρ·L/S, où ρ est la résistivité du matériau (en Ω·m), L la longueur et S la section. '
        'La résistivité augmente avec la température pour les métaux.\n\n'
        'Association en série : les résistances sont placées bout à bout. La résistance équivalente '
        'est la somme : R_s = R₁ + R₂ + ... + Rₙ. Le courant est le même dans chaque résistance, '
        'tandis que les tensions se partagent : U = U₁ + U₂ + ... + Uₙ.\n\n'
        'Association en parallèle : les résistances sont connectées entre les mêmes points. '
        'La conductance totale est la somme des conductances : 1/R_p = 1/R₁ + 1/R₂ + ... + 1/Rₙ. '
        'La tension est la même dans chaque résistance, tandis que les courants se partagent : '
        'I = I₁ + I₂ + ... + Iₙ.\n\n'
        'La puissance dissipée dans une résistance est P = U·I = R·I² = U²/R. '
        'L\'énergie dissipée en un temps t est W = P·t.',
    example:
        'Exemple — Circuit mixte :\n\n'
        'R₁ = 10 Ω, R₂ = 20 Ω, R₃ = 30 Ω. R₁ et R₂ sont en parallèle, puis en série avec R₃. '
        'U = 12 V.\n\n'
        'Étape 1 : Résistance équivalente de R₁ // R₂\n'
        '1/R₁₂ = 1/10 + 1/20 = 3/20\n'
        'R₁₂ = 20/3 ≈ 6,67 Ω\n\n'
        'Étape 2 : Résistance totale\n'
        'R_tot = R₁₂ + R₃ = 6,67 + 30 = 36,67 Ω\n\n'
        'Étape 3 : Courant total\n'
        'I = U/R_tot = 12/36,67 ≈ 0,327 A\n\n'
        'Étape 4 : Tensions et courants partiels\n'
        'U₃ = R₃·I = 30 × 0,327 = 9,81 V\n'
        'U₁₂ = U - U₃ = 12 - 9,81 = 2,19 V\n'
        'I₁ = U₁₂/R₁ = 2,19/10 = 0,219 A\n'
        'I₂ = U₁₂/R₂ = 2,19/20 = 0,110 A\n'
        'Vérification : I₁ + I₂ = 0,329 ≈ 0,327 A ✓\n\n'
        'Résultat : le courant total est 0,327 A, U₃ = 9,81 V, U₁₂ = 2,19 V.',
    takeaways: [
      'La loi d\'Ohm : U = R·I pour un conducteur ohmique',
      'En série : R_s = ΣRᵢ, courant commun, tensions additives',
      'En parallèle : 1/R_p = Σ(1/Rᵢ), tension commune, courants additives',
      'La puissance dissipée : P = UI = RI² = U²/R',
    ],
  ),

  'physique_c_ch4_l2': const LessonContent(
    introText:
        'Les lois des mailles et des nœuds sont les règles fondamentales pour analyser tout circuit '
        'électrique. La loi des nœuds (KCL) impose la conservation du courant, tandis que la loi '
        'des mailles (KVL) impose la conservation de la tension.',
    lessonBody:
        'La loi des nœuds (première loi de Kirchhoff, KCL) énonce que dans un nœud (point de '
        'jonction) d\'un circuit, la somme des courants entrants est égale à la somme des courants '
        'sortants : ΣI\u2091ₙ = ΣI\u2092_out. C\'est une conséquence de la conservation de la charge '
        'électrique : la charge ne s\'accumule pas dans un nœud.\n\n'
        'La loi des mailles (deuxième loi de Kirchhoff, KVL) énonce que dans toute maille '
        '(boucle fermée) d\'un circuit, la somme algébrique des tensions est nulle : ΣU = 0. '
        'On parcourt la maille dans un sens choisi, et on prend +U si on traverse une source '
        'dans le sens + vers -, et -U si on traverse une résistance dans le sens du courant.\n\n'
        'Une méthode systématique pour résoudre un circuit :\n'
        '1. Choisir les directions des courants dans chaque branche\n'
        '2. Appliquer la loi des nœuds à chaque nœud\n'
        '3. Appliquer la loi des mailles à chaque maille indépendante\n'
        '4. Résoudre le système d\'équations\n\n'
        'Le théorème de superposition s\'applique aux circuits linéaires (uniquement résistances '
        'et sources). Pour chaque source, on calcule sa contribution en laissant les autres sources '
        'actives (tension → court-circuit, courant → circuit ouvert) puis on additionne.',
    example:
        'Exemple — Deux sources :\n\n'
        'Deux batteries (E₁ = 12 V, E₂ = 6 V) et trois résistances (R₁ = 4 Ω, R₂ = 2 Ω, '
        'R₃ = 6 Ω) forment le circuit suivant : E₁ et R₁ dans la branche gauche, '
        'E₂ et R₂ dans la branche droite, R₃ au centre.\n\n'
        'Étape 1 : Lois des nœuds\n'
        'Au nœud supérieur : I₁ + I₂ = I₃ (en prenant I₃ descendant à travers R₃)\n\n'
        'Étape 2 : Lois des mailles\n'
        'Maille gauche : E₁ - R₁·I₁ - R₃·I₃ = 0 → 12 - 4I₁ - 6I₃ = 0\n'
        'Maille droite : E₂ - R₂·I₂ - R₃·I₃ = 0 → 6 - 2I₂ - 6I₃ = 0\n\n'
        'Étape 3 : Résolution\n'
        'De la maille gauche : 4I₁ = 12 - 6I₃ → I₁ = 3 - 1,5I₃\n'
        'De la maille droite : 2I₂ = 6 - 6I₃ → I₂ = 3 - 3I₃\n'
        'KCL : (3 - 1,5I₃) + (3 - 3I₃) = I₃\n'
        '6 - 4,5I₃ = I₃ → 6 = 5,5I₃ → I₃ ≈ 1,09 A\n'
        'I₁ = 3 - 1,5(1,09) = 1,36 A, I₂ = 3 - 3(1,09) = -0,27 A\n\n'
        'Résultat : I₁ = 1,36 A, I₂ = -0,27 A (sens opposé), I₃ = 1,09 A.',
    takeaways: [
      'Loi des nœuds (KCL) : ΣI_entrant = ΣI_sortant, conservation de la charge',
      'Loi des mailles (KVL) : ΣU = 0 dans toute boucle, conservation de l\'énergie',
      'Le théorème de superposition s\'applique aux circuits linéaires',
      'La résolution systématique : nœuds + mailles + système d\'équations',
    ],
  ),

  'physique_c_ch4_l3': const LessonContent(
    introText:
        'Les générateurs et récepteurs sont les deux types fondamentaux de composants électriques. '
        'Un générateur fournit de l\'énergie électrique, tandis qu\'un récepteur la consomme. '
        'Comprendre leur comportement est essentiel pour analyser tout circuit.',
    lessonBody:
        'Un générateur est un dispositif qui convertit une autre forme d\'énergie (chimique, '
        'mécanique, etc.) en énergie électrique. Un générateur réel est modélisé par une force '
        'électromotrice (f.é.m.) E en série avec une résistance interne r. La tension aux bornes '
        'est U = E - r·I (en régime débit, le générateur délivre du courant).\n\n'
        'Un récepteur est un dispositif qui convertit l\'énergie électrique en une autre forme '
        '(chaleur, lumière, mouvement). La tension aux bornes d\'un récepteur ohmique est U = R·I. '
        'La puissance consommée est P = U·I = R·I².\n\n'
        'La convention de signes est importante :\n'
        '• Générateur en régime débit : U = E - r·I, le courant sort du pôle +\n'
        '• Générateur en régime charge : U = E + r·I, le courant entre dans le pôle +\n'
        '• Récepteur : U = R·I, le courant entre par le potentiel le plus haut\n\n'
        'Le rendement d\'un générateur est η = P_utile/P_totale = U·I/(E·I) = U/E = R/(R+r). '
        'Le rendement est maximal quand la résistance de charge R est grande par rapport à r.\n\n'
        'La puissance maximale délivrée par un générateur est obtenue pour R = r : '
        'P_max = E²/(4r). C\'est le théorème de Maximum de Puissance de Jacobi.',
    example:
        'Exemple — Générateur et récepteur :\n\n'
        'Un générateur a E = 24 V et r = 2 Ω. Il est relié à une résistance de charge R = 10 Ω.\n\n'
        'Étape 1 : Courant du circuit\n'
        'I = E/(R + r) = 24/(10 + 2) = 2 A\n\n'
        'Étape 2 : Tensions\n'
        'U_récepteur = R·I = 10 × 2 = 20 V\n'
        'U_générateur = E - r·I = 24 - 2 × 2 = 20 V ✓\n\n'
        'Étape 3 : Puissances\n'
        'P_totale = E·I = 24 × 2 = 48 W\n'
        'P_utile = U·I = 20 × 2 = 40 W\n'
        'P_dissipée_internes = r·I² = 2 × 4 = 8 W\n'
        'Vérification : 40 + 8 = 48 W ✓\n\n'
        'Étape 4 : Rendement\n'
        'η = P_utile/P_totale = 40/48 = 83,3%\n'
        'η = R/(R+r) = 10/12 = 83,3% ✓\n\n'
        'Résultat : le courant est 2 A, le rendement est 83,3% et la puissance utile est 40 W.',
    takeaways: [
      'Un générateur réel : E (f.é.m.) et r (résistance interne), U = E - rI en débit',
      'Un récepteur ohmique : U = RI, consomme de l\'énergie',
      'Le rendement η = R/(R+r) est maximal quand R >> r',
      'Puissance maximale pour R = r : P_max = E²/(4r) (Jacobi)',
    ],
  ),

  // =========================================================================
  // Chapitre 5 — Circuits RC, RL, RLC
  // =========================================================================

  'physique_c_ch5_l1': const LessonContent(
    introText:
        'Le circuit RC associe une résistance et un condensateur. Il est essentiel pour comprendre '
        'les phénomènes de charge et de décharge, les filtres et les circuits de temporisation. '
        'Le temps caractéristique τ = RC gouverne la dynamique du circuit.',
    lessonBody:
        'Un circuit RC est constitué d\'une résistance R et d\'un condensateur de capacité C '
        'en série, reliés à une source de tension E.\n\n'
        'Le condensateur est un composant qui stocke de l\'énergie sous forme de champ électrique. '
        'Sa relation fondamentale est Q = C·U, où Q est la charge (en coulombs), C la capacité '
        '(en farads) et U la tension aux bornes.\n\n'
        'Lors de la charge (fermeture de l\'interrupteur), la tension aux bornes du condensateur '
        'évolue selon : u_C(t) = E·(1 - e^(-t/τ)), avec τ = R·C (constante de temps en secondes). '
        'Le courant est i(t) = (E/R)·e^(-t/τ). Le courant est maximal à l\'instant de la fermeture '
        '(i₀ = E/R) puis décroît exponentiellement.\n\n'
        'Lors de la décharge (source retirée), la tension décroît : '
        'u_C(t) = U₀·e^(-t/τ), où U₀ est la tension initiale. Le courant est '
        'i(t) = -(U₀/R)·e^(-t/τ) (sens opposé à la charge).\n\n'
        'Le temps caractéristique τ = RC est le temps nécessaire pour que la tension atteigne '
        '63,2% de sa valeur finale (en charge) ou décroisse de 36,8% de sa valeur initiale '
        '(en décharge). Après 5τ, le processus est considéré comme terminé (99,3%).\n\n'
        'L\'énergie stockée dans un condensateur est W = ½·C·U² = Q²/(2C) = ½·Q·U.',
    example:
        'Exemple — Charge d\'un condensateur :\n\n'
        'Un circuit RC avec R = 100 kΩ, C = 100 μF et E = 12 V. Le condensateur est initialement '
        'déchargé.\n\n'
        'Étape 1 : Constante de temps\n'
        'τ = R·C = 100 × 10³ × 100 × 10⁻⁶ = 10 s\n\n'
        'Étape 2 : Évolution de la tension\n'
        'À t = τ = 10 s : u_C = 12(1 - e⁻¹) = 12 × 0,632 = 7,58 V\n'
        'À t = 3τ = 30 s : u_C = 12(1 - e⁻³) = 12 × 0,950 = 11,40 V\n'
        'À t = 5τ = 50 s : u_C = 12(1 - e⁻⁵) = 12 × 0,993 = 11,92 V\n\n'
        'Étape 3 : Courant\n'
        'i₀ = E/R = 12/100 000 = 0,12 mA\n'
        'À t = 10 s : i = 0,12 × e⁻¹ ≈ 0,044 mA\n\n'
        'Étape 4 : Énergie finale\n'
        'W = ½·C·E² = ½ × 100 × 10⁻⁶ × 144 = 7,2 mJ\n\n'
        'Résultat : τ = 10 s, le condensateur est chargé à 99,3% après 50 s.',
    takeaways: [
      'Le circuit RC a une constante de temps τ = RC',
      'Charge : u_C(t) = E(1 - e^(-t/τ)), décharge : u_C(t) = U₀·e^(-t/τ)',
      'Après 5τ, le processus est considéré comme terminé (99,3%)',
      'L\'énergie stockée : W = ½CU²',
    ],
  ),

  'physique_c_ch5_l2': const LessonContent(
    introText:
        'Le circuit RL associe une résistance et une bobine (inductance). La self-induction '
        's\'oppose aux variations de courant, créant un retard dans l\'établissement ou la '
        'disparition du courant. Le temps caractéristique est τ = L/R.',
    lessonBody:
        'Un circuit RL est constitué d\'une résistance R et d\'une bobine d\'inductance L '
        'en série, reliés à une source de tension E.\n\n'
        'La bobine est un composant qui stocke de l\'énergie sous forme de champ magnétique. '
        'Sa relation fondamentale est u_L = L·di/dt, où L est l\'inductance (en henrys). '
        'La self-induction s\'oppose aux variations de courant (loi de Lenz).\n\n'
        'Lors de l\'établissement du courant (fermeture de l\'interrupteur), le courant croît '
        'selon : i(t) = (E/R)·(1 - e^(-t/τ)), avec τ = L/R (constante de temps en secondes). '
        'La tension aux bornes de la bobine est u_L(t) = E·e^(-t/τ).\n\n'
        'Lors de la coupure (source retirée), le courant décroît : '
        'i(t) = I₀·e^(-t/τ), où I₀ est le courant initial. La tension aux bornes de la bobine '
        'est u_L(t) = -L·I₀/τ·e^(-t/τ) = -E·e^(-t/τ). Cette tension inverse peut être '
        'très élevée lors de la coupure (phénomène de self-induction).\n\n'
        'Le temps caractéristique τ = L/R est le temps nécessaire pour que le courant atteigne '
        '63,2% de sa valeur finale (établissement) ou décroisse de 36,8% (coupure). '
        'Après 5τ, le courant est considéré comme établi ou éteint.\n\n'
        'L\'énergie stockée dans la bobine est W = ½·L·I².',
    example:
        'Exemple — Circuit RL :\n\n'
        'Un circuit RL avec L = 2 H, R = 100 Ω et E = 24 V.\n\n'
        'Étape 1 : Constante de temps\n'
        'τ = L/R = 2/100 = 0,02 s = 20 ms\n\n'
        'Étape 2 : Établissement du courant\n'
        'I_max = E/R = 24/100 = 0,24 A\n'
        'À t = τ = 20 ms : i = 0,24(1 - e⁻¹) = 0,24 × 0,632 = 0,152 A\n'
        'À t = 3τ = 60 ms : i = 0,24(1 - e⁻³) = 0,24 × 0,950 = 0,228 A\n'
        'À t = 5τ = 100 ms : i = 0,24(1 - e⁻⁵) = 0,24 × 0,993 = 0,238 A\n\n'
        'Étape 3 : Tension aux bornes de la bobine\n'
        'À t = 0 : u_L = E = 24 V (courant nul)\n'
        'À t = 20 ms : u_L = 24 × e⁻¹ ≈ 8,83 V\n'
        'À t = 100 ms : u_L ≈ 0,17 V\n\n'
        'Étape 4 : Énergie finale\n'
        'W = ½·L·I² = ½ × 2 × (0,24)² = 0,0576 J ≈ 57,6 mJ\n\n'
        'Résultat : τ = 20 ms, I_max = 0,24 A, énergie = 57,6 mJ.',
    takeaways: [
      'Le circuit RL a une constante de temps τ = L/R',
      'La self-induction s\'oppose aux variations de courant (loi de Lenz)',
      'L\'énergie stockée : W = ½LI²',
      'La coupure brusque génère une tension inverse élevée (danger potentiel)',
    ],
  ),

  'physique_c_ch5_l3': const LessonContent(
    introText:
        'Le circuit RLC série associe une résistance, une bobine et un condensateur en série. '
        'Ce circuit est fondamental en électronique et en télécommunications, car il présente '
        'un phénomène de résonance à une fréquence précise.',
    lessonBody:
        'Le circuit RLC série est constitué d\'une résistance R, d\'une inductance L et '
        'd\'une capacité C en série, reliés à une source de tension sinusoïdale '
        'u(t) = U_m·sin(ωt).\n\n'
        'L\'impédance complexe du circuit est Z = R + j(ωL - 1/(ωC)). L\'impédance totale est '
        '|Z| = √(R² + (ωL - 1/(ωC))²). Le déphasage entre tension et courant est '
        'φ = arctan((ωL - 1/(ωC))/R).\n\n'
        'La pulsation de résonance est ω₀ = 1/√(LC). À la résonance, l\'impédance est minimale '
        '(|Z| = R) et le courant est maximal. Le déphasage est nul : tension et courant sont '
        'en phase. La fréquence de résonance est f₀ = 1/(2π·√(LC)).\n\n'
        'Le facteur de qualité est Q = ω₀·L/R = 1/(R·√(C/L)). Plus Q est grand, plus la '
        'résonance est marquée (pic étroit). La bande passante est Δω = ω₀/Q.\n\n'
        'À la résonance, les tensions aux bornes de L et C peuvent être très supérieures à '
        'la tension d\'alimentation : U_L = U_C = Q·U. C\'est l\'effet de tension de résonance.\n\n'
        'Le circuit RLC peut être sous-amorti (R petit, oscillations), critique (R = 2√(L/C)) '
        'ou sur-amorti (R grand, pas d\'oscillations). Le régime transitoire dépend de ces '
        'conditions.',
    example:
        'Exemple — Résonance RLC :\n\n'
        'Un circuit RLC série avec R = 10 Ω, L = 50 mH, C = 2 μF, alimenté par U = 5 V.\n\n'
        'Étape 1 : Pulsation et fréquence de résonance\n'
        'ω₀ = 1/√(LC) = 1/√(50×10⁻³ × 2×10⁻⁶) = 1/√(10⁻⁷) = 3162 rad/s\n'
        'f₀ = ω₀/(2π) = 3162/6,28 ≈ 503 Hz\n\n'
        'Étape 2 : Courant à la résonance\n'
        'I = U/R = 5/10 = 0,5 A (maximal)\n\n'
        'Étape 3 : Facteur de qualité\n'
        'Q = ω₀·L/R = 3162 × 0,05/10 = 15,8\n\n'
        'Étape 4 : Tensions aux bornes de L et C à la résonance\n'
        'U_L = Q·U = 15,8 × 5 = 79 V !\n'
        'U_C = Q·U = 79 V (en opposition de phase avec U_L)\n\n'
        'Étape 5 : Bande passante\n'
        'Δω = ω₀/Q = 3162/15,8 ≈ 200 rad/s\n'
        'Δf = Δω/(2π) ≈ 31,8 Hz\n\n'
        'Résultat : f₀ ≈ 503 Hz, Q = 15,8, U_L = U_C = 79 V à la résonance.',
    takeaways: [
      'L\'impédance : |Z| = √(R² + (ωL - 1/ωC)²)',
      'Résonance pour ω₀ = 1/√(LC) : courant maximal, déphasage nul',
      'Le facteur de qualité Q = ω₀L/R mesure la sélectivité du circuit',
      'À la résonance, U_L = U_C = Q·U (effet de tension)',
    ],
  ),

  // =========================================================================
  // Chapitre 6 — Ondes
  // =========================================================================

  'physique_c_ch6_l1': const LessonContent(
    introText:
        'Les ondes progressives transportent de l\'énergie sans transport de matière. Elles se '
        'propagent dans un milieu avec une vitesse caractéristique et portent une perturbation '
        'qui se déforme pas au fil du temps. Les ondes mécaniques nécessitent un milieu matériel.',
    lessonBody:
        'Une onde progressive est une perturbation qui se propage dans l\'espace avec une vitesse '
        'constante. On distingue les ondes mécaniques (nécessitent un milieu : son, vagues) '
        'et les ondes électromagnétiques (se propagent dans le vide : lumière, radio).\n\n'
        'L\'équation d\'une onde progressive sinusoïdale unidimensionnelle est : '
        'y(x, t) = A·sin(k·x - ω·t + φ₀), où A est l\'amplitude, k le nombre d\'onde '
        '(k = 2π/λ), ω la pulsation (ω = 2πf) et φ₀ la phase initiale. λ est la longueur '
        'd\'onde (en m), f la fréquence (en Hz).\n\n'
        'La vitesse de propagation est v = λ·f = ω/k. Pour les ondes mécaniques dans un milieu '
        'linéaire, v dépend des propriétés du milieu (élasticité, densité). Pour les ondes '
        'électromagnétiques dans le vide, v = c ≈ 3 × 10⁸ m/s.\n\n'
        'Le vecteur d\'onde \u20D7k est dirigé dans la direction de propagation. Une onde '
        'progressive se déplace dans le sens du vecteur d\'onde. L\'argument (k·x - ω·t) '
        'définit la phase. Deux points en phase sont distants d\'un nombre entier de λ.\n\n'
        'La puissance transportée par une onde est proportionnelle au carré de l\'amplitude : '
        'P ∝ A². L\'intensité (puissance par unité de surface) est I ∝ A².\n\n'
        'Le principe de Huygen dit que tout point atteint par une onde devient une nouvelle source '
        'secondaire d\'ondes. Ce principe explique la diffraction et la réflexion.',
    example:
        'Exemple — Onde mécanique :\n\n'
        'Une onde sur une corde a pour équation y(x, t) = 0,02·sin(4π·x - 100π·t) (x en m, t en s).\n\n'
        'Étape 1 : Identification des paramètres\n'
        'A = 0,02 m = 2 cm\n'
        'k = 4π rad/m → λ = 2π/k = 2π/(4π) = 0,5 m\n'
        'ω = 100π rad/s → f = ω/(2π) = 100π/(2π) = 50 Hz\n\n'
        'Étape 2 : Vitesse de propagation\n'
        'v = λ·f = 0,5 × 50 = 25 m/s\n'
        'Vérification : v = ω/k = 100π/(4π) = 25 m/s ✓\n\n'
        'Étape 3 : Phase à un point donné\n'
        'En x = 0,25 m, t = 0,01 s :\n'
        'φ = 4π(0,25) - 100π(0,01) = π - π = 0\n'
        'y = 0,02·sin(0) = 0 m (point traversé par le nœud)\n\n'
        'Étape 4 : Temps pour parcourir 10 m\n'
        't = d/v = 10/25 = 0,4 s\n\n'
        'Résultat : λ = 0,5 m, f = 50 Hz, v = 25 m/s.',
    takeaways: [
      'L\'onde sinusoïdale : y = A·sin(kx - ωt + φ₀)',
      'La vitesse v = λf = ω/k, constante dans un milieu linéaire',
      'La puissance est proportionnelle au carré de l\'amplitude (P ∝ A²)',
      'Le principe de Huygen explique la diffraction et la réflexion',
    ],
  ),

  'physique_c_ch6_l2': const LessonContent(
    introText:
        'Le son est une onde mécanique de compression-rarefaction qui se propage dans l\'air '
        'ou tout autre milieu élastique. Sa perception par l\'oreille humaine dépend de la fréquence '
        '(hauteur) et de l\'amplitude (intensité sonore).',
    lessonBody:
        'Le son est une onde longitudinale : les vibrations du milieu sont parallèles à la direction '
        'de propagation. Dans l\'air, les molécules alternent entre zones de compression (haute pression) '
        'et de rarefaction (basse pression).\n\n'
        'La vitesse du son dans l\'air dépend de la température : v = 331 + 0,6·T (en m/s, '
        'T en °C). À 20°C, v ≈ 343 m/s. La vitesse est plus grande dans les solides que dans '
        'les gaz, car les solides sont plus élastiques.\n\n'
        'La fréquence du son audible par l\'oreille humaine va de 20 Hz à 20 000 Hz (20 kHz). '
        'Les sons de fréquence inférieure sont des infrasons, ceux de fréquence supérieure sont '
        'des ultrasons.\n\n'
        'L\'intensité sonore est la puissance transportée par unité de surface : I = P/S. '
        'L\'unité est le watt par mètre carré (W/m²). L\'échelle logarithmique du niveau '
        'd\'intensité est : L = 10·log₁₀(I/I₀), où I₀ = 10⁻¹² W/m² est le seuil d\'audibilité. '
        'L\'unité est le décibel (dB).\n\n'
        'Le niveau sonore normal est d\'environ 60 dB (conversation). Le seuil de douleur est '
        'environ 120 dB. Chaque augmentation de 10 dB correspond à une multiplication de l\'intensité '
        'par 10.\n\n'
        'L\'amplitude du son est liée au volume (pression sonore). La hauteur est liée à la fréquence. '
        'Le timbre dépend des harmoniques (spectre de fréquences).',
    example:
        'Exemple — Niveau sonore :\n\n'
        'Un orchestre produit une intensité sonore de I = 0,1 W/m². Calculer le niveau d\'intensité '
        'et comparer avec une conversation (60 dB).\n\n'
        'Étape 1 : Niveau d\'intensité\n'
        'L = 10·log₁₀(I/I₀) = 10·log₁₀(0,1/10⁻¹²)\n'
        'L = 10·log₁₀(10¹¹) = 10 × 11 = 110 dB\n\n'
        'Étape 2 : Rapport des intensités\n'
        'I_conversation = I₀·10^(60/10) = 10⁻¹² × 10⁶ = 10⁻⁶ W/m²\n'
        'I_orchestre/I_conversation = 0,1/10⁻⁶ = 10⁵\n'
        'L\'orchestre est 100 000 fois plus intense qu\'une conversation.\n\n'
        'Étape 3 : Vitesse du son à 35°C\n'
        'v = 331 + 0,6 × 35 = 331 + 21 = 352 m/s\n\n'
        'Étape 4 : Longueur d\'onde d\'un son à 440 Hz\n'
        'λ = v/f = 343/440 ≈ 0,78 m (à 20°C)\n\n'
        'Résultat : L = 110 dB, l\'orchestre est 10⁵ fois plus intense qu\'une conversation.',
    takeaways: [
      'Le son est une onde longitudinale de compression-rarefaction',
      'La vitesse dans l\'air : v = 331 + 0,6T (m/s)',
      'Le niveau d\'intensité : L = 10·log(I/I₀) en dB, seuil I₀ = 10⁻¹² W/m²',
      'L\'audible humain : 20 Hz à 20 kHz, chaque +10 dB = ×10 en intensité',
    ],
  ),

  'physique_c_ch6_l3': const LessonContent(
    introText:
        'L\'effet Doppler est le changement de fréquence perçue par un observateur lorsque '
        'la source ou l\'observateur est en mouvement relatif. Ce phénomène est observable '
        'avec le son (ambulance qui s\'approche) et avec la lumière (décalage spectral).',
    lessonBody:
        'L\'effet Doppler sonore se produit lorsqu\'il y a un mouvement relatif entre la source '
        'et l\'observateur. La fréquence perçue f\' est différente de la fréquence émise f₀.\n\n'
        'Formule générale (source et observateur en mouvement dans le même milieu) : '
        'f\' = f₀ × (v ± v_o)/(v ∓ v_s), où v est la vitesse du son dans le milieu, '
        'v_o la vitesse de l\'observateur et v_s la vitesse de la source.\n\n'
        'Convention de signes :\n'
        '• Source qui se rapproche : on prend - v_s (le numérateur diminue → f\' augmente)\n'
        '• Source qui s\'éloigne : on prend + v_s (le numérateur augmente → f\' diminue)\n'
        '• Observateur qui se rapproche : on prend + v_o (le dénominateur augmente → f\' augmente)\n'
        '• Observateur qui s\'éloigne : on prend - v_o (le dénominateur diminue → f\' diminue)\n\n'
        'La variation de fréquence est Δf = f\' - f₀. Si f\' > f₀, le son est plus aigu '
        '(source se rapproche). Si f\' < f₀, le son est plus grave (source s\'éloigne).\n\n'
        'Le cas particulier de la source supersonique (v_s > v) crée un cône de Mach. '
        'L\'angle de demi-ouverture est donné par sin(α) = v/v_s. Ce cône est responsable du '
        'bang sonique.',
    example:
        'Exemple — Ambulance :\n\n'
        'Une ambulance émettant un signal à 800 Hz se déplace à 30 m/s vers un observateur '
        'immobile. v = 343 m/s.\n\n'
        'Étape 1 : Fréquence perçue (source se rapproche)\n'
        'f\' = f₀ × v/(v - v_s) = 800 × 343/(343 - 30)\n'
        'f\' = 800 × 343/313 = 800 × 1,096 ≈ 877 Hz\n\n'
        'Étape 2 : Variation de fréquence\n'
        'Δf = f\' - f₀ = 877 - 800 = +77 Hz\n'
        'Le son est perçu plus aigu.\n\n'
        'Étape 3 : Cas où l\'ambulance s\'éloigne\n'
        'f\' = 800 × 343/(343 + 30) = 800 × 343/373 ≈ 736 Hz\n'
        'Δf = 736 - 800 = -64 Hz (son plus grave)\n\n'
        'Étape 4 : Cas avec observateur en mouvement\n'
        'Si l\'observateur se déplace à 10 m/s vers l\'ambulance (immobile) :\n'
        'f\' = 800 × (343 + 10)/343 = 800 × 353/343 ≈ 829 Hz\n\n'
        'Résultat : f\' ≈ 877 Hz quand l\'ambulance approche, 736 Hz quand elle s\'éloigne.',
    takeaways: [
      'L\'effet Doppler : f\' = f₀(v ± v_o)/(v ∓ v_s)',
      'Source se rapproche → fréquence perçue plus élevée (son plus aigu)',
      'Source supersonique (v_s > v) → cône de Mach et bang sonique',
      'La convention de signes dépend du sens de mouvement relatif',
    ],
  ),

  // =========================================================================
  // Chapitre 7 — Optique
  // =========================================================================

  'physique_c_ch7_l1': const LessonContent(
    introText:
        'Les lentilles minces sont des éléments optiques transparents qui dévient les rayons '
        'lumineux par réfraction. Elles sont essentielles en optique géométrique et permettent '
        'de former des images réelles ou virtuelles d\'objets.',
    lessonBody:
        'Une lentille mince est un système optique centré constitué de deux surfaces sphériques. '
        'On distingue les lentilles convergentes (épaisses au centre) et divergentes (minces au centre).\n\n'
        'La formule des lentilles minces relie la distance objets u, la distance image v et la '
        'distance focale f : 1/u + 1/v = 1/f. Cette relation signifie que si on connaît '
        'deux des trois grandeurs, on peut calculer la troisième.\n\n'
        'Le grossissement longitudinal est G = v/u. Si G > 0, l\'image est virtuelle. '
        'Si G < 0, l\'image est réelle. Le grossissement transverse est m = h\'/h = -v/u, '
        'où h est la taille de l\'objet et h\' la taille de l\'image.\n\n'
        'Pour une lentille convergente (f > 0) :\n'
        '• u > 2f : image réelle, renversée, réduite (G < -1)\n'
        '• u = 2f : image réelle, renversée, de même taille (G = -1)\n'
        '• f < u < 2f : image réelle, renversée, agrandie (-1 < G < 0)\n'
        '• u = f : image à l\'infini\n'
        '• u < f : image virtuelle, droite, agrandie (G > 1)\n\n'
        'La construction graphique utilise trois rayons principaux : le rayon parallèle à l\'axe '
        'optique (passe par le foyer), le rayon par le centre optique (non dévié) et le rayon '
        'passant par le foyer (sort parallèle).',
    example:
        'Exemple — Lentille convergente :\n\n'
        'Une lentille convergente de distance focale f = 10 cm est placée devant un objet '
        'de taille h = 3 cm situé à u = 25 cm.\n\n'
        'Étape 1 : Distance de l\'image\n'
        '1/v = 1/f - 1/u = 1/10 - 1/25 = (5-2)/50 = 3/50\n'
        'v = 50/3 ≈ 16,67 cm\n\n'
        'Étape 2 : Nature de l\'image\n'
        'v > 0 et u > 0 → image réelle (car G = v/u > 0 → non, G < 0 car v > 0)\n'
        'v = 16,67 cm > 0 → image réelle, du côté opposé à l\'objet\n\n'
        'Étape 3 : Grossissement\n'
        'G = -v/u = -16,67/25 = -0,667\n'
        'L\'image est réduite (|G| < 1) et renversée (G < 0)\n\n'
        'Étape 4 : Taille de l\'image\n'
        'h\' = |G| × h = 0,667 × 3 = 2 cm\n\n'
        'Vérification : 1/25 + 1/16,67 = 0,04 + 0,06 = 0,1 = 1/10 ✓\n\n'
        'Résultat : image réelle, renversée, réduite à 16,67 cm, taille 2 cm.',
    takeaways: [
      'Formule des lentilles minces : 1/u + 1/v = 1/f',
      'Image réelle si v > 0, virtuelle si v < 0',
      'Grossissement G = -v/u : négatif = renversé, |G| > 1 = agrandi',
      'Trois rayons pour la construction graphique : parallèle, centre, focal',
    ],
  ),

  'physique_c_ch7_l2': const LessonContent(
    introText:
        'Les miroirs sphériques sont des surfaces réfléchissantes sphériques qui forment des images '
        'par réflexion. Ils sont utilisés dans les télescopes, les phares et les instruments '
        'optiques. Leur analyse est similaire à celle des lentilles minces.',
    lessonBody:
        'Un miroir sphérique est une portion de sphère réfléchissante. On distingue le miroir '
        'convexe (surface externe, focale virtuelle) et le miroir concave (surface interne, '
        'focale réelle).\n\n'
        'La formule des miroirs sphériques est identique à celle des lentilles : '
        '1/u + 1/v = 1/f, où f = R/2 (R est le rayon de courbure). On utilise la convention '
        'de signes : distances réelles positives, distances virtuelles négatives.\n\n'
        'Pour un miroir concave (f > 0) :\n'
        '• u > 2f : image réelle, renversée, réduite\n'
        '• u = 2f : image réelle, renversée, de même taille\n'
        '• f < u < 2f : image réelle, renversée, agrandie\n'
        '• u = f : image à l\'infinité (miroir focalisateur)\n'
        '• u < f : image virtuelle, droite, agrandie (miroir de maquillage)\n\n'
        'Pour un miroir convex (f < 0) : l\'image est toujours virtuelle, droite et réduite, '
        'quelle que soit la position de l\'objet.\n\n'
        'Le grossissement est G = -v/u. La relation avec les lentilles est : un miroir concave '
        'agit comme une lentille convergente, et un miroir convex comme une lentille divergente.\n\n'
        'Les miroirs sphériques présentent l\'aberration sphérique : les rayons périphériques '
        'ne convergent pas au même point que les rayons paraxiaux. Les miroirs paraboliques '
        'corrigent ce défaut.',
    example:
        'Exemple — Miroir concave :\n\n'
        'Un miroir concave a un rayon de courbure R = 40 cm. Un objet de 5 cm est placé '
        'à u = 15 cm.\n\n'
        'Étape 1 : Distance focale\n'
        'f = R/2 = 40/2 = 20 cm\n\n'
        'Étape 2 : Distance de l\'image\n'
        '1/v = 1/f - 1/u = 1/20 - 1/15 = (3-4)/60 = -1/60\n'
        'v = -60 cm\n\n'
        'Étape 3 : Nature de l\'image\n'
        'v < 0 → image virtuelle, du même côté que l\'objet\n'
        'u = 15 cm < f = 20 cm → cohérent avec image virtuelle\n\n'
        'Étape 4 : Grossissement\n'
        'G = -v/u = -(-60)/15 = 4\n'
        'L\'image est agrandie 4 fois et droite (G > 0)\n\n'
        'Étape 5 : Taille de l\'image\n'
        'h\' = G × h = 4 × 5 = 20 cm\n\n'
        'Résultat : image virtuelle, droite, agrandie 4× à 60 cm devant le miroir.',
    takeaways: [
      'La formule des miroirs : 1/u + 1/v = 1/f avec f = R/2',
      'Miroir concave : image réelle ou virtuelle selon u vs f',
      'Miroir convex : toujours image virtuelle, droite, réduite',
      'L\'aberration sphérique est corrigée par les miroirs paraboliques',
    ],
  ),

  'physique_c_ch7_l3': const LessonContent(
    introText:
        'La diffraction et les interférences sont des phénomènes ondulatoires qui prouvent la nature '
        'ondulatoire de la lumière. La diffraction est la déviation d\'une onde au voisinage d\'un obstacle, '
        'et les interférences résultent de la superposition de deux ondes cohérentes.',
    lessonBody:
        'La diffraction est la déviation d\'une onde au passage d\'un obstacle ou d\'une ouverture. '
        'Elle est particulièrement visible lorsque la taille de l\'ouverture est du même ordre '
        'de grandeur que la longueur d\'onde. Le principe de Huygen-Fresnel explique ce phénomène : '
        'chaque point de l\'onde incidente devient une source secondaire.\n\n'
        'La diffraction par une fente unique produit un motif de diffraction avec un maximum central '
        'large et des minima aux angles θ tels que a·sin(θ) = n·λ, où a est la largeur de la fente '
        'et n un entier non nul.\n\n'
        'Les interférences se produisent lorsque deux ondes cohérentes (même fréquence, déphasage '
        'constant) se superposent. L\'amplitude résultante dépend du déphasage Δφ entre les ondes.\n\n'
        'Le dispositif de Young (deux fentes) produit un système de franges d\'interférence. '
        'Les franges brillantes (maxima) sont aux angles tels que d·sin(θ) = n·λ, où d est '
        'la distance entre les fentes et n un entier. Les franges sombres (minima) sont aux angles '
        'tels que d·sin(θ) = (n + ½)·λ.\n\n'
        'La condition de cohérence est essentielle : deux sources sont cohérentes si elles ont '
        'la même fréquence et un déphasage constant. La lumière d\'une lampe classique n\'est pas '
        'cohérente, tandis que la lumière laser l\'est.\n\n'
        'Le critère de Rayleigh dit qu\'on peut distinguer deux sources si le maximum central '
        'de l\'une coïncide avec le premier minimum de l\'autre : θ_min = 1,22·λ/D, où D est '
        'le diamètre de l\'ouverture.',
    example:
        'Exemple — Dispositif de Young :\n\n'
        'Deux fentes séparées de d = 0,2 mm sont éclairées par une lumière verte (λ = 550 nm). '
        'L\'écran est à D = 2 m.\n\n'
        'Étape 1 : Position des franges brillantes\n'
        'd·sin(θ) = n·λ → sin(θ) = n·λ/d\n'
        'Pour n = 1 : sin(θ₁) = 550×10⁻⁹/(0,2×10⁻³) = 2,75×10⁻³\n'
        'θ₁ ≈ 2,75×10⁻³ rad ≈ 0,158°\n\n'
        'Étape 2 : Position sur l\'écran\n'
        'y₁ = D·tan(θ₁) ≈ D·θ₁ = 2 × 2,75×10⁻³ = 5,5 mm\n\n'
        'Étape 3 : Espacement des franges\n'
        'Δy = λ·D/d = 550×10⁻⁹ × 2/(0,2×10⁻³) = 5,5 mm\n'
        'Vérification : y₁ = Δy pour n = 1 ✓\n\n'
        'Étape 4 : Nombre de franges visibles\n'
        'Le maximum angle est sin(θ_max) = 1 → n_max = d/λ = 0,2×10⁻³/(550×10⁻⁶) ≈ 364\n'
        'Soit environ 364 franges de chaque côté du maximum central.\n\n'
        'Résultat : Δy = 5,5 mm entre deux franges brillantes consécutives.',
    takeaways: [
      'La diffraction est la déviation d\'onde au voisinage d\'un obstacle',
      'Dispositif de Young : franges brillantes pour d·sin(θ) = nλ',
      'L\'espacement des franges : Δy = λD/d',
      'Le critère de Rayleigh : θ_min = 1,22λ/D pour la résolution optique',
    ],
  ),

  // =========================================================================
  // Chapitre 8 — Nucléaire
  // =========================================================================

  'physique_c_ch8_l1': const LessonContent(
    introText:
        'La radioactivité est la propriété qu\'ont certains noyaux atomiques instables de se '
        'transformer spontanément en émettant des particules ou des rayonnements. Ce phénomène '
        'est à la base de nombreuses applications médicales et industrielles.',
    lessonBody:
        'La radioactivité est un phénomène nucléaire spontané. Un noyau instable (radioactif) '
        'se transforme en un autre noyau en émettant des particules et/ou des rayonnements. '
        'On distingue trois types principaux de radioactivité :\n\n'
        'Radioactivité α : émission d\'un noyau d\'hélium (⁴₂He), formé de 2 protons et 2 neutrons. '
        'Le noyau fils perd 4 unités de masse et 2 numéros atomiques. La rayonnement α est peu '
        'pénétrant (arrête par une feuille de papier) mais ionisant.\n\n'
        'Radioactivité β⁻ : émission d\'un électron (⁰₋₁e) et d\'un antineutrino (ν̄). '
        'Un neutron du noyau se transforme en proton : le numéro atomique Z augmente de 1, '
        'le nombre de masse A reste constant. La rayonnement β est moyennement pénétrant.\n\n'
        'Radioactivité γ : émission d\'un photon γ de très haute énergie. Le noyau fils est '
        'dans un état excité et retournant à l\'état fondamental en émettant un rayonnement '
        'électromagnétique. Le rayonnement γ est très pénétrant (nécessite un blindage en plomb).\n\n'
        'La loi de désintégration radioactive : N(t) = N₀·e^(-λt), où N₀ est le nombre initial '
        'de noyaux et λ la constante de désintégration. La durée de vie moyenne est τ = 1/λ. '
        'La demi-vie est t₁/₂ = ln(2)/λ ≈ 0,693/λ.\n\n'
        'L\'activité radioactive est A = λ·N (en becquerels, Bq : 1 Bq = 1 désintégration/s). '
        'L\'unité ancienne est le curie : 1 Ci = 3,7 × 10¹⁰ Bq.',
    example:
        'Exemple — Désintégration radioactive :\n\n'
        'Un échantillon contient N₀ = 10²⁴ noyaux d\'un isotope radioactif. Sa demi-vie est '
        't₁/₂ = 5 ans.\n\n'
        'Étape 1 : Constante de désintégration\n'
        'λ = ln(2)/t₁/₂ = 0,693/(5 × 3,156 × 10⁷ s) = 4,39 × 10⁻⁹ s⁻¹\n\n'
        'Étape 2 : Nombre de noyaux après 15 ans\n'
        'N(15) = N₀·e^(-λt) = 10²⁴ × e^(-λ × 15 × 3,156×10⁷)\n'
        'Simplification : N(15) = N₀ × (1/2)^(15/5) = 10²⁴ × (1/2)³ = 10²⁴/8 = 1,25 × 10²³\n\n'
        'Étape 3 : Activité initiale\n'
        'A₀ = λ·N₀ = 4,39 × 10⁻⁹ × 10²⁴ = 4,39 × 10¹⁵ Bq ≈ 4,39 PBq\n\n'
        'Étape 4 : Énergie libérée (exemple alpha)\n'
        'Si chaque désintégration libère 5 MeV :\n'
        'E = A₀ × 5 MeV = 4,39 × 10¹⁵ × 5 × 1,6×10⁻¹³ J = 0,351 W\n\n'
        'Résultat : après 15 ans (3 demi-vies), il reste 1/8 des noyaux initiaux.',
    takeaways: [
      'Trois types : α (⁴He), β (électron), γ (photon haute énergie)',
      'Loi de désintégration : N(t) = N₀·e^(-λt)',
      'La demi-vie : t₁/₂ = ln(2)/λ, indépendante de la quantité initiale',
      'L\'activité A = λN mesure le nombre de désintegrations par seconde (Bq)',
    ],
  ),

  'physique_c_ch8_l2': const LessonContent(
    introText:
        'Les réactions nucléaires sont des transformations du noyau atomique provoquées par collision '
        'ou absorption de particules. Elles permettent de transmuter les éléments et libèrent '
        'de grandes quantités d\'énergie selon la relation d\'Einstein E = mc².',
    lessonBody:
        'Les réactions nucléaires se distinguent des réactions chimiques car elles modifient la '
        'composition du noyau (nombre de protons et/ou de neutrons). On les représente en notant '
        'les noyaux avec leur notation AZX, où A est le nombre de masse et Z le numéro atomique.\n\n'
        'Les lois de conservation s\'appliquent :\n'
        '• Conservation du numéro atomique : ΣZ_gauche = ΣZ_droite\n'
        '• Conservation du nombre de masse : ΣA_gauche = ΣA_droite\n'
        '• Conservation de l\'énergie (masse-énergie)\n'
        '• Conservation du moment cinétique et de la charge\n\n'
        'La réaction de fission nucléaire consiste à diviser un noyau lourd (comme l\'uranium 235) '
        'en deux noyaux plus légers, en libérant des neutrons et de l\'énergie. Exemple : '
        '²³⁵U + n → ¹⁴¹Ba + ⁹²Kr + 3n + énergie. Un seul noyau d\'U-235 libère environ 200 MeV.\n\n'
        'La réaction de fusion nucléaire consiste à fusionner deux noyaux légers pour former '
        'un noyau plus lourd. Exemple : ²H + ³H → ⁴He + n + 17,6 MeV. La fusion est la source '
        'd\'énergie du soleil.\n\n'
        'Le défaut de masse est la différence de masse entre les reactifs et les produits : '
        'Δm = Σm_gauche - Σm_droite. L\'énergie libérée est Q = Δm·c² (relation d\'Einstein). '
        'Si Δm > 0, la réaction est exothermique (libère de l\'énergie). Si Δm < 0, '
        'la réaction est endothermique.\n\n'
        'L\'énergie de liaison est l\'énergie nécessaire pour séparer tous les nucléons d\'un noyau. '
        'L\'énergie de liaison par nucléon est un indicateur de la stabilité du noyau. '
        'Le maximum est atteint pour le fer (⁵⁶Fe).',
    example:
        'Exemple — Fission de l\'uranium 235 :\n\n'
        '²³⁵U + ¹n → ¹⁴¹Ba + ⁹²Kr + 3·¹n\n\n'
        'Étape 1 : Vérification des lois de conservation\n'
        'Charge : 92 + 0 = 56 + 36 + 0 = 92 ✓\n'
        'Masse : 235 + 1 = 141 + 92 + 3 = 236 ✓\n\n'
        'Étape 2 : Défaut de masse\n'
        'Masses atomiques (en u) :\n'
        'm(²³⁵U) = 235,04393 u\n'
        'm(¹n) = 1,00866 u\n'
        'm(¹⁴¹Ba) = 140,91441 u\n'
        'm(⁹²Kr) = 91,92616 u\n\n'
        'Σm_reactifs = 235,04393 + 1,00866 = 236,05259 u\n'
        'Σm_produits = 140,91441 + 91,92616 + 3(1,00866) = 235,86655 u\n\n'
        'Δm = 236,05259 - 235,86655 = 0,18604 u\n\n'
        'Étape 3 : Énergie libérée\n'
        'Q = Δm × 931,5 MeV/u = 0,18604 × 931,5 ≈ 173,3 MeV\n\n'
        'Étape 4 : Masse convertie en énergie\n'
        'Δm = 0,18604 × 1,6605 × 10⁻²⁷ kg = 3,09 × 10⁻²⁸ kg\n'
        'Q = Δm·c² = 3,09×10⁻²⁸ × (3×10⁸)² ≈ 2,78×10⁻¹¹ J ≈ 173,3 MeV ✓\n\n'
        'Résultat : la fission d\'un noyau d\'U-235 libère environ 173 MeV.',
    takeaways: [
      'Les réactions nucléaires conservent Z et A (charges et masses)',
      'La fission divise un noyau lourd en noyaux légers + neutrons + énergie',
      'La fusion combine des noyaux légers (source d\'énergie du soleil)',
      'L\'énergie libérée : Q = Δm·c² (défaut de masse × c²)',
    ],
  ),

  // =========================================================================
  // Chapitre 9 — Magnétisme
  // =========================================================================

  'physique_c_ch9_l1': const LessonContent(
    introText:
        'Le champ magnétique est un champ vectoriel créé par les courants électriques et les '
        'aimants. Il exerce une force sur les charges en mouvement et les conducteurs parcourus '
        'par un courant. Le magnétisme est intimement lié à l\'électricité.',
    lessonBody:
        'Le champ magnétique \u20D7B est un vecteur mesuré en teslas (T). Il est créé par '
        'les courants électriques (loi de Biot-Savart) et les aimants permanents. Les lignes '
        'de champ magnétique sont des courbes fermées, sans début ni fin.\n\n'
        'La force de Lorentz est la force exercée par le champ magnétique sur une charge q '
        'en mouvement : \u20D7F = q·(\u20D7v × \u20D7B). Cette force est toujours perpendiculaire '
        'au mouvement, elle ne fournit aucun travail mais dévie la trajectoire. Sa norme est '
        'F = q·v·B·sin(θ), où θ est l\'angle entre \u20D7v et \u20D7B.\n\n'
        'La force sur un conducteur parcouru par un courant est : \u20D7F = I·(\u20D7L × \u20D7B), '
        'où \u20D7L est le vecteur longueur du conducteur dans le champ. Sa norme est '
        'F = I·L·B·sin(θ). Cette force est à la base du fonctionnement des moteurs électriques.\n\n'
        'Le champ magnétique terrestre protège la Terre du vent solaire. Il est modélisé par '
        'un dipôle magnétique. Les pôles magnétiques ne coïncident pas avec les pôles géographiques.\n\n'
        'Le flux magnétique à travers une surface S est Φ = B·S·cos(θ), où θ est l\'angle entre '
        '\u20D7B et la normale à la surface. L\'unité est le weber (Wb). '
        'Le flux est maximal lorsque le champ est perpendiculaire à la surface (θ = 0°).',
    example:
        'Exemple — Force sur un conducteur :\n\n'
        'Un fil de 20 cm parcouru par un courant de 5 A est placé dans un champ magnétique '
        'uniforme de 0,3 T. Le fil fait un angle de 30° avec le champ.\n\n'
        'Étape 1 : Force magnétique\n'
        'F = I·L·B·sin(θ) = 5 × 0,2 × 0,3 × sin(30°)\n'
        'F = 5 × 0,2 × 0,3 × 0,5 = 0,15 N\n\n'
        'Étape 2 : Direction de la force\n'
        'La force est perpendiculaire au plan formé par le fil et le champ (règle de la main droite).\n\n'
        'Étape 3 : Angle pour force maximale\n'
        'F_max = I·L·B = 5 × 0,2 × 0,3 = 0,3 N (pour θ = 90°)\n\n'
        'Étape 4 : Flux magnétique\n'
        'Si le champ traverse une bobine de 100 tours, surface 50 cm², perpendiculairement :\n'
        'Φ = N·B·S = 100 × 0,3 × 50×10⁻⁴ = 0,15 Wb\n\n'
        'Résultat : F = 0,15 N, direction perpendiculaire au fil et au champ.',
    takeaways: [
      'La force de Lorentz : \u20D7F = q(\u20D7v × \u20D7B), perpendiculaire au mouvement',
      'Force sur un conducteur : F = ILB·sin(θ)',
      'Le flux magnétique Φ = BS·cos(θ) en webers (Wb)',
      'Le champ magnétique terrestre protège du vent solaire',
    ],
  ),

  'physique_c_ch9_l2': const LessonContent(
    introText:
        'L\'induction électromagnétique est le phénomène par lequel un champ magnétique variable '
        'provoque l\'apparition d\'un courant électrique. Découverte par Faraday en 1831, '
        'c\'est le principe des générateurs, transformateurs et nombreuses applications modernes.',
    lessonBody:
        'La loi de Faraday-Neumann-Lenz énonce qu\'un champ magnétique variable à travers une '
        'bobine induit une f.é.m. (force électromotrice) proportionnelle à la variation du flux : '
        'ε = -dΦ/dt. Le signe - traduit la loi de Lenz : le courant induit s\'oppose à la '
        'variation qui le crée.\n\n'
        'Pour une bobine de N spires, la f.é.m. induite est ε = -N·dΦ/dt. Si le champ varie '
        'linéairement, on peut écrire ε = -N·ΔΦ/Δt.\n\n'
        'Les méthodes pour créer une f.é.m. induite sont :\n'
        '• Déplacer un aimant à l\'intérieur d\'une bobine\n'
        '• Modifier l\'intensité du courant dans un circuit voisin\n'
        '• Déplacer un conducteur dans un champ magnétique (f.é.m. de déplacement)\n\n'
        'La f.é.m. de déplacement est ε = B·L·v (pour un conducteur de longueur L se déplaçant '
        'à vitesse v perpendiculairement à un champ B). C\'est le principe des alternateurs.\n\n'
        'Le courant induit produit un champ magnétique qui s\'oppose la variation du flux (loi de Lenz). '
        'Si le flux augmente, le courant induit crée un champ en sens inverse. Si le flux diminue, '
        'le courant induit crée un champ dans le même sens.\n\n'
        'L\'énergie magnétique stockée dans une bobine est W = ½·L·I². La bobine s\'oppose aux '
        'variations de courant (self-induction).',
    example:
        'Exemple — Bobine dans un champ variable :\n\n'
        'Une bobine de 200 spires, de section 10 cm², est traversée par un champ magnétique '
        'uniforme qui augmente de 0,1 T à 0,5 T en 0,2 s.\n\n'
        'Étape 1 : Variation du flux\n'
        'ΔΦ = N·S·ΔB = 200 × 10×10⁻⁴ × (0,5 - 0,1)\n'
        'ΔΦ = 200 × 10⁻³ × 0,4 = 0,08 Wb\n\n'
        'Étape 2 : F.é.m. induite\n'
        'ε = -ΔΦ/Δt = -0,08/0,2 = -0,4 V\n'
        'La f.é.m. induite est de 0,4 V (le signe indique l\'opposition selon Lenz).\n\n'
        'Étape 3 : Si la bobine a une résistance R = 8 Ω\n'
        'I = |ε|/R = 0,4/8 = 0,05 A = 50 mA\n\n'
        'Étape 4 : F.é.m. de déplacement (cas alternatif)\n'
        'Un conducteur de 50 cm se déplace à 4 m/s perpendiculairement à B = 0,5 T :\n'
        'ε = B·L·v = 0,5 × 0,5 × 4 = 1 V\n\n'
        'Résultat : ε = 0,4 V, courant induit = 50 mA, direction selon la loi de Lenz.',
    takeaways: [
      'La loi de Faraday : ε = -N·dΦ/dt, f.é.m. proportionnelle à la variation du flux',
      'La loi de Lenz : le courant induit s\'oppose à la variation qui le crée',
      'La f.é.m. de déplacement : ε = BLv pour un conducteur en mouvement',
      'L\'induction est le principe des générateurs et transformateurs',
    ],
  ),
};
