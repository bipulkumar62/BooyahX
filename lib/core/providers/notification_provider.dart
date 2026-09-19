import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booyahx/core/models/notification.dart';
import 'package:booyahx/core/data/mock_notifications.dart';

/// BooyahX — Notification State
///
/// Manages notification data using Riverpod.
/// This is a local-only state abstraction. When the backend is added,
/// this provider will be replaced with an async provider that fetches
/// from the API, but the UI consumers won't need to change.

enum NotificationStatus { loading, normal, empty, error }

enum NotificationFilter { all, unread }

class NotificationData {
  final List<BooyahXNotification> notifications;
  final NotificationStatus status;
  final String? errorMessage;

  const NotificationData({
    this.notifications = const [],
    this.status = NotificationStatus.loading,
    this.errorMessage,
  });

  NotificationData copyWith({
    List<BooyahXNotification>? notifications,
    NotificationStatus? status,
    String? errorMessage,
  }) {
    return NotificationData(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationData> {
  NotificationFilter _filter = NotificationFilter.all;

  NotificationNotifier() : super(const NotificationData());

  NotificationFilter get filter => _filter;

  /// Unread count across all notifications (not affected by filter).
  int get unreadCount =>
      state.notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications() async {
    state = state.copyWith(status: NotificationStatus.loading);

    try {
      final notifications = await MockNotificationData.fetchWithDelay();

      if (notifications.isEmpty) {
        state = state.copyWith(
          notifications: [],
          status: NotificationStatus.empty,
        );
      } else {
        state = state.copyWith(
          notifications: notifications,
          status: NotificationStatus.normal,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> changeFilter(NotificationFilter filter) async {
    if (filter == _filter) return;
    _filter = filter;
    // No need to reload; just re-filter the existing list
    state = state.copyWith();
  }

  /// Mark a single notification as read.
  void markAsRead(String notificationId) {
    final updated = state.notifications.map((n) {
      if (n.id == notificationId) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    state = state.copyWith(notifications: updated);
  }

  /// Mark all notifications as read.
  void markAllAsRead() {
    final updated = state.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();

    state = state.copyWith(notifications: updated);
  }

  /// Filtered list based on the current filter.
  List<BooyahXNotification> get filteredNotifications {
    switch (_filter) {
      case NotificationFilter.all:
        return state.notifications;
      case NotificationFilter.unread:
        return state.notifications.where((n) => !n.isRead).toList();
    }
  }

  Future<void> retry() async {
    await loadNotifications();
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationNotifier, NotificationData>(
  (ref) => NotificationNotifier(),
);

/// Convenience provider for unread count.
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifier = ref.read(notificationsProvider.notifier);
  return notifier.unreadCount;
});
