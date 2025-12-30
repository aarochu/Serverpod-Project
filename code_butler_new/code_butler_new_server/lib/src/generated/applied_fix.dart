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

abstract class AppliedFix
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AppliedFix._({
    this.id,
    required this.findingId,
    required this.fixCode,
    required this.appliedAt,
    required this.status,
    this.prUrl,
  });

  factory AppliedFix({
    int? id,
    required int findingId,
    required String fixCode,
    required DateTime appliedAt,
    required String status,
    String? prUrl,
  }) = _AppliedFixImpl;

  factory AppliedFix.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppliedFix(
      id: jsonSerialization['id'] as int?,
      findingId: jsonSerialization['findingId'] as int,
      fixCode: jsonSerialization['fixCode'] as String,
      appliedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['appliedAt'],
      ),
      status: jsonSerialization['status'] as String,
      prUrl: jsonSerialization['prUrl'] as String?,
    );
  }

  static final t = AppliedFixTable();

  static const db = AppliedFixRepository._();

  @override
  int? id;

  int findingId;

  String fixCode;

  DateTime appliedAt;

  String status;

  String? prUrl;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppliedFix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppliedFix copyWith({
    int? id,
    int? findingId,
    String? fixCode,
    DateTime? appliedAt,
    String? status,
    String? prUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppliedFix',
      if (id != null) 'id': id,
      'findingId': findingId,
      'fixCode': fixCode,
      'appliedAt': appliedAt.toJson(),
      'status': status,
      if (prUrl != null) 'prUrl': prUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppliedFix',
      if (id != null) 'id': id,
      'findingId': findingId,
      'fixCode': fixCode,
      'appliedAt': appliedAt.toJson(),
      'status': status,
      if (prUrl != null) 'prUrl': prUrl,
    };
  }

  static AppliedFixInclude include() {
    return AppliedFixInclude._();
  }

  static AppliedFixIncludeList includeList({
    _i1.WhereExpressionBuilder<AppliedFixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppliedFixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppliedFixTable>? orderByList,
    AppliedFixInclude? include,
  }) {
    return AppliedFixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppliedFix.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppliedFix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppliedFixImpl extends AppliedFix {
  _AppliedFixImpl({
    int? id,
    required int findingId,
    required String fixCode,
    required DateTime appliedAt,
    required String status,
    String? prUrl,
  }) : super._(
         id: id,
         findingId: findingId,
         fixCode: fixCode,
         appliedAt: appliedAt,
         status: status,
         prUrl: prUrl,
       );

  /// Returns a shallow copy of this [AppliedFix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppliedFix copyWith({
    Object? id = _Undefined,
    int? findingId,
    String? fixCode,
    DateTime? appliedAt,
    String? status,
    Object? prUrl = _Undefined,
  }) {
    return AppliedFix(
      id: id is int? ? id : this.id,
      findingId: findingId ?? this.findingId,
      fixCode: fixCode ?? this.fixCode,
      appliedAt: appliedAt ?? this.appliedAt,
      status: status ?? this.status,
      prUrl: prUrl is String? ? prUrl : this.prUrl,
    );
  }
}

class AppliedFixUpdateTable extends _i1.UpdateTable<AppliedFixTable> {
  AppliedFixUpdateTable(super.table);

  _i1.ColumnValue<int, int> findingId(int value) => _i1.ColumnValue(
    table.findingId,
    value,
  );

  _i1.ColumnValue<String, String> fixCode(String value) => _i1.ColumnValue(
    table.fixCode,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> appliedAt(DateTime value) =>
      _i1.ColumnValue(
        table.appliedAt,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> prUrl(String? value) => _i1.ColumnValue(
    table.prUrl,
    value,
  );
}

class AppliedFixTable extends _i1.Table<int?> {
  AppliedFixTable({super.tableRelation}) : super(tableName: 'applied_fixes') {
    updateTable = AppliedFixUpdateTable(this);
    findingId = _i1.ColumnInt(
      'findingId',
      this,
    );
    fixCode = _i1.ColumnString(
      'fixCode',
      this,
    );
    appliedAt = _i1.ColumnDateTime(
      'appliedAt',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    prUrl = _i1.ColumnString(
      'prUrl',
      this,
    );
  }

  late final AppliedFixUpdateTable updateTable;

  late final _i1.ColumnInt findingId;

  late final _i1.ColumnString fixCode;

  late final _i1.ColumnDateTime appliedAt;

  late final _i1.ColumnString status;

  late final _i1.ColumnString prUrl;

  @override
  List<_i1.Column> get columns => [
    id,
    findingId,
    fixCode,
    appliedAt,
    status,
    prUrl,
  ];
}

class AppliedFixInclude extends _i1.IncludeObject {
  AppliedFixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AppliedFix.t;
}

class AppliedFixIncludeList extends _i1.IncludeList {
  AppliedFixIncludeList._({
    _i1.WhereExpressionBuilder<AppliedFixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppliedFix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AppliedFix.t;
}

class AppliedFixRepository {
  const AppliedFixRepository._();

  /// Returns a list of [AppliedFix]s matching the given query parameters.
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
  Future<List<AppliedFix>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppliedFixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppliedFixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppliedFixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AppliedFix>(
      where: where?.call(AppliedFix.t),
      orderBy: orderBy?.call(AppliedFix.t),
      orderByList: orderByList?.call(AppliedFix.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AppliedFix] matching the given query parameters.
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
  Future<AppliedFix?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppliedFixTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppliedFixTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppliedFixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AppliedFix>(
      where: where?.call(AppliedFix.t),
      orderBy: orderBy?.call(AppliedFix.t),
      orderByList: orderByList?.call(AppliedFix.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AppliedFix] by its [id] or null if no such row exists.
  Future<AppliedFix?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AppliedFix>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AppliedFix]s in the list and returns the inserted rows.
  ///
  /// The returned [AppliedFix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AppliedFix>> insert(
    _i1.Session session,
    List<AppliedFix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AppliedFix>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AppliedFix] and returns the inserted row.
  ///
  /// The returned [AppliedFix] will have its `id` field set.
  Future<AppliedFix> insertRow(
    _i1.Session session,
    AppliedFix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppliedFix>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppliedFix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppliedFix>> update(
    _i1.Session session,
    List<AppliedFix> rows, {
    _i1.ColumnSelections<AppliedFixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppliedFix>(
      rows,
      columns: columns?.call(AppliedFix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppliedFix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppliedFix> updateRow(
    _i1.Session session,
    AppliedFix row, {
    _i1.ColumnSelections<AppliedFixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppliedFix>(
      row,
      columns: columns?.call(AppliedFix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppliedFix] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppliedFix?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AppliedFixUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppliedFix>(
      id,
      columnValues: columnValues(AppliedFix.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppliedFix]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppliedFix>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AppliedFixUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AppliedFixTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppliedFixTable>? orderBy,
    _i1.OrderByListBuilder<AppliedFixTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppliedFix>(
      columnValues: columnValues(AppliedFix.t.updateTable),
      where: where(AppliedFix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppliedFix.t),
      orderByList: orderByList?.call(AppliedFix.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppliedFix]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppliedFix>> delete(
    _i1.Session session,
    List<AppliedFix> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppliedFix>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppliedFix].
  Future<AppliedFix> deleteRow(
    _i1.Session session,
    AppliedFix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppliedFix>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppliedFix>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AppliedFixTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppliedFix>(
      where: where(AppliedFix.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppliedFixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppliedFix>(
      where: where?.call(AppliedFix.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
