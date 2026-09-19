import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

class BooyahXPrizeRow extends StatelessWidget {
  final int? rank;
  final String? rankLabel;
  final String title;
  final String? subtitle;
  final String amount;
  final String? percentage;
  final Color? rankBgColor;
  final Color? rankTextColor;
  final IconData? rankIcon;
  final bool isHighlighted;

  const BooyahXPrizeRow({
    super.key,
    this.rank,
    this.rankLabel,
    required this.title,
    this.subtitle,
    required this.amount,
    this.percentage,
    this.rankBgColor,
    this.rankTextColor,
    this.rankIcon,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isHighlighted ? AppColors.tertiary.withValues(alpha: 0.4) : AppColors.border,
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank indicator
          if (rank != null || rankIcon != null)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: rankBgColor ?? AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                  color: (rankBgColor ?? AppColors.surfaceContainerHigh).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (rankIcon != null)
                    Icon(rankIcon!, size: 18, color: rankTextColor ?? AppColors.onSurfaceVariant)
                  else
                    Text(
                      rankLabel ?? '#$rank',
                      style: AppTextStyles.labelCaps.copyWith(
                        color: rankTextColor ?? AppColors.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(width: AppDimensions.spaceMd),
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSm.copyWith(color: AppColors.onSurface),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                  ),
              ],
            ),
          ),
          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.labelNumeric.copyWith(color: AppColors.onSurface),
              ),
              if (percentage != null)
                Text(
                  percentage!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
