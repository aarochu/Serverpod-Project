import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:code_butler_client/code_butler_client.dart';
import '../providers/repository_provider.dart';
import '../providers/github_provider.dart';
import '../providers/review_provider.dart';
import '../config/serverpod_client.dart';
import 'review_progress_screen.dart';

/// Screen displaying pull requests for a repository
class PullRequestListScreen extends ConsumerStatefulWidget {
  final int repositoryId;

  const PullRequestListScreen({
    super.key,
    required this.repositoryId,
  });

  @override
  ConsumerState<PullRequestListScreen> createState() =>
      _PullRequestListScreenState();
}

class _PullRequestListScreenState
    extends ConsumerState<PullRequestListScreen> {
  String _selectedFilter = 'all'; // all, open, closed

  Color _getStatusColor(String? state) {
    switch (state?.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      case 'merged':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String? state) {
    switch (state?.toLowerCase()) {
      case 'open':
        return 'Open';
      case 'closed':
        return 'Closed';
      case 'merged':
        return 'Merged';
      default:
        return 'Unknown';
    }
  }

  Future<void> _startReview(
    BuildContext context,
    Map<String, dynamic> prData,
  ) async {
    try {
      final client = ClientManager.client;
      
      // Extract PR information
      final prNumber = prData['number'] as int;
      final title = prData['title'] as String? ?? 'Untitled PR';
      final baseBranch = prData['base']?['ref'] as String? ?? 'main';
      final headBranch = prData['head']?['ref'] as String? ?? 'feature';
      final filesChanged = prData['changed_files'] as int? ?? 0;

      // Create PullRequest in backend
      final pullRequest = await client.pullRequest.createPullRequest(
        widget.repositoryId,
        prNumber,
        title,
        baseBranch,
        headBranch,
        filesChanged,
      );

      // Start review session
      final reviewSession = await client.review.startReview(pullRequest.id);

      // Navigate to review progress screen
      if (context.mounted) {
        context.go('/review/${reviewSession.id}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start review: $e'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _startReview(context, prData),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final repositoryAsync = ref.watch(
      repositoryListProvider.select(
        (value) => value.value?.firstWhere(
          (repo) => repo.id == widget.repositoryId,
          orElse: () => throw Exception('Repository not found'),
        ),
      ),
    );

    return repositoryAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Pull Requests')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Pull Requests')),
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
      data: (repository) {
        // Fetch PRs from GitHub API
        final owner = repository.owner;
        final repo = repository.name;
        final prsAsync = ref.watch(
          pullRequestsProvider((owner: owner, repo: repo, state: _selectedFilter)),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('PRs: ${repository.name}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref.invalidate(
                    pullRequestsProvider((owner: owner, repo: repo, state: _selectedFilter)),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedFilter == 'all',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedFilter = 'all');
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Open'),
                      selected: _selectedFilter == 'open',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedFilter = 'open');
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Closed'),
                      selected: _selectedFilter == 'closed',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedFilter = 'closed');
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // PR list
              Expanded(
                child: prsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading pull requests',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () {
                              ref.invalidate(
                                pullRequestsProvider((owner: owner, repo: repo, state: _selectedFilter)),
                              );
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (prs) {
                    if (prs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.pull_request,
                                size: 64,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No pull requests',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create a pull request on GitHub to get started',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(
                          pullRequestsProvider((owner: owner, repo: repo, state: _selectedFilter)),
                        );
                      },
                      child: ListView.builder(
                        itemCount: prs.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final pr = prs[index];
                          final state = pr['state'] as String?;
                          final isMerged = pr['merged_at'] != null;
                          final statusColor = _getStatusColor(
                            isMerged ? 'merged' : state,
                          );

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 4,
                                color: statusColor,
                              ),
                              title: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '#${pr['number']}',
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      pr['title'] as String? ?? 'Untitled',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    '${pr['base']?['ref']} ← ${pr['head']?['ref']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.insert_drive_file,
                                        size: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${pr['changed_files'] ?? 0} files changed',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: FilledButton(
                                onPressed: () => _startReview(context, pr),
                                child: const Text('Start Review'),
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

