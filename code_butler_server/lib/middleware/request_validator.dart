import 'package:serverpod/serverpod.dart';

/// Request validator middleware
class RequestValidator {
  /// Validates and sanitizes string input
  static String? validateString(String? value, {int? maxLength}) {
    if (value == null) return null;
    
    // Remove null bytes and control characters
    final sanitized = value.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
    
    if (maxLength != null && sanitized.length > maxLength) {
      throw Exception('Input exceeds maximum length of $maxLength');
    }
    
    return sanitized.isEmpty ? null : sanitized;
  }

  /// Validates integer input
  static int? validateInt(dynamic value, {int? min, int? max}) {
    if (value == null) return null;
    
    final intValue = value is int ? value : int.tryParse(value.toString());
    if (intValue == null) {
      throw Exception('Invalid integer value');
    }
    
    if (min != null && intValue < min) {
      throw Exception('Value must be at least $min');
    }
    
    if (max != null && intValue > max) {
      throw Exception('Value must be at most $max');
    }
    
    return intValue;
  }

  /// Validates URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) return null;
    
    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
        throw Exception('Invalid URL scheme');
      }
      return value;
    } catch (e) {
      throw Exception('Invalid URL format: $e');
    }
  }

  /// Validates GitHub repository URL
  static String validateGitHubUrl(String? value) {
    if (value == null || value.isEmpty) {
      throw Exception('Repository URL is required');
    }
    
    final url = validateUrl(value);
    if (url == null) {
      throw Exception('Invalid repository URL');
    }
    
    // Check if it's a GitHub URL
    if (!url.contains('github.com')) {
      throw Exception('Repository must be hosted on GitHub');
    }
    
    return url;
  }

  /// Validates file path
  static String? validateFilePath(String? value) {
    if (value == null || value.isEmpty) return null;
    
    // Prevent path traversal
    if (value.contains('..') || value.contains('~')) {
      throw Exception('Invalid file path');
    }
    
    return value;
  }
}

// Validation middleware would be implemented at endpoint level
// See RepositoryEndpoint for example usage

