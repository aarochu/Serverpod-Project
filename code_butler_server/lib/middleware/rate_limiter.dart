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
    // Use IP address as client identifier
    return session.httpRequest?.remoteAddress ?? 'unknown';
  }
}

/// Rate limiting middleware wrapper
class RateLimitMiddleware extends EndpointMiddleware {
  final RateLimiter rateLimiter;

  RateLimitMiddleware(this.rateLimiter);

  @override
  Future<Object?> handleRequest(
    Session session,
    EndpointRequest request,
    EndpointRequestHandler next,
  ) async {
    final clientId = rateLimiter.getClientId(session);
    
    if (rateLimiter.shouldRateLimit(clientId)) {
      session.log('Rate limit exceeded for client: $clientId', level: LogLevel.warning);
      throw Exception('Rate limit exceeded. Please try again later.');
    }

    return await next(session, request);
  }
}

