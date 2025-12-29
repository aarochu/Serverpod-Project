import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';
import 'dart:async';

/// Provider for notification service instance
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  
  // Start polling when provider is created
  service.startPolling();
  
  // Cleanup when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Provider for notifications list
final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.notificationsStream;
});

/// Provider for unread notification count
final unreadCountProvider = Provider<int>((ref) {
  final notificationsAsync = ref.watch(notificationsProvider);
  
  return notificationsAsync.when(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Provider for marking notification as read
final markAsReadProvider = FutureProvider.family<void, int>((ref, notificationId) async {
  final service = ref.watch(notificationServiceProvider);
  await service.markAsRead(notificationId);
  // Invalidate notifications to refresh
  ref.invalidate(notificationsProvider);
});

