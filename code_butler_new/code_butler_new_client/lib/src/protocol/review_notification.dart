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

abstract class ReviewNotification implements _i1.SerializableModel {
  ReviewNotification._({
    this.id,
    required this.userId,
    required this.reviewSessionId,
    required this.type,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory ReviewNotification({
    int? id,
    required String userId,
    required int reviewSessionId,
    required String type,
    required String message,
    required bool read,
    required DateTime createdAt,
  }) = _ReviewNotificationImpl;

  factory ReviewNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewNotification(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      reviewSessionId: jsonSerialization['reviewSessionId'] as int,
      type: jsonSerialization['type'] as String,
      message: jsonSerialization['message'] as String,
      read: jsonSerialization['read'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  int reviewSessionId;

  String type;

  String message;

  bool read;

  DateTime createdAt;

  /// Returns a shallow copy of this [ReviewNotification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReviewNotification copyWith({
    int? id,
    String? userId,
    int? reviewSessionId,
    String? type,
    String? message,
    bool? read,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewNotification',
      if (id != null) 'id': id,
      'userId': userId,
      'reviewSessionId': reviewSessionId,
      'type': type,
      'message': message,
      'read': read,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewNotificationImpl extends ReviewNotification {
  _ReviewNotificationImpl({
    int? id,
    required String userId,
    required int reviewSessionId,
    required String type,
    required String message,
    required bool read,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         reviewSessionId: reviewSessionId,
         type: type,
         message: message,
         read: read,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReviewNotification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReviewNotification copyWith({
    Object? id = _Undefined,
    String? userId,
    int? reviewSessionId,
    String? type,
    String? message,
    bool? read,
    DateTime? createdAt,
  }) {
    return ReviewNotification(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      reviewSessionId: reviewSessionId ?? this.reviewSessionId,
      type: type ?? this.type,
      message: message ?? this.message,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
