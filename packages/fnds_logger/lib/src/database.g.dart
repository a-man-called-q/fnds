// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LogsTable extends Logs with TableInfo<$LogsTable, Log> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stacktraceMeta = const VerificationMeta(
    'stacktrace',
  );
  @override
  late final GeneratedColumn<String> stacktrace = GeneratedColumn<String>(
    'stacktrace',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    level,
    message,
    stacktrace,
    tag,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Log> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('stacktrace')) {
      context.handle(
        _stacktraceMeta,
        stacktrace.isAcceptableOrUnknown(data['stacktrace']!, _stacktraceMeta),
      );
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Log map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Log(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      level:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}level'],
          )!,
      message:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}message'],
          )!,
      stacktrace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stacktrace'],
      ),
      tag:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}tag'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
    );
  }

  @override
  $LogsTable createAlias(String alias) {
    return $LogsTable(attachedDatabase, alias);
  }
}

class Log extends DataClass implements Insertable<Log> {
  final int id;
  final String level;
  final String message;
  final String? stacktrace;
  final String tag;
  final DateTime timestamp;
  const Log({
    required this.id,
    required this.level,
    required this.message,
    this.stacktrace,
    required this.tag,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<String>(level);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || stacktrace != null) {
      map['stacktrace'] = Variable<String>(stacktrace);
    }
    map['tag'] = Variable<String>(tag);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  LogsCompanion toCompanion(bool nullToAbsent) {
    return LogsCompanion(
      id: Value(id),
      level: Value(level),
      message: Value(message),
      stacktrace:
          stacktrace == null && nullToAbsent
              ? const Value.absent()
              : Value(stacktrace),
      tag: Value(tag),
      timestamp: Value(timestamp),
    );
  }

  factory Log.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Log(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      message: serializer.fromJson<String>(json['message']),
      stacktrace: serializer.fromJson<String?>(json['stacktrace']),
      tag: serializer.fromJson<String>(json['tag']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<String>(level),
      'message': serializer.toJson<String>(message),
      'stacktrace': serializer.toJson<String?>(stacktrace),
      'tag': serializer.toJson<String>(tag),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  Log copyWith({
    int? id,
    String? level,
    String? message,
    Value<String?> stacktrace = const Value.absent(),
    String? tag,
    DateTime? timestamp,
  }) => Log(
    id: id ?? this.id,
    level: level ?? this.level,
    message: message ?? this.message,
    stacktrace: stacktrace.present ? stacktrace.value : this.stacktrace,
    tag: tag ?? this.tag,
    timestamp: timestamp ?? this.timestamp,
  );
  Log copyWithCompanion(LogsCompanion data) {
    return Log(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      message: data.message.present ? data.message.value : this.message,
      stacktrace:
          data.stacktrace.present ? data.stacktrace.value : this.stacktrace,
      tag: data.tag.present ? data.tag.value : this.tag,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Log(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('stacktrace: $stacktrace, ')
          ..write('tag: $tag, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, level, message, stacktrace, tag, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Log &&
          other.id == this.id &&
          other.level == this.level &&
          other.message == this.message &&
          other.stacktrace == this.stacktrace &&
          other.tag == this.tag &&
          other.timestamp == this.timestamp);
}

class LogsCompanion extends UpdateCompanion<Log> {
  final Value<int> id;
  final Value<String> level;
  final Value<String> message;
  final Value<String?> stacktrace;
  final Value<String> tag;
  final Value<DateTime> timestamp;
  const LogsCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.message = const Value.absent(),
    this.stacktrace = const Value.absent(),
    this.tag = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  LogsCompanion.insert({
    this.id = const Value.absent(),
    required String level,
    required String message,
    this.stacktrace = const Value.absent(),
    this.tag = const Value.absent(),
    this.timestamp = const Value.absent(),
  }) : level = Value(level),
       message = Value(message);
  static Insertable<Log> custom({
    Expression<int>? id,
    Expression<String>? level,
    Expression<String>? message,
    Expression<String>? stacktrace,
    Expression<String>? tag,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (message != null) 'message': message,
      if (stacktrace != null) 'stacktrace': stacktrace,
      if (tag != null) 'tag': tag,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  LogsCompanion copyWith({
    Value<int>? id,
    Value<String>? level,
    Value<String>? message,
    Value<String?>? stacktrace,
    Value<String>? tag,
    Value<DateTime>? timestamp,
  }) {
    return LogsCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      message: message ?? this.message,
      stacktrace: stacktrace ?? this.stacktrace,
      tag: tag ?? this.tag,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (stacktrace.present) {
      map['stacktrace'] = Variable<String>(stacktrace.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogsCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('stacktrace: $stacktrace, ')
          ..write('tag: $tag, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$LoggerDB extends GeneratedDatabase {
  _$LoggerDB(QueryExecutor e) : super(e);
  $LoggerDBManager get managers => $LoggerDBManager(this);
  late final $LogsTable logs = $LogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [logs];
}

typedef $$LogsTableCreateCompanionBuilder =
    LogsCompanion Function({
      Value<int> id,
      required String level,
      required String message,
      Value<String?> stacktrace,
      Value<String> tag,
      Value<DateTime> timestamp,
    });
typedef $$LogsTableUpdateCompanionBuilder =
    LogsCompanion Function({
      Value<int> id,
      Value<String> level,
      Value<String> message,
      Value<String?> stacktrace,
      Value<String> tag,
      Value<DateTime> timestamp,
    });

class $$LogsTableFilterComposer extends Composer<_$LoggerDB, $LogsTable> {
  $$LogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stacktrace => $composableBuilder(
    column: $table.stacktrace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LogsTableOrderingComposer extends Composer<_$LoggerDB, $LogsTable> {
  $$LogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stacktrace => $composableBuilder(
    column: $table.stacktrace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LogsTableAnnotationComposer extends Composer<_$LoggerDB, $LogsTable> {
  $$LogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get stacktrace => $composableBuilder(
    column: $table.stacktrace,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$LogsTableTableManager
    extends
        RootTableManager<
          _$LoggerDB,
          $LogsTable,
          Log,
          $$LogsTableFilterComposer,
          $$LogsTableOrderingComposer,
          $$LogsTableAnnotationComposer,
          $$LogsTableCreateCompanionBuilder,
          $$LogsTableUpdateCompanionBuilder,
          (Log, BaseReferences<_$LoggerDB, $LogsTable, Log>),
          Log,
          PrefetchHooks Function()
        > {
  $$LogsTableTableManager(_$LoggerDB db, $LogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$LogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$LogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String?> stacktrace = const Value.absent(),
                Value<String> tag = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => LogsCompanion(
                id: id,
                level: level,
                message: message,
                stacktrace: stacktrace,
                tag: tag,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String level,
                required String message,
                Value<String?> stacktrace = const Value.absent(),
                Value<String> tag = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => LogsCompanion.insert(
                id: id,
                level: level,
                message: message,
                stacktrace: stacktrace,
                tag: tag,
                timestamp: timestamp,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LogsTableProcessedTableManager =
    ProcessedTableManager<
      _$LoggerDB,
      $LogsTable,
      Log,
      $$LogsTableFilterComposer,
      $$LogsTableOrderingComposer,
      $$LogsTableAnnotationComposer,
      $$LogsTableCreateCompanionBuilder,
      $$LogsTableUpdateCompanionBuilder,
      (Log, BaseReferences<_$LoggerDB, $LogsTable, Log>),
      Log,
      PrefetchHooks Function()
    >;

class $LoggerDBManager {
  final _$LoggerDB _db;
  $LoggerDBManager(this._db);
  $$LogsTableTableManager get logs => $$LogsTableTableManager(_db, _db.logs);
}
