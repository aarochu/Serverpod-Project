import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_butler_client/code_butler_client.dart';
import '../providers/review_provider.dart';

/// Screen displaying findings grouped by severity
class FindingsListScreen extends ConsumerWidget {
  final int prId;

  const FindingsListScreen({
    super.key,
    required this.prId,
  });

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      case 'info':
        return Icons.info;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final findingsAsync = ref.watch(findingsProvider(prId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Findings (PR #$prId)'),
      ),
      body: findingsAsync.when(
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
                  'Error loading findings',
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
                    ref.invalidate(findingsProvider(prId));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (findings) {
          if (findings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No findings!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Great job! No issues found in this pull request.',
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

          // Group findings by severity
          final groupedFindings = <String, List<AgentFinding>>{};
          for (final finding in findings) {
            final severity = finding.severity.toLowerCase();
            groupedFindings.putIfAbsent(severity, () => []).add(finding);
          }

          // Sort by severity: critical, warning, info
          final severityOrder = ['critical', 'warning', 'info'];
          final sortedSeverities = groupedFindings.keys.toList()
            ..sort((a, b) {
              final aIndex = severityOrder.indexOf(a);
              final bIndex = severityOrder.indexOf(b);
              if (aIndex == -1 && bIndex == -1) return a.compareTo(b);
              if (aIndex == -1) return 1;
              if (bIndex == -1) return -1;
              return aIndex.compareTo(bIndex);
            });

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: sortedSeverities.length,
            itemBuilder: (context, index) {
              final severity = sortedSeverities[index];
              final severityFindings = groupedFindings[severity]!;
              final severityColor = _getSeverityColor(severity);
              final severityIcon = _getSeverityIcon(severity);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ExpansionTile(
                  leading: Icon(severityIcon, color: severityColor),
                  title: Text(
                    severity.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: severityColor,
                    ),
                  ),
                  subtitle: Text('${severityFindings.length} finding(s)'),
                  children: severityFindings.map((finding) {
                    return _FindingCard(
                      finding: finding,
                      severityColor: severityColor,
                      onTap: () => _showFindingDetails(context, finding),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showFindingDetails(BuildContext context, AgentFinding finding) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      _getSeverityIcon(finding.severity),
                      color: _getSeverityColor(finding.severity),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            finding.severity.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getSeverityColor(finding.severity),
                                ),
                          ),
                          Text(
                            finding.category,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                // Agent Type
                _buildDetailRow(
                  context,
                  'Agent Type',
                  finding.agentType,
                  Icons.smart_toy,
                ),
                const SizedBox(height: 16),
                // File Path
                if (finding.filePath != null && finding.filePath!.isNotEmpty)
                  _buildDetailRow(
                    context,
                    'File',
                    finding.filePath!,
                    Icons.description,
                  ),
                if (finding.filePath != null && finding.filePath!.isNotEmpty)
                  const SizedBox(height: 16),
                // Line Number
                if (finding.lineNumber != null)
                  _buildDetailRow(
                    context,
                    'Line',
                    finding.lineNumber.toString(),
                    Icons.numbers,
                  ),
                if (finding.lineNumber != null) const SizedBox(height: 16),
                // Message
                Text(
                  'Message',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    finding.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                // Code Snippet
                if (finding.codeSnippet != null &&
                    finding.codeSnippet!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Code Snippet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      finding.codeSnippet!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                    ),
                  ),
                ],
                // Suggested Fix
                if (finding.suggestedFix != null &&
                    finding.suggestedFix!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Suggested Fix',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Text(
                      finding.suggestedFix!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Card widget for displaying a single finding
class _FindingCard extends StatelessWidget {
  final AgentFinding finding;
  final Color severityColor;
  final VoidCallback onTap;

  const _FindingCard({
    required this.finding,
    required this.severityColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 4,
        color: severityColor,
      ),
      title: Text(
        finding.message,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (finding.filePath != null && finding.filePath!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              finding.filePath!,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (finding.lineNumber != null) ...[
            const SizedBox(height: 2),
            Text(
              'Line ${finding.lineNumber}',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            'Agent: ${finding.agentType}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

