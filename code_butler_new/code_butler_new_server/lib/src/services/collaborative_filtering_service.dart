import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';

/// Collaborative filtering service for user preferences
class CollaborativeFilteringService {
  final Session session;

  CollaborativeFilteringService(this.session);

  /// Gets user preferences
  Future<List<UserPreference>> getUserPreferences(String userId) async {
    try {
      final preferences = await UserPreference.db.find(
        session,
        where: (p) => p.userId.equals(userId),
      );
      return preferences;
    } catch (e) {
      session.log('Error getting user preferences: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Adjusts severity based on user preferences
  Future<String> adjustSeverityForUser(AgentFinding finding, String userId) async {
    try {
      final preferences = await getUserPreferences(userId);
      
      for (final pref in preferences) {
        if (pref.findingType == finding.category && pref.action == 'reject') {
          // User consistently rejects this type, reduce severity
          if (finding.severity == 'critical' && pref.frequency > 5) {
            return 'warning';
          } else if (finding.severity == 'warning' && pref.frequency > 10) {
            return 'info';
          }
        }
      }
    } catch (e) {
      session.log('Error adjusting severity: $e', level: LogLevel.error);
    }

    return finding.severity;
  }

  /// Prioritizes agents based on user acceptance patterns
  Future<List<String>> prioritizeAgentsForUser(String userId) async {
    try {
      final preferences = await getUserPreferences(userId);
      final agentPriority = <String, int>{};

      for (final pref in preferences) {
        if (pref.action == 'accept') {
          // User accepts findings from this agent type
          agentPriority[pref.findingType] = (agentPriority[pref.findingType] ?? 0) + pref.frequency;
        }
      }

      // Sort by priority
      final sorted = agentPriority.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sorted.map((e) => e.key).toList();
    } catch (e) {
      session.log('Error prioritizing agents: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Records user action on a finding
  Future<void> recordUserAction(
    String userId,
    String findingType,
    String action, // accept/reject
  ) async {
    try {
      final existing = await UserPreference.db.findFirstRow(
        session,
        where: (p) => p.userId.equals(userId) & p.findingType.equals(findingType),
      );

      if (existing != null) {
        final updated = existing.copyWith(
          action: action,
          frequency: existing.frequency + 1,
          lastUpdated: DateTime.now(),
        );
        await UserPreference.db.updateRow(session, updated);
      } else {
        final newPref = UserPreference(
          userId: userId,
          findingType: findingType,
          action: action,
          frequency: 1,
          lastUpdated: DateTime.now(),
        );
        await UserPreference.db.insertRow(session, newPref);
      }
    } catch (e) {
      session.log('Error recording user action: $e', level: LogLevel.error);
    }
  }
}

