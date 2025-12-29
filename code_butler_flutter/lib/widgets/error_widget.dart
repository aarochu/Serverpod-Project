import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enhanced error widget with retry logic and helpful messages
class EnhancedErrorWidget extends StatefulWidget {
  final Object error;
  final VoidCallback onRetry;
  final String? title;
  final String? customMessage;

  const EnhancedErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
    this.title,
    this.customMessage,
  });

  @override
  State<EnhancedErrorWidget> createState() => _EnhancedErrorWidgetState();
}

class _EnhancedErrorWidgetState extends State<EnhancedErrorWidget> {
  int _retryCount = 0;
  DateTime? _lastRetryTime;

  String _getErrorMessage(Object error) {
    final errorString = error.toString().toLowerCase();

    // Network errors
    if (errorString.contains('socketexception') ||
        errorString.contains('network') ||
        errorString.contains('connection')) {
      return 'Network connection failed. Please check your internet connection and try again.';
    }

    // GitHub rate limit
    if (errorString.contains('rate limit') ||
        errorString.contains('403')) {
      return 'GitHub API rate limit exceeded. Please wait a few minutes before trying again.';
    }

    // Backend unreachable
    if (errorString.contains('failed host lookup') ||
        errorString.contains('connection refused') ||
        errorString.contains('localhost:8080')) {
      return 'Cannot connect to backend server. Please ensure the server is running on localhost:8080.';
    }

    // OAuth errors
    if (errorString.contains('oauth') ||
        errorString.contains('authentication')) {
      return 'Authentication failed. Please check your GitHub OAuth credentials and try again.';
    }

    // Generic error
    return widget.customMessage ?? 'An error occurred. Please try again.';
  }

  String _getErrorTitle() {
    final errorString = widget.error.toString().toLowerCase();

    if (errorString.contains('rate limit')) {
      return 'Rate Limit Exceeded';
    }
    if (errorString.contains('connection') || errorString.contains('network')) {
      return 'Connection Error';
    }
    if (errorString.contains('oauth') || errorString.contains('authentication')) {
      return 'Authentication Error';
    }

    return widget.title ?? 'Error';
  }

  IconData _getErrorIcon() {
    final errorString = widget.error.toString().toLowerCase();

    if (errorString.contains('rate limit')) {
      return Icons.timer_off;
    }
    if (errorString.contains('connection') || errorString.contains('network')) {
      return Icons.wifi_off;
    }
    if (errorString.contains('oauth') || errorString.contains('authentication')) {
      return Icons.lock;
    }

    return Icons.error_outline;
  }

  void _handleRetry() {
    setState(() {
      _retryCount++;
      _lastRetryTime = DateTime.now();
    });
    HapticFeedback.mediumImpact();
    widget.onRetry();
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = _getErrorMessage(widget.error);
    final errorTitle = _getErrorTitle();
    final errorIcon = _getErrorIcon();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              errorIcon,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              errorTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (_retryCount > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Retry attempt $_retryCount',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _handleRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
            const SizedBox(height: 12),
            // Show connection test button for backend errors
            if (widget.error.toString().toLowerCase().contains('localhost:8080'))
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Server URL: http://localhost:8080'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Show Server Info'),
              ),
          ],
        ),
      ),
    );
  }
}

