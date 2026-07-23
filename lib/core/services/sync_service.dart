import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../database/app_database.dart' as db;
import '../models/course_model.dart';
import '../models/user_model.dart';
import 'storage_service.dart';
import 'supabase_service.dart';

enum SyncStatus { idle, pushing, pulling, success, error }

/// Service de synchronisation offline‑first avec stratégie Last‑Write‑Wins.
///
/// 1. Push : envoie les opérations en attente (SyncLog) vers Supabase.
/// 2. Pull : récupère les entités modifiées depuis le dernier timestamp.
/// 3. LWW : `updatedAt` le plus récent gagne ; les conflits locaux sont repoussés.
class SyncService {
  bool _isSyncing = false;
  SyncStatus _status = SyncStatus.idle;
  Timer? _autoSyncTimer;

  final StreamController<SyncStatus> _statusController = StreamController<SyncStatus>.broadcast();

  SyncStatus get status => _status;
  Stream<SyncStatus> get statusStream => _statusController.stream;

  static SyncService? _instance;
  static SyncService get instance => _instance ??= SyncService._();
  SyncService._();

  static const _kLastSync = 'last_sync_timestamp';

  static db.AppDatabase get _db => db.DbProvider.instance;

  // ---------------------------------------------------------------------------
  // Cycle de vie
  // ---------------------------------------------------------------------------

  void init() {
    _autoSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) => sync());
    Future.delayed(const Duration(seconds: 3), sync);
  }

  Future<void> sync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      _setStatus(SyncStatus.pushing);
      await _pushPending();

      _setStatus(SyncStatus.pulling);
      await _pullRemote();

      final now = DateTime.now().millisecondsSinceEpoch;
      await _db.into(_db.syncState).insert(
        db.SyncStateCompanion(
          key: const Value(_kLastSync),
          value: Value(now),
        ),
        mode: InsertMode.insertOrReplace,
      );

      // recharger les caches après sync
      await StorageService.init();

      _setStatus(SyncStatus.success);
    } catch (e, s) {
      debugPrint('[Sync] Erreur: $e\n$s');
      _setStatus(SyncStatus.error);
    } finally {
      _isSyncing = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Push
  // ---------------------------------------------------------------------------

  Future<void> _pushPending() async {
    final pending = await (_db.select(_db.syncLog)
      ..where((t) => t.syncedAt.isNull())
      ..orderBy([(t) => OrderingTerm(expression: t.occurredAt)])
    ).get();

    if (pending.isEmpty) return;

    final client = SupabaseService.instance.client;

    for (final op in pending) {
      try {
        await _pushOperation(client, op);
        await (_db.update(_db.syncLog)..where((t) =>
          t.entityType.equals(op.entityType) &
          t.entityId.equals(op.entityId) &
          t.occurredAt.equals(op.occurredAt)
        )).write(
          db.SyncLogCompanion(syncedAt: Value(DateTime.now().millisecondsSinceEpoch)),
        );
      } catch (e) {
        debugPrint('[Sync] Push échec ${op.entityType}/${op.entityId}: $e');
      }
    }
  }

  Future<void> _pushOperation(SupabaseClient client, db.SyncLogData op) async {
    final table = _remoteTable(op.entityType);
    if (table == null) return;

    final data = await _buildPushPayload(op);
    if (data == null) return;

    switch (op.action) {
      case 'create':
        await client.from(table).insert(data);
      case 'update':
        await client.from(table).upsert(data);
      case 'delete':
        await client.from(table).delete().eq('id', op.entityId);
    }
  }

  String? _remoteTable(String entityType) {
    switch (entityType) {
      case 'course': return 'courses';
      case 'chapter': return 'chapters';
      case 'note': return 'notes';
      case 'user': return 'users';
      default: return null;
    }
  }

  Future<Map<String, dynamic>?> _buildPushPayload(db.SyncLogData op) async {
    switch (op.entityType) {
      case 'course':
        final rows = await (_db.select(_db.courses)..where((t) => t.id.equals(op.entityId))).get();
        if (rows.isEmpty) return null;
        final c = rows.first;
        return {
          'id': c.id,
          'title': c.title,
          'subject': c.subject,
          'description': c.description,
          'type': c.type,
          'availability': c.availability,
          'progress': c.progress,
          'image_url': c.imageUrl,
          'lesson_count': c.lessonCount,
          'duration_minutes': c.durationMinutes,
          'updated_at': DateTime.fromMillisecondsSinceEpoch(c.updatedAt).toIso8601String(),
        };
      case 'user':
        final rows = await _db.select(_db.userProfile).get();
        if (rows.isEmpty) return null;
        final u = rows.first;
        return {
          'id': u.id,
          'pseudo': u.pseudo,
          'bac_series': u.bacSeries,
          'avatar_url': u.avatarUrl,
          'bio': u.bio,
          'updated_at': DateTime.now().toIso8601String(),
        };
      default:
        return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Pull
  // ---------------------------------------------------------------------------

  Future<void> _pullRemote() async {
    final lastSync = await _getLastSyncTimestamp();
    final client = SupabaseService.instance.client;

    await _pullCourses(client, lastSync);
    await _pullUser(client, lastSync);
  }

  Future<int> _getLastSyncTimestamp() async {
    final rows = await (_db.select(_db.syncState)..where((t) => t.key.equals(_kLastSync))).get();
    if (rows.isEmpty) return 0;
    return rows.first.value;
  }

  Future<void> _pullCourses(SupabaseClient client, int sinceMs) async {
    try {
      final sinceIso = DateTime.fromMillisecondsSinceEpoch(sinceMs).toIso8601String();
      final response = await client
          .from('courses')
          .select()
          .gte('updated_at', sinceIso);

      for (final row in response) {
        final map = row;
        final remoteUpdated = DateTime.parse(map['updated_at'] as String).millisecondsSinceEpoch;

        // LWW : lire l'updatedAt local depuis Drift
        final localRows = await (_db.select(_db.courses)..where((t) => t.id.equals(map['id']))).get();
        if (localRows.isNotEmpty) {
          final localUpdated = localRows.first.updatedAt;
          if (localUpdated > remoteUpdated) continue;
        }

        await _db.into(_db.courses).insert(db.CoursesCompanion(
          id: Value(map['id'] as String),
          title: Value(map['title'] as String? ?? ''),
          subject: Value(map['subject'] as String? ?? ''),
          description: Value(map['description'] as String? ?? ''),
          type: Value(map['type'] as String? ?? 'PDF'),
          availability: Value(_availFromRemote(map['availability'])),
          progress: Value((map['progress'] as num?)?.toDouble() ?? 0.0),
          imageUrl: Value(map['image_url'] as String? ?? ''),
          lessonCount: Value(map['lesson_count'] as int? ?? 0),
          durationMinutes: Value(map['duration_minutes'] as int? ?? 0),
          updatedAt: Value(remoteUpdated),
          syncStatus: const Value('synced'),
        ));
      }
    } catch (e) {
      debugPrint('[Sync] Pull courses échec: $e');
    }
  }

  Future<void> _pullUser(SupabaseClient client, int sinceMs) async {
    try {
      final authUser = client.auth.currentUser;
      if (authUser == null) return;

      final sinceIso = DateTime.fromMillisecondsSinceEpoch(sinceMs).toIso8601String();
      final response = await client
          .from('users')
          .select()
          .eq('id', authUser.id)
          .gte('updated_at', sinceIso)
          .maybeSingle();

      if (response == null) return;
      final map = response;

      final user = UserModel(
        pseudo: map['pseudo'] as String? ?? '',
        bacSeries: map['bac_series'] as String? ?? '',
        cryptoIdentity: map['id'] as String? ?? '',
        avatarUrl: map['avatar_url'] as String? ?? '',
        bio: map['bio'] as String? ?? '',
      );
      await StorageService.saveUser(user);
    } catch (e) {
      debugPrint('[Sync] Pull user échec: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Enregistrement des changements locaux
  // ---------------------------------------------------------------------------

  Future<void> trackChange(String entityType, String entityId, String action) async {
    await _db.into(_db.syncLog).insert(db.SyncLogCompanion(
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      occurredAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));

    if (!_isSyncing) {
      Future.delayed(const Duration(seconds: 2), () => sync());
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _availFromRemote(dynamic v) {
    if (v is int) return CourseAvailability.values[v].name;
    if (v is String) return v;
    return CourseAvailability.cloud.name;
  }

  void _setStatus(SyncStatus newStatus) {
    _status = newStatus;
    _statusController.add(newStatus);
  }

  Future<void> dispose() async {
    if (_isSyncing) {
      await Future.delayed(const Duration(seconds: 5));
    }
    _autoSyncTimer?.cancel();
    await _statusController.close();
  }
}
