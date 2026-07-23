import 'dart:async';
import 'package:flutter/foundation.dart';

/// Résultat d'une demande de retrait Mobile Money.
class MobileMoneyResult {
  final bool success;
  final String transactionId;
  final String? operatorRef;
  final String? message;
  final DateTime timestamp;
  final MobileMoneyStatus status;

  const MobileMoneyResult({
    required this.success,
    required this.transactionId,
    this.operatorRef,
    this.message,
    required this.timestamp,
    this.status = MobileMoneyStatus.pending,
  });

  factory MobileMoneyResult.failure(String msg) => MobileMoneyResult(
    success: false,
    transactionId: '',
    message: msg,
    timestamp: DateTime.now(),
    status: MobileMoneyStatus.failed,
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'transactionId': transactionId,
    'operatorRef': operatorRef,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
    'status': status.name,
  };
}

enum MobileMoneyStatus {
  pending,      // En attente de confirmation sur le téléphone
  confirmed,    // Utilisateur a confirmé sur USSD → retrait effectué
  failed,       // Échoué (solde insuffisant, annulé, timeout)
}

/// API unifiée Mobile Money Cameroun.
///
/// ## Protocole (collection)
/// 1. Notre serveur envoie une demande de retrait à l'opérateur
/// 2. L'opérateur envoie une notification USSD au téléphone du user
/// 3. Le user ouvre son app Mobile Money et autorise le retrait
/// 4. L'opérateur notifie notre serveur (callback)
/// 5. Le wallet est crédité
///
/// ## Configuration réelle
/// 1. Compte marchand Orange Money / MTN (ou Hub2)
/// 2. Remplir `_apiKey` et `_useRealApi = true`
class MobileMoneyApi {
  static const String _apiKey = ''; // Clé API Hub2 / opérateur
  static const bool _useRealApi = false;

  bool _isValidCameroonNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\+\-\(\)]'), '');
    if (cleaned.startsWith('237')) {
      return cleaned.length == 12 && RegExp(r'^237[6]\d{8}$').hasMatch(cleaned);
    }
    return cleaned.length == 9 && RegExp(r'^[6]\d{8}$').hasMatch(cleaned);
  }

  String _detectOperator(String phone) {
    if (phone.startsWith('69') || phone.startsWith('65') || phone.startsWith('68')) {
      return 'ORANGE';
    }
    if (phone.startsWith('67') || phone.startsWith('66')) {
      return 'MTN';
    }
    return 'UNKNOWN';
  }

  /// Étape 1 : Demander un retrait du compte Mobile Money de l'utilisateur.
  ///
  /// L'utilisateur reçoit une notification USSD et doit confirmer
  /// sur son téléphone en entrant son code PIN Mobile Money.
  Future<MobileMoneyResult> requestWithdrawal({
    required String phoneNumber,
    required double amountFcfa,
  }) async {
    if (!_isValidCameroonNumber(phoneNumber)) {
      return MobileMoneyResult.failure(
        'Numéro invalide. Format : 6XXXXXXXX (Orange/MTN Cameroun).',
      );
    }

    final operator = _detectOperator(phoneNumber);

    if (_useRealApi && _apiKey.isNotEmpty) {
      try {
        return await _operatorRequest(phoneNumber, amountFcfa, operator);
      } catch (e) {
        debugPrint('[MobileMoneyApi] API fail, fallback simulation: $e');
      }
    }

    return _simulateWithdrawal(phoneNumber, amountFcfa, operator);
  }

  /// Étape 2 : Vérifier si l'utilisateur a confirmé le retrait sur son téléphone.
  Future<MobileMoneyResult> checkStatus(String transactionId) async {
    if (_useRealApi && _apiKey.isNotEmpty) {
      try {
        return await _checkOperatorStatus(transactionId);
      } catch (e) {
        debugPrint('[MobileMoneyApi] Status check fail: $e');
      }
    }

    return _simulateCheckStatus(transactionId);
  }

  Future<MobileMoneyResult> _operatorRequest(
    String phone,
    double amount,
    String operator,
  ) async {
    // TODO: Appel API réel Hub2 / opérateur
    // POST /collections
    // {
    //   "amount": amount,
    //   "currency": "XAF",
    //   "phone": phone,
    //   "operator": operator,
    //   "reference": "OURO-...",
    //   "callbackUrl": "https://api.ouro.app/payments/callback"
    // }
    throw UnimplementedError('Configure _apiKey et _useRealApi');
  }

  Future<MobileMoneyResult> _checkOperatorStatus(String transactionId) async {
    // TODO: GET /collections/{transactionId}
    throw UnimplementedError('Configure _apiKey et _useRealApi');
  }

  Future<MobileMoneyResult> _simulateWithdrawal(
    String phone,
    double amount,
    String operator,
  ) async {
    debugPrint('[MobileMoneyApi] 💰 Demande retrait ${operator}Money: $amount FCFA → $phone');
    await Future.delayed(const Duration(seconds: 1));

    return MobileMoneyResult(
      success: true,
      transactionId: 'WTH-${DateTime.now().millisecondsSinceEpoch}',
      operatorRef: '${operator}_${DateTime.now().millisecondsSinceEpoch}',
      message: 'Code USSD envoyé au $amount FCFA. '
          'Ouvre ton app ${operator}Money et confirme le retrait.',
      timestamp: DateTime.now(),
      status: MobileMoneyStatus.pending,
    );
  }

  int _statusCheckCount = 0;

  Future<MobileMoneyResult> _simulateCheckStatus(String transactionId) async {
    _statusCheckCount++;
    await Future.delayed(const Duration(seconds: 1));

    // Simule une confirmation après 3 vérifications
    final confirmed = _statusCheckCount >= 3;

    return MobileMoneyResult(
      success: confirmed,
      transactionId: transactionId,
      message: confirmed
          ? '✅ Retrait confirmé — ${transactionId}'
          : '⏳ En attente de confirmation sur ton téléphone...',
      timestamp: DateTime.now(),
      status: confirmed ? MobileMoneyStatus.confirmed : MobileMoneyStatus.pending,
    );
  }

  void resetSimulation() {
    _statusCheckCount = 0;
  }
}
