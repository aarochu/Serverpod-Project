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

abstract class AgentFinding implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
