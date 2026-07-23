import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

enum WsConnectionState { disconnected, connecting, connected, reconnecting }

enum WsEventType {
  message, presence, call_incoming, sync_request,
  sync_response, file_transfer, notification, system
}

class WsEvent {
  final WsEventType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String? senderId;

  const WsEvent({
    required this.type,
    required this.data,
    required this.timestamp,
    this.senderId,
  });

  factory WsEvent.fromJson(Map<String, dynamic> json) => WsEvent(
    type: WsEventType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => WsEventType.system,
    ),
    data: json['data'] as Map<String, dynamic>? ?? {},
    timestamp: json['timestamp'] != null
        ? DateTime.parse(json['timestamp'] as String)
        : DateTime.now(),
    senderId: json['senderId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    if (senderId != null) 'senderId': senderId,
  };
}

class WebSocketService {
  final String url;
  final Duration reconnectDelay;
  final int maxReconnectAttempts;

  WebSocket? _ws;
  WsConnectionState _state = WsConnectionState.disconnected;
  int _reconnectAttempts = 0;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  String? _authToken;

  final StreamController<WsEvent> _eventController = StreamController<WsEvent>.broadcast();
  final List<void Function(WsConnectionState state)> _stateListeners = [];

  WebSocketService({
    this.url = 'wss://api.ouroprep.app/ws',
    this.reconnectDelay = const Duration(seconds: 3),
    this.maxReconnectAttempts = 10,
  });

  WsConnectionState get state => _state;
  Stream<WsEvent> get events => _eventController.stream;
  bool get isConnected => _state == WsConnectionState.connected;

  void setAuthToken(String? token) => _authToken = token;

  void addStateListener(void Function(WsConnectionState state) listener) => _stateListeners.add(listener);
  void removeStateListener(void Function(WsConnectionState state) listener) => _stateListeners.remove(listener);

  void _setState(WsConnectionState newState) {
    if (_state == newState) return;
    _state = newState;
    for (final l in _stateListeners) { l(newState); }
  }

  Future<void> connect() async {
    if (_state == WsConnectionState.connecting || _state == WsConnectionState.connected) return;
    _setState(WsConnectionState.connecting);

    try {
      final uri = Uri.parse(url);
      final headers = <String, String>{
        'User-Agent': 'ouro-prep-mobile/1.0',
      };
      if (_authToken != null) {
        headers['Authorization'] = 'Bearer $_authToken';
      }

      _ws = await WebSocket.connect(
        uri.toString().replaceFirst('http', 'ws'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      _setState(WsConnectionState.connected);
      _reconnectAttempts = 0;
      _startHeartbeat();

      _ws!.listen(
        (data) {
          try {
            final json = jsonDecode(data as String) as Map<String, dynamic>;
            final event = WsEvent.fromJson(json);
            _eventController.add(event);
          } catch (e) { debugPrint('[WS] $e'); }
        },
        onDone: _onDisconnected,
        onError: (error) => _onDisconnected(),
      );
    } catch (e) {
      _setState(WsConnectionState.disconnected);
      _scheduleReconnect();
    }
  }

  void _onDisconnected() {
    _stopHeartbeat();
    _setState(WsConnectionState.disconnected);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= maxReconnectAttempts) return;
    _reconnectTimer?.cancel();
    _setState(WsConnectionState.reconnecting);
    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2);
    _reconnectTimer = Timer(delay, connect);
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      send(WsEvent(type: WsEventType.system, data: {'ping': true}, timestamp: DateTime.now()));
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void send(WsEvent event) {
    if (_ws == null || _state != WsConnectionState.connected) return;
    try {
      _ws!.add(jsonEncode(event.toJson()));
    } catch (e) { debugPrint('[WS] $e'); _onDisconnected();
    }
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _stopHeartbeat();
    _reconnectAttempts = maxReconnectAttempts;
    await _ws?.close();
    _ws = null;
    _setState(WsConnectionState.disconnected);
  }

  Future<void> sendMessage(String recipientId, String content) async {
    send(WsEvent(
      type: WsEventType.message,
      data: {'recipientId': recipientId, 'content': content},
      timestamp: DateTime.now(),
    ));
  }

  Future<void> sendPresence(bool isOnline) async {
    send(WsEvent(
      type: WsEventType.presence,
      data: {'online': isOnline},
      timestamp: DateTime.now(),
    ));
  }

  void dispose() {
    disconnect();
    _eventController.close();
  }
}
