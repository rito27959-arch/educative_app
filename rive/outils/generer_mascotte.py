"""Kunfox, la mascotte officielle : renardeau en toque de diplômé.

Dessin original de Kunfox (même tête que l'icône), décliné en personnage
complet : oreilles, sourcils, regard, bouches, joues, bras, queue et toque
sont des pièces séparées qui pivotent chacune autour de leur articulation.

Machine à états « Kunfox », entrée nombre `humeur` :
    0 attente   1 joie   2 courage (après une erreur)   3 réflexion
    4 fête      5 salut  6 dodo
Entrée nombre `regard` : 0 centre, 1 gauche, 2 droite, 3 bas, 4 haut.
Couches permanentes : clignement, vie (queue qui ondule, oreilles qui
frémissent), regard.

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

KAPPA = 0.5523

def ellipse_c(cx, cy, rx, ry):
    """Ellipse en 4 sommets cubiques (haut, droite, bas, gauche)."""
    k, kx, ky = KAPPA, KAPPA * rx, KAPPA * ry
    return (f'M{cx} {cy - ry} C{cx + kx} {cy - ry} {cx + rx} {cy - ky} {cx + rx} {cy} '
            f'C{cx + rx} {cy + ky} {cx + kx} {cy + ry} {cx} {cy + ry} '
            f'C{cx - kx} {cy + ry} {cx - rx} {cy + ky} {cx - rx} {cy} '
            f'C{cx - rx} {cy - ky} {cx - kx} {cy - ry} {cx} {cy - ry} Z')

def lisse(pts, coins=(), t=0.32):
    """Chemin fermé et doux passant par `pts` (Catmull-Rom → cubiques) ;
    les indices de `coins` restent pointus."""
    n = len(pts)
    def poignees(i):
        if i in coins: return pts[i], pts[i]
        a, b, c = pts[(i - 1) % n], pts[i], pts[(i + 1) % n]
        dx, dy = (c[0] - a[0]) * t, (c[1] - a[1]) * t
        return (b[0] - dx, b[1] - dy), (b[0] + dx, b[1] + dy)
    h = [poignees(i) for i in range(n)]
    d = f'M{pts[0][0]:.1f} {pts[0][1]:.1f}'
    for i in range(1, n + 1):
        j = i % n
        d += f' C{h[i - 1][1][0]:.1f} {h[i - 1][1][1]:.1f} {h[j][0][0]:.1f} {h[j][0][1]:.1f} {pts[j][0]:.1f} {pts[j][1]:.1f}'
    return d + ' Z'

def formes_oeil(cx, cy=528):
    """Un œil, quatre formes entre lesquelles il se MORPHE (même 4 sommets)."""
    return {
        'ouvert': ellipse_c(cx, cy, 35, 41),
        # œil rieur « ^ » : un arc épais
        'heureux': lisse([(cx, cy - 26), (cx + 38, cy + 14), (cx, cy - 6), (cx - 38, cy + 14)], coins=(1, 3), t=0.28),
        # œil fermé, détendu (dodo)
        'ferme': lisse([(cx, cy + 6), (cx + 36, cy - 2), (cx, cy + 18), (cx - 36, cy - 2)], coins=(1, 3), t=0.3),
        # paupière à moitié baissée (réflexion, courage)
        'mi_clos': lisse([(cx, cy - 8), (cx + 35, cy + 4), (cx, cy + 41), (cx - 35, cy + 4)], coins=(), t=0.36),
    }

def oeil(cote):
    cx = 404 if cote == 'g' else 620
    f = formes_oeil(cx)
    return F(f'Oeil {cote.upper()}', f.pop('ouvert'), formes=f, nom_base='ouvert', remplissage=NUIT)

def reflets(cote):
    cx = 404 if cote == 'g' else 620
    return [E('Reflet petit', (cx - 14, 552), 12, 12, remplissage=BLANC), E('Reflet', (cx + 12, 510), 26, 26, remplissage=BLANC)]

# La bouche : une seule forme qui se morphe (six sommets, coins pointus aux commissures)
BOUCHE = {
    'sourire': lisse([(480, 746), (498, 760), (526, 760), (544, 746), (527, 776), (497, 776)], coins=(0, 3)),
    'grand': lisse([(466, 738), (494, 736), (530, 736), (558, 738), (538, 808), (486, 808)], coins=(0, 3)),
    'triste': lisse([(484, 772), (498, 754), (526, 754), (540, 772), (526, 764), (498, 764)], coins=(0, 3)),
    'o': lisse([(496, 760), (504, 744), (520, 744), (528, 760), (520, 778), (504, 778)], coins=(), t=0.25),
}

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

    # les reflets n'existent que sur l'œil ouvert (clé historique : yeux_ouverts)
    yeux_ouverts = n('yeux_ouverts', G('Reflets', (512, 528), [*reflets('g'), *reflets('d')]))
    cligne = n('cligne', G('Clignement', (512, 528), [yeux_ouverts, n('oeil_g', oeil('g')), n('oeil_d', oeil('d'))]))
    regard = n('regard', G('Regard', (512, 528), [cligne]))
    # enveloppe du regard, pilotée par l'entrée `regard` (couche à part)
    suivi = n('suivi', G('Suivi', (512, 528), [regard]))
    f = dict(BOUCHE)
    bouches = n('b_ouverte', G('Bouche', (512, 760), [
        n('langue', F('Langue', 'M486 786 Q512 770 538 786 Q532 806 512 808 Q492 806 486 786 Z', remplissage=LANGUE, opacity=0)),
        n('bouche', F('Bouche', f.pop('sourire'), formes=f, nom_base='sourire', remplissage=NUIT)),
    ]))
    tete = n('tete', G('Tete', (512, 790), [
        n('toque', toque()),
        n('sourcil_g', sourcil('g')), n('sourcil_d', sourcil('d')),
        suivi,
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
        # volume : lumière venant d'en haut à gauche
        E('Lumiere tete', (372, 448), 150, 46, remplissage='FFB37A', opacity=0.55, rotation=-0.32),
        E('Lumiere tete 2', (300, 470), 34, 16, remplissage='FFE0C2', opacity=0.8, rotation=-0.5),
        F('Ombre masque', 'M214 600 Q330 568 410 620 Q470 664 512 740 Q554 664 614 620 Q694 568 810 600 Q700 716 512 818 Q324 716 214 600 Z', remplissage='F0D9C2'),
        F('Tete', TETE, remplissage=orange_tete),
        n('oreille_vie_g', G('Oreille vie G', (318, 440), [n('oreille_g', oreille('g'))])),
        n('oreille_vie_d', G('Oreille vie D', (706, 440), [n('oreille_d', oreille('d'))])),
    ]))
    saut = n('saut', G('Saut', (512, 1084), [n('pirouette', G('Pirouette', (512, 660), [
        n('bras_g', bras('g')), n('bras_d', bras('d')),
        tete,
        E('Pied G', (448, 1070), 116, 52, remplissage=ORANGE_F),
        E('Pied D', (576, 1070), 116, 52, remplissage=ORANGE_F),
        F('Ventre', VENTRE, remplissage=Degrade([(0, CREME), (1, 'FFE2C6')], (512, 820), (512, 1040))),
        # volume du corps : ombre propre en bas, lumière sur l'épaule gauche
        E('Lumiere corps', (420, 840), 70, 34, remplissage='FFA066', opacity=0.6, rotation=-0.7),
        E('Ombre corps', (512, 1048), 250, 44, remplissage='D24A14', opacity=0.55),
        F('Corps', CORPS, remplissage=orange_corps),
        n('queue_vie', G('Queue vie', (640, 1040), [
            n('queue', G('Queue', (640, 1040), [F('Bout', QUEUE_BOUT, remplissage=CREME), F('Queue', QUEUE, remplissage=ORANGE)]))])),
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
    ('b_ouverte', 'scaleY'): 1, ('b_ouverte', 'scaleX'): 1, ('joues', 'opacity'): 0, ('zzz', 'opacity'): 0, ('zzz', 'y'): 0,
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

def _morph(pistes, choix, duree):
    """Pistes d'opacité « une forme parmi plusieurs » → keyframes de morph."""
    images = sorted({f for k in choix for f, _, _ in pistes[k]} | {0})
    suite = []
    for f in images:
        forme = choix[max(choix, key=lambda k: valeur(pistes[k], f + 0.01))] \
            if any(valeur(pistes[k], f + 0.01) >= 0.5 for k in choix) else None
        suite.append((f, forme))
    out = []
    for f, forme in suite:
        if forme is None: forme = out[-1][1] if out else list(choix.values())[0]
        if out and out[-1][1] == forme: continue
        out.append((f, forme, DOUX))
    # chaque changement dure au moins 5 images : la forme glisse, elle ne saute pas
    lisses = []
    for i, (f, forme, c) in enumerate(out):
        if i > 0:
            prec = lisses[-1]
            lisses.append((max(f, prec[0] + 5) if f - prec[0] < 5 else f, forme, c))
            if f - 5 > prec[0]:
                lisses.insert(len(lisses) - 1, (f - 5 if f >= 5 else f, prec[1], DOUX))
        else:
            lisses.append((f, forme, c))
    return lisses

YEUX = {('yeux_heureux', 'opacity'): 'heureux', ('yeux_fermes', 'opacity'): 'ferme', ('yeux_ouverts', 'opacity'): 'ouvert'}
BOUCHES = {('b_ouverte', 'opacity'): 'grand', ('b_triste', 'opacity'): 'triste', ('b_o', 'opacity'): 'o', ('b_sourire', 'opacity'): 'sourire'}

def humeur(o, nom, duree, pistes, boucle=True, yeux=None):
    """Chaque humeur fixe toutes les pièces expressives : rien ne reste « collé »
    de l'humeur précédente. Les anciennes pistes « quelle bouche, quels yeux »
    deviennent des morphs : les formes glissent l'une vers l'autre."""
    a = Anim(nom, duree, boucle)
    tout = {k: [(0, v, 'hold')] for k, v in REPOS.items()}
    tout.update(pistes)
    for k in list(YEUX) + list(BOUCHES):
        tout.setdefault(k, [(0, 0, 'hold')])
    m_yeux = _morph(tout, YEUX, duree)
    m_bouche = _morph(tout, BOUCHES, duree)
    if yeux:  # une forme d'œil imposée (ex. mi-clos)
        m_yeux = [(f, yeux if forme == 'ouvert' else forme, c) for f, forme, c in m_yeux]
    a.forme(o['oeil_g'], *m_yeux); a.forme(o['oeil_d'], *m_yeux)
    a.forme(o['bouche'], *m_bouche)
    a.cle(o['langue'], 'opacity', *[(f, 1 if forme == 'grand' else 0, DOUX) for f, forme, _ in m_bouche])
    for (cle, prop), images in tout.items():
        if (cle, prop) in YEUX and cle != 'yeux_ouverts': continue
        if (cle, prop) in BOUCHES: continue
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

# --------------------------------------------------------------- mouvement
# Petite bibliothèque des principes de l'animation, appliqués partout pareil.
def ressort(t0, v0, v1, duree, freq=2.4, amorti=7.0, pas=2):
    """Ressort amorti de v0 vers v1 (dépasse, revient, se pose)."""
    imgs = []
    for f in range(t0, t0 + duree, pas):
        tau = (f - t0) / 60
        imgs.append((f, v1 + (v0 - v1) * math.exp(-amorti * tau) * math.cos(2 * math.pi * freq * tau), None))
    imgs.append((t0 + duree, v1, 'hold'))
    return imgs

def seq(*morceaux):
    """Met bout à bout des listes de keyframes (la dernière image d'un morceau
    est remplacée par la première du suivant si elles coïncident)."""
    out = []
    for m in morceaux:
        for k in m:
            if out and out[-1][0] >= k[0]: out.pop()
            out.append(k)
    return out

def retard(images, d):
    """Le même geste, d images plus tard : les parties souples suivent (overlap)."""
    return [(0, images[0][1], 'hold')] + [(f + d, v, c) for f, v, c in images]

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

    # 1 — BRAVO (bonne réponse) : se ramasse, bondit, bras au ciel, retombe
    #     en s'écrasant et se pose sur un ressort. Les oreilles, la queue et la
    #     toque suivent avec un temps de retard.
    D = 84
    b = {
        ('yeux_ouverts', 'opacity'): [(0, 1, 'hold'), (5, 0, 'hold')],
        ('yeux_heureux', 'opacity'): [(0, 0, 'hold'), (5, 1, 'hold')],
        ('b_sourire', 'opacity'): [(0, 1, 'hold'), (4, 0, 'hold')],
        ('b_ouverte', 'opacity'): [(0, 0, 'hold'), (4, 1, 'hold')],
        ('b_ouverte', 'scaleY'): seq([(0, 0.6, SORTIE), (14, 1.18, DOUX)], ressort(14, 1.18, 1, 30)),
        ('b_ouverte', 'scaleX'): seq([(0, 0.9, SORTIE), (14, 1.08, DOUX)], ressort(14, 1.08, 1, 30)),
        ('joues', 'opacity'): [(0, 0, SORTIE), (10, 0.9, 'hold')],
        ('saut', 'y'): [(0, 0, 'hold'), (9, 0, FREIN), (28, -150, ENTREE), (44, 0, 'hold')],
        ('saut', 'scaleY'): seq([(0, 1, SORTIE), (8, 0.9, SORTIE), (14, 1.1, DOUX), (26, 1, ENTREE), (41, 1.05, None), (44, 0.87, None)],
                                ressort(44, 0.87, 1, 40, freq=2.6)),
        ('saut', 'scaleX'): seq([(0, 1, SORTIE), (8, 1.07, SORTIE), (14, 0.93, DOUX), (26, 1, ENTREE), (41, 0.97, None), (44, 1.1, None)],
                                ressort(44, 1.1, 1, 40, freq=2.6)),
        ('ombre', 'scaleX'): seq([(0, 1, SORTIE), (8, 1.08, FREIN), (28, 0.55, ENTREE), (44, 1.1, None)], ressort(44, 1.1, 1, 30)),
        ('ombre', 'opacity'): [(0, 1, SORTIE), (9, 1, FREIN), (28, 0.45, ENTREE), (44, 1, 'hold')],
        ('bras_g', 'rotation'): seq([(0, 0.16, SORTIE), (8, -0.15, SORTIE), (17, 2.5, DOUX), (30, 2.15, DOUX)],
                                    [(30 + f, v, c) for f, v, c in oscille(2.15, 2.6, 7, 28)],
                                    ressort(58, 2.15, 0.45, 26, freq=1.6, amorti=6)),
        ('bras_d', 'rotation'): seq([(0, -0.16, SORTIE), (9, 0.15, SORTIE), (18, -2.5, DOUX), (31, -2.15, DOUX)],
                                    [(31 + f, -v, c) for f, v, c in oscille(2.15, 2.6, 7, 28)],
                                    ressort(59, -2.15, -0.45, 25, freq=1.6, amorti=6)),
        ('tete', 'rotation'): seq([(0, 0, DOUX), (8, 0.04, DOUX), (20, -0.08, DOUX), (44, 0.07, None)], ressort(44, 0.07, 0, 36, freq=1.8)),
        ('tete', 'y'): seq([(0, 0, SORTIE), (8, 9, SORTIE), (15, -6, DOUX), (44, 12, None)], ressort(44, 12, 0, 34, freq=2.2)),
        ('oreille_g', 'rotation'): seq([(0, 0, DOUX), (11, -0.08, DOUX), (19, -0.34, DOUX), (31, 0.16, DOUX), (47, -0.36, None)],
                                       ressort(47, -0.36, 0, 36, freq=2.2, amorti=6)),
        ('oreille_d', 'rotation'): seq([(0, 0, DOUX), (12, 0.08, DOUX), (20, 0.34, DOUX), (32, -0.16, DOUX), (48, 0.36, None)],
                                       ressort(48, 0.36, 0, 36, freq=2.2, amorti=6)),
        ('queue', 'rotation'): seq([(0, 0, DOUX), (9, -0.22, DOUX), (19, 0.5, DOUX), (31, -0.32, DOUX), (46, 0.42, None)],
                                   ressort(46, 0.42, 0, 38, freq=2.0, amorti=5)),
        ('toque', 'y'): [(0, 0, DOUX), (14, 14, DOUX), (30, -44, ENTREE), (46, 0, FREIN), (51, -14, ENTREE), (57, 0, 'hold')],
        ('toque', 'rotation'): [(0, 0.24, DOUX), (30, 0.5, DOUX), (56, 0.24, 'hold')],
        ('sourcil_g', 'y'): [(0, 0, SORTIE), (14, -12, DOUX), (60, -5, 'hold')],
        ('sourcil_d', 'y'): [(0, 0, SORTIE), (15, -12, DOUX), (61, -5, 'hold')],
    }
    for i, d in ((0, 18), (1, 23), (4, 27)):
        for pr in ('scaleX', 'scaleY'):
            b[(f'et{i}', pr)] = [(0, 0, 'hold'), (d, 0, REBOND), (d + 10, 1.1, ENTREE), (d + 30, 0, 'hold')]
    A[1] = humeur(o, 'Bravo', D, b, boucle=False)

    # 1 bis — joie calme : le sourire reste, il se balance doucement
    p = respiration(150, 0.016)
    p.update({
        ('joues', 'opacity'): [(0, 0.6, 'hold')],
        ('tete', 'rotation'): [(0, 0.05, DOUX), (75, -0.05, DOUX), (150, 0.05, None)],
        ('queue', 'rotation'): oscille(-0.16, 0.22, 25, 150),
        ('bras_g', 'rotation'): [(0, 0.45, DOUX), (75, 0.38, DOUX), (150, 0.45, None)],
        ('bras_d', 'rotation'): [(0, -0.45, DOUX), (75, -0.38, DOUX), (150, -0.45, None)],
        ('sourcil_g', 'y'): [(0, -5, 'hold')], ('sourcil_d', 'y'): [(0, -5, 'hold')],
        ('saut', 'y'): [(0, 0, DOUX), (37, -6, DOUX), (75, 0, DOUX), (112, -6, DOUX), (150, 0, None)],
    })
    A['calme'] = humeur(o, 'Joie calme', 150, p)

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

def vie(o):
    """Le personnage n'est jamais figé : la queue ondule (deux rythmes qui
    ne se répètent pas), une oreille frémit de temps en temps."""
    d = 600  # 10 s
    a = Anim('Vie', d, True)
    q = []
    for f in range(0, d + 1, 6):
        t = f / 60
        q.append((f, 0.07 * math.sin(2 * math.pi * t / 2.5) + 0.03 * math.sin(2 * math.pi * t / 0.9 + 1.3), None))
    a.cle(o['queue_vie'], 'rotation', *q)
    a.cle(o['oreille_vie_g'], 'rotation', *seq([(0, 0, 'hold')], ressort(150, -0.16, 0, 50, freq=5, amorti=9), [(400, 0, 'hold')], ressort(400, -0.12, 0, 46, freq=5.5, amorti=10), [(d, 0, None)]))
    a.cle(o['oreille_vie_d'], 'rotation', *seq([(0, 0, 'hold')], ressort(330, 0.16, 0, 50, freq=5, amorti=9), [(d, 0, None)]))
    return a

REGARDS = ['centre', 'gauche', 'droite', 'bas', 'haut']
_DECALAGES = {'centre': (0, 0), 'gauche': (-16, 2), 'droite': (16, 2), 'bas': (0, 14), 'haut': (0, -12)}

def regards(o):
    """Une petite animation tenue par direction : le regard s'y pose."""
    out = []
    for nom in REGARDS:
        dx, dy = _DECALAGES[nom]
        a = Anim(f'Regard {nom}', 30, False)
        a.fixe(o['suivi'], 'x', dx); a.fixe(o['suivi'], 'y', dy)
        out.append(a)
    return out

def produire(apercu=None, fond=None):
    nid.n = 100
    racine, o = construire()
    A = animations(o)
    cl = clignement(o)
    humeur_in = Entree('humeur', 'nombre', apercu or 0)
    etats = [Etat(A[k]) for k in range(len(NOMS))]
    calme = Etat(A['calme'])
    for i, e in enumerate(etats):
        for j, autre in enumerate(etats):
            if i != j: e.vers(autre, egal(humeur_in, j), duree=180)
    # Bravo se joue une fois puis se fond dans la joie calme
    etats[1].vers(calme, fin=True, duree=320)
    for j, autre in enumerate(etats):
        if j != 1: calme.vers(autre, egal(humeur_in, j), duree=200)
    etats = etats + [calme]
    debut = etats[apercu] if apercu is not None else etats[0]
    v = vie(o)
    R = regards(o)
    regard_in = Entree('regard', 'nombre', 0)
    er = [Etat(a) for a in R]
    for i, e in enumerate(er):
        for j, autre in enumerate(er):
            if i != j: e.vers(autre, egal(regard_in, j), duree=220)
    couches = [Couche('Humeur', debut, etats), Couche('Clignement', (ec := Etat(cl)), [ec]),
               Couche('Vie', (ev := Etat(v)), [ev]), Couche('Regard', er[0], er)]
    rml = scene('Kunfox', 600, 700, racine, [a for a in A.values()] + [cl, v, *R], 'Kunfox', [humeur_in, regard_in], couches, fond=fond)
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
