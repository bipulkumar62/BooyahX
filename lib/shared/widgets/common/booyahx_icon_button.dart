import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

class BooyahXIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double? size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final bool isCircle;

  const BooyahXIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.isCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    final btnSize = size ?? AppDimensions.avatarLg;
    final bg = backgroundColor ?? AppColors.surfaceContainerHigh;
    final ic = iconColor ?? AppColors.onSurfaceVariant;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: btnSize,
        height: btnSize,
        decoration: BoxDecoration(
          color: bg,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(AppDimensions.radiusMd),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : null,
        ),
        child: Icon(icon, size: iconSize ?? AppDimensions.iconSm, color: ic),
      ),
    );
  }
}
