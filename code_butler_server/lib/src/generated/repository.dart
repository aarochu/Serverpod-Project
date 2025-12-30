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
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Repository._({
    required this.name,
    required this.url,
    required this.owner,
    required this.defaultBranch,
    this.lastReviewedAt,
  });

  factory Repository({
    required String name,
    required String url,
    required String owner,
    required String defaultBranch,
    DateTime? lastReviewedAt,
  }) = _RepositoryImpl;

  factory Repository.fromJson(Map<String, dynamic> jsonSerialization) {
    return Repository(
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

  String name;

  String url;

  String owner;

  String defaultBranch;

  DateTime? lastReviewedAt;

  /// Returns a shallow copy of this [Repository]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Repository copyWith({
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
    required String name,
    required String url,
    required String owner,
    required String defaultBranch,
    DateTime? lastReviewedAt,
  }) : super._(
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
    String? name,
    String? url,
    String? owner,
    String? defaultBranch,
    Object? lastReviewedAt = _Undefined,
  }) {
    return Repository(
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
