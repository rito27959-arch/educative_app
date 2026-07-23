import 'dart:async';
import 'package:flutter/material.dart';

T? dependentOn<T>(T? value, bool Function() condition) {
  if (condition()) return value;
  return null;
}

String formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '${duration.inHours.toString().padLeft(2, '0')}:$minutes:$seconds';
}

String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes o';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} Ko';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Mo';
}

String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Bonjour';
  if (hour < 18) return 'Bon après-midi';
  return 'Bonsoir';
}

Color lerpColor(Color a, Color b, double t) {
  return Color.lerp(a, b, t)!;
}

bool isNarrowScreen(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }
}

class Throttler {
  final Duration interval;
  DateTime _lastExecution = DateTime(2000);

  Throttler({this.interval = const Duration(seconds: 1)});

  bool tryRun(VoidCallback action) {
    final now = DateTime.now();
    if (now.difference(_lastExecution) >= interval) {
      _lastExecution = now;
      action();
      return true;
    }
    return false;
  }
}
