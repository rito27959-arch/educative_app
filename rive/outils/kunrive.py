"""Petit outil maison pour écrire des scènes Rive (RML) à partir d'une description
Python, et pour en prévisualiser n'importe quelle image en SVG sans la Rive CLI.

Tout se décrit en coordonnées absolues « de dessin » ; l'outil calcule les
positions relatives que Rive attend (chaque groupe est placé à son pivot).

    G(nom, pivot, enfants, **transformations)   → <Node>
    F(nom, d=..., remplissage=..., trait=...)    → <Shape> + <PointsPath>
    E(nom, centre, largeur, hauteur, ...)        → <Shape> + <Ellipse>
    Etoile(nom, centre, taille, branches, ...)   → <Shape> + <Star>

Les chemins acceptent M, L, Q, C et Z (coordonnées absolues).
"""
import math, re

X, Y, ROT, SX, SY, OPA = 13, 14, 15, 16, 17, 18
CLES = {'x': X, 'y': Y, 'rotation': ROT, 'scaleX': SX, 'scaleY': SY, 'opacity': OPA}
# Propriétés d'un TrimPath (fin du tracé visible), clé Rive 115 ; vérifiée par `rive inspect`.
CLE_TRIM_FIN = 115

# Courbes d'accélération (x1, y1, x2, y2), comme en CSS.
SORTIE = (0.16, 1, 0.3, 1)          # rapide puis très doux, l'arrivée « Apple »
REBOND = (0.34, 1.56, 0.64, 1)      # léger dépassement
ELAN = (0.5, -0.6, 0.5, 1.4)        # recule avant de partir
DOUX = (0.42, 0, 0.58, 1)           # aller-retour
ENTREE = (0.42, 0, 1, 1)            # accélère (chute)
FREIN = (0, 0, 0.58, 1)             # ralentit (montée)
LINEAIRE = None


class Compteur:
    def __init__(self, depart=100):
        self.n = depart
    def __call__(self):
        self.n += 1
        return f'0:{self.n}'

nid = Compteur()


# ---------------------------------------------------------------- géométrie
def _jetons(d):
    return re.findall(r'[MLQCZ]|-?\d+(?:\.\d+)?', d)

def contours(d):
    """Chemin → liste de contours [(point, poignée_entrée, poignée_sortie)], fermé ?"""
    t = _jetons(d); i = 0; cmd = None
    tous = []; pts = []; ferme = False
    def f(k): return float(t[k])
    while i < len(t):
        if t[i] in 'MLQCZ':
            cmd = t[i]; i += 1
            if cmd == 'Z':
                ferme = True
                tous.append((pts, True)); pts = []
                continue
        if cmd == 'M':
            if pts: tous.append((pts, False))
            pts = [[(f(i), f(i+1)), None, None]]; i += 2; cmd = 'L'
        elif cmd == 'L':
            pts.append([(f(i), f(i+1)), None, None]); i += 2
        elif cmd == 'Q':
            p0 = pts[-1][0]; q = (f(i), f(i+1)); p = (f(i+2), f(i+3)); i += 4
            pts[-1][2] = (p0[0] + 2/3*(q[0]-p0[0]), p0[1] + 2/3*(q[1]-p0[1]))
            pts.append([p, (p[0] + 2/3*(q[0]-p[0]), p[1] + 2/3*(q[1]-p[1])), None])
        elif cmd == 'C':
            c1 = (f(i), f(i+1)); c2 = (f(i+2), f(i+3)); p = (f(i+4), f(i+5)); i += 6
            pts[-1][2] = c1
            pts.append([p, c2, None])
    if pts: tous.append((pts, False))
    propres = []
    for pts, fermé in tous:
        if fermé and len(pts) > 1 and math.dist(pts[0][0], pts[-1][0]) < 0.01:
            pts[0][1] = pts[-1][1]; pts = pts[:-1]
        propres.append((pts, fermé))
    return propres


def _hex(c):
    c = c.lstrip('#').upper()
    return ('FF' + c) if len(c) == 6 else c

def _rgba(c):
    c = _hex(c)
    a = int(c[:2], 16) / 255
    return f'#{c[2:]}', a


class Peinture:
    """Couleur pleine ou dégradé linéaire/radial (points en coordonnées absolues)."""
    def __init__(self, couleur=None, degrade=None, debut=None, fin=None, radial=False):
        self.couleur = couleur; self.degrade = degrade; self.debut = debut; self.fin = fin; self.radial = radial

def peinture(p):
    if p is None or isinstance(p, Peinture): return p
    return Peinture(couleur=p)

def Degrade(arrets, debut, fin, radial=False):
    return Peinture(degrade=arrets, debut=debut, fin=fin, radial=radial)


# ---------------------------------------------------------------- arbre
class Objet:
    def __init__(self, nom, pivot=(0, 0), **props):
        self.nom = nom; self.pivot = pivot
        self.id = nid()
        self.props = {k: props.pop(k) for k in list(props) if k in CLES}
        self.parent = None
    def base(self, cle):
        return self.props.get(cle, 1.0 if cle in ('scaleX', 'scaleY', 'opacity') else 0.0)


class G(Objet):
    def __init__(self, nom, pivot=(0, 0), enfants=(), **props):
        super().__init__(nom, pivot, **props)
        self.enfants = [e for e in enfants if e is not None]
        for e in self.enfants: e.parent = self


class Forme(Objet):
    def __init__(self, nom, pivot=(0, 0), remplissage=None, trait=None, epaisseur=0, trim=None, **props):
        super().__init__(nom, pivot, **props)
        self.remplissage = peinture(remplissage); self.trait = peinture(trait)
        self.epaisseur = epaisseur; self.trim = trim
        self.trim_id = nid() if trim is not None else None


class F(Forme):
    """Forme à chemin. `formes={'nom': d, ...}` en fait une forme qui se
    MORPHE : chaque sommet reçoit un id et peut être animé d'une forme à
    l'autre (même nombre de sommets partout), avec Anim.forme()."""
    def __init__(self, nom, d, pivot=None, formes=None, nom_base='base', **k):
        self.d = d
        cs = contours(d)
        if pivot is None:
            xs = [p[0][0] for c, _ in cs for p in c]; ys = [p[0][1] for c, _ in cs for p in c]
            pivot = ((min(xs) + max(xs)) / 2, (min(ys) + max(ys)) / 2)
        super().__init__(nom, pivot, **k)
        self.contours = cs
        self.formes = None
        if formes:
            self.nom_base = nom_base
            self.formes = {nom_base: self.params(cs)}
            for n, dd in formes.items():
                p = self.params(contours(dd))
                base = self.formes[nom_base]
                assert len(p) == len(base), f'{nom}/{n} : {len(p)} sommets au lieu de {len(base)}'
                self.formes[n] = _aligner(p, base)
            self.vids = [nid() for _ in self.formes[nom_base]]

    def params(self, cs):
        """Sommets → [(x, y, inRot, inDist, outRot, outDist)] relatifs au pivot."""
        out = []
        for pts, _ in cs:
            for (x, y), hi, ho in pts:
                def pol(h):
                    if h is None or math.dist(h, (x, y)) < 1e-6: return None, 0.0
                    return math.atan2(h[1] - y, h[0] - x), math.dist(h, (x, y))
                ir, idd = pol(hi); orr, od = pol(ho)
                out.append([x - self.pivot[0], y - self.pivot[1], ir, idd, orr, od])
        # une poignée nulle prend l'angle opposé à l'autre (ou 0) : pas de toupie
        for v in out:
            if v[2] is None: v[2] = (v[4] + math.pi) if v[4] is not None else 0.0
            if v[4] is None: v[4] = v[2] - math.pi
        return out


def _proche(a, ref):
    """L'angle a, ramené au tour le plus proche de ref (interpolation sans toupie)."""
    while a - ref > math.pi: a -= 2 * math.pi
    while a - ref < -math.pi: a += 2 * math.pi
    return a

def _aligner(p, base):
    return [[v[0], v[1], _proche(v[2], b[2]), v[3], _proche(v[4], b[4]), v[5]] for v, b in zip(p, base)]


class E(Forme):
    def __init__(self, nom, centre, largeur, hauteur, **k):
        super().__init__(nom, centre, **k); self.l = largeur; self.h = hauteur


class Etoile(Forme):
    def __init__(self, nom, centre, taille, branches=4, creux=0.35, arrondi=0, **k):
        super().__init__(nom, centre, **k); self.l = self.h = taille
        self.branches = branches; self.creux = creux; self.arrondi = arrondi


class Rect(Forme):
    def __init__(self, nom, centre, largeur, hauteur, rayon=0, **k):
        super().__init__(nom, centre, **k); self.l = largeur; self.h = hauteur; self.rayon = rayon


def parcourir(o):
    yield o
    for e in getattr(o, 'enfants', []):
        yield from parcourir(e)


# ---------------------------------------------------------------- RML
def _f(v):
    s = f'{v:.4f}'.rstrip('0').rstrip('.')
    return '0' if s in ('-0', '') else s

def _transfo(o, parent_pivot):
    a = {'x': o.pivot[0] - parent_pivot[0], 'y': o.pivot[1] - parent_pivot[1]}
    for k, v in o.props.items():
        if k in ('x', 'y'): a[k] += v
        else: a[k] = v
    return ' '.join(f'{k}="{_f(v)}"' for k, v in a.items() if not (k in ('x', 'y') and abs(v) < 1e-9))

def _peinture_rml(p, pivot):
    if p.couleur is not None:
        return f'<SolidColor colorValue="{_hex(p.couleur)}" name="C"/>'
    balise = 'RadialGradient' if p.radial else 'LinearGradient'
    arrets = ''.join(f'<GradientStop colorValue="{_hex(c)}" position="{_f(pos)}"/>' for pos, c in p.degrade)
    (sx, sy), (ex, ey) = p.debut, p.fin
    return (f'<{balise} startX="{_f(sx - pivot[0])}" startY="{_f(sy - pivot[1])}" '
            f'endX="{_f(ex - pivot[0])}" endY="{_f(ey - pivot[1])}" name="D">{arrets}</{balise}>')

def _sommet(p, pivot):
    (x, y), hi, ho = p
    x0, y0 = x - pivot[0], y - pivot[1]
    if hi is None and ho is None:
        return f'<StraightVertex x="{_f(x0)}" y="{_f(y0)}"/>'
    def pol(h):
        if h is None or math.dist(h, (x, y)) < 1e-6: return 0.0, 0.0
        return math.atan2(h[1] - y, h[0] - x), math.dist(h, (x, y))
    ir, idd = pol(hi); orr, od = pol(ho)
    return (f'<CubicDetachedVertex x="{_f(x0)}" y="{_f(y0)}" inRotation="{_f(ir)}" inDistance="{_f(idd)}" '
            f'outRotation="{_f(orr)}" outDistance="{_f(od)}"/>')

def rml_objet(o, parent_pivot=(0, 0), ind='    '):
    t = _transfo(o, parent_pivot)
    if isinstance(o, G):
        corps = '\n'.join(rml_objet(e, o.pivot, ind + '  ') for e in o.enfants)
        return f'{ind}<Node {t} name="{o.nom}" id="{o.id}">\n{corps}\n{ind}</Node>'
    geo = ''
    if isinstance(o, F) and o.formes:
        k = 0
        for pts, ferme in o.contours:
            som = ''
            for _ in pts:
                x, y, ir, idd, orr, od = o.formes[o.nom_base][k]
                som += (f'<CubicDetachedVertex x="{_f(x)}" y="{_f(y)}" inRotation="{_f(ir)}" inDistance="{_f(idd)}" '
                        f'outRotation="{_f(orr)}" outDistance="{_f(od)}" id="{o.vids[k]}"/>')
                k += 1
            geo += f'<PointsPath isClosed="{"true" if ferme else "false"}" name="P">{som}</PointsPath>'
    elif isinstance(o, F):
        for pts, ferme in o.contours:
            som = ''.join(_sommet(p, o.pivot) for p in pts)
            geo += f'<PointsPath isClosed="{"true" if ferme else "false"}" name="P">{som}</PointsPath>'
    elif isinstance(o, E):
        geo = f'<Ellipse width="{_f(o.l)}" height="{_f(o.h)}" name="P"/>'
    elif isinstance(o, Etoile):
        geo = (f'<Star width="{_f(o.l)}" height="{_f(o.h)}" points="{o.branches}" innerRadius="{_f(o.creux)}" '
               f'cornerRadius="{_f(o.arrondi)}" name="P"/>')
    elif isinstance(o, Rect):
        r = _f(o.rayon)
        geo = (f'<Rectangle width="{_f(o.l)}" height="{_f(o.h)}" cornerRadiusTL="{r}" cornerRadiusTR="{r}" '
               f'cornerRadiusBL="{r}" cornerRadiusBR="{r}" name="P"/>')
    pt = ''
    if o.remplissage:
        pt += f'<Fill name="Fill">{_peinture_rml(o.remplissage, o.pivot)}</Fill>'
    if o.trait:
        trim = ''
        if o.trim is not None:
            trim = f'<TrimPath start="0" end="{_f(o.trim)}" offset="0" name="Trim" id="{o.trim_id}"/>'
        pt += (f'<Stroke thickness="{_f(o.epaisseur)}" cap="round" join="round" name="Stroke">'
               f'{_peinture_rml(o.trait, o.pivot)}{trim}</Stroke>')
    return f'{ind}<Shape {t} name="{o.nom}" id="{o.id}">{geo}{pt}</Shape>'


# ---------------------------------------------------------------- animations
class Anim:
    """Une LinearAnimation. `pistes[(objet, prop)] = [(image, valeur, courbe), ...]`
    où `courbe` (x1,y1,x2,y2) ou None (linéaire) ou 'hold' gouverne le segment qui suit."""
    def __init__(self, nom, duree, boucle=True):
        self.nom = nom; self.duree = duree; self.boucle = boucle
        self.id = nid(); self.pistes = {}
    def cle(self, objet, prop, *images):
        self.pistes[(objet, prop)] = list(images)
        return self
    def forme(self, objet, *images):
        """Morph : images = (image, nom_de_forme, courbe), ..."""
        self.pistes[(objet, 'forme')] = list(images)
        return self

    def fixe(self, objet, prop, valeur):
        self.pistes[(objet, prop)] = [(0, valeur, 'hold')]
        return self

def _kf(image, valeur, courbe):
    if courbe == 'hold':
        return f'<KeyFrameDouble value="{_f(valeur)}" frame="{image}" interpolationType="hold"/>'
    if courbe is None:
        return f'<KeyFrameDouble value="{_f(valeur)}" frame="{image}" interpolationType="linear"/>'
    x1, y1, x2, y2 = courbe
    return (f'<KeyFrameDouble value="{_f(valeur)}" frame="{image}" interpolationType="cubic">'
            f'<CubicEaseInterpolator x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}"/></KeyFrameDouble>')

def rml_anim(a):
    par_objet = {}
    for (o, p), imgs in a.pistes.items():
        if p == 'forme':
            # un KeyedObject par sommet, six propriétés chacun
            for k, vid in enumerate(o.vids):
                for j, cle in enumerate((24, 25, 84, 85, 86, 87)):
                    par_objet.setdefault(vid, []).append(
                        (cle, [(f, o.formes[n][k][j], c) for f, n, c in imgs]))
        elif p == 'trim':
            par_objet.setdefault(o.trim_id, []).append((CLE_TRIM_FIN, imgs))
        else:
            if p in ('x', 'y'):
                # les valeurs animées de x/y sont des décalages depuis le pivot
                i = 0 if p == 'x' else 1
                pp = o.parent.pivot if o.parent else (0, 0)
                dec = o.pivot[i] - pp[i]
                imgs = [(f, val + dec, c) for f, val, c in imgs]
            par_objet.setdefault(o.id, []).append((CLES[p], imgs))
    corps = ''
    for oid, props in par_objet.items():
        kp = ''.join(f'<KeyedProperty propertyKey="{k}">{"".join(_kf(*i) for i in imgs)}</KeyedProperty>' for k, imgs in props)
        corps += f'\n      <KeyedObject objectId="{oid}">{kp}</KeyedObject>'
    return (f'    <LinearAnimation loopValue="{"loop" if a.boucle else "oneShot"}" duration="{a.duree}" '
            f'fps="60" name="{a.nom}" id="{a.id}">{corps}\n    </LinearAnimation>')


# ---------------------------------------------------------------- machine à états
class Etat:
    def __init__(self, anim):
        self.anim = anim; self.id = nid(); self.transitions = []
    def vers(self, autre, *conditions, fin=False, duree=0):
        self.transitions.append((autre, conditions, fin, duree)); return self

class Couche:
    def __init__(self, nom, entree, etats):
        self.nom = nom; self.entree = entree; self.etats = etats; self.id = nid()

class Entree:
    """Entrée (dépréciée mais universelle) de la machine : 'nombre', 'declencheur' ou 'booleen'."""
    def __init__(self, nom, genre, valeur=0):
        self.nom = nom; self.genre = genre; self.valeur = valeur; self.id = nid()

def egal(entree, valeur): return ('num', entree, 'equal', valeur)
def different(entree, valeur): return ('num', entree, 'notEqual', valeur)
def declenche(entree): return ('trig', entree)

def _cond(c):
    if c[0] == 'num':
        return f'<TransitionNumberCondition inputId="{c[1].id}" opValue="{c[2]}" value="{_f(c[3])}"/>'
    return f'<TransitionTriggerCondition inputId="{c[1].id}"/>'

def rml_machine(nom, mid, entrees, couches):
    genres = {'nombre': 'StateMachineNumber', 'declencheur': 'StateMachineTrigger', 'booleen': 'StateMachineBool'}
    ent = ''.join(f'\n      <{genres[e.genre]} name="{e.nom}"'
                  + (f' value="{_f(e.valeur)}"' if e.genre == 'nombre' and e.valeur else '')
                  + f' id="{e.id}"/>' for e in entrees)
    cs = ''
    for c in couches:
        etats = ''
        for i, e in enumerate(c.etats):
            tr = ''
            for (autre, conds, fin, duree) in e.transitions:
                attrs = f' stateToId="{autre.id}"'
                if duree: attrs += f' duration="{duree}"'
                if fin: attrs += ' enableExitTime="true" exitTimeIsPercetange="true" exitTime="100"'
                tr += f'<StateTransition{attrs}>{"".join(_cond(x) for x in conds)}</StateTransition>'
            etats += f'\n        <AnimationState x="{200 + 180 * i}" y="{(i % 2) * 120}" animationId="{e.anim.id}" id="{e.id}">{tr}</AnimationState>'
        cs += (f'\n      <StateMachineLayer name="{c.nom}" id="{c.id}">'
               f'\n        <AnyState x="200" y="-160"/><ExitState x="600" y="-160"/>'
               f'<EntryState x="0" y="0"><StateTransition stateToId="{c.entree.id}"/></EntryState>{etats}'
               f'\n      </StateMachineLayer>')
    return f'    <StateMachine name="{nom}" id="{mid}">{ent}{cs}\n    </StateMachine>'


def scene(nom_artboard, largeur, hauteur, racine, anims, machine_nom, entrees, couches, fond=None):
    mid = nid()
    f = f'\n    <Fill name="Fond"><SolidColor colorValue="{_hex(fond)}" name="C"/></Fill>' if fond else ''
    return (f'<Rive version="1" kind="fragment">\n'
            f'  <Artboard defaultStateMachineId="{mid}" styleId="0:5" width="{largeur}" height="{hauteur}" '
            f'name="{nom_artboard}" id="0:2">\n    <LayoutComponentStyle name="Style" id="0:5"/>{f}\n'
            f'{rml_objet(racine)}\n'
            f'{rml_machine(machine_nom, mid, entrees, couches)}\n'
            + '\n'.join(rml_anim(a) for a in anims) +
            '\n  </Artboard>\n</Rive>\n')


# ---------------------------------------------------------------- aperçu SVG
def _bezier(t, a, b):
    return 3 * a * t * (1 - t) ** 2 + 3 * b * t * t * (1 - t) + t ** 3

def _ease(courbe, u):
    if courbe is None: return u
    x1, y1, x2, y2 = courbe
    lo, hi = 0.0, 1.0
    for _ in range(40):
        m = (lo + hi) / 2
        if _bezier(m, x1, x2) < u: lo = m
        else: hi = m
    return _bezier((lo + hi) / 2, y1, y2)

def valeur(images, t):
    if t <= images[0][0]: return images[0][1]
    for (f0, v0, c0), (f1, v1, _) in zip(images, images[1:]):
        if f0 <= t <= f1:
            if c0 == 'hold': return v0 if t < f1 else v1
            u = (t - f0) / (f1 - f0) if f1 > f0 else 1
            return v0 + (v1 - v0) * _ease(c0, u)
    return images[-1][1]

def _forme_a(o, imgs, t):
    def lerp(a, b, u): return [x + (y - x) * u for x, y in zip(a, b)]
    P = o.formes
    if t <= imgs[0][0]: return P[imgs[0][1]]
    for (f0, n0, c0), (f1, n1, _) in zip(imgs, imgs[1:]):
        if f0 <= t <= f1:
            if c0 == 'hold': return P[n0] if t < f1 else P[n1]
            u = _ease(c0, (t - f0) / (f1 - f0)) if f1 > f0 else 1
            return [lerp(a, b, u) for a, b in zip(P[n0], P[n1])]
    return P[imgs[-1][1]]

def etat_a(anims_et_temps):
    """[(anim, image), ...] dans l'ordre des couches → {(objet, prop): valeur}"""
    v = {}
    for a, t in anims_et_temps:
        for k, imgs in a.pistes.items():
            v[k] = _forme_a(k[0], imgs, t) if k[1] == 'forme' else valeur(imgs, t)
    return v

def _pt(p, pv): return f'{_f(p[0] - pv[0])} {_f(p[1] - pv[1])}'

def _svg_morph(o, params):
    d = ''; k = 0
    for pts, ferme in o.contours:
        n = len(pts); vs = params[k:k + n]; k += n
        def pt(v): return f'{_f(v[0])} {_f(v[1])}'
        def h(v, entree):
            a, dist = (v[2], v[3]) if entree else (v[4], v[5])
            return (v[0] + math.cos(a) * dist, v[1] + math.sin(a) * dist)
        d += f'M{pt(vs[0])}'
        for i in range(1, n + (1 if ferme else 0)):
            a = vs[i - 1]; b = vs[i % n]
            d += f'C{pt(h(a, False))} {pt(h(b, True))} {pt(b)}'
        if ferme: d += 'Z'
    return d

def _svg_chemin(o):
    d = ''
    for pts, ferme in o.contours:
        n = len(pts)
        d += f'M{_pt(pts[0][0], o.pivot)}'
        for k in range(1, n + (1 if ferme else 0)):
            a = pts[k - 1]; b = pts[k % n]
            if a[2] is None and b[1] is None:
                d += f'L{_pt(b[0], o.pivot)}'
            else:
                c1 = a[2] or a[0]; c2 = b[1] or b[0]
                d += f'C{_pt(c1, o.pivot)} {_pt(c2, o.pivot)} {_pt(b[0], o.pivot)}'
        if ferme: d += 'Z'
    return d

_GID = 0
def _svg_peinture(p, pivot, defs):
    if p.couleur is not None:
        c, a = _rgba(p.couleur)
        return c, a
    global _GID
    _GID += 1; gid = f'g{_GID}'
    arrets = ''
    for pos, c in p.degrade:
        cc, aa = _rgba(c); arrets += f'<stop offset="{pos}" stop-color="{cc}" stop-opacity="{aa:.3f}"/>'
    (sx, sy), (ex, ey) = p.debut, p.fin
    if p.radial:
        r = math.dist((sx, sy), (ex, ey))
        defs.append(f'<radialGradient id="{gid}" gradientUnits="userSpaceOnUse" cx="{sx - pivot[0]}" cy="{sy - pivot[1]}" r="{r}">{arrets}</radialGradient>')
    else:
        defs.append(f'<linearGradient id="{gid}" gradientUnits="userSpaceOnUse" x1="{sx - pivot[0]}" y1="{sy - pivot[1]}" x2="{ex - pivot[0]}" y2="{ey - pivot[1]}">{arrets}</linearGradient>')
    return f'url(#{gid})', 1

def _etoile(o):
    n = o.branches; r = o.l / 2; ri = r * o.creux; pts = []
    for i in range(2 * n):
        rr = r if i % 2 == 0 else ri; a = -math.pi / 2 + i * math.pi / n
        pts.append(f'{rr * math.cos(a):.2f},{rr * math.sin(a):.2f}')
    return 'M' + ' L'.join(pts) + 'Z'

def svg_objet(o, v, parent_pivot, defs):
    def val(p): return v.get((o, p), o.base(p))
    x = o.pivot[0] - parent_pivot[0] + val('x'); y = o.pivot[1] - parent_pivot[1] + val('y')
    tr = f'translate({x:.2f} {y:.2f}) rotate({math.degrees(val("rotation")):.3f}) scale({val("scaleX"):.4f} {val("scaleY"):.4f})'
    op = val('opacity')
    if op <= 0.001: return ''
    if isinstance(o, G):
        corps = ''.join(svg_objet(e, v, o.pivot, defs) for e in reversed(o.enfants))
        return f'<g transform="{tr}" opacity="{op:.3f}">{corps}</g>'
    if isinstance(o, F) and o.formes: d = _svg_morph(o, v.get((o, 'forme'), o.formes[o.nom_base]))
    elif isinstance(o, F): d = _svg_chemin(o)
    elif isinstance(o, E): d = None
    elif isinstance(o, Etoile): d = _etoile(o)
    else: d = None
    attrs = ''
    if o.remplissage:
        c, a = _svg_peinture(o.remplissage, o.pivot, defs); attrs += f' fill="{c}" fill-opacity="{a:.3f}"'
    else: attrs += ' fill="none"'
    if o.trait:
        c, a = _svg_peinture(o.trait, o.pivot, defs)
        attrs += f' stroke="{c}" stroke-opacity="{a:.3f}" stroke-width="{o.epaisseur}" stroke-linecap="round" stroke-linejoin="round"'
        if o.trim is not None:
            fin = v.get((o, 'trim'), o.trim)
            attrs += f' pathLength="1" stroke-dasharray="{max(fin, 0.0001):.4f} 2"'
    if isinstance(o, E):
        forme = f'<ellipse cx="0" cy="0" rx="{o.l / 2}" ry="{o.h / 2}"{attrs}/>'
    elif isinstance(o, Rect):
        forme = f'<rect x="{-o.l / 2}" y="{-o.h / 2}" width="{o.l}" height="{o.h}" rx="{o.rayon}"{attrs}/>'
    else:
        forme = f'<path d="{d}"{attrs}/>'
    return f'<g transform="{tr}" opacity="{op:.3f}">{forme}</g>'

def svg(racine, largeur, hauteur, valeurs, fond=None, taille=None):
    defs = []
    corps = svg_objet(racine, valeurs, (0, 0), defs)
    f = f'<rect width="{largeur}" height="{hauteur}" fill="{_rgba(fond)[0]}"/>' if fond else ''
    w = f' width="{taille}"' if taille else ''
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {largeur} {hauteur}"{w}>'
            f'<defs>{"".join(defs)}</defs>{f}{corps}</svg>')
