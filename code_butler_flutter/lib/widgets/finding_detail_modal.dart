import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:code_butler_client/code_butler_client.dart';

/// Modal widget for displaying detailed finding information
class FindingDetailModal extends StatefulWidget {
  final AgentFinding finding;

  const FindingDetailModal({
    super.key,
    required this.finding,
  });

  @override
  State<FindingDetailModal> createState() => _FindingDetailModalState();
}

class _FindingDetailModalState extends State<FindingDetailModal> {
  bool _isResolved = false;
  bool _isIgnored = false;

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

  IconData _getAgentIcon(String agentType) {
    switch (agentType.toLowerCase()) {
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
        return Icons.smart_toy;
    }
  }

  Future<void> _copyToClipboard(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(widget.finding.severity);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(
                    _getSeverityIcon(widget.finding.severity),
                    color: severityColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.finding.severity.toUpperCase(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: severityColor,
                              ),
                        ),
                        Text(
                          widget.finding.category,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Agent Type
                    _buildDetailRow(
                      context,
                      'Agent Type',
                      widget.finding.agentType,
                      _getAgentIcon(widget.finding.agentType),
                    ),
                    const SizedBox(height: 16),
                    // File Path
                    if (widget.finding.filePath != null &&
                        widget.finding.filePath!.isNotEmpty) ...[
                      _buildDetailRow(
                        context,
                        'File',
                        widget.finding.filePath!,
                        Icons.description,
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Line Number
                    if (widget.finding.lineNumber != null)
                      _buildDetailRow(
                        context,
                        'Line',
                        widget.finding.lineNumber.toString(),
                        Icons.numbers,
                      ),
                    if (widget.finding.lineNumber != null)
                      const SizedBox(height: 24),
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
                        widget.finding.message,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    // Code Snippet
                    if (widget.finding.codeSnippet != null &&
                        widget.finding.codeSnippet!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Code Snippet',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () => _copyToClipboard(
                              widget.finding.codeSnippet!,
                              'Code snippet',
                            ),
                            tooltip: 'Copy code snippet',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: HighlightView(
                          widget.finding.codeSnippet!,
                          language: 'dart',
                          theme: githubTheme,
                          padding: const EdgeInsets.all(8),
                          textStyle: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    // Suggested Fix
                    if (widget.finding.suggestedFix != null &&
                        widget.finding.suggestedFix!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Suggested Fix',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () => _copyToClipboard(
                              widget.finding.suggestedFix!,
                              'Suggested fix',
                            ),
                            tooltip: 'Copy suggested fix',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.finding.suggestedFix!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Apply fix functionality coming soon'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('Apply Fix'),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() => _isResolved = !_isResolved);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _isResolved
                                        ? 'Marked as resolved'
                                        : 'Unmarked as resolved',
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              _isResolved ? Icons.check_circle : Icons.circle_outlined,
                            ),
                            label: Text(_isResolved ? 'Resolved' : 'Mark as Resolved'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _isResolved ? Colors.green : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() => _isIgnored = !_isIgnored);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _isIgnored
                                        ? 'Finding ignored'
                                        : 'Finding unignored',
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              _isIgnored ? Icons.visibility_off : Icons.visibility_off_outlined,
                            ),
                            label: Text(_isIgnored ? 'Ignored' : 'Ignore'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _isIgnored ? Colors.orange : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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

