import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';
import 'package:code_butler_server/middleware/request_validator.dart';

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
      // Validate and sanitize inputs
      final validatedName = RequestValidator.validateString(name, maxLength: 255);
      final validatedUrl = RequestValidator.validateGitHubUrl(url);
      final validatedOwner = RequestValidator.validateString(owner, maxLength: 255);
      final validatedBranch = RequestValidator.validateString(defaultBranch, maxLength: 255);

      if (validatedName == null || validatedOwner == null || validatedBranch == null) {
        throw Exception('Name, owner, and defaultBranch are required');
      }

      // Check if repository with this URL already exists
      final existing = await Repository.db.findFirstRow(
        session,
        where: (r) => r.url.equals(validatedUrl),
      );

      if (existing != null) {
        session.log('Repository with URL $url already exists', level: LogLevel.warning);
        throw Exception('Repository with this URL already exists');
      }

      // Create new repository
      final repository = Repository(
        name: validatedName,
        url: validatedUrl,
        owner: validatedOwner,
        defaultBranch: validatedBranch,
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
      final validatedUrl = RequestValidator.validateGitHubUrl(url);
      final repository = await Repository.db.findFirstRow(
        session,
        where: (r) => r.url.equals(validatedUrl),
      );
      return repository;
    } catch (e) {
      session.log('Error getting repository by URL: $e', level: LogLevel.error);
      return null;
    }
  }
}

