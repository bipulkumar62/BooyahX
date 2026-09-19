import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

enum BooyahXCardStyle { normal, elevated, outlined }

class BooyahXCard extends StatelessWidget {
  final Widget child;
  final BooyahXCardStyle style;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;

  const BooyahXCard({
    super.key,
    required this.child,
    this.style = BooyahXCardStyle.normal,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppDimensions.radiusLg;
    final bgColor = backgroundColor ?? AppColors.surface;
    final borderCol = borderColor ?? AppColors.border;
    final internalPadding = padding ?? const EdgeInsets.all(AppDimensions.cardPaddingLg);

    Widget card = Container(
      width: double.infinity,
      padding: internalPadding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: style == BooyahXCardStyle.outlined
            ? Border.all(color: borderCol, width: AppDimensions.cardBorderWidth)
            : Border.all(color: borderCol, width: AppDimensions.cardBorderWidth),
        boxShadow: style == BooyahXCardStyle.elevated
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    return card;
  }
}
