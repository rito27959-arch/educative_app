// Épreuves de la série TI (format Office du Bac) : informatique,
// mathématiques, physique (électricité, électronique), anglais, français.

import 'modele.dart';

const epreuveInfoTi = Epreuve(
  id: 'bac_ti_info_1',
  matiere: 'info_ti',
  serie: 'TI',
  titre: 'Informatique',
  dureeMinutes: 300,
  coefficient: 5,
  consignes: "Les exercices sont indépendants. Langage : Python ; SQL standard.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Algorithmique avancée',
      enonce: r'''On considère la fonction récursive :

```python
def f(n):
    if n <= 1:
        return 1
    return n * f(n - 1)
```''',
      questions: [
        QuestionEpreuve.nombre('1', "Que renvoie f(5) ?",
            valeur: 120, tolerance: 0, points: 1.5, chapitre: 'info_ti_ch1',
            corrige: r'''$f$ calcule la factorielle : $5! = 5\times4\times3\times2\times1 = 120$.'''),
        QuestionEpreuve.qcm('2', "Quelle est la condition d'arrêt de la récursivité ?",
            options: ['n <= 1', 'n * f(n - 1)', 'n == 5', "il n'y en a pas"],
            bonne: 0,
            points: 1,
            chapitre: 'info_ti_ch1',
            corrige: r'''Le cas de base `n <= 1` renvoie 1 sans nouvel appel : sans lui, la récursion serait infinie.'''),
        QuestionEpreuve.qcm('3', "La complexité de f(n) en nombre d'appels est :",
            options: [r'$O(n)$', r'$O(n^2)$', r'$O(\log n)$', r'$O(2^n)$'],
            bonne: 0,
            points: 1,
            chapitre: 'info_ti_ch1',
            corrige: r'''Un appel par valeur de $n$ à 1 : $n$ appels, soit $O(n)$.'''),
        QuestionEpreuve.redaction('4', "Écris une version itérative de f.",
            chapitre: 'info_ti_ch3',
            bareme: [
              Critere("Initialisation r = 1", 0.5),
              Critere("Boucle de 2 à n et multiplication", 1),
              Critere("Retour du résultat", 0.5),
            ],
            corrige: r'''```python
def f(n):
    r = 1
    for i in range(2, n + 1):
        r = r * i
    return r
```'''),
        QuestionEpreuve.nombre('5', "Dans une liste triée de 4 096 éléments, combien de comparaisons au plus pour une recherche dichotomique ?",
            valeur: 13, tolerance: 0, points: 1.5, chapitre: 'info_ti_ch1',
            corrige: r'''$4096 = 2^{12}$ : on divise 12 fois par deux puis une dernière comparaison, soit **13** au plus (⌊log₂ n⌋ + 1).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Bases de données',
      enonce: r'''Une boutique en ligne de Douala utilise les tables :

Table **Clients** :

```tableau
id_client | nom | ville
1 | Essomba | Douala
2 | Kamga | Bafoussam
3 | Ndiaye | Douala
```

Table **Commandes** :

```tableau
id_cmd | id_client | montant
10 | 1 | 15 000
11 | 3 | 8 000
12 | 1 | 22 000
13 | 2 | 5 000
```''',
      questions: [
        QuestionEpreuve.courte('1', "Dans la table Commandes, comment appelle-t-on la colonne id_client qui fait référence à Clients ?",
            acceptees: ['clé étrangère', 'cle etrangere', 'une clé étrangère', 'foreign key'],
            points: 1,
            chapitre: 'info_ti_ch4',
            corrige: r'''Une **clé étrangère** : elle référence la clé primaire `id_client` de la table Clients.'''),
        QuestionEpreuve.nombre('2', "Que renvoie : SELECT SUM(montant) FROM Commandes WHERE id_client = 1 ?",
            valeur: 37000, tolerance: 0, points: 1.5, chapitre: 'info_ti_ch4',
            corrige: r'''$15\,000 + 22\,000 = 37\,000$.'''),
        QuestionEpreuve.nombre('3', "Combien de lignes renvoie la jointure des clients de Douala avec leurs commandes ?",
            valeur: 3, tolerance: 0, points: 1.5, chapitre: 'info_ti_ch4',
            corrige: r'''Clients de Douala : Essomba (commandes 10 et 12) et Ndiaye (commande 11), soit **3** lignes.'''),
        QuestionEpreuve.redaction('4', "Écris la requête qui affiche le nom de chaque client et le total de ses commandes.",
            chapitre: 'info_ti_ch4',
            bareme: [
              Critere("Jointure correcte sur id_client", 1),
              Critere("SUM(montant) et GROUP BY", 1),
              Critere("Syntaxe correcte", 0.5),
            ],
            corrige: r'''```sql
SELECT c.nom, SUM(m.montant) AS total
FROM Clients c
JOIN Commandes m ON m.id_client = c.id_client
GROUP BY c.id_client, c.nom;
```'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Web, réseaux et génie logiciel',
      enonce: r'''Questions de cours.''',
      questions: [
        QuestionEpreuve.qcm('1', "En HTML, la balise d'un lien hypertexte est :",
            options: ['<a>', '<link>', '<p>', '<href>'],
            bonne: 0,
            points: 1,
            chapitre: 'info_ti_ch5',
            corrige: r'''`<a href="…">texte</a>` ; `<link>` sert à relier une feuille de style.'''),
        QuestionEpreuve.qcm('2', "Le langage qui gère l'apparence d'une page web est :",
            options: ['CSS', 'SQL', 'Python', 'HTTP'],
            bonne: 0,
            points: 1,
            chapitre: 'info_ti_ch5',
            corrige: r'''**CSS** (feuilles de style) : couleurs, polices, mise en page.'''),
        QuestionEpreuve.nombre('3', "Combien d'hôtes utilisables dans un réseau /26 ?",
            valeur: 62, tolerance: 0, points: 1.5, chapitre: 'info_ti_ch6',
            corrige: r'''$32 - 26 = 6$ bits d'hôte : $2^6 - 2 = 62$.'''),
        QuestionEpreuve.qcm('4', "Dans le cycle en V, la phase qui répond à la « spécification » est :",
            options: ['la recette (validation)', 'le codage', 'la conception détaillée', 'les tests unitaires'],
            bonne: 0,
            points: 1,
            chapitre: 'info_ti_ch7',
            corrige: r'''Chaque phase descendante a sa phase de vérification en face : spécification ↔ recette, conception détaillée ↔ tests unitaires.'''),
        QuestionEpreuve.redaction('5', "Explique ce qu'est une injection SQL et comment s'en protéger.",
            chapitre: 'info_ti_ch6',
            bareme: [
              Critere("Définition : code SQL malveillant inséré via une saisie utilisateur", 1),
              Critere("Protection : requêtes préparées / paramétrées, validation des entrées", 1),
            ],
            corrige: r'''Une **injection SQL** consiste à glisser du code SQL dans un champ de saisie (ex. `' OR '1'='1`) pour modifier la requête exécutée par le serveur (contourner un mot de passe, lire des données).

**Protection** : requêtes **préparées** (paramètres séparés du code), validation et échappement des entrées, comptes de base de données aux droits minimaux.'''),
      ],
    ),
  ],
);

const epreuveMathsTi = Epreuve(
  id: 'bac_ti_maths_1',
  matiere: 'maths_ti',
  serie: 'TI',
  titre: 'Mathématiques',
  dureeMinutes: 240,
  coefficient: 4,
  consignes: "Calculatrice autorisée.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Logique et algèbre de Boole',
      enonce: r'''On note $\bar a$ la négation de $a$, $a\cdot b$ le ET et $a + b$ le OU.''',
      questions: [
        QuestionEpreuve.qcm('1', r"L'expression $\overline{a\cdot b}$ est égale à :",
            options: [r'$\bar a + \bar b$', r'$\bar a \cdot \bar b$', r'$a + b$', r'$\overline{a + b}$'],
            bonne: 0,
            points: 1.5,
            chapitre: 'maths_ti_ch1',
            corrige: r'''Loi de De Morgan : $\overline{a\cdot b} = \bar a + \bar b$.'''),
        QuestionEpreuve.qcm('2', r"Simplifie $a + a\cdot b$ :",
            options: [r'$a$', r'$b$', r'$a\cdot b$', r'$1$'],
            bonne: 0,
            points: 1.5,
            chapitre: 'maths_ti_ch1',
            corrige: r'''Absorption : $a + ab = a(1 + b) = a\cdot1 = a$.'''),
        QuestionEpreuve.redaction('3', r"Dresse la table de vérité de $a \oplus b$ (OU exclusif).",
            chapitre: 'maths_ti_ch1',
            bareme: [Critere("Table correcte : vrai seulement si a ≠ b", 1.5)],
            corrige: r'''```tableau
a | b | a ⊕ b
0 | 0 | 0
0 | 1 | 1
1 | 0 | 1
1 | 1 | 0
```'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Suites',
      enonce: r'''On considère la suite géométrique $(u_n)$ de premier terme $u_0 = 3$ et de raison $q = 2$, et la suite arithmétique $(v_n)$ de premier terme $v_0 = 5$ et de raison $r = 4$.''',
      questions: [
        QuestionEpreuve.nombre('1', r"Calcule $u_5$.",
            valeur: 96, tolerance: 0, points: 1.5, chapitre: 'maths_ti_ch2',
            corrige: r'''$u_n = u_0\,q^n$ donc $u_5 = 3\times2^5 = 96$.'''),
        QuestionEpreuve.nombre('2', r"Calcule $S = u_0 + u_1 + \dots + u_5$.",
            valeur: 189, tolerance: 0, points: 1.5, chapitre: 'maths_ti_ch2',
            corrige: r'''$S = u_0\dfrac{1 - q^6}{1 - q} = 3\times\dfrac{1 - 64}{-1} = 189$.'''),
        QuestionEpreuve.expression('3', r"Exprime $v_n$ en fonction de $n$ : $v_n = \dots$",
            attendue: '5 + 4n', variable: 'n', points: 1.5, chapitre: 'maths_ti_ch2',
            corrige: r'''$v_n = v_0 + nr = 5 + 4n$.'''),
        QuestionEpreuve.nombre('4', r"Calcule $v_0 + v_1 + \dots + v_{9}$.",
            valeur: 230, tolerance: 0, points: 1.5, chapitre: 'maths_ti_ch2',
            corrige: r'''10 termes : $S = 10\times\dfrac{v_0 + v_9}{2} = 10\times\dfrac{5 + 41}{2} = 230$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Problème : fonction numérique',
      enonce: r'''Soit $g$ la fonction définie sur $\mathbb R$ par $g(x) = x^3 - 3x + 1$.

```graphe
g(x) = x^3 - 3x + 1 | violet
x: -2.5 .. 2.5
y: -3 .. 5
point: (-1, 3)
point: (1, -1)
```''',
      questions: [
        QuestionEpreuve.expression('1', r"Calcule $g'(x)$.",
            attendue: '3x^2 - 3', points: 1.5, chapitre: 'maths_ti_ch3',
            corrige: r'''$g'(x) = 3x^2 - 3 = 3(x - 1)(x + 1)$.'''),
        QuestionEpreuve.redaction('2', r"Dresse le tableau de variations de $g$.",
            chapitre: 'maths_ti_ch3',
            bareme: [
              Critere(r"$g'$ positive sur $]-\infty;-1]$ et $[1;+\infty[$, négative entre", 1),
              Critere(r"Maximum local $g(-1) = 3$, minimum local $g(1) = -1$", 1),
              Critere("Limites en ±∞ et tableau complet", 1),
            ],
            corrige: r'''```variations
x     | −∞   |   | −1  |   | 1    |   | +∞
g'(x) |      | + | 0   | − | 0    | + |
g(x)  | −∞ b |   | 3 h |   | −1 b |   | +∞ h
```'''),
        QuestionEpreuve.nombre('3', r"Combien de solutions l'équation $g(x) = 0$ admet-elle dans $\mathbb R$ ?",
            valeur: 3, tolerance: 0, points: 2, chapitre: 'maths_ti_ch3',
            corrige: r'''$g$ passe de $-\infty$ à $3$ (s'annule une fois), de $3$ à $-1$ (une fois), de $-1$ à $+\infty$ (une fois) : **3** solutions (théorème des valeurs intermédiaires).'''),
        QuestionEpreuve.nombre('4', r"Une urne contient 3 boules rouges et 7 noires. On tire une boule au hasard. Probabilité qu'elle soit rouge ?",
            valeur: 0.3, tolerance: 0.001, points: 1.5, chapitre: 'maths_ti_ch4',
            corrige: r'''$\dfrac{3}{10} = 0{,}3$.'''),
        QuestionEpreuve.nombre('5', r"On en tire deux, successivement et avec remise. Probabilité d'obtenir deux rouges ?",
            valeur: 0.09, tolerance: 0.001, points: 1.5, chapitre: 'maths_ti_ch4',
            corrige: r'''Tirages indépendants : $0{,}3\times0{,}3 = 0{,}09$.'''),
      ],
    ),
  ],
);

const epreuvePhysiqueTi = Epreuve(
  id: 'bac_ti_physique_1',
  matiere: 'physique_ti',
  serie: 'TI',
  titre: 'Physique',
  dureeMinutes: 180,
  coefficient: 3,
  consignes: "Calculatrice autorisée. Donne les résultats avec leur unité.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Électricité',
      enonce: r'''Un générateur de f.é.m. $E = 12\ \text{V}$ et de résistance interne négligeable alimente deux résistors $R_1 = 40\ \Omega$ et $R_2 = 60\ \Omega$.''',
      questions: [
        QuestionEpreuve.nombre('1', r"Calcule la résistance équivalente si $R_1$ et $R_2$ sont en série.",
            valeur: 100, tolerance: 0.001, unite: 'Ω', points: 1.5, chapitre: 'physique_ti_ch1',
            corrige: r'''$R_s = R_1 + R_2 = 100\ \Omega$.'''),
        QuestionEpreuve.nombre('2', "Calcule l'intensité du courant dans ce montage série.",
            valeur: 0.12, tolerance: 0.01, unite: 'A', points: 1.5, chapitre: 'physique_ti_ch1',
            corrige: r'''$I = \dfrac{E}{R_s} = \dfrac{12}{100} = 0{,}12\ \text{A}$.'''),
        QuestionEpreuve.nombre('3', r"Calcule la résistance équivalente si $R_1$ et $R_2$ sont en parallèle.",
            valeur: 24, tolerance: 0.001, unite: 'Ω', points: 1.5, chapitre: 'physique_ti_ch1',
            corrige: r'''$R_p = \dfrac{R_1R_2}{R_1 + R_2} = \dfrac{2400}{100} = 24\ \Omega$.'''),
        QuestionEpreuve.nombre('4', "Calcule la puissance totale dissipée dans le montage parallèle.",
            valeur: 6, tolerance: 0.01, unite: 'W', points: 2, chapitre: 'physique_ti_ch1',
            corrige: r'''$P = \dfrac{E^2}{R_p} = \dfrac{144}{24} = 6\ \text{W}$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Électronique',
      enonce: r'''Une diode électroluminescente (DEL) de tension de seuil $U_D = 2\ \text{V}$ doit être parcourue par $I = 20\ \text{mA}$ sous une alimentation de $5\ \text{V}$. On la protège par une résistance $R$ en série.

Un condensateur de filtrage lisse ensuite la tension redressée d'une alimentation.''',
      questions: [
        QuestionEpreuve.nombre('1', "Calcule la valeur de R.",
            valeur: 150, tolerance: 0.01, unite: 'Ω', points: 1.5, chapitre: 'physique_ti_ch2',
            corrige: r'''$R = \dfrac{5 - 2}{0{,}020} = 150\ \Omega$.'''),
        QuestionEpreuve.qcm('2', "Une diode conduit lorsqu'elle est polarisée :",
            options: ['en direct, au-delà de sa tension de seuil', 'en inverse', 'dans les deux sens', 'jamais'],
            bonne: 0,
            points: 1.5,
            chapitre: 'physique_ti_ch2',
            corrige: r'''En direct (anode plus positive que la cathode) et au-delà de la tension de seuil.'''),
        QuestionEpreuve.qcm('3', "Dans une alimentation, le pont de diodes (pont de Graetz) sert à :",
            options: ['redresser la tension alternative', 'élever la tension', 'filtrer les parasites radio', 'stocker l\'énergie'],
            bonne: 0,
            points: 1.5,
            chapitre: 'physique_ti_ch2',
            corrige: r'''Il transforme la tension alternative en tension de signe constant (redressement double alternance) ; le condensateur la lisse ensuite.'''),
        QuestionEpreuve.redaction('4', "Décris le rôle d'un transistor utilisé en commutation.",
            chapitre: 'physique_ti_ch2',
            bareme: [
              Critere("Fonctionne comme un interrupteur commandé (bloqué / saturé)", 1.5),
              Critere("Un faible courant de base commande un courant de collecteur plus fort", 1.5),
            ],
            corrige: r'''En commutation, le transistor se comporte comme un **interrupteur commandé** : bloqué (aucun courant, interrupteur ouvert) ou saturé (interrupteur fermé). Un **petit courant de base** suffit à commander un **courant de collecteur bien plus grand** (moteur, relais, DEL de puissance).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Circuits numériques',
      enonce: r'''On étudie des portes logiques et la numération.''',
      questions: [
        QuestionEpreuve.qcm('1', "La sortie d'une porte NAND à deux entrées vaut 0 lorsque :",
            options: ['les deux entrées valent 1', 'une seule entrée vaut 1', 'les deux entrées valent 0', 'jamais'],
            bonne: 0,
            points: 1.5,
            chapitre: 'physique_ti_ch3',
            corrige: r'''NAND = NON-ET : $S = \overline{a\cdot b}$, nulle seulement si $a = b = 1$.'''),
        QuestionEpreuve.nombre('2', r"Convertis $(1011\,0110)_2$ en décimal.",
            valeur: 182, tolerance: 0, points: 1.5, chapitre: 'physique_ti_ch3',
            corrige: r'''$128 + 32 + 16 + 4 + 2 = 182$.'''),
        QuestionEpreuve.courte('3', "Écris 182 en hexadécimal.",
            acceptees: ['B6', '0xB6', 'b6'],
            points: 1.5,
            chapitre: 'physique_ti_ch3',
            corrige: r'''$1011\ 0110$ : $1011 = B$, $0110 = 6$, donc **B6**.'''),
        QuestionEpreuve.nombre('4', "Combien de combinaisons peut-on coder avec 8 bits ?",
            valeur: 256, tolerance: 0, points: 1.5, chapitre: 'physique_ti_ch3',
            corrige: r'''$2^8 = 256$ (de 0 à 255).'''),
      ],
    ),
  ],
);

const epreuveAnglaisTi = Epreuve(
  id: 'bac_ti_anglais_1',
  matiere: 'anglais_ti',
  serie: 'TI',
  titre: 'Anglais technique',
  dureeMinutes: 120,
  coefficient: 2,
  consignes: "Answer all questions in English.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Technical reading',
      enonce: r'''**Cloud storage**

Cloud storage allows users to save files on remote servers and access them from any device connected to the Internet. Instead of buying expensive hard drives, a small company in Buea can rent storage space and pay only for what it uses. However, the data travels over the network, so it must be encrypted. Users should also enable two-factor authentication to protect their accounts.''',
      questions: [
        QuestionEpreuve.vraiFaux('1', "With cloud storage, files are saved only on the user's computer.",
            vrai: false, points: 1.5, chapitre: 'anglais_ti_ch1',
            corrige: r'''False: files are saved on **remote servers**.'''),
        QuestionEpreuve.qcm('2', "Why must data be encrypted?",
            options: ['because it travels over the network', 'because it is too big', 'to make it faster', 'because it is free'],
            bonne: 0,
            points: 1.5,
            chapitre: 'anglais_ti_ch1',
            corrige: r'''"The data travels over the network, so it must be encrypted."'''),
        QuestionEpreuve.courte('3', "Give the full form of the acronym « CPU ».",
            acceptees: ['central processing unit'],
            points: 1.5,
            chapitre: 'anglais_ti_ch1',
            corrige: r'''**Central Processing Unit**, the « brain » of the computer.'''),
        QuestionEpreuve.qcm('4', "« To back up » data means:",
            options: ['to make a copy to avoid losing it', 'to delete it', 'to print it', 'to send it by email'],
            bonne: 0,
            points: 1.5,
            chapitre: 'anglais_ti_ch1',
            corrige: r'''A **backup** is a copy of data kept in a safe place.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Grammar',
      enonce: r'''Choose the correct form.''',
      questions: [
        QuestionEpreuve.qcm('1', "The program ___ by our team last year.",
            options: ['was written', 'is written', 'wrote', 'has written'],
            bonne: 0,
            points: 2,
            chapitre: 'anglais_ti_ch2',
            corrige: r'''Past passive (last year): **was written**.'''),
        QuestionEpreuve.qcm('2', "You ___ restart the computer after installing the update.",
            options: ['must', 'mustn\'t to', 'can to', 'should to'],
            bonne: 0,
            points: 2,
            chapitre: 'anglais_ti_ch2',
            corrige: r'''Modal + base verb without « to »: **must restart**.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Writing',
      enonce: r'''**Topic.** Write an email (about 120 words) to your teacher explaining why your project is late and proposing a new date.''',
      questions: [
        QuestionEpreuve.redaction('1', "Write your email.",
            chapitre: 'anglais_ti_ch2',
            bareme: [
              Critere("Email format: greeting, subject, closing", 2.5),
              Critere("Clear explanation and a proposed date", 3.5),
              Critere("Polite register and correct grammar", 4),
            ],
            corrige: r'''**Subject:** Late submission of my project

Dear Mr Tabi,

I am writing to apologise because my project will be late. My laptop broke down last week and I lost part of my work. I have started again on a school computer and I have already finished the database.

Could I submit the complete project on Friday 14th? I will also send you my backup files so that you can see my progress.

Thank you for your understanding.

Yours sincerely,
Paul'''),
      ],
    ),
  ],
);

const epreuveFrancaisTi = Epreuve(
  id: 'bac_ti_francais_1',
  matiere: 'francais_ti',
  serie: 'TI',
  titre: 'Français',
  dureeMinutes: 120,
  coefficient: 2,
  consignes: "Lis le texte, réponds aux questions puis traite le sujet d'expression écrite.",
  exercices: [
    ExerciceEpreuve(
      titre: 'Compréhension',
      enonce: r'''« Le téléphone portable a changé nos villages. Hier, il fallait marcher des heures pour annoncer une naissance ; aujourd'hui, un message suffit. Le commerçant connaît les prix du marché de la ville avant même de partir, l'élève révise avec des applications. Pourtant, certains anciens regrettent les veillées où l'on se parlait vraiment. Le progrès rapproche ceux qui sont loin, mais éloigne parfois ceux qui sont proches. »''',
      questions: [
        QuestionEpreuve.qcm('1', "Quelle est l'idée générale du texte ?",
            options: ["Le téléphone portable apporte des progrès mais aussi des pertes", "Le téléphone est inutile au village", "Les anciens refusent toute technologie", "Le commerce a disparu"],
            bonne: 0,
            points: 2,
            chapitre: 'francais_ti_ch2',
            corrige: r'''Le texte présente les **avantages** (communication, commerce, études) puis une **limite** (moins de vraies relations).'''),
        QuestionEpreuve.qcm('2', "« Le progrès rapproche ceux qui sont loin, mais éloigne parfois ceux qui sont proches » contient :",
            options: ['une antithèse', 'une comparaison', 'une énumération', 'une litote'],
            bonne: 0,
            points: 2,
            chapitre: 'francais_ti_ch1',
            corrige: r'''**Antithèse** : rapproche / éloigne, loin / proches.'''),
        QuestionEpreuve.courte('3', "Relève le connecteur logique qui introduit l'opposition dans le texte.",
            acceptees: ['pourtant', 'Pourtant'],
            points: 2,
            chapitre: 'francais_ti_ch1',
            corrige: r'''« **Pourtant** » (et aussi « mais » dans la dernière phrase).'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Expression écrite',
      enonce: r'''**Sujet.** Les réseaux sociaux sont-ils un danger ou une chance pour les jeunes ? Rédige un texte argumenté d'une vingtaine de lignes.''',
      questions: [
        QuestionEpreuve.redaction('1', "Rédige ton texte argumenté.",
            chapitre: 'francais_ti_ch1',
            bareme: [
              Critere("Introduction qui pose le problème", 2),
              Critere("Arguments pour la « chance » avec exemples", 4),
              Critere("Arguments pour le « danger » avec exemples", 4),
              Critere("Conclusion personnelle et nuancée", 2),
              Critere("Langue correcte, connecteurs logiques", 2),
            ],
            corrige: r'''## Plan possible
**Introduction** : les réseaux sociaux occupent une grande place dans la vie des jeunes ; sont-ils une chance ou un danger ?

**Une chance** : s'informer, apprendre (tutoriels, groupes de révision), créer et entreprendre, garder le lien avec la famille éloignée.

**Un danger** : fausses informations, cyberharcèlement, perte de temps et dépendance, exposition de la vie privée.

**Conclusion** : ni bons ni mauvais en soi ; tout dépend de l'usage. L'éducation au numérique fait d'eux une chance.'''),
      ],
    ),
  ],
);
