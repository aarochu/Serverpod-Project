import 'package:http/http.dart' as http;
import 'dart:convert';
import 'github_auth_service.dart';

/// Service for interacting with GitHub REST API v3
class GitHubApiService {
  final GitHubAuthService _authService = GitHubAuthService();

  /// Get headers with authorization token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getStoredToken();
    if (token == null) {
      throw Exception('Not authenticated with GitHub');
    }

    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    };
  }

  /// Handle rate limiting errors
  void _handleRateLimit(http.Response response) {
    if (response.statusCode == 403) {
      final remaining = response.headers['x-ratelimit-remaining'];
      if (remaining == '0') {
        final resetTime = response.headers['x-ratelimit-reset'];
        throw Exception(
          'GitHub API rate limit exceeded. Please try again later.',
        );
      }
    }
  }

  /// Get authenticated user's repositories
  Future<List<Map<String, dynamic>>> getUserRepositories() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.https('api.github.com', '/user/repos', {
          'sort': 'updated',
          'per_page': '100',
        }),
        headers: headers,
      );

      _handleRateLimit(response);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch repositories: ${response.statusCode}',
        );
      }

      final List<dynamic> data = jsonDecode(response.body);
      return data.map((repo) => repo as Map<String, dynamic>).toList();
    } catch (e) {
      if (e.toString().contains('rate limit')) {
        rethrow;
      }
      throw Exception('Error fetching repositories: $e');
    }
  }

  /// Get authenticated user information
  Future<Map<String, dynamic>> getUser() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.https('api.github.com', '/user'),
        headers: headers,
      );

      _handleRateLimit(response);

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch user: ${response.statusCode}');
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      if (e.toString().contains('rate limit')) {
        rethrow;
      }
      throw Exception('Error fetching user: $e');
    }
  }

  /// Get pull requests for a repository
  Future<List<Map<String, dynamic>>> getPullRequests(
    String owner,
    String repo, {
    String state = 'all', // open, closed, or all
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.https(
          'api.github.com',
          '/repos/$owner/$repo/pulls',
          {
            'state': state,
            'sort': 'updated',
            'direction': 'desc',
            'per_page': '100',
          },
        ),
        headers: headers,
      );

      _handleRateLimit(response);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch pull requests: ${response.statusCode}',
        );
      }

      final List<dynamic> data = jsonDecode(response.body);
      return data.map((pr) => pr as Map<String, dynamic>).toList();
    } catch (e) {
      if (e.toString().contains('rate limit')) {
        rethrow;
      }
      throw Exception('Error fetching pull requests: $e');
    }
  }

  /// Get files changed in a pull request
  Future<List<Map<String, dynamic>>> getFileChanges(
    String owner,
    String repo,
    int prNumber,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.https(
          'api.github.com',
          '/repos/$owner/$repo/pulls/$prNumber/files',
          {'per_page': '100'},
        ),
        headers: headers,
      );

      _handleRateLimit(response);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch file changes: ${response.statusCode}',
        );
      }

      final List<dynamic> data = jsonDecode(response.body);
      return data.map((file) => file as Map<String, dynamic>).toList();
    } catch (e) {
      if (e.toString().contains('rate limit')) {
        rethrow;
      }
      throw Exception('Error fetching file changes: $e');
    }
  }

  /// Get a specific pull request
  Future<Map<String, dynamic>> getPullRequest(
    String owner,
    String repo,
    int prNumber,
  ) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.https(
          'api.github.com',
          '/repos/$owner/$repo/pulls/$prNumber',
        ),
        headers: headers,
      );

      _handleRateLimit(response);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch pull request: ${response.statusCode}',
        );
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      if (e.toString().contains('rate limit')) {
        rethrow;
      }
      throw Exception('Error fetching pull request: $e');
    }
  }
}

