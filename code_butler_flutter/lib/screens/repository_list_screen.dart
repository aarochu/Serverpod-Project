import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:code_butler_client/code_butler_client.dart';
import '../providers/repository_provider.dart';

/// Screen displaying list of repositories
class RepositoryListScreen extends ConsumerWidget {
  const RepositoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repositoryListAsync = ref.watch(repositoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(repositoryListProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: repositoryListAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
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
                      'Add a repository to get started with code reviews',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
              ref.invalidate(repositoryListProvider);
            },
            child: ListView.builder(
              itemCount: repositories.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final repository = repositories[index];
                return _RepositoryCard(repository: repository);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Stub for adding repositories - to be implemented later
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add repository feature coming soon'),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Repository'),
      ),
    );
  }
}

/// Card widget for displaying repository information
class _RepositoryCard extends StatelessWidget {
  final Repository repository;

  const _RepositoryCard({required this.repository});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.folder,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          repository.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
          ],
        ),
        trailing: FilledButton(
          onPressed: () {
            // Navigate to review screen - will need repository ID and PR number
            // This is a stub for now
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Review feature coming soon'),
              ),
            );
          },
          child: const Text('Review'),
        ),
        isThreeLine: true,
      ),
    );
  }
}

