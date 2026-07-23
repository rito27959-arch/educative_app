import 'dart:convert';
import 'dart:isolate';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

bool _checkDifficulty(String hash, int bits) {
  final prefixZeros = bits ~/ 4;
  final prefix = hash.substring(0, prefixZeros);
  return prefix == '0' * prefixZeros;
}

_SolveResult _solveWork(_SolveParams params) {
  int nonce = 0;
  final maxAttempts = 1 << (params.difficultyBits + 2);
  while (nonce < maxAttempts) {
    final data = utf8.encode('${params.challenge}:$nonce');
    final hash = sha256.convert(data).toString();
    if (_checkDifficulty(hash, params.difficultyBits)) {
      return _SolveResult(nonce: nonce, hash: hash);
    }
    nonce++;
  }
  throw Exception('Proof of work non trouvé après $maxAttempts tentatives');
}

int _benchWork(_SolveParams params) {
  int count = 0;
  final stop = DateTime.now().add(const Duration(milliseconds: 500));
  while (DateTime.now().isBefore(stop)) {
    sha256.convert(utf8.encode('bench:$count'));
    count++;
  }
  return count * 2;
}

class _SolveParams {
  final String challenge;
  final int difficultyBits;
  _SolveParams({required this.challenge, required this.difficultyBits});
}

class _SolveResult {
  final int nonce;
  final String hash;
  _SolveResult({required this.nonce, required this.hash});
}

class ProofOfWork {
  final String challenge;
  final int difficultyBits;
  final int nonce;
  final String hash;

  const ProofOfWork({
    required this.challenge,
    required this.difficultyBits,
    required this.nonce,
    required this.hash,
  });

  Map<String, dynamic> toJson() => {
    'challenge': challenge,
    'difficultyBits': difficultyBits,
    'nonce': nonce,
    'hash': hash,
  };

  bool verify() {
    final computed = sha256
        .convert(utf8.encode('$challenge:$nonce'))
        .toString();
    if (computed != hash) return false;
    return _checkDifficulty(hash, difficultyBits);
  }

  static String generateChallenge() {
    final random = DateTime.now().microsecondsSinceEpoch.toString();
    final data = utf8.encode(random);
    return sha256.convert(data).toString().substring(0, 16);
  }

  static Future<ProofOfWork> solve({
    required String challenge,
    required int difficultyBits,
    void Function(double progress)? onProgress,
  }) async {
    final startTime = DateTime.now();

    final result = await Isolate.run<_SolveResult>(
      () => _solveWork(_SolveParams(
        challenge: challenge,
        difficultyBits: difficultyBits,
      )),
    );

    final elapsed = DateTime.now().difference(startTime);
    debugPrint('[POW] Résolu en ${elapsed.inMilliseconds}ms, '
        'nonce=${result.nonce}, hash=${result.hash.substring(0, 12)}…');

    return ProofOfWork(
      challenge: challenge,
      difficultyBits: difficultyBits,
      nonce: result.nonce,
      hash: result.hash,
    );
  }

  static Future<int> estimateDifficulty() async {
    final result = await Isolate.run<int>(
      () => _benchWork(_SolveParams(challenge: '', difficultyBits: 0)),
    );
    debugPrint('[POW] Bench: $result hash/s');
    if (result > 500000) return 22;
    if (result > 100000) return 20;
    return 18;
  }
}
