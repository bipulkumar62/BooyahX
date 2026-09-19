import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

class BooyahXAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showWallet;
  final int walletBalance;
  final bool showNotifications;
  final int notificationCount;
  final bool showProfileAvatar;

  const BooyahXAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.showWallet = true,
    this.walletBalance = 0,
    this.showNotifications = false,
    this.notificationCount = 0,
    this.showProfileAvatar = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.topHeaderHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.topHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.gutter),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (showBackButton) ...[
              _BackButton(onPressed: onBackPressed ?? () => Navigator.of(context).pop()),
              const SizedBox(width: AppDimensions.spaceSm),
            ],
            if (titleWidget != null)
              titleWidget!
            else if (title != null)
              Expanded(
                child: Text(
                  title!,
                  style: AppTextStyles.titleLg,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              const _BooyahXLogo(),
            const Spacer(),
            if (actions != null) ...actions!, // ignore: use_null_aware_elements
            if (showWallet) ...[
              _WalletPill(balance: walletBalance),
              const SizedBox(width: AppDimensions.spaceSm),
            ],
            if (showNotifications) ...[
              _NotificationBell(count: notificationCount),
              const SizedBox(width: AppDimensions.spaceSm),
            ],
            if (showProfileAvatar) const _ProfileAvatar(),
          ],
        ),
      ),
    );
  }
}

class _BooyahXLogo extends StatelessWidget {
  const _BooyahXLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppDimensions.avatarMd,
          height: AppDimensions.avatarMd,
          decoration: BoxDecoration(
            color: AppColors.primaryFixed,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.primaryFixed, width: 1),
          ),
          child: const Icon(
            Icons.local_fire_department,
            color: AppColors.primary,
            size: AppDimensions.iconMd,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSm),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'BOOYAH',
                    style: AppTextStyles.headlineMd.copyWith(
                      color: AppColors.onSurface,
                      letterSpacing: 0.04,
                    ),
                  ),
                  TextSpan(
                    text: 'X',
                    style: AppTextStyles.headlineMd.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 0.04,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'TOURNAMENT HUB',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 0.1,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _BackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: AppDimensions.avatarLg,
        height: AppDimensions.avatarLg,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: const Icon(
          Icons.arrow_back,
          size: AppDimensions.iconSm,
          color: AppColors.onSurface,
        ),
      ),
    );
  }
}

class _WalletPill extends StatelessWidget {
  final int balance;
  const _WalletPill({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(
        left: AppDimensions.spaceMd,
        right: AppDimensions.spaceXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '₹',
            style: AppTextStyles.labelNumeric.copyWith(
              color: AppColors.tertiary,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            '$balance',
            style: AppTextStyles.labelNumeric.copyWith(
              color: AppColors.onSurface,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              size: 16,
              color: AppColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final int count;
  const _NotificationBell({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: AppDimensions.avatarLg,
          height: AppDimensions.avatarLg,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            size: AppDimensions.iconSm,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        if (count > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: AppDimensions.badgeDotSize,
              height: AppDimensions.badgeDotSize,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.avatarSm,
      height: AppDimensions.avatarSm,
      decoration: const BoxDecoration(
        color: AppColors.onSurface,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        size: AppDimensions.iconSm,
        color: AppColors.surface,
      ),
    );
  }
}
