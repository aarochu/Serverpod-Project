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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class Repository implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String url;

  String owner;

  String defaultBranch;

  DateTime? lastReviewedAt;

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
