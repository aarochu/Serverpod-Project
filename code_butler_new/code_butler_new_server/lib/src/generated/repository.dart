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

abstract class Repository
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Repository._({
    this.id,
    required this.name,
    required this.url,
    required this.owner,
    required this.defaultBranch,
    this.lastReviewedAt,
  });

  factory Repository({
    int? id,
    required String name,
    required String url,
    required String owner,
    required String defaultBranch,
    DateTime? lastReviewedAt,
  }) = _RepositoryImpl;

  factory Repository.fromJson(Map<String, dynamic> jsonSerialization) {
    return Repository(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      url: jsonSerialization['url'] as String,
      owner: jsonSerialization['owner'] as String,
      defaultBranch: jsonSerialization['defaultBranch'] as String,
      lastReviewedAt: jsonSerialization['lastReviewedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastReviewedAt'],
            ),
    );
  }

  static final t = RepositoryTable();

  static const db = RepositoryRepository._();

  @override
  int? id;

  String name;

  String url;

  String owner;

  String defaultBranch;

  DateTime? lastReviewedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Repository]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Repository copyWith({
    int? id,
    String? name,
    String? url,
    String? owner,
    String? defaultBranch,
    DateTime? lastReviewedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Repository',
      if (id != null) 'id': id,
      'name': name,
      'url': url,
      'owner': owner,
      'defaultBranch': defaultBranch,
      if (lastReviewedAt != null) 'lastReviewedAt': lastReviewedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Repository',
      if (id != null) 'id': id,
      'name': name,
      'url': url,
      'owner': owner,
      'defaultBranch': defaultBranch,
      if (lastReviewedAt != null) 'lastReviewedAt': lastReviewedAt?.toJson(),
    };
  }

  static RepositoryInclude include() {
    return RepositoryInclude._();
  }

  static RepositoryIncludeList includeList({
    _i1.WhereExpressionBuilder<RepositoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RepositoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RepositoryTable>? orderByList,
    RepositoryInclude? include,
  }) {
    return RepositoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Repository.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Repository.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RepositoryImpl extends Repository {
  _RepositoryImpl({
    int? id,
    required String name,
    required String url,
    required String owner,
    required String defaultBranch,
    DateTime? lastReviewedAt,
  }) : super._(
         id: id,
         name: name,
         url: url,
         owner: owner,
         defaultBranch: defaultBranch,
         lastReviewedAt: lastReviewedAt,
       );

  /// Returns a shallow copy of this [Repository]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Repository copyWith({
    Object? id = _Undefined,
    String? name,
    String? url,
    String? owner,
    String? defaultBranch,
    Object? lastReviewedAt = _Undefined,
  }) {
    return Repository(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      owner: owner ?? this.owner,
      defaultBranch: defaultBranch ?? this.defaultBranch,
      lastReviewedAt: lastReviewedAt is DateTime?
          ? lastReviewedAt
          : this.lastReviewedAt,
    );
  }
}

class RepositoryUpdateTable extends _i1.UpdateTable<RepositoryTable> {
  RepositoryUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> url(String value) => _i1.ColumnValue(
    table.url,
    value,
  );

  _i1.ColumnValue<String, String> owner(String value) => _i1.ColumnValue(
    table.owner,
    value,
  );

  _i1.ColumnValue<String, String> defaultBranch(String value) =>
      _i1.ColumnValue(
        table.defaultBranch,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastReviewedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastReviewedAt,
        value,
      );
}

class RepositoryTable extends _i1.Table<int?> {
  RepositoryTable({super.tableRelation}) : super(tableName: 'repositories') {
    updateTable = RepositoryUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    url = _i1.ColumnString(
      'url',
      this,
    );
    owner = _i1.ColumnString(
      'owner',
      this,
    );
    defaultBranch = _i1.ColumnString(
      'defaultBranch',
      this,
    );
    lastReviewedAt = _i1.ColumnDateTime(
      'lastReviewedAt',
      this,
    );
  }

  late final RepositoryUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString url;

  late final _i1.ColumnString owner;

  late final _i1.ColumnString defaultBranch;

  late final _i1.ColumnDateTime lastReviewedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    url,
    owner,
    defaultBranch,
    lastReviewedAt,
  ];
}

class RepositoryInclude extends _i1.IncludeObject {
  RepositoryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Repository.t;
}

class RepositoryIncludeList extends _i1.IncludeList {
  RepositoryIncludeList._({
    _i1.WhereExpressionBuilder<RepositoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Repository.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Repository.t;
}

class RepositoryRepository {
  const RepositoryRepository._();

  /// Returns a list of [Repository]s matching the given query parameters.
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
  Future<List<Repository>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RepositoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RepositoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RepositoryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Repository>(
      where: where?.call(Repository.t),
      orderBy: orderBy?.call(Repository.t),
      orderByList: orderByList?.call(Repository.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Repository] matching the given query parameters.
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
  Future<Repository?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RepositoryTable>? where,
    int? offset,
    _i1.OrderByBuilder<RepositoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RepositoryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Repository>(
      where: where?.call(Repository.t),
      orderBy: orderBy?.call(Repository.t),
      orderByList: orderByList?.call(Repository.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Repository] by its [id] or null if no such row exists.
  Future<Repository?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Repository>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Repository]s in the list and returns the inserted rows.
  ///
  /// The returned [Repository]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Repository>> insert(
    _i1.Session session,
    List<Repository> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Repository>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Repository] and returns the inserted row.
  ///
  /// The returned [Repository] will have its `id` field set.
  Future<Repository> insertRow(
    _i1.Session session,
    Repository row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Repository>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Repository]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Repository>> update(
    _i1.Session session,
    List<Repository> rows, {
    _i1.ColumnSelections<RepositoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Repository>(
      rows,
      columns: columns?.call(Repository.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Repository]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Repository> updateRow(
    _i1.Session session,
    Repository row, {
    _i1.ColumnSelections<RepositoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Repository>(
      row,
      columns: columns?.call(Repository.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Repository] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Repository?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<RepositoryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Repository>(
      id,
      columnValues: columnValues(Repository.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Repository]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Repository>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RepositoryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RepositoryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RepositoryTable>? orderBy,
    _i1.OrderByListBuilder<RepositoryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Repository>(
      columnValues: columnValues(Repository.t.updateTable),
      where: where(Repository.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Repository.t),
      orderByList: orderByList?.call(Repository.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Repository]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Repository>> delete(
    _i1.Session session,
    List<Repository> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Repository>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Repository].
  Future<Repository> deleteRow(
    _i1.Session session,
    Repository row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Repository>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Repository>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RepositoryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Repository>(
      where: where(Repository.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RepositoryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Repository>(
      where: where?.call(Repository.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
