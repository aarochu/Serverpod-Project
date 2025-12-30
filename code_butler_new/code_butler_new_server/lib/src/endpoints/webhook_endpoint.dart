import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';
import 'package:code_butler_new_server/src/services/job_processor.dart';

/// Webhook endpoint for GitHub event handling
class WebhookEndpoint extends Endpoint {
  /// Handles pull request events from GitHub
  Future<void> handlePullRequest(
    Session session,
    Map<String, dynamic> payload,
    String? signature,
  ) async {
    try {
      // Verify signature if provided
      if (signature != null) {
        // TODO: Access config values properly in Serverpod 3
        // For now, skip signature verification
        session.log('Webhook signature verification skipped (config access pending)', level: LogLevel.warning);
      }

      // Store webhook event
      await _storeWebhookEvent(session, 'pull_request', payload, signature);

      final action = payload['action'] as String?;
      if (action == 'opened' || action == 'synchronize') {
        // Get PR details
        final prData = payload['pull_request'] as Map<String, dynamic>?;
        if (prData == null) return;

        final repoData = payload['repository'] as Map<String, dynamic>?;
        if (repoData == null) return;

        final owner = repoData['owner']?['login'] as String?;
        final repoName = repoData['name'] as String?;
        final prNumber = prData['number'] as int?;

        if (owner == null || repoName == null || prNumber == null) return;

        // Find or create repository
        final repoUrl = repoData['clone_url'] as String? ?? '';
        var repository = await Repository.db.findFirstRow(
          session,
          where: (r) => r.url.equals(repoUrl),
        );

        if (repository == null) {
          repository = Repository(
            name: repoName,
            url: repoUrl,
            owner: owner,
            defaultBranch: repoData['default_branch'] as String? ?? 'main',
            lastReviewedAt: null,
          );
          await Repository.db.insertRow(session, repository);
        }

        // Find or create pull request
        var pullRequest = await PullRequest.db.findFirstRow(
          session,
          where: (pr) => pr.repositoryId.equals(repository!.id!) & pr.prNumber.equals(prNumber),
        );

        if (pullRequest == null) {
          pullRequest = PullRequest(
            repositoryId: repository.id!,
            prNumber: prNumber,
            title: prData['title'] as String? ?? '',
            status: 'pending',
            baseBranch: prData['base']?['ref'] as String? ?? 'main',
            headBranch: prData['head']?['ref'] as String? ?? '',
            filesChanged: prData['changed_files'] as int? ?? 0,
            createdAt: DateTime.parse(prData['created_at'] as String),
            updatedAt: DateTime.now(),
          );
          await PullRequest.db.insertRow(session, pullRequest);
        }

        // Create review job
        final job = ReviewJob(
          pullRequestId: pullRequest.id!,
          status: 'pending',
          priority: action == 'opened' ? 1 : 2,
          retryCount: 0,
          errorMessage: null,
          createdAt: DateTime.now(),
          startedAt: null,
          completedAt: null,
        );
        await ReviewJob.db.insertRow(session, job);

        session.log('Created review job for PR #$prNumber');
      }
    } catch (e) {
      session.log('Error handling pull request webhook: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Handles push events from GitHub
  Future<void> handlePush(
    Session session,
    Map<String, dynamic> payload,
    String? signature,
  ) async {
    try {
      // Verify signature
      if (signature != null) {
        // TODO: Access config values properly in Serverpod 3
        // For now, skip signature verification
        session.log('Webhook signature verification skipped (config access pending)', level: LogLevel.warning);
      }

      // Store webhook event
      await _storeWebhookEvent(session, 'push', payload, signature);

      // Could trigger re-review of affected PRs
      session.log('Push event received');
    } catch (e) {
      session.log('Error handling push webhook: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Verifies GitHub webhook signature
  bool _verifySignature(Map<String, dynamic> payload, String signature, String secret) {
    try {
      final payloadStr = jsonEncode(payload);
      final hmac = Hmac(sha256, utf8.encode(secret));
      final digest = hmac.convert(utf8.encode(payloadStr));
      final expected = 'sha256=${digest.toString()}';
      return signature == expected;
    } catch (e) {
      return false;
    }
  }

  /// Stores webhook event for audit trail
  Future<void> _storeWebhookEvent(
    Session session,
    String eventType,
    Map<String, dynamic> payload,
    String? signature,
  ) async {
    try {
      final event = WebhookEvent(
        eventType: eventType,
        payload: jsonEncode(payload),
        signature: signature,
        processed: false,
        createdAt: DateTime.now(),
      );
      await WebhookEvent.db.insertRow(session, event);
    } catch (e) {
      session.log('Error storing webhook event: $e', level: LogLevel.error);
    }
  }
}

