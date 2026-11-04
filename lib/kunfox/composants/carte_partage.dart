// La carte de résultat à partager (WhatsApp, Instagram, Droplet…) :
// une image 1080 × 1350 aux couleurs de Kunfox, avec la mascotte, le
// résultat et l'adresse pour télécharger l'app.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/palette.dart';
import 'bouton.dart';
import 'fond_anime.dart';

class StatCarte {
  const StatCarte(this.icone, this.valeur, this.libelle);
  final IconData icone;
  final String valeur;
  final String libelle;
}

class CartePartage extends StatelessWidget {
  const CartePartage({
    super.key,
    required this.titre,
    required this.sousTitre,
    required this.stats,
    this.content = true,
    this.bandeau,
  });

  final String titre;
  final String sousTitre;
  final List<StatCarte> stats;

  /// Kunfox heureux (true) ou qui encourage (false).
  final bool content;

  /// Une petite étiquette au-dessus du titre (« DUEL », « SANS FAUTE »…).
  final String? bandeau;

  static const largeur = 360.0, hauteur = 450.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: largeur,
      height: hauteur,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF8A4C), Palette.orange, Color(0xFFE5501A)],
            ),
          ),
          child: Stack(children: [
            const Positioned.fill(
              child: FondRayons(couleur: Colors.white, centre: Alignment(0, -0.42), anime: false, intensite: 0.9),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 16),
              child: Column(children: [
                Row(children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(color: Palette.nuit, borderRadius: BorderRadius.circular(8)),
                    alignment: Alignment.center,
                    child: const Text('K',
                        style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, color: Palette.orange, fontSize: 16)),
                  ),
                  const SizedBox(width: 8),
                  const Text('Kunfox',
                      style: TextStyle(fontFamily: 'InterTight', fontWeight: FontWeight.w800, color: Colors.white, fontSize: 18)),
                  const Spacer(),
                  if (bandeau != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Palette.nuit, borderRadius: BorderRadius.circular(99)),
                      child: Text(bandeau!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, color: Color(0xFFFFC24B), fontSize: 11, letterSpacing: 1.1)),
                    ),
                ]),
                Expanded(
                  child: Image.asset(
                    content ? 'assets/images/kunfox_joie.png' : 'assets/images/kunfox_courage.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  titre,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: 'InterTight',
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    height: 1.05,
                    color: Colors.white,
                    shadows: [Shadow(color: Color(0x33000000), offset: Offset(0, 2), blurRadius: 0)],
                  ),
                ),
                const SizedBox(height: 6),
                Text(sousTitre,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Colors.white.withValues(alpha: 0.92))),
                const SizedBox(height: 14),
                Row(children: [
                  for (final (i, s) in stats.indexed) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: Palette.creme,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [BoxShadow(color: Color(0xFFB8400F), offset: Offset(0, 3))],
                        ),
                        child: Column(children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(s.icone, size: 16, color: Palette.orange),
                            const SizedBox(width: 3),
                            Text(s.valeur,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: Palette.nuit)),
                          ]),
                          Text(s.libelle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 9.5, letterSpacing: 0.8, color: Color(0xFF8A7F76))),
                        ]),
                      ),
                    ),
                  ],
                ]),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(color: Palette.nuit, borderRadius: BorderRadius.circular(14)),
                  child: const Text.rich(
                    TextSpan(children: [
                      TextSpan(text: 'Révise le bac avec moi  ·  ', style: TextStyle(color: Colors.white)),
                      TextSpan(text: 'kunfox.dropletmesh.app', style: TextStyle(color: Color(0xFFFFC24B))),
                    ]),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Montre la carte dans une feuille et la partage en image (1080 × 1350).
Future<void> partagerCarte(BuildContext context, CartePartage carte, {required String texte}) async {
  final cle = GlobalKey();
  final p = Palette.of(context);
  await precacheImage(const AssetImage('assets/images/kunfox_joie.png'), context);
  if (!context.mounted) return;
  await precacheImage(const AssetImage('assets/images/kunfox_courage.png'), context);
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: p.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) {
      var envoi = false;
      return StatefulBuilder(
        builder: (ctx, majEtat) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 40, height: 5, decoration: BoxDecoration(color: p.bord, borderRadius: BorderRadius.circular(9))),
              const SizedBox(height: 14),
              Flexible(
                child: FittedBox(
                  child: RepaintBoundary(key: cle, child: carte),
                ),
              ),
              const SizedBox(height: 16),
              BoutonKunfox(
                libelle: envoi ? 'Un instant…' : 'Partager',
                surAppui: envoi
                    ? null
                    : () async {
                        majEtat(() => envoi = true);
                        HapticFeedback.mediumImpact();
                        try {
                          final objet = cle.currentContext!.findRenderObject()! as RenderRepaintBoundary;
                          final image = await objet.toImage(pixelRatio: 1080 / CartePartage.largeur);
                          final png = await image.toByteData(format: ui.ImageByteFormat.png);
                          final dossier = await getTemporaryDirectory();
                          final f = File('${dossier.path}/kunfox_resultat.png');
                          await f.writeAsBytes(png!.buffer.asUint8List());
                          await Share.shareXFiles([XFile(f.path, mimeType: 'image/png')], text: texte);
                        } catch (e) {
                          debugPrint('[Kunfox] carte non partagée : $e');
                          await Share.share(texte);
                        }
                        if (ctx.mounted) majEtat(() => envoi = false);
                      },
              ),
            ]),
          ),
        ),
      );
    },
  );
}
