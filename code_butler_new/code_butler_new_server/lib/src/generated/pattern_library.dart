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

abstract class PatternLibrary
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PatternLibrary._({
    this.id,
    required this.pattern,
    required this.language,
    required this.category,
    required this.fixTemplate,
    required this.confidence,
    required this.occurrenceCount,
    required this.lastSeen,
  });

  factory PatternLibrary({
    int? id,
    required String pattern,
    required String language,
    required String category,
    required String fixTemplate,
    required double confidence,
    required int occurrenceCount,
    required DateTime lastSeen,
  }) = _PatternLibraryImpl;

  factory PatternLibrary.fromJson(Map<String, dynamic> jsonSerialization) {
    return PatternLibrary(
      id: jsonSerialization['id'] as int?,
      pattern: jsonSerialization['pattern'] as String,
      language: jsonSerialization['language'] as String,
      category: jsonSerialization['category'] as String,
      fixTemplate: jsonSerialization['fixTemplate'] as String,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      occurrenceCount: jsonSerialization['occurrenceCount'] as int,
      lastSeen: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastSeen'],
      ),
    );
  }

  static final t = PatternLibraryTable();

  static const db = PatternLibraryRepository._();

  @override
  int? id;

  String pattern;

  String language;

  String category;

  String fixTemplate;

  double confidence;

  int occurrenceCount;

  DateTime lastSeen;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PatternLibrary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PatternLibrary copyWith({
    int? id,
    String? pattern,
    String? language,
    String? category,
    String? fixTemplate,
    double? confidence,
    int? occurrenceCount,
    DateTime? lastSeen,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PatternLibrary',
      if (id != null) 'id': id,
      'pattern': pattern,
      'language': language,
      'category': category,
      'fixTemplate': fixTemplate,
      'confidence': confidence,
      'occurrenceCount': occurrenceCount,
      'lastSeen': lastSeen.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PatternLibrary',
      if (id != null) 'id': id,
      'pattern': pattern,
      'language': language,
      'category': category,
      'fixTemplate': fixTemplate,
      'confidence': confidence,
      'occurrenceCount': occurrenceCount,
      'lastSeen': lastSeen.toJson(),
    };
  }

  static PatternLibraryInclude include() {
    return PatternLibraryInclude._();
  }

  static PatternLibraryIncludeList includeList({
    _i1.WhereExpressionBuilder<PatternLibraryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PatternLibraryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PatternLibraryTable>? orderByList,
    PatternLibraryInclude? include,
  }) {
    return PatternLibraryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PatternLibrary.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PatternLibrary.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PatternLibraryImpl extends PatternLibrary {
  _PatternLibraryImpl({
    int? id,
    required String pattern,
    required String language,
    required String category,
    required String fixTemplate,
    required double confidence,
    required int occurrenceCount,
    required DateTime lastSeen,
  }) : super._(
         id: id,
         pattern: pattern,
         language: language,
         category: category,
         fixTemplate: fixTemplate,
         confidence: confidence,
         occurrenceCount: occurrenceCount,
         lastSeen: lastSeen,
       );

  /// Returns a shallow copy of this [PatternLibrary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PatternLibrary copyWith({
    Object? id = _Undefined,
    String? pattern,
    String? language,
    String? category,
    String? fixTemplate,
    double? confidence,
    int? occurrenceCount,
    DateTime? lastSeen,
  }) {
    return PatternLibrary(
      id: id is int? ? id : this.id,
      pattern: pattern ?? this.pattern,
      language: language ?? this.language,
      category: category ?? this.category,
      fixTemplate: fixTemplate ?? this.fixTemplate,
      confidence: confidence ?? this.confidence,
      occurrenceCount: occurrenceCount ?? this.occurrenceCount,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}

class PatternLibraryUpdateTable extends _i1.UpdateTable<PatternLibraryTable> {
  PatternLibraryUpdateTable(super.table);

  _i1.ColumnValue<String, String> pattern(String value) => _i1.ColumnValue(
    table.pattern,
    value,
  );

  _i1.ColumnValue<String, String> language(String value) => _i1.ColumnValue(
    table.language,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> fixTemplate(String value) => _i1.ColumnValue(
    table.fixTemplate,
    value,
  );

  _i1.ColumnValue<double, double> confidence(double value) => _i1.ColumnValue(
    table.confidence,
    value,
  );

  _i1.ColumnValue<int, int> occurrenceCount(int value) => _i1.ColumnValue(
    table.occurrenceCount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastSeen(DateTime value) =>
      _i1.ColumnValue(
        table.lastSeen,
        value,
      );
}

class PatternLibraryTable extends _i1.Table<int?> {
  PatternLibraryTable({super.tableRelation})
    : super(tableName: 'pattern_libraries') {
    updateTable = PatternLibraryUpdateTable(this);
    pattern = _i1.ColumnString(
      'pattern',
      this,
    );
    language = _i1.ColumnString(
      'language',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    fixTemplate = _i1.ColumnString(
      'fixTemplate',
      this,
    );
    confidence = _i1.ColumnDouble(
      'confidence',
      this,
    );
    occurrenceCount = _i1.ColumnInt(
      'occurrenceCount',
      this,
    );
    lastSeen = _i1.ColumnDateTime(
      'lastSeen',
      this,
    );
  }

  late final PatternLibraryUpdateTable updateTable;

  late final _i1.ColumnString pattern;

  late final _i1.ColumnString language;

  late final _i1.ColumnString category;

  late final _i1.ColumnString fixTemplate;

  late final _i1.ColumnDouble confidence;

  late final _i1.ColumnInt occurrenceCount;

  late final _i1.ColumnDateTime lastSeen;

  @override
  List<_i1.Column> get columns => [
    id,
    pattern,
    language,
    category,
    fixTemplate,
    confidence,
    occurrenceCount,
    lastSeen,
  ];
}

class PatternLibraryInclude extends _i1.IncludeObject {
  PatternLibraryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PatternLibrary.t;
}

class PatternLibraryIncludeList extends _i1.IncludeList {
  PatternLibraryIncludeList._({
    _i1.WhereExpressionBuilder<PatternLibraryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PatternLibrary.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PatternLibrary.t;
}

class PatternLibraryRepository {
  const PatternLibraryRepository._();

  /// Returns a list of [PatternLibrary]s matching the given query parameters.
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
  Future<List<PatternLibrary>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PatternLibraryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PatternLibraryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PatternLibraryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PatternLibrary>(
      where: where?.call(PatternLibrary.t),
      orderBy: orderBy?.call(PatternLibrary.t),
      orderByList: orderByList?.call(PatternLibrary.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PatternLibrary] matching the given query parameters.
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
  Future<PatternLibrary?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PatternLibraryTable>? where,
    int? offset,
    _i1.OrderByBuilder<PatternLibraryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PatternLibraryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PatternLibrary>(
      where: where?.call(PatternLibrary.t),
      orderBy: orderBy?.call(PatternLibrary.t),
      orderByList: orderByList?.call(PatternLibrary.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PatternLibrary] by its [id] or null if no such row exists.
  Future<PatternLibrary?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PatternLibrary>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PatternLibrary]s in the list and returns the inserted rows.
  ///
  /// The returned [PatternLibrary]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PatternLibrary>> insert(
    _i1.Session session,
    List<PatternLibrary> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PatternLibrary>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PatternLibrary] and returns the inserted row.
  ///
  /// The returned [PatternLibrary] will have its `id` field set.
  Future<PatternLibrary> insertRow(
    _i1.Session session,
    PatternLibrary row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PatternLibrary>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PatternLibrary]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PatternLibrary>> update(
    _i1.Session session,
    List<PatternLibrary> rows, {
    _i1.ColumnSelections<PatternLibraryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PatternLibrary>(
      rows,
      columns: columns?.call(PatternLibrary.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PatternLibrary]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PatternLibrary> updateRow(
    _i1.Session session,
    PatternLibrary row, {
    _i1.ColumnSelections<PatternLibraryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PatternLibrary>(
      row,
      columns: columns?.call(PatternLibrary.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PatternLibrary] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PatternLibrary?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PatternLibraryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PatternLibrary>(
      id,
      columnValues: columnValues(PatternLibrary.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PatternLibrary]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PatternLibrary>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PatternLibraryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PatternLibraryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PatternLibraryTable>? orderBy,
    _i1.OrderByListBuilder<PatternLibraryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PatternLibrary>(
      columnValues: columnValues(PatternLibrary.t.updateTable),
      where: where(PatternLibrary.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PatternLibrary.t),
      orderByList: orderByList?.call(PatternLibrary.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PatternLibrary]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PatternLibrary>> delete(
    _i1.Session session,
    List<PatternLibrary> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PatternLibrary>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PatternLibrary].
  Future<PatternLibrary> deleteRow(
    _i1.Session session,
    PatternLibrary row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PatternLibrary>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PatternLibrary>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PatternLibraryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PatternLibrary>(
      where: where(PatternLibrary.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PatternLibraryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PatternLibrary>(
      where: where?.call(PatternLibrary.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
