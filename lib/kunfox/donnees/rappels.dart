// ============================================================================
// LES RAPPELS DE KUNFOX — des notifications qui donnent envie, pas qui
// harcèlent.
// ----------------------------------------------------------------------------
// Ce qui fait la force des rappels d'une app d'apprentissage :
//
//  1. LE BON MOMENT. Kunfox retient l'heure à laquelle l'élève fait ses
//     leçons (médiane des dernières) et le rappelle à CETTE heure-là.
//  2. LA SÉRIE EN DANGER. Le soir, si la flamme n'est pas encore allumée
//     aujourd'hui, un rappel dit combien de jours sont en jeu et combien
//     d'heures il reste.
//  3. UNE VOIX. Kunfox parle comme un ami un peu taquin, jamais culpabilisant.
//     Des dizaines de formulations, jamais deux fois la même d'affilée.
//  4. APPRENDRE CE QUI MARCHE. Chaque formulation compte ses envois et ses
//     ouvertures ; les plus efficaces sortent plus souvent (bandit manchot,
//     échantillonnage de Thompson simplifié), sans jamais oublier les autres.
//  5. SAVOIR SE TAIRE. Plus l'élève s'absente, moins Kunfox écrit, puis il
//     envoie un dernier mot (« Je vais arrêter de t'écrire… ») et se tait,
//     jusqu'au retour de l'élève.
//
// Tout est local : les rappels sont programmés sur le téléphone pour les
// 7 jours qui viennent, et reprogrammés à chaque ouverture et chaque leçon.
// Aucun serveur, aucune connexion nécessaire.
// ============================================================================

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../core/services/storage_service.dart';
import 'progression.dart';

/// Une formulation : un titre, un texte, l'image de Kunfox qui va avec.
class _Modele {
  const _Modele(this.id, this.titre, this.texte, this.humeur, {this.grande});
  final String id, titre, texte, humeur;
  final String? grande; // image large (série en danger, adieu…)
}

// {n} jours de série · {h} heures restantes · {m} matière · {p} pseudo
const _quotidien = [
  _Modele('q1', 'C\'est l\'heure de ta leçon 🦊', 'Cinq minutes, c\'est tout ce que je te demande.', 'salut'),
  _Modele('q2', 'Ta leçon de {m} t\'attend', 'Elle est courte, promis. On y va ?', 'attente'),
  _Modele('q3', 'Psst, {p}… 👀', 'Une petite leçon et ton cerveau te dira merci.', 'reflexion'),
  _Modele('q4', 'Le BAC ne va pas se réviser tout seul 😅', 'Allez, une leçon et tu es tranquille pour aujourd\'hui.', 'joie'),
  _Modele('q5', 'Kunfox s\'ennuie un peu', 'Je tourne en rond dans ton téléphone. Une leçon ensemble ?', 'attente'),
  _Modele('q6', 'Un défi pour toi 🎯', 'Cinq questions, zéro faute. Tu relèves ?', 'joie'),
  _Modele('q7', 'Toc toc 🚪', 'C\'est Kunfox. J\'ai une leçon toute prête pour toi.', 'salut'),
  _Modele('q8', 'Petit rappel amical 🦊', 'Les champions révisent un peu chaque jour. Toi aussi.', 'reflexion'),
];
const _danger = [
  _Modele('d1', '🔥 Ta série de {n} jours est en danger !', 'Il reste {h} h pour la sauver. Une seule leçon suffit.', 'courage', grande: 'danger'),
  _Modele('d2', 'Ne laisse pas ta flamme s\'éteindre 🥺', '{n} jours d\'efforts… Cinq minutes et elle repart de plus belle.', 'courage', grande: 'danger'),
  _Modele('d3', 'Ta flamme tremble… 🔥', 'Encore {h} h avant minuit. Je crois en toi !', 'courage', grande: 'danger'),
  _Modele('d4', 'SOS série ! 🚨', '{n} jours, ce serait dommage de tout recommencer demain.', 'courage', grande: 'danger'),
];
const _retour = [
  _Modele('r1', 'Kunfox t\'a gardé ta place 🦊', 'Reprends là où tu t\'es arrêté. Ça ira vite.', 'salut', grande: 'retour'),
  _Modele('r2', 'Tu me manques, {p}', 'Une petite leçon pour se retrouver ?', 'courage', grande: 'retour'),
  _Modele('r3', 'On reprend doucement ?', 'Une leçon facile pour relancer la machine.', 'attente', grande: 'retour'),
];
const _adieu = _Modele('a1', 'Ces rappels ne semblent pas marcher… 🦊💔',
    'Je vais arrêter de t\'en envoyer. Je serai là quand tu reviendras.', 'dodo',
    grande: 'adieu');

class Rappels {
  Rappels._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _pret = false;
  static final _hasard = Random();
  static void Function(String route)? surOuverture;

  static const _canal = AndroidNotificationChannel(
    'kunfox_rappels',
    'Rappels de révision',
    description: 'Kunfox te rappelle ta leçon du jour et te prévient quand ta série est en danger.',
    importance: Importance.high,
  );

  // ------------------------------------------------------------- réglages
  static bool get actifs => StorageService.getString('kunfox.rappels') != 'false';
  static Future<void> activer(bool oui) async {
    await StorageService.setString('kunfox.rappels', oui ? 'true' : 'false');
    await programmer(force: true);
  }

  /// Heure choisie par l'élève (« 18:30 »), sinon null : on devine.
  static String? get heureChoisie => StorageService.getString('kunfox.rappels.heure');
  static Future<void> choisirHeure(int h, int m) async {
    await StorageService.setString('kunfox.rappels.heure', '$h:$m');
    await programmer(force: true);
  }

  static bool get demandeFaite => StorageService.getString('kunfox.rappels.demande') == '1';

  // ------------------------------------------------------------- démarrage
  static Future<void> initialiser() async {
    if (_pret) return;
    try {
      tzdata.initializeTimeZones();
      final nom = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(nom));
    } catch (e) {
      debugPrint('[Rappels] fuseau inconnu, UTC+1 par défaut : $e');
      tz.setLocalLocation(tz.getLocation('Africa/Douala'));
    }
    await _plugin.initialize(
      const InitializationSettings(android: AndroidInitializationSettings('ic_stat_kunfox')),
      onDidReceiveNotificationResponse: (r) => _ouvert(r.payload),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_canal);
    // L'app a été ouverte par une notification alors qu'elle était fermée.
    final lancement = await _plugin.getNotificationAppLaunchDetails();
    if (lancement?.didNotificationLaunchApp ?? false) _ouvert(lancement!.notificationResponse?.payload);
    _pret = true;
  }

  /// Demande l'autorisation (Android 13+). Vrai si accordée.
  static Future<bool> demanderAutorisation() async {
    await StorageService.setString('kunfox.rappels.demande', '1');
    final ok = await _plugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false;
    await programmer(force: true);
    return ok;
  }

  // ------------------------------------------------------------- statistiques
  static Map<String, List<int>> _stats() {
    try {
      final j = jsonDecode(StorageService.getString('kunfox.rappels.stats') ?? '{}') as Map<String, dynamic>;
      return j.map((k, v) => MapEntry(k, (v as List).cast<int>()));
    } catch (_) {
      return {};
    }
  }

  static Future<void> _ecrireStats(Map<String, List<int>> s) =>
      StorageService.setString('kunfox.rappels.stats', jsonEncode(s));

  static void _ouvert(String? payload) {
    if (payload == null) return;
    final s = _stats();
    final id = payload.split('|').first;
    s[id] = [(s[id]?[0] ?? 0), (s[id]?[1] ?? 0) + 1];
    _ecrireStats(s);
    surOuverture?.call('/k');
  }

  /// Échantillonnage de Thompson (approché par une loi bêta tirée au sort)
  /// : la formulation la plus ouverte gagne souvent, les autres ont leur
  /// chance. On évite de répéter la dernière.
  static _Modele _choisir(List<_Modele> liste, Map<String, List<int>> s, String? eviter) {
    double tirage(_Modele m) {
      final envois = s[m.id]?[0] ?? 0, ouvertures = s[m.id]?[1] ?? 0;
      final a = ouvertures + 1.0, b = (envois - ouvertures).clamp(0, 1 << 20) + 1.0;
      // moyenne de la bêta + bruit proportionnel à son écart-type
      final moy = a / (a + b);
      final et = sqrt(a * b / ((a + b) * (a + b) * (a + b + 1)));
      return moy + et * (_hasard.nextDouble() * 2 - 1) * 1.7;
    }
    final candidats = liste.where((m) => m.id != eviter).toList();
    candidats.sort((x, y) => tirage(y).compareTo(tirage(x)));
    return candidats.first;
  }

  // ------------------------------------------------------------- programmation
  /// L'heure habituelle : celle choisie, sinon la médiane des leçons, sinon 18 h 30.
  static (int, int) _heureHabituelle() {
    final c = heureChoisie;
    if (c != null) {
      final p = c.split(':');
      return (int.tryParse(p[0]) ?? 18, int.tryParse(p.length > 1 ? p[1] : '30') ?? 30);
    }
    final brut = StorageService.getString('kunfox.heures');
    final heures = brut == null ? <int>[] : (jsonDecode(brut) as List).cast<int>();
    if (heures.length < 3) return (18, 30);
    final tri = [...heures]..sort();
    final minutes = tri[tri.length ~/ 2];
    // un peu avant l'heure habituelle : le rappel arrive au bon moment
    final m = (minutes - 20).clamp(7 * 60, 21 * 60);
    return (m ~/ 60, m % 60);
  }

  /// À appeler à chaque leçon finie : retient l'heure (en minutes).
  static Future<void> noterLecon() async {
    final brut = StorageService.getString('kunfox.heures');
    final heures = brut == null ? <int>[] : (jsonDecode(brut) as List).cast<int>();
    final n = DateTime.now();
    heures.add(n.hour * 60 + n.minute);
    while (heures.length > 14) {
      heures.removeAt(0);
    }
    await StorageService.setString('kunfox.heures', jsonEncode(heures));
    await programmer(force: true);
  }

  static String _remplir(String t, Map<String, String> v) =>
      v.entries.fold(t, (s, e) => s.replaceAll('{${e.key}}', e.value));

  static Future<void>? _enCours;

  /// Annule tout et reprogramme les 7 prochains jours (un appel à la fois).
  static DateTime? _derniere;

  static Future<void> programmer({String? pseudo, String? matiere, bool force = false}) {
    // L'écran se reconstruit souvent : on ne reprogramme pas plus d'une fois
    // toutes les 10 secondes, sauf changement réel (leçon, réglage).
    final n = DateTime.now();
    if (!force && _derniere != null && n.difference(_derniere!) < const Duration(seconds: 10)) {
      return _enCours ?? Future<void>.value();
    }
    _derniere = n;
    final avant = _enCours ?? Future<void>.value();
    return _enCours = avant.then((_) => _programmer(pseudo: pseudo, matiere: matiere));
  }

  static Future<void> _programmer({String? pseudo, String? matiere}) async {
    if (!_pret) return;
    try {
      // Les rappels programmés la dernière fois et dont l'heure est passée
      // ont été montrés : on les compte comme envoyés.
      final s = _stats();
      final nowUtc = DateTime.now();
      try {
        final prevus = (jsonDecode(StorageService.getString('kunfox.rappels.prevus') ?? '[]') as List).cast<List>();
        for (final e in prevus) {
          final quand = DateTime.tryParse(e[1] as String);
          if (quand != null && quand.isBefore(nowUtc)) {
            final mid = e[0] as String;
            s[mid] = [(s[mid]?[0] ?? 0) + 1, (s[mid]?[1] ?? 0)];
          }
        }
      } catch (_) {}
      final prevus = <List<String>>[];
      await _plugin.cancelAll();
      if (!actifs) {
        await _ecrireStats(s);
        await StorageService.setString('kunfox.rappels.prevus', '[]');
        return;
      }
      final p = _lireProgression();
      final maintenant = tz.TZDateTime.now(tz.local);
      final (h, m) = _heureHabituelle();
      final faitAuj = p.serieFaiteAujourdhui;
      final serie = p.serieActuelle;
      final dernier = p.dernierJour == null ? null : DateTime.tryParse(p.dernierJour!);
      final vars = {
        'p': (pseudo ?? _pseudo).isEmpty ? 'toi' : (pseudo ?? _pseudo),
        'm': matiere ?? _matiere ?? 'révision',
      };
      String? precedent = StorageService.getString('kunfox.rappels.dernier');
      var id = 100;

      Future<void> envoyer(tz.TZDateTime quand, _Modele mod, Map<String, String> v) async {
        if (!quand.isAfter(maintenant)) return;
        final titre = _remplir(mod.titre, v), texte = _remplir(mod.texte, v);
        final details = AndroidNotificationDetails(
          _canal.id,
          _canal.name,
          channelDescription: _canal.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: 'ic_stat_kunfox',
          color: const Color(0xFFFF6B2B),
          largeIcon: DrawableResourceAndroidBitmap('kunfox_${mod.humeur}'),
          styleInformation: mod.grande != null
              ? BigPictureStyleInformation(
                  DrawableResourceAndroidBitmap('kunfox_grand_${mod.grande}'),
                  largeIcon: DrawableResourceAndroidBitmap('kunfox_${mod.humeur}'),
                  contentTitle: titre,
                  summaryText: texte,
                  hideExpandedLargeIcon: true,
                )
              : BigTextStyleInformation(texte),
          category: AndroidNotificationCategory.reminder,
        );
        await _plugin.zonedSchedule(
          id++,
          titre,
          texte,
          quand,
          NotificationDetails(android: details),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: '${mod.id}|${quand.toIso8601String()}',
        );
        prevus.add([mod.id, quand.toUtc().toIso8601String()]);
        precedent = mod.id;
      }

      for (var d = 0; d < 8; d++) {
        final jour = tz.TZDateTime(tz.local, maintenant.year, maintenant.month, maintenant.day + d);
        // jours d'absence à cette date (depuis la dernière leçon)
        final absence = dernier == null ? d + 1 : jour.difference(DateTime(dernier.year, dernier.month, dernier.day)).inDays;
        if (d == 0 && faitAuj) continue;
        final rappel = tz.TZDateTime(tz.local, jour.year, jour.month, jour.day, h, m);
        final soir = tz.TZDateTime(tz.local, jour.year, jour.month, jour.day, 21, 0);

        if (absence <= 1) {
          // jour normal : le rappel à l'heure habituelle…
          await envoyer(rappel, _choisir(_quotidien, s, precedent), vars);
          // …et la série en danger le soir (aujourd'hui, ou demain si la série tient)
          final serieEnJeu = d == 0 ? serie : (faitAuj && d == 1 ? serie : 0);
          if (serieEnJeu > 0) {
            final reste = (24 - 21).toString();
            await envoyer(soir, _choisir(_danger, s, precedent), {...vars, 'n': '$serieEnJeu', 'h': reste});
          }
        } else if (absence <= 3) {
          await envoyer(rappel, _choisir(_retour, s, precedent), vars);
        } else if (absence <= 6) {
          // un jour sur deux
          if (absence.isEven) await envoyer(rappel, _choisir(_retour, s, precedent), vars);
        } else if (absence == 7) {
          await envoyer(rappel, _adieu, vars);
        }
        // au-delà : silence, jusqu'au retour de l'élève
      }
      if (precedent != null) await StorageService.setString('kunfox.rappels.dernier', precedent!);
      await _ecrireStats(s);
      await StorageService.setString('kunfox.rappels.prevus', jsonEncode(prevus));
    } catch (e) {
      debugPrint('[Rappels] programmation impossible : $e');
    }
  }

  /// Pour les captures d'écran de vérification : montre tout de suite un
  /// rappel ordinaire et une série en danger.
  static Future<void> essai() async {
    if (!_pret) return;
    var id = 900;
    for (final (mod, v) in [
      (_danger[0], {'n': '12', 'h': '3'}),
      (_quotidien[0], <String, String>{}),
    ]) {
      final titre = _remplir(mod.titre, v), texte = _remplir(mod.texte, v);
      await _plugin.show(
        id++,
        titre,
        texte,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _canal.id,
            _canal.name,
            importance: Importance.high,
            priority: Priority.high,
            icon: 'ic_stat_kunfox',
            color: const Color(0xFFFF6B2B),
            largeIcon: DrawableResourceAndroidBitmap('kunfox_${mod.humeur}'),
            styleInformation: mod.grande != null
                ? BigPictureStyleInformation(DrawableResourceAndroidBitmap('kunfox_grand_${mod.grande}'),
                    contentTitle: titre, summaryText: texte, hideExpandedLargeIcon: true)
                : BigTextStyleInformation(texte),
          ),
        ),
      );
    }
  }

  // ------------------------------------------------------------- contexte
  static String _pseudo = '';
  static String? _matiere;
  static Progression Function()? lireProgression;
  static Progression _lireProgression() => lireProgression?.call() ?? const Progression();

  static void contexte({required String pseudo, String? matiere}) {
    _pseudo = pseudo;
    _matiere = matiere;
  }
}
