import 'package:serverpod/serverpod.dart';

/// Rate limiter middleware
class RateLimiter {
  final Map<String, List<DateTime>> _requestHistory = {};
  final int requestsPerMinute;
  final int burstSize;

  RateLimiter({
    this.requestsPerMinute = 60,
    this.burstSize = 10,
  });

  /// Checks if request should be rate limited
  bool shouldRateLimit(String clientId) {
    final now = DateTime.now();
    final history = _requestHistory.putIfAbsent(clientId, () => []);

    // Remove requests older than 1 minute
    history.removeWhere((timestamp) => now.difference(timestamp).inMinutes >= 1);

    // Check if over limit
    if (history.length >= requestsPerMinute) {
      return true;
    }

    // Add current request
    history.add(now);

    // Clean up old entries (keep only last 100 clients)
    if (_requestHistory.length > 100) {
      final keysToRemove = _requestHistory.keys.take(_requestHistory.length - 100).toList();
      for (final key in keysToRemove) {
        _requestHistory.remove(key);
      }
    }

    return false;
  }

  /// Gets client identifier from request
  String getClientId(Session session) {
    // Use session ID as client identifier (simplified)
    return session.sessionId?.toString() ?? 'unknown';
  }
}

