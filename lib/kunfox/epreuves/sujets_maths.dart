// Épreuves de mathématiques, séries D et C (format Office du Bac).
// Tous les résultats numériques ont été recalculés ; les corrigés suivent
// la rédaction attendue au Bac.

import 'modele.dart';

const epreuveMathsD = Epreuve(
  id: 'bac_d_maths_1',
  matiere: 'maths',
  serie: 'D',
  titre: 'Mathématiques',
  dureeMinutes: 240,
  coefficient: 4,
  consignes: 'Calculatrice autorisée. Les trois parties sont indépendantes. '
      'La qualité de la rédaction compte : justifie chaque résultat.',
  exercices: [
    ExerciceEpreuve(
      titre: 'Nombres complexes',
      enonce: r'''On considère dans $\mathbb{C}$ l'équation $(E) : z^2 - 2z + 5 = 0$.

Dans le plan complexe muni d'un repère orthonormé direct $(O ; \vec u, \vec v)$, on note $A$, $B$ et $C$ les points d'affixes $z_A = 1 + 2i$, $z_B = 1 - 2i$ et $z_C = 3$.''',
      questions: [
        QuestionEpreuve.nombre('1.a', r"Calcule le discriminant $\Delta$ de $(E)$.",
            valeur: -16, tolerance: 0, points: 0.5, chapitre: 'maths_ch1', corrige: r'''$$\Delta = (-2)^2 - 4\times1\times5 = 4 - 20 = -16$$'''),
        QuestionEpreuve.qcm('1.b', r"Les solutions de $(E)$ sont :",
            options: [r'$1+2i$ et $1-2i$', r'$2+i$ et $2-i$', r'$-1+2i$ et $-1-2i$', r'$1+4i$ et $1-4i$'],
            bonne: 0,
            points: 0.5,
            chapitre: 'maths_ch1',
            corrige: r'''$\Delta = -16 = (4i)^2$, donc $z_1 = \dfrac{2 + 4i}{2} = 1 + 2i$ et $z_2 = \overline{z_1} = 1 - 2i$.'''),
        QuestionEpreuve.nombre('2', r"Calcule $|z_A - z_C|$ (valeur exacte ou approchée).",
            valeur: 2.8284271247, tolerance: 0.002, points: 0.5, chapitre: 'maths_ch1', corrige: r'''$z_A - z_C = -2 + 2i$, donc $|z_A - z_C| = \sqrt{4 + 4} = 2\sqrt2 \approx 2{,}83$.'''),
        QuestionEpreuve.nombre('3', r"Calcule le produit $z_A \times z_B$.",
            valeur: 5, tolerance: 0, points: 0.5, chapitre: 'maths_ch1', corrige: r'''$z_A z_B = (1+2i)(1-2i) = 1 - 4i^2 = 1 + 4 = 5$ (c'est $|z_A|^2$).'''),
        QuestionEpreuve.qcm('4.a', r"Le quotient $\dfrac{z_A - z_C}{z_B - z_C}$ est égal à :",
            options: [r'$-i$', r'$i$', r'$1$', r'$-1 + i$'],
            bonne: 0,
            points: 1,
            chapitre: 'maths_ch1',
            corrige: r'''$$\frac{-2+2i}{-2-2i} = \frac{(-2+2i)(-2+2i)}{(-2)^2 + 2^2} = \frac{4 - 8i - 4}{8} = -i$$'''),
        QuestionEpreuve.redaction('4.b', r"En déduire la nature du triangle $ABC$. Justifie.",
            chapitre: 'maths_ch1',
            bareme: [
              Critere(r"Module du quotient égal à 1, donc $CA = CB$", 0.5),
              Critere(r"Argument $-\frac{\pi}{2}$, donc $(\overrightarrow{CB}, \overrightarrow{CA}) = -\frac{\pi}{2}$ : angle droit en $C$", 0.5),
            ],
            corrige: r'''Le quotient vaut $-i$.

- $\left|\dfrac{z_A - z_C}{z_B - z_C}\right| = |-i| = 1$ donc $CA = CB$ : le triangle est **isocèle en $C$**.
- $\arg(-i) = -\dfrac{\pi}{2}$ donc $(\overrightarrow{CB}, \overrightarrow{CA}) = -\dfrac{\pi}{2}$ : il est **rectangle en $C$**.

$ABC$ est un triangle **rectangle isocèle en $C$**.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Probabilités',
      enonce: r'''Une urne contient **4 boules rouges** et **6 boules vertes**, indiscernables au toucher. On tire **simultanément 3 boules** au hasard.

On note $X$ la variable aléatoire égale au nombre de boules rouges tirées.''',
      questions: [
        QuestionEpreuve.nombre('1', 'Combien y a-t-il de tirages possibles ?',
            valeur: 120, tolerance: 0, points: 0.5, chapitre: 'maths_ch8', corrige: r'''$$\binom{10}{3} = \frac{10\times9\times8}{3\times2\times1} = 120$$'''),
        QuestionEpreuve.nombre('2', r"Calcule $P(X = 3)$ (fraction ou décimal).",
            valeur: 1 / 30, tolerance: 0.01, points: 0.5, chapitre: 'maths_ch8', corrige: r'''$$P(X=3) = \frac{\binom43}{120} = \frac{4}{120} = \frac{1}{30}$$'''),
        QuestionEpreuve.nombre('3', r"Calcule $P(X = 1)$.",
            valeur: 0.5, tolerance: 0.001, points: 0.75, chapitre: 'maths_ch8', corrige: r'''$$P(X=1) = \frac{\binom41\binom62}{120} = \frac{4\times15}{120} = \frac12$$'''),
        QuestionEpreuve.redaction('4', r"Donne la loi de probabilité de $X$ sous forme de tableau.",
            chapitre: 'maths_ch8',
            bareme: [
              Critere(r"Valeurs prises : $0, 1, 2, 3$", 0.25),
              Critere(r"$P(X=0) = \frac{20}{120}$ et $P(X=2) = \frac{36}{120}$", 0.75),
              Critere('La somme des probabilités vaut 1 (vérification)', 0.5),
            ],
            corrige: r'''$P(X=0) = \dfrac{\binom63}{120} = \dfrac{20}{120}$ ; $P(X=2) = \dfrac{\binom42\binom61}{120} = \dfrac{36}{120}$.

```tableau
$x_i$ | 0 | 1 | 2 | 3
$P(X=x_i)$ | $\frac{20}{120}$ | $\frac{60}{120}$ | $\frac{36}{120}$ | $\frac{4}{120}$
```

Vérification : $20 + 60 + 36 + 4 = 120$.'''),
        QuestionEpreuve.nombre('5', r"Calcule l'espérance $E(X)$.",
            valeur: 1.2, tolerance: 0.001, points: 0.75, chapitre: 'maths_ch8', corrige: r'''$$E(X) = \frac{0\times20 + 1\times60 + 2\times36 + 3\times4}{120} = \frac{144}{120} = 1{,}2$$'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Problème : étude de fonction',
      sousTitre: 'Parties A, B et C',
      enonce: r'''Soit $f$ la fonction définie sur $\mathbb{R}$ par
$$f(x) = (x + 2)\,e^{-x}$$
et $(\mathcal C)$ sa courbe représentative dans un repère orthonormé (unité 2 cm).''',
      questions: [
        QuestionEpreuve.nombre('A.1', r"Détermine $\displaystyle\lim_{x \to +\infty} f(x)$.",
            valeur: 0, tolerance: 0, points: 0.5, chapitre: 'maths_ch4', corrige: r'''$f(x) = x e^{-x} + 2e^{-x}$. Par croissances comparées $\lim\limits_{x\to+\infty} x e^{-x} = 0$ et $\lim\limits_{x\to+\infty} e^{-x} = 0$, donc la limite vaut $0$.'''),
        QuestionEpreuve.courte('A.2', r"Détermine $\displaystyle\lim_{x \to -\infty} f(x)$.",
            acceptees: ['-∞', '−∞', '-inf', '-infini', 'moins l\'infini', 'moins infini'],
            points: 0.5,
            chapitre: 'maths_ch2',
            corrige: r'''$\lim\limits_{x\to-\infty} (x+2) = -\infty$ et $\lim\limits_{x\to-\infty} e^{-x} = +\infty$ : par produit, $\lim\limits_{x\to-\infty} f(x) = -\infty$.'''),
        QuestionEpreuve.expression('A.3', r"Calcule $f'(x)$.",
            attendue: '-(x+1)e^(-x)', points: 1.5, chapitre: 'maths_ch3', corrige: r'''$f = uv$ avec $u = x + 2$, $v = e^{-x}$ : $u' = 1$, $v' = -e^{-x}$.
$$f'(x) = e^{-x} - (x+2)e^{-x} = -(x+1)\,e^{-x}$$'''),
        QuestionEpreuve.redaction('A.4', r"Étudie le signe de $f'(x)$ et dresse le tableau de variations de $f$.",
            chapitre: 'maths_ch3',
            bareme: [
              Critere(r"$e^{-x} > 0$, donc $f'(x)$ a le signe de $-(x+1)$", 0.5),
              Critere(r"$f$ croissante sur $]-\infty ; -1]$, décroissante sur $[-1 ; +\infty[$", 0.75),
              Critere(r"Maximum $f(-1) = e$", 0.5),
              Critere('Tableau complet avec les limites', 0.75),
            ],
            corrige: r'''Comme $e^{-x} > 0$, $f'(x)$ est du signe de $-(x+1)$ : positif pour $x < -1$, négatif pour $x > -1$.

$f(-1) = (-1+2)e^{1} = e$.

```variations
x     | −∞   |   | −1  |   | +∞
f'(x) |      | + | 0   | − |
f(x)  | −∞ b |   | e h |   | 0 b
```'''),
        QuestionEpreuve.expression('B.1', r"Donne une équation de la tangente $(T)$ à $(\mathcal C)$ au point d'abscisse $0$ : $y = \dots$",
            attendue: '-x+2', points: 1, chapitre: 'maths_ch3', corrige: r'''$f(0) = 2$ et $f'(0) = -1$, donc $(T) : y = f'(0)(x - 0) + f(0) = -x + 2$.'''),
        QuestionEpreuve.nombre('B.2', r"Quelle est l'abscisse du point d'intersection de $(\mathcal C)$ avec l'axe des abscisses ?",
            valeur: -2, tolerance: 0, points: 0.5, chapitre: 'maths_ch4', corrige: r'''$f(x) = 0 \iff x + 2 = 0$ (car $e^{-x} \neq 0$) $\iff x = -2$.'''),
        QuestionEpreuve.redaction('B.3', r"Trace $(T)$ et $(\mathcal C)$.",
            chapitre: 'maths_ch3',
            bareme: [
              Critere(r"Asymptote horizontale $y = 0$ en $+\infty$ respectée", 0.5),
              Critere(r"Maximum $(-1 ; e)$ et passage par $(-2 ; 0)$ et $(0 ; 2)$", 0.5),
              Critere(r"Tangente $(T)$ correctement tracée", 0.5),
            ],
            corrige: r'''```graphe
f(x) = (x+2)e^(-x) | orange
droite: y = -x + 2 | bleu
x: -3 .. 5
y: -2 .. 3.5
point: (-1, 2.718) S
point: (-2, 0)
point: (0, 2)
```
La courbe monte jusqu'à $S(-1 ; e)$ puis redescend vers l'axe des abscisses, asymptote en $+\infty$.'''),
        QuestionEpreuve.redaction('C.1', r"Montre que $F(x) = -(x+3)e^{-x}$ est une primitive de $f$ sur $\mathbb{R}$.",
            chapitre: 'maths_ch6',
            bareme: [
              Critere(r"Calcul de $F'(x)$ par la dérivée d'un produit", 0.5),
              Critere(r"Conclusion $F' = f$", 0.5),
            ],
            corrige: r'''$$F'(x) = -e^{-x} - (x+3)(-e^{-x}) = e^{-x}(-1 + x + 3) = (x+2)e^{-x} = f(x)$$'''),
        QuestionEpreuve.nombre('C.2', r"Calcule $\displaystyle\int_0^1 f(x)\,dx$ (valeur exacte ou à $10^{-3}$ près).",
            valeur: 1.528482235, tolerance: 0.002, points: 1.5, chapitre: 'maths_ch6', corrige: r'''$$\int_0^1 f(x)\,dx = F(1) - F(0) = -4e^{-1} + 3 = 3 - \frac{4}{e} \approx 1{,}528$$'''),
        QuestionEpreuve.qcm('C.3', r"$f$ est solution de l'équation différentielle :",
            options: [r"$y' + y = e^{-x}$", r"$y' - y = e^{-x}$", r"$y' + y = 0$", r"$y'' + y = 0$"],
            bonne: 0,
            points: 1,
            chapitre: 'maths_ch7',
            corrige: r'''$f'(x) + f(x) = -(x+1)e^{-x} + (x+2)e^{-x} = e^{-x}$.'''),
      ],
    ),
  ],
);

const epreuveMathsC = Epreuve(
  id: 'bac_c_maths_1',
  matiere: 'maths_c',
  serie: 'C',
  titre: 'Mathématiques',
  dureeMinutes: 300,
  coefficient: 5,
  consignes: 'Calculatrice autorisée. L\'exercice 1, l\'exercice 2 et le problème sont indépendants.',
  exercices: [
    ExerciceEpreuve(
      titre: 'Arithmétique',
      enonce: r'''**1.** On considère les entiers $a = 1071$ et $b = 462$.

**2.** On considère dans $\mathbb{Z}^2$ l'équation $(E) : 51x - 22y = 1$.

**3.** On s'intéresse aux puissances de $2$ modulo $7$.''',
      questions: [
        QuestionEpreuve.nombre('1', r"Détermine $\mathrm{PGCD}(1071 ; 462)$ par l'algorithme d'Euclide.",
            valeur: 21, tolerance: 0, points: 0.5, chapitre: 'maths_c_ch10', corrige: r'''$1071 = 2\times462 + 147$ ; $462 = 3\times147 + 21$ ; $147 = 7\times21 + 0$.

Le dernier reste non nul est $21$ : $\mathrm{PGCD}(1071 ; 462) = 21$.'''),
        QuestionEpreuve.qcm('2.a', r"Parmi ces couples, lequel est une solution particulière de $(E)$ ?",
            options: [r'$(19 ; 44)$', r'$(7 ; 16)$', r'$(3 ; 7)$', r'$(22 ; 51)$'],
            bonne: 0,
            points: 1,
            chapitre: 'maths_c_ch10',
            corrige: r'''$51\times19 - 22\times44 = 969 - 968 = 1$. Les autres donnent $5$, $-1$ et $0$.'''),
        QuestionEpreuve.redaction('2.b', r"Résous $(E)$ dans $\mathbb{Z}^2$.",
            chapitre: 'maths_c_ch10',
            bareme: [
              Critere(r"Soustraction : $51(x - 19) = 22(y - 44)$", 0.5),
              Critere(r"Gauss ($\mathrm{PGCD}(51,22)=1$) : $22 \mid x - 19$", 0.5),
              Critere(r"Solutions $(19 + 22k ; 44 + 51k)$, $k \in \mathbb{Z}$, avec vérification", 0.5),
            ],
            corrige: r'''Si $(x ; y)$ est solution : $51x - 22y = 51\times19 - 22\times44$, donc $51(x - 19) = 22(y - 44)$.

$22$ divise $51(x-19)$ et $\mathrm{PGCD}(22 ; 51) = 1$ : d'après le théorème de Gauss, $22 \mid x - 19$, soit $x = 19 + 22k$. Alors $y = 44 + 51k$.

Réciproquement, ces couples vérifient $(E)$.
$$S = \{(19 + 22k ; 44 + 51k),\ k \in \mathbb{Z}\}$$'''),
        QuestionEpreuve.nombre('3', r"Quel est le reste de la division euclidienne de $2^{2026}$ par $7$ ?",
            valeur: 2, tolerance: 0, points: 1, chapitre: 'maths_c_ch10', corrige: r'''$2^3 = 8 \equiv 1 \pmod 7$ et $2026 = 3\times675 + 1$, donc
$$2^{2026} = (2^3)^{675}\times 2 \equiv 1\times 2 \equiv 2 \pmod 7$$'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Complexes et similitudes',
      enonce: r'''Le plan est rapporté à un repère orthonormé direct. On considère la transformation $s$ qui, au point $M$ d'affixe $z$, associe le point $M'$ d'affixe
$$z' = (1 + i)z - i.$$''',
      questions: [
        QuestionEpreuve.nombre('1.a', r"Quel est le rapport de la similitude $s$ ?",
            valeur: 1.414213562, tolerance: 0.002, points: 0.5, chapitre: 'maths_c_ch1', corrige: r'''Le rapport est $|1 + i| = \sqrt2$.'''),
        QuestionEpreuve.qcm('1.b', r"Une mesure de l'angle de $s$ est :",
            options: [r'$\dfrac{\pi}{4}$', r'$\dfrac{\pi}{2}$', r'$-\dfrac{\pi}{4}$', r'$\pi$'],
            bonne: 0,
            points: 0.5,
            chapitre: 'maths_c_ch1',
            corrige: r'''$1 + i = \sqrt2\,e^{i\pi/4}$ : l'angle est $\dfrac{\pi}{4}$.'''),
        QuestionEpreuve.nombre('1.c', r"Donne l'affixe $\omega$ du centre $\Omega$ de $s$.",
            valeur: 1, tolerance: 0, points: 0.75, chapitre: 'maths_c_ch1', corrige: r'''$\omega = (1+i)\omega - i \iff -i\omega = -i \iff \omega = 1$.'''),
        QuestionEpreuve.nombre('2', r"Quelle est l'affixe de l'image du point $A$ d'affixe $i$ ?",
            valeur: -1, tolerance: 0, points: 0.75, chapitre: 'maths_c_ch1', corrige: r'''$z' = (1+i)i - i = i + i^2 - i = -1$.'''),
        QuestionEpreuve.redaction('3', r"Démontre que $s \circ s$ est une similitude directe dont tu préciseras le rapport et l'angle.",
            chapitre: 'maths_c_ch1',
            bareme: [
              Critere(r"Écriture complexe $z'' = (1+i)^2 z + \dots = 2i\,z + \dots$", 0.5),
              Critere(r"Rapport $2$ et angle $\frac{\pi}{2}$ (même centre $\Omega$)", 0.5),
            ],
            corrige: r'''$s\circ s : z \mapsto (1+i)\big((1+i)z - i\big) - i = (1+i)^2 z - i(1+i) - i = 2i\,z + 1 - 2i$.

$2i = 2e^{i\pi/2}$ : $s \circ s$ est la similitude directe de centre $\Omega(1)$, de **rapport $2$** et d'**angle $\dfrac{\pi}{2}$**.'''),
        QuestionEpreuve.qcm('4', r"Les solutions de $z^3 = 8$ dans $\mathbb{C}$ sont :",
            options: [r'$2$, $2e^{2i\pi/3}$, $2e^{-2i\pi/3}$', r'$2$ seulement', r'$2$, $-2$, $2i$', r'$2$, $2e^{i\pi/3}$, $2e^{-i\pi/3}$'],
            bonne: 0,
            points: 0.5,
            chapitre: 'maths_c_ch1',
            corrige: r'''Les racines cubiques de $8 = 2^3$ sont $2e^{2ik\pi/3}$ pour $k \in \{0 ; 1 ; 2\}$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Problème : logarithme',
      sousTitre: 'Parties A, B et C',
      enonce: r'''Soit $f$ la fonction définie sur $]0 ; +\infty[$ par
$$f(x) = \frac{1 + \ln x}{x}$$
et $(\mathcal C)$ sa courbe dans un repère orthonormé.''',
      questions: [
        QuestionEpreuve.courte('A.1', r"Détermine $\displaystyle\lim_{x \to 0^+} f(x)$.",
            acceptees: ['-∞', '−∞', '-inf', '-infini', 'moins l\'infini', 'moins infini'],
            points: 0.5,
            chapitre: 'maths_c_ch4',
            corrige: r'''$\lim\limits_{x\to0^+} (1 + \ln x) = -\infty$ et $\lim\limits_{x\to0^+} \frac1x = +\infty$ : par produit, $-\infty$.'''),
        QuestionEpreuve.nombre('A.2', r"Détermine $\displaystyle\lim_{x \to +\infty} f(x)$.",
            valeur: 0, tolerance: 0, points: 0.5, chapitre: 'maths_c_ch4', corrige: r'''$f(x) = \dfrac1x + \dfrac{\ln x}{x}$ et $\lim\limits_{x\to+\infty}\dfrac{\ln x}{x} = 0$ : la limite vaut $0$.'''),
        QuestionEpreuve.expression('A.3', r"Calcule $f'(x)$.",
            attendue: '-ln(x)/x^2', points: 1.5, chapitre: 'maths_c_ch3', corrige: r'''$$f'(x) = \frac{\frac1x\cdot x - (1 + \ln x)}{x^2} = \frac{-\ln x}{x^2}$$'''),
        QuestionEpreuve.redaction('A.4', r"Dresse le tableau de variations de $f$.",
            chapitre: 'maths_c_ch3',
            bareme: [
              Critere(r"$f'(x)$ a le signe de $-\ln x$ : positif sur $]0;1[$, négatif sur $]1;+\infty[$", 0.75),
              Critere(r"Maximum $f(1) = 1$", 0.5),
              Critere('Tableau avec les deux limites', 1.25),
            ],
            corrige: r'''$x^2 > 0$ : $f'(x)$ a le signe de $-\ln x$.

```variations
x     | 0    |   | 1   |   | +∞
f'(x) | ||   | + | 0   | − |
f(x)  | −∞ b |   | 1 h |   | 0 b
```'''),
        QuestionEpreuve.nombre('A.5', r"Résous $f(x) = 0$ (valeur exacte ou à $10^{-3}$ près).",
            valeur: 0.3678794412, tolerance: 0.003, points: 1, chapitre: 'maths_c_ch4', corrige: r'''$f(x) = 0 \iff 1 + \ln x = 0 \iff x = e^{-1} = \dfrac1e \approx 0{,}368$.'''),
        QuestionEpreuve.qcm('B.1', r"La courbe $(\mathcal C)$ admet pour asymptotes :",
            options: [r'$x = 0$ et $y = 0$', r'$x = 0$ seulement', r'$y = 1$ et $x = 0$', r'$y = x$'],
            bonne: 0,
            points: 1,
            chapitre: 'maths_c_ch2',
            corrige: r'''Limite infinie en $0^+$ : asymptote verticale $x = 0$. Limite nulle en $+\infty$ : asymptote horizontale $y = 0$.'''),
        QuestionEpreuve.expression('B.2', r"Équation de la tangente à $(\mathcal C)$ au point d'abscisse $1$ : $y = \dots$",
            attendue: '1', points: 1, chapitre: 'maths_c_ch3', corrige: r'''$f(1) = 1$ et $f'(1) = 0$ : la tangente est horizontale, $y = 1$.'''),
        QuestionEpreuve.redaction('B.3', r"Trace $(\mathcal C)$.",
            chapitre: 'maths_c_ch3',
            bareme: [
              Critere('Asymptotes respectées', 0.5),
              Critere(r"Maximum $(1 ; 1)$ et passage par $(\frac1e ; 0)$", 0.5),
              Critere('Allure générale correcte', 0.5),
            ],
            corrige: r'''```graphe
f(x) = (1 + ln(x))/x | violet
x: 0 .. 8
y: -3 .. 1.6
point: (1, 1) S
point: (0.3679, 0)
```'''),
        QuestionEpreuve.redaction('C.1', r"Montre que $F(x) = \ln x + \dfrac{(\ln x)^2}{2}$ est une primitive de $f$.",
            chapitre: 'maths_c_ch6',
            bareme: [Critere(r"$F'(x) = \frac1x + \frac{\ln x}{x} = f(x)$", 1)],
            corrige: r'''$$F'(x) = \frac1x + \frac{2\ln x\cdot\frac1x}{2} = \frac{1 + \ln x}{x} = f(x)$$'''),
        QuestionEpreuve.nombre('C.2', r"Calcule l'aire (en unités d'aire) du domaine limité par $(\mathcal C)$, l'axe des abscisses et les droites $x = \frac1e$ et $x = 1$.",
            valeur: 0.5, tolerance: 0.001, points: 1, chapitre: 'maths_c_ch6', corrige: r'''$f \geq 0$ sur $[\frac1e ; 1]$ :
$$\mathcal A = F(1) - F\!\left(\tfrac1e\right) = 0 - \left(-1 + \tfrac12\right) = \tfrac12 \text{ u.a.}$$'''),
        QuestionEpreuve.qcm('C.3', r"La suite $(v_n)$ définie par $v_n = f(n)$ pour $n \geq 1$ :",
            options: ['est décroissante et converge vers 0', 'est croissante', 'diverge vers +∞', 'converge vers 1'],
            bonne: 0,
            points: 0.5,
            chapitre: 'maths_c_ch5',
            corrige: r'''$f$ est décroissante sur $[1 ; +\infty[$, donc $(v_n)$ est décroissante, et $\lim\limits_{n\to+\infty} f(n) = 0$.'''),
      ],
    ),
  ],
);
