import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';
import 'package:code_butler_server/src/agents/base_agent.dart';

/// Verification result structure
class VerificationResult {
  final String status; // approved, needs_revision
  final List<String> issues;

  VerificationResult({
    required this.status,
    required this.issues,
  });
}

/// Verifier agent that checks documentation quality
class VerifierAgent extends BaseAgent {
  @override
  String get agentType => 'verifier';

  /// Verifies generated documentation against actual code
  Future<VerificationResult> verifyDocumentation(
    String generatedDoc,
    String functionSignature,
    String functionBody,
  ) async {
    final issues = <String>[];

    // Extract parameter names from function signature
    final parameters = _extractParameters(functionSignature);
    
    // Extract return type from function signature
    final returnType = _extractReturnType(functionSignature);

    // Check 1: Verify all parameters are documented
    for (final param in parameters) {
      if (!_isParameterDocumented(generatedDoc, param)) {
        issues.add('Parameter "$param" is not documented in the docstring');
      }
    }

    // Check 2: Verify return type is mentioned
    if (returnType != null && returnType != 'void' && !_isReturnTypeMentioned(generatedDoc, returnType)) {
      issues.add('Return type "$returnType" is not mentioned in the docstring');
    }

    // Check 3: Flag hallucinations (parameters not in signature)
    final documentedParams = _extractDocumentedParameters(generatedDoc);
    for (final docParam in documentedParams) {
      if (!parameters.contains(docParam)) {
        issues.add('Documentation references parameter "$docParam" that does not exist in function signature (hallucination)');
      }
    }

    // Check 4: Check for behavior not in code
    final behaviorIssues = _checkBehaviorHallucinations(generatedDoc, functionBody);
    issues.addAll(behaviorIssues);

    final status = issues.isEmpty ? 'approved' : 'needs_revision';
    return VerificationResult(status: status, issues: issues);
  }

  /// Extracts parameter names from function signature
  List<String> _extractParameters(String signature) {
    final paramMatch = RegExp(r'\(([^)]*)\)').firstMatch(signature);
    if (paramMatch == null) return [];

    final params = paramMatch.group(1) ?? '';
    return params.split(',').map((p) {
      // Remove type annotations and default values
      final cleaned = p.trim()
          .split(':').last
          .split('=').first
          .trim()
          .replaceAll(RegExp(r'[^\w]'), '');
      return cleaned;
    }).where((p) => p.isNotEmpty).toList();
  }

  /// Extracts return type from function signature
  String? _extractReturnType(String signature) {
    // Dart: Future<Type> or Type
    final dartMatch = RegExp(r'(Future\s*<[^>]*>|void|dynamic|[\w<>]+)\s+\w+\s*\(').firstMatch(signature);
    if (dartMatch != null) {
      return dartMatch.group(1);
    }

    // Python: -> Type (type hints)
    final pythonMatch = RegExp(r'->\s*([\w<>]+)').firstMatch(signature);
    if (pythonMatch != null) {
      return pythonMatch.group(1);
    }

    return null;
  }

  /// Checks if a parameter is documented
  bool _isParameterDocumented(String doc, String paramName) {
    final lowerDoc = doc.toLowerCase();
    final lowerParam = paramName.toLowerCase();
    
    // Check for various documentation patterns
    final patterns = [
      RegExp('\\b$lowerParam\\b', caseSensitive: false),
      RegExp('\\[?$lowerParam\\]?', caseSensitive: false),
      RegExp('$lowerParam:', caseSensitive: false),
      RegExp('$lowerParam\\s*-', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      if (pattern.hasMatch(lowerDoc)) {
        return true;
      }
    }

    return false;
  }

  /// Checks if return type is mentioned
  bool _isReturnTypeMentioned(String doc, String returnType) {
    final lowerDoc = doc.toLowerCase();
    final lowerReturn = returnType.toLowerCase().replaceAll(RegExp(r'[<>]'), '');
    
    // Check for return/returns mentions
    if (!lowerDoc.contains('return')) {
      return false;
    }

    // Check if return type is mentioned near "return"
    final returnPattern = RegExp('return[^.]*$lowerReturn|$lowerReturn[^.]*return', caseSensitive: false);
    return returnPattern.hasMatch(lowerDoc);
  }

  /// Extracts parameters mentioned in documentation
  List<String> _extractDocumentedParameters(String doc) {
    final params = <String>[];
    
    // Pattern for Dart: /// * [paramName] - description
    final dartPattern = RegExp(r'\[(\w+)\]');
    final dartMatches = dartPattern.allMatches(doc);
    for (final match in dartMatches) {
      params.add(match.group(1)!);
    }

    // Pattern for Python: param_name: description
    final pythonPattern = RegExp(r'(\w+)\s*:', caseSensitive: false);
    final pythonMatches = pythonPattern.allMatches(doc);
    for (final match in pythonMatches) {
      final param = match.group(1)!;
      // Filter out common words
      if (!['args', 'returns', 'raises', 'example', 'note'].contains(param.toLowerCase())) {
        params.add(param);
      }
    }

    return params;
  }

  /// Checks for behavior hallucinations (docs mention behavior not in code)
  List<String> _checkBehaviorHallucinations(String doc, String functionBody) {
    final issues = <String>[];
    final lowerDoc = doc.toLowerCase();
    final lowerBody = functionBody.toLowerCase();

    // Check for exception mentions
    if (lowerDoc.contains('throws') || lowerDoc.contains('raises') || lowerDoc.contains('exception')) {
      // Check if function actually throws/raises
      if (!lowerBody.contains('throw') && !lowerBody.contains('raise') && !lowerBody.contains('exception')) {
        issues.add('Documentation mentions exceptions but function does not throw/raise any');
      }
    }

    // Check for async mentions
    if (lowerDoc.contains('async') || lowerDoc.contains('asynchronous')) {
      if (!lowerBody.contains('async') && !lowerBody.contains('await') && !lowerBody.contains('future')) {
        issues.add('Documentation mentions async behavior but function is not async');
      }
    }

    // Check for file I/O mentions
    if (lowerDoc.contains('file') || lowerDoc.contains('read') || lowerDoc.contains('write')) {
      if (!lowerBody.contains('file') && !lowerBody.contains('read') && !lowerBody.contains('write')) {
        issues.add('Documentation mentions file operations but function does not perform file I/O');
      }
    }

    return issues;
  }

  /// Updates GeneratedDocumentation with verification results
  Future<void> updateVerificationStatus(
    Session session,
    int documentationId,
    VerificationResult result,
  ) async {
    final documentation = await GeneratedDocumentation.db.findById(session, documentationId);
    if (documentation == null) {
      logError(session, 'Documentation $documentationId not found', null);
      return;
    }

    final updated = documentation.copyWith(
      verificationStatus: result.status,
      verificationIssues: result.issues.isEmpty ? null : result.issues.join('; '),
      updatedAt: DateTime.now(),
    );

    await GeneratedDocumentation.db.updateRow(session, updated);
    logInfo(session, 'Updated verification status for documentation $documentationId: ${result.status}');
  }
}

