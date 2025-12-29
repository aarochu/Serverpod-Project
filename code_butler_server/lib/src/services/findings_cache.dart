import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';

/// Findings cache for duplicate detection and pattern tracking
class FindingsCache {
  final Session session;
  final Map<String, int> _patternFrequency = {};
  final Map<String, Set<String>> _duplicateFindings = {};

  FindingsCache(this.session);

  /// Checks if finding is duplicate
  bool isDuplicateFinding(AgentFinding finding) {
    if (finding.filePath == null || finding.lineNumber == null) {
      return false;
    }

    final key = _generateFindingKey(finding);
    if (_duplicateFindings.containsKey(key)) {
      session.log('Duplicate finding detected: $key');
      return true;
    }

    // Track this finding
    _duplicateFindings.putIfAbsent(key, () => <String>{}).add(finding.id.toString());
    return false;
  }

  /// Generates unique key for finding
  String _generateFindingKey(AgentFinding finding) {
    return '${finding.filePath}:${finding.lineNumber}:${finding.category}:${finding.message}';
  }

  /// Tracks finding frequency for pattern
  void trackFindingFrequency(String pattern, String filePath) {
    final key = '$pattern:$filePath';
    _patternFrequency[key] = (_patternFrequency[key] ?? 0) + 1;
  }

  /// Gets finding frequency for pattern
  int getFindingFrequency(String pattern) {
    int total = 0;
    for (final entry in _patternFrequency.entries) {
      if (entry.key.startsWith('$pattern:')) {
        total += entry.value;
      }
    }
    return total;
  }

  /// Adjusts severity based on frequency
  String adjustSeverityByFrequency(String originalSeverity, String pattern) {
    final frequency = getFindingFrequency(pattern);
    
    if (frequency > 10 && originalSeverity == 'info') {
      return 'warning';
    } else if (frequency > 5 && originalSeverity == 'warning') {
      return 'critical';
    }
    
    return originalSeverity;
  }

  /// Clears duplicate tracking
  void clearDuplicates() {
    _duplicateFindings.clear();
  }

  /// Clears pattern frequency
  void clearPatternFrequency() {
    _patternFrequency.clear();
  }
}

