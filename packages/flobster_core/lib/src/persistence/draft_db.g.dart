// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_db.dart';

// ignore_for_file: type=lint
class $FormDraftsTable extends FormDrafts
    with TableInfo<$FormDraftsTable, FormDraftData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formIdMeta = const VerificationMeta('formId');
  @override
  late final GeneratedColumn<String> formId = GeneratedColumn<String>(
    'form_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _draftDataMeta = const VerificationMeta(
    'draftData',
  );
  @override
  late final GeneratedColumn<String> draftData = GeneratedColumn<String>(
    'draft_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, formId, draftData, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'form_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<FormDraftData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('form_id')) {
      context.handle(
        _formIdMeta,
        formId.isAcceptableOrUnknown(data['form_id']!, _formIdMeta),
      );
    } else if (isInserting) {
      context.missing(_formIdMeta);
    }
    if (data.containsKey('draft_data')) {
      context.handle(
        _draftDataMeta,
        draftData.isAcceptableOrUnknown(data['draft_data']!, _draftDataMeta),
      );
    } else if (isInserting) {
      context.missing(_draftDataMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, formId};
  @override
  FormDraftData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormDraftData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      formId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form_id'],
      )!,
      draftData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}draft_data'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FormDraftsTable createAlias(String alias) {
    return $FormDraftsTable(attachedDatabase, alias);
  }
}

class FormDraftData extends DataClass implements Insertable<FormDraftData> {
  /// Unique identifier of the record or draft
  final String id;

  /// Form identifier mapping to a specific view
  final String formId;

  /// Serialized dynamic form content stored as a JSON string
  final String draftData;

  /// Timestamp when the draft was last updated
  final DateTime updatedAt;
  const FormDraftData({
    required this.id,
    required this.formId,
    required this.draftData,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['form_id'] = Variable<String>(formId);
    map['draft_data'] = Variable<String>(draftData);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FormDraftsCompanion toCompanion(bool nullToAbsent) {
    return FormDraftsCompanion(
      id: Value(id),
      formId: Value(formId),
      draftData: Value(draftData),
      updatedAt: Value(updatedAt),
    );
  }

  factory FormDraftData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormDraftData(
      id: serializer.fromJson<String>(json['id']),
      formId: serializer.fromJson<String>(json['formId']),
      draftData: serializer.fromJson<String>(json['draftData']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'formId': serializer.toJson<String>(formId),
      'draftData': serializer.toJson<String>(draftData),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FormDraftData copyWith({
    String? id,
    String? formId,
    String? draftData,
    DateTime? updatedAt,
  }) => FormDraftData(
    id: id ?? this.id,
    formId: formId ?? this.formId,
    draftData: draftData ?? this.draftData,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FormDraftData copyWithCompanion(FormDraftsCompanion data) {
    return FormDraftData(
      id: data.id.present ? data.id.value : this.id,
      formId: data.formId.present ? data.formId.value : this.formId,
      draftData: data.draftData.present ? data.draftData.value : this.draftData,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormDraftData(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('draftData: $draftData, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, formId, draftData, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormDraftData &&
          other.id == this.id &&
          other.formId == this.formId &&
          other.draftData == this.draftData &&
          other.updatedAt == this.updatedAt);
}

class FormDraftsCompanion extends UpdateCompanion<FormDraftData> {
  final Value<String> id;
  final Value<String> formId;
  final Value<String> draftData;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FormDraftsCompanion({
    this.id = const Value.absent(),
    this.formId = const Value.absent(),
    this.draftData = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FormDraftsCompanion.insert({
    required String id,
    required String formId,
    required String draftData,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       formId = Value(formId),
       draftData = Value(draftData),
       updatedAt = Value(updatedAt);
  static Insertable<FormDraftData> custom({
    Expression<String>? id,
    Expression<String>? formId,
    Expression<String>? draftData,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (formId != null) 'form_id': formId,
      if (draftData != null) 'draft_data': draftData,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FormDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? formId,
    Value<String>? draftData,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FormDraftsCompanion(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      draftData: draftData ?? this.draftData,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (formId.present) {
      map['form_id'] = Variable<String>(formId.value);
    }
    if (draftData.present) {
      map['draft_data'] = Variable<String>(draftData.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormDraftsCompanion(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('draftData: $draftData, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$FormDraftDatabase extends GeneratedDatabase {
  _$FormDraftDatabase(QueryExecutor e) : super(e);
  $FormDraftDatabaseManager get managers => $FormDraftDatabaseManager(this);
  late final $FormDraftsTable formDrafts = $FormDraftsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [formDrafts];
}

typedef $$FormDraftsTableCreateCompanionBuilder =
    FormDraftsCompanion Function({
      required String id,
      required String formId,
      required String draftData,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FormDraftsTableUpdateCompanionBuilder =
    FormDraftsCompanion Function({
      Value<String> id,
      Value<String> formId,
      Value<String> draftData,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$FormDraftsTableFilterComposer
    extends Composer<_$FormDraftDatabase, $FormDraftsTable> {
  $$FormDraftsTableFilterComposer({
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

  ColumnFilters<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get draftData => $composableBuilder(
    column: $table.draftData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FormDraftsTableOrderingComposer
    extends Composer<_$FormDraftDatabase, $FormDraftsTable> {
  $$FormDraftsTableOrderingComposer({
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

  ColumnOrderings<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get draftData => $composableBuilder(
    column: $table.draftData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FormDraftsTableAnnotationComposer
    extends Composer<_$FormDraftDatabase, $FormDraftsTable> {
  $$FormDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get formId =>
      $composableBuilder(column: $table.formId, builder: (column) => column);

  GeneratedColumn<String> get draftData =>
      $composableBuilder(column: $table.draftData, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FormDraftsTableTableManager
    extends
        RootTableManager<
          _$FormDraftDatabase,
          $FormDraftsTable,
          FormDraftData,
          $$FormDraftsTableFilterComposer,
          $$FormDraftsTableOrderingComposer,
          $$FormDraftsTableAnnotationComposer,
          $$FormDraftsTableCreateCompanionBuilder,
          $$FormDraftsTableUpdateCompanionBuilder,
          (
            FormDraftData,
            BaseReferences<
              _$FormDraftDatabase,
              $FormDraftsTable,
              FormDraftData
            >,
          ),
          FormDraftData,
          PrefetchHooks Function()
        > {
  $$FormDraftsTableTableManager(_$FormDraftDatabase db, $FormDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FormDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FormDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> formId = const Value.absent(),
                Value<String> draftData = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FormDraftsCompanion(
                id: id,
                formId: formId,
                draftData: draftData,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String formId,
                required String draftData,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FormDraftsCompanion.insert(
                id: id,
                formId: formId,
                draftData: draftData,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FormDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$FormDraftDatabase,
      $FormDraftsTable,
      FormDraftData,
      $$FormDraftsTableFilterComposer,
      $$FormDraftsTableOrderingComposer,
      $$FormDraftsTableAnnotationComposer,
      $$FormDraftsTableCreateCompanionBuilder,
      $$FormDraftsTableUpdateCompanionBuilder,
      (
        FormDraftData,
        BaseReferences<_$FormDraftDatabase, $FormDraftsTable, FormDraftData>,
      ),
      FormDraftData,
      PrefetchHooks Function()
    >;

class $FormDraftDatabaseManager {
  final _$FormDraftDatabase _db;
  $FormDraftDatabaseManager(this._db);
  $$FormDraftsTableTableManager get formDrafts =>
      $$FormDraftsTableTableManager(_db, _db.formDrafts);
}
