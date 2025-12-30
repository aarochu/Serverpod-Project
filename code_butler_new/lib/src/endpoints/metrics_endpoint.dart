import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';

/// Metrics endpoint for analytics and monitoring
class MetricsEndpoint extends Endpoint {
  /// Gets repository health score
  Future<Map<String, dynamic>> getRepositoryHealth(
    Session session,
    int repositoryId,
  ) async {
    try {
      final repository = await Repository.db.findById(session, repositoryId);
      if (repository == null) {
        throw Exception('Repository not found');
      }

      // Get all findings for this repository
      final pullRequests = await PullRequest.db.find(
        session,
        where: (pr) => pr.repositoryId.equals(repositoryId),
      );

      final prIds = pullRequests.map((pr) => pr.id!).toList();
      if (prIds.isEmpty) {
        return {
          'repositoryId': repositoryId,
          'healthScore': 100.0,
          'totalFindings': 0,
          'criticalFindings': 0,
          'resolutionRate': 0.0,
        };
      }

      final findings = await AgentFinding.db.find(
        session,
        where: (f) => f.pullRequestId.inSet(prIds),
      );

      final totalFindings = findings.length;
      final criticalFindings = findings.where((f) => f.severity == 'critical').length;
      final warningFindings = findings.where((f) => f.severity == 'warning').length;

      // Calculate health score (0-100)
      double healthScore = 100.0;
      healthScore -= criticalFindings * 10.0;
      healthScore -= warningFindings * 5.0;
      healthScore = healthScore.clamp(0.0, 100.0);

      // Calculate resolution rate (simplified)
      final completedPRs = pullRequests.where((pr) => pr.status == 'completed').length;
      final resolutionRate = pullRequests.isNotEmpty
          ? (completedPRs / pullRequests.length) * 100.0
          : 0.0;

      return {
        'repositoryId': repositoryId,
        'healthScore': healthScore,
        'totalFindings': totalFindings,
        'criticalFindings': criticalFindings,
        'warningFindings': warningFindings,
        'resolutionRate': resolutionRate,
        'totalPRs': pullRequests.length,
        'completedPRs': completedPRs,
      };
    } catch (e) {
      session.log('Error getting repository health: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Gets trends data
  Future<Map<String, dynamic>> getTrends(Session session, String period) async {
    try {
      final now = DateTime.now();
      DateTime startDate;

      switch (period) {
        case 'day':
          startDate = now.subtract(const Duration(days: 1));
          break;
        case 'week':
          startDate = now.subtract(const Duration(days: 7));
          break;
        case 'month':
          startDate = now.subtract(const Duration(days: 30));
          break;
        default:
          startDate = now.subtract(const Duration(days: 7));
      }

      // Get findings in period
      final findings = await AgentFinding.db.find(
        session,
        where: (f) => f.createdAt.isGreaterThan(startDate),
      );

      // Get reviews in period
      final reviews = await ReviewSession.db.find(
        session,
        where: (r) => r.createdAt.isGreaterThan(startDate),
      );

      // Calculate averages
      final findingsPerDay = findings.length / (now.difference(startDate).inDays + 1);
      final reviewsPerWeek = reviews.length / ((now.difference(startDate).inDays + 1) / 7);

      // Calculate average review time
      double avgReviewTime = 0.0;
      if (reviews.isNotEmpty) {
        final completedReviews = reviews.where((r) => r.status == 'completed').toList();
        if (completedReviews.isNotEmpty) {
          final totalTime = completedReviews.fold<int>(
            0,
            (sum, r) => sum + r.updatedAt.difference(r.createdAt).inSeconds,
          );
          avgReviewTime = totalTime / completedReviews.length;
        }
      }

      return {
        'period': period,
        'findingsPerDay': findingsPerDay,
        'reviewsPerWeek': reviewsPerWeek,
        'averageReviewTimeSeconds': avgReviewTime,
        'totalFindings': findings.length,
        'totalReviews': reviews.length,
      };
    } catch (e) {
      session.log('Error getting trends: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Gets most problematic files
  Future<List<Map<String, dynamic>>> getMostProblematicFiles(
    Session session,
    int repositoryId,
  ) async {
    try {
      final pullRequests = await PullRequest.db.find(
        session,
        where: (pr) => pr.repositoryId.equals(repositoryId),
      );

      final prIds = pullRequests.map((pr) => pr.id!).toList();
      if (prIds.isEmpty) return [];

      final findings = await AgentFinding.db.find(
        session,
        where: (f) => f.pullRequestId.inSet(prIds) & f.filePath.isNotNull(),
      );

      // Count findings per file
      final fileCounts = <String, int>{};
      for (final finding in findings) {
        if (finding.filePath != null) {
          fileCounts[finding.filePath!] = (fileCounts[finding.filePath!] ?? 0) + 1;
        }
      }

      // Sort by count
      final sorted = fileCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sorted.take(10).map((e) => {
        'filePath': e.key,
        'findingCount': e.value,
      }).toList();
    } catch (e) {
      session.log('Error getting problematic files: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Gets agent effectiveness metrics
  Future<Map<String, dynamic>> getAgentEffectiveness(Session session) async {
    try {
      final findings = await AgentFinding.db.find(session);

      final agentStats = <String, Map<String, int>>{};
      for (final finding in findings) {
        final agent = finding.agentType;
        if (!agentStats.containsKey(agent)) {
          agentStats[agent] = {
            'total': 0,
            'critical': 0,
            'warning': 0,
            'info': 0,
          };
        }
        agentStats[agent]!['total'] = (agentStats[agent]!['total'] ?? 0) + 1;
        agentStats[agent]![finding.severity] = (agentStats[agent]![finding.severity] ?? 0) + 1;
      }

      return {
        'agents': agentStats.map((agent, stats) => MapEntry(agent, stats)),
      };
    } catch (e) {
      session.log('Error getting agent effectiveness: $e', level: LogLevel.error);
      return {};
    }
  }

  /// Gets review statistics
  Future<Map<String, dynamic>> getReviewStats(Session session) async {
    try {
      final reviews = await ReviewSession.db.find(session);
      final findings = await AgentFinding.db.find(session);

      final totalReviews = reviews.length;
      final completedReviews = reviews.where((r) => r.status == 'completed').length;
      final failedReviews = reviews.where((r) => r.status == 'failed').length;

      // Calculate average duration
      double avgDuration = 0.0;
      if (completedReviews > 0) {
        final completed = reviews.where((r) => r.status == 'completed').toList();
        final totalTime = completed.fold<int>(
          0,
          (sum, r) => sum + r.updatedAt.difference(r.createdAt).inSeconds,
        );
        avgDuration = totalTime / completed.length;
      }

      // Findings distribution
      final findingsBySeverity = <String, int>{};
      for (final finding in findings) {
        findingsBySeverity[finding.severity] = (findingsBySeverity[finding.severity] ?? 0) + 1;
      }

      return {
        'totalReviews': totalReviews,
        'completedReviews': completedReviews,
        'failedReviews': failedReviews,
        'completionRate': totalReviews > 0 ? (completedReviews / totalReviews) * 100.0 : 0.0,
        'averageDurationSeconds': avgDuration,
        'totalFindings': findings.length,
        'findingsBySeverity': findingsBySeverity,
      };
    } catch (e) {
      session.log('Error getting review stats: $e', level: LogLevel.error);
      return {};
    }
  }
}

