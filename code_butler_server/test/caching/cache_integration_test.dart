import 'package:test/test.dart';
import 'package:code_butler_server/src/services/repository_cache.dart';
import 'package:code_butler_server/src/services/findings_cache.dart';

void main() {
  group('Cache Integration Tests', () {
    test('Repository cache stores and retrieves dependency graph', () {
      final cache = RepositoryCache(MockSession());
      final graph = {'file1.dart': ['file2.dart'], 'file2.dart': []};

      cache.cacheDependencyGraph('https://github.com/test/repo.git', graph);
      final retrieved = cache.getCachedGraph('https://github.com/test/repo.git');

      expect(retrieved, isNotNull);
      expect(retrieved, equals(graph));
    });

    test('Findings cache detects duplicates', () {
      final cache = FindingsCache(MockSession());
      final finding = MockAgentFinding();

      expect(cache.isDuplicateFinding(finding), isFalse);
      expect(cache.isDuplicateFinding(finding), isTrue);
    });
  });
}

class MockSession {
  void log(String message, {LogLevel? level}) {}
}

class MockAgentFinding {
  String? filePath = 'test.dart';
  int? lineNumber = 1;
  String category = 'security';
  String message = 'Test finding';
  int? id = 1;
}

enum LogLevel { info, warning, error }

