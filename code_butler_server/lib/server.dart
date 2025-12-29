import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/endpoints/repository_endpoint.dart';
import 'package:code_butler_server/src/endpoints/review_endpoint.dart';
import 'package:code_butler_server/src/endpoints/pull_request_endpoint.dart';
import 'package:code_butler_server/src/endpoints/webhook_endpoint.dart';
import 'package:code_butler_server/src/endpoints/notification_endpoint.dart';
import 'package:code_butler_server/src/endpoints/metrics_endpoint.dart';
import 'package:code_butler_server/src/endpoints/health_check_endpoint.dart';

// This is the starting point of your server. All server endpoints are referenced from this file.

void main(List<String> args) {
  // Initialize Serverpod and connect to the database.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  pod.start();
}

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    // Register all endpoints
    RepositoryEndpoint.register(server);
    ReviewEndpoint.register(server);
    PullRequestEndpoint.register(server);
    WebhookEndpoint.register(server);
    NotificationEndpoint.register(server);
    MetricsEndpoint.register(server);
    HealthCheckEndpoint.register(server);
  }
}

