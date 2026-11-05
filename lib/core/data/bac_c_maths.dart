import 'lesson_content_model.dart';

final Map<String, LessonContent> bacCMathsContent = {
  // ─── Chapitre 1 : Nombres complexes ───

  'maths_c_ch1_l1': const LessonContent(
    introText:
        'Les nombres complexes étendent les réels en ajoutant une partie imaginaire. '
        'On étudie ici leur forme algébrique et la notion de conjugué.',
    lessonBody:
        'Un nombre complexe s\'écrit z = a + ib où a et b sont des réels et i² = -1. '
        'La partie réelle de z est Re(z) = a et la partie imaginaire est Im(z) = b.\n\n'
        'Le conjugué de z = a + ib est le nombre z̄ = a - ib. On a les propriétés fondamentales : '
        'Re(z) = (z + z̄)/2, Im(z) = (z - z̄)/(2i), z · z̄ = a² + b² = |z|².\n\n'
        'L\'addition et la soustraction se font terme à terme : '
        '(a + ib) + (c + id) = (a + c) + i(b + d). La multiplication utilise i² = -1 : '
        '(a + ib)(c + id) = (ac - bd) + i(bc + ad).\n\n'
        'La division s\'effectue en multipliant par le conjugué du dénominateur : '
        '(a + ib)/(c + id) = [(a + ib)(c - id)] / (c² + d²). '
        'Deux complexes sont égaux si et seulement si leurs parties réelles sont égales '
        'et leurs parties imaginaires sont égales.',
    example:
        'Soit z = 3 + 4i. Calculons z · z̄ et z².\n\n'
        'z · z̄ = (3 + 4i)(3 - 4i) = 9 + 16 = 25 = |z|².\n'
        'z² = (3 + 4i)² = 9 + 24i + 16i² = 9 - 16 + 24i = -7 + 24i.\n\n'
        'Vérifions : |z²| = |z|² ⟹ √(49 + 576) = 25 ⟹ √625 = 25. ✓',
    takeaways: [
      'Un complexe z = a + ib se caractérise par Re(z) = a et Im(z) = b.',
      'Le conjugué z̄ = a - ib satisfait z · z̄ = |z|².',
      'Deux complexes sont égaux ⟺ parties réelles et imaginaires égales.',
      'La division de complexes s\'effectue en multipliant par le conjugué.',
    ],
  ),

  'maths_c_ch1_l2': const LessonContent(
    introText:
        'Le module et l\'argument décrivent un complexe en termes de distance et d\'angle. '
        'La forme exponentielle facilite puissances et produits.',
    lessonBody:
        'Le module de z = a + ib est |z| = √(a² + b²), distance de z à l\'origine dans le plan complexe.\n\n'
        'L\'argument de z ≠ 0 est un angle θ tel que a = |z|cos θ et b = |z|sin θ. '
        'L\'argument principal Arg(z) est l\'unique valeur dans ]-π, π]. '
        'On a tan(Arg(z)) = b/a avec attention au quadrant.\n\n'
        'La forme exponentielle est z = |z| · e^{iθ} avec θ = Arg(z). '
        'La formule d\'Euler donne e^{iθ} = cos θ + i sin θ.\n\n'
        'Pour z₁ = r₁ e^{iθ₁} et z₂ = r₂ e^{iθ₂} : z₁ · z₂ = r₁r₂ e^{i(θ₁+θ₂)} '
        'et z₁/z₂ = (r₁/r₂) e^{i(θ₁-θ₂)}. Les arguments s\'additionnent pour le produit '
        'et se soustraivent pour le quotient.\n\n'
        'Le théorème de Moivre : (e^{iθ})^n = e^{inθ} = cos(nθ) + i sin(nθ). '
        'Les racines n-ièmes de z = r e^{iθ} sont k = r^{1/n} e^{i(θ+2kπ)/n} pour k = 0, 1, ..., n-1.',
    example:
        'Calculons z = 1 + i en forme exponentielle, puis z⁵.\n\n'
        '|z| = √(1+1) = √2. Arg(z) = π/4 (cos π/4 = sin π/4 = √2/2).\n'
        'Donc z = √2 · e^{iπ/4}.\n\n'
        'z⁵ = (√2)⁵ · e^{i·5π/4} = 4√2 · e^{i·5π/4}.\n'
        'cos(5π/4) = -√2/2, sin(5π/4) = -√2/2.\n'
        'z⁵ = 4√2 · (-√2/2 - i√2/2) = -4 - 4i.',
    takeaways: [
      '|z| = √(a² + b²) mesure la distance à l\'origine.',
      'Arg(z) est l\'angle principal dans ]-π, π].',
      'z = |z| · e^{iθ} est la forme exponentielle (formule d\'Euler).',
      'Produit : modules multipliés, arguments additionnés.',
      'Racines n-ièmes : même module, arguments répartis uniformément.',
    ],
  ),

  'maths_c_ch1_l3': const LessonContent(
    introText:
        'Résoudre des équations complexes consiste à identifier parties réelles et imaginaires. '
        'On utilise souvent le conjugué ou la forme exponentielle.',
    lessonBody:
        'Une équation du type z² + az + b = 0 avec a, b ∈ ℂ se résout avec la formule quadratique : '
        'z = (-a ± √Δ) / 2 où Δ = a² - 4b.\n\n'
        'Si Δ > 0 : deux solutions réelles. Si Δ = 0 : une solution double. '
        'Si Δ < 0 : deux solutions conjuguées.\n\n'
        'Pour des équations de la forme az + bz̄ = c (avec a, b, c ∈ ℂ), on écrit z = x + iy '
        'et on sépare les parties réelles et imaginaires pour obtenir un système de deux équations à deux inconnues.\n\n'
        'Autre méthode : on prend le conjugué de l\'équation, ce qui donne une deuxième équation en z et z̄. '
        'On résout le système de deux équations linéaires en z et z̄.\n\n'
        'Pour zⁿ = w avec w = ρe^{iφ}, les solutions sont zₖ = ρ^{1/n} e^{i(φ + 2kπ)/n}, k = 0, ..., n-1. '
        'Ce sont n complexes disposés sur un cercle de rayon ρ^{1/n}.',
    example:
        'Résolvons z² - 2z + 5 = 0.\n\n'
        'Δ = 4 - 20 = -16 < 0.\n'
        '√Δ = 4i (car (4i)² = -16).\n'
        'z = (2 ± 4i) / 2 = 1 ± 2i.\n\n'
        'Vérifions z = 1 + 2i : z² = 1 + 4i - 4 = -3 + 4i.\n'
        '-3 + 4i - 2(1 + 2i) + 5 = -3 + 4i - 2 - 4i + 5 = 0. ✓\n'
        'Les solutions sont conjuguées : 1 + 2i et 1 - 2i.',
    takeaways: [
      'Formule quadratique : z = (-a ± √Δ) / 2 avec Δ = a² - 4b.',
      'Si Δ < 0, les deux solutions sont conjuguées.',
      'Pour az + bz̄ = c, on sépare parties réelles et imaginaires.',
      'Les n racines n-ièmes forment un polygone régulier dans le plan.',
    ],
  ),

  'maths_c_ch1_l4': const LessonContent(
    introText:
        'Les nombres complexes modélisent naturellement les transformations du plan : '
        'translations, rotations, homothéties et symétries.',
    lessonBody:
        'Translation de vecteur w : z ↦ z + w. On déplace chaque point du plan du même vecteur.\n\n'
        'Rotation d\'angle θ autour de l\'origine : z ↦ z · e^{iθ}. '
        'C\'est une multiplication par e^{iθ} qui tourne chaque point d\'angle θ.\n\n'
        'Homothétie de centre O et rapport k > 0 : z ↦ k · z. '
        'On dilate ou contracte chaque point par rapport à l\'origine.\n\n'
        'Combinaison : z ↦ az + b avec a, b ∈ ℂ. Si a = k · e^{iθ}, c\'est une rotation d\'angle θ, '
        'une homothétie de rapport k, puis une translation de vecteur b.\n\n'
        'Symétrie par rapport à un axe passant par l\'origine et faisant un angle α avec l\'axe réel : '
        'z ↦ e^{2iα} · z̄.\n\n'
        'Symétrie centrale par rapport à un point c : z ↦ 2c - z.\n\n'
        'Application aux triangles : trois points a, b, c forment un triangle équilatéral si et seulement si '
        'a² + b² + c² = ab + bc + ca.',
    example:
        'Trouvons l\'image de z = 1 + i par une rotation de π/2 autour de l\'origine suivie '
        'd\'une translation de vecteur 3 - 2i.\n\n'
        'Rotation : z · e^{iπ/2} = (1 + i) · i = i + i² = -1 + i.\n'
        'Translation : (-1 + i) + (3 - 2i) = 2 - i.\n\n'
        'L\'image est w = 2 - i.',
    takeaways: [
      'Translation : z ↦ z + w.',
      'Rotation d\'angle θ : z ↦ z · e^{iθ}.',
      'Homothétie de rapport k : z ↦ k · z.',
      'La transformation générale z ↦ az + b combine rotation, homothétie et translation.',
    ],
  ),

  // ─── Chapitre 2 : Limites et continuité ───

  'maths_c_ch2_l1': const LessonContent(
    introText:
        'La notion de limite est fondamentale en analyse. Elle formalise le comportement '
        'd\'une fonction quand l\'argument tend vers une valeur ou vers l\'infini.',
    lessonBody:
        'On dit que f(x) tend vers L quand x tend vers a, noté lim(x→a) f(x) = L, si pour tout ε > 0, '
        'il existe δ > 0 tel que |x - a| < δ ⟹ |f(x) - L| < ε.\n\n'
        'Limites usuelles : lim(x→0) sin(x)/x = 1, lim(x→+∞) (1 + 1/x)^x = e, '
        'lim(x→+∞) x^n / a^x = 0 pour a > 1 (l\'exponentielle l\'emporte sur le polynôme).\n\n'
        'Opérations sur les limites : si lim f = L et lim g = M, alors lim(f + g) = L + M, '
        'lim(f · g) = L · M, lim(f/g) = L/M (si M ≠ 0).\n\n'
        'Théorème d\'encadrement (sandwich) : si g(x) ≤ f(x) ≤ h(x) et lim g = lim h = L, '
        'alors lim f = L.\n\n'
        'Limites infinies : on note lim(x→a) f(x) = +∞ si f(x) croît au-delà de toute borne. '
        'Les branches infinies sont étudiées en chapitre dédié.\n\n'
        'La composition : si lim(x→a) g(x) = b et lim(y→b) f(y) = L, et si g(x) ≠ b au voisinage de a, '
        'alors lim(x→a) f(g(x)) = L.',
    example:
        'Calculons lim(x→0) (1 - cos x) / x².\n\n'
        'En utilisant 1 - cos x = 2sin²(x/2) :\n'
        'lim(x→0) 2sin²(x/2) / x² = lim(x→0) 2[sin(x/2)/(x/2)]² · (x/2)²/x²\n'
        '= 2 · 1² · 1/4 = 1/2.\n\n'
        'Limite : 1/2.',
    takeaways: [
      'Définition ε-δ : rigoureuse, fondamentale pour l\'analyse.',
      'Limites usuelles : sin(x)/x → 1, exponentielle l\'emporte sur polynôme.',
      'Théorème d\'encadrement : outil puissant pour des limites non triviales.',
      'Opérations compatibles avec les limites finies.',
    ],
  ),

  'maths_c_ch2_l2': const LessonContent(
    introText:
        'La continuité assure l\'absence de « sauts » dans le graphe d\'une fonction. '
        'Le théorème de la valeur intermédiaire (TVI) en est la conséquence clé.',
    lessonBody:
        'Une fonction f est continue en a si lim(x→a) f(x) = f(a). '
        'Autrement dit, la limite existe et coïncide avec la valeur de la fonction.\n\n'
        'Fonctions continues : polynômes, rationnelles (hors pôles), sin, cos, exp, ln, '
        'valeurs absolues. La composition de fonctions continues est continue.\n\n'
        'Théorème de la valeur intermédiaire (TVI) : si f est continue sur [a, b] '
        'et k est un réel compris entre f(a) et f(b), alors il existe c ∈ [a, b] '
        'tel que f(c) = k.\n\n'
        'Application fondamentale : si f est continue sur [a, b] et change de signe '
        '(f(a) · f(b) < 0), alors f s\'annule au moins une fois sur [a, b]. '
        'C\'est le principe de la méthode de dichotomie.\n\n'
        'Corollaire : f([a, b]) = [min, max] si f est continue sur un segment fermé. '
        'Toute fonction continue sur [a, b] admet un minimum et un maximum.\n\n'
        'Point de continuité : on distingue continuité à gauche (lim(x→a⁻) f(x) = f(a)) '
        'et continuité à droite (lim(x→a⁺) f(x) = f(a)). La fonction est continue en a '
        'si et seulement si elle est continue à gauche et à droite.',
    example:
        'Montrons que x³ - x - 1 = 0 admet au moins une solution dans [1, 2].\n\n'
        'Posons f(x) = x³ - x - 1. f est polynomiale, donc continue sur [1, 2].\n'
        'f(1) = 1 - 1 - 1 = -1 < 0.\n'
        'f(2) = 8 - 2 - 1 = 5 > 0.\n\n'
        'Par le TVI, il existe c ∈ [1, 2] tel que f(c) = 0. ✓\n'
        'La méthode de dichotomie localise la racine dans [1, 2].',
    takeaways: [
      'Continue en a ⟺ continue à gauche ET à droite, ET valeurs égales.',
      'TVI : si f continue sur [a, b] et f(a) < k < f(b), alors ∃c : f(c) = k.',
      'Si f change de signe sur [a, b], alors f s\'annule au moins une fois.',
      'Fonction continue sur segment fermé admet min et max.',
    ],
  ),

  'maths_c_ch2_l3': const LessonContent(
    introText:
        'Les branches infinies décrivent le comportement d\'une fonction quand x tend vers '
        'un point où elle « explose ». On distingue asymptotes verticales et obliques.',
    lessonBody:
        'Une fonction f admet une asymptote verticale d\'équation x = a si lim(x→a) f(x) = ±∞. '
        'Cela se produit typiquement en un zéro du dénominateur (pôle).\n\n'
        'Asymptote oblique : f admet une oblique d\'équation y = ax + b si '
        'lim(x→+∞) [f(x) - (ax + b)] = 0. On calcule a = lim(x→+∞) f(x)/x '
        'puis b = lim(x→+∞) [f(x) - ax].\n\n'
        'Asymptote horizontale : cas particulier de l\'oblique avec a = 0, '
        'c\'est-à-dire lim(x→+∞) f(x) = b.\n\n'
        'Limite en +∞ d\'une rationnelle R(x) = P(x)/Q(x) : '
        'si deg(P) < deg(Q), la limite est 0 (asymptote horizontale y = 0). '
        'Si deg(P) = deg(Q), la limite est le rapport des coefficients dominants. '
        'Si deg(P) > deg(Q), la limite est ±∞ avec une oblique ou un comportement polynomial.\n\n'
        'Pour les fractions rationnelles en un point a : on développe le numérateur et le dénominateur '
        'au voisinage de a pour déterminer l\'ordre du pôle et le comportement.',
    example:
        'Étudier les branches infinies de f(x) = (x² + 1) / (x - 1) en +∞ et en 1.\n\n'
        'En x = 1 : le dénominateur s\'annule mais pas le numérateur (2 ≠ 0). '
        'Donc x = 1 est une asymptote verticale.\n\n'
        'En +∞ : division euclidienne : x² + 1 = (x - 1)(x + 1) + 2.\n'
        'f(x) = x + 1 + 2/(x - 1).\n'
        'lim(x→+∞) f(x)/x = 1 (donc a = 1), lim(x→+∞) [f(x) - x] = 1 (donc b = 1).\n'
        'Asymptote oblique : y = x + 1.',
    takeaways: [
      'Asymptote verticale en x = a si lim f(x) = ±∞.',
      'Asymptote oblique y = ax + b si f(x) - (ax+b) → 0 en +∞.',
      'Pour les rationnelles, comparer les degrés du numérateur et dénominateur.',
      'Développement en fractions partielles pour les pôles.',
    ],
  ),

  // ─── Chapitre 3 : Dérivabilité ───

  'maths_c_ch3_l1': const LessonContent(
    introText:
        'La dérivée mesure la vitesse de variation instantanée d\'une fonction. '
        'La différentielle en est l\'approximation linéaire.',
    lessonBody:
        'La dérivée de f en a est f\'(a) = lim(h→0) [f(a+h) - f(a)] / h, si cette limite existe. '
        'Géométriquement, c\'est la pente de la tangente au graphe en (a, f(a)).\n\n'
        'Dérivées usuelles : (xⁿ)\' = nxⁿ⁻¹, (sin x)\' = cos x, (cos x)\' = -sin x, '
        '(exp x)\' = exp x, (ln x)\' = 1/x, (1/x)\' = -1/x².\n\n'
        'Règles de dérivation :\n'
        '- Somme : (f + g)\' = f\' + g\'\n'
        '- Produit : (fg)\' = f\'g + fg\'\n'
        '- Quotient : (f/g)\' = (f\'g - fg\') / g²\n'
        '- Chaîne : (f ∘ g)\'(x) = f\'(g(x)) · g\'(x)\n\n'
        'La différentielle df(a) est la forme linéaire df(a)(h) = f\'(a) · h. '
        'Elle approxime l\'accroissement : f(a + h) ≈ f(a) + f\'(a) · h pour h petit. '
        'C\'est la base de la linéarisation.\n\n'
        'Une fonction dérivable est continue (réciproque fausse). '
        'La dérivée peut exister sans être continue (fonction de Dirichlet modifiée).',
    example:
        'Calculons la dérivée de f(x) = x² · sin(x) en utilisant la règle du produit.\n\n'
        'f\'(x) = (x²)\' · sin(x) + x² · (sin x)\'\n'
        '= 2x · sin(x) + x² · cos(x).\n\n'
        'En x = π/2 : f\'(π/2) = 2·(π/2)·1 + (π/2)²·0 = π.\n'
        'La tangente en (π²/4, π²/4) a pour équation y = π(x - π/2) + π²/4 = πx - π²/4.',
    takeaways: [
      'f\'(a) = lim [f(a+h) - f(a)] / h est la pente de la tangente.',
      'Règles : somme, produit (f\'g + fg\'), quotient, chaîne.',
      'Différentielle : df(a)(h) = f\'(a)·h, approximation linéaire.',
      'Dérivable ⟹ continue (pas la réciproque).',
    ],
  ),

  'maths_c_ch3_l2': const LessonContent(
    introText:
        'L\'étude des variations relie le signe de la dérivée au comportement croissant '
        'ou décroissant d\'une fonction. Les extremums en sont les points clés.',
    lessonBody:
        'Théorème : si f\'(x) > 0 sur un intervalle I, alors f est croissante sur I. '
        'Si f\'(x) < 0 sur I, alors f est décroissante sur I.\n\n'
        'Point critique : f\'(a) = 0 ou f\'(a) n\'existe pas. Les extremums ne peuvent '
        'se produire qu\'en des points critiques.\n\n'
        'Condition du 2nd ordre : si f\'(a) = 0 et f\'\'(a) > 0, alors f admet un minimum local en a. '
        'Si f\'\'(a) < 0, c\'est un maximum local.\n\n'
        'Si f\'\'(a) = 0, le test du 2nd ordre est concluant et on utilise le 3ème ordre '
        'ou on étudie le signe de f\' autour de a.\n\n'
        'Tableau de variations : on identifie les points critiques, on détermine le signe de f\' '
        'entre ces points, et on conclut sur les variations de f.\n\n'
        'Extremums sur un segment [a, b] : on compare les valeurs en les points critiques '
        'à l\'intérieur de l\'intervalle et les valeurs aux bornes a et b. '
        'Le maximum absolu est le plus grand de ces valeurs.\n\n'
        'Point d\'inflexion : f\'\' change de signe. La courbe change de concavité.',
    example:
        'Étudier les variations de f(x) = x³ - 3x + 2.\n\n'
        'f\'(x) = 3x² - 3 = 3(x² - 1) = 3(x-1)(x+1).\n'
        'f\'(x) = 0 ⟹ x = -1 ou x = 1.\n\n'
        'Signe de f\' : négatif sur ]-1, 1[, positif sur ]-∞, -1[ ∪ ]1, +∞[.\n\n'
        'f est décroissante sur [-1, 1], croissante ailleurs.\n'
        'Maximum local en x = -1 : f(-1) = -1 + 3 + 2 = 4.\n'
        'Minimum local en x = 1 : f(1) = 1 - 3 + 2 = 0.',
    takeaways: [
      'f\' > 0 sur I ⟹ f croissante sur I.',
      'Extremums uniquement aux points critiques (f\' = 0 ou indéfinie).',
      'Test du 2nd ordre : f\'\'(a) > 0 ⟹ minimum, f\'\'(a) < 0 ⟹ maximum.',
      'Comparer les valeurs critiques aux bornes pour les extrema absolus.',
    ],
  ),

  'maths_c_ch3_l3': const LessonContent(
    introText:
        'Une bijection entre deux intervalles permet de définir une fonction réciproque. '
        'Celle-ci joue un rôle crucial en calcul intégral et en résolution d\'équations.',
    lessonBody:
        'Une fonction f : I → J est une bijection si elle est à la fois injective (univoque) '
        'et surjective (tout élément de J est atteint). Sur un intervalle, c\'est équivalent '
        'à être strictement monotone.\n\n'
        'Si f est continue et strictement monotone sur [a, b], elle est bijective de [a, b] '
        'sur [f(a), f(b)] (ou [f(b), f(a)] si décroissante).\n\n'
        'La fonction réciproque f⁻¹ est définie par f⁻¹(y) = x ⟺ f(x) = y. '
        'Son graphe est la symétrie du graphe de f par rapport à la droite y = x.\n\n'
        'Dérivée de la réciproque : si f est dérivable et f\'(a) ≠ 0, alors f⁻¹ est dérivable '
        'en b = f(a) et (f⁻¹)\'(b) = 1 / f\'(a). Plus généralement, '
        '(f⁻¹)\'(y) = 1 / f\'(f⁻¹(y)).\n\n'
        'Cas importants :\n'
        '- exp et ln sont réciproques l\'une de l\'autre.\n'
        '- cos et arccos : f⁻¹ existe sur [0, π] car cos est bijective sur cet intervalle.\n'
        '- tan et arctan : f⁻¹ existe sur ]-π/2, π[.\n\n'
        'Croissance de la réciproque : f croissante ⟹ f⁻¹ croissante. '
        'f décroissante ⟹ f⁻¹ décroissante.',
    example:
        'Soit f(x) = eˣ - x. Montrons que f est bijective sur [0, +∞[.\n\n'
        'f\'(x) = eˣ - 1 ≥ 0 pour x ≥ 0 (car eˣ ≥ 1 pour x ≥ 0).\n'
        'f\'(x) = 0 ⟺ x = 0. Donc f est strictement croissante sur [0, +∞[.\n\n'
        'f(0) = 1 et lim(x→+∞) f(x) = +∞.\n'
        'Donc f est bijective de [0, +∞[ sur [1, +∞[.\n\n'
        'Si on pose f(x) = 3, on cherche x tel que eˣ - x = 3. La réciproque existe '
        'mais ne s\'exprime pas avec des fonctions usuelles.',
    takeaways: [
      'Bijection = injective + surjective = strictement monotone sur un intervalle.',
      'La réciproque f⁻¹ satisfait f(f⁻¹(x)) = x et f⁻¹(f(x)) = x.',
      '(f⁻¹)\'(y) = 1 / f\'(f⁻¹(y)).',
      'Le graphe de f⁻¹ est la symétrie de celui de f par rapport à y = x.',
    ],
  ),

  'maths_c_ch3_l4': const LessonContent(
    introText:
        'Le théorème des accroissements finis (TAF) relie la dérivée d\'une fonction '
        'à son accroissement moyen. C\'est un outil fondamental pour les estimations.',
    lessonBody:
        'Théorème des accroissements finis (TAF) : si f est continue sur [a, b] '
        'et dérivable sur ]a, b[, alors il existe c ∈ ]a, b[ tel que '
        'f(b) - f(a) = f\'(c) · (b - a).\n\n'
        'Interprétation : il existe un point où la tangente est parallèle à la corde joignant '
        '(a, f(a)) et (b, f(b)). Le taux de variation instantané coïncide avec le taux de variation moyen.\n\n'
        'Applications :\n'
        '1. Estimation : si |f\'(x)| ≤ M sur [a, b], alors |f(b) - f(a)| ≤ M|b - a|.\n'
        '2. Si f\' = 0 sur un intervalle connexe, alors f est constante.\n'
        '3. Si f\' = g\' sur un intervalle, alors f et g diffèrent d\'une constante.\n\n'
        'Corollaire : si f est C¹ (continue dérivable avec f\' continue) et f\'(a) > 0, '
        'alors f est croissante dans un voisinage de a.\n\n'
        'Inégalité des accroissements finis : |f(x) - f(y)| ≤ M|x - y| avec M = sup|f\'|. '
        'Cela garantit la continuité de Lipschitz de f.',
    example:
        'Montrons que |sin a - sin b| ≤ |a - b| pour tout a, b réels.\n\n'
        'La fonction sin est dérivable sur ℝ avec (sin)\'(x) = cos x.\n'
        '|cos x| ≤ 1 pour tout x, donc |f\'(x)| ≤ 1.\n\n'
        'Par le TAF : sin a - sin b = cos(c) · (a - b) pour un certain c.\n'
        '|sin a - sin b| = |cos c| · |a - b| ≤ 1 · |a - b| = |a - b|. ✓\n\n'
        'Cela prouve que sin est lipschitzienne de constante 1.',
    takeaways: [
      'TAF : ∃c ∈ ]a,b[ tel que f(b)-f(a) = f\'(c)(b-a).',
      'Si |f\'| ≤ M, alors |f(b)-f(a)| ≤ M|b-a|.',
      'Si f\' = 0 sur un intervalle, f est constante.',
      'Applications aux estimations et aux inégalités.',
    ],
  ),

  // ─── Chapitre 4 : Fonctions usuelles ───

  'maths_c_ch4_l1': const LessonContent(
    introText:
        'Le logarithme népérien ln est la réciproque de l\'exponentielle. '
        'Ses propriétés algébriques et sa dérivée en font un outil incontournable.',
    lessonBody:
        'Définition : ln(x) est le nombre réel y tel que eʸ = x, pour x > 0. '
        'C\'est la fonction réciproque de exp.\n\n'
        'Propriétés algebraiques (pour a, b > 0) :\n'
        '- ln(1) = 0, ln(e) = 1\n'
        '- ln(a · b) = ln(a) + ln(b)\n'
        '- ln(a/b) = ln(a) - ln(b)\n'
        '- ln(aⁿ) = n · ln(a)\n\n'
        'Dérivée : (ln x)\' = 1/x pour x > 0.\n\n'
        'Développement de Taylor au voisinage de 1 :\n'
        'ln(1 + x) = x - x²/2 + x³/3 - x⁴/4 + ... pour |x| < 1.\n\n'
        'Limite : lim(x→+∞) ln(x)/xⁿ = 0 pour tout n > 0. Le logarithme croît plus lentement '
        'que toute puissance positive.\n\n'
        'Limite : lim(x→0⁺) x · ln(x) = 0. Le logarithme est « dompté » par x.\n\n'
        'Dérivée logarithmique : pour f(x) > 0, on a [ln f(x)]\' = f\'(x)/f(x). '
        'Utile pour différencier des produits et des puissances complexes.\n\n'
        '```graphe\n'
        'ln(x) = ln(x) | violet\n'
        'exp(x) = e^x | orange\n'
        'droite: y = x | gris\n'
        'x: -3 .. 5\n'
        'y: -3 .. 5\n'
        'point: (1, 0)\n'
        'point: (0, 1)\n'
        'titre: ln et exp sont symétriques par rapport à y = x\n'
        '```',
    example:
        'Calculons lim(x→+∞) ln(x) / √x.\n\n'
        'C\'est une forme indéterminée +∞/+∞. On applique L\'Hospital :\n'
        'lim(x→+∞) ln(x)/√x = lim(x→+∞) (1/x) / (1/(2√x))\n'
        '= lim(x→+∞) 2√x / x = lim(x→+∞) 2/√x = 0.\n\n'
        'Le logarithme est dominé par √x en +∞.',
    takeaways: [
      'ln(x) est la réciproque de exp(x), définie pour x > 0.',
      'Propriétés : ln(ab) = ln a + ln b, ln(aⁿ) = n ln a.',
      '(ln x)\' = 1/x pour x > 0.',
      'ln croît plus lentement que toute puissance positive.',
    ],
  ),

  'maths_c_ch4_l2': const LessonContent(
    introText:
        'La fonction exponentielle exp et ses propriétés de croissance rapide '
        'en font un modèle de croissance naturelle et un outil d\'estimation.',
    lessonBody:
        'Définition : exp(x) = eˣ est la réciproque de ln(x). '
        'On a exp(0) = 1, exp(1) = e ≈ 2,718.\n\n'
        'Propriétés :\n'
        '- exp(x + y) = exp(x) · exp(y)\n'
        '- exp(-x) = 1/exp(x)\n'
        '- exp(x)ⁿ = exp(nx)\n'
        '- exp(x) > 0 pour tout x réel\n\n'
        'Dérivée : (exp x)\' = exp x. L\'exponentielle est sa propre dérivée.\n\n'
        'Développement de Taylor : exp(x) = 1 + x + x²/2! + x³/3! + ... pour tout x.\n\n'
        'Croissance rapide : pour tout n > 0, lim(x→+∞) xⁿ / eˣ = 0. '
        'L\'exponentielle domine toute puissance. De même, lim(x→-∞) xⁿ · eˣ = 0.\n\n'
        'Variations : exp est strictement croissante sur ℝ (car exp\'(x) = exp(x) > 0).\n\n'
        'Exponentielle complexe : e^{ix} = cos(x) + i·sin(x) (formule d\'Euler).\n\n'
        'Applications : modèles de croissance (population, intérêts composés), '
        'décroissance radioactive, solutions d\'équations différentielles.',
    example:
        'Étudier f(x) = x² · e^{-x} sur [0, +∞[.\n\n'
        'f\'(x) = 2x·e^{-x} + x²·(-e^{-x}) = x·e^{-x}(2 - x).\n'
        'f\'(x) = 0 ⟹ x = 0 ou x = 2.\n\n'
        'f\' > 0 sur ]0, 2[ (f croissante), f\' < 0 sur ]2, +∞[ (f décroissante).\n'
        'Maximum en x = 2 : f(2) = 4e^{-2} ≈ 0,541.\n'
        'lim(x→+∞) x² · e^{-x} = 0 (exponentielle domine).',
    takeaways: [
      'exp\'(x) = exp(x) : l\'exponentielle est sa propre dérivée.',
      'exp(x+y) = exp(x)·exp(y) : propriété fondamentale.',
      'L\'exponentielle domine toute puissance en +∞.',
      'Variation : strictement croissante sur ℝ.',
    ],
  ),

  'maths_c_ch4_l3': const LessonContent(
    introText:
        'Comparer les vitesses de croissance de fonctions est essentiel pour évaluer '
        'des limites et simplifier des expressions complexes.',
    lessonBody:
        'Ordre de croissance en +∞ (du plus lent au plus rapide) :\n'
        'ln(x) ≪ x^α (α > 0) ≪ eˣ ≪ x! ≪ xˣ\n\n'
        'Autrement dit : pour tout α > 0, lim(x→+∞) ln(x)/x^α = 0. '
        'Et pour tout n, lim(x→+∞) xⁿ/eˣ = 0.\n\n'
        'Conséquences pour les limites :\n'
        '- lim(x→+∞) (ln x)² / x = 0 (le facteur polynomial gagne).\n'
        '- lim(x→+∞) x / eˣ = 0 (l\'exponentielle gagne).\n'
        '- lim(x→+∞) e^{-x} · xⁿ = 0 pour tout n.\n\n'
        'Ordre de croissance en 0⁺ :\n'
        'x ≪ x^α (0 < α < 1) ⟹ sin(x) ~ x ⟹ tan(x) ~ x ⟹ 1 - cos(x) ~ x²/2.\n\n'
        'Notation de Landau : f ~ g en +∞ signifie lim f/g = 1. '
        'Si f ~ g et g ~ h alors f ~ h (transitivité). f ~ g ⟹ f - g = o(g).\n\n'
        'Applications : simplifier des expressions, appliquer L\'Hospital, '
        'comparer des croissances dans des modèles.',
    example:
        'Calculons lim(x→+∞) (x³ + 5x² - 1) / (2x³ - eˣ).\n\n'
        'Le numérateur ~ x³ en +∞. Le dénominateur ~ -eˣ en +∞.\n'
        'La fraction ~ x³ / (-eˣ) → 0 car eˣ domine x³.\n\n'
        'Donc la limite est 0.',
    takeaways: [
      'Ordre : ln ≪ puissance ≪ exponentielle.',
      'L\'exponentielle domine toute puissance en +∞.',
      'Notation f ~ g signifie f/g → 1.',
      'Appliquer ces ordres pour calculer des limites.',
    ],
  ),

  'maths_c_ch4_l4': const LessonContent(
    introText:
        'Le logarithme décimal (base 10) est utilisé dans les domaines scientifiques '
        'et techniques. Ses propriétés sont analogues à celles du ln.',
    lessonBody:
        'Définition : log(x) = log₁₀(x) est le nombre y tel que 10ʸ = x, pour x > 0.\n\n'
        'Relation avec ln : log(x) = ln(x) / ln(10) ≈ ln(x) / 2,3026.\n\n'
        'Propriétés (identiques à ln) :\n'
        '- log(1) = 0, log(10) = 1\n'
        '- log(ab) = log(a) + log(b)\n'
        '- log(a/b) = log(a) - log(b)\n'
        '- log(aⁿ) = n · log(a)\n\n'
        'Dérivée : (log x)\' = 1 / (x · ln 10).\n\n'
        'Applications :\n'
        '- Échelles : dB (décibels) = 10 · log₁₀(P/P₀), pH = -log₁₀[H⁺].\n'
        '- Richesse spectrale (musique) : rapport de fréquences.\n'
        '- Magnitude des étoiles.\n\n'
        'Limite : lim(x→+∞) log(x)/xⁿ = 0 pour tout n > 0. '
        'Même comportement que ln puisque log(x) = ln(x)/ln(10).\n\n'
        'Notation scientifique : tout nombre x > 0 s\'écrit x = a × 10ⁿ avec 1 ≤ a < 10. '
        'On a log(x) = n + log(a).',
    example:
        'Calculons log₂(32) et log₃(1/81) en utilisant le changement de base.\n\n'
        'log₂(32) : 2⁵ = 32, donc log₂(32) = 5.\n\n'
        'Avec le changement de base : log₂(32) = ln(32)/ln(2) = 5ln(2)/ln(2) = 5. ✓\n\n'
        'log₃(1/81) : 81 = 3⁴, donc 1/81 = 3⁻⁴.\n'
        'log₃(1/81) = log₃(3⁻⁴) = -4.\n\n'
        'Vérification : 3⁻⁴ = 1/81. ✓',
    takeaways: [
      'log₁₀(x) = ln(x)/ln(10), relation de changement de base.',
      'Mêmes propriétés que ln : produit = somme, quotient = différence.',
      '(log x)\' = 1/(x·ln 10).',
      'Applications : dB, pH, notations scientifiques.',
    ],
  ),

  // ─── Chapitre 5 : Suites numériques ───

  'maths_c_ch5_l1': const LessonContent(
    introText:
        'Les suites numériques sont des applications de ℕ dans ℝ. '
        'Leur étude pose les bases de la convergence et de l\'analyse.',
    lessonBody:
        'Une suite (uₙ) est une liste infinie de réels u₀, u₁, u₂, ... '
        'On l\'écrit uₙ = f(n) pour une fonction f : ℕ → ℝ.\n\n'
        'Convergence : (uₙ) converge vers L si pour tout ε > 0, '
        'il existe N tel que pour tout n ≥ N, |uₙ - L| < ε. On note lim uₙ = L.\n\n'
        'Si une suite converge, la limite est unique.\n\n'
        'Propriétés arithmétiques : si lim uₙ = a et lim vₙ = b, alors :\n'
        '- lim(uₙ + vₙ) = a + b\n'
        '- lim(uₙ · vₙ) = a · b\n'
        '- lim(uₙ/vₙ) = a/b si b ≠ 0\n\n'
        'Théorème d\'encadrement : si aₙ ≤ uₙ ≤ bₙ et lim aₙ = lim bₙ = L, '
        'alors lim uₙ = L.\n\n'
        'Suite bornée : uₙ est bornée s\'il existe M tel que |uₙ| ≤ M pour tout n. '
        'Une suite convergente est bornée (réciproque fausse).\n\n'
        'Suite monotone : croissante si uₙ₊₁ ≥ uₙ, décroissante si uₙ₊₁ ≤ uₙ. '
        'Toute suite monotone et bornée est convergente (critère de Cauchy pour les monotones).',
    example:
        'Soit uₙ = (2n + 1)/(n + 3). Calculons lim uₙ.\n\n'
        'Divisons numérateur et dénominateur par n :\n'
        'uₙ = (2 + 1/n) / (1 + 3/n).\n\n'
        'lim(1/n) = 0, donc lim uₙ = 2/1 = 2.\n\n'
        'Vérification : |uₙ - 2| = |(2n+1)/(n+3) - 2| = |(-5)/(n+3)| = 5/(n+3) → 0. ✓',
    takeaways: [
      'Convergence : ∀ε > 0, ∃N : n ≥ N ⟹ |uₙ - L| < ε.',
      'Opérations : limites respectées pour somme, produit, quotient.',
      'Encadrement : si aₙ ≤ uₙ ≤ bₙ et limites égales, convergence.',
      'Monotone + bornée ⟹ convergente.',
    ],
  ),

  'maths_c_ch5_l2': const LessonContent(
    introText:
        'Les suites récurrentes se définissent par u₀ connu et uₙ₊₁ = f(uₙ). '
        'Leur convergence dépend du comportement de la fonction d\'itération.',
    lessonBody:
        'Une suite récurrente est définie par u₀ = a et uₙ₊₁ = f(uₙ) pour une fonction f donnée.\n\n'
        'Point fixe : x est un point fixe de f si f(x) = x. Si la suite converge vers L, '
        'alors L est un point fixe de f.\n\n'
        'Critère de convergence par contraction : si f est contractante dans un intervalle I '
        '(|f\'(x)| < 1 pour tout x ∈ I) et u₀ ∈ I, alors la suite converge vers le point fixe unique.\n\n'
        'Méthode de Newton : pour trouver une racine de g(x) = 0, on pose '
        'uₙ₊₁ = uₙ - g(uₙ)/g\'(uₙ). Convergence quadratique si g\'(L) ≠ 0.\n\n'
        'Suite définie par uₙ₊₁ = √(uₙ + 2) et u₀ = 0 :\n'
        'Point fixe : x = √(x + 2) ⟹ x² = x + 2 ⟹ x² - x - 2 = 0 ⟹ x = 2.\n'
        'f\'(x) = 1/(2√(x+2)), |f\'(2)| = 1/4 < 1. La suite converge vers 2.\n\n'
        'Monotonie : si f est croissante et u₀ ≤ u₁ (ou u₀ ≥ u₁), '
        'la suite est monotone. Combinée avec la borne, cela prouve la convergence.',
    example:
        'Étudier la suite uₙ₊₁ = (uₙ + 3)/2 avec u₀ = 0.\n\n'
        'u₀ = 0, u₁ = 3/2, u₂ = 9/4, u₃ = 21/8, ...\n\n'
        'Point fixe : x = (x+3)/2 ⟹ 2x = x+3 ⟹ x = 3.\n'
        'f\'(x) = 1/2 < 1 pour tout x : contraction garantie.\n\n'
        'Monotonie : u₁ = 3/2 > 0 = u₀, et f croissante ⟹ suite croissante.\n'
        'Borne : uₙ < 3 pour tout n (on le montre par récurrence). '
        'Donc la suite converge vers 3.',
    takeaways: [
      'Point fixe : si uₙ → L, alors f(L) = L.',
      'Si |f\'(L)| < 1, la suite converge vers L.',
      'Newton : uₙ₊₁ = uₙ - g(uₙ)/g\'(uₙ) converge rapidement.',
      'Monotonie + borne = convergence garantie.',
    ],
  ),

  'maths_c_ch5_l3': const LessonContent(
    introText:
        'Les suites arithmético-géométriques combinent progression arithmétique '
        'et géométrique. Leur résolution utilise une transformation astucieuse.',
    lessonBody:
        'Une suite arithmético-géométrique (SAG) est définie par uₙ₊₁ = a·uₙ + b '
        'avec a ≠ 0 et b constants.\n\n'
        'Résolution : on cherche le point fixe L = aL + b, soit L = b/(1-a) si a ≠ 1.\n\n'
        'Si a ≠ 1 : on pose vₙ = uₙ - L. Alors vₙ₊₁ = a·vₙ, donc vₙ = aⁿ·v₀.\n'
        'D\'où uₙ = L + aⁿ(u₀ - L) = b/(1-a) + aⁿ(u₀ - b/(1-a)).\n\n'
        'Convergence :\n'
        '- Si |a| < 1 : uₙ → L = b/(1-a) (convergence géométrique).\n'
        '- Si |a| > 1 : divergence sauf si u₀ = L.\n'
        '- Si a = -1 : oscillation entre deux valeurs.\n'
        '- Si a = 1 : suite arithmétique, convergence si b = 0.\n\n'
        'Application aux intérêts composés : Aₙ₊₁ = (1+r)·Aₙ + C modélise un capital '
        'avec taux r et versement constant C. La formule donne Aₙ directement.\n\n'
        'Variante : uₙ₊₁ = a·uₙ + f(n) avec f(n) polynomial. '
        'On adapte la méthode en cherchant une solution particular du bon degré.',
    example:
        'Résoudre uₙ₊₁ = (1/2)uₙ + 3 avec u₀ = 0.\n\n'
        'Point fixe : L = (1/2)L + 3 ⟹ L/2 = 3 ⟹ L = 6.\n\n'
        'vₙ = uₙ - 6. vₙ₊₁ = uₙ₊₁ - 6 = (1/2)uₙ + 3 - 6 = (1/2)(uₙ - 6) = (1/2)vₙ.\n'
        'vₙ = (1/2)ⁿ · v₀ = (1/2)ⁿ · (0 - 6) = -6·(1/2)ⁿ.\n\n'
        'uₙ = 6 - 6·(1/2)ⁿ = 6(1 - (1/2)ⁿ).\n\n'
        'Vérification : u₀ = 0 ✓, u₁ = 3 = 6(1 - 1/2) ✓, u₂ = 9/2 = 6(1 - 1/4) ✓.',
    takeaways: [
      'SAG : uₙ₊₁ = a·uₙ + b avec L = b/(1-a) si a ≠ 1.',
      'Si |a| < 1, la suite converge vers L.',
      'Méthode : poser vₙ = uₙ - L pour obtenir une suite géométrique.',
      'Formule explicite : uₙ = L + aⁿ(u₀ - L).',
    ],
  ),

  // ─── Chapitre 6 : Intégration ───

  'maths_c_ch6_l1': const LessonContent(
    introText:
        'La primitive est l\'opération inverse de la dérivation. '
        'Calculer des primitives est essentiel pour résoudre des équations différentielles et '
        'calculer des aires.',
    lessonBody:
        'Une primitive de f sur I est une fonction F telle que F\' = f sur I. '
        'Deux primitives diffèrent d\'une constante. On note ∫ f(x) dx = F(x) + C.\n\n'
        'Primitives usuelles :\n'
        '- ∫ xⁿ dx = xⁿ⁺¹/(n+1) + C (n ≠ -1)\n'
        '- ∫ 1/x dx = ln|x| + C\n'
        '- ∫ eˣ dx = eˣ + C\n'
        '- ∫ sin(x) dx = -cos(x) + C\n'
        '- ∫ cos(x) dx = sin(x) + C\n'
        '- ∫ 1/(1+x²) dx = arctan(x) + C\n\n'
        'Ligneuse : ∫ (af + bg) dx = a∫f dx + b∫g dx.\n\n'
        'Primitive par changement de variable : si f = g\' ∘ h · h\', alors '
        '∫ f(x) dx = G(h(x)) + C où G\' = g.\n\n'
        'Primitive par parties : ∫ u·v\' dx = u·v - ∫ u\'·v dx.\n\n'
        'Règle de Ruffini-Horner pour les fractions rationnelles : '
        'décomposer le numérateur par le dénominateur, puis intégrer chaque terme.',
    example:
        'Calculons ∫ x·eˣ dx par parties.\n\n'
        'Posons u = x (donc u\' = 1) et v\' = eˣ (donc v = eˣ).\n\n'
        '∫ x·eˣ dx = x·eˣ - ∫ 1·eˣ dx = x·eˣ - eˣ + C = (x-1)·eˣ + C.\n\n'
        'Vérification : [(x-1)·eˣ]\' = 1·eˣ + (x-1)·eˣ = x·eˣ. ✓',
    takeaways: [
      'Primitive de f est F tel que F\' = f, unique à une constante près.',
      'Primitives usuelles : puissance, exponentielle, trigonométriques.',
      'Changement de variable : ∫ f(h(x))·h\'(x) dx = ∫ f(u) du.',
      'Parties : ∫ u·v\' = u·v - ∫ u\'·v.',
    ],
  ),

  'maths_c_ch6_l2': const LessonContent(
    introText:
        'L\'intégrale de Riemann généralise la notion d\'aire sous une courbe. '
        'C\'est le fondement du calcul intégral.',
    lessonBody:
        'Intégrale de Riemann : pour f continue sur [a, b], on considère des subdivisions '
        'a = x₀ < x₁ < ... < xₙ = b. L\'intégrale est la limite des sommes de Riemann '
        'quand le pas tend vers 0.\n\n'
        '∫[a,b] f(x) dx = lim Σ f(tᵢ)(xᵢ₊₁ - xᵢ) quand max(Δxᵢ) → 0.\n\n'
        'Propriétés :\n'
        '- ∫[a,b] f(x) dx = -∫[b,a] f(x) dx\n'
        '- ∫[a,a] f(x) dx = 0\n'
        '- ∫[a,b] f + ∫[b,c] f = ∫[a,c] f\n'
        '- Si f ≥ 0 sur [a, b], alors ∫[a,b] f ≥ 0\n'
        '- Si f ≤ g, alors ∫ f ≤ ∫ g\n\n'
        'Théorème fondamental : si F est une primitive de f, alors '
        '∫[a,b] f(x) dx = F(b) - F(a) = [F(x)]ᵇₐ.\n\n'
        'Interprétation géométrique : si f ≥ 0, ∫[a,b] f(x) dx est l\'aire sous la courbe. '
        'Si f change de signe, l\'intégrale algébrique compte les aires signées.\n\n'
        'Moyenne d\'une fonction : μ = (1/(b-a)) ∫[a,b] f(x) dx.',
    example:
        'Calculons ∫[0,π] sin(x) dx.\n\n'
        'Une primitive de sin(x) est -cos(x).\n\n'
        '∫[0,π] sin(x) dx = [-cos(x)]₀π = -cos(π) - (-cos(0)) = -(-1) - (-1) = 1 + 1 = 2.\n\n'
        'L\'aire sous la courbe sin(x) sur [0, π] vaut 2.',
    takeaways: [
      '∫[a,b] f(x) dx = F(b) - F(a) si F\' = f.',
      'Si f ≥ 0, l\'intégrale est l\'aire sous la courbe.',
      'Propriétés : linéarité, additivité sur les intervalles.',
      'Moyenne : μ = (1/(b-a)) ∫[a,b] f(x) dx.',
    ],
  ),

  'maths_c_ch6_l3': const LessonContent(
    introText:
        'Maîtriser les techniques d\'intégration permet de calculer des intégrales '
        'complexes. Changement de variable, parties, fractions partielles sont les outils clés.',
    lessonBody:
        '1. Changement de variable : ∫ f(g(x))·g\'(x) dx = ∫ f(u) du avec u = g(x). '
        'Choisir u = g(x) quand on reconnaît f(g(x))·g\'(x).\n\n'
        '2. Intégration par parties : ∫ u dv = uv - ∫ v du. '
        'Règle LIATE pour choisir u : Logarithme, Inverse trig, Algébrique, Trig, Exp.\n\n'
        '3. Fractions rationnelles : si deg(num) ≥ deg(dénom), division euclidienne d\'abord. '
        'Puis décomposition en fractions partielles selon les facteurs du dénominateur :\n'
        '- Facteur simple (x - a) : A/(x - a)\n'
        '- Facteur double (x - a)² : A/(x - a) + B/(x - a)²\n'
        '- Facteur irréductible (x² + bx + c) : (Ax + B)/(x² + bx + c)\n\n'
        '4. Intégrales trigonométriques : utiliser les identités :\n'
        '- sin²(x) = (1 - cos 2x)/2, cos²(x) = (1 + cos 2x)/2\n'
        '- Substitution t = tan(x/2) pour les rationnelles en sin et cos.\n\n'
        '5. Intégrales remarquables :\n'
        '- ∫ 1/√(a² - x²) dx = arcsin(x/a) + C\n'
        '- ∫ 1/(a² + x²) dx = (1/a)·arctan(x/a) + C',
    example:
        'Calculons ∫ x·ln(x) dx par parties.\n\n'
        'Posons u = ln(x) ⟹ u\' = 1/x et dv = x dx ⟹ v = x²/2.\n\n'
        '∫ x·ln(x) dx = (x²/2)·ln(x) - ∫ (x²/2)·(1/x) dx\n'
        '= (x²/2)·ln(x) - (1/2)∫ x dx\n'
        '= (x²/2)·ln(x) - x²/4 + C.\n\n'
        'Vérification : [(x²/2)·ln(x) - x²/4]\' = x·ln(x) + x/2 - x/2 = x·ln(x). ✓',
    takeaways: [
      'Changement de variable : ∫ f(g(x))·g\'(x) dx = ∫ f(u) du.',
      'Parties : ∫ u dv = uv - ∫ v du, choisir u selon LIATE.',
      'Fractions partielles : décomposer selon les facteurs du dénominateur.',
      'Identités trig : sin²x = (1-cos2x)/2 pour réduire les puissances.',
    ],
  ),

  // ─── Chapitre 7 : Équations différentielles ───

  'maths_c_ch7_l1': const LessonContent(
    introText:
        'Les équations différentielles linéaires du 1er ordre modélisent de nombreux '
        'phénomènes : croissance, décroissance, circuits électriques.',
    lessonBody:
        'Forme générale : y\' + a(x)·y = b(x). Si a est constant : y\' + ay = b.\n\n'
        'Cas homogène (b = 0) : y\' + ay = 0. Solution : y = C·e^{-ax}. '
        'On obtient une solution par l\'équation caractéristique λ + a = 0, soit λ = -a.\n\n'
        'Cas non homogène : on cherche une solution particulière yₚ puis on ajoute la solution '
        'générale de l\'homogène.\n'
        '- Si b est constant : yₚ = b/a (constante).\n'
        '- Si b(x) = P(x)·e^{αx} et α n\'est pas racine caractéristique : yₚ = Q(x)·e^{αx} '
        'avec deg(Q) = deg(P).\n'
        '- Si α est racine simple : yₚ = x·Q(x)·e^{αx}.\n\n'
        'Solution générale : y = yₚ + C·e^{-ax}.\n\n'
        'Condition initiale : y(x₀) = y₀ détermine la constante C. '
        'On obtient la solution du problème de Cauchy, unique par le théorème de Cauchy-Lipschitz.\n\n'
        'Applications : y\' = ky (croissance/décroissance exponentielle), '
        'y\' + ky = P (modèle de Newton pour le refroidissement), '
        'RL : L·I\' + R·I = E(t).',
    example:
        'Résoudre y\' - 3y = 6, y(0) = 5.\n\n'
        'Solution homogène : yₕ = C·e^{3x}.\n'
        'Solution particulière : yₚ = 6/(-3) = -2 (constante car b = 6 est constant).\n\n'
        'Solution générale : y = -2 + C·e^{3x}.\n'
        'Condition initiale : y(0) = -2 + C = 5 ⟹ C = 7.\n\n'
        'Solution : y = -2 + 7·e^{3x}.\n'
        'Vérification : y\' = 21e^{3x}, y\' - 3y = 21e^{3x} - 3(-2 + 7e^{3x}) = 21e^{3x} + 6 - 21e^{3x} = 6. ✓',
    takeaways: [
      'y\' + ay = b : solution = homogène + particulière.',
      'Homogène : yₕ = C·e^{-ax}.',
      'Cas constant : yₚ = b/a.',
      'Condition initiale détermine la constante C.',
    ],
  ),

  'maths_c_ch7_l2': const LessonContent(
    introText:
        'Les équations différentielles du 2nd ordre sont centrales en physique : '
        'oscillations, circuits LC, mécanique vibratoire.',
    lessonBody:
        'Forme générale : y\'\' + ay\' + by = 0 (homogène) ou y\'\' + ay\' + b = f(x).\n\n'
        'Équation caractéristique : λ² + aλ + b = 0.\n\n'
        'Trois cas selon le discriminant Δ = a² - 4b :\n\n'
        '1. Δ > 0 : deux racines réelles λ₁ ≠ λ₂.\n'
        '   Solution : y = C₁·e^{λ₁x} + C₂·e^{λ₂x}.\n\n'
        '2. Δ = 0 : racine double λ = -a/2.\n'
        '   Solution : y = (C₁ + C₂x)·e^{λx}.\n\n'
        '3. Δ < 0 : racines complexes λ = α ± iβ.\n'
        '   Solution : y = e^{αx}(C₁·cos(βx) + C₂·sin(βx)).\n\n'
        'Cas non homogène : y = yₚ + yₕ. On cherche y₪ selon la forme de f(x) '
        '(polynôme, exponentielle, sinus, produit).\n\n'
        'Problème de Cauchy : y(x₀) = y₀ et y\'(x₀) = v₀ déterminent C₁ et C₂.\n\n'
        'Applications physiques :\n'
        '- Oscillateur harmonique : x\'\' + ω²x = 0 → oscillations sinusoïdales.\n'
        '- RLC série : LQ\'\' + RQ\' + Q/C = E(t).\n'
        '- Pendule : θ\'\' + (g/l)sin(θ) = 0, linéarisé : θ\'\' + (g/l)θ = 0.',
    example:
        'Résoudre y\'\' - 5y\' + 6y = 0, y(0) = 1, y\'(0) = 4.\n\n'
        'Équation caractéristique : λ² - 5λ + 6 = 0 ⟹ (λ-2)(λ-3) = 0.\n'
        'λ₁ = 2, λ₂ = 3.\n\n'
        'Solution générale : y = C₁·e^{2x} + C₂·e^{3x}.\n'
        'y\' = 2C₁·e^{2x} + 3C₂·e^{3x}.\n\n'
        'y(0) = C₁ + C₂ = 1.\n'
        'y\'(0) = 2C₁ + 3C₂ = 4.\n\n'
        'Système : C₁ + C₂ = 1 et 2C₁ + 3C₂ = 4.\n'
        'C₁ = -1, C₂ = 2.\n'
        'Solution : y = -e^{2x} + 2e^{3x}.',
    takeaways: [
      'Équation caractéristique : λ² + aλ + b = 0.',
      'Δ > 0 : exponentielles réelles. Δ = 0 : (C₁ + C₂x)e^{λx}.',
      'Δ < 0 : e^{αx}(C₁cos βx + C₂sin βx), oscillations.',
      'Deux conditions initiales déterminent C₁ et C₂.',
    ],
  ),

  // ─── Chapitre 8 : Probabilités et statistiques ───

  'maths_c_ch8_l1': const LessonContent(
    introText:
        'Les probabilités conditionnelles mesurent l\'incidence d\'une information '
        'supplémentaire. La formule de Bayes est l\'outil de décision clé.',
    lessonBody:
        'Probabilité conditionnelle : P(A|B) = P(A ∩ B) / P(B) si P(B) > 0. '
        'C\'est la probabilité de A sachant que B s\'est réalisé.\n\n'
        'Formule de Bayes : P(A|B) = P(B|A) · P(A) / P(B).\n\n'
        'Si {A₁, A₂, ..., Aₙ} est une partition de l\'espace, alors :\n'
        'P(B) = Σ P(Aᵢ) · P(B|Aᵢ) (formule des probabilités totales).\n\n'
        'Indépendance : A et B sont indépendants si P(A ∩ B) = P(A) · P(B), '
        'ce qui est équivalent à P(A|B) = P(A).\n\n'
        'Formules :\n'
        '- P(A ∪ B) = P(A) + P(B) - P(A ∩ B)\n'
        '- P(Ā) = 1 - P(A)\n'
        '- P(A ∩ B) = P(A) · P(B|A) = P(B) · P(A|B)\n\n'
        'Interprétation de Bayes : on met à jour nos croyances (probabilité a priori P(A)) '
        'avec une nouvelle observation (P(B|A)) pour obtenir la probabilité a posteriori P(A|B).\n\n'
        'Indépendance mutuelle : A, B, C sont mutuellement indépendants si toutes les paires '
        'et la triple intersection vérifient P = produit des probabilités.',
    example:
        'Dans une population, 1% a une maladie. Un test a 99% de sensibilité (P(positif|malade) = 0,99) '
        'et 5% de fausse alarme (P(positif|sain) = 0,05). Quelle est P(malade|positif) ?\n\n'
        'P(malade) = 0,01, P(sain) = 0,99.\n'
        'P(positif) = P(malade)·P(pos|malade) + P(sain)·P(pos|sain)\n'
        '= 0,01×0,99 + 0,99×0,05 = 0,0099 + 0,0495 = 0,0594.\n\n'
        'P(malade|positif) = (0,01 × 0,99) / 0,0594 = 0,0099/0,0594 ≈ 0,1667.\n\n'
        'Seulement 16,7% des positifs sont réellement malades.',
    takeaways: [
      'P(A|B) = P(A ∩ B) / P(B).',
      'Bayes : P(A|B) = P(B|A)·P(A) / P(B).',
      'Probabilités totales sur une partition.',
      'Indépendance : P(A ∩ B) = P(A)·P(B).',
    ],
  ),

  'maths_c_ch8_l2': const LessonContent(
    introText:
        'Une variable aléatoire discrète prend un nombre fini ou dénombrable de valeurs. '
        'Son espérance et sa variance caractérisent le centre et la dispersion.',
    lessonBody:
        'Variable aléatoire discrète (v.a.d.) : application X : Ω → ℝ qui prend des valeurs '
        'x₁, x₂, ..., xₙ avec des probabilités p₁, p₂, ..., pₙ.\n\n'
        'Loi de probabilité : P(X = xᵢ) = pᵢ avec Σ pᵢ = 1 et pᵢ ≥ 0.\n\n'
        'Espérance (ou moyenne) : E(X) = Σ xᵢ · pᵢ. C\'est la valeur « moyenne » attendue.\n\n'
        'Variance : V(X) = E(X²) - [E(X)]² = Σ (xᵢ - E(X))² · pᵢ.\n'
        'L\'écart-type est σ = √V(X).\n\n'
        'Espérance d\'une fonction : E(g(X)) = Σ g(xᵢ) · pᵢ.\n\n'
        'Propriétés :\n'
        '- E(aX + b) = a·E(X) + b\n'
        '- V(aX + b) = a²·V(X)\n'
        '- V(X) = E(X²) - [E(X)]²\n\n'
        'Médiane : valeur m telle que P(X ≤ m) ≥ 1/2 et P(X ≥ m) ≥ 1/2.\n'
        'Mode : valeur la plus probable.\n\n'
        'Loi uniforme sur {1, ..., n} : P(X = k) = 1/n pour k = 1, ..., n. '
        'E(X) = (n+1)/2, V(X) = (n²-1)/12.',
    example:
        'Soit X lavariable « nombre obtenu en lançant un dé équilibré ».\n\n'
        'P(X = k) = 1/6 pour k = 1, 2, 3, 4, 5, 6.\n\n'
        'E(X) = (1+2+3+4+5+6)/6 = 21/6 = 3,5.\n\n'
        'E(X²) = (1+4+9+16+25+36)/6 = 91/6.\n'
        'V(X) = 91/6 - (3,5)² = 91/6 - 12,25 = 91/6 - 49/4 = 182/12 - 147/12 = 35/12 ≈ 2,92.\n'
        'σ = √(35/12) ≈ 1,71.',
    takeaways: [
      'Espérance : E(X) = Σ xᵢ · pᵢ.',
      'Variance : V(X) = E(X²) - [E(X)]².',
      'E(aX+b) = aE(X)+b, V(aX+b) = a²V(X).',
      'La variance mesure la dispersion autour de l\'espérance.',
    ],
  ),

  'maths_c_ch8_l3': const LessonContent(
    introText:
        'La loi binomiale modélise le nombre de succès dans des épreuves de Bernoulli indépendantes. '
        'La loi normale est la distribution centrale en statistique.',
    lessonBody:
        'Loi binomiale B(n, p) : X = nombre de succès dans n épreuves indépendantes '
        'de probabilité p chacune.\n'
        'P(X = k) = C(n,k) · pᵏ · (1-p)ⁿ⁻ᵏ pour k = 0, 1, ..., n.\n'
        'E(X) = np, V(X) = np(1-p).\n\n'
        'Loi de Poisson (λ) : approximation de B(n, p) quand n est grand et p petit avec np = λ.\n'
        'P(X = k) = e^{-λ} · λᵏ / k!.\n'
        'E(X) = V(X) = λ.\n\n'
        'Loi normale N(μ, σ²) : densité f(x) = (1/(σ√(2π))) · exp(-(x-μ)²/(2σ²)).\n'
        'E(X) = μ, V(X) = σ².\n\n'
        'Loi normale centrée réduite N(0, 1) : la variable Z = (X - μ)/σ suit N(0, 1).\n'
        'Table des valeurs de la fonction Φ(z) = P(Z ≤ z).\n\n'
        'Approximation de De Moivre-Laplace : pour n grand, B(n, p) s\'approche '
        'de N(np, np(1-p)). On utilise P(a ≤ X ≤ b) ≈ Φ((b-np)/√(npq)) - Φ((a-np)/√(npq)).\n\n'
        'Intervalle de confiance à 95% : [μ - 1,96σ, μ + 1,96σ].',
    example:
        'Un étudiant répond au hasard à 10 questions à choix multiples (4 choix chacune).\n\n'
        'X ~ B(10, 1/4). E(X) = 10 × 1/4 = 2,5. V(X) = 10 × 1/4 × 3/4 = 15/8.\n\n'
        'P(X ≥ 6) = Σ[k=6 à 10] C(10,k)(1/4)ᵏ(3/4)¹⁰⁻ᵏ.\n'
        'P(X = 6) = C(10,6)(1/4)⁶(3/4)⁴ = 210 × 1/4096 × 81/256 ≈ 0,0162.\n'
        'On calcule de même pour k = 7, 8, 9, 10 et on additionne.\n\n'
        'Avec l\'approximation normale : μ = 2,5, σ = √1,875 ≈ 1,37.\n'
        'P(X ≥ 6) ≈ P(Z ≥ (6 - 2,5)/1,37) = P(Z ≥ 2,55) ≈ 0,0054.',
    takeaways: [
      'B(n,p) : P(X=k) = C(n,k)pᵏ(1-p)ⁿ⁻ᵏ, E=np, V=np(1-p).',
      'Poisson : approximation de B(n,p) quand n grand, p petit.',
      'N(μ,σ²) : densité gaussienne, Z = (X-μ)/σ centrée réduite.',
      'De Moivre-Laplace : B(n,p) ≈ N(np, np(1-p)) pour n grand.',
    ],
  ),

  // ─── Chapitre 9 : Géométrie dans l\'espace ───

  'maths_c_ch9_l1': const LessonContent(
    introText:
        'Les vecteurs dans l\'espace servent à représenter des directions et des distances. '
        'Ils sont l\'outil fondamental de la géométrie 3D.',
    lessonBody:
        'Un vecteur dans l\'espace est une flèche caractérisée par sa direction, son sens et sa longueur. '
        'On le note AB⃗ ou u⃗. Dans un repère : u⃗ = (x, y, z).\n\n'
        'Opérations vectorielles :\n'
        '- u⃗ + v⃗ = (u₁+v₁, u₂+v₂, u₃+v₃)\n'
        '- λu⃗ = (λu₁, λu₂, λu₃)\n'
        '- AB⃗ = OB⃗ - OA⃗ (coordonnées de B moins celles de A)\n\n'
        'Norme : |u⃗| = √(u₁² + u₂² + u₃²).\n\n'
        'Produit scalaire : u⃗ · v⃗ = u₁v₁ + u₂v₂ + u₃v₃ = |u⃗||v⃗|cos(u⃗, v⃗).\n'
        'Propriétés : commutatif, distributif, u⃗ · u⃗ = |u⃗|².\n\n'
        'Dualité : u⃗ ⊥ v⃗ ⟺ u⃗ · v⃗ = 0.\n\n'
        'Colinéarité : u⃗ et v⃗ sont colinéaires si u⃗ × v⃗ = 0⃗ (ou si l\'un est nul).\n\n'
        'Formules de Lagrange : |u⃗ + v⃗|² = |u⃗|² + |v⃗|² + 2u⃗·v⃗.\n'
        '|u⃗ - v⃗|² = |u⃗|² + |v⃗|² - 2u⃗·v⃗.\n\n'
        'Coordonnées dans un repère orthonormé : AB⃗ = (x_B-x_A, y_B-y_A, z_B-z_A). '
        'La distance AB = |AB⃗|.',
    example:
        'Soit A(1, 2, 3), B(4, 0, -1), C(2, 5, 1). Calculons AB⃗ · AC⃗ et l\'angle (AB⃗, AC⃗).\n\n'
        'AB⃗ = (3, -2, -4), AC⃗ = (1, 3, -2).\n\n'
        'AB⃗ · AC⃗ = 3×1 + (-2)×3 + (-4)×(-2) = 3 - 6 + 8 = 5.\n\n'
        '|AB⃗| = √(9+4+16) = √29.\n'
        '|AC⃗| = √(1+9+4) = √14.\n\n'
        'cos(AB⃗, AC⃗) = 5 / (√29·√14) = 5/√406 ≈ 0,248.\n'
        'Angle ≈ 75,6°.',
    takeaways: [
      'AB⃗ = (x_B-x_A, y_B-y_A, z_B-z_A).',
      'Produit scalaire : u⃗·v⃗ = |u⃗||v⃗|cos(u⃗,v⃗).',
      'u⃗ ⊥ v⃗ ⟺ u⃗·v⃗ = 0.',
      'Norme : |u⃗| = √(u₁² + u₂² + u₃²).',
    ],
  ),

  'maths_c_ch9_l2': const LessonContent(
    introText:
        'Les droites et plans dans l\'espace se définissent par des équations vectorielles, '
        'paramétriques ou cartésiennes. Leur relative position est un enjeu géométrique.',
    lessonBody:
        'Droite passant par A de vecteur directeur d⃗ : '
        'M ∈ (d) ⟺ AM⃗ = λd⃗ (équation vectorielle).\n'
        'Paramétrique : x = x_A + λd₁, y = y_A + λd₂, z = z_A + λd₃.\n'
        'Cartésienne (symétriques) : (x-x_A)/d₁ = (y-y_A)/d₂ = (z-z_A)/d₃ (quand les dᵢ ≠ 0).\n\n'
        'Plan passant par A de vecteurs directeurs u⃗ et v⃗ : '
        'M ∈ (P) ⟺ AM⃗ = λu⃗ + μv⃗.\n'
        'Équation cartésienne : a(x-x_A) + b(y-y_A) + c(z-z_A) = 0 où n⃗ = (a, b, c) est le vecteur normal.\n\n'
        'Position relative :\n'
        '- Droite // plan : d⃗ ⊥ n⃗ (d⃗ · n⃗ = 0) et A ∉ (P).\n'
        '- Droite ⊥ plan : d⃗ // n⃗ (d⃗ × n⃗ = 0⃗).\n'
        '- Deux plans parallèles : n⃗₁ // n⃗₂.\n'
        '- Deux plans sécants : intersection = droite de vecteur directeur n⃗₁ × n⃗₂.\n\n'
        'Distance d\'un point à un plan : d(M, (P)) = |AM⃗ · n⃗| / |n⃗|.\n'
        'Distance d\'un point à une droite : d(M, (d)) = |AM⃗ × d⃗| / |d⃗|.',
    example:
        'Soit le plan (P) : 2x - y + 3z = 6 et le point M(1, 0, -1). '
        'Calculons la distance de M au plan.\n\n'
        'Vecteur normal : n⃗ = (2, -1, 3), |n⃗| = √(4+1+9) = √14.\n'
        'Un point du plan : A(3, 0, 0) vérifie 6 = 6. ✓\n\n'
        'AM⃗ = (-2, 0, -1).\n'
        'AM⃗ · n⃗ = -4 + 0 - 3 = -7.\n\n'
        'd(M, (P)) = |-7| / √14 = 7/√14 = 7√14/14 = √14/2 ≈ 1,87.',
    takeaways: [
      'Droite : AM⃗ = λd⃗. Plan : AM⃗ = λu⃗ + μv⃗.',
      'Plan cartésien : a(x-x_A) + b(y-y_A) + c(z-z_A) = 0.',
      'Distance point-plan : |AM⃗·n⃗| / |n⃗|.',
      'Intersection de deux plans : droite de directeur n⃗₁ × n⃗₂.',
    ],
  ),

  'maths_c_ch9_l3': const LessonContent(
    introText:
        'Le produit vectoriel et le produit mixte sont des opérations essentielles '
        'en géométrie 3D. Ils permettent de calculer des aires, des volumes et des orthogonalités.',
    lessonBody:
        'Produit vectoriel : u⃗ × v⃗ est un vecteur orthogonal à u⃗ et v⃗.\n'
        'Déterminant : u⃗ × v⃗ = |i⃗  j⃗  k⃗; u₁ u₂ u₃; v₁ v₂ v₃| = (u₂v₃-u₃v₂, u₃v₁-u₁v₃, u₁v₂-u₂v₁).\n\n'
        'Propriétés :\n'
        '- |u⃗ × v⃗| = |u⃗||v⃗|sin(u⃗, v⃗) = aire du parallelogramme.\n'
        '- u⃗ × v⃗ = -(v⃗ × u⃗) (anti-commutatif).\n'
        '- u⃗ × v⃗ = 0⃗ ⟺ u⃗ et v⃗ colinéaires.\n'
        '- (u⃗ × v⃗) ⊥ u⃗ et (u⃗ × v⃗) ⊥ v⃗.\n\n'
        'Triple produit scalaire (produit mixte) : [u⃗, v⃗, w⃗] = u⃗ · (v⃗ × w⃗) = det(u⃗, v⃗, w⃗).\n'
        '|[u⃗, v⃗, w⃗]| = volume du parallélépipède.\n\n'
        'Applications :\n'
        '- Aire du triangle ABC : S = |AB⃗ × AC⃗| / 2.\n'
        '- Aire du parallélogramme : S = |u⃗ × v⃗|.\n'
        '- Volume du tétraèdre ABCD : V = |[AB⃗, AC⃗, AD⃗]| / 6.\n'
        '- Coplanarité : A, B, C, D coplanaires ⟺ [AB⃗, AC⃗, AD⃗] = 0.\n\n'
        'Moment : τ⃗ = OA⃗ × F⃗ calcule le moment d\'une force F⃗ par rapport à un point O.',
    example:
        'Calculons l\'aire du triangle ABC avec A(1, 0, 0), B(0, 2, 0), C(0, 0, 3).\n\n'
        'AB⃗ = (-1, 2, 0), AC⃗ = (-1, 0, 3).\n\n'
        'AB⃗ × AC⃗ = |i⃗  j⃗  k⃗; -1 2 0; -1 0 3|\n'
        '= (2×3 - 0×0, 0×(-1) - (-1)×3, (-1)×0 - 2×(-1))\n'
        '= (6, 3, 2).\n\n'
        '|AB⃗ × AC⃗| = √(36 + 9 + 4) = √49 = 7.\n\n'
        'Aire du triangle = 7/2 = 3,5.',
    takeaways: [
      'u⃗ × v⃗ orthogonal à u⃗ et v⃗, |u⃗ × v⃗| = aire du parallélogramme.',
      '[u⃗, v⃗, w⃗] = u⃗ · (v⃗ × w⃗) = volume du parallélépipède.',
      'Aire triangle = |AB⃗ × AC⃗| / 2.',
      'Coplanarité : [AB⃗, AC⃗, AD⃗] = 0.',
    ],
  ),

  // ─── Chapitre 10 : Arithmétique ───

  'maths_c_ch10_l1': const LessonContent(
    introText:
        'La divisibilité dans ℤ est le fondement de l\'arithmétique. '
        'Elle permet d\'étudier les propriétés des nombres entiers.',
    lessonBody:
        'Divisibilité : a divise b (noté a | b) s\'il existe k ∈ ℤ tel que b = a·k.\n\n'
        'Propriétés :\n'
        '- a | a (réflexivité)\n'
        '- a | b et b | c ⟹ a | c (transitivité)\n'
        '- a | b et a | c ⟹ a | (b + c)\n'
        '- a | b ⟹ a | b·c pour tout c\n'
        '- a | b et b | a ⟹ |a| = |b| (sauf si a ou b = 0)\n\n'
        'Division euclidienne : pour tout a ∈ ℤ et b ∈ ℤ*, il existe UNIQUEMENT '
        'un couple (q, r) tel que a = bq + r avec 0 ≤ r < |b|.\n'
        'q est le quotient, r est le reste.\n\n'
        'Critère de divisibilité :\n'
        '- Par 2 : dernier chiffre pair.\n'
        '- Par 3 : somme des chiffres divisible par 3.\n'
        '- Par 9 : somme des chiffres divisible par 9.\n'
        '- Par 10 : dernier chiffre = 0.\n\n'
        'Nombre premier : p > 1 n\'a pour diviseurs que 1 et p. '
        'Tout entier > 1 se décompose en produit de premiers (théorème fondamental de l\'arithmétique).\n\n'
        'Le crible d\'Ératostène permet de trouver tous les premiers jusqu\'à N.',
    example:
        'Effectuons la division euclidienne de 137 par 5.\n\n'
        '137 = 5 × q + r, 0 ≤ r < 5.\n'
        '137 / 5 = 27,4 → q = 27.\n'
        'r = 137 - 5 × 27 = 137 - 135 = 2.\n\n'
        'Donc 137 = 5 × 27 + 2. Vérification : 135 + 2 = 137. ✓\n\n'
        'Critère de 3 : 137 → 1 + 3 + 7 = 11. 11 n\'est pas divisible par 3. '
        'Donc 137 n\'est pas divisible par 3.',
    takeaways: [
      'a | b ⟺ b = a·k pour un k ∈ ℤ.',
      'Division euclidienne unique : a = bq + r, 0 ≤ r < |b|.',
      'Critères de divisibilité : 2, 3, 9, 10.',
      'Décomposition en facteurs premiers (théorème fondamental).',
    ],
  ),

  'maths_c_ch10_l2': const LessonContent(
    introText:
        'Le PGCD (plus grand commun diviseur) et le PPCM (plus petit commun multiple) '
        'sont des outils fondamentaux en arithmétique et en résolution d\'équations.',
    lessonBody:
        'PGCD(a, b) : le plus grand entier qui divise a et b. Notation : pgcd(a, b) ou gcd(a, b).\n\n'
        'Algorithme d\'Euclide (pour calculer le PGCD) :\n'
        '1. Diviser a par b : a = bq₁ + r₁ (0 ≤ r₁ < b)\n'
        '2. Diviser b par r₁ : b = r₁q₂ + r₂\n'
        '3. Continuer jusqu\'à obtenir un reste nul.\n'
        'Le PGCD est le dernier reste non nul.\n\n'
        'Propriétés :\n'
        '- pgcd(a, b) = pgcd(b, a)\n'
        '- pgcd(a, 0) = |a|\n'
        '- pgcd(a, b) = pgcd(a - b, b)\n'
        '- pgcd(a, b) = pgcd(a, b - a)\n\n'
        'PGCD et PPCM : pgcd(a, b) × PPCM(a, b) = |a × b|.\n\n'
        'PGCD étendu (algorithme d\'Euclide étendu) : trouve u, v tels que '
        'au + bv = pgcd(a, b). Utile pour calculer l\'inverse modulaire.\n\n'
        'Premiers entre eux : pgcd(a, b) = 1. '
        'Si a et b sont premiers entre eux et a | bc, alors a | c (lemme de Gauss).\n\n'
        'PPCM(a, b) : le plus petit commun multiple. PPCM(a, b) = ab/pgcd(a, b).',
    example:
        'Calculons pgcd(252, 105) avec l\'algorithme d\'Euclide.\n\n'
        '252 = 105 × 2 + 42\n'
        '105 = 42 × 2 + 21\n'
        '42 = 21 × 2 + 0\n\n'
        'Le dernier reste non nul est 21. Donc pgcd(252, 105) = 21.\n\n'
        'PPCM(252, 105) = (252 × 105) / 21 = 26460 / 21 = 1260.\n\n'
        'Vérification : 1260 / 252 = 5 ✓, 1260 / 105 = 12 ✓.',
    takeaways: [
      'PGCD : algorithme d\'Euclide (divisions successives).',
      'pgcd(a,b) × PPCM(a,b) = |a×b|.',
      'Premiers entre eux : pgcd = 1.',
      'Euclide étendu : au + bv = pgcd(a,b), utile pour inverses modulaires.',
    ],
  ),

  'maths_c_ch10_l3': const LessonContent(
    introText:
        'Les congruences sont l\'arithmétique modulaire. Elles sont utilisées en cryptographie, '
        'en informatique et en théorie des nombres.',
    lessonBody:
        'Congruence : a ≡ b [n] si n | (a - b). Autrement dit, a et b ont le même reste '
        'modulo n. C\'est une relation d\'équivalence.\n\n'
        'Propriétés :\n'
        '- a ≡ b [n] et c ≡ d [n] ⟹ a + c ≡ b + d [n]\n'
        '- a ≡ b [n] et c ≡ d [n] ⟹ a·c ≡ b·d [n]\n'
        '- a ≡ b [n] ⟹ aᵏ ≡ bᵏ [n]\n\n'
        'Arithmétique modulaire :\n'
        '- Addition : (a + b) mod n = [(a mod n) + (b mod n)] mod n\n'
        '- Multiplication : (a × b) mod n = [(a mod n) × (b mod n)] mod n\n\n'
        'Théorème de Fermat : si p est premier et gcd(a, p) = 1, alors a^{p-1} ≡ 1 [p].\n\n'
        'Théorème des restes chinois : si gcd(n₁, n₂) = 1, le système x ≡ a₁ [n₁] '
        'et x ≡ a₂ [n₂] admet une unique solution modulo n₁n₂.\n\n'
        'Nombre premier : p est premier ⟺ pour tout a, gcd(a, p) = 1 ou p | a.\n\n'
        'Applications :\n'
        '- Cryptographie RSA (exponentiation modulaire).\n'
        '- Tests de primalité.\n'
        '- Arithmétique dans les calculateurs.\n\n'
        'Ensemble Z/nZ : les classes de résidus modulo n. '
        'Il y en a exactement n : {0, 1, 2, ..., n-1}.',
    example:
        'Calculons 7^{222} mod 11 avec le théorème de Fermat.\n\n'
        '11 est premier et gcd(7, 11) = 1.\n'
        'Par Fermat : 7^{10} ≡ 1 [11].\n\n'
        '222 = 10 × 22 + 2.\n'
        '7^{222} = (7^{10})^{22} × 7² ≡ 1^{22} × 49 [11] ≡ 49 [11].\n\n'
        '49 = 4 × 11 + 5, donc 49 ≡ 5 [11].\n\n'
        '7^{222} ≡ 5 [11].\n\n'
        'Vérification : sans Fermat, on calculerait 7² = 49, 7⁴ = 2401, etc. '
        'Fermat simplifie énormément.',
    takeaways: [
      'a ≡ b [n] ⟺ n | (a-b) : même reste modulo n.',
      'Opérations : addition, multiplication compatibles avec la congruence.',
      'Fermat : a^{p-1} ≡ 1 [p] si p premier, gcd(a,p) = 1.',
      'Z/nZ contient n classes de résidus : {0, 1, ..., n-1}.',
    ],
  ),
};
