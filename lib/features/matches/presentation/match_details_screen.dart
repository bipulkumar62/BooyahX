import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/core/constants/app_routes.dart';
import 'package:booyahx/core/models/match.dart';
import 'package:booyahx/core/data/mock_matches.dart';
import 'package:booyahx/shared/widgets/widgets.dart';

/// BooyahX — Match Details Screen
///
/// Full match info: tournament info, countdown, room status, and result.
/// Receives a match ID from the route and loads mock data.
class MatchDetailsScreen extends StatefulWidget {
  final String matchId;

  const MatchDetailsScreen({super.key, required this.matchId});

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  _ScreenStatus _status = _ScreenStatus.loading;
  MatchData? _match;

  @override
  void initState() {
    super.initState();
    _loadMatch();
  }

  Future<void> _loadMatch() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final match = MockMatchData.byId(widget.matchId);
    if (match == null) {
      setState(() => _status = _ScreenStatus.error);
      return;
    }

    setState(() {
      _match = match;
      _status = _ScreenStatus.normal;
    });
  }

  void _onViewRoom() {
    final match = _match;
    if (match == null) return;
    context.pushNamed(
      AppRoutes.roomDetails,
      pathParameters: {'matchId': match.id},
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
    );
  }

  // ── Loading ──

  Widget _buildLoadingState() {
    return SafeArea(
      child: Column(
        children: [
          _buildHeaderBar(null),
          const Expanded(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.gutter),
              child: Column(
                children: [
                  SizedBox(height: AppDimensions.spaceMd),
                  BooyahXLoadingSkeleton(width: double.infinity, height: 200),
                  SizedBox(height: AppDimensions.spaceLg),
                  BooyahXLoadingSkeleton(width: 200, height: 24),
                  SizedBox(height: AppDimensions.spaceSm),
                  BooyahXLoadingSkeleton(width: double.infinity, height: 16),
                  SizedBox(height: AppDimensions.spaceLg),
                  BooyahXListSkeleton(itemCount: 3),
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
              title: 'Match not found',
              message: 'Unable to load match details.',
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
    final match = _match!;
    final isUpcoming = match.status == MatchStatus.upcoming;
    final isLive = match.status == MatchStatus.live;
    final isCompleted = match.status == MatchStatus.completed;
    final isResultPending = match.status == MatchStatus.resultPending;

    return SafeArea(
      child: Column(
        children: [
          _buildHeaderBar(match),
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
                  // ── Match Overview Card ──
                  _buildOverviewCard(match),
                  const SizedBox(height: AppDimensions.spaceLg),

                  // ── Countdown (upcoming only) ──
                  if (isUpcoming && match.timeUntilMatch != null && !match.timeUntilMatch!.isNegative) ...[
                    _buildCountdownSection(match),
                    const SizedBox(height: AppDimensions.spaceLg),
                  ],

                  // ── Live indicator ──
                  if (isLive) ...[
                    _buildLiveIndicator(),
                    const SizedBox(height: AppDimensions.spaceLg),
                  ],

                  // ── Result Card (completed) ──
                  if (isCompleted && match.result != null) ...[
                    _buildResultCard(match),
                    const SizedBox(height: AppDimensions.spaceLg),
                  ],

                  // ── Result Pending ──
                  if (isResultPending) ...[
                    _buildResultPendingCard(),
                    const SizedBox(height: AppDimensions.spaceLg),
                  ],

                  // ── Room Section (upcoming/live with room released) ──
                  if ((isUpcoming || isLive) && match.roomCredentials != null) ...[
                    _buildRoomSection(match),
                    const SizedBox(height: AppDimensions.spaceLg),
                  ],

                  // ── Instructions ──
                  _buildInstructions(match),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header Bar ──

  Widget _buildHeaderBar(MatchData? match) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.gutter),
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
              Expanded(
                child: Text(
                  match?.tournamentName ?? 'Match Details',
                  style: AppTextStyles.titleLg,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Overview Card ──

  Widget _buildOverviewCard(MatchData match) {
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
          _buildBanner(match),
          // Title & info
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mode
                Text(
                  'Free Fire MAX • ${match.mode}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXs),
                // Name
                Text(
                  match.tournamentName,
                  style: AppTextStyles.displayHeroMobile.copyWith(
                    color: AppColors.onSurface,
                    fontSize: 22,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                // Date & slot
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 17, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(
                          _formatDateTime(match.matchDateTime),
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (match.slotNumber != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          match.slotNumber!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                // Stats matrix
                _buildStatsRow(match),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Banner ──

  Widget _buildBanner(MatchData match) {
    return Container(
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
          if (match.imageUrl != null)
            Positioned.fill(
              child: Image.network(
                match.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
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
          // Status badge
          Positioned(
            top: 12,
            left: 12,
            child: _MatchStatusBadge(status: match.status, label: match.statusLabel),
          ),
          // Chips
          Positioned(
            bottom: 12,
            left: 12,
            child: Row(
              children: [
                _InfoChip(label: 'MAP: ${match.map}'),
                const SizedBox(width: 8),
                _InfoChip(label: match.mode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ──

  Widget _buildStatsRow(MatchData match) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          _StatCell(label: 'ENTRY', value: match.entryFee, valueColor: AppColors.onSurface),
          _divider(),
          _StatCell(label: 'PRIZE POOL', value: match.prizePool, valueColor: AppColors.tertiary),
          _divider(),
          _StatCell(
            label: 'STATUS',
            value: match.statusLabel ?? 'Unknown',
            valueColor: match.status == MatchStatus.live
                ? AppColors.error
                : match.status == MatchStatus.completed
                    ? AppColors.success
                    : AppColors.onSurface,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceSm),
      color: AppColors.border,
    );
  }

  // ── Countdown Section ──

  Widget _buildCountdownSection(MatchData match) {
    final remaining = match.timeUntilMatch!;
    final h = remaining.inHours;
    final m = remaining.inMinutes % 60;
    final s = remaining.inSeconds % 60;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryFixed.withValues(alpha: 0.3),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            'MATCH STARTS IN',
            style: AppTextStyles.labelCaps.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CountdownDigit(value: h, label: 'HRS'),
              const SizedBox(width: AppDimensions.spaceSm),
              Text(
                ':',
                style: AppTextStyles.displayHeroMobile.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 28,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              _CountdownDigit(value: m, label: 'MIN'),
              const SizedBox(width: AppDimensions.spaceSm),
              Text(
                ':',
                style: AppTextStyles.displayHeroMobile.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 28,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              _CountdownDigit(value: s, label: 'SEC'),
            ],
          ),
        ],
      ),
    );
  }

  // ── Live Indicator ──

  Widget _buildLiveIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _AnimatedLiveDot(),
          const SizedBox(width: AppDimensions.spaceSm),
          Text(
            'MATCH IN PROGRESS',
            style: AppTextStyles.buttonLg.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  // ── Result Card ──

  Widget _buildResultCard(MatchData match) {
    final result = match.result!;
    final isBooyah = result.position == 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(
          color: isBooyah
              ? AppColors.tertiary.withValues(alpha: 0.4)
              : AppColors.border,
          width: isBooyah ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Position
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isBooyah ? AppColors.tertiaryFixed : AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
              border: Border.all(
                color: isBooyah
                    ? AppColors.tertiary.withValues(alpha: 0.3)
                    : AppColors.border,
              ),
            ),
            child: Icon(
              isBooyah ? Icons.emoji_events : Icons.workspace_premium,
              size: 28,
              color: isBooyah ? AppColors.tertiary : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            result.resultLabel ?? 'Match Finished',
            style: AppTextStyles.headlineSm.copyWith(
              color: isBooyah ? AppColors.tertiary : AppColors.onSurface,
            ),
          ),
          if (result.position != null) ...[
            const SizedBox(height: 2),
            Text(
              '#${result.position} Place',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
            ),
          ],
          const SizedBox(height: AppDimensions.spaceLg),
          // Stats row
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            child: Row(
              children: [
                _StatCell(label: 'KILLS', value: '${result.kills ?? 0}', valueColor: AppColors.onSurface),
                _divider(),
                _StatCell(label: 'POINTS', value: '${result.points ?? 0}', valueColor: AppColors.primary),
                _divider(),
                _StatCell(label: 'WINNINGS', value: result.winnings ?? '₹0', valueColor: AppColors.tertiary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Result Pending Card ──

  Widget _buildResultPendingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.hourglass_top,
              size: 28,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            'Result Pending',
            style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 2),
          Text(
            'Results will be announced after anti-cheat validation.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Room Section ──

  Widget _buildRoomSection(MatchData match) {
    final isLocked = match.isRoomLocked;
    final releaseTime = match.roomCredentials?.releaseTime;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLocked ? Icons.lock : Icons.vpn_key,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: Text(
                  'ROOM DETAILS',
                  style: AppTextStyles.labelCaps.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 0.04,
                  ),
                ),
              ),
              if (!isLocked)
                GestureDetector(
                  onTap: _onViewRoom,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceMd,
                      vertical: AppDimensions.spaceXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Text(
                      'VIEW ALL',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          if (isLocked) ...[
            Text(
              'Room details are locked',
              style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              'Room ID and password will be available before the match.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
            if (releaseTime != null) ...[
              const SizedBox(height: AppDimensions.spaceMd),
              Text(
                'ROOM OPENS IN',
                style: AppTextStyles.labelCaps.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 0.08,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              BooyahXCountdown(
                duration: releaseTime.difference(DateTime.now()),
                label: '',
                onFinished: () {
                  // In a real app, this would refresh the room state
                },
              ),
            ],
          ] else ...[
            // Room credentials preview
            Row(
              children: [
                _RoomPreview(label: 'ROOM ID', value: match.roomCredentials?.roomId ?? '—'),
                const SizedBox(width: AppDimensions.spaceMd),
                _RoomPreview(label: 'PASSWORD', value: match.roomCredentials?.roomPassword ?? '—'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Instructions ──

  Widget _buildInstructions(MatchData match) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INSTRUCTIONS',
            style: AppTextStyles.labelCaps.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0.04,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          _InstructionItem(
            number: 1,
            text: 'Join only when room details are released.',
          ),
          _InstructionItem(
            number: 2,
            text: 'Use the registered Free Fire account.',
          ),
          _InstructionItem(
            number: 3,
            text: 'Follow tournament rules strictly.',
          ),
          _InstructionItem(
            number: 4,
            text: 'Screen recording / POV requirements must be followed when applicable.',
          ),
        ],
      ),
    );
  }

  // ── Helpers ──

  String _formatDateTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final mm = dt.minute.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final month = _monthName(dt.month);
    return '$day $month • $hour:$mm $amPm IST';
  }

  String _monthName(int m) {
    const names = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[m];
  }
}

enum _ScreenStatus { loading, normal, error }

// ══════════════════════════════════════════════════════════
// Private Sub-Widgets
// ══════════════════════════════════════════════════════════

class _MatchStatusBadge extends StatelessWidget {
  final MatchStatus status;
  final String? label;
  const _MatchStatusBadge({required this.status, this.label});

  @override
  Widget build(BuildContext context) {
    final variant = switch (status) {
      MatchStatus.upcoming => BadgeVariant.upcoming,
      MatchStatus.live => BadgeVariant.live,
      MatchStatus.completed => BadgeVariant.completed,
      MatchStatus.cancelled => BadgeVariant.failed,
      MatchStatus.resultPending => BadgeVariant.pending,
    };
    final defaultLabel = switch (status) {
      MatchStatus.upcoming => 'Upcoming',
      MatchStatus.live => 'Live',
      MatchStatus.completed => 'Completed',
      MatchStatus.cancelled => 'Cancelled',
      MatchStatus.resultPending => 'Result Pending',
    };
    return BooyahXStatusBadge(
      variant: variant,
      label: label ?? defaultLabel,
      showDot: status == MatchStatus.live,
      animate: status == MatchStatus.live,
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
    final labelColor = label == 'PRIZE POOL'
        ? AppColors.tertiary
        : label == 'WINNINGS'
            ? AppColors.tertiary
            : AppColors.textMuted;

    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: labelColor,
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

class _CountdownDigit extends StatelessWidget {
  final int value;
  final String label;
  const _CountdownDigit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.onSurface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          alignment: Alignment.center,
          child: Text(
            value.toString().padLeft(2, '0'),
            style: AppTextStyles.displayHeroMobile.copyWith(
              color: AppColors.surface,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.labelCaps.copyWith(
            color: AppColors.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _AnimatedLiveDot extends StatefulWidget {
  @override
  State<_AnimatedLiveDot> createState() => _AnimatedLiveDotState();
}

class _AnimatedLiveDotState extends State<_AnimatedLiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, _) => Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: _animation.value),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _RoomPreview extends StatelessWidget {
  final String label;
  final String value;
  const _RoomPreview({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceSm),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 9,
                letterSpacing: 0.04,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTextStyles.labelNumeric.copyWith(
                color: AppColors.onSurface,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final int number;
  final String text;
  const _InstructionItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
