import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:code_butler_client/code_butler_client.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../config/serverpod_client.dart';
import '../providers/repository_provider.dart';

/// Webhook event data
class WebhookEvent {
  final DateTime timestamp;
  final String eventType;
  final String status;
  final String? error;

  WebhookEvent({
    required this.timestamp,
    required this.eventType,
    required this.status,
    this.error,
  });
}

/// Provider for webhook events
final webhookEventsProvider = FutureProvider.family<List<WebhookEvent>, int>((ref, repositoryId) async {
  final client = ClientManager.client;
  
  try {
    // Try to use webhook endpoint if available
    if (client.webhook != null) {
      try {
        final events = await client.webhook.getWebhookEvents(repositoryId);
        // Convert backend response to WebhookEvent list
        return events.map((e) => WebhookEvent(
          timestamp: e.timestamp,
          eventType: e.eventType,
          status: e.status,
          error: e.error,
        )).toList();
      } catch (e) {
        // Endpoint might not exist yet, return empty list
        return [];
      }
    }
    return [];
  } catch (e) {
    return [];
  }
});

/// Webhook settings screen
class WebhookSettingsScreen extends ConsumerWidget {
  final int repositoryId;

  const WebhookSettingsScreen({
    super.key,
    required this.repositoryId,
  });

  Future<void> _testWebhook(BuildContext context, WidgetRef ref, int repoId) async {
    try {
      final client = ClientManager.client;
      
      if (client.webhook != null) {
        try {
          await client.webhook.testWebhook(repoId);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Webhook test sent successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Refresh events
            ref.invalidate(webhookEventsProvider(repoId));
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to test webhook: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Webhook endpoint not available. Backend needs to be updated.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _copyToClipboard(BuildContext context, String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repositoryAsync = ref.watch(repositoryListProvider);
    final repository = repositoryAsync.value?.firstWhere(
      (r) => r.id == repositoryId,
      orElse: () => throw Exception('Repository not found'),
    );
    
    final eventsAsync = ref.watch(webhookEventsProvider(repositoryId));
    
    // Construct webhook URL (assuming server is running on localhost:8080 for dev)
    // In production, this would come from config
    final webhookUrl = 'http://localhost:8080/webhook/github/$repositoryId';
    final webhookSecret = 'your-webhook-secret'; // This should come from backend config

    return Scaffold(
      appBar: AppBar(
        title: const Text('Webhook Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Repository info card
            if (repository != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        repository.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        repository.url,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            
            // Webhook URL section
            Text(
              'Webhook URL',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            webhookUrl,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () => _copyToClipboard(context, webhookUrl, 'Webhook URL'),
                          tooltip: 'Copy webhook URL',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add this URL to your GitHub repository webhook settings',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Webhook Secret section
            Text(
              'Webhook Secret',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '••••••••••••••••',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            // Show secret in dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Webhook Secret'),
                                content: SelectableText(webhookSecret),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _copyToClipboard(context, webhookSecret, 'Webhook secret');
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Copy'),
                                  ),
                                ],
                              ),
                            );
                          },
                          tooltip: 'Reveal secret',
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () => _copyToClipboard(context, webhookSecret, 'Webhook secret'),
                          tooltip: 'Copy webhook secret',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use this secret when configuring the webhook in GitHub',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Instructions card
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Setup Instructions',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionStep(
                      context,
                      '1',
                      'Go to your GitHub repository settings',
                    ),
                    _buildInstructionStep(
                      context,
                      '2',
                      'Navigate to Webhooks → Add webhook',
                    ),
                    _buildInstructionStep(
                      context,
                      '3',
                      'Paste the webhook URL above',
                    ),
                    _buildInstructionStep(
                      context,
                      '4',
                      'Set Content type to "application/json"',
                    ),
                    _buildInstructionStep(
                      context,
                      '5',
                      'Paste the webhook secret above',
                    ),
                    _buildInstructionStep(
                      context,
                      '6',
                      'Select events: "Pull requests" and "Pull request reviews"',
                    ),
                    _buildInstructionStep(
                      context,
                      '7',
                      'Click "Add webhook"',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Test webhook button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _testWebhook(context, ref, repositoryId),
                icon: const Icon(Icons.send),
                label: const Text('Test Webhook'),
              ),
            ),
            const SizedBox(height: 24),
            
            // Recent webhook events
            Text(
              'Recent Webhook Events',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load webhook events',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref.invalidate(webhookEventsProvider(repositoryId)),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (events) {
                if (events.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.webhook,
                              size: 48,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No webhook events yet',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Events will appear here after webhook is configured',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                
                return Column(
                  children: events.map((event) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          event.status == 'success'
                              ? Icons.check_circle
                              : event.status == 'failed'
                                  ? Icons.error
                                  : Icons.pending,
                          color: event.status == 'success'
                              ? Colors.green
                              : event.status == 'failed'
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                        title: Text(event.eventType),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              timeago.format(event.timestamp),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (event.error != null)
                              Text(
                                event.error!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                              ),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(event.status),
                          backgroundColor: event.status == 'success'
                              ? Colors.green.withOpacity(0.2)
                              : event.status == 'failed'
                                  ? Colors.red.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(BuildContext context, String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

