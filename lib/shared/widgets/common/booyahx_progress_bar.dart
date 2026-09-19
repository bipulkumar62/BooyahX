import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

class BooyahXProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final BorderRadius? borderRadius;

  const BooyahXProgressBar({
    super.key,
    required this.value,
    this.height = AppDimensions.progressHeightSm,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: clampedValue,
        minHeight: height,
        backgroundColor: backgroundColor ?? AppColors.surfaceContainerHigh,
        valueColor: AlwaysStoppedAnimation<Color>(
          progressColor ?? AppColors.primary,
        ),
      ),
    );
  }
}
