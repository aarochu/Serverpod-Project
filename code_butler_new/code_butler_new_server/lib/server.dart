import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/endpoints.dart' as endpoints;
import 'package:code_butler_new_server/src/generated/protocol.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect to the database.
  final pod = Serverpod(
    args,
    Protocol(),
    endpoints.Endpoints(),
  );

  // Start the server.
  await pod.start();
}
