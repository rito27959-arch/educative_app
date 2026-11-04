// Les duels Kunfox : défier un ami sur la même leçon.
//
// Celui qui lance le duel joue d'abord ; on envoie à la boîte de Droplet les
// questions exactes qu'il a eues et son parcours (juste/faux et temps de
// chaque réponse). On obtient un code court à partager. L'ami qui ouvre le
// lien reçoit les mêmes questions et court contre le « fantôme » du créateur,
// puis dépose son résultat. Le créateur retrouve ses duels dans Réviser.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../core/models/quiz_question.dart';
import '../../core/services/storage_service.dart';

const _boite = 'https://droplet-mailbox-production.up.railway.app';
const _cleMesDuels = 'kunfox_mes_duels';

/// Le lien à partager : la page du site ouvre l'app (ou propose de l'installer).
String lienDuel(String code) => 'https://kunfox.dropletmesh.app/d/$code';

class Joueur {
  const Joueur({required this.nom, required this.traces, this.avatar = 0});
  final String nom;

  /// Une case par question : (juste, millisecondes).
  final List<(bool, int)> traces;
  final int avatar;

  int get bonnes => traces.where((t) => t.$1).length;
  int get ms => traces.fold(0, (a, t) => a + t.$2);

  /// Meilleur score d'abord ; à égalité, le plus rapide.
  int comparer(Joueur autre) => bonnes != autre.bonnes ? bonnes.compareTo(autre.bonnes) : autre.ms.compareTo(ms);

  Map<String, dynamic> versJson() => {
        'nom': nom,
        'avatar': avatar,
        'traces': [for (final t in traces) [t.$1 ? 1 : 0, t.$2]],
      };

  static Joueur depuisJson(Map<String, dynamic> j) => Joueur(
        nom: j['nom'] as String? ?? '?',
        avatar: j['avatar'] as int? ?? 0,
        traces: [
          for (final t in (j['traces'] as List? ?? const []))
            ((t as List)[0] == 1, (t[1] as num).toInt()),
        ],
      );
}

class Duel {
  const Duel({
    required this.code,
    required this.lecon,
    required this.titre,
    required this.matiere,
    required this.questions,
    required this.createur,
    required this.adversaires,
  });
  final String code;
  final String lecon;
  final String titre;
  final String matiere;
  final List<QuizQuestion> questions;
  final Joueur createur;
  final List<Joueur> adversaires;

  static Duel depuisJson(Map<String, dynamic> j) => Duel(
        code: j['code'] as String,
        lecon: j['lecon'] as String,
        titre: j['titre'] as String,
        matiere: j['matiere'] as String? ?? '',
        questions: [
          for (final (i, q) in (j['questions'] as List).indexed)
            QuizQuestion(
              id: 'duel_${j['code']}_$i',
              question: q['question'] as String,
              options: (q['options'] as List).cast<String>(),
              correctIndex: q['bonne'] as int,
              lessonId: j['lecon'] as String,
              explanation: q['explication'] as String? ?? '',
            ),
        ],
        createur: Joueur.depuisJson(j['createur'] as Map<String, dynamic>),
        adversaires: [for (final a in (j['adversaires'] as List? ?? const [])) Joueur.depuisJson(a as Map<String, dynamic>)],
      );
}

/// Ce qu'une séance de duel emporte avec elle.
class PartieDuel {
  const PartieDuel({required this.lecon, required this.titre, required this.matiere, required this.questions, this.duel});
  final String lecon;
  final String titre;
  final String matiere;
  final List<QuizQuestion> questions;

  /// Null : on lance un nouveau duel. Sinon : on relève celui d'un ami.
  final Duel? duel;
}

/// Le bilan d'une séance de duel, pour l'écran de fin.
class BilanDuel {
  const BilanDuel({required this.partie, required this.moi, this.code, this.erreur});
  final PartieDuel partie;
  final Joueur moi;

  /// Le code du duel créé ou releve (null si l'envoi a échoué).
  final String? code;
  final String? erreur;
}

class ErreurDuel implements Exception {
  ErreurDuel(this.message);
  final String message;
  @override
  String toString() => message;
}

abstract final class Duels {
  static Future<(int, Object?)> _requete(String methode, String chemin, [Object? corps]) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
    try {
      final req = await client.openUrl(methode, Uri.parse('$_boite$chemin'));
      if (corps != null) {
        req.headers.contentType = ContentType.json;
        req.write(jsonEncode(corps));
      }
      final rep = await req.close().timeout(const Duration(seconds: 15));
      final texte = await rep.transform(utf8.decoder).join();
      return (rep.statusCode, texte.isEmpty ? null : jsonDecode(texte));
    } on SocketException {
      throw ErreurDuel('Pas de connexion internet.');
    } on TimeoutException {
      throw ErreurDuel('Le serveur ne répond pas.');
    } finally {
      client.close();
    }
  }

  /// Envoie mon parcours et rend le code du nouveau duel.
  static Future<String> creer(PartieDuel p, Joueur moi) async {
    final (statut, j) = await _requete('POST', '/kunfox/duels', {
      'lecon': p.lecon,
      'titre': p.titre,
      'matiere': p.matiere,
      'questions': [
        for (final q in p.questions)
          {'question': q.question, 'options': q.options, 'bonne': q.correctIndex, 'explication': q.explanation},
      ],
      'createur': moi.versJson(),
    });
    if (statut != 201 || j is! Map) throw ErreurDuel('Le duel n\'a pas pu être créé ($statut).');
    final code = j['code'] as String;
    await _retenir(code, p.titre);
    return code;
  }

  static Future<Duel> lire(String code) async {
    final (statut, j) = await _requete('GET', '/kunfox/duels/${code.toUpperCase()}');
    if (statut == 404) throw ErreurDuel('Ce duel n\'existe plus (un duel dure 30 jours).');
    if (statut != 200 || j is! Map<String, dynamic>) throw ErreurDuel('Duel illisible ($statut).');
    return Duel.depuisJson(j);
  }

  static Future<void> repondre(String code, String titre, Joueur moi) async {
    final (statut, _) = await _requete('POST', '/kunfox/duels/$code/resultat', moi.versJson());
    if (statut != 200) throw ErreurDuel('Ton résultat n\'a pas pu être envoyé ($statut).');
    await _retenir(code, titre, releve: true);
  }

  // ── mes duels, gardés sur le téléphone : [{code, titre, quand, releve}]
  static List<Map<String, dynamic>> mesDuels() {
    try {
      final brut = StorageService.getString(_cleMesDuels);
      if (brut == null) return [];
      return (jsonDecode(brut) as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('[Kunfox] duels illisibles : $e');
      return [];
    }
  }

  static Future<void> _retenir(String code, String? titre, {bool releve = false}) async {
    final liste = mesDuels()..removeWhere((d) => d['code'] == code);
    liste.insert(0, {
      'code': code,
      if (titre != null) 'titre': titre,
      'quand': DateTime.now().toIso8601String(),
      'releve': releve,
    });
    await StorageService.setString(_cleMesDuels, jsonEncode(liste.take(20).toList()));
  }

  /// Le prénom affiché dans les duels.
  static String monNom() {
    final p = StorageService.currentUser?.pseudo.trim() ?? '';
    return p.isEmpty ? 'Moi' : (p.length > 24 ? p.substring(0, 24) : p);
  }
}
