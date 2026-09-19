import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';

class BooyahXDivider extends StatelessWidget {
  final double? height;
  final Color? color;
  final double? thickness;
  final EdgeInsetsGeometry? margin;

  const BooyahXDivider({
    super.key,
    this.height,
    this.color,
    this.thickness,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Divider(
        height: height ?? 1,
        thickness: thickness ?? 1,
        color: color ?? AppColors.border,
      ),
    );
  }
}
