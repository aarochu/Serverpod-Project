import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:code_butler_client/code_butler_client.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../providers/repository_provider.dart';
import '../providers/github_provider.dart';
import 'package:shimmer/shimmer.dart';

/// Screen displaying list of repositories
class RepositoryListScreen extends ConsumerWidget {
  const RepositoryListScreen({super.key});

  void _showAddRepositoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Repository'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.cloud),
              title: const Text('Add from GitHub'),
              subtitle: const Text('Sync repositories from your GitHub account'),
              onTap: () {
                Navigator.pop(context);
                _showGitHubRepositories(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Add Manually'),
              subtitle: const Text('Enter repository details manually'),
              onTap: () {
                Navigator.pop(context);
                _showManualAddDialog(context, ref);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showGitHubRepositories(BuildContext context, WidgetRef ref) {
    final githubReposAsync = ref.watch(userRepositoriesProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Repository'),
        content: SizedBox(
          width: double.maxFinite,
          child: githubReposAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Error: $error'),
            data: (repos) {
              if (repos.isEmpty) {
                return const Text('No repositories found');
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: repos.length,
                itemBuilder: (context, index) {
                  final repo = repos[index];
                  return ListTile(
                    title: Text(repo['name'] as String? ?? ''),
                    subtitle: Text(repo['full_name'] as String? ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.sync),
                      onPressed: () async {
                        final syncResult = await ref.read(
                          syncRepositoryProvider(repo).future,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              syncResult['success'] == true
                                  ? 'Repository synced successfully'
                                  : syncResult['message'] as String? ?? 'Sync failed',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showManualAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    final ownerController = TextEditingController();
    final branchController = TextEditingController(text: 'main');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Repository Manually'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Repository Name',
                  hintText: 'my-repo',
                ),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'Repository URL',
                  hintText: 'https://github.com/owner/repo',
                ),
              ),
              TextField(
                controller: ownerController,
                decoration: const InputDecoration(
                  labelText: 'Owner',
                  hintText: 'username',
                ),
              ),
              TextField(
                controller: branchController,
                decoration: const InputDecoration(
                  labelText: 'Default Branch',
                  hintText: 'main',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await ref.read(
                  createRepositoryProvider((
                    name: nameController.text,
                    url: urlController.text,
                    owner: ownerController.text,
                    defaultBranch: branchController.text,
                  )).future,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Repository added successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repositoryListAsync = ref.watch(repositoryListProvider);
    final authStatus = ref.watch(authStatusProvider);
    final githubUserAsync = ref.watch(githubUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
        actions: [
          // GitHub login/logout button
          authStatus.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => IconButton(
              icon: const Icon(Icons.login),
              onPressed: () async {
                try {
                  await ref.read(authStatusProvider.notifier).login();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged in successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: $e')),
                  );
                }
              },
              tooltip: 'Login with GitHub',
            ),
            data: (isAuthenticated) {
              if (!isAuthenticated) {
                return IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () async {
                    try {
                      await ref.read(authStatusProvider.notifier).login();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged in successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login failed: $e')),
                      );
                    }
                  },
                  tooltip: 'Login with GitHub',
                );
              }
              return githubUserAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await ref.read(authStatusProvider.notifier).logout();
                  },
                  tooltip: 'Logout',
                ),
                data: (user) => PopupMenuButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: user['avatar_url'] != null
                          ? NetworkImage(user['avatar_url'] as String)
                          : null,
                      child: user['avatar_url'] == null
                          ? Text(
                              (user['login'] as String? ?? 'U')[0].toUpperCase(),
                            )
                          : null,
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: false,
                      child: Text(
                        user['login'] as String? ?? 'User',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                      onTap: () async {
                        await ref.read(authStatusProvider.notifier).logout();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(repositoryListProvider);
              if (authStatus.valueOrNull == true) {
                ref.invalidate(userRepositoriesProvider);
              }
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: repositoryListAsync.when(
        loading: () => ListView.builder(
          itemCount: 5,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) => _RepositoryCardSkeleton(),
        ),
        error: (error, stackTrace) => Center(
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
                  'Error loading repositories',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    ref.invalidate(repositoryListProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (repositories) {
          if (repositories.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No repositories yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      authStatus.valueOrNull == true
                          ? 'Sync a repository from GitHub or add one manually'
                          : 'Login with GitHub to sync repositories or add one manually',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => _showAddRepositoryDialog(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Repository'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(repositoryListProvider);
              if (authStatus.valueOrNull == true) {
                ref.invalidate(userRepositoriesProvider);
              }
            },
            child: ListView.builder(
              itemCount: repositories.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final repository = repositories[index];
                return _RepositoryCard(
                  repository: repository,
                  onTap: () {
                    context.go('/repositories/${repository.id}/pull-requests');
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRepositoryDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Repository'),
      ),
    );
  }
}

/// Card widget for displaying repository information
class _RepositoryCard extends StatelessWidget {
  final Repository repository;
  final VoidCallback onTap;

  const _RepositoryCard({
    required this.repository,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.folder,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  repository.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // PR count badge placeholder
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '0 PRs',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Owner: ${repository.owner}'),
              const SizedBox(height: 4),
              Text(
                repository.url,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (repository.defaultBranch.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Branch: ${repository.defaultBranch}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (repository.lastReviewedAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Last reviewed: ${timeago.format(repository.lastReviewedAt!)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: onTap,
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}

/// Skeleton loading card for repositories
class _RepositoryCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surfaceVariant,
        highlightColor: Theme.of(context).colorScheme.surface,
        child: ListTile(
          leading: CircleAvatar(),
          title: Container(
            height: 16,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 12,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
