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

abstract class PatternLibrary implements _i1.SerializableModel {
  PatternLibrary._({
    this.id,
    required this.pattern,
    required this.language,
    required this.category,
    required this.fixTemplate,
    required this.confidence,
    required this.occurrenceCount,
    required this.lastSeen,
  });

  factory PatternLibrary({
    int? id,
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
      id: jsonSerialization['id'] as int?,
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

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
    int? id,
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
      if (id != null) 'id': id,
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

class _Undefined {}

class _PatternLibraryImpl extends PatternLibrary {
  _PatternLibraryImpl({
    int? id,
    required String pattern,
    required String language,
    required String category,
    required String fixTemplate,
    required double confidence,
    required int occurrenceCount,
    required DateTime lastSeen,
  }) : super._(
         id: id,
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
    Object? id = _Undefined,
    String? pattern,
    String? language,
    String? category,
    String? fixTemplate,
    double? confidence,
    int? occurrenceCount,
    DateTime? lastSeen,
  }) {
    return PatternLibrary(
      id: id is int? ? id : this.id,
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
