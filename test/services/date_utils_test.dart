import 'package:flutter_test/flutter_test.dart';
import 'package:ouro_prep/core/utils/date_utils.dart';

void main() {
  group('DateFormats.formatRelative', () {
    test('returns just now for recent time', () {
      final now = DateTime.now();
      expect(DateFormats.formatRelative(now), "À l'instant");
      expect(DateFormats.formatRelative(now.subtract(const Duration(seconds: 30))), "À l'instant");
    });

    test('returns minutes ago', () {
      final now = DateTime.now();
      final fiveMinAgo = now.subtract(const Duration(minutes: 5));
      expect(DateFormats.formatRelative(fiveMinAgo), 'Il y a 5min');
    });

    test('returns hours ago', () {
      final now = DateTime.now();
      final threeHoursAgo = now.subtract(const Duration(hours: 3));
      expect(DateFormats.formatRelative(threeHoursAgo), 'Il y a 3h');
    });

    test('returns days ago', () {
      final now = DateTime.now();
      final fourDaysAgo = now.subtract(const Duration(days: 4));
      expect(DateFormats.formatRelative(fourDaysAgo), 'Il y a 4j');
    });

    test('returns weeks ago', () {
      final now = DateTime.now();
      final twoWeeksAgo = now.subtract(const Duration(days: 14));
      expect(DateFormats.formatRelative(twoWeeksAgo), 'Il y a 2sem');
    });

    test('returns months ago', () {
      final now = DateTime.now();
      final twoMonthsAgo = now.subtract(const Duration(days: 60));
      expect(DateFormats.formatRelative(twoMonthsAgo), 'Il y a 2mois');
    });

    test('returns years ago', () {
      final now = DateTime.now();
      final twoYearsAgo = now.subtract(const Duration(days: 730));
      expect(DateFormats.formatRelative(twoYearsAgo), 'Il y a 2ans');
    });

    test('returns 59 minutes for 59 minutes ago (boundary)', () {
      final now = DateTime.now();
      final t = now.subtract(const Duration(minutes: 59));
      expect(DateFormats.formatRelative(t), 'Il y a 59min');
    });

    test('returns 1 hour for 60 minutes ago (boundary)', () {
      final now = DateTime.now();
      final t = now.subtract(const Duration(minutes: 60));
      expect(DateFormats.formatRelative(t), 'Il y a 1h');
    });
  });

  group('DateFormats.formatShort', () {
    test('formats date as dd/MM/yyyy', () {
      final date = DateTime(2026, 3, 5);
      expect(DateFormats.formatShort(date), '05/03/2026');
    });

    test('pads single digit day and month', () {
      final date = DateTime(2026, 1, 9);
      expect(DateFormats.formatShort(date), '09/01/2026');
    });
  });

  group('DateFormats.formatWithTime', () {
    test('formats date with time', () {
      final date = DateTime(2026, 7, 15, 14, 30);
      expect(DateFormats.formatWithTime(date), '15/07/2026 14:30');
    });
  });

  group('DateFormats.formatMonthYear', () {
    test('formats month and year in French', () {
      expect(DateFormats.formatMonthYear(DateTime(2026, 1, 1)), 'Janvier 2026');
      expect(DateFormats.formatMonthYear(DateTime(2026, 7, 1)), 'Juillet 2026');
      expect(DateFormats.formatMonthYear(DateTime(2026, 12, 1)), 'Décembre 2026');
    });
  });

  group('DateFormats.formatDayName', () {
    test('returns correct French day name', () {
      // 2026-07-15 is a Wednesday
      expect(DateFormats.formatDayName(DateTime(2026, 7, 15)), 'Mercredi');
      expect(DateFormats.formatDayName(DateTime(2026, 7, 14)), 'Mardi');
    });
  });

  group('DateFormats.formatFull', () {
    test('formats full date in French', () {
      // 2026-07-15 is Wednesday
      expect(DateFormats.formatFull(DateTime(2026, 7, 15)), 'Mercredi 15 Juillet 2026');
    });
  });

  group('DateFormats.formatDuration', () {
    test('formats seconds', () {
      expect(DateFormats.formatDuration(const Duration(seconds: 30)), '30s');
    });

    test('formats minutes', () {
      expect(DateFormats.formatDuration(const Duration(minutes: 5)), '5min');
    });

    test('formats hours and minutes', () {
      expect(DateFormats.formatDuration(const Duration(hours: 2, minutes: 30)), '2h 30min');
    });

    test('formats hours only', () {
      expect(DateFormats.formatDuration(const Duration(hours: 1)), '1h 0min');
    });
  });

  group('DateFormats.formatStudyTime', () {
    test('formats minutes', () {
      expect(DateFormats.formatStudyTime(const Duration(minutes: 45)), '45min');
    });

    test('formats hours without minutes', () {
      expect(DateFormats.formatStudyTime(const Duration(hours: 2)), '2h');
    });

    test('formats hours with minutes', () {
      expect(DateFormats.formatStudyTime(const Duration(hours: 1, minutes: 30)), '1h 30');
    });
  });

  group('DateFormats.timeAgo', () {
    test('delegates to formatRelative', () {
      final now = DateTime.now();
      expect(DateFormats.timeAgo(now), DateFormats.formatRelative(now));
    });
  });

  group('DateRangeUtils', () {
    test('isToday returns true for today', () {
      expect(DateRangeUtils.isToday(DateTime.now()), true);
    });

    test('isToday returns false for yesterday', () {
      expect(DateRangeUtils.isToday(DateTime.now().subtract(const Duration(days: 1))), false);
    });

    test('isThisWeek returns true for today', () {
      expect(DateRangeUtils.isThisWeek(DateTime.now()), true);
    });

    test('isThisMonth returns true for today', () {
      expect(DateRangeUtils.isThisMonth(DateTime.now()), true);
    });

    test('isThisMonth returns false for different month', () {
      final now = DateTime.now();
      final differentMonth = DateTime(now.year - 1, 1, 1);
      expect(DateRangeUtils.isThisMonth(differentMonth), false);
    });

    test('daysBetween calculates correctly', () {
      expect(DateRangeUtils.daysBetween(DateTime(2026, 1, 1), DateTime(2026, 1, 5)), 4);
    });

    test('daysBetween is order-independent', () {
      expect(
        DateRangeUtils.daysBetween(DateTime(2026, 1, 5), DateTime(2026, 1, 1)),
        4,
      );
    });

    test('daysBetween returns 0 for same day', () {
      expect(DateRangeUtils.daysBetween(DateTime(2026, 6, 15), DateTime(2026, 6, 15)), 0);
    });
  });
}
