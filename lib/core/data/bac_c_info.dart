import 'lesson_content_model.dart';

final Map<String, LessonContent> bacCInfoContent = {
  // =========================================================================
  // Chapitre 1 — Fondements de la programmation
  // =========================================================================

  'info_c_ch1_l1': const LessonContent(
    introText:
        'L\'algorithmique est l\'art de résoudre un problème en décrivant une suite '
        'd\'étapes précises et ordonnées. C\'est la fondation de toute programmation : '
        'avant d\'écrire du code, il faut concevoir un algorithme clair et efficace.',
    lessonBody:
        'Un algorithme est une procédure finie, déterministe et effective qui, '
        'à partir de données d\'entrée, produit un résultat en un nombre fini d\'étapes. '
        'On le représente le plus souvent sous forme de texte en langage naturel structuré '
        'ou sous forme de diagramme de flux (organigramme).\n\n'
        'Les types de données fondamentaux sont : l\'entier (int), le réel (double), '
        'le booléen (true/false) et le caractère (char). Une variable est un espace '
        'mémoire identifié par un nom, qui stocke une valeur d\'un type donné. '
        'L\'affectation notée ← (flèche) ou = associe une valeur à une variable.\n\n'
        'Les structures de base d\'un algorithme sont : la séquence (exécution linéaire '
        'des instructions), la condition (branchement selon un critère) et la boucle '
        '(répétition d\'un bloc tant qu\'une condition est remplie). On distingue '
        'la boucle « tant que » (test avant) et la boucle « faire... tant que » (test après), '
        'ainsi que la boucle « pour » qui itère sur un compteur défini.\n\n'
        'L\'entrée/sortie permet de communiquer avec l\'utilisateur : lire une valeur au '
        'clavier, afficher un résultat à l\'écran. Les opérateurs arithmétiques (+, -, *, /, %), '
        'de comparaison (>, <, =, ≠) et logiques (ET, OU, NON) composent les expressions.\n\n'
        'La trace d\'algorithme est une technique de débogage consistant à suivre l\'exécution '
        'pas à pas en inscrivant les valeurs des variables dans un tableau. Elle permet de '
        'vérifier la cohérence du traitement et de détecter les erreurs logiques.',
    example:
        'Exemple — Calcul de la moyenne de trois notes :\n\n'
        'Algorithme : MoyenneTroisNotes\n'
        'Variables : n1, n2, n3 : réel ; moy : réel\n\n'
        'Début\n'
        '  Lire(n1)\n'
        '  Lire(n2)\n'
        '  Lire(n3)\n'
        '  moy ← (n1 + n2 + n3) / 3\n'
        '  Afficher("La moyenne est : ", moy)\n'
        'Fin\n\n'
        'Trace d\'exécution avec n1=12, n2=15, n3=9 :\n'
        '| Étape | Instruction     | n1  | n2  | n3  | moy   |\n'
        '| 1     | Lire(n1)        | 12  | ?   | ?   | ?     |\n'
        '| 2     | Lire(n2)        | 12  | 15  | ?   | ?     |\n'
        '| 3     | Lire(n3)        | 12  | 15  | 9   | ?     |\n'
        '| 4     | moy ← (12+15+9)/3 | 12 | 15 | 9   | 12,0  |\n'
        '| 5     | Afficher(moy)   | 12  | 15  | 9   | 12,0  |',
    takeaways: [
      'Un algorithme est fini, déterministe et effectif',
      'Les types fondamentaux sont entier, réel, booléen et caractère',
      'Les trois structures de base sont séquence, condition et boucle',
      'La trace d\'algorithme permet de déboguer en suivant pas à pas',
    ],
  ),

  'info_c_ch1_l2': const LessonContent(
    introText:
        'Les structures de contrôle permettent de diriger le flux d\'exécution d\'un '
        'programme. Elles donnent au programme la capacité de prendre des décisions '
        'et de répéter des opérations, ce qui est essentiel pour résoudre des problèmes complexes.',
    lessonBody:
        'La structure conditionnelle « si... alors... sinon » teste une expression booléenne. '
        'Si elle est vraie, le bloc « alors » s\'exécute ; sinon, le bloc « sinon » est exécuté. '
        'On peut imbriquer plusieurs conditions avec « si... sinon si... sinon ». '
        'Exemple : si note ≥ 16 alors « bien », sinon si note ≥ 10 alors « passable », '
        'sinon « insuffisant ».\n\n'
        'La boucle « tant que » (while) répète un bloc d\'instructions tant que la condition '
        'est vraie. La condition est testée avant chaque itération : si elle est fausse dès le '
        'départ, le bloc ne s\'exécute jamais. Il faut veiller à initialiser et à modifier '
        'la variable de contrôle pour éviter les boucles infinies.\n\n'
        'La boucle « faire... tant que » (do...while) est similaire mais le bloc s\'exécute '
        'au moins une fois car le test est effectué à la fin de l\'itération. Cette structure '
        'est utile lorsqu\'on veut garantir une exécution minimale.\n\n'
        'La boucle « pour » (for) est utilisée lorsqu\'on connaît le nombre d\'itérations à '
        'l\'avance. Elle comporte un compteur, une borne inférieure et une borne supérieure. '
        'À chaque itération, le compteur est incrémenté ou décrémenté automatiquement.\n\n'
        'Les structures d\'arrêt « sortir » (break) et « continuer » (continue) modifient le '
        'comportement d\'une boucle. « Sortir » interrompt immédiatement la boucle ; '
        '« continuer » passe directement à l\'itération suivante sans exécuter les instructions '
        'restantes du bloc.\n\n'
        'Le choix de la bonne structure dépend du problème : on utilise « tant que » quand la '
        'condition d\'arrêt n\'est pas connue à l\'avance, « pour » quand le nombre de passes '
        'est fixé, et « faire... tant que » quand on doit au moins lire une valeur.',
    example:
        'Exemple — Recherche dans un tableau non trié :\n\n'
        'Algorithme : Rechercher\n'
        'Variables : tab : tableau d\'entiers ; n : entier ;Trouve : booléen ; i : entier\n\n'
        'Début\n'
        '  Lire(n)\n'
        '  i ← 1\n'
        '  Trouve ← faux\n'
        '  Tant que (i ≤ longueur(tab)) ET (Trouve = faux) faire\n'
        '    Si tab[i] = n alors\n'
        '      Trouve ← vrai\n'
        '    Sinon\n'
        '      i ← i + 1\n'
        '  Fin tant que\n'
        '  Si Trouve = vrai alors\n'
        '    Afficher("Trouvé à la position ", i)\n'
        '  Sinon\n'
        '    Afficher("Non trouvé")\n'
        'Fin\n\n'
        'Trace avec tab = [5, 3, 8, 1, 7] et n = 8 :\n'
        'i=1 : tab[1]=5 ≠ 8 → i=2\n'
        'i=2 : tab[2]=3 ≠ 8 → i=3\n'
        'i=3 : tab[3]=8 = 8 → Trouve=vrai → arrêt\n'
        'Résultat : "Trouvé à la position 3"',
    takeaways: [
      'La structure conditionnelle si/sinon permet de prendre des décisions',
      'La boucle « tant que » teste la condition avant chaque itération',
      'La boucle « faire... tant que » garantit au moins une exécution',
      'La boucle « pour » est idéale quand le nombre d\'itérations est connu',
    ],
  ),

  'info_c_ch1_l3': const LessonContent(
    introText:
        'Les fonctions et procédures permettent de décomposer un programme en sous-programmes '
        'réutilisables. Elles améliorent la lisibilité, facilitent la maintenance et évitent '
        'la répétition de code.',
    lessonBody:
        'Une fonction est un sous-programme qui retourne une valeur. Elle est définie par un nom, '
        'une liste de paramètres (types et noms) et un type de retour. Lorsqu\'elle est appelée, '
        'on lui passe des arguments qui remplacent les paramètres formels. Le corps de la fonction '
        'contient les instructions qui calculent et retournent la valeur.\n\n'
        'Une procédure est similaire à une fonction mais ne retourne pas de valeur. Elle effectue '
        'une action (affichage, modification de variables, etc.) et peut modifier des variables '
        'passées en paramètre par passage par référence.\n\n'
        'Le passage de paramètres se fait de deux manières : par valeur (une copie est transmise, '
        'l\'original est intact) ou par référence (l\'adresse est transmise, la variable peut être '
        'modifiée). En algorithmique, on écrit « var » ou « réf » pour indiquer le passage '
        'par référence.\n\n'
        'La portée d\'une variable désigne la zone du programme où elle est accessible. Une variable '
        'locale n\'est visible que dans la fonction où elle est déclarée. Une variable globale est '
        'accessible depuis toutes les parties du programme. Il est recommandé de limiter l\'usage '
        'des variables globales pour éviter les effets de bord imprévus.\n\n'
        'La récursivité est une technique où une fonction s\'appelle elle-même. Chaque appel '
        'doit se rapprocher d\'un cas d\'arrêt (cas de base) pour éviter une récursion infinie. '
        'Les exemples classiques sont le calcul de la factorielle et la suite de Fibonacci. '
        'La récursivité est élégante mais peut être moins efficace qu\'une solution itérative '
        'en raison de la surcharge de la pile d\'exécution.',
    example:
        'Exemple — Factorielle (récursif et itératif) :\n\n'
        '--- Version récursive ---\n'
        'Fonction Factorielle(n : entier) : entier\n'
        'Début\n'
        '  Si n ≤ 1 alors\n'
        '    Retourner 1\n'
        '  Sinon\n'
        '    Retourner n × Factorielle(n - 1)\n'
        'Fin\n\n'
        'Trace avec n = 5 :\n'
        'Factorielle(5) = 5 × Factorielle(4)\n'
        'Factorielle(4) = 4 × Factorielle(3)\n'
        'Factorielle(3) = 3 × Factorielle(2)\n'
        'Factorielle(2) = 2 × Factorielle(1)\n'
        'Factorielle(1) = 1  ← cas de base\n'
        'Résultat : 5×4×3×2×1 = 120\n\n'
        '--- Version itérative ---\n'
        'Fonction FactorielleIt(n : entier) : entier\n'
        'Variables : res : entier ; i : entier\n'
        'Début\n'
        '  res ← 1\n'
        '  Pour i de 2 à n faire\n'
        '    res ← res × i\n'
        '  Fin pour\n'
        '  Retourner res\n'
        'Fin',
    takeaways: [
      'Une fonction retourne une valeur, une procédure effectue une action',
      'Le passage par valeur préserve l\'original, le passage par référence le modifie',
      'Les variables locales sont limitées à leur portée, les globales sont accessibles partout',
      'La récursivité nécessite un cas d\'arrêt pour chaque appel',
    ],
  ),

  // =========================================================================
  // Chapitre 2 — Structures de données
  // =========================================================================

  'info_c_ch2_l1': const LessonContent(
    introText:
        'Un tableau est une structure de données qui stocke une collection d\'éléments '
        'de même type, accessibles par un indice. C\'est l\'un des outils les plus '
        'fondamentaux pour manipuler et traiter des données en programmation.',
    lessonBody:
        'Un tableau est un ensemble de variables de même type, regroupées sous un nom unique. '
        'Chaque élément est identifié par un indice (ou index) qui commence généralement à 0 ou 1 '
        'selon le langage. La taille d\'un tableau est fixée à la déclaration (tableau statique) '
        'ou peut évoluer (tableau dynamique ou liste).\n\n'
        'La déclaration d\'un tableau précise le type des éléments et la taille. '
        'Exemple : « T : tableau[1..100] d\'entiers » définit un tableau de 100 entiers '
        'dont les indices vont de 1 à 100. L\'accès à un élément se fait par son indice : '
        'T[i] désigne le iᵉᵐᵉ élément.\n\n'
        'Les opérations courantes sur les tableaux sont : l\'initialisation (remplissage), '
        'la recherche d\'un élément (linéaire ou dichotomique), le tri (sélection, insertion, '
        'bulle), l\'insertion, la suppression et l\'affichage.\n\n'
        'La recherche linéaire parcourt le tableau élément par élément jusqu\'à trouver la cible '
        'ou atteindre la fin. Sa complexité est O(n). La recherche dichotomique, applicable '
        'uniquement sur un tableau trié, divise l\'intervalle de recherche par deux à chaque étape. '
        'Sa complexité est O(log₂(n)), ce qui la rend beaucoup plus rapide pour les grands tableaux.\n\n'
        'Un tableau à deux dimensions (matrice) est un tableau de tableaux. Il est utilisé '
        'pour représenter des grilles, des cartes ou des tableaux de données à deux entrées. '
        'L\'accès se fait par deux indices : M[ligne][colonne].\n\n'
        'Les limites des tableaux statiques sont : la taille fixe à la déclaration et '
        'l\'impossibilité d\'insérer ou supprimer un élément sans décaler les suivants.',
    example:
        'Exemple — Recherche dichotomique dans un tableau trié :\n\n'
        'Algorithme : RechercheDicho\n'
        'Variables : T : tableau trié d\'entiers ; cible : entier ;\n'
        '           debut, fin, milieu : entier ; trouvé : booléen\n\n'
        'Début\n'
        '  debut ← 1\n'
        '  fin ← longueur(T)\n'
        '  trouvé ← faux\n'
        '  Tant que (debut ≤ fin) ET (trouvé = faux) faire\n'
        '    milieu ← (debut + fin) div 2\n'
        '    Si T[milieu] = cible alors\n'
        '      trouvé ← vrai\n'
        '    Sinon si T[milieu] < cible alors\n'
        '      debut ← milieu + 1\n'
        '    Sinon\n'
        '      fin ← milieu - 1\n'
        '  Fin tant que\n'
        '  Si trouvé alors\n'
        '    Afficher("Trouvé à l\'indice ", milieu)\n'
        '  Sinon\n'
        '    Afficher("Non trouvé")\n'
        'Fin\n\n'
        'Exécution avec T = [2, 5, 8, 12, 16, 23, 38, 45] et cible = 23 :\n'
        'Tour 1 : debut=1, fin=8, milieu=4, T[4]=12 < 23 → debut=5\n'
        'Tour 2 : debut=5, fin=8, milieu=6, T[6]=23 = 23 → trouvé\n'
        'Résultat : "Trouvé à l\'indice 6"',
    takeaways: [
      'Un tableau stocke des éléments de même type accessibles par un indice',
      'La recherche linéaire est O(n), la recherche dichotomique est O(log₂(n))',
      'La dichotomie nécessite un tableau préalablement trié',
      'Un tableau à deux dimensions est un tableau de tableaux (matrice)',
    ],
  ),

  'info_c_ch2_l2': const LessonContent(
    introText:
        'Les chaînes de caractères sont des séquences de symboles utilisées pour '
        'représenter du texte. En informatique, elles occupent une place fondamentale '
        'car la plupart des interactions avec l\'utilisateur passent par du texte.',
    lessonBody:
        'Une chaîne de caractères (string) est une suite ordonnée de caractères. '
        'En mémoire, chaque caractère est codé sur un octet (code ASCII) ou plus '
        '(Unicode). Le code ASCII associe à chaque caractère un nombre entier : '
        'A=65, a=97, 0=48. La comparaison de chaînes se fait caractère par caractère '
        'selon leur code ASCII.\n\n'
        'Les opérations courantes sur les chaînes sont : la longueur (nombre de caractères), '
        'la concaténation (jonction de deux chaînes), l\'extraction d\'une sous-chaîne '
        '(slicing), la recherche d\'un caractère ou d\'une sous-chaîne, le remplacement '
        'et la transformation (majuscules, minuscules).\n\n'
        'L\'extraction de sous-chaîne (substring) prend trois paramètres : la position de '
        'début, la position de fin et la chaîne source. Exemple : « SousChaîne("Bonjour", 2, 5) » '
        'retourne "onjo".\n\n'
        'La recherche d\'un caractère dans une chaîne retourne sa position ou -1 s\'il n\'est pas '
        'présent. La recherche de sous-chaîne est plus complexe : l\'algorithme naïf compare '
        'la sous-chaîne à chaque position possible (complexité O(n×m)). L\'algorithme de Knuth-Morris-Pratt '
        '(KMP) est plus efficace car il exploite les informations acquises lors des comparaisons '
        'précédentes pour éviter des comparaisons inutiles.\n\n'
        'Les chaînes sont immuables dans de nombreux langages : toute modification crée une '
        'nouvelle chaîne en mémoire. Pour des manipulations fréquentes, on utilise parfois '
        'des tableaux de caractères ou des buffers.',
    example:
        'Exemple — Vérification d\'un palindrome :\n\n'
        'Algorithme : EstPalindrome\n'
        'Variables : ch : chaîne ; i, j : entier ; ok : booléen\n\n'
        'Début\n'
        '  i ← 1\n'
        '  j ← Longueur(ch)\n'
        '  ok ← vrai\n'
        '  Tant que (i < j) ET (ok = vrai) faire\n'
        '    Si ch[i] ≠ ch[j] alors\n'
        '      ok ← faux\n'
        '    Sinon\n'
        '      i ← i + 1\n'
        '      j ← j - 1\n'
        '  Fin tant que\n'
        '  Si ok alors\n'
        '    Afficher(ch, " est un palindrome")\n'
        '  Sinon\n'
        '    Afficher(ch, " n\'est pas un palindrome")\n'
        'Fin\n\n'
        'Trace avec ch = "RADAR" :\n'
        'Tour 1 : i=1, j=5, ch[1]=R, ch[5]=R → OK, i=2, j=4\n'
        'Tour 2 : i=2, j=4, ch[2]=A, ch[4]=A → OK, i=3, j=3\n'
        'i=j → arrêt → ok=vrai\n'
        'Résultat : "RADAR est un palindrome"\n\n'
        'Trace avec ch = "HELLO" :\n'
        'Tour 1 : i=1, j=5, ch[1]=H, ch[5]=O → ok= faux → arrêt\n'
        'Résultat : "HELLO n\'est pas un palindrome"',
    takeaways: [
      'Une chaîne est une séquence de caractères codés en ASCII ou Unicode',
      'La concaténation joint deux chaînes, la sous-chaîne extrait une partie',
      'La comparaison de chaînes se fait caractère par caractère selon leur code',
      'L\'algorithme naïf de recherche est O(n×m), KMP est plus efficace',
    ],
  ),

  // =========================================================================
  // Chapitre 3 — Manipulation de fichiers
  // =========================================================================

  'info_c_ch3_l1': const LessonContent(
    introText:
        'Les fichiers séquentiels permettent de stocker et retrouver des données '
        'de manière persistante. L\'accès aux données se fait de façon linéaire, '
        'du début à la fin du fichier, ce qui convient au traitement de données organisées.',
    lessonBody:
        'Un fichier séquentiel (ou fichier à accès séquentiel) est un ensemble d\'enregistrements '
        'stockés les uns à la suite des autres. Pour accéder à un enregistrement spécifique, '
        'il faut parcourir tous les enregistrements précédents. C\'est comme lire un livre '
        'page par page : on ne peut pas accéder directement à une page sans passer par les précédentes.\n\n'
        'Un enregistrement est composé de plusieurs champs (attributs). Par exemple, un '
        'enregistrement d\'élève peut contenir : nom (chaîne), âge (entier), moyenne (réel). '
        'Un fichier est manipulé par des opérations standard : ouvrir (en lecture ou écriture), '
        'lire l\'enregistrement suivant, écrire un enregistrement, fermer le fichier.\n\n'
        'La taille d\'un fichier séquentiel dépend du nombre d\'enregistrements. Pour retrouver '
        'une donnée, on effectue une recherche séquentielle : on lit chaque enregistrement '
        'jusqu\'à trouver celui qui correspond au critère. Cette recherche est de complexité O(n).\n\n'
        'Les avantages des fichiers séquentiels sont leur simplicité de mise en œuvre et leur '
        'faible coût en espace disque. Les inconvénients sont : l\'accès lent à un enregistrement '
        'arbitraire, la nécessité de réécrire tout le fichier pour effectuer une modification, '
        'et l\'impossibilité de modifier un enregistrement sans réécrire les suivants.\n\n'
        'L\'insertion dans un fichier séquentiel nécessite de décaler tous les enregistrements '
        'suivants. La suppression est similaire : on décale vers la gauche. Ces opérations sont '
        'coûteuses en temps pour de grands fichiers.',
    example:
        'Exemple — Recherche dans un fichier d\'élèves :\n\n'
        'Algorithme : RechercherEleve\n'
        'Variables : nomRecherche : chaîne ; nom : chaîne ; age : entier ;\n'
        '           moyenne : réel ; trouvé : booléen\n\n'
        'Début\n'
        '  Ouvrir(F, "eleves.txt", lecture)\n'
        '  Lire(nomRecherche)\n'
        '  trouvé ← faux\n'
        '  Tant que (non fin(F)) ET (trouvé = faux) faire\n'
        '    Lire(F, nom)\n'
        '    Lire(F, age)\n'
        '    Lire(F, moyenne)\n'
        '    Si nom = nomRecherche alors\n'
        '      trouvé ← vrai\n'
        '  Fin tant que\n'
        '  Si trouvé alors\n'
        '    Afficher("Nom : ", nom)\n'
        '    Afficher("Âge : ", age)\n'
        '    Afficher("Moyenne : ", moyenne)\n'
        '  Sinon\n'
        '    Afficher("Élève non trouvé")\n'
        '  Fermer(F)\n'
        'Fin\n\n'
        'Fichier eleves.txt :\n'
        'Diallo, 17, 14.5\n'
        'Touré, 16, 12.0\n'
        'Konaté, 18, 15.75\n'
        'Camara, 17, 11.25\n\n'
        'Recherche de "Konaté" → accès en 3 lectures.',
    takeaways: [
      'Un fichier séquentiel stocke les enregistrements les uns à la suite des autres',
      'L\'accès est linéaire : il faut parcourir du début jusqu\'à l\'enregistrement visé',
      'La recherche est de complexité O(n) dans le cas général',
      'Les insertions et suppressions nécessitent le décalage des enregistrements suivants',
    ],
  ),

  'info_c_ch3_l2': const LessonContent(
    introText:
        'Les fichiers directs (ou fichiers à accès direct) permettent d\'accéder '
        'immédiatement à n\'importe quel enregistrement sans lire les précédents. '
        'C\'est le principe des bases de données modernes et des systèmes de fichiers.',
    lessonBody:
        'Un fichier à accès direct (fichier indexé ou fichier à accès aléatoire) permet de localiser '
        'un enregistrement de manière immédiate grâce à un index ou une clé. Contrairement au fichier '
        'séquentiel, on ne lit pas les enregistrements précédents pour atteindre celui désiré.\n\n'
        'Le principe repose sur un calcul qui transforme la clé de recherche en une adresse disque. '
        'Le fichier est divisé en blocs de taille fixe, et chaque bloc contient un ou plusieurs '
        'enregistrements. Un index (table de correspondance) associe chaque clé à l\'adresse du bloc '
        'qui contient l\'enregistrement.\n\n'
        'Le hachage (hashage) est une technique courante : une fonction de hachage transforme la clé '
        'en un numéro de bloc. Cette fonction doit être déterministe et répartir uniformément les '
        'enregistrements. Les collisions (deux clés ayant le même hash) sont gérées par chaînage '
        'ou par adressage ouvert.\n\n'
        'Les opérations sur un fichier direct sont : ouvrir, accéder à un enregistrement par sa clé, '
        'lire, modifier, insérer et supprimer. L\'insertion est plus simple que dans un fichier '
        'séquentiel : on écrit simplement dans un bloc libre. La suppression est également plus '
        'facile.\n\n'
        'Les avantages des fichiers directs sont : l\'accès rapide O(1) en moyenne, la facilité '
        'de modification et de suppression. Les inconvénients sont : l\'espace supplémentaire '
        'pour l\'index, la complexité de gestion des collisions et la nécessité d\'un espace '
        'disque plus important pour éviter la fragmentation.',
    example:
        'Exemple — Fichier d\'élèves avec index par numéro :\n\n'
        'Algorithme : AccederParNumero\n'
        'Variables : numero : entier ; nom : chaîne ; moyenne : réel\n\n'
        'Début\n'
        '  Lire(numero)\n'
        '  Adr ← FonctionHachage(numero)\n'
        '  Accéder(F, Adr)\n'
        '  Lire(F, nom)\n'
        '  Lire(F, moyenne)\n'
        '  Afficher("Nom : ", nom, " | Moyenne : ", moyenne)\n'
        'Fin\n\n'
        'Fichier avec hachage modulo 5 :\n'
        'Bloc 0 : élève n°10 (10 mod 5 = 0)\n'
        'Bloc 1 : élève n°6 (6 mod 5 = 1)\n'
        'Bloc 2 : élève n°2 (2 mod 5 = 2), élève n°7 (7 mod 5 = 2)\n'
        'Bloc 3 : élève n°3 (3 mod 5 = 3)\n'
        'Bloc 4 : élève n°9 (9 mod 5 = 4)\n\n'
        'Recherche de l\'élève n°7 :\n'
        'FonctionHachage(7) = 7 mod 5 = 2 → Bloc 2\n'
        '→ Lecture directe du Bloc 2 → élève trouvé en 1 accès\n\n'
        'Comparaison avec séquentiel : il faudrait lire les 5 premiers enregistrements.',
    takeaways: [
      'Un fichier à accès direct localise un enregistrement par un calcul sur sa clé',
      'La fonction de hachage transforme la clé en adresse de bloc',
      'L\'accès est en O(1) en moyenne grâce au hachage',
      'Les collisions sont gérées par chaînage ou adressage ouvert',
    ],
  ),

  // =========================================================================
  // Chapitre 4 — Algorithmes de tri
  // =========================================================================

  'info_c_ch4_l1': const LessonContent(
    introText:
        'Le tri par sélection est l\'un des algorithmes de tri les plus simples à comprendre '
        'et à implémenter. Il fonctionne en trouvant successivement le plus petit élément '
        'restant et en le plaçant à sa position finale.',
    lessonBody:
        'Le tri par sélection (selection sort) repose sur le principe suivant : à chaque étape, '
        'on cherche l\'élément minimum dans la partie non triée du tableau et on l\'échange '
        'avec le premier élément de cette partie. La partie triée croît d\'un élément à chaque itération.\n\n'
        'L\'algorithme procède en n-1 tours. Au tour i, on parcourt les éléments d\'indice i à n '
        'pour trouver le minimum, puis on échange cet minimum avec l\'élément d\'indice i. '
        'Après n-1 tours, le tableau est entièrement trié.\n\n'
        'La complexité en temps est toujours O(n²), que le tableau soit déjà trié, inversé '
        'ou dans un ordre aléatoire. C\'est parce que les comparaisons sont toujours les mêmes : '
        'on parcourt toujours toute la partie non triée. L\'espace mémoire supplémentaire est O(1) : '
        'le tri est en place (in-place).\n\n'
        'Le tri par sélection est un tri stable si on utilise une technique d\'échange prudente. '
        'Cependant, dans sa version classique avec échange direct, il n\'est pas stable car '
        'l\'échange peut intervertir l\'ordre d\'éléments égaux.\n\n'
        'Les avantages sont sa simplicité d\'implémentation et son faible coût en déplacements '
        '(au plus n-1 échanges). Les inconvénients sont sa lenteur sur de grands tableaux '
        'et le fait qu\'il ne soit pas adaptatif (il ne tire pas profit d\'un tableau partiellement trié).',
    example:
        'Exemple — Tri par sélection sur [64, 25, 12, 22, 11] :\n\n'
        'Tour 1 (i=1) : minimum dans [64,25,12,22,11] est 11\n'
        'Échange 11 et 64 → [11, 25, 12, 22, 64]\n'
        'Trié : [11]\n\n'
        'Tour 2 (i=2) : minimum dans [25,12,22,64] est 12\n'
        'Échange 12 et 25 → [11, 12, 25, 22, 64]\n'
        'Trié : [11, 12]\n\n'
        'Tour 3 (i=3) : minimum dans [25,22,64] est 22\n'
        'Échange 22 et 25 → [11, 12, 22, 25, 64]\n'
        'Trié : [11, 12, 22]\n\n'
        'Tour 4 (i=4) : minimum dans [25,64] est 25\n'
        '25 est déjà en place → pas d\'échange\n'
        'Trié : [11, 12, 22, 25, 64]\n\n'
        'Nombre total de comparaisons : 4 + 3 + 2 + 1 = 10 = n(n-1)/2\n'
        'Nombre total d\'échanges : 3 (maximum n-1)',
    takeaways: [
      'Le tri par sélection place le minimum restant à chaque tour',
      'Complexité temporelle : toujours O(n²), qu\'en quel ordre initial',
      'Espace supplémentaire : O(1) (tri en place)',
      'Au plus n-1 échanges, ce qui est minimal parmi les tris en O(n²)',
    ],
  ),

  'info_c_ch4_l2': const LessonContent(
    introText:
        'Le tri par insertion est inspiré de la manière dont on trie naturellement '
        'des cartes dans sa main. Il construit progressivement un sous-tableau trié '
        'en insérant chaque élément à sa bonne position.',
    lessonBody:
        'Le tri par insertion (insertion sort) fonctionne en maintenant une partie '
        'triée du tableau (à gauche) et en insérant successivement chaque élément non trié '
        '(à droite) à sa position correcte dans la partie triée.\n\n'
        'L\'algorithme commence au deuxième élément (indice 1). Pour chaque élément, on le compare '
        'avec les éléments précédents de la partie triée et on décale vers la droite ceux qui '
        'sont plus grands, jusqu\'à trouver la bonne position pour l\'insérer.\n\n'
        'La complexité en temps dépend de l\'ordre initial : meilleur cas O(n) si le tableau '
        'est déjà trié (chaque élément est comparé une seule fois), pire cas O(n²) si le tableau '
        'est trié en ordre inverse (chaque élément doit être décalé jusqu\'au début). En moyenne, '
        'la complexité est O(n²). L\'espace supplémentaire est O(1).\n\n'
        'Le tri par insertion est un tri stable : les éléments de même valeur conservent leur '
        'ordre initial. C\'est un avantage important dans certaines applications.\n\n'
        'Ce tri est particulièrement efficace pour de petits tableaux (n < 20) ou pour des '
        'tableaux presque triés. C\'est pourquoi il est souvent utilisé comme sous-algorithme '
        'dans des tris plus complexes comme le tri rapide (quicksort) pour les sous-tableaux '
        'de petite taille.\n\n'
        'L\'avantage principal du tri par insertion est son adaptativité : sa performance s\'améliore '
        'avec le degré de tri initial du tableau.',
    example:
        'Exemple — Tri par insertion sur [5, 2, 4, 6, 1, 3] :\n\n'
        'État initial : [5, 2, 4, 6, 1, 3]\n\n'
        'Passage 1 (insérer 2) :\n'
        'Comparer 2 avec 5 → décaler 5 vers la droite\n'
        'Insérer 2 en position 0\n'
        '→ [2, 5, 4, 6, 1, 3]\n\n'
        'Passage 2 (insérer 4) :\n'
        'Comparer 4 avec 5 → décaler 5\n'
        'Comparer 4 avec 2 → 2 < 4, arrêt\n'
        'Insérer 4 en position 1\n'
        '→ [2, 4, 5, 6, 1, 3]\n\n'
        'Passage 3 (insérer 6) :\n'
        'Comparer 6 avec 5 → 5 < 6, arrêt\n'
        '6 reste en place\n'
        '→ [2, 4, 5, 6, 1, 3]\n\n'
        'Passage 4 (insérer 1) :\n'
        'Décaler 6, 5, 4, 2 vers la droite\n'
        'Insérer 1 en position 0\n'
        '→ [1, 2, 4, 5, 6, 3]\n\n'
        'Passage 5 (insérer 3) :\n'
        'Décaler 6, 5, 4 vers la droite\n'
        'Comparer 3 avec 2 → 2 < 3, arrêt\n'
        '→ [1, 2, 3, 4, 5, 6]',
    takeaways: [
      'Le tri par insertion construit un sous-tableau trié élément par élément',
      'Meilleur cas O(n) (déjà trié), pire cas O(n²) (ordre inverse)',
      'C\'est un tri stable et adaptatif',
      'Particulièrement efficace pour les petits tableaux ou les tableaux presque triés',
    ],
  ),

  // =========================================================================
  // Chapitre 5 — Bases de données
  // =========================================================================

  'info_c_ch5_l1': const LessonContent(
    introText:
        'Les bases de données sont des ensembles structurés de données permettant '
        'de stocker, organiser et manipuler de grandes quantités d\'informations de manière '
        'efficace et sécurisée. Elles sont au cœur de la plupart des applications informatiques.',
    lessonBody:
        'Une base de données (BD) est un ensemble de données structurées, partagées et '
        'permanentes, gérées par un Système de Gestion de Base de Données (SGBD). '
        'Le modèle relationnel, proposé par Edgar F. Codd en 1970, organise les données '
        'en tables (relations) composées de lignes (tuples/enregistrements) et de colonnes '
        '(attributs/champs).\n\n'
        'Une table relationnelle est identifiée par un nom et possède un schéma définissant '
        'les noms et types de ses colonnes. La clé primaire (primary key) identifie de manière '
        'unique chaque enregistrement. Elle ne peut pas être nulle et doit être unique. '
        'Une clé étrangère (foreign key) est une colonne qui fait référence à la clé primaire '
        'd\'une autre table, établissant une relation entre les deux.\n\n'
        'Les relations entre tables sont de trois types : un-à-un (1:1), un-à-plusieurs (1:N) '
        'et plusieurs-à-plusieurs (N:P). La relation N:P est implémentée par une table de '
        'jonction (table associative) contenant les clés étrangères des deux tables liées.\n\n'
        'L\'intégrité référentielle garantit qu\'une clé étrangère pointe toujours vers un '
        'enregistrement existant dans la table référencée. L\'intégrité d\'entité impose que '
        'la clé primaire soit unique et non nulle. L\'intégrité de domaine restreint les valeurs '
        'possibles d\'une colonne à un ensemble défini.\n\n'
        'Le modèle entité-association (MCD) permet de concevoir une base de données avant son '
        'implémentation. Il identifie les entités (objets), leurs attributs et les relations '
        'entre elles avec les cardinalités (1, N, P).',
    example:
        'Exemple — Modèle relationnel d\'une application scolaire :\n\n'
        'Table ELEVES :\n'
        '| matricule (PK) | nom       | prenom   | date_naiss  |\n'
        '| E001           | Diallo    | Amadou   | 15/03/2005  |\n'
        '| E002           | Touré     | Fatoumata| 22/07/2004  |\n'
        '| E003           | Konaté    | Ibrahima | 10/11/2005  |\n\n'
        'Table MATIERES :\n'
        '| code (PK) | libelle     | coeff |\n'
        '| INFO01    | Algorithmique| 3    |\n'
        '| MATH01    | Mathématiques| 4    |\n'
        '| FRAN01    | Français     | 2    |\n\n'
        'Table NOTES (table de jonction N:P) :\n'
        '| matricule (FK) | code (FK) | note |\n'
        '| E001           | INFO01    | 15   |\n'
        '| E001           | MATH01    | 12   |\n'
        '| E002           | INFO01    | 18   |\n'
        '| E003           | MATH01    | 14   |\n\n'
        'Clé primaire composite : (matricule, code)\n'
        'Relation : ELEVES 1:N NOTES N:1 MATIERES',
    takeaways: [
      'Une base de données est un ensemble de données structurées géré par un SGBD',
      'Le modèle organisation en tables avec clés primaires et étrangères',
      'Les cardinalités 1:1, 1:N et N:P définissent les relations entre tables',
      'Le MCD (modèle entité-association) permet de concevoir la structure avant l\'implémentation',
    ],
  ),

  'info_c_ch5_l2': const LessonContent(
    introText:
        'SQL (Structured Query Language) est le langage standard pour interroger et '
        'manipuler les bases de données relationnelles. Il permet de créer, lire, modifier '
        'et supprimer des données de manière déclarative et puissante.',
    lessonBody:
        'SQL se divise en sous-langages : le DDL (Data Definition Language) pour créer et modifier '
        'le schéma, le DML (Data Manipulation Language) pour manipuler les données, et le DCL '
        '(Data Control Language) pour gérer les droits d\'accès.\n\n'
        'Les instructions DDL principales sont : CREATE TABLE (créer une table), ALTER TABLE '
        '(modifier la structure), DROP TABLE (supprimer une table). CREATE TABLE définit le nom, '
        'les colonnes et leurs types (INTEGER, VARCHAR, DATE, FLOAT, BOOLEAN).\n\n'
        'Les instructions DML sont : SELECT (lire), INSERT INTO (insérer), UPDATE (modifier), '
        'DELETE (supprimer). La requête SELECT est la plus utilisée. Sa syntaxe de base est :\n'
        'SELECT colonnes FROM table WHERE condition ORDER BY colonne.\n\n'
        'Les clauses WHERE acceptent des opérateurs de comparaison (=, <>, <, >, ≤, ≥), '
        'des opérateurs logiques (AND, OR, NOT), IN (appartenance à une liste), LIKE '
        '(correspondance de motif avec % et _), BETWEEN (plage de valeurs) et IS NULL.\n\n'
        'Les fonctions d\'agrégation calculent des statistiques sur un ensemble de lignes : '
        'COUNT (nombre), SUM (somme), AVG (moyenne), MIN (minimum), MAX (maximum). '
        'La clause GROUP BY regroupe les lignes ayant la même valeur pour les colonnes spécifiées, '
        'et HAVING filtre les groupes (comme WHERE mais pour les agrégats).\n\n'
        'Les jointures combinent les données de plusieurs tables. La jointure interne (INNER JOIN) '
        'retourne les lignes ayant une correspondance dans les deux tables. La jointure externe '
        'gauche (LEFT JOIN) retourne toutes les lignes de la table gauche même sans correspondance.',
    example:
        'Exemple — Requêtes SQL sur la base scolaire :\n\n'
        '-- Création de la table ELEVES\n'
        'CREATE TABLE ELEVES (\n'
        '  matricule VARCHAR(10) PRIMARY KEY,\n'
        '  nom VARCHAR(50) NOT NULL,\n'
        '  prenom VARCHAR(50),\n'
        '  moyenne FLOAT DEFAULT 0\n'
        ');\n\n'
        '-- Insertion de données\n'
        'INSERT INTO ELEVES VALUES (\'E001\', \'Diallo\', \'Amadou\', 14.5);\n'
        'INSERT INTO ELEVES VALUES (\'E002\', \'Touré\', \'Fatoumata\', 16.0);\n\n'
        '-- Sélection avec condition\n'
        'SELECT nom, prenom FROM ELEVES WHERE moyenne ≥ 14;\n'
        '→ Diallo Amadou, Touré Fatoumata\n\n'
        '-- Moyenne par matière avec jointure\n'
        'SELECT m.libelle, AVG(n.note) AS moyenne_classe\n'
        'FROM NOTES n\n'
        'INNER JOIN MATIERES m ON n.code = m.code\n'
        'GROUP BY m.libelle\n'
        'HAVING AVG(n.note) ≥ 12;\n\n'
        '-- Mise à jour\n'
        'UPDATE ELEVES SET moyenne = 15.2 WHERE matricule = \'E001\';\n\n'
        '-- Suppression\n'
        'DELETE FROM ELEVES WHERE matricule = \'E003\';',
    takeaways: [
      'SQL est le langage standard pour les bases de données relationnelles',
      'SELECT, INSERT, UPDATE, DELETE sont les opérations CRUD de base',
      'Les fonctions d\'agrégation (COUNT, SUM, AVG) calculent des statistiques',
      'Les jointures (INNER, LEFT) combinent les données de plusieurs tables',
    ],
  ),
};
