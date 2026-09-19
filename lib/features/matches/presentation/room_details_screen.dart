import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/core/models/match.dart';
import 'package:booyahx/core/data/mock_matches.dart';
import 'package:booyahx/shared/widgets/widgets.dart';

/// BooyahX — Room Details Screen
///
/// Shows room ID/password with lock/release states and copy functionality.
/// Receives a match ID from the route and loads mock data.
class RoomDetailsScreen extends StatefulWidget {
  final String matchId;

  const RoomDetailsScreen({super.key, required this.matchId});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  _ScreenStatus _status = _ScreenStatus.loading;
  MatchData? _match;
  String? _copiedField; // 'id' or 'password' — briefly shown

  @override
  void initState() {
    super.initState();
    _loadRoom();
  }

  Future<void> _loadRoom() async {
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

  void _copyToClipboard(String text, String field) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copiedField = field);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedField = null);
    });
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
          _buildHeaderBar(),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.gutter),
              child: BooyahXListSkeleton(itemCount: 3),
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
          _buildHeaderBar(),
          Expanded(
            child: BooyahXErrorState(
              title: 'Room not found',
              message: 'Unable to load room details.',
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
    final isLocked = match.isRoomLocked;
    final room = match.roomCredentials;

    return SafeArea(
      child: Column(
        children: [
          _buildHeaderBar(),
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
                  // ── Match Summary Card ──
                  _buildMatchSummary(match),
                  const SizedBox(height: AppDimensions.spaceLg),

                  // ── Room Credentials Section ──
                  if (isLocked)
                    _buildLockedSection(match)
                  else if (room != null)
                    _buildAvailableSection(room),

                  const SizedBox(height: AppDimensions.spaceLg),

                  // ── Instructions ──
                  _buildInstructions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──

  Widget _buildHeaderBar() {
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
                  'ROOM DETAILS',
                  style: AppTextStyles.titleLg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Match Summary ──

  Widget _buildMatchSummary(MatchData match) {
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
          // Match name
          Text(
            match.tournamentName,
            style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          // Tags row
          Row(
            children: [
              _Tag(label: match.mode),
              const SizedBox(width: 8),
              _Tag(label: match.map),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          // Info row
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                _formatDateTime(match.matchDateTime),
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (match.slotNumber != null)
                Text(
                  match.slotNumber!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Locked Section ──

  Widget _buildLockedSection(MatchData match) {
    final releaseTime = match.roomCredentials?.releaseTime;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceXl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          // Lock icon
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline,
              size: 32,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            'Room details are locked',
            style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            'Room ID and password will be available before the match.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
          if (releaseTime != null) ...[
            const SizedBox(height: AppDimensions.spaceLg),
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
                // In a real app, refresh the room state
                if (mounted) _loadRoom();
              },
            ),
          ],
        ],
      ),
    );
  }

  // ── Available Section ──

  Widget _buildAvailableSection(RoomCredentials room) {
    return Column(
      children: [
        // Room ID card
        _CredentialCard(
          label: 'ROOM ID',
          value: room.roomId,
          icon: Icons.dialpad,
          isCopied: _copiedField == 'id',
          onCopy: () => _copyToClipboard(room.roomId, 'id'),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        // Password card
        _CredentialCard(
          label: 'ROOM PASSWORD',
          value: room.roomPassword,
          icon: Icons.vpn_key,
          isCopied: _copiedField == 'password',
          onCopy: () => _copyToClipboard(room.roomPassword, 'password'),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        // Copy both
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              final text = 'ID: ${room.roomId} | Password: ${room.roomPassword}';
              _copyToClipboard(text, 'both');
            },
            icon: const Icon(Icons.content_copy, size: 16),
            label: Text(
              _copiedField == 'both' ? 'COPIED!' : 'COPY BOTH',
              style: AppTextStyles.buttonLg.copyWith(
                color: _copiedField == 'both' ? AppColors.success : AppColors.onSurface,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: _copiedField == 'both' ? AppColors.success : AppColors.onSurface,
              side: BorderSide(
                color: _copiedField == 'both' ? AppColors.success : AppColors.outline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceMd),
            ),
          ),
        ),
      ],
    );
  }

  // ── Instructions ──

  Widget _buildInstructions() {
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
            'IMPORTANT',
            style: AppTextStyles.labelCaps.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0.04,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          _InstructionItem(
            number: 1,
            text: 'Join the room only after credentials are released.',
          ),
          _InstructionItem(
            number: 2,
            text: 'Use the same Free Fire account registered on BooyahX.',
          ),
          _InstructionItem(
            number: 3,
            text: 'Do not share room credentials with anyone.',
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

class _CredentialCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isCopied;
  final VoidCallback onCopy;

  const _CredentialCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.isCopied,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(
          color: isCopied ? AppColors.success : AppColors.border,
          width: isCopied ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 0.04,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          // Value + Copy
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.displayHeroMobile.copyWith(
                    color: AppColors.onSurface,
                    fontSize: 24,
                    letterSpacing: 0.04,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onCopy,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceMd,
                    vertical: AppDimensions.spaceSm,
                  ),
                  decoration: BoxDecoration(
                    color: isCopied ? AppColors.successLight : AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    border: Border.all(
                      color: isCopied ? AppColors.success : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCopied ? Icons.check : Icons.content_copy,
                        size: 16,
                        color: isCopied ? AppColors.success : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isCopied ? 'Copied' : 'Copy',
                        style: AppTextStyles.caption.copyWith(
                          color: isCopied ? AppColors.success : AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w600,
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
