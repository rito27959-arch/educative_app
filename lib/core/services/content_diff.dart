import 'dart:convert';
import '../models/content_package.dart';

/// Utilitaire de diff/version pour les mises à jour de contenu.
///
/// Au lieu de retransmettre l'intégralité d'un contenu à chaque mise à jour,
/// on calcule le diff entre deux versions et on ne transmet que les champs
/// modifiés. Le diff est un simple Map des champs qui ont changé, appliqué
/// par-dessus la version précédente.
class ContentDiff {
  /// Calcule le diff entre deux versions d'un contenu.
  /// Retourne un Map des champs modifiés, ou null si identique.
  static Map<String, dynamic>? compute(Map<String, dynamic> oldData, Map<String, dynamic> newData) {
    final diff = <String, dynamic>{};
    bool hasDiff = false;

    for (final key in newData.keys) {
      final oldVal = oldData[key];
      final newVal = newData[key];
      if (!_deepEquals(oldVal, newVal)) {
        diff[key] = newVal;
        hasDiff = true;
      }
    }

    // Clés supprimées
    for (final key in oldData.keys) {
      if (!newData.containsKey(key)) {
        diff[key] = null; // null = suppression
        hasDiff = true;
      }
    }

    return hasDiff ? diff : null;
  }

  /// Applique un diff à une version précédente.
  static Map<String, dynamic> apply(Map<String, dynamic> base, Map<String, dynamic> diff) {
    final result = Map<String, dynamic>.from(base);
    for (final entry in diff.entries) {
      if (entry.value == null) {
        result.remove(entry.key);
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  /// Crée un package de mise à jour différentielle.
  static ContentPackage? createDiffPackage({
    required ContentPackage previous,
    required Map<String, dynamic> newData,
    required String seederId,
  }) {
    final diff = compute(
      jsonDecode('{}') as Map<String, dynamic>,
      newData,
    );
    if (diff == null || diff.isEmpty) return null;

    final diffBytes = utf8.encode(jsonEncode(diff));
    return ContentPackage(
      id: previous.id,
      version: previous.version + 1,
      checksum: ContentPackage.computeChecksum(diffBytes),
      size: diffBytes.length,
      dependencies: previous.dependencies,
      type: previous.type,
      modelId: previous.modelId,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      seederId: seederId,
      prevVersion: previous.id,
    );
  }

  /// Vérifie si un package est un diff (a un prevVersion).
  static bool isDiff(ContentPackage pkg) => pkg.prevVersion != null;

  static bool _deepEquals(dynamic a, dynamic b) {
    if (a is Map && b is Map) {
      if (a.length != b.length) return false;
      for (final key in a.keys) {
        if (!_deepEquals(a[key], b[key])) return false;
      }
      return true;
    }
    if (a is List && b is List) {
      if (a.length != b.length) return false;
      for (int i = 0; i < a.length; i++) {
        if (!_deepEquals(a[i], b[i])) return false;
      }
      return true;
    }
    return a == b;
  }
}
