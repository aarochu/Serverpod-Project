import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';
import 'package:code_butler_new_server/src/services/github_service.dart';

/// Health check endpoint
class HealthCheckEndpoint extends Endpoint {
  /// Comprehensive health check
  Future<Map<String, dynamic>> healthCheck(Session session) async {
    final status = <String, dynamic>{
      'status': 'healthy',
      'timestamp': DateTime.now().toIso8601String(),
      'checks': <String, dynamic>{},
    };

    // Check database connectivity
    try {
      await Repository.db.find(session, limit: 1);
      status['checks']['database'] = {'status': 'healthy', 'message': 'Connected'};
    } catch (e) {
      status['status'] = 'unhealthy';
      status['checks']['database'] = {'status': 'unhealthy', 'message': e.toString()};
    }

    // Check GitHub API access
    try {
      final githubService = GitHubService(session);
      // TODO: Access config values properly in Serverpod 3
      // For now, mark as warning
      status['checks']['github'] = {'status': 'warning', 'message': 'Token configuration check pending'};
    } catch (e) {
      status['checks']['github'] = {'status': 'unhealthy', 'message': e.toString()};
    }

    // Check Gemini API status
    try {
      // TODO: Access config values properly in Serverpod 3
      // For now, mark as warning
      status['checks']['gemini'] = {'status': 'warning', 'message': 'API key configuration check pending'};
    } catch (e) {
      status['checks']['gemini'] = {'status': 'unhealthy', 'message': e.toString()};
    }

    // Check queue depth
    try {
      final pendingJobs = await ReviewJob.db.find(
        session,
        where: (j) => j.status.equals('pending'),
      );
      final queueDepth = pendingJobs.length;
      status['checks']['jobQueue'] = {
        'status': queueDepth > 100 ? 'warning' : 'healthy',
        'message': '$queueDepth pending jobs',
        'queueDepth': queueDepth,
      };
    } catch (e) {
      status['checks']['jobQueue'] = {'status': 'unhealthy', 'message': e.toString()};
    }

    // Check disk space (simplified)
    try {
      final tempDir = Directory.systemTemp;
      if (await tempDir.exists()) {
        status['checks']['diskSpace'] = {'status': 'healthy', 'message': 'Temporary directory accessible'};
      } else {
        status['checks']['diskSpace'] = {'status': 'unhealthy', 'message': 'Temporary directory not accessible'};
      }
    } catch (e) {
      status['checks']['diskSpace'] = {'status': 'unhealthy', 'message': e.toString()};
    }

    return status;
  }
}

