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

abstract class ReviewJob
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ReviewJob._({
    this.id,
    required this.pullRequestId,
    required this.status,
    required this.priority,
    required this.retryCount,
    this.errorMessage,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });

  factory ReviewJob({
    int? id,
    required int pullRequestId,
    required String status,
    required int priority,
    required int retryCount,
    String? errorMessage,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _ReviewJobImpl;

  factory ReviewJob.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewJob(
      id: jsonSerialization['id'] as int?,
      pullRequestId: jsonSerialization['pullRequestId'] as int,
      status: jsonSerialization['status'] as String,
      priority: jsonSerialization['priority'] as int,
      retryCount: jsonSerialization['retryCount'] as int,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  static final t = ReviewJobTable();

  static const db = ReviewJobRepository._();

  @override
  int? id;

  int pullRequestId;

  String status;

  int priority;

  int retryCount;

  String? errorMessage;

  DateTime createdAt;

  DateTime? startedAt;

  DateTime? completedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReviewJob]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReviewJob copyWith({
    int? id,
    int? pullRequestId,
    String? status,
    int? priority,
    int? retryCount,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewJob',
      if (id != null) 'id': id,
      'pullRequestId': pullRequestId,
      'status': status,
      'priority': priority,
      'retryCount': retryCount,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewJob',
      if (id != null) 'id': id,
      'pullRequestId': pullRequestId,
      'status': status,
      'priority': priority,
      'retryCount': retryCount,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  static ReviewJobInclude include() {
    return ReviewJobInclude._();
  }

  static ReviewJobIncludeList includeList({
    _i1.WhereExpressionBuilder<ReviewJobTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewJobTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewJobTable>? orderByList,
    ReviewJobInclude? include,
  }) {
    return ReviewJobIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewJob.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ReviewJob.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewJobImpl extends ReviewJob {
  _ReviewJobImpl({
    int? id,
    required int pullRequestId,
    required String status,
    required int priority,
    required int retryCount,
    String? errorMessage,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) : super._(
         id: id,
         pullRequestId: pullRequestId,
         status: status,
         priority: priority,
         retryCount: retryCount,
         errorMessage: errorMessage,
         createdAt: createdAt,
         startedAt: startedAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [ReviewJob]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReviewJob copyWith({
    Object? id = _Undefined,
    int? pullRequestId,
    String? status,
    int? priority,
    int? retryCount,
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
    Object? startedAt = _Undefined,
    Object? completedAt = _Undefined,
  }) {
    return ReviewJob(
      id: id is int? ? id : this.id,
      pullRequestId: pullRequestId ?? this.pullRequestId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt is DateTime? ? startedAt : this.startedAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}

class ReviewJobUpdateTable extends _i1.UpdateTable<ReviewJobTable> {
  ReviewJobUpdateTable(super.table);

  _i1.ColumnValue<int, int> pullRequestId(int value) => _i1.ColumnValue(
    table.pullRequestId,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<int, int> priority(int value) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<int, int> retryCount(int value) => _i1.ColumnValue(
    table.retryCount,
    value,
  );

  _i1.ColumnValue<String, String> errorMessage(String? value) =>
      _i1.ColumnValue(
        table.errorMessage,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> startedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.startedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.completedAt,
        value,
      );
}

class ReviewJobTable extends _i1.Table<int?> {
  ReviewJobTable({super.tableRelation}) : super(tableName: 'review_jobs') {
    updateTable = ReviewJobUpdateTable(this);
    pullRequestId = _i1.ColumnInt(
      'pullRequestId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    priority = _i1.ColumnInt(
      'priority',
      this,
    );
    retryCount = _i1.ColumnInt(
      'retryCount',
      this,
    );
    errorMessage = _i1.ColumnString(
      'errorMessage',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    startedAt = _i1.ColumnDateTime(
      'startedAt',
      this,
    );
    completedAt = _i1.ColumnDateTime(
      'completedAt',
      this,
    );
  }

  late final ReviewJobUpdateTable updateTable;

  late final _i1.ColumnInt pullRequestId;

  late final _i1.ColumnString status;

  late final _i1.ColumnInt priority;

  late final _i1.ColumnInt retryCount;

  late final _i1.ColumnString errorMessage;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime startedAt;

  late final _i1.ColumnDateTime completedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    pullRequestId,
    status,
    priority,
    retryCount,
    errorMessage,
    createdAt,
    startedAt,
    completedAt,
  ];
}

class ReviewJobInclude extends _i1.IncludeObject {
  ReviewJobInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ReviewJob.t;
}

class ReviewJobIncludeList extends _i1.IncludeList {
  ReviewJobIncludeList._({
    _i1.WhereExpressionBuilder<ReviewJobTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReviewJob.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ReviewJob.t;
}

class ReviewJobRepository {
  const ReviewJobRepository._();

  /// Returns a list of [ReviewJob]s matching the given query parameters.
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
  Future<List<ReviewJob>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewJobTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewJobTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewJobTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ReviewJob>(
      where: where?.call(ReviewJob.t),
      orderBy: orderBy?.call(ReviewJob.t),
      orderByList: orderByList?.call(ReviewJob.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ReviewJob] matching the given query parameters.
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
  Future<ReviewJob?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewJobTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReviewJobTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewJobTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ReviewJob>(
      where: where?.call(ReviewJob.t),
      orderBy: orderBy?.call(ReviewJob.t),
      orderByList: orderByList?.call(ReviewJob.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ReviewJob] by its [id] or null if no such row exists.
  Future<ReviewJob?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ReviewJob>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ReviewJob]s in the list and returns the inserted rows.
  ///
  /// The returned [ReviewJob]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ReviewJob>> insert(
    _i1.Session session,
    List<ReviewJob> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ReviewJob>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ReviewJob] and returns the inserted row.
  ///
  /// The returned [ReviewJob] will have its `id` field set.
  Future<ReviewJob> insertRow(
    _i1.Session session,
    ReviewJob row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReviewJob>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ReviewJob]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReviewJob>> update(
    _i1.Session session,
    List<ReviewJob> rows, {
    _i1.ColumnSelections<ReviewJobTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReviewJob>(
      rows,
      columns: columns?.call(ReviewJob.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReviewJob]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReviewJob> updateRow(
    _i1.Session session,
    ReviewJob row, {
    _i1.ColumnSelections<ReviewJobTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReviewJob>(
      row,
      columns: columns?.call(ReviewJob.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReviewJob] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReviewJob?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ReviewJobUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ReviewJob>(
      id,
      columnValues: columnValues(ReviewJob.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReviewJob]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ReviewJob>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ReviewJobUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ReviewJobTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewJobTable>? orderBy,
    _i1.OrderByListBuilder<ReviewJobTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ReviewJob>(
      columnValues: columnValues(ReviewJob.t.updateTable),
      where: where(ReviewJob.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewJob.t),
      orderByList: orderByList?.call(ReviewJob.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ReviewJob]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReviewJob>> delete(
    _i1.Session session,
    List<ReviewJob> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReviewJob>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReviewJob].
  Future<ReviewJob> deleteRow(
    _i1.Session session,
    ReviewJob row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReviewJob>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ReviewJob>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReviewJobTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReviewJob>(
      where: where(ReviewJob.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewJobTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReviewJob>(
      where: where?.call(ReviewJob.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
