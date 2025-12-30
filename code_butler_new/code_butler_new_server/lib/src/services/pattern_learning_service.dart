import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';

/// Pattern learning service for cross-repository learning
class PatternLearningService {
  final Session session;

  PatternLearningService(this.session);

  /// Tracks a pattern from a finding
  Future<void> trackPattern(
    String pattern,
    String language,
    String category,
    String fix,
  ) async {
    try {
      // Check if pattern exists
      final existing = await PatternLibrary.db.findFirstRow(
        session,
        where: (p) => p.pattern.equals(pattern) & p.language.equals(language) & p.category.equals(category),
      );

      if (existing != null) {
        // Update existing pattern
        final updated = existing.copyWith(
          occurrenceCount: existing.occurrenceCount + 1,
          lastSeen: DateTime.now(),
          fixTemplate: fix, // Update fix template if provided
        );
        await PatternLibrary.db.updateRow(session, updated);
      } else {
        // Create new pattern
        final newPattern = PatternLibrary(
          pattern: pattern,
          language: language,
          category: category,
          fixTemplate: fix,
          confidence: 0.5, // Initial confidence
          occurrenceCount: 1,
          lastSeen: DateTime.now(),
        );
        await PatternLibrary.db.insertRow(session, newPattern);
      }

      session.log('Tracked pattern: $pattern ($language/$category)');
    } catch (e) {
      session.log('Error tracking pattern: $e', level: LogLevel.error);
    }
  }

  /// Gets common patterns for a language and category
  Future<List<PatternLibrary>> getCommonPatterns(
    String language,
    String category,
  ) async {
    try {
      final patterns = await PatternLibrary.db.find(
        session,
        where: (p) => p.language.equals(language) & p.category.equals(category),
        orderBy: (p) => p.occurrenceCount,
        orderDescending: true,
        limit: 20,
      );
      return patterns;
    } catch (e) {
      session.log('Error getting common patterns: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Updates confidence based on acceptance
  Future<void> updateConfidence(String pattern, bool wasAccepted) async {
    try {
      final patternLib = await PatternLibrary.db.findFirstRow(
        session,
        where: (p) => p.pattern.equals(pattern),
      );

      if (patternLib == null) return;

      // Adjust confidence: increase if accepted, decrease if rejected
      final adjustment = wasAccepted ? 0.1 : -0.1;
      final newConfidence = (patternLib.confidence + adjustment).clamp(0.0, 1.0);

      final updated = patternLib.copyWith(confidence: newConfidence);
      await PatternLibrary.db.updateRow(session, updated);

      session.log('Updated confidence for pattern $pattern: $newConfidence');
    } catch (e) {
      session.log('Error updating confidence: $e', level: LogLevel.error);
    }
  }

  /// Builds knowledge base from all findings
  Future<void> buildKnowledgeBase() async {
    try {
      // Get all findings grouped by pattern
      final findings = await AgentFinding.db.find(session);

      final patternMap = <String, Map<String, dynamic>>{};

      for (final finding in findings) {
        final key = '${finding.category}:${finding.message}';
        if (!patternMap.containsKey(key)) {
          patternMap[key] = {
            'pattern': finding.message,
            'category': finding.category,
            'language': 'dart', // Simplified - would extract from filePath
            'count': 0,
            'fix': finding.suggestedFix ?? '',
          };
        }
        patternMap[key]!['count'] = (patternMap[key]!['count'] as int) + 1;
      }

      // Store patterns
      for (final entry in patternMap.entries) {
        final data = entry.value;
        await trackPattern(
          data['pattern'] as String,
          data['language'] as String,
          data['category'] as String,
          data['fix'] as String,
        );
      }

      session.log('Built knowledge base with ${patternMap.length} patterns');
    } catch (e) {
      session.log('Error building knowledge base: $e', level: LogLevel.error);
    }
  }
}

