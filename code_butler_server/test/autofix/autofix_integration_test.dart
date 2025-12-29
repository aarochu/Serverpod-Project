import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/generated/protocol.dart';
import 'package:code_butler_server/src/services/autofix_service.dart';
import 'package:code_butler_server/src/services/git_patch_service.dart';

void main() {
  group('Autofix Integration Tests', () {
    test('Generate fix for security finding', () async {
      // Mock finding
      final finding = AgentFinding(
        pullRequestId: 1,
        agentType: 'security',
        severity: 'critical',
        category: 'hardcoded_secret',
        message: 'Hardcoded secret detected',
        filePath: 'test.dart',
        lineNumber: 10,
        codeSnippet: 'password = "secret123"',
        suggestedFix: 'Use environment variable',
        createdAt: DateTime.now(),
      );

      final originalCode = 'password = "secret123"';
      final autofixService = AutofixService(MockSession());
      final fix = await autofixService.generateFix(finding, originalCode);

      expect(fix, isNotNull);
      expect(fix!.fixedCode, isNot(equals(originalCode)));
      expect(fix.confidenceScore, greaterThan(0.0));
    });

    test('Generate patch from fixes', () {
      final fixes = [
        Fix(
          originalCode: 'old code',
          fixedCode: 'new code',
          lineNumbers: [1],
          confidenceScore: 0.8,
          filePath: 'test.dart',
        ),
      ];

      final patchService = GitPatchService(MockSession(), MockGitHubService());
      final patch = patchService.createPatch(fixes, 'test.dart');

      expect(patch, isNotEmpty);
      expect(patch, contains('diff --git'));
      expect(patch, contains('test.dart'));
    });

    test('Group fixes by file', () {
      final fixes = [
        Fix(
          originalCode: 'code1',
          fixedCode: 'fixed1',
          lineNumbers: [1],
          confidenceScore: 0.8,
          filePath: 'file1.dart',
        ),
        Fix(
          originalCode: 'code2',
          fixedCode: 'fixed2',
          lineNumbers: [2],
          confidenceScore: 0.9,
          filePath: 'file1.dart',
        ),
        Fix(
          originalCode: 'code3',
          fixedCode: 'fixed3',
          lineNumbers: [3],
          confidenceScore: 0.7,
          filePath: 'file2.dart',
        ),
      ];

      final patchService = GitPatchService(MockSession(), MockGitHubService());
      final grouped = patchService.groupFixesByFile(fixes);

      expect(grouped.length, equals(2));
      expect(grouped['file1.dart']?.length, equals(2));
      expect(grouped['file2.dart']?.length, equals(1));
    });
  });
}

// Mock classes for testing
class MockSession extends Session {
  MockSession() : super(
    server: Server([], Protocol(), Endpoints(), config: ServerpodConfig()),
  );
}

class MockGitHubService {
  // Mock implementation
}

