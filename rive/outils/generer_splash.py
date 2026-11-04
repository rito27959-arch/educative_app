"""Génère rive/kunfox_splash/scene.rml : l'écran d'ouverture de Kunfox.

Le renard (dessin original de Kunfox, mêmes tracés que l'icône) est décrit
en coordonnées 1024 ; on convertit ses courbes quadratiques en sommets Rive
(CubicDetachedVertex), centrés sur le visage.

Lancer : python3 rive/outils/generer_splash.py
"""
import math, re, pathlib

CX, CY = 512, 560            # centre du visage, en coordonnées 1024
ECHELLE = 0.30               # 1024 → ~300 px sur l'artboard
NUIT, ORANGE, ORANGE_F, CREME, OR = '0E1730', 'FF6B2B', 'E04E14', 'FFF4E8', 'FFC24B'

ids = iter(range(100, 10000))
def nid(): return f'0:{next(ids)}'

def jetons(d):
    return re.findall(r'[MQLZ]|-?\d+(?:\.\d+)?', d)

def segments(d, dx=0, dy=0):
    """Chemin SVG (M, Q, L, Z) → liste de (point, contrôle_quadratique_ou_None)."""
    t = jetons(d); i = 0; pts = []; cmd = None
    while i < len(t):
        if t[i] in 'MQLZ':
            cmd = t[i]; i += 1
            if cmd == 'Z': continue
        if cmd == 'M':
            pts.append(((float(t[i]) + dx, float(t[i+1]) + dy), None)); i += 2; cmd = 'L'
        elif cmd == 'L':
            pts.append(((float(t[i]) + dx, float(t[i+1]) + dy), None)); i += 2
        elif cmd == 'Q':
            q = (float(t[i]) + dx, float(t[i+1]) + dy); p = (float(t[i+2]) + dx, float(t[i+3]) + dy)
            pts.append((p, q)); i += 4
    return pts

def sommets(d, ferme=True, dx=0, dy=0):
    s = segments(d, dx, dy)
    if ferme and len(s) > 1 and math.dist(s[0][0], s[-1][0]) < 0.01:
        # le dernier point revient au premier : sa courbe d'arrivée est celle du premier
        s[0] = (s[0][0], s[-1][1]); s = s[:-1]
    n = len(s); out = []
    for k in range(n):
        p, q_arrivee = s[k]
        prec = s[k - 1][0]
        suiv = s[(k + 1) % n] if (ferme or k + 1 < n) else None
        h_in = (p[0] + 2/3 * (q_arrivee[0] - p[0]), p[1] + 2/3 * (q_arrivee[1] - p[1])) if (q_arrivee and (ferme or k > 0)) else None
        h_out = None
        if suiv and suiv[1]:
            q = suiv[1]; h_out = (p[0] + 2/3 * (q[0] - p[0]), p[1] + 2/3 * (q[1] - p[1]))
        x, y = p[0] - CX, p[1] - CY
        if not h_in and not h_out:
            out.append(f'<StraightVertex x="{x:.2f}" y="{y:.2f}"/>')
        else:
            def pol(h):
                if not h: return 0.0, 0.0
                return math.atan2(h[1] - p[1], h[0] - p[0]), math.dist(h, p)
            ir, idist = pol(h_in); orr, odist = pol(h_out)
            out.append(f'<CubicDetachedVertex x="{x:.2f}" y="{y:.2f}" inRotation="{ir:.5f}" inDistance="{idist:.2f}" outRotation="{orr:.5f}" outDistance="{odist:.2f}"/>')
    return out

def forme(nom, d, couleur=None, trait=None, ferme=True, dx=0, dy=0, sid=None):
    v = '\n        '.join(sommets(d, ferme, dx, dy))
    peinture = ''
    if couleur: peinture += f'<Fill name="Fill"><SolidColor colorValue="FF{couleur}" name="C"/></Fill>'
    if trait: peinture += f'<Stroke thickness="{trait[1]}" cap="round" join="round" name="Stroke"><SolidColor colorValue="FF{trait[0]}" name="C"/></Stroke>'
    idattr = f' id="{sid}"' if sid else ''
    return f'''<Shape name="{nom}"{idattr}>
      <PointsPath isClosed="{'true' if ferme else 'false'}" name="Path">
        {v}
      </PointsPath>
      {peinture}
    </Shape>'''

def ellipse(nom, x, y, w, h, couleur):
    return f'<Shape x="{x - CX}" y="{y - CY}" name="{nom}"><Ellipse width="{w}" height="{h}" name="Path"/><Fill name="Fill"><SolidColor colorValue="FF{couleur}" name="C"/></Fill></Shape>'

DY = 30  # le dessin de l'icône est décalé de 30 vers le bas
TETE = 'M300 210 Q332 330 400 392 Q456 372 512 372 Q568 372 624 392 Q692 330 724 210 Q800 300 812 450 Q850 520 836 572 Q700 700 512 812 Q324 700 188 572 Q174 520 212 450 Q224 300 300 210 Z'
OREILLE_G = 'M312 268 Q340 352 384 392 Q320 420 268 452 Q270 340 312 268 Z'
OREILLE_D = 'M712 268 Q684 352 640 392 Q704 420 756 452 Q754 340 712 268 Z'
MASQUE = 'M188 572 Q300 530 400 590 Q456 624 512 700 Q568 624 624 590 Q724 530 836 572 Q700 700 512 812 Q324 700 188 572 Z'
TRUFFE = 'M474 664 Q512 650 550 664 Q544 702 512 718 Q480 702 474 664 Z'
SOURIRE = 'M482 748 Q512 770 542 748'

# La toque, dessinée autour de son propre centre (posée sur l'oreille droite).
TOQUE_X, TOQUE_Y = 700, 230
def toque_local(d):  # coordonnées locales à la toque (avant sa rotation)
    return d
PLATEAU = 'M-130 -60 L0 -120 L130 -60 L0 0 Z'
CALOTTE = 'M-70 -28 L-70 20 Q0 52 70 20 L70 -28 L0 4 Z'
CORDON = 'M0 -60 L102 -28 L102 50'

ID = {k: nid() for k in ['renard', 'echelle', 'yeux', 'toque', 'sm', 'couche', 'etat_entree', 'etat_attente', 'anim_entree', 'anim_attente',
                         'e1', 'e2', 'e3', 'e4']}

def toque():
    def f(nom, d, ferme=True, couleur=None):
        # pour la toque, l'origine des sommets est le centre de la toque : on compense CX/CY
        return forme(nom, d, couleur, (NUIT, 10), ferme, dx=CX, dy=CY)
    return f'''<Node x="{TOQUE_X - CX}" y="{TOQUE_Y + DY - CY}" rotation="0.24" name="Toque" id="{ID['toque']}">
    <Shape x="102" y="56" name="Pompon"><Ellipse width="28" height="28" name="Path"/><Fill name="Fill"><SolidColor colorValue="FF{OR}" name="C"/></Fill></Shape>
    {forme('Cordon', CORDON, None, (OR, 10), False, dx=CX, dy=CY)}
    {f('Plateau', PLATEAU, couleur=CREME)}
    {f('Calotte', CALOTTE, couleur=CREME)}
  </Node>'''

def etincelle(i, x, y, taille):
    return f'''<Shape x="{x}" y="{y}" scaleX="0" scaleY="0" name="Etincelle {i}" id="{ID['e' + str(i)]}">
      <Star width="{taille}" height="{taille}" points="4" innerRadius="0.32" cornerRadius="1" name="Path"/>
      <Fill name="Fill"><SolidColor colorValue="FF{OR}" name="C"/></Fill>
    </Shape>'''

def kf(valeur, frame, interp='linear', courbe=None):
    if courbe:
        x1, y1, x2, y2 = courbe
        return f'<KeyFrameDouble value="{valeur}" frame="{frame}" interpolationType="cubic"><CubicEaseInterpolator x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}"/></KeyFrameDouble>'
    return f'<KeyFrameDouble value="{valeur}" frame="{frame}" interpolationType="{interp}"/>'

def piste(obj, cle, images):
    return f'<KeyedObject objectId="{obj}"><KeyedProperty propertyKey="{cle}">{"".join(images)}</KeyedProperty></KeyedObject>'

SORTIE = (0.16, 1, 0.3, 1)
REBOND = (0.34, 1.56, 0.64, 1)
ENTREE_DOUCE = (0.42, 0, 1, 1)
ALLER_RETOUR = (0.42, 0, 0.58, 1)
X, Y, ROT, SX, SY, OPA = 13, 14, 15, 16, 17, 18
TY = TOQUE_Y + DY - CY

entree = [
    piste(ID['renard'], OPA, [kf(0, 0, courbe=SORTIE), kf(1, 14)]),
    piste(ID['renard'], SX, [kf(0.2, 0, courbe=REBOND), kf(1, 40)]),
    piste(ID['renard'], SY, [kf(0.2, 0, courbe=REBOND), kf(1, 40)]),
    piste(ID['renard'], ROT, [kf(-0.35, 0, courbe=SORTIE), kf(0, 44)]),
    # la toque tombe du ciel, rebondit une fois et se pose
    piste(ID['toque'], OPA, [kf(0, 0, 'hold'), kf(1, 30)]),
    piste(ID['toque'], Y, [kf(TY - 1100, 0, 'hold'), kf(TY - 1100, 30, courbe=ENTREE_DOUCE), kf(TY, 50, courbe=(0, 0, 0.58, 1)), kf(TY - 70, 58, courbe=ENTREE_DOUCE), kf(TY, 66)]),
    piste(ID['toque'], ROT, [kf(0.9, 30, courbe=SORTIE), kf(0.24, 66)]),
    # il cligne des yeux
    piste(ID['yeux'], SY, [kf(1, 0, 'hold'), kf(1, 84, courbe=ALLER_RETOUR), kf(0.08, 90, courbe=ALLER_RETOUR), kf(1, 97)]),
]
for i, debut in zip(range(1, 5), [64, 70, 76, 82]):
    for cle in (SX, SY):
        entree.append(piste(ID['e' + str(i)], cle, [kf(0, 0, 'hold'), kf(0, debut, courbe=REBOND), kf(1, debut + 12, courbe=ENTREE_DOUCE), kf(0, debut + 30)]))
    entree.append(piste(ID['e' + str(i)], ROT, [kf(0, debut), kf(1.6, debut + 30)]))

attente = [
    piste(ID['renard'], SX, [kf(1, 0, courbe=ALLER_RETOUR), kf(1.035, 90, courbe=ALLER_RETOUR), kf(1, 180)]),
    piste(ID['renard'], SY, [kf(1, 0, courbe=ALLER_RETOUR), kf(1.035, 90, courbe=ALLER_RETOUR), kf(1, 180)]),
    piste(ID['yeux'], SY, [kf(1, 0, 'hold'), kf(1, 130, courbe=ALLER_RETOUR), kf(0.08, 136, courbe=ALLER_RETOUR), kf(1, 143)]),
    piste(ID['toque'], ROT, [kf(0.24, 0, courbe=ALLER_RETOUR), kf(0.32, 90, courbe=ALLER_RETOUR), kf(0.24, 180)]),
]

YEUX_Y = 528 + DY
scene = f'''<Rive version="1" kind="fragment">
  <Artboard defaultStateMachineId="{ID['sm']}" styleId="0:5" width="400" height="800" name="Ouverture" id="0:2">
    <LayoutComponentStyle name="Style" id="0:5"/>
    <Fill name="Fond"><SolidColor colorValue="FF{NUIT}" name="C"/></Fill>

    {etincelle(1, 92, 250, 26)}
    {etincelle(2, 312, 232, 20)}
    {etincelle(3, 70, 420, 16)}
    {etincelle(4, 330, 430, 24)}

    <Node x="200" y="360" opacity="0" scaleX="0.2" scaleY="0.2" name="Renard" id="{ID['renard']}">
      <Node scaleX="{ECHELLE}" scaleY="{ECHELLE}" name="Echelle" id="{ID['echelle']}">
        {toque()}
        <Node y="{YEUX_Y - CY}" name="Yeux" id="{ID['yeux']}">
          {ellipse('Reflet G', 416, 512 + DY - (YEUX_Y - CY), 24, 24, 'FFFFFF')}
          {ellipse('Reflet D', 632, 512 + DY - (YEUX_Y - CY), 24, 24, 'FFFFFF')}
          {ellipse('Oeil G', 404, CY, 68, 80, NUIT)}
          {ellipse('Oeil D', 620, CY, 68, 80, NUIT)}
        </Node>
        {forme('Truffe', TRUFFE, NUIT, dy=DY)}
        {forme('Sourire', SOURIRE, None, (NUIT, 12), False, dy=DY)}
        {forme('Masque', MASQUE, CREME, dy=DY)}
        {forme('Oreille G', OREILLE_G, ORANGE_F, dy=DY)}
        {forme('Oreille D', OREILLE_D, ORANGE_F, dy=DY)}
        {forme('Tete', TETE, ORANGE, dy=DY)}
      </Node>
    </Node>

    <StateMachine name="Ouverture" id="{ID['sm']}">
      <StateMachineLayer name="Couche" id="{ID['couche']}">
        <AnyState x="200" y="-120"/><ExitState x="400" y="-120"/><EntryState x="0" y="0"><StateTransition stateToId="{ID['etat_entree']}"/></EntryState>
        <AnimationState x="200" y="0" animationId="{ID['anim_entree']}" id="{ID['etat_entree']}">
          <StateTransition stateToId="{ID['etat_attente']}" enableExitTime="true" exitTimeIsPercetange="true" exitTime="100"/>
        </AnimationState>
        <AnimationState x="400" y="0" animationId="{ID['anim_attente']}" id="{ID['etat_attente']}"/>
      </StateMachineLayer>
    </StateMachine>

    <LinearAnimation loopValue="oneShot" duration="120" name="Entree" id="{ID['anim_entree']}">
      {''.join(entree)}
    </LinearAnimation>
    <LinearAnimation loopValue="loop" duration="180" name="Attente" id="{ID['anim_attente']}">
      {''.join(attente)}
    </LinearAnimation>
  </Artboard>
</Rive>
'''
racine = pathlib.Path(__file__).resolve().parent.parent
(racine / 'kunfox_splash' / 'scene.rml').write_text(scene)
print('scene.rml écrit,', len(scene), 'caractères')
