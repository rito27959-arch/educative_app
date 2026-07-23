import 'package:flutter_test/flutter_test.dart';
import 'package:ouro_prep/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error for null', () {
      expect(Validators.email(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('   '), isNotNull);
    });

    test('returns error for missing @', () {
      expect(Validators.email('testexample.com'), isNotNull);
    });

    test('returns error for missing dot', () {
      expect(Validators.email('test@'), isNotNull);
    });

    test('returns null for valid email', () {
      expect(Validators.email('test@example.com'), null);
      expect(Validators.email('user.name+tag@domain.co'), null);
      expect(Validators.email('a@b.c'), null);
    });
  });

  group('Validators.phone', () {
    test('returns null for null (phone is optional)', () {
      expect(Validators.phone(null), null);
    });

    test('returns null for empty string', () {
      expect(Validators.phone(''), null);
      expect(Validators.phone('   '), null);
    });

    test('returns null for valid Cameroon format 6XXXXXXXX', () {
      expect(Validators.phone('691234567'), null);
      expect(Validators.phone('650123456'), null);
      expect(Validators.phone('677889900'), null);
    });

    test('returns null for valid international format', () {
      expect(Validators.phone('+237691234567'), null);
      expect(Validators.phone('+221771234567'), null);
    });

    test('returns null for 8-digit number', () {
      expect(Validators.phone('12345678'), null);
    });

    test('returns null for 15-digit number', () {
      expect(Validators.phone('123456789012345'), null);
    });

    test('returns error for too short', () {
      expect(Validators.phone('1234567'), isNotNull);
      expect(Validators.phone('12'), isNotNull);
    });

    test('returns error for too long (16 digits)', () {
      expect(Validators.phone('1234567890123456'), isNotNull);
    });

    test('returns error for non-numeric', () {
      expect(Validators.phone('abcdefgh'), isNotNull);
    });

    test('handles spaces correctly', () {
      expect(Validators.phone('691 234 567'), null);
      expect(Validators.phone('+237 691 234 567'), null);
    });
  });

  group('Validators.pseudo', () {
    test('returns error for null', () {
      expect(Validators.pseudo(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.pseudo(''), isNotNull);
      expect(Validators.pseudo('   '), isNotNull);
    });

    test('returns error for single character', () {
      expect(Validators.pseudo('a'), isNotNull);
    });

    test('returns null for 2 characters (minimum)', () {
      expect(Validators.pseudo('ab'), null);
    });

    test('returns null for 20 characters (maximum)', () {
      expect(Validators.pseudo('a' * 20), null);
    });

    test('returns error for 21 characters (too long)', () {
      expect(Validators.pseudo('a' * 21), isNotNull);
    });

    test('returns null for valid characters', () {
      expect(Validators.pseudo('Alice'), null);
      expect(Validators.pseudo('user_name'), null);
      expect(Validators.pseudo('user-name'), null);
      expect(Validators.pseudo('User 123'), null);
    });

    test('returns error for special characters', () {
      expect(Validators.pseudo('user@name'), isNotNull);
      expect(Validators.pseudo('user!name'), isNotNull);
      expect(Validators.pseudo('user.name'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('returns error for null', () {
      expect(Validators.password(null), isNotNull);
    });

    test('returns error for empty', () {
      expect(Validators.password(''), isNotNull);
    });

    test('returns error for too short', () {
      expect(Validators.password('Ab1'), isNotNull);
    });

    test('returns error for missing uppercase', () {
      expect(Validators.password('abcdef1'), isNotNull);
    });

    test('returns error for missing digit', () {
      expect(Validators.password('Abcdefg'), isNotNull);
    });

    test('returns null for valid password', () {
      expect(Validators.password('Abcdef1'), null);
      expect(Validators.password('Strong1Pass'), null);
    });
  });

  group('Validators.required', () {
    test('returns error for null', () {
      expect(Validators.required(null), isNotNull);
    });

    test('returns error for empty', () {
      expect(Validators.required(''), isNotNull);
    });

    test('returns null for valid value', () {
      expect(Validators.required('hello'), null);
    });

    test('uses custom field name', () {
      final result = Validators.required('', 'Nom');
      expect(result, contains('Nom'));
    });
  });

  group('Validators.url', () {
    test('returns null for null', () {
      expect(Validators.url(null), null);
    });

    test('returns null for empty', () {
      expect(Validators.url(''), null);
    });

    test('returns null for valid http', () {
      expect(Validators.url('http://example.com'), null);
    });

    test('returns null for valid https', () {
      expect(Validators.url('https://example.com'), null);
    });

    test('returns error for missing protocol', () {
      expect(Validators.url('example.com'), isNotNull);
    });
  });

  group('Validators.maxLength', () {
    test('returns null when within limit', () {
      expect(Validators.maxLength('hello', 10), null);
    });

    test('returns error when over limit', () {
      expect(Validators.maxLength('hello world', 5), isNotNull);
    });

    test('returns null for null value', () {
      expect(Validators.maxLength(null, 5), null);
    });
  });

  group('Validators.minLength', () {
    test('returns null when meets minimum', () {
      expect(Validators.minLength('hello', 3), null);
    });

    test('returns error when under minimum', () {
      expect(Validators.minLength('hi', 5), isNotNull);
    });

    test('returns null for null value', () {
      expect(Validators.minLength(null, 5), null);
    });
  });

  group('Validators.numeric', () {
    test('returns null for null', () {
      expect(Validators.numeric(null), null);
    });

    test('returns null for valid number', () {
      expect(Validators.numeric('42'), null);
      expect(Validators.numeric('3.14'), null);
      expect(Validators.numeric('-5'), null);
    });

    test('returns error for non-numeric', () {
      expect(Validators.numeric('abc'), isNotNull);
    });
  });

  group('Validators.match', () {
    test('returns null when values match', () {
      expect(Validators.match('abc', 'abc'), null);
    });

    test('returns error when values differ', () {
      expect(Validators.match('abc', 'xyz'), isNotNull);
    });
  });

  group('FormValidation.isValid', () {
    test('returns true when all null', () {
      expect(FormValidation.isValid({'a': null, 'b': null}), true);
    });

    test('returns false when any has error', () {
      expect(FormValidation.isValid({'a': null, 'b': 'error'}), false);
    });
  });
}
