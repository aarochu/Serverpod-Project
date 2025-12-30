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
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  GeneratedDocumentation._({
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

  int pullRequestId;

  String filePath;

  String? functionName;

  String originalCode;

  String generatedDoc;

  String verificationStatus;

  String? verificationIssues;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [GeneratedDocumentation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GeneratedDocumentation copyWith({
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
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GeneratedDocumentationImpl extends GeneratedDocumentation {
  _GeneratedDocumentationImpl({
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
