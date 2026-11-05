// ============================================================================
// LA PROGRESSION DE L'ÉLÈVE DANS KUNFOX.
// ----------------------------------------------------------------------------
// XP, série de jours, cœurs (5 max, un de plus toutes les 30 min), leçons
// faites, matière en cours, chiffres du jour pour les quêtes. Tout est gardé
// dans les réglages locaux (StorageService) sous la clé `kunfox.progression`.
// ============================================================================

import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/curriculum_data.dart';
import '../../core/models/curriculum_models.dart';
import '../../core/services/storage_service.dart';
import 'compte_droplet.dart';

const int kCoeursMax = 5;
const Duration kRechargeCoeur = Duration(minutes: 30);
const int kObjectifJour = 30; // XP par jour

String jourDe(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class Progression {
  const Progression({
    this.xp = 0,
    this.xpParJour = const {},
    this.serie = 0,
    this.meilleureSerie = 0,
    this.dernierJour,
    this.coeurs = kCoeursMax,
    this.coeurPerduA,
    this.leconsFaites = const {},
    this.scores = const {},
    this.chapitresFaits = const {},
    this.matiere,
    this.leconsDuJour = 0,
    this.sansFauteDuJour = 0,
    this.meilleurCombo = 0,
    this.jourCompteurs,
  });

  final int xp;
  final Map<String, int> xpParJour;
  final int serie;
  final int meilleureSerie;
  final String? dernierJour;
  final int coeurs;
  final DateTime? coeurPerduA;
  final Set<String> leconsFaites;
  final Map<String, int> scores;
  final Set<String> chapitresFaits;
  final String? matiere;
  final int leconsDuJour;
  final int sansFauteDuJour;
  final int meilleurCombo;
  final String? jourCompteurs;

  int get xpAujourdhui => xpParJour[jourDe(DateTime.now())] ?? 0;

  /// La série en vigueur : elle tombe à 0 si un jour entier a été manqué.
  int get serieActuelle {
    if (dernierJour == null) return 0;
    final hier = jourDe(DateTime.now().subtract(const Duration(days: 1)));
    final auj = jourDe(DateTime.now());
    return (dernierJour == auj || dernierJour == hier) ? serie : 0;
  }

  bool get serieFaiteAujourdhui => dernierJour == jourDe(DateTime.now());

  /// Les cœurs en tenant compte de la recharge écoulée.
  int get coeursActuels {
    if (coeurs >= kCoeursMax || coeurPerduA == null) return math.min(coeurs, kCoeursMax);
    final gagnes = DateTime.now().difference(coeurPerduA!).inMinutes ~/ kRechargeCoeur.inMinutes;
    return math.min(kCoeursMax, coeurs + gagnes);
  }

  Duration? get prochainCoeurDans {
    if (coeursActuels >= kCoeursMax || coeurPerduA == null) return null;
    final ecoule = DateTime.now().difference(coeurPerduA!).inSeconds % kRechargeCoeur.inSeconds;
    return Duration(seconds: kRechargeCoeur.inSeconds - ecoule);
  }

  /// Niveau : 100 XP pour le niveau 2, puis +50 par niveau.
  int get niveau {
    var n = 1, seuil = 100, reste = xp;
    while (reste >= seuil) {
      reste -= seuil;
      n++;
      seuil += 50;
    }
    return n;
  }

  Progression copyWith({
    int? xp,
    Map<String, int>? xpParJour,
    int? serie,
    int? meilleureSerie,
    String? dernierJour,
    int? coeurs,
    DateTime? coeurPerduA,
    bool effacerCoeurPerdu = false,
    Set<String>? leconsFaites,
    Map<String, int>? scores,
    Set<String>? chapitresFaits,
    String? matiere,
    int? leconsDuJour,
    int? sansFauteDuJour,
    int? meilleurCombo,
    String? jourCompteurs,
  }) =>
      Progression(
        xp: xp ?? this.xp,
        xpParJour: xpParJour ?? this.xpParJour,
        serie: serie ?? this.serie,
        meilleureSerie: meilleureSerie ?? this.meilleureSerie,
        dernierJour: dernierJour ?? this.dernierJour,
        coeurs: coeurs ?? this.coeurs,
        coeurPerduA: effacerCoeurPerdu ? null : (coeurPerduA ?? this.coeurPerduA),
        leconsFaites: leconsFaites ?? this.leconsFaites,
        scores: scores ?? this.scores,
        chapitresFaits: chapitresFaits ?? this.chapitresFaits,
        matiere: matiere ?? this.matiere,
        leconsDuJour: leconsDuJour ?? this.leconsDuJour,
        sansFauteDuJour: sansFauteDuJour ?? this.sansFauteDuJour,
        meilleurCombo: meilleurCombo ?? this.meilleurCombo,
        jourCompteurs: jourCompteurs ?? this.jourCompteurs,
      );

  Map<String, dynamic> versJson() => {
        'xp': xp,
        'xpParJour': xpParJour,
        'serie': serie,
        'meilleureSerie': meilleureSerie,
        'dernierJour': dernierJour,
        'coeurs': coeurs,
        'coeurPerduA': coeurPerduA?.toIso8601String(),
        'leconsFaites': leconsFaites.toList(),
        'scores': scores,
        'chapitresFaits': chapitresFaits.toList(),
        'matiere': matiere,
        'leconsDuJour': leconsDuJour,
        'sansFauteDuJour': sansFauteDuJour,
        'meilleurCombo': meilleurCombo,
        'jourCompteurs': jourCompteurs,
      };

  static Progression depuisJson(Map<String, dynamic> j) => Progression(
        xp: (j['xp'] as num?)?.toInt() ?? 0,
        xpParJour: ((j['xpParJour'] as Map?) ?? {}).map((k, v) => MapEntry(k as String, (v as num).toInt())),
        serie: (j['serie'] as num?)?.toInt() ?? 0,
        meilleureSerie: (j['meilleureSerie'] as num?)?.toInt() ?? 0,
        dernierJour: j['dernierJour'] as String?,
        coeurs: (j['coeurs'] as num?)?.toInt() ?? kCoeursMax,
        coeurPerduA: DateTime.tryParse(j['coeurPerduA'] as String? ?? ''),
        leconsFaites: ((j['leconsFaites'] as List?) ?? []).cast<String>().toSet(),
        scores: ((j['scores'] as Map?) ?? {}).map((k, v) => MapEntry(k as String, (v as num).toInt())),
        chapitresFaits: ((j['chapitresFaits'] as List?) ?? []).cast<String>().toSet(),
        matiere: j['matiere'] as String?,
        leconsDuJour: (j['leconsDuJour'] as num?)?.toInt() ?? 0,
        sansFauteDuJour: (j['sansFauteDuJour'] as num?)?.toInt() ?? 0,
        meilleurCombo: (j['meilleurCombo'] as num?)?.toInt() ?? 0,
        jourCompteurs: j['jourCompteurs'] as String?,
      );
}

/// Ce que rapporte une leçon terminée, pour l'écran de fin.
class BilanLecon {
  const BilanLecon({
    required this.xp,
    required this.precision,
    required this.duree,
    required this.serieAvant,
    required this.serieApres,
    required this.premiereDuJour,
    required this.niveauAvant,
    required this.niveauApres,
    required this.chapitreFini,
  });

  final int xp;
  final int precision; // en %
  final Duration duree;
  final int serieAvant;
  final int serieApres;
  final bool premiereDuJour;
  final int niveauAvant;
  final int niveauApres;
  final bool chapitreFini;
}

class ProgressionNotifier extends StateNotifier<Progression> {
  ProgressionNotifier() : super(_lire());

  static const _cle = 'kunfox.progression';

  static Progression _lire() {
    try {
      final brut = StorageService.getString(_cle);
      if (brut == null || brut.isEmpty) return const Progression();
      return Progression.depuisJson(jsonDecode(brut) as Map<String, dynamic>);
    } catch (_) {
      return const Progression();
    }
  }

  /// Le profil joint à la sauvegarde (pseudo, série) : fourni par l'app.
  static Map<String, dynamic> Function()? profil;

  void _ecrire(Progression p) {
    state = p;
    StorageService.setString(_cle, jsonEncode(p.versJson()));
    // Connecté avec Droplet : la progression part, chiffrée, quelques
    // secondes après le dernier changement.
    CompteDroplet.planifier(contenuSauvegarde);
  }

  Map<String, dynamic> contenuSauvegarde() => {'v': 1, 'progression': state.versJson(), ...?profil?.call()};

  /// Remplace la progression par celle d'une sauvegarde (nouveau téléphone).
  void remplacer(Map<String, dynamic> json) => _ecrire(Progression.depuisJson(json));

  /// Remet les compteurs du jour à zéro quand on change de jour.
  Progression _jour(Progression p) {
    final auj = jourDe(DateTime.now());
    if (p.jourCompteurs == auj) return p;
    return p.copyWith(leconsDuJour: 0, sansFauteDuJour: 0, jourCompteurs: auj);
  }

  void choisirMatiere(String id) => _ecrire(state.copyWith(matiere: id));

  void perdreCoeur() {
    final p = state;
    final actuels = p.coeursActuels;
    if (actuels <= 0) return;
    // La recharge repart de maintenant, en gardant le temps déjà écoulé
    // vers le prochain cœur.
    final maintenant = DateTime.now();
    var base = maintenant;
    if (actuels < kCoeursMax && p.coeurPerduA != null) {
      final reste = maintenant.difference(p.coeurPerduA!).inSeconds % kRechargeCoeur.inSeconds;
      base = maintenant.subtract(Duration(seconds: reste));
    }
    _ecrire(p.copyWith(coeurs: actuels - 1, coeurPerduA: base));
  }

  void rechargerCoeurs() => _ecrire(state.copyWith(coeurs: kCoeursMax, effacerCoeurPerdu: true));

  void gagnerCoeur() {
    final n = math.min(kCoeursMax, state.coeursActuels + 1);
    _ecrire(n >= kCoeursMax ? state.copyWith(coeurs: n, effacerCoeurPerdu: true) : state.copyWith(coeurs: n));
  }

  /// XP en plus (par exemple « doubler mes XP » après une pub récompensée).
  void bonusXp(int n) {
    if (n <= 0) return;
    final p = state;
    final auj = jourDe(DateTime.now());
    _ecrire(p.copyWith(xp: p.xp + n, xpParJour: {...p.xpParJour, auj: (p.xpParJour[auj] ?? 0) + n}));
  }

  /// Enregistre une leçon (ou une révision si [leconId] est null).
  BilanLecon terminer({
    required String? leconId,
    required int bonnes,
    required int total,
    required Duration duree,
    required int meilleurCombo,
  }) {
    var p = _jour(state);
    final auj = jourDe(DateTime.now());
    final hier = jourDe(DateTime.now().subtract(const Duration(days: 1)));
    final serieAvant = p.serieActuelle;
    final premiere = p.dernierJour != auj;
    final serieApres = premiere ? (p.dernierJour == hier ? p.serie + 1 : 1) : p.serie;
    final precision = total == 0 ? 100 : (bonnes * 100 / total).round();
    final sansFaute = total > 0 && bonnes == total;
    final int xp = ((leconId == null ? 10 : 15) + (sansFaute ? 5 : 0) + math.min(5, meilleurCombo ~/ 3)).toInt();
    final niveauAvant = p.niveau;

    var chapitreFini = false;
    final faites = {...p.leconsFaites};
    final chapitres = {...p.chapitresFaits};
    if (leconId != null) {
      faites.add(leconId);
      final ch = chapitreDe(leconId);
      if (ch != null && !chapitres.contains(ch.id) && ch.lessons.every((l) => faites.contains(l.id))) {
        chapitres.add(ch.id);
        chapitreFini = true;
      }
    }
    p = p.copyWith(
      xp: p.xp + xp,
      xpParJour: {...p.xpParJour, auj: (p.xpParJour[auj] ?? 0) + xp},
      serie: serieApres,
      meilleureSerie: math.max(p.meilleureSerie, serieApres),
      dernierJour: auj,
      leconsFaites: faites,
      chapitresFaits: chapitres,
      scores: leconId == null ? p.scores : {...p.scores, leconId: math.max(p.scores[leconId] ?? 0, precision)},
      leconsDuJour: p.leconsDuJour + 1,
      sansFauteDuJour: p.sansFauteDuJour + (sansFaute ? 1 : 0),
      meilleurCombo: math.max(p.meilleurCombo, meilleurCombo),
    );
    // Réviser rapporte un cœur, comme l'entraînement chez Duolingo.
    if (leconId == null) {
      final n = math.min(kCoeursMax, p.coeursActuels + 1);
      p = n >= kCoeursMax ? p.copyWith(coeurs: n, effacerCoeurPerdu: true) : p.copyWith(coeurs: n);
    }
    _ecrire(p);
    return BilanLecon(
      xp: xp,
      precision: precision,
      duree: duree,
      serieAvant: serieAvant,
      serieApres: serieApres,
      premiereDuJour: premiere,
      niveauAvant: niveauAvant,
      niveauApres: p.niveau,
      chapitreFini: chapitreFini,
    );
  }

  /// Enregistre une épreuve d'unité : série et XP comme une révision, plus
  /// 40 XP et la couronne d'or si elle est remportée pour la première fois.
  BilanBoss terminerBoss({
    required String chapitreId,
    required int bonnes,
    required int total,
    required Duration duree,
    required int meilleurCombo,
  }) {
    final avant = state;
    final dejaReussi = avant.bossReussi(chapitreId);
    final bilan = terminer(leconId: null, bonnes: bonnes, total: total, duree: duree, meilleurCombo: meilleurCombo);
    final precision = total == 0 ? 0 : (bonnes * 100 / total).round();
    final reussi = precision >= kSeuilBoss;
    final bonus = reussi && !dejaReussi ? 40 : 0;
    final auj = jourDe(DateTime.now());
    final p = state;
    _ecrire(p.copyWith(
      xp: p.xp + bonus,
      xpParJour: {...p.xpParJour, auj: (p.xpParJour[auj] ?? 0) + bonus},
      scores: {...p.scores, cleBoss(chapitreId): math.max(p.scores[cleBoss(chapitreId)] ?? 0, precision)},
    ));
    return BilanBoss(
      chapitreId: chapitreId,
      bonnes: bonnes,
      total: total,
      reussi: reussi,
      dejaReussi: dejaReussi,
      xp: bilan.xp + bonus,
      duree: duree,
      lecon: bilan,
    );
  }

  /// Une épreuve type Bac corrigée : la note (sur 20) est gardée (la
  /// meilleure), la série avance, et elle rapporte 5 XP par point.
  BilanLecon enregistrerExamen({required String epreuveId, required double note, required Duration duree}) {
    final bilan = terminer(leconId: null, bonnes: note.round(), total: 20, duree: duree, meilleurCombo: 0);
    final p = state;
    final cle = 'examen:$epreuveId';
    final pct = (note * 5).round().clamp(0, 100);
    final bonus = (note * 5).round();
    final auj = jourDe(DateTime.now());
    _ecrire(p.copyWith(
      xp: p.xp + bonus,
      xpParJour: {...p.xpParJour, auj: (p.xpParJour[auj] ?? 0) + bonus},
      scores: {...p.scores, cle: math.max(p.scores[cle] ?? 0, pct)},
    ));
    return bilan;
  }
}

/// Le bilan d'une épreuve d'unité (le « grand boss »).
class BilanBoss {
  const BilanBoss({
    required this.chapitreId,
    required this.bonnes,
    required this.total,
    required this.reussi,
    required this.dejaReussi,
    required this.xp,
    required this.duree,
    required this.lecon,
  });
  final String chapitreId;
  final int bonnes, total;
  final bool reussi;

  /// L'épreuve était déjà réussie avant : pas de nouvelle couronne.
  final bool dejaReussi;
  final int xp;
  final Duration duree;
  final BilanLecon lecon;
  int get precision => total == 0 ? 0 : (bonnes * 100 / total).round();
}

/// Il faut 70 % pour remporter l'épreuve d'une unité.
const kSeuilBoss = 70;
String cleBoss(String chapitreId) => 'boss:$chapitreId';

extension EpreuvesUnite on Progression {
  /// Meilleure note (sur 20) à une épreuve type Bac.
  double? noteExamen(String epreuveId) {
    final v = scores['examen:$epreuveId'];
    return v == null ? null : v / 5;
  }

  int? scoreBoss(String chapitreId) => scores[cleBoss(chapitreId)];
  bool bossReussi(String chapitreId) => (scoreBoss(chapitreId) ?? 0) >= kSeuilBoss;
}

final progressionProvider = StateNotifierProvider<ProgressionNotifier, Progression>((ref) => ProgressionNotifier());

/// Le chapitre qui contient une leçon.
CurriculumChapter? chapitreDe(String leconId) {
  for (final s in CurriculumData.all) {
    for (final c in s.chapters) {
      if (c.lessons.any((l) => l.id == leconId)) return c;
    }
  }
  return null;
}

/// L'état d'une leçon sur le parcours.
enum EtatNoeud { faite, actuelle, verrouillee }

/// Toutes les leçons d'une matière, dans l'ordre du parcours.
List<Lesson> leconsDe(SubjectCurriculum s) {
  final chapitres = [...s.chapters]..sort((a, b) => a.order.compareTo(b.order));
  return [
    for (final c in chapitres) ...([...c.lessons]..sort((a, b) => a.order.compareTo(b.order))),
  ];
}

/// La leçon à faire maintenant dans une matière : la première non faite.
String? leconActuelle(SubjectCurriculum s, Progression p) {
  for (final l in leconsDe(s)) {
    if (!p.leconsFaites.contains(l.id)) return l.id;
  }
  return null;
}

EtatNoeud etatLecon(SubjectCurriculum s, Progression p, String leconId) {
  if (p.leconsFaites.contains(leconId)) return EtatNoeud.faite;
  return leconActuelle(s, p) == leconId ? EtatNoeud.actuelle : EtatNoeud.verrouillee;
}
