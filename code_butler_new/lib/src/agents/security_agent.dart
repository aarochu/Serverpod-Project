import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';
import 'package:code_butler_server/src/agents/base_agent.dart';

/// Security finding structure
class SecurityFinding {
  final String severity;
  final int lineNumber;
  final String description;
  final String suggestedFix;
  final String codeSnippet;

  SecurityFinding({
    required this.severity,
    required this.lineNumber,
    required this.description,
    required this.suggestedFix,
    required this.codeSnippet,
  });
}

/// Security agent that scans for vulnerabilities
class SecurityAgent extends BaseAgent {
  @override
  String get agentType => 'security';

  /// Scans a file for security issues
  Future<List<SecurityFinding>> scanFile(String filePath, String content) async {
    final findings = <SecurityFinding>[];
    final lines = content.split('\n');

    // Pattern 1: Hardcoded secrets
    findings.addAll(_detectHardcodedSecrets(lines, filePath));

    // Pattern 2: SQL injection risks
    findings.addAll(_detectSqlInjection(lines, filePath));

    // Pattern 3: Unsafe operations
    findings.addAll(_detectUnsafeOperations(lines, filePath));

    // Pattern 4: Unvalidated user input
    findings.addAll(_detectUnvalidatedInput(lines, filePath));

    return findings;
  }

  /// Detects hardcoded secrets (API keys, passwords, tokens)
  List<SecurityFinding> _detectHardcodedSecrets(List<String> lines, String filePath) {
    final findings = <SecurityFinding>[];
    
    // Patterns for secrets
    final secretPatterns = [
      RegExp(r'(?i)(password|passwd|pwd)\s*[=:]\s*["\']([^"\']+)["\']', caseSensitive: false),
      RegExp(r'(?i)(api[_-]?key|apikey)\s*[=:]\s*["\']([^"\']+)["\']', caseSensitive: false),
      RegExp(r'(?i)(secret|token|auth[_-]?token)\s*[=:]\s*["\']([^"\']+)["\']', caseSensitive: false),
      RegExp(r'(?i)(access[_-]?token)\s*[=:]\s*["\']([^"\']+)["\']', caseSensitive: false),
      RegExp(r'(?i)(private[_-]?key|privatekey)\s*[=:]\s*["\']([^"\']+)["\']', caseSensitive: false),
    ];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      for (final pattern in secretPatterns) {
        if (pattern.hasMatch(line)) {
          final match = pattern.firstMatch(line);
          final secretType = match?.group(1) ?? 'secret';
          findings.add(SecurityFinding(
            severity: 'critical',
            lineNumber: i + 1,
            description: 'Hardcoded $secretType detected. Secrets should never be committed to version control.',
            suggestedFix: 'Move secrets to environment variables or secure configuration management. '
                'Use ${_getSecretManager(filePath)} for secret storage.',
            codeSnippet: line.trim(),
          ));
        }
      }
    }

    return findings;
  }

  /// Detects SQL injection risks
  List<SecurityFinding> _detectSqlInjection(List<String> lines, String filePath) {
    final findings = <SecurityFinding>[];
    
    // Pattern: String concatenation in SQL queries
    final sqlPattern = RegExp(r'(?i)(SELECT|INSERT|UPDATE|DELETE|CREATE|DROP|ALTER)\s+.*\+.*["\']', caseSensitive: false);
    final stringConcatPattern = RegExp(r'["\'].*\+.*\$|["\'].*\+.*\{');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (sqlPattern.hasMatch(line) || (line.contains('query') && stringConcatPattern.hasMatch(line))) {
        findings.add(SecurityFinding(
          severity: 'critical',
          lineNumber: i + 1,
          description: 'Potential SQL injection vulnerability detected. String concatenation in SQL queries is unsafe.',
          suggestedFix: 'Use parameterized queries or prepared statements. '
              'Example: Use query parameters instead of string concatenation.',
          codeSnippet: line.trim(),
        ));
      }
    }

    return findings;
  }

  /// Detects unsafe operations (eval, shell injection, etc.)
  List<SecurityFinding> _detectUnsafeOperations(List<String> lines, String filePath) {
    final findings = <SecurityFinding>();
    
    // Pattern 1: eval() usage
    final evalPattern = RegExp(r'\beval\s*\(', caseSensitive: false);
    
    // Pattern 2: Shell command injection
    final shellPatterns = [
      RegExp(r'Process\.run\s*\([^,]+,\s*["\'].*\$'),
      RegExp(r'exec\s*\([^,]+,\s*["\'].*\+'),
      RegExp(r'system\s*\([^,]+,\s*["\'].*\+'),
    ];

    // Pattern 3: Dangerous file operations
    final dangerousFileOps = [
      RegExp(r'File\([^)]+\)\.writeAsStringSync\s*\([^,]+,\s*[^)]+\)'),
    ];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      if (evalPattern.hasMatch(line)) {
        findings.add(SecurityFinding(
          severity: 'critical',
          lineNumber: i + 1,
          description: 'Use of eval() detected. This can execute arbitrary code and is a security risk.',
          suggestedFix: 'Avoid eval() entirely. Use safer alternatives like JSON parsing or structured data handling.',
          codeSnippet: line.trim(),
        ));
      }

      for (final pattern in shellPatterns) {
        if (pattern.hasMatch(line)) {
          findings.add(SecurityFinding(
            severity: 'critical',
            lineNumber: i + 1,
            description: 'Potential shell command injection detected. User input concatenated into shell commands.',
            suggestedFix: 'Validate and sanitize all user input. Use Process.run with argument lists instead of string concatenation.',
            codeSnippet: line.trim(),
          ));
        }
      }

      for (final pattern in dangerousFileOps) {
        if (pattern.hasMatch(line) && line.contains('user') || line.contains('input')) {
          findings.add(SecurityFinding(
            severity: 'warning',
            lineNumber: i + 1,
            description: 'File write operation may use unvalidated input. Risk of path traversal or file overwrite.',
            suggestedFix: 'Validate file paths and sanitize user input. Use path validation libraries.',
            codeSnippet: line.trim(),
          ));
        }
      }
    }

    return findings;
  }

  /// Detects unvalidated user input
  List<SecurityFinding> _detectUnvalidatedInput(List<String> lines, String filePath) {
    final findings = <SecurityFinding>[];
    
    // Pattern: User input used without validation
    final inputPatterns = [
      RegExp(r'(?i)(req\.|request\.|input\.|params\.|query\.|body\.)', caseSensitive: false),
    ];

    final validationPatterns = [
      RegExp(r'(?i)(validate|sanitize|escape|filter)', caseSensitive: false),
    ];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      // Check if line uses user input
      bool usesInput = false;
      for (final pattern in inputPatterns) {
        if (pattern.hasMatch(line)) {
          usesInput = true;
          break;
        }
      }

      if (usesInput) {
        // Check if validation is present in nearby lines
        bool hasValidation = false;
        final contextStart = (i - 2).clamp(0, lines.length);
        final contextEnd = (i + 2).clamp(0, lines.length);
        
        for (int j = contextStart; j < contextEnd; j++) {
          for (final pattern in validationPatterns) {
            if (pattern.hasMatch(lines[j])) {
              hasValidation = true;
              break;
            }
          }
        }

        if (!hasValidation) {
          findings.add(SecurityFinding(
            severity: 'warning',
            lineNumber: i + 1,
            description: 'User input used without apparent validation. This may lead to injection attacks or data corruption.',
            suggestedFix: 'Add input validation and sanitization before using user-provided data.',
            codeSnippet: line.trim(),
          ));
        }
      }
    }

    return findings;
  }

  /// Returns appropriate secret manager suggestion based on language
  String _getSecretManager(String filePath) {
    if (filePath.endsWith('.dart')) {
      return 'environment variables or Flutter secure storage';
    } else if (filePath.endsWith('.py')) {
      return 'python-dotenv or AWS Secrets Manager';
    } else {
      return 'environment variables or a secrets management service';
    }
  }

  /// Converts security findings to AgentFinding objects and stores them
  Future<List<AgentFinding>> storeFindings(
    Session session,
    int pullRequestId,
    String filePath,
    List<SecurityFinding> findings,
  ) async {
    final agentFindings = <AgentFinding>[];

    for (final finding in findings) {
      final agentFinding = AgentFinding(
        pullRequestId: pullRequestId,
        agentType: agentType,
        severity: finding.severity,
        category: 'security',
        message: finding.description,
        filePath: filePath,
        lineNumber: finding.lineNumber,
        codeSnippet: finding.codeSnippet,
        suggestedFix: finding.suggestedFix,
        createdAt: DateTime.now(),
      );

      final created = await AgentFinding.db.insertRow(session, agentFinding);
      agentFindings.add(created);
    }

    return agentFindings;
  }
}

