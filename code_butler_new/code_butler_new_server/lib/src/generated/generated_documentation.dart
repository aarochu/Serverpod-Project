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

abstract class GeneratedDocumentation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  GeneratedDocumentation._({
    this.id,
    required this.pullRequestId,
    required this.filePath,
    this.functionName,
    required this.originalCode,
    required this.generatedDoc,
    required this.verificationStatus,
    this.verificationIssues,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GeneratedDocumentation({
    int? id,
    required int pullRequestId,
    required String filePath,
    String? functionName,
    required String originalCode,
    required String generatedDoc,
    required String verificationStatus,
    String? verificationIssues,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _GeneratedDocumentationImpl;

  factory GeneratedDocumentation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GeneratedDocumentation(
      id: jsonSerialization['id'] as int?,
      pullRequestId: jsonSerialization['pullRequestId'] as int,
      filePath: jsonSerialization['filePath'] as String,
      functionName: jsonSerialization['functionName'] as String?,
      originalCode: jsonSerialization['originalCode'] as String,
      generatedDoc: jsonSerialization['generatedDoc'] as String,
      verificationStatus: jsonSerialization['verificationStatus'] as String,
      verificationIssues: jsonSerialization['verificationIssues'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = GeneratedDocumentationTable();

  static const db = GeneratedDocumentationRepository._();

  @override
  int? id;

  int pullRequestId;

  String filePath;

  String? functionName;

  String originalCode;

  String generatedDoc;

  String verificationStatus;

  String? verificationIssues;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [GeneratedDocumentation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GeneratedDocumentation copyWith({
    int? id,
    int? pullRequestId,
    String? filePath,
    String? functionName,
    String? originalCode,
    String? generatedDoc,
    String? verificationStatus,
    String? verificationIssues,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GeneratedDocumentation',
      if (id != null) 'id': id,
      'pullRequestId': pullRequestId,
      'filePath': filePath,
      if (functionName != null) 'functionName': functionName,
      'originalCode': originalCode,
      'generatedDoc': generatedDoc,
      'verificationStatus': verificationStatus,
      if (verificationIssues != null) 'verificationIssues': verificationIssues,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GeneratedDocumentation',
      if (id != null) 'id': id,
      'pullRequestId': pullRequestId,
      'filePath': filePath,
      if (functionName != null) 'functionName': functionName,
      'originalCode': originalCode,
      'generatedDoc': generatedDoc,
      'verificationStatus': verificationStatus,
      if (verificationIssues != null) 'verificationIssues': verificationIssues,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static GeneratedDocumentationInclude include() {
    return GeneratedDocumentationInclude._();
  }

  static GeneratedDocumentationIncludeList includeList({
    _i1.WhereExpressionBuilder<GeneratedDocumentationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GeneratedDocumentationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GeneratedDocumentationTable>? orderByList,
    GeneratedDocumentationInclude? include,
  }) {
    return GeneratedDocumentationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GeneratedDocumentation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(GeneratedDocumentation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GeneratedDocumentationImpl extends GeneratedDocumentation {
  _GeneratedDocumentationImpl({
    int? id,
    required int pullRequestId,
    required String filePath,
    String? functionName,
    required String originalCode,
    required String generatedDoc,
    required String verificationStatus,
    String? verificationIssues,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         pullRequestId: pullRequestId,
         filePath: filePath,
         functionName: functionName,
         originalCode: originalCode,
         generatedDoc: generatedDoc,
         verificationStatus: verificationStatus,
         verificationIssues: verificationIssues,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [GeneratedDocumentation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GeneratedDocumentation copyWith({
    Object? id = _Undefined,
    int? pullRequestId,
    String? filePath,
    Object? functionName = _Undefined,
    String? originalCode,
    String? generatedDoc,
    String? verificationStatus,
    Object? verificationIssues = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GeneratedDocumentation(
      id: id is int? ? id : this.id,
      pullRequestId: pullRequestId ?? this.pullRequestId,
      filePath: filePath ?? this.filePath,
      functionName: functionName is String? ? functionName : this.functionName,
      originalCode: originalCode ?? this.originalCode,
      generatedDoc: generatedDoc ?? this.generatedDoc,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verificationIssues: verificationIssues is String?
          ? verificationIssues
          : this.verificationIssues,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class GeneratedDocumentationUpdateTable
    extends _i1.UpdateTable<GeneratedDocumentationTable> {
  GeneratedDocumentationUpdateTable(super.table);

  _i1.ColumnValue<int, int> pullRequestId(int value) => _i1.ColumnValue(
    table.pullRequestId,
    value,
  );

  _i1.ColumnValue<String, String> filePath(String value) => _i1.ColumnValue(
    table.filePath,
    value,
  );

  _i1.ColumnValue<String, String> functionName(String? value) =>
      _i1.ColumnValue(
        table.functionName,
        value,
      );

  _i1.ColumnValue<String, String> originalCode(String value) => _i1.ColumnValue(
    table.originalCode,
    value,
  );

  _i1.ColumnValue<String, String> generatedDoc(String value) => _i1.ColumnValue(
    table.generatedDoc,
    value,
  );

  _i1.ColumnValue<String, String> verificationStatus(String value) =>
      _i1.ColumnValue(
        table.verificationStatus,
        value,
      );

  _i1.ColumnValue<String, String> verificationIssues(String? value) =>
      _i1.ColumnValue(
        table.verificationIssues,
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

class GeneratedDocumentationTable extends _i1.Table<int?> {
  GeneratedDocumentationTable({super.tableRelation})
    : super(tableName: 'generated_documentation') {
    updateTable = GeneratedDocumentationUpdateTable(this);
    pullRequestId = _i1.ColumnInt(
      'pullRequestId',
      this,
    );
    filePath = _i1.ColumnString(
      'filePath',
      this,
    );
    functionName = _i1.ColumnString(
      'functionName',
      this,
    );
    originalCode = _i1.ColumnString(
      'originalCode',
      this,
    );
    generatedDoc = _i1.ColumnString(
      'generatedDoc',
      this,
    );
    verificationStatus = _i1.ColumnString(
      'verificationStatus',
      this,
    );
    verificationIssues = _i1.ColumnString(
      'verificationIssues',
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

  late final GeneratedDocumentationUpdateTable updateTable;

  late final _i1.ColumnInt pullRequestId;

  late final _i1.ColumnString filePath;

  late final _i1.ColumnString functionName;

  late final _i1.ColumnString originalCode;

  late final _i1.ColumnString generatedDoc;

  late final _i1.ColumnString verificationStatus;

  late final _i1.ColumnString verificationIssues;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    pullRequestId,
    filePath,
    functionName,
    originalCode,
    generatedDoc,
    verificationStatus,
    verificationIssues,
    createdAt,
    updatedAt,
  ];
}

class GeneratedDocumentationInclude extends _i1.IncludeObject {
  GeneratedDocumentationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => GeneratedDocumentation.t;
}

class GeneratedDocumentationIncludeList extends _i1.IncludeList {
  GeneratedDocumentationIncludeList._({
    _i1.WhereExpressionBuilder<GeneratedDocumentationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GeneratedDocumentation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => GeneratedDocumentation.t;
}

class GeneratedDocumentationRepository {
  const GeneratedDocumentationRepository._();

  /// Returns a list of [GeneratedDocumentation]s matching the given query parameters.
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
  Future<List<GeneratedDocumentation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GeneratedDocumentationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GeneratedDocumentationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GeneratedDocumentationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<GeneratedDocumentation>(
      where: where?.call(GeneratedDocumentation.t),
      orderBy: orderBy?.call(GeneratedDocumentation.t),
      orderByList: orderByList?.call(GeneratedDocumentation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [GeneratedDocumentation] matching the given query parameters.
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
  Future<GeneratedDocumentation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GeneratedDocumentationTable>? where,
    int? offset,
    _i1.OrderByBuilder<GeneratedDocumentationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GeneratedDocumentationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<GeneratedDocumentation>(
      where: where?.call(GeneratedDocumentation.t),
      orderBy: orderBy?.call(GeneratedDocumentation.t),
      orderByList: orderByList?.call(GeneratedDocumentation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [GeneratedDocumentation] by its [id] or null if no such row exists.
  Future<GeneratedDocumentation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<GeneratedDocumentation>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [GeneratedDocumentation]s in the list and returns the inserted rows.
  ///
  /// The returned [GeneratedDocumentation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<GeneratedDocumentation>> insert(
    _i1.Session session,
    List<GeneratedDocumentation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<GeneratedDocumentation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [GeneratedDocumentation] and returns the inserted row.
  ///
  /// The returned [GeneratedDocumentation] will have its `id` field set.
  Future<GeneratedDocumentation> insertRow(
    _i1.Session session,
    GeneratedDocumentation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<GeneratedDocumentation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [GeneratedDocumentation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<GeneratedDocumentation>> update(
    _i1.Session session,
    List<GeneratedDocumentation> rows, {
    _i1.ColumnSelections<GeneratedDocumentationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<GeneratedDocumentation>(
      rows,
      columns: columns?.call(GeneratedDocumentation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GeneratedDocumentation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GeneratedDocumentation> updateRow(
    _i1.Session session,
    GeneratedDocumentation row, {
    _i1.ColumnSelections<GeneratedDocumentationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<GeneratedDocumentation>(
      row,
      columns: columns?.call(GeneratedDocumentation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GeneratedDocumentation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GeneratedDocumentation?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<GeneratedDocumentationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<GeneratedDocumentation>(
      id,
      columnValues: columnValues(GeneratedDocumentation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GeneratedDocumentation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<GeneratedDocumentation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<GeneratedDocumentationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<GeneratedDocumentationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GeneratedDocumentationTable>? orderBy,
    _i1.OrderByListBuilder<GeneratedDocumentationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<GeneratedDocumentation>(
      columnValues: columnValues(GeneratedDocumentation.t.updateTable),
      where: where(GeneratedDocumentation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GeneratedDocumentation.t),
      orderByList: orderByList?.call(GeneratedDocumentation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [GeneratedDocumentation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<GeneratedDocumentation>> delete(
    _i1.Session session,
    List<GeneratedDocumentation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<GeneratedDocumentation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [GeneratedDocumentation].
  Future<GeneratedDocumentation> deleteRow(
    _i1.Session session,
    GeneratedDocumentation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GeneratedDocumentation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<GeneratedDocumentation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GeneratedDocumentationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<GeneratedDocumentation>(
      where: where(GeneratedDocumentation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GeneratedDocumentationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<GeneratedDocumentation>(
      where: where?.call(GeneratedDocumentation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
