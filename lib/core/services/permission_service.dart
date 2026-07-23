import 'package:flutter/services.dart';

enum AndroidPermission {
  storage,
  microphone,
  location,
  camera,
  notifications,
  nearbyDevices,
  bluetooth,
  phoneState,
}

class PermissionStatus {
  final bool granted;
  final bool permanentlyDenied;
  final bool shouldShowRationale;

  const PermissionStatus({
    required this.granted,
    this.permanentlyDenied = false,
    this.shouldShowRationale = false,
  });
}

class PermissionService {
  static const _channel = MethodChannel('com.nexora.ouroprep/permissions');

  static const Map<AndroidPermission, String> _permissionNames = {
    AndroidPermission.storage: 'android.permission.READ_EXTERNAL_STORAGE',
    AndroidPermission.microphone: 'android.permission.RECORD_AUDIO',
    AndroidPermission.location: 'android.permission.ACCESS_FINE_LOCATION',
    AndroidPermission.camera: 'android.permission.CAMERA',
    AndroidPermission.notifications: 'android.permission.POST_NOTIFICATIONS',
    AndroidPermission.nearbyDevices: 'android.permission.NEARBY_WIFI_DEVICES',
    AndroidPermission.bluetooth: 'android.permission.BLUETOOTH_CONNECT',
    AndroidPermission.phoneState: 'android.permission.READ_PHONE_STATE',
  };

  static Future<PermissionStatus> check(AndroidPermission perm) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'checkPermission',
        _permissionNames[perm],
      );
      return PermissionStatus(
        granted: result == 'granted',
        permanentlyDenied: result == 'denied_never_ask',
        shouldShowRationale: result == 'denied_show_rationale',
      );
    } catch (_) {
      return PermissionStatus(granted: true);
    }
  }

  static Future<PermissionStatus> request(AndroidPermission perm) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'requestPermission',
        _permissionNames[perm],
      );
      return PermissionStatus(
        granted: result == 'granted',
        permanentlyDenied: result == 'denied_never_ask',
        shouldShowRationale: result == 'denied_show_rationale',
      );
    } catch (_) {
      return PermissionStatus(granted: true);
    }
  }
}
