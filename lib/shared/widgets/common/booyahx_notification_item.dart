import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

enum NotificationType {
  match,
  system,
  wallet,
  achievement,
  tournament,
  room,
  result,
  reward,
}

class BooyahXNotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String? timeAgo;
  final NotificationType type;
  final bool isRead;
  final VoidCallback? onTap;

  const BooyahXNotificationItem({
    super.key,
    required this.title,
    required this.message,
    this.timeAgo,
    this.type = NotificationType.system,
    this.isRead = false,
    this.onTap,
  });

  IconData get _icon => switch (type) {
    NotificationType.match => Icons.sports_esports,
    NotificationType.system => Icons.info_outline,
    NotificationType.wallet => Icons.account_balance_wallet,
    NotificationType.achievement => Icons.emoji_events,
    NotificationType.tournament => Icons.emoji_events,
    NotificationType.room => Icons.meeting_room,
    NotificationType.result => Icons.leaderboard,
    NotificationType.reward => Icons.account_balance_wallet,
  };

  Color get _iconColor => switch (type) {
    NotificationType.match => AppColors.primary,
    NotificationType.system => AppColors.textMuted,
    NotificationType.wallet => AppColors.tertiary,
    NotificationType.achievement => AppColors.warning,
    NotificationType.tournament => AppColors.secondary,
    NotificationType.room => AppColors.primary,
    NotificationType.result => AppColors.tertiary,
    NotificationType.reward => AppColors.success,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
        decoration: BoxDecoration(
          color: isRead ? AppColors.surface : AppColors.primaryFixed.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: isRead ? AppColors.border : AppColors.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Icon(_icon, size: 20, color: _iconColor),
            ),
            const SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSm.copyWith(color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (timeAgo != null)
              Text(
                timeAgo!,
                style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
              ),
          ],
        ),
      ),
    );
  }
}
