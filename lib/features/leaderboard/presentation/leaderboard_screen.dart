import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/core/models/leaderboard.dart';
import 'package:booyahx/core/data/mock_leaderboard.dart';
import 'package:booyahx/core/providers/leaderboard_provider.dart';
import 'package:booyahx/core/providers/player_profile_provider.dart';
import 'package:booyahx/shared/widgets/widgets.dart';

/// BooyahX — Leaderboard Screen
///
/// Displays player rankings with filter tabs, a podium for the top 3,
/// and a scrollable list of all ranked players. Uses mock data during
/// development. Will be replaced by a real API data source later.
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Load leaderboard data on first render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaderboardProvider.notifier).loadLeaderboard();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardData = ref.watch(leaderboardProvider);
    final playerProfile = ref.watch(playerProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const _LeaderboardAppBar(),
      body: _buildBody(leaderboardData, playerProfile?.inGameName),
    );
  }

  Widget _buildBody(LeaderboardData data, String? currentIgn) {
    return switch (data.status) {
      LeaderboardStatus.loading => _buildLoadingState(),
      LeaderboardStatus.normal => _buildNormalState(data, currentIgn),
      LeaderboardStatus.empty => _buildEmptyState(),
      LeaderboardStatus.error => _buildErrorState(data.errorMessage),
    };
  }

  // ── Loading State ──

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.gutter,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.spaceMd),
          // Skeleton filter chips
          Row(
            children: List.generate(
              4,
              (i) => Padding(
                padding: const EdgeInsets.only(right: AppDimensions.spaceSm),
                child: BooyahXLoadingSkeleton(
                  width: 80 + (i * 10).toDouble(),
                  height: 36,
                  borderRadius: AppDimensions.radiusFull,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          // Skeleton podium
          _buildSkeletonPodium(),
          const SizedBox(height: AppDimensions.spaceLg),
          // Skeleton list rows
          ...List.generate(
            8,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
              child: const BooyahXLoadingSkeleton(
                width: double.infinity,
                height: 64,
                borderRadius: AppDimensions.radiusLg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonPodium() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          Column(
            children: [
              const BooyahXLoadingSkeleton(
                width: 48,
                height: 48,
                borderRadius: AppDimensions.radiusFull,
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              const BooyahXLoadingSkeleton(width: 64, height: 12),
            ],
          ),
          const SizedBox(width: AppDimensions.spaceLg),
          // 1st place
          Column(
            children: [
              const BooyahXLoadingSkeleton(
                width: 64,
                height: 64,
                borderRadius: AppDimensions.radiusFull,
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              const BooyahXLoadingSkeleton(width: 80, height: 12),
            ],
          ),
          const SizedBox(width: AppDimensions.spaceLg),
          // 3rd place
          Column(
            children: [
              const BooyahXLoadingSkeleton(
                width: 48,
                height: 48,
                borderRadius: AppDimensions.radiusFull,
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              const BooyahXLoadingSkeleton(width: 64, height: 12),
            ],
          ),
        ],
      ),
    );
  }

  // ── Normal State ──

  Widget _buildNormalState(LeaderboardData data, String? currentIgn) {
    final filter = ref.read(leaderboardProvider.notifier).filter;
    final top3 = data.players.take(3).toList();
    final remaining = data.players.skip(3).toList();

    // Find current user's rank if they exist
    final currentRank = currentIgn != null
        ? data.players
            .where((p) => p.inGameName.toUpperCase() == currentIgn.toUpperCase())
            .firstOrNull
        : null;

    return RefreshIndicator(
      onRefresh: () => ref.read(leaderboardProvider.notifier).retry(),
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // ── Filter Chips ──
          SliverToBoxAdapter(
            child: _FilterBar(
              selectedFilter: filter,
              onFilterChanged: (f) =>
                  ref.read(leaderboardProvider.notifier).changeFilter(f),
            ),
          ),

          // ── Section Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.gutter,
                AppDimensions.spaceMd,
                AppDimensions.gutter,
                AppDimensions.spaceSm,
              ),
              child: BooyahXSectionHeader(
                title: '${MockLeaderboardData.filterLabels[filter]} Rankings',
                badgeText: '${data.players.length} Players',
              ),
            ),
          ),

          // ── Top Players Podium ──
          if (top3.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.gutter,
                  0,
                  AppDimensions.gutter,
                  AppDimensions.spaceLg,
                ),
                child: _TopPlayersPodium(
                  players: top3,
                  currentIgn: currentIgn,
                ),
              ),
            ),

          // ── Ranking List Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.gutter,
                0,
                AppDimensions.gutter,
                AppDimensions.spaceSm,
              ),
              child: const _RankingListHeader(),
            ),
          ),

          // ── Ranking List ──
          if (remaining.isEmpty)
            const SliverFillRemaining(child: _EmptyRankings())
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.gutter,
              ),
              sliver: SliverList.builder(
                itemCount: remaining.length,
                itemBuilder: (context, index) {
                  final player = remaining[index];
                  final isCurrentUser = currentIgn != null &&
                      player.inGameName.toUpperCase() ==
                          currentIgn.toUpperCase();

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.spaceSm,
                    ),
                    child: BooyahXLeaderboardRow(
                      rank: player.rank,
                      inGameName: player.inGameName,
                      avatarUrl: player.avatarUrl,
                      matches: player.matches,
                      kills: player.kills,
                      points: player.points,
                      winnings: player.winnings,
                      isCurrentUser: isCurrentUser,
                    ),
                  );
                },
              ),
            ),

          // ── Current User Rank Card (if not in top rankings) ──
          if (currentRank == null && currentIgn != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.gutter,
                  AppDimensions.spaceLg,
                  AppDimensions.gutter,
                  AppDimensions.spaceXl,
                ),
                child: _CurrentUserCard(
                  ign: currentIgn,
                  rank: '--',
                ),
              ),
            ),

          // ── Bottom Safe Area ──
          const SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.spaceLg),
          ),
        ],
      ),
    );
  }

  // ── Empty State ──

  Widget _buildEmptyState() {
    return BooyahXEmptyState(
      icon: Icons.leaderboard_outlined,
      title: 'No rankings available',
      subtitle: 'No players have been ranked yet. Check back soon!',
      actionLabel: 'Refresh',
      onAction: () => ref.read(leaderboardProvider.notifier).retry(),
    );
  }

  // ── Error State ──

  Widget _buildErrorState(String? message) {
    return BooyahXErrorState(
      title: 'Unable to load leaderboard',
      message: message ?? 'Something went wrong. Please check your connection and try again.',
      actionLabel: 'Try Again',
      onAction: () => ref.read(leaderboardProvider.notifier).retry(),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Private Sub-Widgets
// ══════════════════════════════════════════════════════════

/// Custom app bar for the leaderboard screen.
class _LeaderboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _LeaderboardAppBar();

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
            // Leaderboard icon
            Container(
              width: AppDimensions.avatarMd,
              height: AppDimensions.avatarMd,
              decoration: BoxDecoration(
                color: AppColors.tertiaryFixed,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.tertiaryFixed, width: 1),
              ),
              child: const Icon(
                Icons.leaderboard,
                color: AppColors.tertiary,
                size: AppDimensions.iconMd,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            // Title
            Text(
              'LEADERBOARD',
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.onSurface,
                letterSpacing: 0.04,
              ),
            ),
            const Spacer(),
            // Info icon
            Container(
              width: AppDimensions.avatarLg,
              height: AppDimensions.avatarLg,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: const Icon(
                Icons.info_outline,
                size: AppDimensions.iconSm,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrollable filter bar for leaderboard periods.
class _FilterBar extends StatelessWidget {
  final LeaderboardFilter selectedFilter;
  final ValueChanged<LeaderboardFilter> onFilterChanged;

  const _FilterBar({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.gutter,
        ),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(
          width: AppDimensions.spaceSm,
        ),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter.filter == selectedFilter;

          return BooyahXChip(
            label: filter.label,
            icon: filter.icon,
            isSelected: isSelected,
            selectedBackgroundColor: AppColors.onSurface,
            selectedTextColor: AppColors.surface,
            unselectedBackgroundColor: AppColors.surface,
            unselectedTextColor: AppColors.onSurfaceVariant,
            onTap: () => onFilterChanged(filter.filter),
          );
        },
      ),
    );
  }

  static const _filters = [
    _FilterItem(filter: LeaderboardFilter.overall, label: 'OVERALL', icon: Icons.emoji_events),
    _FilterItem(filter: LeaderboardFilter.weekly, label: 'WEEKLY', icon: Icons.date_range),
    _FilterItem(filter: LeaderboardFilter.monthly, label: 'MONTHLY', icon: Icons.calendar_month),
    _FilterItem(filter: LeaderboardFilter.season, label: 'SEASON', icon: Icons.stars),
  ];
}

class _FilterItem {
  final LeaderboardFilter filter;
  final String label;
  final IconData icon;
  const _FilterItem({
    required this.filter,
    required this.label,
    required this.icon,
  });
}

/// Top 3 players podium section.
class _TopPlayersPodium extends StatelessWidget {
  final List<LeaderboardPlayer> players;
  final String? currentIgn;

  const _TopPlayersPodium({
    required this.players,
    this.currentIgn,
  });

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) return const SizedBox.shrink();

    // Reorder: 2nd, 1st, 3rd for podium layout
    final ordered = <_PodiumEntry>[];
    if (players.length >= 2) {
      ordered.add(_PodiumEntry(player: players[1], size: _PodiumSize.medium));
    }
    if (players.isNotEmpty) {
      ordered.add(_PodiumEntry(player: players[0], size: _PodiumSize.large));
    }
    if (players.length >= 3) {
      ordered.add(_PodiumEntry(player: players[2], size: _PodiumSize.small));
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.tertiaryFixed.withValues(alpha: 0.4),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(
          color: AppColors.tertiary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Players
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: ordered
                .map((entry) => _PodiumPlayer(
                      entry: entry,
                      isCurrentUser: currentIgn != null &&
                          entry.player.inGameName.toUpperCase() ==
                              currentIgn!.toUpperCase(),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          // Stats row
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceLg,
              vertical: AppDimensions.spaceSm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PodiumStat(
                  icon: Icons.local_fire_department,
                  label: 'Total Kills',
                  value: _formatNumber(
                    players.fold(0, (sum, p) => sum + p.kills),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceLg),
                _PodiumStat(
                  icon: Icons.sports_esports,
                  label: 'Matches',
                  value: _formatNumber(
                    players.fold(0, (sum, p) => sum + p.matches),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return '$value';
  }
}

enum _PodiumSize { large, medium, small }

class _PodiumEntry {
  final LeaderboardPlayer player;
  final _PodiumSize size;
  const _PodiumEntry({required this.player, required this.size});
}

class _PodiumPlayer extends StatelessWidget {
  final _PodiumEntry entry;
  final bool isCurrentUser;

  const _PodiumPlayer({
    required this.entry,
    this.isCurrentUser = false,
  });

  Color get _rankColor {
    if (entry.player.rank == 1) return AppColors.tertiary;
    if (entry.player.rank == 2) return AppColors.textMuted;
    if (entry.player.rank == 3) return const Color(0xFFCD7F32);
    return AppColors.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Crown for #1
          if (entry.player.rank == 1)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceXs),
              child: Icon(
                Icons.emoji_events,
                color: _rankColor,
                size: 20,
              ),
            ),

          // Avatar with rank badge
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Avatar
              BooyahXAvatar(
                imageUrl: entry.player.avatarUrl,
                initials: entry.player.inGameName.isNotEmpty
                    ? entry.player.inGameName[0].toUpperCase()
                    : '?',
                size: entry.size == _PodiumSize.large
                    ? AvatarSize.xl
                    : AvatarSize.lg,
                borderColor: _rankColor,
                backgroundColor: isCurrentUser ? AppColors.primary : null,
              ),
              // Rank badge
              Positioned(
                bottom: entry.size == _PodiumSize.large ? -4 : -2,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _rankColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surface,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.player.rank}',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          // Name
          Text(
            entry.player.inGameName,
            style: AppTextStyles.titleSm.copyWith(
              color: isCurrentUser ? AppColors.primary : AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceXs),

          // Points
          Text(
            '${_formatPoints(entry.player.points)} pts',
            style: AppTextStyles.labelNumeric.copyWith(
              color: AppColors.primary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXs),

          // Winnings
          if (entry.player.winnings != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceSm,
                vertical: AppDimensions.spaceXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.tertiaryFixed,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                entry.player.winnings!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.tertiary,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
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

class _PodiumStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _PodiumStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: AppDimensions.spaceXs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTextStyles.labelNumeric.copyWith(
                color: AppColors.onSurface,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Column headers for the ranking list.
class _RankingListHeader extends StatelessWidget {
  const _RankingListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.cardPaddingLg,
        vertical: AppDimensions.spaceSm,
      ),
      child: Row(
        children: [
          const SizedBox(width: 32), // Rank column
          const SizedBox(width: AppDimensions.spaceMd),
          const SizedBox(width: AppDimensions.avatarSm), // Avatar
          const SizedBox(width: AppDimensions.spaceMd),
          const Expanded(
            child: Text(
              'PLAYER',
              style: AppTextStyles.caption,
            ),
          ),
          _HeaderCell(label: 'KILLS'),
          const SizedBox(width: AppDimensions.spaceLg),
          _HeaderCell(label: 'POINTS'),
          const SizedBox(width: AppDimensions.spaceMd),
          _HeaderCell(label: 'WON'),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textMuted,
        fontSize: 9,
        letterSpacing: 0.06,
      ),
      textAlign: TextAlign.right,
    );
  }
}

/// Empty rankings placeholder when only top 3 exist.
class _EmptyRankings extends StatelessWidget {
  const _EmptyRankings();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXxl),
        child: Text(
          'Only top 3 players are ranked in this period.',
          style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Card shown when the current player is not in the visible rankings.
class _CurrentUserCard extends StatelessWidget {
  final String ign;
  final String rank;

  const _CurrentUserCard({
    required this.ign,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Center(
              child: Text(
                rank,
                style: AppTextStyles.labelNumeric.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          // Avatar
          BooyahXAvatar(
            initials: ign.isNotEmpty ? ign[0].toUpperCase() : '?',
            size: AvatarSize.md,
            borderColor: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ign,
                  style: AppTextStyles.titleSm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Your rank',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          // Arrow
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
