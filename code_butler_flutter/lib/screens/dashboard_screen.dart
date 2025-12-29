import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:code_butler_client/code_butler_client.dart';
import '../providers/dashboard_provider.dart';

/// Dashboard screen with analytics and metrics
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes min $seconds sec';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final trendAsync = ref.watch(findingsTrendProvider);
    final severityAsync = ref.watch(severityDistributionProvider);
    final agentTypeAsync = ref.watch(agentTypeDistributionProvider);
    final problematicFilesAsync = ref.watch(problematicFilesProvider);
    final healthAsync = ref.watch(repositoryHealthProvider);
    final recentSessionsAsync = ref.watch(recentReviewSessionsProvider);
    final timeRange = ref.watch(timeRangeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // Time range selector
          SegmentedButton<TimeRange>(
            segments: const [
              ButtonSegment(
                value: TimeRange.last7Days,
                label: Text('7d'),
              ),
              ButtonSegment(
                value: TimeRange.last30Days,
                label: Text('30d'),
              ),
              ButtonSegment(
                value: TimeRange.allTime,
                label: Text('All'),
              ),
            ],
            selected: {timeRange},
            onSelectionChanged: (Set<TimeRange> newSelection) {
              ref.read(timeRangeProvider.notifier).state = newSelection.first;
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allReviewSessionsProvider);
          ref.invalidate(allFindingsProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metrics cards
              statsAsync.when(
                loading: () => _buildMetricsSkeleton(context),
                error: (error, _) => Semantics(
                  label: 'Error loading dashboard statistics',
                  child: Center(
                    child: Text('Error loading stats: $error'),
                  ),
                ),
                data: (stats) => Semantics(
                  label: 'Dashboard metrics: ${stats.totalReviews} total reviews, ${stats.totalFindings} total findings, ${stats.successRate.toStringAsFixed(1)}% success rate',
                  child: _buildMetricsCards(context, stats),
                ),
              ),
              const SizedBox(height: 24),
              // Charts section
              Semantics(
                header: true,
                child: Text(
                  'Analytics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              // Line chart - Findings trend
              SizedBox(
                height: 200,
                child: trendAsync.when(
                  loading: () => _buildChartSkeleton(context),
                  error: (error, _) => Center(
                    child: Text('Error: $error'),
                  ),
                  data: (trendPoints) => _buildLineChart(context, trendPoints),
                ),
              ),
              const SizedBox(height: 24),
              // Pie and Bar charts row
              Row(
                children: [
                  // Pie chart - Severity distribution
                  Expanded(
                    child: SizedBox(
                      height: 250,
                      child: severityAsync.when(
                        loading: () => _buildChartSkeleton(context),
                        error: (error, _) => Center(
                          child: Text('Error: $error'),
                        ),
                        data: (distribution) => _buildPieChart(
                          context,
                          distribution,
                          ref,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Bar chart - Agent type distribution
                  Expanded(
                    child: SizedBox(
                      height: 250,
                      child: agentTypeAsync.when(
                        loading: () => _buildChartSkeleton(context),
                        error: (error, _) => Center(
                          child: Text('Error: $error'),
                        ),
                        data: (distribution) => _buildBarChart(
                          context,
                          distribution,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Most problematic files
              Semantics(
                header: true,
                child: Text(
                  'Most Problematic Files',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              problematicFilesAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => Text('Error: $error'),
                data: (files) => _buildProblematicFilesList(context, files),
              ),
              const SizedBox(height: 24),
              // Repository health scores
              Semantics(
                header: true,
                child: Text(
                  'Repository Health',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              healthAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => Text('Error: $error'),
                data: (healthScores) => _buildHealthScores(context, healthScores),
              ),
              const SizedBox(height: 24),
              // Recent review sessions
              Semantics(
                header: true,
                child: Text(
                  'Recent Reviews',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              recentSessionsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => Text('Error: $error'),
                data: (sessions) => _buildRecentSessions(context, sessions),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsCards(BuildContext context, DashboardStats stats) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            title: 'Total Reviews',
            value: stats.totalReviews.toString(),
            icon: Icons.reviews,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            title: 'Avg Duration',
            value: _formatDuration(stats.averageDuration),
            icon: Icons.timer,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            title: 'Total Findings',
            value: stats.totalFindings.toString(),
            icon: Icons.bug_report,
            color: Colors.orange,
            badge: '${stats.criticalFindings}C ${stats.warningFindings}W ${stats.infoFindings}I',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            title: 'Success Rate',
            value: '${stats.successRate.toStringAsFixed(1)}%',
            icon: Icons.check_circle,
            color: stats.successRate >= 80 ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsSkeleton(BuildContext context) {
    return Row(
      children: List.generate(
        4,
        (index) => Expanded(
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.surfaceVariant,
            highlightColor: Theme.of(context).colorScheme.surface,
            child: Container(
              height: 100,
              margin: EdgeInsets.only(right: index < 3 ? 12 : 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surfaceVariant,
      highlightColor: Theme.of(context).colorScheme.surface,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLineChart(
    BuildContext context,
    List<FindingsTrendPoint> points,
  ) {
    if (points.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < points.length) {
                      final date = points[value.toInt()].date;
                      return Text(
                        '${date.month}/${date.day}',
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: points.asMap().entries.map((entry) {
                  return FlSpot(
                    entry.key.toDouble(),
                    entry.value.findingsCount.toDouble(),
                  );
                }).toList(),
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      '${spot.y.toInt()} findings',
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart(
    BuildContext context,
    SeverityDistribution distribution,
    WidgetRef ref,
  ) {
    if (distribution.total == 0) {
      return Center(
        child: Text(
          'No findings',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: distribution.critical.toDouble(),
                title: '${distribution.criticalPercent.toStringAsFixed(1)}%',
                color: Colors.red,
                radius: 60,
              ),
              PieChartSectionData(
                value: distribution.warning.toDouble(),
                title: '${distribution.warningPercent.toStringAsFixed(1)}%',
                color: Colors.orange,
                radius: 60,
              ),
              PieChartSectionData(
                value: distribution.info.toDouble(),
                title: '${distribution.infoPercent.toStringAsFixed(1)}%',
                color: Colors.blue,
                radius: 60,
              ),
            ],
            sectionsSpace: 2,
            centerSpaceRadius: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(
    BuildContext context,
    AgentTypeDistribution distribution,
  ) {
    if (distribution.counts.isEmpty) {
      return Center(
        child: Text(
          'No data',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final entries = distribution.counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: entries.isNotEmpty
                ? entries.first.value.toDouble() * 1.2
                : 10,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.toInt()}',
                    const TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < entries.length) {
                      return Text(
                        entries[value.toInt()].key,
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            barGroups: entries.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.value.toDouble(),
                    color: Theme.of(context).colorScheme.primary,
                    width: 16,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildProblematicFilesList(
    BuildContext context,
    List<ProblematicFile> files,
  ) {
    if (files.isEmpty) {
      return Center(
        child: Text(
          'No problematic files',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              child: Text('${index + 1}'),
            ),
            title: Text(
              file.filePath,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text('${file.findingCount} findings'),
            trailing: Chip(
              label: Text('Score: ${file.densityScore.toStringAsFixed(1)}'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHealthScores(
    BuildContext context,
    List<RepositoryHealth> healthScores,
  ) {
    if (healthScores.isEmpty) {
      return Center(
        child: Text(
          'No repository data',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: healthScores.length,
        itemBuilder: (context, index) {
          final health = healthScores[index];
          final color = health.healthScore >= 80
              ? Colors.green
              : health.healthScore >= 50
                  ? Colors.orange
                  : Colors.red;

          return ListTile(
            leading: CircularProgressIndicator(
              value: health.healthScore / 100,
              color: color,
            ),
            title: Text(health.repositoryName),
            subtitle: Text(
              '${health.totalFindings} findings in ${health.fileCount} files',
            ),
            trailing: Text(
              '${health.healthScore.toStringAsFixed(1)}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentSessions(
    BuildContext context,
    List<ReviewSession> sessions,
  ) {
    if (sessions.isEmpty) {
      return Center(
        child: Text(
          'No recent reviews',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          final statusColor = _getStatusColor(session.status);

          return ListTile(
            leading: Icon(
              _getStatusIcon(session.status),
              color: statusColor,
            ),
            title: Text('Review #${session.id}'),
            subtitle: Text(
              'PR #${session.pullRequestId} - ${session.status}',
            ),
            trailing: Text(
              '${session.progressPercent.toStringAsFixed(0)}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            onTap: () {
              context.go('/review/${session.id}');
            },
            semanticLabel: 'Review session ${session.id}, status ${session.status}, ${session.progressPercent.toStringAsFixed(0)}% complete',
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'analyzing':
      case 'in_progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      case 'analyzing':
      case 'in_progress':
        return Icons.hourglass_empty;
      default:
        return Icons.help_outline;
    }
  }
}

/// Metric card widget
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? badge;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge!,
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
