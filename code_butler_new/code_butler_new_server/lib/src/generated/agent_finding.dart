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

abstract class AgentFinding
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AgentFinding._({
    this.id,
    required this.pullRequestId,
    required this.agentType,
    required this.severity,
    required this.category,
    required this.message,
    this.filePath,
    this.lineNumber,
    this.codeSnippet,
    this.suggestedFix,
    required this.createdAt,
  });

  factory AgentFinding({
    int? id,
    required int pullRequestId,
    required String agentType,
    required String severity,
    required String category,
    required String message,
    String? filePath,
    int? lineNumber,
    String? codeSnippet,
    String? suggestedFix,
    required DateTime createdAt,
  }) = _AgentFindingImpl;

  factory AgentFinding.fromJson(Map<String, dynamic> jsonSerialization) {
    return AgentFinding(
      id: jsonSerialization['id'] as int?,
      pullRequestId: jsonSerialization['pullRequestId'] as int,
      agentType: jsonSerialization['agentType'] as String,
      severity: jsonSerialization['severity'] as String,
      category: jsonSerialization['category'] as String,
      message: jsonSerialization['message'] as String,
      filePath: jsonSerialization['filePath'] as String?,
      lineNumber: jsonSerialization['lineNumber'] as int?,
      codeSnippet: jsonSerialization['codeSnippet'] as String?,
      suggestedFix: jsonSerialization['suggestedFix'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AgentFindingTable();

  static const db = AgentFindingRepository._();

  @override
  int? id;

  int pullRequestId;

  String agentType;

  String severity;

  String category;

  String message;

  String? filePath;

  int? lineNumber;

  String? codeSnippet;

  String? suggestedFix;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AgentFinding]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AgentFinding copyWith({
    int? id,
    int? pullRequestId,
    String? agentType,
    String? severity,
    String? category,
    String? message,
    String? filePath,
    int? lineNumber,
    String? codeSnippet,
    String? suggestedFix,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AgentFinding',
      if (id != null) 'id': id,
      'pullRequestId': pullRequestId,
      'agentType': agentType,
      'severity': severity,
      'category': category,
      'message': message,
      if (filePath != null) 'filePath': filePath,
      if (lineNumber != null) 'lineNumber': lineNumber,
      if (codeSnippet != null) 'codeSnippet': codeSnippet,
      if (suggestedFix != null) 'suggestedFix': suggestedFix,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AgentFinding',
      if (id != null) 'id': id,
      'pullRequestId': pullRequestId,
      'agentType': agentType,
      'severity': severity,
      'category': category,
      'message': message,
      if (filePath != null) 'filePath': filePath,
      if (lineNumber != null) 'lineNumber': lineNumber,
      if (codeSnippet != null) 'codeSnippet': codeSnippet,
      if (suggestedFix != null) 'suggestedFix': suggestedFix,
      'createdAt': createdAt.toJson(),
    };
  }

  static AgentFindingInclude include() {
    return AgentFindingInclude._();
  }

  static AgentFindingIncludeList includeList({
    _i1.WhereExpressionBuilder<AgentFindingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AgentFindingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AgentFindingTable>? orderByList,
    AgentFindingInclude? include,
  }) {
    return AgentFindingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AgentFinding.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AgentFinding.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AgentFindingImpl extends AgentFinding {
  _AgentFindingImpl({
    int? id,
    required int pullRequestId,
    required String agentType,
    required String severity,
    required String category,
    required String message,
    String? filePath,
    int? lineNumber,
    String? codeSnippet,
    String? suggestedFix,
    required DateTime createdAt,
  }) : super._(
         id: id,
         pullRequestId: pullRequestId,
         agentType: agentType,
         severity: severity,
         category: category,
         message: message,
         filePath: filePath,
         lineNumber: lineNumber,
         codeSnippet: codeSnippet,
         suggestedFix: suggestedFix,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AgentFinding]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AgentFinding copyWith({
    Object? id = _Undefined,
    int? pullRequestId,
    String? agentType,
    String? severity,
    String? category,
    String? message,
    Object? filePath = _Undefined,
    Object? lineNumber = _Undefined,
    Object? codeSnippet = _Undefined,
    Object? suggestedFix = _Undefined,
    DateTime? createdAt,
  }) {
    return AgentFinding(
      id: id is int? ? id : this.id,
      pullRequestId: pullRequestId ?? this.pullRequestId,
      agentType: agentType ?? this.agentType,
      severity: severity ?? this.severity,
      category: category ?? this.category,
      message: message ?? this.message,
      filePath: filePath is String? ? filePath : this.filePath,
      lineNumber: lineNumber is int? ? lineNumber : this.lineNumber,
      codeSnippet: codeSnippet is String? ? codeSnippet : this.codeSnippet,
      suggestedFix: suggestedFix is String? ? suggestedFix : this.suggestedFix,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AgentFindingUpdateTable extends _i1.UpdateTable<AgentFindingTable> {
  AgentFindingUpdateTable(super.table);

  _i1.ColumnValue<int, int> pullRequestId(int value) => _i1.ColumnValue(
    table.pullRequestId,
    value,
  );

  _i1.ColumnValue<String, String> agentType(String value) => _i1.ColumnValue(
    table.agentType,
    value,
  );

  _i1.ColumnValue<String, String> severity(String value) => _i1.ColumnValue(
    table.severity,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> message(String value) => _i1.ColumnValue(
    table.message,
    value,
  );

  _i1.ColumnValue<String, String> filePath(String? value) => _i1.ColumnValue(
    table.filePath,
    value,
  );

  _i1.ColumnValue<int, int> lineNumber(int? value) => _i1.ColumnValue(
    table.lineNumber,
    value,
  );

  _i1.ColumnValue<String, String> codeSnippet(String? value) => _i1.ColumnValue(
    table.codeSnippet,
    value,
  );

  _i1.ColumnValue<String, String> suggestedFix(String? value) =>
      _i1.ColumnValue(
        table.suggestedFix,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AgentFindingTable extends _i1.Table<int?> {
  AgentFindingTable({super.tableRelation})
    : super(tableName: 'agent_findings') {
    updateTable = AgentFindingUpdateTable(this);
    pullRequestId = _i1.ColumnInt(
      'pullRequestId',
      this,
    );
    agentType = _i1.ColumnString(
      'agentType',
      this,
    );
    severity = _i1.ColumnString(
      'severity',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    message = _i1.ColumnString(
      'message',
      this,
    );
    filePath = _i1.ColumnString(
      'filePath',
      this,
    );
    lineNumber = _i1.ColumnInt(
      'lineNumber',
      this,
    );
    codeSnippet = _i1.ColumnString(
      'codeSnippet',
      this,
    );
    suggestedFix = _i1.ColumnString(
      'suggestedFix',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AgentFindingUpdateTable updateTable;

  late final _i1.ColumnInt pullRequestId;

  late final _i1.ColumnString agentType;

  late final _i1.ColumnString severity;

  late final _i1.ColumnString category;

  late final _i1.ColumnString message;

  late final _i1.ColumnString filePath;

  late final _i1.ColumnInt lineNumber;

  late final _i1.ColumnString codeSnippet;

  late final _i1.ColumnString suggestedFix;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    pullRequestId,
    agentType,
    severity,
    category,
    message,
    filePath,
    lineNumber,
    codeSnippet,
    suggestedFix,
    createdAt,
  ];
}

class AgentFindingInclude extends _i1.IncludeObject {
  AgentFindingInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AgentFinding.t;
}

class AgentFindingIncludeList extends _i1.IncludeList {
  AgentFindingIncludeList._({
    _i1.WhereExpressionBuilder<AgentFindingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AgentFinding.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AgentFinding.t;
}

class AgentFindingRepository {
  const AgentFindingRepository._();

  /// Returns a list of [AgentFinding]s matching the given query parameters.
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
  Future<List<AgentFinding>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AgentFindingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AgentFindingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AgentFindingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AgentFinding>(
      where: where?.call(AgentFinding.t),
      orderBy: orderBy?.call(AgentFinding.t),
      orderByList: orderByList?.call(AgentFinding.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AgentFinding] matching the given query parameters.
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
  Future<AgentFinding?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AgentFindingTable>? where,
    int? offset,
    _i1.OrderByBuilder<AgentFindingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AgentFindingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AgentFinding>(
      where: where?.call(AgentFinding.t),
      orderBy: orderBy?.call(AgentFinding.t),
      orderByList: orderByList?.call(AgentFinding.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AgentFinding] by its [id] or null if no such row exists.
  Future<AgentFinding?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AgentFinding>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AgentFinding]s in the list and returns the inserted rows.
  ///
  /// The returned [AgentFinding]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AgentFinding>> insert(
    _i1.Session session,
    List<AgentFinding> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AgentFinding>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AgentFinding] and returns the inserted row.
  ///
  /// The returned [AgentFinding] will have its `id` field set.
  Future<AgentFinding> insertRow(
    _i1.Session session,
    AgentFinding row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AgentFinding>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AgentFinding]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AgentFinding>> update(
    _i1.Session session,
    List<AgentFinding> rows, {
    _i1.ColumnSelections<AgentFindingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AgentFinding>(
      rows,
      columns: columns?.call(AgentFinding.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AgentFinding]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AgentFinding> updateRow(
    _i1.Session session,
    AgentFinding row, {
    _i1.ColumnSelections<AgentFindingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AgentFinding>(
      row,
      columns: columns?.call(AgentFinding.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AgentFinding] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AgentFinding?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AgentFindingUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AgentFinding>(
      id,
      columnValues: columnValues(AgentFinding.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AgentFinding]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AgentFinding>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AgentFindingUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AgentFindingTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AgentFindingTable>? orderBy,
    _i1.OrderByListBuilder<AgentFindingTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AgentFinding>(
      columnValues: columnValues(AgentFinding.t.updateTable),
      where: where(AgentFinding.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AgentFinding.t),
      orderByList: orderByList?.call(AgentFinding.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AgentFinding]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AgentFinding>> delete(
    _i1.Session session,
    List<AgentFinding> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AgentFinding>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AgentFinding].
  Future<AgentFinding> deleteRow(
    _i1.Session session,
    AgentFinding row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AgentFinding>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AgentFinding>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AgentFindingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AgentFinding>(
      where: where(AgentFinding.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AgentFindingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AgentFinding>(
      where: where?.call(AgentFinding.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
