class DateFormats {
  DateFormats._();

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inSeconds < 60) return "À l'instant";
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';
    if (diff.inDays < 30) return 'Il y a ${(diff.inDays / 7).round()}sem';
    if (diff.inDays < 365) return 'Il y a ${(diff.inDays / 30).round()}mois';
    return 'Il y a ${(diff.inDays / 365).round()}ans';
  }

  static String formatShort(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String formatWithTime(DateTime date) {
    return '${formatShort(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String formatMonthYear(DateTime date) {
    const months = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
    return '${months[date.month - 1]} ${date.year}';
  }

  static String formatDayName(DateTime date) {
    const days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    return days[date.weekday - 1];
  }

  static String formatFull(DateTime date) {
    return '${formatDayName(date)} ${date.day} ${formatMonthYear(date)}';
  }

  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}min';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}min';
    }
    return '${duration.inSeconds}s';
  }

  static String formatStudyTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) return '${hours}h${minutes > 0 ? ' $minutes' : ''}';
    return '${minutes}min';
  }

  static String timeAgo(DateTime date) {
    return formatRelative(date);
  }
}

class DateRangeUtils {
  DateRangeUtils._();

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return date.isAfter(weekStart.subtract(const Duration(days: 1)));
  }

  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static int daysBetween(DateTime a, DateTime b) {
    final aDay = DateTime(a.year, a.month, a.day);
    final bDay = DateTime(b.year, b.month, b.day);
    return bDay.difference(aDay).inDays.abs();
  }
}
