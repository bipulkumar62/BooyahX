import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/shared/widgets/common/booyahx_avatar.dart';

/// BooyahX — Leaderboard Player Row
///
/// Displays a single player's ranking information including rank, avatar,
/// name, matches, kills, points, and winnings. Used in the leaderboard list.
class BooyahXLeaderboardRow extends StatelessWidget {
  final int rank;
  final String inGameName;
  final String? avatarUrl;
  final int matches;
  final int kills;
  final int points;
  final String? winnings;
  final bool isCurrentUser;
  final VoidCallback? onTap;

  const BooyahXLeaderboardRow({
    super.key,
    required this.rank,
    required this.inGameName,
    this.avatarUrl,
    required this.matches,
    required this.kills,
    required this.points,
    this.winnings,
    this.isCurrentUser = false,
    this.onTap,
  });

  Color get _rankColor {
    if (rank == 1) return AppColors.tertiary; // Gold
    if (rank == 2) return AppColors.textMuted; // Silver
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    return AppColors.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.cardPaddingLg,
          vertical: AppDimensions.spaceMd,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColors.primaryFixed.withValues(alpha: 0.3) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: isCurrentUser
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.border,
            width: isCurrentUser ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 32,
              child: Text(
                '$rank',
                style: AppTextStyles.labelNumeric.copyWith(
                  color: _rankColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMd),

            // Avatar
            BooyahXAvatar(
              imageUrl: avatarUrl,
              initials: inGameName.isNotEmpty ? inGameName[0].toUpperCase() : '?',
              size: AvatarSize.sm,
              borderColor: _rankColor,
            ),
            const SizedBox(width: AppDimensions.spaceMd),

            // Name + Matches
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inGameName,
                    style: AppTextStyles.titleSm.copyWith(
                      color: isCurrentUser ? AppColors.primary : AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$matches matches',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Kills
            _StatColumn(label: 'Kills', value: '$kills'),
            const SizedBox(width: AppDimensions.spaceLg),

            // Points
            _StatColumn(
              label: 'Points',
              value: _formatPoints(points),
              valueColor: AppColors.primary,
              isBold: true,
            ),
            const SizedBox(width: AppDimensions.spaceMd),

            // Winnings
            if (winnings != null)
              _StatColumn(
                label: 'Won',
                value: winnings!,
                valueColor: AppColors.tertiary,
              ),
          ],
        ),
      ),
    );
  }

  String _formatPoints(int points) {
    if (points >= 1000) {
      return '${(points / 1000).toStringAsFixed(1)}k';
    }
    return '$points';
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _StatColumn({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMuted,
            fontSize: 9,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.labelNumeric.copyWith(
            color: valueColor ?? AppColors.onSurface,
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
