// Pilote des captures d'écran (vérification seulement).
import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (String nom, List<int> octets, [Map<String, Object?>? args]) async {
      final f = File('captures/$nom.png');
      f.parent.createSync(recursive: true);
      f.writeAsBytesSync(octets);
      return true;
    },
  );
}
