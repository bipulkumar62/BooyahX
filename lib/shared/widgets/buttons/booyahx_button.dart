import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

enum BooyahXButtonStyle { primary, secondary, outlined, destructive, cyan }

class BooyahXButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BooyahXButtonStyle style;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final double? height;

  const BooyahXButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = BooyahXButtonStyle.primary,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? AppDimensions.buttonHeightLg;
    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: buttonHeight,
      child: switch (style) {
        BooyahXButtonStyle.primary => _buildPrimary(isEnabled, buttonHeight),
        BooyahXButtonStyle.secondary => _buildSecondary(isEnabled, buttonHeight),
        BooyahXButtonStyle.outlined => _buildOutlined(isEnabled, buttonHeight),
        BooyahXButtonStyle.destructive => _buildDestructive(isEnabled, buttonHeight),
        BooyahXButtonStyle.cyan => _buildCyan(isEnabled, buttonHeight),
      },
    );
  }

  Widget _buildPrimary(bool isEnabled, double h) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
        disabledForegroundColor: AppColors.onPrimary.withValues(alpha: 0.7),
        minimumSize: Size(isExpanded ? double.infinity : 0, h),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        elevation: isEnabled ? 2 : 0,
      ),
      child: _buildChild(),
    );
  }

  Widget _buildSecondary(bool isEnabled, double h) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.surfaceContainerHigh,
        foregroundColor: AppColors.onSurface,
        disabledBackgroundColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
        disabledForegroundColor: AppColors.onSurface.withValues(alpha: 0.5),
        minimumSize: Size(isExpanded ? double.infinity : 0, h),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          side: const BorderSide(color: AppColors.outline),
        ),
        elevation: 0,
      ),
      child: _buildChild(),
    );
  }

  Widget _buildOutlined(bool isEnabled, double h) {
    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onSurface,
        disabledForegroundColor: AppColors.onSurface.withValues(alpha: 0.4),
        minimumSize: Size(isExpanded ? double.infinity : 0, h),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        side: BorderSide(
          color: isEnabled ? AppColors.outline : AppColors.outline.withValues(alpha: 0.5),
        ),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildDestructive(bool isEnabled, double h) {
    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        disabledForegroundColor: AppColors.error.withValues(alpha: 0.4),
        minimumSize: Size(isExpanded ? double.infinity : 0, h),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        side: BorderSide(
          color: isEnabled ? AppColors.error.withValues(alpha: 0.4) : AppColors.error.withValues(alpha: 0.2),
        ),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildCyan(bool isEnabled, double h) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.cyanAccent,
        foregroundColor: AppColors.onSurface,
        disabledBackgroundColor: AppColors.cyanAccent.withValues(alpha: 0.5),
        disabledForegroundColor: AppColors.onSurface.withValues(alpha: 0.5),
        minimumSize: Size(isExpanded ? double.infinity : 0, h),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        elevation: isEnabled ? 2 : 0,
      ),
      child: _buildChild(isDark: true),
    );
  }

  Widget _buildChild({bool isDark = false}) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isDark ? AppColors.onSurface : AppColors.onPrimary,
          ),
        ),
      );
    }

    final textStyle = AppTextStyles.buttonLg.copyWith(
      color: isDark ? AppColors.onSurface : AppColors.onPrimary,
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconSm),
          const SizedBox(width: AppDimensions.spaceSm),
          Text(label.toUpperCase(), style: textStyle),
        ],
      );
    }

    return Text(label.toUpperCase(), style: textStyle);
  }
}
