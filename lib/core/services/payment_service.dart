import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/payment_model.dart';
import 'storage_service.dart';
import 'mobile_money_api.dart';

/// Service de paiement et récompenses — Cameroun.
///
/// ## Paiement unique : Mobile Money Cameroun
/// L'utilisateur reçoit une notification USSD et confirme le retrait
/// depuis son app Orange Money ou MTN Mobile Money.
///
/// ## 20 récompenses
/// L'App paie l'utilisateur en coins pour ses actions positives.
class PaymentService {
  final MobileMoneyApi _mobileApi = MobileMoneyApi();

  Wallet _wallet = const Wallet();
  bool _initialized = false;

  String? _pendingTopUpId;
  double? _pendingAmount;
  String? _pendingPhone;

  Wallet get wallet => _wallet;
  int get streakFreezesAvailable => _wallet.streakFreezesAvailable;
  String? get pendingTopUpId => _pendingTopUpId;

  // ── Initialisation ────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;
    await _loadWallet();
    _initialized = true;
    debugPrint('[PaymentService] wallet: ${_wallet.balanceFcfa} FCFA, ${_wallet.coinBalance} coins');
  }

  Future<void> _loadWallet() async {
    final json = StorageService.getString('wallet_data');
    if (json == null || json.isEmpty) {
      _wallet = const Wallet(balanceFcfa: 5000, coinBalance: 200);
      await _saveWallet();
      return;
    }
    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final transactions = (data['transactions'] as List?)
              ?.map((t) => Transaction.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [];
      final rewards = (data['rewards'] as List?)
              ?.map((r) => Reward.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [];
      _wallet = Wallet(
        balanceFcfa: (data['balanceFcfa'] as num?)?.toDouble() ?? 0,
        coinBalance: data['coinBalance'] as int? ?? 0,
        recentTransactions: transactions,
        recentRewards: rewards,
        hasPin: data['hasPin'] as bool? ?? false,
        monthlySpendFcfa: (data['monthlySpendFcfa'] as num?)?.toDouble() ?? 0,
        monthlyLimitFcfa: (data['monthlyLimitFcfa'] as num?)?.toDouble() ?? 50000,
        streakFreezesAvailable: data['streakFreezesAvailable'] as int? ?? 0,
      );
    } catch (e) {
      debugPrint('[PaymentService] Erreur chargement wallet: $e');
      _wallet = const Wallet(balanceFcfa: 5000, coinBalance: 200);
    }
  }

  Future<void> _saveWallet() async {
    final data = {
      'balanceFcfa': _wallet.balanceFcfa,
      'coinBalance': _wallet.coinBalance,
      'transactions': _wallet.recentTransactions.map((t) => t.toJson()).toList(),
      'rewards': _wallet.recentRewards.map((r) => r.toJson()).toList(),
      'hasPin': _wallet.hasPin,
      'monthlySpendFcfa': _wallet.monthlySpendFcfa,
      'monthlyLimitFcfa': _wallet.monthlyLimitFcfa,
      'streakFreezesAvailable': _wallet.streakFreezesAvailable,
    };
    await StorageService.setString('wallet_data', jsonEncode(data));
  }

  // ── 20 récompenses (l'App paie l'utilisateur) ────────────────────────────

  Future<Reward> earnReward(RewardType type) async {
    final info = RewardInfo.fromType(type);
    final reward = Reward(
      id: const Uuid().v4(),
      type: type,
      coinAmount: info.coinAmount,
      earnedAt: DateTime.now(),
    );

    _wallet = _wallet.copyWith(
      coinBalance: _wallet.coinBalance + info.coinAmount,
      recentRewards: [reward, ..._wallet.recentRewards].take(50).toList(),
    );
    await _saveWallet();
    debugPrint('[PaymentService] 🎉 Récompense: ${info.title} → +${info.coinAmount} coins');
    return reward;
  }

  bool useStreakFreeze() {
    if (_wallet.coinBalance < 50) return false;
    _wallet = _wallet.copyWith(
      coinBalance: _wallet.coinBalance - 50,
      streakFreezesAvailable: _wallet.streakFreezesAvailable + 1,
    );
    _saveWallet();
    return true;
  }

  bool hasEarned(RewardType type) =>
      _wallet.recentRewards.any((r) => r.type == type);

  int earnCount(RewardType type) =>
      _wallet.recentRewards.where((r) => r.type == type).length;

  // ── Wallet (porte-monnaie FCFA) ───────────────────────────────────────────

  /// Étape 1 : Demander un retrait Mobile Money.
  ///
  /// L'utilisateur reçoit un USSD et doit confirmer sur son téléphone.
  /// Appelle [confirmTopUp] après confirmation.
  Future<MobileMoneyResult> requestTopUp({
    required double amountFcfa,
    required String phoneNumber,
  }) async {
    final result = await _mobileApi.requestWithdrawal(
      phoneNumber: phoneNumber,
      amountFcfa: amountFcfa,
    );

    if (result.success) {
      _pendingTopUpId = result.transactionId;
      _pendingPhone = phoneNumber;
      _pendingAmount = amountFcfa;
      _mobileApi.resetSimulation();
    }

    return result;
  }

  /// Étape 2 : Vérifier si l'utilisateur a confirmé le retrait sur son téléphone.
  ///
  /// Une fois confirmé, le wallet est crédité.
  Future<MobileMoneyResult> checkTopUpStatus() async {
    if (_pendingTopUpId == null) {
      return MobileMoneyResult.failure('Aucun top-up en cours.');
    }

    final result = await _mobileApi.checkStatus(_pendingTopUpId!);

    if (result.status == MobileMoneyStatus.confirmed && _pendingAmount != null) {
      final tx = Transaction(
        id: const Uuid().v4(),
        description: 'Recharge wallet — Mobile Money Cameroun',
        amountFcfa: _pendingAmount!,
        feeFcfa: 0,
        status: TransactionStatus.completed,
        timestamp: DateTime.now(),
        reference: _pendingTopUpId,
        isCredit: true,
      );

      _wallet = _wallet.copyWith(
        balanceFcfa: _wallet.balanceFcfa + _pendingAmount!,
        recentTransactions: [tx, ..._wallet.recentTransactions].take(50).toList(),
      );
      await _saveWallet();

      _pendingTopUpId = null;
      _pendingAmount = null;
      _pendingPhone = null;
    }

    return result;
  }

  /// Paiement via le wallet (solde FCFA suffisant requis).
  Future<Transaction> payWithWallet({
    required double amountFcfa,
    required String description,
  }) async {
    if (_wallet.balanceFcfa < amountFcfa) {
      throw Exception('Solde insuffisant — ${_wallet.balanceFcfa} FCFA');
    }

    final tx = Transaction(
      id: const Uuid().v4(),
      description: description,
      amountFcfa: amountFcfa,
      feeFcfa: 0,
      status: TransactionStatus.completed,
      timestamp: DateTime.now(),
      reference: 'PAY-${DateTime.now().millisecondsSinceEpoch}',
    );

    _wallet = _wallet.copyWith(
      balanceFcfa: _wallet.balanceFcfa - amountFcfa,
      monthlySpendFcfa: _wallet.monthlySpendFcfa + amountFcfa,
      recentTransactions: [tx, ..._wallet.recentTransactions].take(50).toList(),
    );
    await _saveWallet();
    return tx;
  }

  // ── Abonnement Premium ────────────────────────────────────────────────────

  static const double premiumMonthlyFcfa = 1500;
  static const double premiumYearlyFcfa = 12000;

  Future<Transaction> subscribePremiumMonthly() async {
    if (_wallet.balanceFcfa < premiumMonthlyFcfa) {
      throw Exception('Solde insuffisant. Recharge ton wallet d\'abord.');
    }
    return payWithWallet(
      amountFcfa: premiumMonthlyFcfa,
      description: 'Abonnement Ouro Premium — Mensuel',
    );
  }

  Future<Transaction> subscribePremiumYearly() async {
    if (_wallet.balanceFcfa < premiumYearlyFcfa) {
      throw Exception('Solde insuffisant. Recharge ton wallet d\'abord.');
    }
    return payWithWallet(
      amountFcfa: premiumYearlyFcfa,
      description: 'Abonnement Ouro Premium — Annuel (économie 6000 FCFA)',
    );
  }

  // ── PIN ───────────────────────────────────────────────────────────────────

  bool verifyPin(String pin) {
    final storedHash = StorageService.getString('wallet_pin_hash');
    if (storedHash == null) return true;
    return _hashPin(pin) == storedHash;
  }

  Future<void> setPin(String pin) async {
    await StorageService.setString('wallet_pin_hash', _hashPin(pin));
    _wallet = _wallet.copyWith(hasPin: true);
    await _saveWallet();
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode('ouro_wallet_$pin');
    return bytes.map((b) => b.toRadixString(16)).join();
  }
}
