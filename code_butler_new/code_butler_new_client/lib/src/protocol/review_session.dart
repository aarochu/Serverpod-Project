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

abstract class ReviewSession implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
