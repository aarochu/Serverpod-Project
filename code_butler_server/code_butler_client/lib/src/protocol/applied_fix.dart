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

abstract class AppliedFix
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AppliedFix._({
    required this.findingId,
    required this.fixCode,
    required this.appliedAt,
    required this.status,
    this.prUrl,
  });

  factory AppliedFix({
    required int findingId,
    required String fixCode,
    required DateTime appliedAt,
    required String status,
    String? prUrl,
  }) = _AppliedFixImpl;

  factory AppliedFix.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppliedFix(
      findingId: jsonSerialization['findingId'] as int,
      fixCode: jsonSerialization['fixCode'] as String,
      appliedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['appliedAt'],
      ),
      status: jsonSerialization['status'] as String,
      prUrl: jsonSerialization['prUrl'] as String?,
    );
  }

  int findingId;

  String fixCode;

  DateTime appliedAt;

  String status;

  String? prUrl;

  /// Returns a shallow copy of this [AppliedFix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppliedFix copyWith({
    int? findingId,
    String? fixCode,
    DateTime? appliedAt,
    String? status,
    String? prUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppliedFix',
      'findingId': findingId,
      'fixCode': fixCode,
      'appliedAt': appliedAt.toJson(),
      'status': status,
      if (prUrl != null) 'prUrl': prUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppliedFix',
      'findingId': findingId,
      'fixCode': fixCode,
      'appliedAt': appliedAt.toJson(),
      'status': status,
      if (prUrl != null) 'prUrl': prUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppliedFixImpl extends AppliedFix {
  _AppliedFixImpl({
    required int findingId,
    required String fixCode,
    required DateTime appliedAt,
    required String status,
    String? prUrl,
  }) : super._(
         findingId: findingId,
         fixCode: fixCode,
         appliedAt: appliedAt,
         status: status,
         prUrl: prUrl,
       );

  /// Returns a shallow copy of this [AppliedFix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppliedFix copyWith({
    int? findingId,
    String? fixCode,
    DateTime? appliedAt,
    String? status,
    Object? prUrl = _Undefined,
  }) {
    return AppliedFix(
      findingId: findingId ?? this.findingId,
      fixCode: fixCode ?? this.fixCode,
      appliedAt: appliedAt ?? this.appliedAt,
      status: status ?? this.status,
      prUrl: prUrl is String? ? prUrl : this.prUrl,
    );
  }
}
