import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service for GitHub OAuth authentication
class GitHubAuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'github_access_token';
  
  // TODO: Configure these from environment or config file
  // For now, these should be set from GitHub OAuth app settings
  static const String clientId = 'YOUR_GITHUB_CLIENT_ID';
  static const String clientSecret = 'YOUR_GITHUB_CLIENT_SECRET';
  static const String redirectUrl = 'http://localhost:8080/auth/callback';
  static const String callbackUrlScheme = 'localhost';
  
  /// Authenticate with GitHub using OAuth flow
  /// Returns access token on success, throws exception on failure
  Future<String> authenticateWithGitHub() async {
    try {
      final url = Uri.https(
        'github.com',
        '/login/oauth/authorize',
        {
          'client_id': clientId,
          'redirect_uri': redirectUrl,
          'scope': 'repo read:user',
          'response_type': 'code',
        },
      );

      final result = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: callbackUrlScheme,
        options: const FlutterWebAuth2Options(
          intentFlags: {
            AndroidIntentFlag.newTask,
            AndroidIntentFlag.clearTop,
          },
        ),
      );

      // Parse the callback URL to extract the code
      final callbackUri = Uri.parse(result);
      final code = callbackUri.queryParameters['code'];
      
      if (code == null) {
        final error = callbackUri.queryParameters['error'];
        final errorDescription = callbackUri.queryParameters['error_description'];
        throw Exception(
          errorDescription ?? error ?? 'Authentication failed',
        );
      }

      // Exchange code for access token
      final token = await _exchangeCodeForToken(code);
      
      // Store token securely
      await _storage.write(key: _tokenKey, value: token);
      
      return token;
    } on FlutterWebAuth2Exception catch (e) {
      throw Exception('OAuth flow cancelled or failed: ${e.message}');
    } catch (e) {
      throw Exception('Failed to authenticate with GitHub: $e');
    }
  }

  /// Exchange authorization code for access token
  Future<String> _exchangeCodeForToken(String code) async {
    // Note: In production, this should be done on the backend for security
    // For now, we'll make a direct call (not recommended for production)
    final response = await http.post(
      Uri.https('github.com', '/login/oauth/access_token'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'redirect_uri': redirectUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to exchange code for token: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final token = data['access_token'] as String?;
    
    if (token == null) {
      final error = data['error'] ?? 'Unknown error';
      throw Exception('Failed to get access token: $error');
    }

    return token;
  }

  /// Get stored access token
  Future<String?> getStoredToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout and clear stored token
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}

