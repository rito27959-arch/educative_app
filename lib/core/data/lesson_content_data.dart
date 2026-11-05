import 'bac_c_chimie.dart';
import 'bac_c_info.dart';
import 'bac_c_maths.dart';
import 'bac_c_physique.dart';
import 'bac_c_svt.dart';
import 'lesson_content_model.dart';

class LessonContentData {
  static Map<String, LessonContent> get all => _content;
  static final Map<String, LessonContent> _content = {};

  static LessonContent? get(String lessonId) => _content[lessonId];

  static void init() {
    _content.clear();
    _content.addAll(_mathsCh1);
    _content.addAll(_mathsCh2);
    _content.addAll(_mathsCh3);
    _content.addAll(_mathsCh4);
    _content.addAll(_mathsCh5);
    _content.addAll(_mathsCh6);
    _content.addAll(_mathsCh7);
    _content.addAll(_mathsCh8);
    _content.addAll(_mathsCh9);
    _content.addAll(_mathsCh10);
    _content.addAll(_physiqueCh1);
    _content.addAll(_physiqueCh2);
    _content.addAll(_physiqueCh3);
    _content.addAll(_physiqueCh4);
    _content.addAll(_physiqueCh5);
    _content.addAll(_physiqueCh6);
    _content.addAll(_physiqueCh7);
    _content.addAll(_physiqueCh8);
    _content.addAll(_chimieCh1);
    _content.addAll(_chimieCh2);
    _content.addAll(_chimieCh3);
    _content.addAll(_chimieCh4);
    _content.addAll(_chimieCh5);
    _content.addAll(_chimieCh6);
    _content.addAll(_svtCh1);
    _content.addAll(_svtCh2);
    _content.addAll(_svtCh3);
    _content.addAll(_svtCh4);
    _content.addAll(_svtCh5);
    _content.addAll(_svtCh6);
    _content.addAll(_svtCh7);
    _content.addAll(_infoCh1);
    _content.addAll(_infoCh2);
    _content.addAll(_infoCh3);
    _content.addAll(_infoCh4);
    _content.addAll(_infoCh5);
    _content.addAll(_infoCh6);
    // BAC C
    _content.addAll(bacCMathsContent);
    _content.addAll(bacCPhysiqueContent);
    _content.addAll(bacCChimieContent);
    _content.addAll(bacCSvtContent);
    _content.addAll(bacCInfoContent);
  }

  // ===========================================================================
  // MATHÉMATIQUES — Chapitre 1 : Nombres complexes
  // ===========================================================================

  static final Map<String, LessonContent> _mathsCh1 = {
    'maths_ch1_l1': const LessonContent(
      introText:
          'Le corps des nombres complexes, noté ℂ, est une extension du corps des nombres réels ℝ. '
          'Il permet de résoudre toute équation polynomiale, notamment celles dont le discriminant est négatif. '
          'Dans cette leçon, nous allons découvrir la forme algébrique d\'un nombre complexe et ses propriétés fondamentales.',
      lessonBody:
          'Un nombre complexe est un nombre de la forme z = a + ib, où a et b sont des nombres réels '
          '(notés a, b ∈ ℝ) et i est l\'unité imaginaire définie par i² = -1. Le nombre a est appelé '
          'la partie réelle de z, notée Re(z), et b est la partie imaginaire de z, notée Im(z). '
          'Un nombre est dit purement réel si b = 0 (alors z = a ∈ ℝ) et purement imaginaire si a = 0 '
          '(alors z = ib).\n\n'
          'Le conjugué d\'un nombre complexe z = a + ib est le nombre z̄ = a - ib. Le conjugué s\'obtient '
          'en changeant le signe de la partie imaginaire. Le produit d\'un nombre complexe par son conjugué '
          'donne toujours un nombre réel positif ou nul : z × z̄ = (a + ib)(a - ib) = a² + b². Cette '
          'propriété est essentielle pour calculer le module d\'un nombre complexe.\n\n'
          'Deux nombres complexes z₁ = a₁ + ib₁ et z₂ = a₂ + ib₂ sont égaux si et seulement si '
          'a₁ = a₂ et b₁ = b₂. En d\'autres termes, deux nombres complexes sont égaux quand leurs parties '
          'réelles sont égales et leurs parties imaginaires sont égales. L\'addition se fait terme à terme : '
          'z₁ + z₂ = (a₁ + a₂) + i(b₁ + b₂). La soustraction suit la même logique. '
          'La multiplication utilise la distributivité en tenant compte que i² = -1 : '
          'z₁ × z₂ = (a₁a₂ - b₁b₂) + i(a₁b₂ + a₂b₁).',
      example:
          'Exemple 1 — Identifier les parties :\n'
          'Soit z = 3 - 5i. On a Re(z) = 3 et Im(z) = -5.\n\n'
          'Exemple 2 — Conjugué :\n'
          'Le conjugué de z = 3 - 5i est z̄ = 3 + 5i.\n'
          'Vérification : z × z̄ = (3 - 5i)(3 + 5i) = 9 + 25 = 34.\n\n'
          'Exemple 3 — Égalité :\n'
          'Si z₁ = 2 + 4i et z₂ = x + iy, alors z₁ = z₂ ⟺ x = 2 et y = 4.\n\n'
          'Exemple 4 — Multiplication :\n'
          'Soient z₁ = 1 + 2i et z₂ = 3 - i.\n'
          'z₁ × z₂ = (1×3 - 2×(-1)) + i(1×(-1) + 2×3)\n'
          '        = (3 + 2) + i(-1 + 6)\n'
          '        = 5 + 5i.',
      takeaways: [
        'z = a + ib avec a = Re(z) et b = Im(z)',
        'Le conjugué : z̄ = a - ib',
        'z × z̄ = a² + b² (toujours réel)',
        'Deux complexes sont égaux ⟺ parties réelles et imaginaires égales',
      ],
    ),
    'maths_ch1_l2': const LessonContent(
      introText:
          'Le module et l\'argument d\'un nombre complexe permettent de le représenter géométriquement '
          'dans le plan complexe (plan d\'Argand). La forme trigonométrique et la forme exponentielle '
          'sont des écritures équivalentes très utilisées en calcul.',
      lessonBody:
          'Le module d\'un nombre complexe z = a + ib, noté |z|, est défini par la formule '
          '|z| = √(a² + b²). Il correspond à la distance du point M d\'affixe z à l\'origine O '
          'dans le plan complexe. Le module est toujours un nombre réel positif ou nul. '
          'On a |z| = 0 si et seulement si z = 0. Par ailleurs, on peut écrire |z|² = z × z̄ = a² + b².\n\n'
          'L\'argument d\'un nombre complexe z ≠ 0, noté arg(z), est l\'angle que fait le vecteur OM '
          'avec l\'axe réel positif. Cet angle est défini à une constante près (2kπ, k ∈ ℤ). '
          'L\'argument principal, noté Arg(z), est l\'unique valeur de l\'argument dans l\'intervalle ]-π, π]. '
          'Pour z = a + ib avec z ≠ 0 : tan(Arg(z)) = b/a, avec des précisions supplémentaires selon le signe de a et b.\n\n'
          'La forme trigonométrique d\'un nombre complexe z ≠ 0 s\'écrit : z = |z|(cos θ + i sin θ), '
          'où θ = arg(z). Cette forme est très commode pour multiplier et diviser des nombres complexes. '
          'La forme exponentielle, encore plus compacte, utilise la formule d\'Euler : '
          'z = |z|e^(iθ), où e^(iθ) = cos θ + i sin θ. '
          'Pour le produit de deux nombres complexes : z₁ × z₂ = |z₁|×|z₂| × e^(i(θ₁+θ₂)), '
          'c\'est-à-dire que les modules se multiplient et les arguments s\'additionnent. '
          'Pour le quotient : z₁/z₂ = (|z₁|/|z₂|) × e^(i(θ₁-θ₂)), les modules se divisent et les arguments se soustraient.',
      example:
          'Exemple 1 — Module :\n'
          'Pour z = 3 + 4i : |z| = √(3² + 4²) = √(9 + 16) = √25 = 5.\n\n'
          'Exemple 2 — Argument principal :\n'
          'Pour z = 1 + i√3 : tan(Arg(z)) = √3/1 = √3, donc Arg(z) = π/3 (soit 60°).\n'
          'Vérification : cos(π/3) = 1/2 et sin(π/3) = √3/2.\n'
          'Z = 2(cos(π/3) + i sin(π/3)) = 2 × (1/2 + i√3/2) = 1 + i√3. ✓\n\n'
          'Exemple 3 — Forme exponentielle :\n'
          'z = 5e^(iπ/4) signifie |z| = 5 et arg(z) = π/4.\n'
          'z = 5(cos(π/4) + i sin(π/4)) = 5(√2/2 + i√2/2) = 5√2/2 + i·5√2/2.\n\n'
          'Exemple 4 — Produit avec formes trigonométriques :\n'
          'z₁ = 2e^(iπ/6) et z₂ = 3e^(iπ/3)\n'
          'z₁ × z₂ = (2×3)e^(i(π/6 + π/3)) = 6e^(iπ/2) = 6i.',
      takeaways: [
        '|z| = √(a² + b²) est la distance à l\'origine',
        '|z|² = z × z̄ = a² + b²',
        'Forme trigonométrique : z = |z|(cos θ + i sin θ)',
        'Forme exponentielle : z = |z|e^(iθ) avec e^(iθ) = cos θ + i sin θ',
        'Produit : modules ×, arguments + ; Quotient : modules /, arguments −',
      ],
    ),
    'maths_ch1_l3': const LessonContent(
      introText:
          'Les équations dans ℂ permettent de résoudre des équations du second degré même lorsque le '
          'discriminant est négatif. Contrairement à ℝ, dans ℂ toute équation du second degré admet '
          'toujours deux racines (comptées avec leur multiplicité).',
      lessonBody:
          'Considérons l\'équation du second degré az² + bz + c = 0 avec a, b, c ∈ ℝ et a ≠ 0. '
          'On calcule le discriminant Δ = b² - 4ac. Si Δ > 0, l\'équation admet deux racines réelles '
          'distinctes (cas classique en ℝ). Si Δ = 0, il y a une racine double. Si Δ < 0, l\'équation '
          'n\'admet pas de racines réelles mais admet deux racines complexes conjuguées dans ℂ.\n\n'
          'Quand Δ < 0, on note √Δ = i√|Δ|. Les deux racines sont alors données par :\n'
          'z₁ = (-b + i√|Δ|) / (2a) et z₂ = (-b - i√|Δ|) / (2a).\n'
          'Ces deux racines sont conjuguées l\'une de l\'autre : z̄₁ = z₂. Cela signifie qu\'elles ont '
          'la même partie réelle (-b/2a) et des parties imaginaires opposées. Cette propriété est fondamentale '
          'et permet de ne calculer qu\'une seule racine, l\'autre étant obtenue par conjuguaison.\n\n'
          'En forme trigonométrique, si z₁ = r·e^(iθ), alors z₂ = r·e^(-iθ) (même module, argument opposé). '
          'La somme des racines vaut z₁ + z₂ = -b/a (toujours réelle) et leur produit vaut z₁ × z₂ = c/a '
          '(aussi réel). Ce sont les relations de Viète qui restent valables dans ℂ. '
          'La forme factorisée de l\'équation est : a(z - z₁)(z - z₂) = 0.',
      example:
          'Exemple — Résoudre z² + 2z + 5 = 0\n\n'
          'Étape 1 : Calcul du discriminant\n'
          'Δ = 2² - 4(1)(5) = 4 - 20 = -16\n\n'
          'Étape 2 : Comme Δ < 0, on écrit √Δ = i√16 = 4i\n\n'
          'Étape 3 : Calcul des racines\n'
          'z₁ = (-2 + 4i) / 2 = -1 + 2i\n'
          'z₂ = (-2 - 4i) / 2 = -1 - 2i\n\n'
          'Vérification :\n'
          'z₁² = (-1 + 2i)² = 1 - 4i + 4i² = 1 - 4i - 4 = -3 - 4i\n'
          '2z₁ = -2 + 4i\n'
          'z₁² + 2z₁ + 5 = (-3 - 4i) + (-2 + 4i) + 5 = 0. ✓\n\n'
          'Vérification par les relations de Viète :\n'
          'z₁ + z₂ = (-1 + 2i) + (-1 - 2i) = -2 = -b/a ✓\n'
          'z₁ × z₂ = (-1 + 2i)(-1 - 2i) = 1 + 4 = 5 = c/a ✓',
      takeaways: [
        'Δ < 0 ⟺ deux racines complexes conjuguées dans ℂ',
        'z₁ = (-b + i√|Δ|)/(2a) et z₂ = (-b - i√|Δ|)/(2a)',
        'z̄₁ = z₂ : parties réelles égales, parties imaginaires opposées',
        'Relations de Viète : z₁ + z₂ = -b/a et z₁ × z₂ = c/a',
      ],
    ),
    'maths_ch1_l4': const LessonContent(
      introText:
          'Les nombres complexes offrent un cadre puissant pour décrire des transformations '
          'géométriques du plan : translations, rotations, homothéties et similitudes. '
          'Chaque transformation du plan peut être associée à une opération sur les affixes.',
      lessonBody:
          'L\'affixe d\'un point M du plan est le nombre complexe z tel que le vecteur OM a pour '
          'coordonnées (Re(z), Im(z)). Le plan complexe (ou plan d\'Argand) identifie ainsi chaque point '
          'du plan à un nombre complexe. L\'origine O a pour affixe 0 et le point M(a, b) a pour affixe z = a + ib.\n\n'
          'La translation d\'vecteur b s\'exprime simplement : si le point M a pour affixe z, le point M\' '
          'image de M par cette translation a pour affixe z\' = z + b. Par exemple, translater le point '
          'd\'affixe 2 + i du vecteur 3 - 2i donne le point d\'affixe (2 + i) + (3 - 2i) = 5 - i.\n\n'
          'La rotation de centre O et d\'angle θ s\'effectue en multipliant par e^(iθ). Si z est l\'affixe '
          'de M, alors z\' = z × e^(iθ) est l\'affixe du point M\' obtenu par rotation d\'angle θ autour '
          'de l\'origine. La rotation d\'angle π/2 (90°) revient à multiplier par i, et celle d\'angle π '
          '(180°) revient à multiplier par -1. Une rotation de centre C(c) est donnée par z\' = c + (z - c)e^(iθ).\n\n'
          'Une similitude de centre C(c), d\'angle θ et de rapport k est la composition d\'une rotation '
          'et d\'une homothétie. Elle s\'écrit : z\' = c + k·e^(iθ)·(z - c). Si k > 1, c\'est une '
          'agrandissement ; si 0 < k < 1, c\'est une réduction. Toute combinaison affine z\' = az + b '
          '(avec a, b ∈ ℂ et a ≠ 0) est une similitude directe si arg(a) est l\'angle de rotation et '
          '|a| le rapport de similitude.',
      example:
          'Exemple 1 — Translation :\n'
          'Point M d\'affixe z = 1 + 3i. Translation du vecteur b = 2 - i.\n'
          'z\' = z + b = (1 + 3i) + (2 - i) = 3 + 2i.\n'
          'M\' a pour coordonnées (3, 2).\n\n'
          'Exemple 2 — Rotation autour de l\'origine :\n'
          'Point M d\'affixe z = 1. Rotation d\'angle π/2 autour de O.\n'
          'z\' = z × e^(iπ/2) = 1 × i = i.\n'
          'Le point (1, 0) est envoyé en (0, 1).\n\n'
          'Exemple 3 — Rotation autour d\'un point :\n'
          'Point M d\'affixe z = 3 + i. Rotation d\'angle π/3 autour du point C d\'affixe c = 1 + i.\n'
          'z\' = c + (z - c) × e^(iπ/3)\n'
          'z - c = 2 (partie réelle uniquement)\n'
          'e^(iπ/3) = 1/2 + i√3/2\n'
          'z\' = (1 + i) + 2(1/2 + i√3/2) = (1 + i) + (1 + i√3) = 2 + i(1 + √3).\n\n'
          'Exemple 4 — Similitude :\n'
          'z\' = 2e^(iπ/4)·z + (1 - i)\n'
          'Rapport : |a| = 2 (agrandissement de rapport 2)\n'
          'Angle : arg(a) = π/4 (rotation de 45°)\n'
          'Terme de translation : b = 1 - i.',
      takeaways: [
        'L\'affixe d\'un point M(x, y) est z = x + iy',
        'Translation : z\' = z + b',
        'Rotation de centre O, angle θ : z\' = z × e^(iθ)',
        'Rotation de centre C(c) : z\' = c + (z - c)e^(iθ)',
        'Similitude : z\' = c + k·e^(iθ)(z - c) avec rapport k et angle θ',
      ],
    ),
  };

  // ===========================================================================
  // MATHÉMATIQUES — Chapitre 2 : Limites et continuité
  // ===========================================================================

  static final Map<String, LessonContent> _mathsCh2 = {
    'maths_ch2_l1': const LessonContent(
      introText:
          'La notion de limite est fondamentale en analyse mathématique. Elle permet d\'étudier le '
          'comportement d\'une fonction au voisinage d\'un point ou à l\'infini. Dans cette leçon, '
          'nous allons maîtriser les techniques de calcul des limites et identifier les asymptotes.',
      lessonBody:
          'Soit f une fonction définie sur un intervalle I. On dit que f(x) tend vers L quand x tend vers a '
          'si pour tout ε > 0, il existe δ > 0 tel que |x - a| < δ implique |f(x) - L| < ε. '
          'On note lim_{x→a} f(x) = L.\n\n'
          'Limites à l\'infini : lim_{x→+∞} f(x) = L signifie que pour tout ε > 0, il existe A > 0 '
          'tel que x > A implique |f(x) - L| < ε. De même pour -∞.\n\n'
          'Limites infinies : lim_{x→a} f(x) = +∞ signifie que pour tout M > 0, il existe δ > 0 '
          'tel que |x - a| < δ implique f(x) > M.\n\n'
          'Opérations sur les limites : soit lim f = L et lim g = M. Alors :\n'
          '• lim(f + g) = L + M\n'
          '• lim(f × g) = L × M\n'
          '• lim(f/g) = L/M si M ≠ 0\n\n'
          'Formes indéterminées : +∞ - ∞, 0 × ∞, ∞/∞, 0/0. On lève l\'indétermination par '
          'factorisation (termes prépondérants), quantité conjuguée, ou limite du taux d\'accroissement.\n\n'
          'Asymptotes :\n'
          '• Asymptote horizontale y = L si lim_{x→±∞} f(x) = L\n'
          '• Asymptote verticale x = a si lim_{x→a} f(x) = ±∞\n'
          '• Asymptote oblique y = ax + b si lim_{x→±∞} [f(x) - (ax + b)] = 0',
      example:
          'Exemple 1 — Limite en l\'infini :\n'
          'Calculer lim_{x→+∞} (3x² - 2x + 1)/(x² + 5).\n'
          'On factorise par x² au numérateur et dénominateur :\n'
          '= (3 - 2/x + 1/x²)/(1 + 5/x²)\n'
          'Quand x → +∞, 2/x → 0, 1/x² → 0, 5/x² → 0.\n'
          'Donc lim = 3/1 = 3.\n\n'
          'Exemple 2 — Forme indéterminée :\n'
          'Calculer lim_{x→0} (sin x)/x.\n'
          'C\'est la limite du taux d\'accroissement de sin en 0.\n'
          'Par définition : sin\'(0) = lim_{x→0} (sin x - sin 0)/(x - 0) = cos(0) = 1.\n'
          'Donc lim_{x→0} (sin x)/x = 1.',
      takeaways: [
        'Définition formelle de la limite avec ε et δ',
        'Opérations algébriques sur les limites',
        'Formes indéterminées : ∞-∞, 0×∞, ∞/∞, 0/0',
        'Asymptotes : horizontale (y=L), verticale (x=a), oblique (y=ax+b)',
        'Technique de factorisation par le terme de plus haut degré',
      ],
    ),
    'maths_ch2_l2': const LessonContent(
      introText:
          'La continuité est une propriété fondamentale des fonctions qui permet d\'appliquer '
          'le théorème des valeurs intermédiaires (TVI). Une fonction continue sur un intervalle '
          'prend toutes les valeurs comprises entre f(a) et f(b).',
      lessonBody:
          'Une fonction f est continue en a si lim_{x→a} f(x) = f(a). Graphiquement, cela signifie '
          'qu\'on peut tracer la courbe sans lever le crayon. Une fonction est continue sur un '
          'intervalle I si elle est continue en tout point de I.\n\n'
          'Continuité des fonctions usuelles : toute fonction polynomiale est continue sur ℝ. '
          'Les fonctions trigonométriques (sin, cos) sont continues sur ℝ. La fonction exponentielle '
          'est continue sur ℝ. La fonction logarithme est continue sur ]0, +∞[.\n\n'
          'Opérations : la somme, le produit, le quotient (si le dénominateur ne s\'annule pas) '
          'et la composée de fonctions continues sont continues.\n\n'
          'Théorème des valeurs intermédiaires (TVI) : si f est continue sur [a, b] et si '
          'f(a) × f(b) < 0 (c\'est-à-dire f(a) et f(b) sont de signes contraires), alors il '
          'existe au moins un réel c ∈ ]a, b[ tel que f(c) = 0.\n\n'
          'Corollaire : si f est continue sur [a, b] et si k est compris entre f(a) et f(b), '
          'alors il existe c ∈ [a, b] tel que f(c) = k.\n\n'
          'Théorème de la bijection : si f est continue et strictement monotone sur [a, b], '
          'alors f réalise une bijection de [a, b] vers [f(a), f(b)] (ou [f(b), f(a)] si décroissante).',
      example:
          'Exemple — TVI :\n'
          'Montrer que l\'équation x³ - 3x + 1 = 0 admet une solution dans [0, 1].\n'
          'Soit f(x) = x³ - 3x + 1. f est continue sur ℝ (fonction polynomiale).\n'
          'Calculons : f(0) = 0 - 0 + 1 = 1 (positif)\n'
          'f(1) = 1 - 3 + 1 = -1 (négatif)\n'
          'Donc f(0) × f(1) = -1 < 0. Par le TVI, il existe c ∈ ]0, 1[ tel que f(c) = 0.\n'
          'Donc l\'équation admet au moins une solution dans ]0, 1[.',
      takeaways: [
        'f continue en a ⟺ lim_{x→a} f(x) = f(a)',
        'Polynômes, trigo, exponentielle, logarithme sont continus',
        'TVI : si f(a)×f(b) < 0, ∃c ∈ ]a,b[ : f(c) = 0',
        'Bijection : continue + strictement monotone = bijection',
      ],
    ),
    'maths_ch2_l3': const LessonContent(
      introText:
          'Les fonctions trigonométriques présentent des limites remarquables qui sont essentielles '
          'pour l\'étude des phénomènes périodiques. Ces limites permettent de lever des formes '
          'indéterminées spécifiques aux expressions trigonométriques.',
      lessonBody:
          'Limites fondamentales des fonctions trigonométriques :\n\n'
          'lim_{x→0} (sin x)/x = 1. Cette limite se démontre par comparaison d\'aires dans le '
          'cercle trigonométrique. Elle est fondamentale pour le calcul différentiel.\n\n'
          'lim_{x→0} (1 - cos x)/x² = 1/2. Cette limite découle de la précédente en utilisant '
          'l\'identité 1 - cos x = 2 sin²(x/2).\n\n'
          'lim_{x→0} (tan x)/x = 1. Car tan x = sin x / cos x et cos 0 = 1.\n\n'
          'Continuité de sin et cos : pour tout a ∈ ℝ,\n'
          'lim_{x→a} sin x = sin a et lim_{x→a} cos x = cos a.\n\n'
          'Limites à l\'infini : sin x et cos x n\'ont pas de limite en ±∞ car elles '
          'oscillent entre -1 et 1. Cependant, on a les encadrements :\n'
          '-1 ≤ sin x ≤ 1 et -1 ≤ cos x ≤ 1.\n\n'
          'Théorème des gendarmes : si pour x proche de a, g(x) ≤ f(x) ≤ h(x) et '
          'lim g(x) = lim h(x) = L, alors lim f(x) = L.\n'
          'Application : lim_{x→+∞} (sin x)/x = 0 car -1/x ≤ (sin x)/x ≤ 1/x.',
      example:
          'Exemple 1 — Calcul avec sin :\n'
          'Calculer lim_{x→0} (sin 3x)/(2x).\n'
          'Posons t = 3x. Quand x → 0, t → 0.\n'
          '(sin 3x)/(2x) = (sin t)/(2 × t/3) = (3/2) × (sin t)/t\n'
          'lim = (3/2) × 1 = 3/2.\n\n'
          'Exemple 2 — Théorème des gendarmes :\n'
          'Calculer lim_{x→+∞} (cos x)/x².\n'
          'On a -1 ≤ cos x ≤ 1, donc -1/x² ≤ (cos x)/x² ≤ 1/x².\n'
          'lim -1/x² = lim 1/x² = 0. Par le théorème des gendarmes, '
          'lim_{x→+∞} (cos x)/x² = 0.',
      takeaways: [
        'lim_{x→0} sin x / x = 1 (limite fondamentale)',
        'lim_{x→0} (1 - cos x)/x² = 1/2',
        'sin et cos n\'ont pas de limite à l\'infini',
        'Théorème des gendarmes : encadrement vers la même limite',
        'Changement de variable pour adapter les limites fondamentales',
      ],
    ),
  };

  // ===========================================================================
  // MATHÉMATIQUES — Chapitre 3 : Dérivation et études de fonctions
  // ===========================================================================

  static final Map<String, LessonContent> _mathsCh3 = {
    'maths_ch3_l1': const LessonContent(
      introText:
          'La dérivée est l\'outil central de l\'analyse différentielle. Elle mesure le taux de variation '
          'instantanée d\'une fonction et permet d\'étudier ses variations. Cette leçon introduit le '
          'nombre dérivé et les formules de dérivation des fonctions usuelles.',
      lessonBody:
          'Le taux d\'accroissement de f entre a et a + h est : T(h) = [f(a + h) - f(a)]/h.\n'
          'Si T(h) admet une limite finie quand h → 0, cette limite est appelée nombre dérivé de f en a, '
          'noté f\'(a). On dit que f est dérivable en a.\n\n'
          'Équation de la tangente au point d\'abscisse a :\n'
          'y = f\'(a)(x - a) + f(a)\n\n'
          'Dérivées des fonctions usuelles :\n'
          '• f(x) = k (constante) → f\'(x) = 0\n'
          '• f(x) = xⁿ → f\'(x) = n xⁿ⁻¹\n'
          '• f(x) = √x → f\'(x) = 1/(2√x)\n'
          '• f(x) = sin x → f\'(x) = cos x\n'
          '• f(x) = cos x → f\'(x) = -sin x\n'
          '• f(x) = eˣ → f\'(x) = eˣ\n'
          '• f(x) = ln x → f\'(x) = 1/x\n\n'
          'Règles de calcul :\n'
          '• (u + v)\' = u\' + v\'\n'
          '• (ku)\' = ku\' (k constante)\n'
          '• (u × v)\' = u\'v + uv\'\n'
          '• (u/v)\' = (u\'v - uv\')/v²\n'
          '• (u ∘ v)\' = (u\' ∘ v) × v\' (dérivée composée)',
      example:
          'Exemple 1 — Calcul de dérivée :\n'
          'Soit f(x) = (3x² + 2)(x - 1).\n'
          'Posons u(x) = 3x² + 2, u\'(x) = 6x.\n'
          'v(x) = x - 1, v\'(x) = 1.\n'
          'f\'(x) = (6x)(x - 1) + (3x² + 2)(1)\n'
          'f\'(x) = 6x² - 6x + 3x² + 2\n'
          'f\'(x) = 9x² - 6x + 2.\n\n'
          'Exemple 2 — Tangente :\n'
          'Soit f(x) = x². Calculer l\'équation de la tangente en a = 3.\n'
          'f\'(x) = 2x, donc f\'(3) = 6 et f(3) = 9.\n'
          'Tangente : y = 6(x - 3) + 9 = 6x - 9.\n\n'
          '```graphe\n'
          'f(x) = x^2 | orange\n'
          'droite: y = 6x - 9 | bleu\n'
          'x: -1 .. 5\n'
          'y: -2 .. 14\n'
          'point: (3, 9) A\n'
          'titre: La tangente en A(3 ; 9) touche la parabole\n'
          '```',
      takeaways: [
        'Nombre dérivé : lim_{h→0} (f(a+h)-f(a))/h',
        'Tangente : y = f\'(a)(x-a) + f(a)',
        'Dérivées usuelles : xⁿ, √x, sin, cos, eˣ, ln x',
        'Règles : somme, produit, quotient, composée',
      ],
    ),
    'maths_ch3_l2': const LessonContent(
      introText:
          'Le signe de la dérivée première permet de déterminer les variations d\'une fonction '
          'et d\'identifier ses extremums locaux et globaux. C\'est une application fondamentale '
          'du calcul différentiel en optimisation.',
      lessonBody:
          'Lien entre signe de la dérivée et variations :\n'
          '• Si f\'(x) > 0 sur un intervalle I, alors f est strictement croissante sur I.\n'
          '• Si f\'(x) < 0 sur I, alors f est strictement décroissante sur I.\n'
          '• Si f\'(x) = 0 sur I, alors f est constante sur I.\n\n'
          'Extremums locaux : si f admet un extremum local en a et si f est dérivable en a, '
          'alors f\'(a) = 0. La réciproque n\'est pas vraie (contre-exemple : f(x) = x³ en 0).\n\n'
          'Condition suffisante d\'extremum : si f\'(a) = 0 et f\' change de signe en a, '
          'alors f admet un extremum local en a.\n'
          '• Si f\' passe de + à - en a, alors f(a) est un maximum local.\n'
          '• Si f\' passe de - à + en a, alors f(a) est un minimum local.\n\n'
          'Dérivée seconde : si f\'(a) = 0 et f"(a) > 0, alors f(a) est un minimum local. '
          'Si f\'(a) = 0 et f"(a) < 0, alors f(a) est un maximum local.\n\n'
          'Tableau de variation : on organise l\'étude en 4 étapes :\n'
          '1. Domaine de définition (Df)\n'
          '2. Calcul de f\'(x)\n'
          '3. Signe de f\'(x) selon x\n'
          '4. Variations et extremums',
      example:
          'Exemple — Étude complète :\n'
          'Soit f(x) = x³ - 3x + 1.\n'
          'Df = ℝ.\n'
          'f\'(x) = 3x² - 3 = 3(x² - 1) = 3(x - 1)(x + 1).\n'
          'Signe de f\'(x) :\n'
          'x | -∞  | -1  | 1  | +∞\n'
          'f\'(x) | + | 0 | - | 0 | +\n'
          'f | ↗ | f(-1)=3 | ↘ | f(1)=-1 | ↗\n'
          'Maximum local : f(-1) = 3.\n'
          'Minimum local : f(1) = -1.',
      takeaways: [
        'f\' > 0 → f croissante ; f\' < 0 → f décroissante',
        'Extremum local ⇒ f\' = 0 (condition nécessaire)',
        'Maximum local : f\' passe de + à -',
        'Minimum local : f\' passe de - à +',
        'Tableau de variation : Df → f\' → signe → variations',
      ],
    ),
    'maths_ch3_l3': const LessonContent(
      introText:
          'Le théorème des accroissements finis (TAF) est un résultat fondamental qui relie '
          'le taux d\'accroissement global d\'une fonction sur un intervalle à sa dérivée en '
          'un point intermédiaire. La formule de Taylor en est une généralisation.',
      lessonBody:
          'Théorème de Rolle : si f est continue sur [a, b], dérivable sur ]a, b[, et '
          'f(a) = f(b), alors il existe c ∈ ]a, b[ tel que f\'(c) = 0.\n\n'
          'Théorème des accroissements finis : si f est continue sur [a, b] et dérivable '
          'sur ]a, b[, alors il existe c ∈ ]a, b[ tel que :\n'
          'f\'(c) = [f(b) - f(a)]/(b - a)\n'
          'Autrement dit, la pente de la sécante (AB) est égale à la pente de la tangente en c.\n\n'
          'Inégalité des accroissements finis : si |f\'(x)| ≤ M pour tout x ∈ [a, b], '
          'alors |f(b) - f(a)| ≤ M × |b - a|.\n\n'
          'Formule de Taylor-Young : si f est n fois dérivable en a, alors :\n'
          'f(a + h) = f(a) + h f\'(a) + h²/2! f"(a) + ... + hⁿ/n! f⁽ⁿ⁾(a) + hⁿ ε(h)\n'
          'où ε(h) → 0 quand h → 0.\n\n'
          'Applications :'
          '• Développements limités des fonctions usuelles\n'
          '• Calcul de limites avec des formes indéterminées\n'
          '• Approximation locale d\'une fonction par un polynôme',
      example:
          'Exemple 1 — TAF :\n'
          'Soit f(x) = x² sur [1, 3].\n'
          'f(3) - f(1) = 9 - 1 = 8, b - a = 2.\n'
          'Donc il existe c ∈ ]1, 3[ tel que f\'(c) = 8/2 = 4.\n'
          'f\'(x) = 2x, donc 2c = 4, c = 2 ∈ ]1, 3[. Vérifié.\n\n'
          'Exemple 2 — Développement limité de sin :\n'
          'sin h = h - h³/6 + h⁵/120 + o(h⁵).\n'
          'Application : lim_{x→0} (sin x - x)/x³ = -1/6.',
      takeaways: [
        'Rolle : f(a) = f(b) ⇒ ∃c : f\'(c) = 0',
        'TAF : f\'(c) = (f(b)-f(a))/(b-a)',
        'Inégalité : |f(b)-f(a)| ≤ M·|b-a|',
        'Taylor-Young : développement polynomial local',
      ],
    ),
  };

  // ===========================================================================
  // MATHÉMATIQUES — Chapitre 4 : Fonctions logarithmes et exponentielles
  // ===========================================================================

  static final Map<String, LessonContent> _mathsCh4 = {
    'maths_ch4_l1': const LessonContent(
      introText:
          'La fonction logarithme népérien est la réciproque de la fonction exponentielle. '
          'Elle transforme les produits en sommes et joue un rôle central en analyse, '
          'notamment pour l\'étude des croissances et la résolution d\'équations.',
      lessonBody:
          'Le logarithme népérien, noté ln, est défini sur ]0, +∞[ par :\n'
          'ln x = ∫₁ˣ (1/t) dt.\n'
          'Propriétés fondamentales : ln(1) = 0 et ln(e) = 1.\n\n'
          'Pour tous a, b > 0 et tout réel n :\n'
          '• ln(a × b) = ln a + ln b\n'
          '• ln(a/b) = ln a - ln b\n'
          '• ln(aⁿ) = n ln a\n'
          '• ln(√a) = (1/2) ln a\n\n'
          'Dérivée : (ln x)\' = 1/x pour x > 0.\n'
          'Si u(x) > 0 et dérivable, alors (ln u)\' = u\'/u.\n\n'
          'Limites :\n'
          '• lim_{x→+∞} ln x = +∞\n'
          '• lim_{x→0⁺} ln x = -∞\n'
          '• lim_{x→+∞} (ln x)/x = 0 (croissance comparée)\n'
          '• lim_{x→0⁺} x ln x = 0\n\n'
          'Représentation : la courbe de ln traverse l\'axe des abscisses en (1, 0). '
          'Elle est strictement croissante, concave sur ]0, +∞[.',
      example:
          'Exemple 1 — Résolution :\n'
          'Résoudre ln(2x + 1) = 1.\n'
          'Condition : 2x + 1 > 0, soit x > -1/2.\n'
          'ln(2x + 1) = 1 ⇔ 2x + 1 = e¹ = e\n'
          '⇔ x = (e - 1)/2 ≈ 0,859. Valide car > -0,5.\n\n'
          'Exemple 2 — Dérivée :\n'
          'f(x) = ln(x² + 1). f\'(x) = (2x)/(x² + 1).\n\n'
          '```graphe\n'
          'ln(x) = ln(x) | violet\n'
          'exp(x) = e^x | orange\n'
          'droite: y = x | gris\n'
          'x: -3 .. 5\n'
          'y: -3 .. 5\n'
          '```',
      takeaways: [
        'ln x défini sur ]0, +∞[, ln 1 = 0, ln e = 1',
        'ln(ab) = ln a + ln b ; ln(a/b) = ln a - ln b',
        '(ln x)\' = 1/x ; (ln u)\' = u\'/u',
        'limite de (ln x)/x = 0 en +∞',
        'Courbe strictement croissante, concave',
      ],
    ),
    'maths_ch4_l2': const LessonContent(
      introText:
          'La fonction exponentielle, réciproque du logarithme népérien, est l\'une des '
          'fonctions les plus importantes des mathématiques. Elle modélise les croissances '
          'exponentielles, les désintégrations radioactives et de nombreux phénomènes naturels.',
      lessonBody:
          'La fonction exponentielle, notée exp(x) ou eˣ, est définie sur ℝ par :\n'
          'y = eˣ ⇔ x = ln y (pour y > 0).\n'
          'Propriétés fondamentales : e⁰ = 1 et e¹ = e.\n\n'
          'Pour tous a, b ∈ ℝ :\n'
          '• e^(a + b) = e^a × e^b\n'
          '• e^(a - b) = e^a / e^b\n'
          '• e^(na) = (e^a)ⁿ\n\n'
          'Dérivée : (eˣ)\' = eˣ.\n'
          'Plus généralement : (e^u)\' = u\' × e^u.\n\n'
          'Limites :\n'
          '• lim_{x→-∞} eˣ = 0\n'
          '• lim_{x→+∞} eˣ = +∞\n'
          '• lim_{x→+∞} eˣ/x = +∞ (croissance comparée)\n'
          '• lim_{x→-∞} x eˣ = 0\n\n'
          'Relation ln-exp :\n'
          '• ln(eˣ) = x pour tout x ∈ ℝ\n'
          '• e^(ln x) = x pour tout x > 0\n\n'
          'Représentation : la courbe de eˣ traverse l\'axe des ordonnées en (0, 1). '
          'Elle est strictement croissante, convexe sur ℝ.',
      example:
          'Exemple 1 — Résolution :\n'
          'Résoudre e^(2x) - 3eˣ + 2 = 0.\n'
          'Posons X = eˣ > 0. L\'équation devient : X² - 3X + 2 = 0.\n'
          'Δ = 9 - 8 = 1. X₁ = 1, X₂ = 2.\n'
          'X = eˣ = 1 ⇒ x = 0.\n'
          'X = eˣ = 2 ⇒ x = ln 2.\n'
          'Solutions : x ∈ {0, ln 2}.\n\n'
          'Exemple 2 — Dérivée :\n'
          'f(x) = e^(-x²). f\'(x) = -2x × e^(-x²).',
      takeaways: [
        'eˣ définie sur ℝ, e⁰ = 1, e¹ = e',
        'e^(a+b) = e^a × e^b ; e^(a-b) = e^a/e^b',
        '(eˣ)\' = eˣ ; (e^u)\' = u\' e^u',
        'Limite : eˣ/x → +∞ en +∞ (croissance très rapide)',
        'ln(eˣ) = x ; e^(ln x) = x (réciprocité)',
      ],
    ),
    'maths_ch4_l3': const LessonContent(
      introText:
          'Les croissances comparées permettent de comparer les vitesses de divergence '
          'des fonctions logarithmes, polynomiales et exponentielles à l\'infini. '
          'Ces résultats sont essentiels pour lever les formes indéterminées.',
      lessonBody:
          'Théorème des croissances comparées :\n\n'
          'À l\'infini (+∞) :\n'
          '1. Pour tout n > 0 : lim_{x→+∞} (ln x)/xⁿ = 0\n'
          '   Le logarithme croît moins vite que toute puissance positive de x.\n\n'
          '2. Pour tout n > 0 : lim_{x→+∞} xⁿ/eˣ = 0\n'
          '   L\'exponentielle croît plus vite que toute puissance de x.\n\n'
          '3. lim_{x→+∞} eˣ/xⁿ = +∞\n\n'
          'En 0⁺ :\n'
          '1. lim_{x→0⁺} xⁿ ln x = 0 pour tout n > 0.\n'
          '2. lim_{x→0⁺} xˣ = 1 (en écrivant xˣ = e^(x ln x)).\n\n'
          'En -∞ :\n'
          'lim_{x→-∞} |x|ⁿ eˣ = 0 (l\'exponentielle l\'emporte).\n\n'
          'Hiérarchie des croissances (de la plus lente à la plus rapide) :\n'
          'ln x ≺ xⁿ (n > 0) ≺ eˣ ≺ x! (factorielle)\n\n'
          'Application : toute fonction de la forme P(x)/eˣ, où P est un polynôme, '
          'tend vers 0 en +∞.',
      example:
          'Exemple 1 — Croissance comparée :\n'
          'Calculer lim_{x→+∞} (x³ + 2x)/(eˣ - 1).\n'
          'En +∞, x³/eˣ → 0 et 2x/eˣ → 0.\n'
          'Donc la limite est 0.\n\n'
          'Exemple 2 — Forme 0 × ∞ :\n'
          'Calculer lim_{x→0⁺} x ln x.\n'
          'C\'est une forme 0 × (-∞).\n'
          'D\'après les croissances comparées : lim_{x→0⁺} x ln x = 0.\n\n'
          'Exemple 3 — Ratio logarithmique :\n'
          'lim_{x→+∞} (ln x)/√x = 0.\n'
          'Même √x (qui croît lentement) croît plus vite que ln x.',
      takeaways: [
        'ln x croît moins vite que toute puissance de x',
        'eˣ croît plus vite que toute puissance de x',
        'En 0⁺ : xⁿ ln x → 0 ; xˣ → 1',
        'Hiérarchie : ln x ≺ xⁿ ≺ eˣ ≺ x!',
      ],
    ),
  };

  // ===========================================================================
  // MATHÉMATIQUES — Chapitre 5 : Suites numériques
  // ===========================================================================

  static final Map<String, LessonContent> _mathsCh5 = {
    'maths_ch5_l1': const LessonContent(
      introText:
          'Les suites numériques sont des listes ordonnées de nombres qui jouent un rôle '
          'fondamental en analyse. L\'étude de leur convergence permet de comprendre le '
          'comportement asymptotique de nombreux processus mathématiques.',
      lessonBody:
          'Une suite numérique est une fonction u : ℕ → ℝ. On note uₙ le terme de rang n.\n'
          'Une suite peut être définie par :\n'
          '• Formule explicite : uₙ = f(n)\n'
          '• Récurrence : uₙ₊₁ = f(uₙ)\n\n'
          'Monotonie :\n'
          '• u est croissante si uₙ₊₁ ≥ uₙ pour tout n\n'
          '• u est décroissante si uₙ₊₁ ≤ uₙ pour tout n\n'
          '• u est constante si uₙ₊₁ = uₙ\n\n'
          'Bornes :\n'
          '• u est majorée s\'il existe M tel que uₙ ≤ M pour tout n\n'
          '• u est minorée s\'il existe m tel que uₙ ≥ m pour tout n\n'
          '• u est bornée si elle est majorée et minorée\n\n'
          'Convergence :\n'
          '• u converge vers L si lim_{n→+∞} uₙ = L\n'
          '• Toute suite convergente est bornée\n'
          '• Toute suite croissante majorée converge\n'
          '• Toute suite décroissante minorée converge\n\n'
          'Suites adjacentes : deux suites (uₙ) et (vₙ) sont adjacentes si :\n'
          '1. u est croissante et v est décroissante\n'
          '2. lim (vₙ - uₙ) = 0\n'
          'Alors elles convergent vers la même limite.',
      example:
          'Exemple 1 — Convergence :\n'
          'Soit uₙ = (n + 1)/n = 1 + 1/n.\n'
          'u est décroissante (car 1/n décroît), minorée par 1.\n'
          'lim uₙ = 1. Donc u converge vers 1.\n\n'
          'Exemple 2 — Suites adjacentes :\n'
          'uₙ = 1 + 1/1! + 1/2! + ... + 1/n!\n'
          'vₙ = uₙ + 1/(n·n!)\n'
          '(uₙ) et (vₙ) sont adjacentes et convergent vers e.',
      takeaways: [
        'uₙ = f(n) explicite ou uₙ₊₁ = f(uₙ) récurrente',
        'Suite croissante majorée → convergente',
        'Suite décroissante minorée → convergente',
        'Suites adjacentes : même limite',
        'Toute suite convergente est bornée',
      ],
    ),
    'maths_ch5_l2': const LessonContent(
      introText:
          'Les suites arithmético-géométriques combinent une progression arithmétique '
          'et une progression géométrique. Leur étude permet de modéliser de nombreuses '
          'situations concrètes comme les prêts bancaires ou les populations.',
      lessonBody:
          'Une suite arithmético-géométrique est définie par :\n'
          'uₙ₊₁ = a uₙ + b, où a et b sont des constantes réelles.\n\n'
          'Méthode de résolution :\n'
          '1. On cherche le point fixe ℓ tel que ℓ = aℓ + b.\n'
          '   Soit ℓ = b/(1 - a) si a ≠ 1.\n'
          '2. On pose vₙ = uₙ - ℓ.\n'
          '3. vₙ₊₁ = uₙ₊₁ - ℓ = (a uₙ + b) - ℓ = a uₙ + b - ℓ = a(uₙ - ℓ) = a vₙ.\n'
          '4. Donc (vₙ) est géométrique de raison a : vₙ = aⁿ v₀.\n'
          '5. Finalement : uₙ = ℓ + aⁿ (u₀ - ℓ).\n\n'
          'Cas particuliers :\n'
          '• Si a = 1 : uₙ₊₁ = uₙ + b (suite arithmétique : uₙ = u₀ + nb)\n'
          '• Si b = 0 : uₙ₊₁ = a uₙ (suite géométrique : uₙ = aⁿ u₀)\n\n'
          'Convergence :\n'
          '• Si |a| < 1, alors (uₙ) converge vers ℓ (quel que soit u₀).\n'
          '• Si |a| > 1, (uₙ) diverge (sauf si u₀ = ℓ).\n'
          '• Si a = 1, (uₙ) est arithmétique (diverge si b ≠ 0).',
      example:
          'Exemple — Suite arithmético-géométrique :\n'
          'Soit u₀ = 2, uₙ₊₁ = 0,5 uₙ + 1.\n'
          'Point fixe : ℓ = 0,5ℓ + 1 ⇒ 0,5ℓ = 1 ⇒ ℓ = 2.\n'
          'vₙ = uₙ - 2. vₙ₊₁ = 0,5 vₙ.\n'
          'vₙ = (0,5)ⁿ × v₀ = (0,5)ⁿ × 0 = 0.\n'
          'Donc uₙ = 2 pour tout n. La suite est constante.\n\n'
          'Prenons u₀ = 1. v₀ = 1 - 2 = -1.\n'
          'vₙ = (0,5)ⁿ × (-1).\n'
          'uₙ = 2 - (0,5)ⁿ.\n'
          'Quand n → +∞, (0,5)ⁿ → 0, donc uₙ → 2 = ℓ.',
      takeaways: [
        'uₙ₊₁ = a uₙ + b : point fixe ℓ = b/(1-a)',
        'Se ramène à une suite géométrique vₙ = uₙ - ℓ',
        'uₙ = ℓ + aⁿ(u₀ - ℓ)',
        'Converge vers ℓ si |a| < 1',
      ],
    ),
    'maths_ch5_l3': const LessonContent(
      introText:
          'Les suites récurrentes linéaires d\'ordre 2, comme la suite de Fibonacci, '
          'modélisent des phénomènes où chaque terme dépend des deux précédents. '
          'Leur étude repose sur la résolution d\'une équation caractéristique.',
      lessonBody:
          'Une suite récurrente linéaire d\'ordre 2 est définie par :\n'
          'uₙ₊₂ = a uₙ₊₁ + b uₙ, avec a, b ∈ ℝ.\n\n'
          'Équation caractéristique : r² = a r + b, soit r² - a r - b = 0.\n\n'
          'Cas 1 — Deux racines réelles distinctes r₁ ≠ r₂ :\n'
          'uₙ = α r₁ⁿ + β r₂ⁿ, où α, β sont déterminés par u₀ et u₁.\n\n'
          'Cas 2 — Une racine double r₀ :\n'
          'uₙ = (α + β n) r₀ⁿ.\n\n'
          'Cas 3 — Racines complexes conjuguées :\n'
          'uₙ = ρⁿ (α cos(nθ) + β sin(nθ)).\n\n'
          'Suite de Fibonacci :\n'
          'u₀ = 0, u₁ = 1, uₙ₊₂ = uₙ₊₁ + uₙ.\n'
          'Équation : r² - r - 1 = 0 ⇒ r = (1 ± √5)/2.\n'
          'Soit φ = (1 + √5)/2 (nombre d\'or) et ψ = (1 - √5)/2.\n'
          'uₙ = (φⁿ - ψⁿ)/√5.\n\n'
          'Propriété : lim_{n→+∞} uₙ₊₁/uₙ = φ (nombre d\'or).',
      example:
          'Exemple — Suite récurrente :\n'
          'Soit u₀ = 0, u₁ = 1, uₙ₊₂ = 3uₙ₊₁ - 2uₙ.\n'
          'Équation caractéristique : r² - 3r + 2 = 0.\n'
          'r₁ = 1, r₂ = 2.\n'
          'Donc uₙ = α·1ⁿ + β·2ⁿ = α + β·2ⁿ.\n'
          'u₀ = α + β = 0 ⇒ α = -β.\n'
          'u₁ = α + 2β = -β + 2β = β = 1.\n'
          'Donc α = -1, β = 1. uₙ = 2ⁿ - 1.\n'
          'Vérification : u₂ = 4 - 1 = 3, et u₂ = 3u₁ - 2u₀ = 3. ✓',
      takeaways: [
        'uₙ₊₂ = a uₙ₊₁ + b uₙ → équation r² - a r - b = 0',
        'uₙ = α r₁ⁿ + β r₂ⁿ (racines distinctes)',
        'Suite de Fibonacci : uₙ = (φⁿ - ψⁿ)/√5',
        'Nombre d\'or φ = (1+√5)/2, rapport limite de Fibonacci',
      ],
    ),
  };

  // ===========================================================================
  // MATHÉMATIQUES — Chapitre 6 : Calcul intégral
  // ===========================================================================

  static final Map<String, LessonContent> _mathsCh6 = {
    'maths_ch6_l1': const LessonContent(
      introText:
          'La notion de primitive est l\'opération inverse de la dérivation. Trouver une primitive '
          'd\'une fonction revient à chercher une fonction dont la dérivée est la fonction donnée. '
          'C\'est la porte d\'entrée du calcul intégral.',
      lessonBody:
          'Une primitive de f sur un intervalle I est une fonction F telle que F\'(x) = f(x) '
          'pour tout x ∈ I. Si F est une primitive de f, alors toutes les primitives de f '
          'sont de la forme F(x) + C, où C est une constante réelle.\n\n'
          'Primitives usuelles :\n'
          '• f(x) = a (constante) → F(x) = ax + C\n'
          '• f(x) = xⁿ → F(x) = xⁿ⁺¹/(n+1) + C (n ≠ -1)\n'
          '• f(x) = 1/x → F(x) = ln|x| + C\n'
          '• f(x) = eˣ → F(x) = eˣ + C\n'
          '• f(x) = sin x → F(x) = -cos x + C\n'
          '• f(x) = cos x → F(x) = sin x + C\n'
          '• f(x) = 1/√(1-x²) → F(x) = arcsin x + C\n\n'
          'Linéarité : si F est primitive de f et G primitive de g, alors :\n'
          '• F + G est primitive de f + g\n'
          '• kF est primitive de kf (k constante)\n\n'
          'Primitive de u\' × f\'(u) : si F\' = f, alors (F ∘ u)\' = u\' × f(u). '
          'Donc une primitive de u\' × f(u) est F(u).',
      example:
          'Exemple — Calcul de primitives :\n'
          '1. f(x) = 3x² - 2x + 1\n'
          'F(x) = x³ - x² + x + C.\n\n'
          '2. f(x) = 1/(2x + 1)\n'
          'F(x) = (1/2) ln|2x + 1| + C.\n\n'
          '3. f(x) = 2x e^(x²)\n'
          'On a u = x², u\' = 2x, donc F(x) = e^(x²) + C.',
      takeaways: [
        'F primitive de f ⇔ F\' = f',
        'Primitives usuelles : xⁿ, 1/x, eˣ, sin, cos',
        'Linéarité : (F+G)\' = f+g, (kF)\' = kf',
        'Primitive de u\'·f\'(u) = F(u)',
        'Toutes les primitives diffèrent d\'une constante',
      ],
    ),
    'maths_ch6_l2': const LessonContent(
      introText:
          'L\'intégrale définie mesure l\'aire sous la courbe d\'une fonction entre deux bornes. '
          'Le lien entre intégrale et primitive est donné par le théorème fondamental de l\'analyse, '
          'l\'un des résultats les plus importants des mathématiques.',
      lessonBody:
          'L\'intégrale de f de a à b, notée ∫ₐᵇ f(x) dx, représente l\'aire algébrique '
          'comprise entre la courbe de f et l\'axe des abscisses, entre les droites x = a et x = b.\n\n'
          'Théorème fondamental de l\'analyse :\n'
          'Si f est continue sur [a, b] et F est une primitive de f, alors :\n'
          '∫ₐᵇ f(x) dx = F(b) - F(a).\n\n'
          'Propriétés :\n'
          '• Linéarité : ∫ₐᵇ (f+g) = ∫ₐᵇ f + ∫ₐᵇ g\n'
          '• Relation de Chasles : ∫ₐᵇ f + ∫ᵇᶜ f = ∫ₐᶜ f\n'
          '• Positivité : si f(x) ≥ 0 sur [a, b], alors ∫ₐᵇ f(x) dx ≥ 0\n'
          '• Inégalité : si f ≤ g sur [a, b], alors ∫ₐᵇ f ≤ ∫ₐᵇ g\n\n'
          'Valeur moyenne de f sur [a, b] :\n'
          'm = (1/(b - a)) × ∫ₐᵇ f(x) dx.\n\n'
          'Calcul d\'aires :\n'
          '• Aire entre deux courbes : ∫ₐᵇ |f(x) - g(x)| dx\n'
          '• Aire sous la courbe : ∫ₐᵇ f(x) dx (si f ≥ 0).',
      example:
          'Exemple 1 — Intégrale simple :\n'
          'Calculer ∫₀² (3x² - 2x + 1) dx.\n'
          'Primitive : F(x) = x³ - x² + x.\n'
          'F(2) = 8 - 4 + 2 = 6.\n'
          'F(0) = 0.\n'
          '∫₀² (3x² - 2x + 1) dx = 6 - 0 = 6.\n\n'
          'Exemple 2 — Aire sous la courbe :\n'
          'Calculer l\'aire entre la courbe de f(x) = x² et l\'axe des x de 0 à 1.\n'
          'F(x) = x³/3. F(1) - F(0) = 1/3 - 0 = 1/3 u.a.',
      takeaways: [
        '∫ₐᵇ f(x) dx = F(b) - F(a) (théorème fondamental)',
        'Linéarité, Chasles, positivité',
        'Valeur moyenne : (1/(b-a)) ∫ₐᵇ f',
        'Aire sous la courbe = ∫ₐᵇ f(x) dx (si f ≥ 0)',
      ],
    ),
    'maths_ch6_l3': const LessonContent(
      introText:
          'L\'intégration par parties (IPP) est une technique puissante pour calculer des '
          'intégrales de produits de fonctions. Elle transforme une intégrale en une autre, '
          'plus simple à évaluer, en exploitant la dérivée d\'un produit.',
      lessonBody:
          'Formule d\'intégration par parties :\n'
          '∫ₐᵇ u(x) v\'(x) dx = [u(x) v(x)]ₐᵇ - ∫ₐᵇ u\'(x) v(x) dx\n\n'
          'Ou plus simplement : ∫ u dv = uv - ∫ v du.\n\n'
          'Stratégie de choix de u et dv :\n'
          'On choisit u de sorte que u\' soit plus simple que u (règle LIATE) :\n'
          'L : Logarithme (ln x)\n'
          'I : Inverse trigonométrique (arcsin, arctan)\n'
          'A : Algébrique (xⁿ)\n'
          'T : Trigonométrique (sin x, cos x)\n'
          'E : Exponentielle (eˣ)\n\n'
          'Applications :\n'
          '• ∫ x eˣ dx : poser u = x, dv = eˣ dx\n'
          '• ∫ ln x dx : poser u = ln x, dv = dx\n'
          '• ∫ x cos x dx : poser u = x, dv = cos x dx\n\n'
          'IPP multiples : pour ∫ x² eˣ dx, on applique IPP deux fois.',
      example:
          'Exemple 1 — ∫ x eˣ dx :\n'
          'Posons u = x ⇒ du = dx.\n'
          'dv = eˣ dx ⇒ v = eˣ.\n'
          '∫ x eˣ dx = x eˣ - ∫ eˣ dx = x eˣ - eˣ + C.\n\n'
          'Exemple 2 — ∫₀¹ x eˣ dx :\n'
          '= [x eˣ - eˣ]₀¹\n'
          '= (1·e¹ - e¹) - (0·e⁰ - e⁰)\n'
          '= (e - e) - (0 - 1) = 1.\n\n'
          'Exemple 3 — ∫ ln x dx :\n'
          'u = ln x, dv = dx.\n'
          'du = (1/x) dx, v = x.\n'
          '∫ ln x dx = x ln x - ∫ x·(1/x) dx = x ln x - ∫ dx = x ln x - x + C.',
      takeaways: [
        '∫ u dv = uv - ∫ v du',
        'Règle LIATE : Log, Inverse, Algébrique, Trigo, Exp',
        'Choisir u qui se simplifie en dérivant',
        'Pour xⁿ eˣ : appliquer IPP n fois',
      ],
    ),
  };

  // ===========================================================================
  // MATHÉMATIQUES — Chapitre 7 : Équations différentielles
  // ===========================================================================

  static final Map<String, LessonContent> _mathsCh7 = {
    'maths_ch7_l1': const LessonContent(
      introText:
          'Les équations différentielles du premier ordre relient une fonction à sa dérivée. '
          'Elles modélisent des phénomènes d\'évolution comme la croissance bactérienne, '
          'la décharge d\'un condensateur ou la désintégration radioactive.',
      lessonBody:
          'Une équation différentielle linéaire du premier ordre est de la forme :\n'
          'y\' + a(x) y = b(x).\n\n'
          'Équation homogène (sans second membre) : y\' + a y = 0.\n'
          'Solution générale : yₕ(x) = C e^{-∫ a(x) dx}, où C ∈ ℝ.\n\n'
          'Si a est constant : y\' + a y = 0 ⇒ y(x) = C e^{-ax}.\n\n'
          'Équation avec second membre constant : y\' + a y = b.\n'
          'Solution particulière constante : yₚ = b/a (si a ≠ 0).\n'
          'Solution générale : y(x) = C e^{-ax} + b/a.\n\n'
          'Méthode de variation de la constante :\n'
          'Pour y\' + a y = b(x), on cherche y(x) = C(x) e^{-∫ a dx}.\n'
          'On obtient C\'(x) = b(x) e^{∫ a dx}, qu\'on intègre.\n\n'
          'Problème de Cauchy : si on impose y(x₀) = y₀, on détermine la constante C '
          'de manière unique.',
      example:
          'Exemple 1 — y\' + 2y = 0 :\n'
          'Solution : y(x) = C e^{-2x}.\n'
          'Si y(0) = 3, alors C = 3, soit y(x) = 3 e^{-2x}.\n\n'
          'Exemple 2 — y\' + 3y = 6 :\n'
          'Solution homogène : yₕ = C e^{-3x}.\n'
          'Solution particulière : yₚ = 6/3 = 2.\n'
          'Solution générale : y(x) = C e^{-3x} + 2.\n'
          'Si y(0) = 5 : C + 2 = 5 ⇒ C = 3, soit y(x) = 3 e^{-3x} + 2.',
      takeaways: [
        'y\' + a y = 0 ⇒ y = C e^{-∫ a dx}',
        'y\' + a y = b ⇒ solution particulière + homogène',
        'Variation de la constante : C(x) pour second membre variable',
        'Problème de Cauchy : condition initiale → une solution unique',
      ],
    ),
    'maths_ch7_l2': const LessonContent(
      introText:
          'Les équations différentielles du second ordre décrivent des phénomènes oscillatoires, '
          'comme les mouvements d\'un pendule ou les circuits RLC. Leur résolution fait intervenir '
          'une équation caractéristique et des solutions exponentielles ou trigonométriques.',
      lessonBody:
          'Équation linéaire du second ordre à coefficients constants :\n'
          'y" + a y\' + b y = 0 (homogène).\n\n'
          'Équation caractéristique : r² + a r + b = 0.\n\n'
          'Trois cas selon Δ = a² - 4b :\n\n'
          '1. Δ > 0 : deux racines réelles r₁ ≠ r₂.\n'
          '   y(x) = C₁ e^{r₁x} + C₂ e^{r₂x}.\n\n'
          '2. Δ = 0 : une racine double r₀ = -a/2.\n'
          '   y(x) = (C₁ + C₂ x) e^{r₀x}.\n\n'
          '3. Δ < 0 : racines complexes r = α ± iβ.\n'
          '   y(x) = e^{αx} (C₁ cos βx + C₂ sin βx).\n\n'
          'Cas particulier important : y" + ω² y = 0 (oscillateur harmonique).\n'
          'Équation caractéristique : r² + ω² = 0 ⇒ r = ± iω.\n'
          'Solution : y(x) = C₁ cos(ωx) + C₂ sin(ωx).\n\n'
          'Avec second membre : y" + a y\' + b y = f(x).\n'
          'Solution générale = solution homogène + solution particulière.',
      example:
          'Exemple 1 — y" - 3y\' + 2y = 0 :\n'
          'r² - 3r + 2 = 0 ⇒ r₁ = 1, r₂ = 2.\n'
          'y(x) = C₁ eˣ + C₂ e^{2x}.\n\n'
          'Exemple 2 — y" + 4y = 0 (oscillateur) :\n'
          'r² + 4 = 0 ⇒ r = ± 2i.\n'
          'y(x) = C₁ cos(2x) + C₂ sin(2x).\n'
          'Pulsation : ω = 2, période : T = 2π/ω = π.',
      takeaways: [
        'y" + a y\' + b y = 0 → équation r² + a r + b = 0',
        'Δ > 0 : exponentielles réelles',
        'Δ = 0 : exponentielle × polynôme',
        'Δ < 0 : exponentielle × sin/cos (oscillations)',
        'y" + ω² y = 0 : solutions sinusoïdales pures',
      ],
    ),
  };

  // ===========================================================================
  // MATHÉMATIQUES — Chapitre 8 : Probabilités
  // ===========================================================================

  static final Map<String, LessonContent> _mathsCh8 = {
    'maths_ch8_l1': const LessonContent(
      introText:
          'Une variable aléatoire discrète associe une probabilité à chaque valeur possible '
          'd\'une expérience aléatoire. L\'espérance et la variance mesurent respectivement '
          'la tendance centrale et la dispersion de cette distribution.',
      lessonBody:
          'Une variable aléatoire discrète X est une fonction qui associe un nombre réel '
          'à chaque issue d\'une expérience aléatoire. La loi de probabilité de X associe '
          'à chaque valeur xᵢ sa probabilité pᵢ = P(X = xᵢ).\n\n'
          'Propriétés : 0 ≤ pᵢ ≤ 1 et Σ pᵢ = 1.\n\n'
          'Espérance mathématique :\n'
          'E(X) = Σ xᵢ pᵢ.\n'
          'C\'est la moyenne pondérée des valeurs possibles.\n\n'
          'Propriétés de l\'espérance :\n'
          '• E(aX + b) = a E(X) + b\n'
          '• E(X + Y) = E(X) + E(Y)\n\n'
          'Variance :\n'
          'V(X) = Σ (xᵢ - E(X))² pᵢ = E(X²) - [E(X)]².\n\n'
          'Écart-type : σ(X) = √V(X).\n\n'
          'Propriétés de la variance :\n'
          '• V(aX + b) = a² V(X)\n'
          '• V(X) ≥ 0, V(X) = 0 si X est constante\n\n'
          'Fonction de répartition :\n'
          'F(x) = P(X ≤ x) = Σ_{xᵢ ≤ x} pᵢ.',
      example:
          'Exemple — Lancer de dé :\n'
          'X = résultat du lancer d\'un dé équilibré.\n'
          'P(X = k) = 1/6 pour k = 1, ..., 6.\n'
          'E(X) = (1+2+3+4+5+6)/6 = 3,5.\n'
          'E(X²) = (1+4+9+16+25+36)/6 = 91/6 ≈ 15,17.\n'
          'V(X) = 15,17 - (3,5)² = 15,17 - 12,25 = 2,92.\n'
          'σ(X) = √2,92 ≈ 1,71.',
      takeaways: [
        'Loi de probabilité : Σ pᵢ = 1',
        'E(X) = Σ xᵢ pᵢ (moyenne pondérée)',
        'V(X) = Σ (xᵢ - E(X))² pᵢ',
        'Écart-type : σ = √V',
        'E(aX+b) = aE(X)+b ; V(aX+b) = a²V(X)',
      ],
    ),
    'maths_ch8_l2': const LessonContent(
      introText:
          'La loi binomiale modélise le nombre de succès dans une série d\'épreuves de Bernoulli '
          'indépendantes. C\'est l\'une des lois de probabilité les plus importantes en raison '
          'de ses nombreuses applications pratiques.',
      lessonBody:
          'Une épreuve de Bernoulli est une expérience aléatoire à deux issues : '
          'succès (S) avec probabilité p, échec (E) avec probabilité q = 1 - p.\n\n'
          'Schéma de Bernoulli : on répète n épreuves de Bernoulli identiques et indépendantes.\n'
          'La variable aléatoire X = nombre de succès suit la loi binomiale B(n, p).\n\n'
          'Formule : P(X = k) = C(n, k) p^k q^{n-k}.\n'
          'où C(n, k) = n!/(k!(n-k)!) est le coefficient binomial.\n\n'
          'Espérance : E(X) = n p.\n'
          'Variance : V(X) = n p q.\n'
          'Écart-type : σ(X) = √(n p q).\n\n'
          'Exemple d\'application :\n'
          'On lance 5 fois une pièce équilibrée (p = 0,5).\n'
          'X = nombre de faces.\n'
          'P(X = 3) = C(5, 3) × (0,5)³ × (0,5)² = 10 × 0,125 × 0,25 = 0,3125.\n\n'
          'Propriétés :\n'
          '• La somme de deux binomiales indépendantes de même paramètre p suit B(n₁+n₂, p).\n'
          '• Loi des grands nombres : la fréquence tend vers p quand n → +∞.\n'
          '• Espérance de la fréquence : E(X/n) = p.',
      example:
          'Exemple — Contrôle qualité :\n'
          'Dans une usine, 5% des pièces sont défectueuses.\n'
          'On prélève 20 pièces au hasard.\n'
          'X = nombre de pièces défectueuses suit B(20, 0,05).\n'
          'P(X = 0) = C(20,0) × (0,95)^20 ≈ 0,358.\n'
          'P(X ≥ 1) = 1 - P(X = 0) ≈ 0,642.\n'
          'E(X) = 20 × 0,05 = 1 (en moyenne, 1 pièce défectueuse par lot).',
      takeaways: [
        'Épreuve de Bernoulli : succès (p) ou échec (q=1-p)',
        'B(n,p) : P(X=k) = C(n,k) p^k q^{n-k}',
        'E(X) = np ; V(X) = npq',
        'C(n,k) = n!/(k!(n-k)!)',
      ],
    ),
    'maths_ch8_l3': const LessonContent(
      introText:
          'La loi normale (ou loi de Gauss) est la loi de probabilité continue la plus importante '
          'en statistique. Elle modélise de nombreux phénomènes naturels et constitue la base '
          'de l\'inférence statistique grâce au théorème central limite.',
      lessonBody:
          'Une variable aléatoire X suit la loi normale N(μ, σ²) si sa densité de probabilité est :\n'
          'f(x) = (1/(σ√(2π))) × exp(-(x-μ)²/(2σ²)).\n\n'
          'Propriétés :\n'
          '• E(X) = μ (espérance = moyenne)\n'
          '• V(X) = σ² (variance)\n'
          '• σ = écart-type\n'
          '• La courbe est en forme de cloche, symétrique autour de μ.\n\n'
          'Loi normale centrée réduite : Z = (X - μ)/σ suit N(0, 1).\n'
          'Sa fonction de répartition est notée Φ(z) = P(Z ≤ z).\n\n'
          'Intervalles remarquables (règle 68-95-99,7) :\n'
          '• P(μ - σ ≤ X ≤ μ + σ) ≈ 0,683 (68,3%)\n'
          '• P(μ - 2σ ≤ X ≤ μ + 2σ) ≈ 0,954 (95,4%)\n'
          '• P(μ - 3σ ≤ X ≤ μ + 3σ) ≈ 0,997 (99,7%)\n\n'
          'Théorème central limite : la moyenne d\'un grand nombre de variables aléatoires '
          'indépendantes et identiquement distribuées tend vers une loi normale.\n\n'
          'Approximation de la loi binomiale : si n ≥ 30, np ≥ 5 et nq ≥ 5, '
          'on peut approximer B(n, p) par N(np, npq).',
      example:
          'Exemple 1 — Calcul de probabilité :\n'
          'Soit X ∼ N(100, 15²). Calculer P(X ≤ 130).\n'
          'Z = (130 - 100)/15 = 2.\n'
          'P(X ≤ 130) = P(Z ≤ 2) = Φ(2) ≈ 0,977.\n\n'
          'Exemple 2 — Approximation binomiale :\n'
          'On lance 100 fois une pièce équilibrée.\n'
          'X ∼ B(100, 0,5). Approximons par N(50, 25).\n'
          'P(X ≤ 60) : Z = (60,5 - 50)/5 = 2,1 (correction de continuité).\n'
          'P ≈ Φ(2,1) ≈ 0,982.',
      takeaways: [
        'N(μ, σ²) : densité en cloche, symétrique autour de μ',
        'Centrée réduite : Z = (X-μ)/σ ∼ N(0,1)',
        '68% des valeurs dans [μ-σ, μ+σ]',
        '95% dans [μ-2σ, μ+2σ]',
        'Approximation binomiale par normale si n ≥ 30',
      ],
    ),
  };

  // ===========================================================================
  // MATHÉMATIQUES — Chapitre 9 : Géométrie dans l\'espace
  // ===========================================================================

  static final Map<String, LessonContent> _mathsCh9 = {
    'maths_ch9_l1': const LessonContent(
      introText:
          'La géométrie dans l\'espace étend les notions vectorielles du plan à trois dimensions. '
          'Les vecteurs, combinaisons linéaires et bases sont les outils fondamentaux pour '
          'représenter et manipuler des objets dans l\'espace.',
      lessonBody:
          'Un vecteur de l\'espace est défini par trois coordonnées : v = (x, y, z).\n'
          'Les opérations vectorielles sont similaires au plan :\n'
          '• Addition : v + w = (x₁+x₂, y₁+y₂, z₁+z₂)\n'
          '• Multiplication par scalaire : λv = (λx, λy, λz)\n\n'
          'Combinaison linéaire : tout vecteur peut s\'écrire comme combinaison linéaire '
          'des vecteurs de base i = (1,0,0), j = (0,1,0), k = (0,0,1).\n\n'
          'Produit scalaire : v·w = x₁x₂ + y₁y₂ + z₁z₂.\n'
          '• v·w = |v||w| cos θ\n'
          '• v ⟂ w ⇔ v·w = 0\n\n'
          'Norme d\'un vecteur : |v| = √(x² + y² + z²).\n\n'
          'Produit vectoriel : v × w = (y₁z₂ - z₁y₂, z₁x₂ - x₁z₂, x₁y₂ - y₁x₂).\n'
          '• v × w est orthogonal à v et w\n'
          '• |v × w| = |v||w| sin θ\n'
          '• Il donne l\'aire du parallélogramme formé par v et w\n\n'
          'Base orthonormée : trois vecteurs unitaires deux à deux orthogonaux.\n'
          'Tout vecteur se décompose de manière unique dans une base : v = αi + βj + γk.',
      example:
          'Exemple 1 — Produit scalaire :\n'
          'Soient v = (1, 2, -1) et w = (3, 0, 4).\n'
          'v·w = 1×3 + 2×0 + (-1)×4 = 3 + 0 - 4 = -1.\n'
          '|v| = √(1+4+1) = √6.\n'
          '|w| = √(9+0+16) = √25 = 5.\n'
          'cos θ = -1/(5√6) ≈ -0,082, donc θ ≈ 94,7°.\n\n'
          'Exemple 2 — Produit vectoriel :\n'
          'v × w = (2×4 - (-1)×0, (-1)×3 - 1×4, 1×0 - 2×3)\n'
          '= (8 - 0, -3 - 4, 0 - 6) = (8, -7, -6).',
      takeaways: [
        'v = (x, y, z) dans ℝ³',
        'Produit scalaire : v·w = x₁x₂ + y₁y₂ + z₁z₂',
        'Produit vectoriel : orthogonal à v et w',
        'Base orthonormée i, j, k',
      ],
    ),
    'maths_ch9_l2': const LessonContent(
      introText:
          'Les droites et les plans dans l\'espace sont représentés par des équations '
          'paramétriques ou cartésiennes. Leurs intersections sont des problèmes classiques '
          'de géométrie dans l\'espace.',
      lessonBody:
          'Représentation paramétrique d\'une droite passant par A(x₀, y₀, z₀) '
          'de vecteur directeur v(a, b, c) :\n'
          'x = x₀ + a t\n'
          'y = y₀ + b t\n'
          'z = z₀ + c t, t ∈ ℝ\n\n'
          'Équation cartésienne d\'un plan passant par A avec vecteur normal n(a, b, c) :\n'
          'a(x - x₀) + b(y - y₀) + c(z - z₀) = 0\n'
          'Soit : ax + by + cz + d = 0.\n\n'
          'Positions relatives de deux droites :\n'
          '• Parallèles si leurs vecteurs directeurs sont colinéaires\n'
          '• Sécantes si elles se coupent en un point\n'
          '• Non coplanaires si elles ne sont ni parallèles ni sécantes\n\n'
          'Positions relatives d\'une droite et d\'un plan :\n'
          '• Droite parallèle au plan si v·n = 0\n'
          '• Droite perpendiculaire au plan si v est colinéaire à n\n'
          '• Sécants sinon (un point d\'intersection)\n\n'
          'Positions relatives de deux plans :\n'
          '• Parallèles si leurs normaux sont colinéaires\n'
          '• Sécants selon une droite si leurs normaux ne sont pas colinéaires\n\n'
          'Distance d\'un point M(x₀, y₀, z₀) à un plan ax + by + cz + d = 0 :\n'
          'd = |ax₀ + by₀ + cz₀ + d| / √(a² + b² + c²).',
      example:
          'Exemple — Intersection droite-plan :\n'
          'Droite : (x, y, z) = (1+t, 2-t, 3+2t), t ∈ ℝ.\n'
          'Plan : 2x - y + 3z - 4 = 0.\n'
          'On remplace : 2(1+t) - (2-t) + 3(3+2t) - 4 = 0.\n'
          '2 + 2t - 2 + t + 9 + 6t - 4 = 0.\n'
          '9t + 5 = 0 ⇒ t = -5/9.\n'
          'Point d\'intersection : (1-5/9, 2+5/9, 3-10/9) = (4/9, 23/9, 17/9).',
      takeaways: [
        'Droite : paramétrique (x = x₀ + at, ...)',
        'Plan : ax + by + cz + d = 0 (normal n(a,b,c))',
        'Intersection droite-plan : substituer dans l\'équation',
        'Distance point-plan : |ax₀+by₀+cz₀+d|/√(a²+b²+c²)',
      ],
    ),
    'maths_ch9_l3': const LessonContent(
      introText:
          'Le produit scalaire dans l\'espace permet de définir l\'orthogonalité et de calculer '
          'des distances. Il généralise les notions de projection et de perpendicularité du plan.',
      lessonBody:
          'Produit scalaire dans ℝ³ :\n'
          'Pour v = (x₁, y₁, z₁) et w = (x₂, y₂, z₂) :\n'
          'v·w = x₁x₂ + y₁y₂ + z₁z₂.\n\n'
          'Propriétés :\n'
          '• Symétrie : v·w = w·v\n'
          '• Bilinéarité : (λv + μw)·u = λ(v·u) + μ(w·u)\n'
          '• Positivité : v·v ≥ 0, v·v = 0 ⇔ v = 0\n\n'
          'Orthogonalité : v ⟂ w ⇔ v·w = 0.\n'
          'Deux droites sont orthogonales si le produit scalaire de leurs vecteurs directeurs est nul.\n\n'
          'Distance entre deux points :\n'
          'AB = √((x_B - x_A)² + (y_B - y_A)² + (z_B - z_A)²).\n\n'
          'Distance d\'un point à une droite :\n'
          'Si la droite passe par A et a pour vecteur directeur v, alors :\n'
          'd(M, droite) = |AM × v| / |v|.\n\n'
          'Projection orthogonale d\'un vecteur sur un autre :\n'
          'proj_v(w) = ((w·v)/(v·v)) × v.\n\n'
          'Angle entre deux vecteurs :\n'
          'cos θ = (v·w)/(|v||w|).',
      example:
          'Exemple 1 — Distance point-droite :\n'
          'Droite passant par A(1, 0, 2) de vecteur v(2, -1, 3).\n'
          'Point M(4, 1, -1). AM = (3, 1, -3).\n'
          'AM × v = (1×3 - (-3)×(-1), (-3)×2 - 3×3, 3×(-1) - 1×2)\n'
          '= (3 - 3, -6 - 9, -3 - 2) = (0, -15, -5).\n'
          '|AM × v| = √(0 + 225 + 25) = √250 = 5√10.\n'
          '|v| = √(4+1+9) = √14.\n'
          'd = 5√10/√14 = 5√(5/7).\n\n'
          'Exemple 2 — Angle :\n'
          'Soient v(1, 0, 1) et w(0, 2, 1).\n'
          'v·w = 0 + 0 + 1 = 1.\n'
          '|v| = √2, |w| = √5.\n'
          'cos θ = 1/(√10) ≈ 0,316 ⇒ θ ≈ 71,6°.',
      takeaways: [
        'v·w = x₁x₂ + y₁y₂ + z₁z₂',
        'Orthogonalité : v·w = 0',
        'Distance point-droite : d = |AM×v|/|v|',
        'Angle : cos θ = (v·w)/(|v||w|)',
        'Projection : proj_v(w) = ((w·v)/(v·v)) v',
      ],
    ),
  };

  // ===========================================================================
  // MATHÉMATIQUES — Chapitre 10 : Arithmétique
  // ===========================================================================

  static final Map<String, LessonContent> _mathsCh10 = {
    'maths_ch10_l1': const LessonContent(
      introText:
          'L\'arithmétique dans ℤ étudie les propriétés des nombres entiers. Les notions '
          'de divisibilité, de multiples et de diviseurs sont fondamentales pour comprendre '
          'la structure des nombres et résoudre des équations diophantiennes.',
      lessonBody:
          'On dit que a divise b (noté a | b) s\'il existe un entier k tel que b = a × k.\n'
          'Propriétés :\n'
          '• Si a | b et a | c alors a | (b + c) et a | (b - c)\n'
          '• Si a | b et b | c alors a | c (transitivité)\n'
          '• Si a | b et a | c alors a | (ub + vc) pour tous entiers u, v\n\n'
          'Division euclidienne : pour a, b ∈ ℕ, b ≠ 0, il existe un unique couple (q, r) '
          'tel que a = bq + r avec 0 ≤ r < b. q est le quotient, r le reste.\n\n'
          'Nombres premiers : un entier p ≥ 2 est premier si ses seuls diviseurs sont 1 et p.\n'
          'Liste des petits nombres premiers : 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31...\n\n'
          'Théorème fondamental de l\'arithmétique (unicité de la décomposition) :\n'
          'tout entier n ≥ 2 se décompose de manière unique (à l\'ordre près) en produit '
          'de facteurs premiers : n = p₁^{α₁} × p₂^{α₂} × ... × p_k^{α_k}.\n\n'
          'Lemme d\'Euclide : si p est premier et p | (ab), alors p | a ou p | b.\n\n'
          'Critères de divisibilité :\n'
          '• Par 2 : le dernier chiffre est pair\n'
          '• Par 3 : la somme des chiffres est multiple de 3\n'
          '• Par 5 : le dernier chiffre est 0 ou 5\n'
          '• Par 9 : la somme des chiffres est multiple de 9',
      example:
          'Exemple 1 — Division euclidienne :\n'
          'Soit a = 125, b = 7.\n'
          '125 = 7 × 17 + 6. Donc q = 17, r = 6.\n\n'
          'Exemple 2 — Décomposition :\n'
          '360 = 36 × 10 = (6²) × (2×5) = (2×3)² × 2 × 5 = 2³ × 3² × 5.\n\n'
          'Exemple 3 — Test de primalité :\n'
          'Vérifier si 101 est premier.\n'
          'On teste les diviseurs premiers jusqu\'à √101 ≈ 10.\n'
          '101 n\'est divisible ni par 2, 3, 5, 7. Donc 101 est premier.',
      takeaways: [
        'a|b ⇔ b = a×k pour un entier k',
        'Division euclidienne : a = bq + r, 0 ≤ r < b',
        'Nombre premier : divisible seulement par 1 et lui-même',
        'Décomposition unique en facteurs premiers',
      ],
    ),
    'maths_ch10_l2': const LessonContent(
      introText:
          'Le PGCD (Plus Grand Commun Diviseur) et le PPCM (Plus Petit Commun Multiple) '
          'sont des outils essentiels pour travailler avec les fractions, résoudre des '
          'équations diophantiennes et simplifier des expressions arithmétiques.',
      lessonBody:
          'PGCD de deux entiers : le plus grand entier qui divise à la fois a et b.\n'
          'Notation : pgcd(a, b) ou a ∧ b.\n\n'
          'Algorithme d\'Euclide :\n'
          '1. On effectue la division euclidienne de a par b : a = bq + r\n'
          '2. pgcd(a, b) = pgcd(b, r)\n'
          '3. On recommence jusqu\'à obtenir un reste nul\n'
          '4. Le dernier reste non nul est le PGCD.\n\n'
          'Propriétés :\n'
          '• pgcd(a, b) = pgcd(b, a) (symétrie)\n'
          '• pgcd(ka, kb) = k × pgcd(a, b) (homogénéité)\n'
          '• pgcd(a, b) × ppcm(a, b) = a × b\n\n'
          'Théorème de Bézout : il existe des entiers u et v tels que :\n'
          'au + bv = pgcd(a, b).\n'
          'En particulier, a et b sont premiers entre eux (pgcd = 1) '
          'si et seulement s\'il existe u, v tels que au + bv = 1.\n\n'
          'PPCM : le plus petit entier positif multiple commun à a et b.\n'
          'ppcm(a, b) = (a × b) / pgcd(a, b).\n\n'
          'Algorithme d\'Euclide étendu : permet de calculer les coefficients u et v de Bézout.',
      example:
          'Exemple 1 — Algorithme d\'Euclide :\n'
          'pgcd(252, 105) :\n'
          '252 = 105 × 2 + 42\n'
          '105 = 42 × 2 + 21\n'
          '42 = 21 × 2 + 0\n'
          'pgcd(252, 105) = 21.\n\n'
          'Exemple 2 — Bézout :\n'
          'On a pgcd(252, 105) = 21.\n'
          'En remontant : 21 = 105 - 42 × 2\n'
          '42 = 252 - 105 × 2\n'
          'Donc 21 = 105 - 2(252 - 105×2) = 5×105 - 2×252.\n'
          'Soit u = -2, v = 5.\n\n'
          'Exemple 3 — PPCM :\n'
          'ppcm(252, 105) = (252 × 105) / 21 = 26460 / 21 = 1260.',
      takeaways: [
        'Algorithme d\'Euclide pour le PGCD',
        'pgcd(a,b) × ppcm(a,b) = a × b',
        'Bézout : ∃ u,v : au + bv = pgcd(a,b)',
        'a et b premiers entre eux ⇔ pgcd = 1',
      ],
    ),
    'maths_ch10_l3': const LessonContent(
      introText:
          'Les congruences généralisent la notion de reste de division et permettent '
          'de travailler sur les classes d\'équivalence modulo n. Elles sont essentielles '
          'en cryptographie et pour résoudre des équations diophantiennes.',
      lessonBody:
          'On dit que a est congru à b modulo n (n ≥ 2) si n divise (a - b).\n'
          'Notation : a ≡ b (mod n).\n\n'
          'Propriétés :\n'
          '• a ≡ a (mod n) (réflexivité)\n'
          '• Si a ≡ b (mod n) alors b ≡ a (mod n) (symétrie)\n'
          '• Si a ≡ b (mod n) et b ≡ c (mod n) alors a ≡ c (mod n) (transitivité)\n\n'
          'Opérations :\n'
          '• Si a ≡ b (mod n) et c ≡ d (mod n), alors :\n'
          '  - a + c ≡ b + d (mod n)\n'
          '  - a - c ≡ b - d (mod n)\n'
          '  - a × c ≡ b × d (mod n)\n'
          '  - a^k ≡ b^k (mod n)\n\n'
          'Attention : on ne peut pas toujours diviser. a × x ≡ a × y (mod n) '
          'n\'implique x ≡ y (mod n) que si pgcd(a, n) = 1.\n\n'
          'Classes modulo n : ℤ/nℤ = {0, 1, 2, ..., n-1}.\n'
          'Chaque classe contient tous les entiers ayant le même reste modulo n.\n\n'
          'Équation diophantienne : ax + by = c.\n'
          'Solutions si et seulement si pgcd(a, b) | c.\n\n'
          'Petit théorème de Fermat : si p est premier et a non divisible par p, '
          'alors a^{p-1} ≡ 1 (mod p).\n\n'
          'Application : calcul de restes de puissances et cryptographie RSA.',
      example:
          'Exemple 1 — Congruence :\n'
          '17 ≡ 5 (mod 12) car 17 - 5 = 12.\n'
          '3 × 5 ≡ 3 (mod 12) car 15 - 3 = 12.\n\n'
          'Exemple 2 — Résolution :\n'
          'Résoudre 3x ≡ 4 (mod 7).\n'
          'pgcd(3, 7) = 1, donc on peut inverser 3 modulo 7.\n'
          '3 × 5 = 15 ≡ 1 (mod 7), donc l\'inverse de 3 est 5.\n'
          'x ≡ 5 × 4 ≡ 20 ≡ 6 (mod 7).\n\n'
          'Exemple 3 — Fermat :\n'
          'Calculer 2^{100} mod 7.\n'
          '7 est premier, donc 2⁶ ≡ 1 (mod 7) (Fermat).\n'
          '2^{100} = 2^{6×16 + 4} = (2⁶)^{16} × 2⁴ ≡ 1^{16} × 16 ≡ 16 ≡ 2 (mod 7).',
      takeaways: [
        'a ≡ b (mod n) ⇔ n | (a-b)',
        'Congruences compatibles avec +, -, ×, puissance',
        'Inverse modulo n : ax ≡ 1 (mod n) si pgcd(a,n)=1',
        'Fermat : a^{p-1} ≡ 1 (mod p) si p premier',
      ],
    ),
  };

  // ===========================================================================
  // PHYSIQUE — Chapitre 2 : Dynamique newtonienne
  // ===========================================================================

  static final Map<String, LessonContent> _physiqueCh2 = {
    'physique_ch2_l1': const LessonContent(
      introText:
          'Les trois lois de Newton constituent le fondement de la mécanique classique. '
          'Elles décrivent comment les forces agissent sur les corps et comment ces corps réagissent '
          'aux forces. Maîtriser ces lois permet d\'analyser et de prédire le mouvement de tout objet.',
      lessonBody:
          'La première loi de Newton, dite loi d\'inertie, énonce qu\'un corps libre (non soumis à des forces) '
          'ou soumis à des forces équilibrées reste au repos ou en mouvement rectiligne uniforme (MRU). '
          'En d\'autres termes, un corps conserve son état de repos ou de mouvement uniforme tant qu\'une '
          'force nette ne s\'exerce pas sur lui. Cette loi introduit la notion de référentiel inertiel : '
          'un référentiel dans lequel la loi d\'inertie est vérifiée.\n\n'
          'La deuxième loi de Newton, dite loi fondamentale de la dynamique, établit que la somme vectorielle '
          'des forces extérieures appliquées à un corps est égale au produit de sa masse par son accélération : '
          'ΣF⃗ = m × a⃗. Cette équation vectorielle relie la cause du mouvement (la force resultant) à son '
          'effet (l\'accélération). La masse m est une grandeur scalaire positive qui caractérise l\'inertie '
          'du corps : plus la masse est grande, plus le corps résiste aux changements de mouvement. Les unités '
          'du Système International sont le newton (N) pour la force, le kilogramme (kg) pour la masse, et '
          'le mètre par seconde carré (m/s²) pour l\'accélération. On a 1 N = 1 kg × 1 m/s².\n\n'
          'La troisième loi de Newton, dite loi d\'action-réaction, énonce que si un corps A exerce une force '
          'sur un corps B (action), alors le corps B exerce sur le corps A une force de même intensité, de '
          'direction opposée et de même ligne d\'action (réaction). Mathématiquement : F⃗_{A sur B} = -F⃗_{B sur A}. '
          'Ces deux forces s\'exercent sur des corps différents et ne se compensent jamais car elles n\'agissent '
          'pas sur le même corps. Cette loi explique les mouvements de propulsion (fusée, nageur) et les '
          'forces de contact.\n\n'
          'Applications : le calcul du poids d\'un objet P⃗ = mg⃗ utilise la deuxième loi avec a⃗ = g⃗ (champ '
          'de pesanteur). La tension dans une corde, les frottements, les réactions de support sont toutes '
          'des forces que l\'on identifie en appliquant le schéma du corps isolé (diagramme de corps libre).',
      example:
          'Exemple 1 — Loi d\'inertie :\n'
          'Un bloc glisse sur une surface sans frottement avec une vitesse de 3 m/s. Aucune force nette '
          'ne s\'exerce horizontalement. Par la loi d\'inertie, le bloc continue en MRU à 3 m/s indéfiniment.\n\n'
          'Exemple 2 — Deuxième loi :\n'
          'Un bloc de 5 kg est poussé par une force de 20 N sur une surface sans frottement.\n'
          'a = F/m = 20/5 = 4 m/s².\n'
          'Vitesse après 3 secondes : v = v₀ + at = 0 + 4 × 3 = 12 m/s.\n'
          'Position : x = ½at² = ½ × 4 × 9 = 18 m.\n\n'
          'Exemple 3 — Action-réaction :\n'
          'Un skateur (80 kg) pousse un mur avec une force de 100 N.\n'
          'Le mur exerce une force de 100 N en sens opposé sur le skateur.\n'
          'Accélération du skateur : a = F/m = 100/80 = 1,25 m/s².',
      takeaways: [
        '1ère loi (inertie) : sans force nette, MRU ou repos',
        '2ème loi : ΣF = m × a (loi fondamentale de la dynamique)',
        '3ème loi : action et réaction sont égales et opposées',
        'Forces d\'action-réaction s\'exercent sur des corps différents',
        '1 N = 1 kg × 1 m/s²',
      ],
    ),
    'physique_ch2_l2': const LessonContent(
      introText:
          'La force gravitationnelle est l\'une des forces fondamentales de la nature. Elle explique '
          'la chute des corps, le poids et le mouvement des astres. La loi de Newton de l\'attraction '
          'universelle relie la force gravitationnelle à la masse et à la distance entre deux corps.',
      lessonBody:
          'Le poids est la force gravitationnelle exercée par la Terre sur un objet situé à sa surface. '
          'On note P⃗ = mg⃗, où m est la masse de l\'objet (en kg) et g⃗ le champ de pesanteur terrestre. '
          'La norme du poids est P = mg, avec g ≈ 9,81 m/s² à la surface de la Terre. Le poids est exprimé '
          'en newtons (N). À ne pas confondre masse (propriété intrinsèque, en kg) et poids (force, en N).\n\n'
          'La loi universelle de la gravitation de Newton (1687) énonce que tout corps massif attire tout '
          'autre corps massif avec une force dirigée le long de la ligne joignant les centres de masse. '
          'La grandeur de cette force est : F = G × (m₁ × m₂) / r², où G ≈ 6,674 × 10⁻¹¹ N·m²/kg² est '
          'la constante gravitationnelle universelle, m₁ et m₂ sont les masses des deux corps, et r est la '
          'distance entre leurs centres de masse. La force est toujours attractive.\n\n'
          'Le champ de pesanteur g⃗ est défini comme la force gravitationnelle par unité de masse : g⃗ = F⃗/m. '
          'À la surface de la Terre, g ≈ 9,81 m/s², mais cette valeur varie légèrement avec l\'altitude, '
          'la latitude et la densité du sous-sol. Sur la Lune, g_L ≈ 1,62 m/s² (environ 6 fois plus faible).\n\n'
          'L\'énergie potentielle de pesanteur dans le champ uniforme de la Terre est Ep = mgh, où h est la '
          'hauteur par rapport à un niveau de référence. Cette énergie augmente quand l\'objet monte et '
          'diminue quand il descend. Elle est convertie en énergie cinétique lors de la chute libre.',
      example:
          'Exemple 1 — Poids :\n'
          'Masse d\'un corps : m = 70 kg.\n'
          'Poids : P = mg = 70 × 9,81 = 686,7 N.\n\n'
          'Exemple 2 — Force gravitationnelle :\n'
          'Deux sphères de 100 kg chacune, séparées par 0,5 m.\n'
          'F = G × m₁m₂/r² = 6,674 × 10⁻¹¹ × (100 × 100) / 0,5²\n'
          'F = 6,674 × 10⁻¹¹ × 10⁴ / 0,25 = 2,67 × 10⁻⁶ N.\n'
          'Force très faible (confirmation : la gravitation est une force faible).\n\n'
          'Exemple 3 — Énergie potentielle :\n'
          'Un sac de 10 kg est placé à 3 m de hauteur.\n'
          'Ep = mgh = 10 × 9,81 × 3 = 294,3 J.\n'
          'En tombant, cette énergie se convertit en énergie cinétique : Ec = 294,3 J.',
      takeaways: [
        'Poids : P = mg (force en N, pas en kg)',
        'Loi de Newton : F = G m₁m₂/r² (attraction universelle)',
        'Champ de pesanteur : g ≈ 9,81 m/s² sur Terre',
        'Énergie potentielle : Ep = mgh',
        'Masse ≠ poids : masse en kg, poids en N',
      ],
    ),
    'physique_ch2_l3': const LessonContent(
      introText:
          'Le travail d\'une force et les différentes formes d\'énergie permettent de quantifier les '
          'échanges énergétiques dans un système mécanique. Le principe de conservation de l\'énergie '
          'mécanique est l\'un des outils les plus puissants en physique.',
      lessonBody:
          'Le travail d\'une force constante F⃗ lors du déplacement d\'un point matériel de A à B est : '
          'T = F⃗ · AB⃗ = F × d × cos θ, où F est l\'intensité de la force, d la longueur du déplacement '
          '(distance AB) et θ l\'angle entre la direction de la force et celle du déplacement. Le travail '
          'est un scalaire qui peut être positif (la force aide le mouvement), nul (force perpendiculaire '
          'au déplacement) ou négatif (la force s\'oppose au mouvement). Son unité est le joule (J) : '
          '1 J = 1 N × 1 m.\n\n'
          'L\'énergie cinétique caractérise le mouvement d\'un corps : Ec = ½mv², où m est la masse et v '
          'la vitesse. Elle est toujours positive ou nulle. Le théorème de l\'énergie cinétique établit que '
          'le travail de la force résultante est égal à la variation d\'énergie cinétique : '
          'T_{A→B} = ½mv_B² - ½mv_A² = ΔEc.\n\n'
          'L\'énergie potentielle de pesanteur est Ep = mgh. Elle ne dépend que de la hauteur h par rapport '
          'à un niveau de référence choisi. Le travail de la pesanteur est lié à la variation d\'énergie '
          'potentielle : T_{pes} = -ΔEp = -(mgh_B - mgh_A).\n\n'
          'L\'énergie mécanique est la somme de l\'énergie cinétique et de l\'énergie potentielle : '
          'Em = Ec + Ep = ½mv² + mgh. Le principe de conservation de l\'énergie mécanique énonce que si '
          'seules les forces conservatrices (comme la pesanteur) travaillent, alors Em est conservée : '
          '½mv_A² + mgh_A = ½mv_B² + mgh_B. Ce principe est extrêmement puissant car il permet de relier '
          'les vitesses et les hauteurs sans connaître le détail de la trajectoire.',
      example:
          'Exemple 1 — Travail d\'une force :\n'
          'Une force de 50 N tire un coffre de 25 kg sur 10 m à angle de 30°.\n'
          'T = F × d × cos θ = 50 × 10 × cos 30° = 500 × 0,866 = 433 J.\n\n'
          'Exemple 2 — Théorème de l\'énergie cinétique :\n'
          'Un bloc de 2 kg part du repos et est poussé par 100 J de travail.\n'
          'T = ΔEc = ½mv² - 0\n'
          '100 = ½ × 2 × v² = v²\n'
          'v = √100 = 10 m/s.\n\n'
          'Exemple 3 — Conservation de l\'énergie mécanique :\n'
          'Un objet est lâché du repos à hauteur h = 5 m (sans frottements).\n'
          'En haut : Em = mgh = m × 9,81 × 5 = 49,05m J (Ec = 0).\n'
          'Au sol (h = 0) : Em = ½mv² = 49,05m.\n'
          '½v² = 49,05 → v = √(2 × 9,81 × 5) = √98,1 ≈ 9,90 m/s.',
      takeaways: [
        'Travail : T = F × d × cos θ (en joules)',
        'Énergie cinétique : Ec = ½mv²',
        'Énergie potentielle : Ep = mgh',
        'Théorème : T_{résultante} = ΔEc',
        'Conservation : Em = Ec + Ep = constante (sans frottements)',
      ],
    ),
  };

  // ===========================================================================
  // PHYSIQUE — Chapitre 3 : Électricité : Courant continu
  // ===========================================================================

  static final Map<String, LessonContent> _physiqueCh3 = {
    'physique_ch3_l1': const LessonContent(
      introText:
          'La loi d\'Ohm est la relation fondamentale qui lie tension, courant et résistance dans un '
          'circuit électrique. Elle permet d\'analyser les dipôles électriques et de calculer les grandeurs '
          'dans les circuits en courant continu.',
      lessonBody:
          'Un dipôle électrique est un élément de circuit comportant deux bornes. On définit trois grandeurs '
          'caractéristiques : la tension U (en volts, V), le courant I (en ampères, A) et la résistance R '
          '(en ohms, Ω). Le sens conventionnel du courant va du potentiel positif vers le potentiel négatif.\n\n'
          'La loi d\'Ohm pour un dipôle ohmique (résistance pure) s\'écrit : U = R × I. Un dipôle est dit '
          'ohmique si sa caractéristique (courbe U = f(I)) est une droite passant par l\'origine. La pente '
          'de cette droite est la résistance R. Les résistances sont des dipôles ohmiques. L\'unité de '
          'résistance est l\'ohm (Ω) : 1 Ω = 1 V/A.\n\n'
          'La loi d\'Ohm généralisée pour tout dipôle (ohmique ou non) s\'écrit : U_AB = R × I + ε, '
          'où ε est la force électromotrice (f.é.m.) du dipôle s\'il est source. Pour un récepteur '
          '(consommateur), ε = 0 et U = R × I. Pour une source (générateur), ε > 0 et U = ε - R × I '
          '(la tension aux bornes est inférieure à la f.é.m. à cause de la chute de tension interne).\n\n'
          'La puissance électrique est P = U × I (en watts, W). Pour un récepteur ohmique : '
          'P = R × I² = U²/R. L\'énergie électrique consommée est W = P × t = U × I × t (en joules '
          'ou en watt-heures Wh : 1 Wh = 3600 J). La loi de Joule précise que la puissance dissipée '
          'sous forme de chaleur dans un conducteur est P = R × I².',
      example:
          'Exemple 1 — Loi d\'Ohm :\n'
          'Une résistance de 10 Ω est parcourue par un courant de 0,5 A.\n'
          'Tension : U = R × I = 10 × 0,5 = 5 V.\n\n'
          'Exemple 2 — Puissance :\n'
          'Un radiateur de 2 000 W est alimenté en 230 V.\n'
          'Courant : I = P/U = 2000/230 ≈ 8,70 A.\n'
          'Résistance : R = U/I = 230/8,70 ≈ 26,4 Ω.\n\n'
          'Exemple 3 — Source avec résistance interne :\n'
          'Une pile de f.é.m. ε = 9 V avec résistance interne r = 1 Ω alimente une résistance R = 17 Ω.\n'
          'Courant : I = ε/(R + r) = 9/(17 + 1) = 0,5 A.\n'
          'Tension aux bornes de R : U = R × I = 17 × 0,5 = 8,5 V.\n'
          'Vérification : U = ε - r × I = 9 - 0,5 = 8,5 V. ✓',
      takeaways: [
        'Loi d\'Ohm : U = R × I (dipôle ohmique)',
        'Source : U = ε - R × I ; Récepteur : U = R × I',
        'Puissance : P = U × I = R × I² = U²/R',
        'Énergie : W = U × I × t (en joules)',
        'F.é.m. ε est la tension maximale d\'une source à vide',
      ],
    ),
    'physique_ch3_l2': const LessonContent(
      introText:
          'L\'analyse des circuits électriques en courant continu repose sur deux règles fondamentales : '
          'la loi des nœuds (Kirchhoff) et la loi des mailles. Ces règles permettent de résoudre n\'importe '
          'quel circuit, même complexe.',
      lessonBody:
          'La loi des nœuds (première loi de Kirchhoff) énonce qu\'en tout point de branching (nœud) d\'un '
          'circuit, la somme algébrique des courants entrants est égale à la somme des courants sortants. '
          'Autrement dit : ΣI_entrantes = ΣI_sortantes, ou ΣI = 0 en convention de signe. Cette loi découle '
          'de la conservation de la charge électrique : la charge ne s\'accumule pas aux nœuds.\n\n'
          'La loi des mailles (deuxième loi de Kirchhoff) énonce que dans toute boucle fermée (maille) '
          'd\'un circuit, la somme algébrique des tensions est nulle : ΣU = 0 en parcourant la boucle dans '
          'un sens donné. On compte les tensions des sources (positives si on parcourt de - à +) et celles '
          'des résistances (négatives si le courant est dans le sens de parcours, selon la convention : '
          'U = RI quand on suit le courant). Cette loi découle de la conservation de l\'énergie.\n\n'
          'Conventions de signe : on choisit un sens de parcours de la maille. Pour une source, on met ε '
          'positif si on traverse de - à +. Pour une résistance R parcourue par un courant I dans le sens '
          'de parcours, on met -RI. Si le courant est en sens opposé, on met +RI.\n\n'
          'Méthode de résolution : 1) On repère les nœuds et les mailles. 2) On affecte des directions '
          'arbitraires aux courants inconnus. 3) On écrit les équations de la loi des nœuds (il y a N-1 '
          'équations indépendantes pour N nœuds) et de la loi des mailles (M équations pour M mailles '
          'indépendantes). 4) On résout le système d\'équations linéaires.',
      example:
          'Exemple — Circuit à deux sources :\n'
          'Deux piles ε₁ = 12 V (r₁ = 1 Ω) et ε₂ = 6 V (r₂ = 1 Ω) sont opposées, '
          'avec une résistance R = 4 Ω.\n\n'
          'Convention : courant I dans le sens de ε₁.\n'
          'Loi des mailles (boucle) : +ε₁ - R × I - r₁ × I - ε₂ - r₂ × I = 0\n'
          '12 - 4I - I - 6 - I = 0\n'
          '12 - 6 = 6I → 6 = 6I → I = 1 A.\n\n'
          'Tensions :\n'
          'U_R = R × I = 4 × 1 = 4 V.\n'
          'U ε₁ = ε₁ - r₁ × I = 12 - 1 = 11 V (source débitée).\n'
          'U ε₂ = ε₂ + r₂ × I = 6 + 1 = 7 V (source chargée).',
      takeaways: [
        'Loi des nœuds : ΣI_entrantes = ΣI_sortantes (conservation de charge)',
        'Loi des mailles : ΣU = 0 dans toute boucle (conservation d\'énergie)',
        'Convention de signe : ε positive si on traverse de - à +',
        'N nœuds → N-1 équations indépendantes',
        'Résoudre le système pour trouver les courants inconnus',
      ],
    ),
    'physique_ch3_l3': const LessonContent(
      introText:
          'Le pont de Wheatstone est un circuit électrique très utilisé pour mesurer une résistance '
          'inconnue avec une grande précision. Il utilise un galvanomètre et un système de pont '
          'pour détecter l\'égalité de potentiel entre deux points.',
      lessonBody:
          'Le pont de Wheatstone est constitué de quatre résistances R₁, R₂, R₃ et R₄ disposées '
          'en losange. Une source de tension U alimente le pont, et un galvanomètre G est relié '
          'entre les deux points milieu du losange (points B et D).\n\n'
          'Le pont est dit équilibré quand aucun courant ne traverse le galvanomètre (I_G = 0). '
          'Cela signifie que les potentiels aux points B et D sont égaux : V_B = V_D. Dans ce cas, '
          'on a la relation fondamentale : R₁/R₂ = R₃/R₄, soit R₁ × R₄ = R₂ × R₃.\n\n'
          'Principe de fonctionnement : on connaît trois résistances et on cherche la quatrième '
          '(la résistance inconnue Rx). On ajuste une résistance variable (rhéostat) jusqu\'à ce que '
          'le galvanomètre indique zéro (courant nul). À l\'équilibre, on déduit Rx par la formule '
          'de pont : par exemple, si R₁ = Rx (inconnue), R₂ = résistance de référence, R₃ et R₄ '
          'sont des résistances connues, alors Rx = R₂ × R₃/R₄.\n\n'
          'Pont diviseur de tension : les deux branches parallèles R₁-R₂ et R₃-R₄ forment des '
          'diviseurs de tension. Le potentiel en B est V_B = U × R₂/(R₁+R₂) et celui en D est '
          'V_D = U × R₄/(R₃+R₄). Le pont est équilibré quand V_B = V_D.\n\n'
          'Sensibilité du pont : la sensibilité est maximale quand les quatre résistances sont '
          'du même ordre de grandeur. En pratique, on utilise des résistances de précision pour '
          'obtenir des mesures très précises (jusqu\'au millième).',
      example:
          'Exemple — Mesure par pont de Wheatstone :\n'
          'On cherche Rx. On dispose : R₂ = 200 Ω, R₃ = 100 Ω, R₄ = 400 Ω.\n'
          'On ajuste jusqu\'à l\'équilibre du galvanomètre.\n\n'
          'Formule de pont : Rx/R₂ = R₃/R₄\n'
          'Rx = R₂ × R₃/R₄ = 200 × 100/400 = 50 Ω.\n\n'
          'Vérification par les potentiels :\n'
          'U = 12 V (source).\n'
          'V_B = U × R₂/(Rx + R₂) = 12 × 200/(50 + 200) = 12 × 200/250 = 9,6 V.\n'
          'V_D = U × R₄/(R₃ + R₄) = 12 × 400/(100 + 400) = 12 × 400/500 = 9,6 V.\n'
          'V_B = V_D = 9,6 V → pont équilibré. ✓',
      takeaways: [
        'Pont de Wheatstone : 4 résistances en losange + galvanomètre',
        'Pont équilibré : I_G = 0, donc R₁/R₂ = R₃/R₄',
        'Permet de mesurer une résistance inconnue avec précision',
        'Sensibilité maximale quand les résistances sont du même ordre',
        'Application : mesure de résistance, capteurs, balance de Wheatstone',
      ],
    ),
  };

  // ===========================================================================
  // PHYSIQUE — Chapitre 4 : Électrocinétique : Régimes transitoires
  // ===========================================================================

  static final Map<String, LessonContent> _physiqueCh4 = {
    'physique_ch4_l1': const LessonContent(
      introText:
          'La charge et la décharge d\'un condensateur dans un circuit RC illustrent le régime transitoire '
          'en électrocinétique. Le condensateur stocke l\'énergie électrique sous forme de champ électrique '
          'et sa charge varie exponentiellement avec le temps.',
      lessonBody:
          'Un condensateur est constitué de deux armatures conductrices séparées par un diélectrique. '
          'Sa capacité C (en farads, F) est définie par C = Q/U, où Q est la charge (en coulombs, C) '
          'et U la tension aux bornes (en volts, V). Un condensateur non chargé se comporte comme un '
          'court-circuit au moment de la connexion (U = 0, Q = 0), puis s\'oppose progressivement '
          'au passage du courant à mesure qu\'il se charge.\n\n'
          'Circuit de charge : une source de tension E, une résistance R et un condensateur C en série. '
          'Au moment t = 0, on ferme l\'interrupteur. La charge q(t) sur le condensateur évolue selon : '
          'q(t) = Q_max(1 - e^{-t/RC}), où Q_max = C × E. La tension aux bornes du condensateur est : '
          'u_C(t) = E(1 - e^{-t/RC}). Le courant dans le circuit est : i(t) = (E/R) × e^{-t/RC}.\n\n'
          'La constante de temps τ = RC (en secondes) caractérise la rapidité de charge. Après un temps τ, '
          'le condensateur est chargé à 63,2% de sa valeur finale. Après 5τ, il est considéré comme '
          'entièrement chargé (>99,3%). Cette constante de temps dépend uniquement de R et C.\n\n'
          'Circuit de décharge : le condensateur chargé (tension U₀) se décharge à travers une résistance R. '
          'La charge décroît selon : q(t) = Q₀ × e^{-t/RC}. La tension : u_C(t) = U₀ × e^{-t/RC}. '
          'Le courant de décharge : i(t) = -(U₀/R) × e^{-t/RC} (le signe négatif indique que le courant '
          'est dans le sens opposé à celui de charge). L\'énergie stockée dans le condensateur est '
          'W = ½CU² = ½Q²/C = ½QU.',
      example:
          'Exemple — Charge d\'un condensateur :\n'
          'R = 10 kΩ = 10⁴ Ω, C = 100 μF = 10⁻⁴ F, E = 12 V.\n\n'
          'Constante de temps : τ = RC = 10⁴ × 10⁻⁴ = 1 s.\n'
          'Charge maximale : Q_max = CE = 10⁻⁴ × 12 = 1,2 × 10⁻³ C = 1,2 mC.\n\n'
          'Après t = 1 s (1τ) :\n'
          'u_C = 12(1 - e⁻¹) = 12 × 0,632 = 7,58 V.\n'
          'i = (12/10⁴) × e⁻¹ = 1,2 × 10⁻³ × 0,368 = 0,442 mA.\n\n'
          'Après t = 3 s (3τ) :\n'
          'u_C = 12(1 - e⁻³) = 12 × 0,950 = 11,40 V.\n\n'
          'Après t = 5 s (5τ) : considéré chargé completamente.\n'
          'u_C ≈ 12 V, i ≈ 0 A.',
      takeaways: [
        'τ = RC = constante de temps (en secondes)',
        'Charge : u_C = E(1 - e^{-t/τ}), i = (E/R)e^{-t/τ}',
        'Décharge : u_C = U₀e^{-t/τ}',
        'Après 5τ, le condensateur est considéré comme chargé/déchargé',
        'Énergie stockée : W = ½CU²',
      ],
    ),
    'physique_ch4_l2': const LessonContent(
      introText:
          'La bobine (inducteur) s\'oppose aux variations de courant dans un circuit. L\'établissement '
          'du courant dans un circuit RL (résistance-inducteur) est un régime transitoire caractérisé '
          'par une croissance exponentielle du courant vers sa valeur limite.',
      lessonBody:
          'Une bobine est un composant constitué d\'un enroulement de fil conducteur, caractérisée par '
          'son inductance L (en henrys, H). La bobine s\'oppose aux variations de courant grâce à la '
          'force contre-électromotrice (f.c.é.m.) qu\'elle génère : ε_L = -L × (dI/dt). Cette f.c.é.m. '
          's\'oppose à la variation de courant (loi de Lenz).\n\n'
          'Circuit RL : une source de tension E, une résistance R et une bobine d\'inductance L en série. '
          'Quand on ferme l\'interrupteur à t = 0, le courant croît progressivement de 0 vers sa valeur '
          'limite I_max = E/R. L\'évolution du courant est : i(t) = (E/R)(1 - e^{-t/τ}), où τ = L/R '
          'est la constante de temps du circuit RL (en secondes).\n\n'
          'La tension aux bornes de la bobine est : u_L(t) = L × (di/dt) = E × e^{-t/τ}. Au moment '
          't = 0, la bobine s\'oppose totalement au courant (u_L = E, comme un circuit ouvert). À t → ∞, '
          'la bobine se comporte comme un fil (u_L = 0). La tension aux bornes de la résistance est '
          'u_R(t) = R × i(t) = E(1 - e^{-t/τ}).\n\n'
          'Constante de temps τ = L/R : après un temps τ, le courant atteint 63,2% de sa valeur finale. '
          'Après 5τ, le courant est considéré comme établi (>99,3%). Plus L est grande ou R petite, '
          'plus le courant met de temps à s\'établir.\n\n'
          'Énergie magnétique stockée dans la bobine : W = ½LI² (en joules). Cette énergie est stockée '
          'sous forme de champ magnétique dans la bobine. Lors de la coupure du circuit, l\'énergie '
          'magnétique peut provoquer une étincelle (surtension) car la bobine cherche à maintenir le courant.',
      example:
          'Exemple — Établissement du courant :\n'
          'L = 0,5 H, R = 100 Ω, E = 50 V.\n\n'
          'Constante de temps : τ = L/R = 0,5/100 = 5 × 10⁻³ s = 5 ms.\n'
          'Courant maximal : I_max = E/R = 50/100 = 0,5 A.\n\n'
          'Après t = 5 ms (1τ) :\n'
          'i = 0,5 × (1 - e⁻¹) = 0,5 × 0,632 = 0,316 A.\n'
          'u_L = 50 × e⁻¹ = 50 × 0,368 = 18,4 V.\n\n'
          'Après t = 15 ms (3τ) :\n'
          'i = 0,5 × (1 - e⁻³) = 0,5 × 0,950 = 0,475 A.\n\n'
          'Énergie magnétique à I = 0,5 A :\n'
          'W = ½LI² = ½ × 0,5 × 0,25 = 0,0625 J = 62,5 mJ.',
      takeaways: [
        'Constante de temps τ = L/R (en secondes)',
        'Courant : i = (E/R)(1 - e^{-t/τ})',
        'Tension bobine : u_L = E × e^{-t/τ} (décroissante)',
        'Après 5τ, le courant est considéré établi',
        'Énergie magnétique : W = ½LI²',
      ],
    ),
    'physique_ch4_l3': const LessonContent(
      introText:
          'Le circuit RLC comporte une résistance, une bobine et un condensateur. Il peut présenter '
          'des oscillations électriques amorties, comparables aux oscillations d\'un pendule avec frottements. '
          'C\'est le modèle de base des circuits résonants.',
      lessonBody:
          'Un circuit RLC série comprend une résistance R, une bobine d\'inductance L et un condensateur '
          'de capacité C reliés en série avec une source de f.é.m. ε. L\'équation différentielle du circuit '
          'est : L × d²q/dt² + R × dq/dt + q/C = ε(t), où q est la charge du condensateur.\n\n'
          'Régime libre (ε = 0, circuit déchargé à t = 0) : les oscillations dépendent du rapport entre '
          'la résistance et les paramètres L et C. On définit la pulsation propre non amortie : '
          'ω₀ = 1/√(LC) (en rad/s). La fréquence propre est f₀ = 1/(2π√(LC)) (en hertz).\n\n'
          'Le coefficient d\'amortissement est α = R/(2L). On distingue trois cas :\n'
          '1) Sous-amorti (R petit) : α < ω₀, soit R < 2√(L/C). Le courant oscille avec une amplitude '
          'décroissante exponentiellement : i(t) = I₀ × e^{-αt} × cos(ωt + φ), où ω = √(ω₀² - α²).\n'
          '2) Critique (R intermédiaire) : α = ω₀, soit R = 2√(L/C). Pas d\'oscillation, retour le plus '
          'rapide à l\'équilibre.\n'
          '3) Suramorti (R grand) : α > ω₀, soit R > 2√(L/C). Retour lent à l\'équilibre sans oscillation.\n\n'
          'Période d\'oscillation : T = 2π/ω ≈ 2π√(LC) pour un faible amortissement. L\'énergie '
          'oscille entre le champ magnétique de la bobine (W_L = ½LI²) et le champ électrique du '
          'condensateur (W_C = ½q²/C), la résistance dissipant de l\'énergie sous forme de chaleur.',
      example:
          'Exemple — Circuit RLC amorti :\n'
          'L = 10 mH = 10⁻² H, C = 100 μF = 10⁻⁴ F, R = 20 Ω.\n\n'
          'Pulsation propre : ω₀ = 1/√(LC) = 1/√(10⁻² × 10⁻⁴) = 1/√10⁻⁶ = 1000 rad/s.\n'
          'Fréquence : f₀ = ω₀/(2π) = 1000/6,28 ≈ 159 Hz.\n\n'
          'Coefficient d\'amortissement : α = R/(2L) = 20/(2 × 10⁻²) = 1000 rad/s.\n'
          'Condition critique : 2√(L/C) = 2√(10⁻²/10⁻⁴) = 2√100 = 20 Ω.\n\n'
          'Ici R = 20 Ω = 2√(L/C) : on est au cas critique !\n'
          'Le circuit retourne à l\'équilibre sans osciller.\n\n'
          'Si R = 5 Ω (sous-amorti) :\n'
          'α = 5/(2 × 10⁻²) = 250 rad/s.\n'
          'ω = √(ω₀² - α²) = √(10⁶ - 62500) = √937500 ≈ 968 rad/s.\n'
          'La période d\'oscillation amortie : T = 2π/968 ≈ 6,49 ms.',
      takeaways: [
        'ω₀ = 1/√(LC) : pulsation propre ; f₀ = 1/(2π√(LC))',
        'α = R/(2L) : coefficient d\'amortissement',
        'Sous-amorti : R < 2√(L/C) → oscillations amorties',
        'Critique : R = 2√(L/C) → pas d\'oscillation, retour rapide',
        'Énergie oscille entre champ magnétique (L) et électrique (C)',
      ],
    ),
  };

  // ===========================================================================
  // PHYSIQUE — Chapitre 5 : Ondes mécaniques
  // ===========================================================================

  static final Map<String, LessonContent> _physiqueCh5 = {
    'physique_ch5_l1': const LessonContent(
      introText:
          'Les ondes progressives périodiques transportent de l\'énergie sans transport de matière. '
          'Elles se propagent dans un milieu avec une célérité caractéristique et sont décrites par '
          'leur longueur d\'onde, leur fréquence et leur période.',
      lessonBody:
          'Une onde progressive périodique est une perturbation qui se propage dans un milieu avec une '
          'vitesse constante (la célérité) tout en conservant sa forme. L\'oscillation des points du milieu '
          'se fait autour d\'une position d\'équilibre, perpendiculairement à la direction de propagation '
          '(onde transversale) ou parallèlement (onde longitudinale).\n\n'
          'Les grandeurs caractéristiques d\'une onde sont :\n'
          '- La période T (en secondes) : temps nécessaire pour une oscillation complète.\n'
          '- La fréquence f = 1/T (en hertz, Hz) : nombre d\'oscillations par seconde.\n'
          '- La pulsation ω = 2πf = 2π/T (en rad/s).\n'
          '- La longueur d\'onde λ (en mètres) : distance parcourue par l\'onde pendant une période.\n'
          '- La célérité v = λ × f = λ/T (en m/s) : vitesse de propagation de l\'onde.\n\n'
          'La relation fondamentale est v = λf. Cette relation montre que pour une célérité donnée, '
          'la fréquence et la longueur d\'onde sont inversement proportionnelles. La célérité dépend '
          'du milieu (v = 340 m/s dans l\'air pour le son, v = 1500 m/s dans l\'eau, v = 3 × 10⁸ m/s '
          'dans le vide pour la lumière).\n\n'
          'L\'équation d\'une onde progressive sinusoïdale se propageant dans le sens positif de Ox est : '
          'y(x, t) = A × sin(ωt - kx + φ₀), où A est l\'amplitude (en m), k = 2π/λ le nombre d\'onde '
          '(en rad/m), φ₀ la phase initiale. La quantité (ωt - kx + φ₀) est la phase de l\'onde.\n\n'
          'Le principe de superposition énonce que lorsque deux ondes de même nature se rencontrent, '
          'la perturbation résultante est la somme algébrique des perturbations individuelles. Ce principe '
          'explique les phénomènes d\'interférence et de diffraction.',
      example:
          'Exemple 1 — Relation v = λf :\n'
          'Une onde sonore de fréquence 440 Hz (la note la) se propage dans l\'air à 340 m/s.\n'
          'Longueur d\'onde : λ = v/f = 340/440 ≈ 0,773 m ≈ 77,3 cm.\n\n'
          'Exemple 2 — Équation d\'onde :\n'
          'y(x,t) = 0,02 × sin(100πt - 2πx) (en mètres).\n'
          'Amplitude : A = 0,02 m = 2 cm.\n'
          'Pulsation : ω = 100π rad/s → f = ω/(2π) = 50 Hz.\n'
          'Nombre d\'onde : k = 2π rad/m → λ = 2π/k = 1 m.\n'
          'Célérité : v = λf = 1 × 50 = 50 m/s.\n\n'
          'Exemple 3 — Période :\n'
          'Une onde de fréquence f = 100 Hz.\n'
          'Période : T = 1/f = 1/100 = 0,01 s = 10 ms.',
      takeaways: [
        'v = λf = λ/T : relation fondamentale',
        'T = 1/f ; ω = 2πf = 2π/T ; k = 2π/λ',
        'Célérité : v = 340 m/s (air), 1500 m/s (eau)',
        'Principe de superposition : y_total = y₁ + y₂',
        'Onde transversale : oscillation ⊥ propagation',
      ],
    ),
    'physique_ch5_l2': const LessonContent(
      introText:
          'Les ondes sonores sont des ondes mécaniques transversales qui se propagent dans l\'air '
          'ou d\'autres milieux. L\'effet Doppler modifie la fréquence perçue quand la source ou '
          'l\'observateur est en mouvement, ce qui a de nombreuses applications pratiques.',
      lessonBody:
          'Le son est une onde mécanique longitudinale qui se propage par compression et décompression '
          'du milieu. La gamme audible par l\'oreille humaine s\'étend de 20 Hz à 20 000 Hz. Les sons '
          'infrasonores (f < 20 Hz) et ultrasonores (f > 20 000 Hz) ne sont pas perçus.\n\n'
          'L\'intensité sonore mesure l\'énergie transportée par l\'onde par unité de surface. Elle est '
          'définie par I = P/S (en W/m²), où P est la puissance de la source et S la surface sphérique '
          'à distance r de la source : I = P/(4πr²). L\'intensité décroît en 1/r² avec la distance.\n\n'
          'Le niveau d\'intensité sonore est mesuré en décibels (dB) : L = 10 × log(I/I₀), où '
          'I₀ = 10⁻¹² W/m² est le seuil d\'audibilité. Le seuil de douleur est d\'environ 120 dB '
          '(I = 1 W/m²). Chaque augmentation de 10 dB correspond à une multiplication de l\'intensité '
          'par 10, mais l\'oreille perçoit cela comme un doublement environ.\n\n'
          'L\'effet Doppler modifie la fréquence perçue par un observateur lorsqu\'il y a mouvement relatif '
          'entre la source et l\'observateur. Formule : f\' = f × (v ± v_o)/(v ∓ v_s), où v est la '
          'célérité du son, v_o la vitesse de l\'observateur (+(v_o) si on se rapproche de la source, '
          '- v_s si la source se rapproche de l\'observateur). Quand la source se rapproche, la fréquence '
          'perçue est plus élevée (sifflement aigu). Quand elle s\'éloigne, la fréquence perçue est plus '
          'basse (sifflement grave). Au-delà de la vitesse du son (effet Doppler-Hugoniot), des ondes de '
          'choc se forment (dégagement supersonique).',
      example:
          'Exemple 1 — Intensité :\n'
          'Un haut-parleur de 10 W rayonne dans toutes les directions.\n'
          'À 5 m : I = 10/(4π × 25) = 10/314,2 ≈ 0,0318 W/m².\n'
          'Niveau : L = 10 × log(0,0318/10⁻¹²) = 10 × log(3,18 × 10¹⁰) ≈ 105 dB.\n\n'
          'Exemple 2 — Effet Doppler :\n'
          'Une ambulance (sirène à 800 Hz) se déplace à 30 m/s vers un piéton immobile.\n'
          'v = 340 m/s dans l\'air.\n'
          'f\' = 800 × 340/(340 - 30) = 800 × 340/310 ≈ 877 Hz.\n'
          'La fréquence perçue est plus élevée (rapprochement).\n\n'
          'Si l\'ambulance s\'éloigne :\n'
          'f\' = 800 × 340/(340 + 30) = 800 × 340/370 ≈ 735 Hz.\n'
          'La fréquence perçue est plus basse (éloignement).',
      takeaways: [
        'Son : onde longitudinale, gamme audible 20 Hz – 20 kHz',
        'Intensité : I = P/(4πr²), décroît en 1/r²',
        'Niveau sonore : L = 10 × log(I/I₀) en dB',
        'Effet Doppler : f\' = f × (v ± v_o)/(v ∓ v_s)',
        'Source qui se rapproche → fréquence plus élevée',
      ],
    ),
  };

  // ===========================================================================
  // PHYSIQUE — Chapitre 6 : Physique nucléaire
  // ===========================================================================

  static final Map<String, LessonContent> _physiqueCh6 = {
    'physique_ch6_l1': const LessonContent(
      introText:
          'Le noyau atomique est constitué de protons et de neutrons (nucléons). La radioactivité '
          'est le phénomène par lequel certains noyaux instables se transforment spontanément en '
          'émettant des rayonnements. La loi de décroissance radioactive permet de prévoir l\'évolution '
          'd\'un échantillon radioactif dans le temps.',
      lessonBody:
          'Le noyau atomique est constitué de protons (charge +e) et de neutrons (charge neutre). '
          'Le nombre de protons (Z) définit l\'élément chimique, le nombre de neutrons (N) varie pour '
          'un même élément (isotopes). Le nombre de masse A = Z + N est le nombre total de nucléons. '
          'On note un noyau X par ^A_Z X.\n\n'
          'La radioactivité est le phénomène de transformation spontanée de noyaux instables (radioactifs). '
          'Trois types principaux :\n'
          '1) Désintégration α (alpha) : le noyau émet un noyau d\'hélium ^4_2 He (particule α). Le noyau '
          'fille perd 2 protons et 2 neutrons : Z diminue de 2, A diminue de 4.\n'
          '2) Désintégration β⁻ (bêta moins) : un neutron se transforme en proton + électron + antineutrino. '
          'Le noyau fille gagne 1 proton : Z augmente de 1, A reste constant.\n'
          '3) Émission γ (gamma) : le noyau excité émet un photon de grande énergie. Ni Z ni A ne changent, '
          'le noyau passe d\'un état excité à un état fondamental.\n\n'
          'La loi de décroissance radioactive décrit l\'évolution du nombre de noyaux N(t) dans le temps : '
          'N(t) = N₀ × e^{-λt}, où N₀ est le nombre initial de noyaux et λ la constante de désintégration '
          '(en s⁻¹). La période radioactive T₁/₂ est le temps nécessaire pour que la moitié des noyaux '
          'se soit désintégrée : T₁/₂ = ln(2)/λ ≈ 0,693/λ. L\'activité radioactive est A = λN = A₀ × e^{-λt}, '
          'mesurée en becquerels (Bq) : 1 Bq = 1 désintégration/seconde.',
      example:
          'Exemple 1 — Désintégration α :\n'
          '^238_92 U → ^234_90 Th + ^4_2 He\n'
          'Z : 92 → 90 + 2 (conservation) ✓\n'
          'A : 238 → 234 + 4 (conservation) ✓\n\n'
          'Exemple 2 — Désintégration β⁻ :\n'
          '^14_6 C → ^14_7 N + ^0_(-1) e + ν̄_e\n'
          'Z : 6 → 7 + (-1) = 6 ✓\n'
          'A : 14 → 14 + 0 = 14 ✓\n\n'
          'Exemple 3 — Décroissance :\n'
          'Un échantillon contient N₀ = 10¹² noyaux de période T₁/₂ = 5 730 ans (carbone 14).\n'
          'Constante : λ = 0,693/5730 ≈ 1,21 × 10⁻⁴ an⁻¹.\n'
          'Après 5 730 ans (1 période) : N = 10¹²/2 = 5 × 10¹¹ noyaux.\n'
          'Après 11 460 ans (2 périodes) : N = 10¹²/4 = 2,5 × 10¹¹ noyaux.\n'
          'Activité initiale : A₀ = λN₀ = 1,21 × 10⁻⁴ × 10¹² ≈ 1,21 × 10⁸ Bq.',
      takeaways: [
        'Noyau : protons (Z) + neutrons (N), A = Z + N',
        'α : ^4_2 He (Z−2, A−4) ; β⁻ : neutron → proton (Z+1, A constant)',
        'γ : émission photon (pas de changement de Z ni A)',
        'Décroissance : N = N₀e^{-λt} ; T₁/₂ = 0,693/λ',
        'Activité : A = λN (en becquerels, Bq)',
      ],
    ),
    'physique_ch6_l2': const LessonContent(
      introText:
          'La fission et la fusion nucléaire sont deux processus nucléaires qui libèrent d\'importantes '
          'quantités d\'énergie grâce à la conversion d\'une partie de la masse en énergie selon la '
          'relation d\'Einstein E = mc².',
      lessonBody:
          'Le défaut de masse Δm est la différence entre la masse des nucléons séparés et la masse '
          'du noyau. Ce défaut correspond à l\'énergie de liaison Eb du noyau : Eb = Δm × c² = (Zm_p + Nm_n - M_Noyau) × c². '
          'Plus l\'énergie de liaison est grande, plus le noyau est stable. L\'énergie de liaison par '
          'nucléon (Eb/A) atteint un maximum vers A ≈ 56 (fer-56), ce qui explique pourquoi la fission '
          'des noyaux lourds et la fusion des noyaux légers libèrent de l\'énergie.\n\n'
          'La fission nucléaire est la division d\'un noyau lourd en deux noyaux plus légers (fissiles) '
          'sous l\'impact d\'un neutron. Exemple : ^235_92 U + ^1_0 n → ^141_56 Ba + ^92_36 Kr + 3 ^1_0 n. '
          'La réaction libère environ 200 MeV par fission et produit des neutrons qui peuvent provoquer '
          'd\'autres fissions : c\'est la réaction en chaîne. La criticité dépend du milieu : sous-critique '
          '(la réaction s\'éteint), critique (réaction stable, réacteur), surcritique (réaction croissante, '
          'bombe atomique). Le contrôle se fait par des barres absorbantes (cadmium, bore).\n\n'
          'La fusion nucléaire est la réunion de deux noyaux légers pour former un noyau plus lourd. '
          'Exemple : ^2_1 H + ^3_1 H → ^4_2 He + ^1_0 n + 17,6 MeV. La fusion nécessite des températures '
          'très élevées (plusieurs millions de degrés) pour vaincre la répulsion électrostatique entre les '
          'noyaux positifs. C\'est le processus qui alimente le Soleil et les étoiles. L\'énergie de fusion '
          'est bien supérieure à l\'énergie de fission par unité de masse. Le projet ITER vise à maîtriser '
          'la fusion nucléaire pour la production d\'énergie.',
      example:
          'Exemple 1 — Défaut de masse :\n'
          'Masse du neutron : m_n = 1,008665 u\n'
          'Masse du proton : m_p = 1,007276 u\n'
          'Masse du noyau d\'hélium : M(He) = 4,002602 u\n\n'
          'Δm = (2 × 1,007276 + 2 × 1,008665) - 4,002602\n'
          'Δm = 4,031882 - 4,002602 = 0,029280 u\n\n'
          'Eb = Δm × 931,5 MeV/u = 0,029280 × 931,5 ≈ 27,3 MeV.\n'
          'Eb/A = 27,3/4 ≈ 6,8 MeV/nucléon.\n\n'
          'Exemple 2 — Fission :\n'
          '^235_92 U + n → ^141_56 Ba + ^92_36 Kr + 3n\n'
          'Énergie libérée ≈ 200 MeV par fission.\n'
          'Pour 1 kg d\'uranium 235 : 1000/(235 × 1,66 × 10⁻²⁷) ≈ 2,57 × 10²⁴ noyaux.\n'
          'Énergie totale ≈ 2,57 × 10²⁴ × 200 × 1,6 × 10⁻¹³ ≈ 8,2 × 10¹³ J ≈ 82 TJ.',
      takeaways: [
        'Défaut de masse : Δm → Eb = Δm × c²',
        'Fission : noyau lourd + neutron → 2 noyaux + neutrons + énergie',
        'Fusion : 2 noyaux légers → noyau plus lourd + énergie',
        'Réaction en chaîne : neutrons produits déclenchent d\'autres fissions',
        'Fusion nécessite T > 10⁶ K (conditions stellaires)',
      ],
    ),
  };

  // ===========================================================================
  // PHYSIQUE — Chapitre 7 : Optique géométrique
  // ===========================================================================

  static final Map<String, LessonContent> _physiqueCh7 = {
    'physique_ch7_l1': const LessonContent(
      introText:
          'Les lentilles minces sont des éléments optiques fondamentaux utilisés pour former des images. '
          'Les lentilles convergentes et divergentes obéissent aux relations de conjugaison qui permettent '
          'de déterminer la position, la taille et la nature des images formées.',
      lessonBody:
          'Une lentille mince est un système optique centré constitué d\'un matériau transparent limité '
          'par deux surface sphériques. On distingue :\n'
          '- Lentille convergente (LC) : plus épaisse au centre qu\'aux bords. Focalise les rayons '
          'parallèles en un point F appelé foyer. Distance focale f > 0.\n'
          '- Lentille divergente (LD) : plus mince au centre. Les rayons parallèles divergent comme '
          's\'ils provenaient d\'un foyer virtuel F\'. Distance focale f\' < 0.\n\n'
          'Construction de l\'image pour une lentille convergente (f > 0) :\n'
          '- Rayon parallèle à l\'axe optique → passe par F\' (foyer image).\n'
          '- Rayon passant par le centre O → inchangé.\n'
          '- Rayon passant par F (foyer objet) → sort parallèle à l\'axe.\n\n'
          'Relation de conjugaison : 1/v - 1/u = 1/f (convention de signe : u < 0 si objet à gauche, '
          'v > 0 si image à droite). Ou sous forme de produit : u × v = f × (u - v).\n\n'
          'Grandissement linéaire : Γ = h\'/h = v/u, où h est la taille de l\'objet et h\' celle de l\'image.\n'
          '- |Γ| > 1 : image agrandie\n'
          '- |Γ| < 1 : image réduite\n'
          '- Γ > 0 : image droite\n'
          '- Γ < 0 : image renversée\n\n'
          'Nature des images avec une LC convergente :\n'
          '- u < f : image virtuelle, droite, agrandie (cas de la loupe)\n'
          '- f < u < 2f : image réelle, renversée, agrandie (projecteur)\n'
          '- u = 2f : image réelle, renversée, même taille\n'
          '- u > 2f : image réelle, renversée, réduite (appareil photo)\n\n'
          'Avec une LD divergente, l\'image est toujours virtuelle, droite et réduite, quelle que soit '
          'la position de l\'objet.',
      example:
          'Exemple — Lentille convergente :\n'
          'f = 10 cm, objet à u = -30 cm (devant la lentille).\n\n'
          '1/v - 1/(-30) = 1/10\n'
          '1/v + 1/30 = 1/10\n'
          '1/v = 1/10 - 1/30 = (3-1)/30 = 2/30 = 1/15\n'
          'v = 15 cm (image à droite, réelle).\n\n'
          'Grandissement : Γ = v/u = 15/(-30) = -0,5.\n'
          'Image renversée (Γ < 0) et réduite (|Γ| = 0,5).\n\n'
          'Nature : image réelle, renversée, réduite de moitié.\n'
          'Si h = 4 cm, alors h\' = 0,5 × 4 = 2 cm.',
      takeaways: [
        'LC (f > 0) : convergente ; LD (f < 0) : divergente',
        '1/v - 1/u = 1/f (relation de conjugaison)',
        'Grandissement : Γ = v/u = h\'/h',
        'LC : image réelle si u > f, virtuelle si u < f',
        'LD : toujours image virtuelle, droite, réduite',
      ],
    ),
    'physique_ch7_l2': const LessonContent(
      introText:
          'Les instruments d\'optique utilisent des lentilles pour observer des objets petits, '
          'éloignés ou peu lumineux. La loupe, le microscope et la lunette sont les trois instruments '
          'de base de l\'optique géométrique.',
      lessonBody:
          'La loupe (lentille convergente) est utilisée pour observer de petits objets de près. '
          'L\'objet est placé entre la lentille et son foyer (u < f) pour obtenir une image virtuelle, '
          'droite et agrandie. Le pouvoir grossant d\'une loupe est PG = 25/f (en cm), où 25 cm est la '
          'distance minimale d\'accommodation de l\'œil normal (point near). Plus la distance focale est '
          'petite, plus le grossissement est élevé.\n\n'
          'Le microscope composé est constitué de deux lentilles : un objectif de courte distance focale f_o '
          'et un oculaire de distance focale f_e. L\'objet est placé juste au-delà du foyer de l\'objectif. '
          'L\'objectif forme une image réelle intermédiaire agrandie, qui sert d\'objet pour l\'oculaire. '
          'L\'oculaire fonctionne comme une loupe pour agrandir cette image intermédiaire. Le grossissement '
          'total est le produit des grossissements : G = G_o × G_e ≈ (L/f_o) × (25/f_e), où L est la '
          'longueur du microscope (distance entre les foyers image de l\'objectif et objet de l\'oculaire).\n\n'
          'La lunette astronomique est composée d\'un objectif de longue distance focale F et d\'un oculaire '
          'de courte distance focale f_e. L\'objet est à l\'infini (très éloigné). L\'objectif forme une image '
          'réelle réduite au foyer image F\', qui est placé au foyer objet de l\'oculaire. L\'oculaire agrandit '
          'cette image. Le grossissement est : G = -F/f_e (le signe négatif indique que l\'image est renversée). '
          'Pour une lunette terrestre, on ajoute un prisme erecteur pour redresser l\'image.\n\n'
          'L\'angle d\'ouverture numérique (AN) caractérise la capacité d\'un instrument à collecter la lumière. '
          'Plus l\'AN est grand, plus l\'instrument est lumineux et bonne est la résolution (capacité à '
          'distinguer deux points proches). La limite de résolution est donnée par le critère de Rayleigh : '
          'deux points sont distinguables si leur séparation angulaire est supérieure à θ_min = 1,22 λ/D.',
      example:
          'Exemple 1 — Loupe :\n'
          'f = 10 cm.\n'
          'PG = 25/f = 25/10 = 2,5×.\n'
          'L\'objet apparaît 2,5 fois plus grand que vu à l\'œil nu à 25 cm.\n\n'
          'Exemple 2 — Microscope :\n'
          'f_o = 1 cm, f_e = 2,5 cm, L = 16 cm.\n'
          'G = (L/f_o) × (25/f_e) = (16/1) × (25/2,5) = 16 × 10 = 160×.\n\n'
          'Exemple 3 — Lunette astronomique :\n'
          'F = 100 cm, f_e = 2 cm.\n'
          'G = -F/f_e = -100/2 = -50×.\n'
          'Image 50 fois plus grande et renversée.',
      takeaways: [
        'Loupe : PG = 25/f (image virtuelle agrandie)',
        'Microscope : G ≈ (L/f_o) × (25/f_e)',
        'Lunette : G = -F/f_e (image renversée)',
        'Plus f est petite, plus le grossissement est élevé',
        'Résolution : critère de Rayleigh, θ_min = 1,22 λ/D',
      ],
    ),
  };

  // ===========================================================================
  // PHYSIQUE — Chapitre 8 : Magnétisme
  // ===========================================================================

  static final Map<String, LessonContent> _physiqueCh8 = {
    'physique_ch8_l1': const LessonContent(
      introText:
          'Le champ magnétique est une grandeur vectorielle qui décrit l\'influence magnétique dans '
          'l\'espace. Il est créé par les courants électriques et les aimants. Les lignes de champ '
          'permettent de visualiser sa direction et son intensité.',
      lessonBody:
          'Le champ magnétique B⃗ est une grandeur vectorielle mesurée en teslas (T) dans le Système '
          'International. 1 T = 1 kg/(A·s²). Le champ terrestre est de l\'ordre de 5 × 10⁻⁵ T. '
          'Un aimant permanent produit des champs de l\'ordre de 0,01 à 1 T.\n\n'
          'Sources du champ magnétique :\n'
          '1) Aimants permanents : barreau aimanté avec un pôle nord (N) et un pôle sud (S). '
          'Les lignes de champ sortent du pôle nord et entrent par le pôle sud.\n'
          '2) Courant électrique : un fil parcouru par un courant crée un champ magnétique autour de lui. '
          'Le champ est tangent aux cercles concentriques centrés sur le fil. Sa grandeur est : '
          'B = μ₀I/(2πr), où μ₀ = 4π × 10⁻⁷ T·m/A est la perméabilité du vide.\n'
          '3) Solénoïde : bobine de N spires parcourue par un courant I crée un champ uniforme à l\'intérieur : '
          'B = μ₀ × (N/L) × I, où L est la longueur de la bobine.\n\n'
          'L\'action du champ magnétique sur un conducteur parcouru par un courant est la force de Laplace : '
          'F⃗ = I × L⃗ × B⃗. La force est perpendiculaire à la fois au courant et au champ magnétique. '
          'Son intensité est F = BIL sin θ, où θ est l\'angle entre le conducteur et le champ. Cette force '
          'est le principe des moteurs électriques.\n\n'
          'L\'action du champ magnétique sur une charge q en mouvement est la force de Lorentz : '
          'F⃗ = q × v⃗ × B⃗. Cette force est toujours perpendiculaire à la vitesse, elle ne produit pas '
          'de travail mais dévie la trajectoire de la charge. Elle explique le mouvement circulaire des '
          ' charges dans un champ magnétique uniforme.',
      example:
          'Exemple 1 — Champ autour d\'un fil :\n'
          'Un fil parcouru par I = 5 A. Champ à r = 10 cm.\n'
          'B = μ₀I/(2πr) = 4π × 10⁻⁷ × 5 / (2π × 0,10)\n'
          'B = 2 × 10⁻⁷ × 5 / 0,10 = 10⁻⁵ T = 0,01 mT.\n\n'
          'Exemple 2 — Force de Laplace :\n'
          'Un conducteur de longueur L = 0,5 m, courant I = 3 A, dans un champ B = 0,2 T perpendiculaire.\n'
          'F = BIL = 0,2 × 3 × 0,5 = 0,3 N.\n\n'
          'Exemple 3 — Force de Lorentz :\n'
          'Un proton (q = 1,6 × 10⁻¹⁹ C) se déplace à v = 10⁶ m/s perpendiculairement à B = 0,1 T.\n'
          'F = qvB = 1,6 × 10⁻¹⁹ × 10⁶ × 0,1 = 1,6 × 10⁻¹⁴ N.\n'
          'Le proton décrit un mouvement circulaire de rayon r = mv/(qB).',
      takeaways: [
        'Champ magnétique B⃗ en teslas (T)',
        'Fil : B = μ₀I/(2πr) ; Solénoïde : B = μ₀NI/L',
        'Force de Laplace : F⃗ = IL⃗ × B⃗ (moteur électrique)',
        'Force de Lorentz : F⃗ = qv⃗ × B⃗ (déviation des charges)',
        'Lignes de champ : sortent du N, entrent au S',
      ],
    ),
    'physique_ch8_l2': const LessonContent(
      introText:
          'L\'induction électromagnétique est le phénomène par lequel un champ magnétique variable '
          'induit une force électromotrice (f.é.m.) dans un circuit. Découverte par Faraday en 1831, '
          'elle est à la base du fonctionnement des générateurs et des transformateurs.',
      lessonBody:
          'La loi de Faraday-Neumann-Lenz énonce que la f.é.m. induite dans un circuit est proportionnelle '
          'à la vitesse de variation du flux magnétique à travers ce circuit : ε = -dΦ/dt, où Φ = B⃗·S⃗ '
          'est le flux magnétique (en webers, Wb : 1 Wb = 1 T·m²). Le signe négatif traduit la loi de Lenz : '
          'l\'induit produit un courant dont le champ magnétique s\'oppose à la variation de flux qui l\'a '
          'provoquée.\n\n'
          'Le flux magnétique est : Φ = B × S × cos θ, où B est l\'intensité du champ, S la surface '
          'de la bobine et θ l\'angle entre B⃗ et la normale à la surface. Le flux varie si B varie '
          '(induction par variation de champ), si S varie (induction par variation de surface), ou si θ '
          'varie (induction par rotation — principe des alternateurs).\n\n'
          'L\'auto-induction est le phénomène par lequel un circuit induit une f.é.m. dans lui-même '
          'lorsque le courant qui le traverse varie. La f.é.m. d\'auto-induction est : ε_L = -L × dI/dt, '
          'où L est l\'inductance propre du circuit (en henrys, H). Le coefficient d\'auto-induction L '
          'dépend de la géométrie du circuit : pour un solénoïde, L = μ₀N²S/L.\n\n'
          'L\'énergie magnétique stockée dans une inductance est W = ½LI² (en joules). Cette énergie '
          'est stockée sous forme de champ magnétique. Lors de l\'ouverture brusque d\'un circuit '
          'inductif, la variation brutale de courant (dI/dt très grand) génère une f.é.m. d\'auto-induction '
          'très élevée, capable de produire une étincelle (surtension). C\'est ce principe qu\'on utilise '
          'dans les bougies d\'allumage des moteurs.',
      example:
          'Exemple 1 — Loi de Faraday :\n'
          'Une bobine de 200 spires, surface S = 50 cm² = 5 × 10⁻³ m².\n'
          'Le champ varie de 0,1 T à 0,5 T en 0,02 s.\n'
          'ΔΦ = ΔB × S = (0,5 - 0,1) × 5 × 10⁻³ = 2 × 10⁻³ Wb.\n'
          'ε = -N × ΔΦ/Δt = -200 × 2 × 10⁻³ / 0,02 = -20 V.\n'
          'La f.é.m. induite est de 20 V.\n\n'
          'Exemple 2 — Auto-induction :\n'
          'L = 0,1 H, le courant varie de 0 à 5 A en 0,01 s.\n'
          'ε_L = -L × ΔI/Δt = -0,1 × 5/0,01 = -50 V.\n'
          'La f.é.m. d\'auto-induction est de 50 V.\n\n'
          'Exemple 3 — Énergie magnétique :\n'
          'Une inductance L = 0,5 H parcourue par I = 4 A.\n'
          'W = ½LI² = ½ × 0,5 × 16 = 4 J.',
      takeaways: [
        'Faraday : ε = -dΦ/dt (f.é.m. induite)',
        'Φ = BS cos θ : flux magnétique (en webers)',
        'Lenz : l\'induit s\'oppose à la variation de flux',
        'Auto-induction : ε_L = -L × dI/dt',
        'Énergie : W = ½LI² (stockée dans le champ magnétique)',
      ],
    ),
  };

  // ===========================================================================
  // PHYSIQUE — Chapitre 1 : Cinématique
  // ===========================================================================

  static final Map<String, LessonContent> _physiqueCh1 = {
    'physique_ch1_l1': const LessonContent(
      introText:
          'La cinématique est la branche de la mécanique qui décrit le mouvement des objets '
          'sans chercher à en comprendre les causes (les forces). Elle utilise les vecteurs pour '
          'décrire la position, la vitesse et l\'accélération d\'un mobile dans un repère donné.',
      lessonBody:
          'Pour décrire le mouvement d\'un corps, on choisit un repère d\'étude (généralement un repère '
          'cartésien orthogonal Oxyz) fixe. La position du mobile M à chaque instant t est repérée par '
          'le vecteur position OM⃗, noté r⃗(t). Les coordonnées de ce vecteur dans le repère sont les '
          'fonctions x(t), y(t), z(t) qui décrivent l\'évolution temporelle de la position du mobile.\n\n'
          'Le vecteur vitesse v⃗ est la dérivée temporelle du vecteur position : v⃗ = dr⃗/dt. Dans le '
          'repère cartésien, ses composantes sont vx = dx/dt, vy = dy/dt, vz = dz/dt. Le vecteur vitesse '
          'est toujours tangent à la trajectoire du mobile. Sa norme ||v⃗|| = √(vx² + vy² + vz²) '
          'représente la vitesse instantanée (ou vitesse scalaire) du mobile.\n\n'
          'Le vecteur accélération a⃗ est la dérivée temporelle du vecteur vitesse : a⃗ = dv⃗/dt = d²r⃗/dt². '
          'Ses composantes sont ax = dvx/dt, ay = dvy/dt, az = dvz/dt. L\'accélération décrit la rapidité '
          'avec laquelle le vecteur vitesse change. Elle n\'est pas nécessairement dans la direction du mouvement : '
          'd\'un mouvement circulaire uniforme, par exemple, l\'accélération est dirigée vers le centre de la '
          'trajectoire (accélération centripète) bien que la vitesse soit tangentielle.\n\n'
          'La dérivation vectorielle obéit aux mêmes règles que la dérivation scalaire : la dérivée d\'une somme '
          'est la somme des dérivées, la dérivée d\'un produit par un scalaire est le produit du scalaire par la '
          'dérivée, etc. Les grandeurs vectorielles portent une flèche ou un accent barre (r⃗, v⃗, a⃗) pour les '
          'distinguer des grandeurs scalaires.',
      example:
          'Exemple — Mouvement dans le plan :\n'
          'Un mobile a pour coordonnées : x(t) = 3t² et y(t) = 2t + 1 (en mètres et secondes).\n\n'
          'Vecteur position : r⃗(t) = 3t²·i⃗ + (2t + 1)·j⃗\n\n'
          'Vecteur vitesse :\n'
          'vx = dx/dt = 6t\n'
          'vy = dy/dt = 2\n'
          'v⃗(t) = 6t·i⃗ + 2·j⃗\n'
          'Vitesse instantanée : v(t) = √(36t² + 4)\n'
          'À t = 1 s : v(1) = √(36 + 4) = √40 ≈ 6,32 m/s\n\n'
          'Vecteur accélération :\n'
          'ax = dvx/dt = 6\n'
          'ay = dvy/dt = 0\n'
          'a⃗ = 6·i⃗ (constante, dirigée selon l\'axe Ox)\n\n'
          'Le mouvement est uniformément accéléré selon x, uniforme selon y.',
      takeaways: [
        'Vecteur position : r⃗(t) = OM⃗ décrit la position dans le repère',
        'Vecteur vitesse : v⃗ = dr⃗/dt, tangent à la trajectoire',
        'Vecteur accélération : a⃗ = dv⃗/dt, décrite le changement de vitesse',
        'L\'accélération n\'est pas forcément colinéaire à la vitesse',
      ],
    ),
    'physique_ch1_l2': const LessonContent(
      introText:
          'Le mouvement rectiligne uniforme (MRU) est le mouvement le plus simple : le mobile se déplace '
          'en ligne droite à vitesse constante. C\'est le point de départ de toute étude cinématique.',
      lessonBody:
          'Un mouvement est dit rectiligne uniforme (MRU) lorsque le mobile se déplace en ligne droite '
          'avec une vitesse constante, c\'est-à-dire de norme et de direction invariables. Dans un MRU, '
          'le vecteur accélération est nul : a⃗ = 0⃗. La trajectoire est une droite et la vitesse est '
          'par conséquent tangente à cette droite.\n\n'
          'L\'équation horaire du MRU s\'obtient en intégrant la relation v = dx/dt = cste. On obtient :\n'
          'x(t) = x₀ + vt\n'
          'où x₀ est la position initiale (à t = 0) et v est la vitesse (constante, positive ou négative). '
          'Si v > 0, le mobile se déplace dans le sens positif de l\'axe. Si v < 0, il se déplace en sens '
          'inverse. La position varie linéairement avec le temps.\n\n'
          'La représentation graphique du MRU est simple. Le diagramme position-temps (x, t) est une droite '
          'de pente v. Le diagramme vitesse-temps (v, t) est une droite horizontale à la hauteur v. '
          'L\'aire sous la courbe (v, t) entre deux instants t₁ et t₂ représente le déplacement effectué '
          'pendant cet intervalle : Δx = v × (t₂ - t₁).\n\n'
          'Un exemple concret de MRU est le déplacement d\'une voiture sur une autoroute à vitesse de '
          'croisière constante. Un autre exemple est le mouvement de la lumière dans le vide (v = c ≈ 3×10⁸ m/s). '
          'En pratique, le MRU est une approximation : tout mouvement réel subit des perturbations.',
      example:
          'Exemple — Déplacement en MRU :\n'
          'Une voiture roule en MRU à v = 90 km/h sur une autoroute.\n\n'
          'a) Conversion des unités :\n'
          'v = 90 km/h = 90 × 1000/3600 = 25 m/s\n\n'
          'b) Position à t = 12 min :\n'
          't = 12 min = 720 s\n'
          'x(t) = x₀ + vt = 0 + 25 × 720 = 18 000 m = 18 km\n\n'
          'c) Temps pour parcourir 45 km :\n'
          'x = vt ⟹ t = x/v = 45 000/25 = 1 800 s = 30 min\n\n'
          'd) Déplacement entre t₁ = 5 min et t₂ = 20 min :\n'
          'Δt = 15 min = 900 s\n'
          'Δx = v × Δt = 25 × 900 = 22 500 m = 22,5 km\n\n'
          'e) Diagramme (x, t) : droite passant par l\'origine de pente 25 m/s.',
      takeaways: [
        'MRU : vitesse constante, accélération nulle',
        'Équation horaire : x(t) = x₀ + vt',
        'Diagramme (x, t) : droite de pente v',
        'Diagramme (v, t) : droite horizontale',
        'Déplacement = aire sous la courbe (v, t)',
      ],
    ),
    'physique_ch1_l3': const LessonContent(
      introText:
          'Le mouvement rectiligne uniformément varié (MRUV) décrit le mouvement d\'un mobile en ligne droite '
          'avec une accélération constante non nulle. C\'est le cas le plus fréquent en cinématique, notamment '
          'la chute libre sous l\'effet de la pesanteur.',
      lessonBody:
          'Un mouvement est dit rectiligne uniformément varié (MRUV) lorsque le mobile possède une accélération '
          'constante a (de norme et de direction fixes) colinéaire à la vitesse. La trajectoire est une droite '
          'et la vitesse varie linéairement avec le temps. Si a > 0, le mouvement est accéléré (la vitesse '
          'augmente en valeur absolue). Si a < 0, le mouvement est décéléré.\n\n'
          'Les équations fondamentales du MRUV sont :\n'
          '1) Vitesse : v(t) = v₀ + at\n'
          '2) Position : x(t) = x₀ + v₀t + ½at²\n'
          '3) Équation sans temps : v² = v₀² + 2a(x - x₀)\n'
          'où v₀ est la vitesse initiale (à t = 0), x₀ la position initiale, a l\'accélération constante. '
          'Ces trois équations sont interdépendantes : on peut passer de l\'une à l\'autre par intégration '
          'ou dérivation.\n\n'
          'Le cas particulier de la chute libre est un MRUV où l\'accélération est la pesanteur : a = g ≈ 9,81 m/s² '
          '(vers le bas). En négligeant la résistance de l\'air, tous les corps tombent avec la même accélération '
          'quelle que soit leur masse (principe de Galilée). L\'équation de la vitesse est v(t) = v₀ + gt et '
          'celle de la position est y(t) = y₀ + v₀t - ½gt² (axe orienté vers le haut, donc g est négatif).\n\n'
          'Le lancer vertical est l\'exemple type de MRUV. Un objet lancé verticalement vers le haut avec une '
          'vitesse initiale v₀ subit une décélération constante g. Il atteint son point culminant quand v = 0, '
          'puis retombe librement. Le temps de montée est égal au temps de descente (en négligeant la résistance '
          'de l\'air). La hauteur maximale est h = v₀²/(2g).',
      example:
          'Exemple — Lancer vertical :\n'
          'On lance une pierre verticalement vers le haut avec v₀ = 20 m/s depuis le sol (y₀ = 0).\n\n'
          'a) Vitesse à tout instant (axe vers le haut, g = -9,81 m/s²) :\n'
          'v(t) = v₀ + gt = 20 - 9,81t\n\n'
          'b) Position à tout instant :\n'
          'y(t) = v₀t + ½gt² = 20t - 4,905t²\n\n'
          'c) Temps pour atteindre le point culminant (v = 0) :\n'
          '0 = 20 - 9,81t ⟹ t = 20/9,81 ≈ 2,04 s\n\n'
          'd) Hauteur maximale :\n'
          'y(2,04) = 20(2,04) - 4,905(2,04)² ≈ 40,8 - 20,4 ≈ 20,4 m\n'
          'Ou directement : h = v₀²/(2g) = 400/(2×9,81) ≈ 20,4 m\n\n'
          'e) Temps total de vol (retour au sol, y = 0) :\n'
          '0 = 20t - 4,905t² = t(20 - 4,905t)\n'
          't = 0 (départ) ou t = 20/4,905 ≈ 4,08 s\n'
          'Le temps de descente est bien égal au temps de montée : 4,08/2 = 2,04 s. ✓\n\n'
          'f) Vitesse à l\'impact (au retour au sol) :\n'
          'v(4,08) = 20 - 9,81 × 4,08 ≈ -20 m/s (vers le bas, même intensité que v₀)',
      takeaways: [
        'MRUV : accélération constante, vitesse linéaire en t',
        'v(t) = v₀ + at ; x(t) = x₀ + v₀t + ½at²',
        'v² = v₀² + 2a(x - x₀) (équation sans temps)',
        'Chute libre : a = g ≈ 9,81 m/s² (vers le bas)',
        'Lancer vertical : t montée = t descente, h_max = v₀²/(2g)',
      ],
    ),
  };

  // ===========================================================================
  // CHIMIE — Chapitre 1 : Acides et bases
  // ===========================================================================

  static final Map<String, LessonContent> _chimieCh1 = {
    'chimie_ch1_l1': const LessonContent(
      introText:
          'La théorie acide-base selon Brönsted-Lowry (1923) est le cadre le plus utilisé en chimie '
          'pour décrire les réactions de transfert de protons. Elle élargit la définition des acides et '
          'des bases au-delà de la simple production d\'ions H⁺ ou OH⁻ en solution aqueuse.',
      lessonBody:
          'Selon la définition de Brönsted-Lowry, un acide (noté AH) est toute espèce chimique capable '
          'de céder un proton (H⁺) lors d\'une réaction. Une base (notée B) est toute espèce chimique '
          'capable de capter un proton. Une réaction acido-basique est donc une réaction de transfert de '
          'proton entre un acide et une base.\n\n'
          'Lorsqu\'un acide AH cède son proton, il se transforme en sa base conjuguée A⁻. Inversement, '
          'lorsqu\'une base B capte un proton, elle se transforme en son acide conjugué BH⁺. On parle '
          'de couples acide-base conjugués : (AH, A⁻) et (BH⁺, B). La réaction acido-basique s\'écrit '
          'généralement : AH + B⁻ → A⁻ + BH⁺.\n\n'
          'Exemples de couples acide-base conjugués :\n'
          '- L\'acide chlorhydrique HCl est un acide très fort : HCl → H⁺ + Cl⁻. Le couple est (HCl, Cl⁻). '
          'Mais HCl est si fort que Cl⁻ est une base très faible (sa base conjuguée est négligeable).\n'
          '- L\'ammonium NH₄⁺ est un acide faible : NH₄⁺ ⇌ NH₃ + H⁺. Le couple est (NH₄⁺, NH₃).\n'
          '- L\'eau peut jouer les deux rôles (amphotère) : H₂O ⇌ H⁺ + OH⁻. Le couple est (H₂O, OH⁻).\n'
          '- L\'acide acétique CH₃COOH est un acide faible : CH₃COOH ⇌ CH₃COO⁻ + H⁺.\n\n'
          'La force d\'un acide dépend de sa capacité à céder son proton en solution. Un acide fort est '
          'totalement dissocié en solution, tandis qu\'un acide faible n\'est que partiellement dissocié '
          '(réaction d\'équilibre). La force d\'une base est inversement liée à la force de son acide '
          'conjugué : plus l\'acide est fort, plus la base conjuguée est faible.',
      example:
          'Exemple 1 — Réaction dans l\'eau :\n'
          'HCl + H₂O → H₃O⁺ + Cl⁻\n'
          'HCl joue le rôle d\'acide (cède H⁺).\n'
          'H₂O joue le rôle de base (capte H⁺).\n'
          'Couples : (HCl, Cl⁻) et (H₃O⁺, H₂O).\n'
          'HCl est un acide fort, Cl⁻ est une base très faible.\n\n'
          'Exemple 2 — Ammonium :\n'
          'NH₄⁺ + OH⁻ → NH₃ + H₂O\n'
          'NH₄⁺ est l\'acide (cède H⁺).\n'
          'OH⁻ est la base (capte H⁺).\n'
          'Couples : (NH₄⁺, NH₃) et (H₂O, OH⁻).\n'
          'NH₄⁺ est un acide faible (pKa ≈ 9,25).\n\n'
          'Exemple 3 — Autoionisation de l\'eau :\n'
          'H₂O + H₂O ⇌ H₃O⁺ + OH⁻\n'
          'L\'eau est à la fois acide et base (amphotère).\n'
          'Kw = [H₃O⁺][OH⁻] = 10⁻¹⁴ à 25°C.',
      takeaways: [
        'Acide = cède un proton (H⁺) ; Base = capte un proton',
        'Réaction : AH + B⁻ ⇌ A⁻ + BH⁺',
        'Couples acide-base conjugués : (AH, A⁻)',
        'Acide fort = totalement dissocié ; acide faible = partiellement dissocié',
        'L\'eau est amphotère : elle peut jouer les deux rôles',
      ],
    ),
    'chimie_ch1_l2': const LessonContent(
      introText:
          'Le pH et le pKa sont des grandeurs logarithmiques qui permettent de caractériser respectivement '
          'l\'acidité d\'une solution et la force d\'un acide. Ils sont indispensables en chimie pour comparer '
          'des solutions et prédire le sens des réactions acido-basiques.',
      lessonBody:
          'Le pH (potentiel hydrogène) est défini par la formule : pH = -log[H₃O⁺], où [H₃O⁺] est la '
          'concentration molaire en ions oxonium (en mol/L). L\'échelle de pH va généralement de 0 à 14 '
          'pour les solutions aqueuses à 25°C : pH < 7 ⟹ solution acide, pH = 7 ⟹ solution neutre, '
          'pH > 7 ⟹ solution basique. Un pH de 3 est cent fois plus acide qu\'un pH de 5 (chaque unité '
          'de pH correspond à un facteur 10).\n\n'
          'La constante d\'acidité Ka caractérise la force d\'un acide faible. Pour la dissociation '
          'AH + H₂O ⇌ A⁻ + H₃O⁺, on définit : Ka = [A⁻][H₃O⁺] / [AH]. Plus Ka est grand, plus '
          'l\'acide est fort (il se dissocié davantage). Le pKa est défini par pKa = -log(Ka). '
          'Un acide faible a un pKa élevé (Ka faible) et un acide plus fort a un pKa faible (Ka élevé). '
          'Par exemple, l\'acide acétique a pKa ≈ 4,76 et l\'acide cyanhydrique a pKa ≈ 9,21.\n\n'
          'La relation fondamentale entre pH, pKa et les concentrations est la formule de Henderson-Hasselbalch :\n'
          'pH = pKa + log([A⁻]/[AH])\n'
          'où [A⁻] est la concentration de la base conjuguée et [AH] celle de l\'acide. Cette formule '
          'est valable pour les solutions tampons (mélanges d\'un acide faible et de sa base conjuguée). '
          'Quand [A⁻] = [AH], on a pH = pKa. C\'est le point où le tampon est le plus efficace.\n\n'
          'Les domaines de prédominance montrent quelle espèce domine en solution en fonction du pH. '
          'Pour un couple (AH, A⁻) : si pH < pKa, l\'acide AH prédomine ; si pH > pKa, la base A⁻ '
          'prédomine. Les indicateurs colorés sont des substances organiques qui changent de couleur dans '
          'certaines plages de pH. Par exemple, le bleu de bromothymol passe du jaune (pH < 6) au bleu '
          '(pH > 7,6). Le choix de l\'indicateur pour un dosage dépend du pH au point d\'équivalence.',
      example:
          'Exemple 1 — Calcul de pH :\n'
          'Solution d\'acide acétique 0,1 mol/L.\n'
          'Ka = 1,8 × 10⁻⁵ ; pKa = 4,76\n'
          '[H₃O⁺] ≈ √(Ka × Ca) = √(1,8 × 10⁻⁵ × 0,1) = √(1,8 × 10⁻⁶) ≈ 1,34 × 10⁻³ mol/L\n'
          'pH = -log(1,34 × 10⁻³) ≈ 2,87\n\n'
          'Exemple 2 — Solution tampon :\n'
          'Mélange de CH₃COOH 0,1 M et CH₃COONa 0,2 M.\n'
          'pH = pKa + log([A⁻]/[AH]) = 4,76 + log(0,2/0,1)\n'
          'pH = 4,76 + log(2) = 4,76 + 0,30 = 5,06\n\n'
          'Exemple 3 — Domaine de prédominance :\n'
          'Pour le couple NH₄⁺/NH₃ (pKa = 9,25) :\n'
          'Si pH = 7 (pH < pKa) : NH₄⁺ prédomine.\n'
          'Si pH = 11 (pH > pKa) : NH₃ prédomine.\n'
          'Au point pH = pKa = 9,25 : [NH₄⁺] = [NH₃].',
      takeaways: [
        'pH = -log[H₃O⁺] ; échelle de 0 à 14',
        'Ka = [A⁻][H₃O⁺]/[AH] ; pKa = -log(Ka)',
        'Henderson-Hasselbalch : pH = pKa + log([A⁻]/[AH])',
        'pH < pKa ⟹ AH prédomine ; pH > pKa ⟹ A⁻ prédomine',
        'Tampon optimal quand pH = pKa',
      ],
    ),
    'chimie_ch1_l3': const LessonContent(
      introText:
          'Le dosage acido-basique est une méthode analytique quantitative qui permet de déterminer la '
          'concentration d\'un acide (ou d\'une base) en le faisant réagir avec une base (ou un acide) '
          'de concentration connue. C\'est une opération fondamentale en chimie.',
      lessonBody:
          'Le principe du dosage acido-basique repose sur une réaction support de dosage, c\'est-à-dire '
          'une réaction acido-basique complète et rapide entre l\'acide à doser (analyte) et la base de '
          'dosage (titrant), ou inversement. Le titrant est versé goutte à goutte dans l\'analyte jusqu\'à '
          'atteindre le point d\'équivalence, quantité stœchiométrique.\n\n'
          'Le point d\'équivalence est le moment où les quantités de matière de l\'acide et de la base '
          'sont exactement dans le rapport stœchiométrique de la réaction. Pour une réaction AH + BOH → '
          'AB + H₂O, le point d\'équivalence correspond à n(AH) = n(BOH). Le point de virage est le moment '
          'où l\'indicateur coloré change de couleur. Idéalement, le point de virage coïncide avec le point '
          'd\'équivalence.\n\n'
          'La courbe de titrage (ou courbe potentiométrique) représente l\'évolution du pH en fonction du '
          'volume de titrant versé : pH = f(V). Elle présente trois zones caractéristiques : une zone de pH '
          'relativement stable au début (zone tampon), un saut de pH brutal au voisinage du point d\'équivalence, '
          'et une zone de stabilisation après le point d\'équivalence. L\'amplitude du saut de pH dépend de la '
          'force des réactifs : elle est plus grande pour un dosage acide fort/base forte.\n\n'
          'Le choix de l\'indicateur coloré est crucial. Il doit avoir une plage de virage qui correspond '
          'au saut de pH au point d\'équivalence. Par exemple, pour un dosage HCl (acide fort) par NaOH '
          '(base forte), le point d\'équivalence est à pH = 7 et le saut de pH est de pH ≈ 4 à pH ≈ 10. '
          'Le bleu de bromothymol (plage 6,0-7,6) ou le phénolphtaléine (plage 8,0-10,0) conviennent. '
          'Pour un dosage acide faible par base forte, le point d\'équivalence est à pH > 7, donc la '
          'phénolphtaléine est préférable.',
      example:
          'Exemple — Dosage de HCl par NaOH :\n'
          'On titre 20 mL d\'HCl 0,1 mol/L par du NaOH 0,1 mol/L.\n\n'
          'Réaction : HCl + NaOH → NaCl + H₂O\n'
          'Stœchiométrie : 1 mole de HCl réagit avec 1 mole de NaOH.\n\n'
          'Volume au point d\'équivalence :\n'
          'n(HCl) = C(HCl) × V(HCl) = 0,1 × 0,020 = 0,002 mol\n'
          'n(NaOH) = n(HCl) = 0,002 mol\n'
          'V(NaOH) = n(NaOH) / C(NaOH) = 0,002 / 0,1 = 0,020 L = 20 mL\n\n'
          'Évolution du pH :\n'
          '- Avant dosage (V = 0) : pH = -log(0,1) = 1\n'
          '- À mi-dosage (V = 10 mL) : [HCl] restant ≈ 0,033 M, pH ≈ 1,48\n'
          '- Au point d\'équivalence (V = 20 mL) : pH = 7 (solution de NaCl, sel neutre)\n'
          '- Après le point d\'équivalence (V = 25 mL) : excès de NaOH, pH ≈ 12,3\n\n'
          'Indicateur : bleu de bromothymol (virage jaune → bleu à pH ≈ 7). ✓\n\n'
          'Formule de calcul : Ca × Va = Cb × Vb (relation fondamentale du dosage)\n'
          '0,1 × 20 = 0,1 × 20 → Vb = 20 mL. ✓',
      takeaways: [
        'Dosage = réaction support de dosage totale et rapide',
        'Point d\'équivalence : quantités stœchiométriques exactes',
        'Courbe de titrage : pH = f(V) avec saut de pH au point d\'équivalence',
        'Ca × Va = Cb × Vb (relation fondamentale)',
        'Choix de l\'indicateur : plage de virage ≈ saut de pH',
      ],
    ),
  };

  // ===========================================================================
  // CHIMIE — Chapitre 2 : Oxydoréduction
  // ===========================================================================

  static final Map<String, LessonContent> _chimieCh2 = {
    'chimie_ch2_l1': const LessonContent(
      introText:
          'L\'oxydoréduction est une réaction chimique au cours de laquelle il y a transfert d\'électrons '
          'entre les espèces chimiques. La notion de nombre d\'oxydation permet d\'identifier les espèces '
          'oxydées et réduites et d\'équilibrer les réactions redox.',
      lessonBody:
          'Le nombre d\'oxydation (n.o.) est une charge formelle attribuée à un atome dans une molécule '
          'ou un ion. Règles principales :\n'
          '- L\'état d\'oxydation d\'un atome libre est 0.\n'
          '- Pour un ion monoatomique, le n.o. = charge de l\'ion.\n'
          '- L\'oxygène a généralement n.o. = -2 (sauf peroxydes où n.o. = -1).\n'
          '- L\'hydrogène a n.o. = +1 avec les non-métaux, -1 avec les métaux.\n'
          '- La somme des n.o. dans une molécule neutre est 0 ; dans un ion, elle égale la charge.\n\n'
          'Oxydation : un atome perd des électrons (son n.o. augmente).\n'
          'Réduction : un atome gagne des électrons (son n.o. diminue).\n'
          'Un agent réducteur est oxydé (il cède des électrons).\n'
          'Un agent oxydant est réduit (il capte des électrons).\n\n'
          'Équilibrage par la méthode des demi-équations :\n'
          '1) Séparer en deux demi-équations (oxydation et réduction).\n'
          '2) Équilibrer chaque demi-équation (atomes puis charges par ajout d\'électrons).\n'
          '3) Multiplier pour obtenir le même nombre d\'électrons.\n'
          '4) Additionner les demi-équations.\n\n'
          'N.B. : en milieu acide, on équilibre H et O par H₂O et H⁺. En milieu basique, on ajoute OH⁻.',
      example:
          'Exemple — Réaction en milieu acide :\n'
          'Fe²⁺ + MnO₄⁻ → Fe³⁺ + Mn²⁺\n\n'
          'Demi-équation d\'oxydation : Fe²⁺ → Fe³⁺ + e⁻\n'
          'Demi-équation de réduction : MnO₄⁻ + 8H⁺ + 5e⁻ → Mn²⁺ + 4H₂O\n\n'
          'Multiplions la première par 5 :\n'
          '5Fe²⁺ → 5Fe³⁺ + 5e⁻\n'
          'MnO₄⁻ + 8H⁺ + 5e⁻ → Mn²⁺ + 4H₂O\n\n'
          'Équation totale :\n'
          '5Fe²⁺ + MnO₄⁻ + 8H⁺ → 5Fe³⁺ + Mn²⁺ + 4H₂O\n\n'
          'Vérification des charges :\n'
          'Gauche : 5(+2) + (-1) + 8(+1) = +17\n'
          'Droite : 5(+3) + (+2) = +17 ✓',
      takeaways: [
        'Oxydation = perte d\'électrons ; Réduction = gain d\'électrons',
        'Nombre d\'oxydation : charge formelle sur un atome',
        'Agent oxydant est réduit ; agent réducteur est oxydé',
        'Équilibrage par demi-équations (électrons échangés)',
        'Milieu acide : H⁺ et H₂O ; milieu basique : OH⁻',
      ],
    ),
    'chimie_ch2_l2': const LessonContent(
      introText:
          'Les piles électrochimiques transforment l\'énergie chimique en énergie électrique par une '
          'réaction d\'oxydoréduction spontanée. La force électromotrice (f.é.m.) et le potentiel standard '
          'permettent de caractériser la capacité d\'une pile à produire un courant.',
      lessonBody:
          'Une pile électrique est constituée de deux demi-éléments reliés par un pont salin. Chaque '
          'demi-élément comprend une électrode plongeant dans une solution d\'ions. '
          'L\'anode est l\'électrode où se produit l\'oxydation (perte d\'électrons). La cathode est '
          'l\'électrode où se produit la réduction (gain d\'électrons). Les électrons circulent de '
          'l\'anode vers la cathode dans le circuit extérieur.\n\n'
          'Le potentiel standard E° mesure la tendance d\'une demi-réaction à se réduire '
          '(à gagner des électrons) dans des conditions standard (1 mol/L, 25°C, 1 atm). Plus E° est '
          'grand et positif, plus l\'espèce est un bon agent oxydant. La f.é.m. standard est : '
          'E°_pile = E°_cathode - E°_anode > 0 (réaction spontanée).\n\n'
          'Exemples de potentiels standards :\n'
          '- Zn²⁺/Zn : E° = -0,76 V (bon agent réducteur)\n'
          '- Cu²⁺/Cu : E° = +0,34 V\n'
          '- H⁺/H₂ : E° = 0 V (référence)\n'
          '- Ag⁺/Ag : E° = +0,80 V\n\n'
          'Équation de Nernst (conditions non standard) :\n'
          'E = E° + (RT/nF) × ln([Oxydant]/[Réduit])\n'
          'À 25°C : E = E° + (0,059/n) × log([Oxydant]/[Réduit])\n'
          'où n = nombre d\'électrons échangés, F = 96 485 C/mol.',
      example:
          'Exemple — Pile Daniell (Zn/Cu) :\n'
          'Anode (oxydation) : Zn → Zn²⁺ + 2e⁻\n'
          'Cathode (réduction) : Cu²⁺ + 2e⁻ → Cu ; E° = +0,34 V\n\n'
          'F.é.m. : E° = E°_cathode - E°_anode = 0,34 - (-0,76) = 1,10 V.\n\n'
          'Équation globale : Zn + Cu²⁺ → Zn²⁺ + Cu\n\n'
          'Avec Nernst si [Zn²⁺] = 2 M et [Cu²⁺] = 0,5 M :\n'
          'E = 1,10 + (0,059/2) × log(0,5/2)\n'
          'E = 1,10 + 0,0295 × (-0,602) = 1,082 V.',
      takeaways: [
        'Anode = oxydation ; Cathode = réduction',
        'E°_pile = E°_cathode - E°_anode > 0 (spontané)',
        'Potentiel standard : tendance à être réduit',
        'Nernst : E = E° + (0,059/n) log([O]/[R]) à 25°C',
        'F = 96 485 C/mol (constante de Faraday)',
      ],
    ),
    'chimie_ch2_l3': const LessonContent(
      introText:
          'L\'électrolyse est une réaction d\'oxydoréduction non spontanée provoquée par le passage '
          'd\'un courant électrique à travers un milieu ionique. C\'est un procédé industriel majeur '
          'pour l\'extraction des métaux et la production de chimiques.',
      lessonBody:
          'Le principe de l\'électrolyse : forcer le passage d\'un courant continu dans un '
          'électrolyte (solution ou milieu fondu) à l\'aide de deux électrodes reliées '
          'à une source de tension. À la cathode (-) se produit la réduction des cations. '
          'À l\'anode (+) se produit l\'oxydation des anions.\n\n'
          'Électrolyse du NaCl fondu (801°C) :\n'
          '- Anode : 2Cl⁻ → Cl₂ + 2e⁻\n'
          '- Cathode : Na⁺ + e⁻ → Na\n\n'
          'Électrolyse de l\'eau :\n'
          '- Anode : 2H₂O → O₂ + 4H⁺ + 4e⁻\n'
          '- Cathode : 4H⁺ + 4e⁻ → 2H₂\n'
          'Réaction globale : 2H₂O → 2H₂ + O₂\n'
          'Rapport des volumes : V(H₂)/V(O₂) = 2.\n\n'
          'Loi de Faraday : n = It/(n_e × F), où Q = It est la charge '
          'en coulombs, n_e le nombre d\'électrons échangés et F = 96 485 C/mol.\n\n'
          'Applications industrielles :\n'
          '- Extraction de l\'aluminium (Hall-Héroult)\n'
          '- Galvanoplastie (dépôt électrolytique)\n'
          '- Purification du cuivre',
      example:
          'Exemple — Électrolyse de CuSO₄ :\n'
          'I = 2 A pendant 30 min = 1800 s.\n\n'
          'Cathode : Cu²⁺ + 2e⁻ → Cu (n_e = 2)\n'
          'Masse : m = (I × t × M)/(n_e × F)\n'
          'm = (2 × 1800 × 63,5)/(2 × 96 485)\n'
          'm = 228 600 / 192 970 ≈ 1,18 g de cuivre.\n\n'
          'Volume d\'O₂ à l\'anode :\n'
          'n(O₂) = It/(4F) = 3600/(4 × 96485) = 9,33 × 10⁻³ mol\n'
          'V(O₂) ≈ 229 mL (à 25°C).',
      takeaways: [
        'Électrolyse : réaction redox forcée par courant',
        'Cathode : réduction ; Anode : oxydation',
        'Loi de Faraday : n = It/(n_e F)',
        'Applications : aluminium, galvanoplastie, purification',
        'Rendement coulombique : rapport théorique/expérimental',
      ],
    ),
  };

  // ===========================================================================
  // CHIMIE — Chapitre 3 : Chimie organique
  // ===========================================================================

  static final Map<String, LessonContent> _chimieCh3 = {
    'chimie_ch3_l1': const LessonContent(
      introText:
          'La chimie organique étudie les composés du carbone, qui forment la base de la vie. '
          'Les hydrocarbures (alcanes, alcènes, alcynes) sont les molécules organiques les plus simples, '
          'constituées uniquement de carbone et d\'hydrogène.',
      lessonBody:
          'Les alcanes sont des hydrocarbures saturés (liaisons simples) de formule CₙH₂ₙ₊₂. '
          'Noms : méthane (C₁), éthane (C₂), propane (C₃), butane (C₄), pentane (C₅). '
          'Ils forment une série homologue dont chaque terme diffère par un groupe CH₂. '
          'Molécules apolaires, peu réactives, combustibles.\n\n'
          'Les alcènes contiennent au moins une double liaison C=C. Formule : CₙH₂ₙ. '
          'Noms : éthène (C₂H₄), propène (C₃H₆), but-1-ène, but-2-ène. '
          'La double liaison est un site réactif. La nomenclature IUPAC localise la liaison '
          'par un nombre.\n\n'
          'Les alcynes contiennent au moins une triple liaison C≡C. Formule : CₙH₂ₙ₋₂. '
          'Le plus simple est l\'acétylène (éthyne) C₂H₂, utilisé pour le soudage.\n\n'
          'L\'isomérie structural : plusieurs molécules ont la même formule brute mais des '
          'structures différentes. Exemple : C₄H₁₀ existe sous n-butane et isobutane. '
          'L\'isomérie de position concerne la localisation d\'un groupe fonctionnel '
          '(but-1-ène et but-2-ène).',
      example:
          'Exemple 1 — Nomenclature :\n'
          'CH₃-CH₂-CH₂-CH₃ : butane (C₄H₁₀)\n'
          'CH₃-CH=CH-CH₃ : but-2-ène (C₄H₈)\n'
          'CH₃-C≡CH : propyne (C₃H₄)\n\n'
          'Exemple 2 — Formules moléculaires :\n'
          'Alcané de 6 C : C₆H₁₄ (hexane)\n'
          'Alcène de 5 C : C₅H₁₀ (pentène)\n\n'
          'Exemple 3 — Isomérie :\n'
          'C₄H₁₀ : 2 isomères (n-butane, isobutane)\n'
          'C₅H₁₂ : 3 isomères (n-pentane, isopentane, néopentane)',
      takeaways: [
        'Alcanes : CₙH₂ₙ₊₂ (saturés, liaisons simples)',
        'Alcènes : CₙH₂ₙ (insaturés, double liaison C=C)',
        'Alcynes : CₙH₂ₙ₋₂ (triple liaison C≡C)',
        'Isomérie : même formule brute, structures différentes',
        'IUPAC : localisation des liaisons par numérotation',
      ],
    ),
    'chimie_ch3_l2': const LessonContent(
      introText:
          'Les fonctions oxygénées sont des composés organiques contenant de l\'oxygène sous forme '
          'de groupes fonctionnels. Les alcools, aldéhydes, cétones et acides carboxyliques '
          'constituent les principales familles de la chimie organique.',
      lessonBody:
          'Les alcools contiennent le groupe hydroxyle -OH lié à un carbone : R-OH. '
          'Classification : primaire (-OH sur C avec 2 H), secondaire (1 H), tertiaire (0 H). '
          'Suffixe -ol (éthanol CH₃CH₂OH, propan-1-ol). Les liaisons hydrogène augmentent '
          'le point d\'ébullition.\n\n'
          'Les aldéhydes contiennent le groupe -CHO en bout de chaîne : R-CHO. '
          'Suffixe -al (méthanal = formaldéhyde HCHO, éthanal = CH₃CHO). '
          'Facilement oxydés en acides carboxyliques.\n\n'
          'Les cétones contiennent le groupe -CO- au milieu : R-CO-R\'. '
          'Suffixe -one (propanone = acétone CH₃COCH₃). Moins oxydables que les aldéhydes.\n\n'
          'Les acides carboxyliques contiennent -COOH : R-COOH. '
          'Suffixe -oïque (acide formique HCOOH, acide acétique CH₃COOH). '
          'Acides faibles : R-COOH ⇌ R-COO⁻ + H⁺.',
      example:
          'Exemple 1 — Reconnaissance :\n'
          'CH₃-OH : alcool (méthanol)\n'
          'CH₃-CHO : aldéhyde (éthanal)\n'
          'CH₃-CO-CH₃ : cétone (propanone)\n'
          'CH₃-COOH : acide (acide éthanoïque)\n\n'
          'Exemple 2 — Oxydation séquentielle :\n'
          'Alcool primaire → Aldéhyde → Acide\n'
          'CH₃CH₂OH → CH₃CHO → CH₃COOH\n\n'
          'Exemple 3 — Points d\'ébullition :\n'
          'Propane (C₃H₈) : -42°C\n'
          'Propan-1-ol (C₃H₇OH) : 97°C (liaisons H)',
      takeaways: [
        'Alcool : R-OH (suffixe -ol)',
        'Aldéhyde : R-CHO (suffixe -al)',
        'Cétone : R-CO-R\' (suffixe -one)',
        'Acide : R-COOH (suffixe -oïque, acide faible)',
        'Liaisons H : augmentent le point d\'ébullition',
      ],
    ),
    'chimie_ch3_l3': const LessonContent(
      introText:
          'Les réactions en chimie organique suivent des mécanismes caractéristiques : substitution, '
          'addition et élimination. Ces trois types couvrent la majorité des transformations '
          'organiques.',
      lessonBody:
          'Substitution : remplacer un atome/groupe par un autre dans une molécule. '
          'Substitution radicalaire : CH₄ + Cl₂ →(UV) CH₃Cl + HCl. '
          'Substitution électrophile aromatique sur le benzène.\n\n'
          'Addition : ajout d\'atomes sur une liaison multiple qui devient simple. '
          'Addition d\'HBr sur le propène : CH₃-CH=CH₂ + HBr → CH₃-CHBr-CH₃ '
          '(règle de Markovnikov : H s\'ajoute au C le plus hydrogéné). '
          'Hydratation : CH₂=CH₂ + H₂O → CH₃CH₂OH (en milieu acide). '
          'Hydrogénation : CH₂=CH₂ + H₂ → CH₃CH₃ (avec Pt ou Pd).\n\n'
          'Élimination : retrait d\'atomes pour former une liaison multiple. '
          'Déshydratation : CH₃CH₂OH →(H₂SO₄, 170°C) CH₂=CH₂ + H₂O. '
          'Déshydrohalogénation : CH₃CHBrCH₃ + OH⁻ → CH₃CH=CH₂ + H₂O + Br⁻.\n\n'
          'Addition et élimination sont des réactions inverses. Le choix des conditions '
          '(température, solvant, catalyseur) détermine le sens dominant.',
      example:
          'Exemple 1 — Substitution :\n'
          'CH₄ + Cl₂ →(UV) CH₃Cl + HCl\n\n'
          'Exemple 2 — Addition (Markovnikov) :\n'
          'CH₃-CH=CH₂ + HBr → CH₃-CHBr-CH₃\n'
          'Le Br s\'ajoute au C le moins hydrogéné (C2).\n\n'
          'Exemple 3 — Déshydratation :\n'
          'CH₃-CH₂-OH →(H₂SO₄) CH₂=CH₂ + H₂O\n'
          'Alcool primaire → alcène + eau.',
      takeaways: [
        'Substitution : remplacement d\'atome/groupe',
        'Addition : sur liaison multiple (HBr, H₂O, H₂)',
        'Élimination : retrait → liaison multiple',
        'Markovnikov : H sur le C le plus hydrogéné',
        'Addition et élimination = réactions inverses',
      ],
    ),
  };

  // ===========================================================================
  // CHIMIE — Chapitre 4 : Cinétique chimique
  // ===========================================================================

  static final Map<String, LessonContent> _chimieCh4 = {
    'chimie_ch4_l1': const LessonContent(
      introText:
          'La cinétique chimique étudie la vitesse des réactions et les facteurs qui l\'influencent. '
          'La loi de vitesse relie la rapidité de réaction aux concentrations des réactifs, '
          'permettant de prédire l\'évolution d\'une réaction dans le temps.',
      lessonBody:
          'La vitesse de réaction v mesure la variation de concentration d\'un réactif ou d\'un produit '
          'par unité de temps : v = -d[R]/dt = +d[P]/dt (en mol/(L·s)). La convention de signe négative '
          'pour les réactifs indique que leur concentration diminue.\n\n'
          'Ordre de réaction par rapport à un réactif : on détermine expérimentalement comment la vitesse '
          'dépend de la concentration. Pour A + B → Produits, la loi de vitesse s\'écrit :\n'
          'v = k × [A]^m × [B]^n\n'
          'où k est la constante de vitesse (dépend de la température), m est l\'ordre par rapport à A, '
          'et n l\'ordre par rapport à B. L\'ordre total est m + n.\n\n'
          'Ordre 0 (m = 0) : v = k, la vitesse est indépendante de la concentration.\n'
          'Ordre 1 (m = 1) : v = k[A], décroissance exponentielle : [A] = [A]₀ × e^{-kt}.\n'
          'Ordre 2 (m = 2) : v = k[A]², équation du second degré pour 1/[A].\n\n'
          'Facteurs cinétiques :\n'
          '- Température : la vitesse double environ tous les 10°C (règle empirique).\n'
          '- Concentration : plus la concentration est élevée, plus les collisions sont fréquentes.\n'
          '- Surface de contact : pour les hétérogènes, une plus grande surface augmente la vitesse.\n'
          '- Nature des réactifs : les réactions entre ions en solution sont très rapides.\n\n'
          'La demi-vie t₁/₂ est le temps nécessaire pour que la concentration diminue de moitié. '
          'Pour un ordre 1 : t₁/₂ = ln(2)/k ≈ 0,693/k.',
      example:
          'Exemple — Ordre 1 :\n'
          'Une réaction de premier ordre avec k = 0,02 min⁻¹.\n'
          'Demi-vie : t₁/₂ = 0,693/0,02 = 34,65 min.\n\n'
          'Concentration après 100 min :\n'
          '[A] = [A]₀ × e^{-0,02 × 100} = [A]₀ × e^{-2} = [A]₀ × 0,135.\n'
          'Il reste 13,5% du réactif initial.',
      takeaways: [
        'v = k[A]^m[B]^n : loi de vitesse',
        'k = constante de vitesse (dépend de T)',
        'Ordre 1 : [A] = [A]₀e^{-kt}, t₁/₂ = 0,693/k',
        'Facteurs : T, concentration, surface, nature',
        'T₁/₂ indépendant de [A]₀ en ordre 1',
      ],
    ),
    'chimie_ch4_l2': const LessonContent(
      introText:
          'La catalyse est le procédé par lequel un catalyseur accélère une réaction chimique '
          'sans être consommé. Il offre un chemin de réaction alternatif à plus faible énergie '
          'd\'activation, modifiant la cinétique mais pas l\'équilibre.',
      lessonBody:
          'Un catalyseur est une substance qui augmente la vitesse d\'une réaction sans être '
          'transformée à la fin de la réaction. Il abaisse l\'énergie d\'activation Ea '
          '(barrière énergétique à franchir pour que la réaction ait lieu) en offrant un '
          'mécanisme alternatif.\n\n'
          'L\'équation d\'Arrhenius relie la constante de vitesse à la température :\n'
          'k = A × e^{-Ea/(RT)}\n'
          'où A est le facteur pré-exponentiel, Ea l\'énergie d\'activation (J/mol), '
          'R = 8,314 J/(mol·K) la constante des gaz parfaits et T la température (K).\n\n'
          'Types de catalyse :\n'
          '- Catalyse homogène : le catalyseur est dans la même phase que les réactifs '
          '(ex : ions en solution).\n'
          '- Catalyse hétérogène : le catalyseur est dans une phase différente '
          '(ex : surface métallique pour des gaz). Le réactif se fixe sur la surface '
          '(adsorption), réagit, puis le produit se désorbe.\n'
          '- Catalyse biologique (enzymatique) : les enzymes sont des protéines qui '
          'catalysent les réactions du métabolisme avec une grande spécificité. Le site '
          'actif de l\'enzyme s\'adapte au substrat (modèle de la serrure et de la clé).\n\n'
          'Le catalyseur ne déplace pas l\'équilibre chimique (il accélère la réaction '
          'directe ET inverse au même titre). Il ne modifie pas les grandeurs d\'état '
          '(ΔH, ΔG, Keq) mais permet d\'atteindre l\'équilibre plus rapidement.',
      example:
          'Exemple — Effet de la température :\n'
          'Ea = 50 kJ/mol = 50 000 J/mol.\n'
          'k(25°C) = A × e^{-50000/(8,314 × 298)} = A × e^{-20,2}\n'
          'k(35°C) = A × e^{-50000/(8,314 × 308)} = A × e^{-19,5}\n\n'
          'Rapport : k(35)/k(25) = e^{0,7} ≈ 2,0.\n'
          'La vitesse double pour une augmentation de 10°C (règle d\'Arrhenius).',
      takeaways: [
        'Catalyseur : accélère sans être consommé',
        'Abaisse l\'énergie d\'activation Ea',
        'k = A × e^{-Ea/(RT)} : équation d\'Arrhenius',
        'Homogène, hétérogène, enzymatique',
        'Ne déplace pas l\'équilibre, accélère seulement',
      ],
    ),
  };

  // ===========================================================================
  // CHIMIE — Chapitre 5 : Thermodynamique chimique
  // ===========================================================================

  static final Map<String, LessonContent> _chimieCh5 = {
    'chimie_ch5_l1': const LessonContent(
      introText:
          'L\'enthalpie de réaction mesure la chaleur échangée lors d\'une réaction chimique à pression '
          'constante. La loi de Hess permet de calculer l\'enthalpie de réactions complexes en combinant '
          'des réactions intermédiaires dont on connaît les données.',
      lessonBody:
          'L\'enthalpie de réaction ΔrH mesure la chaleur échangée entre le système (les réactifs) '
          'et le milieu extérieur lors d\'une réaction à pression constante. '
          'ΔrH < 0 : réaction exothermique (dégagement de chaleur). '
          'ΔrH > 0 : réaction endothermique (absorption de chaleur).\n\n'
          'Enthalpies standard : ΔrH° est mesurée dans des conditions standard (25°C, 1 bar, '
          'concentrations standard 1 mol/L). L\'unité est kJ/mol.\n\n'
          'Loi de Hess : l\'enthalpie de réaction ne dépend que de l\'état initial et final, '
          'pas du chemin suivi. Si une réaction peut s\'effectuer en plusieurs étapes, '
          'l\'enthalpie totale est la somme des enthalpies de chaque étape :\n'
          'ΔrH(réaction globale) = Σ ΔrH(étapes).\n\n'
          'Calcul par enthalpies standard de formation ΔfH° : '
          'ΔrH° = Σ ΔfH°(produits) - Σ ΔfH°(réactifs). '
          'L\'enthalpie standard de formation est la chaleur de formation d\'une substance '
          'à partir de ses éléments dans leur état standard.\n\n'
          'Calorimétrie : l\'expérience de bombe calorimétrique mesure l\'énergie de combustion. '
          'La variation de température de l\'eau environnante permet de calculer l\'énergie dégagée : '
          'Q = m × c × ΔT, où m est la masse d\'eau, c = 4,18 J/(g·K) et ΔT la variation de température.',
      example:
          'Exemple 1 — Réaction exothermique :\n'
          'Combustion du méthane : CH₄ + 2O₂ → CO₂ + 2H₂O\n'
          'ΔrH° = -890 kJ/mol (dégagement de chaleur).\n\n'
          'Exemple 2 — Calcul par Hess :\n'
          'Données :\n'
          '① C + O₂ → CO₂ ; ΔH₁ = -393,5 kJ/mol\n'
          '② H₂ + ½O₂ → H₂O ; ΔH₂ = -285,8 kJ/mol\n'
          '③ CO₂ + H₂O → CH₃OH + 3/2 O₂ ; ΔH₃ = +726,5 kJ/mol\n\n'
          'On cherche : C + 2H₂ + ½O₂ → CH₃OH\n'
          'ΔrH° = ΔH₁ + 2×ΔH₂ + ΔH₃\n'
          '= -393,5 + 2(-285,8) + 726,5 = -238,6 kJ/mol.',
      takeaways: [
        'ΔrH < 0 : exothermique ; ΔrH > 0 : endothermique',
        'Loi de Hess : l\'enthalpie ne dépend que des états initial/final',
        'ΔrH° = Σ ΔfH°(produits) - Σ ΔfH°(réactifs)',
        'Calorimétrie : Q = mcΔT',
        'ΔfH°(éléments dans leur état standard) = 0',
      ],
    ),
    'chimie_ch5_l2': const LessonContent(
      introText:
          'L\'équilibre chimique est l\'état vers lequel tend spontanément un système réactionnel '
          'fermé. La loi d\'action de masse et la constante d\'équilibre Keq permettent de quantifier '
          'la position de l\'équilibre et de prédire les rendements.',
      lessonBody:
          'Une réaction chimique est dite réversible quand elle peut se faire dans les deux sens. '
          'L\'équilibre chimique est atteint quand les vitesses de la réaction directe et inverse '
          'sont égales : v_directe = v_inverse. À l\'équilibre, les concentrations ne changent plus '
          '(mais les réactions continuent au niveau microscopique).\n\n'
          'La loi d\'action de masse (law of mass action) : pour la réaction aA + bB ⇌ cC + dD, '
          'la constante d\'équilibre est :\n'
          'Keq = ([C]^c × [D]^d) / ([A]^a × [B]^b)\n'
          'où les concentrations sont celles mesurées à l\'équilibre. Keq est sans dimension '
          '(activités) et ne dépend que de la température.\n\n'
          'Interprétation de Keq :\n'
          '- Keq >> 1 : l\'équilibre est déplacé vers les produits (réaction quasi complète).\n'
          '- Keq << 1 : l\'équilibre est déplacé vers les réactifs (réaction peu avancée).\n'
          '- Keq ≈ 1 : proportions importantes de réactifs et de produits.\n\n'
          'Principe de Le Chatelier : si un système à l\'équilibre subit une perturbation '
          '(concentration, pression, température), le système évolue dans le sens qui tend '
          'à annuler cette perturbation.\n'
          '- Augmentation de [réactif] → équilibre déplacé vers les produits.\n'
          '- Augmentation de la pression → équilibre vers le côté avec moins de moles de gaz.\n'
          '- Augmentation de la température → déplacement vers le sens endothermique.',
      example:
          'Exemple — Calcul de Keq :\n'
          'N₂ + 3H₂ ⇌ 2NH₃\n'
          'À l\'équilibre à 500°C : [N₂] = 0,5 M, [H₂] = 1,5 M, [NH₃] = 0,8 M.\n\n'
          'Keq = [NH₃]² / ([N₂] × [H₂]³)\n'
          'Keq = 0,8² / (0,5 × 1,5³)\n'
          'Keq = 0,64 / (0,5 × 3,375)\n'
          'Keq = 0,64 / 1,6875 ≈ 0,379\n\n'
          'Keq < 1 : l\'équilibre est plutôt vers les réactifs à cette température.',
      takeaways: [
        'Équilibre : v_directe = v_inverse, concentrations constantes',
        'Keq = [produits]/[réactifs] à l\'équilibre',
        'Keq >> 1 → produits ; Keq << 1 → réactifs',
        'Le Chatelier : le système s\'oppose aux perturbations',
        'Keq ne dépend que de la température',
      ],
    ),
  };

  // ===========================================================================
  // CHIMIE — Chapitre 6 : Chimie des solutions
  // ===========================================================================

  static final Map<String, LessonContent> _chimieCh6 = {
    'chimie_ch6_l1': const LessonContent(
      introText:
          'La solubilité caractérise la capacité d\'une substance à se dissoudre dans un solvant. '
          'Le produit de solubilité Ks permet de prévoir la formation d\'un précipité et '
          'de calculer les concentrations à l\'équilibre de dissolution.',
      lessonBody:
          'Un sel est dit soluble ou insoluble selon sa solubilité s (en g/L ou en mol/L). '
          'La solubilité maximale est la concentration maximale de soluté que l\'on peut dissoudre '
          'dans un solvant à une température donnée. Une solution est dite saturée quand elle contient '
          'la quantité maximale de soluté dissous.\n\n'
          'Le produit de solubilité Ks (ou Kps) caractérise l\'équilibre de dissolution d\'un sel '
          'difficilement soluble. Pour AB(s) ⇌ A⁺(aq) + B⁻(aq) :\n'
          'Ks = [A⁺] × [B⁻]\n'
          'Pour A₂B₃(s) ⇌ 2A³⁺(aq) + 3B²⁻(aq) :\n'
          'Ks = [A³⁺]² × [B²⁻]³\n\n'
          'Le produit d\'ion Ip détermine le sens de la précipitation :\n'
          '- Ip < Ks : la solution est non saturée, pas de précipité.\n'
          '- Ip = Ks : la solution est à saturation, équilibre de dissolution.\n'
          '- Ip > Ks : la solution est sursaturée, précipitation se produit.\n\n'
          'Applications :\n'
          '- Analyse qualitative : identification des ions par précipitation sélective.\n'
          '- Dosage par précipitation : dosage argentométrique (Mohr).\n'
          '- Traitement des eaux : élimination des métaux lourds par précipitation.',
      example:
          'Exemple — Précipitation du chlorure d\'argent :\n'
          'Ks(AgCl) = 1,6 × 10⁻¹⁰ à 25°C.\n\n'
          'On mélange 100 mL de AgNO₃ 0,01 M avec 100 mL de NaCl 0,01 M.\n'
          'Volumes finaux : [Ag⁺] = 0,01/2 = 0,005 M ; [Cl⁻] = 0,01/2 = 0,005 M.\n\n'
          'Ip = [Ag⁺] × [Cl⁻] = 0,005 × 0,005 = 2,5 × 10⁻⁵\n\n'
          'Ip = 2,5 × 10⁻⁵ >> Ks = 1,6 × 10⁻¹⁰.\n'
          'Ip > Ks : il y a précipitation de AgCl blanc.\n\n'
          'Concentration résiduelle à l\'équilibre :\n'
          '[Ag⁺] = [Cl⁻] = √Ks = √(1,6 × 10⁻¹⁰) = 1,26 × 10⁻⁵ M.',
      takeaways: [
        'Ks : constante de solubilité (sel difficilement soluble)',
        'Ip < Ks : pas de précipité ; Ip > Ks : précipitation',
        'Ks = [A⁺]^m × [B⁻]^n à l\'équilibre',
        'Solubilité s = √Ks pour AB (1:1)',
        'Applications : analyse qualitative, dosage, traitement eaux',
      ],
    ),
  };

  // ===========================================================================
  // SVT — Chapitre 1 : Génétique
  // ===========================================================================

  static final Map<String, LessonContent> _svtCh1 = {
    'svt_ch1_l1': const LessonContent(
      introText:
          'L\'ADN (acide désoxyribonucléique) est la molécule porteuse de l\'information génétique '
          'chez tous les êtres vivants. Sa structure en double hélice, découvert par Watson et Crick '
          'en 1953, est l\'une des découvertes les plus importantes du XXe siècle.',
      lessonBody:
          'L\'ADN est un polymère constitué d\'unités appelées nucléotides. Chaque nucléotide est composé '
          'de trois éléments : un groupement phosphate (PO₄³⁻), un sucre à 5 carbones (le désoxyribose) '
          'et une base azotée. Il existe quatre bases azotées dans l\'ADN : l\'adénine (A), la thymine (T), '
          'la cytosine (C) et la guanine (G). On distingue les bases puriques (A et G, structure à deux cycles) '
          'des bases pyrimidiques (T et C, structure à un cycle).\n\n'
          'L\'ADN adopte une structure en double hélice : deux brins d\'ADN s\'enroulent l\'un autour de '
          'l\'autre en hélice droite. Les deux brins sont antiparallèles (sens 5\'→3\' et 3\'→5\'). '
          'Les bases azotées des brins opposés s\'apparient par des liaisons hydrogène selon la règle de '
          'complémentarité : l\'adénine (A) s\'apparie toujours avec la thymine (T) par 2 liaisons hydrogène '
          '(notées A=T), et la cytosine (C) s\'apparie toujours avec la guanine (G) par 3 liaisons '
          'hydrogène (notées C≡G). Cette complémentarité est la base du mécanisme de réplication.\n\n'
          'La réplication de l\'ADN est le processus par lequel une molécule d\'ADN produit deux copies '
          'identiques d\'elle-même. Elle est dite semi-conservative : chaque molécule fille contient un '
          'brin ancien (conservé) et un brin nouveau (synthétisé). Ce mécanisme a été démontré par '
          'Meselson et Stahl en 1958. La réplication a lieu pendant la phase S de l\'interphase, avant '
          'la division cellulaire. L\'enzyme principale est l\'ADN polymérase, qui lit le brin matrice '
          'et synthétise le brin complémentaire dans le sens 5\'→3\'.\n\n'
          'Dans le noyau des cellules eucaryotes, l\'ADN est associé à des protéines appelées histones '
          'pour former la chromatine. L\'ADN s\'enroule autour des histones formant des nucleosomes, '
          'qui s\'agencent en fibre de 30 nm, puis en structures plus compactes. Lors de la division '
          'cellulaire, la chromatine se condense pour former les chromosomes, visibles au microscope. '
          'L\'être humain possède 46 chromosomes (23 paires) contenant environ 3 milliards de paires de bases.',
      example:
          'Exemple — Complémentarité des bases :\n'
          'Si un brin d\'ADN a la séquence : 5\'-ATCGGTAC-3\'\n'
          'Le brin complémentaire est : 3\'-TAGCCATG-5\'\n\n'
          'Appariements :\n'
          'A ↔ T (2 liaisons hydrogène)\n'
          'T ↔ A (2 liaisons hydrogène)\n'
          'C ↔ G (3 liaisons hydrogène)\n'
          'G ↔ C (3 liaisons hydrogène)\n\n'
          'Pourcentage de GC : si une molécule d\'ADN contient 30% de A, alors :\n'
          '%T = %A = 30%\n'
          '%G = %C = (100 - 60)/2 = 20%\n\n'
          'Réplication semi-conservative :\n'
          'Brin ancien 1 : 5\'-ATCGGTAC-3\'\n'
          'Brin ancien 2 : 3\'-TAGCCATG-5\'\n'
          'Après réplication :\n'
          'Molécule 1 : brin ancien 1 + brin nouveau (complémentaire de 1)\n'
          'Molécule 2 : brin ancien 2 + brin nouveau (complémentaire de 2)\n'
          'Chaque molécule fille = 1 brin ancien + 1 brin nouveau. ✓',
      takeaways: [
        'Nucléotide = phosphate + désoxyribose + base (A, T, C ou G)',
        'Double hélice : 2 brins antiparallèles',
        'Complémentarité : A=T (2 liaisons H), C≡G (3 liaisons H)',
        'Réplication semi-conservative : 1 brin ancien + 1 brin nouveau',
        'ADN + histones → chromatine → chromosomes',
      ],
    ),
    'svt_ch1_l2': const LessonContent(
      introText:
          'L\'expression des gènes est le processus par lequel l\'information contenue dans l\'ADN est '
          'utilisée pour synthétiser des protéines fonctionnelles. Ce processus comprend deux grandes '
          'étapes : la transcription (ADN → ARN) et la traduction (ARN → protéine).',
      lessonBody:
          'La transcription est la synthèse d\'un ARN messager (ARNm) à partir d\'un gène de l\'ADN. '
          'Elle est réalisée par l\'enzyme ARN polymérase, qui se fixe sur une région promotrice en amont '
          'du gène. L\'ARN polymérase déroule la double hélice et lit le brin matrice dans le sens 3\'→5\', '
          'synthétisant l\'ARNm dans le sens 5\'→3\'. Les bases sont complémentaires : A de l\'ADN donne U '
          '(uracile) dans l\'ARN, T donne A, C donne G et G donne C. La transcription a lieu dans le noyau '
          'des cellules eucaryotes.\n\n'
          'L\'ARNm est ensuite exporté dans le cytoplasme, où il sera traduit en protéine. Le code génétique '
          'est constitué de codons : chaque triplet de bases successif sur l\'ARNm (3 nucléotides) code pour '
          'un acide aminé spécifique. Le code est dit universel car le même codon code pour le même acide '
          'aminé chez presque tous les êtres vivants. Sur les 64 codons possibles (4³ = 64), 61 codent pour '
          'des acides aminés et 3 sont des codons stop (UAA, UAG, UGA) qui signalent l\'arrêt de la traduction. '
          'Le codon AUG (méthionine) est le codon start (initiation).\n\n'
          'La traduction a lieu sur les ribosomes, situés dans le cytoplasme (ribosomes libres ou fixés sur '
          'le réticulum endoplasmique). L\'ARN de transfert (ARNt) amène les acides aminés au ribosome. '
          'Chaque ARNt porte un anticodon complémentaire du codon de l\'ARNm et l\'acide aminé correspondant. '
          'Le ribosome lit l\'ARNm dans le sens 5\'→3\' et assemble les acides aminés dans l\'ordre codé. '
          'La protéine naissante se replie ensuite en une structure tridimensionnelle fonctionnelle.\n\n'
          'L\'ensemble du processus ADN → ARN → protéine est résumé par la «中心法则 » (dogme central) de '
          'la biologie moléculaire, énoncé par Crick en 1958. Les 20 acides aminés constituant les protéines '
          'sont encodés par les 61 codons sens. La même information génétique (ADN) donne donc naissance à '
          'des protéines différentes selon les types cellulaires et les conditions, par régulation de '
          'l\'expression des gènes.',
      example:
          'Exemple — Transcription et traduction :\n\n'
          'Séquence d\'ADN (brin non-codant, 3\'→5\') :\n'
          '3\'-TAC-GGA-ATT-GCA-5\'\n\n'
          'Transcription (ARNm, 5\'→3\') :\n'
          '5\'-AUG-CCU-UUA-CGU-3\'\n\n'
          'Traduction (codon par codon) :\n'
          'AUG → Méthionine (Met) — codon start\n'
          'CCU → Proline (Pro)\n'
          'UUA → Leucine (Leu)\n'
          'CGU → Arginine (Arg)\n\n'
          'Protéine résultante :\n'
          'Met - Pro - Leu - Arg\n\n'
          'Tableau des codons principaux :\n'
          'UUU, UUC → Phénylalanine\n'
          'AUG → Méthionine (start)\n'
          'UAA, UAG, UGA → STOP\n'
          'GGU, GGC, GGA, GGG → Glycine',
      takeaways: [
        'Transcription : ADN → ARNm (dans le noyau, par ARN polymérase)',
        'Traduction : ARNm → protéine (ribosomes, dans le cytoplasme)',
        'Codon = triplet de bases sur l\'ARNm (64 codons = 61 AA + 3 STOP)',
        'Code génétique universel, non redondant, dégénéré',
        'Dogme central : ADN → ARN → Protéine',
      ],
    ),
    'svt_ch1_l3': const LessonContent(
      introText:
          'Les mutations et le brassage génétique sont les deux sources de diversité génétique. '
          'Les mutations créent de nouvelles allèles, tandis que le brassage génétique lors de la méiose '
          'génère de nouvelles combinaisons d\'allèles sur les chromosomes.',
      lessonBody:
          'Une mutation est une modification de la séquence de nucléotides de l\'ADN. Les mutations ponctuelles '
          'concernent un ou quelques nucléotides et comprennent : la substitution (remplacement d\'une base '
          'par une autre), l\'insertion (ajout d\'une ou plusieurs bases) et la délétion (perte d\'une ou '
          'plusieurs bases). Les mutations par insertion ou délétion entraînent un décalage du cadre de '
          'lecture (frameshift), modifiant tous les codons en aval. Les substitutions peuvent être silencieuses '
          '(même acide aminé grâce à la dégénérescence du code) ou missense (acide aminé différent).\n\n'
          'La méiose est la division cellulaire spécifique à la formation des cellules reproductrices '
          '(gamètes). Elle comporte deux divisions successives à partir d\'une cellule diploïde (2n). '
          'La première division méiotique (M1) sépare les chromosomes homologues : chaque cellule fille '
          'reçoit un chromosome de chaque paire (n chromosomes en double chromatide). La deuxième division '
          'méiotique (M2) sépare les chromatides sœurs, donnant 4 cellules haploïdes (n).\n\n'
          'Le brassage génétique a lieu lors de la méiose et génère de la diversité génétique. Il existe '
          'deux types de brassage. Le brassage intrachromosomique (crossing-over) se produit en prophase I '
          'de M1 : des fragments non chromatiques de chromatides non sœurs d\'une même paire de chromosomes '
          'homologues s\'échangent. Cela crée de nouvelles combinaisons d\'allèles sur un même chromosome. '
          'Le brassage interchromosomique (indépendance chromosomique) se produit en anaphase I : la '
          'répartition des chromosomes homologues dans les cellules filles est aléatoire. Comme chaque '
          'paire se répartit indépendamment, cela multiplie les combinaisons possibles.\n\n'
          'Pour un organisme possédant n paires de chromosomes, le nombre de combinaisons possibles par '
          'brassage interchromosomique est 2ⁿ. Chez l\'homme (n = 23), cela donne plus de 8 millions '
          'de combinaisons possibles. Le crossing-over augmente encore cette diversité en créant des '
          'chromosomes recombinés. C\'est pourquoi les frères et sœurs (hors jumeaux identiques) ne sont '
          'jamais génétiquement identiques.',
      example:
          'Exemple 1 — Types de mutations :\n'
          'Séquence normale : AUG-CCU-GAA-UAC (Met-Pro-Glu-Tyr)\n\n'
          'Substitution : AUG-CCU-GCA-UAC (Met-Pro-Ala-Tyr)\n'
          'Le codon GAA → GCA change l\'acide aminé (mutation missense).\n\n'
          'Insertion : AUG-CCU-GAU-AAU-AC... (décalage du cadre de lecture)\n'
          'Tous les codons après l\'insertion sont modifiés → protéine non fonctionnelle.\n\n'
          'Délétion : AUG-CCU-AUA-C... (décalage du cadre de lecture)\n\n'
          'Exemple 2 — Crossing-over :\n'
          'Chromosome maternel : A B c D\n'
          'Chromosome paternel : a b C d\n'
          'Après crossing-over entre B et C :\n'
          'Chromosome recombiné 1 : A B C d\n'
          'Chromosome recombiné 2 : a b c D\n\n'
          'Exemple 3 — Brassage interchromosomique :\n'
          'Cellule 2n avec 2 paires de chromosomes.\n'
          'Nombre de combinaisons : 2² = 4.\n'
          'Pour n = 23 paires (humain) : 2²³ = 8 388 608 combinaisons.',
      takeaways: [
        'Mutation = modification de la séquence d\'ADN',
        'Substitution, insertion, délétion',
        'Méiose : 2 divisions → 4 cellules haploïdes (n)',
        'Crossing-over : échange de fragments entre chromatides non sœurs',
        'Brassage interchromosomique : 2ⁿ combinaisons possibles',
      ],
    ),
    'svt_ch1_l4': const LessonContent(
      introText:
          'L\'hérédité humaine étudie la transmission des caractères héréditaires des parents aux enfants. '
          'L\'étude des arbres généalogiques permet de déterminer le mode de transmission d\'un caractère '
          'et de prédire le risque pour les enfants d\'hériter d\'une maladie génétique.',
      lessonBody:
          'Les caractères héréditaires sont déterminés par des gènes situés sur les chromosomes. '
          'Chaque individu possède deux allèles pour chaque gène (un hérité de chaque parent). '
          'On distingue les allèles dominants (s\'expriment même en un seul exemplaire, notés en majuscules) '
          'et les allèles récessifs (nécessitent deux exemplaires pour s\'exprimer, notés en minuscules). '
          'Un individu est homozygote quand il possède deux allèles identiques (AA ou aa) et hétérozygote '
          'quand il possède deux allèles différents (Aa).\n\n'
          'La transmission autosomique dominante caractérise les caractères dont l\'allèle maladie (noté A) '
          'est dominant. Un seul exemplaire suffit pour être atteint. Les individus AA et Aa sont atteints, '
          'seuls les aa sont sains. Un parent atteint hétérozygote (Aa) a 50% de chances de transmettre '
          'l\'allèle maladie à chacun de ses enfants. La maladie ne saute jamais une génération : un enfant '
          'atteint a toujours au moins un parent atteint.\n\n'
          'La transmission autosomique récessive caractérise les caractères dont l\'allèle maladie (noté a) '
          'est récessif. Seuls les individus aa sont atteints. Les porteurs sains (Aa) ne présentent pas '
          'la maladie mais peuvent la transmettre. Un enfant atteint (aa) a pour parents deux porteurs sains '
          '(Aa × Aa). La maladie peut sauter des générations : deux parents sains peuvent avoir un enfant atteint.\n\n'
          'La drépanocytose (anémie falciforme) est une maladie génétique autosomique récessive fréquente '
          'en Afrique subsaharienne. L\'allèle maladie (HbS) code pour une hémoglobine anormale. Les individus '
          'HbSHbS sont atteints (drépanocytaires), les HbAHbS sont porteurs sains (drépanocytaires mineurs), '
          'et les HbAHbA sont sains. La mucoviscidose est une autre maladie autosomique récessive, touchant '
          'principalement les populations d\'origine européenne. Elle affecte les sécrétions muqueuses.\n\n'
          'Pour construire un arbre généalogique, on utilise des symboles conventionnels : carrés pour les '
          'hommes, ronds pour les femmes, symboles remplis pour les individus atteints. L\'analyse de '
          'l\'arbre permet de déterminer si le caractère est dominant ou récessif, et s\'il est lié au sexe '
          'ou autosomique.',
      example:
          'Exemple — Drépanocytose (autosomique récessive) :\n\n'
          'Génération I :\n'
          'Père : HbAHbA (sain) × Mère : HbAHbA (saine)\n'
          '→ Tous les enfants sont HbAHbA (sains)\n\n'
          'Génération II :\n'
          'Père : HbAHbA (sain) × Mère : HbAHbS (porteuse)\n'
          '→ 50% HbAHbA (sains) et 50% HbAHbS (porteurs)\n\n'
          'Génération III :\n'
          'Si deux porteurs HbAHbA × HbAHbA se reproduisent :\n'
          '→ Tous HbAHbA (sains)\n\n'
          'Si deux porteurs HbAHbS × HbAHbS se reproduisent :\n'
          '→ 25% HbAHbA (sains)\n'
          '→ 50% HbAHbS (porteurs sains)\n'
          '→ 25% HbSHbS (atteints)\n\n'
          'Arbre généalogique :\n'
          'Generation I:   ○(I-1) —— □(I-2)\n'
          '                     |\n'
          'Generation II:  □(II-1) —— ○(II-2) [porteur]\n'
          '                    |          |\n'
          'Generation III: ○(III-1)  ○(III-2) [atteint]\n\n'
          'Conclusion : Si deux parents sains ont un enfant atteint, le caractère est récessif.',
      takeaways: [
        'Allèle dominant (A) = s\'exprime en un seul exemplaire',
        'Allèle récessif (a) = nécessite deux exemplaires',
        'Autosomique dominante : maladie ne saute jamais une génération',
        'Autosomique récessive : maladie peut sauter des générations',
        'Drépanocytose = autosomique récessive (HbS = allèle maladie)',
      ],
    ),
  };

  // ===========================================================================
  // SVT — Chapitre 2 : Immunologie
  // ===========================================================================

  static final Map<String, LessonContent> _svtCh2 = {
    'svt_ch2_l1': const LessonContent(
      introText:
          'Le système immunitaire protège l\'organisme contre les agents pathogènes. L\'immunité innée '
          'est la première ligne de défense, non spécifique, présente dès la naissance. Elle comprend '
          'des barrières physiques, chimiques et cellulaires.',
      lessonBody:
          'Barrières physiques : la peau (épithélium kératinisé) constitue une barrière mécanique '
          'imperméable. Les muqueuses (voies respiratoires, digestives, urogénitales) produisent du '
          'mucus qui piège les micro-organismes. Les cils vibrants des voies aériennes évacuent les '
          'particules étrangères (escalier muco-ciliaire). Les larmes, la salive et l\'urine assurent '
          'un lavage mécanique.\n\n'
          'Barrières chimiques : le suc gastrique (pH ≈ 2) détruit la plupart des microbes. Le lysozyme '
          'présent dans les larmes et la salive dégrade la paroi bactérienne. Les acides gras de la peau '
          'ont un effet antibactérien. Le mucus contient des IgA (immunoglobulines A) qui neutralisent '
          'les pathogènes.\n\n'
          'Phagocytose : les phagocytes (macrophages, polynucléaires neutrophiles) ingèrent et détruisent '
          'les micro-organismes. Le macrophage reconnaît le pathogène via des récepteurs de reconnaissance '
          'de motifs moléculaires (PAMP). Il l\'avale dans une vacuole (phagosome) qui fusionne avec un '
          'lysosome. Les enzymes lysosomales détruisent le pathogène.\n\n'
          'Inflammation : réponse locale à une agression (blessure, infection). Elle se caractérise par '
          'rougeur, chaleur, gonflement et douleur. Les médiateurs chimiques (histamine, prostaglandines) '
          'dilateront les vaisseaux sanguins, augmentent la perméabilité capillaire et attirent les '
          'leucocytes au site infecté.',
      example:
          'Exemple — Phagocytose :\n'
          '1) Bactérie pénètre par une coupure de la peau.\n'
          '2) Macrophage reconnaît les PAMP de la bactérie.\n'
          '3) Le macrophage étend ses prolongements et avale la bactérie.\n'
          '4) La bactérie est enclosed dans un phagosome.\n'
          '5) Phagosome + lysosome = phagolysosome.\n'
          '6) Enzymes détruisent la bactérie.\n'
          '7) Le macrophage présente des antigènes à l\'immunité adaptative.',
      takeaways: [
        'Immunité innée : non spécifique, présente dès la naissance',
        'Barrières physiques : peau, muqueuses, mucus',
        'Phagocytose : macrophages et neutrophiles ingèrent les pathogènes',
        'Inflammation : réponse locale (rougeur, chaleur, gonflement, douleur)',
        'Lien avec adaptative : présentation d\'antigènes',
      ],
    ),
    'svt_ch2_l2': const LessonContent(
      introText:
          'L\'immunité adaptative est spécifique et dotée de mémoire. Les lymphocytes B produisent '
          'des anticorps (immunité humorale), tandis que les lymphocytes T détruisent les cellules '
          'infectées (immunité cellulaire).',
      lessonBody:
          'L\'immunité adaptative est spécifique (reconnaît un antigène précis), systémique (agit '
          'dans tout l\'organisme) et dotée de mémoire (réponse plus rapide lors d\'une seconde exposition).\n\n'
          'Lymphocytes B : produits dans la moelle osseuse. Chaque lymphocyte B porte à sa surface '
          'un récepteur (immunoglobuline) spécifique d\'un antigène. Lors de la rencontre avec l\'antigène, '
          'le lymphocyte B s\'active et se différencie en plasmocyte (produit des anticorps) et en '
          'lymphocyte B mémoire.\n\n'
          'Anticorps (immunoglobulines) : protéines en forme de Y qui se fixent spécifiquement sur '
          'l\'antigène (épitope). Types : IgG (sang, traversent le placenta), IgM (première réponse), '
          'IgA (sécrétions : lait, salive, larmes), IgE (allergies, parasites), IgD (récepteur B).\n'
          'Mécanismes d\'action des anticorps : neutralisation, opsonisation (facilite la phagocytose), '
          'activation du complément, agglutination.\n\n'
          'Lymphocytes T : produits dans le thymus. Reconnaissent les antigènes présentés par les '
          'molécules du CMH (Complexe Majeur d\'Histocompatibilité) à la surface des cellules. '
          'Lymphocytes T helper (CD4) : coordonnent la réponse immunitaire en activant les lymphocytes B '
          'et les T cytotoxiques. Lymphocytes T cytotoxiques (CD8) : détruisent les cellules infectées '
          'ou cancéreuses.\n\n'
          'Réponse primaire : première exposition à l\'antigène. Délai de 5-10 jours avant la production '
          'd\'anticorps. Dominance d\'IgM puis IgG. Réponse secondaire : re-exposition. Mémoire immunologique '
          '→ réponse plus rapide (1-3 jours), plus intense et plus longue. Dominance d\'IgG.',
      example:
          'Exemple — Réponse immunitaire primaire vs secondaire :\n\n'
          '1ère infection par le virus X :\n'
          '- J0 : contamination\n'
          '- J5-7 : début de la réponse (IgM)\n'
          '- J10-14 : pic d\'anticorps IgG\n'
          '- Après : diminution, mais cellules mémoire persistent\n\n'
          '2ème infection par le virus X :\n'
          '- J0 : contamination\n'
          '- J1-3 : réponse rapide (IgG déjà présentes)\n'
          '- Pic plus élevé et plus précoce\n'
          '- Moins de symptômes (voire aucun)',
      takeaways: [
        'Spécifique, systémique, dotée de mémoire',
        'Lymphocytes B → plasmocytes → anticorps (humorale)',
        'Lymphocytes T helper (CD4) et cytotoxiques (CD8)',
        'Réponse secondaire plus rapide grâce à la mémoire',
        'IgG (sang), IgM (1ère réponse), IgA (sécrétions)',
      ],
    ),
    'svt_ch2_l3': const LessonContent(
      introText:
          'La vaccination et la sérothérapie sont des méthodes de prophylaxie qui exploitent les '
          'mécanismes de l\'immunité adaptative pour protéger contre les maladies infectieuses. '
          'La vaccination stimulation la mémoire immunitaire, la sérothérapie apporte des anticorps.',
      lessonBody:
          'Vaccination : principe d\'inoculer un antigène inactivé ou atténué (le vaccin) pour stimuler '
          'la réponse immunitaire sans provoquer la maladie. Le vaccin contient des antigènes (protéines '
          'de la surface du pathogène) qui activent les lymphocytes B et T. L\'organisme produit des '
          'anticorps et, surtout, des lymphocytes mémoire. En cas de contamination ultérieure, la réponse '
          'secondaire est rapide et efficace.\n\n'
          'Types de vaccins :\n'
          '- Inactivé (mort) : virus/bactérie tués (ex : vaccin antigrippal)\n'
          '- Atténué (vivant affaibli) : pathogène vivant dont la virulence est réduite (ex : rougeole)\n'
          '- Sous-unitaire : protéines purifiées du pathogène (ex : vaccin hépatite B)\n'
          '- ARN messager : code pour une protéine antigénique du pathogène (ex : vaccins COVID-19)\n\n'
          'Vaccination obligatoire : dans de nombreux pays, certains vaccins sont obligatoires pour '
          'l\'entrée à l\'école ou pour voyager. Le calendrier vaccinal définit les âges de vaccination.\n\n'
          'Sérothérapie : administration d\'anticorps monoclonaux ou de sérum immunitaire (contenant '
          'des anticorps) pour traiter une infection en cours. On injecte des anticorps anti-venin '
          '(piqûre de serpent), anti-toxine (tétanos, botulisme). La protection est immédiate mais '
          'temporaire (les anticorps injectés sont éliminés en quelques semaines). Contrairement à la '
          'vaccination, la sérothérapie ne crée pas de mémoire immunitaire.',
      example:
          'Exemple — Vaccination contre la variole :\n'
          '- Le vaccin de Jenner (1796) utilisait le virus de la vaccine (similaire mais inoffensif)\n'
          '- Stimulation croisée : les anticorps anti-vaccine protègent aussi contre la variole\n'
          '- Campagne mondiale d\'éradication (OMS, 1967-1980)\n'
          '- Variole déclarée éradiquée en 1980\n\n'
          'Exemple — Sérothérapie anti-venin :\n'
          '- Piqûure de viperidé → injection d\'anticorps anti-venin\n'
          '- Protection immédiate (les anticorps neutralisent le venin)\n'
          '- Pas de mémoire : risque de réinfection si nouvelle piqûure',
      takeaways: [
        'Vaccin : antigène inactivé/atténué → mémoire immunitaire',
        'Types : inactivé, atténué, sous-unitaire, ARNm',
        'Sérothérapie : injection d\'anticorps (protection immédiate)',
        'Vaccination = mémoire durable ; sérothérapie = temporaire',
        'Éradication possible par vaccination de masse',
      ],
    ),
  };

  // ===========================================================================
  // SVT — Chapitre 3 : Écologie
  // ===========================================================================

  static final Map<String, LessonContent> _svtCh3 = {
    'svt_ch3_l1': const LessonContent(
      introText:
          'Un écosystème est un ensemble d\'êtres vivants (biocénose) et de leur milieu de vie '
          '(biotope) en interaction. L\'étude des facteurs biotiques et abiotiques permet de comprendre '
          'la structure et le fonctionnement des écosystèmes.',
      lessonBody:
          'Biotope (facteurs abiotiques) : ensemble des facteurs physico-chimiques du milieu. '
          'Lumière : détermine la répartition des organismes photosynthétiques (zone euphotique). '
          'Température : influence le métabolisme et la répartition géographique. Eau : facteur limitant '
          'dans les milieux arides. pH du sol : influence la biodiversité végétale. Nutriments minéraux '
          '(N, P, K) : disponibles dans le sol ou l\'eau.\n\n'
          'Biocénose (facteurs biotiques) : ensemble des organismes vivants d\'un écosystème. '
          'Les interactions interspecifiques comprennent :\n'
          '- Compétition : deux espèces se disputent une ressource commune.\n'
          '- Prédation : un organisme (prédateur) consomme un autre (proie).\n'
          '- Parasitisme : le parasite vit au détriment de l\'hôte.\n'
          '- Mutualisme : les deux espèces bénéficient de l\'association.\n'
          '- Commensalisme : une espèce bénéficie sans nuire ni aider l\'autre.\n\n'
          'Niveaux trophiques : chaque organisme occupe un ou plusieurs niveaux trophiques. '
          'Producteurs (autotrophes : plantes, algues) → Consommateurs primaires (herbivores) → '
          'Consommateurs secondaires (carnivores) → Décomposeurs (champignons, bactéries). '
          'Chaîne alimentaire : parcours d\'un aliment dans l\'écosystème. Réseau alimentaire : '
          'ensemble des chaînes alimentaires d\'un écosystème.',
      example:
          'Exemple — Interactions dans une forêt :\n'
          '- Compétition : deux espèces d\'arbres pour la lumière\n'
          '- Prédation : hibou consomme des rongeurs\n'
          '- Parasitisme : vers intestinaux chez un cerf\n'
          '- Mutualisme : champignons mycorhiziens + racines d\'arbres\n'
          '- Commensalisme : oiseaux nichant dans un arbre sans le nuire',
      takeaways: [
        'Biotope (abiotique) + Biocénose (biotique) = Écosystème',
        'Facteurs abiotiques : lumière, température, eau, pH, nutriments',
        'Interactions : compétition, prédation, parasitisme, mutualisme',
        'Chaîne alimentaire : producteurs → consommateurs → décomposeurs',
        'Réseau alimentaire : ensemble des chaînes croisées',
      ],
    ),
    'svt_ch3_l2': const LessonContent(
      introText:
          'Les flux d\'énergie et les cycles de la matière assurent le fonctionnement des écosystèmes. '
          'La photosynthèse et la respiration sont les deux processus complémentaires qui régissent '
          'la production de biomasse et le recyclage de la matière.',
      lessonBody:
          'Flux d\'énergie : l\'énergie solaire est captée par les producteurs (photosynthèse). '
          'À chaque étape trophique, seule une fraction de l\'énergie est transférée (rendement ≈ 10%). '
          'La pyramide des biomasses montre la diminution de la biomasse à chaque niveau trophique. '
          'L\'énergie circule (irréversible), tandis que la matière se recycle.\n\n'
          'Photosynthèse : processus par lequel les organismes autotrophes transforment l\'énergie '
          'lumineuse en énergie chimique. Équation globale :\n'
          '6CO₂ + 6H₂O + énergie lumineuse → C₆H₁₂O₆ + 6O₂\n\n'
          'Deux étapes :\n'
          '- Phase photochimique (dans les thylakoïdes) : captation de la lumière par les pigments '
          '(chlorophylle), décomposition de l\'eau (photolyse), production d\'ATP et NADPH, libération d\'O₂.\n'
          '- Phase obscure / Cycle de Calvin (stroma) : fixation du CO₂ par la rubisco, réduction '
          'en glucose. Les 3 phosphoglycérate (3PG) → Glycéraldéhyde-3-phosphate (G3P) → glucose.\n\n'
          'Respiration cellulaire : processus de dégradation du glucose pour produire de l\'ATP. '
          'Équation globale :\n'
          'C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + ATP\n\n'
          'Trois étapes :\n'
          '- Glycolyse (cytoplasme) : glucose → 2 pyruvates, 2 ATP nets.\n'
          '- Cycle de Krebs (matrice mitochondriale) : oxydation des acétyl-CoA, CO₂ produit.\n'
          '- Chaîne respiratoire (membrane intérieure mitochondriale) : transfert d\'électrons, '
          'production massive d\'ATP (≈ 34 ATP) grâce à la phosphorylation oxidative.',
      example:
          'Exemple — Bilan énergétique :\n'
          'Photosynthèse : 6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂\n'
          'Respiration : C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + ~38 ATP\n\n'
          'Rendement trophique :\n'
          'Producteurs : 100% de l\'énergie captée\n'
          'Herbivores : ~10% (90% perdu en chaleur)\n'
          'Carnivores : ~1%\n'
          '→ Pyramide des biomasses : biomasse décroissante vers le haut',
      takeaways: [
        'Photosynthèse : CO₂ + H₂O → glucose + O₂ (énergie lumineuse)',
        'Respiration : glucose + O₂ → CO₂ + H₂O + ATP',
        'Énergie circule, matière se recycle',
        'Rendement trophique ≈ 10% à chaque niveau',
        'Phase photochimique (thylakoïdes) + Cycle de Calvin (stroma)',
      ],
    ),
    'svt_ch3_l3': const LessonContent(
      introText:
          'La dynamique des populations étudie l\'évolution du nombre d\'individus d\'une espèce '
          'dans un écosystème. Les modèles de croissance et les facteurs de régulation permettent '
          'de comprendre les variations démographiques.',
      lessonBody:
          'Croissance exponentielle : dans des conditions idéales (ressources illimitées), la population '
          'croît exponentiellement : N(t) = N₀ × e^{rt}, où N₀ est l\'effectif initial et r le taux '
          'intrinsèque de croissance (r = taux de natalité - taux de mortalité). Cette croissance '
          'ne se maintient que temporairement.\n\n'
          'Modèle logistique : en milieu limité, la croissance suit une courbe en S (sigmoïde). '
          'La population croît rapidement puis se stabilise quand elle atteint la capacité '
          'du milieu (K, ou « carrying capacity ») :\n'
          'dN/dt = r × N × (1 - N/K)\n'
          'À N = K/2, la croissance est maximale. À N = K, la croissance est nulle.\n\n'
          'Facteurs de régulation :\n'
          '- Densodépendants : dépendent de la densité de population (compétition, prédation, '
          'maladies). Ils maintiennent la population autour de K.\n'
          '- Densoindépendants : indépendants de la densité (catastrophes naturelles, conditions '
          'météorologiques extrêmes). Ils causent des fluctuations imprévisibles.\n\n'
          'Interactions interspécifiques :\n'
          '- Prédation proie-prédateur : modèles de Lotka-Volterra prédisent des oscillations '
          'décroissantes des populations.\n'
          '- Compétition interspécifique : le principe d\'exclusion de Gause stipule que deux espèces '
          'ne peuvent occuper la même niche écologique indéfiniment.\n\n'
          'Biodiversité : diversité des espèces, des gènes et des écosystèmes. Menaces : '
          'destruction d\'habitats, pollution, changement climatique, espèces invasives.',
      example:
          'Exemple — Modèle logistique :\n'
          'K = 1000 individus, r = 0,5, N₀ = 100.\n\n'
          'N(t) = K / (1 + ((K-N₀)/N₀) × e^{-rt})\n\n'
          't=0 : N = 1000/(1+9×1) = 100 ✓\n'
          't=5 : N = 1000/(1+9×e^{-2,5}) = 1000/(1+9×0,082) = 1000/1,738 ≈ 575\n'
          't=10 : N = 1000/(1+9×e^{-5}) = 1000/(1+9×0,0067) = 1000/1,06 ≈ 943\n'
          't→∞ : N → 1000 = K.',
      takeaways: [
        'Exponentielle : N = N₀e^{rt} (ressources illimitées)',
        'Logistique : stabilisation à N = K (capacité du milieu)',
        'Facteurs densodépendants vs densoindépendants',
        'Lotka-Volterra : oscillations proies-prédateurs',
        'Biodiversité menacée par activités humaines',
      ],
    ),
  };

  // ===========================================================================
  // SVT — Chapitre 4 : Géologie
  // ===========================================================================

  static final Map<String, LessonContent> _svtCh4 = {
    'svt_ch4_l1': const LessonContent(
      introText:
          'La structure interne de la Terre est composée de plusieurs couches concentriques : '
          'la croûte, le manteau et le noyau. Chaque couche possède des propriétés physiques '
          'et chimiques spécifiques qui déterminent la géodynamique terrestre.',
      lessonBody:
          'La croûte terrestre est la couche superficielle, solide, de 5 à 70 km d\'épaisseur. '
          'Croûte continentale (30-70 km, granitique, densité ≈ 2,7) et croûte océanique (5-10 km, '
          'basaltique, densité ≈ 3,0). La frontière avec le manteau est la discontinuité de Mohorovičić '
          '(Moho), découverte par sismologie.\n\n'
          'Le manteau s\'étend de la Moho jusqu\'à 2 890 km de profondeur. Composé de roches '
          'ultramafiques (péridotite). Le manteau supérieur (jusqu\'à 400 km) contient l\'asthénosphère, '
          'une zone partiellement fondue sur laquelle « glissent » les plaques lithosphériques. '
          'La lithosphère (croûte + manteau supérieur rigide) forme les plaques tectoniques.\n\n'
          'Le noyau extérieur (2 890 - 5 150 km) est liquide (fer-nickel). Son mouvement de convection '
          'génère le champ magnétique terrestre (dynamo terrestre). Le noyau intérieur (5 150 - 6 371 km) '
          'est solide (fer-nickel, pression extrême).\n\n'
          'Méthodes d\'étude :\n'
          '- Sismologie : les ondes sismiques (P et S) se propagent différemment selon les milieux. '
          'Les ondes S ne traversent pas les milieux liquides → preuve du noyau extérieur liquide.\n'
          '- Volcanisme : échantillons directs du manteau (xénolithes).\n'
          '- Potassium-argon : datation des roches volcaniques.\n'
          '- Gravimétrie : variations de densité du sous-sol.',
      example:
          'Exemple — Zones terrestres :\n'
          'Couche : Croûte\n'
          '  Profondeur : 0 - 30 km (continentale)\n'
          '  État : solide, granitique\n'
          '  Température : ≈ 500°C\n\n'
          'Couche : Manteau supérieur\n'
          '  Profondeur : 30 - 400 km\n'
          '  État : solide rigide (lithosphère) / partiellement fondu (asthénosphère)\n\n'
          'Couche : Noyau extérieur\n'
          '  Profondeur : 2 890 - 5 150 km\n'
          '  État : LIQUIDE (fer-nickel)\n'
          '  Rôle : champ magnétique\n\n'
          'Couche : Noyau intérieur\n'
          '  Profondeur : 5 150 - 6 371 km\n'
          '  État : SOLIDE (pression extrême)',
      takeaways: [
        'Croûte : 5-70 km, granitique (continentale) / basaltique (océanique)',
        'Manteau : péridotite, asthénosphère partiellement fondue',
        'Noyau extérieur LIQUIDE → champ magnétique (dynamo)',
        'Noyau intérieur SOLIDE (pression extrême)',
        'Ondes S ne traversent pas les liquides → preuve du noyau liquide',
      ],
    ),
    'svt_ch4_l2': const LessonContent(
      introText:
          'La tectonique des plaques est la théorie qui explique les mouvements de la lithosphère '
          'terrestre. Les interactions entre les plaques aux limites divergentes, convergentes '
          'et transformantes produisent la plupart des phénomènes géologiques majeurs.',
      lessonBody:
          'La lithosphère est fragmentée en une dizaine de plaques tectoniques majeures et plusieurs '
          'plaques secondaires. Ces plaques « flottent » sur l\'asthénosphère et se déplacent de '
          'quelques cm/an sous l\'effet des courants de convection du manteau.\n\n'
          'Limites divergentes (de rift) : les plaques s\'écartent. Le manteau remonte, fond partiellement, '
          'et nouvelle croûte océanique se forme (dorsale médio-océanique). Exemple : dorsale médio-Atlantique. '
          'Vitesse : 2-10 cm/an. Phénomènes : volcans, séismes faibles, magnets.\n\n'
          'Limites convergentes (de subduction) : une plaque plonge sous l\'autre dans le manteau. '
          'Trois cas :\n'
          '- Océanique-continentale : la plaque océanique (plus dense) plonge sous la continentale. '
          'Formation d\'un arc volcanique et d\'une fosse océanique (Andes, Pacifique).\n'
          '- Océanique-océanique : la plaque plus ancienne plonge sous la plus jeune. Arc insulaire '
          '(Japon, Philippines).\n'
          '- Continentale-continentale : collision, formation de chaînes de montagnes (Himalaya).\n\n'
          'Limites transformantes : les plaques glissent l\'une par rapport à l\'autre. '
          'Pas de création ni destruction de croûte. Séismes fréquents (faille de San Andreas).\n\n'
          'Cycle de Wilson : décrit l\'ouverture et la fermeture des bassins océaniques (cycle complet '
          'de ≈ 500 millions d\'années).',
      example:
          'Exemple — Limites de plaques :\n'
          'Dorsale atlantique : Amérique du Sud s\'éloigne de l\'Afrique ≈ 2,5 cm/an.\n\n'
          'Subduction pacifique : plaque Nazca sous l\'Amérique du Sud → Andes.\n\n'
          'Collision : Inde s\'éloigne de 5 cm/an vers l\'Asie → Himalaya (plus de 8 000 m).\n\n'
          'Faille transformante : faille de San Andreas (Californie), décalage ≈ 3,5 cm/an.',
      takeaways: [
        'Divergente : plaques s\'écartent, dorsale, croûte nouvelle',
        'Convergente : subduction ou collision, volcanisme, montagnes',
        'Transformante : glissement latéral, séismes, pas de croûte nouvelle',
        'Courants de convection du manteau = moteur des plaques',
        'Cycle de Wilson : ouverture/fermeture des océans',
      ],
    ),
    'svt_ch4_l3': const LessonContent(
      introText:
          'Les roches et les minéraux constituent la croûte terrestre. Le cycle des roches décrit '
          'les transformations continues entre les trois types de roches : magmatiques, sédimentaires '
          'et métamorphiques, sous l\'effet des forces internes et externes de la Terre.',
      lessonBody:
          'Minéraux : substances cristallines inorganiques de composition chimique définie. Exemples : '
          'quartz (SiO₂), feldspath, mica, calcite (CaCO₃), pyrite (FeS₂). Classés par dureté '
          '(échelle de Mohs : talc 1, diamant 10), densité, éclat, clivage.\n\n'
          'Roches magmatiques : formation par refroidissement du magma/lave. '
          'Intrusives (plutoniques) : refroidissement lent en profondeur, gros cristaux (granite). '
          'Extrusives (vulcaniennes) : refroidissement rapide en surface, cristaux fins (basalte, andésite). '
          'Composition : felsique (riche en Si, claire) vs mafique (pauvre en Si, foncée).\n\n'
          'Roches sédimentaires : formation par accumulation et cementation de sédiments. '
          'Détritiques (grès, argile : fragments de roches préexistantes). Chimiques (calcaire, halite : '
          'précipitation chimique). Biochimiques (calcaire récifal, craie : squelettes d\'organismes). '
          'Stratification et fossilisation sont caractéristiques.\n\n'
          'Roches métamorphiques : transformation de roches préexistantes par la chaleur, la pression '
          'et les fluides chimiques. Exemples : marbre (calcaire métamorphique), quartzite (grès), '
          'gneiss (granite), schiste (argile). Peuvent être foliées (schisteux) ou non foliées.\n\n'
          'Cycle des roches : le magma se refroidit → roche magmatique → altération/érosion → '
          'sédiments → compaction/cementation → roche sédimentaire → enfouissement/chaleur/pression → '
          'roche métamorphique → fusion → nouveau magma. Ce cycle est continu et sans début ni fin.',
      example:
          'Exemple — Transformation du granite :\n'
          '1) Granite (roche magmatique intrusive)\n'
          '2) Érosion → sédiments (grains de quartz, feldspath)\n'
          '3) Compaction → grès (roche sédimentaire)\n'
          '4) Enfouissement + pression → quartzite (roche métamorphique)\n'
          '5) Fusion → magma → nouvelle roche magmatique\n\n'
          'Classification rapide :\n'
          'Granite : magmatique intrusive, felsique\n'
          'Basalte : magmatique extrusive, mafique\n'
          'Grès : sédimentaire détritique\n'
          'Marbre : métamorphique (calcaire original)',
      takeaways: [
        'Minéraux : cristaux inorganiques de composition définie',
        'Magmatiques : par refroidissement du magma (intrusive/extrusive)',
        'Sédimentaires : par accumulation de sédiments (stratification)',
        'Métamorphiques : par chaleur + pression (foliation possible)',
        'Cycle sans fin : magmatique → sédimentaire → métamorphique → magmatique',
      ],
    ),
  };

  // ===========================================================================
  // SVT — Chapitre 5 : Biologie cellulaire
  // ===========================================================================

  static final Map<String, LessonContent> _svtCh5 = {
    'svt_ch5_l1': const LessonContent(
      introText:
          'La cellule est l\'unité de base de la vie. Tous les êtres vivants sont composés de cellules. '
          'L\'étude de l\'organisation cellulaire (membrane, noyau, organites) permet de comprendre '
          'le fonctionnement fondamental du vivant.',
      lessonBody:
          'La membrane plasmique (ou membrane cellulaire) est une barrière sélective qui entoure la '
          'cellule. Son modèle est le « mosaïque fluides » (Singer et Nicolson, 1972) : double couche '
          'de phospholipides dans laquelle sont insérées des protéines (intégnales et périphériques). '
          'Le cholestérol module la fluidité. La perméabilité sélective permet le passage de certaines '
          'molécules (diffusion, osmose, transport actif).\n\n'
          'Le noyau contient l\'ADN organisé en chromosomes. Il est entouré par l\'enveloppe nucléaire '
          '(double membrane perforée par des pores nucléaires). Le nucléole synthétise les ARN ribosomaux. '
          'Le noyau contrôle l\'expression des gènes et la synthèse des protéines.\n\n'
          'Organites cytoplasmiques :\n'
          '- Ribosomes : synthèse des protéines (translation).\n'
          '- Réticulum endoplasmique (RE) : RE rugueux (avec ribosomes, synthèse protéique) et '
          'RE lisse (synthèse lipidique, détoxification).\n'
          '- Appareil de Golgi : modification, tri et sécrétion des protéines.\n'
          '- Mitochondries : respiration cellulaire, production d\'ATP. Double membrane, ADN propre, '
          'ribosomes → semi-autonomie.\n'
          '- Plastides (chloroplastes chez les végétaux) : photosynthèse. Double membrane, ADN propre.\n'
          '- Lysosomes : digestion intracellulaire (enzymes hydrolytiques).\n'
          '- Cytosquelette : structure, mobilité, division cellulaire.\n\n'
          'Différenciation cellulaire : toutes les cellules d\'un organisme contiennent le même ADN, '
          'mais l\'expression des gènes diffère selon les types cellulaires (expression sélective des gènes).',
      example:
          'Exemple — Différences entre cellule animale et végétale :\n'
          'Cellule animale : pas de paroi, pas de chloroplastes, centrioles, lysosomes.\n'
          'Cellule végétale : paroi cellulosique, chloroplastes, grande vacuole centrale, plasmodesmes.\n\n'
          'Fonction des organites :\n'
          'Mitochondrie : C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + ATP\n'
          'Chloroplaste : 6CO₂ + 6H₂O + lumière → C₆H₁₂O₆ + 6O₂',
      takeaways: [
        'Membrane : mosaïque fluides (phospholipides + protéines)',
        'Noyau : contient l\'ADN, contrôle l\'expression des gènes',
        'Mitochondrie : respiration → ATP (ADN propre)',
        'Chloroplaste : photosynthèse (ADN propre)',
        'Différenciation : même ADN, expression génétique différente',
      ],
    ),
    'svt_ch5_l2': const LessonContent(
      introText:
          'La respiration cellulaire est le processus de dégradation du glucose pour produire de '
          'l\'ATP, la monnaie énergétique de la cellule. Elle comprend la glycolyse, le cycle de Krebs '
          'et la chaîne respiratoire.',
      lessonBody:
          'La respiration cellulaire aérobie se déroule en trois étapes successives :\n\n'
          '1) Glycolyse (cytoplasme) : le glucose (C₆H₁₂O₆) est coupé en deux molécules de pyruvate '
          '(C₃H₄O₃). Bilan : -1 glucose, -2 ATP (consommés), +4 ATP (produits) = +2 ATP nets, '
          '+2 NADH. La glycolyse est la voie la plus ancienne (anaérobie, présente chez tous les '
          'êtres vivants). Elle ne nécessite pas d\'oxygène.\n\n'
          '2) Cycle de Krebs (matrice mitochondriale) : le pyruvate est converti en acétyl-CoA '
          '(réaction de décarboxylation, libération de CO₂). L\'acétyl-CoA entre dans le cycle de Krebs : '
          'oxydation complète en CO₂. Bilan par tour : 3 NADH, 1 FADH₂, 1 GTP (= ATP), 2 CO₂. '
          'Pour un glucose : 2 tours (2 pyruvates).\n\n'
          '3) Chaîne respiratoire et phosphorylation oxidative (membrane intérieure mitochondriale) : '
          'les NADH et FADH₂ cèdent leurs électrons à des complexes protéiques (I, II, III, IV). '
          'Les électrons sont transférés de proche en proche jusqu\'à l\'oxygène (accepteur final). '
          'Le gradient de protons généré alimente l\'ATP synthase (complexe V) qui produit l\'ATP. '
          'Bilan : ≈ 34 ATP par glucose.\n\n'
          'Bilan global de la respiration aérobie :\n'
          'C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + ≈ 38 ATP.\n\n'
          'Respiration anaérobie : en absence d\'O₂, la fermentation lactate (muscles) ou '
          'alcoolique (levures) régénère le NAD⁺ pour permettre la glycolyse. Bilan : 2 ATP seulement.',
      example:
          'Exemple — Rendement énergétique :\n'
          '1 glucose → glycolyse : 2 ATP\n'
          '1 glucose → Krebs : 2 GTP (= 2 ATP)\n'
          'NADH de glycolyse : 2 NADH × 2,5 ATP/NADH = 5 ATP\n'
          'NADH/FADH₂ de Krebs : 6 NADH × 2,5 + 1 FADH₂ × 1,5 = 16,5 ATP\n\n'
          'Total ≈ 2 + 2 + 5 + 16,5 ≈ 25,5 ATP (estimation moderne)\n'
          'Ancien bilan : ≈ 38 ATP (souvent cité en cours).\n\n'
          'Fermentation lactate (anaérobie) :\n'
          'Pyruvate + NADH → Lactate + NAD⁺\n'
          'Seulement 2 ATP par glucose.',
      takeaways: [
        'Glycolyse : glucose → 2 pyruvates + 2 ATP (cytoplasme)',
        'Krebs : acétyl-CoA → CO₂ + NADH/FADH₂ (mitochondrie)',
        'Chaîne respiratoire : NADH/FADH₂ → ATP via gradient H⁺',
        'Bilan aérobie : ≈ 38 ATP/glucose',
        'Anaérobie : fermentation, 2 ATP seulement',
      ],
    ),
  };

  // ===========================================================================
  // SVT — Chapitre 6 : Reproduction
  // ===========================================================================

  static final Map<String, LessonContent> _svtCh6 = {
    'svt_ch6_l1': const LessonContent(
      introText:
          'L\'appareil reproducteur humain comprend les organes génitaux masculins et féminins. '
          'La gamétogenèse (spermatogenèse et ovogenèse) est le processus de formation des gamètes, '
          'cellules sexuelles haploïdes essentielles à la reproduction.',
      lessonBody:
          'Appareil reproducteur masculin : les testicules produisent les spermatozoïdes '
          '(spermatogenèse) et les hormones mâles (testostérone). Les spermatozoïdes mûrissent '
          'dans l\'épididyme, traversent le canal déférent et sont mélangés aux sécrétions des '
          'glandes accessoires (vésicules séminales, prostate) pour former le sperme. Le pénis '
          'permet la copulation.\n\n'
          'Appareil reproducteur féminin : les ovaires produisent les ovules (ovogenèse) et les '
          'hormones féminines (œstrogènes, progestérone). Les trompes de Fallope relient les ovaires '
          'à l\'utérus. L\'utérus (myomètre + endomètre) est le siège de la nidation et du développement '
          'embryonnaire. Le col de l\'utérus et le vagin complètent l\'appareil.\n\n'
          'Spermatogenèse : processus continu (de la puberté à la mort), dans les tubules séminifères '
          'des testicules. Une cellule souche diploïde (2n = 46 chromosomes) subit mitose puis méiose '
          'pour produire 4 spermatozoïdes haploïdes (n = 23 chromosomes). Durée : ≈ 74 jours. '
          'Température optimale : 34°C (testicules hors du corps).\n\n'
          'Ovogenèse : processus discontinu, débutant avant la naissance. Les ovocytes primaires '
          'sont formés avant la naissance (pause en prophase I). À la puberté, un ovocyte par cycle '
          'reprend la méiose I → ovocyte secondaire + globule polaire. La méiose II n\'est terminée '
          'qu\'au moment de la fécondation. Résultat : 1 ovule fonctionnel + 2-3 globules polaires '
          '(par opposition aux 4 spermatozoïdes). Les ovocytes s\'épuisent avec l\'âge (ménopause ≈ 50 ans).',
      example:
          'Exemple — Comparaison spermatogenèse/ovogenèse :\n'
          'Spermatogenèse :\n'
          '- Continu (puberté → mort)\n'
          '- 1 cellule → 4 spermatozoïdes\n'
          '- Produit chaque jour des millions de spermatozoïdes\n\n'
          'Ovogenèse :\n'
          '- Discontinu (pause avant puberté, arrêt à ménopause)\n'
          '- 1 cellule → 1 ovule + 2-3 globules polaires\n'
          '- 1 ovule par cycle (≈ 28 jours)\n'
          '- Stock limité (≈ 400 000 ovocytes à la naissance)',
      takeaways: [
        'Spermatogenèse : continue, 4 spermatozoïdes/cellule, 74 jours',
        'Ovogenèse : discontinue, 1 ovule/cycle, stock limité',
        'Spermatozoïde : n = 23 chromosomes, flagellé',
        'Ovule : n = 23 chromosomes, plus grande cellule du corps',
        'Ménopause : épuisement du stock d\'ovocytes (≈ 50 ans)',
      ],
    ),
    'svt_ch6_l2': const LessonContent(
      introText:
          'La régulation hormonale du cycle menstruel féminin est un processus complexe impliquant '
          'l\'hypothalamus, l\'hypophyse et les ovaires. Les interactions entre hormones FSH, LH, '
          'œstrogènes et progestérone orchestrent l\'ovulation et la préparation de l\'utérus.',
      lessonBody:
          'Le cycle menstruel dure environ 28 jours (variation normale : 21-35 jours) et comporte '
          'deux phases principales :\n\n'
          '1) Phase folliculaire (jours 1-14) : l\'hypothalamus sécrète le GnRH qui stimule '
          'l\'hypophyse antérieure. Celle-ci libère la FSH (hormone folliculo-stimulante) et la LH '
          '(hormone lutéinisante). La FSH stimule la croissance de plusieurs follicules ovariens. '
          'Un follicule dominant émerge et sécrète des œstrogènes. Les œstrogènes stimulent la '
          'prolifération de l\'endomètre (phase proliférative). Les œstrogènes exercent un feedback '
          'négatif sur la FSH (les autres follicules dégénèrent) puis, à forte concentration, un '
          'feedback positif sur la LH.\n\n'
          '2) Ovulation (jour 14) : le pic de LH (feedback positif des œstrogènes) déclenche '
          'l\'explosion du follicule dominant et la libération de l\'ovule dans la trompe.\n\n'
          '3) Phase lutéale (jours 14-28) : le follicule éclaté se transforme en corps jaune '
          '(lutéinisation par la LH). Le corps jaune sécrète de la progestérone et des œstrogènes. '
          'La progestérone prépare l\'endomètre à la nidation (phase sécrétrice : endomètre gonflé, '
          'vascularisé, riche en glycogène). Si pas de fécondation, le corps jaune dégénère (lutéolyse) '
          'en jour 24-26. La chute de progestérone et d\'œstrogènes déclenche les menstrues (saignement, '
          'jou 1-5 du cycle suivant).',
      example:
          'Exemple — Timeline du cycle :\n'
          'Jour 1 : Début des menstrues (chute de progestérone)\n'
          'Jour 5 : Fin des menstrues, début phase folliculaire\n'
          'Jour 7-10 : Croissance folliculaire, pic d\'œstrogènes\n'
          'Jour 14 : OVULATION (pic de LH)\n'
          'Jour 15-24 : Corps jaune, progestérone élevée\n'
          'Jour 24-26 : Dégénérescence du corps jaune\n'
          'Jour 28 : Fin du cycle, chutes hormonales → menstrues',
      takeaways: [
        'Cycle ≈ 28 jours : folliculaire (14 j) + lutéale (14 j)',
        'FSH : croissance folliculaire ; LH : ovulation',
        'Œstrogènes : prolifération endométriale',
        'Progestérone : préparation à la nidation',
        'Pas de fécondation → corps jaune dégénère → menstrues',
      ],
    ),
    'svt_ch6_l3': const LessonContent(
      introText:
          'La fécondation est l\'union du spermatozoïde et de l\'ovule pour former un zygote '
          'diploïde. Le développement embryonnaire comprend la segmentation, la gastrulation et '
          'l\'organogenèse,Aboutissant à la formation d\'un fœtus viable.',
      lessonBody:
          'Fécondation : a lieu dans la trompe de Fallope, quelques heures après l\'ovulation. '
          'Le spermatozoïde traverse la couronne radiée (réaction acrosomique : libération d\'enzymes '
          'protéolytiques). Seul le noyau du spermatozoïde pénètre dans l\'ovule. La barrière '
          'génétique empêche la polyspermie. Les deux pronoyaux (mâle et femelle) fusionnent → '
          'zygote diploïde (2n = 46 chromosomes).\n\n'
          'Segmentation : le zygote se divise par mitose successives. Jour 1 : 2 cellules. Jour 2 : '
          '4 cellules. Jour 3 : morula (16 cellules). Jour 4-5 : blastocyste (100+ cellules). '
          'Le blastocyste contient la masse interne (embryon) et le trophoblaste (future placenta).\n\n'
          'Nidation (implantation) : le blastocyste s\'implante dans l\'endomètre vers le 7ème-10ème jour. '
          'Le trophoblaste sécrète de la β-hCG (hormone chorionique gonadotrope) qui maintient le corps '
          'jaune et les taux élevés de progestérone (test de grossesse détecte la β-hCG).\n\n'
          'Gastrulation (semaine 3) : formation des trois feuillets embryonnaires :\n'
          '- Ectoderme → système nerveux, épiderme\n'
          '- Mésoderme → os, muscles, sang, système reproducteur\n'
          '- Endoderme → tube digestif, poumons, foie\n\n'
          'Organogenèse (semaines 3-8) : les organes se forment. Le cœur bat vers la semaine 4. '
          'Les membres apparaissent vers la semaine 6. À 8 semaines, l\'embryon (15 mm) est appelé '
          'fœtus. Le placenta assure les échanges entre la mère et le fœtus (nutriments, O₂, déchets).',
      example:
          'Exemple — Développement précoce :\n'
          'Jour 0 : Fécondation dans la trompe\n'
          'Jour 1-3 : Segmentation (2 → 4 → 8 → 16 cellules)\n'
          'Jour 5 : Blastocyste\n'
          'Jour 7-10 : Nidation dans l\'endomètre\n'
          'Semaine 3 : Gastrulation (3 feuillets)\n'
          'Semaine 4 : Cœur bat\n'
          'Semaine 8 : Embryon → fœtus (15 mm)\n'
          'Mois 3 : Organes fonctionnels\n'
          'Mois 9 : Naissance',
      takeaways: [
        'Fécondation : spermatozoïde + ovule → zygote (2n)',
        'Réaction acrosomique + barrière à la polyspermie',
        'Segmentation : morula → blastocyste (jour 5)',
        'Gastrulation : ectoderme, mésoderme, endoderme',
        'β-hCG maintient le corps jaune (test de grossesse)',
      ],
    ),
  };

  // ===========================================================================
  // SVT — Chapitre 7 : Neurobiologie
  // ===========================================================================

  static final Map<String, LessonContent> _svtCh7 = {
    'svt_ch7_l1': const LessonContent(
      introText:
          'Le neurone est l\'unité fonctionnelle du système nerveux. Il transmet l\'information '
          'sous forme d\'influx nerveux (potentiel d\'action) le long de son axone. L\'étude du '
          'potentiel de repos et du potentiel d\'action est fondamentale en neurophysiologie.',
      lessonBody:
          'Structure du neurone : corps cellulaire (soma) contenant le noyau, dendrites (réception '
          'de l\'information), axone (conduction de l\'influx), terminaisons synaptiques (transmission '
          'à un autre neurone ou un effecteur). L\'axone peut être recouvert de myéline (gaine de '
          'myéline formée par les oligodendrocytes ou les cellules de Schwann), qui accélère la '
          'conduction par saut de Ranvier.\n\n'
          'Potentiel de repos : à l\'intérieur de la membrane neuronale, le potentiel est d\'environ '
          '-70 mV par rapport à l\'extérieur. Ce gradient est maintenu par :\n'
          '- La pompe Na⁺/K⁺ : 3 Na⁺ expulsés pour 2 K⁺ introduits (ATP nécessaire).\n'
          '- Perméabilité sélective : la membrane est plus perméable aux K⁺ qu\'aux Na⁺ au repos.\n'
          '- Gradient de concentration : [K⁺]_int > [K⁺]_ext, [Na⁺]_ext > [Na⁺]_int.\n\n'
          'Potentiel d\'action : c\'est l\'inversion rapide du potentiel membranaire le long de l\'axone. '
          'En réponse à un stimulus suffisant (seuil de déclenchement), les canaux voltage-dépendants '
          's\'ouvrent : phase de dépolarisation (Na⁺ entre, potentiel passe à +30 mV), phase de '
          'repolarisation (K⁺ sort, potentiel revient vers -70 mV), phase d\'hyperpolarisation '
          '(potentiel temporairement plus négatif). La pompe Na⁺/K⁺ rétablit les concentrations initiales.\n\n'
          'Conduction de l\'influx : dans les fibres myélinisées, l\'influx « saute » d\'un nœud de '
          'Ranvier à l\'autre (conduction saltatoire, très rapide : 100 m/s). Dans les fibres non '
          'myélinisées, la conduction est continue et plus lente (1 m/s). La loi du tout ou rien : '
          'si le seuil n\'est pas atteint, pas de potentiel d\'action ; si le seuil est atteint, le '
          'potentiel d\'action est maximal et constant.',
      example:
          'Exemple — Potentiel d\'action :\n'
          'Potentiel de repos : -70 mV\n'
          'Seuil de déclenchement : -55 mV\n'
          'Phase de dépolarisation : Na⁺ entre → +30 mV (environ 1 ms)\n'
          'Phase de repolarisation : K⁺ sort → -70 mV\n'
          'Hyperpolarisation : -80 mV (temporaire)\n'
          'Retour à -70 mV par pompe Na⁺/K⁺\n\n'
          'Vitesse de conduction :\n'
          '- Fibre myélinisée : 100 m/s (conduction saltatoire)\n'
          '- Fibre non myélinisée : 1 m/s (conduction continue)\n'
          '- Temps pour un nerf de 1 m : 10 ms (myélinisé) vs 1 s (non myélinisé)',
      takeaways: [
        'Neurone : soma, dendrites, axone, terminaisons',
        'Potentiel de repos : -70 mV (pompe Na⁺/K⁺)',
        'Potentiel d\'action : dépolarisation (Na⁺) + repolarisation (K⁺)',
        'Loi du tout ou rien',
        'Conduction saltatoire (myélinisée) = rapide',
      ],
    ),
    'svt_ch7_l2': const LessonContent(
      introText:
          'La synapse est la jonction entre deux neurones (ou entre un neurone et un effecteur). '
          'La transmission synaptique chimique utilise des neurotransmetteurs pour transmettre '
          'l\'information d\'un neurone pré-synaptique au neurone post-synaptique.',
      lessonBody:
          'Structure de la synapse chimique : terminaison du neurone pré-synaptique (contenant des '
          'vésicules synaptiques remplies de neurotransmetteurs), fente synaptique (espace de 20-40 nm), '
          'membrane du neurone post-synaptique (contenant des récepteurs spécifiques).\n\n'
          'Mécanisme de transmission :\n'
          '1) L\'influx nerveux arrive à la terminaison pré-synaptique.\n'
          '2) Les canaux calciques voltage-dépendants s\'ouvrent (Ca²⁺ entre).\n'
          '3) Le Ca²⁺ déclenche l\'exocytose des vésicules synaptiques.\n'
          '4) Le neurotransmetteur est libéré dans la fente synaptique.\n'
          '5) Il se fixe sur les récepteurs de la membrane post-synaptique.\n'
          '6) Canal ionique s\'ouvre ou récepteur métabotrope déclenche une cascade.\n'
          '7) Potentiel postsynaptique excitateur (EPSP) ou inhibiteur (IPSP).\n'
          '8) Le neurotransmetteur est dégradé ou recapté (rétrogradation).\n\n'
          'Principaux neurotransmetteurs :\n'
          '- Acétylcholine (ACh) : neuromusculaire, mémoire (déficit = Alzheimer).\n'
          '- Dopamine : mouvement, motivation, plaisir (déficit = Parkinson, excès = schizophrénie).\n'
          '- Sérotonine (5-HT) : humeur, sommeil (déficit = dépression).\n'
          '- Noradrénaline : vigilance, stress.\n'
          '- GABA : inhibiteur principal du cerveau.\n'
          '- Glutamate : excitateur principal du cerveau.\n\n'
          'Intégration : un neurone reçoit des milliers de synapses. Le potentiel d\'action se '
          'déclenche si la somme des EPSP dépasse le seuil au niveau du cône d\'émergence (somme '
          'spatiale et temporelle des influx). C\'est le principe d\'intégration neuronale.',
      example:
          'Exemple — Synapse neuromusculaire :\n'
          '1) Influx arrive à la jonction neuromusculaire\n'
          '2) Ca²⁺ entre dans la terminaison\n'
          '3) Vésicules d\'acétylcholine fusionnent avec la membrane\n'
          '4) ACh libérée dans la fente synaptique\n'
          '5) ACh se fixe sur les récepteurs nicotiniques du muscle\n'
          '6) Na⁺ entre dans la fibre musculaire\n'
          '7) Dépolarisation → contraction musculaire\n'
          '8) ACh est dégradée par l\'acétylcholinestérase\n\n'
          'Pathologies :\n'
          'Parkinson : destruction des neurones à dopamine (substance noire)\n'
          'Alzheimer : déficit en acétylcholine',
      takeaways: [
        'Synapse : pré-synaptique → fente → post-synaptique',
        'Transmission chimique par neurotransmetteurs',
        'EPSP (excitateur) vs IPSP (inhibiteur)',
        'ACh, dopamine, sérotonine, GABA, glutamate',
        'Intégration : sommation spatiale et temporelle',
      ],
    ),
  };

  // ===========================================================================
  // INFORMATIQUE — Chapitre 1 : Algorithmique
  // ===========================================================================

  static final Map<String, LessonContent> _infoCh1 = {
    'info_ch1_l1': const LessonContent(
      introText:
          'L\'algorithmique est la science de la résolution de problèmes par la définition d\'une '
          'suite d\'instructions précises et ordonnées. Un algorithme est le pilier de tout programme '
          'informatique : avant de coder, il faut concevoir l\'algorithme.',
      lessonBody:
          'Un algorithme est une suite finie et ordonnée d\'instructions ou d\'opérations permettant '
          'de résoudre un problème donné. Un bon algorithme doit être précis (chaque instruction est '
          'claire et sans ambiguïté), fin (il s\'arrête après un nombre fini d\'étapes), et efficace '
          '(il produit le résultat attendu). L\'algorithme peut être exprimé en pseudo-code (langage '
          'proche du français) ou sous forme d\'organigramme (représentation graphique).\n\n'
          'Un organigramme utilise des symboles normalisés : un ovale pour le début et la fin (terminateur), '
          'un parallélogramme pour les entrées/sorties (données), un rectangle pour les traitements '
          '(calculs, affectations), un losange pour les décisions (conditions), et des flèches pour '
          'indiquer le flux d\'exécution. L\'organigramme est particulièrement utile pour visualiser '
          'la logique d\'un algorithme complexe.\n\n'
          'En pseudo-code, on utilise des concepts de programmation simplifiés. Une variable est un espace '
          'mémoire identifié par un nom, qui stocke une valeur pouvant changer au cours de l\'exécution. '
          'Une constante est une valeur qui ne change jamais. Les types de données principaux sont : '
          'entier (int), réel (float), booléen (true/false), caractère (char) et chaîne de caractères (string). '
          'L\'affectation s\'écrit avec := ou = (ex : x := 5).\n\n'
          'L\'écriture d\'un algorithme suit généralement quatre étapes : 1) Analyse du problème '
          '(identifier les entrées et les sorties), 2) Conception (élaborer la méthode de résolution), '
          '3) Codage en pseudo-code ou organigramme, 4) Vérification (tester sur des cas simples). '
          'Cette démarche méthodique est essentielle et s\'applique à tout problème informatique.',
      example:
          'Exemple — Algorithme de calcul de la moyenne de 3 notes :\n\n'
          'ALGORITHME CalculMoyenne\n'
          'VARIABLES :\n'
          '  note1, note2, note3 : RÉEL\n'
          '  moyenne : RÉEL\n\n'
          'DÉBUT\n'
          '  ÉCRIRE("Entrez la note 1 :")\n'
          '  LIRE(note1)\n'
          '  ÉCRIRE("Entrez la note 2 :")\n'
          '  LIRE(note2)\n'
          '  ÉCRIRE("Entrez la note 3 :")\n'
          '  LIRE(note3)\n'
          '  moyenne := (note1 + note2 + note3) / 3\n'
          '  ÉCRIRE("La moyenne est :", moyenne)\n'
          'FIN\n\n'
          'Organigramme :\n'
          '  (Début)\n'
          '    ↓\n'
          '  [Lire note1, note2, note3]\n'
          '    ↓\n'
          '  [moyenne := (note1+note2+note3)/3]\n'
          '    ↓\n'
          '  [Afficher moyenne]\n'
          '    ↓\n'
          '  (Fin)\n\n'
          'Test : note1=12, note2=15, note3=10\n'
          'moyenne = (12+15+10)/3 = 37/3 = 12,33',
      takeaways: [
        'Algorithme = suite finie d\'instructions pour résoudre un problème',
        'Organigramme : ovale (début/fin), rectangle (traitement), losange (décision)',
        'Pseudo-code = langage de description proche du français',
        'Variables (modifiables) vs constantes (fixes)',
        'Types : entier, réel, booléen, caractère, chaîne',
      ],
    ),
    'info_ch1_l2': const LessonContent(
      introText:
          'Les structures de contrôle permettent de modifier le flux d\'exécution d\'un algorithme. '
          'Elles comprennent les structures conditionnelles (sélection) et les structures de répétition '
          '(boucles), qui rendent les algorithmes capables de prendre des décisions et de répéter des actions.',
      lessonBody:
          'La structure conditionnelle permet d\'exécuter différentes instructions selon qu\'une condition '
          'est vraie ou fausse. La syntaxe de base est :\n'
          'SI condition ALORS\n'
          '  instructions si vrai\n'
          'SINON\n'
          '  instructions si faux\n'
          'FIN SI\n'
          'La condition est une expression booléenne (vraie ou fausse). On peut imbriquer plusieurs SI. '
          'Exemple : SI (note ≥ 10) ALORS ÉCRIRE("Admis") SINON ÉCRIRE("Refusé") FIN SI.\n\n'
          'La boucle « Pour » (Pour...à) permet de répéter un bloc d\'instructions un nombre connu '
          'd\'avance de fois. Syntaxe :\n'
          'POUR i DE 1 À N FAIRE\n'
          '  instructions\n'
          'FIN POUR\n'
          'La variable i (compteur) prend successivement les valeurs de 1 à N, et les instructions '
          'sont exécutées pour chaque valeur. C\'est idéal pour traiter les éléments d\'un tableau ou '
          'pour des itérations numérotées.\n\n'
          'La boucle « Tant Que » (TantQue...Faire) répète un bloc tant qu\'une condition est vérifiée. '
          'Syntaxe :\n'
          'TANTQUE condition FAIRE\n'
          '  instructions\n'
          'FIN TANTQUE\n'
          'Contrairement à la boucle Pour, on ne connaît pas nécessairement le nombre d\'iterations à '
          'l\'avance. Il est essentiel que les instructions de la boucle modifient la condition d\'arrêt '
          'pour éviter une boucle infinie.\n\n'
          'Il existe aussi la boucle « Répéter...Jusqu\'à » qui exécute au moins une fois le bloc '
          'd\'instructions avant de vérifier la condition. La recherche dans un tableau est un exercice '
          'classique : on parcourt le tableau élément par élément (boucle Pour) en vérifiant si chaque '
          'élément correspond à la valeur recherchée (condition SI).',
      example:
          'Exemple 1 — Condition :\n'
          'ALGORITHME Parite\n'
          'VARIABLES n : ENTIER\n'
          'DÉBUT\n'
          '  LIRE(n)\n'
          '  SI (n MOD 2 = 0) ALORS\n'
          '    ÉCRIRE(n, "est pair")\n'
          '  SINON\n'
          '    ÉCRIRE(n, "est impair")\n'
          '  FIN SI\n'
          'FIN\n\n'
          'Exemple 2 — Boucle Pour : Factorielle\n'
          'ALGORITHME Factorielle\n'
          'VARIABLES n, i, resultat : ENTIER\n'
          'DÉBUT\n'
          '  LIRE(n)\n'
          '  resultat := 1\n'
          '  POUR i DE 1 À n FAIRE\n'
          '    resultat := resultat × i\n'
          '  FIN POUR\n'
          '  ÉCRIRE(n, "! =", resultat)\n'
          'FIN\n'
          'Test : n=5 → resultat = 1×1×2×3×4×5 = 120\n\n'
          'Exemple 3 — Boucle TantQue : Recherche\n'
          'ALGORITHME Rechercher\n'
          'VARIABLES tab[1..10] : TABLEAU D\'ENTIERS\n'
          '  x, i : ENTIER\n'
          '  trouvé : BOOLÉEN\n'
          'DÉBUT\n'
          '  trouvé := FAUX\n'
          '  i := 1\n'
          '  LIRE(x)\n'
          '  TANTQUE (i ≤ 10) ET (trouvé = FAUX) FAIRE\n'
          '    SI (tab[i] = x) ALORS trouvé := VRAI\n'
          '    SINON i := i + 1\n'
          '  FIN TANTQUE\n'
          '  SI trouvé ALORS ÉCRIRE("Trouvé à la position", i)\n'
          '  SINON ÉCRIRE("Non trouvé")\n'
          'FIN',
      takeaways: [
        'SI...ALORS...SINON : sélection selon une condition',
        'POUR i DE a À b : boucle à nombre d\'itérations connu',
        'TANTQUE condition FAIRE : boucle à nombre d\'itérations inconnu',
        'MOD (modulo) donne le reste de la division entière',
        'Toujours s\'assurer que la boucle a un moyen de s\'arrêter',
      ],
    ),
    'info_ch1_l3': const LessonContent(
      introText:
          'Les fonctions et procédures sont des sous-programmes qui permettent de décomposer un algorithme '
          'en parties modulaires. Elles favorisent la lisibilité, la réutilisation du code et la '
          'maintenance des programmes complexes.',
      lessonBody:
          'Une procédure est un sous-programme qui exécute une suite d\'instructions sans retourner de '
          'valeur. Elle est appelée par une instruction « APPELER nomProcédure ». Une fonction est un '
          'sous-programme qui retourne une valeur. Elle est utilisée dans des expressions : « résultat := '
          'nomFonction(arguments) ». La définition d\'une fonction ou procédure comprend l\'en-tête '
          '(nom, paramètres, type de retour) et le corps (les instructions).\n\n'
          'Les paramètres formels sont les variables déclarées dans l\'en-tête de la fonction/procédure. '
          'Les paramètres réels sont les valeurs effectivement passées lors de l\'appel. Lors de l\'appel, '
          'les paramètres réels sont copiés dans les paramètres formels. On distingue deux modes de passage : '
          'le passage par valeur (une copie de la valeur est transmise, la variable d\'origine est intacte) '
          'et le passage par référence (l\'adresse de la variable est transmise, toute modification du '
          'paramètre formel modifie la variable d\'origine).\n\n'
          'La récursivité est une technique où une fonction s\'appelle elle-même. Elle est particulièrement '
          'élégante pour résoudre des problèmes qui se décomposent en sous-problèmes de même nature '
          '(comme les factorielles, les suites de Fibonacci, les arbres). Toute fonction récursive doit '
          'avoir un cas d\'arrêt (ou cas de base) pour éviter l\'appel infini. L\'exemple classique est '
          'la factorielle : n! = n × (n-1)! avec 0! = 1 comme cas d\'arrêt.\n\n'
          'La fonction de Fibonacci illustre bien la récursivité : F(0) = 0, F(1) = 1, F(n) = F(n-1) + F(n-2). '
          'Mais la récursivité simple de Fibonacci est inefficace (beaucoup d\'appels en double). On peut '
          'l\'optimiser par mémoïsation (stockage des résultats déjà calculés) ou par itération. '
          'Le choix entre récursion et itération dépend de la nature du problème et des contraintes '
          'de performance.',
      example:
          'Exemple 1 — Fonction factorielle (récursive) :\n'
          'ALGORITHME Factorielle\n'
          'FONCTION fact(n : ENTIER) : ENTIER\n'
          'DÉBUT\n'
          '  SI (n = 0) ALORS\n'
          '    RETOURNER 1\n'
          '  SINON\n'
          '    RETOURNER n × fact(n - 1)\n'
          '  FIN SI\n'
          'FIN FONCTION\n\n'
          'Appel : fact(5)\n'
          'fact(5) = 5 × fact(4)\n'
          '        = 5 × 4 × fact(3)\n'
          '        = 5 × 4 × 3 × fact(2)\n'
          '        = 5 × 4 × 3 × 2 × fact(1)\n'
          '        = 5 × 4 × 3 × 2 × 1 × fact(0)\n'
          '        = 5 × 4 × 3 × 2 × 1 × 1 = 120\n\n'
          'Exemple 2 — Fonction Fibonacci (récursive) :\n'
          'FONCTION fib(n : ENTIER) : ENTIER\n'
          'DÉBUT\n'
          '  SI (n ≤ 1) ALORS RETOURNER n\n'
          '  SINON RETOURNER fib(n-1) + fib(n-2)\n'
          'FIN FONCTION\n\n'
          'Suite : 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...\n'
          'fib(6) = fib(5) + fib(4)\n'
          '       = (fib(4)+fib(3)) + (fib(3)+fib(2))\n'
          '       = 8 + 5 = 13\n\n'
          'Exemple 3 — Procédure (passage par référence) :\n'
          'PROCÉDURE echanger(VAR a, b : ENTIER)\n'
          'VAR temp : ENTIER\n'
          'DÉBUT\n'
          '  temp := a\n'
          '  a := b\n'
          '  b := temp\n'
          'FIN PROCÉDURE\n\n'
          'x := 5, y := 10\n'
          'APPELER echanger(x, y)\n'
          '→ x = 10, y = 5 (variables modifiées grâce au passage par référence)',
      takeaways: [
        'Fonction = retourne une valeur ; Procédure = exécute des instructions',
        'Paramètres formels (définition) vs réels (appel)',
        'Passion par valeur (copie) vs par référence (adresse)',
        'Récursivité = fonction qui s\'appelle elle-même',
        'Toujours inclure un cas d\'arrêt en récursivité',
      ],
    ),
  };

  // ===========================================================================
  // INFORMATIQUE — Chapitre 2 : Structures de données
  // ===========================================================================

  static final Map<String, LessonContent> _infoCh2 = {
    'info_ch2_l1': const LessonContent(
      introText:
          'Les tableaux et les listes sont des structures de données linéaires qui permettent '
          'de stocker et manipuler des collections d\'éléments. Leur choix dépend des opérations '
          'à effectuer : accès par indice, insertion, suppression.',
      lessonBody:
          'Un tableau est une structure de données à taille fixe, contenant des éléments de même type '
          'accessibles par un indice. En mémoire, les éléments sont contigus. L\'accès par indice est '
          'en O(1) (temps constant). En C : int tab[10]; tab[3] = 42;. En Python : tab = [1, 2, 3]. '
          'Les tableaux ont une taille fixe (en C) ou dynamique (en Python, liste).\n\n'
          'Opérations sur les tableaux :\n'
          '- Accès par indice : O(1)\n'
          '- Recherche non trié : O(n) — il faut parcourir tous les éléments\n'
          '- Recherche trié : O(log n) — dichotomie\n'
          '- Insertion en fin : O(1)\n'
          '- Insertion en milieu : O(n) — décalage nécessaire\n'
          '- Suppression en milieu : O(n)\n\n'
          'Liste chaînée : chaque élément (nœud) contient une donnée et un pointeur vers l\'élément '
          'suivant. La liste est dynamique (taille modifiable). Avantages : insertion/suppression en O(1) '
          'si on connaît la position. Inconvénient : accès séquentiel en O(n). Types : simple, double, '
          'circulaire.\n\n'
          'Comparaison tableau/liste :\n'
          '- Tableau : accès rapide O(1), taille fixe, mémoire contiguë.\n'
          '- Liste : accès séquentiel O(n), taille dynamique, mémoire dispersée.',
      example:
          'Exemple — Recherche dichotomique (tableau trié) :\n'
          'Tableau trié : [2, 5, 8, 12, 16, 23, 38, 56, 72, 91]\n'
          'Recherche de 23 :\n'
          '1) Milieu = 16 (indice 4). 23 > 16 → chercher à droite.\n'
          '2) Milieu = 56 (indice 7). 23 < 56 → chercher à gauche.\n'
          '3) Milieu = 23 (indice 5). Trouvé !\n'
          'Complexité : O(log₂(10)) ≈ 3 comparaisons.',
      takeaways: [
        'Tableau : taille fixe, accès O(1) par indice',
        'Liste chaînée : taille dynamique, insertion/suppression O(1)',
        'Recherche dichotomique : O(log n) sur tableau trié',
        'Insertion en milieu : O(n) (tableau) vs O(1) (liste)',
        'Choix selon les opérations dominantes',
      ],
    ),
    'info_ch2_l2': const LessonContent(
      introText:
          'Les piles et les files sont des structures de données linéaires avec des règles d\'accès '
          'spécifiques. La pile fonctionne en LIFO (Last In, First Out) et la file en FIFO '
          '(First In, First Out). Elles sont essentielles en informatique.',
      lessonBody:
          'Pile (Stack) : structure LIFO — le dernier élément empilé est le premier sorti. '
          'Opérations principales :\n'
          '- Empiler (push) : ajouter un élément au sommet.\n'
          '- Dépiler (pop) : retirer l\'élément du sommet.\n'
          '- Sommet (top) : consulter l\'élément au sommet sans le retirer.\n'
          '- EstVide : vérifier si la pile est vide.\n\n'
          'Applications des piles :\n'
          '- Annulation (Ctrl+Z) : les actions sont empilées et dépilées en sens inverse.\n'
          '- Évaluation d\'expressions (notation polonaise inversée).\n'
          '- Appels de fonctions (pile d\'exécution, récursivité).\n'
          '- Vérification de parenthésage : empiler ou(, dépiler quand on voit ).\n\n'
          'File (Queue) : structure FIFO — le premier élément entré est le premier sorti. '
          'Opérations principales :\n'
          '- Enfiler (enqueue) : ajouter à l\'arrière.\n'
          '- Défiler (dequeue) : retirer de l\'avant.\n'
          '- Premier (front) : consulter l\'élément de tête.\n'
          '- EstVide.\n\n'
          'Variantes : file à priorité (élément le plus prioritaire sort en premier), '
          'deque (double file : insertion/suppression aux deux extrémités).\n\n'
          'Complexité : push/pop (pile) et enqueue/dequeue (file) sont en O(1).',
      example:
          'Exemple — Pile pour parenthésage :\n'
          'Expression : (3 + 4) × (2 - 1)\n'
          'Parcours caractère par caractère :\n'
          '( → empiler ( → pile : [(]\n'
          '3 → traitement\n'
          '+ → traitement\n'
          '4 → traitement\n'
          ') → dépiler ( car matching → pile : []\n'
          '× → traitement\n'
          '( → empiler ( → pile : [(]\n'
          '2 → traitement\n'
          '- → traitement\n'
          '1 → traitement\n'
          ') → dépiler ( → pile : []\n'
          'Fin : pile vide = parenthésage valide ✓',
      takeaways: [
        'Pile : LIFO (dernier entré, premier sorti)',
        'File : FIFO (premier entré, premier sorti)',
        'Push/pop : O(1) ; Enqueue/dequeue : O(1)',
        'Applications pile : Ctrl+Z, récursivité, parenthésage',
        'Applications file : impression, processus, BFS',
      ],
    ),
    'info_ch2_l3': const LessonContent(
      introText:
          'Les arbres et les graphes sont des structures de données hiérarchiques et non linéaires. '
          'Les arbres binaires organisent les données en nœuds parent-enfant. Les graphes modélisent '
          'des relations complexes entre des objets.',
      lessonBody:
          'Arbre binaire : chaque nœud a au plus deux fils (gauche et droit). Terminologie : '
          'racine (nœud principal), feuilles (nœuds sans enfants), profondeur (distance à la racine), '
          'hauteur (profondeur maximale). Arbre binaire de recherche (ABR) : pour chaque nœud, '
          'tous les éléments du sous-arbre gauche sont inférieurs et tous ceux du sous-arbre droit '
          'sont supérieurs. Recherche, insertion et suppression en O(h) où h est la hauteur.\n\n'
          'Parcours d\'un arbre binaire :\n'
          '- Infixe (gauche, racine, droite) : donne les éléments en ordre croissant dans un ABR.\n'
          '- Préfixe (racine, gauche, droite) : utile pour copier un arbre.\n'
          '- Postfixe (gauche, droite, racine) : utile pour supprimer un arbre.\n'
          '- Parcours en largeur (niveau par niveau, par file).\n\n'
          'Graphe : ensemble de sommets (nœuds) reliés par des arêtes (liens). Types : '
          'orienté (arcs) ou non orienté, pondéré (poids sur les arêtes) ou non pondéré. '
          'Représentation : matrice d\'adjacence (O(n²) en espace) ou liste d\'adjacence '
          '(O(n + m) en espace).\n\n'
          'Algorithmes de parcours de graphes :\n'
          '- Parcours en profondeur (DFS) : utilise une pile (ou récursion). Exploration avant.\n'
          '- Parcours en largeur (BFS) : utilise une file. Exploration par niveaux.\n\n'
          'Applications : réseaux sociaux, cartes routières, planification, dépendances.',
      example:
          'Exemple — ABR et parcours infixe :\n'
          '         8\n'
          '        / \\\n'
          '       3   10\n'
          '      / \\    \\\n'
          '     1   6    14\n'
          '        / \\   /\n'
          '       4   7 13\n\n'
          'Parcours infixe : 1, 3, 4, 6, 7, 8, 10, 13, 14 (ordre croissant)\n'
          'Parcours préfixe : 8, 3, 1, 6, 4, 7, 10, 14, 13\n'
          'Parcours postfixe : 1, 4, 7, 6, 3, 13, 14, 10, 8',
      takeaways: [
        'Arbre binaire : au plus 2 fils par nœud',
        'ABR : gauche < racine < droite',
        'Parcours infixe ABR → ordre croissant',
        'Graphe : sommets + arêtes (orienté ou non, pondéré ou non)',
        'DFS (pile) vs BFS (file)',
      ],
    ),
  };

  // ===========================================================================
  // INFORMATIQUE — Chapitre 3 : Programmation Python
  // ===========================================================================

  static final Map<String, LessonContent> _infoCh3 = {
    'info_ch3_l1': const LessonContent(
      introText:
          'Python est un langage de programmation interprété, polyvalent et accessible. '
          'Son syntaxe claire en fait un excellent langage d\'apprentissage. Cette leçon '
          'présente les bases : variables, types, entrées/sorties.',
      lessonBody:
          'Variables et types : en Python, on n\'déclare pas le type explicitement. '
          'L\'interpréteur déduit le type à l\'affectation.\n'
          '- Entier : x = 42 (int)\n'
          '- Réel : y = 3.14 (float)\n'
          '- Chaîne : s = "bonjour" ou s = \'bonjour\' (str)\n'
          '- Booléen : b = True ou b = False (bool)\n'
          '- Liste : L = [1, 2, 3] (list, mutable)\n'
          '- Tuple : t = (1, 2, 3) (tuple, immuable)\n'
          '- Dictionnaire : d = {"nom": "Ali", "age": 20}\n\n'
          'Entrées/sorties :\n'
          '- Affichage : print("Bonjour", variable)\n'
          '- Saisie : nom = input("Entrez votre nom : ")\n'
          '  Retourne toujours une chaîne (str). Pour un nombre : int(input(...))\n\n'
          'Opérateurs :\n'
          '- Arithmétiques : +, -, *, /, // (division entière), % (modulo), ** (puissance)\n'
          '- Comparaison : ==, !=, <, >, <=, >= (retournent True/False)\n'
          '- Logiques : and, or, not\n'
          '- Chaînes : + (concaténation), * (répétition), len() (longueur)\n\n'
          'Conditions : si/non si/sinon : if x > 0: ... elif x == 0: ... else: ...\n'
          'Boucle pour : for i in range(10): ... (i = 0, 1, ..., 9)\n'
          'Boucle tant que : while condition: ...\n\n'
          'Indentation : Python utilise l\'indentation (4 espaces) pour délimiter les blocs. '
          'Pas d\'accolades comme en C.',
      example:
          'Exemple — Programme complet :\n'
          '# Saisie et traitement\n'
          'nom = input("Entrez votre nom : ")\n'
          'age = int(input("Entrez votre âge : "))\n\n'
          '# Condition\n'
          'if age >= 18:\n'
          '    print(nom, "est majeur")\n'
          'else:\n'
          '    print(nom, "est mineur")\n\n'
          '# Boucle\n'
          'for i in range(1, 6):\n'
          '    print(i, "×", age, "=", i * age)\n\n'
          '# Sortie attendue (age=20) :\n'
          '# Ali est majeur\n'
          '# 1 × 20 = 20\n'
          '# 2 × 20 = 40\n'
          '# ...\n'
          '# 5 × 20 = 100',
      takeaways: [
        'Pas de déclaration de type explicite en Python',
        'Types principaux : int, float, str, bool, list, dict',
        'input() retourne str ; int() convertit en entier',
        'Indentation (4 espaces) pour les blocs',
        'if/elif/else, for ... in range(), while',
      ],
    ),
    'info_ch3_l2': const LessonContent(
      introText:
          'Les fonctions et modules permettent d\'organiser le code en unités réutilisables. '
          'Les fonctions encapsulent une logique, les modules regroupent des fonctions et '
          'des données connexes. La bibliothèque standard Python offre de nombreuses utilités.',
      lessonBody:
          'Définition de fonction :\n'
          'def nom_fonction(paramètres):\n'
          '    """Docstring""" \n'
          '    instructions\n'
          '    return résultat\n\n'
          'Paramètres : positionnels, mots-clés, valeurs par défaut. '
          'Exemple : def puissance(base, expo=2): return base ** expo.\n'
          'Appel : puissance(3) → 9 ; puissance(3, 3) → 27.\n\n'
          'Portée des variables : locale (dans la fonction), globale (hors fonction). '
          'Le mot-clé global permet de modifier une variable globale dans une fonction.\n\n'
          'Modules : fichiers .py contenant des fonctions, classes, variables. '
          'Import : import math ; math.sqrt(16) → 4.0. '
          'Import sélectif : from math import sqrt, pi. '
          'Import alias : import numpy as np.\n\n'
          'Bibliothèque standard (extraits) :\n'
          '- math : sqrt, sin, cos, pi, log\n'
          '- random : randint, choice, shuffle\n'
          '- datetime : date, time, timedelta\n'
          '- os : gestion de fichiers et répertoires\n'
          '- json : lecture/écriture de fichiers JSON\n'
          '- csv : lecture/écriture de fichiers CSV\n\n'
          'Fichiers : ouverture avec open(), modes r (lecture), w (écriture), a (ajout). '
          'Fermeture avec close() ou contexte with : with open("f.txt") as f: contenu = f.read().',
      example:
          'Exemple — Fonction et module :\n'
          'import math\n\n'
          'def volume_cylindre(rayon, hauteur):\n'
          '    """Calcule le volume d\'un cylindre."""\n'
          '    return math.pi * rayon**2 * hauteur\n\n'
          'v = volume_cylindre(5, 10)\n'
          'print(f"Volume = {v:.2f} m³")\n'
          '# Volume = 785.40 m³',
      takeaways: [
        'def nom(paramètres): ... return valeur',
        'Valeurs par défaut : def f(x, n=2)',
        'import module ; from module import func',
        'Bibliothèque standard : math, random, datetime, os',
        'with open(fichier) as f : contexte sécurisé',
      ],
    ),
    'info_ch3_l3': const LessonContent(
      introText:
          'La programmation orientée objet (POO) organise le code autour d\'objets qui combinent '
          'des données (attributs) et des comportements (méthodes). Les classes modélisent des '
          'concepts du monde réel. L\'héritage permet la réutilisation et l\'extension.',
      lessonBody:
          'Classe : plan de construction d\'un objet. Définie par :\n'
          'class Animal:\n'
          '    def __init__(self, nom, espece):  # constructeur\n'
          '        self.nom = nom          # attribut\n'
          '        self.espece = espece\n\n'
          '    def parler(self):           # méthode\n'
          '        return f"{self.nom} fait un bruit"\n\n'
          'Objet : instance d\'une classe.\n'
          'chat = Animal("Minou", "chat")\n'
          'chat.parler()  # "Minou fait un bruit"\n\n'
          'Encapsulation : contrôle de l\'accès aux attributs. '
          'Convention : atributs privés avec _ (ex : self._age). '
          'Propriétés (@property) pour contrôler l\'accès.\n\n'
          'Héritage : une classe enfant hérite des attributs et méthodes d\'une classe parent. '
          'class Chien(Animal): def parler(self): return f"{self.nom} aboie"\n'
          'Le mot-clé super() accède aux méthodes de la classe parent.\n\n'
          'Polymorphisme : une même méthode peut avoir des comportements différents selon le type '
          'de l\'objet. Si Chien et Chat héritent d\'Animal et redéfinissent parler(), '
          'appeler parler() sur un objet de type inconnu fonctionnera correctement.\n\n'
          'AVANTAGES POO : réutilisabilité (héritage), modularité, maintenabilité, '
          'modélisation du monde réel.',
      example:
          'Exemple — Héritage :\n'
          'class Personne:\n'
          '    def __init__(self, nom, age):\n'
          '        self.nom = nom\n'
          '        self.age = age\n'
          '    def se_presenter(self):\n'
          '        return f"Je suis {self.nom}, {self.age} ans"\n\n'
          'class Etudiant(Personne):\n'
          '    def __init__(self, nom, age, filiere):\n'
          '        super().__init__(nom, age)\n'
          '        self.filiere = filiere\n'
          '    def se_presenter(self):\n'
          '        return f"{super().se_presenter()}, en {self.filiere}"\n\n'
          'e = Etudiant("Ali", 20, "NSI")\n'
          'print(e.se_presenter())\n'
          '# "Je suis Ali, 20 ans, en NSI"',
      takeaways: [
        'Classe : attributs + méthodes ; Objet : instance de classe',
        '__init__ : constructeur ; self = référence à l\'objet',
        'Héritage : class Enfant(Parent)',
        'super() : accès aux méthodes de la classe parent',
        'Polymorphisme : même méthode, comportement selon le type',
      ],
    ),
  };

  // ===========================================================================
  // INFORMATIQUE — Chapitre 4 : Bases de données
  // ===========================================================================

  static final Map<String, LessonContent> _infoCh4 = {
    'info_ch4_l1': const LessonContent(
      introText:
          'Le modèle relationnel organise les données en tables (relations) constituées de lignes '
          '(enregistrements) et de colonnes (attributs). Les clés primaires et étrangères assurent '
          'l\'intégrité et les relations entre les tables.',
      lessonBody:
          'Table (relation) : ensemble structuré de données en forme de tableau. Chaque ligne '
          'est un enregistrement, chaque colonne est un attribut de type défini. Exemple : '
          'table Etudiant(EtudiantID, Nom, Prenom, DateNaissance, Filiere).\n\n'
          'Clé primaire (PK) : attribut (ou ensemble d\'attributs) qui identifie de manière unique '
          'chaque enregistrement. Elle ne peut pas être nulle et doit être unique. '
          'Convention : nom de l\'attribut en majuscules, suffixé par "ID" ou "Code".\n\n'
          'Clé étrangère (FK) : attribut d\'une table qui fait référence à la clé primaire d\'une '
          'autre table. Elle établit la relation entre les deux tables. '
          'Exemple : la table Inscription(EtudiantID, CoursID) contient des clés étrangères '
          'qui font référence aux tables Etudiant et Cours.\n\n'
          'Types de relations :\n'
          '- 1:1 (un à un) : un étudiant a une seule carte d\'étudiant.\n'
          '- 1:N (un à plusieurs) : un étudiant s\'inscrit à plusieurs cours.\n'
          '- N:N (plusieurs à plusieurs) : plusieurs étudiants dans plusieurs cours → table intermédiaire.\n\n'
          'Intégrité référentielle : on ne peut pas supprimer un enregistrement qui est référencé '
          'par une clé étrangère dans une autre table (sauf cascade).\n\n'
          'Normalisation : processus d\'organisation des tables pour éliminer la redondance. '
          'Formes normales : 1FN (attributs atomiques), 2FN (dépendance totale à la PK), '
          '3FN (pas de dépendance transitive).',
      example:
          'Exemple — Schéma de base de données :\n\n'
          'Table Etudiant :\n'
          '| EtudiantID (PK) | Nom    | Prenom | Filiere  |\n'
          '| 1               | Diallo | Aminata| Info     |\n'
          '| 2               | Koné   | Moussa | Maths    |\n\n'
          'Table Cours :\n'
          '| CoursID (PK) | Intitule      | Coefficient |\n'
          '| 101          | Algorithmique | 3           |\n'
          '| 102          | Base de données| 4          |\n\n'
          'Table Inscription :\n'
          '| EtudiantID (FK) | CoursID (FK) | Note |\n'
          '| 1               | 101          | 14   |\n'
          '| 1               | 102          | 16   |\n'
          '| 2               | 101          | 12   |',
      takeaways: [
        'Table = lignes (enregistrements) + colonnes (attributs)',
        'Clé primaire : identifiant unique (PK)',
        'Clé étrangère : référence à une PK d\'une autre table (FK)',
        'Relations : 1:1, 1:N, N:N',
        'Normalisation : éliminer la redondance (1FN, 2FN, 3FN)',
      ],
    ),
    'info_ch4_l2': const LessonContent(
      introText:
          'SQL (Structured Query Language) est le langage standard pour interroger et manipuler '
          'les bases de données relationnelles. Les opérations CRUD (Create, Read, Update, Delete) '
          'couvrent toutes les opérations courantes.',
      lessonBody:
          'SELECT : interroger des données.\n'
          'SELECT colonnes FROM table WHERE condition ORDER BY colonne;\n'
          'Exemple : SELECT Nom, Prenom FROM Etudiant WHERE Filiere = \'Info\' ORDER BY Nom;\n\n'
          'INSERT : ajouter des données.\n'
          'INSERT INTO table (col1, col2) VALUES (val1, val2);\n'
          'Exemple : INSERT INTO Etudiant (Nom, Prenom, Filiere) VALUES (\'Touré\', \'Fatou\', \'Info\');\n\n'
          'UPDATE : modifier des données.\n'
          'UPDATE table SET col1 = val1 WHERE condition;\n'
          'Exemple : UPDATE Etudiant SET Filiere = \'Maths\' WHERE EtudiantID = 1;\n\n'
          'DELETE : supprimer des données.\n'
          'DELETE FROM table WHERE condition;\n'
          'Exemple : DELETE FROM Etudiant WHERE EtudiantID = 2;\n\n'
          'Jointures : combiner des données de plusieurs tables.\n'
          'SELECT E.Nom, I.Note FROM Etudiant E\n'
          'JOIN Inscription I ON E.EtudiantID = I.EtudiantID\n'
          'WHERE I.CoursID = 101;\n\n'
          'Fonctions d\'agrégation :\n'
          '- COUNT(*) : nombre d\'enregistrements\n'
          '- SUM(colonne) : somme\n'
          '- AVG(colonne) : moyenne\n'
          '- MIN/MIN : minimum/maximum\n'
          'GROUP BY : regrouper les résultats (ex : moyenne par filière).',
      example:
          'Exemple — Requête complète :\n'
          'SELECT E.Nom, AVG(I.Note) as Moyenne\n'
          'FROM Etudiant E\n'
          'JOIN Inscription I ON E.EtudiantID = I.EtudiantID\n'
          'GROUP BY E.EtudiantID, E.Nom\n'
          'HAVING AVG(I.Note) >= 12\n'
          'ORDER BY Moyenne DESC;\n\n'
          'Résultat :\n'
          '| Nom    | Moyenne |\n'
          '| Diallo | 15,0    |\n'
          '| Koné   | 12,0    |',
      takeaways: [
        'SELECT ... FROM ... WHERE ... ORDER BY',
        'INSERT INTO ... VALUES ...',
        'UPDATE ... SET ... WHERE ...',
        'DELETE FROM ... WHERE ...',
        'JOIN pour combiner les tables ; GROUP BY pour l\'agrégation',
      ],
    ),
    'info_ch4_l3': const LessonContent(
      introText:
          'La conception de bases de données suit une démarche méthodologique. MERISE est une '
          'méthode française de conception qui distingue le niveau conceptuel (MCD), '
          'le niveau logique (MLD) et le niveau physique (MPD).',
      lessonBody:
          'MERISE est une méthode d\'analyse et de conception des systèmes d\'information. '
          'Elle sépare les données (modèle des données) et les traitements (modèle des traitements) '
          'à chaque niveau d\'abstraction.\n\n'
          'Modèle Conceptuel de Données (MCD) : décrit les entités (objets du monde réel), '
          'les associations (liens entre entités) et les cardinalités (1, n). '
          'Exemple : ETUDIANT (1,n) s\'inscrit (1,n) COURS.\n'
          'Le MCD comprend : entités (rectangle), associations (losange), cardinalités (1, n).\n\n'
          'Modèle Logique de Données (MLD) : traduction du MCD en schéma de tables relationnelles. '
          'Règles de passage :\n'
          '- Entité → table avec sa clé primaire\n'
          '- Association 1:N → clé étrangère du côté N\n'
          '- Association N:N → table intermédiaire\n'
          '- Propriété → colonne\n\n'
          'Modèle Physique de Données (MPD) : implémentation concrète dans un SGBD (MySQL, PostgreSQL). '
          'Définition des types SQL (INT, VARCHAR, DATE, etc.), des contraintes (PRIMARY KEY, FOREIGN KEY, '
          'NOT NULL, UNIQUE), des index pour optimiser les performances.\n\n'
          'Démarche de conception :\n'
          '1) Analyse des besoins (règles de gestion)\n'
          '2) Construction du MCD (entités, associations, cardinalités)\n'
          '3) Passage au MLD (règles de transformation)\n'
          '4) Implémentation du MPD (CREATE TABLE SQL)',
      example:
          'Exemple — MCD vers MLD :\n\n'
          'MCD :\n'
          'ETUDIANT (1,n) ---- s\'inscrit ---- (1,n) COURS\n\n'
          'MLD :\n'
          'Etudiant(EtudiantID PK, Nom, Prenom)\n'
          'Cours(CoursID PK, Intitule, Coefficient)\n'
          'Inscription(EtudiantID FK, CoursID FK, Note)\n\n'
          'CREATE TABLE Inscription (\n'
          '  EtudiantID INT REFERENCES Etudiant(EtudiantID),\n'
          '  CoursID INT REFERENCES Cours(CoursID),\n'
          '  Note DECIMAL(4,2),\n'
          '  PRIMARY KEY (EtudiantID, CoursID)\n'
          ');',
      takeaways: [
        'MERISE : MCD → MLD → MPD',
        'MCD : entités, associations, cardinalités',
        'MLD : tables, clés primaires/étrangères',
        'MPD : CREATE TABLE, types, contraintes SQL',
        'Table intermédiaire pour les relations N:N',
      ],
    ),
  };

  // ===========================================================================
  // INFORMATIQUE — Chapitre 5 : Réseaux et Internet
  // ===========================================================================

  static final Map<String, LessonContent> _infoCh5 = {
    'info_ch5_l1': const LessonContent(
      introText:
          'Les réseaux informatiques permettent la communication entre ordinateurs. Le modèle OSI '
          'décompose les communications en 7 couches, tandis que le modèle TCP/IP est le standard '
          'réel d\'Internet. Comprendre ces modèles est essentiel en informatique.',
      lessonBody:
          'Un réseau informatique est un ensemble d\'équipements reliés pour échanger des données. '
          'Classification : LAN (réseau local, bâtiment), WAN (réseau étendu, ville/pays), '
          'MAN (réseau métropolitain), Internet (réseau mondial).\n\n'
          'Modèle OSI (Open Systems Interconnection) : 7 couches d\'abstraction :\n'
          '7. Application : interface utilisateur (HTTP, FTP, SMTP)\n'
          '6. Présentation : formatage, chiffrement, compression\n'
          '5. Session : gestion des sessions de communication\n'
          '4. Transport : fiabilité (TCP), segmentation, contrôle de flux\n'
          '3. Réseau : adressage logique (IP), routage, commutation de paquets\n'
          '2. Liaison de données : adressage physique (MAC), contrôle d\'erreurs\n'
          '1. Physique : transmission de bits sur le support (câble, fibre, ondes)\n\n'
          'Modèle TCP/IP : 4 couches (plus pratique) :\n'
          '4. Application (HTTP, DNS, SMTP, FTP)\n'
          '3. Transport (TCP : fiable, UDP : rapide)\n'
          '2. Internet (IP : adressage et routage)\n'
          '1. Accès réseau (Ethernet, Wi-Fi)\n\n'
          'Adressage :\n'
          '- IP (IPv4) : 4 octets en décimal pointé (192.168.1.1)\n'
          '- MAC : adresse physique de la carte réseau (AA:BB:CC:DD:EE:FF)\n'
          '- Port : numéro de service (80 = HTTP, 443 = HTTPS, 22 = SSH)',
      example:
          'Exemple — Communication client-serveur :\n'
          '1) Tape "google.com" dans le navigateur\n'
          '2) Couche Application : requête HTTP\n'
          '3) Couche Transport : segment TCP (port 443)\n'
          '4) Couche Internet : paquet IP (dest = 142.250.x.x)\n'
          '5) Couche Liaison : trame Ethernet (MAC du routeur)\n'
          '6) Couche Physique : bits sur le câble/Wi-Fi\n'
          '7) Routeur : examine l\'IP, transmet vers le serveur\n'
          '8) Serveur : traite et renvoie la réponse',
      takeaways: [
        'OSI : 7 couches (théorique) ; TCP/IP : 4 couches (réel)',
        'TCP : fiable, retransmission ; UDP : rapide, sans garantie',
        'IP : adressage logique (192.168.x.x) ; MAC : physique',
        'Port : identifie le service (80=HTTP, 443=HTTPS)',
        'Routeur : interconnecte les réseaux, transmet les paquets',
      ],
    ),
    'info_ch5_l2': const LessonContent(
      introText:
          'Les protocoles Internet (HTTP, DNS, DHCP) régissent la communication entre les '
          'équipements réseau. DNS traduit les noms de domaine en adresses IP, DHCP attribue '
          'automatiquement des configurations réseau, et HTTP permet le transfert de pages web.',
      lessonBody:
          'DNS (Domain Name System) : le « répertoire téléphonique » d\'Internet. Il traduit '
          'les noms de domaine (www.google.com) en adresses IP (142.250.x.x). Fonctionnement : '
          'le client envoie une requête DNS au serveur DNS configuré. Si le serveur ne connaît pas '
          'la réponse, il interroge les serveurs racine → TLD (.com) →权威 (google.com). '
          'Le résultat est mis en cache pour accélérer les requêtes futures.\n\n'
          'DHCP (Dynamic Host Configuration Protocol) : attribue automatiquement une configuration '
          'réseau (adresse IP, masque, passerelle, serveur DNS) aux appareils qui se connectent. '
          'Processus DORA : Discover (client cherche un serveur), Offer (serveur propose une IP), '
          'Request (client accepte), Acknowledge (serveur confirme).\n\n'
          'HTTP/HTTPS : protocole de transfert de pages web.\n'
          '- HTTP (port 80) : texte clair, non sécurisé.\n'
          '- HTTPS (port 443) : chiffré par TLS/SSL, sécurisé.\n'
          'Méthodes HTTP : GET (récupérer une page), POST (envoyer des données), PUT, DELETE.\n'
          'Réponses : 200 OK, 301 Redirection, 404 Not Found, 500 Erreur serveur.\n\n'
          'SMTP : envoi de courrier électronique (port 587/465).\n'
          'POP3/IMAP : réception de courrier (POP3 = télécharge, IMAP = synchronise).\n'
          'FTP : transfert de fichiers (ports 20/21).',
      example:
          'Exemple — Résolution DNS :\n'
          '1) www.exemple.com dans le navigateur\n'
          '2) Consultation cache local → pas trouvé\n'
          '3) Requête au serveur DNS du FAI\n'
          '4) Serveur interroge racine → .com\n'
          '5) Serveur .com → authoritative pour exemple.com\n'
          '6) Réponse : 93.184.216.34\n'
          '7) Le navigateur se connecte à 93.184.216.34:443\n'
          '8) Handshake TLS puis requête GET /',
      takeaways: [
        'DNS : nom de domaine → adresse IP',
        'DHCP : attribution automatique d\'IP (DORA)',
        'HTTP (80) non chiffré ; HTTPS (443) chiffré (TLS)',
        'Méthodes : GET (lire), POST (envoyer), PUT, DELETE',
        'SMTP : envoi mail ; POP3/IMAP : réception',
      ],
    ),
  };

  // ===========================================================================
  // INFORMATIQUE — Chapitre 6 : Sécurité informatique
  // ===========================================================================

  static final Map<String, LessonContent> _infoCh6 = {
    'info_ch6_l1': const LessonContent(
      introText:
          'La sécurité informatique protège les systèmes et les données contre les menaces. '
          'Virus, phishing, attaques par déni de service sont autant de risques qu\'il faut '
          'connaître pour se protéger efficacement.',
      lessonBody:
          'Menaces informatiques principales :\n\n'
          'Malwares (logiciels malveillants) :\n'
          '- Virus : programme qui s\'insère dans un autre programme et se réplique.\n'
          '- Ver (worm) : se répèle automatiquement via le réseau sans hôte.\n'
          '- Cheval de Troie : programme malveillant déguisé en logiciel légitime.\n'
          '- Ransomware (rançongiciel) : chiffre les données et demande une rançon.\n'
          '- Spyware : espionne les activités de l\'utilisateur.\n\n'
          'Phishing (hameçonnage) : technique d\'ingénierie sociale visant à voler des informations '
          'personnelles (identifiants, cartes bancaires) en se faisant passer pour un organisme '
          'de confiance (banque, administration) via des emails ou faux sites web.\n\n'
          'Attaques réseau :\n'
          '- DoS/DDoS : inonder un serveur de requêtes pour le rendre indisponible.\n'
          '- Man-in-the-middle : intercepter les communications entre deux parties.\n'
          '- Brute force : essayer toutes les combinaisons de mots de passe.\n'
          '- SQL injection : injecter du code SQL dans un formulaire.\n\n'
          'Mesures de protection :\n'
          '- Antivirus et pare-feu.\n'
          '- Mises à jour régulières (correctifs de sécurité).\n'
          '- Mots de passe robustes et authentification à deux facteurs (2FA).\n'
          '- Sauvegardes régulières.\n'
          '- Sensibilisation des utilisateurs.\n'
          '- chiffrement des données sensibles.',
      example:
          'Exemple — Phishing :\n'
          'Email reçu : "Votre compte bancaire a été compromis. Cliquez ici pour vérifier."\n\n'
          'Signes d\'alerte :\n'
          '- Adresse email suspecte (banque@banque-secure.xyz)\n'
          '- Fautes d\'orthographe\n'
          '- Demande urgente d\'informations personnelles\n'
          '- Lien vers un site non officiel\n\n'
          'Conduite à tenir :\n'
          '- Ne pas cliquer sur le lien\n'
          '- Contacter la banque directement\n'
          '- Signaler l\'email comme spam/phishing',
      takeaways: [
        'Malwares : virus, ver, cheval de Troie, ransomware',
        'Phishing : hameçonnage pour voler des identifiants',
        'DDoS : surcharge d\'un serveur pour le rendre indisponible',
        'Protection : antivirus, mise à jour, mots de passe, 2FA',
        'Sensibilisation = première ligne de défense',
      ],
    ),
    'info_ch6_l2': const LessonContent(
      introText:
          'La cryptographie est l\'art de protéger l\'information en la rendant illisible pour '
          'les personnes non autorisées. Le chiffrement symétrique et asymétrique sont les deux '
          'grandes familles, utilisées ensemble pour sécuriser les communications sur Internet.',
      lessonBody:
          'Chiffrement symétrique : un seul et même secret (clé) est utilisé pour chiffrer et '
          'déchiffrer. Le problème : comment partager la clé en toute sécurité ?\n'
          'Algorithmes : AES (Advanced Encryption Standard, 128/192/256 bits), DES/3DES (obsolète), '
          'Blowfish. L\'AES est le standard actuel, utilisé pour chiffrer les disques, les VPN, etc.\n\n'
          'Chiffrement asymétrique (à clé publique) : chaque utilisateur possède une paire de clés : '
          'une clé publique (diffusée) et une clé privée (secrète). Ce qui est chiffré avec la clé '
          'publique ne peut être déchiffré qu\'avec la clé privée, et inversement.\n'
          'Algorithmes : RSA (basé sur la factorielle de grands nombres), ECC (courbes elliptiques). '
          'Applications : signature numérique, échange de clés, certificats SSL/TLS.\n\n'
          'Signature numérique : permet de garantir l\'authenticité et l\'intégrité d\'un message. '
          'L\'émetteur signe avec sa clé privée, le destinataire vérifie avec la clé publique. '
          'Utilisée pour les mises à jour logicielles, les emails signés.\n\n'
          'Certificats et PKI : un certificat SSL/TLS atteste qu\'une clé publique appartient bien '
          'à un domaine (ex : www.google.com). Délivré par une autorité de certification (CA). '
          'HTTPS repose sur ces certificats pour sécuriser les communications.\n\n'
          'Hashage : fonction à sens unique (hachage) qui transforme une donnée en empreinte '
          'de taille fixe (ex : SHA-256 = 256 bits). Impossible de retrouver la donnée initiale. '
          'Utilisé pour vérifier l\'intégrité (comparer les hachages) et stocker les mots de passe '
          '(jamais en clair, toujours hachés + salés).',
      example:
          'Exemple — Chiffrement asymétrique :\n'
          'Alice veut envoyer un message secret à Bob.\n'
          '1) Bob génère une paire de clés : publique (B_pub) et privée (B_priv)\n'
          '2) Bob partage B_pub publiquement\n'
          '3) Alice chiffre le message avec B_pub\n'
          '4) Seul B_priv peut déchiffrer → Bob reçoit le message\n\n'
          'Exemple — Hashage de mot de passe :\n'
          'Mot de passe : "MonMotDePasse123"\n'
          'Hash SHA-256 : 5d41402abc4b2a76b9719d911017c592...\n'
          'On stocke le hash, jamais le mot de passe en clair.\n'
          'Au login : on hache la saisie et on compare.',
      takeaways: [
        'Symétrique : même clé pour chiffrer/déchiffrer (AES)',
        'Asymétrique : clé publique + clé privée (RSA)',
        'Signature numérique : authenticité + intégrité',
        'Hashage : fonction à sens unique (SHA-256)',
        'HTTPS = TLS = asymétrique (échange de clé) + symétrique (données)',
      ],
    ),
  };
  // PLACEHOLDER_FOR_BAC_C_CONTENT
}
