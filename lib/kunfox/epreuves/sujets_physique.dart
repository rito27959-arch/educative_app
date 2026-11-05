// Épreuves de physique, séries D et C (format Office du Bac).
// Données numériques choisies pour des calculs exacts ; résultats vérifiés.

import 'modele.dart';

const epreuvePhysiqueD = Epreuve(
  id: 'bac_d_physique_1',
  matiere: 'physique',
  serie: 'D',
  titre: 'Physique',
  dureeMinutes: 240,
  coefficient: 4,
  consignes: "Calculatrice autorisée. Prendre g = 10 m·s⁻². Donne les résultats avec leur unité.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Mécanique : plan incliné',
      enonce: r'''Un solide $(S)$ de masse $m = 0{,}5\ \text{kg}$, assimilable à un point matériel, est lâché sans vitesse initiale du point $A$ d'un plan incliné d'un angle $\alpha = 30°$ sur l'horizontale. Il glisse jusqu'au point $B$ tel que $AB = L = 2\ \text{m}$.

**Partie 1** : les frottements sont négligés.
**Partie 2** : on mesure en réalité $v_B = 4\ \text{m·s}^{-1}$ ; on modélise les frottements par une force $\vec f$ constante, opposée au mouvement.''',
      questions: [
        QuestionEpreuve.redaction('1.a', r"En appliquant le théorème du centre d'inertie, établis l'expression de l'accélération $a$ du solide.",
            chapitre: 'physique_ch2',
            bareme: [
              Critere(r"Bilan des forces : poids $\vec P$ et réaction normale $\vec R$", 0.5),
              Critere(r"Projection sur l'axe du mouvement : $m a = m g \sin\alpha$", 0.5),
              Critere(r"Résultat $a = g\sin\alpha$", 0.5),
            ],
            corrige: r'''Système : le solide, référentiel terrestre supposé galiléen.

Forces : le poids $\vec P$ et la réaction $\vec R$ du plan (perpendiculaire au plan, sans frottement).

$\vec P + \vec R = m\vec a$. En projetant sur l'axe $(Ox)$ parallèle au plan, orienté vers le bas :
$$m g \sin\alpha + 0 = m a \quad\Longrightarrow\quad a = g\sin\alpha$$'''),
        QuestionEpreuve.nombre('1.b', r"Calcule $a$.", valeur: 5, tolerance: 0.01, unite: 'm/s²', points: 1, chapitre: 'physique_ch2',
            corrige: r'''$a = 10\times\sin 30° = 10\times0{,}5 = 5\ \text{m·s}^{-2}$.'''),
        QuestionEpreuve.qcm('1.c', 'La nature du mouvement est :',
            options: ['rectiligne uniformément accéléré', 'rectiligne uniforme', 'circulaire uniforme', 'rectiligne uniformément décéléré'],
            bonne: 0,
            points: 0.5,
            chapitre: 'physique_ch1',
            corrige: r'''Trajectoire droite et accélération constante non nulle, de même sens que la vitesse.'''),
        QuestionEpreuve.nombre('1.d', r"Calcule la vitesse $v_B$ au point $B$ (sans frottement).",
            valeur: 4.472135955, tolerance: 0.01, unite: 'm/s', points: 1, chapitre: 'physique_ch1',
            corrige: r'''$v_B^2 - 0 = 2aL$ donc $v_B = \sqrt{2\times5\times2} = \sqrt{20} \approx 4{,}47\ \text{m·s}^{-1}$.'''),
        QuestionEpreuve.nombre('1.e', r"Calcule la durée $t_B$ du trajet $AB$.",
            valeur: 0.894427191, tolerance: 0.01, unite: 's', points: 1, chapitre: 'physique_ch1',
            corrige: r'''$v_B = a\,t_B$ donc $t_B = \dfrac{\sqrt{20}}{5} \approx 0{,}89\ \text{s}$.'''),
        QuestionEpreuve.nombre('2', r"Avec $v_B = 4\ \text{m·s}^{-1}$, calcule l'intensité $f$ de la force de frottement.",
            valeur: 0.5, tolerance: 0.01, unite: 'N', points: 1, chapitre: 'physique_ch2',
            corrige: r'''Nouvelle accélération : $a' = \dfrac{v_B^2}{2L} = \dfrac{16}{4} = 4\ \text{m·s}^{-2}$.

$m a' = m g\sin\alpha - f$ donc $f = m(g\sin\alpha - a') = 0{,}5\times(5 - 4) = 0{,}5\ \text{N}$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Électricité : dipôle RC',
      enonce: r'''On charge un condensateur de capacité $C = 10\ \mu\text{F}$ à travers un conducteur ohmique de résistance $R = 1\ \text{k}\Omega$, sous une tension constante $E = 6\ \text{V}$. À $t = 0$, le condensateur est déchargé.

La tension aux bornes du condensateur est $u_C(t) = E\left(1 - e^{-t/\tau}\right)$ ; sa courbe ($t$ en ms) est :

```graphe
u(x) = 6(1 - e^(-x/10)) | bleu
droite: y = 6 | gris
x: 0 .. 60
y: 0 .. 7
titre: u_C en V, t en ms
```''',
      questions: [
        QuestionEpreuve.redaction('1', r"Établis l'équation différentielle vérifiée par $u_C$.",
            chapitre: 'physique_ch4',
            bareme: [
              Critere(r"Loi des mailles $E = u_R + u_C$ et $u_R = R i$", 0.5),
              Critere(r"$i = C\dfrac{du_C}{dt}$", 0.5),
              Critere(r"$RC\dfrac{du_C}{dt} + u_C = E$", 0.5),
            ],
            corrige: r'''Loi des mailles : $E = u_R + u_C = R i + u_C$, avec $i = \dfrac{dq}{dt} = C\dfrac{du_C}{dt}$ :
$$RC\,\frac{du_C}{dt} + u_C = E$$'''),
        QuestionEpreuve.nombre('2', r"Calcule la constante de temps $\tau = RC$ (en secondes).",
            valeur: 0.01, tolerance: 0.01, unite: 's', points: 1, chapitre: 'physique_ch4',
            corrige: r'''$\tau = RC = 10^3\times10\times10^{-6} = 10^{-2}\ \text{s} = 10\ \text{ms}$.'''),
        QuestionEpreuve.nombre('3', r"Calcule $u_C(\tau)$.",
            valeur: 3.792723, tolerance: 0.01, unite: 'V', points: 1, chapitre: 'physique_ch4',
            corrige: r'''$u_C(\tau) = E(1 - e^{-1}) \approx 0{,}63\times6 \approx 3{,}79\ \text{V}$ : c'est la méthode graphique pour lire $\tau$.'''),
        QuestionEpreuve.qcm('4', 'On considère le condensateur pratiquement chargé au bout de :',
            options: [r"$5\tau = 50\ \text{ms}$", r"$\tau = 10\ \text{ms}$", r"$2\tau = 20\ \text{ms}$", r"$100\tau = 1\ \text{s}$"],
            bonne: 0,
            points: 0.5,
            chapitre: 'physique_ch4',
            corrige: r'''À $t = 5\tau$, $u_C = E(1 - e^{-5}) \approx 0{,}993\,E$ : plus de 99 % de la charge.'''),
        QuestionEpreuve.nombre('5', r"Calcule l'énergie emmagasinée par le condensateur chargé.",
            valeur: 1.8e-4, tolerance: 0.01, unite: 'J', points: 1, chapitre: 'physique_ch4',
            corrige: r'''$\mathcal E = \dfrac12 C E^2 = 0{,}5\times10^{-5}\times36 = 1{,}8\times10^{-4}\ \text{J}$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Physique nucléaire',
      enonce: r'''L'iode 131 ($^{131}_{\ 53}\text{I}$), utilisé en médecine, est radioactif $\beta^-$. Sa demi-vie est $T = 8$ jours.

Données : $^{131}_{\ 54}\text{Xe}$ (xénon), $^{131}_{\ 52}\text{Te}$ (tellure).''',
      questions: [
        QuestionEpreuve.courte('1', r"Quel noyau fils est formé (symbole ou nom) ?",
            acceptees: ['Xe', 'xénon', 'xenon', '131 Xe', 'Xe 131', 'xénon 131'],
            points: 1,
            chapitre: 'physique_ch6',
            corrige: r'''$$^{131}_{\ 53}\text{I} \longrightarrow\ ^{131}_{\ 54}\text{Xe} +\ ^{\ 0}_{-1}\text{e}$$
Conservation du nombre de masse ($131$) et du nombre de charge ($53 = 54 - 1$).'''),
        QuestionEpreuve.nombre('2', r"Calcule la constante radioactive $\lambda$ (en jour⁻¹).",
            valeur: 0.0866434, tolerance: 0.01, points: 1, chapitre: 'physique_ch6',
            corrige: r'''$\lambda = \dfrac{\ln 2}{T} = \dfrac{0{,}693}{8} \approx 8{,}66\times10^{-2}\ \text{j}^{-1}$.'''),
        QuestionEpreuve.nombre('3', r"Quelle fraction $N/N_0$ des noyaux reste au bout de 24 jours ?",
            valeur: 0.125, tolerance: 0.01, points: 1, chapitre: 'physique_ch6',
            corrige: r'''$24\ \text{j} = 3T$ donc $N = \dfrac{N_0}{2^3} = \dfrac{N_0}{8}$ : il reste $12{,}5\ \%$.'''),
        QuestionEpreuve.nombre('4', r"Au bout de combien de jours ne reste-t-il que $\frac{1}{16}$ des noyaux ?",
            valeur: 32, tolerance: 0.01, unite: 'jours', points: 1, chapitre: 'physique_ch6',
            corrige: r'''$\dfrac{1}{16} = \dfrac{1}{2^4}$ : il faut $4T = 32$ jours.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Ondes mécaniques',
      enonce: r'''L'extrémité $S$ d'une corde tendue est reliée à un vibreur de fréquence $N = 50\ \text{Hz}$. Une onde progressive sinusoïdale se propage le long de la corde, sans amortissement ni réflexion.

On mesure une distance de $1{,}2\ \text{m}$ entre **cinq crêtes consécutives**.''',
      questions: [
        QuestionEpreuve.redaction('1', 'Définis une onde mécanique progressive.',
            chapitre: 'physique_ch5',
            bareme: [
              Critere('Propagation d\'une perturbation dans un milieu matériel', 0.5),
              Critere('Transport d\'énergie sans transport de matière', 0.5),
            ],
            corrige: r'''C'est le phénomène de **propagation d'une perturbation** dans un milieu matériel élastique, de proche en proche, **avec transport d'énergie mais sans transport de matière**.'''),
        QuestionEpreuve.nombre('2', r"Calcule la longueur d'onde $\lambda$.",
            valeur: 0.3, tolerance: 0.01, unite: 'm', points: 1, chapitre: 'physique_ch5',
            corrige: r'''Cinq crêtes consécutives sont séparées de $4\lambda$ : $\lambda = \dfrac{1{,}2}{4} = 0{,}3\ \text{m}$.'''),
        QuestionEpreuve.nombre('3', r"Calcule la célérité $v$ de l'onde.",
            valeur: 15, tolerance: 0.01, unite: 'm/s', points: 1, chapitre: 'physique_ch5',
            corrige: r'''$v = \lambda N = 0{,}3\times50 = 15\ \text{m·s}^{-1}$.'''),
        QuestionEpreuve.qcm('4', r"Un point $M$ situé à $SM = 45\ \text{cm}$ de la source vibre :",
            options: ['en opposition de phase avec S', 'en phase avec S', 'en quadrature avec S', 'il reste immobile'],
            bonne: 0,
            points: 1,
            chapitre: 'physique_ch5',
            corrige: r'''$\dfrac{SM}{\lambda} = \dfrac{0{,}45}{0{,}3} = 1{,}5$ : $SM = (2k+1)\dfrac{\lambda}{2}$ avec $k = 1$, donc **opposition de phase**.'''),
        QuestionEpreuve.qcm('5', r"On éclaire la corde avec un stroboscope. Pour quelle fréquence des éclairs la corde paraît-elle immobile ?",
            options: ['25 Hz', '60 Hz', '75 Hz', '40 Hz'],
            bonne: 0,
            points: 1,
            chapitre: 'physique_ch5',
            corrige: r'''Immobilité apparente si $N = k N_e$ avec $k$ entier : $N_e = 50, 25, 16{,}7\dots$ Hz. Parmi les choix, **25 Hz**.'''),
      ],
    ),
  ],
);

const epreuvePhysiqueC = Epreuve(
  id: 'bac_c_physique_1',
  matiere: 'physique_c',
  serie: 'C',
  titre: 'Physique',
  dureeMinutes: 300,
  coefficient: 5,
  consignes: "Calculatrice autorisée. Les exercices sont indépendants. Donne les résultats avec leur unité.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Oscillateur mécanique',
      enonce: r'''Un solide de masse $m = 200\ \text{g}$ est fixé à un ressort horizontal de raideur $k = 20\ \text{N·m}^{-1}$. Les frottements sont négligés. On écarte le solide de $X_m = 5\ \text{cm}$ de sa position d'équilibre et on le lâche sans vitesse à $t = 0$.

L'élongation est $x(t) = X_m\cos(\omega_0 t)$ ($x$ en cm, $t$ en s) :

```graphe
x(t) = 5cos(10t) | violet
x: 0 .. 1.3
y: -6 .. 6
titre: x en cm, t en s
```''',
      questions: [
        QuestionEpreuve.redaction('1', r"Établis l'équation différentielle du mouvement.",
            chapitre: 'physique_c_ch3',
            bareme: [
              Critere(r"Bilan : poids, réaction (verticaux) et tension $\vec T = -kx\,\vec i$", 0.5),
              Critere(r"$m\ddot x = -kx$, soit $\ddot x + \dfrac km x = 0$", 1),
            ],
            corrige: r'''Projection de la relation fondamentale sur l'axe horizontal : $m\ddot x = -kx$.
$$\ddot x + \frac{k}{m}\,x = 0$$'''),
        QuestionEpreuve.nombre('2', r"Calcule la pulsation propre $\omega_0$.",
            valeur: 10, tolerance: 0.01, unite: 'rad/s', points: 1, chapitre: 'physique_c_ch3',
            corrige: r'''$\omega_0 = \sqrt{\dfrac km} = \sqrt{\dfrac{20}{0{,}2}} = 10\ \text{rad·s}^{-1}$.'''),
        QuestionEpreuve.nombre('3', r"Calcule la période propre $T_0$.",
            valeur: 0.6283185, tolerance: 0.01, unite: 's', points: 1, chapitre: 'physique_c_ch3',
            corrige: r'''$T_0 = \dfrac{2\pi}{\omega_0} \approx 0{,}63\ \text{s}$.'''),
        QuestionEpreuve.nombre('4', r"Calcule la vitesse maximale du solide.",
            valeur: 0.5, tolerance: 0.01, unite: 'm/s', points: 1.5, chapitre: 'physique_c_ch3',
            corrige: r'''$v_{max} = X_m\,\omega_0 = 0{,}05\times10 = 0{,}5\ \text{m·s}^{-1}$.'''),
        QuestionEpreuve.nombre('5', r"Calcule l'énergie mécanique de l'oscillateur.",
            valeur: 0.025, tolerance: 0.01, unite: 'J', points: 1, chapitre: 'physique_c_ch2',
            corrige: r'''$E = \dfrac12 k X_m^2 = 0{,}5\times20\times0{,}05^2 = 2{,}5\times10^{-2}\ \text{J}$, constante (pas de frottement).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Particule dans un champ magnétique',
      enonce: r'''Un proton (masse $m = 1{,}67\times10^{-27}\ \text{kg}$, charge $e = 1{,}6\times10^{-19}\ \text{C}$) pénètre avec une vitesse $v = 1{,}0\times10^{6}\ \text{m·s}^{-1}$ dans une zone où règne un champ magnétique uniforme $\vec B$ perpendiculaire à $\vec v$, d'intensité $B = 0{,}1\ \text{T}$. Le poids est négligeable.''',
      questions: [
        QuestionEpreuve.qcm('1', 'Le mouvement du proton dans le champ est :',
            options: ['circulaire uniforme', 'rectiligne uniforme', 'parabolique', 'rectiligne uniformément accéléré'],
            bonne: 0,
            points: 1,
            chapitre: 'physique_c_ch9',
            corrige: r'''La force de Lorentz $\vec F = e\,\vec v\wedge\vec B$ est perpendiculaire à $\vec v$ : elle ne travaille pas, la vitesse garde la même norme et la trajectoire est un cercle.'''),
        QuestionEpreuve.redaction('2', r"Établis l'expression du rayon $R$ de la trajectoire.",
            chapitre: 'physique_c_ch9',
            bareme: [
              Critere(r"Accélération normale $\dfrac{v^2}{R}$ dans la base de Frenet", 0.5),
              Critere(r"$evB = m\dfrac{v^2}{R}$ donc $R = \dfrac{mv}{eB}$", 1),
            ],
            corrige: r'''Dans la base de Frenet : $e v B = m\dfrac{v^2}{R}$ donc
$$R = \frac{m v}{e B}$$'''),
        QuestionEpreuve.nombre('3', r"Calcule $R$.",
            valeur: 0.104375, tolerance: 0.01, unite: 'm', points: 1.5, chapitre: 'physique_c_ch9',
            corrige: r'''$R = \dfrac{1{,}67\times10^{-27}\times10^6}{1{,}6\times10^{-19}\times0{,}1} \approx 0{,}104\ \text{m} \approx 10{,}4\ \text{cm}$.'''),
        QuestionEpreuve.nombre('4', r"Calcule la durée d'un demi-tour.",
            valeur: 3.279e-7, tolerance: 0.01, unite: 's', points: 1, chapitre: 'physique_c_ch9',
            corrige: r'''$t = \dfrac{\pi R}{v} = \dfrac{\pi m}{eB} \approx 3{,}28\times10^{-7}\ \text{s}$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Optique : lentille convergente',
      enonce: r'''Un objet $AB$ de hauteur $2\ \text{cm}$ est placé perpendiculairement à l'axe optique d'une lentille convergente de distance focale $f' = 10\ \text{cm}$, à $30\ \text{cm}$ devant la lentille ($\overline{OA} = -30\ \text{cm}$).''',
      questions: [
        QuestionEpreuve.nombre('1', r"Calcule la position $\overline{OA'}$ de l'image (en cm).",
            valeur: 15, tolerance: 0.01, unite: 'cm', points: 1.5, chapitre: 'physique_c_ch7',
            corrige: r'''$\dfrac{1}{\overline{OA'}} - \dfrac{1}{\overline{OA}} = \dfrac{1}{f'}$ donc $\dfrac{1}{\overline{OA'}} = \dfrac1{10} - \dfrac1{30} = \dfrac{2}{30}$, $\overline{OA'} = 15\ \text{cm}$.'''),
        QuestionEpreuve.nombre('2', r"Calcule le grandissement $\gamma$.",
            valeur: -0.5, tolerance: 0.01, points: 1, chapitre: 'physique_c_ch7',
            corrige: r'''$\gamma = \dfrac{\overline{OA'}}{\overline{OA}} = \dfrac{15}{-30} = -0{,}5$.'''),
        QuestionEpreuve.qcm('3', "L'image est :",
            options: ['réelle, renversée, 2 fois plus petite', 'virtuelle, droite, agrandie', 'réelle, droite, de même taille', 'virtuelle, renversée'],
            bonne: 0,
            points: 1.5,
            chapitre: 'physique_c_ch7',
            corrige: r'''$\overline{OA'} > 0$ : image **réelle** ; $\gamma < 0$ : **renversée** ; $|\gamma| = 0{,}5$ : deux fois plus petite ($A'B' = 1\ \text{cm}$).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Régime transitoire : bobine',
      enonce: r'''Une bobine d'inductance $L = 0{,}1\ \text{H}$ et de résistance négligeable est montée en série avec un conducteur ohmique $R = 10\ \Omega$ et un générateur idéal de tension $E = 12\ \text{V}$. On ferme l'interrupteur à $t = 0$.

L'intensité vaut $i(t) = \dfrac ER\left(1 - e^{-t/\tau}\right)$ ($t$ en ms) :

```graphe
i(x) = 1.2(1 - e^(-x/10)) | orange
droite: y = 1.2 | gris
x: 0 .. 60
y: 0 .. 1.5
titre: i en A, t en ms
```''',
      questions: [
        QuestionEpreuve.nombre('1', r"Calcule la constante de temps $\tau = \dfrac LR$.",
            valeur: 0.01, tolerance: 0.01, unite: 's', points: 1, chapitre: 'physique_c_ch5',
            corrige: r'''$\tau = \dfrac{0{,}1}{10} = 10^{-2}\ \text{s} = 10\ \text{ms}$.'''),
        QuestionEpreuve.nombre('2', r"Calcule l'intensité en régime permanent.",
            valeur: 1.2, tolerance: 0.01, unite: 'A', points: 1, chapitre: 'physique_c_ch5',
            corrige: r'''En régime permanent $\dfrac{di}{dt} = 0$ : $I = \dfrac ER = 1{,}2\ \text{A}$.'''),
        QuestionEpreuve.nombre('3', r"Calcule l'énergie magnétique stockée en régime permanent.",
            valeur: 0.072, tolerance: 0.01, unite: 'J', points: 1, chapitre: 'physique_c_ch5',
            corrige: r'''$\mathcal E = \dfrac12 L I^2 = 0{,}5\times0{,}1\times1{,}44 = 7{,}2\times10^{-2}\ \text{J}$.'''),
        QuestionEpreuve.redaction('4', r"Explique le rôle de la bobine à la fermeture du circuit.",
            chapitre: 'physique_c_ch5',
            bareme: [
              Critere("La bobine s'oppose aux variations du courant (loi de Lenz)", 1),
              Critere("Le courant s'établit progressivement, sans discontinuité", 1),
            ],
            corrige: r'''La tension $u_L = L\dfrac{di}{dt}$ s'oppose à la variation de $i$ : l'intensité ne peut pas varier brusquement. Le courant **s'établit progressivement** (retard à l'établissement du courant), en environ $5\tau = 50\ \text{ms}$.'''),
      ],
    ),
  ],
);
