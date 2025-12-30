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

abstract class ReviewJob
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReviewJob._({
    required this.pullRequestId,
    required this.status,
    required this.priority,
    required this.retryCount,
    this.errorMessage,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });

  factory ReviewJob({
    required int pullRequestId,
    required String status,
    required int priority,
    required int retryCount,
    String? errorMessage,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _ReviewJobImpl;

  factory ReviewJob.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewJob(
      pullRequestId: jsonSerialization['pullRequestId'] as int,
      status: jsonSerialization['status'] as String,
      priority: jsonSerialization['priority'] as int,
      retryCount: jsonSerialization['retryCount'] as int,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  int pullRequestId;

  String status;

  int priority;

  int retryCount;

  String? errorMessage;

  DateTime createdAt;

  DateTime? startedAt;

  DateTime? completedAt;

  /// Returns a shallow copy of this [ReviewJob]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReviewJob copyWith({
    int? pullRequestId,
    String? status,
    int? priority,
    int? retryCount,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewJob',
      'pullRequestId': pullRequestId,
      'status': status,
      'priority': priority,
      'retryCount': retryCount,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewJob',
      'pullRequestId': pullRequestId,
      'status': status,
      'priority': priority,
      'retryCount': retryCount,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewJobImpl extends ReviewJob {
  _ReviewJobImpl({
    required int pullRequestId,
    required String status,
    required int priority,
    required int retryCount,
    String? errorMessage,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) : super._(
         pullRequestId: pullRequestId,
         status: status,
         priority: priority,
         retryCount: retryCount,
         errorMessage: errorMessage,
         createdAt: createdAt,
         startedAt: startedAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [ReviewJob]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReviewJob copyWith({
    int? pullRequestId,
    String? status,
    int? priority,
    int? retryCount,
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
    Object? startedAt = _Undefined,
    Object? completedAt = _Undefined,
  }) {
    return ReviewJob(
      pullRequestId: pullRequestId ?? this.pullRequestId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt is DateTime? ? startedAt : this.startedAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}
