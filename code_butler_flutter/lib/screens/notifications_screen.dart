import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/notification_service.dart';
import '../providers/notification_provider.dart';

/// Notifications screen displaying all notifications
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'review_completed':
        return Icons.check_circle;
      case 'autofix_applied':
        return Icons.auto_fix_high;
      case 'webhook_triggered':
        return Icons.webhook;
      case 'error_alert':
        return Icons.error;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type, BuildContext context) {
    switch (type) {
      case 'review_completed':
        return Colors.green;
      case 'autofix_applied':
        return Colors.blue;
      case 'webhook_triggered':
        return Colors.purple;
      case 'error_alert':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(notificationsProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading notifications',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    ref.invalidate(notificationsProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You\'re all caught up!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Group notifications by date
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final yesterday = today.subtract(const Duration(days: 1));
          final thisWeek = today.subtract(const Duration(days: 7));

          final todayNotifications = <AppNotification>[];
          final yesterdayNotifications = <AppNotification>[];
          final thisWeekNotifications = <AppNotification>[];
          final olderNotifications = <AppNotification>[];

          for (final notification in notifications) {
            final notificationDate = DateTime(
              notification.timestamp.year,
              notification.timestamp.month,
              notification.timestamp.day,
            );

            if (notificationDate == today) {
              todayNotifications.add(notification);
            } else if (notificationDate == yesterday) {
              yesterdayNotifications.add(notification);
            } else if (notificationDate.isAfter(thisWeek)) {
              thisWeekNotifications.add(notification);
            } else {
              olderNotifications.add(notification);
            }
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(notificationsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                if (todayNotifications.isNotEmpty) ...[
                  _buildSectionHeader(context, 'Today'),
                  ...todayNotifications.map((n) => _buildNotificationTile(context, ref, n)),
                ],
                if (yesterdayNotifications.isNotEmpty) ...[
                  _buildSectionHeader(context, 'Yesterday'),
                  ...yesterdayNotifications.map((n) => _buildNotificationTile(context, ref, n)),
                ],
                if (thisWeekNotifications.isNotEmpty) ...[
                  _buildSectionHeader(context, 'This Week'),
                  ...thisWeekNotifications.map((n) => _buildNotificationTile(context, ref, n)),
                ],
                if (olderNotifications.isNotEmpty) ...[
                  _buildSectionHeader(context, 'Older'),
                  ...olderNotifications.map((n) => _buildNotificationTile(context, ref, n)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    WidgetRef ref,
    AppNotification notification,
  ) {
    final icon = _getNotificationIcon(notification.type);
    final color = _getNotificationColor(notification.type, context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              timeago.format(notification.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () async {
          if (!notification.isRead) {
            await ref.read(markAsReadProvider(notification.id).future);
          }
        },
      ),
    );
  }
}

