import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';
import 'package:code_butler_server/src/agents/agent_orchestrator.dart';

// Helper to avoid await warning for fire-and-forget futures
void unawaited(Future<void> future) {
  future.catchError((error) {
    // Errors are logged in the background task
  });
}

class ReviewEndpoint extends Endpoint {
  /// Starts a new review session for a pull request
  /// Spawns async background task to run agent processing
  Future<ReviewSession> startReview(Session session, int pullRequestId) async {
    try {
      final now = DateTime.now();
      final reviewSession = ReviewSession(
        pullRequestId: pullRequestId,
        status: 'initializing',
        currentFile: null,
        filesProcessed: 0,
        totalFiles: 0,
        progressPercent: 0.0,
        errorMessage: null,
        createdAt: now,
        updatedAt: now,
      );

      final created = await ReviewSession.db.insertRow(session, reviewSession);
      session.log('Started review session: ${created.id} for PR $pullRequestId');

      // Spawn async background task to run agent processing
      // Don't await - let it run asynchronously
      unawaited(_runAgentProcessing(session, created.id!));

      return created;
    } catch (e) {
      session.log('Error starting review: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Runs agent processing in background
  Future<void> _runAgentProcessing(Session session, int reviewSessionId) async {
    try {
      session.log('Starting agent processing for review session $reviewSessionId');
      
      // Check for demo mode
      final demoMode = session.serverpod.config.extra?['demoMode'] as bool? ?? false;
      
      final orchestrator = AgentOrchestrator(
        session,
        demoMode: demoMode,
        fileTimeoutSeconds: demoMode ? 10 : 30,
        maxFilesPerReview: demoMode ? 50 : 500,
      );
      
      await orchestrator.processReview(reviewSessionId);
      session.log('Agent processing completed for review session $reviewSessionId');
    } catch (e) {
      session.log('Error in agent processing: $e', level: LogLevel.error);
      // Error already handled in orchestrator, just log here
    }
  }

  /// Gets the current status of a review session
  Future<ReviewSession?> getReviewStatus(Session session, int reviewSessionId) async {
    try {
      final reviewSession = await ReviewSession.db.findById(session, reviewSessionId);
      return reviewSession;
    } catch (e) {
      session.log('Error getting review status: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Gets all findings for a pull request, optionally filtered by severity
  Future<List<AgentFinding>> getFindings(
    Session session,
    int pullRequestId, {
    String? severity,
  }) async {
    try {
      var query = AgentFinding.db.find(
        session,
        where: (f) => f.pullRequestId.equals(pullRequestId),
      );

      if (severity != null) {
        query = AgentFinding.db.find(
          session,
          where: (f) => f.pullRequestId.equals(pullRequestId) & f.severity.equals(severity),
        );
      }

      final findings = await query;
      
      // Sort by severity (critical > warning > info), then by createdAt
      findings.sort((a, b) {
        final severityOrder = {'critical': 0, 'warning': 1, 'info': 2};
        final aOrder = severityOrder[a.severity] ?? 3;
        final bOrder = severityOrder[b.severity] ?? 3;
        
        if (aOrder != bOrder) {
          return aOrder.compareTo(bOrder);
        }
        
        return a.createdAt.compareTo(b.createdAt);
      });

      return findings;
    } catch (e) {
      session.log('Error getting findings: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Streams review progress updates, polling every 2 seconds
  Stream<String> watchReviewProgress(Session session, int reviewSessionId) async* {
    try {
      while (true) {
        final reviewSession = await ReviewSession.db.findById(session, reviewSessionId);
        
        if (reviewSession == null) {
          yield 'error:0.0:Session not found';
          break;
        }

        final status = reviewSession.status;
        final progress = reviewSession.progressPercent;
        final currentFile = reviewSession.currentFile ?? '';

        // Format: "status:progress:currentFile"
        yield '$status:$progress:$currentFile';

        // Stop streaming if review is completed or failed
        if (status == 'completed' || status == 'failed') {
          break;
        }

        // Wait 2 seconds before next poll
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e) {
      session.log('Error watching review progress: $e', level: LogLevel.error);
      yield 'error:0.0:${e.toString()}';
    }
  }
}

