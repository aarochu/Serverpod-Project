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

abstract class ReviewSession
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ReviewSession._({
    this.id,
    required this.pullRequestId,
    required this.status,
    this.currentFile,
    required this.filesProcessed,
    required this.totalFiles,
    required this.progressPercent,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewSession({
    int? id,
    required int pullRequestId,
    required String status,
    String? currentFile,
    required int filesProcessed,
    required int totalFiles,
    required double progressPercent,
    String? errorMessage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReviewSessionImpl;

  factory ReviewSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewSession(
      id: jsonSerialization['id'] as int?,
      pullRequestId: jsonSerialization['pullRequestId'] as int,
      status: jsonSerialization['status'] as String,
      currentFile: jsonSerialization['currentFile'] as String?,
      filesProcessed: jsonSerialization['filesProcessed'] as int,
      totalFiles: jsonSerialization['totalFiles'] as int,
      progressPercent: (jsonSerialization['progressPercent'] as num).toDouble(),
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = ReviewSessionTable();

  static const db = ReviewSessionRepository._();

  @override
  int? id;

  int pullRequestId;

  String status;

  String? currentFile;

  int filesProcessed;

  int totalFiles;

  double progressPercent;

  String? errorMessage;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReviewSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReviewSession copyWith({
    int? id,
    int? pullRequestId,
    String? status,
    String? currentFile,
    int? filesProcessed,
    int? totalFiles,
    double? progressPercent,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewSession',
      if (id != null) 'id': id,
      'pullRequestId': pullRequestId,
      'status': status,
      if (currentFile != null) 'currentFile': currentFile,
      'filesProcessed': filesProcessed,
      'totalFiles': totalFiles,
      'progressPercent': progressPercent,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewSession',
      if (id != null) 'id': id,
      'pullRequestId': pullRequestId,
      'status': status,
      if (currentFile != null) 'currentFile': currentFile,
      'filesProcessed': filesProcessed,
      'totalFiles': totalFiles,
      'progressPercent': progressPercent,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ReviewSessionInclude include() {
    return ReviewSessionInclude._();
  }

  static ReviewSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<ReviewSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewSessionTable>? orderByList,
    ReviewSessionInclude? include,
  }) {
    return ReviewSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ReviewSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewSessionImpl extends ReviewSession {
  _ReviewSessionImpl({
    int? id,
    required int pullRequestId,
    required String status,
    String? currentFile,
    required int filesProcessed,
    required int totalFiles,
    required double progressPercent,
    String? errorMessage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         pullRequestId: pullRequestId,
         status: status,
         currentFile: currentFile,
         filesProcessed: filesProcessed,
         totalFiles: totalFiles,
         progressPercent: progressPercent,
         errorMessage: errorMessage,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ReviewSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReviewSession copyWith({
    Object? id = _Undefined,
    int? pullRequestId,
    String? status,
    Object? currentFile = _Undefined,
    int? filesProcessed,
    int? totalFiles,
    double? progressPercent,
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewSession(
      id: id is int? ? id : this.id,
      pullRequestId: pullRequestId ?? this.pullRequestId,
      status: status ?? this.status,
      currentFile: currentFile is String? ? currentFile : this.currentFile,
      filesProcessed: filesProcessed ?? this.filesProcessed,
      totalFiles: totalFiles ?? this.totalFiles,
      progressPercent: progressPercent ?? this.progressPercent,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ReviewSessionUpdateTable extends _i1.UpdateTable<ReviewSessionTable> {
  ReviewSessionUpdateTable(super.table);

  _i1.ColumnValue<int, int> pullRequestId(int value) => _i1.ColumnValue(
    table.pullRequestId,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> currentFile(String? value) => _i1.ColumnValue(
    table.currentFile,
    value,
  );

  _i1.ColumnValue<int, int> filesProcessed(int value) => _i1.ColumnValue(
    table.filesProcessed,
    value,
  );

  _i1.ColumnValue<int, int> totalFiles(int value) => _i1.ColumnValue(
    table.totalFiles,
    value,
  );

  _i1.ColumnValue<double, double> progressPercent(double value) =>
      _i1.ColumnValue(
        table.progressPercent,
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

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ReviewSessionTable extends _i1.Table<int?> {
  ReviewSessionTable({super.tableRelation})
    : super(tableName: 'review_sessions') {
    updateTable = ReviewSessionUpdateTable(this);
    pullRequestId = _i1.ColumnInt(
      'pullRequestId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    currentFile = _i1.ColumnString(
      'currentFile',
      this,
    );
    filesProcessed = _i1.ColumnInt(
      'filesProcessed',
      this,
    );
    totalFiles = _i1.ColumnInt(
      'totalFiles',
      this,
    );
    progressPercent = _i1.ColumnDouble(
      'progressPercent',
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
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final ReviewSessionUpdateTable updateTable;

  late final _i1.ColumnInt pullRequestId;

  late final _i1.ColumnString status;

  late final _i1.ColumnString currentFile;

  late final _i1.ColumnInt filesProcessed;

  late final _i1.ColumnInt totalFiles;

  late final _i1.ColumnDouble progressPercent;

  late final _i1.ColumnString errorMessage;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    pullRequestId,
    status,
    currentFile,
    filesProcessed,
    totalFiles,
    progressPercent,
    errorMessage,
    createdAt,
    updatedAt,
  ];
}

class ReviewSessionInclude extends _i1.IncludeObject {
  ReviewSessionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ReviewSession.t;
}

class ReviewSessionIncludeList extends _i1.IncludeList {
  ReviewSessionIncludeList._({
    _i1.WhereExpressionBuilder<ReviewSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReviewSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ReviewSession.t;
}

class ReviewSessionRepository {
  const ReviewSessionRepository._();

  /// Returns a list of [ReviewSession]s matching the given query parameters.
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
  Future<List<ReviewSession>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewSessionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ReviewSession>(
      where: where?.call(ReviewSession.t),
      orderBy: orderBy?.call(ReviewSession.t),
      orderByList: orderByList?.call(ReviewSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ReviewSession] matching the given query parameters.
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
  Future<ReviewSession?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReviewSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewSessionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ReviewSession>(
      where: where?.call(ReviewSession.t),
      orderBy: orderBy?.call(ReviewSession.t),
      orderByList: orderByList?.call(ReviewSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ReviewSession] by its [id] or null if no such row exists.
  Future<ReviewSession?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ReviewSession>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ReviewSession]s in the list and returns the inserted rows.
  ///
  /// The returned [ReviewSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ReviewSession>> insert(
    _i1.Session session,
    List<ReviewSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ReviewSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ReviewSession] and returns the inserted row.
  ///
  /// The returned [ReviewSession] will have its `id` field set.
  Future<ReviewSession> insertRow(
    _i1.Session session,
    ReviewSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReviewSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ReviewSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReviewSession>> update(
    _i1.Session session,
    List<ReviewSession> rows, {
    _i1.ColumnSelections<ReviewSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReviewSession>(
      rows,
      columns: columns?.call(ReviewSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReviewSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReviewSession> updateRow(
    _i1.Session session,
    ReviewSession row, {
    _i1.ColumnSelections<ReviewSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReviewSession>(
      row,
      columns: columns?.call(ReviewSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReviewSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReviewSession?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ReviewSessionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ReviewSession>(
      id,
      columnValues: columnValues(ReviewSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReviewSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ReviewSession>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ReviewSessionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ReviewSessionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewSessionTable>? orderBy,
    _i1.OrderByListBuilder<ReviewSessionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ReviewSession>(
      columnValues: columnValues(ReviewSession.t.updateTable),
      where: where(ReviewSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewSession.t),
      orderByList: orderByList?.call(ReviewSession.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ReviewSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReviewSession>> delete(
    _i1.Session session,
    List<ReviewSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReviewSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReviewSession].
  Future<ReviewSession> deleteRow(
    _i1.Session session,
    ReviewSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReviewSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ReviewSession>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReviewSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReviewSession>(
      where: where(ReviewSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReviewSession>(
      where: where?.call(ReviewSession.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
