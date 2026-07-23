import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_model.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/proof_of_work.dart';
import 'payment_provider.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    onReward: (type) => ref.read(walletProvider.notifier).earnReward(type),
  );
});

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final UserModel? user;
  final String? errorMessage;
  final double powProgress;

  const AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.user,
    this.errorMessage,
    this.powProgress = 0.0,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    UserModel? user,
    String? errorMessage,
    double? powProgress,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      errorMessage: errorMessage,
      powProgress: powProgress ?? this.powProgress,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final void Function(RewardType) _earnReward;

  AuthNotifier({required void Function(RewardType) onReward})
      : _earnReward = onReward,
        super(const AuthState()) {
    _checkAuth();
  }

  void _checkAuth() {
    final saved = StorageService.currentUser;
    if (saved != null && StorageService.isLoggedIn) {
      state = AuthState(isLoggedIn: true, user: saved);
    }
  }

  String _deriveIdentity(String pseudo, String bacSeries) {
    final raw = '$pseudo:$bacSeries:${StorageService.generateId()}';
    return sha256.convert(utf8.encode(raw)).toString();
  }

  /// Connexion locale avec preuve de travail anti-bot.
  Future<void> login(String pseudo, String bacSeries) async {
    state = state.copyWith(isLoading: true, errorMessage: null, powProgress: 0.0);

    try {
      // 1. Estimer la difficulté CPU
      final difficulty = await ProofOfWork.estimateDifficulty();

      // 2. Générer le challenge
      final challenge = ProofOfWork.generateChallenge();

      // 3. Résoudre la preuve de travail (dans un isolate)
      final pow = await ProofOfWork.solve(
        challenge: challenge,
        difficultyBits: difficulty,
      );

      // 4. Vérifier (toujours vrai, mais prouve que le CPU a travaillé)
      assert(pow.verify(), 'La preuve de travail devrait être valide');

      // 5. Créer l'identité locale
      final cryptoIdentity = _deriveIdentity(pseudo, bacSeries);
      final user = UserModel(
        pseudo: pseudo,
        bacSeries: bacSeries,
        cryptoIdentity: cryptoIdentity,
      );

      await StorageService.saveUser(user);
      state = AuthState(isLoggedIn: true, user: user);

      _earnReward(RewardType.dailyLogin);

      final lastStudy = StorageService.getLastStudyDate();
      if (lastStudy != null && DateTime.now().difference(lastStudy).inDays >= 7) {
        _earnReward(RewardType.comebackBonus);
      }

      final earlyGiven = StorageService.getString('early_adopter_given');
      if (earlyGiven == null || earlyGiven.isEmpty) {
        await StorageService.setString('early_adopter_given', '1');
        _earnReward(RewardType.earlyAdopter);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur de vérification anti-bot: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void updateUser(UserModel user) {
    state = state.copyWith(user: user);
  }

  Future<void> logout() async {
    state = const AuthState();
  }
}
