import 'dart:async';
import 'dart:math';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';
import 'package:github/github.dart';

/// GitHub service for repository and PR operations
class GitHubService {
  final Session session;
  GitHub? _github;
  String? _token;

  GitHubService(this.session);

  /// Authenticates with GitHub using a personal access token
  void authenticateWithToken(String token) {
    _token = token;
    if (token.isNotEmpty && token != 'YOUR_GITHUB_TOKEN') {
      _github = GitHub(auth: Authentication.withToken(token));
      session.log('GitHub authentication successful');
    } else {
      session.log('GitHub token not configured', level: LogLevel.warning);
    }
  }

  /// Fetches repository metadata
  Future<Repository> fetchRepository(String owner, String repoName) async {
    if (_github == null) {
      throw Exception('GitHub not authenticated. Call authenticateWithToken first.');
    }

    try {
      final repo = await _github!.repositories.getRepository(
        RepositorySlug(owner, repoName),
      );

      session.log('Fetched repository: ${repo.fullName}');
      return repo;
    } catch (e) {
      session.log('Error fetching repository: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Fetches pull request details
  Future<PullRequest> fetchPullRequest(
    String owner,
    String repoName,
    int prNumber,
  ) async {
    if (_github == null) {
      throw Exception('GitHub not authenticated. Call authenticateWithToken first.');
    }

    try {
      final slug = RepositorySlug(owner, repoName);
      final pr = await _github!.pullRequests.get(slug, prNumber);

      session.log('Fetched PR #$prNumber: ${pr.title}');
      return pr;
    } catch (e) {
      session.log('Error fetching pull request: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Posts review comment with formatted findings
  Future<void> postReviewComment(
    String owner,
    String repoName,
    int prNumber,
    List<AgentFinding> findings,
  ) async {
    if (_github == null) {
      session.log('GitHub not authenticated. Skipping comment posting.', level: LogLevel.warning);
      return;
    }

    try {
      final comment = _formatFindingsAsMarkdown(findings);
      final slug = RepositorySlug(owner, repoName);

      await _postCommentWithRetry(slug, prNumber, comment);
      session.log('Posted review comment to PR #$prNumber');
    } catch (e) {
      session.log('Error posting review comment: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Formats findings as markdown table
  String _formatFindingsAsMarkdown(List<AgentFinding> findings) {
    if (findings.isEmpty) {
      return '## Code Review Results\n\n✅ No issues found!';
    }

    // Calculate summary statistics
    final totalFindings = findings.length;
    final bySeverity = <String, int>{};
    final byCategory = <String, int>{};
    final byAgent = <String, int>{};

    for (final finding in findings) {
      bySeverity[finding.severity] = (bySeverity[finding.severity] ?? 0) + 1;
      byCategory[finding.category] = (byCategory[finding.category] ?? 0) + 1;
      byAgent[finding.agentType] = (byAgent[finding.agentType] ?? 0) + 1;
    }

    final buffer = StringBuffer();
    buffer.writeln('## Code Review Results\n');
    buffer.writeln('### Summary\n');
    buffer.writeln('- **Total Findings:** $totalFindings\n');

    if (bySeverity.isNotEmpty) {
      buffer.writeln('**By Severity:**');
      bySeverity.forEach((severity, count) {
        final emoji = severity == 'critical' ? '🔴' : severity == 'warning' ? '🟡' : '🔵';
        buffer.writeln('- $emoji $severity: $count');
      });
      buffer.writeln();
    }

    if (byCategory.isNotEmpty) {
      buffer.writeln('**By Category:**');
      byCategory.forEach((category, count) {
        buffer.writeln('- $category: $count');
      });
      buffer.writeln();
    }

    if (byAgent.isNotEmpty) {
      buffer.writeln('**By Agent:**');
      byAgent.forEach((agent, count) {
        buffer.writeln('- $agent: $count');
      });
      buffer.writeln();
    }

    buffer.writeln('### Detailed Findings\n');
    buffer.writeln('| File | Line | Severity | Agent | Message |');
    buffer.writeln('|------|------|----------|-------|---------|');

    for (final finding in findings) {
      final file = finding.filePath ?? 'N/A';
      final line = finding.lineNumber?.toString() ?? 'N/A';
      final severity = _getSeverityEmoji(finding.severity);
      final agent = finding.agentType;
      final message = finding.message.replaceAll('|', '\\|').replaceAll('\n', ' ');

      buffer.writeln('| $file | $line | $severity ${finding.severity} | $agent | $message |');
    }

    return buffer.toString();
  }

  /// Gets emoji for severity
  String _getSeverityEmoji(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return '🔴';
      case 'warning':
        return '🟡';
      case 'info':
        return '🔵';
      default:
        return '⚪';
    }
  }

  /// Posts comment with retry logic and rate limiting handling
  Future<void> _postCommentWithRetry(
    RepositorySlug slug,
    int prNumber,
    String comment,
    {int maxRetries = 3}
  ) async {
    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        await _github!.issues.createComment(slug, prNumber, comment);
        return;
      } on RateLimit {
        // Handle rate limiting
        final resetTime = DateTime.now().add(const Duration(minutes: 1));
        session.log('Rate limit exceeded. Waiting until $resetTime', level: LogLevel.warning);
        await Future.delayed(const Duration(minutes: 1));
        retryCount++;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          rethrow;
        }
        
        // Exponential backoff
        final delay = Duration(seconds: pow(2, retryCount).toInt());
        await Future.delayed(delay);
      }
    }
  }
}

