import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';

class RepositoryEndpoint extends Endpoint {
  /// Creates a new repository in the database
  Future<Repository> createRepository(
    Session session,
    String name,
    String url,
    String owner,
    String defaultBranch,
  ) async {
    try {
      // Check if repository with this URL already exists
      final existing = await Repository.db.findFirstRow(
        session,
        where: (r) => r.url.equals(url),
      );

      if (existing != null) {
        session.log('Repository with URL $url already exists', level: LogLevel.warning);
        throw Exception('Repository with this URL already exists');
      }

      // Create new repository
      final repository = Repository(
        name: name,
        url: url,
        owner: owner,
        defaultBranch: defaultBranch,
        lastReviewedAt: null,
      );

      final created = await Repository.db.insertRow(session, repository);
      session.log('Created repository: ${created.id} - $name');
      return created;
    } catch (e) {
      session.log('Error creating repository: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Lists all repositories ordered by name
  Future<List<Repository>> listRepositories(Session session) async {
    try {
      final repositories = await Repository.db.find(
        session,
        orderBy: (r) => r.name,
      );
      return repositories;
    } catch (e) {
      session.log('Error listing repositories: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Gets a repository by its URL
  Future<Repository?> getRepositoryByUrl(Session session, String url) async {
    try {
      final repository = await Repository.db.findFirstRow(
        session,
        where: (r) => r.url.equals(url),
      );
      return repository;
    } catch (e) {
      session.log('Error getting repository by URL: $e', level: LogLevel.error);
      return null;
    }
  }
}

