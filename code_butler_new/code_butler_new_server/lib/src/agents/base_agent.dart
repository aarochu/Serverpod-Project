import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';

/// Abstract base class for all code review agents
abstract class BaseAgent {
  /// The type identifier for this agent
  String get agentType;

  /// Session for database operations and logging
  Session? session;

  /// Analyzes a pull request and returns findings
  /// 
  /// [session] - Database session
  /// [pullRequestId] - ID of the pull request to analyze
  /// [reviewSession] - Current review session context
  /// Returns list of agent findings
  Future<List<AgentFinding>> analyze(
    Session session,
    int pullRequestId,
    ReviewSession reviewSession,
  );

  /// Logs an info message
  void logInfo(Session session, String message) {
    session.log('[$agentType] $message', level: LogLevel.info);
  }

  /// Logs an error message
  void logError(Session session, String message, [Object? error]) {
    final errorMsg = error != null ? '$message: $error' : message;
    session.log('[$agentType] ERROR: $errorMsg', level: LogLevel.error);
  }
}

