import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/core/constants/app_routes.dart';
import 'package:booyahx/core/models/player_stats.dart';
import 'package:booyahx/core/data/mock_player_stats.dart';
import 'package:booyahx/core/providers/player_profile_provider.dart';
import 'package:booyahx/core/providers/profile_settings_provider.dart';
import 'package:booyahx/shared/widgets/widgets.dart';

/// BooyahX — Profile & Settings Screen
///
/// Displays player profile header, statistics, navigation options,
/// and local settings. Uses mock data during development.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final settings = ref.watch(profileSettingsProvider);
    final stats = MockPlayerStats.currentPlayer;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh — data is local
          await Future.delayed(const Duration(milliseconds: 400));
        },
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // ── Profile Header ──
            SliverToBoxAdapter(
              child: _ProfileHeader(
                name: profile?.name ?? 'Player',
                ign: profile?.inGameName ?? 'Player',
                uid: profile?.uid ?? '000000',
                onEdit: () => _showEditProfile(context, ref),
              ),
            ),

            // ── Statistics ──
            SliverToBoxAdapter(
              child: _StatsSection(stats: stats),
            ),

            // ── Menu Options ──
            SliverToBoxAdapter(
              child: _MenuSection(
                onMyMatches: () => context.go(AppRoutes.myMatchesPath),
                onLeaderboard: () => context.go(AppRoutes.leaderboardPath),
                onNotifications: () => context.go(AppRoutes.notificationsPath),
                onWallet: () => context.push(AppRoutes.walletPath),
              ),
            ),

            // ── Settings ──
            SliverToBoxAdapter(
              child: _SettingsSection(
                settings: settings,
                onToggleNotifications: () =>
                    ref.read(profileSettingsProvider.notifier).toggleNotifications(),
                onToggleSound: () =>
                    ref.read(profileSettingsProvider.notifier).toggleSound(),
              ),
            ),

            // ── About ──
            const SliverToBoxAdapter(
              child: _AboutSection(),
            ),

            // ── Bottom Safe Area ──
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.spaceXxl),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context, WidgetRef ref) {
    final profile = ref.read(playerProfileProvider);
    BooyahXBottomSheet.show(
      context: context,
      title: 'Edit Profile',
      child: _EditProfileForm(
        initialName: profile?.name ?? '',
        initialIgn: profile?.inGameName ?? '',
        initialUid: profile?.uid ?? '',
        onSave: (name, ign, uid) {
          ref.read(playerProfileProvider.notifier).updateProfile(
                name: name,
                inGameName: ign,
                uid: uid,
              );
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Private Sub-Widgets
// ══════════════════════════════════════════════════════════

/// Profile header with avatar, name, UID, and edit button.
class _ProfileHeader extends StatelessWidget {
  final String name;
  final String ign;
  final String uid;
  final VoidCallback onEdit;

  const _ProfileHeader({
    required this.name,
    required this.ign,
    required this.uid,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.gutter,
        AppDimensions.spaceXxl,
        AppDimensions.gutter,
        AppDimensions.spaceXl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar title
            Row(
              children: [
                Container(
                  width: AppDimensions.avatarMd,
                  height: AppDimensions.avatarMd,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryFixed,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.secondary,
                    size: AppDimensions.iconMd,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceSm),
                Text(
                  'PROFILE',
                  style: AppTextStyles.headlineMd.copyWith(
                    color: AppColors.onSurface,
                    letterSpacing: 0.04,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceXl),

            // Avatar
            BooyahXAvatar(
              initials: name.isNotEmpty ? name[0].toUpperCase() : '?',
              size: AvatarSize.xl,
              backgroundColor: AppColors.primary,
              borderColor: AppColors.primaryFixed,
            ),
            const SizedBox(height: AppDimensions.spaceLg),

            // Player Name
            Text(
              name,
              style: AppTextStyles.headlineLg.copyWith(
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spaceXs),

            // IGN
            Text(
              ign,
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spaceXs),

            // UID badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceMd,
                vertical: AppDimensions.spaceXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.tag,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: AppDimensions.spaceXs),
                  Text(
                    'UID: $uid',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLg),

            // Edit button
            BooyahXButton(
              label: 'Edit Profile',
              icon: Icons.edit_outlined,
              style: BooyahXButtonStyle.outlined,
              isExpanded: false,
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Player statistics section.
class _StatsSection extends StatelessWidget {
  final PlayerStats stats;

  const _StatsSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.gutter,
        AppDimensions.spaceLg,
        AppDimensions.gutter,
        AppDimensions.spaceLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BooyahXSectionHeader(
            title: 'Your Stats',
            subtitle: 'Performance',
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.sports_esports,
                  label: 'Matches',
                  value: '${stats.totalMatches}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: _StatCard(
                  icon: Icons.emoji_events,
                  label: 'Wins',
                  value: '${stats.wins}',
                  color: AppColors.tertiary,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department,
                  label: 'Kills',
                  value: '${stats.kills}',
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.stars,
                  label: 'Points',
                  value: _formatPoints(stats.points),
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: _StatCard(
                  icon: Icons.account_balance_wallet,
                  label: 'Earnings',
                  value: stats.earnings,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              // Win rate card
              Expanded(
                child: _StatCard(
                  icon: Icons.percent,
                  label: 'Win Rate',
                  value: '${stats.winRate.toStringAsFixed(1)}%',
                  color: AppColors.cyanAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPoints(int points) {
    if (points >= 1000) {
      return '${(points / 1000).toStringAsFixed(1)}k';
    }
    return '$points';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSm,
        vertical: AppDimensions.spaceMd,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            value,
            style: AppTextStyles.titleMd.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMuted,
              fontSize: 9,
              letterSpacing: 0.06,
            ),
          ),
        ],
      ),
    );
  }
}

/// Navigation menu options.
class _MenuSection extends StatelessWidget {
  final VoidCallback onMyMatches;
  final VoidCallback onLeaderboard;
  final VoidCallback onNotifications;
  final VoidCallback onWallet;

  const _MenuSection({
    required this.onMyMatches,
    required this.onLeaderboard,
    required this.onNotifications,
    required this.onWallet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.gutter,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BooyahXSectionHeader(
            title: 'Quick Links',
            subtitle: 'Navigation',
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          _MenuTile(
            icon: Icons.sports_esports_outlined,
            iconColor: AppColors.primary,
            title: 'My Matches',
            subtitle: 'View your upcoming and past matches',
            onTap: onMyMatches,
          ),
          _MenuTile(
            icon: Icons.leaderboard_outlined,
            iconColor: AppColors.tertiary,
            title: 'Leaderboard',
            subtitle: 'See global player rankings',
            onTap: onLeaderboard,
          ),
          _MenuTile(
            icon: Icons.notifications_outlined,
            iconColor: AppColors.secondary,
            title: 'Notifications',
            subtitle: 'Check your latest updates',
            onTap: onNotifications,
          ),
          _MenuTile(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.success,
            title: 'Wallet',
            subtitle: 'View balance and transactions',
            onTap: onWallet,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleSm.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: AppDimensions.iconSm,
                color: AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Settings section with toggles.
class _SettingsSection extends StatelessWidget {
  final ProfileSettings settings;
  final VoidCallback onToggleNotifications;
  final VoidCallback onToggleSound;

  const _SettingsSection({
    required this.settings,
    required this.onToggleNotifications,
    required this.onToggleSound,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.gutter,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.spaceLg),
          BooyahXSectionHeader(
            title: 'Settings',
            subtitle: 'Preferences',
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  iconColor: AppColors.primary,
                  title: 'Notifications',
                  subtitle: settings.notificationsEnabled
                      ? 'Enabled'
                      : 'Disabled',
                  trailing: Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (_) => onToggleNotifications(),
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primaryFixed,
                    inactiveThumbColor: AppColors.textLight,
                    inactiveTrackColor: AppColors.surfaceContainerHigh,
                  ),
                ),
                const BooyahXDivider(),
                _SettingsTile(
                  icon: Icons.volume_up_outlined,
                  iconColor: AppColors.secondary,
                  title: 'Sound',
                  subtitle: settings.soundEnabled ? 'Enabled' : 'Disabled',
                  trailing: Switch(
                    value: settings.soundEnabled,
                    onChanged: (_) => onToggleSound(),
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primaryFixed,
                    inactiveThumbColor: AppColors.textLight,
                    inactiveTrackColor: AppColors.surfaceContainerHigh,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.cardPaddingLg,
        vertical: AppDimensions.spaceMd,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSm.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

/// About section with app branding.
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.gutter,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.spaceLg),
          BooyahXSectionHeader(
            title: 'About',
            subtitle: 'Info',
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Container(
            padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                // App icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.cyanAccent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: AppColors.onPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BOOYAHX',
                        style: AppTextStyles.titleMd.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.04,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tournament Hub for Free Fire MAX',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceSm,
                    vertical: AppDimensions.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    'v1.0.0',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Edit Profile Form (Bottom Sheet)
// ══════════════════════════════════════════════════════════

class _EditProfileForm extends StatefulWidget {
  final String initialName;
  final String initialIgn;
  final String initialUid;
  final void Function(String name, String ign, String uid) onSave;

  const _EditProfileForm({
    required this.initialName,
    required this.initialIgn,
    required this.initialUid,
    required this.onSave,
  });

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _ignController;
  late final TextEditingController _uidController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _ignController = TextEditingController(text: widget.initialIgn);
    _uidController = TextEditingController(text: widget.initialUid);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ignController.dispose();
    _uidController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final ign = _ignController.text.trim();
      final uid = _uidController.text.trim();
      widget.onSave(name, ign, uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BooyahXTextField(
            label: 'Player Name',
            hintText: 'Enter your name',
            controller: _nameController,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name cannot be empty';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          BooyahXTextField(
            label: 'In-Game Name',
            hintText: 'Enter your IGN',
            controller: _ignController,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'IGN cannot be empty';
              }
              if (value.trim().length < 3) {
                return 'IGN must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          BooyahXTextField(
            label: 'Free Fire UID',
            hintText: 'Enter your UID',
            controller: _uidController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'UID cannot be empty';
              }
              if (value.trim().length < 4) {
                return 'UID must be at least 4 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.spaceXl),
          BooyahXButton(
            label: 'Save Changes',
            onPressed: _handleSave,
          ),
        ],
      ),
    );
  }
}
