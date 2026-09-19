import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

enum BadgeVariant {
  upcoming,
  live,
  completed,
  locked,
  registered,
  success,
  pending,
  failed,
  closingSoon,
  almostFull,
  open,
  info,
}

class BooyahXStatusBadge extends StatelessWidget {
  final BadgeVariant variant;
  final String label;
  final bool showDot;
  final bool animate;
  final double? fontSize;

  const BooyahXStatusBadge({
    super.key,
    required this.variant,
    required this.label,
    this.showDot = false,
    this.animate = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSm,
        vertical: AppDimensions.spaceXs,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: config.borderColor, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot || variant == BadgeVariant.live) ...[
            if (animate)
              _AnimatedDot(color: config.dotColor)
            else
              Container(
                width: AppDimensions.statusDotSize,
                height: AppDimensions.statusDotSize,
                decoration: BoxDecoration(
                  color: config.dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            const SizedBox(width: AppDimensions.spaceXs),
          ],
          Text(
            label.toUpperCase(),
            style: (AppTextStyles.labelCaps).copyWith(
              color: config.textColor,
              fontSize: fontSize ?? 10,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _getConfig() {
    return switch (variant) {
      BadgeVariant.upcoming => _BadgeConfig(
        backgroundColor: AppColors.openBlueBg,
        textColor: AppColors.primaryDark,
        borderColor: AppColors.primary.withValues(alpha: 0.3),
        dotColor: AppColors.primary,
      ),
      BadgeVariant.live => _BadgeConfig(
        backgroundColor: AppColors.liveRedBg,
        textColor: AppColors.liveRed,
        borderColor: AppColors.liveRed.withValues(alpha: 0.3),
        dotColor: AppColors.liveRed,
      ),
      BadgeVariant.completed => _BadgeConfig(
        backgroundColor: AppColors.surfaceContainerHigh,
        textColor: AppColors.onSurfaceVariant,
        borderColor: AppColors.outline,
        dotColor: AppColors.textMuted,
      ),
      BadgeVariant.locked => _BadgeConfig(
        backgroundColor: AppColors.surfaceContainerHigh,
        textColor: AppColors.primary,
        borderColor: AppColors.primary.withValues(alpha: 0.3),
        dotColor: AppColors.primary,
      ),
      BadgeVariant.registered => _BadgeConfig(
        backgroundColor: AppColors.registeredGreenBg,
        textColor: AppColors.registeredGreen,
        borderColor: AppColors.registeredGreen.withValues(alpha: 0.3),
        dotColor: AppColors.registeredGreen,
      ),
      BadgeVariant.success => _BadgeConfig(
        backgroundColor: AppColors.successLight,
        textColor: AppColors.successDark,
        borderColor: AppColors.success.withValues(alpha: 0.3),
        dotColor: AppColors.success,
      ),
      BadgeVariant.pending => _BadgeConfig(
        backgroundColor: AppColors.warningLight,
        textColor: AppColors.warningDark,
        borderColor: AppColors.warning.withValues(alpha: 0.3),
        dotColor: AppColors.warning,
      ),
      BadgeVariant.failed => _BadgeConfig(
        backgroundColor: AppColors.errorLight,
        textColor: AppColors.errorDark,
        borderColor: AppColors.error.withValues(alpha: 0.3),
        dotColor: AppColors.error,
      ),
      BadgeVariant.closingSoon => _BadgeConfig(
        backgroundColor: AppColors.closingSoonBg,
        textColor: AppColors.closingSoon,
        borderColor: AppColors.closingSoon.withValues(alpha: 0.3),
        dotColor: AppColors.closingSoon,
      ),
      BadgeVariant.almostFull => _BadgeConfig(
        backgroundColor: AppColors.almostFullBg,
        textColor: AppColors.warningDark,
        borderColor: AppColors.almostFull.withValues(alpha: 0.3),
        dotColor: AppColors.almostFull,
      ),
      BadgeVariant.open => _BadgeConfig(
        backgroundColor: AppColors.openBlueBg,
        textColor: AppColors.primary,
        borderColor: AppColors.primary.withValues(alpha: 0.3),
        dotColor: AppColors.primary,
      ),
      BadgeVariant.info => _BadgeConfig(
        backgroundColor: AppColors.secondaryContainer,
        textColor: AppColors.secondaryDark,
        borderColor: AppColors.secondary.withValues(alpha: 0.3),
        dotColor: AppColors.secondary,
      ),
    };
  }
}

class _BadgeConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color dotColor;

  const _BadgeConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.dotColor,
  });
}

class _AnimatedDot extends StatefulWidget {
  final Color color;
  const _AnimatedDot({required this.color});

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.5 + (_controller.value * 0.5),
          child: Container(
            width: AppDimensions.statusDotSize,
            height: AppDimensions.statusDotSize,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
