// Kabi rendu sur la machine (sans émulateur), avec le moteur Rive de l'app :
// vérifie que kabi.riv se lit, et photographie les poses de la carte dans
// plusieurs couleurs (build/captures_hote/k*.png).

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ouro_prep/shared/widgets/kunfox/kunfox_rive.dart';

void main() {
  final dossier = Directory('build/captures_hote')..createSync(recursive: true);
  final cle = GlobalKey();

  Future<void> photo(WidgetTester tester, String nom) async {
    await tester.pump();
    await tester.runAsync(() async {
      final objet = cle.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await objet.toImage(pixelRatio: 2);
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      File('${dossier.path}/$nom.png').writeAsBytesSync(png!.buffer.asUint8List());
    });
  }

  Future<void> charger(WidgetTester tester) async {
    // Le fichier Rive se lit pour de vrai (entrées/sorties), puis on laisse
    // les animations avancer.
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
      await tester.pump(const Duration(milliseconds: 50));
    }
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('k1 Kabi : les poses de la carte', (tester) async {
    tester.view.physicalSize = const Size(1400, 1100);
    tester.view.devicePixelRatio = 2;
    const poses = [
      (PoseKabi.coucou, ExpressionKabi.joie, CouleurKabi.orange),
      (PoseKabi.presenteDroite, ExpressionKabi.joie, CouleurKabi.bleu),
      (PoseKabi.halteres, ExpressionKabi.determine, CouleurKabi.vert),
      (PoseKabi.reflexion, ExpressionKabi.neutre, CouleurKabi.violet),
      (PoseKabi.boxe, ExpressionKabi.determine, CouleurKabi.rouge),
      (PoseKabi.mainsHanches, ExpressionKabi.fier, CouleurKabi.rose),
      (PoseKabi.dodo, ExpressionKabi.sommeil, CouleurKabi.marron),
      (PoseKabi.ecoute, ExpressionKabi.joie, CouleurKabi.noir),
    ];
    await tester.pumpWidget(RepaintBoundary(
      key: cle,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFFFF8F1),
          body: Center(
            child: Wrap(spacing: 12, runSpacing: 12, children: [
              for (final (p, e, c) in poses) KunfoxMascotte(pose: p, expression: e, couleur: c, taille: 150),
            ]),
          ),
        ),
      ),
    ));
    await charger(tester);
    expect(KunfoxMascotte.kabiIllisible, isFalse, reason: 'kabi.riv doit se lire avec le moteur Rive de l\'app');
    await photo(tester, 'k1_kabi_poses');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('k2 Kabi : le choix de la couleur', (tester) async {
    tester.view.physicalSize = const Size(780, 400);
    tester.view.devicePixelRatio = 2;
    await tester.pumpWidget(RepaintBoundary(
      key: cle,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Padding(padding: EdgeInsets.all(20), child: ChoixCouleurKabi())),
      ),
    ));
    await charger(tester);
    await photo(tester, 'k2_choix_couleur');
    await tester.pumpWidget(const SizedBox());
  });
}
