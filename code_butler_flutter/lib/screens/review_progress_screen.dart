import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/review_provider.dart';

/// Screen displaying review progress with polling
class ReviewProgressScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const ReviewProgressScreen({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<ReviewProgressScreen> createState() =>
      _ReviewProgressScreenState();
}

class _ReviewProgressScreenState extends ConsumerState<ReviewProgressScreen> {
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    // Start polling immediately
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    // Poll every 2 seconds
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final notifier = ref.read(reviewSessionProvider.notifier);
      notifier.refreshStatus(widget.sessionId);
    });

    // Initial fetch
    final notifier = ref.read(reviewSessionProvider.notifier);
    notifier.refreshStatus(widget.sessionId);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return Colors.green;
      case 'failed':
      case 'error':
        return Colors.red;
      case 'analyzing':
      case 'in_progress':
      case 'processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewSessionAsync = ref.watch(reviewSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Progress'),
      ),
      body: reviewSessionAsync.when(
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
                  'Error loading review status',
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
                    final notifier = ref.read(reviewSessionProvider.notifier);
                    notifier.refreshStatus(widget.sessionId);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (session) {
          final isCompleted = session.status.toLowerCase() == 'completed' ||
              session.status.toLowerCase() == 'success';
          final statusColor = _getStatusColor(session.status);

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Progress indicator
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: session.progressPercent / 100,
                          strokeWidth: 12,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${session.progressPercent.toStringAsFixed(0)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Complete',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Status text
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor, width: 2),
                    ),
                    child: Text(
                      session.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Current file
                  if (session.currentFile != null &&
                      session.currentFile!.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Processing: ${session.currentFile}',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Files processed count
                  Text(
                    'Files: ${session.filesProcessed} / ${session.totalFiles}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // Error message if any
                  if (session.errorMessage != null &&
                      session.errorMessage!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              session.errorMessage!,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  // View Findings button (when completed)
                  if (isCompleted)
                    FilledButton.icon(
                      onPressed: () {
                        // Navigate to findings screen
                        // Note: We need pullRequestId from the session
                        // This will need to be passed or retrieved from the session
                        // For now, using a placeholder
                        context.go('/findings/${session.pullRequestId}');
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('View Findings'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

