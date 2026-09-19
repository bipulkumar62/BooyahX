import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/core/models/tournament.dart';
import 'package:booyahx/core/data/mock_tournaments.dart';
import 'package:booyahx/shared/widgets/widgets.dart';

/// BooyahX — Tournament Details Screen
///
/// Displays full tournament information with three tabs:
/// Prize Pool, Players, and Rules.
/// Receives a tournament ID from the route and loads mock data.
class TournamentDetailsScreen extends StatefulWidget {
  final String tournamentId;

  const TournamentDetailsScreen({
    super.key,
    required this.tournamentId,
  });

  @override
  State<TournamentDetailsScreen> createState() => _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState extends State<TournamentDetailsScreen> {
  // ── State ──
  _ScreenStatus _status = _ScreenStatus.loading;
  TournamentDetail? _detail;
  int _selectedTabIndex = 0;
  bool _hasJoined = false;

  @override
  void initState() {
    super.initState();
    _loadTournament();
  }

  Future<void> _loadTournament() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final detail = MockTournamentData.detailById(widget.tournamentId);

    if (detail == null) {
      setState(() {
        _status = _ScreenStatus.error;
      });
      return;
    }

    setState(() {
      _detail = detail;
      _hasJoined = detail.hasJoined;
      _status = _ScreenStatus.normal;
    });
  }

  void _onJoinTap() {
    final detail = _detail;
    if (detail == null) return;

    final t = detail.tournament;

    // Determine CTA label based on tournament state
    if (t.status == TournamentStatus.full ||
        t.status == TournamentStatus.live ||
        t.status == TournamentStatus.completed ||
        t.status == TournamentStatus.cancelled ||
        _hasJoined) {
      return;
    }

    _showJoinConfirmation(detail);
  }

  void _showJoinConfirmation(TournamentDetail detail) {
    final t = detail.tournament;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sports_esports,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // Title
              Text(
                'Join Tournament?',
                style: AppTextStyles.headlineSm.copyWith(
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceSm),

              // Tournament name
              Text(
                t.name,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // Details card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _DialogInfoRow(
                      label: 'Entry Fee',
                      value: t.entryFee ?? '₹0',
                      valueColor: AppColors.onSurface,
                    ),
                    const SizedBox(height: AppDimensions.spaceSm),
                    _DialogInfoRow(
                      label: 'Available Slots',
                      value: '${t.remainingSlots ?? 0}',
                      valueColor: AppColors.primary,
                    ),
                    const SizedBox(height: AppDimensions.spaceSm),
                    _DialogInfoRow(
                      label: 'Prize Pool',
                      value: t.prizePool ?? '₹0',
                      valueColor: AppColors.tertiary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),

              // Cancel button
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightMd,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.onSurface,
                    side: const BorderSide(color: AppColors.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    ),
                  ),
                  child: Text(
                    'CANCEL',
                    style: AppTextStyles.buttonLg.copyWith(color: AppColors.onSurface),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceSm),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightLg,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _confirmJoin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    ),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: AppTextStyles.buttonLg.copyWith(color: AppColors.onPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmJoin() {
    // Simulate successful join — no backend call
    setState(() {
      _hasJoined = true;
    });

    if (!mounted) return;

    final t = _detail?.tournament;
    final slotNumber = (t?.filledSlots ?? 0) + 1;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 32,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(
                'Slot Confirmed!',
                style: AppTextStyles.headlineSm.copyWith(
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              Text(
                'You are officially registered for ${t?.name ?? 'this tournament'}.',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _DialogInfoRow(
                      label: 'Allocated Slot',
                      value: '#$slotNumber',
                      valueColor: AppColors.primary,
                    ),
                    const SizedBox(height: AppDimensions.spaceSm),
                    _DialogInfoRow(
                      label: 'Room Credentials',
                      value: t?.dateTime ?? '15 min before match',
                      valueColor: AppColors.tertiary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightLg,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.onSurface,
                    foregroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    ),
                  ),
                  child: Text(
                    'GOT IT',
                    style: AppTextStyles.buttonLg.copyWith(color: AppColors.surface),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: switch (_status) {
        _ScreenStatus.loading => _buildLoadingState(),
        _ScreenStatus.normal => _buildNormalState(),
        _ScreenStatus.error => _buildErrorState(),
      },
      bottomNavigationBar: _status == _ScreenStatus.normal && _detail != null
          ? _buildBottomCta(_detail!)
          : null,
    );
  }

  // ── Loading ──

  Widget _buildLoadingState() {
    return SafeArea(
      child: Column(
        children: [
          _buildHeaderBar(null),
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.gutter,
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.spaceMd),
                  const BooyahXLoadingSkeleton(
                    width: double.infinity,
                    height: 200,
                    borderRadius: AppDimensions.radiusXl,
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  const BooyahXLoadingSkeleton(width: 200, height: 24),
                  const SizedBox(height: AppDimensions.spaceSm),
                  const BooyahXLoadingSkeleton(width: double.infinity, height: 16),
                  const SizedBox(height: AppDimensions.spaceLg),
                  const BooyahXListSkeleton(itemCount: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error ──

  Widget _buildErrorState() {
    return SafeArea(
      child: Column(
        children: [
          _buildHeaderBar(null),
          Expanded(
            child: BooyahXErrorState(
              title: 'Tournament not found',
              message: 'Unable to load tournament details. Please try again.',
              actionLabel: 'Go Back',
              onAction: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Normal ──

  Widget _buildNormalState() {
    final detail = _detail!;
    final t = detail.tournament;

    return SafeArea(
      child: Column(
        children: [
          _buildHeaderBar(t),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.gutter,
                AppDimensions.spaceSm,
                AppDimensions.gutter,
                AppDimensions.spaceXl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Tournament Overview Card ──
                  _buildOverviewCard(detail),
                  const SizedBox(height: AppDimensions.spaceLg),

                  // ── Segmented Tabs ──
                  _buildTabBar(detail),
                  const SizedBox(height: AppDimensions.spaceMd),

                  // ── Tab Content ──
                  _buildTabContent(detail),

                  // ── Bottom padding for CTA ──
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header Bar ──

  Widget _buildHeaderBar(Tournament? tournament) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.gutter,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppDimensions.topHeaderHeight,
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => context.pop(),
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
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              // Title
              Expanded(
                child: Text(
                  tournament?.name ?? 'Tournament',
                  style: AppTextStyles.titleLg,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              // Wallet
              _WalletPill(balance: 450),
            ],
          ),
        ),
      ),
    );
  }

  // ── Overview Card ──

  Widget _buildOverviewCard(TournamentDetail detail) {
    final t = detail.tournament;
    final filled = t.filledSlots ?? 0;
    final total = t.totalSlots ?? 100;
    final progress = filled / total;
    final remaining = total - filled;
    final percentFull = (progress * 100).toInt();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map banner
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.inverseSurface,
                  AppColors.inverseSurface.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Map image if available
                if (t.imageUrl != null)
                  Positioned.fill(
                    child: Image.network(
                      t.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                // Gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // Top badges
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatusBadge(status: t.status, label: t.statusLabel),
                      if (detail.regionLabel != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.public, size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                detail.regionLabel!,
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // Bottom chips
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Row(
                    children: [
                      _InfoChip(label: 'MAP: ${t.map}'),
                      const SizedBox(width: 8),
                      _InfoChip(label: '${t.mode}${detail.tournamentModeDetail != null ? ' • ${detail.tournamentModeDetail}' : ''}'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Title & info
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mode label
                Text(
                  'Free Fire MAX • ${t.mode}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXs),

                // Tournament name
                Text(
                  t.name,
                  style: AppTextStyles.displayHeroMobile.copyWith(
                    color: AppColors.onSurface,
                    fontSize: 22,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spaceSm),

                // Date & slots left
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 17,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          t.dateTime ?? 'TBA',
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: remaining > 0 ? AppColors.successLight : AppColors.errorLight,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        border: Border.all(
                          color: remaining > 0
                              ? AppColors.success.withValues(alpha: 0.3)
                              : AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            remaining > 0 ? Icons.group : Icons.block,
                            size: 14,
                            color: remaining > 0 ? AppColors.successDark : AppColors.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            remaining > 0 ? '$remaining slots left' : 'Full',
                            style: AppTextStyles.caption.copyWith(
                              color: remaining > 0 ? AppColors.successDark : AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMd),

                // Progress bar
                BooyahXProgressBar(
                  value: progress,
                  progressColor: remaining > 0 ? AppColors.primary : AppColors.error,
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$filled / $total Players',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      '$percentFull% Full',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceLg),

                // Stats matrix
                _buildStatsMatrix(detail),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Matrix ──

  Widget _buildStatsMatrix(TournamentDetail detail) {
    final t = detail.tournament;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          _StatCell(label: 'ENTRY', value: t.entryFee ?? '₹0', valueColor: AppColors.onSurface),
          _statDivider(),
          _StatCell(label: 'PRIZE POOL', value: t.prizePool ?? '₹0', valueColor: AppColors.tertiary),
          _statDivider(),
          _StatCell(label: 'PER KILL', value: detail.perKillAmount ?? t.perKill ?? '₹0', valueColor: AppColors.primary),
          _statDivider(),
          _StatCell(label: 'MODE', value: detail.tournamentModeDetail ?? 'TPP', valueColor: AppColors.onSurface),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceSm),
      color: AppColors.border,
    );
  }

  // ── Tab Bar ──

  Widget _buildTabBar(TournamentDetail detail) {
    final playerCount = detail.players.length;
    final tabs = [
      _TabData(label: 'Prize Pool', icon: Icons.emoji_events),
      _TabData(label: 'Players ($playerCount)', icon: null),
      _TabData(label: 'Rules', icon: null),
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXs),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final isSelected = _selectedTabIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceSm,
                  vertical: AppDimensions.spaceSm,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: isSelected ? Border.all(color: AppColors.border, width: 0.5) : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tab.icon != null) ...[
                      Icon(
                        tab.icon,
                        size: 18,
                        color: isSelected ? AppColors.tertiary : AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: Text(
                        tab.label,
                        style: AppTextStyles.bodySm.copyWith(
                          color: isSelected ? AppColors.onSurface : AppColors.textMuted,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Tab Content ──

  Widget _buildTabContent(TournamentDetail detail) {
    return switch (_selectedTabIndex) {
      0 => _buildPrizePoolTab(detail),
      1 => _buildPlayersTab(detail),
      2 => _buildRulesTab(detail),
      _ => const SizedBox.shrink(),
    };
  }

  // ── Prize Pool Tab ──

  Widget _buildPrizePoolTab(TournamentDetail detail) {
    if (detail.prizeDistribution.isEmpty) {
      return const BooyahXEmptyState(
        icon: Icons.emoji_events_outlined,
        title: 'No prize distribution available',
        subtitle: 'Prize pool details will be announced soon.',
      );
    }

    return Column(
      children: [
        // Kill bounty assurance banner
        if (detail.killBountyLabel != null) ...[
          _KillBountyBanner(detail: detail),
          const SizedBox(height: AppDimensions.spaceMd),
        ],

        // Prize rows
        ...detail.prizeDistribution.map((prize) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
            child: _PrizePoolRow(prize: prize),
          );
        }),
      ],
    );
  }

  // ── Players Tab ──

  Widget _buildPlayersTab(TournamentDetail detail) {
    if (detail.players.isEmpty) {
      return const BooyahXEmptyState(
        icon: Icons.group_outlined,
        title: 'No players have joined yet',
        subtitle: 'Be the first to register for this tournament!',
      );
    }

    return Column(
      children: [
        // Player rows
        ...detail.players.map((player) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
            child: BooyahXPlayerRow(
              rank: player.rank,
              name: player.name,
              subtitle: 'UID: ${player.uid} • Lvl ${player.level}',
              slotLabel: player.slotLabel,
            ),
          );
        }),

        // More players indicator
        if (detail.tournament.filledSlots != null &&
            detail.players.length < (detail.tournament.filledSlots ?? 0))
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.spaceMd),
            child: Text(
              '+ ${(detail.tournament.filledSlots ?? 0) - detail.players.length} more competitors confirmed',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  // ── Rules Tab ──

  Widget _buildRulesTab(TournamentDetail detail) {
    if (detail.rules.isEmpty) {
      return const BooyahXEmptyState(
        icon: Icons.rule_outlined,
        title: 'No rules available',
        subtitle: 'Tournament rules will be published before the match.',
      );
    }

    return Column(
      children: detail.rules.map((rule) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
          child: _RuleCard(rule: rule),
        );
      }).toList(),
    );
  }

  // ── Bottom CTA ──

  Widget _buildBottomCta(TournamentDetail detail) {
    final t = detail.tournament;
    final remaining = t.remainingSlots ?? 0;
    final isJoinable = !_hasJoined &&
        t.status != TournamentStatus.full &&
        t.status != TournamentStatus.live &&
        t.status != TournamentStatus.completed &&
        t.status != TournamentStatus.cancelled;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.gutter,
            AppDimensions.spaceMd,
            AppDimensions.gutter,
            AppDimensions.spaceSm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fee summary row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ENTRY PRICE',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 0.04,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            t.entryFee ?? '₹0',
                            style: AppTextStyles.displayHeroMobile.copyWith(
                              color: AppColors.onSurface,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            remaining > 0 ? '${t.mode.split(' ').first.toUpperCase()} SLOT' : 'FULL',
                            style: AppTextStyles.caption.copyWith(
                              color: remaining > 0 ? AppColors.primary : AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Wallet badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceMd,
                      vertical: AppDimensions.spaceSm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Wallet: ',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        Text(
                          '₹450',
                          style: AppTextStyles.labelNumeric.copyWith(
                            color: AppColors.onSurface,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(Sufficient)',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.successDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // CTA Button
              if (_hasJoined)
                _buildJoinedButton()
              else if (!isJoinable)
                _buildDisabledButton(t)
              else
                BooyahXButton(
                  label: 'Join Tournament (${t.entryFee ?? '₹0'})',
                  onPressed: _onJoinTap,
                  icon: Icons.sports_esports,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJoinedButton() {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeightLg,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successLight,
          foregroundColor: AppColors.successDark,
          disabledBackgroundColor: AppColors.successLight,
          disabledForegroundColor: AppColors.successDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified, size: 20, color: AppColors.successDark),
            const SizedBox(width: AppDimensions.spaceSm),
            Text(
              'JOINED',
              style: AppTextStyles.buttonLg.copyWith(color: AppColors.successDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledButton(Tournament t) {
    String label;
    switch (t.status) {
      case TournamentStatus.full:
        label = 'TOURNAMENT FULL';
      case TournamentStatus.live:
        label = 'TOURNAMENT LIVE';
      case TournamentStatus.completed:
        label = 'TOURNAMENT COMPLETED';
      case TournamentStatus.cancelled:
        label = 'TOURNAMENT CANCELLED';
      default:
        label = 'UNAVAILABLE';
    }

    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeightLg,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceContainerHigh,
          foregroundColor: AppColors.textMuted,
          disabledBackgroundColor: AppColors.surfaceContainerHigh,
          disabledForegroundColor: AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonLg.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}

enum _ScreenStatus { loading, normal, error }

class _TabData {
  final String label;
  final IconData? icon;
  const _TabData({required this.label, this.icon});
}

// ══════════════════════════════════════════════════════════
// Private Sub-Widgets
// ══════════════════════════════════════════════════════════

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

class _StatusBadge extends StatelessWidget {
  final TournamentStatus status;
  final String? label;
  const _StatusBadge({required this.status, this.label});

  @override
  Widget build(BuildContext context) {
    final variant = switch (status) {
      TournamentStatus.open => BadgeVariant.open,
      TournamentStatus.registrationOpen => BadgeVariant.registered,
      TournamentStatus.almostFull => BadgeVariant.almostFull,
      TournamentStatus.closingSoon => BadgeVariant.closingSoon,
      TournamentStatus.full => BadgeVariant.failed,
      TournamentStatus.live => BadgeVariant.live,
      TournamentStatus.completed => BadgeVariant.completed,
      TournamentStatus.cancelled => BadgeVariant.failed,
    };

    final defaultLabel = switch (status) {
      TournamentStatus.open => 'Open',
      TournamentStatus.registrationOpen => 'Registration Open',
      TournamentStatus.almostFull => 'Almost Full',
      TournamentStatus.closingSoon => 'Closing Soon',
      TournamentStatus.full => 'Full',
      TournamentStatus.live => 'Live',
      TournamentStatus.completed => 'Completed',
      TournamentStatus.cancelled => 'Cancelled',
    };

    return BooyahXStatusBadge(
      variant: variant,
      label: label ?? defaultLabel,
      showDot: status == TournamentStatus.live || status == TournamentStatus.registrationOpen,
      animate: status == TournamentStatus.live,
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.labelCaps.copyWith(
          color: AppColors.onSurface,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _StatCell({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: label == 'PRIZE POOL'
                  ? AppColors.tertiary
                  : label == 'PER KILL'
                      ? AppColors.primary
                      : AppColors.textMuted,
              fontSize: 9,
              letterSpacing: 0.04,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.labelNumeric.copyWith(
                color: valueColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrizePoolRow extends StatelessWidget {
  final PrizeDistribution prize;
  const _PrizePoolRow({required this.prize});

  @override
  Widget build(BuildContext context) {
    final isChampion = prize.isHighlighted;
    final rankText = prize.rankRange ?? (prize.rank != null ? '#${prize.rank}' : '');

    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isChampion ? AppColors.tertiary.withValues(alpha: 0.4) : AppColors.border,
          width: isChampion ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank indicator
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isChampion ? AppColors.tertiaryFixed : AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: isChampion
                    ? AppColors.tertiary.withValues(alpha: 0.3)
                    : AppColors.border,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isChampion ? Icons.emoji_events : Icons.workspace_premium,
                  size: 18,
                  color: isChampion ? AppColors.tertiary : AppColors.onSurfaceVariant,
                ),
                Text(
                  rankText.toUpperCase(),
                  style: AppTextStyles.labelCaps.copyWith(
                    color: isChampion ? AppColors.tertiary : AppColors.onSurfaceVariant,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),

          // Title & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prize.title,
                  style: AppTextStyles.titleSm.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: isChampion ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
                if (prize.subtitle != null)
                  Text(
                    prize.subtitle!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    prize.amount,
                    style: AppTextStyles.labelNumeric.copyWith(
                      color: AppColors.onSurface,
                      fontSize: isChampion ? 18 : 16,
                    ),
                  ),
                  if (prize.amountEach != null)
                    Text(
                      ' each',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
              if (prize.percentage != null)
                Text(
                  prize.percentage!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KillBountyBanner extends StatelessWidget {
  final TournamentDetail detail;
  const _KillBountyBanner({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryFixed.withValues(alpha: 0.4),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: const Icon(Icons.bolt, size: 22, color: Colors.white),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.killBountyLabel ?? 'Kill Bounty',
                  style: AppTextStyles.titleSm.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail.killBountyDescription ?? '',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  maxLines: 3,
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

class _RuleCard extends StatelessWidget {
  final TournamentRule rule;
  const _RuleCard({required this.rule});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${rule.number}. ${rule.title}',
            style: AppTextStyles.titleSm.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          Text(
            rule.description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _DialogInfoRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.bodySm.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
