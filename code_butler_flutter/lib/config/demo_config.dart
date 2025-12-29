import 'package:shared_preferences/shared_preferences.dart';

/// Demo configuration and utilities
class DemoConfig {
  static const String _demoModeKey = 'demo_mode_enabled';
  static const String _demoRepoIdKey = 'demo_repo_id';
  
  /// Check if demo mode is enabled
  static Future<bool> isDemoMode() async {
    // Check environment variable first (for production builds)
    const envDemoMode = String.fromEnvironment('DEMO_MODE', defaultValue: 'false');
    if (envDemoMode == 'true') {
      return true;
    }
    
    // Check SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_demoModeKey) ?? false;
  }

  /// Enable or disable demo mode
  static Future<void> setDemoMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_demoModeKey, enabled);
  }

  /// Get demo repository ID
  static Future<int?> getDemoRepoId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_demoRepoIdKey);
  }

  /// Set demo repository ID
  static Future<void> setDemoRepoId(int? repoId) async {
    final prefs = await SharedPreferences.getInstance();
    if (repoId != null) {
      await prefs.setInt(_demoRepoIdKey, repoId);
    } else {
      await prefs.remove(_demoRepoIdKey);
    }
  }

  /// Demo repository ID constant (fallback)
  static const int defaultDemoRepoId = 1;

  /// Animation speed multiplier in demo mode
  static const double demoAnimationSpeed = 1.5;

  /// Skip loading states in demo mode
  static const bool skipLoadingStates = true;

  /// Generate demo data for when backend unavailable
  static Map<String, dynamic> generateDemoRepository() {
    return {
      'id': 1,
      'name': 'demo-repo',
      'url': 'https://github.com/demo/demo-repo',
      'owner': 'demo',
      'defaultBranch': 'main',
    };
  }

  static List<Map<String, dynamic>> generateDemoPullRequests() {
    return [
      {
        'id': 1,
        'number': 42,
        'title': 'Add new feature',
        'state': 'open',
        'filesChanged': 15,
      },
      {
        'id': 2,
        'number': 41,
        'title': 'Fix bug in authentication',
        'state': 'closed',
        'filesChanged': 3,
      },
    ];
  }

  static List<Map<String, dynamic>> generateDemoFindings() {
    return [
      {
        'id': 1,
        'severity': 'critical',
        'category': 'Security',
        'agentType': 'Security',
        'message': 'Potential SQL injection vulnerability',
        'filePath': 'lib/database/query.dart',
        'lineNumber': 42,
      },
      {
        'id': 2,
        'severity': 'warning',
        'category': 'Performance',
        'agentType': 'Performance',
        'message': 'Inefficient loop detected',
        'filePath': 'lib/utils/processor.dart',
        'lineNumber': 128,
      },
    ];
  }
}

