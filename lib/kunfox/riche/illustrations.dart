// « En image » : une carte de plus dans les leçons, avec une courbe, un
// tableau ou une formule clé. Indexé par l'id de la leçon ; plusieurs
// séries partagent la même illustration.

const _limites = r'''Trois comportements à reconnaître sur une courbe :

```graphe
f(x) = 1/x | violet
g(x) = e^x | orange
h(x) = ln(x) | vert
x: -4 .. 5
y: -4 .. 5
```

$$\lim_{x\to0^+}\frac1x = +\infty \qquad \lim_{x\to-\infty} e^x = 0 \qquad \lim_{x\to+\infty}\ln x = +\infty$$''';

const _tvi = r'''> **Théorème des valeurs intermédiaires.** Si $f$ est continue sur $[a;b]$ et si $k$ est compris entre $f(a)$ et $f(b)$, l'équation $f(x) = k$ a au moins une solution dans $[a;b]$ (exactement une si $f$ est strictement monotone).

```graphe
f(x) = x^3 - 3x + 1 | violet
droite: y = 0 | gris
x: -2.2 .. 2.2
y: -3 .. 4
point: (0.347, 0) α
```
Ici $f(0) = 1 > 0$ et $f(1) = -1 < 0$ : une solution $\alpha \in\ ]0;1[$.''';

const _derivee = r'''La dérivée est la pente de la tangente.

```graphe
f(x) = x^2 - 2x | orange
droite: y = 2x - 4 | bleu
x: -1 .. 4
y: -2 .. 5
point: (2, 0) A
titre: tangente en A : y = f'(2)(x − 2) + f(2)
```

```tableau
$f(x)$ | $x^n$ | $\sqrt x$ | $e^x$ | $\ln x$ | $\sin x$
$f'(x)$ | $nx^{n-1}$ | $\frac{1}{2\sqrt x}$ | $e^x$ | $\frac1x$ | $\cos x$
```''';

const _variations = r'''Signe de $f'$ → sens de variation de $f$. Exemple : $f(x) = x^3 - 3x$, $f'(x) = 3(x-1)(x+1)$.

```variations
x     | −∞   |   | −1  |   | 1    |   | +∞
f'(x) |      | + | 0   | − | 0    | + |
f(x)  | −∞ b |   | 2 h |   | −2 b |   | +∞ h
```

```graphe
f(x) = x^3 - 3x | violet
x: -2.5 .. 2.5
y: -4 .. 4
point: (-1, 2)
point: (1, -2)
```''';

const _lnExp = r'''$\ln$ et $\exp$ sont réciproques : leurs courbes sont symétriques par rapport à $y = x$.

```graphe
exp(x) = e^x | orange
ln(x) = ln(x) | violet
droite: y = x | gris
x: -3 .. 5
y: -3 .. 5
point: (0, 1)
point: (1, 0)
```

$$\ln(ab) = \ln a + \ln b \qquad e^{a+b} = e^a e^b \qquad \ln(e^x) = x$$''';

const _croissances = r'''À l'infini, l'exponentielle l'emporte sur toute puissance, qui l'emporte sur le logarithme.

```graphe
f(x) = ln(x) | vert
g(x) = x | bleu
h(x) = e^x | orange
x: 0 .. 6
y: -1 .. 8
```

$$\lim_{x\to+\infty}\frac{e^x}{x} = +\infty \qquad \lim_{x\to+\infty}\frac{\ln x}{x} = 0 \qquad \lim_{x\to0^+} x\ln x = 0$$''';

const _suites = r'''Une suite géométrique de raison $0 < q < 1$ converge vers $0$ ; une suite arithmético-géométrique $u_{n+1} = au_n + b$ converge vers $\ell = \frac{b}{1-a}$ si $|a| < 1$.

```graphe
u(x) = 6 - 4*0.5^x | violet
droite: y = 6 | gris
x: 0 .. 10
y: 0 .. 7
point: (0, 2) u₀
point: (1, 4) u₁
point: (2, 5) u₂
point: (3, 5.5) u₃
```

```tableau
n | 0 | 1 | 2 | 3 | 4
$u_n$ | 2 | 4 | 5 | 5,5 | 5,75
```''';

const _integrale = r'''L'intégrale d'une fonction positive est l'aire sous sa courbe :
$$\int_a^b f(x)\,dx = F(b) - F(a)$$

```graphe
f(x) = x^2 | orange
x: -0.5 .. 2.5
y: -0.5 .. 5
point: (1, 1)
point: (2, 4)
titre: aire entre x = 1 et x = 2 : 7/3 u.a.
```
$\displaystyle\int_1^2 x^2\,dx = \left[\frac{x^3}{3}\right]_1^2 = \frac83 - \frac13 = \frac73$.''';

const _ipp = r'''> **Intégration par parties.** $$\int_a^b u\,v'\,dx = \big[uv\big]_a^b - \int_a^b u'\,v\,dx$$

Exemple : $\displaystyle\int_0^1 x e^x\,dx = \big[xe^x\big]_0^1 - \int_0^1 e^x\,dx = e - (e - 1) = 1$.''';

const _edo = r'''Les solutions de $y' = ay$ sont $y = Ce^{ax}$ ; celles de $y'' + \omega^2 y = 0$ sont $y = A\cos\omega x + B\sin\omega x$.

```graphe
y(x) = 2e^(-0.5x) | orange
z(x) = cos(2x) + sin(2x) | violet
x: 0 .. 8
y: -2 .. 2.5
```''';

const _binomiale = r'''Loi binomiale $\mathcal B(n ; p)$ : $P(X = k) = \binom nk p^k(1-p)^{n-k}$, $E(X) = np$.

Exemple $\mathcal B(4 ; 0{,}5)$ :

```tableau
k | 0 | 1 | 2 | 3 | 4
$P(X=k)$ | $\frac1{16}$ | $\frac4{16}$ | $\frac6{16}$ | $\frac4{16}$ | $\frac1{16}$
```''';

const _normale = r'''La loi normale $\mathcal N(\mu ; \sigma^2)$ a une courbe en cloche centrée sur $\mu$.

```graphe
f(x) = e^(-x^2/2)/sqrt(2pi) | violet
x: -4 .. 4
y: -0.05 .. 0.5
titre: densité de N(0 ; 1)
```
$P(-1{,}96 \leq X \leq 1{,}96) \approx 0{,}95$ pour $X \sim \mathcal N(0 ; 1)$.''';

const _complexes = r'''$z = a + ib = r\,e^{i\theta}$ avec $r = |z| = \sqrt{a^2 + b^2}$ et $\cos\theta = \frac ar$, $\sin\theta = \frac br$.

```tableau
$\theta$ | $0$ | $\frac\pi6$ | $\frac\pi4$ | $\frac\pi3$ | $\frac\pi2$
$\cos\theta$ | $1$ | $\frac{\sqrt3}2$ | $\frac{\sqrt2}2$ | $\frac12$ | $0$
$\sin\theta$ | $0$ | $\frac12$ | $\frac{\sqrt2}2$ | $\frac{\sqrt3}2$ | $1$
```''';

const _mru = r'''$$x(t) = \frac12 a t^2 + v_0 t + x_0 \qquad v(t) = at + v_0 \qquad v^2 - v_0^2 = 2a(x - x_0)$$

```graphe
x(t) = 0.5*2*t^2 | orange
v(t) = 2t | bleu
x: 0 .. 5
y: 0 .. 25
titre: a = 2 m/s² : position (parabole) et vitesse (droite)
```''';

const _parabolique = r'''Projectile lancé avec $v_0$ sous l'angle $\alpha$ : trajectoire parabolique
$$y = -\frac{g}{2v_0^2\cos^2\alpha}\,x^2 + x\tan\alpha$$

```graphe
y(x) = -0.098x^2 + x | orange
x: 0 .. 11
y: 0 .. 3
titre: v₀ = 10 m/s, α = 45°, g = 9,8 : portée ≈ 10,2 m
point: (5.1, 2.55) S
```''';

const _oscillateur = r'''$$\ddot x + \omega_0^2 x = 0 \qquad x(t) = X_m\cos(\omega_0 t + \varphi) \qquad T_0 = 2\pi\sqrt{\frac mk}$$

```graphe
x(t) = 3cos(2pi*t) | violet
a(t) = 3e^(-0.4t)cos(2pi*t) | orange
x: 0 .. 4
y: -3.5 .. 3.5
titre: oscillations libres (violet) et amorties (orange)
```''';

const _rc = r'''Charge d'un condensateur : $u_C(t) = E\left(1 - e^{-t/\tau}\right)$ ; décharge : $u_C(t) = E\,e^{-t/\tau}$, avec $\tau = RC$.

```graphe
c(t) = 6(1 - e^(-t)) | bleu
d(t) = 6e^(-t) | orange
droite: y = 3.79 | gris
x: 0 .. 5
y: 0 .. 6.5
titre: t en unités de τ ; à t = τ, u = 63 % de E
```''';

const _rl = r'''Dans un circuit RL, $i(t) = \frac ER\left(1 - e^{-t/\tau}\right)$ avec $\tau = \frac LR$ : la bobine retarde l'établissement du courant.

```graphe
i(t) = 1 - e^(-t) | orange
droite: y = 1 | gris
x: 0 .. 5
y: 0 .. 1.2
titre: i / (E/R) en fonction de t / τ
```''';

const _rlc = r'''Oscillations électriques libres : $T_0 = 2\pi\sqrt{LC}$. Avec une résistance, elles s'amortissent.

```graphe
u(t) = 5e^(-0.3t)cos(3t) | violet
x: 0 .. 12
y: -5.5 .. 5.5
titre: régime pseudo-périodique
```''';

const _ondes = r'''$$v = \lambda N = \frac{\lambda}{T}$$ Deux points distants de $k\lambda$ vibrent en phase, de $(2k+1)\frac\lambda2$ en opposition de phase.

```graphe
y(x) = sin(2pi*x/0.3) | bleu
x: 0 .. 0.9
y: -1.5 .. 1.5
titre: aspect de la corde à un instant (λ = 0,3 m)
```''';

const _radioactivite = r'''$$N(t) = N_0\,e^{-\lambda t} \qquad T = \frac{\ln 2}{\lambda}$$ Au bout de chaque demi-vie, il reste la moitié des noyaux.

```graphe
n(t) = 100e^(-0.693t) | vert
x: 0 .. 5
y: 0 .. 105
point: (1, 50)
point: (2, 25)
point: (3, 12.5)
titre: % de noyaux restants, t en demi-vies
```''';

const _lentilles = r'''$$\frac{1}{\overline{OA'}} - \frac{1}{\overline{OA}} = \frac{1}{f'} \qquad \gamma = \frac{\overline{A'B'}}{\overline{AB}} = \frac{\overline{OA'}}{\overline{OA}}$$

```tableau
Position de l'objet | Image
au-delà de 2f' | réelle, renversée, plus petite
entre f' et 2f' | réelle, renversée, plus grande
entre F et O | virtuelle, droite, agrandie (loupe)
```''';

const _ohm = r'''$$U = RI \qquad R_{\text{série}} = R_1 + R_2 \qquad \frac{1}{R_{\text{parallèle}}} = \frac{1}{R_1} + \frac{1}{R_2} \qquad P = UI = RI^2$$

```graphe
u(i) = 50i | bleu
x: 0 .. 0.2
y: 0 .. 10
titre: caractéristique d'un résistor R = 50 Ω (U en V, I en A)
```''';

const _ph = r'''$$\text{pH} = -\log[\text{H}_3\text{O}^+] \qquad \text{pH} = \text{p}K_a + \log\frac{[\text{A}^-]}{[\text{AH}]}$$

```tableau
pH | < pKa − 1 | = pKa | > pKa + 1
espèce prédominante | acide AH | AH = A⁻ | base A⁻
```''';

const _dosage = r'''Courbe de dosage d'un acide faible par une base forte : zone tampon, demi-équivalence (pH = p$K_a$), saut de pH à l'équivalence.

```graphe
p(x) = 4.8 + ln(x/(20-x))/ln(10) | vert
x: 0 .. 20
y: 2 .. 9
point: (10, 4.8) E½
titre: pH en fonction de V_B (mL) avant l'équivalence (V_E = 20 mL)
```''';

const _cinetique = r'''L'avancement croît de plus en plus lentement ; $t_{1/2}$ est atteint quand $x = \frac{x_{max}}{2}$.

```graphe
x(t) = 10(1 - e^(-0.0693t)) | orange
droite: y = 10 | gris
x: 0 .. 60
y: 0 .. 11
point: (10, 5) t½
```''';

const _affine = r'''Une fonction affine $f(x) = ax + b$ a pour courbe une droite : $a$ est la pente, $b$ l'ordonnée à l'origine.

```graphe
f(x) = 2x + 1 | bleu
g(x) = -0.5x + 3 | orange
x: -2 .. 5
y: -3 .. 8
```''';

const _stats = r'''Moyenne $\bar x = \dfrac{\sum n_i x_i}{N}$ ; médiane : valeur qui partage la série en deux moitiés ; mode : valeur la plus fréquente.

```tableau
Note | 8 | 10 | 12 | 14
Effectif | 2 | 4 | 3 | 1
Effectif cumulé | 2 | 6 | 9 | 10
```
Moyenne $= \dfrac{16 + 40 + 36 + 14}{10} = 10{,}6$ ; médiane $= 10$ ; mode $= 10$.''';

const Map<String, String> illustrationsLecons = {
  // limites, continuité
  'maths_ch2_l1': _limites, 'maths_c_ch2_l1': _limites, 'maths_c_ch2_l3': _limites,
  'maths_ch2_l2': _tvi, 'maths_c_ch2_l2': _tvi,
  // dérivation
  'maths_ch3_l1': _derivee, 'maths_c_ch3_l1': _derivee, 'maths_ti_ch3_l1': _derivee,
  'maths_ch3_l2': _variations, 'maths_c_ch3_l2': _variations,
  // ln, exp
  'maths_ch4_l1': _lnExp, 'maths_ch4_l2': _lnExp, 'maths_c_ch4_l1': _lnExp, 'maths_c_ch4_l2': _lnExp, 'maths_ti_ch3_l2': _lnExp,
  'maths_ch4_l3': _croissances, 'maths_c_ch4_l3': _croissances,
  // suites
  'maths_ch5_l1': _suites, 'maths_ch5_l2': _suites, 'maths_c_ch5_l1': _suites, 'maths_c_ch5_l3': _suites, 'maths_ti_ch2_l1': _suites,
  // intégrales
  'maths_ch6_l2': _integrale, 'maths_c_ch6_l2': _integrale, 'maths_ti_ch3_l3': _integrale,
  'maths_ch6_l3': _ipp, 'maths_c_ch6_l3': _ipp,
  // équations différentielles
  'maths_ch7_l1': _edo, 'maths_ch7_l2': _edo, 'maths_c_ch7_l1': _edo, 'maths_c_ch7_l2': _edo,
  // probabilités
  'maths_ch8_l2': _binomiale, 'maths_c_ch8_l3': _binomiale,
  'maths_ch8_l3': _normale,
  // complexes
  'maths_ch1_l2': _complexes, 'maths_c_ch1_l2': _complexes,
  // maths A
  'maths_a_ch4_l1': _affine, 'maths_a_ch2_l2': _stats, 'maths_ti_ch4_l3': _stats,
  // physique
  'physique_ch1_l3': _mru, 'physique_c_ch1_l2': _mru,
  'physique_c_ch1_l4': _parabolique,
  'physique_c_ch3_l1': _oscillateur, 'physique_c_ch3_l3': _oscillateur, 'physique_ch4_l3': _rlc, 'physique_c_ch5_l3': _rlc,
  'physique_ch4_l1': _rc, 'physique_c_ch5_l1': _rc,
  'physique_ch4_l2': _rl, 'physique_c_ch5_l2': _rl,
  'physique_ch5_l1': _ondes, 'physique_c_ch6_l1': _ondes,
  'physique_ch6_l1': _radioactivite, 'physique_c_ch8_l1': _radioactivite,
  'physique_ch7_l1': _lentilles, 'physique_c_ch7_l1': _lentilles,
  'physique_ch3_l1': _ohm, 'physique_c_ch4_l1': _ohm,
  // chimie
  'chimie_ch1_l2': _ph, 'chimie_c_ch1_l2': _ph,
  'chimie_ch1_l3': _dosage, 'chimie_c_ch1_l3': _dosage,
  'chimie_ch4_l1': _cinetique, 'chimie_c_ch4_l1': _cinetique,
};
