import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';

/// Notification service for review events
class NotificationService {
  final Session session;

  NotificationService(this.session);

  /// Creates a notification
  Future<void> createNotification(
    String userId,
    int reviewSessionId,
    String type,
    String message,
  ) async {
    try {
      final notification = ReviewNotification(
        userId: userId,
        reviewSessionId: reviewSessionId,
        type: type,
        message: message,
        read: false,
        createdAt: DateTime.now(),
      );
      await ReviewNotification.db.insertRow(session, notification);
      session.log('Created notification for user $userId: $type');
    } catch (e) {
      session.log('Error creating notification: $e', level: LogLevel.error);
    }
  }

  /// Notifies when review completes
  Future<void> notifyOnCompletion(int reviewSessionId) async {
    try {
      final reviewSession = await ReviewSession.db.findById(session, reviewSessionId);
      if (reviewSession == null) return;

      final pullRequest = await PullRequest.db.findById(session, reviewSession.pullRequestId);
      if (pullRequest == null) return;

      // Get PR author (simplified - would get from GitHub)
      final userId = 'user_${pullRequest.id}'; // Placeholder

      await createNotification(
        userId,
        reviewSessionId,
        'completed',
        'Review completed for PR #${pullRequest.prNumber}',
      );
    } catch (e) {
      session.log('Error notifying on completion: $e', level: LogLevel.error);
    }
  }

  /// Notifies on critical findings
  Future<void> notifyOnCriticalFindings(
    int reviewSessionId,
    List<AgentFinding> findings,
  ) async {
    try {
      final reviewSession = await ReviewSession.db.findById(session, reviewSessionId);
      if (reviewSession == null) return;

      final pullRequest = await PullRequest.db.findById(session, reviewSession.pullRequestId);
      if (pullRequest == null) return;

      final criticalCount = findings.where((f) => f.severity == 'critical').length;
      if (criticalCount == 0) return;

      final userId = 'user_${pullRequest.id}'; // Placeholder

      await createNotification(
        userId,
        reviewSessionId,
        'critical',
        '⚠️ $criticalCount critical findings detected in PR #${pullRequest.prNumber}',
      );
    } catch (e) {
      session.log('Error notifying on critical findings: $e', level: LogLevel.error);
    }
  }
}

