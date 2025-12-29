import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';

class PullRequestEndpoint extends Endpoint {
  /// Creates a new pull request
  Future<PullRequest> createPullRequest(
    Session session,
    int repositoryId,
    int prNumber,
    String title,
    String baseBranch,
    String headBranch,
    int filesChanged,
  ) async {
    try {
      final now = DateTime.now();
      final pullRequest = PullRequest(
        repositoryId: repositoryId,
        prNumber: prNumber,
        title: title,
        status: 'pending',
        baseBranch: baseBranch,
        headBranch: headBranch,
        filesChanged: filesChanged,
        createdAt: now,
        updatedAt: now,
      );

      final created = await PullRequest.db.insertRow(session, pullRequest);
      session.log('Created pull request: ${created.id} - PR #$prNumber');
      return created;
    } catch (e) {
      session.log('Error creating pull request: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Lists all pull requests for a repository, ordered by PR number descending
  Future<List<PullRequest>> listPullRequests(Session session, int repositoryId) async {
    try {
      final pullRequests = await PullRequest.db.find(
        session,
        where: (pr) => pr.repositoryId.equals(repositoryId),
        orderBy: (pr) => pr.prNumber,
        orderDescending: true,
      );
      return pullRequests;
    } catch (e) {
      session.log('Error listing pull requests: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Gets a pull request by repository ID and PR number
  Future<PullRequest?> getPullRequest(
    Session session,
    int repositoryId,
    int prNumber,
  ) async {
    try {
      final pullRequest = await PullRequest.db.findFirstRow(
        session,
        where: (pr) => pr.repositoryId.equals(repositoryId) & pr.prNumber.equals(prNumber),
      );
      return pullRequest;
    } catch (e) {
      session.log('Error getting pull request: $e', level: LogLevel.error);
      return null;
    }
  }
}

