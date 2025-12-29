import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_butler_client/code_butler_client.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../providers/review_provider.dart';
import '../providers/autofix_provider.dart';
import '../widgets/finding_detail_modal.dart';

/// Sort options for findings
enum FindingsSort {
  severity,
  file,
  agent,
  lineNumber,
}

/// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for active filters
final activeFiltersProvider = StateProvider<Set<String>>((ref) => {'all'});

/// Provider for sort option
final sortOptionProvider = StateProvider<FindingsSort>((ref) => FindingsSort.severity);

/// Screen displaying findings with advanced filtering and grouping
class FindingsListScreen extends ConsumerStatefulWidget {
  final int prId;

  const FindingsListScreen({
    super.key,
    required this.prId,
  });

  @override
  ConsumerState<FindingsListScreen> createState() => _FindingsListScreenState();
}

class _FindingsListScreenState extends ConsumerState<FindingsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _allExpanded = false;
  bool _batchMode = false;
  final Set<int> _selectedFindings = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

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

  List<AgentFinding> _filterAndSortFindings(List<AgentFinding> findings) {
    var filtered = findings;

    // Apply search filter
    final searchQuery = ref.read(searchQueryProvider);
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((f) {
        final messageMatch = f.message.toLowerCase().contains(searchQuery.toLowerCase());
        final fileMatch = f.filePath?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
        return messageMatch || fileMatch;
      }).toList();
    }

    // Apply category filters
    final activeFilters = ref.read(activeFiltersProvider);
    if (!activeFilters.contains('all')) {
      filtered = filtered.where((f) {
        if (activeFilters.contains('critical') && f.severity.toLowerCase() == 'critical') {
          return true;
        }
        if (activeFilters.contains('warning') && f.severity.toLowerCase() == 'warning') {
          return true;
        }
        if (activeFilters.contains('security') && f.category.toLowerCase().contains('security')) {
          return true;
        }
        if (activeFilters.contains('performance') && f.category.toLowerCase().contains('performance')) {
          return true;
        }
        if (activeFilters.contains('documentation') && f.category.toLowerCase().contains('documentation')) {
          return true;
        }
        return false;
      }).toList();
    }

    // Apply sorting
    final sortOption = ref.read(sortOptionProvider);
    filtered.sort((a, b) {
      switch (sortOption) {
        case FindingsSort.severity:
          final severityOrder = {'critical': 0, 'warning': 1, 'info': 2};
          final aOrder = severityOrder[a.severity.toLowerCase()] ?? 3;
          final bOrder = severityOrder[b.severity.toLowerCase()] ?? 3;
          if (aOrder != bOrder) return aOrder.compareTo(bOrder);
          return a.createdAt.compareTo(b.createdAt);
        case FindingsSort.file:
          final aFile = a.filePath ?? '';
          final bFile = b.filePath ?? '';
          if (aFile != bFile) return aFile.compareTo(bFile);
          return (a.lineNumber ?? 0).compareTo(b.lineNumber ?? 0);
        case FindingsSort.agent:
          if (a.agentType != b.agentType) return a.agentType.compareTo(b.agentType);
          return a.createdAt.compareTo(b.createdAt);
        case FindingsSort.lineNumber:
          final aLine = a.lineNumber ?? 0;
          final bLine = b.lineNumber ?? 0;
          if (aLine != bLine) return aLine.compareTo(bLine);
          return a.createdAt.compareTo(b.createdAt);
      }
    });

    return filtered;
  }

  Map<String, List<AgentFinding>> _groupBySeverity(List<AgentFinding> findings) {
    final grouped = <String, List<AgentFinding>>{};
    for (final finding in findings) {
      final severity = finding.severity.toLowerCase();
      grouped.putIfAbsent(severity, () => []).add(finding);
    }
    return grouped;
  }

  Map<String, List<AgentFinding>> _groupByCategory(List<AgentFinding> findings) {
    final grouped = <String, List<AgentFinding>>{};
    for (final finding in findings) {
      final category = finding.category;
      grouped.putIfAbsent(category, () => []).add(finding);
    }
    return grouped;
  }

  Map<String, List<AgentFinding>> _groupByFile(List<AgentFinding> findings) {
    final grouped = <String, List<AgentFinding>>{};
    for (final finding in findings) {
      final file = finding.filePath ?? 'Unknown';
      grouped.putIfAbsent(file, () => []).add(finding);
    }
    return grouped;
  }

  Map<String, List<AgentFinding>> _groupByAgent(List<AgentFinding> findings) {
    final grouped = <String, List<AgentFinding>>{};
    for (final finding in findings) {
      final agent = finding.agentType;
      grouped.putIfAbsent(agent, () => []).add(finding);
    }
    return grouped;
  }

  Future<void> _exportFindings(List<AgentFinding> findings, String format) async {
    if (findings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No findings to export')),
      );
      return;
    }

    try {
      String content;
      String fileName;
      String mimeType;

      if (format == 'json') {
        content = jsonEncode(
          findings.map((f) => {
            'severity': f.severity,
            'category': f.category,
            'agentType': f.agentType,
            'message': f.message,
            'filePath': f.filePath,
            'lineNumber': f.lineNumber,
            'codeSnippet': f.codeSnippet,
            'suggestedFix': f.suggestedFix,
            'createdAt': f.createdAt.toIso8601String(),
          }).toList(),
        );
        fileName = 'findings_pr${widget.prId}.json';
        mimeType = 'application/json';
      } else {
        // CSV format
        final buffer = StringBuffer();
        buffer.writeln('Severity,Category,Agent Type,Message,File Path,Line Number,Code Snippet,Suggested Fix,Created At');
        for (final finding in findings) {
          buffer.writeln([
            finding.severity,
            finding.category,
            finding.agentType,
            '"${finding.message.replaceAll('"', '""')}"',
            finding.filePath ?? '',
            finding.lineNumber?.toString() ?? '',
            '"${(finding.codeSnippet ?? '').replaceAll('"', '""')}"',
            '"${(finding.suggestedFix ?? '').replaceAll('"', '""')}"',
            finding.createdAt.toIso8601String(),
          ].join(','));
        }
        content = buffer.toString();
        fileName = 'findings_pr${widget.prId}.csv';
        mimeType = 'text/csv';
      }

      await Share.share(
        content,
        subject: 'Findings Export',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final findingsAsync = ref.watch(findingsProvider(widget.prId));
    final searchQuery = ref.watch(searchQueryProvider);
    final activeFilters = ref.watch(activeFiltersProvider);
    final sortOption = ref.watch(sortOptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_batchMode 
            ? '${_selectedFindings.length} selected' 
            : 'Findings (PR #${widget.prId})'),
        actions: [
          if (_batchMode) ...[
            IconButton(
              icon: const Icon(Icons.check_circle),
              onPressed: () async {
                if (_selectedFindings.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select findings to apply fixes')),
                  );
                  return;
                }
                
                final autofixNotifier = ref.read(autofixProvider.notifier);
                await autofixNotifier.batchApplyFix(_selectedFindings.toList());
                
                final autofixState = ref.read(autofixProvider);
                if (autofixState.status == AutofixStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fixes applied successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  setState(() {
                    _batchMode = false;
                    _selectedFindings.clear();
                  });
                } else if (autofixState.status == AutofixStatus.failed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to apply fixes: ${autofixState.error ?? "Unknown error"}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              tooltip: 'Apply fixes to selected',
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _batchMode = false;
                  _selectedFindings.clear();
                });
              },
              tooltip: 'Cancel batch mode',
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: () {
                setState(() {
                  _batchMode = true;
                });
              },
              tooltip: 'Batch select',
            ),
            PopupMenuButton(
              icon: const Icon(Icons.share),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.code),
                      SizedBox(width: 8),
                      Text('Export as JSON'),
                    ],
                  ),
                  onTap: () async {
                    final findings = await findingsAsync.value;
                    if (findings != null) {
                      await _exportFindings(findings, 'json');
                    }
                  },
                ),
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.table_chart),
                      SizedBox(width: 8),
                      Text('Export as CSV'),
                    ],
                  ),
                  onTap: () async {
                    final findings = await findingsAsync.value;
                    if (findings != null) {
                      await _exportFindings(findings, 'csv');
                    }
                  },
                ),
              ],
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'By Severity'),
            Tab(text: 'By Category'),
            Tab(text: 'By File'),
            Tab(text: 'By Agent'),
          ],
        ),
      ),
      body: findingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
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
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    ref.invalidate(findingsProvider(widget.prId));
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
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final filteredFindings = _filterAndSortFindings(findings);

          // Calculate summary statistics
          final criticalCount = filteredFindings.where(
            (f) => f.severity.toLowerCase() == 'critical',
          ).length;
          final warningCount = filteredFindings.where(
            (f) => f.severity.toLowerCase() == 'warning',
          ).length;
          final infoCount = filteredFindings.where(
            (f) => f.severity.toLowerCase() == 'info',
          ).length;

          final mostAffectedFile = filteredFindings
              .where((f) => f.filePath != null)
              .fold<Map<String, int>>({}, (map, f) {
            map[f.filePath!] = (map[f.filePath!] ?? 0) + 1;
            return map;
          }).entries
              .reduce((a, b) => a.value > b.value ? a : b);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(findingsProvider(widget.prId));
            },
            child: Column(
              children: [
                // Search bar and filters
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Search bar
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search findings...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Filter chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                              label: 'Show All',
                              selected: activeFilters.contains('all'),
                              onSelected: (selected) {
                                ref.read(activeFiltersProvider.notifier).state = 
                                    selected ? {'all'} : <String>{};
                              },
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Critical Only',
                              selected: activeFilters.contains('critical'),
                              onSelected: (selected) {
                                final current = Set<String>.from(
                                  ref.read(activeFiltersProvider),
                                );
                                current.remove('all');
                                if (selected) {
                                  current.add('critical');
                                } else {
                                  current.remove('critical');
                                }
                                if (current.isEmpty) current.add('all');
                                ref.read(activeFiltersProvider.notifier).state = current;
                              },
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Security',
                              selected: activeFilters.contains('security'),
                              onSelected: (selected) {
                                final current = Set<String>.from(
                                  ref.read(activeFiltersProvider),
                                );
                                current.remove('all');
                                if (selected) {
                                  current.add('security');
                                } else {
                                  current.remove('security');
                                }
                                if (current.isEmpty) current.add('all');
                                ref.read(activeFiltersProvider.notifier).state = current;
                              },
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Performance',
                              selected: activeFilters.contains('performance'),
                              onSelected: (selected) {
                                final current = Set<String>.from(
                                  ref.read(activeFiltersProvider),
                                );
                                current.remove('all');
                                if (selected) {
                                  current.add('performance');
                                } else {
                                  current.remove('performance');
                                }
                                if (current.isEmpty) current.add('all');
                                ref.read(activeFiltersProvider.notifier).state = current;
                              },
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Documentation',
                              selected: activeFilters.contains('documentation'),
                              onSelected: (selected) {
                                final current = Set<String>.from(
                                  ref.read(activeFiltersProvider),
                                );
                                current.remove('all');
                                if (selected) {
                                  current.add('documentation');
                                } else {
                                  current.remove('documentation');
                                }
                                if (current.isEmpty) current.add('all');
                                ref.read(activeFiltersProvider.notifier).state = current;
                              },
                            ),
                            if (activeFilters.length > 1 || 
                                (activeFilters.length == 1 && !activeFilters.contains('all')))
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Chip(
                                  label: Text('${activeFilters.length} active'),
                                  onDeleted: () {
                                    ref.read(activeFiltersProvider.notifier).state = {'all'};
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Sort dropdown and expand/collapse
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<FindingsSort>(
                              value: sortOption,
                              decoration: InputDecoration(
                                labelText: 'Sort by',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: FindingsSort.severity,
                                  child: Text('Severity'),
                                ),
                                DropdownMenuItem(
                                  value: FindingsSort.file,
                                  child: Text('File'),
                                ),
                                DropdownMenuItem(
                                  value: FindingsSort.agent,
                                  child: Text('Agent'),
                                ),
                                DropdownMenuItem(
                                  value: FindingsSort.lineNumber,
                                  child: Text('Line Number'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  ref.read(sortOptionProvider.notifier).state = value;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              _allExpanded ? Icons.unfold_less : Icons.unfold_more,
                            ),
                            onPressed: () {
                              setState(() => _allExpanded = !_allExpanded);
                            },
                            tooltip: _allExpanded 
                                ? 'Collapse all' 
                                : 'Expand all',
                          ),
                        ],
                      ),
                      // Summary statistics card
                      Card(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total: ${filteredFindings.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$criticalCount critical, $warningCount warnings, $infoCount info',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              if (mostAffectedFile.key.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Most affected:',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      mostAffectedFile.key.split('/').last,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
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
                // Tab view
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildGroupedList(
                        context,
                        _groupBySeverity(filteredFindings),
                        'severity',
                      ),
                      _buildGroupedList(
                        context,
                        _groupByCategory(filteredFindings),
                        'category',
                      ),
                      _buildGroupedList(
                        context,
                        _groupByFile(filteredFindings),
                        'file',
                      ),
                      _buildGroupedList(
                        context,
                        _groupByAgent(filteredFindings),
                        'agent',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupedList(
    BuildContext context,
    Map<String, List<AgentFinding>> grouped,
    String groupType,
  ) {
    if (grouped.isEmpty) {
      return Center(
        child: Text(
          'No findings match filters',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final sortedKeys = grouped.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final key = sortedKeys[index];
        final findings = grouped[key]!;
        final severityColor = groupType == 'severity' 
            ? _getSeverityColor(key)
            : Theme.of(context).colorScheme.primary;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ExpansionTile(
            initiallyExpanded: _allExpanded,
            leading: groupType == 'severity'
                ? Icon(_getSeverityIcon(key), color: severityColor)
                : groupType == 'agent'
                    ? Icon(_getAgentIcon(key), color: severityColor)
                    : Icon(Icons.folder, color: severityColor),
            title: Text(
              key,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: groupType == 'severity' ? severityColor : null,
              ),
            ),
            subtitle: Text('${findings.length} finding(s)'),
            children: findings.map((finding) {
              return _EnhancedFindingCard(
                finding: finding,
                severityColor: _getSeverityColor(finding.severity),
                batchMode: _batchMode,
                isSelected: _selectedFindings.contains(finding.id),
                onTap: () {
                  if (_batchMode) {
                    setState(() {
                      if (_selectedFindings.contains(finding.id)) {
                        _selectedFindings.remove(finding.id);
                      } else {
                        _selectedFindings.add(finding.id);
                      }
                    });
                  } else {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => FindingDetailModal(finding: finding),
                    );
                  }
                },
                onApplyFix: () async {
                  final autofixNotifier = ref.read(autofixProvider.notifier);
                  await autofixNotifier.applyFix(finding.id);
                  
                  final autofixState = ref.read(autofixProvider);
                  if (autofixState.status == AutofixStatus.success && autofixState.prUrl != null) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Text('Fix applied! '),
                              TextButton(
                                onPressed: () async {
                                  if (await canLaunchUrl(Uri.parse(autofixState.prUrl!))) {
                                    await launchUrl(Uri.parse(autofixState.prUrl!));
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
                  } else if (autofixState.status == AutofixStatus.failed) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to apply fix: ${autofixState.error ?? "Unknown error"}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

/// Enhanced finding card with more details
class _EnhancedFindingCard extends ConsumerWidget {
  final AgentFinding finding;
  final Color severityColor;
  final VoidCallback onTap;
  final bool batchMode;
  final bool isSelected;
  final VoidCallback? onApplyFix;

  const _EnhancedFindingCard({
    required this.finding,
    required this.severityColor,
    required this.onTap,
    this.batchMode = false,
    this.isSelected = false,
    this.onApplyFix,
  });

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autofixState = ref.watch(autofixProvider);
    final isApplying = autofixState.status == AutofixStatus.applying && 
                       autofixState.findingId == finding.id;
    final isApplied = autofixState.status == AutofixStatus.success && 
                      autofixState.findingId == finding.id;
    
    return ListTile(
      leading: batchMode
          ? Checkbox(
              value: isSelected,
              onChanged: (value) => onTap(),
            )
          : Container(
              width: 4,
              color: severityColor,
            ),
      title: Row(
        children: [
          // Agent icon
          Icon(
            _getAgentIcon(finding.agentType),
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          // Severity badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              finding.severity.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: severityColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Category tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              finding.category,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            finding.message,
            style: const TextStyle(fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (finding.filePath != null && finding.filePath!.isNotEmpty) ...[
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                // Show all findings for this file
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Showing findings for ${finding.filePath}'),
                  ),
                );
              },
              child: Text(
                finding.filePath!,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
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
        ],
      ),
      trailing: batchMode
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (finding.suggestedFix != null && 
                    finding.suggestedFix!.isNotEmpty &&
                    onApplyFix != null) ...[
                  if (isApplying)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else if (isApplied)
                    const Icon(Icons.check_circle, color: Colors.green)
                  else
                    IconButton(
                      icon: const Icon(Icons.auto_fix_high),
                      onPressed: onApplyFix,
                      tooltip: 'Apply fix',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
                const Icon(Icons.chevron_right),
              ],
            ),
      onTap: onTap,
      isThreeLine: true,
    );
  }
}

/// Filter chip widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
    );
  }
}
