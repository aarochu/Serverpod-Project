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

abstract class PullRequest implements _i1.SerializableModel {
  PullRequest._({
    this.id,
    required this.repositoryId,
    required this.prNumber,
    required this.title,
    required this.status,
    required this.baseBranch,
    required this.headBranch,
    required this.filesChanged,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PullRequest({
    int? id,
    required int repositoryId,
    required int prNumber,
    required String title,
    required String status,
    required String baseBranch,
    required String headBranch,
    required int filesChanged,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PullRequestImpl;

  factory PullRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return PullRequest(
      id: jsonSerialization['id'] as int?,
      repositoryId: jsonSerialization['repositoryId'] as int,
      prNumber: jsonSerialization['prNumber'] as int,
      title: jsonSerialization['title'] as String,
      status: jsonSerialization['status'] as String,
      baseBranch: jsonSerialization['baseBranch'] as String,
      headBranch: jsonSerialization['headBranch'] as String,
      filesChanged: jsonSerialization['filesChanged'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int repositoryId;

  int prNumber;

  String title;

  String status;

  String baseBranch;

  String headBranch;

  int filesChanged;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [PullRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PullRequest copyWith({
    int? id,
    int? repositoryId,
    int? prNumber,
    String? title,
    String? status,
    String? baseBranch,
    String? headBranch,
    int? filesChanged,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PullRequest',
      if (id != null) 'id': id,
      'repositoryId': repositoryId,
      'prNumber': prNumber,
      'title': title,
      'status': status,
      'baseBranch': baseBranch,
      'headBranch': headBranch,
      'filesChanged': filesChanged,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PullRequestImpl extends PullRequest {
  _PullRequestImpl({
    int? id,
    required int repositoryId,
    required int prNumber,
    required String title,
    required String status,
    required String baseBranch,
    required String headBranch,
    required int filesChanged,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         repositoryId: repositoryId,
         prNumber: prNumber,
         title: title,
         status: status,
         baseBranch: baseBranch,
         headBranch: headBranch,
         filesChanged: filesChanged,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PullRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PullRequest copyWith({
    Object? id = _Undefined,
    int? repositoryId,
    int? prNumber,
    String? title,
    String? status,
    String? baseBranch,
    String? headBranch,
    int? filesChanged,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PullRequest(
      id: id is int? ? id : this.id,
      repositoryId: repositoryId ?? this.repositoryId,
      prNumber: prNumber ?? this.prNumber,
      title: title ?? this.title,
      status: status ?? this.status,
      baseBranch: baseBranch ?? this.baseBranch,
      headBranch: headBranch ?? this.headBranch,
      filesChanged: filesChanged ?? this.filesChanged,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
