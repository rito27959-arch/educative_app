// Captures des écrans d'épreuve rendues sur la machine (sans émulateur) :
// les PNG vont dans build/captures_hote/. Sert à vérifier l'affichage des
// formules, courbes et tableaux.

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ouro_prep/core/services/storage_service.dart';
import 'package:ouro_prep/kunfox/ecrans/examen.dart';
import 'package:ouro_prep/kunfox/riche/contenu_riche.dart';
import 'package:ouro_prep/kunfox/theme/kunfox_theme.dart';
import 'package:ouro_prep/kunfox/theme/palette.dart';

Future<void> _chargerPolices() async {
  final manifeste = jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
  for (final f in manifeste) {
    final famille = f['family'] as String;
    final chargeur = FontLoader(famille);
    for (final p in f['fonts'] as List) {
      chargeur.addFont(rootBundle.load(p['asset'] as String));
    }
    await chargeur.load();
  }
}

void main() {
  final dossier = Directory('build/captures_hote')..createSync(recursive: true);
  final cle = GlobalKey();

  setUpAll(() async {
    await _chargerPolices();
    await StorageService.setString('kunfox.sons', 'false');
  });

  Future<void> monter(WidgetTester tester, Widget ecran, {bool sombre = false}) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2;
    await tester.pumpWidget(ProviderScope(
      child: RepaintBoundary(
        key: cle,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: sombre ? KunfoxTheme.sombre() : KunfoxTheme.clair(),
          home: ecran,
        ),
      ),
    ));
  }

  Future<void> photo(WidgetTester tester, String nom) async {
    await tester.pump();
    await tester.runAsync(() async {
      final objet = cle.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await objet.toImage(pixelRatio: 2);
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      File('${dossier.path}/$nom.png').writeAsBytesSync(png!.buffer.asUint8List());
    });
  }

  Future<void> avancer(WidgetTester tester, int ms) async {
    for (var t = 0; t < ms; t += 50) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> finir(WidgetTester tester) async {
    await avancer(tester, 3500);
    await tester.pumpWidget(const SizedBox());
    await avancer(tester, 200);
  }

  testWidgets('h1 entrée de l\'épreuve', (tester) async {
    await monter(tester, const ExamenEntreeEcran(epreuveId: 'bac_c_maths_1'));
    await avancer(tester, 2200);
    await photo(tester, 'h1_examen_entree');
    await finir(tester);
  });

  testWidgets('h2 copie', (tester) async {
    await monter(tester, ExamenCopieEcran(epreuveId: 'bac_d_maths_1', copie: Copie(epreuveId: 'bac_d_maths_1')));
    await avancer(tester, 600);
    await photo(tester, 'h2a_copie_ex1');
    await tester.tap(find.textContaining('Ex. 3').first);
    await avancer(tester, 900);
    await photo(tester, 'h2b_copie_probleme');
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -700));
    await avancer(tester, 600);
    await photo(tester, 'h2c_copie_questions');
    await finir(tester);
  });

  testWidgets('h3 correction', (tester) async {
    final copie = Copie(
      epreuveId: 'bac_d_maths_1',
      reponses: {'0.0': '-16', '0.1': 0, '0.2': '2√2', '1.0': '120', '1.2': '0,4', '2.0': '0', '2.1': '-∞', '2.2': '-(x+1)e^(-x)', '2.4': '-x+2'},
      coches: {'2.3': {0, 1, 2}},
    );
    await monter(tester, ExamenCorrectionEcran(epreuveId: 'bac_d_maths_1', copie: copie));
    await avancer(tester, 800);
    await photo(tester, 'h3a_correction');
    for (var i = 0; i < 8; i++) {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -760));
      await avancer(tester, 300);
      if (i == 3 || i == 5 || i == 7) await photo(tester, 'h3b_correction_$i');
    }
    await finir(tester);
  });

  testWidgets('h4 note', (tester) async {
    await monter(
      tester,
      const ExamenNoteEcran(
        resultat: ResultatExamen(
          epreuveId: 'bac_d_maths_1',
          note: 14.5,
          parExercice: [(4, 4), (2.5, 4), (8, 12)],
          aRevoir: ['maths_ch1', 'maths_ch6'],
          duree: Duration(minutes: 182),
        ),
      ),
    );
    await avancer(tester, 3000);
    await photo(tester, 'h4_note');
    await finir(tester);
  });

  testWidgets('h5 cours riche', (tester) async {
    await monter(
      tester,
      Builder(
        builder: (context) => Scaffold(
          backgroundColor: Palette.of(context).fond,
          body: SafeArea(
            child: ListView(padding: const EdgeInsets.all(16), children: const [
              ContenuRiche(r'''## Étude d'une fonction
> **Propriété.** Si $f'(x) > 0$ sur un intervalle $I$, alors $f$ est strictement croissante sur $I$.

Soit $f(x) = (x+2)e^{-x}$. On a $f'(x) = -(x+1)e^{-x}$, et
$$\int_0^1 f(x)\,dx = 3 - \frac{4}{e} \approx 1{,}528$$

```variations
x     | −∞   |   | −1  |   | +∞
f'(x) |      | + | 0   | − |
f(x)  | −∞ b |   | e h |   | 0 b
```

```graphe
f(x) = (x+2)e^(-x) | orange
droite: y = -x + 2 | bleu
x: -3 .. 5
y: -2 .. 3.5
point: (-1, 2.718) S
```

```tableau
x | −2 | −1 | 0 | 1
f(x) | 0 | e | 2 | 3/e
```'''),
            ]),
          ),
        ),
      ),
    );
    await avancer(tester, 1800);
    await photo(tester, 'h5_cours_riche');
    await finir(tester);
  });
}
