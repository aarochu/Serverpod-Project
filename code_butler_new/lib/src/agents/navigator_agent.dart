import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';
import 'package:code_butler_server/src/agents/base_agent.dart';

/// File metadata structure
class FileMetadata {
  final String path;
  final String language;
  final int size;
  final DateTime lastModified;

  FileMetadata({
    required this.path,
    required this.language,
    required this.size,
    required this.lastModified,
  });
}

/// Navigator agent that analyzes repository structure
class NavigatorAgent extends BaseAgent {
  @override
  String get agentType => 'navigator';

  String? _clonedRepoPath;
  List<FileMetadata> _fileMetadataList = [];
  Map<String, List<String>> _dependencyGraph = {};
  Session? _session;

  String? get clonedRepoPath => _clonedRepoPath;

  /// Clones a repository to a temporary directory
  Future<String> cloneRepository(String url, String branch) async {
    try {
      // Create temporary directory
      final tempDir = await Directory.systemTemp.createTemp('code_butler_');
      final repoPath = '${tempDir.path}/repo';

      _session = session;
      logInfo(session, 'Cloning repository $url (branch: $branch) to $repoPath');

      // Clone repository using git
      final cloneResult = await Process.run(
        'git',
        ['clone', '--branch', branch, '--depth', '1', url, repoPath],
        runInShell: true,
      );

      if (cloneResult.exitCode != 0) {
        throw Exception('Failed to clone repository: ${cloneResult.stderr}');
      }

      _clonedRepoPath = repoPath;
      logInfo(session, 'Repository cloned successfully');
      return repoPath;
    } catch (e) {
      logError(session, 'Error cloning repository', e);
      rethrow;
    }
  }

  /// Builds dependency graph by parsing import statements
  Map<String, List<String>> buildDependencyGraph(List<String> filePaths) {
    _dependencyGraph.clear();
    final dependencies = <String, List<String>>{};

    for (final filePath in filePaths) {
      dependencies[filePath] = [];
      final file = File(filePath);
      if (!file.existsSync()) continue;

      final content = file.readAsStringSync();
      final language = _detectLanguage(filePath);

      if (language == 'dart') {
        // Parse Dart imports: import 'package:...' or import '...'
        final importPattern = RegExp(r"import\s+['\"]([^'\"]+)['\"]");
        final matches = importPattern.allMatches(content);
        for (final match in matches) {
          final importPath = match.group(1)!;
          // Find corresponding file
          final dependentFile = _resolveImportPath(filePath, importPath);
          if (dependentFile != null && filePaths.contains(dependentFile)) {
            dependencies[filePath]!.add(dependentFile);
          }
        }
      } else if (language == 'python') {
        // Parse Python imports: import x, from x import y
        final importPattern = RegExp(r"(?:from\s+([^\s]+)\s+)?import\s+([^\s]+)");
        final matches = importPattern.allMatches(content);
        for (final match in matches) {
          final module = match.group(1) ?? match.group(2)!;
          final dependentFile = _resolvePythonImport(filePath, module);
          if (dependentFile != null && filePaths.contains(dependentFile)) {
            dependencies[filePath]!.add(dependentFile);
          }
        }
      }
    }

    _dependencyGraph = dependencies;
    return dependencies;
  }

  /// Gets files sorted by dependency order (leaf nodes first)
  List<FileMetadata> getFilesToAnalyze() {
    if (_fileMetadataList.isEmpty) {
      throw StateError('File metadata list is empty. Call analyze() first.');
    }

    // Topological sort: files with no dependencies come first
    final sortedFiles = <String>[];
    final visited = <String>{};
    final visiting = <String>{};

    void visit(String file) {
      if (visiting.contains(file)) {
        // Circular dependency detected, add anyway
        return;
      }
      if (visited.contains(file)) return;

      visiting.add(file);
      final deps = _dependencyGraph[file] ?? [];
      for (final dep in deps) {
        if (_fileMetadataList.any((f) => f.path == dep)) {
          visit(dep);
        }
      }
      visiting.remove(file);
      visited.add(file);
      sortedFiles.add(file);
    }

    for (final file in _fileMetadataList.map((f) => f.path)) {
      if (!visited.contains(file)) {
        visit(file);
      }
    }

    // Return metadata in sorted order
    final sortedMetadata = <FileMetadata>[];
    for (final filePath in sortedFiles) {
      final metadata = _fileMetadataList.firstWhere((f) => f.path == filePath);
      sortedMetadata.add(metadata);
    }

    return sortedMetadata;
  }

  @override
  Future<List<AgentFinding>> analyze(
    Session session,
    int pullRequestId,
    ReviewSession reviewSession,
  ) async {
    logInfo(session, 'Starting repository structure analysis for PR $pullRequestId');

    try {
      // Get repository URL and branch from PullRequest
      final pullRequest = await PullRequest.db.findById(session, pullRequestId);
      if (pullRequest == null) {
        throw Exception('PullRequest $pullRequestId not found');
      }

      final repository = await Repository.db.findById(session, pullRequest.repositoryId);
      if (repository == null) {
        throw Exception('Repository ${pullRequest.repositoryId} not found');
      }

      // Clone repository
      await cloneRepository(repository.url, pullRequest.headBranch);

      // Discover files
      final files = await _discoverFiles(_clonedRepoPath!);
      _fileMetadataList = files;

      // Build dependency graph
      final filePaths = files.map((f) => f.path).toList();
      buildDependencyGraph(filePaths);

      // Get sorted files
      final sortedFiles = getFilesToAnalyze();

      // Create finding with repository structure info
      final finding = AgentFinding(
        pullRequestId: pullRequestId,
        agentType: agentType,
        severity: 'info',
        category: 'structure',
        message: 'Repository structure analyzed. Found ${files.length} files. '
            'Dependency graph built with ${_dependencyGraph.length} nodes. '
            'Files sorted by dependency order for analysis.',
        filePath: null,
        lineNumber: null,
        codeSnippet: 'Total files: ${files.length}\n'
            'Languages: ${files.map((f) => f.language).toSet().join(", ")}\n'
            'Files to analyze: ${sortedFiles.length}',
        suggestedFix: null,
        createdAt: DateTime.now(),
      );

      final created = await AgentFinding.db.insertRow(session, finding);
      logInfo(session, 'Created finding: ${created.id}');

      return [created];
    } catch (e) {
      logError(session, 'Error during analysis', e);
      return [];
    }
  }

  /// Discovers all code files in the repository
  Future<List<FileMetadata>> _discoverFiles(String repoPath) async {
    final files = <FileMetadata>[];
    final dir = Directory(repoPath);

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        final path = entity.path;
        final language = _detectLanguage(path);
        if (language.isNotEmpty) {
          final stat = await entity.stat();
          files.add(FileMetadata(
            path: path,
            language: language,
            size: stat.size,
            lastModified: stat.modified,
          ));
        }
      }
    }

    return files;
  }

  /// Detects programming language from file extension
  String _detectLanguage(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'dart':
        return 'dart';
      case 'py':
        return 'python';
      case 'js':
      case 'jsx':
        return 'javascript';
      case 'ts':
      case 'tsx':
        return 'typescript';
      case 'java':
        return 'java';
      case 'go':
        return 'go';
      case 'rs':
        return 'rust';
      default:
        return '';
    }
  }

  /// Resolves import path to actual file path (simplified)
  String? _resolveImportPath(String currentFile, String importPath) {
    // Simplified resolution - in production would need proper package resolution
    if (importPath.startsWith('package:')) {
      return null; // External package
    }
    final currentDir = Directory(currentFile).parent.path;
    final resolved = Uri.parse('$currentDir/$importPath').toFilePath();
    return File(resolved).existsSync() ? resolved : null;
  }

  /// Resolves Python import to file path (simplified)
  String? _resolvePythonImport(String currentFile, String module) {
    final currentDir = Directory(currentFile).parent.path;
    final possiblePaths = [
      '$currentDir/$module.py',
      '$currentDir/$module/__init__.py',
    ];
    for (final path in possiblePaths) {
      if (File(path).existsSync()) {
        return path;
      }
    }
    return null;
  }

  /// Getter for cloned repo path
  String? get clonedRepoPath => _clonedRepoPath;

  /// Getter for file metadata list
  List<FileMetadata> get fileMetadataList => _fileMetadataList;
}
