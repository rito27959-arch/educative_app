import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart' as db;
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/mesh_message.dart';
import 'auth_service.dart';

/// Facade statique avec cache mémoire + persistante Drift atomique.
///
/// Tous les getters sont synchrones (lecture depuis le cache).
/// Toutes les écritures passent par Drift (transaction) + mettent à jour le cache.
/// Si Drift n'est pas initialisé (tests), les écritures ne font que mettre à jour
/// le cache mémoire sans persister.
class StorageService {
  static db.AppDatabase? get _database =>
      db.DbProvider.isReady ? db.DbProvider.instance : null;

  // Caches mémoire
  static UserModel? _userCache;
  static List<CourseModel> _coursesCache = [];
  static List<ChapterModel> _chaptersCache = [];
  static List<NoteModel> _notesCache = [];
  static List<MeshMessage> _messagesCache = [];
  static Set<String> _seenIdsCache = {};
  static Map<String, dynamic> _settingsCache = {};
  static AuthCredentials? _authCache;

  static Future<void> init() async {
    await db.DbProvider.init();
    await _reloadCaches();
  }

  static Future<void> _reloadCaches() async {
    final d = _database;
    if (d == null) return;

    _userCache = await _readUser();
    _coursesCache = (await d.select(d.courses).get()).map(_courseFromRow).toList();
    _chaptersCache = (await d.select(d.chapters).get()).map(_chapterFromRow).toList();
    _notesCache = (await d.select(d.notes).get()).map(_noteFromRow).toList();
    _messagesCache = (await d.select(d.meshMessages).get()).map(_msgFromRow).toList();
    _seenIdsCache = (await d.select(d.seenMessageIds).get()).map((r) => r.messageId).toSet();
    _settingsCache = {for (final r in (await d.select(d.appSettings).get())) r.key: _parseSettingValue(r.value)};
    _authCache = await _readAuthCredentials();
    await _loadContributionEvents();
  }

  // -- Helpers --------------------------------------------------------------

  static String generateCryptoIdentity(String pseudo) {
    final bytes = utf8.encode(pseudo + DateTime.now().toIso8601String());
    return sha256.convert(bytes).toString();
  }

  static String generateId() => const Uuid().v4();

  // -- User -----------------------------------------------------------------

  static Future<UserModel?> _readUser() async {
    final d = _database;
    if (d == null) return null;
    final rows = await d.select(d.userProfile).get();
    if (rows.isEmpty) return null;
    final r = rows.first;
    return UserModel(
      pseudo: r.pseudo,
      bacSeries: r.bacSeries,
      cryptoIdentity: r.cryptoIdentity,
      avatarUrl: r.avatarUrl,
      isGatewayActive: r.isGatewayActive == 1,
      meshPeers: r.meshPeers,
      bio: r.bio,
    );
  }

  static bool get isLoggedIn => _userCache != null;
  static UserModel? get currentUser => _userCache;

  static Future<void> saveUser(UserModel user) async {
    final d = _database;
    if (d != null) {
      await d.transaction(() async {
        await d.into(d.userProfile).insert(db.UserProfileCompanion(
          id: Value(user.cryptoIdentity),
          pseudo: Value(user.pseudo),
          bacSeries: Value(user.bacSeries),
          cryptoIdentity: Value(user.cryptoIdentity),
          avatarUrl: Value(user.avatarUrl),
          isGatewayActive: Value(user.isGatewayActive ? 1 : 0),
          meshPeers: Value(user.meshPeers),
          bio: Value(user.bio),
        ));
      });
    }
    _userCache = user;
  }

  // -- Courses --------------------------------------------------------------

  static List<CourseModel> getCourses() => _coursesCache;

  static Future<void> saveCourse(CourseModel course) async {
    final d = _database;
    if (d != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      await d.transaction(() async {
        await d.into(d.courses).insert(db.CoursesCompanion(
          id: Value(course.id),
          title: Value(course.title),
          subject: Value(course.subject),
          description: Value(course.description),
          type: Value(course.type),
          availability: Value(course.availability.name),
          progress: Value(course.progress),
          imageUrl: Value(course.imageUrl),
          lessonCount: Value(course.lessonCount),
          durationMinutes: Value(course.durationMinutes),
          updatedAt: Value(now),
          syncStatus: const Value('pending'),
        ));
      });
      _coursesCache = (await d.select(d.courses).get()).map(_courseFromRow).toList();
    }
  }

  static CourseModel? getCourseById(String id) {
    try {
      return _coursesCache.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static CourseModel _courseFromRow(db.Course r) => CourseModel(
    id: r.id,
    title: r.title,
    subject: r.subject,
    description: r.description,
    type: r.type,
    availability: CourseAvailability.values.firstWhere(
      (a) => a.name == r.availability,
      orElse: () => CourseAvailability.cloud,
    ),
    progress: r.progress,
    imageUrl: r.imageUrl,
    lessonCount: r.lessonCount,
    durationMinutes: r.durationMinutes,
  );

  // -- Chapters -------------------------------------------------------------

  static List<ChapterModel> getChapters(String courseId) =>
      _chaptersCache.where((c) => c.courseId == courseId).toList();

  static Future<void> saveChapter(ChapterModel chapter) async {
    final d = _database;
    if (d != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      await d.transaction(() async {
        await d.into(d.chapters).insert(db.ChaptersCompanion(
          id: Value(chapter.id),
          courseId: Value(chapter.courseId),
          title: Value(chapter.title),
          contentUrl: Value(chapter.contentUrl),
          type: Value(chapter.type),
          availability: Value(chapter.availability.name),
          progress: Value(chapter.progress),
          updatedAt: Value(now),
          syncStatus: const Value('pending'),
        ));
      });
      _chaptersCache = (await d.select(d.chapters).get()).map(_chapterFromRow).toList();
    }
  }

  static ChapterModel _chapterFromRow(db.Chapter r) => ChapterModel(
    id: r.id,
    courseId: r.courseId,
    title: r.title,
    contentUrl: r.contentUrl,
    type: r.type,
    availability: CourseAvailability.values.firstWhere(
      (a) => a.name == r.availability,
      orElse: () => CourseAvailability.cloud,
    ),
    progress: r.progress,
  );

  // -- Notes ----------------------------------------------------------------

  static List<NoteModel> getNotes(String chapterId) =>
      _notesCache.where((n) => n.chapterId == chapterId).toList();

  static Future<void> saveNote(NoteModel note) async {
    final d = _database;
    if (d != null) {
      final now = note.createdAt.millisecondsSinceEpoch;
      await d.transaction(() async {
        await d.into(d.notes).insert(db.NotesCompanion(
          id: Value(note.id),
          chapterId: Value(note.chapterId),
          content: Value(note.content),
          createdAt: Value(now),
          updatedAt: Value(now),
          syncStatus: const Value('pending'),
        ));
      });
      _notesCache = (await d.select(d.notes).get()).map(_noteFromRow).toList();
    }
  }

  static NoteModel _noteFromRow(db.Note r) => NoteModel(
    id: r.id,
    chapterId: r.chapterId,
    content: r.content,
    createdAt: DateTime.fromMillisecondsSinceEpoch(r.createdAt),
  );

  // -- Mesh Messages --------------------------------------------------------

  static List<MeshMessage> getMessages() => _messagesCache;

  static Future<void> saveMessage(MeshMessage msg) async {
    final d = _database;
    if (d != null) {
      final now = msg.timestamp.millisecondsSinceEpoch;
      await d.transaction(() async {
        await d.into(d.meshMessages).insert(db.MeshMessagesCompanion(
          id: Value(msg.id),
          authorPseudo: Value(msg.authorPseudo),
          content: Value(msg.content),
          type: Value(msg.type),
          timestamp: Value(now),
          imageUrl: Value<String?>(msg.imageUrl),
          audioUrl: Value<String?>(msg.audioUrl),
          hopCount: Value(msg.hopCount),
          reactions: Value(json.encode(msg.reactions)),
          updatedAt: Value(now),
          syncStatus: const Value('synced'),
          fileId: Value<String?>(msg.fileId),
          fileName: Value<String?>(msg.fileName),
          fileSize: Value<int?>(msg.fileSize),
          fileMimeType: Value<String?>(msg.fileMimeType),
          replyToId: Value<String?>(msg.replyToId),
          status: Value(msg.status.name),
          routeInfo: Value<String?>(msg.routeInfo),
        ));
      });
      _messagesCache = (await d.select(d.meshMessages).get()).map(_msgFromRow).toList();
    }
  }

  static Future<void> updateMessageStatus(String messageId, MessageStatus status) async {
    final d = _database;
    if (d != null) {
      await (d.update(d.meshMessages)..where((t) => t.id.equals(messageId)))
          .write(db.MeshMessagesCompanion(
            status: Value(status.name),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ));
    }
    final idx = _messagesCache.indexWhere((m) => m.id == messageId);
    if (idx >= 0) {
      _messagesCache[idx] = _messagesCache[idx].copyWith(status: status);
    }
  }

  /// Charge les messages paginés (les plus récents d'abord).
  static List<MeshMessage> getMessagesPaginated({int limit = 50, int offset = 0}) {
    final sorted = List<MeshMessage>.from(_messagesCache)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    if (offset >= sorted.length) return [];
    final end = (offset + limit).clamp(0, sorted.length);
    return sorted.sublist(offset, end);
  }

  /// Sauvegarde un fichier partagé dans le dossier dédié.
  static Future<String> saveSharedFile({
    required String fileId,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final sharedDir = Directory('${dir.path}/shared');
    if (!await sharedDir.exists()) await sharedDir.create(recursive: true);
    final file = File('${sharedDir.path}/$fileId-$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Retourne le chemin local d'un fichier partagé.
  static Future<String?> getSharedFilePath(String fileId, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/shared/$fileId-$fileName');
    if (await file.exists()) return file.path;
    return null;
  }

  static MeshMessage _msgFromRow(db.MeshMessage r) => MeshMessage(
    id: r.id,
    authorPseudo: r.authorPseudo,
    content: r.content,
    type: r.type,
    reactions: r.reactions.isNotEmpty
        ? (json.decode(r.reactions) as List<dynamic>).cast<String>()
        : [],
    timestamp: DateTime.fromMillisecondsSinceEpoch(r.timestamp),
    imageUrl: r.imageUrl,
    audioUrl: r.audioUrl,
    hopCount: r.hopCount,
    fileId: r.fileId,
    fileName: r.fileName,
    fileSize: r.fileSize,
    fileMimeType: r.fileMimeType,
    replyToId: r.replyToId,
    status: MessageStatus.values.firstWhere(
      (s) => s.name == r.status,
      orElse: () => MessageStatus.sent,
    ),
    routeInfo: r.routeInfo,
  );

  static int getMessageCount() => _messagesCache.length;

  // -- Mesh stats -----------------------------------------------------------

  static MeshStats getMeshStats() {
    final relayedFiles = _messagesCache.where((m) => m.type == 'file').length;
    final totalGb = _messagesCache.length * 0.001;
    return MeshStats(
      distributedGb: double.parse(totalGb.toStringAsFixed(2)),
      relayedFiles: relayedFiles,
      helpedPeers: _messagesCache.map((m) => m.authorPseudo).toSet().length,
      totalPeers: 1,
    );
  }

  // -- Settings -------------------------------------------------------------

  static dynamic _parseSettingValue(String raw) {
    if (raw == 'true') return true;
    if (raw == 'false') return false;
    final intVal = int.tryParse(raw);
    if (intVal != null) return intVal;
    final doubleVal = double.tryParse(raw);
    if (doubleVal != null) return doubleVal;
    return raw;
  }

  static Map<String, dynamic>? getSettings() {
    if (_settingsCache.isEmpty) return null;
    return Map<String, dynamic>.from(_settingsCache);
  }

  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    final d = _database;
    if (d != null) {
      await d.transaction(() async {
        for (final entry in settings.entries) {
          await d.into(d.appSettings).insert(
            db.AppSettingsCompanion(
              key: Value(entry.key),
              value: Value(entry.value.toString()),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
    }
    _settingsCache = Map<String, dynamic>.from(settings);
  }

  // -- Seen message ids -----------------------------------------------------

  static Set<String> getSeenMessageIds() => _seenIdsCache;

  static Future<void> addSeenMessageId(String id) async {
    final d = _database;
    if (d != null) {
      await d.transaction(() async {
        await d.into(d.seenMessageIds).insert(
          db.SeenMessageIdsCompanion(messageId: Value(id)),
          mode: InsertMode.insertOrIgnore,
        );
      });
    }
    _seenIdsCache.add(id);
  }

  // -- Generic key/value ----------------------------------------------------

  static String? getString(String key) => _settingsCache[key]?.toString();

  static Future<void> setString(String key, String value) async {
    final d = _database;
    if (d != null) {
      await d.into(d.appSettings).insert(
        db.AppSettingsCompanion(key: Value(key), value: Value(value)),
        mode: InsertMode.insertOrReplace,
      );
    }
    _settingsCache[key] = value;
  }

  static Future<void> remove(String key) async {
    final d = _database;
    if (d != null) {
      await (d.delete(d.appSettings)..where((t) => t.key.equals(key))).go();
    }
    _settingsCache.remove(key);
  }

  // -- Outbox (messages en attente d'envoi) ----------------------------------

  static const String _outboxKey = 'mesh_outbox';

  static Future<void> saveOutbox(Map<String, dynamic> entry) async {
    final existing = getString(_outboxKey);
    List<Map<String, dynamic>> outbox;
    if (existing != null && existing.isNotEmpty) {
      try {
        outbox = (jsonDecode(existing) as List).cast<Map<String, dynamic>>();
      } catch (_) { outbox = []; }
    } else {
      outbox = [];
    }
    outbox.add(entry);
    await setString(_outboxKey, jsonEncode(outbox));
  }

  static List<Map<String, dynamic>> getOutbox() {
    final existing = getString(_outboxKey);
    if (existing == null || existing.isEmpty) return [];
    try {
      return (jsonDecode(existing) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  static Future<void> clearOutboxEntry(String messageId) async {
    final existing = getString(_outboxKey);
    if (existing == null || existing.isEmpty) return;
    try {
      final list = (jsonDecode(existing) as List).cast<Map<String, dynamic>>();
      list.removeWhere((e) => e['id'] == messageId);
      await setString(_outboxKey, jsonEncode(list));
    } catch (_) {}
  }

  static Future<void> clearOutbox() async {
    await remove(_outboxKey);
  }

  // -- Pending relays (store-and-forward Bridgefy) ---------------------------

  static const String _pendingRelaysKey = 'pending_relays';

  static Future<void> savePendingRelay(String messageId, Uint8List payload) async {
    final existing = getString(_pendingRelaysKey);
    List<Map<String, dynamic>> relays;
    if (existing != null && existing.isNotEmpty) {
      try {
        relays = (jsonDecode(existing) as List).cast<Map<String, dynamic>>();
      } catch (_) { relays = []; }
    } else {
      relays = [];
    }
    relays.add({
      'id': messageId,
      'payload': base64Encode(payload),
    });
    await setString(_pendingRelaysKey, jsonEncode(relays));
  }

  static List<Map<String, dynamic>> getPendingRelays() {
    final existing = getString(_pendingRelaysKey);
    if (existing == null || existing.isEmpty) return [];
    try {
      return (jsonDecode(existing) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  static Future<void> clearPendingRelays() async {
    await remove(_pendingRelaysKey);
  }

  // -- Streak & Progression --------------------------------------------------

  static const String _lastStudyKey = 'last_study_date';
  static const String _streakKey = 'streak_days';

  /// Retourne la date du dernier jour d'étude (sans heure).
  static DateTime? getLastStudyDate() {
    final v = getString(_lastStudyKey);
    if (v == null) return null;
    return DateTime.tryParse(v);
  }

  static Future<void> _setLastStudyDate(DateTime date) async {
    await setString(_lastStudyKey, date.toIso8601String().substring(0, 10));
  }

  static int getStreakDays() {
    final v = getString(_streakKey);
    return v != null ? int.tryParse(v) ?? 0 : 0;
  }

  static Future<void> _setStreakDays(int days) async {
    await setString(_streakKey, days.toString());
  }

  /// Appelé quand l'utilisateur étudie (consultation chapitre, quiz, etc.).
  /// Met à jour le streak automatiquement en comparant avec la dernière date.
  static Future<int> recordStudyActivity() async {
    final today = DateTime.now();
    final todayStr = today.toIso8601String().substring(0, 10);
    final lastDate = getLastStudyDate();
    final lastStr = lastDate?.toIso8601String().substring(0, 10);

    if (lastStr == todayStr) {
      // Déjà étudié aujourd'hui → pas de changement
      return getStreakDays();
    }

    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayStr = yesterday.toIso8601String().substring(0, 10);

    int newStreak;
    if (lastStr == yesterdayStr) {
      // Continue → incrémente
      newStreak = getStreakDays() + 1;
    } else {
      // Rupture ou première fois → reset à 1
      newStreak = 1;
    }

    await _setStreakDays(newStreak);
    await _setLastStudyDate(today);
    debugPrint('[Progression] Streak mis à jour: $newStreak jours');
    return newStreak;
  }

  static int getQuizScore() {
    final v = getString('quiz_score');
    return v != null ? int.tryParse(v) ?? 0 : 0;
  }

  static Future<void> saveQuizScore(int score) async {
    await setString('quiz_score', score.toString());
  }

  // -- Study sessions --------------------------------------------------------

  static const String _sessionsKey = 'study_sessions';

  static Future<void> saveStudySession(Map<String, dynamic> session) async {
    final existing = getString(_sessionsKey);
    List<Map<String, dynamic>> sessions;
    if (existing != null && existing.isNotEmpty) {
      try {
        sessions = (jsonDecode(existing) as List).cast<Map<String, dynamic>>();
      } catch (_) { sessions = []; }
    } else {
      sessions = [];
    }
    sessions.add(session);
    await setString(_sessionsKey, jsonEncode(sessions));
  }

  static List<Map<String, dynamic>> getStudySessions() {
    final existing = getString(_sessionsKey);
    if (existing == null || existing.isEmpty) return [];
    try {
      return (jsonDecode(existing) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  /// Retourne les sessions d'aujourd'hui.
  static List<Map<String, dynamic>> getTodaySessions() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return getStudySessions().where((s) {
      final d = s['date'] as String?;
      return d != null && d.substring(0, 10) == today;
    }).toList();
  }

  /// Minutes d'étude cette semaine (lundi → dimanche).
  static int getStudyMinutesThisWeek() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sessions = getStudySessions();
    int total = 0;
    for (final s in sessions) {
      final d = DateTime.tryParse(s['date'] as String? ?? '');
      if (d != null && !d.isBefore(monday) && !d.isAfter(now)) {
        total += s['durationMinutes'] as int? ?? 0;
      }
    }
    return total;
  }

  /// Minutes d'étude aujourd'hui.
  static int getStudyMinutesToday() {
    return getTodaySessions().fold(0, (sum, s) => sum + (s['durationMinutes'] as int? ?? 0));
  }

  /// Nombre total de chapitres complétés.
  static int getChaptersCompletedCount() {
    return _chaptersCache.where((c) => c.progress >= 1.0).length;
  }

  /// Progression globale moyenne sur tous les cours.
  static double getGlobalProgress() {
    if (_coursesCache.isEmpty) return 0.0;
    final total = _coursesCache.fold<double>(0, (sum, c) => sum + c.progress);
    return total / _coursesCache.length;
  }

  // -- Marquer un chapitre comme terminé --------------------------------------

  /// Marque un chapitre comme terminé (progress=1.0), recalcule la progression
  /// du cours parent, et enregistre l'activité d'étude (streak).
  static Future<void> markChapterComplete(String chapterId, String courseId) async {
    final chapterIdx = _chaptersCache.indexWhere((c) => c.id == chapterId);
    if (chapterIdx == -1) return;
    _chaptersCache[chapterIdx] = _chaptersCache[chapterIdx].copyWith(progress: 1.0);
    await saveChapter(_chaptersCache[chapterIdx]);

    // Recalculer la progression du cours
    final chapters = getChapters(courseId);
    final completed = chapters.where((c) => c.progress >= 1.0).length;
    final progress = chapters.isEmpty ? 0.0 : completed / chapters.length;

    final courseIdx = _coursesCache.indexWhere((c) => c.id == courseId);
    if (courseIdx >= 0) {
      _coursesCache[courseIdx] = _coursesCache[courseIdx].copyWith(progress: progress);
      await saveCourse(_coursesCache[courseIdx]);
    }

    // Enregistrer l'activité (streak)
    await recordStudyActivity();

    // Enregistrer une session d'étude
    await saveStudySession({
      'id': generateId(),
      'date': DateTime.now().toIso8601String(),
      'durationMinutes': 10, // estimé
      'chaptersCompleted': 1,
      'quizzesPassed': 0,
    });

    debugPrint('[Progression] Chapitre $chapterId terminé. Cours $courseId: ${(progress * 100).round()}%');
  }

  // -- Onboarding ------------------------------------------------------------

  static const String _onboardingKey = 'onboarding_complete';

  static bool isOnboardingComplete() {
    final v = getString(_onboardingKey);
    return v == 'true';
  }

  static Future<void> setOnboardingComplete() async {
    await setString(_onboardingKey, 'true');
  }

  // -- Auth credentials (legacy) -------------------------------------------

  static Future<AuthCredentials?> _readAuthCredentials() async {
    final d = _database;
    if (d == null) return null;
    final rows = await d.select(d.authCredentialsTable).get();
    if (rows.isEmpty) return null;
    final r = rows.first;
    return AuthCredentials(
      accessToken: r.accessToken,
      refreshToken: r.refreshToken,
      user: _userCache ?? UserModel(pseudo: '', bacSeries: '', cryptoIdentity: ''),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(r.expiresAt),
    );
  }

  static AuthCredentials? getAuthCredentials() => _authCache;

  static Future<void> saveAuthCredentials(AuthCredentials credentials) async {
    final d = _database;
    if (d != null) {
      await d.transaction(() async {
        await d.into(d.authCredentialsTable).insert(
          db.AuthCredentialsTableCompanion(
            key: const Value('default'),
            accessToken: Value(credentials.accessToken),
            refreshToken: Value(credentials.refreshToken),
            expiresAt: Value(credentials.expiresAt.millisecondsSinceEpoch),
          ),
          mode: InsertMode.insertOrReplace,
        );
      });
    }
    _authCache = credentials;
  }

  static Future<void> clearAuthCredentials() async {
    final d = _database;
    if (d != null) {
      await d.delete(d.authCredentialsTable).go();
    }
    _authCache = null;
  }

  // -- Contribution points (Phase C) ----------------------------------------

  static final List<ContributionEvent> _contributionEvents = [];

  /// Enregistre un événement de contribution en local.
  static Future<void> addContributionEvent({
    required String type, // 'relay', 'forum_helpful', 'tutoring_call', 'relay_minute'
    required int points,
    String? description,
  }) async {
    final event = ContributionEvent(
      type: type,
      points: points,
      description: description,
      timestamp: DateTime.now(),
      synced: false,
    );
    _contributionEvents.add(event);
    // Persist via settings (JSON array)
    final events = _contributionEvents
        .map((e) => {
              'type': e.type,
              'points': e.points,
              'description': e.description,
              'timestamp': e.timestamp.millisecondsSinceEpoch,
              'synced': e.synced,
            })
        .toList();
    await saveSettings({'contribution_events': jsonEncode(events)});
  }

  /// Retourne tous les événements de contribution.
  static List<ContributionEvent> getContributionEvents() =>
      List.unmodifiable(_contributionEvents);

  /// Calcule les points totaux, en attente, et le décompte par type.
  static ContributionPoints getContributionPoints() {
    int total = 0;
    int pending = 0;
    int relaysCount = 0;
    int forumHelpfulCount = 0;
    int tutoringCallCount = 0;
    int relayMinutes = 0;

    for (final event in _contributionEvents) {
      if (!event.synced) pending += event.points;
      total += event.points;
      switch (event.type) {
        case 'relay':
          relaysCount++;
        case 'forum_helpful':
          forumHelpfulCount++;
        case 'tutoring_call':
          tutoringCallCount++;
        case 'relay_minute':
          relayMinutes++;
      }
    }

    return ContributionPoints(
      total: total,
      pendingPoints: pending,
      relaysCount: relaysCount,
      forumHelpfulCount: forumHelpfulCount,
      tutoringCallCount: tutoringCallCount,
      relayMinutes: relayMinutes,
    );
  }

  /// Charge les événements depuis le stockage persistant (appelé au démarrage).
  static Future<void> _loadContributionEvents() async {
    final raw = getString('contribution_events');
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List;
      _contributionEvents.clear();
      for (final item in list) {
        _contributionEvents.add(ContributionEvent(
          type: item['type'] as String,
          points: item['points'] as int,
          description: item['description'] as String?,
          timestamp: DateTime.fromMillisecondsSinceEpoch(item['timestamp'] as int),
          synced: item['synced'] as bool? ?? false,
        ));
      }
    } catch (_) {}
  }

  // -- Peer persistence (table de routage durable) --------------------------

  static const String _knownPeersKey = 'known_peers';

  /// Sauvegarde la liste des pairs connus pour reconnection rapide.
  static Future<void> savePeers(List<PeerRecord> peers) async {
    final json = peers.map((p) => p.toJson()).toList();
    await setString(_knownPeersKey, jsonEncode(json));
  }

  /// Ajoute ou met à jour un pair dans la table persistante.
  static Future<void> upsertPeer(PeerRecord peer) async {
    final existing = getKnownPeers();
    existing.removeWhere((p) => p.peerId == peer.peerId);
    existing.add(peer);
    await savePeers(existing);
  }

  /// Charge la table de pairs persistée.
  static List<PeerRecord> getKnownPeers() {
    final existing = getString(_knownPeersKey);
    if (existing == null || existing.isEmpty) return [];
    try {
      final list = jsonDecode(existing) as List;
      return list.map((e) => PeerRecord.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Supprime un pair de la table persistante.
  static Future<void> removeKnownPeer(String peerId) async {
    final existing = getKnownPeers();
    existing.removeWhere((p) => p.peerId == peerId);
    await savePeers(existing);
  }
}

/// Événement de contribution.
class ContributionEvent {
  final String type;
  final int points;
  final String? description;
  final DateTime timestamp;
  bool synced;

  ContributionEvent({
    required this.type,
    required this.points,
    this.description,
    required this.timestamp,
    this.synced = false,
  });
}
