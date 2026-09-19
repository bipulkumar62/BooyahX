import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/constants/app_routes.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

/// BooyahX — Bottom Navigation Shell
///
/// Wraps tabbed routes with a persistent 5-tab bottom navigation bar.
/// Active tab is highlighted with primary color.
class BottomNavScaffold extends StatelessWidget {
  final Widget child;

  const BottomNavScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.homePath)) return 0;
    if (location.startsWith(AppRoutes.myMatchesPath)) return 1;
    if (location.startsWith(AppRoutes.leaderboardPath)) return 2;
    if (location.startsWith(AppRoutes.notificationsPath)) return 3;
    if (location.startsWith(AppRoutes.profilePath)) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.homePath);
      case 1:
        context.go(AppRoutes.myMatchesPath);
      case 2:
        context.go(AppRoutes.leaderboardPath);
      case 3:
        context.go(AppRoutes.notificationsPath);
      case 4:
        context.go(AppRoutes.profilePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: AppDimensions.bottomNavHeight,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.local_fire_department_outlined,
                  activeIcon: Icons.local_fire_department,
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () => _onTap(context, 0),
                ),
                _NavItem(
                  icon: Icons.sports_esports_outlined,
                  activeIcon: Icons.sports_esports,
                  label: 'Matches',
                  isSelected: currentIndex == 1,
                  onTap: () => _onTap(context, 1),
                ),
                _NavItem(
                  icon: Icons.leaderboard_outlined,
                  activeIcon: Icons.leaderboard,
                  label: 'Rank',
                  isSelected: currentIndex == 2,
                  onTap: () => _onTap(context, 2),
                ),
                _NavItem(
                  icon: Icons.notifications_outlined,
                  activeIcon: Icons.notifications,
                  label: 'Alerts',
                  isSelected: currentIndex == 3,
                  onTap: () => _onTap(context, 3),
                ),
                _NavItem(
                  icon: Icons.account_circle_outlined,
                  activeIcon: Icons.account_circle,
                  label: 'Profile',
                  isSelected: currentIndex == 4,
                  onTap: () => _onTap(context, 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.textMuted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: AppDimensions.iconMd,
              color: color,
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
