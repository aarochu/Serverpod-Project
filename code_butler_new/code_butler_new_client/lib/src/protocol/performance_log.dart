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

abstract class PerformanceLog implements _i1.SerializableModel {
  PerformanceLog._({
    this.id,
    required this.agentType,
    this.filePath,
    required this.executionTimeMs,
    this.memoryUsageMB,
    this.queryCount,
    required this.createdAt,
  });

  factory PerformanceLog({
    int? id,
    required String agentType,
    String? filePath,
    required int executionTimeMs,
    double? memoryUsageMB,
    int? queryCount,
    required DateTime createdAt,
  }) = _PerformanceLogImpl;

  factory PerformanceLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return PerformanceLog(
      id: jsonSerialization['id'] as int?,
      agentType: jsonSerialization['agentType'] as String,
      filePath: jsonSerialization['filePath'] as String?,
      executionTimeMs: jsonSerialization['executionTimeMs'] as int,
      memoryUsageMB: (jsonSerialization['memoryUsageMB'] as num?)?.toDouble(),
      queryCount: jsonSerialization['queryCount'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String agentType;

  String? filePath;

  int executionTimeMs;

  double? memoryUsageMB;

  int? queryCount;

  DateTime createdAt;

  /// Returns a shallow copy of this [PerformanceLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PerformanceLog copyWith({
    int? id,
    String? agentType,
    String? filePath,
    int? executionTimeMs,
    double? memoryUsageMB,
    int? queryCount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PerformanceLog',
      if (id != null) 'id': id,
      'agentType': agentType,
      if (filePath != null) 'filePath': filePath,
      'executionTimeMs': executionTimeMs,
      if (memoryUsageMB != null) 'memoryUsageMB': memoryUsageMB,
      if (queryCount != null) 'queryCount': queryCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PerformanceLogImpl extends PerformanceLog {
  _PerformanceLogImpl({
    int? id,
    required String agentType,
    String? filePath,
    required int executionTimeMs,
    double? memoryUsageMB,
    int? queryCount,
    required DateTime createdAt,
  }) : super._(
         id: id,
         agentType: agentType,
         filePath: filePath,
         executionTimeMs: executionTimeMs,
         memoryUsageMB: memoryUsageMB,
         queryCount: queryCount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PerformanceLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PerformanceLog copyWith({
    Object? id = _Undefined,
    String? agentType,
    Object? filePath = _Undefined,
    int? executionTimeMs,
    Object? memoryUsageMB = _Undefined,
    Object? queryCount = _Undefined,
    DateTime? createdAt,
  }) {
    return PerformanceLog(
      id: id is int? ? id : this.id,
      agentType: agentType ?? this.agentType,
      filePath: filePath is String? ? filePath : this.filePath,
      executionTimeMs: executionTimeMs ?? this.executionTimeMs,
      memoryUsageMB: memoryUsageMB is double?
          ? memoryUsageMB
          : this.memoryUsageMB,
      queryCount: queryCount is int? ? queryCount : this.queryCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
