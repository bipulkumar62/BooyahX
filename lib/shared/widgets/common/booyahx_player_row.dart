import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/shared/widgets/common/booyahx_avatar.dart';

class BooyahXPlayerRow extends StatelessWidget {
  final int? rank;
  final String name;
  final String? subtitle;
  final String? slotLabel;
  final String? avatarUrl;

  const BooyahXPlayerRow({
    super.key,
    this.rank,
    required this.name,
    this.subtitle,
    this.slotLabel,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          BooyahXAvatar(
            imageUrl: avatarUrl,
            initials: name.isNotEmpty ? name[0].toUpperCase() : '?',
            size: AvatarSize.sm,
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
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
          if (slotLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Text(
                slotLabel!,
                style: AppTextStyles.labelCaps.copyWith(
                  color: AppColors.primary,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
