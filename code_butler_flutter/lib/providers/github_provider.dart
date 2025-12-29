import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/github_auth_service.dart';
import '../services/github_api_service.dart';
import '../config/serverpod_client.dart';
import '../providers/repository_provider.dart';

/// StateNotifier for GitHub authentication status
class AuthStatusNotifier extends StateNotifier<AsyncValue<bool>> {
  final GitHubAuthService _authService = GitHubAuthService();

  AuthStatusNotifier() : super(const AsyncValue.loading()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      state = AsyncValue.data(isAuthenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    try {
      await _authService.authenticateWithGitHub();
      state = const AsyncValue.data(true);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _authService.logout();
      state = const AsyncValue.data(false);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Provider for authentication status
final authStatusProvider =
    StateNotifierProvider<AuthStatusNotifier, AsyncValue<bool>>(
  (ref) => AuthStatusNotifier(),
);

/// Provider for authenticated user information
final githubUserProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final authStatus = ref.watch(authStatusProvider);
  if (authStatus.valueOrNull != true) {
    throw Exception('Not authenticated');
  }

  final apiService = GitHubApiService();
  return await apiService.getUser();
});

/// Provider for user's GitHub repositories
final userRepositoriesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final authStatus = ref.watch(authStatusProvider);
  if (authStatus.valueOrNull != true) {
    throw Exception('Not authenticated');
  }

  final apiService = GitHubApiService();
  return await apiService.getUserRepositories();
});

/// Provider family for pull requests by repository
final pullRequestsProvider = FutureProvider.family<
    List<Map<String, dynamic>>,
    ({String owner, String repo, String state})>((ref, params) async {
  final authStatus = ref.watch(authStatusProvider);
  if (authStatus.valueOrNull != true) {
    throw Exception('Not authenticated');
  }

  final apiService = GitHubApiService();
  return await apiService.getPullRequests(
    params.owner,
    params.repo,
    state: params.state,
  );
});

/// Provider for syncing a GitHub repository to backend
final syncRepositoryProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>(
  (ref, githubRepo) async {
    try {
      final client = ClientManager.client;
      
      // Extract repository information
      final name = githubRepo['name'] as String;
      final url = githubRepo['html_url'] as String;
      final owner = githubRepo['owner']?['login'] as String? ?? '';
      final defaultBranch = githubRepo['default_branch'] as String? ?? 'main';

      // Create repository in backend
      final repository = await client.repository.createRepository(
        name,
        url,
        owner,
        defaultBranch,
      );

      // Invalidate repository list to refresh
      ref.invalidate(repositoryListProvider);

      return {
        'success': true,
        'repository': repository,
        'message': 'Repository synced successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to sync repository',
      };
    }
  },
);

