import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user preferences and state persistence
class PreferencesService {
  static const String _themeModeKey = 'theme_mode';
  static const String _timeRangeKey = 'time_range';
  static const String _lastRepositoryKey = 'last_repository_id';
  static const String _lastReviewKey = 'last_review_id';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  /// Get theme mode preference
  static Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey);
  }

  /// Set theme mode preference
  static Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode);
  }

  /// Get time range preference
  static Future<String?> getTimeRange() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_timeRangeKey);
  }

  /// Set time range preference
  static Future<void> setTimeRange(String range) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timeRangeKey, range);
  }

  /// Get last viewed repository ID
  static Future<int?> getLastRepositoryId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastRepositoryKey);
  }

  /// Set last viewed repository ID
  static Future<void> setLastRepositoryId(int? repoId) async {
    final prefs = await SharedPreferences.getInstance();
    if (repoId != null) {
      await prefs.setInt(_lastRepositoryKey, repoId);
    } else {
      await prefs.remove(_lastRepositoryKey);
    }
  }

  /// Get last viewed review ID
  static Future<int?> getLastReviewId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastReviewKey);
  }

  /// Set last viewed review ID
  static Future<void> setLastReviewId(int? reviewId) async {
    final prefs = await SharedPreferences.getInstance();
    if (reviewId != null) {
      await prefs.setInt(_lastReviewKey, reviewId);
    } else {
      await prefs.remove(_lastReviewKey);
    }
  }

  /// Check if onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  /// Mark onboarding as completed
  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, completed);
  }

  /// Clear all preferences
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

