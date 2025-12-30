import 'dart:async';
import 'dart:math';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';
import 'package:code_butler_new_server/src/agents/base_agent.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Documentation agent that generates docstrings using Gemini API
class DocumentationAgent extends BaseAgent {
  @override
  String get agentType => 'documentation';

  GenerativeModel? _model;
  String? _apiKey;

  @override
  Future<List<AgentFinding>> analyze(
    Session session,
    int pullRequestId,
    ReviewSession reviewSession,
  ) async {
    // This method is required by BaseAgent but DocumentationAgent uses generateDocstring instead
    // This is a placeholder - the orchestrator should call generateDocstring directly
    logInfo(session, 'Documentation agent analyze called for PR $pullRequestId');
    return [];
  }

  /// Initializes the Gemini API client
  void initialize(String apiKey) {
    _apiKey = apiKey;
    if (apiKey.isNotEmpty && apiKey != 'YOUR_GEMINI_API_KEY') {
      _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );
    }
  }

  /// Generates a docstring for a function using Gemini API
  Future<String> generateDocstring(
    String functionSignature,
    String functionBody,
    String language,
  ) async {
    // If API not configured, use template-based fallback
    if (_model == null || _apiKey == null || _apiKey!.isEmpty || _apiKey == 'YOUR_GEMINI_API_KEY') {
      return _generateTemplateDocstring(functionSignature, functionBody, language);
    }

    try {
      final prompt = _buildPrompt(functionSignature, functionBody, language);
      final response = await _callGeminiWithRetry(prompt);
      return _formatDocstring(response, language);
    } catch (e) {
      // Fallback to template on error
      return _generateTemplateDocstring(functionSignature, functionBody, language);
    }
  }

  /// Builds the prompt for Gemini API
  String _buildPrompt(String functionSignature, String functionBody, String language) {
    return '''Generate a concise technical docstring for this $language function:

$functionSignature
$functionBody

Requirements:
- Include parameter descriptions
- Describe return value
- Mention potential exceptions
- Use proper $language docstring format
- Be concise and technical
- Do not include the function signature itself, only the docstring

Docstring:''';
  }

  /// Calls Gemini API with retry logic and exponential backoff
  Future<String> _callGeminiWithRetry(String prompt, {int maxRetries = 3}) async {
    if (_model == null) {
      throw Exception('Gemini model not initialized');
    }

    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        final content = [Content.text(prompt)];
        final response = await _model!.generateContent(content);
        
        if (response.text != null && response.text!.isNotEmpty) {
          return response.text!;
        } else {
          throw Exception('Empty response from Gemini API');
        }
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          throw Exception('Failed to call Gemini API after $maxRetries retries: $e');
        }
        
        // Exponential backoff: wait 2^retryCount seconds
        final delay = Duration(seconds: pow(2, retryCount).toInt());
        await Future.delayed(delay);
      }
    }

    throw Exception('Failed to call Gemini API');
  }

  /// Formats the response as proper docstring for the language
  String _formatDocstring(String response, String language) {
    // Clean up response
    String docstring = response.trim();
    
    // Remove any markdown code blocks if present
    docstring = docstring.replaceAll(RegExp(r'```[a-z]*\n?'), '');
    docstring = docstring.replaceAll('```', '');
    docstring = docstring.trim();

    // Format based on language
    if (language == 'dart') {
      // Dart uses /// for documentation
      final lines = docstring.split('\n');
      return lines.map((line) => '/// ${line.trim()}').join('\n');
    } else if (language == 'python') {
      // Python uses """ for docstrings
      if (!docstring.startsWith('"""')) {
        docstring = '"""\n$docstring\n"""';
      }
      return docstring;
    } else {
      // Default: use // style
      final lines = docstring.split('\n');
      return lines.map((line) => '// ${line.trim()}').join('\n');
    }
  }

  /// Generates template-based docstring as fallback
  String _generateTemplateDocstring(String functionSignature, String functionBody, String language) {
    // Extract function name and parameters
    final nameMatch = RegExp(r'(\w+)\s*\([^)]*\)').firstMatch(functionSignature);
    final functionName = nameMatch?.group(1) ?? 'function';
    
    final paramMatch = RegExp(r'\(([^)]*)\)').firstMatch(functionSignature);
    final params = paramMatch?.group(1)?.split(',') ?? [];
    
    if (language == 'dart') {
      final docLines = <String>[
        '/// $functionName',
        '///',
      ];
      
      for (final param in params) {
        final trimmed = param.trim();
        if (trimmed.isNotEmpty) {
          final paramName = trimmed.split(' ').last.replaceAll(RegExp(r'[^\w]'), '');
          docLines.add('/// * [$paramName] - Parameter description');
        }
      }
      
      docLines.add('///');
      docLines.add('/// Returns the result');
      
      return docLines.join('\n');
    } else if (language == 'python') {
      final docLines = <String>[
        '"""',
        functionName,
        '',
      ];
      
      for (final param in params) {
        final trimmed = param.trim();
        if (trimmed.isNotEmpty) {
          final paramName = trimmed.split('=').first.trim().split(':').first.trim();
          docLines.add('    Args:');
          docLines.add('        $paramName: Parameter description');
        }
      }
      
      docLines.add('');
      docLines.add('    Returns:');
      docLines.add('        The result');
      docLines.add('"""');
      
      return docLines.join('\n');
    } else {
      return '// $functionName - Generated documentation';
    }
  }

  /// Generates documentation for a function and stores it
  Future<GeneratedDocumentation> generateAndStore(
    Session session,
    int pullRequestId,
    String filePath,
    String functionName,
    String functionSignature,
    String functionBody,
    String language,
  ) async {
    try {
      final generatedDoc = await generateDocstring(functionSignature, functionBody, language);
      
      final documentation = GeneratedDocumentation(
        pullRequestId: pullRequestId,
        filePath: filePath,
        functionName: functionName,
        originalCode: '$functionSignature\n$functionBody',
        generatedDoc: generatedDoc,
        verificationStatus: 'pending',
        verificationIssues: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await GeneratedDocumentation.db.insertRow(session, documentation);
      logInfo(session, 'Generated documentation for $functionName in $filePath');
      
      return created;
    } catch (e) {
      logError(session, 'Error generating documentation', e);
      rethrow;
    }
  }
}

