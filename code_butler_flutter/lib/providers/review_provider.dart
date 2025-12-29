import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_butler_client/code_butler_client.dart';
import '../config/serverpod_client.dart';

/// StateNotifier for managing review session state
class ReviewSessionNotifier extends StateNotifier<AsyncValue<ReviewSession>> {
  ReviewSessionNotifier() : super(const AsyncValue.loading());

  /// Start a new review session
  /// Takes only pullRequestId (backend API: startReview(pullRequestId))
  Future<void> startReview(int pullRequestId) async {
    state = const AsyncValue.loading();
    try {
      final client = ClientManager.client;
      // Backend endpoint: startReview(session, pullRequestId)
      final session = await client.review.startReview(pullRequestId);
      state = AsyncValue.data(session);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Get the status of the current review session
  /// Backend API: getReviewStatus(session, reviewSessionId)
  Future<void> getReviewStatus(int sessionId) async {
    try {
      final client = ClientManager.client;
      // Backend endpoint returns ReviewSession? (nullable)
      final session = await client.review.getReviewStatus(sessionId);
      if (session != null) {
        state = AsyncValue.data(session);
      } else {
        state = AsyncValue.error(
          Exception('Review session not found'),
          StackTrace.current,
        );
      }
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
/// Backend API: getFindings(session, pullRequestId, {severity?})
final findingsProvider =
    FutureProvider.family<List<AgentFinding>, int>((ref, pullRequestId) async {
  final client = ClientManager.client;
  // Backend endpoint is on review endpoint: client.review.getFindings(pullRequestId)
  return await client.review.getFindings(pullRequestId);
});

