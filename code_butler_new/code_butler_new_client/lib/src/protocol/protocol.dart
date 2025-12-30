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
import 'agent_finding.dart' as _i2;
import 'applied_fix.dart' as _i3;
import 'generated_documentation.dart' as _i4;
import 'greetings/greeting.dart' as _i5;
import 'pattern_library.dart' as _i6;
import 'performance_log.dart' as _i7;
import 'pull_request.dart' as _i8;
import 'repository.dart' as _i9;
import 'review_job.dart' as _i10;
import 'review_notification.dart' as _i11;
import 'review_session.dart' as _i12;
import 'user_preference.dart' as _i13;
import 'webhook_event.dart' as _i14;
import 'package:code_butler_new_client/src/protocol/review_notification.dart'
    as _i15;
import 'package:code_butler_new_client/src/protocol/pull_request.dart' as _i16;
import 'package:code_butler_new_client/src/protocol/repository.dart' as _i17;
import 'package:code_butler_new_client/src/protocol/agent_finding.dart' as _i18;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i19;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i20;
export 'agent_finding.dart';
export 'applied_fix.dart';
export 'generated_documentation.dart';
export 'greetings/greeting.dart';
export 'pattern_library.dart';
export 'performance_log.dart';
export 'pull_request.dart';
export 'repository.dart';
export 'review_job.dart';
export 'review_notification.dart';
export 'review_session.dart';
export 'user_preference.dart';
export 'webhook_event.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AgentFinding) {
      return _i2.AgentFinding.fromJson(data) as T;
    }
    if (t == _i3.AppliedFix) {
      return _i3.AppliedFix.fromJson(data) as T;
    }
    if (t == _i4.GeneratedDocumentation) {
      return _i4.GeneratedDocumentation.fromJson(data) as T;
    }
    if (t == _i5.Greeting) {
      return _i5.Greeting.fromJson(data) as T;
    }
    if (t == _i6.PatternLibrary) {
      return _i6.PatternLibrary.fromJson(data) as T;
    }
    if (t == _i7.PerformanceLog) {
      return _i7.PerformanceLog.fromJson(data) as T;
    }
    if (t == _i8.PullRequest) {
      return _i8.PullRequest.fromJson(data) as T;
    }
    if (t == _i9.Repository) {
      return _i9.Repository.fromJson(data) as T;
    }
    if (t == _i10.ReviewJob) {
      return _i10.ReviewJob.fromJson(data) as T;
    }
    if (t == _i11.ReviewNotification) {
      return _i11.ReviewNotification.fromJson(data) as T;
    }
    if (t == _i12.ReviewSession) {
      return _i12.ReviewSession.fromJson(data) as T;
    }
    if (t == _i13.UserPreference) {
      return _i13.UserPreference.fromJson(data) as T;
    }
    if (t == _i14.WebhookEvent) {
      return _i14.WebhookEvent.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AgentFinding?>()) {
      return (data != null ? _i2.AgentFinding.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AppliedFix?>()) {
      return (data != null ? _i3.AppliedFix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.GeneratedDocumentation?>()) {
      return (data != null ? _i4.GeneratedDocumentation.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.Greeting?>()) {
      return (data != null ? _i5.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.PatternLibrary?>()) {
      return (data != null ? _i6.PatternLibrary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.PerformanceLog?>()) {
      return (data != null ? _i7.PerformanceLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PullRequest?>()) {
      return (data != null ? _i8.PullRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Repository?>()) {
      return (data != null ? _i9.Repository.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ReviewJob?>()) {
      return (data != null ? _i10.ReviewJob.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ReviewNotification?>()) {
      return (data != null ? _i11.ReviewNotification.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.ReviewSession?>()) {
      return (data != null ? _i12.ReviewSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.UserPreference?>()) {
      return (data != null ? _i13.UserPreference.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.WebhookEvent?>()) {
      return (data != null ? _i14.WebhookEvent.fromJson(data) : null) as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<Map<String, dynamic>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, dynamic>>(e))
              .toList()
          as T;
    }
    if (t == List<_i15.ReviewNotification>) {
      return (data as List)
              .map((e) => deserialize<_i15.ReviewNotification>(e))
              .toList()
          as T;
    }
    if (t == List<_i16.PullRequest>) {
      return (data as List)
              .map((e) => deserialize<_i16.PullRequest>(e))
              .toList()
          as T;
    }
    if (t == List<_i17.Repository>) {
      return (data as List).map((e) => deserialize<_i17.Repository>(e)).toList()
          as T;
    }
    if (t == List<_i18.AgentFinding>) {
      return (data as List)
              .map((e) => deserialize<_i18.AgentFinding>(e))
              .toList()
          as T;
    }
    try {
      return _i19.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i20.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AgentFinding => 'AgentFinding',
      _i3.AppliedFix => 'AppliedFix',
      _i4.GeneratedDocumentation => 'GeneratedDocumentation',
      _i5.Greeting => 'Greeting',
      _i6.PatternLibrary => 'PatternLibrary',
      _i7.PerformanceLog => 'PerformanceLog',
      _i8.PullRequest => 'PullRequest',
      _i9.Repository => 'Repository',
      _i10.ReviewJob => 'ReviewJob',
      _i11.ReviewNotification => 'ReviewNotification',
      _i12.ReviewSession => 'ReviewSession',
      _i13.UserPreference => 'UserPreference',
      _i14.WebhookEvent => 'WebhookEvent',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'code_butler_new.',
        '',
      );
    }

    switch (data) {
      case _i2.AgentFinding():
        return 'AgentFinding';
      case _i3.AppliedFix():
        return 'AppliedFix';
      case _i4.GeneratedDocumentation():
        return 'GeneratedDocumentation';
      case _i5.Greeting():
        return 'Greeting';
      case _i6.PatternLibrary():
        return 'PatternLibrary';
      case _i7.PerformanceLog():
        return 'PerformanceLog';
      case _i8.PullRequest():
        return 'PullRequest';
      case _i9.Repository():
        return 'Repository';
      case _i10.ReviewJob():
        return 'ReviewJob';
      case _i11.ReviewNotification():
        return 'ReviewNotification';
      case _i12.ReviewSession():
        return 'ReviewSession';
      case _i13.UserPreference():
        return 'UserPreference';
      case _i14.WebhookEvent():
        return 'WebhookEvent';
    }
    className = _i19.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i20.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AgentFinding') {
      return deserialize<_i2.AgentFinding>(data['data']);
    }
    if (dataClassName == 'AppliedFix') {
      return deserialize<_i3.AppliedFix>(data['data']);
    }
    if (dataClassName == 'GeneratedDocumentation') {
      return deserialize<_i4.GeneratedDocumentation>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i5.Greeting>(data['data']);
    }
    if (dataClassName == 'PatternLibrary') {
      return deserialize<_i6.PatternLibrary>(data['data']);
    }
    if (dataClassName == 'PerformanceLog') {
      return deserialize<_i7.PerformanceLog>(data['data']);
    }
    if (dataClassName == 'PullRequest') {
      return deserialize<_i8.PullRequest>(data['data']);
    }
    if (dataClassName == 'Repository') {
      return deserialize<_i9.Repository>(data['data']);
    }
    if (dataClassName == 'ReviewJob') {
      return deserialize<_i10.ReviewJob>(data['data']);
    }
    if (dataClassName == 'ReviewNotification') {
      return deserialize<_i11.ReviewNotification>(data['data']);
    }
    if (dataClassName == 'ReviewSession') {
      return deserialize<_i12.ReviewSession>(data['data']);
    }
    if (dataClassName == 'UserPreference') {
      return deserialize<_i13.UserPreference>(data['data']);
    }
    if (dataClassName == 'WebhookEvent') {
      return deserialize<_i14.WebhookEvent>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i19.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i20.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
