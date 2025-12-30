/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class WebhookEvent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  WebhookEvent._({
    this.id,
    required this.eventType,
    required this.payload,
    this.signature,
    required this.processed,
    required this.createdAt,
  });

  factory WebhookEvent({
    int? id,
    required String eventType,
    required String payload,
    String? signature,
    required bool processed,
    required DateTime createdAt,
  }) = _WebhookEventImpl;

  factory WebhookEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return WebhookEvent(
      id: jsonSerialization['id'] as int?,
      eventType: jsonSerialization['eventType'] as String,
      payload: jsonSerialization['payload'] as String,
      signature: jsonSerialization['signature'] as String?,
      processed: jsonSerialization['processed'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = WebhookEventTable();

  static const db = WebhookEventRepository._();

  @override
  int? id;

  String eventType;

  String payload;

  String? signature;

  bool processed;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [WebhookEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WebhookEvent copyWith({
    int? id,
    String? eventType,
    String? payload,
    String? signature,
    bool? processed,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WebhookEvent',
      if (id != null) 'id': id,
      'eventType': eventType,
      'payload': payload,
      if (signature != null) 'signature': signature,
      'processed': processed,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WebhookEvent',
      if (id != null) 'id': id,
      'eventType': eventType,
      'payload': payload,
      if (signature != null) 'signature': signature,
      'processed': processed,
      'createdAt': createdAt.toJson(),
    };
  }

  static WebhookEventInclude include() {
    return WebhookEventInclude._();
  }

  static WebhookEventIncludeList includeList({
    _i1.WhereExpressionBuilder<WebhookEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WebhookEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WebhookEventTable>? orderByList,
    WebhookEventInclude? include,
  }) {
    return WebhookEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WebhookEvent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WebhookEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WebhookEventImpl extends WebhookEvent {
  _WebhookEventImpl({
    int? id,
    required String eventType,
    required String payload,
    String? signature,
    required bool processed,
    required DateTime createdAt,
  }) : super._(
         id: id,
         eventType: eventType,
         payload: payload,
         signature: signature,
         processed: processed,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [WebhookEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WebhookEvent copyWith({
    Object? id = _Undefined,
    String? eventType,
    String? payload,
    Object? signature = _Undefined,
    bool? processed,
    DateTime? createdAt,
  }) {
    return WebhookEvent(
      id: id is int? ? id : this.id,
      eventType: eventType ?? this.eventType,
      payload: payload ?? this.payload,
      signature: signature is String? ? signature : this.signature,
      processed: processed ?? this.processed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class WebhookEventUpdateTable extends _i1.UpdateTable<WebhookEventTable> {
  WebhookEventUpdateTable(super.table);

  _i1.ColumnValue<String, String> eventType(String value) => _i1.ColumnValue(
    table.eventType,
    value,
  );

  _i1.ColumnValue<String, String> payload(String value) => _i1.ColumnValue(
    table.payload,
    value,
  );

  _i1.ColumnValue<String, String> signature(String? value) => _i1.ColumnValue(
    table.signature,
    value,
  );

  _i1.ColumnValue<bool, bool> processed(bool value) => _i1.ColumnValue(
    table.processed,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class WebhookEventTable extends _i1.Table<int?> {
  WebhookEventTable({super.tableRelation})
    : super(tableName: 'webhook_events') {
    updateTable = WebhookEventUpdateTable(this);
    eventType = _i1.ColumnString(
      'eventType',
      this,
    );
    payload = _i1.ColumnString(
      'payload',
      this,
    );
    signature = _i1.ColumnString(
      'signature',
      this,
    );
    processed = _i1.ColumnBool(
      'processed',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final WebhookEventUpdateTable updateTable;

  late final _i1.ColumnString eventType;

  late final _i1.ColumnString payload;

  late final _i1.ColumnString signature;

  late final _i1.ColumnBool processed;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    eventType,
    payload,
    signature,
    processed,
    createdAt,
  ];
}

class WebhookEventInclude extends _i1.IncludeObject {
  WebhookEventInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => WebhookEvent.t;
}

class WebhookEventIncludeList extends _i1.IncludeList {
  WebhookEventIncludeList._({
    _i1.WhereExpressionBuilder<WebhookEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WebhookEvent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => WebhookEvent.t;
}

class WebhookEventRepository {
  const WebhookEventRepository._();

  /// Returns a list of [WebhookEvent]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<WebhookEvent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WebhookEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WebhookEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WebhookEventTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<WebhookEvent>(
      where: where?.call(WebhookEvent.t),
      orderBy: orderBy?.call(WebhookEvent.t),
      orderByList: orderByList?.call(WebhookEvent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [WebhookEvent] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<WebhookEvent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WebhookEventTable>? where,
    int? offset,
    _i1.OrderByBuilder<WebhookEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WebhookEventTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<WebhookEvent>(
      where: where?.call(WebhookEvent.t),
      orderBy: orderBy?.call(WebhookEvent.t),
      orderByList: orderByList?.call(WebhookEvent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [WebhookEvent] by its [id] or null if no such row exists.
  Future<WebhookEvent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<WebhookEvent>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [WebhookEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [WebhookEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<WebhookEvent>> insert(
    _i1.Session session,
    List<WebhookEvent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<WebhookEvent>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [WebhookEvent] and returns the inserted row.
  ///
  /// The returned [WebhookEvent] will have its `id` field set.
  Future<WebhookEvent> insertRow(
    _i1.Session session,
    WebhookEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WebhookEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WebhookEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WebhookEvent>> update(
    _i1.Session session,
    List<WebhookEvent> rows, {
    _i1.ColumnSelections<WebhookEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WebhookEvent>(
      rows,
      columns: columns?.call(WebhookEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WebhookEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WebhookEvent> updateRow(
    _i1.Session session,
    WebhookEvent row, {
    _i1.ColumnSelections<WebhookEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WebhookEvent>(
      row,
      columns: columns?.call(WebhookEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WebhookEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WebhookEvent?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<WebhookEventUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<WebhookEvent>(
      id,
      columnValues: columnValues(WebhookEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WebhookEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<WebhookEvent>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<WebhookEventUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<WebhookEventTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WebhookEventTable>? orderBy,
    _i1.OrderByListBuilder<WebhookEventTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<WebhookEvent>(
      columnValues: columnValues(WebhookEvent.t.updateTable),
      where: where(WebhookEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WebhookEvent.t),
      orderByList: orderByList?.call(WebhookEvent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [WebhookEvent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WebhookEvent>> delete(
    _i1.Session session,
    List<WebhookEvent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WebhookEvent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WebhookEvent].
  Future<WebhookEvent> deleteRow(
    _i1.Session session,
    WebhookEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WebhookEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WebhookEvent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<WebhookEventTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WebhookEvent>(
      where: where(WebhookEvent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WebhookEventTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WebhookEvent>(
      where: where?.call(WebhookEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
