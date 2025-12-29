import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';
import 'package:code_butler_server/src/agents/base_agent.dart';

/// Performance suggestion structure
class PerformanceSuggestion {
  final String impact; // high, medium, low
  final String description;
  final String codeExample;
  final int lineNumber;

  PerformanceSuggestion({
    required this.impact,
    required this.description,
    required this.codeExample,
    required this.lineNumber,
  });
}

/// Performance agent that analyzes code for optimization opportunities
class PerformanceAgent extends BaseAgent {
  @override
  String get agentType => 'performance';

  /// Analyzes code for performance bottlenecks
  Future<List<PerformanceSuggestion>> analyzePerformance(
    String filePath,
    String content,
    String language,
  ) async {
    final suggestions = <PerformanceSuggestion>[];

    if (language == 'dart') {
      suggestions.addAll(_analyzeDartPerformance(filePath, content));
    } else {
      suggestions.addAll(_analyzeGenericPerformance(filePath, content));
    }

    return suggestions;
  }

  /// Analyzes Dart-specific performance issues
  List<PerformanceSuggestion> _analyzeDartPerformance(String filePath, String content) {
    final suggestions = <PerformanceSuggestion>[];
    final lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Check for missing const constructors
      if (_hasMissingConst(line)) {
        suggestions.add(PerformanceSuggestion(
          impact: 'medium',
          description: 'Missing const constructor. Using const can improve performance and reduce memory usage.',
          codeExample: line.replaceAll(RegExp(r'(\w+)\(([^)]*)\)'), 'const \$1(\$2)'),
          lineNumber: i + 1,
        ));
      }

      // Check for unnecessary rebuilds
      if (_hasUnnecessaryRebuild(line)) {
        suggestions.add(PerformanceSuggestion(
          impact: 'high',
          description: 'Potential unnecessary widget rebuild. Consider using const widgets or optimizing build methods.',
          codeExample: '// Consider: const WidgetName() or use Builder pattern',
          lineNumber: i + 1,
        ));
      }

      // Check for synchronous file operations in async contexts
      if (_hasSyncFileOpInAsync(line, content, i)) {
        suggestions.add(PerformanceSuggestion(
          impact: 'high',
          description: 'Synchronous file operation in async context. Use async file operations to avoid blocking.',
          codeExample: line.replaceAll('Sync', '').replaceAll('readAsStringSync', 'readAsString'),
          lineNumber: i + 1,
        ));
      }

      // Check for inefficient string concatenation
      if (_hasInefficientStringConcat(line)) {
        suggestions.add(PerformanceSuggestion(
          impact: 'medium',
          description: 'Inefficient string concatenation in loop. Use StringBuffer or join() for better performance.',
          codeExample: '// Use: final buffer = StringBuffer(); buffer.write(item); or items.join("")',
          lineNumber: i + 1,
        ));
      }
    }

    // Check for nested loops with high complexity
    suggestions.addAll(_detectNestedLoops(lines));

    // Check for repeated database queries in loops
    suggestions.addAll(_detectRepeatedDbQueries(lines));

    return suggestions;
  }

  /// Analyzes generic performance issues
  List<PerformanceSuggestion> _analyzeGenericPerformance(String filePath, String content) {
    final suggestions = <PerformanceSuggestion>[];
    final lines = content.split('\n');

    // Check for nested loops
    suggestions.addAll(_detectNestedLoops(lines));

    // Check for inefficient string concatenation
    for (int i = 0; i < lines.length; i++) {
      if (_hasInefficientStringConcat(lines[i])) {
        suggestions.add(PerformanceSuggestion(
          impact: 'medium',
          description: 'Inefficient string concatenation. Consider using StringBuilder or join() method.',
          codeExample: '// Use appropriate string builder for your language',
          lineNumber: i + 1,
        ));
      }
    }

    return suggestions;
  }

  /// Detects nested loops with high complexity
  List<PerformanceSuggestion> _detectNestedLoops(List<String> lines) {
    final suggestions = <PerformanceSuggestion>[];
    int nestingLevel = 0;
    int loopStartLine = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      if (_isLoop(line)) {
        nestingLevel++;
        if (nestingLevel == 1) {
          loopStartLine = i + 1;
        } else if (nestingLevel >= 3) {
          suggestions.add(PerformanceSuggestion(
            impact: 'high',
            description: 'Deeply nested loops (${nestingLevel} levels) detected. This can cause performance issues with large datasets.',
            codeExample: '// Consider: Flattening loops, using map/filter, or optimizing algorithm complexity',
            lineNumber: loopStartLine,
          ));
        }
      }

      if (_isClosingBrace(line)) {
        nestingLevel = nestingLevel > 0 ? nestingLevel - 1 : 0;
      }
    }

    return suggestions;
  }

  /// Detects repeated database queries in loops
  List<PerformanceSuggestion> _detectRepeatedDbQueries(List<String> lines) {
    final suggestions = <PerformanceSuggestion>[];
    bool inLoop = false;
    int loopStartLine = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (_isLoop(line)) {
        inLoop = true;
        loopStartLine = i + 1;
      }

      if (inLoop && _isDbQuery(line)) {
        suggestions.add(PerformanceSuggestion(
          impact: 'high',
          description: 'Database query inside loop detected. This can cause N+1 query problem. Consider batch loading or query optimization.',
          codeExample: '// Use: Batch queries, eager loading, or query outside loop',
          lineNumber: loopStartLine,
        ));
      }

      if (_isClosingBrace(line)) {
        inLoop = false;
      }
    }

    return suggestions;
  }

  /// Checks if line has missing const constructor
  bool _hasMissingConst(String line) {
    if (!line.contains('(') || !line.contains(')')) return false;
    if (line.contains('const ') || line.contains('final ')) return false;
    
    // Check for common widget/object constructors that could be const
    final constablePatterns = [
      RegExp(r'\b(Text|Container|Padding|SizedBox|Column|Row|Center)\([^)]*\)'),
    ];

    for (final pattern in constablePatterns) {
      if (pattern.hasMatch(line) && !line.contains('const ')) {
        return true;
      }
    }

    return false;
  }

  /// Checks for unnecessary rebuilds
  bool _hasUnnecessaryRebuild(String line) {
    // Check for setState in build method or expensive operations
    if (line.contains('setState') && line.contains('build')) {
      return true;
    }
    
    // Check for expensive operations in build methods
    if (line.contains('build') && 
        (line.contains('Future') || line.contains('async') || line.contains('await'))) {
      return true;
    }

    return false;
  }

  /// Checks for synchronous file operations in async contexts
  bool _hasSyncFileOpInAsync(String line, String content, int lineIndex) {
    if (!line.contains('Sync') && !line.contains('readAsStringSync') && !line.contains('writeAsStringSync')) {
      return false;
    }

    // Check if we're in an async function
    final beforeLines = content.split('\n').sublist(0, lineIndex + 1).join('\n');
    return beforeLines.contains('async') || beforeLines.contains('Future');
  }

  /// Checks for inefficient string concatenation
  bool _hasInefficientStringConcat(String line) {
    // Check for string concatenation in loops
    if (_isLoop(line)) {
      return false; // Will be checked in context
    }

    // Check for multiple + operations on same line
    final plusCount = '+'.allMatches(line).length;
    if (plusCount >= 3 && line.contains('"') && line.contains('+')) {
      return true;
    }

    return false;
  }

  /// Checks if line is a loop
  bool _isLoop(String line) {
    final loopPatterns = [
      RegExp(r'\bfor\s*\('),
      RegExp(r'\bwhile\s*\('),
      RegExp(r'\bforEach\s*\('),
      RegExp(r'\.map\s*\('),
    ];

    for (final pattern in loopPatterns) {
      if (pattern.hasMatch(line)) {
        return true;
      }
    }

    return false;
  }

  /// Checks if line is a closing brace
  bool _isClosingBrace(String line) {
    return line.trim() == '}' || line.trim() == ']';
  }

  /// Checks if line contains database query
  bool _isDbQuery(String line) {
    final queryPatterns = [
      RegExp(r'(?i)\b(select|insert|update|delete|find|query|db\.|database\.)', caseSensitive: false),
      RegExp(r'\.find\(|\.findOne\(|\.findById\('),
    ];

    for (final pattern in queryPatterns) {
      if (pattern.hasMatch(line)) {
        return true;
      }
    }

    return false;
  }

  /// Converts performance suggestions to AgentFinding objects and stores them
  Future<List<AgentFinding>> storeFindings(
    Session session,
    int pullRequestId,
    String filePath,
    List<PerformanceSuggestion> suggestions,
  ) async {
    final agentFindings = <AgentFinding>[];

    for (final suggestion in suggestions) {
      final agentFinding = AgentFinding(
        pullRequestId: pullRequestId,
        agentType: agentType,
        severity: suggestion.impact == 'high' ? 'warning' : 'info',
        category: 'performance',
        message: suggestion.description,
        filePath: filePath,
        lineNumber: suggestion.lineNumber,
        codeSnippet: suggestion.codeExample,
        suggestedFix: suggestion.codeExample,
        createdAt: DateTime.now(),
      );

      final created = await AgentFinding.db.insertRow(session, agentFinding);
      agentFindings.add(created);
    }

    return agentFindings;
  }
}

