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

abstract class PatternLibrary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PatternLibrary._({
    required this.pattern,
    required this.language,
    required this.category,
    required this.fixTemplate,
    required this.confidence,
    required this.occurrenceCount,
    required this.lastSeen,
  });

  factory PatternLibrary({
    required String pattern,
    required String language,
    required String category,
    required String fixTemplate,
    required double confidence,
    required int occurrenceCount,
    required DateTime lastSeen,
  }) = _PatternLibraryImpl;

  factory PatternLibrary.fromJson(Map<String, dynamic> jsonSerialization) {
    return PatternLibrary(
      pattern: jsonSerialization['pattern'] as String,
      language: jsonSerialization['language'] as String,
      category: jsonSerialization['category'] as String,
      fixTemplate: jsonSerialization['fixTemplate'] as String,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      occurrenceCount: jsonSerialization['occurrenceCount'] as int,
      lastSeen: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastSeen'],
      ),
    );
  }

  String pattern;

  String language;

  String category;

  String fixTemplate;

  double confidence;

  int occurrenceCount;

  DateTime lastSeen;

  /// Returns a shallow copy of this [PatternLibrary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PatternLibrary copyWith({
    String? pattern,
    String? language,
    String? category,
    String? fixTemplate,
    double? confidence,
    int? occurrenceCount,
    DateTime? lastSeen,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PatternLibrary',
      'pattern': pattern,
      'language': language,
      'category': category,
      'fixTemplate': fixTemplate,
      'confidence': confidence,
      'occurrenceCount': occurrenceCount,
      'lastSeen': lastSeen.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PatternLibrary',
      'pattern': pattern,
      'language': language,
      'category': category,
      'fixTemplate': fixTemplate,
      'confidence': confidence,
      'occurrenceCount': occurrenceCount,
      'lastSeen': lastSeen.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PatternLibraryImpl extends PatternLibrary {
  _PatternLibraryImpl({
    required String pattern,
    required String language,
    required String category,
    required String fixTemplate,
    required double confidence,
    required int occurrenceCount,
    required DateTime lastSeen,
  }) : super._(
         pattern: pattern,
         language: language,
         category: category,
         fixTemplate: fixTemplate,
         confidence: confidence,
         occurrenceCount: occurrenceCount,
         lastSeen: lastSeen,
       );

  /// Returns a shallow copy of this [PatternLibrary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PatternLibrary copyWith({
    String? pattern,
    String? language,
    String? category,
    String? fixTemplate,
    double? confidence,
    int? occurrenceCount,
    DateTime? lastSeen,
  }) {
    return PatternLibrary(
      pattern: pattern ?? this.pattern,
      language: language ?? this.language,
      category: category ?? this.category,
      fixTemplate: fixTemplate ?? this.fixTemplate,
      confidence: confidence ?? this.confidence,
      occurrenceCount: occurrenceCount ?? this.occurrenceCount,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
