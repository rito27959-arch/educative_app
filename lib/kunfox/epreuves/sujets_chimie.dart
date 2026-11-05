// Épreuves de chimie, séries D et C (format Office du Bac).

import 'modele.dart';

const epreuveChimieD = Epreuve(
  id: 'bac_d_chimie_1',
  matiere: 'chimie',
  serie: 'D',
  titre: 'Chimie',
  dureeMinutes: 180,
  coefficient: 2,
  consignes: "Calculatrice autorisée. Masses molaires (g/mol) : H = 1 ; C = 12 ; O = 16 ; Zn = 65,4. F = 96 500 C/mol.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Acide éthanoïque et dosage',
      enonce: r'''Une solution $S_A$ d'acide éthanoïque $\text{CH}_3\text{COOH}$ de concentration $C_A = 0{,}1\ \text{mol·L}^{-1}$ a un pH de $2{,}9$.

On dose $V_A = 20\ \text{mL}$ de $S_A$ par une solution d'hydroxyde de sodium de concentration $C_B = 0{,}1\ \text{mol·L}^{-1}$. Avant l'équivalence, le pH suit la courbe ci-dessous ($V_B$ en mL) :

```graphe
p(x) = 4.8 + ln(x/(20-x))/ln(10) | vert
x: 0 .. 20
y: 2 .. 8
point: (10, 4.8) E½
titre: pH en fonction de V_B
```''',
      questions: [
        QuestionEpreuve.nombre('1', r"Calcule la concentration $[\text{H}_3\text{O}^+]$ de la solution $S_A$ (mol/L).",
            valeur: 1.2589254e-3, tolerance: 0.02, points: 1, chapitre: 'chimie_ch1',
            corrige: r'''$[\text{H}_3\text{O}^+] = 10^{-\text{pH}} = 10^{-2{,}9} \approx 1{,}26\times10^{-3}\ \text{mol·L}^{-1}$.'''),
        QuestionEpreuve.qcm('2', "L'acide éthanoïque est un acide faible car :",
            options: [r"$[\text{H}_3\text{O}^+] < C_A$", r"$[\text{H}_3\text{O}^+] = C_A$", r"son pH est inférieur à 7", r"il contient un groupe carboxyle"],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_ch1',
            corrige: r'''$1{,}26\times10^{-3} < 0{,}1$ : la réaction avec l'eau est **limitée**, l'acide est faible.'''),
        QuestionEpreuve.nombre('3', r"Calcule le taux d'avancement final $\tau$ de la réaction de l'acide avec l'eau (nombre décimal).",
            valeur: 0.012589, tolerance: 0.02, points: 1, chapitre: 'chimie_ch1',
            corrige: r'''$\tau = \dfrac{[\text{H}_3\text{O}^+]}{C_A} = \dfrac{1{,}26\times10^{-3}}{0{,}1} \approx 1{,}26\times10^{-2}$, soit environ $1{,}3\ \%$.'''),
        QuestionEpreuve.redaction('4', "Écris l'équation de la réaction de dosage et donne ses caractéristiques.",
            chapitre: 'chimie_ch1',
            bareme: [
              Critere(r"$\text{CH}_3\text{COOH} + \text{HO}^- \rightarrow \text{CH}_3\text{COO}^- + \text{H}_2\text{O}$", 0.5),
              Critere('Réaction rapide, totale (et exothermique)', 0.5),
            ],
            corrige: r'''$$\text{CH}_3\text{COOH} + \text{HO}^- \longrightarrow \text{CH}_3\text{COO}^- + \text{H}_2\text{O}$$
C'est une réaction **rapide**, **totale** et exothermique : elle convient pour un dosage.'''),
        QuestionEpreuve.nombre('5', r"Calcule le volume $V_{BE}$ versé à l'équivalence.",
            valeur: 20, tolerance: 0.01, unite: 'mL', points: 1, chapitre: 'chimie_ch1',
            corrige: r'''À l'équivalence $C_A V_A = C_B V_{BE}$ donc $V_{BE} = \dfrac{0{,}1\times20}{0{,}1} = 20\ \text{mL}$.'''),
        QuestionEpreuve.nombre('6', r"Quel est le pH à la demi-équivalence ? (pKa du couple : 4,8)",
            valeur: 4.8, tolerance: 0.01, points: 1, chapitre: 'chimie_ch1',
            corrige: r'''À la demi-équivalence $[\text{CH}_3\text{COOH}] = [\text{CH}_3\text{COO}^-]$, donc $\text{pH} = \text{p}K_a = 4{,}8$.'''),
        QuestionEpreuve.qcm('7', "Quel indicateur coloré choisir pour ce dosage ?",
            options: ['Phénolphtaléine (8,2 – 10)', 'Hélianthine (3,1 – 4,4)', 'Rouge de méthyle (4,2 – 6,2)', 'Aucun ne convient'],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_ch1',
            corrige: r'''À l'équivalence la solution contient la base $\text{CH}_3\text{COO}^-$ : $\text{pH}_E > 7$ (environ 8,7). La zone de virage doit contenir $\text{pH}_E$ : **phénolphtaléine**.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Chimie organique : estérification',
      enonce: r'''On mélange $0{,}5\ \text{mol}$ d'acide éthanoïque et $0{,}5\ \text{mol}$ d'éthanol avec quelques gouttes d'acide sulfurique concentré, et on chauffe à reflux.''',
      questions: [
        QuestionEpreuve.redaction('1', "Écris l'équation-bilan de la réaction avec les formules semi-développées.",
            chapitre: 'chimie_ch3',
            bareme: [
              Critere('Réactifs et produits corrects (ester + eau)', 0.5),
              Critere('Double flèche (équilibre)', 0.5),
            ],
            corrige: r'''$$\text{CH}_3\text{COOH} + \text{CH}_3\text{CH}_2\text{OH} \rightleftharpoons \text{CH}_3\text{COOCH}_2\text{CH}_3 + \text{H}_2\text{O}$$'''),
        QuestionEpreuve.courte('2', "Nomme l'ester formé.",
            acceptees: ["éthanoate d'éthyle", 'ethanoate d ethyle', "acétate d'éthyle", 'acetate d ethyle'],
            points: 1,
            chapitre: 'chimie_ch3',
            corrige: r'''C'est l'**éthanoate d'éthyle** (acétate d'éthyle).'''),
        QuestionEpreuve.qcm('3', "L'estérification est une réaction :",
            options: ['lente, limitée et athermique', 'rapide et totale', 'lente et totale', 'rapide, limitée et exothermique'],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_ch3',
            corrige: r'''L'acide sulfurique (catalyseur) et le chauffage accélèrent la réaction, mais ne changent pas la limite.'''),
        QuestionEpreuve.nombre('4', "Calcule la masse molaire de l'ester.",
            valeur: 88, tolerance: 0.005, unite: 'g/mol', points: 1, chapitre: 'chimie_ch3',
            corrige: r'''$\text{C}_4\text{H}_8\text{O}_2$ : $M = 4\times12 + 8\times1 + 2\times16 = 88\ \text{g·mol}^{-1}$.'''),
        QuestionEpreuve.nombre('5', "Le rendement est de 67 %. Calcule la masse d'ester obtenue.",
            valeur: 29.48, tolerance: 0.02, unite: 'g', points: 1, chapitre: 'chimie_ch3',
            corrige: r'''$n_{\text{ester}} = 0{,}67\times0{,}5 = 0{,}335\ \text{mol}$, donc $m = 0{,}335\times88 \approx 29{,}5\ \text{g}$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Cinétique chimique',
      enonce: r'''On suit la formation d'un produit P au cours du temps (avancement $x$ en mmol ; avancement maximal $x_{max} = 10\ \text{mmol}$) :

```tableau
t (min) | 0 | 5 | 10 | 15 | 20 | 30 | 40 | 60
x (mmol) | 0 | 2,9 | 5,0 | 6,5 | 7,5 | 8,75 | 9,4 | 9,8
```

```graphe
x(t) = 10(1 - e^(-0.0693t)) | orange
x: 0 .. 60
y: 0 .. 11
point: (10, 5) t½
titre: x en mmol, t en min
```''',
      questions: [
        QuestionEpreuve.nombre('1', r"Détermine le temps de demi-réaction $t_{1/2}$.",
            valeur: 10, tolerance: 0.02, unite: 'min', points: 1, chapitre: 'chimie_ch4',
            corrige: r'''$t_{1/2}$ est atteint quand $x = \dfrac{x_{max}}{2} = 5\ \text{mmol}$ : d'après le tableau, $t_{1/2} = 10\ \text{min}$.'''),
        QuestionEpreuve.nombre('2', "Calcule la vitesse moyenne de formation de P entre 0 et 10 min (mmol/min).",
            valeur: 0.5, tolerance: 0.01, points: 1, chapitre: 'chimie_ch4',
            corrige: r'''$v_m = \dfrac{5{,}0 - 0}{10 - 0} = 0{,}5\ \text{mmol·min}^{-1}$.'''),
        QuestionEpreuve.qcm('3', 'Au cours du temps, la vitesse de la réaction :',
            options: ['diminue, car les réactifs s\'épuisent', 'augmente', 'reste constante', 'est nulle dès le début'],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_ch4',
            corrige: r'''La pente de la courbe diminue : la concentration des réactifs (facteur cinétique) diminue.'''),
        QuestionEpreuve.qcm('4', 'Pour obtenir plus vite la même quantité de P, on peut :',
            options: ['élever la température', 'diluer le mélange', 'refroidir le mélange', 'agiter moins'],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_ch4',
            corrige: r'''La température est un facteur cinétique : l'élever accélère la réaction (sans changer $x_{max}$).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Oxydoréduction : la pile Daniell',
      enonce: r'''On réalise la pile $\text{Zn} \mid \text{Zn}^{2+} \parallel \text{Cu}^{2+} \mid \text{Cu}$.

Potentiels standards : $E°(\text{Cu}^{2+}/\text{Cu}) = 0{,}34\ \text{V}$ ; $E°(\text{Zn}^{2+}/\text{Zn}) = -0{,}76\ \text{V}$.''',
      questions: [
        QuestionEpreuve.nombre('1', 'Calcule la force électromotrice standard de la pile.',
            valeur: 1.10, tolerance: 0.01, unite: 'V', points: 1, chapitre: 'chimie_ch2',
            corrige: r'''$e = E°(\text{Cu}^{2+}/\text{Cu}) - E°(\text{Zn}^{2+}/\text{Zn}) = 0{,}34 - (-0{,}76) = 1{,}10\ \text{V}$.'''),
        QuestionEpreuve.qcm('2', 'Le pôle positif de la pile est :',
            options: ["l'électrode de cuivre", "l'électrode de zinc", 'le pont salin', 'aucun'],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_ch2',
            corrige: r'''Le pôle $+$ est l'électrode du couple de plus grand potentiel : le **cuivre**.'''),
        QuestionEpreuve.redaction('3', "Écris l'équation de fonctionnement de la pile.",
            chapitre: 'chimie_ch2',
            bareme: [Critere(r"$\text{Zn} + \text{Cu}^{2+} \rightarrow \text{Zn}^{2+} + \text{Cu}$", 1)],
            corrige: r'''Oxydation au pôle $-$ : $\text{Zn} \rightarrow \text{Zn}^{2+} + 2e^-$ ; réduction au pôle $+$ : $\text{Cu}^{2+} + 2e^- \rightarrow \text{Cu}$.
$$\text{Zn} + \text{Cu}^{2+} \longrightarrow \text{Zn}^{2+} + \text{Cu}$$'''),
        QuestionEpreuve.nombre('4', "La pile débite 0,2 A pendant 1 heure. Calcule la masse de zinc consommée.",
            valeur: 0.24398, tolerance: 0.02, unite: 'g', points: 1, chapitre: 'chimie_ch2',
            corrige: r'''$Q = I t = 0{,}2\times3600 = 720\ \text{C}$ ; $n(e^-) = \dfrac{720}{96\,500} \approx 7{,}46\times10^{-3}\ \text{mol}$.

$n(\text{Zn}) = \dfrac{n(e^-)}{2} \approx 3{,}73\times10^{-3}\ \text{mol}$, donc $m = 3{,}73\times10^{-3}\times65{,}4 \approx 0{,}244\ \text{g}$.'''),
      ],
    ),
  ],
);

const epreuveChimieC = Epreuve(
  id: 'bac_c_chimie_1',
  matiere: 'chimie_c',
  serie: 'C',
  titre: 'Chimie',
  dureeMinutes: 180,
  coefficient: 3,
  consignes: "Calculatrice autorisée. Masses molaires (g/mol) : H = 1 ; C = 12 ; O = 16 ; Cl = 35,5 ; Ag = 108. À 25 °C, pKe = 14.",
  exercices: [
    ExerciceEpreuve(
      titre: "Solution d'ammoniac",
      enonce: r'''On prépare une solution d'ammoniac $\text{NH}_3$ de concentration $C_B = 1{,}0\times10^{-2}\ \text{mol·L}^{-1}$. Le p$K_a$ du couple $\text{NH}_4^+/\text{NH}_3$ vaut $9{,}2$.

On dose ensuite $V_B = 20\ \text{mL}$ de cette solution par de l'acide chlorhydrique de concentration $C_A = 2{,}0\times10^{-2}\ \text{mol·L}^{-1}$.''',
      questions: [
        QuestionEpreuve.nombre('1', r"L'ammoniac étant une base faible peu dissociée, calcule le pH de la solution avec $\text{pH} = \frac12(\text{p}K_e + \text{p}K_a + \log C_B)$.",
            valeur: 10.6, tolerance: 0.01, points: 1, chapitre: 'chimie_c_ch1',
            corrige: r'''$\text{pH} = \dfrac12(14 + 9{,}2 - 2) = 10{,}6$.'''),
        QuestionEpreuve.qcm('2', 'Dans cette solution, l\'espèce prédominante est :',
            options: [r"$\text{NH}_3$", r"$\text{NH}_4^+$", 'aucune des deux', 'les deux à égalité'],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_c_ch1',
            corrige: r'''$\text{pH} = 10{,}6 > \text{p}K_a = 9{,}2$ : la base $\text{NH}_3$ prédomine.'''),
        QuestionEpreuve.redaction('3', 'Trace le diagramme de prédominance du couple.',
            chapitre: 'chimie_c_ch1',
            bareme: [Critere(r"Axe des pH avec la frontière à $\text{p}K_a = 9{,}2$, $\text{NH}_4^+$ à gauche, $\text{NH}_3$ à droite", 1)],
            corrige: r'''```tableau
pH | 0 → 9,2 | 9,2 | 9,2 → 14
espèce prédominante | $\text{NH}_4^+$ | égalité | $\text{NH}_3$
```'''),
        QuestionEpreuve.nombre('4', "Calcule le volume d'acide versé à l'équivalence.",
            valeur: 10, tolerance: 0.01, unite: 'mL', points: 1, chapitre: 'chimie_c_ch1',
            corrige: r'''$C_A V_{AE} = C_B V_B$ donc $V_{AE} = \dfrac{10^{-2}\times20}{2\times10^{-2}} = 10\ \text{mL}$.'''),
        QuestionEpreuve.qcm('5', "À l'équivalence, le pH est :",
            options: ['inférieur à 7', 'égal à 7', 'supérieur à 7', 'égal au pKa'],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_c_ch1',
            corrige: r'''À l'équivalence la solution contient l'acide faible $\text{NH}_4^+$ : $\text{pH}_E < 7$.'''),
        QuestionEpreuve.nombre('6', "Quel est le pH à la demi-équivalence ?",
            valeur: 9.2, tolerance: 0.01, points: 1, chapitre: 'chimie_c_ch1',
            corrige: r'''À la demi-équivalence, $\text{pH} = \text{p}K_a = 9{,}2$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Saponification',
      enonce: r'''On fait réagir $8{,}8\ \text{g}$ d'éthanoate d'éthyle $\text{CH}_3\text{COOC}_2\text{H}_5$ avec un excès de solution d'hydroxyde de sodium, à chaud.''',
      questions: [
        QuestionEpreuve.redaction('1', "Écris l'équation-bilan de la réaction.",
            chapitre: 'chimie_c_ch3',
            bareme: [Critere(r"$\text{CH}_3\text{COOC}_2\text{H}_5 + \text{HO}^- \rightarrow \text{CH}_3\text{COO}^- + \text{C}_2\text{H}_5\text{OH}$", 1)],
            corrige: r'''$$\text{CH}_3\text{COOC}_2\text{H}_5 + \text{HO}^- \longrightarrow \text{CH}_3\text{COO}^- + \text{C}_2\text{H}_5\text{OH}$$'''),
        QuestionEpreuve.qcm('2', 'La saponification est une réaction :',
            options: ['lente et totale', 'rapide et limitée', 'lente et limitée', 'instantanée et limitée'],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_c_ch3',
            corrige: r'''Contrairement à l'estérification, la saponification est **totale** (et lente).'''),
        QuestionEpreuve.courte('3', "Nomme l'alcool obtenu.",
            acceptees: ['éthanol', 'ethanol', 'alcool éthylique'],
            points: 1,
            chapitre: 'chimie_c_ch3',
            corrige: r'''L'**éthanol** $\text{C}_2\text{H}_5\text{OH}$.'''),
        QuestionEpreuve.nombre('4', "Calcule la masse d'éthanol formée.",
            valeur: 4.6, tolerance: 0.01, unite: 'g', points: 1, chapitre: 'chimie_c_ch3',
            corrige: r'''$n = \dfrac{8{,}8}{88} = 0{,}1\ \text{mol}$ d'ester, réaction totale : $0{,}1\ \text{mol}$ d'éthanol, soit $0{,}1\times46 = 4{,}6\ \text{g}$.'''),
        QuestionEpreuve.qcm('5', "Avec un triester d'acide gras, cette réaction sert à fabriquer :",
            options: ['des savons', 'des parfums', 'des engrais', 'des plastiques'],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_c_ch3',
            corrige: r'''La saponification des corps gras donne du glycérol et des carboxylates de sodium : les **savons**.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Cinétique : réaction d\'ordre 1',
      enonce: r'''Un réactif A se décompose selon une loi d'ordre 1 : $[A](t) = C_0\,e^{-kt}$ avec $C_0 = 2{,}0\times10^{-2}\ \text{mol·L}^{-1}$ et $k = 0{,}05\ \text{min}^{-1}$.

```graphe
a(t) = 20e^(-0.05t) | bleu
x: 0 .. 60
y: 0 .. 22
point: (13.86, 10) t½
titre: [A] en mmol/L, t en min
```''',
      questions: [
        QuestionEpreuve.redaction('1', 'Définis la vitesse volumique de disparition de A.',
            chapitre: 'chimie_c_ch4',
            bareme: [Critere(r"$v = -\dfrac{d[A]}{dt}$, exprimée en mol·L⁻¹·min⁻¹", 1)],
            corrige: r'''$$v(t) = -\frac{d[A]}{dt}$$
Graphiquement, c'est l'opposé du coefficient directeur de la tangente à la courbe $[A](t)$.'''),
        QuestionEpreuve.nombre('2', r"Calcule le temps de demi-réaction $t_{1/2} = \dfrac{\ln 2}{k}$.",
            valeur: 13.8629, tolerance: 0.01, unite: 'min', points: 1, chapitre: 'chimie_c_ch4',
            corrige: r'''$t_{1/2} = \dfrac{0{,}693}{0{,}05} \approx 13{,}9\ \text{min}$.'''),
        QuestionEpreuve.nombre('3', r"Calcule $[A]$ à $t = 20\ \text{min}$ (mol/L).",
            valeur: 7.3576e-3, tolerance: 0.02, points: 1, chapitre: 'chimie_c_ch4',
            corrige: r'''$[A](20) = 2\times10^{-2}\,e^{-1} \approx 7{,}36\times10^{-3}\ \text{mol·L}^{-1}$.'''),
        QuestionEpreuve.nombre('4', r"Calcule la vitesse initiale $v_0 = kC_0$ (mol/L/min).",
            valeur: 1.0e-3, tolerance: 0.01, points: 1, chapitre: 'chimie_c_ch4',
            corrige: r'''$v_0 = 0{,}05\times2\times10^{-2} = 1{,}0\times10^{-3}\ \text{mol·L}^{-1}\text{·min}^{-1}$.'''),
        QuestionEpreuve.qcm('5', 'Un catalyseur :',
            options: ['accélère la réaction sans être consommé', 'déplace l\'équilibre', 'augmente le rendement final', 'est un réactif'],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_c_ch4',
            corrige: r'''Il accélère la réaction et se retrouve intact en fin de réaction ; il ne modifie pas l'état final.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Solubilité du chlorure d\'argent',
      enonce: r'''Le produit de solubilité du chlorure d'argent $\text{AgCl}$ est $K_s = 1{,}8\times10^{-10}$ à 25 °C.''',
      questions: [
        QuestionEpreuve.nombre('1', r"Calcule la solubilité $s$ de AgCl dans l'eau pure (mol/L).",
            valeur: 1.3416e-5, tolerance: 0.02, points: 1, chapitre: 'chimie_c_ch5',
            corrige: r'''$K_s = [\text{Ag}^+][\text{Cl}^-] = s^2$ donc $s = \sqrt{1{,}8\times10^{-10}} \approx 1{,}34\times10^{-5}\ \text{mol·L}^{-1}$.'''),
        QuestionEpreuve.nombre('2', r"Quelle masse de AgCl peut-on dissoudre dans 1 L d'eau ? (g)",
            valeur: 1.9252e-3, tolerance: 0.02, points: 1, chapitre: 'chimie_c_ch5',
            corrige: r'''$M(\text{AgCl}) = 143{,}5\ \text{g·mol}^{-1}$ : $m = 1{,}34\times10^{-5}\times143{,}5 \approx 1{,}93\times10^{-3}\ \text{g}$.'''),
        QuestionEpreuve.qcm('3', 'Dans une solution de chlorure de sodium, la solubilité de AgCl :',
            options: ['diminue (effet d\'ion commun)', 'augmente', 'ne change pas', 'devient infinie'],
            bonne: 0,
            points: 1,
            chapitre: 'chimie_c_ch5',
            corrige: r'''Les ions $\text{Cl}^-$ déjà présents déplacent l'équilibre de dissolution vers le solide : **effet d'ion commun**.'''),
        QuestionEpreuve.nombre('4', r"Calcule la solubilité $s'$ de AgCl dans NaCl à $0{,}1\ \text{mol·L}^{-1}$.",
            valeur: 1.8e-9, tolerance: 0.02, points: 1, chapitre: 'chimie_c_ch5',
            corrige: r'''$[\text{Cl}^-] \approx 0{,}1$ donc $s' = \dfrac{K_s}{0{,}1} = 1{,}8\times10^{-9}\ \text{mol·L}^{-1}$ : environ 7 500 fois moins que dans l'eau pure.'''),
      ],
    ),
  ],
);
