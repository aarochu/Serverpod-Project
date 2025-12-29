import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_butler_client/code_butler_client.dart';
import '../config/serverpod_client.dart';

/// StateNotifier for managing review session state
class ReviewSessionNotifier extends StateNotifier<AsyncValue<ReviewSession>> {
  ReviewSessionNotifier() : super(const AsyncValue.loading());

  /// Start a new review session
  Future<void> startReview(int repositoryId, int prNumber) async {
    state = const AsyncValue.loading();
    try {
      final client = ClientManager.client;
      // Assuming endpoint: client.review.startReview(repositoryId, prNumber)
      // This will be available after Person 1 creates the backend endpoints
      final session = await client.review.startReview(
        repositoryId: repositoryId,
        prNumber: prNumber,
      );
      state = AsyncValue.data(session);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh the status of the current review session
  Future<void> refreshStatus(int sessionId) async {
    try {
      final client = ClientManager.client;
      // Assuming endpoint: client.review.refreshStatus(sessionId)
      // This will be available after Person 1 creates the backend endpoints
      final session = await client.review.refreshStatus(sessionId: sessionId);
      state = AsyncValue.data(session);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for review session state
final reviewSessionProvider =
    StateNotifierProvider<ReviewSessionNotifier, AsyncValue<ReviewSession>>(
  (ref) => ReviewSessionNotifier(),
);

/// Provider family for fetching findings by pull request ID
/// 
/// Usage: ref.watch(findingsProvider(pullRequestId))
final findingsProvider =
    FutureProvider.family<List<AgentFinding>, int>((ref, pullRequestId) async {
  final client = ClientManager.client;
  // Assuming endpoint: client.findings.getFindings(pullRequestId)
  // This will be available after Person 1 creates the backend endpoints
  return await client.findings.getFindings(pullRequestId: pullRequestId);
});

