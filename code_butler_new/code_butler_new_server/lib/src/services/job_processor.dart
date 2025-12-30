import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';
import 'package:code_butler_new_server/src/agents/agent_orchestrator.dart';
import 'package:code_butler_new_server/src/endpoints/review_endpoint.dart';

/// Job processor for background review tasks
class JobProcessor {
  final Session session;
  final int maxWorkers;
  final int retryAttempts;
  final int retryDelaySeconds;
  Timer? _pollTimer;
  final Set<int> _processingJobs = {};

  JobProcessor(
    this.session, {
    this.maxWorkers = 3,
    this.retryAttempts = 3,
    this.retryDelaySeconds = 60,
  });

  /// Starts processing job queue
  void start() {
    session.log('JobProcessor started');
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _processJobQueue();
    });
  }

  /// Stops processing job queue
  void stop() {
    _pollTimer?.cancel();
    session.log('JobProcessor stopped');
  }

  /// Processes pending jobs from queue
  Future<void> _processJobQueue() async {
    if (_processingJobs.length >= maxWorkers) {
      return; // At capacity
    }

    try {
      // Get pending jobs ordered by priority
      final pendingJobs = await ReviewJob.db.find(
        session,
        where: (j) => j.status.equals('pending'),
        orderBy: (j) => j.priority,
        orderDescending: true,
        limit: maxWorkers - _processingJobs.length,
      );

      for (final job in pendingJobs) {
        if (_processingJobs.contains(job.id)) continue;
        _processingJobs.add(job.id!);
        unawaited(_processJob(job.id!));
      }
    } catch (e) {
      session.log('Error processing job queue: $e', level: LogLevel.error);
    }
  }

  /// Processes a single job
  Future<void> _processJob(int jobId) async {
    try {
      final job = await ReviewJob.db.findById(session, jobId);
      if (job == null || job.status != 'pending') {
        _processingJobs.remove(jobId);
        return;
      }

      // Update status to processing
      final updated = job.copyWith(
        status: 'processing',
        startedAt: DateTime.now(),
      );
      await ReviewJob.db.updateRow(session, updated);

      // Get pull request
      final pullRequest = await PullRequest.db.findById(session, job.pullRequestId);
      if (pullRequest == null) {
        await _markJobFailed(jobId, 'PullRequest not found');
        return;
      }

      // Create review session and start review
      final reviewEndpoint = ReviewEndpoint();
      final reviewSession = await reviewEndpoint.startReview(session, pullRequest.id!);

      // Wait for review to complete (simplified - would poll status)
      await Future.delayed(const Duration(seconds: 10));

      // Mark job as completed
      await _markJobCompleted(jobId);
    } catch (e) {
      session.log('Error processing job $jobId: $e', level: LogLevel.error);
      await _handleJobError(jobId, e.toString());
    } finally {
      _processingJobs.remove(jobId);
    }
  }

  /// Marks job as completed
  Future<void> _markJobCompleted(int jobId) async {
    final job = await ReviewJob.db.findById(session, jobId);
    if (job == null) return;

    final updated = job.copyWith(
      status: 'completed',
      completedAt: DateTime.now(),
    );
    await ReviewJob.db.updateRow(session, updated);
  }

  /// Marks job as failed
  Future<void> _markJobFailed(int jobId, String errorMessage) async {
    final job = await ReviewJob.db.findById(session, jobId);
    if (job == null) return;

    final updated = job.copyWith(
      status: 'failed',
      errorMessage: errorMessage,
      completedAt: DateTime.now(),
    );
    await ReviewJob.db.updateRow(session, updated);
  }

  /// Handles job error with retry logic
  Future<void> _handleJobError(int jobId, String errorMessage) async {
    final job = await ReviewJob.db.findById(session, jobId);
    if (job == null) return;

    if (job.retryCount < retryAttempts) {
      // Retry with exponential backoff
      final delay = Duration(seconds: retryDelaySeconds * (job.retryCount + 1));
      session.log('Retrying job $jobId after ${delay.inSeconds}s (attempt ${job.retryCount + 1}/$retryAttempts)');

      final updated = job.copyWith(
        status: 'pending',
        retryCount: job.retryCount + 1,
        errorMessage: errorMessage,
      );
      await ReviewJob.db.updateRow(session, updated);

      // Schedule retry
      Future.delayed(delay, () {
        _processingJobs.remove(jobId);
      });
    } else {
      // Max retries reached
      await _markJobFailed(jobId, 'Max retries reached: $errorMessage');
    }
  }

  /// Retries a failed job
  Future<void> retryFailedJob(int jobId) async {
    final job = await ReviewJob.db.findById(session, jobId);
    if (job == null) return;

    final updated = job.copyWith(
      status: 'pending',
      retryCount: 0,
      errorMessage: null,
    );
    await ReviewJob.db.updateRow(session, updated);
  }
}

// Helper to avoid await warning
void unawaited(Future<void> future) {
  future.catchError((error) {
    // Errors are logged in the background task
  });
}

