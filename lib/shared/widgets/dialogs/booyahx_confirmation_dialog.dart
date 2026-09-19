import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

class BooyahXConfirmationDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String message;
  final String? details;
  final String confirmLabel;
  final String? cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const BooyahXConfirmationDialog({
    super.key,
    required this.icon,
    this.iconColor = AppColors.success,
    this.iconBgColor = AppColors.successLight,
    required this.title,
    required this.message,
    this.details,
    required this.confirmLabel,
    this.cancelLabel,
    required this.onConfirm,
    this.onCancel,
  });

  static Future<void> show({
    required BuildContext context,
    required IconData icon,
    Color? iconColor,
    Color? iconBgColor,
    required String title,
    required String message,
    String? details,
    required String confirmLabel,
    String? cancelLabel,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog(
      context: context,
      builder: (_) => BooyahXConfirmationDialog(
        icon: icon,
        iconColor: iconColor ?? AppColors.success,
        iconBgColor: iconBgColor ?? AppColors.successLight,
        title: title,
        message: message,
        details: details,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: iconColor),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            Text(
              title,
              style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              message,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: AppDimensions.spaceMd),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  details!,
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.spaceXl),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeightLg,
              child: ElevatedButton(
                onPressed: () {
                  onConfirm();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.onSurface,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  ),
                ),
                child: Text(confirmLabel.toUpperCase(), style: AppTextStyles.buttonLg),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
