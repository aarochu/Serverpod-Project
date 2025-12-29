import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:code_butler_client/code_butler_client.dart';

/// Singleton manager for Serverpod client initialization
class ClientManager {
  static Client? _client;

  /// Get the initialized client instance
  /// Throws an exception if client has not been initialized
  static Client get client {
    if (_client == null) {
      throw Exception(
        'ClientManager not initialized. Call ClientManager.initialize() first.',
      );
    }
    return _client!;
  }

  /// Initialize the Serverpod client
  /// 
  /// [host] - Server host (default: 'localhost')
  /// [port] - Server port (default: 8080)
  /// [isProduction] - Whether running in production mode
  static Future<void> initialize({
    String host = 'localhost',
    int port = 8080,
    bool isProduction = false,
  }) async {
    _client = Client(
      'http://$host:$port/',
      authenticationKeyManager: FlutterAuthenticationKeyManager(),
    );
  }
}

