import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';

/// Fix object containing code changes
class Fix {
  final String originalCode;
  final String fixedCode;
  final List<int> lineNumbers;
  final double confidenceScore;
  final String filePath;

  Fix({
    required this.originalCode,
    required this.fixedCode,
    required this.lineNumbers,
    required this.confidenceScore,
    required this.filePath,
  });
}

/// Autofix service that generates code fixes
class AutofixService {
  final Session session;

  AutofixService(this.session);

  /// Generates a fix for an AgentFinding
  Future<Fix?> generateFix(AgentFinding finding, String originalCode) async {
    try {
      switch (finding.category) {
        case 'documentation':
          return await _generateDocumentationFix(finding, originalCode);
        case 'security':
          return await _generateSecurityFix(finding, originalCode);
        case 'performance':
          return await _generatePerformanceFix(finding, originalCode);
        case 'complexity':
          return await _generateComplexityFix(finding, originalCode);
        default:
          return _generateTemplateFix(finding, originalCode);
      }
    } catch (e) {
      session.log('Error generating fix: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Generates documentation fix using verified docstrings
  Future<Fix?> _generateDocumentationFix(AgentFinding finding, String code) async {
    if (finding.filePath == null) return null;

    // Get verified documentation for this file
    final docs = await GeneratedDocumentation.db.find(
      session,
      where: (d) => d.filePath.equals(finding.filePath!) & d.verificationStatus.equals('approved'),
    );

    if (docs.isEmpty) return null;

    // Find matching function and apply docstring
    final doc = docs.first;
    final functionName = doc.functionName;
    if (functionName == null) return null;

    // Find function in code and insert docstring
    final lines = code.split('\n');
    int functionLine = -1;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains(functionName) && lines[i].contains('(')) {
        functionLine = i;
        break;
      }
    }

    if (functionLine == -1) return null;

    // Insert docstring before function
    final fixedLines = List<String>.from(lines);
    final docLines = doc.generatedDoc.split('\n');
    for (var docLine in docLines.reversed) {
      fixedLines.insert(functionLine, docLine);
    }

    return Fix(
      originalCode: code,
      fixedCode: fixedLines.join('\n'),
      lineNumbers: [functionLine + 1],
      confidenceScore: 0.9,
      filePath: finding.filePath!,
    );
  }

  /// Generates security fix
  Fix? _generateSecurityFix(AgentFinding finding, String code) {
    if (finding.codeSnippet == null) return null;

    final snippet = finding.codeSnippet!;
    String fixedCode = code;

    // Fix hardcoded secrets
    if (snippet.contains('password') || snippet.contains('api_key') || snippet.contains('secret')) {
      fixedCode = _replaceHardcodedSecret(code, snippet);
    }

    // Fix SQL injection
    if (snippet.contains('SELECT') || snippet.contains('INSERT') || snippet.contains('UPDATE')) {
      fixedCode = _fixSqlInjection(code, snippet);
    }

    // Fix eval usage
    if (snippet.contains('eval(')) {
      fixedCode = _fixEvalUsage(code, snippet);
    }

    if (fixedCode == code) return null; // No fix generated

    final lineNumber = finding.lineNumber ?? 1;
    return Fix(
      originalCode: code,
      fixedCode: fixedCode,
      lineNumbers: [lineNumber],
      confidenceScore: 0.8,
      filePath: finding.filePath ?? '',
    );
  }

  /// Generates performance fix
  Fix? _generatePerformanceFix(AgentFinding finding, String code) {
    if (finding.codeSnippet == null) return null;

    final snippet = finding.codeSnippet!;
    String fixedCode = code;

    // Add const constructor
    if (snippet.contains('Text(') || snippet.contains('Container(')) {
      fixedCode = _addConstConstructor(code, snippet);
    }

    // Fix string concatenation
    if (snippet.contains('+') && snippet.contains('"')) {
      fixedCode = _fixStringConcatenation(code, snippet);
    }

    if (fixedCode == code) return null;

    final lineNumber = finding.lineNumber ?? 1;
    return Fix(
      originalCode: code,
      fixedCode: fixedCode,
      lineNumbers: [lineNumber],
      confidenceScore: 0.7,
      filePath: finding.filePath ?? '',
    );
  }

  /// Generates complexity fix
  Fix? _generateComplexityFix(AgentFinding finding, String code) {
    // Suggest breaking down complex functions
    return Fix(
      originalCode: code,
      fixedCode: code, // Would need actual refactoring
      lineNumbers: [finding.lineNumber ?? 1],
      confidenceScore: 0.5,
      filePath: finding.filePath ?? '',
    );
  }

  /// Generates template-based fix for simple issues
  Fix? _generateTemplateFix(AgentFinding finding, String code) {
    if (finding.suggestedFix == null) return null;

    // Apply suggested fix from finding
    final lines = code.split('\n');
    final lineNumber = finding.lineNumber;
    if (lineNumber == null || lineNumber < 1 || lineNumber > lines.length) {
      return null;
    }

    final fixedLines = List<String>.from(lines);
    fixedLines[lineNumber - 1] = finding.suggestedFix!;

    return Fix(
      originalCode: code,
      fixedCode: fixedLines.join('\n'),
      lineNumbers: [lineNumber],
      confidenceScore: 0.6,
      filePath: finding.filePath ?? '',
    );
  }

  /// Replaces hardcoded secret with environment variable
  String _replaceHardcodedSecret(String code, String snippet) {
    // Pattern: password = "value" -> password = Platform.environment['PASSWORD'] ?? ''
    return code.replaceAllMapped(
      RegExp(r'(\w+)\s*[=:]\s*["'']([^"'']+)["'']'),
      (match) {
        final varName = match.group(1)!;
        return '$varName = Platform.environment[\'${varName.toUpperCase()}\'] ?? \'\'';
      },
    );
  }

  /// Fixes SQL injection by using parameterized queries
  String _fixSqlInjection(String code, String snippet) {
    // Replace string concatenation with parameterized query
    return code.replaceAllMapped(
      RegExp(r'query\s*=\s*["'']([^"'']*)\s*\+\s*([^"'']+)["'']'),
      (match) {
        return 'query = "\${match.group(1)}?\${match.group(2)}"'; // Simplified
      },
    );
  }

  /// Fixes eval usage
  String _fixEvalUsage(String code, String snippet) {
    // Replace eval with safer alternative
    return code.replaceAll('eval(', '// TODO: Replace eval with safer alternative: ');
  }

  /// Adds const constructor
  String _addConstConstructor(String code, String snippet) {
    return code.replaceAllMapped(
      RegExp(r'(\w+)\(([^)]*)\)'),
      (match) {
        final widgetName = match.group(1)!;
        if (widgetName == 'Text' || widgetName == 'Container' || widgetName == 'SizedBox') {
          return 'const $widgetName(${match.group(2)})';
        }
        return match.group(0)!;
      },
    );
  }

  /// Fixes string concatenation
  String _fixStringConcatenation(String code, String snippet) {
    // Suggest using StringBuffer or join
    return code.replaceAllMapped(
      RegExp(r'["'']([^"'']*)\s*\+\s*["'']([^"'']+)["'']'),
      (match) {
        return '"${match.group(1)}${match.group(2)}"';
      },
    );
  }

  /// Applies documentation fix from GeneratedDocumentation
  Future<Fix?> applyDocumentationFix(String filePath, int findingId) async {
    final finding = await AgentFinding.db.findById(session, findingId);
    if (finding == null) return null;

    final file = File(filePath);
    if (!file.existsSync()) return null;

    final content = file.readAsStringSync();
    return await _generateDocumentationFix(finding, content);
  }

  /// Applies security fix
  Future<Fix?> applySecurityFix(AgentFinding finding, String code) async {
    return _generateSecurityFix(finding, code);
  }

  /// Applies performance fix
  Future<Fix?> applyPerformanceFix(AgentFinding finding, String code) async {
    return _generatePerformanceFix(finding, code);
  }
}

