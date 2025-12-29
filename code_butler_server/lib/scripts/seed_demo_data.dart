import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';

/// Seed script to populate database with demo data
/// Run with: dart run lib/scripts/seed_demo_data.dart
Future<void> main(List<String> args) async {
  print('🌱 Seeding demo data...');

  // Initialize Serverpod
  final pod = Serverpod(
    [],
    Protocol(),
    Endpoints(),
  );

  await pod.start();

  try {
    final session = Session(pod.server);

    // Clear existing data (optional - comment out to preserve data)
    print('Clearing existing data...');
    await _clearDatabase(session);

    // Create demo repository
    print('Creating demo repository...');
    final repository = await _createDemoRepository(session);

    // Create demo pull requests
    print('Creating demo pull requests...');
    final pullRequests = await _createDemoPullRequests(session, repository.id!);

    // Create historical reviews with findings
    print('Creating historical reviews...');
    await _createHistoricalReviews(session, pullRequests);

    // Populate pattern library
    print('Populating pattern library...');
    await _populatePatternLibrary(session);

    // Create user preferences
    print('Creating user preferences...');
    await _createUserPreferences(session);

    print('✅ Demo data seeded successfully!');
    print('');
    print('Repository ID: ${repository.id}');
    print('Pull Requests created: ${pullRequests.length}');
  } catch (e) {
    print('❌ Error seeding data: $e');
    exit(1);
  } finally {
    await pod.stop();
  }
}

Future<void> _clearDatabase(Session session) async {
  // Clear in reverse dependency order
  await AgentFinding.db.deleteWhere(session, where: (f) => f.id.isNotNull());
  await GeneratedDocumentation.db.deleteWhere(session, where: (d) => d.id.isNotNull());
  await ReviewSession.db.deleteWhere(session, where: (r) => r.id.isNotNull());
  await PullRequest.db.deleteWhere(session, where: (pr) => pr.id.isNotNull());
  await Repository.db.deleteWhere(session, where: (r) => r.id.isNotNull());
  await PatternLibrary.db.deleteWhere(session, where: (p) => p.id.isNotNull());
  await UserPreference.db.deleteWhere(session, where: (u) => u.id.isNotNull());
}

Future<Repository> _createDemoRepository(Session session) async {
  final repository = Repository(
    name: 'code-butler-demo',
    url: 'https://github.com/demo/code-butler-demo.git',
    owner: 'demo',
    defaultBranch: 'main',
    lastReviewedAt: DateTime.now().subtract(const Duration(days: 1)),
  );

  return await Repository.db.insertRow(session, repository);
}

Future<List<PullRequest>> _createDemoPullRequests(
  Session session,
  int repositoryId,
) async {
  final pullRequests = <PullRequest>[];

  for (int i = 1; i <= 5; i++) {
    final pr = PullRequest(
      repositoryId: repositoryId,
      prNumber: i,
      title: 'Demo PR #$i: ${_getPRTitle(i)}',
      status: i == 1 ? 'pending' : 'completed',
      baseBranch: 'main',
      headBranch: 'feature/demo-$i',
      filesChanged: 5 + i * 2,
      createdAt: DateTime.now().subtract(Duration(days: 10 - i)),
      updatedAt: DateTime.now().subtract(Duration(days: 10 - i)),
    );

    final created = await PullRequest.db.insertRow(session, pr);
    pullRequests.add(created);
  }

  return pullRequests;
}

String _getPRTitle(int prNumber) {
  final titles = [
    'Add new feature',
    'Fix security vulnerability',
    'Improve performance',
    'Update documentation',
    'Refactor code',
  ];
  return titles[(prNumber - 1) % titles.length];
}

Future<void> _createHistoricalReviews(
  Session session,
  List<PullRequest> pullRequests,
) async {
  for (int i = 0; i < pullRequests.length; i++) {
    final pr = pullRequests[i];
    final findingCount = 3 + i * 2; // Varying finding counts

    // Create review session
    final reviewSession = ReviewSession(
      pullRequestId: pr.id!,
      status: pr.status == 'completed' ? 'completed' : 'pending',
      currentFile: null,
      filesProcessed: pr.filesChanged,
      totalFiles: pr.filesChanged,
      progressPercent: pr.status == 'completed' ? 100.0 : 50.0,
      errorMessage: null,
      createdAt: pr.createdAt,
      updatedAt: pr.updatedAt,
    );

    final createdSession = await ReviewSession.db.insertRow(session, reviewSession);

    // Create findings
    final agentTypes = ['security', 'performance', 'reader', 'documentation'];
    final severities = ['critical', 'warning', 'info'];
    final categories = [
      'hardcoded_secret',
      'sql_injection',
      'inefficient_algorithm',
      'missing_documentation',
      'complexity',
    ];

    for (int j = 0; j < findingCount; j++) {
      final finding = AgentFinding(
        pullRequestId: pr.id!,
        agentType: agentTypes[j % agentTypes.length],
        severity: severities[j % severities.length],
        category: categories[j % categories.length],
        message: _getFindingMessage(j),
        filePath: 'lib/file_${j % 5}.dart',
        lineNumber: 10 + j * 5,
        codeSnippet: _getCodeSnippet(j),
        suggestedFix: _getSuggestedFix(j),
        createdAt: pr.createdAt.add(Duration(minutes: j)),
      );

      await AgentFinding.db.insertRow(session, finding);
    }
  }
}

String _getFindingMessage(int index) {
  final messages = [
    'Hardcoded API key detected',
    'Potential SQL injection vulnerability',
    'Inefficient nested loop detected',
    'Missing documentation for public method',
    'High cyclomatic complexity',
    'Unsafe eval usage',
    'Missing const constructor',
    'Inefficient string concatenation',
  ];
  return messages[index % messages.length];
}

String _getCodeSnippet(int index) {
  final snippets = [
    'apiKey = "sk-live-123456"',
    'query = "SELECT * FROM users WHERE name = \'$userInput\'"',
    'for (int i = 0; i < 100; i++) { for (int j = 0; j < 100; j++) { ... } }',
    'void processData(String input) { ... }',
    'Complex function with 15+ branches',
  ];
  return snippets[index % snippets.length];
}

String _getSuggestedFix(int index) {
  final fixes = [
    'Use environment variables or secrets management',
    'Use parameterized queries',
    'Refactor nested loops or use more efficient algorithms',
    'Add documentation comment',
    'Break down into smaller functions',
  ];
  return fixes[index % fixes.length];
}

Future<void> _populatePatternLibrary(Session session) async {
  final patterns = [
    {
      'pattern': 'Hardcoded API key',
      'language': 'dart',
      'category': 'security',
      'fix': 'Use Platform.environment or secrets management',
      'confidence': 0.9,
    },
    {
      'pattern': 'SQL injection',
      'language': 'dart',
      'category': 'security',
      'fix': 'Use parameterized queries',
      'confidence': 0.85,
    },
    {
      'pattern': 'Nested loops',
      'language': 'dart',
      'category': 'performance',
      'fix': 'Refactor or use efficient data structures',
      'confidence': 0.7,
    },
    {
      'pattern': 'Missing documentation',
      'language': 'dart',
      'category': 'documentation',
      'fix': 'Add docstring or documentation comment',
      'confidence': 0.8,
    },
  ];

  for (final patternData in patterns) {
    final pattern = PatternLibrary(
      pattern: patternData['pattern'] as String,
      language: patternData['language'] as String,
      category: patternData['category'] as String,
      fixTemplate: patternData['fix'] as String,
      confidence: patternData['confidence'] as double,
      occurrenceCount: 5 + (patterns.indexOf(patternData) * 3),
      lastSeen: DateTime.now().subtract(Duration(days: patterns.indexOf(patternData))),
    );

    await PatternLibrary.db.insertRow(session, pattern);
  }
}

Future<void> _createUserPreferences(Session session) async {
  final preferences = [
    {
      'userId': 'demo_user_1',
      'findingType': 'security',
      'action': 'accept',
      'frequency': 10,
    },
    {
      'userId': 'demo_user_1',
      'findingType': 'performance',
      'action': 'accept',
      'frequency': 8,
    },
    {
      'userId': 'demo_user_1',
      'findingType': 'documentation',
      'action': 'reject',
      'frequency': 5,
    },
  ];

  for (final prefData in preferences) {
    final preference = UserPreference(
      userId: prefData['userId'] as String,
      findingType: prefData['findingType'] as String,
      action: prefData['action'] as String,
      frequency: prefData['frequency'] as int,
      lastUpdated: DateTime.now().subtract(Duration(days: preferences.indexOf(prefData))),
    );

    await UserPreference.db.insertRow(session, preference);
  }
}

