import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';

class BooyahXSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? badgeText;

  const BooyahXSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitle != null)
              Text(
                subtitle!.toUpperCase(),
                style: AppTextStyles.labelCaps.copyWith(
                  color: AppColors.primary,
                  fontSize: 10,
                ),
              ),
            Row(
              children: [
                Text(title, style: AppTextStyles.headlineMd),
                if (badgeText != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const Spacer(),
        if (trailing != null) trailing!, // ignore: use_null_aware_elements
      ],
    );
  }
}
