import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';

/// Repository similarity service
class RepositorySimilarityService {
  final Session session;

  RepositorySimilarityService(this.session);

  /// Calculates similarity between two repositories
  double calculateSimilarity(Repository repo1, Repository repo2) {
    double similarity = 0.0;

    // Same owner increases similarity
    if (repo1.owner == repo2.owner) {
      similarity += 0.3;
    }

    // Similar names (simple heuristic)
    final name1 = repo1.name.toLowerCase();
    final name2 = repo2.name.toLowerCase();
    if (name1.contains(name2) || name2.contains(name1)) {
      similarity += 0.2;
    }

    // Same default branch
    if (repo1.defaultBranch == repo2.defaultBranch) {
      similarity += 0.1;
    }

    // Would add more sophisticated checks: dependencies, framework, etc.
    return similarity.clamp(0.0, 1.0);
  }

  /// Finds similar repositories
  Future<List<Repository>> findSimilarRepositories(Repository repo) async {
    try {
      final allRepos = await Repository.db.find(session);
      final similarities = <MapEntry<Repository, double>>[];

      for (final otherRepo in allRepos) {
        if (otherRepo.id == repo.id) continue;
        final similarity = calculateSimilarity(repo, otherRepo);
        if (similarity > 0.3) {
          similarities.add(MapEntry(otherRepo, similarity));
        }
      }

      // Sort by similarity
      similarities.sort((a, b) => b.value.compareTo(a.value));

      return similarities.map((e) => e.key).toList();
    } catch (e) {
      session.log('Error finding similar repositories: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Applies learnings from similar repositories
  Future<List<String>> applyLearnings(
    Repository repo,
    List<Repository> similarRepos,
  ) async {
    final recommendations = <String>[];

    try {
      // Get common findings from similar repos
      final similarRepoIds = similarRepos.map((r) => r.id!).toSet();
      final findings = await AgentFinding.db.find(
        session,
        where: (f) => f.pullRequestId.inSet(similarRepoIds), // Simplified - would need proper join
      );

      // Count finding types
      final findingTypes = <String, int>{};
      for (final finding in findings) {
        findingTypes[finding.category] = (findingTypes[finding.category] ?? 0) + 1;
      }

      // Generate recommendations
      for (final entry in findingTypes.entries) {
        if (entry.value > 5) {
          recommendations.add('Common issue in similar repos: ${entry.key} (${entry.value} occurrences)');
        }
      }

      session.log('Applied learnings from ${similarRepos.length} similar repositories');
    } catch (e) {
      session.log('Error applying learnings: $e', level: LogLevel.error);
    }

    return recommendations;
  }

  /// Gets recommendations for repositories needing review
  Future<List<Repository>> getRecommendations() async {
    try {
      final repos = await Repository.db.find(session);
      final recommendations = <Repository>[];

      for (final repo in repos) {
        // Check last reviewed date
        if (repo.lastReviewedAt == null) {
          recommendations.add(repo);
          continue;
        }

        final daysSinceReview = DateTime.now().difference(repo.lastReviewedAt!).inDays;
        if (daysSinceReview > 30) {
          recommendations.add(repo);
        }
      }

      return recommendations;
    } catch (e) {
      session.log('Error getting recommendations: $e', level: LogLevel.error);
      return [];
    }
  }
}

