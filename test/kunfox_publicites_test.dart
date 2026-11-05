import 'package:flutter_test/flutter_test.dart';
import 'package:ouro_prep/kunfox/pub/publicites.dart';

void main() {
  final t = DateTime(2026, 11, 5, 15);
  bool ok({int total = 10, bool premiere = false, int depuis = 2, DateTime? derniere, int auj = 0}) =>
      Publicites.interstitielAutorise(
        leconsTotales: total,
        premiereDuJour: premiere,
        leconsDepuisDernierePub: depuis,
        dernierePub: derniere,
        pubsAujourdhui: auj,
        maintenant: t,
      );

  test('pas de pub pour les nouveaux élèves', () {
    expect(ok(total: 1), isFalse);
    expect(ok(total: 2), isFalse);
    expect(ok(total: 3), isTrue);
  });
  test('jamais après la première leçon du jour', () => expect(ok(premiere: true), isFalse));
  test('une leçon sur deux au plus', () {
    expect(ok(depuis: 1), isFalse);
    expect(ok(depuis: 2), isTrue);
  });
  test('au moins 4 minutes entre deux pubs', () {
    expect(ok(derniere: t.subtract(const Duration(minutes: 3))), isFalse);
    expect(ok(derniere: t.subtract(const Duration(minutes: 5))), isTrue);
  });
  test('6 par jour au maximum', () {
    expect(ok(auj: 5), isTrue);
    expect(ok(auj: 6), isFalse);
  });
  test('sans identifiants, pubs éteintes (et jamais sur ordinateur)', () {
    expect(Publicites.configurees, isFalse);
  });
}
