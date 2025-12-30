import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/endpoints.dart' as endpoints;
import 'package:code_butler_server/src/generated/protocol.dart';

// This is the starting point of your server. All server endpoints are referenced from this file.

void main(List<String> args) {
  // Initialize Serverpod and connect to the database.
  final pod = Serverpod(
    args,
    Protocol(),
    endpoints.Endpoints(),
  );

  pod.start();
}

