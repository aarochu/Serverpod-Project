import 'dart:async';
import 'package:code_butler_client/code_butler_client.dart';
import '../config/serverpod_client.dart';

/// Notification data model
class AppNotification {
  final int id;
  final String type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.metadata,
  });
}

/// Notification service for polling and managing notifications
class NotificationService {
  Timer? _pollTimer;
  final StreamController<List<AppNotification>> _notificationsController =
      StreamController<List<AppNotification>>.broadcast();
  
  Stream<List<AppNotification>> get notificationsStream => _notificationsController.stream;

  /// Start polling for notifications
  void startPolling({Duration interval = const Duration(seconds: 30)}) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(interval, (_) => _fetchNotifications());
    // Fetch immediately
    _fetchNotifications();
  }

  /// Stop polling for notifications
  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  /// Fetch notifications from backend
  Future<List<AppNotification>> _fetchNotifications() async {
    try {
      final client = ClientManager.client;
      
      // Try to use notification endpoint if available
      if (client.notification != null) {
        try {
          final notifications = await client.notification.getNotifications();
          // Convert backend response to AppNotification list
          final appNotifications = notifications.map((n) => AppNotification(
            id: n.id,
            type: n.type,
            title: n.title,
            message: n.message,
            timestamp: n.timestamp,
            isRead: n.isRead,
            metadata: n.metadata,
          )).toList();
          
          _notificationsController.add(appNotifications);
          return appNotifications;
        } catch (e) {
          // Endpoint might not exist yet, return empty list
          _notificationsController.add([]);
          return [];
        }
      }
      
      _notificationsController.add([]);
      return [];
    } catch (e) {
      _notificationsController.add([]);
      return [];
    }
  }

  /// Get notifications (one-time fetch)
  Future<List<AppNotification>> getNotifications() async {
    return await _fetchNotifications();
  }

  /// Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      final client = ClientManager.client;
      
      if (client.notification != null) {
        try {
          await client.notification.markAsRead(notificationId);
          // Refresh notifications after marking as read
          await _fetchNotifications();
        } catch (e) {
          // Endpoint might not exist yet, ignore
        }
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Dispose resources
  void dispose() {
    stopPolling();
    _notificationsController.close();
  }
}

