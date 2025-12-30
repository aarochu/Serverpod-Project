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
import 'package:serverpod/protocol.dart' as _i2;
import 'agent_finding.dart' as _i3;
import 'applied_fix.dart' as _i4;
import 'generated_documentation.dart' as _i5;
import 'pattern_library.dart' as _i6;
import 'performance_log.dart' as _i7;
import 'pull_request.dart' as _i8;
import 'repository.dart' as _i9;
import 'review_job.dart' as _i10;
import 'review_notification.dart' as _i11;
import 'review_session.dart' as _i12;
import 'user_preference.dart' as _i13;
import 'webhook_event.dart' as _i14;
export 'agent_finding.dart';
export 'applied_fix.dart';
export 'generated_documentation.dart';
export 'pattern_library.dart';
export 'performance_log.dart';
export 'pull_request.dart';
export 'repository.dart';
export 'review_job.dart';
export 'review_notification.dart';
export 'review_session.dart';
export 'user_preference.dart';
export 'webhook_event.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    ..._i2.Protocol.targetTableDefinitions,
  ];

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

    if (t == _i3.AgentFinding) {
      return _i3.AgentFinding.fromJson(data) as T;
    }
    if (t == _i4.AppliedFix) {
      return _i4.AppliedFix.fromJson(data) as T;
    }
    if (t == _i5.GeneratedDocumentation) {
      return _i5.GeneratedDocumentation.fromJson(data) as T;
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
    if (t == _i1.getType<_i3.AgentFinding?>()) {
      return (data != null ? _i3.AgentFinding.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AppliedFix?>()) {
      return (data != null ? _i4.AppliedFix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.GeneratedDocumentation?>()) {
      return (data != null ? _i5.GeneratedDocumentation.fromJson(data) : null)
          as T;
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
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i3.AgentFinding => 'AgentFinding',
      _i4.AppliedFix => 'AppliedFix',
      _i5.GeneratedDocumentation => 'GeneratedDocumentation',
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
      return (data['__className__'] as String).replaceFirst('code_butler.', '');
    }

    switch (data) {
      case _i3.AgentFinding():
        return 'AgentFinding';
      case _i4.AppliedFix():
        return 'AppliedFix';
      case _i5.GeneratedDocumentation():
        return 'GeneratedDocumentation';
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
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
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
      return deserialize<_i3.AgentFinding>(data['data']);
    }
    if (dataClassName == 'AppliedFix') {
      return deserialize<_i4.AppliedFix>(data['data']);
    }
    if (dataClassName == 'GeneratedDocumentation') {
      return deserialize<_i5.GeneratedDocumentation>(data['data']);
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
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'code_butler';
}
