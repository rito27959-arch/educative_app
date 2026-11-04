"""Effets de Kunfox : flamme de série, cœur de vie, bonne réponse, erreur, niveau.

Chaque effet est un petit projet Rive à fond transparent :
    rive/kunfox_flamme   entrée nombre `allumee` (0 éteinte, 1 allumée)
    rive/kunfox_coeur    entrée nombre `vide`    (0 plein, 1 perdu)
    rive/kunfox_reussite joue une fois
    rive/kunfox_erreur   joue une fois
    rive/kunfox_niveau   joue l'entrée puis brille en boucle

    python3 rive/outils/generer_effets.py [--apercus] [--svg <dossier>]
"""
import math, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from kunrive import *

NUIT, OR, CREME, BLANC = '14213D', 'FFC24B', 'FFF4E8', 'FFFFFF'
ETEINT = 'C3CAD6'

def anneau(nom, c, d, couleur, ep):
    return E(nom, c, d, d, trait=couleur, epaisseur=ep, opacity=0)


# ================================================================ flamme
def flamme():
    o = {}
    def n(k, v): o[k] = v; return v
    EXT = 'M150 300 Q78 300 70 230 Q64 170 112 120 Q110 160 132 172 Q130 110 168 56 Q178 122 214 152 Q242 184 232 232 Q222 300 150 300 Z'
    MIL = 'M150 296 Q104 296 102 252 Q100 212 132 186 Q134 216 152 222 Q156 190 180 166 Q202 206 200 246 Q198 296 150 296 Z'
    COE = 'M150 292 Q122 292 122 266 Q122 242 150 216 Q178 242 178 266 Q178 292 150 292 Z'
    braises = [n(f'b{i}', E(f'Braise {i}', (130 + i * 14, 210), 10 - i % 2 * 3, 10 - i % 2 * 3, remplissage=OR, opacity=0)) for i in range(4)]
    racine = G('Racine', (0, 0), [
        n('etincelle', Etoile('Etincelle', (150, 262), 90, 4, 0.28, remplissage='FFF1C1', scaleX=0, scaleY=0)),
        *braises,
        n('feu', G('Feu', (150, 300), [
            n('coeur', G('Coeur', (150, 292), [F('Coeur', COE, remplissage=Degrade([(0, 'FFFBEA'), (1, 'FFE7A0')], (150, 220), (150, 292)))])),
            n('milieu', G('Milieu', (150, 296), [F('Milieu', MIL, remplissage=Degrade([(0, 'FFE066'), (1, 'FFA531')], (150, 170), (150, 296)))])),
            n('ext', G('Exterieur', (150, 300), [F('Exterieur', EXT, remplissage=Degrade([(0, 'FFB13B'), (0.55, 'FF7A2A'), (1, 'F2491D')], (150, 60), (150, 300)))])),
        ], scaleX=0, scaleY=0)),
        n('eteinte', G('Eteinte', (150, 300), [F('Eteinte', EXT, remplissage=ETEINT)])),
        n('onde', anneau('Onde', (150, 230), 120, 'FFC24B', 8)),
        n('halo', E('Halo', (150, 220), 300, 300, remplissage=Degrade([(0, '66FFA531'), (1, '00FFA531')], (150, 220), (300, 220), radial=True), opacity=0)),
    ])
    def fige(a, sauf):
        repos = {('feu', 'scaleX'): 1, ('feu', 'scaleY'): 1, ('eteinte', 'opacity'): 0, ('halo', 'opacity'): 0.8,
                 ('etincelle', 'scaleX'): 0, ('etincelle', 'scaleY'): 0, ('onde', 'opacity'): 0}
        for (k, p), v in repos.items():
            if (k, p) not in sauf: a.fixe(o[k], p, v)
        for (k, p), imgs in sauf.items(): a.cle(o[k], p, *imgs)
        return a
    eteinte = fige(Anim('Eteinte', 120), {
        ('feu', 'scaleX'): [(0, 0, 'hold')], ('feu', 'scaleY'): [(0, 0, 'hold')], ('halo', 'opacity'): [(0, 0, 'hold')],
        ('eteinte', 'opacity'): [(0, 1, 'hold')],
        ('eteinte', 'scaleY'): [(0, 1, DOUX), (60, 0.96, DOUX), (120, 1, None)],
    })
    for i in range(4): eteinte.fixe(o[f'b{i}'], 'opacity', 0)
    allumage = fige(Anim('Allumage', 72, boucle=False), {
        ('eteinte', 'opacity'): [(0, 1, SORTIE), (12, 0, 'hold')],
        ('eteinte', 'scaleY'): [(0, 1, SORTIE), (12, 0.6, 'hold')],
        ('etincelle', 'scaleX'): [(0, 0, SORTIE), (9, 1.3, ENTREE), (22, 0, 'hold')],
        ('etincelle', 'scaleY'): [(0, 0, SORTIE), (9, 1.3, ENTREE), (22, 0, 'hold')],
        ('etincelle', 'rotation'): [(0, 0, None), (22, 1.2, 'hold')],
        ('feu', 'scaleX'): [(0, 0, 'hold'), (6, 0.1, SORTIE), (24, 1.1, DOUX), (36, 0.95, DOUX), (48, 1.02, DOUX), (60, 1, 'hold')],
        ('feu', 'scaleY'): [(0, 0, 'hold'), (6, 0.1, SORTIE), (26, 1.24, DOUX), (38, 0.92, DOUX), (50, 1.04, DOUX), (62, 1, 'hold')],
        ('halo', 'opacity'): [(0, 0, 'hold'), (10, 0, SORTIE), (28, 1, DOUX), (72, 0.8, None)],
        ('onde', 'opacity'): [(0, 0, 'hold'), (14, 0.9, None), (46, 0, 'hold')],
        ('onde', 'scaleX'): [(0, 0.4, 'hold'), (14, 0.4, SORTIE), (46, 2.4, 'hold')],
        ('onde', 'scaleY'): [(0, 0.4, 'hold'), (14, 0.4, SORTIE), (46, 2.4, 'hold')],
    })
    for i in range(4):  # gerbe de braises au moment où ça prend
        ang = -math.pi / 2 + (i - 1.5) * 0.45
        allumage.cle(o[f'b{i}'], 'opacity', (0, 0, 'hold'), (16, 1, None), (50, 0, 'hold'))
        allumage.cle(o[f'b{i}'], 'x', (0, 0, 'hold'), (16, 0, SORTIE), (50, math.cos(ang) * 110, 'hold'))
        allumage.cle(o[f'b{i}'], 'y', (0, 0, 'hold'), (16, 0, SORTIE), (50, math.sin(ang) * 150, 'hold'))
    vive = fige(Anim('Vive', 90), {
        ('halo', 'opacity'): [(0, 0.7, DOUX), (45, 0.95, DOUX), (90, 0.7, None)],
    })
    vive.cle(o['ext'], 'scaleY', (0, 1, DOUX), (22, 1.06, DOUX), (40, 0.97, DOUX), (64, 1.04, DOUX), (90, 1, None))
    vive.cle(o['ext'], 'scaleX', (0, 1, DOUX), (22, 0.97, DOUX), (40, 1.02, DOUX), (64, 0.98, DOUX), (90, 1, None))
    vive.cle(o['ext'], 'rotation', (0, 0, DOUX), (30, 0.035, DOUX), (60, -0.03, DOUX), (90, 0, None))
    vive.cle(o['milieu'], 'scaleY', (0, 1.02, DOUX), (30, 0.94, DOUX), (56, 1.07, DOUX), (90, 1.02, None))
    vive.cle(o['milieu'], 'rotation', (0, -0.02, DOUX), (45, 0.04, DOUX), (90, -0.02, None))
    vive.cle(o['coeur'], 'scaleY', (0, 1, DOUX), (18, 0.9, DOUX), (45, 1.06, DOUX), (72, 0.94, DOUX), (90, 1, None))
    vive.cle(o['coeur'], 'scaleX', (0, 1, DOUX), (45, 0.95, DOUX), (90, 1, None))
    for i in range(4):
        s = i * 22; dx = (-1) ** i * 18
        vive.cle(o[f'b{i}'], 'opacity', (0, 0, 'hold'), (s, 0, None), (s + 12, 1, None), (s + 50, 1, None), (s + 64, 0, 'hold'), (90, 0, None))
        vive.cle(o[f'b{i}'], 'y', (0, 0, 'hold'), (s, 0, None), (s + 64, -170, 'hold'), (90, 0, None))
        vive.cle(o[f'b{i}'], 'x', (0, 0, 'hold'), (s, 0, DOUX), (s + 32, dx, DOUX), (s + 64, 0, 'hold'), (90, 0, None))
    entree = Entree('allumee', 'nombre')
    e_et, e_al, e_vi = Etat(eteinte), Etat(allumage), Etat(vive)
    e_et.vers(e_al, egal(entree, 1)); e_al.vers(e_vi, fin=True); e_vi.vers(e_et, egal(entree, 0), duree=300)
    return dict(nom='flamme', taille=(300, 340), racine=racine, anims=[eteinte, allumage, vive], entrees=[entree],
                etats=[e_et, e_al, e_vi], apercus={'eteinte': (e_et, 0), 'allumage': (e_al, 1)})


# ================================================================ cœur
def coeur():
    o = {}
    def n(k, v): o[k] = v; return v
    C = 'M150 250 Q60 190 54 130 Q50 74 100 66 Q136 62 150 100 Q164 62 200 66 Q250 74 246 130 Q240 190 150 250 Z'
    FENTE = 'L140 130 L160 160 L142 190 L156 220 L150 250'
    G_ = 'M150 100 ' + FENTE + ' Q60 190 54 130 Q50 74 100 66 Q136 62 150 100 Z'
    D_ = 'M150 100 Q164 62 200 66 Q250 74 246 130 Q240 190 150 250 L156 220 L142 190 L160 160 L140 130 Z'
    rouge = Degrade([(0, 'FF7A93'), (1, 'E8324F')], (150, 66), (150, 250))
    reflet = F('Reflet', 'M82 112 Q86 88 110 82', trait='AAFFFFFF', epaisseur=12)
    eclats = [n(f'x{i}', Etoile(f'Eclat {i}', (150, 170), 26, 3, 0.5, remplissage='FF5A74', opacity=0)) for i in range(4)]
    paillettes = [n(f'p{i}', Etoile(f'Paillette {i}', (150 + 100 * math.cos(a), 160 + 100 * math.sin(a)), 30, 4, 0.3, remplissage=OR, scaleX=0, scaleY=0))
                  for i, a in enumerate([-2.4, -0.7, 0.4, 2.6])]
    racine = G('Racine', (0, 0), [
        *paillettes, *eclats,
        n('plein', G('Plein', (150, 160), [reflet, F('Coeur', C, remplissage=rouge)])),
        n('mg', G('Moitie G', (150, 250), [F('Moitie G', G_, remplissage=rouge)], opacity=0)),
        n('md', G('Moitie D', (150, 250), [F('Moitie D', D_, remplissage=rouge)], opacity=0)),
        n('vide', G('Vide', (150, 160), [F('Vide', C, remplissage=ETEINT)], opacity=0)),
        n('onde', anneau('Onde', (150, 160), 200, 'FF7A93', 8)),
    ])
    REPOS = {('plein', 'opacity'): 1, ('plein', 'scaleX'): 1, ('plein', 'scaleY'): 1, ('plein', 'x'): 0,
             ('mg', 'opacity'): 0, ('md', 'opacity'): 0, ('vide', 'opacity'): 0, ('vide', 'scaleX'): 1, ('vide', 'scaleY'): 1,
             ('onde', 'opacity'): 0, **{(f'x{i}', 'opacity'): 0 for i in range(4)},
             **{(f'p{i}', p): 0 for i in range(4) for p in ('scaleX', 'scaleY')}}
    def anim(nom, duree, pistes, boucle=True):
        a = Anim(nom, duree, boucle)
        for (k, p), v in REPOS.items():
            if (k, p) not in pistes: a.fixe(o[k], p, v)
        for (k, p), imgs in pistes.items(): a.cle(o[k], p, *imgs)
        return a
    battement = [(0, 1, 'hold'), (40, 1, SORTIE), (48, 1.1, DOUX), (56, 0.97, SORTIE), (63, 1.06, DOUX), (76, 1, 'hold'), (100, 1, None)]
    plein = anim('Plein', 100, {('plein', 'scaleX'): battement, ('plein', 'scaleY'): battement})
    perte = anim('Perte', 66, {
        ('plein', 'x'): [(0, 0, None), (3, -10, None), (6, 10, None), (9, -8, None), (12, 6, 'hold')],
        ('plein', 'opacity'): [(0, 1, 'hold'), (14, 0, 'hold')],
        ('mg', 'opacity'): [(0, 0, 'hold'), (14, 1, 'hold'), (34, 1, DOUX), (52, 0, 'hold')],
        ('md', 'opacity'): [(0, 0, 'hold'), (14, 1, 'hold'), (34, 1, DOUX), (52, 0, 'hold')],
        ('vide', 'opacity'): [(0, 0, 'hold'), (36, 0, SORTIE), (54, 1, 'hold')],
        ('vide', 'scaleX'): [(0, 0.6, 'hold'), (36, 0.6, REBOND), (56, 1, 'hold')],
        ('vide', 'scaleY'): [(0, 0.6, 'hold'), (36, 0.6, REBOND), (56, 1, 'hold')],
    }, boucle=False)
    for k, sens in (('mg', -1), ('md', 1)):
        perte.cle(o[k], 'rotation', (0, 0, 'hold'), (14, 0, SORTIE), (52, 0.55 * sens, 'hold'))
        perte.cle(o[k], 'x', (0, 0, 'hold'), (14, 0, SORTIE), (52, 34 * sens, 'hold'))
        perte.cle(o[k], 'y', (0, 0, 'hold'), (14, 0, ENTREE), (52, 60, 'hold'))
    for i, a in enumerate([-2.2, -0.9, 0.3, 2.9]):
        perte.cle(o[f'x{i}'], 'opacity', (0, 0, 'hold'), (14, 1, None), (44, 0, 'hold'))
        perte.cle(o[f'x{i}'], 'x', (0, 0, 'hold'), (14, 0, SORTIE), (44, math.cos(a) * 120, 'hold'))
        perte.cle(o[f'x{i}'], 'y', (0, 0, 'hold'), (14, 0, SORTIE), (44, math.sin(a) * 110 + 30, 'hold'))
        perte.cle(o[f'x{i}'], 'rotation', (0, 0, 'hold'), (14, 0, None), (44, 3 * (1 if i % 2 else -1), 'hold'))
    vide = anim('Vide', 120, {('plein', 'opacity'): [(0, 0, 'hold')], ('vide', 'opacity'): [(0, 1, 'hold')],
                              ('vide', 'scaleX'): [(0, 1, DOUX), (60, 0.97, DOUX), (120, 1, None)],
                              ('vide', 'scaleY'): [(0, 1, DOUX), (60, 0.97, DOUX), (120, 1, None)]})
    rech = {('vide', 'opacity'): [(0, 1, 'hold'), (10, 1, SORTIE), (20, 0, 'hold')],
            ('plein', 'opacity'): [(0, 0, 'hold'), (6, 0, SORTIE), (14, 1, 'hold')],
            ('plein', 'scaleX'): [(0, 0, 'hold'), (6, 0, SORTIE), (20, 1.28, DOUX), (30, 0.93, DOUX), (40, 1.03, DOUX), (50, 1, 'hold')],
            ('plein', 'scaleY'): [(0, 0, 'hold'), (6, 0, SORTIE), (20, 1.28, DOUX), (30, 0.93, DOUX), (40, 1.03, DOUX), (50, 1, 'hold')],
            ('onde', 'opacity'): [(0, 0, 'hold'), (14, 0.9, None), (44, 0, 'hold')],
            ('onde', 'scaleX'): [(0, 0.5, 'hold'), (14, 0.5, SORTIE), (44, 1.7, 'hold')],
            ('onde', 'scaleY'): [(0, 0.5, 'hold'), (14, 0.5, SORTIE), (44, 1.7, 'hold')]}
    for i in range(4):
        for p in ('scaleX', 'scaleY'):
            rech[(f'p{i}', p)] = [(0, 0, 'hold'), (16 + i * 4, 0, REBOND), (28 + i * 4, 1, ENTREE), (48 + i * 4, 0, 'hold')]
    recharge = anim('Recharge', 60, rech, boucle=False)
    entree = Entree('vide', 'nombre')
    ep, epe, ev, er = Etat(plein), Etat(perte), Etat(vide), Etat(recharge)
    ep.vers(epe, egal(entree, 1)); epe.vers(ev, fin=True); ev.vers(er, egal(entree, 0)); er.vers(ep, fin=True)
    return dict(nom='coeur', taille=(300, 300), racine=racine, anims=[plein, perte, vide, recharge], entrees=[entree],
                etats=[ep, epe, ev, er], apercus={'perte': (epe, 1), 'recharge': (er, 0)})


# ================================================================ bonne réponse / erreur
def pastille(nom, couleurs, traits, secousse=False):
    o = {}
    def n(k, v): o[k] = v; return v
    c = (200, 200)
    parts = [n(f'q{i}', E(f'Particule {i}', c, 18 if i % 2 else 12, 18 if i % 2 else 12, remplissage=couleurs[2] if i % 2 else OR, opacity=0))
             for i in range(10)] if not secousse else []
    marques = [n(f't{i}', F(f'Trait {i}', d, trait=BLANC, epaisseur=24, trim=0)) for i, d in enumerate(traits)]
    racine = G('Racine', (0, 0), [*parts, n('pastille', G('Pastille', c, [
        *marques,
        F('Reflet', 'M136 150 Q150 122 180 112', trait='55FFFFFF', epaisseur=10),
        E('Disque', c, 180, 180, remplissage=Degrade([(0, couleurs[0]), (1, couleurs[1])], (200, 110), (200, 290))),
    ], scaleX=0, scaleY=0)), n('onde', anneau('Onde', c, 190, couleurs[0], 10))])
    a = Anim(nom, 80, boucle=False)
    pop = [(0, 0, SORTIE), (16, 1.16, DOUX), (26, 0.95, DOUX), (36, 1.02, DOUX), (46, 1, 'hold')]
    a.cle(o['pastille'], 'scaleX', *pop); a.cle(o['pastille'], 'scaleY', *pop)
    a.cle(o['onde'], 'opacity', (0, 0, 'hold'), (8, 0.8, None), (50, 0, 'hold'))
    a.cle(o['onde'], 'scaleX', (0, 0.9, 'hold'), (8, 0.9, SORTIE), (50, 1.9, 'hold'))
    a.cle(o['onde'], 'scaleY', (0, 0.9, 'hold'), (8, 0.9, SORTIE), (50, 1.9, 'hold'))
    for i, t in enumerate(marques):
        d = 14 + i * 12
        a.cle(t, 'trim', (0, 0, 'hold'), (d, 0, SORTIE), (d + 18, 1, 'hold'))
    if secousse:
        a.cle(o['pastille'], 'x', (0, 0, 'hold'), (40, 0, None), (44, -14, None), (48, 12, None), (52, -9, None), (56, 6, None), (60, -3, None), (64, 0, 'hold'))
    for i in range(len(parts)):
        ang = i * 2 * math.pi / len(parts) - math.pi / 2; r = 170 if i % 2 else 140
        a.cle(o[f'q{i}'], 'opacity', (0, 0, 'hold'), (10, 1, None), (54, 0, 'hold'))
        a.cle(o[f'q{i}'], 'x', (0, 0, 'hold'), (10, 0, SORTIE), (48, math.cos(ang) * r, 'hold'))
        a.cle(o[f'q{i}'], 'y', (0, 0, 'hold'), (10, 0, SORTIE), (48, math.sin(ang) * r, 'hold'))
    e = Etat(a)
    return dict(nom=nom.lower(), taille=(400, 400), racine=racine, anims=[a], entrees=[], etats=[e], apercus={'jeu': (e, 0)})

def reussite():
    return pastille('Reussite', ('6EDC7E', '27B04B', '4CC9F0'), ['M152 204 L188 240 L252 166'])

def erreur():
    return pastille('Erreur', ('FF7A8A', 'E8324F', 'FF8FA3'), ['M164 164 L236 236', 'M236 164 L164 236'], secousse=True)


# ================================================================ niveau supérieur
def niveau():
    o = {}
    def n(k, v): o[k] = v; return v
    c = (200, 200)
    rayons = []
    for i in range(12):
        a = i * math.pi / 6; h = 0.09
        p1 = (200 + 190 * math.cos(a - h), 200 + 190 * math.sin(a - h)); p2 = (200 + 190 * math.cos(a + h), 200 + 190 * math.sin(a + h))
        rayons.append(F(f'Rayon {i}', f'M200 200 L{p1[0]:.1f} {p1[1]:.1f} L{p2[0]:.1f} {p2[1]:.1f} Z', pivot=c,
                        remplissage=Degrade([(0, '88FFC24B'), (1, '00FFC24B')], c, (390, 200), radial=True)))
    couleurs = ['FFC24B', '4CC9F0', 'FF8FA3', '7BE07B', 'FF6B2B', 'FFF4E8']
    conf = [n(f'c{i}', Rect(f'Confetti {i}', c, 16 if i % 2 else 10, 10 if i % 2 else 18, 3, remplissage=couleurs[i % 6], opacity=0)) for i in range(14)]
    scint = [n(f's{i}', Etoile(f'Scintille {i}', p, t, 4, 0.3, remplissage='FFF1C1', scaleX=0, scaleY=0))
             for i, (p, t) in enumerate([((92, 112), 34), ((314, 98), 26), ((330, 300), 30), ((78, 296), 22)])]
    racine = G('Racine', (0, 0), [
        *conf, *scint,
        n('badge', G('Badge', c, [
            n('etoile', G('Etoile', c, [Etoile('Etoile', c, 120, 5, 0.5, arrondi=6,
                                               remplissage=Degrade([(0, 'FFF0B0'), (1, 'FFB020')], (200, 140), (200, 260)))], scaleX=0, scaleY=0)),
            E('Fond', c, 168, 168, remplissage=Degrade([(0, '22335C'), (1, '0C1630')], (200, 116), (200, 284))),
            E('Bord', c, 204, 204, remplissage=Degrade([(0, 'FFE08A'), (1, 'F09A1A')], (200, 98), (200, 302))),
        ], scaleX=0, scaleY=0)),
        n('rayons', G('Rayons', c, rayons, opacity=0, scaleX=0.3, scaleY=0.3)),
    ])
    ent = Anim('Entree', 84, boucle=False)
    pop = [(0, 0, SORTIE), (20, 1.18, DOUX), (32, 0.95, DOUX), (44, 1, 'hold')]
    ent.cle(o['badge'], 'scaleX', *pop); ent.cle(o['badge'], 'scaleY', *pop)
    ent.cle(o['badge'], 'rotation', (0, -0.7, SORTIE), (36, 0, 'hold'))
    pe = [(0, 0, 'hold'), (14, 0, SORTIE), (30, 1.3, DOUX), (42, 0.94, DOUX), (54, 1, 'hold')]
    ent.cle(o['etoile'], 'scaleX', *pe); ent.cle(o['etoile'], 'scaleY', *pe)
    ent.cle(o['etoile'], 'rotation', (0, -1.2, 'hold'), (14, -1.2, SORTIE), (46, 0, 'hold'))
    ent.cle(o['rayons'], 'opacity', (0, 0, 'hold'), (16, 0, SORTIE), (40, 1, 'hold'))
    ent.cle(o['rayons'], 'scaleX', (0, 0.3, 'hold'), (16, 0.3, SORTIE), (48, 1, 'hold'))
    ent.cle(o['rayons'], 'scaleY', (0, 0.3, 'hold'), (16, 0.3, SORTIE), (48, 1, 'hold'))
    ent.cle(o['rayons'], 'rotation', (0, 0, None), (84, 0.18, 'hold'))
    for i in range(14):
        ang = -math.pi / 2 + (i - 6.5) * 0.36; r = 150 + (i % 3) * 30
        ent.cle(o[f'c{i}'], 'opacity', (0, 0, 'hold'), (18, 1, None), (70, 1, DOUX), (84, 0, 'hold'))
        ent.cle(o[f'c{i}'], 'x', (0, 0, 'hold'), (18, 0, SORTIE), (50, math.cos(ang) * r, DOUX), (84, math.cos(ang) * r * 1.1, 'hold'))
        ent.cle(o[f'c{i}'], 'y', (0, 0, 'hold'), (18, 0, SORTIE), (50, math.sin(ang) * r * 0.9, ENTREE), (84, math.sin(ang) * r * 0.9 + 110, 'hold'))
        ent.cle(o[f'c{i}'], 'rotation', (0, 0, 'hold'), (18, 0, None), (84, 5 if i % 2 else -5, 'hold'))
    for i in range(4):
        for p in ('scaleX', 'scaleY'): ent.fixe(o[f's{i}'], p, 0)
    brille = Anim('Brille', 240)
    brille.cle(o['rayons'], 'rotation', (0, 0.18, None), (240, 0.18 + math.pi / 6, None))
    for k in ('opacity', 'scaleX', 'scaleY'): brille.fixe(o['rayons'], k, 1)
    for k in ('scaleX', 'scaleY'): brille.fixe(o['badge'], k, 1)
    brille.fixe(o['badge'], 'rotation', 0)
    brille.cle(o['badge'], 'y', (0, 0, DOUX), (120, -8, DOUX), (240, 0, None))
    for k in ('scaleX', 'scaleY'): brille.cle(o['etoile'], k, (0, 1, DOUX), (60, 1.06, DOUX), (120, 1, 'hold'), (240, 1, None))
    for i in range(14): brille.fixe(o[f'c{i}'], 'opacity', 0)
    for i in range(4):
        d = i * 55
        for p in ('scaleX', 'scaleY'):
            brille.cle(o[f's{i}'], p, (0, 0, 'hold'), (d, 0, SORTIE), (d + 16, 1, ENTREE), (d + 36, 0, 'hold'), (240, 0, None))
        brille.cle(o[f's{i}'], 'rotation', (0, 0, 'hold'), (d, 0, None), (d + 36, 1.2, 'hold'), (240, 0, None))
    e1, e2 = Etat(ent), Etat(brille)
    e1.vers(e2, fin=True)
    return dict(nom='niveau', taille=(400, 400), racine=racine, anims=[ent, brille], entrees=[], etats=[e1, e2], apercus={'jeu': (e1, 0)})


EFFETS = [flamme, coeur, reussite, erreur, niveau]

def produire(fabrique, apercu=None, fond=None):
    nid.n = 100
    e = fabrique()
    debut, v = e['apercus'][apercu] if apercu else (e['etats'][0], 0)
    for ent in e['entrees']: ent.valeur = v
    w, h = e['taille']
    rml = scene(e['nom'].capitalize(), w, h, e['racine'], e['anims'], e['nom'].capitalize(), e['entrees'],
                [Couche('Couche', debut, e['etats'])], fond=fond)
    return rml, e

if __name__ == '__main__':
    base = pathlib.Path(__file__).resolve().parent.parent
    for fab in EFFETS:
        rml, e = produire(fab)
        d = base / f'kunfox_{e["nom"]}'; d.mkdir(exist_ok=True)
        (d / 'scene.rml').write_text(rml); (d / 'rive.yaml').write_text(f'name: kunfox_{e["nom"]}\n')
        print(d.name, len(rml))
        if '--apercus' in sys.argv:
            for nom in e['apercus']:
                r, _ = produire(fab, nom, fond='0E1730')
                d = base / 'apercus' / f'{e["nom"]}_{nom}'; d.mkdir(parents=True, exist_ok=True)
                (d / 'scene.rml').write_text(r); (d / 'rive.yaml').write_text(f'name: {e["nom"]}_{nom}\n')
    if '--svg' in sys.argv:
        dossier = pathlib.Path(sys.argv[sys.argv.index('--svg') + 1]); dossier.mkdir(parents=True, exist_ok=True)
        html = ['<html><body style="margin:0;background:#0E1730;color:#fff;font:12px sans-serif">']
        for fab in EFFETS:
            _, e = produire(fab); w, h = e['taille']
            for a in e['anims']:
                html.append(f'<div style="display:flex;align-items:center"><b style="width:80px">{a.nom}</b>')
                for k in range(8):
                    t = round(a.duree * k / 7)
                    html.append(f'<div>{svg(e["racine"], w, h, etat_a([(a, t)]), fond="0E1730", taille=130)}<br>{t}</div>')
                html.append('</div>')
        (dossier / 'effets.html').write_text(''.join(html) + '</body></html>')
        print('aperçu :', dossier / 'effets.html')
