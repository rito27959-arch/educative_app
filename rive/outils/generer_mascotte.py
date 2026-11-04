"""Kunfox, la mascotte officielle : renardeau en toque de diplômé.

Dessin original de Kunfox (même tête que l'icône), décliné en personnage
complet : oreilles, sourcils, regard, bouches, joues, bras, queue et toque
sont des pièces séparées qui pivotent chacune autour de leur articulation.

Machine à états « Kunfox », entrée nombre `humeur` :
    0 attente   1 joie   2 courage (après une erreur)   3 réflexion
    4 fête      5 salut  6 dodo
Une seconde couche fait cligner les yeux en permanence.

    python3 rive/outils/generer_mascotte.py                 → rive/kunfox_mascotte/scene.rml
    python3 rive/outils/generer_mascotte.py --apercus       → + rive/apercus/mascotte_<humeur>/
    python3 rive/outils/generer_mascotte.py --svg <dossier> → images SVG pour vérifier sans la CLI
"""
import math, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from kunrive import *

NUIT, ORANGE, ORANGE_C, ORANGE_F, BRUN = '14213D', 'FF6B2B', 'FF8A45', 'E04E14', 'B8400F'
CREME, OR, ROSE, LANGUE, BLANC = 'FFF4E8', 'FFC24B', 'FF8FA3', 'FF6F86', 'FFFFFF'
CONFETTIS = ['FFC24B', '4CC9F0', 'FF8FA3', '7BE07B', 'FFF4E8', 'FF6B2B']

def miroir(d):
    """Symétrique gauche ↔ droite d'un chemin (axe x = 512)."""
    out = []; jet = re.findall(r'[MLQCZ]|-?\d+(?:\.\d+)?', d); est_x = True
    for j in jet:
        if j in 'MLQCZ': out.append(j); est_x = True; continue
        v = float(j)
        out.append(f'{1024 - v:g}' if est_x else f'{v:g}'); est_x = not est_x
    return ' '.join(out)

# --------------------------------------------------------------- les pièces
orange_tete = Degrade([(0, ORANGE_C), (1, ORANGE)], (512, 380), (512, 760))
orange_corps = Degrade([(0, ORANGE), (1, 'F2561A')], (512, 780), (512, 1080))

def oreille(cote):
    ext = 'M206 488 Q214 300 300 206 Q348 318 426 404 Z'
    intr = 'M258 430 Q264 330 302 268 Q330 344 384 400 Z'
    piv = (318, 440)
    if cote == 'd': ext, intr, piv = miroir(ext), miroir(intr), (1024 - piv[0], piv[1])
    enfants = [F('Interieur', intr, remplissage=ORANGE_F), F('Oreille', ext, remplissage=ORANGE_C)]
    return G(f'Oreille {cote.upper()}', piv, enfants)

def toque():
    c = (702, 246)
    def t(d):  # dessin local (centre du plateau = 0,0) → absolu
        jet = re.findall(r'[MLQCZ]|-?\d+(?:\.\d+)?', d); out = []; est_x = True
        for j in jet:
            if j in 'MLQCZ': out.append(j); est_x = True; continue
            out.append(f'{float(j) + (c[0] if est_x else c[1]):g}'); est_x = not est_x
        return ' '.join(out)
    return G('Toque', c, [
        E('Pompon', (c[0] + 102, c[1] + 58), 30, 30, remplissage=OR),
        F('Cordon', t('M0 -2 L102 28 L102 52'), trait=OR, epaisseur=10),
        F('Plateau', t('M-132 -2 L0 -62 L132 -2 L0 58 Z'), remplissage=NUIT),
        F('Reflet plateau', t('M-96 -6 L0 -48 L40 -30 L-56 12 Z'), remplissage='26365C'),
        F('Calotte', t('M-72 30 L-72 78 Q0 112 72 78 L72 30 L0 62 Z'), remplissage='0C1630'),
    ], rotation=0.24)

def oeil(cote):
    cx = 404 if cote == 'g' else 620
    return G(f'Oeil {cote.upper()}', (cx, 528), [
        E('Reflet petit', (cx - 14, 552), 12, 12, remplissage=BLANC),
        E('Reflet', (cx + 12, 510), 26, 26, remplissage=BLANC),
        E('Iris', (cx, 528), 70, 82, remplissage=NUIT),
    ])

def oeil_heureux(cote):
    cx = 404 if cote == 'g' else 620
    return F(f'Heureux {cote.upper()}', f'M{cx - 36} 546 Q{cx} 496 {cx + 36} 546', trait=NUIT, epaisseur=20)

def oeil_ferme(cote):
    cx = 404 if cote == 'g' else 620
    return F(f'Ferme {cote.upper()}', f'M{cx - 34} 530 Q{cx} 562 {cx + 34} 530', trait=NUIT, epaisseur=16)

def sourcil(cote):
    d = 'M370 456 Q404 438 440 450'
    piv = (404, 450)
    if cote == 'd': d, piv = miroir(d), (620, 450)
    return G(f'Sourcil {cote.upper()}', piv, [F('Trait', d, trait=BRUN, epaisseur=14)])

def bras(cote):
    d = 'M344 856 Q326 930 340 984 Q372 1012 404 984 Q414 930 400 856 Z'
    patte = 'M339 960 Q342 1006 372 1008 Q402 1006 405 960 Q372 976 339 960 Z'
    piv = (372, 872)
    if cote == 'd': d, patte, piv = miroir(d), miroir(patte), (1024 - piv[0], piv[1])
    return G(f'Bras {cote.upper()}', piv, [F('Patte', patte, remplissage=CREME), F('Bras', d, remplissage=ORANGE_F)])

QUEUE = 'M630 1040 Q742 1060 792 980 Q836 904 808 810 Q884 852 900 942 Q912 1046 812 1080 Q706 1100 630 1068 Z'
QUEUE_BOUT = 'M808 810 Q884 852 900 942 Q862 910 822 902 Q832 852 808 810 Z'
CORPS = 'M512 764 Q648 764 680 884 Q710 1004 642 1056 Q512 1096 382 1056 Q314 1004 344 884 Q376 764 512 764 Z'
VENTRE = 'M512 808 Q570 812 592 880 Q624 990 512 1040 Q400 990 432 880 Q454 812 512 808 Z'
TETE = 'M214 452 Q300 360 404 390 Q458 370 512 370 Q566 370 620 390 Q724 360 810 452 Q852 520 838 574 Q700 704 512 814 Q324 704 186 574 Q172 520 214 452 Z'
MASQUE = 'M186 574 Q300 532 402 592 Q458 626 512 702 Q566 626 622 592 Q724 532 838 574 Q700 704 512 814 Q324 704 186 574 Z'
TRUFFE = 'M472 664 Q512 648 552 664 Q546 704 512 720 Q478 704 472 664 Z'
REFLET_TRUFFE = 'M492 664 Q506 658 520 662 Q512 674 494 672 Z'

def construire():
    o = {}
    def n(cle, obj): o[cle] = obj; return obj

    yeux_ouverts = n('yeux_ouverts', G('Yeux ouverts', (512, 528), [oeil('g'), oeil('d')]))
    cligne = n('cligne', G('Clignement', (512, 528), [yeux_ouverts]))
    regard = n('regard', G('Regard', (512, 528), [
        cligne,
        n('yeux_heureux', G('Yeux heureux', (512, 528), [oeil_heureux('g'), oeil_heureux('d')], opacity=0)),
        n('yeux_fermes', G('Yeux fermes', (512, 528), [oeil_ferme('g'), oeil_ferme('d')], opacity=0)),
    ]))
    bouches = G('Bouches', (512, 760), [
        n('b_sourire', G('Sourire', (512, 756), [F('Trait', 'M480 746 Q512 774 544 746', trait=NUIT, epaisseur=12)])),
        n('b_ouverte', G('Bouche ouverte', (512, 744), [
            F('Langue', 'M486 786 Q512 770 538 786 Q532 806 512 808 Q492 806 486 786 Z', remplissage=LANGUE),
            F('Bouche', 'M468 740 Q512 734 556 740 Q550 806 512 812 Q474 806 468 740 Z', remplissage=NUIT),
        ], opacity=0)),
        n('b_triste', G('Triste', (512, 760), [F('Trait', 'M486 768 Q512 744 538 768', trait=NUIT, epaisseur=12)], opacity=0)),
        n('b_o', G('Bouche o', (512, 762), [E('O', (512, 762), 28, 32, remplissage=NUIT)], opacity=0)),
    ])
    tete = n('tete', G('Tete', (512, 790), [
        n('toque', toque()),
        n('sourcil_g', sourcil('g')), n('sourcil_d', sourcil('d')),
        regard,
        n('zzz', G('Zzz', (200, 330), [
            F('Z1', 'M190 340 L226 340 L190 376 L226 376', trait=NUIT, epaisseur=11),
            F('Z2', 'M140 260 L166 260 L140 286 L166 286', trait=NUIT, epaisseur=9),
        ], opacity=0)),
        F('Reflet truffe', REFLET_TRUFFE, remplissage='3A4A72'),
        F('Truffe', TRUFFE, remplissage=NUIT),
        bouches,
        n('joues', G('Joues', (512, 632), [
            E('Joue G', (334, 628), 76, 42, remplissage=ROSE), E('Joue D', (690, 628), 76, 42, remplissage=ROSE)], opacity=0)),
        F('Masque', MASQUE, remplissage=CREME),
        F('Tete', TETE, remplissage=orange_tete),
        n('oreille_g', oreille('g')), n('oreille_d', oreille('d')),
    ]))
    saut = n('saut', G('Saut', (512, 1084), [n('pirouette', G('Pirouette', (512, 660), [
        n('bras_g', bras('g')), n('bras_d', bras('d')),
        tete,
        E('Pied G', (448, 1070), 116, 52, remplissage=ORANGE_F),
        E('Pied D', (576, 1070), 116, 52, remplissage=ORANGE_F),
        F('Ventre', VENTRE, remplissage=Degrade([(0, CREME), (1, 'FFE2C6')], (512, 820), (512, 1040))),
        F('Corps', CORPS, remplissage=orange_corps),
        n('queue', G('Queue', (640, 1040), [F('Bout', QUEUE_BOUT, remplissage=CREME), F('Queue', QUEUE, remplissage=ORANGE)])),
    ]))]))
    # étincelles et confettis de la fête, hors du saut (ils restent dans la scène)
    etincelles = []
    for i, (x, y, t) in enumerate([(230, 330, 64), (840, 420, 52), (170, 700, 44), (900, 640, 60), (300, 180, 36), (770, 150, 40)]):
        etincelles.append(n(f'et{i}', Etoile(f'Etincelle {i}', (x, y), t, 4, 0.32, remplissage=OR, scaleX=0, scaleY=0)))
    confettis = []
    for i in range(10):
        x = 180 + i * 72; c = CONFETTIS[i % len(CONFETTIS)]
        confettis.append(n(f'cf{i}', Rect(f'Confetti {i}', (x, -40), 22 if i % 2 else 14, 12 if i % 2 else 22, 3, remplissage=c, opacity=0)))
    racine = G('Kunfox', (512, 1084), [
        *etincelles, *confettis, saut,
        n('ombre', E('Ombre', (512, 1094), 330, 40, remplissage='2214213D')),
    ], x=300 - 512, y=640 - 1084, scaleX=0.54, scaleY=0.54)
    return racine, o


# --------------------------------------------------------------- les humeurs
REPOS = {
    ('yeux_ouverts', 'opacity'): 1, ('yeux_heureux', 'opacity'): 0, ('yeux_fermes', 'opacity'): 0,
    ('regard', 'x'): 0, ('regard', 'y'): 0,
    ('b_sourire', 'opacity'): 1, ('b_ouverte', 'opacity'): 0, ('b_triste', 'opacity'): 0, ('b_o', 'opacity'): 0,
    ('b_ouverte', 'scaleY'): 1, ('joues', 'opacity'): 0, ('zzz', 'opacity'): 0, ('zzz', 'y'): 0,
    ('sourcil_g', 'rotation'): 0, ('sourcil_g', 'y'): 0, ('sourcil_d', 'rotation'): 0, ('sourcil_d', 'y'): 0,
    ('oreille_g', 'rotation'): 0, ('oreille_d', 'rotation'): 0,
    ('tete', 'rotation'): 0, ('tete', 'y'): 0,
    ('saut', 'y'): 0, ('saut', 'scaleX'): 1, ('saut', 'scaleY'): 1, ('pirouette', 'rotation'): 0,
    ('bras_g', 'rotation'): 0.16, ('bras_d', 'rotation'): -0.16,
    ('queue', 'rotation'): 0, ('toque', 'y'): 0, ('toque', 'rotation'): 0.24,
    ('ombre', 'scaleX'): 1, ('ombre', 'opacity'): 1,
    **{(f'et{i}', p): 0 for i in range(6) for p in ('scaleX', 'scaleY')},
    **{(f'cf{i}', 'opacity'): 0 for i in range(10)},
}

def humeur(o, nom, duree, pistes, boucle=True):
    """Chaque humeur fixe toutes les pièces expressives : rien ne reste « collé »
    de l'humeur précédente."""
    a = Anim(nom, duree, boucle)
    for (cle, prop), v in REPOS.items():
        if (cle, prop) in pistes: continue
        a.fixe(o[cle], prop, v)
    for (cle, prop), images in pistes.items():
        a.cle(o[cle], prop, *images)
    return a

def respiration(duree, ampl=0.018):
    m = duree // 2
    return {('saut', 'scaleY'): [(0, 1, DOUX), (m, 1 + ampl, DOUX), (duree, 1, None)],
            ('saut', 'scaleX'): [(0, 1, DOUX), (m, 1 - ampl * 0.45, DOUX), (duree, 1, None)]}

def oscille(a, b, periode, duree, courbe=DOUX, decal=0):
    """Va-et-vient a ↔ b, `periode` images par aller, sur `duree` images."""
    imgs = []; t = 0; v = (a, b)
    k = 0
    while t < duree:
        imgs.append((t, v[k % 2], courbe)); t += periode; k += 1
    imgs.append((duree, v[k % 2] if False else a, None))
    return imgs

def animations(o):
    A = {}
    # 0 — attente : respire, regarde autour, l'oreille frémit, la queue balance
    p = respiration(240)
    p.update({
        ('tete', 'rotation'): [(0, -0.02, DOUX), (130, 0.03, DOUX), (240, -0.02, None)],
        ('tete', 'y'): [(0, 0, DOUX), (130, 5, DOUX), (240, 0, None)],
        ('queue', 'rotation'): [(0, -0.07, DOUX), (120, 0.11, DOUX), (240, -0.07, None)],
        ('oreille_d', 'rotation'): [(0, 0, 'hold'), (150, 0, SORTIE), (154, 0.24, DOUX), (160, 0, SORTIE), (164, 0.14, DOUX), (174, 0, None)],
        ('regard', 'x'): [(0, 0, 'hold'), (60, 0, SORTIE), (70, 12, 'hold'), (120, 12, SORTIE), (130, -10, 'hold'), (190, -10, SORTIE), (200, 0, None)],
        ('bras_g', 'rotation'): [(0, 0.16, DOUX), (120, 0.24, DOUX), (240, 0.16, None)],
        ('bras_d', 'rotation'): [(0, -0.16, DOUX), (120, -0.24, DOUX), (240, -0.16, None)],
        ('toque', 'rotation'): [(0, 0.24, DOUX), (130, 0.28, DOUX), (240, 0.24, None)],
    })
    A[0] = humeur(o, 'Attente', 240, p)

    # 1 — joie : petit bond plein de ressort, yeux rieurs, bras en l'air
    A[1] = humeur(o, 'Joie', 60, {
        ('yeux_ouverts', 'opacity'): [(0, 0, 'hold')], ('yeux_heureux', 'opacity'): [(0, 1, 'hold')],
        ('b_sourire', 'opacity'): [(0, 0, 'hold')], ('b_ouverte', 'opacity'): [(0, 1, 'hold')],
        ('joues', 'opacity'): [(0, 0.85, 'hold')],
        ('saut', 'y'): [(0, 0, SORTIE), (22, -120, ENTREE), (38, 0, 'hold')],
        ('saut', 'scaleY'): [(0, 0.9, SORTIE), (8, 1.08, DOUX), (22, 1, ENTREE), (38, 1.05, SORTIE), (44, 0.88, DOUX), (52, 1.02, DOUX), (60, 0.9, None)],
        ('saut', 'scaleX'): [(0, 1.08, SORTIE), (8, 0.94, DOUX), (22, 1, ENTREE), (38, 0.97, SORTIE), (44, 1.1, DOUX), (52, 0.99, DOUX), (60, 1.08, None)],
        ('ombre', 'scaleX'): [(0, 1, SORTIE), (22, 0.62, ENTREE), (38, 1, None)],
        ('ombre', 'opacity'): [(0, 1, SORTIE), (22, 0.45, ENTREE), (38, 1, None)],
        ('bras_g', 'rotation'): [(0, 0.7, SORTIE), (20, 2.3, DOUX), (44, 0.7, DOUX), (60, 0.7, None)],
        ('bras_d', 'rotation'): [(0, -0.7, SORTIE), (20, -2.3, DOUX), (44, -0.7, DOUX), (60, -0.7, None)],
        ('oreille_g', 'rotation'): [(0, 0, SORTIE), (22, 0.1, ENTREE), (40, -0.2, DOUX), (52, 0.04, DOUX), (60, 0, None)],
        ('oreille_d', 'rotation'): [(0, 0, SORTIE), (22, -0.1, ENTREE), (40, 0.2, DOUX), (52, -0.04, DOUX), (60, 0, None)],
        ('queue', 'rotation'): oscille(-0.28, 0.32, 15, 60),
        ('tete', 'rotation'): [(0, 0, DOUX), (22, -0.06, DOUX), (44, 0.05, DOUX), (60, 0, None)],
        ('toque', 'y'): [(0, 0, SORTIE), (22, 16, ENTREE), (40, -46, DOUX), (54, 0, None)],
        ('toque', 'rotation'): [(0, 0.24, DOUX), (40, 0.4, DOUX), (60, 0.24, None)],
    })

    # 2 — courage : oreilles basses, sourcils inquiets, puis un petit hochement « on y retourne »
    p = respiration(180, 0.012)
    p.update({
        ('b_sourire', 'opacity'): [(0, 0, 'hold')], ('b_triste', 'opacity'): [(0, 1, 'hold'), (120, 1, DOUX), (132, 0, 'hold'), (170, 0, DOUX), (180, 1, None)],
        ('b_o', 'opacity'): [(0, 0, 'hold')],
        ('oreille_g', 'rotation'): [(0, -0.62, DOUX), (90, -0.55, DOUX), (180, -0.62, None)],
        ('oreille_d', 'rotation'): [(0, 0.62, DOUX), (90, 0.55, DOUX), (180, 0.62, None)],
        ('sourcil_g', 'rotation'): [(0, -0.34, 'hold')], ('sourcil_g', 'y'): [(0, -8, 'hold')],
        ('sourcil_d', 'rotation'): [(0, 0.34, 'hold')], ('sourcil_d', 'y'): [(0, -8, 'hold')],
        ('regard', 'y'): [(0, 16, DOUX), (110, 16, SORTIE), (124, 0, DOUX), (168, 0, DOUX), (180, 16, None)],
        ('regard', 'x'): [(0, -6, 'hold'), (110, -6, SORTIE), (124, 0, DOUX), (168, 0, DOUX), (180, -6, None)],
        ('tete', 'rotation'): [(0, 0.09, DOUX), (110, 0.06, SORTIE), (126, 0, DOUX), (168, 0, DOUX), (180, 0.09, None)],
        ('tete', 'y'): [(0, 12, DOUX), (110, 10, SORTIE), (122, -10, REBOND), (134, 0, DOUX), (168, 0, DOUX), (180, 12, None)],
        ('bras_g', 'rotation'): [(0, -0.06, 'hold')], ('bras_d', 'rotation'): [(0, 0.06, 'hold')],
        ('queue', 'rotation'): [(0, 0.3, DOUX), (90, 0.22, DOUX), (180, 0.3, None)],
        ('toque', 'rotation'): [(0, 0.5, DOUX), (90, 0.44, DOUX), (180, 0.5, None)],
    })
    # le sourire revient pendant le hochement
    p[('b_sourire', 'opacity')] = [(0, 0, 'hold'), (120, 0, DOUX), (132, 1, 'hold'), (170, 1, DOUX), (180, 0, None)]
    A[2] = humeur(o, 'Courage', 180, p)

    # 3 — réflexion : tête penchée, regard en l'air, patte sous le menton qui tapote
    p = respiration(240, 0.01)
    p.update({
        ('b_sourire', 'opacity'): [(0, 0, 'hold')], ('b_o', 'opacity'): [(0, 1, 'hold')],
        ('regard', 'x'): [(0, 14, DOUX), (120, 18, DOUX), (240, 14, None)],
        ('regard', 'y'): [(0, -18, 'hold')],
        ('sourcil_d', 'y'): [(0, -16, DOUX), (120, -20, DOUX), (240, -16, None)], ('sourcil_d', 'rotation'): [(0, 0.14, 'hold')],
        ('sourcil_g', 'rotation'): [(0, 0.1, 'hold')], ('sourcil_g', 'y'): [(0, 4, 'hold')],
        ('tete', 'rotation'): [(0, -0.12, DOUX), (120, -0.15, DOUX), (240, -0.12, None)],
        ('bras_d', 'rotation'): [(0, 2.25, SORTIE), (20, 2.38, SORTIE), (40, 2.25, SORTIE), (60, 2.38, SORTIE), (80, 2.25, 'hold'), (160, 2.25, SORTIE), (180, 2.38, SORTIE), (200, 2.25, 'hold'), (240, 2.25, None)],
        ('oreille_g', 'rotation'): [(0, -0.08, 'hold'), (100, -0.08, SORTIE), (104, -0.26, DOUX), (112, -0.08, None)],
        ('queue', 'rotation'): [(0, 0, DOUX), (120, 0.08, DOUX), (240, 0, None)],
    })
    A[3] = humeur(o, 'Reflexion', 240, p)

    # 4 — fête : un petit bond, puis un grand avec pirouette ; la toque s'envole, confettis
    f = {
        ('yeux_ouverts', 'opacity'): [(0, 0, 'hold')], ('yeux_heureux', 'opacity'): [(0, 1, 'hold')],
        ('b_sourire', 'opacity'): [(0, 0, 'hold')], ('b_ouverte', 'opacity'): [(0, 1, 'hold')],
        ('joues', 'opacity'): [(0, 0.9, 'hold')],
        ('saut', 'y'): [(0, 0, SORTIE), (16, -60, ENTREE), (30, 0, 'hold'), (40, 0, SORTIE), (70, -150, ENTREE), (100, 0, 'hold'), (150, 0, None)],
        ('pirouette', 'rotation'): [(0, 0, 'hold'), (44, 0, DOUX), (96, 6.2832, 'hold'), (150, 6.2832, None)],
        ('saut', 'scaleY'): [(0, 0.92, SORTIE), (8, 1.06, DOUX), (16, 1, ENTREE), (30, 1.04, SORTIE), (36, 0.84, SORTIE), (46, 1.1, DOUX), (70, 1, ENTREE), (100, 1.05, SORTIE), (106, 0.86, DOUX), (118, 1.03, DOUX), (130, 1, DOUX), (150, 0.92, None)],
        ('saut', 'scaleX'): [(0, 1.06, SORTIE), (8, 0.95, DOUX), (16, 1, ENTREE), (30, 0.97, SORTIE), (36, 1.12, SORTIE), (46, 0.92, DOUX), (70, 1, ENTREE), (100, 0.97, SORTIE), (106, 1.12, DOUX), (118, 0.98, DOUX), (130, 1, DOUX), (150, 1.06, None)],
        ('ombre', 'scaleX'): [(0, 1, SORTIE), (16, 0.8, ENTREE), (30, 1, 'hold'), (40, 1, SORTIE), (70, 0.4, ENTREE), (100, 1, None)],
        ('ombre', 'opacity'): [(0, 1, SORTIE), (16, 0.7, ENTREE), (30, 1, 'hold'), (40, 1, SORTIE), (70, 0.3, ENTREE), (100, 1, None)],
        ('bras_g', 'rotation'): oscille(2.0, 2.6, 10, 150),
        ('bras_d', 'rotation'): oscille(-2.0, -2.6, 10, 150),
        ('oreille_g', 'rotation'): [(0, 0, DOUX), (36, -0.22, DOUX), (70, 0.12, DOUX), (106, -0.24, DOUX), (124, 0.05, DOUX), (150, 0, None)],
        ('oreille_d', 'rotation'): [(0, 0, DOUX), (36, 0.22, DOUX), (70, -0.12, DOUX), (106, 0.24, DOUX), (124, -0.05, DOUX), (150, 0, None)],
        ('queue', 'rotation'): oscille(-0.3, 0.34, 12, 150),
        ('toque', 'y'): [(0, 0, 'hold'), (46, 0, FREIN), (84, -230, ENTREE), (112, 0, SORTIE), (118, -24, ENTREE), (124, 0, None)],
        ('toque', 'rotation'): [(0, 0.24, 'hold'), (46, 0.24, DOUX), (84, -2.9, DOUX), (112, 0.24, None)],
    }
    for i, debut in enumerate([66, 74, 82, 90, 98, 106]):
        for pr in ('scaleX', 'scaleY'):
            f[(f'et{i}', pr)] = [(0, 0, 'hold'), (debut, 0, REBOND), (debut + 12, 1.15, ENTREE), (debut + 34, 0, 'hold'), (150, 0, None)]
    o_et = [f'et{i}' for i in range(6)]
    A[4] = humeur(o, 'Fete', 150, f)
    # rotation des étincelles et chute des confettis
    for i in range(6):
        A[4].cle(o[o_et[i]], 'rotation', (0, 0, None), (150, 3.1 if i % 2 else -3.1, None))
    for i in range(10):
        d = 60 + (i * 7) % 40
        A[4].cle(o[f'cf{i}'], 'opacity', (0, 0, 'hold'), (d, 1, 'hold'), (d + 70, 1, DOUX), (d + 84, 0, 'hold'), (150, 0, None))
        A[4].cle(o[f'cf{i}'], 'y', (0, 0, 'hold'), (d, 0, None), (d + 84, 980 + (i % 3) * 60, 'hold'), (150, 0, None))
        A[4].cle(o[f'cf{i}'], 'x', (0, 0, 'hold'), (d, 0, DOUX), (d + 42, 40 if i % 2 else -40, DOUX), (d + 84, 0, 'hold'), (150, 0, None))
        A[4].cle(o[f'cf{i}'], 'rotation', (0, 0, 'hold'), (d, 0, None), (d + 84, 7 if i % 2 else -6, 'hold'), (150, 0, None))

    # 5 — salut : la patte droite fait coucou, sourire franc
    A[5] = humeur(o, 'Salut', 120, {
        ('b_sourire', 'opacity'): [(0, 0, 'hold')], ('b_ouverte', 'opacity'): [(0, 1, 'hold')],
        ('b_ouverte', 'scaleY'): [(0, 0.8, 'hold')], ('joues', 'opacity'): [(0, 0.55, 'hold')],
        ('bras_d', 'rotation'): oscille(-2.05, -2.75, 15, 120),
        ('tete', 'rotation'): [(0, 0.07, DOUX), (60, 0.1, DOUX), (120, 0.07, None)],
        ('saut', 'y'): oscille(0, -10, 30, 120),
        ('oreille_d', 'rotation'): [(0, 0, 'hold'), (40, 0, SORTIE), (44, 0.22, DOUX), (52, 0, None)],
        ('queue', 'rotation'): oscille(-0.18, 0.22, 20, 120),
        ('regard', 'x'): [(0, 4, 'hold')],
    })

    # 6 — dodo : yeux fermés, respiration lente, Zzz qui montent
    p = respiration(240, 0.03)
    p.update({
        ('yeux_ouverts', 'opacity'): [(0, 0, 'hold')], ('yeux_fermes', 'opacity'): [(0, 1, 'hold')],
        ('b_sourire', 'opacity'): [(0, 0, 'hold')], ('b_o', 'opacity'): [(0, 0.8, 'hold')],
        ('tete', 'rotation'): [(0, 0.14, DOUX), (120, 0.18, DOUX), (240, 0.14, None)],
        ('tete', 'y'): [(0, 14, DOUX), (120, 20, DOUX), (240, 14, None)],
        ('oreille_g', 'rotation'): [(0, -0.3, 'hold')], ('oreille_d', 'rotation'): [(0, 0.3, 'hold')],
        ('zzz', 'opacity'): [(0, 0, DOUX), (40, 1, 'hold'), (180, 1, DOUX), (220, 0, 'hold'), (240, 0, None)],
        ('zzz', 'y'): [(0, 30, None), (240, -60, None)],
        ('toque', 'rotation'): [(0, 0.5, 'hold')],
        ('bras_g', 'rotation'): [(0, 0.05, 'hold')], ('bras_d', 'rotation'): [(0, -0.05, 'hold')],
    })
    A[6] = humeur(o, 'Dodo', 240, p)
    return A

NOMS = ['attente', 'joie', 'courage', 'reflexion', 'fete', 'salut', 'dodo']

def clignement(o):
    a = Anim('Clignement', 300, True)
    a.cle(o['cligne'], 'scaleY', (0, 1, 'hold'), (100, 1, ENTREE), (104, 0.08, FREIN), (110, 1, 'hold'),
          (250, 1, ENTREE), (254, 0.08, FREIN), (259, 1, ENTREE), (263, 0.08, FREIN), (269, 1, 'hold'), (300, 1, None))
    return a

def produire(apercu=None, fond=None):
    nid.n = 100
    racine, o = construire()
    A = animations(o)
    cl = clignement(o)
    humeur_in = Entree('humeur', 'nombre', apercu or 0)
    etats = [Etat(A[k]) for k in range(len(NOMS))]
    for i, e in enumerate(etats):
        for j, autre in enumerate(etats):
            if i != j: e.vers(autre, egal(humeur_in, j), duree=180)
    debut = etats[apercu] if apercu is not None else etats[0]
    couches = [Couche('Humeur', debut, etats), Couche('Clignement', (ec := Etat(cl)), [ec])]
    rml = scene('Kunfox', 600, 700, racine, list(A.values()) + [cl], 'Kunfox', [humeur_in], couches, fond=fond)
    return rml, racine, o, A, cl

if __name__ == '__main__':
    base = pathlib.Path(__file__).resolve().parent.parent
    rml, *_ = produire()
    (base / 'kunfox_mascotte').mkdir(exist_ok=True)
    (base / 'kunfox_mascotte' / 'scene.rml').write_text(rml)
    (base / 'kunfox_mascotte' / 'rive.yaml').write_text('name: kunfox_mascotte\n')
    print('kunfox_mascotte/scene.rml :', len(rml), 'caractères')
    if '--apercus' in sys.argv:
        for i, nom in enumerate(NOMS):
            d = base / 'apercus' / f'mascotte_{nom}'; d.mkdir(parents=True, exist_ok=True)
            r, *_ = produire(i, fond='EEF1F6')
            (d / 'scene.rml').write_text(r); (d / 'rive.yaml').write_text(f'name: mascotte_{nom}\n')
    if '--svg' in sys.argv:
        dossier = pathlib.Path(sys.argv[sys.argv.index('--svg') + 1]); dossier.mkdir(parents=True, exist_ok=True)
        _, racine, o, A, cl = produire()
        html = ['<html><body style="margin:0;background:#EEF1F6;font:12px sans-serif">']
        for i, nom in enumerate(NOMS):
            a = A[i]; html.append(f'<div style="display:flex;align-items:center"><b style="width:70px">{nom}</b>')
            for k in range(6):
                t = round(a.duree * k / 6)
                html.append(f'<div>{svg(racine, 600, 700, etat_a([(a, t), (cl, 0)]), fond="EEF1F6", taille=170)}<br>{t}</div>')
            html.append('</div>')
        (dossier / 'planche.html').write_text(''.join(html) + '</body></html>')
        print('aperçu :', dossier / 'planche.html')
