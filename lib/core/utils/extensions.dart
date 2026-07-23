import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  bool get isLight => Theme.of(this).brightness == Brightness.light;

  void showSnackBar(String message, {Color? color, Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: duration ?? const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void showError(String message) {
    showSnackBar(message, color: Colors.red.shade800);
  }

  void showSuccess(String message) {
    showSnackBar(message, color: Colors.green.shade800);
  }

  void push(Widget page) {
    Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }

  void replaceWith(Widget page) {
    Navigator.of(this).pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  void showOuroBottomSheet(Widget sheet) {
    showModalBottomSheet(
      context: this,
      builder: (_) => sheet,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void showOuroDialog(Widget dialog) {
    showDialog(
      context: this,
      builder: (_) => dialog,
    );
  }
}

extension NumX on num {
  double get w => this * MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single).size.width / 375;
  double get h => this * MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single).size.height / 812;
  SizedBox get spacingH => SizedBox(height: toDouble());
  SizedBox get spacingW => SizedBox(width: toDouble());
  Duration get msDuration => Duration(milliseconds: toInt());
  Duration get secDuration => Duration(seconds: toInt());
  Duration get minDuration => Duration(minutes: toInt());
}

extension StringX on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get truncate => length > 30 ? '${substring(0, 30)}...' : this;

  String get initials {
    final parts = trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.length == 1 && parts[0].length >= 2) {
      return parts[0].substring(0, 2).toUpperCase();
    }
    return isEmpty ? '' : this[0].toUpperCase();
  }

  bool get isValidEmail => contains('@') && contains('.');
  bool get isValidPseudo => length >= 2 && length <= 20;
}

extension DateTimeX on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inDays > 7) return format('dd MMM');
    if (diff.inDays > 0) return 'Il y a ${diff.inDays}j';
    if (diff.inHours > 0) return 'Il y a ${diff.inHours}h';
    if (diff.inMinutes > 0) return 'Il y a ${diff.inMinutes}min';
    return 'À l\'instant';
  }

  String format(String pattern) {
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return pattern
        .replaceAll('dd', day.toString().padLeft(2, '0'))
        .replaceAll('MMM', months[month - 1])
        .replaceAll('yyyy', year.toString());
  }
}

extension WidgetX on Widget {
  Widget paddingAll(double value) => Padding(padding: EdgeInsets.all(value), child: this);
  Widget paddingSymmetric({double h = 0, double v = 0}) => Padding(padding: EdgeInsets.symmetric(horizontal: h, vertical: v), child: this);
  Widget paddingOnly({double l = 0, double t = 0, double r = 0, double b = 0}) => Padding(padding: EdgeInsets.only(left: l, top: t, right: r, bottom: b), child: this);
  Widget centered() => Center(child: this);
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  Widget onTap(VoidCallback callback) {
    return GestureDetector(onTap: callback, child: this);
  }

  Widget sliver() => SliverToBoxAdapter(child: this);
}

extension IterableX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  Map<K, List<T>> groupBy<K>(K Function(T) key) {
    final map = <K, List<T>>{};
    for (final element in this) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}
