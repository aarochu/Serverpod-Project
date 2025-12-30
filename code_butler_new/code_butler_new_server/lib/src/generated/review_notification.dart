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

abstract class ReviewNotification
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ReviewNotification._({
    this.id,
    required this.userId,
    required this.reviewSessionId,
    required this.type,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory ReviewNotification({
    int? id,
    required String userId,
    required int reviewSessionId,
    required String type,
    required String message,
    required bool read,
    required DateTime createdAt,
  }) = _ReviewNotificationImpl;

  factory ReviewNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewNotification(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      reviewSessionId: jsonSerialization['reviewSessionId'] as int,
      type: jsonSerialization['type'] as String,
      message: jsonSerialization['message'] as String,
      read: jsonSerialization['read'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ReviewNotificationTable();

  static const db = ReviewNotificationRepository._();

  @override
  int? id;

  String userId;

  int reviewSessionId;

  String type;

  String message;

  bool read;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReviewNotification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReviewNotification copyWith({
    int? id,
    String? userId,
    int? reviewSessionId,
    String? type,
    String? message,
    bool? read,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewNotification',
      if (id != null) 'id': id,
      'userId': userId,
      'reviewSessionId': reviewSessionId,
      'type': type,
      'message': message,
      'read': read,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewNotification',
      if (id != null) 'id': id,
      'userId': userId,
      'reviewSessionId': reviewSessionId,
      'type': type,
      'message': message,
      'read': read,
      'createdAt': createdAt.toJson(),
    };
  }

  static ReviewNotificationInclude include() {
    return ReviewNotificationInclude._();
  }

  static ReviewNotificationIncludeList includeList({
    _i1.WhereExpressionBuilder<ReviewNotificationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewNotificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewNotificationTable>? orderByList,
    ReviewNotificationInclude? include,
  }) {
    return ReviewNotificationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewNotification.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ReviewNotification.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewNotificationImpl extends ReviewNotification {
  _ReviewNotificationImpl({
    int? id,
    required String userId,
    required int reviewSessionId,
    required String type,
    required String message,
    required bool read,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         reviewSessionId: reviewSessionId,
         type: type,
         message: message,
         read: read,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReviewNotification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReviewNotification copyWith({
    Object? id = _Undefined,
    String? userId,
    int? reviewSessionId,
    String? type,
    String? message,
    bool? read,
    DateTime? createdAt,
  }) {
    return ReviewNotification(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      reviewSessionId: reviewSessionId ?? this.reviewSessionId,
      type: type ?? this.type,
      message: message ?? this.message,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ReviewNotificationUpdateTable
    extends _i1.UpdateTable<ReviewNotificationTable> {
  ReviewNotificationUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> reviewSessionId(int value) => _i1.ColumnValue(
    table.reviewSessionId,
    value,
  );

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<String, String> message(String value) => _i1.ColumnValue(
    table.message,
    value,
  );

  _i1.ColumnValue<bool, bool> read(bool value) => _i1.ColumnValue(
    table.read,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class ReviewNotificationTable extends _i1.Table<int?> {
  ReviewNotificationTable({super.tableRelation})
    : super(tableName: 'review_notifications') {
    updateTable = ReviewNotificationUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    reviewSessionId = _i1.ColumnInt(
      'reviewSessionId',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    message = _i1.ColumnString(
      'message',
      this,
    );
    read = _i1.ColumnBool(
      'read',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ReviewNotificationUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnInt reviewSessionId;

  late final _i1.ColumnString type;

  late final _i1.ColumnString message;

  late final _i1.ColumnBool read;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    reviewSessionId,
    type,
    message,
    read,
    createdAt,
  ];
}

class ReviewNotificationInclude extends _i1.IncludeObject {
  ReviewNotificationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ReviewNotification.t;
}

class ReviewNotificationIncludeList extends _i1.IncludeList {
  ReviewNotificationIncludeList._({
    _i1.WhereExpressionBuilder<ReviewNotificationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReviewNotification.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ReviewNotification.t;
}

class ReviewNotificationRepository {
  const ReviewNotificationRepository._();

  /// Returns a list of [ReviewNotification]s matching the given query parameters.
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
  Future<List<ReviewNotification>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewNotificationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewNotificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewNotificationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ReviewNotification>(
      where: where?.call(ReviewNotification.t),
      orderBy: orderBy?.call(ReviewNotification.t),
      orderByList: orderByList?.call(ReviewNotification.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ReviewNotification] matching the given query parameters.
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
  Future<ReviewNotification?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewNotificationTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReviewNotificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewNotificationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ReviewNotification>(
      where: where?.call(ReviewNotification.t),
      orderBy: orderBy?.call(ReviewNotification.t),
      orderByList: orderByList?.call(ReviewNotification.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ReviewNotification] by its [id] or null if no such row exists.
  Future<ReviewNotification?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ReviewNotification>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ReviewNotification]s in the list and returns the inserted rows.
  ///
  /// The returned [ReviewNotification]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ReviewNotification>> insert(
    _i1.Session session,
    List<ReviewNotification> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ReviewNotification>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ReviewNotification] and returns the inserted row.
  ///
  /// The returned [ReviewNotification] will have its `id` field set.
  Future<ReviewNotification> insertRow(
    _i1.Session session,
    ReviewNotification row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReviewNotification>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ReviewNotification]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReviewNotification>> update(
    _i1.Session session,
    List<ReviewNotification> rows, {
    _i1.ColumnSelections<ReviewNotificationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReviewNotification>(
      rows,
      columns: columns?.call(ReviewNotification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReviewNotification]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReviewNotification> updateRow(
    _i1.Session session,
    ReviewNotification row, {
    _i1.ColumnSelections<ReviewNotificationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReviewNotification>(
      row,
      columns: columns?.call(ReviewNotification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReviewNotification] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReviewNotification?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ReviewNotificationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ReviewNotification>(
      id,
      columnValues: columnValues(ReviewNotification.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReviewNotification]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ReviewNotification>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ReviewNotificationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ReviewNotificationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewNotificationTable>? orderBy,
    _i1.OrderByListBuilder<ReviewNotificationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ReviewNotification>(
      columnValues: columnValues(ReviewNotification.t.updateTable),
      where: where(ReviewNotification.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReviewNotification.t),
      orderByList: orderByList?.call(ReviewNotification.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ReviewNotification]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReviewNotification>> delete(
    _i1.Session session,
    List<ReviewNotification> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReviewNotification>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReviewNotification].
  Future<ReviewNotification> deleteRow(
    _i1.Session session,
    ReviewNotification row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReviewNotification>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ReviewNotification>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReviewNotificationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReviewNotification>(
      where: where(ReviewNotification.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewNotificationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReviewNotification>(
      where: where?.call(ReviewNotification.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
