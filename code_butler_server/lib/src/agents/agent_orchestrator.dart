import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';
import 'package:code_butler_server/src/agents/base_agent.dart';
import 'package:code_butler_server/src/agents/navigator_agent.dart';

/// Orchestrates the review process by coordinating multiple agents
class AgentOrchestrator {
  final Session session;

  AgentOrchestrator(this.session);

  /// Runs a complete review workflow for a review session
  Future<void> runReview(int reviewSessionId) async {
    try {
      // 1. Update status to "initializing"
      await _updateStatus(reviewSessionId, 'initializing', null);

      // 2. Get the review session
      final reviewSession = await ReviewSession.db.findById(session, reviewSessionId);
      if (reviewSession == null) {
        session.log('Review session $reviewSessionId not found', level: LogLevel.error);
        return;
      }

      // 3. Update status to "analyzing"
      await _updateStatus(reviewSessionId, 'analyzing', null);

      // 4. Run NavigatorAgent
      final navigatorAgent = NavigatorAgent();
      final findings = await navigatorAgent.analyze(
        session,
        reviewSession.pullRequestId,
        reviewSession,
      );

      session.log('NavigatorAgent completed with ${findings.length} findings');

      // 5. Update progress (placeholder - in real implementation, this would track file processing)
      await _updateProgress(
        reviewSessionId,
        filesProcessed: 1,
        totalFiles: 1,
        currentFile: 'repository_structure',
      );

      // 6. Update status to "completed"
      await _updateStatus(reviewSessionId, 'completed', null);

      session.log('Review session $reviewSessionId completed successfully');
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
    int reviewSessionId, {
    required int filesProcessed,
    required int totalFiles,
    String? currentFile,
  }) async {
    final reviewSession = await ReviewSession.db.findById(session, reviewSessionId);
    if (reviewSession == null) return;

    // Calculate progress percentage
    final progressPercent = totalFiles > 0
        ? (filesProcessed / totalFiles) * 100.0
        : 0.0;

    final updated = reviewSession.copyWith(
      filesProcessed: filesProcessed,
      totalFiles: totalFiles,
      progressPercent: progressPercent,
      currentFile: currentFile,
      updatedAt: DateTime.now(),
    );

    await ReviewSession.db.updateRow(session, updated);
  }
}

