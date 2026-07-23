// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CoursesTable extends Courses with TableInfo<$CoursesTable, Course> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoursesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _availabilityMeta = const VerificationMeta(
    'availability',
  );
  @override
  late final GeneratedColumn<String> availability = GeneratedColumn<String>(
    'availability',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonCountMeta = const VerificationMeta(
    'lessonCount',
  );
  @override
  late final GeneratedColumn<int> lessonCount = GeneratedColumn<int>(
    'lesson_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    subject,
    description,
    type,
    availability,
    progress,
    imageUrl,
    lessonCount,
    durationMinutes,
    updatedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Course> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('availability')) {
      context.handle(
        _availabilityMeta,
        availability.isAcceptableOrUnknown(
          data['availability']!,
          _availabilityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_availabilityMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('lesson_count')) {
      context.handle(
        _lessonCountMeta,
        lessonCount.isAcceptableOrUnknown(
          data['lesson_count']!,
          _lessonCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lessonCountMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Course map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Course(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      availability: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}availability'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      lessonCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_count'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $CoursesTable createAlias(String alias) {
    return $CoursesTable(attachedDatabase, alias);
  }
}

class Course extends DataClass implements Insertable<Course> {
  final String id;
  final String title;
  final String subject;
  final String description;
  final String type;
  final String availability;
  final double progress;
  final String imageUrl;
  final int lessonCount;
  final int durationMinutes;
  final int updatedAt;
  final String syncStatus;
  const Course({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.type,
    required this.availability,
    required this.progress,
    required this.imageUrl,
    required this.lessonCount,
    required this.durationMinutes,
    required this.updatedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['subject'] = Variable<String>(subject);
    map['description'] = Variable<String>(description);
    map['type'] = Variable<String>(type);
    map['availability'] = Variable<String>(availability);
    map['progress'] = Variable<double>(progress);
    map['image_url'] = Variable<String>(imageUrl);
    map['lesson_count'] = Variable<int>(lessonCount);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  CoursesCompanion toCompanion(bool nullToAbsent) {
    return CoursesCompanion(
      id: Value(id),
      title: Value(title),
      subject: Value(subject),
      description: Value(description),
      type: Value(type),
      availability: Value(availability),
      progress: Value(progress),
      imageUrl: Value(imageUrl),
      lessonCount: Value(lessonCount),
      durationMinutes: Value(durationMinutes),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Course.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Course(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      subject: serializer.fromJson<String>(json['subject']),
      description: serializer.fromJson<String>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      availability: serializer.fromJson<String>(json['availability']),
      progress: serializer.fromJson<double>(json['progress']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      lessonCount: serializer.fromJson<int>(json['lessonCount']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'subject': serializer.toJson<String>(subject),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<String>(type),
      'availability': serializer.toJson<String>(availability),
      'progress': serializer.toJson<double>(progress),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'lessonCount': serializer.toJson<int>(lessonCount),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Course copyWith({
    String? id,
    String? title,
    String? subject,
    String? description,
    String? type,
    String? availability,
    double? progress,
    String? imageUrl,
    int? lessonCount,
    int? durationMinutes,
    int? updatedAt,
    String? syncStatus,
  }) => Course(
    id: id ?? this.id,
    title: title ?? this.title,
    subject: subject ?? this.subject,
    description: description ?? this.description,
    type: type ?? this.type,
    availability: availability ?? this.availability,
    progress: progress ?? this.progress,
    imageUrl: imageUrl ?? this.imageUrl,
    lessonCount: lessonCount ?? this.lessonCount,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Course copyWithCompanion(CoursesCompanion data) {
    return Course(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      subject: data.subject.present ? data.subject.value : this.subject,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      availability: data.availability.present
          ? data.availability.value
          : this.availability,
      progress: data.progress.present ? data.progress.value : this.progress,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      lessonCount: data.lessonCount.present
          ? data.lessonCount.value
          : this.lessonCount,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Course(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subject: $subject, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('availability: $availability, ')
          ..write('progress: $progress, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('lessonCount: $lessonCount, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    subject,
    description,
    type,
    availability,
    progress,
    imageUrl,
    lessonCount,
    durationMinutes,
    updatedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Course &&
          other.id == this.id &&
          other.title == this.title &&
          other.subject == this.subject &&
          other.description == this.description &&
          other.type == this.type &&
          other.availability == this.availability &&
          other.progress == this.progress &&
          other.imageUrl == this.imageUrl &&
          other.lessonCount == this.lessonCount &&
          other.durationMinutes == this.durationMinutes &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class CoursesCompanion extends UpdateCompanion<Course> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> subject;
  final Value<String> description;
  final Value<String> type;
  final Value<String> availability;
  final Value<double> progress;
  final Value<String> imageUrl;
  final Value<int> lessonCount;
  final Value<int> durationMinutes;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const CoursesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.subject = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.availability = const Value.absent(),
    this.progress = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.lessonCount = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoursesCompanion.insert({
    required String id,
    required String title,
    required String subject,
    required String description,
    required String type,
    required String availability,
    required double progress,
    required String imageUrl,
    required int lessonCount,
    required int durationMinutes,
    required int updatedAt,
    required String syncStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       subject = Value(subject),
       description = Value(description),
       type = Value(type),
       availability = Value(availability),
       progress = Value(progress),
       imageUrl = Value(imageUrl),
       lessonCount = Value(lessonCount),
       durationMinutes = Value(durationMinutes),
       updatedAt = Value(updatedAt),
       syncStatus = Value(syncStatus);
  static Insertable<Course> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? subject,
    Expression<String>? description,
    Expression<String>? type,
    Expression<String>? availability,
    Expression<double>? progress,
    Expression<String>? imageUrl,
    Expression<int>? lessonCount,
    Expression<int>? durationMinutes,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (subject != null) 'subject': subject,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (availability != null) 'availability': availability,
      if (progress != null) 'progress': progress,
      if (imageUrl != null) 'image_url': imageUrl,
      if (lessonCount != null) 'lesson_count': lessonCount,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoursesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? subject,
    Value<String>? description,
    Value<String>? type,
    Value<String>? availability,
    Value<double>? progress,
    Value<String>? imageUrl,
    Value<int>? lessonCount,
    Value<int>? durationMinutes,
    Value<int>? updatedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return CoursesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      type: type ?? this.type,
      availability: availability ?? this.availability,
      progress: progress ?? this.progress,
      imageUrl: imageUrl ?? this.imageUrl,
      lessonCount: lessonCount ?? this.lessonCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (availability.present) {
      map['availability'] = Variable<String>(availability.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (lessonCount.present) {
      map['lesson_count'] = Variable<int>(lessonCount.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoursesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subject: $subject, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('availability: $availability, ')
          ..write('progress: $progress, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('lessonCount: $lessonCount, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentUrlMeta = const VerificationMeta(
    'contentUrl',
  );
  @override
  late final GeneratedColumn<String> contentUrl = GeneratedColumn<String>(
    'content_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _availabilityMeta = const VerificationMeta(
    'availability',
  );
  @override
  late final GeneratedColumn<String> availability = GeneratedColumn<String>(
    'availability',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseId,
    title,
    contentUrl,
    type,
    availability,
    progress,
    updatedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_url')) {
      context.handle(
        _contentUrlMeta,
        contentUrl.isAcceptableOrUnknown(data['content_url']!, _contentUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_contentUrlMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('availability')) {
      context.handle(
        _availabilityMeta,
        availability.isAcceptableOrUnknown(
          data['availability']!,
          _availabilityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_availabilityMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      contentUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_url'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      availability: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}availability'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final String id;
  final String courseId;
  final String title;
  final String contentUrl;
  final String type;
  final String availability;
  final double progress;
  final int updatedAt;
  final String syncStatus;
  const Chapter({
    required this.id,
    required this.courseId,
    required this.title,
    required this.contentUrl,
    required this.type,
    required this.availability,
    required this.progress,
    required this.updatedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['title'] = Variable<String>(title);
    map['content_url'] = Variable<String>(contentUrl);
    map['type'] = Variable<String>(type);
    map['availability'] = Variable<String>(availability);
    map['progress'] = Variable<double>(progress);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      courseId: Value(courseId),
      title: Value(title),
      contentUrl: Value(contentUrl),
      type: Value(type),
      availability: Value(availability),
      progress: Value(progress),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      contentUrl: serializer.fromJson<String>(json['contentUrl']),
      type: serializer.fromJson<String>(json['type']),
      availability: serializer.fromJson<String>(json['availability']),
      progress: serializer.fromJson<double>(json['progress']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String>(courseId),
      'title': serializer.toJson<String>(title),
      'contentUrl': serializer.toJson<String>(contentUrl),
      'type': serializer.toJson<String>(type),
      'availability': serializer.toJson<String>(availability),
      'progress': serializer.toJson<double>(progress),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Chapter copyWith({
    String? id,
    String? courseId,
    String? title,
    String? contentUrl,
    String? type,
    String? availability,
    double? progress,
    int? updatedAt,
    String? syncStatus,
  }) => Chapter(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    contentUrl: contentUrl ?? this.contentUrl,
    type: type ?? this.type,
    availability: availability ?? this.availability,
    progress: progress ?? this.progress,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      title: data.title.present ? data.title.value : this.title,
      contentUrl: data.contentUrl.present
          ? data.contentUrl.value
          : this.contentUrl,
      type: data.type.present ? data.type.value : this.type,
      availability: data.availability.present
          ? data.availability.value
          : this.availability,
      progress: data.progress.present ? data.progress.value : this.progress,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('contentUrl: $contentUrl, ')
          ..write('type: $type, ')
          ..write('availability: $availability, ')
          ..write('progress: $progress, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    courseId,
    title,
    contentUrl,
    type,
    availability,
    progress,
    updatedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.contentUrl == this.contentUrl &&
          other.type == this.type &&
          other.availability == this.availability &&
          other.progress == this.progress &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<String> title;
  final Value<String> contentUrl;
  final Value<String> type;
  final Value<String> availability;
  final Value<double> progress;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.contentUrl = const Value.absent(),
    this.type = const Value.absent(),
    this.availability = const Value.absent(),
    this.progress = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String id,
    required String courseId,
    required String title,
    required String contentUrl,
    required String type,
    required String availability,
    required double progress,
    required int updatedAt,
    required String syncStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       courseId = Value(courseId),
       title = Value(title),
       contentUrl = Value(contentUrl),
       type = Value(type),
       availability = Value(availability),
       progress = Value(progress),
       updatedAt = Value(updatedAt),
       syncStatus = Value(syncStatus);
  static Insertable<Chapter> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? title,
    Expression<String>? contentUrl,
    Expression<String>? type,
    Expression<String>? availability,
    Expression<double>? progress,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (contentUrl != null) 'content_url': contentUrl,
      if (type != null) 'type': type,
      if (availability != null) 'availability': availability,
      if (progress != null) 'progress': progress,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith({
    Value<String>? id,
    Value<String>? courseId,
    Value<String>? title,
    Value<String>? contentUrl,
    Value<String>? type,
    Value<String>? availability,
    Value<double>? progress,
    Value<int>? updatedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return ChaptersCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      contentUrl: contentUrl ?? this.contentUrl,
      type: type ?? this.type,
      availability: availability ?? this.availability,
      progress: progress ?? this.progress,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentUrl.present) {
      map['content_url'] = Variable<String>(contentUrl.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (availability.present) {
      map['availability'] = Variable<String>(availability.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('contentUrl: $contentUrl, ')
          ..write('type: $type, ')
          ..write('availability: $availability, ')
          ..write('progress: $progress, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chapterId,
    content,
    createdAt,
    updatedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final String id;
  final String chapterId;
  final String content;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;
  const Note({
    required this.id,
    required this.chapterId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<String>(json['id']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Note copyWith({
    String? id,
    String? chapterId,
    String? content,
    int? createdAt,
    int? updatedAt,
    String? syncStatus,
  }) => Note(
    id: id ?? this.id,
    chapterId: chapterId ?? this.chapterId,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, chapterId, content, createdAt, updatedAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> id;
  final Value<String> chapterId;
  final Value<String> content;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String chapterId,
    required String content,
    required int createdAt,
    required int updatedAt,
    required String syncStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       chapterId = Value(chapterId),
       content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       syncStatus = Value(syncStatus);
  static Insertable<Note> custom({
    Expression<String>? id,
    Expression<String>? chapterId,
    Expression<String>? content,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith({
    Value<String>? id,
    Value<String>? chapterId,
    Value<String>? content,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeshMessagesTable extends MeshMessages
    with TableInfo<$MeshMessagesTable, MeshMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeshMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorPseudoMeta = const VerificationMeta(
    'authorPseudo',
  );
  @override
  late final GeneratedColumn<String> authorPseudo = GeneratedColumn<String>(
    'author_pseudo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hopCountMeta = const VerificationMeta(
    'hopCount',
  );
  @override
  late final GeneratedColumn<int> hopCount = GeneratedColumn<int>(
    'hop_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reactionsMeta = const VerificationMeta(
    'reactions',
  );
  @override
  late final GeneratedColumn<String> reactions = GeneratedColumn<String>(
    'reactions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<String> fileId = GeneratedColumn<String>(
    'file_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileMimeTypeMeta = const VerificationMeta(
    'fileMimeType',
  );
  @override
  late final GeneratedColumn<String> fileMimeType = GeneratedColumn<String>(
    'file_mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replyToIdMeta = const VerificationMeta(
    'replyToId',
  );
  @override
  late final GeneratedColumn<String> replyToId = GeneratedColumn<String>(
    'reply_to_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routeInfoMeta = const VerificationMeta(
    'routeInfo',
  );
  @override
  late final GeneratedColumn<String> routeInfo = GeneratedColumn<String>(
    'route_info',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    authorPseudo,
    content,
    type,
    timestamp,
    imageUrl,
    audioUrl,
    hopCount,
    reactions,
    updatedAt,
    syncStatus,
    fileId,
    fileName,
    fileSize,
    fileMimeType,
    replyToId,
    status,
    routeInfo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mesh_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeshMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('author_pseudo')) {
      context.handle(
        _authorPseudoMeta,
        authorPseudo.isAcceptableOrUnknown(
          data['author_pseudo']!,
          _authorPseudoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorPseudoMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('hop_count')) {
      context.handle(
        _hopCountMeta,
        hopCount.isAcceptableOrUnknown(data['hop_count']!, _hopCountMeta),
      );
    } else if (isInserting) {
      context.missing(_hopCountMeta);
    }
    if (data.containsKey('reactions')) {
      context.handle(
        _reactionsMeta,
        reactions.isAcceptableOrUnknown(data['reactions']!, _reactionsMeta),
      );
    } else if (isInserting) {
      context.missing(_reactionsMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    }
    if (data.containsKey('file_mime_type')) {
      context.handle(
        _fileMimeTypeMeta,
        fileMimeType.isAcceptableOrUnknown(
          data['file_mime_type']!,
          _fileMimeTypeMeta,
        ),
      );
    }
    if (data.containsKey('reply_to_id')) {
      context.handle(
        _replyToIdMeta,
        replyToId.isAcceptableOrUnknown(data['reply_to_id']!, _replyToIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('route_info')) {
      context.handle(
        _routeInfoMeta,
        routeInfo.isAcceptableOrUnknown(data['route_info']!, _routeInfoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeshMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeshMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      authorPseudo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_pseudo'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      hopCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hop_count'],
      )!,
      reactions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reactions'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_id'],
      ),
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      ),
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      ),
      fileMimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_mime_type'],
      ),
      replyToId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_to_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      routeInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_info'],
      ),
    );
  }

  @override
  $MeshMessagesTable createAlias(String alias) {
    return $MeshMessagesTable(attachedDatabase, alias);
  }
}

class MeshMessage extends DataClass implements Insertable<MeshMessage> {
  final String id;
  final String authorPseudo;
  final String content;
  final String type;
  final int timestamp;
  final String? imageUrl;
  final String? audioUrl;
  final int hopCount;
  final String reactions;
  final int updatedAt;
  final String syncStatus;
  final String? fileId;
  final String? fileName;
  final int? fileSize;
  final String? fileMimeType;
  final String? replyToId;
  final String status;
  final String? routeInfo;
  const MeshMessage({
    required this.id,
    required this.authorPseudo,
    required this.content,
    required this.type,
    required this.timestamp,
    this.imageUrl,
    this.audioUrl,
    required this.hopCount,
    required this.reactions,
    required this.updatedAt,
    required this.syncStatus,
    this.fileId,
    this.fileName,
    this.fileSize,
    this.fileMimeType,
    this.replyToId,
    required this.status,
    this.routeInfo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['author_pseudo'] = Variable<String>(authorPseudo);
    map['content'] = Variable<String>(content);
    map['type'] = Variable<String>(type);
    map['timestamp'] = Variable<int>(timestamp);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    map['hop_count'] = Variable<int>(hopCount);
    map['reactions'] = Variable<String>(reactions);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || fileId != null) {
      map['file_id'] = Variable<String>(fileId);
    }
    if (!nullToAbsent || fileName != null) {
      map['file_name'] = Variable<String>(fileName);
    }
    if (!nullToAbsent || fileSize != null) {
      map['file_size'] = Variable<int>(fileSize);
    }
    if (!nullToAbsent || fileMimeType != null) {
      map['file_mime_type'] = Variable<String>(fileMimeType);
    }
    if (!nullToAbsent || replyToId != null) {
      map['reply_to_id'] = Variable<String>(replyToId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || routeInfo != null) {
      map['route_info'] = Variable<String>(routeInfo);
    }
    return map;
  }

  MeshMessagesCompanion toCompanion(bool nullToAbsent) {
    return MeshMessagesCompanion(
      id: Value(id),
      authorPseudo: Value(authorPseudo),
      content: Value(content),
      type: Value(type),
      timestamp: Value(timestamp),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      hopCount: Value(hopCount),
      reactions: Value(reactions),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      fileId: fileId == null && nullToAbsent
          ? const Value.absent()
          : Value(fileId),
      fileName: fileName == null && nullToAbsent
          ? const Value.absent()
          : Value(fileName),
      fileSize: fileSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSize),
      fileMimeType: fileMimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(fileMimeType),
      replyToId: replyToId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToId),
      status: Value(status),
      routeInfo: routeInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(routeInfo),
    );
  }

  factory MeshMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeshMessage(
      id: serializer.fromJson<String>(json['id']),
      authorPseudo: serializer.fromJson<String>(json['authorPseudo']),
      content: serializer.fromJson<String>(json['content']),
      type: serializer.fromJson<String>(json['type']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      hopCount: serializer.fromJson<int>(json['hopCount']),
      reactions: serializer.fromJson<String>(json['reactions']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      fileId: serializer.fromJson<String?>(json['fileId']),
      fileName: serializer.fromJson<String?>(json['fileName']),
      fileSize: serializer.fromJson<int?>(json['fileSize']),
      fileMimeType: serializer.fromJson<String?>(json['fileMimeType']),
      replyToId: serializer.fromJson<String?>(json['replyToId']),
      status: serializer.fromJson<String>(json['status']),
      routeInfo: serializer.fromJson<String?>(json['routeInfo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'authorPseudo': serializer.toJson<String>(authorPseudo),
      'content': serializer.toJson<String>(content),
      'type': serializer.toJson<String>(type),
      'timestamp': serializer.toJson<int>(timestamp),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'hopCount': serializer.toJson<int>(hopCount),
      'reactions': serializer.toJson<String>(reactions),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'fileId': serializer.toJson<String?>(fileId),
      'fileName': serializer.toJson<String?>(fileName),
      'fileSize': serializer.toJson<int?>(fileSize),
      'fileMimeType': serializer.toJson<String?>(fileMimeType),
      'replyToId': serializer.toJson<String?>(replyToId),
      'status': serializer.toJson<String>(status),
      'routeInfo': serializer.toJson<String?>(routeInfo),
    };
  }

  MeshMessage copyWith({
    String? id,
    String? authorPseudo,
    String? content,
    String? type,
    int? timestamp,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> audioUrl = const Value.absent(),
    int? hopCount,
    String? reactions,
    int? updatedAt,
    String? syncStatus,
    Value<String?> fileId = const Value.absent(),
    Value<String?> fileName = const Value.absent(),
    Value<int?> fileSize = const Value.absent(),
    Value<String?> fileMimeType = const Value.absent(),
    Value<String?> replyToId = const Value.absent(),
    String? status,
    Value<String?> routeInfo = const Value.absent(),
  }) => MeshMessage(
    id: id ?? this.id,
    authorPseudo: authorPseudo ?? this.authorPseudo,
    content: content ?? this.content,
    type: type ?? this.type,
    timestamp: timestamp ?? this.timestamp,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    hopCount: hopCount ?? this.hopCount,
    reactions: reactions ?? this.reactions,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    fileId: fileId.present ? fileId.value : this.fileId,
    fileName: fileName.present ? fileName.value : this.fileName,
    fileSize: fileSize.present ? fileSize.value : this.fileSize,
    fileMimeType: fileMimeType.present ? fileMimeType.value : this.fileMimeType,
    replyToId: replyToId.present ? replyToId.value : this.replyToId,
    status: status ?? this.status,
    routeInfo: routeInfo.present ? routeInfo.value : this.routeInfo,
  );
  MeshMessage copyWithCompanion(MeshMessagesCompanion data) {
    return MeshMessage(
      id: data.id.present ? data.id.value : this.id,
      authorPseudo: data.authorPseudo.present
          ? data.authorPseudo.value
          : this.authorPseudo,
      content: data.content.present ? data.content.value : this.content,
      type: data.type.present ? data.type.value : this.type,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      hopCount: data.hopCount.present ? data.hopCount.value : this.hopCount,
      reactions: data.reactions.present ? data.reactions.value : this.reactions,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      fileMimeType: data.fileMimeType.present
          ? data.fileMimeType.value
          : this.fileMimeType,
      replyToId: data.replyToId.present ? data.replyToId.value : this.replyToId,
      status: data.status.present ? data.status.value : this.status,
      routeInfo: data.routeInfo.present ? data.routeInfo.value : this.routeInfo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeshMessage(')
          ..write('id: $id, ')
          ..write('authorPseudo: $authorPseudo, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('timestamp: $timestamp, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('hopCount: $hopCount, ')
          ..write('reactions: $reactions, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('fileId: $fileId, ')
          ..write('fileName: $fileName, ')
          ..write('fileSize: $fileSize, ')
          ..write('fileMimeType: $fileMimeType, ')
          ..write('replyToId: $replyToId, ')
          ..write('status: $status, ')
          ..write('routeInfo: $routeInfo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    authorPseudo,
    content,
    type,
    timestamp,
    imageUrl,
    audioUrl,
    hopCount,
    reactions,
    updatedAt,
    syncStatus,
    fileId,
    fileName,
    fileSize,
    fileMimeType,
    replyToId,
    status,
    routeInfo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeshMessage &&
          other.id == this.id &&
          other.authorPseudo == this.authorPseudo &&
          other.content == this.content &&
          other.type == this.type &&
          other.timestamp == this.timestamp &&
          other.imageUrl == this.imageUrl &&
          other.audioUrl == this.audioUrl &&
          other.hopCount == this.hopCount &&
          other.reactions == this.reactions &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.fileId == this.fileId &&
          other.fileName == this.fileName &&
          other.fileSize == this.fileSize &&
          other.fileMimeType == this.fileMimeType &&
          other.replyToId == this.replyToId &&
          other.status == this.status &&
          other.routeInfo == this.routeInfo);
}

class MeshMessagesCompanion extends UpdateCompanion<MeshMessage> {
  final Value<String> id;
  final Value<String> authorPseudo;
  final Value<String> content;
  final Value<String> type;
  final Value<int> timestamp;
  final Value<String?> imageUrl;
  final Value<String?> audioUrl;
  final Value<int> hopCount;
  final Value<String> reactions;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<String?> fileId;
  final Value<String?> fileName;
  final Value<int?> fileSize;
  final Value<String?> fileMimeType;
  final Value<String?> replyToId;
  final Value<String> status;
  final Value<String?> routeInfo;
  final Value<int> rowid;
  const MeshMessagesCompanion({
    this.id = const Value.absent(),
    this.authorPseudo = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.hopCount = const Value.absent(),
    this.reactions = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.fileId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.fileMimeType = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.status = const Value.absent(),
    this.routeInfo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeshMessagesCompanion.insert({
    required String id,
    required String authorPseudo,
    required String content,
    required String type,
    required int timestamp,
    this.imageUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    required int hopCount,
    required String reactions,
    required int updatedAt,
    required String syncStatus,
    this.fileId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.fileMimeType = const Value.absent(),
    this.replyToId = const Value.absent(),
    required String status,
    this.routeInfo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       authorPseudo = Value(authorPseudo),
       content = Value(content),
       type = Value(type),
       timestamp = Value(timestamp),
       hopCount = Value(hopCount),
       reactions = Value(reactions),
       updatedAt = Value(updatedAt),
       syncStatus = Value(syncStatus),
       status = Value(status);
  static Insertable<MeshMessage> custom({
    Expression<String>? id,
    Expression<String>? authorPseudo,
    Expression<String>? content,
    Expression<String>? type,
    Expression<int>? timestamp,
    Expression<String>? imageUrl,
    Expression<String>? audioUrl,
    Expression<int>? hopCount,
    Expression<String>? reactions,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? fileId,
    Expression<String>? fileName,
    Expression<int>? fileSize,
    Expression<String>? fileMimeType,
    Expression<String>? replyToId,
    Expression<String>? status,
    Expression<String>? routeInfo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authorPseudo != null) 'author_pseudo': authorPseudo,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
      if (timestamp != null) 'timestamp': timestamp,
      if (imageUrl != null) 'image_url': imageUrl,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (hopCount != null) 'hop_count': hopCount,
      if (reactions != null) 'reactions': reactions,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (fileId != null) 'file_id': fileId,
      if (fileName != null) 'file_name': fileName,
      if (fileSize != null) 'file_size': fileSize,
      if (fileMimeType != null) 'file_mime_type': fileMimeType,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (status != null) 'status': status,
      if (routeInfo != null) 'route_info': routeInfo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeshMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? authorPseudo,
    Value<String>? content,
    Value<String>? type,
    Value<int>? timestamp,
    Value<String?>? imageUrl,
    Value<String?>? audioUrl,
    Value<int>? hopCount,
    Value<String>? reactions,
    Value<int>? updatedAt,
    Value<String>? syncStatus,
    Value<String?>? fileId,
    Value<String?>? fileName,
    Value<int?>? fileSize,
    Value<String?>? fileMimeType,
    Value<String?>? replyToId,
    Value<String>? status,
    Value<String?>? routeInfo,
    Value<int>? rowid,
  }) {
    return MeshMessagesCompanion(
      id: id ?? this.id,
      authorPseudo: authorPseudo ?? this.authorPseudo,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      hopCount: hopCount ?? this.hopCount,
      reactions: reactions ?? this.reactions,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      fileId: fileId ?? this.fileId,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      fileMimeType: fileMimeType ?? this.fileMimeType,
      replyToId: replyToId ?? this.replyToId,
      status: status ?? this.status,
      routeInfo: routeInfo ?? this.routeInfo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (authorPseudo.present) {
      map['author_pseudo'] = Variable<String>(authorPseudo.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (hopCount.present) {
      map['hop_count'] = Variable<int>(hopCount.value);
    }
    if (reactions.present) {
      map['reactions'] = Variable<String>(reactions.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (fileId.present) {
      map['file_id'] = Variable<String>(fileId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (fileMimeType.present) {
      map['file_mime_type'] = Variable<String>(fileMimeType.value);
    }
    if (replyToId.present) {
      map['reply_to_id'] = Variable<String>(replyToId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (routeInfo.present) {
      map['route_info'] = Variable<String>(routeInfo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeshMessagesCompanion(')
          ..write('id: $id, ')
          ..write('authorPseudo: $authorPseudo, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('timestamp: $timestamp, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('hopCount: $hopCount, ')
          ..write('reactions: $reactions, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('fileId: $fileId, ')
          ..write('fileName: $fileName, ')
          ..write('fileSize: $fileSize, ')
          ..write('fileMimeType: $fileMimeType, ')
          ..write('replyToId: $replyToId, ')
          ..write('status: $status, ')
          ..write('routeInfo: $routeInfo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfileTable extends UserProfile
    with TableInfo<$UserProfileTable, UserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pseudoMeta = const VerificationMeta('pseudo');
  @override
  late final GeneratedColumn<String> pseudo = GeneratedColumn<String>(
    'pseudo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bacSeriesMeta = const VerificationMeta(
    'bacSeries',
  );
  @override
  late final GeneratedColumn<String> bacSeries = GeneratedColumn<String>(
    'bac_series',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cryptoIdentityMeta = const VerificationMeta(
    'cryptoIdentity',
  );
  @override
  late final GeneratedColumn<String> cryptoIdentity = GeneratedColumn<String>(
    'crypto_identity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isGatewayActiveMeta = const VerificationMeta(
    'isGatewayActive',
  );
  @override
  late final GeneratedColumn<int> isGatewayActive = GeneratedColumn<int>(
    'is_gateway_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meshPeersMeta = const VerificationMeta(
    'meshPeers',
  );
  @override
  late final GeneratedColumn<int> meshPeers = GeneratedColumn<int>(
    'mesh_peers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pseudo,
    bacSeries,
    cryptoIdentity,
    avatarUrl,
    isGatewayActive,
    meshPeers,
    bio,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pseudo')) {
      context.handle(
        _pseudoMeta,
        pseudo.isAcceptableOrUnknown(data['pseudo']!, _pseudoMeta),
      );
    } else if (isInserting) {
      context.missing(_pseudoMeta);
    }
    if (data.containsKey('bac_series')) {
      context.handle(
        _bacSeriesMeta,
        bacSeries.isAcceptableOrUnknown(data['bac_series']!, _bacSeriesMeta),
      );
    } else if (isInserting) {
      context.missing(_bacSeriesMeta);
    }
    if (data.containsKey('crypto_identity')) {
      context.handle(
        _cryptoIdentityMeta,
        cryptoIdentity.isAcceptableOrUnknown(
          data['crypto_identity']!,
          _cryptoIdentityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cryptoIdentityMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarUrlMeta);
    }
    if (data.containsKey('is_gateway_active')) {
      context.handle(
        _isGatewayActiveMeta,
        isGatewayActive.isAcceptableOrUnknown(
          data['is_gateway_active']!,
          _isGatewayActiveMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isGatewayActiveMeta);
    }
    if (data.containsKey('mesh_peers')) {
      context.handle(
        _meshPeersMeta,
        meshPeers.isAcceptableOrUnknown(data['mesh_peers']!, _meshPeersMeta),
      );
    } else if (isInserting) {
      context.missing(_meshPeersMeta);
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    } else if (isInserting) {
      context.missing(_bioMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pseudo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pseudo'],
      )!,
      bacSeries: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bac_series'],
      )!,
      cryptoIdentity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crypto_identity'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      )!,
      isGatewayActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_gateway_active'],
      )!,
      meshPeers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mesh_peers'],
      )!,
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      )!,
    );
  }

  @override
  $UserProfileTable createAlias(String alias) {
    return $UserProfileTable(attachedDatabase, alias);
  }
}

class UserProfileData extends DataClass implements Insertable<UserProfileData> {
  final String id;
  final String pseudo;
  final String bacSeries;
  final String cryptoIdentity;
  final String avatarUrl;
  final int isGatewayActive;
  final int meshPeers;
  final String bio;
  const UserProfileData({
    required this.id,
    required this.pseudo,
    required this.bacSeries,
    required this.cryptoIdentity,
    required this.avatarUrl,
    required this.isGatewayActive,
    required this.meshPeers,
    required this.bio,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pseudo'] = Variable<String>(pseudo);
    map['bac_series'] = Variable<String>(bacSeries);
    map['crypto_identity'] = Variable<String>(cryptoIdentity);
    map['avatar_url'] = Variable<String>(avatarUrl);
    map['is_gateway_active'] = Variable<int>(isGatewayActive);
    map['mesh_peers'] = Variable<int>(meshPeers);
    map['bio'] = Variable<String>(bio);
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      id: Value(id),
      pseudo: Value(pseudo),
      bacSeries: Value(bacSeries),
      cryptoIdentity: Value(cryptoIdentity),
      avatarUrl: Value(avatarUrl),
      isGatewayActive: Value(isGatewayActive),
      meshPeers: Value(meshPeers),
      bio: Value(bio),
    );
  }

  factory UserProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileData(
      id: serializer.fromJson<String>(json['id']),
      pseudo: serializer.fromJson<String>(json['pseudo']),
      bacSeries: serializer.fromJson<String>(json['bacSeries']),
      cryptoIdentity: serializer.fromJson<String>(json['cryptoIdentity']),
      avatarUrl: serializer.fromJson<String>(json['avatarUrl']),
      isGatewayActive: serializer.fromJson<int>(json['isGatewayActive']),
      meshPeers: serializer.fromJson<int>(json['meshPeers']),
      bio: serializer.fromJson<String>(json['bio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pseudo': serializer.toJson<String>(pseudo),
      'bacSeries': serializer.toJson<String>(bacSeries),
      'cryptoIdentity': serializer.toJson<String>(cryptoIdentity),
      'avatarUrl': serializer.toJson<String>(avatarUrl),
      'isGatewayActive': serializer.toJson<int>(isGatewayActive),
      'meshPeers': serializer.toJson<int>(meshPeers),
      'bio': serializer.toJson<String>(bio),
    };
  }

  UserProfileData copyWith({
    String? id,
    String? pseudo,
    String? bacSeries,
    String? cryptoIdentity,
    String? avatarUrl,
    int? isGatewayActive,
    int? meshPeers,
    String? bio,
  }) => UserProfileData(
    id: id ?? this.id,
    pseudo: pseudo ?? this.pseudo,
    bacSeries: bacSeries ?? this.bacSeries,
    cryptoIdentity: cryptoIdentity ?? this.cryptoIdentity,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    isGatewayActive: isGatewayActive ?? this.isGatewayActive,
    meshPeers: meshPeers ?? this.meshPeers,
    bio: bio ?? this.bio,
  );
  UserProfileData copyWithCompanion(UserProfileCompanion data) {
    return UserProfileData(
      id: data.id.present ? data.id.value : this.id,
      pseudo: data.pseudo.present ? data.pseudo.value : this.pseudo,
      bacSeries: data.bacSeries.present ? data.bacSeries.value : this.bacSeries,
      cryptoIdentity: data.cryptoIdentity.present
          ? data.cryptoIdentity.value
          : this.cryptoIdentity,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      isGatewayActive: data.isGatewayActive.present
          ? data.isGatewayActive.value
          : this.isGatewayActive,
      meshPeers: data.meshPeers.present ? data.meshPeers.value : this.meshPeers,
      bio: data.bio.present ? data.bio.value : this.bio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileData(')
          ..write('id: $id, ')
          ..write('pseudo: $pseudo, ')
          ..write('bacSeries: $bacSeries, ')
          ..write('cryptoIdentity: $cryptoIdentity, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('isGatewayActive: $isGatewayActive, ')
          ..write('meshPeers: $meshPeers, ')
          ..write('bio: $bio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pseudo,
    bacSeries,
    cryptoIdentity,
    avatarUrl,
    isGatewayActive,
    meshPeers,
    bio,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileData &&
          other.id == this.id &&
          other.pseudo == this.pseudo &&
          other.bacSeries == this.bacSeries &&
          other.cryptoIdentity == this.cryptoIdentity &&
          other.avatarUrl == this.avatarUrl &&
          other.isGatewayActive == this.isGatewayActive &&
          other.meshPeers == this.meshPeers &&
          other.bio == this.bio);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileData> {
  final Value<String> id;
  final Value<String> pseudo;
  final Value<String> bacSeries;
  final Value<String> cryptoIdentity;
  final Value<String> avatarUrl;
  final Value<int> isGatewayActive;
  final Value<int> meshPeers;
  final Value<String> bio;
  final Value<int> rowid;
  const UserProfileCompanion({
    this.id = const Value.absent(),
    this.pseudo = const Value.absent(),
    this.bacSeries = const Value.absent(),
    this.cryptoIdentity = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.isGatewayActive = const Value.absent(),
    this.meshPeers = const Value.absent(),
    this.bio = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfileCompanion.insert({
    required String id,
    required String pseudo,
    required String bacSeries,
    required String cryptoIdentity,
    required String avatarUrl,
    required int isGatewayActive,
    required int meshPeers,
    required String bio,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pseudo = Value(pseudo),
       bacSeries = Value(bacSeries),
       cryptoIdentity = Value(cryptoIdentity),
       avatarUrl = Value(avatarUrl),
       isGatewayActive = Value(isGatewayActive),
       meshPeers = Value(meshPeers),
       bio = Value(bio);
  static Insertable<UserProfileData> custom({
    Expression<String>? id,
    Expression<String>? pseudo,
    Expression<String>? bacSeries,
    Expression<String>? cryptoIdentity,
    Expression<String>? avatarUrl,
    Expression<int>? isGatewayActive,
    Expression<int>? meshPeers,
    Expression<String>? bio,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pseudo != null) 'pseudo': pseudo,
      if (bacSeries != null) 'bac_series': bacSeries,
      if (cryptoIdentity != null) 'crypto_identity': cryptoIdentity,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (isGatewayActive != null) 'is_gateway_active': isGatewayActive,
      if (meshPeers != null) 'mesh_peers': meshPeers,
      if (bio != null) 'bio': bio,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfileCompanion copyWith({
    Value<String>? id,
    Value<String>? pseudo,
    Value<String>? bacSeries,
    Value<String>? cryptoIdentity,
    Value<String>? avatarUrl,
    Value<int>? isGatewayActive,
    Value<int>? meshPeers,
    Value<String>? bio,
    Value<int>? rowid,
  }) {
    return UserProfileCompanion(
      id: id ?? this.id,
      pseudo: pseudo ?? this.pseudo,
      bacSeries: bacSeries ?? this.bacSeries,
      cryptoIdentity: cryptoIdentity ?? this.cryptoIdentity,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isGatewayActive: isGatewayActive ?? this.isGatewayActive,
      meshPeers: meshPeers ?? this.meshPeers,
      bio: bio ?? this.bio,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pseudo.present) {
      map['pseudo'] = Variable<String>(pseudo.value);
    }
    if (bacSeries.present) {
      map['bac_series'] = Variable<String>(bacSeries.value);
    }
    if (cryptoIdentity.present) {
      map['crypto_identity'] = Variable<String>(cryptoIdentity.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (isGatewayActive.present) {
      map['is_gateway_active'] = Variable<int>(isGatewayActive.value);
    }
    if (meshPeers.present) {
      map['mesh_peers'] = Variable<int>(meshPeers.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileCompanion(')
          ..write('id: $id, ')
          ..write('pseudo: $pseudo, ')
          ..write('bacSeries: $bacSeries, ')
          ..write('cryptoIdentity: $cryptoIdentity, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('isGatewayActive: $isGatewayActive, ')
          ..write('meshPeers: $meshPeers, ')
          ..write('bio: $bio, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SeenMessageIdsTable extends SeenMessageIds
    with TableInfo<$SeenMessageIdsTable, SeenMessageId> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeenMessageIdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [messageId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seen_message_ids';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeenMessageId> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId};
  @override
  SeenMessageId map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeenMessageId(
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
    );
  }

  @override
  $SeenMessageIdsTable createAlias(String alias) {
    return $SeenMessageIdsTable(attachedDatabase, alias);
  }
}

class SeenMessageId extends DataClass implements Insertable<SeenMessageId> {
  final String messageId;
  const SeenMessageId({required this.messageId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['message_id'] = Variable<String>(messageId);
    return map;
  }

  SeenMessageIdsCompanion toCompanion(bool nullToAbsent) {
    return SeenMessageIdsCompanion(messageId: Value(messageId));
  }

  factory SeenMessageId.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeenMessageId(
      messageId: serializer.fromJson<String>(json['messageId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'messageId': serializer.toJson<String>(messageId)};
  }

  SeenMessageId copyWith({String? messageId}) =>
      SeenMessageId(messageId: messageId ?? this.messageId);
  SeenMessageId copyWithCompanion(SeenMessageIdsCompanion data) {
    return SeenMessageId(
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeenMessageId(')
          ..write('messageId: $messageId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => messageId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeenMessageId && other.messageId == this.messageId);
}

class SeenMessageIdsCompanion extends UpdateCompanion<SeenMessageId> {
  final Value<String> messageId;
  final Value<int> rowid;
  const SeenMessageIdsCompanion({
    this.messageId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SeenMessageIdsCompanion.insert({
    required String messageId,
    this.rowid = const Value.absent(),
  }) : messageId = Value(messageId);
  static Insertable<SeenMessageId> custom({
    Expression<String>? messageId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SeenMessageIdsCompanion copyWith({
    Value<String>? messageId,
    Value<int>? rowid,
  }) {
    return SeenMessageIdsCompanion(
      messageId: messageId ?? this.messageId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeenMessageIdsCompanion(')
          ..write('messageId: $messageId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuthCredentialsTableTable extends AuthCredentialsTable
    with TableInfo<$AuthCredentialsTableTable, AuthCredentialsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthCredentialsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'refresh_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<int> expiresAt = GeneratedColumn<int>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    accessToken,
    refreshToken,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_credentials_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthCredentialsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accessTokenMeta);
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(
          data['refresh_token']!,
          _refreshTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_refreshTokenMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AuthCredentialsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthCredentialsTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      )!,
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires_at'],
      )!,
    );
  }

  @override
  $AuthCredentialsTableTable createAlias(String alias) {
    return $AuthCredentialsTableTable(attachedDatabase, alias);
  }
}

class AuthCredentialsTableData extends DataClass
    implements Insertable<AuthCredentialsTableData> {
  final String key;
  final String accessToken;
  final String refreshToken;
  final int expiresAt;
  const AuthCredentialsTableData({
    required this.key,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['access_token'] = Variable<String>(accessToken);
    map['refresh_token'] = Variable<String>(refreshToken);
    map['expires_at'] = Variable<int>(expiresAt);
    return map;
  }

  AuthCredentialsTableCompanion toCompanion(bool nullToAbsent) {
    return AuthCredentialsTableCompanion(
      key: Value(key),
      accessToken: Value(accessToken),
      refreshToken: Value(refreshToken),
      expiresAt: Value(expiresAt),
    );
  }

  factory AuthCredentialsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthCredentialsTableData(
      key: serializer.fromJson<String>(json['key']),
      accessToken: serializer.fromJson<String>(json['accessToken']),
      refreshToken: serializer.fromJson<String>(json['refreshToken']),
      expiresAt: serializer.fromJson<int>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'accessToken': serializer.toJson<String>(accessToken),
      'refreshToken': serializer.toJson<String>(refreshToken),
      'expiresAt': serializer.toJson<int>(expiresAt),
    };
  }

  AuthCredentialsTableData copyWith({
    String? key,
    String? accessToken,
    String? refreshToken,
    int? expiresAt,
  }) => AuthCredentialsTableData(
    key: key ?? this.key,
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    expiresAt: expiresAt ?? this.expiresAt,
  );
  AuthCredentialsTableData copyWithCompanion(
    AuthCredentialsTableCompanion data,
  ) {
    return AuthCredentialsTableData(
      key: data.key.present ? data.key.value : this.key,
      accessToken: data.accessToken.present
          ? data.accessToken.value
          : this.accessToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthCredentialsTableData(')
          ..write('key: $key, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, accessToken, refreshToken, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthCredentialsTableData &&
          other.key == this.key &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken &&
          other.expiresAt == this.expiresAt);
}

class AuthCredentialsTableCompanion
    extends UpdateCompanion<AuthCredentialsTableData> {
  final Value<String> key;
  final Value<String> accessToken;
  final Value<String> refreshToken;
  final Value<int> expiresAt;
  final Value<int> rowid;
  const AuthCredentialsTableCompanion({
    this.key = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthCredentialsTableCompanion.insert({
    required String key,
    required String accessToken,
    required String refreshToken,
    required int expiresAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       accessToken = Value(accessToken),
       refreshToken = Value(refreshToken),
       expiresAt = Value(expiresAt);
  static Insertable<AuthCredentialsTableData> custom({
    Expression<String>? key,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<int>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthCredentialsTableCompanion copyWith({
    Value<String>? key,
    Value<String>? accessToken,
    Value<String>? refreshToken,
    Value<int>? expiresAt,
    Value<int>? rowid,
  }) {
    return AuthCredentialsTableCompanion(
      key: key ?? this.key,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<int>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthCredentialsTableCompanion(')
          ..write('key: $key, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncLogTable extends SyncLog with TableInfo<$SyncLogTable, SyncLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<int> occurredAt = GeneratedColumn<int>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<int> syncedAt = GeneratedColumn<int>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    entityType,
    entityId,
    action,
    occurredAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityType, entityId, occurredAt};
  @override
  SyncLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLogData(
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurred_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $SyncLogTable createAlias(String alias) {
    return $SyncLogTable(attachedDatabase, alias);
  }
}

class SyncLogData extends DataClass implements Insertable<SyncLogData> {
  final String entityType;
  final String entityId;
  final String action;
  final int occurredAt;
  final int? syncedAt;
  const SyncLogData({
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.occurredAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    map['occurred_at'] = Variable<int>(occurredAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<int>(syncedAt);
    }
    return map;
  }

  SyncLogCompanion toCompanion(bool nullToAbsent) {
    return SyncLogCompanion(
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      occurredAt: Value(occurredAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SyncLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLogData(
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      occurredAt: serializer.fromJson<int>(json['occurredAt']),
      syncedAt: serializer.fromJson<int?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'occurredAt': serializer.toJson<int>(occurredAt),
      'syncedAt': serializer.toJson<int?>(syncedAt),
    };
  }

  SyncLogData copyWith({
    String? entityType,
    String? entityId,
    String? action,
    int? occurredAt,
    Value<int?> syncedAt = const Value.absent(),
  }) => SyncLogData(
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    action: action ?? this.action,
    occurredAt: occurredAt ?? this.occurredAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  SyncLogData copyWithCompanion(SyncLogCompanion data) {
    return SyncLogData(
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogData(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(entityType, entityId, action, occurredAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLogData &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.occurredAt == this.occurredAt &&
          other.syncedAt == this.syncedAt);
}

class SyncLogCompanion extends UpdateCompanion<SyncLogData> {
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> action;
  final Value<int> occurredAt;
  final Value<int?> syncedAt;
  final Value<int> rowid;
  const SyncLogCompanion({
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncLogCompanion.insert({
    required String entityType,
    required String entityId,
    required String action,
    required int occurredAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       action = Value(action),
       occurredAt = Value(occurredAt);
  static Insertable<SyncLogData> custom({
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<int>? occurredAt,
    Expression<int>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncLogCompanion copyWith({
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? action,
    Value<int>? occurredAt,
    Value<int?>? syncedAt,
    Value<int>? rowid,
  }) {
    return SyncLogCompanion(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      occurredAt: occurredAt ?? this.occurredAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<int>(occurredAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<int>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogCompanion(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final String key;
  final int value;
  const SyncStateData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<int>(value);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(key: Value(key), value: Value(value));
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<int>(value),
    };
  }

  SyncStateData copyWith({String? key, int? value}) =>
      SyncStateData(key: key ?? this.key, value: value ?? this.value);
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<String> key;
  final Value<int> value;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String key,
    required int value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncStateData> custom({
    Expression<String>? key,
    Expression<int>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? key,
    Value<int>? value,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CoursesTable courses = $CoursesTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $MeshMessagesTable meshMessages = $MeshMessagesTable(this);
  late final $UserProfileTable userProfile = $UserProfileTable(this);
  late final $SeenMessageIdsTable seenMessageIds = $SeenMessageIdsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $AuthCredentialsTableTable authCredentialsTable =
      $AuthCredentialsTableTable(this);
  late final $SyncLogTable syncLog = $SyncLogTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    courses,
    chapters,
    notes,
    meshMessages,
    userProfile,
    seenMessageIds,
    appSettings,
    authCredentialsTable,
    syncLog,
    syncState,
  ];
}

typedef $$CoursesTableCreateCompanionBuilder =
    CoursesCompanion Function({
      required String id,
      required String title,
      required String subject,
      required String description,
      required String type,
      required String availability,
      required double progress,
      required String imageUrl,
      required int lessonCount,
      required int durationMinutes,
      required int updatedAt,
      required String syncStatus,
      Value<int> rowid,
    });
typedef $$CoursesTableUpdateCompanionBuilder =
    CoursesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> subject,
      Value<String> description,
      Value<String> type,
      Value<String> availability,
      Value<double> progress,
      Value<String> imageUrl,
      Value<int> lessonCount,
      Value<int> durationMinutes,
      Value<int> updatedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$CoursesTableFilterComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lessonCount => $composableBuilder(
    column: $table.lessonCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoursesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lessonCount => $composableBuilder(
    column: $table.lessonCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoursesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => column,
  );

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get lessonCount => $composableBuilder(
    column: $table.lessonCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$CoursesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoursesTable,
          Course,
          $$CoursesTableFilterComposer,
          $$CoursesTableOrderingComposer,
          $$CoursesTableAnnotationComposer,
          $$CoursesTableCreateCompanionBuilder,
          $$CoursesTableUpdateCompanionBuilder,
          (Course, BaseReferences<_$AppDatabase, $CoursesTable, Course>),
          Course,
          PrefetchHooks Function()
        > {
  $$CoursesTableTableManager(_$AppDatabase db, $CoursesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoursesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoursesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoursesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> availability = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<int> lessonCount = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoursesCompanion(
                id: id,
                title: title,
                subject: subject,
                description: description,
                type: type,
                availability: availability,
                progress: progress,
                imageUrl: imageUrl,
                lessonCount: lessonCount,
                durationMinutes: durationMinutes,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String subject,
                required String description,
                required String type,
                required String availability,
                required double progress,
                required String imageUrl,
                required int lessonCount,
                required int durationMinutes,
                required int updatedAt,
                required String syncStatus,
                Value<int> rowid = const Value.absent(),
              }) => CoursesCompanion.insert(
                id: id,
                title: title,
                subject: subject,
                description: description,
                type: type,
                availability: availability,
                progress: progress,
                imageUrl: imageUrl,
                lessonCount: lessonCount,
                durationMinutes: durationMinutes,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoursesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoursesTable,
      Course,
      $$CoursesTableFilterComposer,
      $$CoursesTableOrderingComposer,
      $$CoursesTableAnnotationComposer,
      $$CoursesTableCreateCompanionBuilder,
      $$CoursesTableUpdateCompanionBuilder,
      (Course, BaseReferences<_$AppDatabase, $CoursesTable, Course>),
      Course,
      PrefetchHooks Function()
    >;
typedef $$ChaptersTableCreateCompanionBuilder =
    ChaptersCompanion Function({
      required String id,
      required String courseId,
      required String title,
      required String contentUrl,
      required String type,
      required String availability,
      required double progress,
      required int updatedAt,
      required String syncStatus,
      Value<int> rowid,
    });
typedef $$ChaptersTableUpdateCompanionBuilder =
    ChaptersCompanion Function({
      Value<String> id,
      Value<String> courseId,
      Value<String> title,
      Value<String> contentUrl,
      Value<String> type,
      Value<String> availability,
      Value<double> progress,
      Value<int> updatedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentUrl => $composableBuilder(
    column: $table.contentUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentUrl => $composableBuilder(
    column: $table.contentUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contentUrl => $composableBuilder(
    column: $table.contentUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => column,
  );

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$ChaptersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChaptersTable,
          Chapter,
          $$ChaptersTableFilterComposer,
          $$ChaptersTableOrderingComposer,
          $$ChaptersTableAnnotationComposer,
          $$ChaptersTableCreateCompanionBuilder,
          $$ChaptersTableUpdateCompanionBuilder,
          (Chapter, BaseReferences<_$AppDatabase, $ChaptersTable, Chapter>),
          Chapter,
          PrefetchHooks Function()
        > {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> courseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> contentUrl = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> availability = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion(
                id: id,
                courseId: courseId,
                title: title,
                contentUrl: contentUrl,
                type: type,
                availability: availability,
                progress: progress,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String courseId,
                required String title,
                required String contentUrl,
                required String type,
                required String availability,
                required double progress,
                required int updatedAt,
                required String syncStatus,
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion.insert(
                id: id,
                courseId: courseId,
                title: title,
                contentUrl: contentUrl,
                type: type,
                availability: availability,
                progress: progress,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChaptersTable,
      Chapter,
      $$ChaptersTableFilterComposer,
      $$ChaptersTableOrderingComposer,
      $$ChaptersTableAnnotationComposer,
      $$ChaptersTableCreateCompanionBuilder,
      $$ChaptersTableUpdateCompanionBuilder,
      (Chapter, BaseReferences<_$AppDatabase, $ChaptersTable, Chapter>),
      Chapter,
      PrefetchHooks Function()
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      required String id,
      required String chapterId,
      required String content,
      required int createdAt,
      required int updatedAt,
      required String syncStatus,
      Value<int> rowid,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<String> id,
      Value<String> chapterId,
      Value<String> content,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
          Note,
          PrefetchHooks Function()
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                chapterId: chapterId,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String chapterId,
                required String content,
                required int createdAt,
                required int updatedAt,
                required String syncStatus,
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                chapterId: chapterId,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
      Note,
      PrefetchHooks Function()
    >;
typedef $$MeshMessagesTableCreateCompanionBuilder =
    MeshMessagesCompanion Function({
      required String id,
      required String authorPseudo,
      required String content,
      required String type,
      required int timestamp,
      Value<String?> imageUrl,
      Value<String?> audioUrl,
      required int hopCount,
      required String reactions,
      required int updatedAt,
      required String syncStatus,
      Value<String?> fileId,
      Value<String?> fileName,
      Value<int?> fileSize,
      Value<String?> fileMimeType,
      Value<String?> replyToId,
      required String status,
      Value<String?> routeInfo,
      Value<int> rowid,
    });
typedef $$MeshMessagesTableUpdateCompanionBuilder =
    MeshMessagesCompanion Function({
      Value<String> id,
      Value<String> authorPseudo,
      Value<String> content,
      Value<String> type,
      Value<int> timestamp,
      Value<String?> imageUrl,
      Value<String?> audioUrl,
      Value<int> hopCount,
      Value<String> reactions,
      Value<int> updatedAt,
      Value<String> syncStatus,
      Value<String?> fileId,
      Value<String?> fileName,
      Value<int?> fileSize,
      Value<String?> fileMimeType,
      Value<String?> replyToId,
      Value<String> status,
      Value<String?> routeInfo,
      Value<int> rowid,
    });

class $$MeshMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MeshMessagesTable> {
  $$MeshMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorPseudo => $composableBuilder(
    column: $table.authorPseudo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hopCount => $composableBuilder(
    column: $table.hopCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reactions => $composableBuilder(
    column: $table.reactions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileMimeType => $composableBuilder(
    column: $table.fileMimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replyToId => $composableBuilder(
    column: $table.replyToId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routeInfo => $composableBuilder(
    column: $table.routeInfo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MeshMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MeshMessagesTable> {
  $$MeshMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorPseudo => $composableBuilder(
    column: $table.authorPseudo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hopCount => $composableBuilder(
    column: $table.hopCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reactions => $composableBuilder(
    column: $table.reactions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileMimeType => $composableBuilder(
    column: $table.fileMimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replyToId => $composableBuilder(
    column: $table.replyToId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routeInfo => $composableBuilder(
    column: $table.routeInfo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MeshMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeshMessagesTable> {
  $$MeshMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authorPseudo => $composableBuilder(
    column: $table.authorPseudo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<int> get hopCount =>
      $composableBuilder(column: $table.hopCount, builder: (column) => column);

  GeneratedColumn<String> get reactions =>
      $composableBuilder(column: $table.reactions, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileId =>
      $composableBuilder(column: $table.fileId, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get fileMimeType => $composableBuilder(
    column: $table.fileMimeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replyToId =>
      $composableBuilder(column: $table.replyToId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get routeInfo =>
      $composableBuilder(column: $table.routeInfo, builder: (column) => column);
}

class $$MeshMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeshMessagesTable,
          MeshMessage,
          $$MeshMessagesTableFilterComposer,
          $$MeshMessagesTableOrderingComposer,
          $$MeshMessagesTableAnnotationComposer,
          $$MeshMessagesTableCreateCompanionBuilder,
          $$MeshMessagesTableUpdateCompanionBuilder,
          (
            MeshMessage,
            BaseReferences<_$AppDatabase, $MeshMessagesTable, MeshMessage>,
          ),
          MeshMessage,
          PrefetchHooks Function()
        > {
  $$MeshMessagesTableTableManager(_$AppDatabase db, $MeshMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeshMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeshMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeshMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> authorPseudo = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int> hopCount = const Value.absent(),
                Value<String> reactions = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> fileId = const Value.absent(),
                Value<String?> fileName = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                Value<String?> fileMimeType = const Value.absent(),
                Value<String?> replyToId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> routeInfo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeshMessagesCompanion(
                id: id,
                authorPseudo: authorPseudo,
                content: content,
                type: type,
                timestamp: timestamp,
                imageUrl: imageUrl,
                audioUrl: audioUrl,
                hopCount: hopCount,
                reactions: reactions,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                fileId: fileId,
                fileName: fileName,
                fileSize: fileSize,
                fileMimeType: fileMimeType,
                replyToId: replyToId,
                status: status,
                routeInfo: routeInfo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String authorPseudo,
                required String content,
                required String type,
                required int timestamp,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                required int hopCount,
                required String reactions,
                required int updatedAt,
                required String syncStatus,
                Value<String?> fileId = const Value.absent(),
                Value<String?> fileName = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                Value<String?> fileMimeType = const Value.absent(),
                Value<String?> replyToId = const Value.absent(),
                required String status,
                Value<String?> routeInfo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeshMessagesCompanion.insert(
                id: id,
                authorPseudo: authorPseudo,
                content: content,
                type: type,
                timestamp: timestamp,
                imageUrl: imageUrl,
                audioUrl: audioUrl,
                hopCount: hopCount,
                reactions: reactions,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                fileId: fileId,
                fileName: fileName,
                fileSize: fileSize,
                fileMimeType: fileMimeType,
                replyToId: replyToId,
                status: status,
                routeInfo: routeInfo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MeshMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeshMessagesTable,
      MeshMessage,
      $$MeshMessagesTableFilterComposer,
      $$MeshMessagesTableOrderingComposer,
      $$MeshMessagesTableAnnotationComposer,
      $$MeshMessagesTableCreateCompanionBuilder,
      $$MeshMessagesTableUpdateCompanionBuilder,
      (
        MeshMessage,
        BaseReferences<_$AppDatabase, $MeshMessagesTable, MeshMessage>,
      ),
      MeshMessage,
      PrefetchHooks Function()
    >;
typedef $$UserProfileTableCreateCompanionBuilder =
    UserProfileCompanion Function({
      required String id,
      required String pseudo,
      required String bacSeries,
      required String cryptoIdentity,
      required String avatarUrl,
      required int isGatewayActive,
      required int meshPeers,
      required String bio,
      Value<int> rowid,
    });
typedef $$UserProfileTableUpdateCompanionBuilder =
    UserProfileCompanion Function({
      Value<String> id,
      Value<String> pseudo,
      Value<String> bacSeries,
      Value<String> cryptoIdentity,
      Value<String> avatarUrl,
      Value<int> isGatewayActive,
      Value<int> meshPeers,
      Value<String> bio,
      Value<int> rowid,
    });

class $$UserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pseudo => $composableBuilder(
    column: $table.pseudo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bacSeries => $composableBuilder(
    column: $table.bacSeries,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cryptoIdentity => $composableBuilder(
    column: $table.cryptoIdentity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isGatewayActive => $composableBuilder(
    column: $table.isGatewayActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get meshPeers => $composableBuilder(
    column: $table.meshPeers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pseudo => $composableBuilder(
    column: $table.pseudo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bacSeries => $composableBuilder(
    column: $table.bacSeries,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cryptoIdentity => $composableBuilder(
    column: $table.cryptoIdentity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isGatewayActive => $composableBuilder(
    column: $table.isGatewayActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get meshPeers => $composableBuilder(
    column: $table.meshPeers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pseudo =>
      $composableBuilder(column: $table.pseudo, builder: (column) => column);

  GeneratedColumn<String> get bacSeries =>
      $composableBuilder(column: $table.bacSeries, builder: (column) => column);

  GeneratedColumn<String> get cryptoIdentity => $composableBuilder(
    column: $table.cryptoIdentity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<int> get isGatewayActive => $composableBuilder(
    column: $table.isGatewayActive,
    builder: (column) => column,
  );

  GeneratedColumn<int> get meshPeers =>
      $composableBuilder(column: $table.meshPeers, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);
}

class $$UserProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTable,
          UserProfileData,
          $$UserProfileTableFilterComposer,
          $$UserProfileTableOrderingComposer,
          $$UserProfileTableAnnotationComposer,
          $$UserProfileTableCreateCompanionBuilder,
          $$UserProfileTableUpdateCompanionBuilder,
          (
            UserProfileData,
            BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>,
          ),
          UserProfileData,
          PrefetchHooks Function()
        > {
  $$UserProfileTableTableManager(_$AppDatabase db, $UserProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pseudo = const Value.absent(),
                Value<String> bacSeries = const Value.absent(),
                Value<String> cryptoIdentity = const Value.absent(),
                Value<String> avatarUrl = const Value.absent(),
                Value<int> isGatewayActive = const Value.absent(),
                Value<int> meshPeers = const Value.absent(),
                Value<String> bio = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfileCompanion(
                id: id,
                pseudo: pseudo,
                bacSeries: bacSeries,
                cryptoIdentity: cryptoIdentity,
                avatarUrl: avatarUrl,
                isGatewayActive: isGatewayActive,
                meshPeers: meshPeers,
                bio: bio,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String pseudo,
                required String bacSeries,
                required String cryptoIdentity,
                required String avatarUrl,
                required int isGatewayActive,
                required int meshPeers,
                required String bio,
                Value<int> rowid = const Value.absent(),
              }) => UserProfileCompanion.insert(
                id: id,
                pseudo: pseudo,
                bacSeries: bacSeries,
                cryptoIdentity: cryptoIdentity,
                avatarUrl: avatarUrl,
                isGatewayActive: isGatewayActive,
                meshPeers: meshPeers,
                bio: bio,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTable,
      UserProfileData,
      $$UserProfileTableFilterComposer,
      $$UserProfileTableOrderingComposer,
      $$UserProfileTableAnnotationComposer,
      $$UserProfileTableCreateCompanionBuilder,
      $$UserProfileTableUpdateCompanionBuilder,
      (
        UserProfileData,
        BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>,
      ),
      UserProfileData,
      PrefetchHooks Function()
    >;
typedef $$SeenMessageIdsTableCreateCompanionBuilder =
    SeenMessageIdsCompanion Function({
      required String messageId,
      Value<int> rowid,
    });
typedef $$SeenMessageIdsTableUpdateCompanionBuilder =
    SeenMessageIdsCompanion Function({
      Value<String> messageId,
      Value<int> rowid,
    });

class $$SeenMessageIdsTableFilterComposer
    extends Composer<_$AppDatabase, $SeenMessageIdsTable> {
  $$SeenMessageIdsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SeenMessageIdsTableOrderingComposer
    extends Composer<_$AppDatabase, $SeenMessageIdsTable> {
  $$SeenMessageIdsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SeenMessageIdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeenMessageIdsTable> {
  $$SeenMessageIdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);
}

class $$SeenMessageIdsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeenMessageIdsTable,
          SeenMessageId,
          $$SeenMessageIdsTableFilterComposer,
          $$SeenMessageIdsTableOrderingComposer,
          $$SeenMessageIdsTableAnnotationComposer,
          $$SeenMessageIdsTableCreateCompanionBuilder,
          $$SeenMessageIdsTableUpdateCompanionBuilder,
          (
            SeenMessageId,
            BaseReferences<_$AppDatabase, $SeenMessageIdsTable, SeenMessageId>,
          ),
          SeenMessageId,
          PrefetchHooks Function()
        > {
  $$SeenMessageIdsTableTableManager(
    _$AppDatabase db,
    $SeenMessageIdsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeenMessageIdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeenMessageIdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeenMessageIdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> messageId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SeenMessageIdsCompanion(messageId: messageId, rowid: rowid),
          createCompanionCallback:
              ({
                required String messageId,
                Value<int> rowid = const Value.absent(),
              }) => SeenMessageIdsCompanion.insert(
                messageId: messageId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SeenMessageIdsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeenMessageIdsTable,
      SeenMessageId,
      $$SeenMessageIdsTableFilterComposer,
      $$SeenMessageIdsTableOrderingComposer,
      $$SeenMessageIdsTableAnnotationComposer,
      $$SeenMessageIdsTableCreateCompanionBuilder,
      $$SeenMessageIdsTableUpdateCompanionBuilder,
      (
        SeenMessageId,
        BaseReferences<_$AppDatabase, $SeenMessageIdsTable, SeenMessageId>,
      ),
      SeenMessageId,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$AuthCredentialsTableTableCreateCompanionBuilder =
    AuthCredentialsTableCompanion Function({
      required String key,
      required String accessToken,
      required String refreshToken,
      required int expiresAt,
      Value<int> rowid,
    });
typedef $$AuthCredentialsTableTableUpdateCompanionBuilder =
    AuthCredentialsTableCompanion Function({
      Value<String> key,
      Value<String> accessToken,
      Value<String> refreshToken,
      Value<int> expiresAt,
      Value<int> rowid,
    });

class $$AuthCredentialsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AuthCredentialsTableTable> {
  $$AuthCredentialsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuthCredentialsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthCredentialsTableTable> {
  $$AuthCredentialsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuthCredentialsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthCredentialsTableTable> {
  $$AuthCredentialsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$AuthCredentialsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuthCredentialsTableTable,
          AuthCredentialsTableData,
          $$AuthCredentialsTableTableFilterComposer,
          $$AuthCredentialsTableTableOrderingComposer,
          $$AuthCredentialsTableTableAnnotationComposer,
          $$AuthCredentialsTableTableCreateCompanionBuilder,
          $$AuthCredentialsTableTableUpdateCompanionBuilder,
          (
            AuthCredentialsTableData,
            BaseReferences<
              _$AppDatabase,
              $AuthCredentialsTableTable,
              AuthCredentialsTableData
            >,
          ),
          AuthCredentialsTableData,
          PrefetchHooks Function()
        > {
  $$AuthCredentialsTableTableTableManager(
    _$AppDatabase db,
    $AuthCredentialsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthCredentialsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthCredentialsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AuthCredentialsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> accessToken = const Value.absent(),
                Value<String> refreshToken = const Value.absent(),
                Value<int> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthCredentialsTableCompanion(
                key: key,
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String accessToken,
                required String refreshToken,
                required int expiresAt,
                Value<int> rowid = const Value.absent(),
              }) => AuthCredentialsTableCompanion.insert(
                key: key,
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuthCredentialsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuthCredentialsTableTable,
      AuthCredentialsTableData,
      $$AuthCredentialsTableTableFilterComposer,
      $$AuthCredentialsTableTableOrderingComposer,
      $$AuthCredentialsTableTableAnnotationComposer,
      $$AuthCredentialsTableTableCreateCompanionBuilder,
      $$AuthCredentialsTableTableUpdateCompanionBuilder,
      (
        AuthCredentialsTableData,
        BaseReferences<
          _$AppDatabase,
          $AuthCredentialsTableTable,
          AuthCredentialsTableData
        >,
      ),
      AuthCredentialsTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncLogTableCreateCompanionBuilder =
    SyncLogCompanion Function({
      required String entityType,
      required String entityId,
      required String action,
      required int occurredAt,
      Value<int?> syncedAt,
      Value<int> rowid,
    });
typedef $$SyncLogTableUpdateCompanionBuilder =
    SyncLogCompanion Function({
      Value<String> entityType,
      Value<String> entityId,
      Value<String> action,
      Value<int> occurredAt,
      Value<int?> syncedAt,
      Value<int> rowid,
    });

class $$SyncLogTableFilterComposer
    extends Composer<_$AppDatabase, $SyncLogTable> {
  $$SyncLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncLogTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncLogTable> {
  $$SyncLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncLogTable> {
  $$SyncLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<int> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SyncLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncLogTable,
          SyncLogData,
          $$SyncLogTableFilterComposer,
          $$SyncLogTableOrderingComposer,
          $$SyncLogTableAnnotationComposer,
          $$SyncLogTableCreateCompanionBuilder,
          $$SyncLogTableUpdateCompanionBuilder,
          (
            SyncLogData,
            BaseReferences<_$AppDatabase, $SyncLogTable, SyncLogData>,
          ),
          SyncLogData,
          PrefetchHooks Function()
        > {
  $$SyncLogTableTableManager(_$AppDatabase db, $SyncLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<int> occurredAt = const Value.absent(),
                Value<int?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncLogCompanion(
                entityType: entityType,
                entityId: entityId,
                action: action,
                occurredAt: occurredAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityType,
                required String entityId,
                required String action,
                required int occurredAt,
                Value<int?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncLogCompanion.insert(
                entityType: entityType,
                entityId: entityId,
                action: action,
                occurredAt: occurredAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncLogTable,
      SyncLogData,
      $$SyncLogTableFilterComposer,
      $$SyncLogTableOrderingComposer,
      $$SyncLogTableAnnotationComposer,
      $$SyncLogTableCreateCompanionBuilder,
      $$SyncLogTableUpdateCompanionBuilder,
      (SyncLogData, BaseReferences<_$AppDatabase, $SyncLogTable, SyncLogData>),
      SyncLogData,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      required String key,
      required int value,
      Value<int> rowid,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<String> key,
      Value<int> value,
      Value<int> rowid,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateData,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateData,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
          ),
          SyncStateData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required int value,
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateData,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateData,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
      ),
      SyncStateData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CoursesTableTableManager get courses =>
      $$CoursesTableTableManager(_db, _db.courses);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$MeshMessagesTableTableManager get meshMessages =>
      $$MeshMessagesTableTableManager(_db, _db.meshMessages);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
  $$SeenMessageIdsTableTableManager get seenMessageIds =>
      $$SeenMessageIdsTableTableManager(_db, _db.seenMessageIds);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$AuthCredentialsTableTableTableManager get authCredentialsTable =>
      $$AuthCredentialsTableTableTableManager(_db, _db.authCredentialsTable);
  $$SyncLogTableTableManager get syncLog =>
      $$SyncLogTableTableManager(_db, _db.syncLog);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
}
