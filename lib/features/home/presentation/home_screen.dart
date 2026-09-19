import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/core/constants/app_routes.dart';
import 'package:booyahx/core/models/tournament.dart';
import 'package:booyahx/core/data/mock_tournaments.dart';
import 'package:booyahx/core/providers/player_profile_provider.dart';
import 'package:booyahx/services/api_service.dart';
import 'package:booyahx/shared/widgets/widgets.dart';

/// BooyahX — Home Screen (Tournament Hub)
///
/// The main landing screen showing featured banner, category filters,
/// and a scrollable tournament list. Uses mock data during development.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // ── State ──
  TournamentCategory _selectedCategory = TournamentCategory.soloBr;
  _ScreenStatus _screenStatus = _ScreenStatus.loading;
  List<Tournament> _tournaments = [];
  Tournament _featuredBanner = MockTournamentData.featuredBanner;

  @override
  void initState() {
    super.initState();
    _loadTournaments();
  }

  // ── Data Loading ──

  Future<void> _loadTournaments() async {
    if (!mounted) return;

    try {
      final data = await ApiService.instance.getTournaments();
      if (!mounted) return;

      final tournaments = data.map((json) => _fromApi(json)).toList();

      // Separate featured and regular tournaments
      final featured = tournaments.where((t) => t.isFeatured).toList();
      if (featured.isNotEmpty) {
        _featuredBanner = featured.first;
      }

      setState(() {
        _tournaments = _filterByCategory(tournaments, _selectedCategory);
        _screenStatus = _tournaments.isEmpty
            ? _ScreenStatus.empty
            : _ScreenStatus.normal;
      });
    } catch (e) {
      if (!mounted) return;
      // Fallback to mock data if API fails
      setState(() {
        _tournaments = MockTournamentData.byCategory(_selectedCategory);
        _featuredBanner = MockTournamentData.featuredBanner;
        _screenStatus = _ScreenStatus.normal;
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _screenStatus = _ScreenStatus.loading;
    });

    await _loadTournaments();
  }

  void _onCategoryChanged(TournamentCategory category) {
    if (category == _selectedCategory) return;
    setState(() {
      _selectedCategory = category;
      _screenStatus = _ScreenStatus.loading;
    });
    _loadTournaments();
  }

  void _onRetry() {
    setState(() {
      _screenStatus = _ScreenStatus.loading;
    });
    _loadTournaments();
  }

  /// Convert API JSON to Tournament model.
  Tournament _fromApi(Map<String, dynamic> json) {
    return Tournament(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      game: json['game'] ?? 'Free Fire',
      description: json['description'],
      mode: json['mode'] ?? 'SOLO BR',
      map: json['map'] ?? 'Bermuda',
      dateTime: json['dateTime'] != null
          ? DateTime.tryParse(json['dateTime'])?.toLocal().toString()
          : null,
      prizePool: json['prizePool'],
      perKill: json['perKill'],
      entryFee: json['entryFee'],
      totalSlots: json['totalSlots'],
      filledSlots: json['filledSlots'],
      status: _parseStatus(json['status']),
      statusLabel: _statusLabel(json['status']),
      imageUrl: json['imageUrl'],
      category: _parseCategory(json['category']),
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  TournamentStatus _parseStatus(String? status) {
    return switch (status) {
      'upcoming' => TournamentStatus.upcoming,
      'open' => TournamentStatus.open,
      'registrationOpen' => TournamentStatus.registrationOpen,
      'almostFull' => TournamentStatus.almostFull,
      'closingSoon' => TournamentStatus.closingSoon,
      'full' => TournamentStatus.full,
      'live' => TournamentStatus.live,
      'completed' => TournamentStatus.completed,
      'cancelled' => TournamentStatus.cancelled,
      _ => TournamentStatus.open,
    };
  }

  String _statusLabel(String? status) {
    return switch (status) {
      'upcoming' => 'Upcoming',
      'open' => 'Open',
      'registrationOpen' => 'Registration Open',
      'almostFull' => 'Almost Full',
      'closingSoon' => 'Closing Soon',
      'full' => 'Full',
      'live' => 'Live',
      'completed' => 'Completed',
      'cancelled' => 'Cancelled',
      _ => 'Open',
    };
  }

  TournamentCategory _parseCategory(String? category) {
    return switch (category) {
      'soloBr' => TournamentCategory.soloBr,
      'duoBr' => TournamentCategory.duoBr,
      'duoPerKill' => TournamentCategory.duoPerKill,
      'soloPerKill' => TournamentCategory.soloPerKill,
      _ => TournamentCategory.all,
    };
  }

  List<Tournament> _filterByCategory(
      List<Tournament> tournaments, TournamentCategory category) {
    if (category == TournamentCategory.all) return tournaments;
    return tournaments.where((t) => t.category == category).toList();
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final playerProfile = ref.watch(playerProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BooyahXAppBar(
        showWallet: true,
        walletBalance: 450,
        showNotifications: true,
        notificationCount: 3,
        showProfileAvatar: true,
        titleWidget: _HomeAppBarTitle(ign: playerProfile?.inGameName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            tooltip: 'Create Tournament',
            onPressed: () async {
              final result = await context.push<bool>(AppRoutes.createTournamentPath);
              if (result == true && mounted) {
                _onRefresh();
              }
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return switch (_screenStatus) {
      _ScreenStatus.loading => _buildLoadingState(),
      _ScreenStatus.normal => _buildNormalState(),
      _ScreenStatus.empty => _buildEmptyState(),
      _ScreenStatus.error => _buildErrorState(),
    };
  }

  // ── Normal State ──

  Widget _buildNormalState() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // ── Featured Flash Banner ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.gutter,
                AppDimensions.spaceMd,
                AppDimensions.gutter,
                AppDimensions.spaceMd,
              ),
              child: _FlashBanner(tournament: _featuredBanner),
            ),
          ),

          // ── Category Filter Chips ──
          SliverToBoxAdapter(
            child: _CategoryFilterBar(
              selectedCategory: _selectedCategory,
              onCategoryChanged: _onCategoryChanged,
            ),
          ),

          // ── Section Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.gutter,
                AppDimensions.spaceMd,
                AppDimensions.gutter,
                AppDimensions.spaceMd,
              ),
              child: BooyahXSectionHeader(
                title: 'Upcoming Tournaments',
                badgeText: '${_tournaments.length} Available',
              ),
            ),
          ),

          // ── Tournament List ──
          if (_tournaments.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.gutter,
              ),
              sliver: SliverList.builder(
                itemCount: _tournaments.length,
                itemBuilder: (context, index) {
                  final tournament = _tournaments[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.spaceMd,
                    ),
                    child: BooyahXTournamentCard(
                      name: tournament.name,
                      description: tournament.description,
                      mode: tournament.mode,
                      map: tournament.map,
                      dateTime: tournament.dateTime,
                      prizePool: tournament.prizePool,
                      perKill: tournament.perKill,
                      entryFee: tournament.entryFee,
                      totalSlots: tournament.totalSlots,
                      filledSlots: tournament.filledSlots,
                      status: tournament.status,
                      statusLabel: tournament.statusLabel,
                      ctaLabel: tournament.ctaLabel,
                      imageUrl: tournament.imageUrl,
                      onTap: () => _onTournamentTap(tournament),
                      onJoin: () => _onTournamentJoin(tournament),
                    ),
                  );
                },
              ),
            ),

          // ── Quick Guarantee Banner ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.gutter,
                AppDimensions.spaceSm,
                AppDimensions.gutter,
                AppDimensions.spaceXl,
              ),
              child: const _GuaranteeBanner(),
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
          // Skeleton banner
          const BooyahXLoadingSkeleton(
            width: double.infinity,
            height: 140,
            borderRadius: AppDimensions.radiusLg,
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          // Skeleton chips
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
          // Skeleton tournament cards
          const BooyahXListSkeleton(itemCount: 3),
        ],
      ),
    );
  }

  // ── Empty State ──

  Widget _buildEmptyState() {
    return BooyahXEmptyState(
      icon: Icons.sports_esports_outlined,
      title: 'No tournaments available',
      subtitle: 'No tournaments found right now. Check back soon!',
      actionLabel: 'Refresh',
      onAction: _onRefresh,
    );
  }

  // ── Error State ──

  Widget _buildErrorState() {
    return BooyahXErrorState(
      title: 'Unable to load tournaments',
      message: 'Something went wrong. Please check your connection and try again.',
      actionLabel: 'Try Again',
      onAction: _onRetry,
    );
  }

  // ── Actions ──

  void _onTournamentTap(Tournament tournament) {
    context.push(
      AppRoutes.tournamentDetailById(tournament.id),
    );
  }

  void _onTournamentJoin(Tournament tournament) {
    // For now, navigate to tournament details.
    // Payment/slot joining will be implemented later.
    context.push(
      AppRoutes.tournamentDetailById(tournament.id),
    );
  }
}

enum _ScreenStatus { loading, normal, empty, error }

// ══════════════════════════════════════════════════════════
// Private Sub-Widgets
// ══════════════════════════════════════════════════════════

/// Custom app bar title showing BOOYAH + X branding + player IGN.
class _HomeAppBarTitle extends StatelessWidget {
  final String? ign;
  const _HomeAppBarTitle({this.ign});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Logo icon
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
            Row(
              children: [
                Text(
                  'BOOYAH',
                  style: AppTextStyles.headlineMd.copyWith(
                    color: AppColors.onSurface,
                    letterSpacing: 0.04,
                  ),
                ),
                Text(
                  'X',
                  style: AppTextStyles.headlineMd.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 0.04,
                  ),
                ),
              ],
            ),
            if (ign != null)
              Text(
                ign!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 0.02,
                  fontSize: 10,
                ),
              )
            else
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

/// Flash Banner — Featured tournament at the top of the Home screen.
class _FlashBanner extends StatelessWidget {
  final Tournament tournament;
  const _FlashBanner({required this.tournament});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.tournamentDetailById(tournament.id),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryFixed.withValues(alpha: 0.3),
                      AppColors.surface,
                      AppColors.primaryFixed.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Status + Time Left
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _BannerStatusBadge(
                        label: tournament.statusLabel ?? 'Closing Soon',
                      ),
                      if (tournament.featuredTimeLeft != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              size: 15,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tournament.featuredTimeLeft!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),

                  // Tournament name
                  Text(
                    tournament.name,
                    style: AppTextStyles.headlineMd.copyWith(
                      color: AppColors.onSurface,
                      letterSpacing: 0.01,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spaceXs),

                  // Prize pool
                  if (tournament.featuredPrizePool != null)
                    Row(
                      children: [
                        Text(
                          'Grand Pool',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                            letterSpacing: 0.04,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tournament.featuredPrizePool!,
                          style: AppTextStyles.labelNumeric.copyWith(
                            color: AppColors.tertiary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: AppDimensions.spaceMd),

                  // Bottom row: Joined avatars + Join Now button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Joined count
                      Row(
                        children: [
                          // Avatar stack
                          SizedBox(
                            width: 64,
                            height: 24,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: 0,
                                  child: _MiniAvatar(
                                    label: 'FF',
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  child: _MiniAvatar(
                                    label: 'PRO',
                                    color: AppColors.primary,
                                  ),
                                ),
                                Positioned(
                                  left: 32,
                                  child: _MiniAvatar(
                                    label: '+${(tournament.featuredTotalCount ?? 100) - (tournament.featuredJoinedCount ?? 94)}',
                                    color: AppColors.tertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceSm),
                          Text(
                            '${tournament.featuredJoinedCount ?? 94}/${tournament.featuredTotalCount ?? 100} Joined',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // Join Now button
                      GestureDetector(
                        onTap: () => context.push(
                          AppRoutes.tournamentDetailById(tournament.id),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceMd,
                            vertical: AppDimensions.spaceSm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cyanAccent,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMd,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cyanAccent.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'JOIN NOW',
                                style: AppTextStyles.labelCaps.copyWith(
                                  color: AppColors.onSurface,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.bolt,
                                size: 16,
                                color: AppColors.onSurface,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Status badge for the flash banner.
class _BannerStatusBadge extends StatelessWidget {
  final String label;
  const _BannerStatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated dot
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelCaps.copyWith(
              color: AppColors.error,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mini avatar for the banner player stack.
class _MiniAvatar extends StatelessWidget {
  final String label;
  final Color color;
  const _MiniAvatar({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: 2),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

/// Horizontal scrollable category filter bar.
class _CategoryFilterBar extends StatelessWidget {
  final TournamentCategory selectedCategory;
  final ValueChanged<TournamentCategory> onCategoryChanged;

  const _CategoryFilterBar({
    required this.selectedCategory,
    required this.onCategoryChanged,
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
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(
          width: AppDimensions.spaceSm,
        ),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat.category == selectedCategory;

          return BooyahXChip(
            label: cat.label,
            icon: cat.icon,
            isSelected: isSelected,
            selectedBackgroundColor: AppColors.onSurface,
            selectedTextColor: AppColors.surface,
            unselectedBackgroundColor: AppColors.surface,
            unselectedTextColor: AppColors.onSurfaceVariant,
            onTap: () => onCategoryChanged(cat.category),
          );
        },
      ),
    );
  }

  static const _categories = [
    _CategoryItem(category: TournamentCategory.soloBr, label: 'SOLO BR', icon: Icons.person),
    _CategoryItem(category: TournamentCategory.duoBr, label: 'DUO BR', icon: Icons.group),
    _CategoryItem(category: TournamentCategory.duoPerKill, label: 'DUO PER KILL', icon: Icons.military_tech),
    _CategoryItem(category: TournamentCategory.soloPerKill, label: 'SOLO PER KILL', icon: Icons.sports_martial_arts),
  ];
}

class _CategoryItem {
  final TournamentCategory category;
  final String label;
  final IconData icon;
  const _CategoryItem({
    required this.category,
    required this.label,
    required this.icon,
  });
}

/// Quick Guarantee Banner at the bottom of the Home screen.
class _GuaranteeBanner extends StatelessWidget {
  const _GuaranteeBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              size: AppDimensions.iconLg,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instant Winnings Payout',
                  style: AppTextStyles.titleMd.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rewards credit directly to in-app wallet within 10 minutes post match confirmation.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
