// ============================================================================
// SE CONNECTER AVEC DROPLET, ET LA SAUVEGARDE QUI VA AVEC.
// ----------------------------------------------------------------------------
// 1. Kunfox crée une clé éphémère (X25519) et ouvre
//    droplet://droplet/autoriser?app=kunfox&cle=…&etat=…
// 2. Droplet demande l'accord de l'élève, puis rouvre Kunfox sur
//    kunfox://kunfox/connexion?etat=…&e=…&n=…&c=…  — une réponse chiffrée
//    pour notre clé éphémère : le pseudo, et un SECRET propre à Kunfox.
// 3. Ce secret (gardé dans le coffre du téléphone) donne :
//    • l'identifiant de la sauvegarde sur le serveur (impossible à deviner) ;
//    • la clé qui chiffre la progression avant envoi.
//    Le serveur ne garde qu'un paquet illisible. Le même compte Droplet
//    redonne le même secret sur un nouveau téléphone : tout revient.
// ============================================================================

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

const _boite = 'https://droplet-mailbox-production.up.railway.app';
const _coffre = FlutterSecureStorage();
const _cleSecret = 'kunfox.droplet.secret';
const _clePseudo = 'kunfox.droplet.pseudo';
const _cleAttente = 'kunfox.droplet.attente';

String _b64(List<int> o) => base64Url.encode(o).replaceAll('=', '');
List<int> _deb64(String s) => base64Url.decode(base64Url.normalize(s));

class ReponseDroplet {
  const ReponseDroplet({required this.secret, required this.pseudo});
  final List<int> secret;
  final String pseudo;
}

class CompteDroplet {
  CompteDroplet._();

  static List<int>? _secret;
  static String? pseudo;

  /// À appeler au démarrage : relit le coffre.
  static Future<void> charger() async {
    try {
      final s = await _coffre.read(key: _cleSecret);
      _secret = s == null ? null : _deb64(s);
      pseudo = await _coffre.read(key: _clePseudo);
    } catch (e) {
      debugPrint('[Kunfox] coffre illisible : $e');
    }
  }

  static bool get connecte => _secret != null;

  /// Ouvre Droplet pour demander l'accord. Faux si Droplet n'est pas là.
  static Future<bool> demarrer() async {
    final x = X25519();
    final paire = await x.newKeyPair();
    final prive = await paire.extractPrivateKeyBytes();
    final pub = await paire.extractPublicKey();
    final etat = _b64(List.generate(16, (_) => Random.secure().nextInt(256)));
    await _coffre.write(key: _cleAttente, value: jsonEncode({'etat': etat, 'k': _b64(prive)}));
    final lien = Uri.parse('droplet://droplet/autoriser?app=kunfox&cle=${_b64(pub.bytes)}&etat=$etat');
    try {
      return await launchUrl(lien, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  /// Page pour installer Droplet quand il manque.
  static Future<void> obtenirDroplet() =>
      launchUrl(Uri.parse('https://dropletmesh.app'), mode: LaunchMode.externalApplication);

  /// Ouvre Droplet (pour réviser ensemble), ou sa version web.
  static Future<void> ouvrirDroplet() async {
    try {
      if (await launchUrl(Uri.parse('droplet://droplet/chats'), mode: LaunchMode.externalApplication)) return;
    } catch (_) {}
    await launchUrl(Uri.parse('https://web.dropletmesh.app'), mode: LaunchMode.externalApplication);
  }

  /// Déchiffre la réponse de Droplet. Null si refusée, périmée ou fausse.
  static Future<ReponseDroplet?> recevoir(Map<String, String> p) async {
    final brut = await _coffre.read(key: _cleAttente);
    if (brut == null) return null;
    final attente = jsonDecode(brut) as Map<String, dynamic>;
    if (p['etat'] != attente['etat'] || p['refus'] == '1') return null;
    try {
      final x = X25519();
      final paire = await x.newKeyPairFromSeed(_deb64(attente['k'] as String));
      final partage = await x.sharedSecretKey(
        keyPair: paire,
        remotePublicKey: SimplePublicKey(_deb64(p['e']!), type: KeyPairType.x25519),
      );
      final cle = await Hkdf(hmac: Hmac.sha256(), outputLength: 32).deriveKey(
        secretKey: partage,
        info: utf8.encode('droplet-autoriser-v1'),
        nonce: utf8.encode(attente['etat'] as String),
      );
      final tout = _deb64(p['c']!);
      final clair = await AesGcm.with256bits().decrypt(
        SecretBox(tout.sublist(0, tout.length - 16), nonce: _deb64(p['n']!), mac: Mac(tout.sublist(tout.length - 16))),
        secretKey: cle,
      );
      final j = jsonDecode(utf8.decode(clair)) as Map<String, dynamic>;
      if (j['etat'] != attente['etat']) return null;
      final secret = _deb64(j['s'] as String);
      _secret = secret;
      pseudo = (j['p'] as String?)?.trim();
      await _coffre.write(key: _cleSecret, value: _b64(secret));
      if (pseudo != null) await _coffre.write(key: _clePseudo, value: pseudo);
      await _coffre.delete(key: _cleAttente);
      return ReponseDroplet(secret: secret, pseudo: pseudo ?? '');
    } catch (e) {
      debugPrint('[Kunfox] réponse Droplet illisible : $e');
      return null;
    }
  }

  static Future<void> deconnecter() async {
    _secret = null;
    pseudo = null;
    await _coffre.delete(key: _cleSecret);
    await _coffre.delete(key: _clePseudo);
  }

  // ------------------------------------------------------------ sauvegarde
  static Future<List<int>> _derive(String etiquette) async {
    final k = await Hkdf(hmac: Hmac.sha256(), outputLength: 32).deriveKey(
      secretKey: SecretKey(_secret!),
      info: utf8.encode(etiquette),
      nonce: utf8.encode('kunfox'),
    );
    return k.extractBytes();
  }

  static Future<Uri> _adresse() async => Uri.parse('$_boite/kunfox/${_b64(await _derive('kunfox-stockage-v1'))}');

  static DateTime? derniereSauvegarde;
  static Timer? _minuteur;
  static Map<String, dynamic> Function()? _contenu;

  /// Programme un envoi quelques secondes après le dernier changement.
  static void planifier(Map<String, dynamic> Function() contenu) {
    _contenu = contenu;
    if (!connecte) return;
    _minuteur?.cancel();
    _minuteur = Timer(const Duration(seconds: 4), () => envoyer());
  }

  static Future<bool> envoyer() async {
    final c = _contenu;
    if (!connecte || c == null) return false;
    try {
      final cle = SecretKey(await _derive('kunfox-chiffre-v1'));
      final boite = await AesGcm.with256bits().encrypt(utf8.encode(jsonEncode(c())), secretKey: cle);
      final paquet = base64.encode([...boite.nonce, ...boite.cipherText, ...boite.mac.bytes]);
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
      final req = await client.putUrl(await _adresse());
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode({'paquet': paquet, 'version': DateTime.now().millisecondsSinceEpoch}));
      final rep = await req.close();
      await rep.drain<void>();
      client.close();
      if (rep.statusCode == 200) derniereSauvegarde = DateTime.now();
      return rep.statusCode == 200 || rep.statusCode == 409;
    } catch (e) {
      debugPrint('[Kunfox] sauvegarde impossible : $e');
      return false;
    }
  }

  /// La sauvegarde du compte, déchiffrée. Null s'il n'y en a pas.
  static Future<Map<String, dynamic>?> recuperer() async {
    if (!connecte) return null;
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
    try {
      final rep = await (await client.getUrl(await _adresse())).close();
      final corps = await rep.transform(utf8.decoder).join();
      if (rep.statusCode != 200) return null;
      final paquet = base64.decode((jsonDecode(corps) as Map<String, dynamic>)['paquet'] as String);
      final cle = SecretKey(await _derive('kunfox-chiffre-v1'));
      final clair = await AesGcm.with256bits().decrypt(
        SecretBox(paquet.sublist(12, paquet.length - 16),
            nonce: paquet.sublist(0, 12), mac: Mac(Uint8List.fromList(paquet.sublist(paquet.length - 16)))),
        secretKey: cle,
      );
      return jsonDecode(utf8.decode(clair)) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('[Kunfox] récupération impossible : $e');
      return null;
    } finally {
      client.close();
    }
  }
}
