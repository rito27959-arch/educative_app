import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'supabase_service.dart';
import 'storage_service.dart';

enum PushPermission { granted, denied, provisional, notDetermined }

class PushNotification {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final String? deepLink;
  final Map<String, dynamic> data;
  final DateTime receivedAt;
  final bool isRead;

  const PushNotification({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.deepLink,
    this.data = const {},
    required this.receivedAt,
    this.isRead = false,
  });

  PushNotification copyWith({bool? isRead}) => PushNotification(
    id: id, title: title, body: body, imageUrl: imageUrl,
    deepLink: deepLink, data: data, receivedAt: receivedAt,
    isRead: isRead ?? this.isRead,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'body': body,
    if (imageUrl != null) 'imageUrl': imageUrl,
    if (deepLink != null) 'deepLink': deepLink,
    'data': data, 'receivedAt': receivedAt.toIso8601String(),
    'isRead': isRead,
  };

  factory PushNotification.fromJson(Map<String, dynamic> json) => PushNotification(
    id: json['id'] as String,
    title: json['title'] as String,
    body: json['body'] as String,
    imageUrl: json['imageUrl'] as String?,
    deepLink: json['deepLink'] as String?,
    data: json['data'] as Map<String, dynamic>? ?? {},
    receivedAt: DateTime.parse(json['receivedAt'] as String),
    isRead: json['isRead'] as bool? ?? false,
  );
}

class PushService {
  String? _deviceToken;
  PushPermission _permission = PushPermission.notDetermined;
  String? _pushEndpoint;

  final StreamController<PushNotification> _notificationController = StreamController<PushNotification>.broadcast();
  final List<PushNotification> _history = [];

  PushService();

  Stream<PushNotification> get onNotification => _notificationController.stream;
  PushPermission get permission => _permission;
  List<PushNotification> get history => List.unmodifiable(_history);
  int get unreadCount => _history.where((n) => !n.isRead).length;

  Future<void> init() async {
    _loadHistory();
    _deviceToken = StorageService.getString('push_device_token');
    _pushEndpoint = StorageService.getString('push_endpoint');
    if (_deviceToken != null) {
      await _registerToken();
    }
  }

  Future<void> requestPermission() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        const channel = MethodChannel('ouro_prep/notifications');
        final result = await channel.invokeMethod<bool>('requestPermission');
        _permission = result == true ? PushPermission.granted : PushPermission.denied;
      } else {
        _permission = PushPermission.granted;
      }
    } catch (_) {
      _permission = PushPermission.granted;
    }
  }

  Future<void> registerDeviceToken(String token, {String? endpoint}) async {
    _deviceToken = token;
    _pushEndpoint = endpoint;
    await StorageService.setString('push_device_token', token);
    if (endpoint != null) {
      await StorageService.setString('push_endpoint', endpoint);
    }
    await _registerToken();
  }

  Future<void> _registerToken() async {
    if (_deviceToken == null) return;
    try {
      await SupabaseService.instance.client.from('push_tokens').upsert({
        'token': _deviceToken,
        'platform': 'android',
        'endpoint': _pushEndpoint,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e, _) {
      debugPrint('[Push] Register error: $e');
    }
  }

  Future<void> unregisterToken() async {
    if (_deviceToken == null) return;
    try {
      await SupabaseService.instance.client
          .from('push_tokens')
          .delete()
          .eq('token', _deviceToken!);
    } catch (e, _) {
      debugPrint('[Push] Unregister error: $e');
    }
    _deviceToken = null;
    await StorageService.remove('push_device_token');
    await StorageService.remove('push_endpoint');
  }

  void handleNotificationReceived(Map<String, dynamic> payload) {
    final notification = PushNotification(
      id: payload['id'] as String? ?? StorageService.generateId(),
      title: payload['title'] as String? ?? '',
      body: payload['body'] as String? ?? '',
      imageUrl: payload['imageUrl'] as String?,
      deepLink: payload['deepLink'] as String?,
      data: payload,
      receivedAt: DateTime.now(),
    );
    _history.insert(0, notification);
    _persistHistory();
    _notificationController.add(notification);
  }

  void markAsRead(String notificationId) {
    final idx = _history.indexWhere((n) => n.id == notificationId);
    if (idx >= 0) {
      _history[idx] = _history[idx].copyWith(isRead: true);
      _persistHistory();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _history.length; i++) {
      _history[i] = _history[i].copyWith(isRead: true);
    }
    _persistHistory();
  }

  void clearHistory() {
    _history.clear();
    StorageService.setString('push_history', '[]');
  }

  void _loadHistory() {
    final saved = StorageService.getString('push_history');
    if (saved != null) {
      final list = jsonDecode(saved) as List<dynamic>;
      _history.addAll(list.map((e) => PushNotification.fromJson(e as Map<String, dynamic>)));
    }
  }

  void _persistHistory() {
    StorageService.setString('push_history', jsonEncode(_history.map((e) => e.toJson()).toList()));
  }

  void dispose() {
    _notificationController.close();
  }
}
