import 'package:flutter/material.dart';
import '../../design_system/ouro_colors.dart';

sealed class AppException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  AppException(this.message, {this.code, this.stackTrace});

  @override
  String toString() => '[$code] $message';
}

class NetworkException extends AppException {
  final int? statusCode;

  NetworkException(super.message, {this.statusCode, super.code, super.stackTrace});
}

class StorageException extends AppException {
  StorageException(super.message, {super.code, super.stackTrace});
}

class AuthException extends AppException {
  AuthException(super.message, {super.code, super.stackTrace});
}

class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  ValidationException(super.message, {this.fieldErrors = const {}, super.code, super.stackTrace});
}

class MeshException extends AppException {
  final int hopCount;

  MeshException(super.message, {this.hopCount = 0, super.code, super.stackTrace});
}

class CacheException extends AppException {
  CacheException(super.message, {super.code, super.stackTrace});
}

class CallUnavailableException extends AppException {
  CallUnavailableException(super.message, {super.code, super.stackTrace});
}

class NotFoundException extends AppException {
  final String? entityType;

  NotFoundException(super.message, {this.entityType, super.code, super.stackTrace});
}

class ErrorHandler {
  static String getDisplayMessage(Object? error) {
    if (error is AppException) return error.message;
    if (error is FlutterError) return error.message;
    return 'Une erreur inattendue est survenue';
  }

  static Color getErrorColor(Object? error) {
    if (error is NetworkException) return OuroColors.errorRed;
    if (error is AuthException) return OuroColors.ouroOrange;
    if (error is ValidationException) return OuroColors.errorRed;
    return OuroColors.textSecondary;
  }

  static IconData getErrorIcon(Object? error) {
    if (error is NetworkException) return Icons.wifi_off;
    if (error is AuthException) return Icons.lock_outline;
    if (error is ValidationException) return Icons.error_outline;
    if (error is StorageException) return Icons.storage;
    if (error is MeshException) return Icons.wifi_tethering_off;
    return Icons.error_outline;
  }
}

class Result<T> {
  final T? data;
  final AppException? error;

  Result._({this.data, this.error});

  factory Result.success(T data) => Result._(data: data);
  factory Result.failure(AppException error) => Result._(error: error);

  bool get isSuccess => data != null && error == null;
  bool get isFailure => error != null;

  T getOrThrow() {
    if (isFailure) throw error!;
    return data as T;
  }

  T? getOrNull() => data;

  R fold<R>(R Function(T data) onSuccess, R Function(AppException error) onFailure) {
    if (isSuccess) return onSuccess(data as T);
    return onFailure(error!);
  }
}
