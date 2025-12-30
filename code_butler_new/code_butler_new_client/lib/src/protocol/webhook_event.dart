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

abstract class WebhookEvent implements _i1.SerializableModel {
  WebhookEvent._({
    this.id,
    required this.eventType,
    required this.payload,
    this.signature,
    required this.processed,
    required this.createdAt,
  });

  factory WebhookEvent({
    int? id,
    required String eventType,
    required String payload,
    String? signature,
    required bool processed,
    required DateTime createdAt,
  }) = _WebhookEventImpl;

  factory WebhookEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return WebhookEvent(
      id: jsonSerialization['id'] as int?,
      eventType: jsonSerialization['eventType'] as String,
      payload: jsonSerialization['payload'] as String,
      signature: jsonSerialization['signature'] as String?,
      processed: jsonSerialization['processed'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String eventType;

  String payload;

  String? signature;

  bool processed;

  DateTime createdAt;

  /// Returns a shallow copy of this [WebhookEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WebhookEvent copyWith({
    int? id,
    String? eventType,
    String? payload,
    String? signature,
    bool? processed,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WebhookEvent',
      if (id != null) 'id': id,
      'eventType': eventType,
      'payload': payload,
      if (signature != null) 'signature': signature,
      'processed': processed,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WebhookEventImpl extends WebhookEvent {
  _WebhookEventImpl({
    int? id,
    required String eventType,
    required String payload,
    String? signature,
    required bool processed,
    required DateTime createdAt,
  }) : super._(
         id: id,
         eventType: eventType,
         payload: payload,
         signature: signature,
         processed: processed,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [WebhookEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WebhookEvent copyWith({
    Object? id = _Undefined,
    String? eventType,
    String? payload,
    Object? signature = _Undefined,
    bool? processed,
    DateTime? createdAt,
  }) {
    return WebhookEvent(
      id: id is int? ? id : this.id,
      eventType: eventType ?? this.eventType,
      payload: payload ?? this.payload,
      signature: signature is String? ? signature : this.signature,
      processed: processed ?? this.processed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
