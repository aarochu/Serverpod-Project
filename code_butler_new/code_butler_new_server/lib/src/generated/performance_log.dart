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

abstract class PerformanceLog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PerformanceLog._({
    this.id,
    required this.agentType,
    this.filePath,
    required this.executionTimeMs,
    this.memoryUsageMB,
    this.queryCount,
    required this.createdAt,
  });

  factory PerformanceLog({
    int? id,
    required String agentType,
    String? filePath,
    required int executionTimeMs,
    double? memoryUsageMB,
    int? queryCount,
    required DateTime createdAt,
  }) = _PerformanceLogImpl;

  factory PerformanceLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return PerformanceLog(
      id: jsonSerialization['id'] as int?,
      agentType: jsonSerialization['agentType'] as String,
      filePath: jsonSerialization['filePath'] as String?,
      executionTimeMs: jsonSerialization['executionTimeMs'] as int,
      memoryUsageMB: (jsonSerialization['memoryUsageMB'] as num?)?.toDouble(),
      queryCount: jsonSerialization['queryCount'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = PerformanceLogTable();

  static const db = PerformanceLogRepository._();

  @override
  int? id;

  String agentType;

  String? filePath;

  int executionTimeMs;

  double? memoryUsageMB;

  int? queryCount;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PerformanceLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PerformanceLog copyWith({
    int? id,
    String? agentType,
    String? filePath,
    int? executionTimeMs,
    double? memoryUsageMB,
    int? queryCount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PerformanceLog',
      if (id != null) 'id': id,
      'agentType': agentType,
      if (filePath != null) 'filePath': filePath,
      'executionTimeMs': executionTimeMs,
      if (memoryUsageMB != null) 'memoryUsageMB': memoryUsageMB,
      if (queryCount != null) 'queryCount': queryCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PerformanceLog',
      if (id != null) 'id': id,
      'agentType': agentType,
      if (filePath != null) 'filePath': filePath,
      'executionTimeMs': executionTimeMs,
      if (memoryUsageMB != null) 'memoryUsageMB': memoryUsageMB,
      if (queryCount != null) 'queryCount': queryCount,
      'createdAt': createdAt.toJson(),
    };
  }

  static PerformanceLogInclude include() {
    return PerformanceLogInclude._();
  }

  static PerformanceLogIncludeList includeList({
    _i1.WhereExpressionBuilder<PerformanceLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PerformanceLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PerformanceLogTable>? orderByList,
    PerformanceLogInclude? include,
  }) {
    return PerformanceLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PerformanceLog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PerformanceLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PerformanceLogImpl extends PerformanceLog {
  _PerformanceLogImpl({
    int? id,
    required String agentType,
    String? filePath,
    required int executionTimeMs,
    double? memoryUsageMB,
    int? queryCount,
    required DateTime createdAt,
  }) : super._(
         id: id,
         agentType: agentType,
         filePath: filePath,
         executionTimeMs: executionTimeMs,
         memoryUsageMB: memoryUsageMB,
         queryCount: queryCount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PerformanceLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PerformanceLog copyWith({
    Object? id = _Undefined,
    String? agentType,
    Object? filePath = _Undefined,
    int? executionTimeMs,
    Object? memoryUsageMB = _Undefined,
    Object? queryCount = _Undefined,
    DateTime? createdAt,
  }) {
    return PerformanceLog(
      id: id is int? ? id : this.id,
      agentType: agentType ?? this.agentType,
      filePath: filePath is String? ? filePath : this.filePath,
      executionTimeMs: executionTimeMs ?? this.executionTimeMs,
      memoryUsageMB: memoryUsageMB is double?
          ? memoryUsageMB
          : this.memoryUsageMB,
      queryCount: queryCount is int? ? queryCount : this.queryCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PerformanceLogUpdateTable extends _i1.UpdateTable<PerformanceLogTable> {
  PerformanceLogUpdateTable(super.table);

  _i1.ColumnValue<String, String> agentType(String value) => _i1.ColumnValue(
    table.agentType,
    value,
  );

  _i1.ColumnValue<String, String> filePath(String? value) => _i1.ColumnValue(
    table.filePath,
    value,
  );

  _i1.ColumnValue<int, int> executionTimeMs(int value) => _i1.ColumnValue(
    table.executionTimeMs,
    value,
  );

  _i1.ColumnValue<double, double> memoryUsageMB(double? value) =>
      _i1.ColumnValue(
        table.memoryUsageMB,
        value,
      );

  _i1.ColumnValue<int, int> queryCount(int? value) => _i1.ColumnValue(
    table.queryCount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class PerformanceLogTable extends _i1.Table<int?> {
  PerformanceLogTable({super.tableRelation})
    : super(tableName: 'performance_logs') {
    updateTable = PerformanceLogUpdateTable(this);
    agentType = _i1.ColumnString(
      'agentType',
      this,
    );
    filePath = _i1.ColumnString(
      'filePath',
      this,
    );
    executionTimeMs = _i1.ColumnInt(
      'executionTimeMs',
      this,
    );
    memoryUsageMB = _i1.ColumnDouble(
      'memoryUsageMB',
      this,
    );
    queryCount = _i1.ColumnInt(
      'queryCount',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final PerformanceLogUpdateTable updateTable;

  late final _i1.ColumnString agentType;

  late final _i1.ColumnString filePath;

  late final _i1.ColumnInt executionTimeMs;

  late final _i1.ColumnDouble memoryUsageMB;

  late final _i1.ColumnInt queryCount;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    agentType,
    filePath,
    executionTimeMs,
    memoryUsageMB,
    queryCount,
    createdAt,
  ];
}

class PerformanceLogInclude extends _i1.IncludeObject {
  PerformanceLogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PerformanceLog.t;
}

class PerformanceLogIncludeList extends _i1.IncludeList {
  PerformanceLogIncludeList._({
    _i1.WhereExpressionBuilder<PerformanceLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PerformanceLog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PerformanceLog.t;
}

class PerformanceLogRepository {
  const PerformanceLogRepository._();

  /// Returns a list of [PerformanceLog]s matching the given query parameters.
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
  Future<List<PerformanceLog>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PerformanceLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PerformanceLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PerformanceLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PerformanceLog>(
      where: where?.call(PerformanceLog.t),
      orderBy: orderBy?.call(PerformanceLog.t),
      orderByList: orderByList?.call(PerformanceLog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PerformanceLog] matching the given query parameters.
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
  Future<PerformanceLog?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PerformanceLogTable>? where,
    int? offset,
    _i1.OrderByBuilder<PerformanceLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PerformanceLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PerformanceLog>(
      where: where?.call(PerformanceLog.t),
      orderBy: orderBy?.call(PerformanceLog.t),
      orderByList: orderByList?.call(PerformanceLog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PerformanceLog] by its [id] or null if no such row exists.
  Future<PerformanceLog?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PerformanceLog>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PerformanceLog]s in the list and returns the inserted rows.
  ///
  /// The returned [PerformanceLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PerformanceLog>> insert(
    _i1.Session session,
    List<PerformanceLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PerformanceLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PerformanceLog] and returns the inserted row.
  ///
  /// The returned [PerformanceLog] will have its `id` field set.
  Future<PerformanceLog> insertRow(
    _i1.Session session,
    PerformanceLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PerformanceLog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PerformanceLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PerformanceLog>> update(
    _i1.Session session,
    List<PerformanceLog> rows, {
    _i1.ColumnSelections<PerformanceLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PerformanceLog>(
      rows,
      columns: columns?.call(PerformanceLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PerformanceLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PerformanceLog> updateRow(
    _i1.Session session,
    PerformanceLog row, {
    _i1.ColumnSelections<PerformanceLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PerformanceLog>(
      row,
      columns: columns?.call(PerformanceLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PerformanceLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PerformanceLog?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PerformanceLogUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PerformanceLog>(
      id,
      columnValues: columnValues(PerformanceLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PerformanceLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PerformanceLog>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PerformanceLogUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PerformanceLogTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PerformanceLogTable>? orderBy,
    _i1.OrderByListBuilder<PerformanceLogTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PerformanceLog>(
      columnValues: columnValues(PerformanceLog.t.updateTable),
      where: where(PerformanceLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PerformanceLog.t),
      orderByList: orderByList?.call(PerformanceLog.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PerformanceLog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PerformanceLog>> delete(
    _i1.Session session,
    List<PerformanceLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PerformanceLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PerformanceLog].
  Future<PerformanceLog> deleteRow(
    _i1.Session session,
    PerformanceLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PerformanceLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PerformanceLog>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PerformanceLogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PerformanceLog>(
      where: where(PerformanceLog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PerformanceLogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PerformanceLog>(
      where: where?.call(PerformanceLog.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
