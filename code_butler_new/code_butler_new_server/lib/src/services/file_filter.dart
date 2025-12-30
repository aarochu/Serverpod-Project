import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/agents/navigator_agent.dart';

/// File filter for skipping test files, generated code, vendor directories
class FileFilter {
  final Session session;
  final bool skipTestFiles;
  final bool skipGeneratedCode;
  final List<String> ignorePatterns;

  FileFilter(
    this.session, {
    this.skipTestFiles = true,
    this.skipGeneratedCode = true,
    List<String>? ignorePatterns,
  }) : ignorePatterns = ignorePatterns ?? [
          'node_modules',
          'vendor',
          '.git',
          'build',
          'dist',
          '.dart_tool',
          '.idea',
          '.vscode',
        ];

  /// Checks if file should be analyzed
  bool shouldAnalyzeFile(String filePath, String repoPath) {
    final relativePath = filePath.replaceFirst(repoPath, '').replaceFirst(RegExp(r'^[/\\]'), '');

    // Skip ignored patterns
    for (final pattern in ignorePatterns) {
      if (relativePath.contains(pattern)) {
        session.log('Skipping file (ignored pattern): $relativePath');
        return false;
      }
    }

    // Skip test files
    if (skipTestFiles) {
      if (relativePath.contains('_test.dart') ||
          relativePath.contains('test/') ||
          relativePath.contains('/test_') ||
          relativePath.contains('__tests__') ||
          relativePath.contains('.test.')) {
        session.log('Skipping test file: $relativePath');
        return false;
      }
    }

    // Skip generated code
    if (skipGeneratedCode) {
      if (relativePath.contains('.g.dart') ||
          relativePath.contains('.freezed.dart') ||
          relativePath.contains('generated') ||
          relativePath.contains('.pb.dart')) {
        session.log('Skipping generated file: $relativePath');
        return false;
      }
    }

    return true;
  }

  /// Filters list of files
  List<FileMetadata> filterFiles(List<FileMetadata> files, String repoPath) {
    return files.where((file) => shouldAnalyzeFile(file.path, repoPath)).toList();
  }
}

