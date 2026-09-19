import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/core/constants/app_routes.dart';
import 'package:booyahx/core/models/notification.dart'
    as model;
import 'package:booyahx/core/providers/notification_provider.dart';
import 'package:booyahx/core/utils/time_formatter.dart';
import 'package:booyahx/shared/widgets/widgets.dart';

/// BooyahX — Notifications Screen
///
/// Displays all notifications with read/unread state, filter tabs,
/// mark-as-read functionality, and tap navigation to related screens.
/// Uses mock data during development.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications on first render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationData = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);
    final filtered = notifier.filteredNotifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _NotificationsAppBar(
        unreadCount: notifier.unreadCount,
        onMarkAllRead: () => notifier.markAllAsRead(),
      ),
      body: _buildBody(notificationData, filtered),
    );
  }

  Widget _buildBody(
    NotificationData data,
    List<model.BooyahXNotification> filtered,
  ) {
    return switch (data.status) {
      NotificationStatus.loading => _buildLoadingState(),
      NotificationStatus.normal => _buildNormalState(data, filtered),
      NotificationStatus.empty => _buildEmptyState(),
      NotificationStatus.error => _buildErrorState(data.errorMessage),
    };
  }

  // ── Loading State ──

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.gutter,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.spaceMd),
          // Skeleton filter chips
          Row(
            children: List.generate(
              2,
              (i) => Padding(
                padding: const EdgeInsets.only(right: AppDimensions.spaceSm),
                child: BooyahXLoadingSkeleton(
                  width: i == 0 ? 72 : 80,
                  height: 36,
                  borderRadius: AppDimensions.radiusFull,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          // Skeleton notification rows
          ...List.generate(
            6,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.spaceSm),
              child: BooyahXLoadingSkeleton(
                width: double.infinity,
                height: 88,
                borderRadius: AppDimensions.radiusLg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Normal State ──

  Widget _buildNormalState(
    NotificationData data,
    List<model.BooyahXNotification> filtered,
  ) {
    final notifier = ref.read(notificationsProvider.notifier);

    return Column(
      children: [
        // ── Filter Tabs ──
        _FilterBar(
          selectedFilter: notifier.filter,
          onFilterChanged: (f) =>
              ref.read(notificationsProvider.notifier).changeFilter(f),
          unreadCount: notifier.unreadCount,
        ),

        // ── Notification List ──
        Expanded(
          child: filtered.isEmpty
              ? _buildFilterEmptyState(notifier.filter)
              : RefreshIndicator(
                  onRefresh: () =>
                      ref.read(notificationsProvider.notifier).retry(),
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.gutter,
                      vertical: AppDimensions.spaceSm,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppDimensions.spaceSm),
                    itemBuilder: (context, index) {
                      final notification = filtered[index];
                      return _NotificationCard(
                        notification: notification,
                        onTap: () => _handleNotificationTap(notification),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  // ── Filter Empty State ──

  Widget _buildFilterEmptyState(NotificationFilter filter) {
    if (filter == NotificationFilter.unread) {
      return BooyahXEmptyState(
        icon: Icons.mark_email_read_outlined,
        title: 'All caught up!',
        subtitle: 'No unread notifications. You\'re up to date.',
      );
    }
    return BooyahXEmptyState(
      icon: Icons.notifications_none,
      title: 'No notifications',
      subtitle: 'You\'ll see tournament updates, match results, and more here.',
    );
  }

  // ── Empty State ──

  Widget _buildEmptyState() {
    return BooyahXEmptyState(
      icon: Icons.notifications_none,
      title: 'No notifications yet',
      subtitle:
          'When you join tournaments or play matches, updates will appear here.',
      actionLabel: 'Refresh',
      onAction: () =>
          ref.read(notificationsProvider.notifier).retry(),
    );
  }

  // ── Error State ──

  Widget _buildErrorState(String? message) {
    return BooyahXErrorState(
      title: 'Unable to load notifications',
      message:
          message ?? 'Something went wrong. Please check your connection and try again.',
      actionLabel: 'Try Again',
      onAction: () =>
          ref.read(notificationsProvider.notifier).retry(),
    );
  }

  // ── Tap Handler ──

  void _handleNotificationTap(model.BooyahXNotification notification) {
    // Mark as read
    ref.read(notificationsProvider.notifier).markAsRead(notification.id);

    // Navigate based on type
    if (notification.relatedTournamentId != null) {
      context.push(
        AppRoutes.tournamentDetailPath.replaceAll(':id', notification.relatedTournamentId!),
      );
    } else if (notification.relatedMatchId != null) {
      context.push(
        AppRoutes.matchDetailPath.replaceAll(':id', notification.relatedMatchId!),
      );
    }
    // System/general notifications stay on this screen
  }
}

// ══════════════════════════════════════════════════════════
// Private Sub-Widgets
// ══════════════════════════════════════════════════════════

/// Custom app bar for the notifications screen.
class _NotificationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;

  const _NotificationsAppBar({
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(AppDimensions.topHeaderHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.topHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.gutter),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Icon
            Container(
              width: AppDimensions.avatarMd,
              height: AppDimensions.avatarMd,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: const Icon(
                Icons.notifications,
                color: AppColors.primary,
                size: AppDimensions.iconMd,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            // Title
            Text(
              'NOTIFICATIONS',
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.onSurface,
                letterSpacing: 0.04,
              ),
            ),
            const Spacer(),
            // Mark all as read
            if (unreadCount > 0)
              GestureDetector(
                onTap: onMarkAllRead,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceMd,
                    vertical: AppDimensions.spaceSm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed.withValues(alpha: 0.3),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    'Mark all read',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal filter bar for notification tabs.
class _FilterBar extends StatelessWidget {
  final NotificationFilter selectedFilter;
  final ValueChanged<NotificationFilter> onFilterChanged;
  final int unreadCount;

  const _FilterBar({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.gutter,
          vertical: AppDimensions.spaceSm,
        ),
        children: [
          BooyahXChip(
            label: 'ALL',
            icon: Icons.notifications,
            isSelected: selectedFilter == NotificationFilter.all,
            selectedBackgroundColor: AppColors.onSurface,
            selectedTextColor: AppColors.surface,
            unselectedBackgroundColor: AppColors.surface,
            unselectedTextColor: AppColors.onSurfaceVariant,
            onTap: () => onFilterChanged(NotificationFilter.all),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          BooyahXChip(
            label: unreadCount > 0 ? 'UNREAD ($unreadCount)' : 'UNREAD',
            icon: Icons.mark_email_unread,
            isSelected: selectedFilter == NotificationFilter.unread,
            selectedBackgroundColor: AppColors.onSurface,
            selectedTextColor: AppColors.surface,
            unselectedBackgroundColor: AppColors.surface,
            unselectedTextColor: AppColors.onSurfaceVariant,
            onTap: () => onFilterChanged(NotificationFilter.unread),
          ),
        ],
      ),
    );
  }
}

/// A single notification card.
class _NotificationCard extends StatelessWidget {
  final model.BooyahXNotification notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  /// Map model notification type to widget NotificationType.
  NotificationType get _widgetType => switch (notification.type) {
        model.BooyahXNotificationType.tournament =>
          NotificationType.tournament,
        model.BooyahXNotificationType.match => NotificationType.match,
        model.BooyahXNotificationType.room => NotificationType.room,
        model.BooyahXNotificationType.result => NotificationType.result,
        model.BooyahXNotificationType.reward => NotificationType.reward,
        model.BooyahXNotificationType.system => NotificationType.system,
      };

  @override
  Widget build(BuildContext context) {
    return BooyahXNotificationItem(
      title: notification.title,
      message: notification.message,
      timeAgo: TimeFormatter.formatRelative(notification.timestamp),
      type: _widgetType,
      isRead: notification.isRead,
      onTap: onTap,
    );
  }
}
