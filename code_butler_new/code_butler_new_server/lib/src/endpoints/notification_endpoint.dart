import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/generated/protocol.dart';

/// Notification endpoint for user notifications
class NotificationEndpoint extends Endpoint {
  /// Gets notifications for a user
  Future<List<ReviewNotification>> getNotifications(
    Session session,
    String userId,
  ) async {
    try {
      final notifications = await ReviewNotification.db.find(
        session,
        where: (n) => n.userId.equals(userId),
        orderBy: (n) => n.createdAt,
        orderDescending: true,
        limit: 50,
      );
      return notifications;
    } catch (e) {
      session.log('Error getting notifications: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Marks notification as read
  Future<void> markAsRead(Session session, int notificationId) async {
    try {
      final notification = await ReviewNotification.db.findById(session, notificationId);
      if (notification == null) return;

      final updated = notification.copyWith(read: true);
      await ReviewNotification.db.updateRow(session, updated);
    } catch (e) {
      session.log('Error marking notification as read: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Gets unread notification count
  Future<int> getUnreadCount(Session session, String userId) async {
    try {
      final notifications = await ReviewNotification.db.find(
        session,
        where: (n) => n.userId.equals(userId) & n.read.equals(false),
      );
      return notifications.length;
    } catch (e) {
      session.log('Error getting unread count: $e', level: LogLevel.error);
      return 0;
    }
  }
}

