import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'supabase_service.dart';

@pragma('vm:never-inline')
class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> properties;
  final DateTime timestamp;
  final String sessionId;

  const AnalyticsEvent({
    required this.name,
    this.properties = const {},
    required this.timestamp,
    required this.sessionId,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'properties': properties,
    'timestamp': timestamp.toIso8601String(),
    'sessionId': sessionId,
  };
}

class PerformanceMetric {
  final String metric;
  final double value;
  final Map<String, String> tags;
  final DateTime timestamp;

  const PerformanceMetric({
    required this.metric,
    required this.value,
    this.tags = const {},
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'metric': metric,
    'value': value,
    'tags': tags,
    'timestamp': timestamp.toIso8601String(),
  };
}

class AnalyticsService {
  static AnalyticsService? _instance;
  final String _sessionId;
  final List<AnalyticsEvent> _buffer = [];
  final List<PerformanceMetric> _metricsBuffer = [];
  static const int _flushThreshold = 20;
  static const Duration _flushInterval = Duration(seconds: 30);
  Timer? _flushTimer;
  bool _enabled = true;
  int _crashCount = 0;

  AnalyticsService._() : _sessionId = _generateSessionId();

  factory AnalyticsService() {
    _instance ??= AnalyticsService._();
    return _instance!;
  }

  static String _generateSessionId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  String get sessionId => _sessionId;

  void init() {
    _flushTimer = Timer.periodic(_flushInterval, (_) => flush());
    _trackAppLaunch();
  }

  void trackEvent(String name, {Map<String, dynamic> properties = const {}}) {
    if (!_enabled) return;
    final event = AnalyticsEvent(name: name, properties: properties, timestamp: DateTime.now(), sessionId: _sessionId);
    _buffer.add(event);
    if (_buffer.length >= _flushThreshold) flush();
  }

  void trackScreen(String screenName) {
    trackEvent('screen_view', properties: {'screen': screenName});
  }

  void trackAction(String action, {Map<String, dynamic> properties = const {}}) {
    trackEvent('user_action', properties: {'action': action, ...properties});
  }

  void trackError(String error, {String? stackTrace, bool isFatal = false}) {
    if (isFatal) _crashCount++;
    trackEvent(isFatal ? 'crash' : 'error', properties: {
      'error': error,
      'stackTrace': stackTrace ?? '',
      'crashCount': _crashCount.toString(),
    });
  }

  void trackPerformance(String metric, double value, {Map<String, String> tags = const {}}) {
    if (!_enabled) return;
    _metricsBuffer.add(PerformanceMetric(
      metric: metric, value: value, tags: tags, timestamp: DateTime.now(),
    ));
  }

  void trackMeshPerformance(int peerCount, int messageCount, double latencyMs) {
    trackPerformance('mesh.peers', peerCount.toDouble(), tags: {'unit': 'count'});
    trackPerformance('mesh.messages', messageCount.toDouble(), tags: {'unit': 'count'});
    trackPerformance('mesh.latency', latencyMs, tags: {'unit': 'ms'});
  }

  void trackCallQuality(double bitrate, double audioLevel, int durationSec) {
    trackPerformance('call.bitrate', bitrate, tags: {'unit': 'kbps'});
    trackPerformance('call.audioLevel', audioLevel, tags: {'unit': 'db'});
    trackPerformance('call.duration', durationSec.toDouble(), tags: {'unit': 'sec'});
  }

  Future<void> flush() async {
    if (_buffer.isEmpty && _metricsBuffer.isEmpty) return;

    final events = List<AnalyticsEvent>.from(_buffer);
    final metrics = List<PerformanceMetric>.from(_metricsBuffer);
    _buffer.clear();
    _metricsBuffer.clear();

    try {
      await SupabaseService.instance.client.from('analytics_events').insert(
        events.map((e) => e.toJson()).toList(),
      );
      if (metrics.isNotEmpty) {
        await SupabaseService.instance.client.from('analytics_metrics').insert(
          metrics.map((m) => m.toJson()).toList(),
        );
      }
    } catch (e, _) {
      _buffer.insertAll(0, events);
      _metricsBuffer.insertAll(0, metrics);
      debugPrint('[Analytics] Flush error: $e');
    }
  }

  void _trackAppLaunch() {
    trackEvent('app_launch', properties: {
      'platform': Platform.operatingSystem,
      'osVersion': Platform.operatingSystemVersion,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void setEnabled(bool enabled) => _enabled = enabled;

  Future<void> dispose() async {
    await flush();
    _flushTimer?.cancel();
  }
}
