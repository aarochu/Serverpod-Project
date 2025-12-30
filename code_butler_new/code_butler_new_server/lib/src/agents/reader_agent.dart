import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';
import 'package:code_butler_new_server/src/agents/base_agent.dart';

/// File analysis result structure
class FileAnalysis {
  final String filePath;
  final String language;
  final int linesOfCode;
  final int cyclomaticComplexity;
  final int nestingDepth;
  final List<FunctionInfo> functions;
  final List<ClassInfo> classes;

  FileAnalysis({
    required this.filePath,
    required this.language,
    required this.linesOfCode,
    required this.cyclomaticComplexity,
    required this.nestingDepth,
    required this.functions,
    required this.classes,
  });
}

/// Function information
class FunctionInfo {
  final String name;
  final String signature;
  final List<String> parameters;
  final String? returnType;
  final int lineNumber;
  final int complexity;

  FunctionInfo({
    required this.name,
    required this.signature,
    required this.parameters,
    this.returnType,
    required this.lineNumber,
    required this.complexity,
  });
}

/// Class information
class ClassInfo {
  final String name;
  final int lineNumber;
  final List<String> methods;

  ClassInfo({
    required this.name,
    required this.lineNumber,
    required this.methods,
  });
}

/// Reader agent that analyzes code structure
class ReaderAgent extends BaseAgent {
  @override
  String get agentType => 'reader';

  @override
  Future<List<AgentFinding>> analyze(
    Session session,
    int pullRequestId,
    ReviewSession reviewSession,
  ) async {
    // This method is required by BaseAgent but ReaderAgent uses analyzeFile instead
    // This is a placeholder - the orchestrator should call analyzeFile directly
    logInfo(session, 'Reader agent analyze called for PR $pullRequestId');
    return [];
  }

  /// Analyzes a file and extracts structure information
  Future<FileAnalysis> analyzeFile(String filePath, String language) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('File not found: $filePath');
    }

    final content = file.readAsStringSync();
    final lines = content.split('\n');
    final linesOfCode = lines.where((line) => 
      line.trim().isNotEmpty && !line.trim().startsWith('//') && !line.trim().startsWith('#')
    ).length;

    if (language == 'dart') {
      return _analyzeDartFile(filePath, content, linesOfCode);
    } else if (language == 'python') {
      return _analyzePythonFile(filePath, content, linesOfCode);
    } else {
      // Generic analysis for other languages
      return FileAnalysis(
        filePath: filePath,
        language: language,
        linesOfCode: linesOfCode,
        cyclomaticComplexity: _estimateComplexity(content),
        nestingDepth: _calculateNestingDepth(content),
        functions: [],
        classes: [],
      );
    }
  }

  /// Analyzes Dart file
  FileAnalysis _analyzeDartFile(String filePath, String content, int linesOfCode) {
    final functions = <FunctionInfo>[];
    final classes = <ClassInfo>[];
    final lines = content.split('\n');

    // Parse functions: function name(...) { or void name(...) { or Future<...> name(...) {
    final functionPattern = RegExp(
      r'(?:Future\s*<[^>]*>\s*|void\s+|dynamic\s+|[\w<>]+\s+)?(\w+)\s*\([^)]*\)\s*\{',
    );

    // Parse classes: class Name { or class Name extends ... {
    final classPattern = RegExp(r'class\s+(\w+)(?:\s+extends|\s+implements|\s*\{)');

    int maxNesting = 0;
    int currentNesting = 0;
    int totalComplexity = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      // Track nesting
      currentNesting += '{'.allMatches(line).length;
      currentNesting -= '}'.allMatches(line).length;
      maxNesting = maxNesting > currentNesting ? maxNesting : currentNesting;

      // Extract functions
      final functionMatch = functionPattern.firstMatch(line);
      if (functionMatch != null) {
        final name = functionMatch.group(1)!;
        final signature = line.trim();
        final parameters = _extractParameters(signature);
        final returnType = _extractReturnType(signature);
        final complexity = _estimateFunctionComplexity(content, name);

        functions.add(FunctionInfo(
          name: name,
          signature: signature,
          parameters: parameters,
          returnType: returnType,
          lineNumber: i + 1,
          complexity: complexity,
        ));
        totalComplexity += complexity;
      }

      // Extract classes
      final classMatch = classPattern.firstMatch(line);
      if (classMatch != null) {
        final className = classMatch.group(1)!;
        final methods = _extractClassMethods(content, className);
        classes.add(ClassInfo(
          name: className,
          lineNumber: i + 1,
          methods: methods,
        ));
      }
    }

    return FileAnalysis(
      filePath: filePath,
      language: 'dart',
      linesOfCode: linesOfCode,
      cyclomaticComplexity: totalComplexity,
      nestingDepth: maxNesting,
      functions: functions,
      classes: classes,
    );
  }

  /// Analyzes Python file
  FileAnalysis _analyzePythonFile(String filePath, String content, int linesOfCode) {
    final functions = <FunctionInfo>[];
    final classes = <ClassInfo>[];
    final lines = content.split('\n');

    // Parse functions: def name(...):
    final functionPattern = RegExp(r'def\s+(\w+)\s*\(([^)]*)\)\s*:');

    // Parse classes: class Name:
    final classPattern = RegExp(r'class\s+(\w+)(?:\s*\([^)]*\))?\s*:');

    int maxNesting = 0;
    int currentNesting = 0;
    int totalComplexity = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      // Track nesting (indentation-based)
      final indent = line.length - line.trimLeft().length;
      currentNesting = (indent / 4).floor();
      maxNesting = maxNesting > currentNesting ? maxNesting : currentNesting;

      // Extract functions
      final functionMatch = functionPattern.firstMatch(line);
      if (functionMatch != null) {
        final name = functionMatch.group(1)!;
        final params = functionMatch.group(2) ?? '';
        final parameters = params.split(',').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
        final signature = line.trim();
        final complexity = _estimateFunctionComplexity(content, name);

        functions.add(FunctionInfo(
          name: name,
          signature: signature,
          parameters: parameters,
          returnType: null, // Python doesn't declare return types
          lineNumber: i + 1,
          complexity: complexity,
        ));
        totalComplexity += complexity;
      }

      // Extract classes
      final classMatch = classPattern.firstMatch(line);
      if (classMatch != null) {
        final className = classMatch.group(1)!;
        final methods = _extractPythonClassMethods(content, className);
        classes.add(ClassInfo(
          name: className,
          lineNumber: i + 1,
          methods: methods,
        ));
      }
    }

    return FileAnalysis(
      filePath: filePath,
      language: 'python',
      linesOfCode: linesOfCode,
      cyclomaticComplexity: totalComplexity,
      nestingDepth: maxNesting,
      functions: functions,
      classes: classes,
    );
  }

  /// Estimates cyclomatic complexity
  int _estimateComplexity(String content) {
    int complexity = 1; // Base complexity
    complexity += RegExp(r'\bif\b|\belse\b|\bwhile\b|\bfor\b|\bswitch\b|\bcase\b').allMatches(content).length;
    complexity += RegExp(r'\b&&\b|\b\|\|\b').allMatches(content).length;
    return complexity;
  }

  /// Calculates maximum nesting depth
  int _calculateNestingDepth(String content) {
    int maxDepth = 0;
    int currentDepth = 0;
    for (final char in content.split('')) {
      if (char == '{') {
        currentDepth++;
        maxDepth = maxDepth > currentDepth ? maxDepth : currentDepth;
      } else if (char == '}') {
        currentDepth--;
      }
    }
    return maxDepth;
  }

  /// Estimates function complexity
  int _estimateFunctionComplexity(String content, String functionName) {
    // Find function body and count decision points
    final pattern = RegExp('\\b$functionName\\s*\\([^)]*\\)\\s*\\{([^}]*)\\}');
    final match = pattern.firstMatch(content);
    if (match == null) return 1;
    
    final body = match.group(1) ?? '';
    return _estimateComplexity(body);
  }

  /// Extracts parameters from function signature
  List<String> _extractParameters(String signature) {
    final paramMatch = RegExp(r'\(([^)]*)\)').firstMatch(signature);
    if (paramMatch == null) return [];
    
    final params = paramMatch.group(1) ?? '';
    return params.split(',').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
  }

  /// Extracts return type from function signature
  String? _extractReturnType(String signature) {
    final returnMatch = RegExp(r'(Future\s*<[^>]*>|void|dynamic|[\w<>]+)\s+\w+\s*\(').firstMatch(signature);
    return returnMatch?.group(1);
  }

  /// Extracts class methods (Dart)
  List<String> _extractClassMethods(String content, String className) {
    final methods = <String>[];
    final classPattern = RegExp('class\\s+$className\\s*\\{([^}]*)\\}');
    final match = classPattern.firstMatch(content);
    if (match == null) return methods;
    
    final body = match.group(1) ?? '';
    final methodPattern = RegExp(r'(\w+)\s*\([^)]*\)\s*\{');
    final matches = methodPattern.allMatches(body);
    for (final m in matches) {
      methods.add(m.group(1)!);
    }
    return methods;
  }

  /// Extracts class methods (Python)
  List<String> _extractPythonClassMethods(String content, String className) {
    final methods = <String>[];
    final lines = content.split('\n');
    bool inClass = false;
    int classIndent = 0;

    for (final line in lines) {
      if (line.contains('class $className')) {
        inClass = true;
        classIndent = line.length - line.trimLeft().length;
        continue;
      }
      
      if (inClass) {
        final indent = line.length - line.trimLeft().length;
        if (indent <= classIndent && line.trim().isNotEmpty && !line.trim().startsWith('#')) {
          inClass = false;
          continue;
        }
        
        final methodMatch = RegExp(r'def\s+(\w+)').firstMatch(line);
        if (methodMatch != null) {
          methods.add(methodMatch.group(1)!);
        }
      }
    }
    
    return methods;
  }
}

