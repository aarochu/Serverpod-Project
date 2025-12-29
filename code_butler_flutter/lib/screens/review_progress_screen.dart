import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../providers/review_provider.dart';
import '../config/serverpod_client.dart';

/// Screen displaying review progress with real-time streaming
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

class _ReviewProgressScreenState
    extends ConsumerState<ReviewProgressScreen> {
  final ConfettiController _confettiController = ConfettiController();
  final List<String> _completedFiles = [];
  final List<String> _agentLogs = [];
  bool _showLogs = false;
  String? _currentAgent;
  double _progress = 0.0;
  String _status = 'initializing';
  String? _currentFile;

  IconData _getAgentIcon(String? agentType) {
    switch (agentType?.toLowerCase()) {
      case 'navigator':
        return Icons.map;
      case 'reader':
        return Icons.book;
      case 'security':
        return Icons.security;
      case 'performance':
        return Icons.speed;
      case 'documentation':
        return Icons.description;
      default:
        return Icons.help_outline;
    }
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

  String _formatTimeRemaining(int filesProcessed, int totalFiles) {
    if (filesProcessed == 0 || totalFiles == 0) return 'Calculating...';
    final avgTimePerFile = 2.0; // seconds (estimate)
    final remainingFiles = totalFiles - filesProcessed;
    final secondsRemaining = (remainingFiles * avgTimePerFile).round();
    if (secondsRemaining < 60) {
      return '$secondsRemaining seconds';
    }
    final minutes = secondsRemaining ~/ 60;
    return '$minutes minute${minutes > 1 ? 's' : ''}';
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressStreamAsync = ref.watch(
      reviewProgressStreamProvider(widget.sessionId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Progress'),
        actions: [
          IconButton(
            icon: Icon(_showLogs ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() => _showLogs = !_showLogs);
            },
            tooltip: _showLogs ? 'Hide logs' : 'Show logs',
          ),
        ],
      ),
      body: progressStreamAsync.when(
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
                    ref.invalidate(
                      reviewProgressStreamProvider(widget.sessionId),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (updateString) {
          // Parse stream format: "status:progress:currentFile"
          final parts = updateString.split(':');
          if (parts.length >= 2) {
            _status = parts[0];
            _progress = double.tryParse(parts[1]) ?? 0.0;
            _currentFile = parts.length > 2 ? parts[2] : null;

            // Add to completed files if file changed
            if (_currentFile != null &&
                _currentFile!.isNotEmpty &&
                !_completedFiles.contains(_currentFile)) {
              setState(() {
                _completedFiles.add(_currentFile!);
                _agentLogs.add('Completed: $_currentFile');
              });
            }

            // Trigger confetti and haptic on completion
            if (_status.toLowerCase() == 'completed' &&
                _progress >= 100.0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                HapticFeedback.lightImpact();
                _confettiController.play();
              });
            }
          }

          final isCompleted = _status.toLowerCase() == 'completed' ||
              _status.toLowerCase() == 'success';
          final isFailed = _status.toLowerCase() == 'failed' ||
              _status.toLowerCase() == 'error';
          final statusColor = _getStatusColor(_status);

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Confetti overlay
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirection: 3.14 / 2,
                        maxBlastForce: 5,
                        minBlastForce: 2,
                        emissionFrequency: 0.05,
                        numberOfParticles: 50,
                        gravity: 0.1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Progress indicator with animation
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: _progress / 100,
                            strokeWidth: 12,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              statusColor,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ) ?? const TextStyle(),
                                child: Text(
                                  '${_progress.toStringAsFixed(0)}%',
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
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
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
                        _status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Agent activity feed
                    if (_currentAgent != null || _status == 'analyzing') ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getAgentIcon(_currentAgent),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _currentAgent != null
                                  ? 'Agent: $_currentAgent'
                                  : 'Analyzing...',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Current file
                    if (_currentFile != null && _currentFile!.isNotEmpty) ...[
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
                              'Processing: $_currentFile',
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
                      'Files: ${_completedFiles.length} processed',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    // Estimated time remaining
                    if (!isCompleted && !isFailed && _completedFiles.isNotEmpty)
                      Text(
                        'Estimated time remaining: ${_formatTimeRemaining(_completedFiles.length, _completedFiles.length + 5)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    const SizedBox(height: 24),
                    // Completed files list
                    if (_completedFiles.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Completed Files',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            ..._completedFiles.take(5).map((file) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          file,
                                          style: Theme.of(context).textTheme.bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            if (_completedFiles.length > 5)
                              Text(
                                '... and ${_completedFiles.length - 5} more',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Error message if any
                    if (isFailed) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Review failed',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onErrorContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            FilledButton.icon(
                              onPressed: () async {
                                // Retry review - would need pullRequestId
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Retry functionality coming soon'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry Review'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // View Findings button (when completed)
                    if (isCompleted) ...[
                      FilledButton.icon(
                        onPressed: () async {
                          // Get pullRequestId from session
                          try {
                            final client = ClientManager.client;
                            final session = await client.review.getReviewStatus(
                              widget.sessionId,
                            );
                            if (session != null) {
                              context.go('/findings/${session.pullRequestId}');
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
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
                    // Log feed (collapsible)
                    if (_showLogs) ...[
                      const SizedBox(height: 24),
                      ExpansionTile(
                        title: const Text('Review Logs'),
                        initiallyExpanded: true,
                        children: [
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              itemCount: _agentLogs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    _agentLogs[index],
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontFamily: 'monospace',
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
