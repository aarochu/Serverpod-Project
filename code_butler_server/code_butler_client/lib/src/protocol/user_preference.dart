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

abstract class UserPreference
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UserPreference._({
    required this.userId,
    required this.findingType,
    required this.action,
    required this.frequency,
    required this.lastUpdated,
  });

  factory UserPreference({
    required String userId,
    required String findingType,
    required String action,
    required int frequency,
    required DateTime lastUpdated,
  }) = _UserPreferenceImpl;

  factory UserPreference.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserPreference(
      userId: jsonSerialization['userId'] as String,
      findingType: jsonSerialization['findingType'] as String,
      action: jsonSerialization['action'] as String,
      frequency: jsonSerialization['frequency'] as int,
      lastUpdated: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastUpdated'],
      ),
    );
  }

  String userId;

  String findingType;

  String action;

  int frequency;

  DateTime lastUpdated;

  /// Returns a shallow copy of this [UserPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserPreference copyWith({
    String? userId,
    String? findingType,
    String? action,
    int? frequency,
    DateTime? lastUpdated,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserPreference',
      'userId': userId,
      'findingType': findingType,
      'action': action,
      'frequency': frequency,
      'lastUpdated': lastUpdated.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserPreference',
      'userId': userId,
      'findingType': findingType,
      'action': action,
      'frequency': frequency,
      'lastUpdated': lastUpdated.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UserPreferenceImpl extends UserPreference {
  _UserPreferenceImpl({
    required String userId,
    required String findingType,
    required String action,
    required int frequency,
    required DateTime lastUpdated,
  }) : super._(
         userId: userId,
         findingType: findingType,
         action: action,
         frequency: frequency,
         lastUpdated: lastUpdated,
       );

  /// Returns a shallow copy of this [UserPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserPreference copyWith({
    String? userId,
    String? findingType,
    String? action,
    int? frequency,
    DateTime? lastUpdated,
  }) {
    return UserPreference(
      userId: userId ?? this.userId,
      findingType: findingType ?? this.findingType,
      action: action ?? this.action,
      frequency: frequency ?? this.frequency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
