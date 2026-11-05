// Sujets n° 2 : chimie, SVTEEHB et informatique, séries D et C.

import 'modele.dart';

const epreuveChimieD2 = Epreuve(
  id: 'bac_d_chimie_2',
  matiere: 'chimie',
  serie: 'D',
  titre: 'Chimie',
  session: 'Sujet 2',
  dureeMinutes: 180,
  coefficient: 2,
  consignes: "Calculatrice autorisée. Masses molaires (g/mol) : H = 1 ; C = 12 ; O = 16. pKe = 14.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Acides forts et bases fortes',
      enonce: r'''On dispose d'une solution d'acide chlorhydrique à $C_A = 1{,}0\times10^{-2}\ \text{mol·L}^{-1}$ et d'une solution d'hydroxyde de sodium à $C_B = 1{,}0\times10^{-3}\ \text{mol·L}^{-1}$.''',
      questions: [
        QuestionEpreuve.nombre('1', "pH de la solution d'acide chlorhydrique.", valeur: 2, tolerance: 0.01, points: 1, chapitre: 'chimie_ch1',
            corrige: r'''Acide fort : $[\text{H}_3\text{O}^+] = C_A = 10^{-2}$, donc pH $= 2$.'''),
        QuestionEpreuve.nombre('2', "On dilue 10 fois cette solution : nouveau pH ?", valeur: 3, tolerance: 0.01, points: 1, chapitre: 'chimie_ch1',
            corrige: r'''$C' = 10^{-3}$ donc pH $= 3$ : diluer 10 fois un acide fort augmente le pH d'une unité.'''),
        QuestionEpreuve.nombre('3', "pH de la solution d'hydroxyde de sodium.", valeur: 11, tolerance: 0.01, points: 1, chapitre: 'chimie_ch1',
            corrige: r'''$[\text{HO}^-] = 10^{-3}$, $[\text{H}_3\text{O}^+] = \dfrac{10^{-14}}{10^{-3}} = 10^{-11}$ : pH $= 11$.'''),
        QuestionEpreuve.nombre('4', "On mélange des volumes égaux d'acide et de soude de même concentration (10⁻² mol/L). pH du mélange ?", valeur: 7, tolerance: 0.01, points: 1, chapitre: 'chimie_ch1',
            corrige: r'''Quantités égales d'acide fort et de base forte : neutralisation totale, solution de NaCl neutre, pH $= 7$ à 25 °C.'''),
        QuestionEpreuve.qcm('5', "Pour le dosage d'un acide fort par une base forte, on peut utiliser :",
            options: ['le bleu de bromothymol (6,0 – 7,6)', "l'hélianthine seule (3,1 – 4,4)", 'aucun indicateur', 'le tournesol en poudre'],
            bonne: 0, points: 1, chapitre: 'chimie_ch1',
            corrige: r'''pH à l'équivalence $= 7$ : le BBT, dont la zone de virage contient 7.'''),
        QuestionEpreuve.redaction('6', "Écris l'équation de l'autoprotolyse de l'eau et donne l'expression de Ke.",
            chapitre: 'chimie_ch1',
            bareme: [Critere(r"$2\text{H}_2\text{O} \rightleftharpoons \text{H}_3\text{O}^+ + \text{HO}^-$ et $K_e = [\text{H}_3\text{O}^+][\text{HO}^-] = 10^{-14}$", 1)],
            corrige: r'''$$2\,\text{H}_2\text{O} \rightleftharpoons \text{H}_3\text{O}^+ + \text{HO}^-\qquad K_e = [\text{H}_3\text{O}^+][\text{HO}^-] = 10^{-14}\ \text{à } 25\ °\text{C}$$'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Alcools et oxydation ménagée',
      enonce: r'''On étudie l'éthanol $\text{CH}_3\text{CH}_2\text{OH}$ et le propan-2-ol $\text{CH}_3\text{CHOHCH}_3$.''',
      questions: [
        QuestionEpreuve.qcm('1', "Le propan-2-ol est un alcool :", options: ['secondaire', 'primaire', 'tertiaire', 'aromatique'],
            bonne: 0, points: 1, chapitre: 'chimie_ch3',
            corrige: r'''Le carbone fonctionnel porte deux groupes carbonés : alcool **secondaire**.'''),
        QuestionEpreuve.courte('2', "Nomme le produit de l'oxydation ménagée du propan-2-ol.",
            acceptees: ['propanone', 'acétone', 'acetone', 'la propanone'],
            points: 1, chapitre: 'chimie_ch3',
            corrige: r'''Un alcool secondaire donne une cétone : la **propanone** (acétone).'''),
        QuestionEpreuve.qcm('3', "Le test à la 2,4-DNPH positif (précipité jaune) indique :",
            options: ['un groupe carbonyle (aldéhyde ou cétone)', 'un acide carboxylique', 'un alcool', 'un ester'],
            bonne: 0, points: 1, chapitre: 'chimie_ch3',
            corrige: r'''La DNPH caractérise le groupe **carbonyle** ; la liqueur de Fehling distingue ensuite l'aldéhyde (positif) de la cétone.'''),
        QuestionEpreuve.nombre('4', "Masse molaire de l'éthanol.", valeur: 46, tolerance: 0.005, unite: 'g/mol', points: 1, chapitre: 'chimie_ch3',
            corrige: r'''$\text{C}_2\text{H}_6\text{O}$ : $2\times12 + 6 + 16 = 46\ \text{g·mol}^{-1}$.'''),
        QuestionEpreuve.redaction('5', "Donne les produits successifs de l'oxydation ménagée de l'éthanol (oxydant en excès).",
            chapitre: 'chimie_ch3',
            bareme: [Critere("Éthanal (aldéhyde) puis acide éthanoïque", 1)],
            corrige: r'''Alcool primaire : éthanol $\to$ **éthanal** $\text{CH}_3\text{CHO}$ $\to$ **acide éthanoïque** $\text{CH}_3\text{COOH}$ (si l'oxydant est en excès).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Dosage d\'oxydoréduction',
      enonce: r'''On dose $V = 20\ \text{mL}$ d'une solution d'ions $\text{Fe}^{2+}$ par une solution acidifiée de permanganate de potassium à $C = 0{,}02\ \text{mol·L}^{-1}$. L'équivalence est obtenue pour $V_E = 10\ \text{mL}$.

$$\text{MnO}_4^- + 5\,\text{Fe}^{2+} + 8\,\text{H}^+ \longrightarrow \text{Mn}^{2+} + 5\,\text{Fe}^{3+} + 4\,\text{H}_2\text{O}$$''',
      questions: [
        QuestionEpreuve.qcm('1', r"Dans cette réaction, $\text{MnO}_4^-$ joue le rôle :", options: ["d'oxydant", 'de réducteur', 'de catalyseur', "d'acide"],
            bonne: 0, points: 1, chapitre: 'chimie_ch2',
            corrige: r'''Il capte des électrons (Mn passe de +VII à +II) : c'est l'**oxydant**.'''),
        QuestionEpreuve.nombre('2', r"Calcule la concentration en ions $\text{Fe}^{2+}$ (mol/L).", valeur: 0.05, tolerance: 0.01, points: 2, chapitre: 'chimie_ch2',
            corrige: r'''À l'équivalence $n(\text{Fe}^{2+}) = 5\,n(\text{MnO}_4^-) = 5\times0{,}02\times0{,}010 = 10^{-3}\ \text{mol}$, donc $[\text{Fe}^{2+}] = \dfrac{10^{-3}}{0{,}020} = 0{,}05\ \text{mol·L}^{-1}$.'''),
        QuestionEpreuve.qcm('3', "Comment repère-t-on l'équivalence ?", options: ['la teinte violette persiste', 'la solution devient incolore', 'un précipité blanc apparaît', 'un gaz se dégage'],
            bonne: 0, points: 1, chapitre: 'chimie_ch2',
            corrige: r'''Avant l'équivalence, $\text{MnO}_4^-$ (violet) est consommé ; juste après, il est en excès : la **teinte violette persiste**.'''),
        QuestionEpreuve.redaction('4', "Écris les deux demi-équations électroniques.",
            chapitre: 'chimie_ch2',
            bareme: [Critere(r"$\text{MnO}_4^- + 8\text{H}^+ + 5e^- \rightarrow \text{Mn}^{2+} + 4\text{H}_2\text{O}$ et $\text{Fe}^{2+} \rightarrow \text{Fe}^{3+} + e^-$", 1)],
            corrige: r'''$$\text{MnO}_4^- + 8\,\text{H}^+ + 5\,e^- \rightarrow \text{Mn}^{2+} + 4\,\text{H}_2\text{O}$$
$$\text{Fe}^{2+} \rightarrow \text{Fe}^{3+} + e^- \quad (\times 5)$$'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Cinétique',
      enonce: r'''La quantité de produit formé suit $n(t) = 0{,}1\left(1 - e^{-t/20}\right)$ mol ($t$ en min) :

```graphe
n(t) = 0.1(1 - e^(-t/20)) | vert
droite: y = 0.1 | gris
x: 0 .. 100
y: 0 .. 0.12
point: (13.86, 0.05) t½
titre: n en mol, t en min
```''',
      questions: [
        QuestionEpreuve.nombre('1', r"Calcule le temps de demi-réaction (min).", valeur: 13.8629, tolerance: 0.01, unite: 'min', points: 2, chapitre: 'chimie_ch4',
            corrige: r'''$n(t_{1/2}) = 0{,}05 \iff e^{-t/20} = \frac12 \iff t_{1/2} = 20\ln 2 \approx 13{,}9\ \text{min}$.'''),
        QuestionEpreuve.qcm('2', "Si on refroidit le mélange, le temps de demi-réaction :", options: ['augmente', 'diminue', 'ne change pas', 'devient nul'],
            bonne: 0, points: 1, chapitre: 'chimie_ch4',
            corrige: r'''La réaction est plus lente à basse température : $t_{1/2}$ augmente.'''),
        QuestionEpreuve.redaction('3', "Définis le temps de demi-réaction.",
            chapitre: 'chimie_ch4',
            bareme: [Critere("Durée au bout de laquelle l'avancement atteint la moitié de sa valeur finale", 1)],
            corrige: r'''C'est la durée au bout de laquelle l'avancement atteint **la moitié de sa valeur finale**.'''),
      ],
    ),
  ],
);

const epreuveChimieC2 = Epreuve(
  id: 'bac_c_chimie_2',
  matiere: 'chimie_c',
  serie: 'C',
  titre: 'Chimie',
  session: 'Sujet 2',
  dureeMinutes: 180,
  coefficient: 3,
  consignes: "Calculatrice autorisée. Masses molaires (g/mol) : H = 1 ; C = 12 ; N = 14 ; O = 16 ; Cu = 63,5. F = 96 500 C/mol.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Solutions tampons',
      enonce: r'''On mélange des quantités égales d'acide éthanoïque et d'éthanoate de sodium. p$K_a$(CH₃COOH/CH₃COO⁻) $= 4{,}8$.''',
      questions: [
        QuestionEpreuve.nombre('1', "pH du mélange équimolaire.", valeur: 4.8, tolerance: 0.01, points: 1, chapitre: 'chimie_c_ch1',
            corrige: r'''$\text{pH} = \text{p}K_a + \log\dfrac{[\text{A}^-]}{[\text{AH}]} = 4{,}8 + \log 1 = 4{,}8$.'''),
        QuestionEpreuve.nombre('2', "pH si [base] = 10 × [acide].", valeur: 5.8, tolerance: 0.01, points: 1.5, chapitre: 'chimie_c_ch1',
            corrige: r'''$\text{pH} = 4{,}8 + \log 10 = 5{,}8$.'''),
        QuestionEpreuve.qcm('3', "Une solution tampon :", options: ['varie peu de pH par ajout modéré d\'acide, de base ou par dilution', 'a toujours un pH de 7', 'est une base forte', 'neutralise tout'],
            bonne: 0, points: 1, chapitre: 'chimie_c_ch1',
            corrige: r'''C'est sa définition ; son pH est voisin du p$K_a$ du couple.'''),
        QuestionEpreuve.nombre('4', "Volume de soude à 0,1 mol/L à ajouter à 20 mL d'acide éthanoïque à 0,1 mol/L pour obtenir pH = pKa (mL).", valeur: 10, tolerance: 0.01, unite: 'mL', points: 1.5, chapitre: 'chimie_c_ch1',
            corrige: r'''pH $=$ p$K_a$ à la demi-équivalence : $V = \dfrac{V_E}{2} = \dfrac{20}{2} = 10\ \text{mL}$.'''),
        QuestionEpreuve.redaction('5', "Cite une application des solutions tampons.",
            chapitre: 'chimie_c_ch1',
            bareme: [Critere("Sang (pH ≈ 7,4), étalonnage des pH-mètres, milieux biologiques…", 1)],
            corrige: r'''Le **sang** est tamponné autour de pH 7,4 ; on utilise aussi des tampons pour **étalonner les pH-mètres** et en biologie (cultures, enzymes).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Acides α-aminés',
      enonce: r'''La glycine a pour formule $\text{H}_2\text{N–CH}_2\text{–COOH}$ ; l'alanine $\text{H}_2\text{N–CH(CH}_3\text{)–COOH}$.''',
      questions: [
        QuestionEpreuve.nombre('1', "Masse molaire de la glycine.", valeur: 75, tolerance: 0.005, unite: 'g/mol', points: 1, chapitre: 'chimie_c_ch3',
            corrige: r'''$\text{C}_2\text{H}_5\text{NO}_2$ : $24 + 5 + 14 + 32 = 75\ \text{g·mol}^{-1}$.'''),
        QuestionEpreuve.courte('2', "Comment appelle-t-on la liaison –CO–NH– entre deux acides aminés ?",
            acceptees: ['liaison peptidique', 'peptidique', 'la liaison peptidique'],
            points: 1, chapitre: 'chimie_c_ch3',
            corrige: r'''La **liaison peptidique** (fonction amide).'''),
        QuestionEpreuve.nombre('3', "Combien de dipeptides différents peut-on former avec la glycine et l'alanine (chacun pouvant être utilisé deux fois) ?", valeur: 4, tolerance: 0, points: 1, chapitre: 'chimie_c_ch3',
            corrige: r'''Gly-Gly, Ala-Ala, Gly-Ala et Ala-Gly : **4**.'''),
        QuestionEpreuve.qcm('4', "L'alanine possède un carbone asymétrique, donc :", options: ['elle est chirale (deux énantiomères)', "elle n'a pas d'isomère", 'elle est un alcool', 'elle est achirale'],
            bonne: 0, points: 1, chapitre: 'chimie_c_ch3',
            corrige: r'''Un carbone lié à 4 groupes différents rend la molécule chirale : formes D et L.'''),
        QuestionEpreuve.redaction('5', "Écris l'équation de formation du dipeptide Gly-Ala.",
            chapitre: 'chimie_c_ch3',
            bareme: [Critere("Condensation : Gly + Ala → Gly-Ala + H₂O, liaison peptidique correcte", 1)],
            corrige: r'''$$\text{H}_2\text{N–CH}_2\text{–COOH} + \text{H}_2\text{N–CH(CH}_3\text{)–COOH} \rightarrow \text{H}_2\text{N–CH}_2\text{–CO–NH–CH(CH}_3\text{)–COOH} + \text{H}_2\text{O}$$'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Électrolyse',
      enonce: r'''On électrolyse une solution de sulfate de cuivre avec un courant $I = 2\ \text{A}$ pendant $t = 965\ \text{s}$. Du cuivre se dépose à la cathode.''',
      questions: [
        QuestionEpreuve.nombre('1', "Masse de cuivre déposée (g).", valeur: 0.635, tolerance: 0.01, unite: 'g', points: 2, chapitre: 'chimie_c_ch5',
            corrige: r'''$Q = It = 1930\ \text{C}$ ; $n(e^-) = \dfrac{1930}{96\,500} = 0{,}02$ ; $n(\text{Cu}) = 0{,}01\ \text{mol}$ ; $m = 0{,}635\ \text{g}$.'''),
        QuestionEpreuve.qcm('2', "À la cathode se produit :", options: ['une réduction', 'une oxydation', 'une neutralisation', 'une précipitation'],
            bonne: 0, points: 1, chapitre: 'chimie_c_ch5',
            corrige: r'''$\text{Cu}^{2+} + 2e^- \rightarrow \text{Cu}$ : réduction à la cathode.'''),
        QuestionEpreuve.courte('3', "Quel gaz se dégage à l'anode (électrode inerte) ?",
            acceptees: ['dioxygène', 'O2', 'oxygène', 'O₂'],
            points: 1, chapitre: 'chimie_c_ch5',
            corrige: r'''L'eau est oxydée : $2\text{H}_2\text{O} \rightarrow \text{O}_2 + 4\text{H}^+ + 4e^-$ : **dioxygène**.'''),
        QuestionEpreuve.redaction('4', "Cite une application industrielle de l'électrolyse.",
            chapitre: 'chimie_c_ch5',
            bareme: [Critere("Purification du cuivre, galvanoplastie, production d'aluminium…", 1)],
            corrige: r'''Raffinage du cuivre, **production d'aluminium** (Edéa au Cameroun), galvanoplastie (chromage, argenture).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Équilibre d\'estérification',
      enonce: r'''La constante d'équilibre de l'estérification acide éthanoïque + éthanol vaut $K = 4$.''',
      questions: [
        QuestionEpreuve.nombre('1', "Rendement à partir d'un mélange équimolaire (fraction décimale).", valeur: 0.6667, tolerance: 0.01, points: 1.5, chapitre: 'chimie_c_ch4',
            corrige: r'''$\dfrac{x^2}{(1-x)^2} = 4 \Rightarrow \dfrac{x}{1-x} = 2 \Rightarrow x = \dfrac23 \approx 0{,}67$.'''),
        QuestionEpreuve.qcm('2', "Un excès d'alcool :", options: ["augmente le rendement en ester", "diminue le rendement", "n'a aucun effet", "change la valeur de K"],
            bonne: 0, points: 1, chapitre: 'chimie_c_ch4',
            corrige: r'''L'équilibre se déplace vers la formation de l'ester ; $K$ ne change pas.'''),
        QuestionEpreuve.nombre('3', "Avancement final (mol) pour 1 mol d'acide et 2 mol d'alcool.", valeur: 0.84530, tolerance: 0.01, unite: 'mol', points: 1.5, chapitre: 'chimie_c_ch4',
            corrige: r'''$\dfrac{x^2}{(1-x)(2-x)} = 4 \iff 3x^2 - 12x + 8 = 0 \iff x = \dfrac{12 - \sqrt{48}}{6} \approx 0{,}845\ \text{mol}$ (l'autre racine dépasse 1).'''),
      ],
    ),
  ],
);

const _genetiqueHumaine = ExerciceEpreuve(
  titre: 'Génétique humaine : la drépanocytose',
  enonce: r'''La drépanocytose est une maladie héréditaire fréquente en Afrique centrale. Elle est due à un allèle **récessif** $s$ (hémoglobine anormale) d'un gène porté par un autosome ; l'allèle normal est $A$.

Un couple, tous deux non malades, a un premier enfant malade.''',
  questions: [
    QuestionEpreuve.qcm('1', "Le génotype des deux parents est :", options: ['A/s et A/s', 'A/A et A/s', 's/s et A/A', 'A/A et A/A'],
        bonne: 0, points: 1.5, chapitre: 'svt_ch1',
        corrige: r'''L'enfant malade est $s/s$ : il a reçu un $s$ de chaque parent. Les parents, sains, sont **hétérozygotes** $A/s$.'''),
    QuestionEpreuve.nombre('2', "Probabilité que leur prochain enfant soit malade ?", valeur: 0.25, tolerance: 0.001, points: 1.5, chapitre: 'svt_ch1',
        corrige: r'''$A/s \times A/s$ : $\frac14$ $A/A$, $\frac12$ $A/s$, $\frac14$ $s/s$. Probabilité : $\frac14$.'''),
    QuestionEpreuve.nombre('3', "Sachant que l'enfant est sain, probabilité qu'il soit porteur (A/s) ?", valeur: 2 / 3, tolerance: 0.01, points: 1.5, chapitre: 'svt_ch1',
        corrige: r'''Parmi les enfants sains ($\frac34$), les porteurs représentent $\frac{1/2}{3/4} = \frac23$.'''),
    QuestionEpreuve.courte('4', "Comment appelle-t-on l'hémoglobine anormale ?", acceptees: ['HbS', 'hémoglobine S', 'Hb S', 'hemoglobine S'],
        points: 1, chapitre: 'svt_ch1',
        corrige: r'''L'**hémoglobine S** (HbS), qui déforme les globules rouges en faucille.'''),
    QuestionEpreuve.redaction('5', "Pourquoi conseille-t-on un test (électrophorèse de l'hémoglobine) avant le mariage ?",
        chapitre: 'svt_ch1',
        bareme: [
          Critere("Deux porteurs sains ont 1 risque sur 4 d'avoir un enfant malade à chaque grossesse", 1),
          Critere("Le test révèle les porteurs (A/s) qui n'ont pas de symptômes", 0.5),
        ],
        corrige: r'''Les porteurs $A/s$ ne sont pas malades et ignorent souvent leur statut. Si deux porteurs ont des enfants, **chaque grossesse** présente un risque de $\frac14$. L'électrophorèse permet de connaître son statut et de recevoir un conseil génétique.'''),
  ],
);

const epreuveSvtD2 = Epreuve(
  id: 'bac_d_svt_2',
  matiere: 'svt',
  serie: 'D',
  titre: 'SVTEEHB',
  session: 'Sujet 2',
  dureeMinutes: 240,
  coefficient: 4,
  consignes: "Justifie tes réponses à partir des documents.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Reproduction humaine',
      enonce: r'''Le document montre l'évolution du taux de LH au cours d'un cycle de 28 jours :

```graphe
l(x) = 5 + 60e^(-((x-14)^2)/1.5) | violet
x: 1 .. 28
y: 0 .. 70
titre: LH (u.a.), jours du cycle
```''',
      questions: [
        QuestionEpreuve.nombre('1', "À quel jour du cycle a lieu l'ovulation ?", valeur: 14, tolerance: 0, points: 1, chapitre: 'svt_ch6',
            corrige: r'''Le pic de LH déclenche l'ovulation environ 24 h plus tard : vers le **14ᵉ jour**.'''),
        QuestionEpreuve.qcm('2', "L'hormone hypophysaire responsable de l'ovulation est :", options: ['la LH', 'la progestérone', "l'insuline", 'la testostérone'],
            bonne: 0, points: 1, chapitre: 'svt_ch6',
            corrige: r'''Le **pic de LH**, provoqué par le rétrocontrôle positif des œstrogènes.'''),
        QuestionEpreuve.courte('3', "Quelle hormone le corps jaune sécrète-t-il principalement ?", acceptees: ['progestérone', 'la progestérone', 'progesterone'],
            points: 1, chapitre: 'svt_ch6',
            corrige: r'''La **progestérone** (et des œstrogènes), qui prépare l'utérus à la nidation.'''),
        QuestionEpreuve.qcm('4', "La fécondation a lieu habituellement :", options: ["dans le tiers supérieur de la trompe", "dans l'utérus", "dans l'ovaire", "dans le vagin"],
            bonne: 0, points: 1, chapitre: 'svt_ch6',
            corrige: r'''Dans la **trompe** (pavillon et ampoule) ; l'œuf migre ensuite vers l'utérus.'''),
        QuestionEpreuve.nombre('5', "Durée (jours) de la phase lutéale dans ce cycle.", valeur: 14, tolerance: 0, points: 1, chapitre: 'svt_ch6',
            corrige: r'''Du jour 14 au jour 28 : **14 jours** (durée assez constante d'un cycle à l'autre).'''),
        QuestionEpreuve.redaction('6', "Explique le mode d'action de la pilule contraceptive combinée.",
            chapitre: 'svt_ch6',
            bareme: [
              Critere("Hormones de synthèse (œstrogène + progestatif) à doses constantes", 0.5),
              Critere("Rétrocontrôle négatif sur l'hypothalamus et l'hypophyse : pas de pic de LH, pas d'ovulation", 1),
              Critere("Effets annexes : glaire cervicale épaisse, endomètre peu développé", 0.5),
            ],
            corrige: r'''La pilule apporte chaque jour des hormones de synthèse. Leur concentration constante exerce un **rétrocontrôle négatif** sur le complexe hypothalamo-hypophysaire : la sécrétion de FSH et LH reste faible, **il n'y a pas de pic de LH, donc pas d'ovulation**. De plus, la glaire cervicale s'épaissit (barrière aux spermatozoïdes) et l'endomètre se développe peu.'''),
      ],
    ),
    _genetiqueHumaine,
    ExerciceEpreuve(
      titre: 'Géologie',
      enonce: r'''Le mont Cameroun appartient à la « Ligne du Cameroun », un alignement de volcans qui va du golfe de Guinée jusqu'au Tchad. On date une roche par le carbone 14 ($T = 5\,730$ ans).''',
      questions: [
        QuestionEpreuve.nombre('1', "Il reste 25 % du carbone 14 initial dans un bois fossilisé sous une coulée. Âge (ans) ?", valeur: 11460, tolerance: 0.01, unite: 'ans', points: 2, chapitre: 'svt_ch4',
            corrige: r'''$25\ \% = \frac14 = \frac{1}{2^2}$ : deux demi-vies, $2\times5730 = 11\,460$ ans.'''),
        QuestionEpreuve.courte('2', "Quelle roche volcanique sombre forme l'essentiel des coulées du mont Cameroun ?", acceptees: ['basalte', 'le basalte', 'basaltes'],
            points: 1, chapitre: 'svt_ch4',
            corrige: r'''Le **basalte**, roche magmatique volcanique à structure microlithique.'''),
        QuestionEpreuve.qcm('3', "Selon le principe de superposition, dans une série sédimentaire non déformée :", options: ['la couche du dessus est la plus récente', 'la couche du dessous est la plus récente', 'toutes ont le même âge', "on ne peut rien dire"],
            bonne: 0, points: 1, chapitre: 'svt_ch4',
            corrige: r'''Une couche est plus récente que celle qu'elle recouvre.'''),
        QuestionEpreuve.redaction('4', "Explique ce qu'est un volcan de type effusif.",
            chapitre: 'svt_ch4',
            bareme: [
              Critere("Lave fluide, pauvre en silice, peu de gaz", 1),
              Critere("Coulées de lave, éruptions peu explosives (ex. mont Cameroun)", 1),
            ],
            corrige: r'''Un volcan **effusif** émet une lave **fluide** (basaltique, pauvre en silice) d'où les gaz s'échappent facilement : il produit surtout des **coulées de lave**, avec des éruptions peu explosives. Le mont Cameroun en est un exemple (éruptions de 1999 et 2000).'''),
      ],
    ),
  ],
);

const epreuveSvtC2 = Epreuve(
  id: 'bac_c_svt_2',
  matiere: 'svt_c',
  serie: 'C',
  titre: 'SVTEEHB',
  session: 'Sujet 2',
  dureeMinutes: 120,
  coefficient: 2,
  consignes: "Justifie tes réponses.",
  exercices: [
    _genetiqueHumaine,
    ExerciceEpreuve(
      titre: 'Immunologie : groupes sanguins',
      enonce: r'''Le groupe sanguin dépend des antigènes portés par les globules rouges (A, B) et des anticorps du plasma.

```tableau
Groupe | Antigènes | Anticorps
A | A | anti-B
B | B | anti-A
AB | A et B | aucun
O | aucun | anti-A et anti-B
```''',
      questions: [
        QuestionEpreuve.courte('1', "Quel groupe est « donneur universel » (pour les globules rouges) ?", acceptees: ['O', 'groupe O', 'O-', 'O négatif'],
            points: 2, chapitre: 'svt_c_ch2',
            corrige: r'''Le groupe **O** (rhésus négatif) : ses globules rouges ne portent ni A ni B.'''),
        QuestionEpreuve.qcm('2', "Un receveur du groupe A peut recevoir des globules rouges des groupes :", options: ['A et O', 'A et B', 'AB seulement', 'tous'],
            bonne: 0, points: 2, chapitre: 'svt_c_ch2',
            corrige: r'''Il possède des anti-B : il ne doit pas recevoir d'antigène B. Donc **A ou O**.'''),
        QuestionEpreuve.redaction('3', "Explique la différence entre vaccination et sérothérapie.",
            chapitre: 'svt_c_ch2',
            bareme: [
              Critere("Vaccination : antigène atténué, immunité active, durable, préventive", 1.5),
              Critere("Sérothérapie : anticorps tout faits, immunité passive, immédiate et brève, curative", 1.5),
            ],
            corrige: r'''- **Vaccination** : on injecte un antigène rendu inoffensif ; l'organisme fabrique lui-même anticorps et cellules mémoire. Immunité **active**, lente à s'installer mais **durable** : c'est une prévention.
- **Sérothérapie** : on injecte des **anticorps** déjà fabriqués (sérum). Immunité **passive**, **immédiate** mais de courte durée : c'est un traitement d'urgence (tétanos, morsure de serpent).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Écologie : photosynthèse et carbone',
      enonce: r'''La forêt du bassin du Congo absorbe d'importantes quantités de dioxyde de carbone.''',
      questions: [
        QuestionEpreuve.qcm('1', "La photosynthèse :", options: ['absorbe du CO₂ et rejette du O₂', 'absorbe du O₂ et rejette du CO₂', 'ne se fait que la nuit', 'produit de l\'azote'],
            bonne: 0, points: 1.5, chapitre: 'svt_c_ch3',
            corrige: r'''$6\text{CO}_2 + 6\text{H}_2\text{O} \xrightarrow{\text{lumière}} \text{C}_6\text{H}_{12}\text{O}_6 + 6\text{O}_2$.'''),
        QuestionEpreuve.courte('2', "Dans quel organite de la cellule végétale se déroule la photosynthèse ?", acceptees: ['chloroplaste', 'chloroplastes', 'le chloroplaste'],
            points: 1.5, chapitre: 'svt_c_ch3',
            corrige: r'''Le **chloroplaste**, qui contient la chlorophylle.'''),
        QuestionEpreuve.redaction('3', "Explique les conséquences de la déforestation sur le cycle du carbone et le climat.",
            chapitre: 'svt_c_ch3',
            bareme: [
              Critere("Moins de CO₂ absorbé par la photosynthèse", 1),
              Critere("CO₂ libéré par la combustion et la décomposition du bois", 1),
              Critere("Renforcement de l'effet de serre, réchauffement, pertes de biodiversité", 1),
            ],
            corrige: r'''La forêt est un **puits de carbone**. La déforestation :
- réduit l'absorption de CO₂ par la photosynthèse ;
- libère le carbone stocké (brûlis, décomposition) ;
- augmente donc le CO₂ atmosphérique et **renforce l'effet de serre** ; elle détruit aussi la biodiversité et modifie les pluies.'''),
      ],
    ),
  ],
);

const epreuveInfoD2 = Epreuve(
  id: 'bac_d_info_2',
  matiere: 'info',
  serie: 'D',
  titre: 'Informatique',
  session: 'Sujet 2',
  dureeMinutes: 180,
  coefficient: 2,
  consignes: "Langage : Python.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Listes en Python',
      enonce: r'''```python
notes = [12, 7, 15, 9, 18, 10]
s = 0
for n in notes:
    if n % 2 == 0:
        s = s + n
print(s, len(notes), notes[1:3])
```''',
      questions: [
        QuestionEpreuve.nombre('1', "Quelle est la valeur de s affichée ?", valeur: 40, tolerance: 0, points: 1.5, chapitre: 'info_ch3',
            corrige: r'''Les notes paires sont 12, 18 et 10 : $s = 40$.'''),
        QuestionEpreuve.nombre('2', "Que vaut len(notes) ?", valeur: 6, tolerance: 0, points: 1, chapitre: 'info_ch3',
            corrige: r'''La liste contient **6** éléments.'''),
        QuestionEpreuve.qcm('3', "Que vaut notes[1:3] ?", options: ['[7, 15]', '[12, 7, 15]', '[7, 15, 9]', '[12, 7]'],
            bonne: 0, points: 1.5, chapitre: 'info_ch3',
            corrige: r'''Indices 1 et 2 (3 exclu) : `[7, 15]`.'''),
        QuestionEpreuve.redaction('4', "Écris une fonction compter(liste, x) qui renvoie le nombre d'occurrences de x.",
            chapitre: 'info_ch3',
            bareme: [
              Critere("Compteur initialisé à 0", 1),
              Critere("Parcours et comparaison", 1),
              Critere("Renvoi du compteur", 0.5),
            ],
            corrige: r'''```python
def compter(liste, x):
    c = 0
    for e in liste:
        if e == x:
            c = c + 1
    return c
```'''),
        QuestionEpreuve.qcm('5', "Le tri par sélection d'une liste de n éléments a une complexité :", options: [r'$O(n^2)$', r'$O(n)$', r'$O(\log n)$', r'$O(n\log n)$'],
            bonne: 0, points: 1.5, chapitre: 'info_ch1',
            corrige: r'''On cherche le minimum $n$ fois dans une partie de liste : environ $\frac{n^2}{2}$ comparaisons.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Bases de données : la bibliothèque',
      enonce: r'''Table **Livres** :

```tableau
id | titre | auteur | annee
1 | Une vie de boy | Oyono | 1956
2 | Ville cruelle | Eza Boto | 1954
3 | L'Enfant noir | Camara Laye | 1953
4 | Le vieux nègre et la médaille | Oyono | 1956
```''',
      questions: [
        QuestionEpreuve.nombre('1', "Combien de lignes renvoie : SELECT * FROM Livres WHERE auteur = 'Oyono' ?", valeur: 2, tolerance: 0, points: 1.5, chapitre: 'info_ch4',
            corrige: r'''Les livres 1 et 4 : **2** lignes.'''),
        QuestionEpreuve.nombre('2', "Que renvoie : SELECT MIN(annee) FROM Livres ?", valeur: 1953, tolerance: 0, points: 1.5, chapitre: 'info_ch4',
            corrige: r'''*L'Enfant noir*, 1953.'''),
        QuestionEpreuve.redaction('3', "Écris la requête qui ajoute le livre « Les Soleils des indépendances » de Kourouma (1968).",
            chapitre: 'info_ch4',
            bareme: [
              Critere("INSERT INTO Livres", 1),
              Critere("VALUES avec les 4 valeurs dans le bon ordre", 1),
            ],
            corrige: r'''```sql
INSERT INTO Livres (id, titre, auteur, annee)
VALUES (5, 'Les Soleils des indépendances', 'Kourouma', 1968);
```'''),
        QuestionEpreuve.qcm('4', "Pour modifier une ligne existante, on utilise :", options: ['UPDATE', 'ALTER', 'INSERT', 'SELECT'],
            bonne: 0, points: 1.5, chapitre: 'info_ch4',
            corrige: r'''`UPDATE Livres SET … WHERE …` ; `ALTER` modifie la structure de la table.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Sécurité informatique',
      enonce: r'''Questions de cours.''',
      questions: [
        QuestionEpreuve.qcm('1', "Un mot de passe solide :", options: ['est long et mélange lettres, chiffres et symboles', 'est votre date de naissance', 'est « 123456 »', 'est le même partout'],
            bonne: 0, points: 1.5, chapitre: 'info_ch6',
            corrige: r'''Longueur (12 caractères ou plus) et diversité ; un mot de passe différent par service.'''),
        QuestionEpreuve.qcm('2', "L'hameçonnage (phishing) consiste à :", options: ['se faire passer pour un service de confiance pour voler des identifiants', 'réparer un ordinateur', 'chiffrer un disque', 'accélérer Internet'],
            bonne: 0, points: 1.5, chapitre: 'info_ch6',
            corrige: r'''Faux message (SMS, mail) imitant une banque, un opérateur de mobile money… pour obtenir codes et mots de passe.'''),
        QuestionEpreuve.redaction('3', "Donne trois bonnes pratiques pour protéger son téléphone.",
            chapitre: 'info_ch6',
            bareme: [Critere("Trois pratiques pertinentes (code de verrouillage, mises à jour, applis officielles, sauvegardes, ne jamais donner son code…)", 2.5)],
            corrige: r'''- Verrouiller l'écran (code, empreinte) ;
- installer les **mises à jour** et seulement des applications officielles ;
- ne jamais communiquer ses codes (mobile money, SMS de validation) ;
- activer la double authentification et faire des sauvegardes.'''),
      ],
    ),
  ],
);

const epreuveInfoC2 = Epreuve(
  id: 'bac_c_info_2',
  matiere: 'info_c',
  serie: 'C',
  titre: 'Informatique',
  session: 'Sujet 2',
  dureeMinutes: 180,
  coefficient: 2,
  consignes: "Langage : Python.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Piles et files',
      enonce: r'''```python
pile = []
for x in [3, 8, 5]:
    pile.append(x)
a = pile.pop()
pile.append(1)
b = pile.pop()
c = pile.pop()
```''',
      questions: [
        QuestionEpreuve.nombre('1', "Valeur de a ?", valeur: 5, tolerance: 0, points: 1.5, chapitre: 'info_c_ch2',
            corrige: r'''Dernier empilé, premier dépilé : `a = 5`.'''),
        QuestionEpreuve.nombre('2', "Valeur de b ?", valeur: 1, tolerance: 0, points: 1.5, chapitre: 'info_c_ch2',
            corrige: r'''On a empilé 1 juste avant : `b = 1`.'''),
        QuestionEpreuve.nombre('3', "Valeur de c ?", valeur: 8, tolerance: 0, points: 1.5, chapitre: 'info_c_ch2',
            corrige: r'''La pile contenait `[3, 8]` : `c = 8`.'''),
        QuestionEpreuve.qcm('4', "Quelle structure utilise une imprimante partagée pour traiter les documents dans l'ordre d'arrivée ?", options: ['une file (FIFO)', 'une pile (LIFO)', 'un arbre', 'un dictionnaire'],
            bonne: 0, points: 1.5, chapitre: 'info_c_ch2',
            corrige: r'''Premier arrivé, premier servi : une **file**.'''),
        QuestionEpreuve.redaction('5', "Écris une fonction est_bien_parenthesee(s) qui utilise une pile pour vérifier les parenthèses d'une chaîne.",
            chapitre: 'info_c_ch2',
            bareme: [
              Critere("Empiler sur « ( », dépiler sur « ) »", 1),
              Critere("Échec si on dépile une pile vide", 0.5),
              Critere("Succès seulement si la pile est vide à la fin", 0.5),
            ],
            corrige: r'''```python
def est_bien_parenthesee(s):
    pile = []
    for c in s:
        if c == '(':
            pile.append(c)
        elif c == ')':
            if not pile:
                return False
            pile.pop()
    return len(pile) == 0
```'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Bases de données',
      enonce: r'''Table **Matchs** (championnat scolaire) :

```tableau
id | equipe | buts
1 | Lycée Joss | 3
2 | Lycée Leclerc | 1
3 | Lycée Joss | 2
4 | Lycée de Mbalmayo | 2
```''',
      questions: [
        QuestionEpreuve.nombre('1', "Que renvoie : SELECT SUM(buts) FROM Matchs WHERE equipe = 'Lycée Joss' ?", valeur: 5, tolerance: 0, points: 1.5, chapitre: 'info_c_ch4',
            corrige: r'''$3 + 2 = 5$.'''),
        QuestionEpreuve.nombre('2', "Combien de lignes renvoie : SELECT DISTINCT equipe FROM Matchs ?", valeur: 3, tolerance: 0, points: 1.5, chapitre: 'info_c_ch4',
            corrige: r'''Trois équipes différentes.'''),
        QuestionEpreuve.redaction('3', "Écris la requête qui classe les équipes par total de buts décroissant.",
            chapitre: 'info_c_ch4',
            bareme: [
              Critere("SUM(buts) et GROUP BY equipe", 1.5),
              Critere("ORDER BY total DESC", 1.5),
            ],
            corrige: r'''```sql
SELECT equipe, SUM(buts) AS total
FROM Matchs
GROUP BY equipe
ORDER BY total DESC;
```'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Réseaux',
      enonce: r'''Le réseau d'une salle informatique utilise l'adresse $172.16.5.0/24$.''',
      questions: [
        QuestionEpreuve.courte('1', "Quelle est l'adresse de diffusion (broadcast) ?", acceptees: ['172.16.5.255'],
            points: 1.5, chapitre: 'info_c_ch5',
            corrige: r'''Tous les bits d'hôte à 1 : **172.16.5.255**.'''),
        QuestionEpreuve.qcm('2', "Quel équipement relie ce réseau local à Internet ?", options: ['un routeur', 'un câble HDMI', 'une imprimante', 'un clavier'],
            bonne: 0, points: 1.5, chapitre: 'info_c_ch5',
            corrige: r'''Le **routeur** (passerelle) achemine les paquets entre réseaux.'''),
        QuestionEpreuve.redaction('3', "Explique la différence entre adresse IP et adresse MAC.",
            chapitre: 'info_c_ch5',
            bareme: [
              Critere("IP : adresse logique, attribuée selon le réseau, peut changer", 1.5),
              Critere("MAC : adresse physique de la carte réseau, fixée par le fabricant", 1.5),
            ],
            corrige: r'''- L'**adresse IP** est **logique** : attribuée par le réseau (souvent par DHCP), elle sert au routage entre réseaux et peut changer.
- L'**adresse MAC** est **physique** : gravée dans la carte réseau par le fabricant (48 bits), elle sert à la communication dans le réseau local.'''),
      ],
    ),
  ],
);
