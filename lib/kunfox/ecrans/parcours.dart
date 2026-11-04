// ============================================================================
// LE PARCOURS — l'écran principal de Kunfox.
// ----------------------------------------------------------------------------
// Chaque chapitre de la matière est une « unité » : une bannière de couleur,
// puis ses leçons en pastilles rondes posées sur un chemin qui serpente.
//   • leçon faite       : pastille pleine, coche
//   • leçon à faire     : pastille avec anneau, bulle « COMMENCER » qui
//                         flotte, Kunfox assis à côté
//   • leçon verrouillée : pastille grise, cadenas
// Au bout de chaque unité, le trophée ouvre l'épreuve du chapitre.
// Derrière : le ciel Flame en parallaxe. Toucher une pastille ouvre sa carte.
// ============================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/curriculum_models.dart';
import '../../shared/widgets/kunfox/kunfox_rive.dart';
import '../composants/barre_haut.dart';
import '../composants/bouton.dart';
import '../donnees/matieres.dart';
import '../donnees/progression.dart';
import '../flame/effets_flame.dart';
import '../theme/palette.dart';

const double _kNoeud = 74;
const double _kPas = 104;
const List<double> _kSinueux = [0, -0.55, -0.85, -0.55, 0, 0.55, 0.85, 0.55];

class ParcoursEcran extends ConsumerStatefulWidget {
  const ParcoursEcran({super.key});

  @override
  ConsumerState<ParcoursEcran> createState() => _ParcoursEcranState();
}

class _ParcoursEcranState extends ConsumerState<ParcoursEcran> {
  final _defilement = ScrollController();
  final _cleActuelle = GlobalKey();
  bool _actuelleVisible = true;
  String? _ouverte; // la pastille dont la carte est ouverte

  @override
  void initState() {
    super.initState();
    _defilement.addListener(_surDefilement);
    WidgetsBinding.instance.addPostFrameCallback((_) => _allerALaLecon(anime: false));
  }

  @override
  void dispose() {
    _defilement.dispose();
    super.dispose();
  }

  void _surDefilement() {
    final ctx = _cleActuelle.currentContext;
    if (ctx == null) {
      if (_actuelleVisible) setState(() => _actuelleVisible = false);
      return;
    }
    final boite = ctx.findRenderObject() as RenderBox?;
    if (boite == null || !boite.attached) return;
    final y = boite.localToGlobal(Offset.zero).dy;
    final h = MediaQuery.of(context).size.height;
    final visible = y > 60 && y < h - 120;
    if (visible != _actuelleVisible) setState(() => _actuelleVisible = visible);
  }

  void _allerALaLecon({bool anime = true}) {
    final ctx = _cleActuelle.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.45,
      duration: anime ? const Duration(milliseconds: 600) : Duration.zero,
      curve: const Cubic(0.16, 1, 0.3, 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final matiere = ref.watch(matiereActiveProvider);
    final prog = ref.watch(progressionProvider);

    if (matiere == null) {
      return Center(child: Text('Aucune matière pour ta série', style: TextStyle(color: p.doux)));
    }
    final chapitres = [...matiere.chapters]..sort((a, b) => a.order.compareTo(b.order));
    final actuelle = leconActuelle(matiere, prog);

    return Column(children: [
      const BarreHaut(),
      Expanded(
        child: Stack(children: [
          Positioned.fill(child: CielFlame(defilement: _defilement, sombre: p.sombre, couleur: p.sombre ? p.or : p.prim)),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => setState(() => _ouverte = null),
            child: ListView.builder(
              controller: _defilement,
              padding: const EdgeInsets.only(top: 16, bottom: 140),
              itemCount: chapitres.length,
              itemBuilder: (context, i) {
                final c = chapitres[i];
                final couleur = p.unites[i % p.unites.length];
                // une unité s'ouvre quand la précédente est finie
                final ouverte = i == 0 || chapitres[i - 1].lessons.every((l) => prog.leconsFaites.contains(l.id));
                return _Unite(
                  numero: i + 1,
                  chapitre: c,
                  couleur: couleur,
                  matiere: matiere,
                  progression: prog,
                  actuelle: actuelle,
                  accessible: ouverte,
                  cleActuelle: _cleActuelle,
                  ouverte: _ouverte,
                  surOuvrir: (id) => setState(() => _ouverte = _ouverte == id ? null : id),
                );
              },
            ),
          ),
          // Le bouton pour revenir à la leçon du moment quand elle est hors de l'écran.
          Positioned(
            right: 16,
            bottom: 20,
            child: AnimatedScale(
              scale: _actuelleVisible || actuelle == null ? 0 : 1,
              duration: const Duration(milliseconds: 260),
              curve: const Cubic(0.34, 1.56, 0.64, 1),
              child: Material(
                color: p.surface,
                shape: CircleBorder(side: BorderSide(color: p.bord, width: 2)),
                elevation: 0,
                child: IconButton(
                  tooltip: 'Aller à ma leçon',
                  icon: Icon(Icons.my_location_rounded, color: p.prim),
                  onPressed: _allerALaLecon,
                ),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }
}

// ------------------------------------------------------------------ unité
class _Unite extends StatelessWidget {
  const _Unite({
    required this.numero,
    required this.chapitre,
    required this.couleur,
    required this.matiere,
    required this.progression,
    required this.actuelle,
    required this.accessible,
    required this.cleActuelle,
    required this.ouverte,
    required this.surOuvrir,
  });

  final int numero;
  final CurriculumChapter chapitre;
  final Color couleur;
  final SubjectCurriculum matiere;
  final Progression progression;
  final String? actuelle;
  final bool accessible;
  final GlobalKey cleActuelle;
  final String? ouverte;
  final ValueChanged<String> surOuvrir;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final lecons = [...chapitre.lessons]..sort((a, b) => a.order.compareTo(b.order));
    final faites = lecons.where((l) => progression.leconsFaites.contains(l.id)).length;
    final fini = faites == lecons.length && lecons.isNotEmpty;
    final n = lecons.length + 1; // + le trophée
    final largeur = MediaQuery.of(context).size.width;
    final amplitude = math.min(78.0, largeur * 0.2);
    final hauteur = n * _kPas + 20;
    Offset centre(int k) => Offset(largeur / 2 + _kSinueux[k % _kSinueux.length] * amplitude, 40 + k * _kPas + _kNoeud / 2);
    final indexActuel = lecons.indexWhere((l) => l.id == actuelle);

    return Column(children: [
      // la bannière de l'unité
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
        child: Container(
          decoration: BoxDecoration(
            color: accessible ? couleur : p.verrou,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Palette.fonce(accessible ? couleur : p.verrou, 0.25), offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.fromLTRB(18, 14, 10, 14),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('UNITÉ $numero · ${faites}/${lecons.length}',
                    style: TextStyle(
                        fontFamily: 'Inter', fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1,
                        color: (accessible ? Colors.white : p.doux).withValues(alpha: 0.85))),
                const SizedBox(height: 4),
                Text(chapitre.title,
                    style: TextStyle(
                        fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 20, height: 1.15,
                        color: accessible ? Colors.white : p.doux)),
              ]),
            ),
            IconButton(
              tooltip: 'Fiche du chapitre',
              onPressed: accessible
                  ? () => context.push('/curriculum/subject/${matiere.id}/chapter/${chapitre.id}/intro')
                  : null,
              icon: Icon(Icons.menu_book_rounded, color: accessible ? Colors.white : p.doux),
            ),
          ]),
        ),
      ),
      SizedBox(
        height: hauteur,
        child: Stack(clipBehavior: Clip.none, children: [
          // le chemin pointillé entre les pastilles
          Positioned.fill(
            child: CustomPaint(painter: _Chemin([for (var k = 0; k < n; k++) centre(k)], p.verrou, couleur, faites)),
          ),
          _place(
            centre(lecons.length),
            _Trophee(
              couleur: couleur,
              fini: fini,
              ouvert: accessible && (faites >= (lecons.length / 2).ceil()),
              surAppui: () => context.push('/curriculum/subject/${matiere.id}/chapter/${chapitre.id}/boss-exam'),
            ),
          ),
          // Kunfox s'assoit à côté de la leçon du moment
          if (indexActuel >= 0)
            Positioned(
              left: centre(indexActuel).dx + (_kSinueux[indexActuel % _kSinueux.length] <= 0 ? 70 : -190),
              top: centre(indexActuel).dy - 96,
              child: const IgnorePointer(child: KunfoxMascotte(humeur: HumeurKunfox.attente, taille: 120)),
            ),
          // les pastilles ; celle dont la carte est ouverte passe devant les autres
          for (final k in [
            for (var k = 0; k < lecons.length; k++) if (lecons[k].id != ouverte) k,
            for (var k = 0; k < lecons.length; k++) if (lecons[k].id == ouverte) k,
          ])
            _place(
              centre(k),
              _Noeud(
                key: lecons[k].id == actuelle ? cleActuelle : null,
                lecon: lecons[k],
                rang: k + 1,
                total: lecons.length,
                couleur: couleur,
                etat: progression.leconsFaites.contains(lecons[k].id)
                    ? EtatNoeud.faite
                    : lecons[k].id == actuelle
                        ? EtatNoeud.actuelle
                        : EtatNoeud.verrouillee,
                ouverte: ouverte == lecons[k].id,
                surAppui: () => surOuvrir(lecons[k].id),
                matiere: matiere,
                chapitre: chapitre,
              ),
            ),
        ]),
      ),
    ]);
  }

  Widget _place(Offset c, Widget enfant) => Positioned(
        left: c.dx - 110,
        top: c.dy - _kNoeud / 2,
        width: 220,
        child: Align(alignment: Alignment.topCenter, child: enfant),
      );
}

class _Chemin extends CustomPainter {
  _Chemin(this.points, this.gris, this.couleur, this.faites);
  final List<Offset> points;
  final Color gris, couleur;
  final int faites;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i + 1 < points.length; i++) {
      final a = points[i], b = points[i + 1];
      final pinceau = Paint()
        ..color = (i < faites ? couleur.withValues(alpha: 0.55) : gris)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 10;
      // pointillés le long d'une courbe douce
      const pas = 12;
      for (var k = 0; k < pas; k += 2) {
        final t0 = k / pas, t1 = (k + 1) / pas;
        Offset q(double t) {
          final c1 = Offset(a.dx, a.dy + (b.dy - a.dy) * 0.5);
          final c2 = Offset(b.dx, a.dy + (b.dy - a.dy) * 0.5);
          final u = 1 - t;
          return a * (u * u * u) + c1 * (3 * u * u * t) + c2 * (3 * u * t * t) + b * (t * t * t);
        }
        canvas.drawLine(q(t0), q(t1), pinceau);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _Chemin old) => old.faites != faites || old.couleur != couleur || old.points.length != points.length;
}

// ------------------------------------------------------------------ pastille
class _Noeud extends StatefulWidget {
  const _Noeud({
    super.key,
    required this.lecon,
    required this.rang,
    required this.total,
    required this.couleur,
    required this.etat,
    required this.ouverte,
    required this.surAppui,
    required this.matiere,
    required this.chapitre,
  });

  final Lesson lecon;
  final int rang, total;
  final Color couleur;
  final EtatNoeud etat;
  final bool ouverte;
  final VoidCallback surAppui;
  final SubjectCurriculum matiere;
  final CurriculumChapter chapitre;

  @override
  State<_Noeud> createState() => _NoeudState();
}

class _NoeudState extends State<_Noeud> with SingleTickerProviderStateMixin {
  late final AnimationController _flotte =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
  bool _enfonce = false;

  @override
  void dispose() {
    _flotte.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final faite = widget.etat == EtatNoeud.faite;
    final actuelle = widget.etat == EtatNoeud.actuelle;
    final couleur = widget.etat == EtatNoeud.verrouillee ? p.verrou : widget.couleur;
    final icone = faite
        ? Icons.check_rounded
        : actuelle
            ? Icons.star_rounded
            : Icons.lock_rounded;

    final pastille = GestureDetector(
      onTapDown: (_) => setState(() => _enfonce = true),
      onTapCancel: () => setState(() => _enfonce = false),
      onTapUp: (_) {
        setState(() => _enfonce = false);
        HapticFeedback.selectionClick();
        widget.surAppui();
      },
      child: SizedBox(
        width: _kNoeud + 16,
        height: _kNoeud + 16,
        child: Stack(alignment: Alignment.center, children: [
          if (actuelle)
            SizedBox(
              width: _kNoeud + 16,
              height: _kNoeud + 16,
              child: CircularProgressIndicator(
                value: 1,
                strokeWidth: 6,
                color: widget.couleur.withValues(alpha: 0.35),
              ),
            ),
          // tranche
          Positioned(
            top: 8 + 6,
            child: Container(
              width: _kNoeud,
              height: _kNoeud - 6,
              decoration: BoxDecoration(color: Palette.fonce(couleur, 0.25), shape: BoxShape.circle),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 70),
            top: _enfonce ? 14 : 8,
            child: Container(
              width: _kNoeud,
              height: _kNoeud - 6,
              decoration: BoxDecoration(color: couleur, shape: BoxShape.circle),
              child: Icon(icone, size: 36, color: widget.etat == EtatNoeud.verrouillee ? p.doux : Colors.white),
            ),
          ),
        ]),
      ),
    );

    return Semantics(
      button: true,
      label: '${widget.lecon.title}. Leçon ${widget.rang} sur ${widget.total}. '
          '${faite ? 'Faite' : actuelle ? 'À faire maintenant' : 'Verrouillée'}',
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Stack(clipBehavior: Clip.none, alignment: Alignment.topCenter, children: [
          pastille,
          if (actuelle && !widget.ouverte)
            Positioned(
              top: -44,
              child: AnimatedBuilder(
                animation: _flotte,
                builder: (context, enfant) =>
                    Transform.translate(offset: Offset(0, -6 * Curves.easeInOut.transform(_flotte.value)), child: enfant),
                child: _Bulle(texte: 'COMMENCER', couleur: widget.couleur),
              ),
            ),
        ]),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: const Cubic(0.16, 1, 0.3, 1),
          child: widget.ouverte ? _Carte(noeud: widget) : const SizedBox(width: 220),
        ),
      ]),
    );
  }
}

class _Bulle extends StatelessWidget {
  const _Bulle({required this.texte, required this.couleur});
  final String texte;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: p.bord, width: 2),
        ),
        child: Text(texte,
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1, color: couleur)),
      ),
      CustomPaint(size: const Size(16, 8), painter: _Pointe(p.surface, p.bord)),
    ]);
  }
}

class _Pointe extends CustomPainter {
  _Pointe(this.fond, this.bord);
  final Color fond, bord;
  @override
  void paint(Canvas canvas, Size s) {
    final chemin = Path()
      ..moveTo(0, -2)
      ..lineTo(s.width / 2, s.height)
      ..lineTo(s.width, -2)
      ..close();
    canvas.drawPath(chemin, Paint()..color = fond);
    canvas.drawPath(
        Path()
          ..moveTo(0, 0)
          ..lineTo(s.width / 2, s.height)
          ..lineTo(s.width, 0),
        Paint()
          ..color = bord
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _Pointe o) => o.fond != fond || o.bord != bord;
}

/// La carte qui s'ouvre sous une pastille.
class _Carte extends StatelessWidget {
  const _Carte({required this.noeud});
  final _Noeud noeud;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final verrou = noeud.etat == EtatNoeud.verrouillee;
    final fond = verrou ? p.surface : noeud.couleur;
    final texte = verrou ? p.texte : Colors.white;
    return Container(
      width: 260,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fond,
        borderRadius: BorderRadius.circular(18),
        border: verrou ? Border.all(color: p.bord, width: 2) : null,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text(noeud.lecon.title, style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, fontSize: 18, color: texte)),
        const SizedBox(height: 4),
        Text(
          verrou ? 'Termine les leçons d\'avant pour débloquer celle-ci.' : 'Leçon ${noeud.rang} sur ${noeud.total}',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: texte.withValues(alpha: 0.85)),
        ),
        if (!verrou) ...[
          const SizedBox(height: 12),
          BoutonKunfox(
            libelle: noeud.etat == EtatNoeud.faite ? 'Revoir  +10 XP' : 'Commencer  +15 XP',
            couleur: Colors.white,
            couleurTexte: noeud.couleur,
            hauteur: 46,
            surAppui: () => context.push('/k/lecon/${noeud.lecon.id}'),
          ),
        ],
      ]),
    );
  }
}

class _Trophee extends StatelessWidget {
  const _Trophee({required this.couleur, required this.fini, required this.ouvert, required this.surAppui});
  final Color couleur;
  final bool fini, ouvert;
  final VoidCallback surAppui;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final c = fini ? p.or : (ouvert ? couleur : p.verrou);
    return Semantics(
      button: true,
      label: fini ? 'Épreuve du chapitre réussie' : ouvert ? 'Épreuve du chapitre' : 'Épreuve du chapitre, verrouillée',
      child: GestureDetector(
        onTap: ouvert || fini ? surAppui : null,
        child: Container(
          width: _kNoeud + 6,
          height: _kNoeud + 6,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Palette.fonce(c, 0.25), offset: const Offset(0, 6))],
          ),
          child: Icon(Icons.emoji_events_rounded, size: 40, color: ouvert || fini ? Colors.white : p.doux),
        ),
      ),
    );
  }
}
