import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_butler_client/code_butler_client.dart';
import '../config/serverpod_client.dart';

/// Provider for fetching the list of repositories
final repositoryListProvider = FutureProvider<List<Repository>>((ref) async {
  final client = ClientManager.client;
  // Assuming endpoint: client.repository.listRepositories()
  // This will be available after Person 1 creates the backend endpoints
  return await client.repository.listRepositories();
});

/// Provider family for creating a new repository
/// 
/// Usage: ref.read(createRepositoryProvider(repoData).future)
final createRepositoryProvider = FutureProvider.family<Repository, ({
  String name,
  String url,
  String owner,
  String defaultBranch,
})>((ref, params) async {
  final client = ClientManager.client;
  // Assuming endpoint: client.repository.createRepository(...)
  // This will be available after Person 1 creates the backend endpoints
  final repository = await client.repository.createRepository(
    name: params.name,
    url: params.url,
    owner: params.owner,
    defaultBranch: params.defaultBranch,
  );
  
  // Invalidate the list provider to refresh the repository list
  ref.invalidate(repositoryListProvider);
  
  return repository;
});

