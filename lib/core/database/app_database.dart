import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart' as sqlite3_flutter_libs;
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Table definitions
// ---------------------------------------------------------------------------

class Courses extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get subject => text()();
  TextColumn get description => text()();
  TextColumn get type => text()();
  TextColumn get availability => text()();
  RealColumn get progress => real()();
  TextColumn get imageUrl => text()();
  IntColumn get lessonCount => integer()();
  IntColumn get durationMinutes => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text()(); // pending | synced | conflict

  @override
  Set<Column> get primaryKey => {id};
}

class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text()();
  TextColumn get title => text()();
  TextColumn get contentUrl => text()();
  TextColumn get type => text()();
  TextColumn get availability => text()();
  RealColumn get progress => real()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId => text()();
  TextColumn get content => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class MeshMessages extends Table {
  TextColumn get id => text()();
  TextColumn get authorPseudo => text()();
  TextColumn get content => text()();
  TextColumn get type => text()();
  IntColumn get timestamp => integer()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  IntColumn get hopCount => integer()();
  TextColumn get reactions => text()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text()();
  TextColumn get fileId => text().nullable()();
  TextColumn get fileName => text().nullable()();
  IntColumn get fileSize => integer().nullable()();
  TextColumn get fileMimeType => text().nullable()();
  TextColumn get replyToId => text().nullable()();
  TextColumn get status => text()();
  TextColumn get routeInfo => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserProfile extends Table {
  TextColumn get id => text()();
  TextColumn get pseudo => text()();
  TextColumn get bacSeries => text()();
  TextColumn get cryptoIdentity => text()();
  TextColumn get avatarUrl => text()();
  IntColumn get isGatewayActive => integer()();
  IntColumn get meshPeers => integer()();
  TextColumn get bio => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SeenMessageIds extends Table {
  TextColumn get messageId => text()();

  @override
  Set<Column> get primaryKey => {messageId};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class AuthCredentialsTable extends Table {
  TextColumn get key => text()();
  TextColumn get accessToken => text()();
  TextColumn get refreshToken => text()();
  IntColumn get expiresAt => integer()();

  @override
  Set<Column> get primaryKey => {key};
}

// -- Sync tracking ----------------------------------------------------------

class SyncLog extends Table {
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get action => text()();   // create | update | delete
  IntColumn get occurredAt => integer()();
  IntColumn get syncedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {entityType, entityId, occurredAt};
}

class SyncState extends Table {
  TextColumn get key => text()();
  IntColumn get value => integer()();

  @override
  Set<Column> get primaryKey => {key};
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

QueryExecutor _createExecutor() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    await sqlite3_flutter_libs.applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    final file = File('${dir.path}/ouro_prep.db');
    return NativeDatabase(file, setup: (db) {
      db.execute('PRAGMA journal_mode=WAL');
      db.execute('PRAGMA foreign_keys=ON');
    });
  });
}

@DriftDatabase(
  tables: [
    Courses,
    Chapters,
    Notes,
    MeshMessages,
    UserProfile,
    SeenMessageIds,
    AppSettings,
    AuthCredentialsTable,
    SyncLog,
    SyncState,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_createExecutor());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(meshMessages, meshMessages.fileId);
        await m.addColumn(meshMessages, meshMessages.fileName);
        await m.addColumn(meshMessages, meshMessages.fileSize);
        await m.addColumn(meshMessages, meshMessages.fileMimeType);
      }
      if (from < 3) {
        await m.addColumn(meshMessages, meshMessages.replyToId);
        await m.addColumn(meshMessages, meshMessages.status);
        await m.addColumn(meshMessages, meshMessages.routeInfo);
      }
    },
  );

  // -- Migration JSON → SQLite (one-time) -----------------------------------

  Future<void> migrateFromJson() async {
    final dir = await getApplicationDocumentsDirectory();
    final jsonFile = File('${dir.path}/ouro_prep_store.json');
    if (!await jsonFile.exists()) return;

    try {
      final data = json.decode(await jsonFile.readAsString()) as Map<String, dynamic>;

      await transaction(() async {
        // Users
        if (data['user'] != null) {
          final u = data['user'] as Map<String, dynamic>;
          await into(userProfile).insert(UserProfileCompanion(
            id: Value(u['cryptoIdentity'] as String? ?? const Uuid().v4()),
            pseudo: Value(u['pseudo'] as String? ?? ''),
            bacSeries: Value(u['bacSeries'] as String? ?? ''),
            cryptoIdentity: Value(u['cryptoIdentity'] as String? ?? ''),
            avatarUrl: Value(u['avatarUrl'] as String? ?? ''),
            isGatewayActive: Value(u['isGatewayActive'] as bool? ?? false ? 1 : 0),
            meshPeers: Value(u['meshPeers'] as int? ?? 0),
            bio: Value(u['bio'] as String? ?? ''),
          ));
        }

        // Courses
        final coursesList = data['courses'] as List<dynamic>? ?? [];
        for (final c in coursesList) {
          final map = c as Map<String, dynamic>;
          await into(courses).insert(CoursesCompanion(
            id: Value(map['id'] as String),
            title: Value(map['title'] as String),
            subject: Value(map['subject'] as String? ?? ''),
            description: Value(map['description'] as String? ?? ''),
            type: Value(map['type'] as String? ?? 'PDF'),
            availability: Value(_availToString(map['availability'])),
            progress: Value((map['progress'] as num?)?.toDouble() ?? 0.0),
            imageUrl: Value(map['imageUrl'] as String? ?? ''),
            lessonCount: Value(map['lessonCount'] as int? ?? 0),
            durationMinutes: Value(map['durationMinutes'] as int? ?? 0),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
            syncStatus: Value('synced'),
          ));
        }

        // Chapters
        final chaptersList = data['chapters'] as List<dynamic>? ?? [];
        for (final c in chaptersList) {
          final map = c as Map<String, dynamic>;
          await into(chapters).insert(ChaptersCompanion(
            id: Value(map['id'] as String),
            courseId: Value(map['courseId'] as String),
            title: Value(map['title'] as String? ?? ''),
            contentUrl: Value(map['contentUrl'] as String? ?? ''),
            type: Value(map['type'] as String? ?? 'PDF'),
            availability: Value(_availToString(map['availability'])),
            progress: Value((map['progress'] as num?)?.toDouble() ?? 0.0),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
            syncStatus: Value('synced'),
          ));
        }

        // Notes
        final notesList = data['notes'] as List<dynamic>? ?? [];
        for (final n in notesList) {
          final map = n as Map<String, dynamic>;
          await into(notes).insert(NotesCompanion(
            id: Value(map['id'] as String),
            chapterId: Value(map['chapterId'] as String),
            content: Value(map['content'] as String? ?? ''),
            createdAt: Value(_parseMsEpoch(map['createdAt'])),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
            syncStatus: Value('synced'),
          ));
        }

        // Messages
        final msgs = data['messages'] as List<dynamic>? ?? [];
        for (final m in msgs) {
          final map = m as Map<String, dynamic>;
          await into(meshMessages).insert(MeshMessagesCompanion(
            id: Value(map['id'] as String),
            authorPseudo: Value(map['authorPseudo'] as String? ?? ''),
            content: Value(map['content'] as String? ?? ''),
            type: Value(map['type'] as String? ?? 'text'),
            timestamp: Value(_parseMsEpoch(map['timestamp'])),
            imageUrl: Value<String?>(map['imageUrl'] as String?),
            audioUrl: Value<String?>(map['audioUrl'] as String?),
            hopCount: Value(map['hopCount'] as int? ?? 0),
            reactions: Value(map['reactions'] != null ? json.encode(map['reactions']) : '[]'),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
            syncStatus: Value('synced'),
          ));
        }

        // Seen message ids
        final seenList = data['seen_message_ids'] as List<dynamic>? ?? [];
        for (final sid in seenList) {
          await into(seenMessageIds).insert(SeenMessageIdsCompanion(
            messageId: Value(sid as String),
          ));
        }

        // Settings
        final settings = data['settings'] as Map<String, dynamic>?;
        if (settings != null) {
          for (final entry in settings.entries) {
            await into(appSettings).insert(AppSettingsCompanion(
              key: Value(entry.key),
              value: Value(entry.value.toString()),
            ));
          }
        }

        // Auth credentials
        if (data['auth_credentials'] != null) {
          final ac = data['auth_credentials'] as Map<String, dynamic>;
          await into(authCredentialsTable).insert(AuthCredentialsTableCompanion(
            key: Value('default'),
            accessToken: Value(ac['accessToken'] as String? ?? ''),
            refreshToken: Value(ac['refreshToken'] as String? ?? ''),
            expiresAt: Value(_parseMsEpoch(ac['expiresAt'])),
          ));
        }
      });

      // Rename old JSON file so migration runs only once
      await jsonFile.rename('${dir.path}/ouro_prep_store.migrated.json');
      debugPrint('[DB] Migration JSON → SQLite réussie');
    } catch (e, _) {
      debugPrint('[DB] Erreur migration JSON: $e');
    }
  }
}

// -- Helpers ----------------------------------------------------------------

String _availToString(dynamic v) {
  if (v is int) return ['local', 'mesh', 'cloud'][v];
  if (v is String) return v;
  return 'cloud';
}

int _parseMsEpoch(dynamic v) {
  if (v is int) return v;
  if (v is String) {
    try {
      return DateTime.parse(v).millisecondsSinceEpoch;
    } catch (_) {
      return DateTime.now().millisecondsSinceEpoch;
    }
  }
  return DateTime.now().millisecondsSinceEpoch;
}

class DbProvider {
  static AppDatabase? _db;
  static AppDatabase get instance => _db ?? (throw StateError('AppDatabase not initialized'));
  static bool _initialized = false;
  static bool get isReady => _initialized;

  static Future<void> init() async {
    if (_initialized) return;
    _db = AppDatabase();
    await _db!.migrateFromJson();
    _initialized = true;
  }
}
