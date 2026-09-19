import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/core/constants/app_routes.dart';
import 'package:booyahx/core/models/match.dart';
import 'package:booyahx/core/data/mock_matches.dart';
import 'package:booyahx/shared/widgets/widgets.dart';

/// BooyahX — My Matches Screen
///
/// Three-tab view: Upcoming, Live, Played.
/// Each tab shows match cards that navigate to Match Details.
class MyMatchesScreen extends StatefulWidget {
  const MyMatchesScreen({super.key});

  @override
  State<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> {
  _ScreenStatus _status = _ScreenStatus.loading;
  int _selectedTab = 0;

  List<MatchData> _upcoming = [];
  List<MatchData> _live = [];
  List<MatchData> _played = [];

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      _upcoming = MockMatchData.upcoming;
      _live = MockMatchData.live;
      _played = MockMatchData.played;
      _status = _ScreenStatus.normal;
    });
  }

  void _onMatchTap(String matchId) {
    context.pushNamed(
      AppRoutes.matchDetail,
      pathParameters: {'id': matchId},
    );
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            _buildHeader(),
            // ── Segmented Tabs ──
            _buildTabBar(),
            // ── Content ──
            Expanded(
              child: _status == _ScreenStatus.loading
                  ? _buildLoadingState()
                  : _status == _ScreenStatus.error
                      ? _buildErrorState()
                      : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──

  Widget _buildHeader() {
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
            children: const [
              Expanded(
                child: Text(
                  'MY MATCHES',
                  style: AppTextStyles.titleLg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Tab Bar ──

  Widget _buildTabBar() {
    final tabs = [
      'Upcoming (${_upcoming.length})',
      'Live (${_live.length})',
      'Played (${_played.length})',
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXs),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceSm,
                  vertical: AppDimensions.spaceSm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: isSelected
                      ? null
                      : Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Text(
                  tabs[index],
                  style: AppTextStyles.bodySm.copyWith(
                    color: isSelected ? AppColors.onPrimary : AppColors.textMuted,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Content ──

  Widget _buildContent() {
    final matches = _selectedTab == 0
        ? _upcoming
        : _selectedTab == 1
            ? _live
            : _played;

    if (matches.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadMatches,
      color: AppColors.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.gutter,
          AppDimensions.spaceMd,
          AppDimensions.gutter,
          AppDimensions.spaceXl,
        ),
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          final state = match.status == MatchStatus.live
              ? MatchState.live
              : match.status == MatchStatus.upcoming
                  ? MatchState.upcoming
                  : MatchState.played;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
            child: BooyahXMatchCard(
              name: match.tournamentName,
              mode: match.mode,
              map: match.map,
              dateTime: _formatDateTime(match.matchDateTime),
              entryFee: match.entryFee,
              prizePool: match.prizePool,
              state: state,
              slotNumber: match.slotNumber,
              roomStatus: _roomStatusLabel(match),
              countdownText: _countdownText(match),
              ctaLabel: state == MatchState.upcoming ? 'VIEW MATCH' : null,
              isRegistered: match.playerStatus == 'Registered' ||
                  match.playerStatus == 'In Match',
              onTap: () => _onMatchTap(match.id),
              onCta: () => _onMatchTap(match.id),
            ),
          );
        },
      ),
    );
  }

  // ── Empty State ──

  Widget _buildEmptyState() {
    final labels = ['No upcoming matches', 'No live matches', 'No played matches'];
    final icons = [
      Icons.event_outlined,
      Icons.play_circle_outline,
      Icons.history,
    ];
    return BooyahXEmptyState(
      icon: icons[_selectedTab],
      title: labels[_selectedTab],
      subtitle: 'Check back later for new matches.',
    );
  }

  // ── Loading ──

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.gutter),
      child: BooyahXListSkeleton(itemCount: 4),
    );
  }

  // ── Error ──

  Widget _buildErrorState() {
    return BooyahXErrorState(
      title: 'Unable to load matches',
      message: 'Something went wrong. Please try again.',
      actionLabel: 'Try Again',
      onAction: () {
        setState(() => _status = _ScreenStatus.loading);
        _loadMatches();
      },
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

  String? _roomStatusLabel(MatchData match) {
    if (match.status == MatchStatus.completed ||
        match.status == MatchStatus.cancelled) {
      return null;
    }
    if (match.isRoomLocked) return '🔒 Room locked';
    return '🔑 Room available';
  }

  String? _countdownText(MatchData match) {
    if (match.status != MatchStatus.upcoming) return null;
    final remaining = match.timeUntilMatch;
    if (remaining == null || remaining.isNegative) return null;
    final h = remaining.inHours;
    final m = remaining.inMinutes % 60;
    final s = remaining.inSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

enum _ScreenStatus { loading, normal, error }
