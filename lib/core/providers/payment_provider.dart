import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_model.dart';
import '../services/payment_service.dart';
import '../services/mobile_money_api.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  final service = PaymentService();
  ref.onDispose(() => service.init());
  return service;
});

final walletProvider = StateNotifierProvider<WalletNotifier, Wallet>((ref) {
  final service = ref.watch(paymentServiceProvider);
  return WalletNotifier(service);
});

final topUpStateProvider = StateProvider<TopUpState?>((_) => null);

class TopUpState {
  final String transactionId;
  final String phoneNumber;
  final double amountFcfa;
  final String operator;
  final bool isPending;

  const TopUpState({
    required this.transactionId,
    required this.phoneNumber,
    required this.amountFcfa,
    required this.operator,
    this.isPending = true,
  });
}

class WalletNotifier extends StateNotifier<Wallet> {
  final PaymentService _service;

  WalletNotifier(this._service) : super(_service.wallet) {
    _service.init().then((_) => state = _service.wallet);
  }

  /// Étape 1 : initier le retrait Mobile Money
  Future<MobileMoneyResult> requestTopUp({
    required double amountFcfa,
    required String phoneNumber,
  }) async {
    return _service.requestTopUp(amountFcfa: amountFcfa, phoneNumber: phoneNumber);
  }

  /// Étape 2 : vérifier si l'utilisateur a confirmé
  Future<MobileMoneyResult> checkTopUpStatus() async {
    final result = await _service.checkTopUpStatus();
    state = _service.wallet;
    return result;
  }

  Future<void> payWithWallet({
    required double amountFcfa,
    required String description,
  }) async {
    await _service.payWithWallet(amountFcfa: amountFcfa, description: description);
    state = _service.wallet;
  }

  Future<void> earnReward(RewardType type) async {
    await _service.earnReward(type);
    state = _service.wallet;
  }

  bool useStreakFreeze() {
    final ok = _service.useStreakFreeze();
    if (ok) state = _service.wallet;
    return ok;
  }

  Future<void> subscribePremiumMonthly() async {
    await _service.subscribePremiumMonthly();
    state = _service.wallet;
  }

  Future<void> subscribePremiumYearly() async {
    await _service.subscribePremiumYearly();
    state = _service.wallet;
  }

  Future<void> setPin(String pin) async {
    await _service.setPin(pin);
    state = _service.wallet;
  }
}

final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  return ref.watch(walletProvider).recentTransactions;
});

final rewardsProvider = Provider<List<Reward>>((ref) {
  return ref.watch(walletProvider).recentRewards;
});

final coinBalanceProvider = Provider<int>((ref) {
  return ref.watch(walletProvider).coinBalance;
});

final streakFreezesProvider = Provider<int>((ref) {
  return ref.watch(walletProvider).streakFreezesAvailable;
});
