import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:ouro_prep/kunfox/riche/expressions.dart';

void main() {
  group('Expressions.nombre', () {
    test('virgule, fractions, racines, pi', () {
      expect(Expressions.nombre('3,5'), closeTo(3.5, 1e-12));
      expect(Expressions.nombre('1/4'), closeTo(0.25, 1e-12));
      expect(Expressions.nombre('2√3'), closeTo(2 * math.sqrt(3), 1e-9));
      expect(Expressions.nombre('π/2'), closeTo(math.pi / 2, 1e-9));
      expect(Expressions.nombre('1.2e-3'), closeTo(0.0012, 1e-12));
      expect(Expressions.nombre('-16'), closeTo(-16, 1e-12));
      expect(Expressions.nombre('e'), closeTo(math.e, 1e-9));
      expect(Expressions.nombre('ln(2)'), closeTo(math.ln2, 1e-9));
      expect(Expressions.nombre('abc+'), isNull);
    });
  });

  group('Expressions.equivalentes', () {
    test('écritures lycée', () {
      expect(Expressions.equivalentes('2x+3', '3+2*x'), isTrue);
      expect(Expressions.equivalentes('x²-1', '(x-1)(x+1)'), isTrue);
      expect(Expressions.equivalentes('e^(-x)', 'exp(-x)'), isTrue);
      expect(Expressions.equivalentes('(1-x)e^(-x)', 'e^(-x)-x*e^(-x)'), isTrue);
      expect(Expressions.equivalentes('1/x', 'x^(-1)'), isTrue);
      expect(Expressions.equivalentes('2x+3', '2x+4'), isFalse);
      expect(Expressions.equivalentes('ln(x)+1', '1+ln x'), isFalse); // « ln x » sans parenthèses : illisible, refusé
      expect(Expressions.equivalentes('√(x)', 'sqrt(x)'), isTrue);
      expect(Expressions.equivalentes('3x²', '3*x^2'), isTrue);
    });
  });

  group('Expressions.fonction', () {
    test('trace', () {
      final f = Expressions.fonction('x^2 - 2x')!;
      expect(f(3), closeTo(3, 1e-12));
      final g = Expressions.fonction('(2x+1)/(x-1)')!;
      expect(g(2), closeTo(5, 1e-12));
      expect(g(1).isFinite, isFalse);
    });
  });
}
