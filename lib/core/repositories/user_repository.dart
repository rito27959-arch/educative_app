import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../network/network_info.dart';
import '../errors/app_exceptions.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  final CryptoService _crypto = CryptoService();

  Future<UserModel> createUser(String pseudo, String bacSeries) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final identity = StorageService.generateCryptoIdentity(pseudo);
    _crypto.generateKeyPair(identity);
    final user = UserModel(
      pseudo: pseudo,
      bacSeries: bacSeries,
      cryptoIdentity: identity,
      isGatewayActive: true,
    );
    await StorageService.saveUser(user);
    return user;
  }

  UserModel? getCurrentUser() => StorageService.currentUser;
  bool get isLoggedIn => StorageService.isLoggedIn;

  Future<void> updateProfile({
    String? pseudo,
    String? avatarUrl,
    bool? isGatewayActive,
  }) async {
    final current = StorageService.currentUser;
    if (current == null) {
      throw AuthException('Aucun utilisateur connecté');
    }
    final updated = current.copyWith(
      pseudo: pseudo,
      avatarUrl: avatarUrl,
      isGatewayActive: isGatewayActive,
    );
    await StorageService.saveUser(updated);
  }

  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  String getCryptoIdentity() {
    final user = StorageService.currentUser;
    if (user == null) {
      throw AuthException('Aucun utilisateur connecté');
    }
    return user.cryptoIdentity;
  }

  bool verifyIdentity(String identity) {
    return _crypto.hasKey(identity);
  }
}

class BacSeries {
  static const List<String> all = ['BAC C', 'BAC D', 'BAC TI', 'BAC A'];

  static String getDescription(String bac) {
    switch (bac) {
      case 'BAC C':
        return 'Mathématiques et Sciences Physiques';
      case 'BAC D':
        return 'Sciences de la Vie et de la Terre';
      case 'BAC TI':
        return "Technologies de l'Information";
      case 'BAC A':
        return 'Littéraire';
      default:
        return '';
    }
  }

  static String toSeriesId(String bac) {
    switch (bac) {
      case 'BAC C': return 'c';
      case 'BAC D': return 'd';
      case 'BAC TI': return 'ti';
      case 'BAC A': return 'a';
      default: return 'c';
    }
  }

  static List<String> getRecommendedSubjects(String bac) {
    switch (bac) {
      case 'BAC C':
        return ['Mathématiques', 'Physique', 'Informatique'];
      case 'BAC D':
        return ['SVT', 'Physique', 'Mathématiques'];
      case 'BAC TI':
        return ['Informatique', 'Mathématiques', 'Physique'];
      case 'BAC A':
        return ['Littérature', 'Philosophie', 'Histoire'];
      default:
        return [];
    }
  }
}
