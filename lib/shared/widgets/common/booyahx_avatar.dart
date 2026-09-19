import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

enum AvatarSize { xs, sm, md, lg, xl }

class BooyahXAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final AvatarSize size;
  final Color? backgroundColor;
  final Color? borderColor;
  final IconData? icon;

  const BooyahXAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = AvatarSize.md,
    this.backgroundColor,
    this.borderColor,
    this.icon,
  });

  double get _dimension => switch (size) {
    AvatarSize.xs => AppDimensions.avatarXs,
    AvatarSize.sm => AppDimensions.avatarSm,
    AvatarSize.md => AppDimensions.avatarMd,
    AvatarSize.lg => AppDimensions.avatarLg,
    AvatarSize.xl => AppDimensions.avatarXl,
  };

  double get _fontSize => switch (size) {
    AvatarSize.xs => 9,
    AvatarSize.sm => 11,
    AvatarSize.md => 12,
    AvatarSize.lg => 14,
    AvatarSize.xl => 20,
  };

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.onSurface;
    final borderCol = borderColor;

    return Container(
      width: _dimension,
      height: _dimension,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: borderCol != null
            ? Border.all(color: borderCol, width: 1.5)
            : null,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl != null
          ? null
          : Center(
              child: icon != null
                  ? Icon(icon, size: _dimension * 0.5, color: AppColors.surface)
                  : Text(
                      initials ?? '?',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w700,
                        fontSize: _fontSize,
                      ),
                    ),
            ),
    );
  }
}
