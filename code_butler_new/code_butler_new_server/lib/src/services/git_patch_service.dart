import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/services/autofix_service.dart';
import 'package:code_butler_new_server/src/services/github_service.dart';
import 'package:github/github.dart' as github;

/// Git patch service for applying fixes
class GitPatchService {
  final Session session;
  final GitHubService githubService;

  GitPatchService(this.session, this.githubService);

  github.GitHub? get _github => (githubService as dynamic)._github;

  /// Creates git diff format patch from fixes
  String createPatch(List<Fix> fixes, String filePath) {
    if (fixes.isEmpty) return '';

    final buffer = StringBuffer();
    buffer.writeln('diff --git a/$filePath b/$filePath');
    buffer.writeln('index 0000000..1111111 100644');
    buffer.writeln('--- a/$filePath');
    buffer.writeln('+++ b/$filePath');

    // Group fixes by line number
    fixes.sort((a, b) => a.lineNumbers.first.compareTo(b.lineNumbers.first));

    for (final fix in fixes) {
      final originalLines = fix.originalCode.split('\n');
      final fixedLines = fix.fixedCode.split('\n');

      // Generate unified diff format
      buffer.writeln('@@ -${fix.lineNumbers.first},${originalLines.length} +${fix.lineNumbers.first},${fixedLines.length} @@');
      
      for (final line in originalLines) {
        buffer.writeln('-$line');
      }
      for (final line in fixedLines) {
        buffer.writeln('+$line');
      }
    }

    return buffer.toString();
  }

  /// Groups fixes by file
  Map<String, List<Fix>> groupFixesByFile(List<Fix> fixes) {
    final grouped = <String, List<Fix>>{};
    for (final fix in fixes) {
      grouped.putIfAbsent(fix.filePath, () => []).add(fix);
    }
    return grouped;
  }

  /// Creates a new branch via GitHub API
  Future<String> createBranch(
    String owner,
    String repo,
    String baseBranch,
    String branchName,
  ) async {
    try {
      final slug = RepositorySlug(owner, repo);
      final github = _github;
      if (github == null) {
        throw Exception('GitHub not authenticated');
      }

      // Get base branch SHA
      final ref = await github.git.getReference(slug, 'heads/$baseBranch');
      final baseSha = ref.object.sha;

      // Create new branch
      await github.git.createReference(
        slug,
        'refs/heads/$branchName',
        baseSha,
      );

      session.log('Created branch $branchName from $baseBranch');
      return branchName;
    } catch (e) {
      session.log('Error creating branch: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Commits changes to a branch
  Future<void> commitChanges(
    String owner,
    String repo,
    String branch,
    Map<String, String> filePatches,
  ) async {
    try {
      final slug = RepositorySlug(owner, repo);
      final github = _github;
      if (github == null) {
        throw Exception('GitHub not authenticated');
      }

      // Get current tree
      final ref = await github.git.getReference(slug, 'heads/$branch');
      final commit = await github.git.getCommit(slug, ref.object.sha!);
      final baseTree = commit.tree.sha!;

      // Create blobs for each file
      final treeItems = <github.CreateGitTreeEntry>[];
      for (final entry in filePatches.entries) {
        final blob = await github.git.createBlob(slug, github.BlobInput(
          content: entry.value,
          encoding: 'utf-8',
        ));
        
        treeItems.add(github.CreateGitTreeEntry(
          path: entry.key,
          mode: '100644',
          type: 'blob',
          sha: blob.sha!,
        ));
      }

      // Create tree
      final tree = await github.git.createTree(slug, github.CreateGitTreeInput(
        baseTree: baseTree,
        tree: treeItems,
      ));

      // Create commit
      await github.git.createCommit(slug, github.CreateGitCommitInput(
        message: 'Apply autofixes from Code Butler',
        tree: tree.sha!,
        parents: [ref.object.sha!],
      ));

      session.log('Committed changes to branch $branch');
    } catch (e) {
      session.log('Error committing changes: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Creates pull request with detailed description
  Future<PullRequest> createPullRequest(
    String owner,
    String repo,
    String baseBranch,
    String headBranch,
    List<Fix> fixes,
  ) async {
    try {
      final slug = RepositorySlug(owner, repo);
      final github = _github;
      if (github == null) {
        throw Exception('GitHub not authenticated');
      }

      final description = _formatPRDescription(fixes);

      final pr = await github.pullRequests.create(
        slug,
        github.CreatePullRequest(
          title: 'Code Butler Autofixes',
          body: description,
          base: baseBranch,
          head: headBranch,
        ),
      );

      session.log('Created PR #${pr.number}: ${pr.title}');
      return pr;
    } catch (e) {
      session.log('Error creating PR: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Formats PR description with fix details
  String _formatPRDescription(List<Fix> fixes) {
    final buffer = StringBuffer();
    buffer.writeln('# Code Butler Autofixes\n');
    buffer.writeln('This PR contains automated fixes generated by Code Butler.\n');

    // Summary statistics
    final byCategory = <String, int>{};
    final byFile = <String, int>{};
    for (final fix in fixes) {
      byCategory['fixes'] = (byCategory['fixes'] ?? 0) + 1;
      byFile[fix.filePath] = (byFile[fix.filePath] ?? 0) + 1;
    }

    buffer.writeln('## Summary\n');
    buffer.writeln('- **Total Fixes:** ${fixes.length}');
    buffer.writeln('- **Files Modified:** ${byFile.length}\n');

    // File-by-file breakdown
    buffer.writeln('## Files Modified\n');
    for (final entry in byFile.entries) {
      buffer.writeln('- `${entry.key}`: ${entry.value} fix(es)');
    }

    buffer.writeln('\n## Fixes by Category\n');
    buffer.writeln('| Category | Count |');
    buffer.writeln('|----------|-------|');
    for (final entry in byCategory.entries) {
      buffer.writeln('| ${entry.key} | ${entry.value} |');
    }

    return buffer.toString();
  }
}

