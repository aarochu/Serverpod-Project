import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/demo_config.dart';
import '../config/serverpod_client.dart';

/// Provider for demo mode state
final demoModeProvider = StateNotifierProvider<DemoModeNotifier, bool>((ref) {
  return DemoModeNotifier();
});

class DemoModeNotifier extends StateNotifier<bool> {
  DemoModeNotifier() : super(false) {
    _loadDemoMode();
  }

  Future<void> _loadDemoMode() async {
    state = await DemoConfig.isDemoMode();
  }

  Future<void> setDemoMode(bool enabled) async {
    await DemoConfig.setDemoMode(enabled);
    state = enabled;
  }
}

/// Provider for selected demo repository
final selectedDemoRepoProvider = StateNotifierProvider<DemoRepoNotifier, int?>((ref) {
  return DemoRepoNotifier();
});

class DemoRepoNotifier extends StateNotifier<int?> {
  DemoRepoNotifier() : super(null) {
    _loadDemoRepo();
  }

  Future<void> _loadDemoRepo() async {
    state = await DemoConfig.getDemoRepoId() ?? DemoConfig.defaultDemoRepoId;
  }

  Future<void> setDemoRepo(int? repoId) async {
    await DemoConfig.setDemoRepoId(repoId);
    state = repoId;
  }
}

/// Provider for resetting demo data
final resetDemoDataProvider = FutureProvider<void>((ref) async {
  final client = ClientManager.client;
  
  try {
    // Try to call backend seed script if available
    if (client.demo != null) {
      try {
        await client.demo.resetDemoData();
      } catch (e) {
        // Endpoint might not exist, ignore
      }
    }
  } catch (e) {
    // Ignore errors
  }
});

