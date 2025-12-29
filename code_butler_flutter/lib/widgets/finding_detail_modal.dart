import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_butler_client/code_butler_client.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/autofix_provider.dart';

/// Modal widget for displaying detailed finding information
class FindingDetailModal extends ConsumerStatefulWidget {
  final AgentFinding finding;

  const FindingDetailModal({
    super.key,
    required this.finding,
  });

  @override
  ConsumerState<FindingDetailModal> createState() => _FindingDetailModalState();
}

class _FindingDetailModalState extends ConsumerState<FindingDetailModal> {
  bool _isResolved = false;
  bool _isIgnored = false;
  bool _showComparison = false;
  String? _detectedLanguage;

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

  String _detectLanguage(String? filePath, String? codeSnippet) {
    if (filePath != null) {
      final extension = filePath.split('.').last.toLowerCase();
      switch (extension) {
        case 'dart':
          return 'dart';
        case 'js':
        case 'jsx':
          return 'javascript';
        case 'ts':
        case 'tsx':
          return 'typescript';
        case 'py':
          return 'python';
        case 'java':
          return 'java';
        case 'cpp':
        case 'cc':
        case 'cxx':
          return 'cpp';
        case 'c':
          return 'c';
        case 'go':
          return 'go';
        case 'rs':
          return 'rust';
        case 'rb':
          return 'ruby';
        case 'php':
          return 'php';
        case 'swift':
          return 'swift';
        case 'kt':
          return 'kotlin';
        case 'html':
          return 'html';
        case 'css':
          return 'css';
        case 'json':
          return 'json';
        case 'yaml':
        case 'yml':
          return 'yaml';
        case 'md':
          return 'markdown';
        case 'sh':
        case 'bash':
          return 'bash';
        default:
          return 'dart'; // Default
      }
    }
    return 'dart'; // Default
  }

  String _buildContextCode(String? codeSnippet, int? lineNumber) {
    if (codeSnippet == null || codeSnippet.isEmpty) {
      return '';
    }

    final lines = codeSnippet.split('\n');
    final targetLineIndex = lineNumber != null && lineNumber > 0 
        ? (lineNumber - 1).clamp(0, lines.length - 1)
        : 0;

    // Get 10 lines before and after
    final startIndex = (targetLineIndex - 10).clamp(0, lines.length);
    final endIndex = (targetLineIndex + 11).clamp(0, lines.length);
    
    final contextLines = lines.sublist(startIndex, endIndex);
    final contextStartLine = startIndex + 1;

    // Build code with line numbers
    final buffer = StringBuffer();
    for (int i = 0; i < contextLines.length; i++) {
      final lineNum = contextStartLine + i;
      final isTargetLine = lineNum == lineNumber;
      buffer.writeln('${lineNum.toString().padLeft(4)} | ${contextLines[i]}');
    }

    return buffer.toString();
  }

  Future<void> _openGitHubLink() async {
    // Construct GitHub URL
    // Format: {repoUrl}/blob/{branch}/{filePath}#L{lineNumber}
    // Note: Would need repository URL and branch from context
    // For now, show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('GitHub link functionality requires repository context'),
      ),
    );
  }

  Future<void> _shareFinding() async {
    final buffer = StringBuffer();
    buffer.writeln('Finding: ${widget.finding.severity.toUpperCase()}');
    buffer.writeln('Category: ${widget.finding.category}');
    buffer.writeln('Agent: ${widget.finding.agentType}');
    buffer.writeln('');
    buffer.writeln('Message:');
    buffer.writeln(widget.finding.message);
    buffer.writeln('');
    
    if (widget.finding.filePath != null) {
      buffer.writeln('File: ${widget.finding.filePath}');
    }
    if (widget.finding.lineNumber != null) {
      buffer.writeln('Line: ${widget.finding.lineNumber}');
    }
    buffer.writeln('');
    
    if (widget.finding.codeSnippet != null) {
      buffer.writeln('Code Snippet:');
      buffer.writeln(widget.finding.codeSnippet);
      buffer.writeln('');
    }
    
    if (widget.finding.suggestedFix != null) {
      buffer.writeln('Suggested Fix:');
      buffer.writeln(widget.finding.suggestedFix);
    }

    await Share.share(buffer.toString(), subject: 'Code Finding');
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
                    // File Path with GitHub link
                    if (widget.finding.filePath != null &&
                        widget.finding.filePath!.isNotEmpty) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailRow(
                              context,
                              'File',
                              widget.finding.filePath!,
                              Icons.description,
                            ),
                          ),
                          if (widget.finding.lineNumber != null)
                            IconButton(
                              icon: const Icon(Icons.open_in_new),
                              onPressed: _openGitHubLink,
                              tooltip: 'Open in GitHub',
                            ),
                        ],
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
                    // Code Snippet with Context
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
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () => _copyToClipboard(
                                  widget.finding.codeSnippet!,
                                  'Code snippet',
                                ),
                                tooltip: 'Copy code snippet',
                              ),
                              IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: _shareFinding,
                                tooltip: 'Share finding',
                              ),
                            ],
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Context code with line numbers
                            if (widget.finding.lineNumber != null)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: SelectableText(
                                  _buildContextCode(
                                    widget.finding.codeSnippet,
                                    widget.finding.lineNumber,
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            else
                              HighlightView(
                                widget.finding.codeSnippet!,
                                language: _detectLanguage(
                                  widget.finding.filePath,
                                  widget.finding.codeSnippet,
                                ),
                                theme: githubTheme,
                                padding: const EdgeInsets.all(8),
                                textStyle: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    // Suggested Fix with Side-by-Side Comparison
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
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  _showComparison 
                                      ? Icons.view_agenda 
                                      : Icons.compare_arrows,
                                ),
                                onPressed: () {
                                  setState(() => _showComparison = !_showComparison);
                                },
                                tooltip: _showComparison 
                                    ? 'Show single view' 
                                    : 'Show comparison',
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
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_showComparison && widget.finding.codeSnippet != null)
                        // Side-by-side comparison
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red, width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Original',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    SelectableText(
                                      widget.finding.codeSnippet!,
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
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
                                      'Fixed',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    SelectableText(
                                      widget.finding.suggestedFix!,
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        // Single view
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
                              HighlightView(
                                widget.finding.suggestedFix!,
                                language: _detectLanguage(
                                  widget.finding.filePath,
                                  widget.finding.suggestedFix,
                                ),
                                theme: githubTheme,
                                padding: const EdgeInsets.all(8),
                                textStyle: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Consumer(
                                builder: (context, ref, child) {
                                  final autofixState = ref.watch(autofixProvider);
                                  final isApplying = autofixState.status == AutofixStatus.applying && 
                                                     autofixState.findingId == widget.finding.id;
                                  final isApplied = autofixState.status == AutofixStatus.success && 
                                                    autofixState.findingId == widget.finding.id;
                                  final hasError = autofixState.status == AutofixStatus.failed && 
                                                   autofixState.findingId == widget.finding.id;
                                  
                                  return FilledButton.icon(
                                    onPressed: isApplying || isApplied
                                        ? null
                                        : () async {
                                            final autofixNotifier = ref.read(autofixProvider.notifier);
                                            await autofixNotifier.applyFix(widget.finding.id);
                                            
                                            final state = ref.read(autofixProvider);
                                            if (state.status == AutofixStatus.success && state.prUrl != null) {
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Row(
                                                      children: [
                                                        const Text('Fix applied! '),
                                                        TextButton(
                                                          onPressed: () async {
                                                            if (await canLaunchUrl(Uri.parse(state.prUrl!))) {
                                                              await launchUrl(Uri.parse(state.prUrl!));
                                                            }
                                                          },
                                                          child: const Text('View PR'),
                                                        ),
                                                      ],
                                                    ),
                                                    backgroundColor: Colors.green,
                                                    duration: const Duration(seconds: 5),
                                                  ),
                                                );
                                              }
                                            } else if (state.status == AutofixStatus.failed) {
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Failed to apply fix: ${state.error ?? "Unknown error"}'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                    icon: isApplying
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : isApplied
                                            ? const Icon(Icons.check_circle)
                                            : const Icon(Icons.auto_fix_high),
                                    label: Text(
                                      isApplying
                                          ? 'Applying...'
                                          : isApplied
                                              ? 'Fix Applied'
                                              : 'Apply Fix',
                                    ),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: isApplied
                                          ? Colors.green
                                          : hasError
                                              ? Colors.red
                                              : null,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                    // Related Findings Section (placeholder)
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.link,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Related Findings',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Other findings in the same file will appear here',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
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

