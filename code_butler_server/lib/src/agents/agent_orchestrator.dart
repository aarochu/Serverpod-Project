import 'dart:io';
import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';
import 'package:code_butler_server/src/agents/base_agent.dart';
import 'package:code_butler_server/src/agents/navigator_agent.dart';
import 'package:code_butler_server/src/agents/reader_agent.dart';
import 'package:code_butler_server/src/agents/security_agent.dart';
import 'package:code_butler_server/src/agents/performance_agent.dart';
import 'package:code_butler_server/src/agents/documentation_agent.dart';
import 'package:code_butler_server/src/agents/verifier_agent.dart';
import 'package:code_butler_server/src/services/github_service.dart';
import 'package:code_butler_server/src/services/file_filter.dart';
import 'package:code_butler_server/src/services/repository_cache.dart';
import 'package:code_butler_server/src/services/findings_cache.dart';
import 'package:code_butler_server/src/generated/protocol.dart';

/// Orchestrates the review process by coordinating multiple agents
class AgentOrchestrator {
  final Session session;
  final int concurrentTaskLimit;
  final int fileTimeoutSeconds;
  final int maxFilesPerReview;
  final int maxTimePerReview;
  final int maxCriticalFindings;
  final FileFilter fileFilter;
  final RepositoryCache? repositoryCache;
  final FindingsCache findingsCache;

  AgentOrchestrator(
    this.session, {
    this.concurrentTaskLimit = 5,
    this.fileTimeoutSeconds = 30,
    this.maxFilesPerReview = 100,
    this.maxTimePerReview = 300,
    this.maxCriticalFindings = 10,
    FileFilter? fileFilter,
    this.repositoryCache,
  }) : fileFilter = fileFilter ?? FileFilter(session),
       findingsCache = FindingsCache(session);

  /// Processes a complete review workflow for a review session
  Future<void> processReview(int reviewSessionId) async {
    try {
      // Get the review session
      var reviewSession = await ReviewSession.db.findById(session, reviewSessionId);
      if (reviewSession == null) {
        session.log('Review session $reviewSessionId not found', level: LogLevel.error);
        return;
      }

      final pullRequest = await PullRequest.db.findById(session, reviewSession.pullRequestId);
      if (pullRequest == null) {
        await _updateStatus(reviewSessionId, 'failed', 'PullRequest not found');
        return;
      }

      final repository = await Repository.db.findById(session, pullRequest.repositoryId);
      if (repository == null) {
        await _updateStatus(reviewSessionId, 'failed', 'Repository not found');
        return;
      }

      // Stage 1 (0-20%): NavigatorAgent clones repo and builds file list
      await _updateStatus(reviewSessionId, 'initializing', null);
      await _updateProgress(reviewSessionId, 0, 100, 'Cloning repository...');

      NavigatorAgent navigatorAgent = NavigatorAgent();
      
      final navigatorFindings = await navigatorAgent.analyze(
        session,
        reviewSession.pullRequestId,
        reviewSession,
      );
      

      final fileMetadataList = navigatorAgent.fileMetadataList;
      var sortedFiles = navigatorAgent.getFilesToAnalyze();
      
      // Apply file filtering
      final clonedRepoPath = navigatorAgent.clonedRepoPath ?? '';
      sortedFiles = fileFilter.filterFiles(sortedFiles, clonedRepoPath);
      
      // Apply intelligent prioritization
      sortedFiles = _prioritizeFiles(sortedFiles, reviewSession);
      
      // Limit files if configured
      if (maxFilesPerReview > 0 && sortedFiles.length > maxFilesPerReview) {
        session.log('Limiting files to $maxFilesPerReview (found ${sortedFiles.length})');
        sortedFiles = sortedFiles.take(maxFilesPerReview).toList();
      }
      
      await _updateProgress(reviewSessionId, 20, 100, 'Repository cloned, ${sortedFiles.length} files to analyze');

      // Stage 2 (20-60%): Analyze files with ReaderAgent, SecurityAgent, PerformanceAgent
      await _updateStatus(reviewSessionId, 'analyzing', null);
      
      final allFindings = <AgentFinding>[...navigatorFindings];
      int filesProcessed = 0;
      final totalFiles = sortedFiles.length;
      final startTime = DateTime.now();
      int criticalFindingsCount = allFindings.where((f) => f.severity == 'critical').length;

      // Process files in parallel batches
      for (int i = 0; i < sortedFiles.length; i += concurrentTaskLimit) {
        final batch = sortedFiles.skip(i).take(concurrentTaskLimit).toList();
        
        final batchResults = await Future.wait(
          batch.map((fileMetadata) => _processFile(
            fileMetadata.path,
            fileMetadata.language,
            reviewSession.pullRequestId,
            reviewSessionId,
          )),
        );

        for (final findings in batchResults) {
          allFindings.addAll(findings);
          criticalFindingsCount += findings.where((f) => f.severity == 'critical').length;
        }

        // Early termination if too many critical findings
        if (maxCriticalFindings > 0 && criticalFindingsCount >= maxCriticalFindings) {
          session.log('Early termination: $criticalFindingsCount critical findings (limit: $maxCriticalFindings)');
          await _updateStatus(reviewSessionId, 'completed', 'Too many critical findings detected');
          break;
        }

        // Check time limit
        final elapsed = DateTime.now().difference(startTime).inSeconds;
        if (maxTimePerReview > 0 && elapsed >= maxTimePerReview) {
          session.log('Time limit reached: ${elapsed}s (limit: ${maxTimePerReview}s)');
          await _updateStatus(reviewSessionId, 'completed', 'Time limit reached');
          break;
        }

        filesProcessed += batch.length;
        final progress = 20 + ((filesProcessed / totalFiles) * 40).round();
        await _updateProgress(
          reviewSessionId,
          progress,
          100,
          'Analyzed ${filesProcessed}/$totalFiles files',
        );
      }

      await _updateProgress(reviewSessionId, 60, 100, 'Code analysis complete');

      // Stage 3 (60-80%): Generate and verify documentation
      await _updateStatus(reviewSessionId, 'documenting', null);
      
      // Get functions that need documentation (simplified: get from ReaderAgent analysis)
      final functionsNeedingDocs = await _getFunctionsNeedingDocs(sortedFiles, reviewSession.pullRequestId);
      
      int docsProcessed = 0;
      final totalDocs = functionsNeedingDocs.length;

      for (final funcInfo in functionsNeedingDocs) {
        try {
          // Generate documentation
          final docAgent = DocumentationAgent();
          // Initialize with API key from config (would need to pass it)
          // For now, will use template fallback
          
          final documentation = await docAgent.generateAndStore(
            session,
            reviewSession.pullRequestId,
            funcInfo['filePath'] as String,
            funcInfo['functionName'] as String,
            funcInfo['signature'] as String,
            funcInfo['body'] as String,
            funcInfo['language'] as String,
          );

          // Verify documentation
          final verifierAgent = VerifierAgent();
          
          final verification = await verifierAgent.verifyDocumentation(
            documentation.generatedDoc,
            funcInfo['signature'] as String,
            funcInfo['body'] as String,
          );

          await verifierAgent.updateVerificationStatus(
            session,
            documentation.id!,
            verification,
          );

          docsProcessed++;
          final progress = 60 + ((docsProcessed / totalDocs) * 20).round();
          await _updateProgress(
            reviewSessionId,
            progress,
            100,
            'Documented ${docsProcessed}/$totalDocs functions',
          );
        } catch (e) {
          session.log('Error processing documentation for ${funcInfo['functionName']}: $e', level: LogLevel.error);
          // Continue with next function
        }
      }

      await _updateProgress(reviewSessionId, 80, 100, 'Documentation complete');

      // Stage 4 (80-100%): Post findings to GitHub
      await _updateStatus(reviewSessionId, 'posting', null);
      
      try {
        final githubService = GitHubService(session);
        // Initialize with token from config (would need to pass it)
        // For now, will skip if not configured
        
        final owner = repository.owner;
        final repoName = repository.url.split('/').last.replaceAll('.git', '');
        
        await githubService.postReviewComment(
          owner,
          repoName,
          pullRequest.prNumber,
          allFindings,
        );
      } catch (e) {
        session.log('Error posting to GitHub: $e', level: LogLevel.warning);
        // Don't fail the whole review if GitHub posting fails
      }

      await _updateProgress(reviewSessionId, 100, 100, 'Review complete');
      await _updateStatus(reviewSessionId, 'completed', null);

      session.log('Review session $reviewSessionId completed successfully with ${allFindings.length} findings');
    } catch (e) {
      // On error: set status to "failed" and store error message
      await _updateStatus(
        reviewSessionId,
        'failed',
        'Error during review: ${e.toString()}',
      );
      session.log('Review session $reviewSessionId failed: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Processes a single file with multiple agents
  Future<List<AgentFinding>> _processFile(
    String filePath,
    String language,
    int pullRequestId,
    int reviewSessionId,
  ) async {
    try {
      return await _processFileWithTimeout(filePath, language, pullRequestId);
    } catch (e) {
      session.log('Error processing file $filePath: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Processes file with timeout
  Future<List<AgentFinding>> _processFileWithTimeout(
    String filePath,
    String language,
    int pullRequestId,
  ) async {
    return await Future.timeout(
      Duration(seconds: fileTimeoutSeconds),
      () => _analyzeFile(filePath, language, pullRequestId),
    );
  }

  /// Analyzes a file with ReaderAgent, SecurityAgent, and PerformanceAgent
  Future<List<AgentFinding>> _analyzeFile(
    String filePath,
    String language,
    int pullRequestId,
  ) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      return [];
    }

    final content = file.readAsStringSync();
    final allFindings = <AgentFinding>[];

    // Run agents in parallel
    final results = await Future.wait([
      _runReaderAgent(filePath, language, pullRequestId),
      _runSecurityAgent(filePath, content, pullRequestId),
      _runPerformanceAgent(filePath, content, language, pullRequestId),
    ]);

    allFindings.addAll(results[0] as List<AgentFinding>);
    allFindings.addAll(results[1] as List<AgentFinding>);
    allFindings.addAll(results[2] as List<AgentFinding>);

    return allFindings;
  }

  /// Runs ReaderAgent
  Future<List<AgentFinding>> _runReaderAgent(
    String filePath,
    String language,
    int pullRequestId,
  ) async {
      final startTime = DateTime.now();
      try {
        final readerAgent = ReaderAgent();
        final analysis = await readerAgent.analyzeFile(filePath, language);

      // Create findings for high complexity
      final findings = <AgentFinding>[];
      if (analysis.cyclomaticComplexity > 10) {
        findings.add(AgentFinding(
          pullRequestId: pullRequestId,
          agentType: 'reader',
          severity: 'warning',
          category: 'complexity',
          message: 'High cyclomatic complexity (${analysis.cyclomaticComplexity}). Consider refactoring.',
          filePath: filePath,
          lineNumber: null,
          codeSnippet: 'Complexity: ${analysis.cyclomaticComplexity}, Nesting: ${analysis.nestingDepth}',
          suggestedFix: 'Break down complex functions into smaller, more manageable pieces.',
          createdAt: DateTime.now(),
        ));
      }

      if (findings.isNotEmpty) {
        final stored = await Future.wait(
          findings.map((f) => AgentFinding.db.insertRow(session, f)),
        );
        
        // Log performance
        final executionTime = DateTime.now().difference(startTime).inMilliseconds;
        await _logPerformance('reader', filePath, executionTime);
        
        return stored;
      }

      // Log performance even if no findings
      final executionTime = DateTime.now().difference(startTime).inMilliseconds;
      await _logPerformance('reader', filePath, executionTime);

      return [];
    } catch (e) {
      session.log('ReaderAgent error for $filePath: $e', level: LogLevel.error);
      final executionTime = DateTime.now().difference(startTime).inMilliseconds;
      await _logPerformance('reader', filePath, executionTime);
      return [];
    }
  }

  /// Logs performance metrics
  Future<void> _logPerformance(String agentType, String? filePath, int executionTimeMs) async {
    try {
      final log = PerformanceLog(
        agentType: agentType,
        filePath: filePath,
        executionTimeMs: executionTimeMs,
        memoryUsageMB: null, // Would measure in production
        queryCount: null,
        createdAt: DateTime.now(),
      );
      await PerformanceLog.db.insertRow(session, log);
    } catch (e) {
      session.log('Error logging performance: $e', level: LogLevel.error);
    }
  }

  /// Runs SecurityAgent
  Future<List<AgentFinding>> _runSecurityAgent(
    String filePath,
    String content,
    int pullRequestId,
  ) async {
      try {
        final securityAgent = SecurityAgent();
      final findings = await securityAgent.scanFile(filePath, content);
      return await securityAgent.storeFindings(session, pullRequestId, filePath, findings);
    } catch (e) {
      session.log('SecurityAgent error for $filePath: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Runs PerformanceAgent
  Future<List<AgentFinding>> _runPerformanceAgent(
    String filePath,
    String content,
    String language,
    int pullRequestId,
  ) async {
      try {
        final performanceAgent = PerformanceAgent();
      final suggestions = await performanceAgent.analyzePerformance(filePath, content, language);
      return await performanceAgent.storeFindings(session, pullRequestId, filePath, suggestions);
    } catch (e) {
      session.log('PerformanceAgent error for $filePath: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Gets functions that need documentation (simplified implementation)
  Future<List<Map<String, dynamic>>> _getFunctionsNeedingDocs(
    List<dynamic> fileMetadataList,
    int pullRequestId,
  ) async {
    final functions = <Map<String, dynamic>>[];
    
    // Simplified: get functions from files that don't have documentation
    // In production, would check existing GeneratedDocumentation records
    for (final fileMetadata in fileMetadataList.take(10)) { // Limit to 10 for now
      try {
        final readerAgent = ReaderAgent();
        final analysis = await readerAgent.analyzeFile(fileMetadata.path, fileMetadata.language);
        
        for (final func in analysis.functions) {
          functions.add({
            'filePath': fileMetadata.path,
            'functionName': func.name,
            'signature': func.signature,
            'body': func.signature, // Simplified
            'language': fileMetadata.language,
          });
        }
      } catch (e) {
        // Skip files that can't be analyzed
        continue;
      }
    }

    return functions;
  }

  /// Updates the status of a review session
  Future<void> _updateStatus(
    int reviewSessionId,
    String status,
    String? errorMessage,
  ) async {
    final reviewSession = await ReviewSession.db.findById(session, reviewSessionId);
    if (reviewSession == null) return;

    final updated = reviewSession.copyWith(
      status: status,
      errorMessage: errorMessage,
      updatedAt: DateTime.now(),
    );

    await ReviewSession.db.updateRow(session, updated);
  }

  /// Updates the progress of a review session
  Future<void> _updateProgress(
    int reviewSessionId,
    int progressPercent,
    int totalPercent,
    String? currentFile,
  ) async {
    final reviewSession = await ReviewSession.db.findById(session, reviewSessionId);
    if (reviewSession == null) return;

    final updated = reviewSession.copyWith(
      progressPercent: progressPercent.toDouble(),
      currentFile: currentFile,
      updatedAt: DateTime.now(),
    );

    await ReviewSession.db.updateRow(session, updated);
  }
}
