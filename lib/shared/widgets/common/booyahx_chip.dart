import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

class BooyahXChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? selectedBackgroundColor;
  final Color? selectedTextColor;
  final Color? unselectedBackgroundColor;
  final Color? unselectedTextColor;

  const BooyahXChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.selectedBackgroundColor,
    this.selectedTextColor,
    this.unselectedBackgroundColor,
    this.unselectedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? (selectedBackgroundColor ?? AppColors.onSurface)
        : (unselectedBackgroundColor ?? AppColors.surface);
    final txtColor = isSelected
        ? (selectedTextColor ?? AppColors.surface)
        : (unselectedTextColor ?? AppColors.onSurfaceVariant);
    final borderCol = isSelected
        ? AppColors.onSurface
        : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceSm,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: borderCol, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppDimensions.iconXs, color: txtColor),
              const SizedBox(width: AppDimensions.spaceXs),
            ],
            Text(
              label.toUpperCase(),
              style: AppTextStyles.labelCaps.copyWith(
                color: txtColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
