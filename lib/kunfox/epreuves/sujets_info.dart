// Épreuves d'informatique, séries D et C (format Office du Bac).

import 'modele.dart';

const _tableEleves = r'''Une base de données scolaire contient la table **Eleves** :

```tableau
id | nom | serie | moyenne
1 | Abena | D | 13,5
2 | Mballa | C | 15,0
3 | Ngo Bassa | D | 9,5
4 | Fouda | C | 11,0
5 | Tchoua | D | 16,25
6 | Eyenga | D | 8,0
```''';

const epreuveInfoD = Epreuve(
  id: 'bac_d_info_1',
  matiere: 'info',
  serie: 'D',
  titre: 'Informatique',
  dureeMinutes: 180,
  coefficient: 2,
  consignes: 'Les trois exercices sont indépendants. Le langage utilisé est Python.',
  exercices: [
    ExerciceEpreuve(
      titre: 'Algorithmique et numération',
      enonce: r'''On considère le programme Python suivant :

```python
s = 0
for i in range(1, 6):
    s = s + i * i
print(s)
```''',
      questions: [
        QuestionEpreuve.nombre('1', 'Quelle valeur ce programme affiche-t-il ?',
            valeur: 55, tolerance: 0, points: 1.5, chapitre: 'info_ch3',
            corrige: r'''`range(1, 6)` donne $1, 2, 3, 4, 5$ : $s = 1 + 4 + 9 + 16 + 25 = 55$.'''),
        QuestionEpreuve.nombre('2', r"Convertis $(101101)_2$ en base 10.",
            valeur: 45, tolerance: 0, points: 1, chapitre: 'info_ch1',
            corrige: r'''$1\times2^5 + 0\times2^4 + 1\times2^3 + 1\times2^2 + 0\times2^1 + 1\times2^0 = 32 + 8 + 4 + 1 = 45$.'''),
        QuestionEpreuve.courte('3', 'Écris 200 en binaire.',
            acceptees: ['11001000', '1100 1000'],
            points: 1,
            chapitre: 'info_ch1',
            corrige: r'''$200 = 128 + 64 + 8$ : $(11001000)_2$.'''),
        QuestionEpreuve.qcm('4', 'La complexité du tri à bulles sur une liste de n éléments est, dans le pire des cas :',
            options: [r'$O(n^2)$', r'$O(n)$', r'$O(\log n)$', r'$O(1)$'],
            bonne: 0,
            points: 1,
            chapitre: 'info_ch1',
            corrige: r'''Deux boucles imbriquées : de l'ordre de $\frac{n(n-1)}{2}$ comparaisons, soit $O(n^2)$.'''),
        QuestionEpreuve.nombre('5', 'Combien de comparaisons faut-il au maximum pour une recherche dichotomique dans une liste triée de 1 000 éléments ?',
            valeur: 10, tolerance: 0, points: 1, chapitre: 'info_ch1',
            corrige: r'''Chaque comparaison divise l'intervalle par 2 : $2^{10} = 1024 \geq 1000$, donc **10** comparaisons au plus.'''),
        QuestionEpreuve.redaction('6', 'Écris une fonction Python `maximum(liste)` qui renvoie le plus grand élément d\'une liste non vide, sans utiliser `max`.',
            chapitre: 'info_ch3',
            bareme: [
              Critere('Initialisation avec le premier élément', 0.5),
              Critere('Parcours et comparaison correcte', 0.5),
              Critere('Renvoi du résultat (return)', 0.5),
            ],
            corrige: r'''```python
def maximum(liste):
    m = liste[0]
    for x in liste:
        if x > m:
            m = x
    return m
```'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Bases de données',
      enonce: _tableEleves,
      questions: [
        QuestionEpreuve.qcm('1', 'Dans cette table, la clé primaire est :',
            options: ['id', 'nom', 'serie', 'moyenne'],
            bonne: 0,
            points: 1,
            chapitre: 'info_ch4',
            corrige: r'''`id` identifie chaque ligne de façon **unique** : c'est la clé primaire (deux élèves peuvent avoir le même nom).'''),
        QuestionEpreuve.nombre('2', "Combien de lignes renvoie : SELECT * FROM Eleves WHERE serie = 'D' ?",
            valeur: 4, tolerance: 0, points: 1, chapitre: 'info_ch4',
            corrige: r'''Abena, Ngo Bassa, Tchoua et Eyenga : **4** lignes.'''),
        QuestionEpreuve.courte('3', 'Quel nom renvoie : SELECT nom FROM Eleves ORDER BY moyenne DESC LIMIT 1 ?',
            acceptees: ['Tchoua'],
            points: 1,
            chapitre: 'info_ch4',
            corrige: r'''Tri par moyenne décroissante, on garde la première : **Tchoua** (16,25).'''),
        QuestionEpreuve.nombre('4', "Que renvoie : SELECT AVG(moyenne) FROM Eleves WHERE serie = 'C' ?",
            valeur: 13, tolerance: 0.001, points: 1, chapitre: 'info_ch4',
            corrige: r'''$\dfrac{15{,}0 + 11{,}0}{2} = 13$.'''),
        QuestionEpreuve.qcm('5', 'Le mot-clé SQL qui trie les résultats est :',
            options: ['ORDER BY', 'GROUP BY', 'SORT', 'WHERE'],
            bonne: 0,
            points: 1,
            chapitre: 'info_ch4',
            corrige: r'''`ORDER BY colonne` (ASC par défaut, DESC pour décroissant).'''),
        QuestionEpreuve.redaction('6', 'Écris la requête qui affiche le nom et la moyenne des élèves admis (moyenne ≥ 10), du meilleur au moins bon.',
            chapitre: 'info_ch4',
            bareme: [
              Critere('SELECT nom, moyenne FROM Eleves', 0.5),
              Critere('WHERE moyenne >= 10', 0.75),
              Critere('ORDER BY moyenne DESC', 0.75),
            ],
            corrige: r'''```sql
SELECT nom, moyenne
FROM Eleves
WHERE moyenne >= 10
ORDER BY moyenne DESC;
```
Résultat : Tchoua, Mballa, Abena, Fouda.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Réseaux',
      enonce: r'''Un ordinateur du laboratoire du lycée a pour adresse IP $192.168.1.37$ avec le masque $255.255.255.0$ (soit $/24$).''',
      questions: [
        QuestionEpreuve.courte('1', 'Quelle est l\'adresse du réseau ?',
            acceptees: ['192.168.1.0', '192.168.1.0/24'],
            points: 1,
            chapitre: 'info_ch5',
            corrige: r'''On garde les 24 premiers bits (les trois premiers octets) et on met le reste à 0 : **192.168.1.0**.'''),
        QuestionEpreuve.nombre('2', 'Combien d\'hôtes peut-on adresser dans ce réseau ?',
            valeur: 254, tolerance: 0, points: 1, chapitre: 'info_ch5',
            corrige: r'''8 bits pour les hôtes : $2^8 - 2 = 254$ (on retire l'adresse du réseau et celle de diffusion).'''),
        QuestionEpreuve.qcm('3', 'Le rôle du DNS est de :',
            options: ['traduire un nom de domaine en adresse IP', 'attribuer automatiquement les adresses IP', 'chiffrer les échanges', 'relier deux réseaux'],
            bonne: 0,
            points: 1,
            chapitre: 'info_ch5',
            corrige: r'''Le DNS associe un nom (ex. `minesec.gov.cm`) à une adresse IP. L'attribution automatique des adresses, c'est le DHCP.'''),
        QuestionEpreuve.qcm('4', 'Pour consulter un site de façon sécurisée (chiffrée), on utilise :',
            options: ['HTTPS', 'HTTP', 'FTP', 'SMTP'],
            bonne: 0,
            points: 1,
            chapitre: 'info_ch6',
            corrige: r'''HTTPS = HTTP + chiffrement TLS (cadenas dans le navigateur).'''),
        QuestionEpreuve.nombre('5', 'Combien de secondes faut-il pour télécharger un fichier de 50 Mo avec une connexion de 8 Mbit/s ?',
            valeur: 50, tolerance: 0.01, unite: 's', points: 1, chapitre: 'info_ch5',
            corrige: r'''$50\ \text{Mo} = 400\ \text{Mbit}$ ; $t = \dfrac{400}{8} = 50\ \text{s}$.'''),
        QuestionEpreuve.redaction('6', 'Donne la différence entre un réseau LAN et un réseau WAN, avec un exemple de chacun.',
            chapitre: 'info_ch5',
            bareme: [
              Critere('LAN : réseau local, zone géographique restreinte (salle, lycée)', 0.5),
              Critere('WAN : réseau étendu (ville, pays, Internet)', 0.5),
            ],
            corrige: r'''- **LAN** (réseau local) : couvre une zone restreinte, comme la salle informatique du lycée.
- **WAN** (réseau étendu) : relie des réseaux éloignés, à l'échelle d'un pays ou du monde ; **Internet** est le plus grand des WAN.'''),
      ],
    ),
  ],
);

const epreuveInfoC = Epreuve(
  id: 'bac_c_info_1',
  matiere: 'info_c',
  serie: 'C',
  titre: 'Informatique',
  dureeMinutes: 180,
  coefficient: 2,
  consignes: 'Les trois exercices sont indépendants. Le langage utilisé est Python.',
  exercices: [
    ExerciceEpreuve(
      titre: 'Algorithmique',
      enonce: r'''On considère la fonction Python suivante :

```python
def mystere(n):
    r = 0
    while n > 0:
        r = r + n % 10
        n = n // 10
    return r
```''',
      questions: [
        QuestionEpreuve.nombre('1', 'Que renvoie mystere(2026) ?',
            valeur: 10, tolerance: 0, points: 1.5, chapitre: 'info_c_ch1',
            corrige: r'''La fonction additionne les chiffres : $6 + 2 + 0 + 2 = 10$.'''),
        QuestionEpreuve.qcm('2', 'Que calcule cette fonction ?',
            options: ['la somme des chiffres de n', 'le nombre de chiffres de n', 'n à l\'envers', 'le reste de n par 10'],
            bonne: 0,
            points: 1,
            chapitre: 'info_c_ch1',
            corrige: r'''`n % 10` donne le dernier chiffre, `n // 10` le supprime : on cumule chaque chiffre.'''),
        QuestionEpreuve.nombre('3', 'Combien de tours de boucle sont effectués pour mystere(2026) ?',
            valeur: 4, tolerance: 0, points: 1, chapitre: 'info_c_ch1',
            corrige: r'''Un tour par chiffre : $2026 \to 202 \to 20 \to 2 \to 0$, soit **4** tours.'''),
        QuestionEpreuve.nombre('4', r"Convertis $(\text{FF})_{16}$ en base 10.",
            valeur: 255, tolerance: 0, points: 1, chapitre: 'info_c_ch1',
            corrige: r'''$15\times16 + 15 = 255$.'''),
        QuestionEpreuve.redaction('5', 'Écris une fonction `est_premier(n)` qui renvoie True si n (≥ 2) est premier.',
            chapitre: 'info_c_ch3',
            bareme: [
              Critere('Boucle sur les diviseurs possibles (jusqu\'à √n de préférence)', 0.75),
              Critere('Test du reste n % d == 0 et retour False', 0.75),
              Critere('Retour True à la fin', 0.5),
            ],
            corrige: r'''```python
def est_premier(n):
    d = 2
    while d * d <= n:
        if n % d == 0:
            return False
        d = d + 1
    return True
```
On s'arrête à $\sqrt n$ : si $n = a \times b$ avec $a \leq b$, alors $a \leq \sqrt n$.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Structures de données et bases de données',
      enonce: _tableEleves,
      questions: [
        QuestionEpreuve.qcm('1', 'Une pile fonctionne selon le principe :',
            options: ['dernier entré, premier sorti (LIFO)', 'premier entré, premier sorti (FIFO)', 'aléatoire', 'trié'],
            bonne: 0,
            points: 1,
            chapitre: 'info_c_ch2',
            corrige: r'''La pile (stack) est LIFO, comme une pile d'assiettes ; la file (queue) est FIFO.'''),
        QuestionEpreuve.nombre('2', "Combien de lignes renvoie : SELECT nom FROM Eleves WHERE moyenne < 10 ?",
            valeur: 2, tolerance: 0, points: 1, chapitre: 'info_c_ch4',
            corrige: r'''Ngo Bassa (9,5) et Eyenga (8,0) : **2** lignes.'''),
        QuestionEpreuve.nombre('3', "Que renvoie : SELECT MAX(moyenne) FROM Eleves WHERE serie = 'C' ?",
            valeur: 15, tolerance: 0.001, points: 1, chapitre: 'info_c_ch4',
            corrige: r'''Mballa : 15,0.'''),
        QuestionEpreuve.nombre('4', "Que renvoie : SELECT COUNT(*) FROM Eleves WHERE serie = 'D' AND moyenne >= 10 ?",
            valeur: 2, tolerance: 0, points: 1, chapitre: 'info_c_ch4',
            corrige: r'''Abena (13,5) et Tchoua (16,25) : **2**.'''),
        QuestionEpreuve.redaction('5', 'Écris la requête qui donne, pour chaque série, le nombre d\'élèves et la moyenne de la série.',
            chapitre: 'info_c_ch4',
            bareme: [
              Critere('SELECT serie, COUNT(*), AVG(moyenne)', 1.5),
              Critere('GROUP BY serie', 1.5),
            ],
            corrige: r'''```sql
SELECT serie, COUNT(*), AVG(moyenne)
FROM Eleves
GROUP BY serie;
```
Résultat : C → 2 élèves, 13 ; D → 4 élèves, 11,8125.'''),
      ],
    ),
    ExerciceEpreuve(
      titre: 'Réseaux',
      enonce: r'''Une entreprise de Douala utilise le réseau $10.0.0.0/8$ et un serveur web d'adresse $10.2.3.4$.''',
      questions: [
        QuestionEpreuve.qcm('1', 'Le masque correspondant à /8 est :',
            options: ['255.0.0.0', '255.255.0.0', '255.255.255.0', '255.255.255.255'],
            bonne: 0,
            points: 1,
            chapitre: 'info_c_ch5',
            corrige: r'''/8 : les 8 premiers bits à 1, soit **255.0.0.0**.'''),
        QuestionEpreuve.nombre('2', 'Combien d\'hôtes peut-on adresser dans ce réseau ?',
            valeur: 16777214, tolerance: 0, points: 1, chapitre: 'info_c_ch5',
            corrige: r'''24 bits pour les hôtes : $2^{24} - 2 = 16\,777\,214$.'''),
        QuestionEpreuve.qcm('3', 'Quel protocole attribue automatiquement les adresses IP aux postes ?',
            options: ['DHCP', 'DNS', 'HTTP', 'FTP'],
            bonne: 0,
            points: 1,
            chapitre: 'info_c_ch5',
            corrige: r'''Le **DHCP** distribue automatiquement adresse IP, masque, passerelle et DNS.'''),
        QuestionEpreuve.nombre('4', 'Combien de secondes pour envoyer 120 Mo à 16 Mbit/s ?',
            valeur: 60, tolerance: 0.01, unite: 's', points: 1, chapitre: 'info_c_ch5',
            corrige: r'''$120\ \text{Mo} = 960\ \text{Mbit}$ ; $t = \dfrac{960}{16} = 60\ \text{s}$.'''),
        QuestionEpreuve.redaction('5', 'Cite deux mesures pour protéger ce serveur contre les attaques.',
            chapitre: 'info_c_ch5',
            bareme: [
              Critere('Pare-feu / filtrage des ports', 1.25),
              Critere('Mises à jour, mots de passe forts, sauvegardes, HTTPS…', 1.25),
            ],
            corrige: r'''- Installer un **pare-feu** qui ne laisse passer que les ports utiles (80, 443).
- Tenir le système **à jour**, utiliser des **mots de passe forts**, chiffrer avec **HTTPS** et faire des **sauvegardes** régulières.'''),
      ],
    ),
  ],
);
