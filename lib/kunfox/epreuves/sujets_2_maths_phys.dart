// Sujets n° 2 : mathématiques et physique, séries D et C.

import 'modele.dart';

const epreuveMathsD2 = Epreuve(
  id: 'bac_d_maths_2',
  matiere: 'maths',
  serie: 'D',
  titre: 'Mathématiques',
  session: 'Sujet 2',
  dureeMinutes: 240,
  coefficient: 4,
  consignes: "Calculatrice autorisée. Les trois parties sont indépendantes.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Suites numériques',
      enonce: r'''On considère la suite $(u_n)$ définie par $u_0 = 2$ et, pour tout entier naturel $n$, $u_{n+1} = \dfrac12 u_n + 3$.

On pose $v_n = u_n - 6$.''',
      questions: [
        QuestionEpreuve.nombre('1.a', r"Calcule $u_1$.", valeur: 4, tolerance: 0, points: 0.5, chapitre: 'maths_ch5',
            corrige: r'''$u_1 = \frac12\times2 + 3 = 4$.'''),
        QuestionEpreuve.nombre('1.b', r"Calcule $u_2$.", valeur: 5, tolerance: 0, points: 0.5, chapitre: 'maths_ch5',
            corrige: r'''$u_2 = \frac12\times4 + 3 = 5$.'''),
        QuestionEpreuve.qcm('2', r"La suite $(v_n)$ est :",
            options: [r"géométrique de raison $\frac12$", r"arithmétique de raison $3$", r"géométrique de raison $2$", r"constante"],
            bonne: 0,
            points: 1,
            chapitre: 'maths_ch5',
            corrige: r'''$v_{n+1} = u_{n+1} - 6 = \frac12 u_n - 3 = \frac12(u_n - 6) = \frac12 v_n$ : géométrique de raison $\frac12$, de premier terme $v_0 = -4$.'''),
        QuestionEpreuve.expression('3', r"Exprime $u_n$ en fonction de $n$ : $u_n = \dots$",
            attendue: '6 - 4*0.5^n', variable: 'n', points: 1, chapitre: 'maths_ch5',
            corrige: r'''$v_n = -4\left(\frac12\right)^n$ donc $u_n = 6 - 4\left(\frac12\right)^n$.'''),
        QuestionEpreuve.nombre('4', r"Quelle est la limite de $(u_n)$ ?", valeur: 6, tolerance: 0, points: 0.5, chapitre: 'maths_ch5',
            corrige: r'''$-1 < \frac12 < 1$ donc $\left(\frac12\right)^n \to 0$ et $u_n \to 6$.'''),
        QuestionEpreuve.nombre('5', r"Quel est le plus petit entier $n$ tel que $u_n > 5{,}99$ ?", valeur: 9, tolerance: 0, points: 0.5, chapitre: 'maths_ch5',
            corrige: r'''$4\left(\frac12\right)^n < 0{,}01 \iff 2^n > 400$ ; $2^8 = 256$, $2^9 = 512$ : $n = 9$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Équations différentielles',
      enonce: r'''On étudie deux équations différentielles :
$$(E_1) : y' = 2y \qquad (E_2) : y'' + 4y = 0$$''',
      questions: [
        QuestionEpreuve.expression('1', r"Donne la solution de $(E_1)$ telle que $y(0) = 3$ : $y(x) = \dots$",
            attendue: '3e^(2x)', points: 1, chapitre: 'maths_ch7',
            corrige: r'''Les solutions de $y' = ay$ sont $x \mapsto Ce^{ax}$ ; $y(0) = C = 3$, donc $y(x) = 3e^{2x}$.'''),
        QuestionEpreuve.qcm('2', r"Les solutions de $(E_2)$ sont les fonctions :",
            options: [r"$A\cos 2x + B\sin 2x$", r"$Ae^{2x} + Be^{-2x}$", r"$A\cos 4x + B\sin 4x$", r"$(Ax + B)e^{2x}$"],
            bonne: 0,
            points: 1,
            chapitre: 'maths_ch7',
            corrige: r'''$y'' + \omega^2 y = 0$ avec $\omega = 2$ : $y = A\cos 2x + B\sin 2x$.'''),
        QuestionEpreuve.expression('3', r"Solution de $(E_2)$ avec $y(0) = 1$ et $y'(0) = 2$ : $y(x) = \dots$",
            attendue: 'cos(2x) + sin(2x)', points: 1, chapitre: 'maths_ch7',
            corrige: r'''$y(0) = A = 1$ ; $y'(x) = -2A\sin 2x + 2B\cos 2x$ donc $y'(0) = 2B = 2$, $B = 1$ : $y = \cos 2x + \sin 2x$.'''),
        QuestionEpreuve.nombre('4', r"Calcule $y\left(\frac{\pi}{4}\right)$ pour cette solution.", valeur: 1, tolerance: 0.001, points: 1, chapitre: 'maths_ch7',
            corrige: r'''$\cos\frac{\pi}{2} + \sin\frac{\pi}{2} = 0 + 1 = 1$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Problème : asymptote oblique',
      sousTitre: 'Parties A, B et C',
      enonce: r'''Soit $f$ la fonction définie sur $\mathbb R^*$ par
$$f(x) = x + 1 + \frac1x.$$''',
      questions: [
        QuestionEpreuve.courte('A.1', r"Détermine $\displaystyle\lim_{x\to0^+} f(x)$.",
            acceptees: ['+∞', '∞', '+inf', '+infini', "plus l'infini", 'plus infini'],
            points: 0.5, chapitre: 'maths_ch2',
            corrige: r'''$\frac1x \to +\infty$ quand $x \to 0^+$ : la limite vaut $+\infty$.'''),
        QuestionEpreuve.courte('A.2', r"Détermine $\displaystyle\lim_{x\to0^-} f(x)$.",
            acceptees: ['-∞', '−∞', '-inf', '-infini', "moins l'infini", 'moins infini'],
            points: 0.5, chapitre: 'maths_ch2',
            corrige: r'''$\frac1x \to -\infty$ quand $x \to 0^-$ : la limite vaut $-\infty$. La droite $x = 0$ est asymptote verticale.'''),
        QuestionEpreuve.expression('A.3', r"Calcule $f'(x)$.", attendue: '1 - 1/x^2', points: 1.5, chapitre: 'maths_ch3',
            corrige: r'''$$f'(x) = 1 - \frac{1}{x^2} = \frac{x^2 - 1}{x^2} = \frac{(x-1)(x+1)}{x^2}$$'''),
        QuestionEpreuve.redaction('A.4', r"Dresse le tableau de variations de $f$.",
            chapitre: 'maths_ch3',
            bareme: [
              Critere(r"Signe de $f'$ : celui de $x^2 - 1$", 0.75),
              Critere(r"Extremums $f(-1) = -1$ et $f(1) = 3$", 0.75),
              Critere("Double barre en 0 et limites complètes", 1),
            ],
            corrige: r'''```variations
x     | −∞   |   | −1   |   | 0           |   | 1   |   | +∞
f'(x) |      | + | 0    | − | ||          | − | 0   | + |
f(x)  | −∞ b |   | −1 h |   | −∞ b ‖ +∞ h |   | 3 b |   | +∞ h
```'''),
        QuestionEpreuve.nombre('A.5', r"Calcule le minimum local $f(1)$.", valeur: 3, tolerance: 0, points: 0.5, chapitre: 'maths_ch3',
            corrige: r'''$f(1) = 1 + 1 + 1 = 3$.'''),
        QuestionEpreuve.qcm('B.1', r"La courbe admet en $\pm\infty$ l'asymptote oblique :",
            options: [r"$y = x + 1$", r"$y = x$", r"$y = 1$", r"$y = 2x + 1$"],
            bonne: 0,
            points: 1,
            chapitre: 'maths_ch2',
            corrige: r'''$f(x) - (x + 1) = \frac1x \to 0$ en $\pm\infty$.'''),
        QuestionEpreuve.redaction('B.2', r"Étudie la position de la courbe par rapport à cette asymptote.",
            chapitre: 'maths_ch2',
            bareme: [Critere(r"$f(x) - (x+1) = \frac1x$ : au-dessus pour $x > 0$, au-dessous pour $x < 0$", 1)],
            corrige: r'''$f(x) - (x+1) = \dfrac1x$ : positif sur $]0;+\infty[$ (courbe **au-dessus**), négatif sur $]-\infty;0[$ (courbe **au-dessous**).'''),
        QuestionEpreuve.redaction('B.3', r"Trace la courbe et ses asymptotes.",
            chapitre: 'maths_ch3',
            bareme: [
              Critere("Asymptotes x = 0 et y = x + 1 tracées", 0.5),
              Critere("Extremums (−1 ; −1) et (1 ; 3) placés", 0.5),
              Critere("Allure correcte des deux branches", 0.5),
            ],
            corrige: r'''```graphe
f(x) = x + 1 + 1/x | orange
droite: y = x + 1 | bleu
asymptote: x = 0
x: -5 .. 5
y: -6 .. 8
point: (-1, -1)
point: (1, 3)
```'''),
        QuestionEpreuve.nombre('C.1', r"Calcule l'aire (u.a.) entre la courbe, l'asymptote $y = x + 1$ et les droites $x = 1$ et $x = e$.",
            valeur: 1, tolerance: 0.001, points: 1.5, chapitre: 'maths_ch6',
            corrige: r'''$\displaystyle\int_1^e \frac1x\,dx = [\ln x]_1^e = 1$ u.a.'''),
        QuestionEpreuve.nombre('C.2', r"Calcule $\displaystyle\int_1^2 f(x)\,dx$ (à $10^{-3}$ près).",
            valeur: 3.193147, tolerance: 0.002, points: 1.5, chapitre: 'maths_ch6',
            corrige: r'''$\displaystyle\int_1^2 f = \left[\frac{x^2}{2} + x + \ln x\right]_1^2 = (2 + 2 + \ln 2) - \left(\frac12 + 1\right) = \frac52 + \ln 2 \approx 3{,}193$.'''),
      ],
    ),
  ],
);

const epreuveMathsC2 = Epreuve(
  id: 'bac_c_maths_2',
  matiere: 'maths_c',
  serie: 'C',
  titre: 'Mathématiques',
  session: 'Sujet 2',
  dureeMinutes: 300,
  coefficient: 5,
  consignes: "Calculatrice autorisée. Les exercices et le problème sont indépendants.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Arithmétique',
      enonce: r'''Questions indépendantes de divisibilité et de congruences.''',
      questions: [
        QuestionEpreuve.nombre('1', r"Quel est le reste de la division de $3^{100}$ par $5$ ?", valeur: 1, tolerance: 0, points: 1, chapitre: 'maths_c_ch10',
            corrige: r'''$3^4 = 81 \equiv 1 \pmod 5$ et $100 = 4\times25$ : $3^{100} \equiv 1 \pmod 5$.'''),
        QuestionEpreuve.nombre('2', r"Calcule $\mathrm{PGCD}(924 ; 360)$.", valeur: 12, tolerance: 0, points: 0.5, chapitre: 'maths_c_ch10',
            corrige: r'''$924 = 2\times360 + 204$ ; $360 = 204 + 156$ ; $204 = 156 + 48$ ; $156 = 3\times48 + 12$ ; $48 = 4\times12$ : PGCD $= 12$.'''),
        QuestionEpreuve.nombre('3', r"Combien $360$ a-t-il de diviseurs positifs ?", valeur: 24, tolerance: 0, points: 1, chapitre: 'maths_c_ch10',
            corrige: r'''$360 = 2^3\times3^2\times5$ : $(3+1)(2+1)(1+1) = 24$ diviseurs.'''),
        QuestionEpreuve.redaction('4', r"Démontre que pour tout entier naturel $n$, $n(n+1)(n+2)$ est divisible par $6$.",
            chapitre: 'maths_c_ch10',
            bareme: [
              Critere("Parmi deux entiers consécutifs, l'un est pair : divisible par 2", 0.5),
              Critere("Parmi trois entiers consécutifs, l'un est multiple de 3", 0.5),
              Critere("2 et 3 premiers entre eux : divisible par 6", 0.5),
            ],
            corrige: r'''Parmi $n$, $n+1$, $n+2$ il y a au moins un nombre pair, donc $2$ divise le produit ; et exactement un multiple de $3$, donc $3$ divise le produit. Comme $\mathrm{PGCD}(2 ; 3) = 1$, $6$ divise $n(n+1)(n+2)$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Loi binomiale',
      enonce: r'''Un archer atteint sa cible avec une probabilité $p = 0{,}8$. Il tire $5$ flèches, de façon indépendante. $X$ est le nombre de cibles atteintes.''',
      questions: [
        QuestionEpreuve.qcm('1', r"$X$ suit la loi :", options: [r"$\mathcal B(5 ; 0{,}8)$", r"$\mathcal B(0{,}8 ; 5)$", r"uniforme sur $\{0,\dots,5\}$", r"$\mathcal B(5 ; 0{,}2)$"],
            bonne: 0, points: 1, chapitre: 'maths_c_ch8',
            corrige: r'''5 épreuves de Bernoulli identiques et indépendantes, de succès $p = 0{,}8$ : $X \sim \mathcal B(5 ; 0{,}8)$.'''),
        QuestionEpreuve.nombre('2', r"Calcule $P(X = 5)$.", valeur: 0.32768, tolerance: 0.005, points: 1, chapitre: 'maths_c_ch8',
            corrige: r'''$0{,}8^5 = 0{,}32768$.'''),
        QuestionEpreuve.nombre('3', r"Calcule $P(X \geq 1)$.", valeur: 0.99968, tolerance: 0.0005, points: 1, chapitre: 'maths_c_ch8',
            corrige: r'''$P(X \geq 1) = 1 - P(X = 0) = 1 - 0{,}2^5 = 0{,}99968$.'''),
        QuestionEpreuve.nombre('4', r"Calcule l'espérance $E(X)$.", valeur: 4, tolerance: 0.001, points: 1, chapitre: 'maths_c_ch8',
            corrige: r'''$E(X) = np = 5\times0{,}8 = 4$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Problème : exponentielle',
      sousTitre: 'Parties A, B et C',
      enonce: r'''Soit $f$ la fonction définie sur $\mathbb R$ par
$$f(x) = (x - 1)e^{x} + 1.$$''',
      questions: [
        QuestionEpreuve.nombre('A.1', r"Détermine $\displaystyle\lim_{x\to-\infty} f(x)$.", valeur: 1, tolerance: 0, points: 0.5, chapitre: 'maths_c_ch4',
            corrige: r'''$\lim\limits_{x\to-\infty} xe^x = 0$ et $\lim\limits_{x\to-\infty} e^x = 0$ : la limite vaut $1$ ; asymptote $y = 1$ en $-\infty$.'''),
        QuestionEpreuve.courte('A.2', r"Détermine $\displaystyle\lim_{x\to+\infty} f(x)$.",
            acceptees: ['+∞', '∞', '+inf', '+infini', "plus l'infini", 'plus infini'],
            points: 0.5, chapitre: 'maths_c_ch4',
            corrige: r'''$(x - 1) \to +\infty$ et $e^x \to +\infty$ : la limite vaut $+\infty$.'''),
        QuestionEpreuve.expression('A.3', r"Calcule $f'(x)$.", attendue: 'x*e^x', points: 1.5, chapitre: 'maths_c_ch3',
            corrige: r'''$f'(x) = e^x + (x - 1)e^x = x\,e^x$.'''),
        QuestionEpreuve.redaction('A.4', r"Dresse le tableau de variations de $f$.",
            chapitre: 'maths_c_ch3',
            bareme: [
              Critere(r"$f'(x)$ du signe de $x$", 0.75),
              Critere(r"Minimum $f(0) = 0$", 0.75),
              Critere("Tableau complet avec limites", 1),
            ],
            corrige: r'''```variations
x     | −∞  |   | 0   |   | +∞
f'(x) |     | − | 0   | + |
f(x)  | 1 h |   | 0 b |   | +∞ h
```'''),
        QuestionEpreuve.qcm('A.5', r"On en déduit que, pour tout réel $x$ :", options: [r"$f(x) \geq 0$", r"$f(x) \leq 0$", r"$f(x) > 1$", r"$f(x) < 1$"],
            bonne: 0, points: 1, chapitre: 'maths_c_ch3',
            corrige: r'''Le minimum de $f$ sur $\mathbb R$ est $f(0) = 0$, donc $f(x) \geq 0$ : soit $(x - 1)e^x \geq -1$.'''),
        QuestionEpreuve.nombre('B.1', r"Résous $f(x) = 1$.", valeur: 1, tolerance: 0, points: 1, chapitre: 'maths_c_ch4',
            corrige: r'''$(x - 1)e^x = 0 \iff x = 1$ (car $e^x > 0$).'''),
        QuestionEpreuve.expression('B.2', r"Équation de la tangente au point d'abscisse 1 : $y = \dots$",
            attendue: 'e*(x-1) + 1', points: 1, chapitre: 'maths_c_ch3',
            corrige: r'''$f(1) = 1$ et $f'(1) = e$ : $y = e(x - 1) + 1$.'''),
        QuestionEpreuve.redaction('B.3', r"Trace la courbe de $f$.",
            chapitre: 'maths_c_ch3',
            bareme: [
              Critere("Asymptote y = 1 en −∞", 0.5),
              Critere("Minimum (0 ; 0) et passage par (1 ; 1)", 0.5),
              Critere("Allure correcte", 0.5),
            ],
            corrige: r'''```graphe
f(x) = (x - 1)e^x + 1 | violet
droite: y = 1 | gris
x: -5 .. 2
y: -0.5 .. 4
point: (0, 0)
point: (1, 1)
```'''),
        QuestionEpreuve.redaction('C.1', r"Montre que $G(x) = (x - 2)e^x$ est une primitive de $(x - 1)e^x$.",
            chapitre: 'maths_c_ch6',
            bareme: [Critere(r"$G'(x) = e^x + (x-2)e^x = (x-1)e^x$", 1)],
            corrige: r'''$G'(x) = e^x + (x - 2)e^x = (x - 1)e^x$.'''),
        QuestionEpreuve.nombre('C.2', r"Calcule $\displaystyle\int_0^1 f(x)\,dx$ (à $10^{-3}$ près).", valeur: 0.2817182, tolerance: 0.005, points: 1.5, chapitre: 'maths_c_ch6',
            corrige: r'''$\displaystyle\int_0^1 f = \big[(x-2)e^x + x\big]_0^1 = (-e + 1) - (-2) = 3 - e \approx 0{,}282$.'''),
      ],
    ),
  ],
);

const epreuvePhysiqueD2 = Epreuve(
  id: 'bac_d_physique_2',
  matiere: 'physique',
  serie: 'D',
  titre: 'Physique',
  session: 'Sujet 2',
  dureeMinutes: 240,
  coefficient: 4,
  consignes: "Calculatrice autorisée. g = 10 m·s⁻².",
  exercices: [
    ExerciceEpreuve(
      titre: 'Mouvement dans le champ de pesanteur',
      enonce: r'''Une balle est lancée horizontalement, avec une vitesse $v_0 = 5\ \text{m·s}^{-1}$, depuis une table de hauteur $h = 1{,}8\ \text{m}$. On néglige l'air.

```graphe
y(x) = 1.8 - 0.2x^2 | orange
x: 0 .. 3.5
y: 0 .. 2.2
point: (3, 0) P
titre: trajectoire (m)
```''',
      questions: [
        QuestionEpreuve.redaction('1', "Établis les équations horaires x(t) et y(t) (origine au sol, à la verticale du point de lancement).",
            chapitre: 'physique_ch2',
            bareme: [
              Critere(r"$\vec a = \vec g$ : $a_x = 0$, $a_y = -g$", 0.5),
              Critere(r"$x(t) = v_0 t$ et $y(t) = -\frac12 g t^2 + h$", 1),
            ],
            corrige: r'''Seul le poids agit : $\vec a = \vec g$.
$$x(t) = v_0\,t \qquad y(t) = -\frac12 g\,t^2 + h$$
Trajectoire : $y = h - \dfrac{g}{2v_0^2}x^2 = 1{,}8 - 0{,}2x^2$, une **parabole**.'''),
        QuestionEpreuve.nombre('2', "Calcule la durée de la chute.", valeur: 0.6, tolerance: 0.01, unite: 's', points: 1.5, chapitre: 'physique_ch1',
            corrige: r'''$y = 0 \iff t = \sqrt{\dfrac{2h}{g}} = \sqrt{0{,}36} = 0{,}6\ \text{s}$.'''),
        QuestionEpreuve.nombre('3', "À quelle distance horizontale la balle touche-t-elle le sol ?", valeur: 3, tolerance: 0.01, unite: 'm', points: 1.5, chapitre: 'physique_ch1',
            corrige: r'''$x = v_0 t = 5\times0{,}6 = 3\ \text{m}$.'''),
        QuestionEpreuve.nombre('4', "Calcule la vitesse de la balle à l'impact.", valeur: 7.8102, tolerance: 0.01, unite: 'm/s', points: 1, chapitre: 'physique_ch1',
            corrige: r'''$v_x = 5$, $v_y = -gt = -6$ : $v = \sqrt{25 + 36} = \sqrt{61} \approx 7{,}81\ \text{m·s}^{-1}$.'''),
        QuestionEpreuve.qcm('5', "La trajectoire est :", options: ['une portion de parabole', 'une droite', 'un cercle', 'une hyperbole'],
            bonne: 0, points: 0.5, chapitre: 'physique_ch1',
            corrige: r'''$y$ est un polynôme du second degré en $x$ : parabole.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Énergie électrique',
      enonce: r'''Un fer à repasser porte les indications **220 V – 1 000 W**. Le kWh coûte 100 FCFA.''',
      questions: [
        QuestionEpreuve.nombre('1', "Calcule l'intensité du courant qui le traverse.", valeur: 4.5454, tolerance: 0.01, unite: 'A', points: 1, chapitre: 'physique_ch3',
            corrige: r'''$I = \dfrac PU = \dfrac{1000}{220} \approx 4{,}55\ \text{A}$.'''),
        QuestionEpreuve.nombre('2', "Calcule sa résistance.", valeur: 48.4, tolerance: 0.01, unite: 'Ω', points: 1, chapitre: 'physique_ch3',
            corrige: r'''$R = \dfrac{U^2}{P} = \dfrac{48\,400}{1000} = 48{,}4\ \Omega$.'''),
        QuestionEpreuve.nombre('3', "Énergie consommée en 2 h de repassage (en joules).", valeur: 7.2e6, tolerance: 0.01, unite: 'J', points: 1, chapitre: 'physique_ch3',
            corrige: r'''$W = Pt = 1000\times7200 = 7{,}2\times10^6\ \text{J}$ (soit 2 kWh).'''),
        QuestionEpreuve.nombre('4', "Combien coûtent ces 2 heures (FCFA) ?", valeur: 200, tolerance: 0, points: 1, chapitre: 'physique_ch3',
            corrige: r'''$2\ \text{kWh}\times100 = 200$ FCFA.'''),
        QuestionEpreuve.redaction('5', "Qu'est-ce que l'effet Joule ? Donne un avantage et un inconvénient.",
            chapitre: 'physique_ch3',
            bareme: [
              Critere("Dégagement de chaleur dans un conducteur parcouru par un courant", 0.5),
              Critere("Avantage (chauffage, fer…) et inconvénient (pertes, échauffement des câbles)", 0.5),
            ],
            corrige: r'''L'**effet Joule** est le dégagement de chaleur dans un conducteur traversé par un courant ($P = RI^2$). Avantage : chauffage (fer, bouilloire). Inconvénient : pertes d'énergie dans les lignes et échauffement dangereux des câbles.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Optique',
      enonce: r'''Une lentille convergente a une distance focale $f' = 20\ \text{cm}$. Un objet est placé à $60\ \text{cm}$ devant elle.''',
      questions: [
        QuestionEpreuve.nombre('1', "Position de l'image OA' (cm).", valeur: 30, tolerance: 0.01, unite: 'cm', points: 1.5, chapitre: 'physique_ch7',
            corrige: r'''$\dfrac{1}{\overline{OA'}} = \dfrac{1}{20} - \dfrac{1}{60} = \dfrac{2}{60}$ : $\overline{OA'} = 30\ \text{cm}$.'''),
        QuestionEpreuve.nombre('2', "Grandissement γ.", valeur: -0.5, tolerance: 0.01, points: 1, chapitre: 'physique_ch7',
            corrige: r'''$\gamma = \dfrac{30}{-60} = -0{,}5$.'''),
        QuestionEpreuve.nombre('3', "Vergence de la lentille (en dioptries).", valeur: 5, tolerance: 0.01, unite: 'δ', points: 1, chapitre: 'physique_ch7',
            corrige: r'''$C = \dfrac{1}{f'} = \dfrac{1}{0{,}20} = 5\ \delta$.'''),
        QuestionEpreuve.qcm('4', "L'image est :", options: ['réelle et renversée', 'virtuelle et droite', 'réelle et droite', 'à l\'infini'],
            bonne: 0, points: 0.5, chapitre: 'physique_ch7',
            corrige: r'''$\overline{OA'} > 0$ (réelle) et $\gamma < 0$ (renversée).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Physique nucléaire',
      enonce: r'''Le cobalt 60, utilisé en radiothérapie, est radioactif $\beta^-$ de demi-vie $T = 5{,}27$ ans.''',
      questions: [
        QuestionEpreuve.nombre('1', "Pourcentage de noyaux restant au bout de 15,81 ans (%).", valeur: 12.5, tolerance: 0.01, unite: '%', points: 1.5, chapitre: 'physique_ch6',
            corrige: r'''$15{,}81 = 3T$ : il reste $\dfrac{1}{2^3} = 12{,}5\ \%$.'''),
        QuestionEpreuve.nombre('2', "Constante radioactive λ (an⁻¹).", valeur: 0.131527, tolerance: 0.01, points: 1.5, chapitre: 'physique_ch6',
            corrige: r'''$\lambda = \dfrac{\ln 2}{5{,}27} \approx 0{,}132\ \text{an}^{-1}$.'''),
        QuestionEpreuve.qcm('3', "La particule émise lors d'une désintégration β⁻ est :", options: ['un électron', 'un positon', 'un noyau d\'hélium', 'un neutron'],
            bonne: 0, points: 1, chapitre: 'physique_ch6',
            corrige: r'''β⁻ : un neutron se transforme en proton en émettant un **électron** (et un antineutrino).'''),
        QuestionEpreuve.redaction('4', r"Que traduit la relation $E = mc^2$ ?",
            chapitre: 'physique_ch6',
            bareme: [Critere("Équivalence masse-énergie : une perte de masse libère de l'énergie", 1)],
            corrige: r'''Einstein : la masse est une forme d'énergie. Lors d'une réaction nucléaire, la masse des produits est inférieure à celle des réactifs ; ce **défaut de masse** $\Delta m$ est libéré sous forme d'énergie $E = \Delta m\,c^2$.'''),
      ],
    ),
  ],
);

const epreuvePhysiqueC2 = Epreuve(
  id: 'bac_c_physique_2',
  matiere: 'physique_c',
  serie: 'C',
  titre: 'Physique',
  session: 'Sujet 2',
  dureeMinutes: 300,
  coefficient: 5,
  consignes: "Calculatrice autorisée. Donne les résultats avec leur unité.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Pendule simple',
      enonce: r'''Un pendule simple de longueur $L = 1\ \text{m}$ oscille avec de petites amplitudes en un lieu où $g = 9{,}8\ \text{m·s}^{-2}$.''',
      questions: [
        QuestionEpreuve.nombre('1', r"Calcule la période propre $T_0 = 2\pi\sqrt{L/g}$.", valeur: 2.00709, tolerance: 0.01, unite: 's', points: 1.5, chapitre: 'physique_c_ch3',
            corrige: r'''$T_0 = 2\pi\sqrt{\dfrac{1}{9{,}8}} \approx 2{,}01\ \text{s}$.'''),
        QuestionEpreuve.nombre('2', "Calcule sa fréquence.", valeur: 0.49823, tolerance: 0.01, unite: 'Hz', points: 1, chapitre: 'physique_c_ch3',
            corrige: r'''$N = \dfrac{1}{T_0} \approx 0{,}498\ \text{Hz}$.'''),
        QuestionEpreuve.nombre('3', "Quelle longueur donne une période de 1 s ?", valeur: 0.24824, tolerance: 0.01, unite: 'm', points: 1.5, chapitre: 'physique_c_ch3',
            corrige: r'''$L = \dfrac{g\,T^2}{4\pi^2} = \dfrac{9{,}8}{4\pi^2} \approx 0{,}248\ \text{m}$.'''),
        QuestionEpreuve.redaction('4', "Qu'appelle-t-on l'isochronisme des petites oscillations ?",
            chapitre: 'physique_c_ch3',
            bareme: [Critere("La période ne dépend pas de l'amplitude (pour de petites amplitudes)", 1)],
            corrige: r'''Pour de petites amplitudes (moins de 10° environ), la période **ne dépend pas de l'amplitude** : c'est le principe des horloges à balancier.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Champ électrique',
      enonce: r'''Deux plaques parallèles distantes de $d = 2\ \text{cm}$ sont soumises à une tension $U = 200\ \text{V}$. Un électron ($e = 1{,}6\times10^{-19}\ \text{C}$) pénètre entre les plaques.''',
      questions: [
        QuestionEpreuve.nombre('1', "Intensité du champ électrique (V/m).", valeur: 10000, tolerance: 0.01, unite: 'V/m', points: 1.5, chapitre: 'physique_c_ch9',
            corrige: r'''$E = \dfrac Ud = \dfrac{200}{0{,}02} = 10^4\ \text{V·m}^{-1}$.'''),
        QuestionEpreuve.nombre('2', "Intensité de la force électrique sur l'électron (N).", valeur: 1.6e-15, tolerance: 0.01, unite: 'N', points: 1.5, chapitre: 'physique_c_ch9',
            corrige: r'''$F = eE = 1{,}6\times10^{-19}\times10^4 = 1{,}6\times10^{-15}\ \text{N}$.'''),
        QuestionEpreuve.qcm('3', "La force subie par l'électron est :", options: ['opposée au champ', 'dans le sens du champ', 'perpendiculaire au champ', 'nulle'],
            bonne: 0, points: 1, chapitre: 'physique_c_ch9',
            corrige: r'''$\vec F = q\vec E$ avec $q = -e < 0$ : la force est **opposée** à $\vec E$ (vers la plaque positive).'''),
        QuestionEpreuve.redaction('4', "Décris la trajectoire d'un électron entrant perpendiculairement au champ.",
            chapitre: 'physique_c_ch9',
            bareme: [Critere("Mouvement uniformément accéléré perpendiculairement, uniforme parallèlement : parabole", 1)],
            corrige: r'''Comme un projectile dans le champ de pesanteur : vitesse constante parallèlement aux plaques, accélération constante perpendiculairement. La trajectoire est une **parabole**, déviée vers la plaque positive.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Interférences lumineuses',
      enonce: r'''Dans l'expérience des fentes d'Young, une lumière de longueur d'onde $\lambda = 600\ \text{nm}$ éclaire deux fentes distantes de $a = 0{,}5\ \text{mm}$. L'écran est à $D = 1\ \text{m}$.''',
      questions: [
        QuestionEpreuve.nombre('1', r"Calcule l'interfrange $i = \lambda D/a$ (en mm).", valeur: 1.2, tolerance: 0.01, unite: 'mm', points: 2, chapitre: 'physique_c_ch7',
            corrige: r'''$i = \dfrac{600\times10^{-9}\times1}{0{,}5\times10^{-3}} = 1{,}2\times10^{-3}\ \text{m} = 1{,}2\ \text{mm}$.'''),
        QuestionEpreuve.nombre('2', "Largeur occupée par 5 interfranges (mm).", valeur: 6, tolerance: 0.01, unite: 'mm', points: 1, chapitre: 'physique_c_ch7',
            corrige: r'''$5\times1{,}2 = 6\ \text{mm}$.'''),
        QuestionEpreuve.qcm('3', "Ce phénomène met en évidence :", options: ['la nature ondulatoire de la lumière', 'sa nature corpusculaire', 'la réfraction', 'l\'effet photoélectrique'],
            bonne: 0, points: 1, chapitre: 'physique_c_ch7',
            corrige: r'''Seules des **ondes** peuvent interférer : franges brillantes et sombres.'''),
        QuestionEpreuve.redaction('4', "Explique l'origine des franges sombres.",
            chapitre: 'physique_c_ch7',
            bareme: [Critere("Ondes arrivant en opposition de phase : différence de marche (2k+1)λ/2", 1)],
            corrige: r'''En un point sombre, les ondes issues des deux fentes arrivent en **opposition de phase** : leur différence de marche vaut $(2k+1)\dfrac\lambda2$ et elles s'annulent.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Satellite en orbite',
      enonce: r'''Un satellite tourne autour de la Terre (rayon $R = 6\,400\ \text{km}$) à l'altitude $h = 600\ \text{km}$. On donne $g_0 = 9{,}8\ \text{m·s}^{-2}$ au sol.''',
      questions: [
        QuestionEpreuve.nombre('1', r"Calcule sa vitesse $v = R\sqrt{\dfrac{g_0}{R + h}}$ (m/s).", valeur: 7572.6, tolerance: 0.01, unite: 'm/s', points: 2, chapitre: 'physique_c_ch2',
            corrige: r'''$v = 6{,}4\times10^6\sqrt{\dfrac{9{,}8}{7{,}0\times10^6}} \approx 7\,573\ \text{m·s}^{-1}$.'''),
        QuestionEpreuve.nombre('2', "Calcule sa période (s).", valeur: 5808.2, tolerance: 0.01, unite: 's', points: 1.5, chapitre: 'physique_c_ch2',
            corrige: r'''$T = \dfrac{2\pi(R + h)}{v} = \dfrac{2\pi\times7\times10^6}{7\,573} \approx 5\,808\ \text{s}$, environ 1 h 37 min.'''),
        QuestionEpreuve.qcm('3', "Dans le référentiel géocentrique, son mouvement est :", options: ['circulaire uniforme', 'rectiligne uniforme', 'circulaire accéléré', 'parabolique'],
            bonne: 0, points: 0.5, chapitre: 'physique_c_ch2',
            corrige: r'''La force de gravitation, centripète, donne un mouvement circulaire uniforme.'''),
        QuestionEpreuve.redaction('4', "Énonce la troisième loi de Kepler.",
            chapitre: 'physique_c_ch2',
            bareme: [Critere(r"$\dfrac{T^2}{r^3}$ est constant pour tous les satellites d'un même astre", 1)],
            corrige: r'''Pour tous les satellites d'un même astre attracteur, $\dfrac{T^2}{r^3} = \dfrac{4\pi^2}{GM}$ est **constant**.'''),
      ],
    ),
  ],
);
