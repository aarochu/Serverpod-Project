import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_butler_client/code_butler_client.dart';
import '../config/serverpod_client.dart';

/// Time range filter for dashboard data
enum TimeRange {
  last7Days,
  last30Days,
  allTime,
}

/// Provider for time range selection
final timeRangeProvider = StateProvider<TimeRange>((ref) => TimeRange.allTime);

/// Filter data by time range
DateTime? _getStartDate(TimeRange range) {
  final now = DateTime.now();
  switch (range) {
    case TimeRange.last7Days:
      return now.subtract(const Duration(days: 7));
    case TimeRange.last30Days:
      return now.subtract(const Duration(days: 30));
    case TimeRange.allTime:
      return null;
  }
}

/// Provider for all review sessions
/// Uses metrics endpoint if available, otherwise falls back to empty list
final allReviewSessionsProvider = FutureProvider<List<ReviewSession>>((ref) async {
  final client = ClientManager.client;
  final timeRange = ref.watch(timeRangeProvider);
  final startDate = _getStartDate(timeRange);
  
  try {
    // Try to use metrics endpoint if available
    if (client.metrics != null) {
      try {
        return await client.metrics.getAllReviewSessions(startDate);
      } catch (e) {
        // Endpoint might not exist yet, fall back to empty list
        return [];
      }
    }
    return [];
  } catch (e) {
    // Graceful fallback if endpoint doesn't exist
    return [];
  }
});

/// Provider for all findings
/// Uses metrics endpoint if available, otherwise falls back to empty list
final allFindingsProvider = FutureProvider<List<AgentFinding>>((ref) async {
  final client = ClientManager.client;
  final timeRange = ref.watch(timeRangeProvider);
  final startDate = _getStartDate(timeRange);
  
  try {
    // Try to use metrics endpoint if available
    if (client.metrics != null) {
      try {
        return await client.metrics.getAllFindings(startDate);
      } catch (e) {
        // Endpoint might not exist yet, fall back to empty list
        return [];
      }
    }
    return [];
  } catch (e) {
    // Graceful fallback if endpoint doesn't exist
    return [];
  }
});

/// Dashboard statistics data class
class DashboardStats {
  final int totalReviews;
  final Duration averageDuration;
  final int totalFindings;
  final double successRate;
  final double failureRate;
  final int criticalFindings;
  final int warningFindings;
  final int infoFindings;

  DashboardStats({
    required this.totalReviews,
    required this.averageDuration,
    required this.totalFindings,
    required this.successRate,
    required this.failureRate,
    required this.criticalFindings,
    required this.warningFindings,
    required this.infoFindings,
  });
}

/// Provider for dashboard statistics
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final sessionsAsync = ref.watch(allReviewSessionsProvider);
  final findingsAsync = ref.watch(allFindingsProvider);

  return await Future.wait([sessionsAsync.future, findingsAsync.future]).then(
    (results) {
      final sessions = results[0] as List<ReviewSession>;
      final findings = results[1] as List<AgentFinding>;

      // Calculate statistics
      final totalReviews = sessions.length;
      
      // Calculate average duration
      final completedSessions = sessions.where(
        (s) => s.status.toLowerCase() == 'completed',
      ).toList();
      
      Duration averageDuration = Duration.zero;
      if (completedSessions.isNotEmpty) {
        final totalDuration = completedSessions.fold<Duration>(
          Duration.zero,
          (sum, session) {
            final duration = session.updatedAt.difference(session.createdAt);
            return sum + duration;
          },
        );
        averageDuration = Duration(
          milliseconds: (totalDuration.inMilliseconds / completedSessions.length).round(),
        );
      }

      // Calculate success/failure rates
      final completedCount = sessions.where(
        (s) => s.status.toLowerCase() == 'completed',
      ).length;
      final failedCount = sessions.where(
        (s) => s.status.toLowerCase() == 'failed',
      ).length;
      
      final successRate = totalReviews > 0 
          ? (completedCount / totalReviews) * 100 
          : 0.0;
      final failureRate = totalReviews > 0 
          ? (failedCount / totalReviews) * 100 
          : 0.0;

      // Calculate findings breakdown
      final criticalFindings = findings.where(
        (f) => f.severity.toLowerCase() == 'critical',
      ).length;
      final warningFindings = findings.where(
        (f) => f.severity.toLowerCase() == 'warning',
      ).length;
      final infoFindings = findings.where(
        (f) => f.severity.toLowerCase() == 'info',
      ).length;

      return DashboardStats(
        totalReviews: totalReviews,
        averageDuration: averageDuration,
        totalFindings: findings.length,
        successRate: successRate,
        failureRate: failureRate,
        criticalFindings: criticalFindings,
        warningFindings: warningFindings,
        infoFindings: infoFindings,
      );
    },
  );
});

/// Data point for line chart
class FindingsTrendPoint {
  final DateTime date;
  final int findingsCount;

  FindingsTrendPoint({
    required this.date,
    required this.findingsCount,
  });
}

/// Provider for findings trend data (line chart)
/// Uses metrics endpoint if available, otherwise computes from local data
final findingsTrendProvider = FutureProvider<List<FindingsTrendPoint>>((ref) async {
  final client = ClientManager.client;
  final timeRange = ref.watch(timeRangeProvider);
  final startDate = _getStartDate(timeRange);
  
  try {
    // Try to use metrics endpoint if available
    if (client.metrics != null) {
      try {
        final trends = await client.metrics.getTrends(startDate, DateTime.now());
        // Convert backend response to FindingsTrendPoint list
        return trends.map((t) => FindingsTrendPoint(
          date: t.date,
          findingsCount: t.count,
        )).toList();
      } catch (e) {
        // Fall through to local computation
      }
    }
  } catch (e) {
    // Fall through to local computation
  }
  
  // Fallback to local computation
  final sessionsAsync = ref.watch(allReviewSessionsProvider);
  final findingsAsync = ref.watch(allFindingsProvider);

  return await Future.wait([sessionsAsync.future, findingsAsync.future]).then(
    (results) {
      final sessions = results[0] as List<ReviewSession>;
      final findings = results[1] as List<AgentFinding>;

      // Get last 15 reviews sorted by date
      final sortedSessions = List<ReviewSession>.from(sessions)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final recentSessions = sortedSessions.take(15).toList();

      // Group findings by review session date
      final Map<DateTime, int> findingsByDate = {};
      
      for (final session in recentSessions) {
        final sessionDate = DateTime(
          session.createdAt.year,
          session.createdAt.month,
          session.createdAt.day,
        );
        
        // Count findings for this session's PR
        final sessionFindings = findings.where(
          (f) => f.pullRequestId == session.pullRequestId,
        ).length;
        
        findingsByDate[sessionDate] = 
            (findingsByDate[sessionDate] ?? 0) + sessionFindings;
      }

      // Convert to list of trend points
      return findingsByDate.entries
          .map((entry) => FindingsTrendPoint(
                date: entry.key,
                findingsCount: entry.value,
              ))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    },
  );
});

/// Severity distribution data for pie chart
class SeverityDistribution {
  final int critical;
  final int warning;
  final int info;

  SeverityDistribution({
    required this.critical,
    required this.warning,
    required this.info,
  });

  int get total => critical + warning + info;
  
  double get criticalPercent => total > 0 ? (critical / total) * 100 : 0.0;
  double get warningPercent => total > 0 ? (warning / total) * 100 : 0.0;
  double get infoPercent => total > 0 ? (info / total) * 100 : 0.0;
}

/// Provider for severity distribution (pie chart)
final severityDistributionProvider = 
    FutureProvider<SeverityDistribution>((ref) async {
  final findingsAsync = ref.watch(allFindingsProvider);
  final findings = await findingsAsync.future;

  final critical = findings.where(
    (f) => f.severity.toLowerCase() == 'critical',
  ).length;
  final warning = findings.where(
    (f) => f.severity.toLowerCase() == 'warning',
  ).length;
  final info = findings.where(
    (f) => f.severity.toLowerCase() == 'info',
  ).length;

  return SeverityDistribution(
    critical: critical,
    warning: warning,
    info: info,
  );
});

/// Agent type distribution data for bar chart
class AgentTypeDistribution {
  final Map<String, int> counts;

  AgentTypeDistribution(this.counts);
}

/// Provider for agent type distribution (bar chart)
final agentTypeDistributionProvider = 
    FutureProvider<AgentTypeDistribution>((ref) async {
  final findingsAsync = ref.watch(allFindingsProvider);
  final findings = await findingsAsync.future;

  final Map<String, int> counts = {};
  for (final finding in findings) {
    counts[finding.agentType] = (counts[finding.agentType] ?? 0) + 1;
  }

  return AgentTypeDistribution(counts);
});

/// Problematic file data
class ProblematicFile {
  final String filePath;
  final int findingCount;
  final double densityScore;

  ProblematicFile({
    required this.filePath,
    required this.findingCount,
    required this.densityScore,
  });
}

/// Provider for most problematic files
/// Uses metrics endpoint if available, otherwise computes from local data
final problematicFilesProvider = FutureProvider<List<ProblematicFile>>((ref) async {
  final client = ClientManager.client;
  
  try {
    // Try to use metrics endpoint if available
    if (client.metrics != null) {
      try {
        final files = await client.metrics.getProblematicFiles(10);
        // Convert backend response to ProblematicFile list
        return files.map((f) => ProblematicFile(
          filePath: f.filePath,
          findingCount: f.count,
          densityScore: f.density,
        )).toList();
      } catch (e) {
        // Fall through to local computation
      }
    }
  } catch (e) {
    // Fall through to local computation
  }
  
  // Fallback to local computation
  final findingsAsync = ref.watch(allFindingsProvider);
  final findings = await findingsAsync.future;

  // Group findings by file path
  final Map<String, List<AgentFinding>> findingsByFile = {};
  for (final finding in findings) {
    if (finding.filePath != null && finding.filePath!.isNotEmpty) {
      findingsByFile.putIfAbsent(
        finding.filePath!,
        () => [],
      ).add(finding);
    }
  }

  // Calculate density score (findings per file - simplified)
  final problematicFiles = findingsByFile.entries.map((entry) {
    return ProblematicFile(
      filePath: entry.key,
      findingCount: entry.value.length,
      densityScore: entry.value.length.toDouble(), // Simplified - could use LOC if available
    );
  }).toList();

  // Sort by finding count descending
  problematicFiles.sort((a, b) => b.findingCount.compareTo(a.findingCount));

  return problematicFiles.take(10).toList();
});

/// Repository health score
class RepositoryHealth {
  final int repositoryId;
  final String repositoryName;
  final double healthScore; // 0-100
  final int totalFindings;
  final int fileCount;

  RepositoryHealth({
    required this.repositoryId,
    required this.repositoryName,
    required this.healthScore,
    required this.totalFindings,
    required this.fileCount,
  });
}

/// Provider for repository health scores
/// Uses metrics endpoint if available, otherwise computes from local data
final repositoryHealthProvider = FutureProvider<List<RepositoryHealth>>((ref) async {
  final client = ClientManager.client;
  
  try {
    // Try to use metrics endpoint if available
    if (client.metrics != null) {
      try {
        final health = await client.metrics.getRepositoryHealth();
        // Convert backend response to RepositoryHealth list
        return health.map((h) => RepositoryHealth(
          repositoryId: h.repositoryId,
          repositoryName: h.repositoryName,
          healthScore: h.healthScore,
          totalFindings: h.totalFindings,
          fileCount: h.fileCount,
        )).toList();
      } catch (e) {
        // Fall through to local computation
      }
    }
  } catch (e) {
    // Fall through to local computation
  }
  
  // Fallback to local computation
  final findingsAsync = ref.watch(allFindingsProvider);
  final findings = await findingsAsync.future;

  // Group findings by repository (via pull request)
  // Note: This is simplified - would need PR -> Repository mapping
  final Map<int, List<AgentFinding>> findingsByRepo = {};
  for (final finding in findings) {
    // Simplified: using pullRequestId as proxy for repository
    // In real implementation, would need to fetch PRs and map to repositories
    findingsByRepo.putIfAbsent(
      finding.pullRequestId,
      () => [],
    ).add(finding);
  }

  // Calculate health scores
  final healthScores = findingsByRepo.entries.map((entry) {
    final findingCount = entry.value.length;
    // Simplified health calculation: fewer findings = better health
    final healthScore = findingCount == 0 
        ? 100.0 
        : (100.0 / (1 + findingCount * 0.1)).clamp(0.0, 100.0);

    return RepositoryHealth(
      repositoryId: entry.key,
      repositoryName: 'Repository ${entry.key}',
      healthScore: healthScore,
      totalFindings: findingCount,
      fileCount: entry.value.map((f) => f.filePath).whereType<String>().toSet().length,
    );
  }).toList();

  healthScores.sort((a, b) => b.healthScore.compareTo(a.healthScore));
  return healthScores;
});

/// Provider for recent review sessions
final recentReviewSessionsProvider = FutureProvider<List<ReviewSession>>((ref) async {
  final sessionsAsync = ref.watch(allReviewSessionsProvider);
  final sessions = await sessionsAsync.future;

  // Sort by creation date descending and take last 10
  final sorted = List<ReviewSession>.from(sessions)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  
  return sorted.take(10).toList();
});

/// Agent effectiveness data
class AgentEffectiveness {
  final String agentType;
  final int findingsCount;
  final double averageConfidence;
  final int reviewsParticipated;

  AgentEffectiveness({
    required this.agentType,
    required this.findingsCount,
    required this.averageConfidence,
    required this.reviewsParticipated,
  });
}

/// Provider for agent effectiveness statistics
final agentEffectivenessProvider = FutureProvider<List<AgentEffectiveness>>((ref) async {
  final client = ClientManager.client;
  
  try {
    // Try to use metrics endpoint if available
    if (client.metrics != null) {
      try {
        final effectiveness = await client.metrics.getAgentEffectiveness();
        // Convert backend response to AgentEffectiveness list
        return effectiveness.map((e) => AgentEffectiveness(
          agentType: e.agentType,
          findingsCount: e.findingsCount,
          averageConfidence: e.averageConfidence,
          reviewsParticipated: e.reviewsParticipated,
        )).toList();
      } catch (e) {
        // Fall through to local computation
      }
    }
  } catch (e) {
    // Fall through to local computation
  }
  
  // Fallback to local computation from findings
  final findingsAsync = ref.watch(allFindingsProvider);
  final findings = await findingsAsync.future;
  
  final Map<String, List<AgentFinding>> findingsByAgent = {};
  for (final finding in findings) {
    findingsByAgent.putIfAbsent(
      finding.agentType,
      () => [],
    ).add(finding);
  }
  
  return findingsByAgent.entries.map((entry) {
    final agentFindings = entry.value;
    final avgConfidence = agentFindings
        .where((f) => f.confidence != null)
        .map((f) => f.confidence!)
        .fold<double>(0.0, (sum, conf) => sum + conf) / 
        (agentFindings.where((f) => f.confidence != null).length > 0 
            ? agentFindings.where((f) => f.confidence != null).length 
            : 1);
    
    return AgentEffectiveness(
      agentType: entry.key,
      findingsCount: agentFindings.length,
      averageConfidence: avgConfidence,
      reviewsParticipated: agentFindings.map((f) => f.pullRequestId).toSet().length,
    );
  }).toList();
});

/// Review statistics data
class ReviewStats {
  final int totalReviews;
  final int completedReviews;
  final int failedReviews;
  final Duration averageDuration;
  final double successRate;

  ReviewStats({
    required this.totalReviews,
    required this.completedReviews,
    required this.failedReviews,
    required this.averageDuration,
    required this.successRate,
  });
}

/// Provider for review statistics
final reviewStatsProvider = FutureProvider<ReviewStats>((ref) async {
  final client = ClientManager.client;
  
  try {
    // Try to use metrics endpoint if available
    if (client.metrics != null) {
      try {
        final stats = await client.metrics.getReviewStats();
        return ReviewStats(
          totalReviews: stats.totalReviews,
          completedReviews: stats.completedReviews,
          failedReviews: stats.failedReviews,
          averageDuration: stats.averageDuration,
          successRate: stats.successRate,
        );
      } catch (e) {
        // Fall through to local computation
      }
    }
  } catch (e) {
    // Fall through to local computation
  }
  
  // Fallback to local computation
  final sessionsAsync = ref.watch(allReviewSessionsProvider);
  final sessions = await sessionsAsync.future;
  
  final totalReviews = sessions.length;
  final completedReviews = sessions.where((s) => s.status.toLowerCase() == 'completed').length;
  final failedReviews = sessions.where((s) => s.status.toLowerCase() == 'failed').length;
  
  final completedSessions = sessions.where((s) => s.status.toLowerCase() == 'completed').toList();
  Duration averageDuration = Duration.zero;
  if (completedSessions.isNotEmpty) {
    final totalDuration = completedSessions.fold<Duration>(
      Duration.zero,
      (sum, session) => sum + session.updatedAt.difference(session.createdAt),
    );
    averageDuration = Duration(
      milliseconds: (totalDuration.inMilliseconds / completedSessions.length).round(),
    );
  }
  
  final successRate = totalReviews > 0 ? (completedReviews / totalReviews) * 100 : 0.0;
  
  return ReviewStats(
    totalReviews: totalReviews,
    completedReviews: completedReviews,
    failedReviews: failedReviews,
    averageDuration: averageDuration,
    successRate: successRate,
  );
});

