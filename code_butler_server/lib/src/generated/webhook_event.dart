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

abstract class WebhookEvent
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  WebhookEvent._({
    required this.eventType,
    required this.payload,
    this.signature,
    required this.processed,
    required this.createdAt,
  });

  factory WebhookEvent({
    required String eventType,
    required String payload,
    String? signature,
    required bool processed,
    required DateTime createdAt,
  }) = _WebhookEventImpl;

  factory WebhookEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return WebhookEvent(
      eventType: jsonSerialization['eventType'] as String,
      payload: jsonSerialization['payload'] as String,
      signature: jsonSerialization['signature'] as String?,
      processed: jsonSerialization['processed'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String eventType;

  String payload;

  String? signature;

  bool processed;

  DateTime createdAt;

  /// Returns a shallow copy of this [WebhookEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WebhookEvent copyWith({
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
      'eventType': eventType,
      'payload': payload,
      if (signature != null) 'signature': signature,
      'processed': processed,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WebhookEvent',
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
    required String eventType,
    required String payload,
    String? signature,
    required bool processed,
    required DateTime createdAt,
  }) : super._(
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
    String? eventType,
    String? payload,
    Object? signature = _Undefined,
    bool? processed,
    DateTime? createdAt,
  }) {
    return WebhookEvent(
      eventType: eventType ?? this.eventType,
      payload: payload ?? this.payload,
      signature: signature is String? ? signature : this.signature,
      processed: processed ?? this.processed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
