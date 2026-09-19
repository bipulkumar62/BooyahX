import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/shared/widgets/status/booyahx_status_badge.dart';

enum MatchState { upcoming, live, played }

class BooyahXMatchCard extends StatelessWidget {
  final String name;
  final String mode;
  final String map;
  final String? dateTime;
  final String? matchId;
  final String? slotNumber;
  final String? entryFee;
  final String? entryFeeStatus;
  final String? prizePool;
  final String? teammate;
  final MatchState state;
  final String? roomStatus;
  final String? countdownText;
  final String? livePhase;
  final String? aliveCount;
  final String? matchTime;
  final String? imageUrl;
  final String? ctaLabel;
  final VoidCallback? onTap;
  final VoidCallback? onCta;
  final bool isRegistered;

  const BooyahXMatchCard({
    super.key,
    required this.name,
    required this.mode,
    required this.map,
    this.dateTime,
    this.matchId,
    this.slotNumber,
    this.entryFee,
    this.entryFeeStatus,
    this.prizePool,
    this.teammate,
    this.state = MatchState.upcoming,
    this.roomStatus,
    this.countdownText,
    this.livePhase,
    this.aliveCount,
    this.matchTime,
    this.imageUrl,
    this.ctaLabel,
    this.onTap,
    this.onCta,
    this.isRegistered = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: state == MatchState.live ? AppColors.liveRed.withValues(alpha: 0.3) : AppColors.border,
            width: state == MatchState.live ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageHeader(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    return Stack(
      children: [
        Container(
          height: AppDimensions.thumbnailHeightSm,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageUrl == null
              ? const Center(
                  child: Icon(Icons.image, color: AppColors.textLight, size: 28),
                )
              : null,
        ),
        // Gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ),
        // Top badges
        Positioned(
          top: AppDimensions.spaceSm,
          left: AppDimensions.spaceSm,
          child: Row(
            children: [
              _ImageBadge(text: mode, color: _modeColor),
              const SizedBox(width: 4),
              _ImageBadge(text: map, color: AppColors.onSurfaceVariant, icon: _mapIcon),
            ],
          ),
        ),
        // Registered badge
        if (isRegistered)
          Positioned(
            top: AppDimensions.spaceSm,
            right: AppDimensions.spaceSm,
            child: BooyahXStatusBadge(
              variant: BadgeVariant.registered,
              label: 'REGISTERED',
            ),
          ),
        // Live indicator
        if (state == MatchState.live)
          Positioned(
            top: AppDimensions.spaceSm,
            right: AppDimensions.spaceSm,
            child: BooyahXStatusBadge(
              variant: BadgeVariant.live,
              label: 'LIVE NOW',
              showDot: true,
              animate: true,
            ),
          ),
        // Date/time
        if (dateTime != null)
          Positioned(
            bottom: AppDimensions.spaceSm,
            left: AppDimensions.spaceSm,
            child: Row(
              children: [
                Icon(
                  state == MatchState.live ? Icons.radio_button_checked : Icons.schedule,
                  size: 12,
                  color: state == MatchState.live ? AppColors.liveRed : AppColors.primaryLight,
                ),
                const SizedBox(width: 4),
                Text(
                  dateTime!,
                  style: AppTextStyles.bodySm.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + teammate
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (matchId != null || slotNumber != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        [
                          if (matchId != null) 'Match ID: $matchId',
                          if (slotNumber != null) 'Slot: #$slotNumber',
                        ].join(' • '),
                        style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ],
                ),
              ),
              if (prizePool != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Prize', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
                    Text(
                      prizePool!,
                      style: AppTextStyles.labelNumeric.copyWith(color: AppColors.onSurface, fontSize: 14),
                    ),
                  ],
                ),
            ],
          ),

          if (teammate != null) ...[
            const SizedBox(height: AppDimensions.spaceSm),
            Row(
              children: [
                const Icon(Icons.group, size: 16, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text('Teammate: ', style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'IGN: $teammate',
                    style: AppTextStyles.labelNumeric.copyWith(
                      color: AppColors.onSurface,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Stats row
          if (entryFee != null || prizePool != null) ...[
            const SizedBox(height: AppDimensions.spaceMd),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceSm),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  if (entryFee != null)
                    Expanded(
                      child: _StatCell(
                        label: 'ENTRY FEE',
                        value: entryFee!,
                        suffix: entryFeeStatus,
                        valueColor: AppColors.onSurface,
                      ),
                    ),
                  if (prizePool != null)
                    Expanded(
                      child: _StatCell(
                        label: 'PRIZE POOL',
                        value: prizePool!,
                        valueColor: AppColors.tertiary,
                        icon: Icons.emoji_events,
                        iconColor: AppColors.tertiary,
                      ),
                    ),
                ],
              ),
            ),
          ],

          // Room status (for upcoming)
          if (roomStatus != null) ...[
            const SizedBox(height: AppDimensions.spaceMd),
            _RoomStatusBox(status: roomStatus!, countdown: countdownText),
          ],

          // Live match info
          if (state == MatchState.live && livePhase != null) ...[
            const SizedBox(height: AppDimensions.spaceMd),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceSm),
              decoration: BoxDecoration(
                color: AppColors.liveRedBg,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.liveRed.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: AppColors.liveRed),
                  const SizedBox(width: 8),
                  Text(
                    '$livePhase',
                    style: AppTextStyles.caption.copyWith(color: AppColors.liveRed),
                  ),
                  if (aliveCount != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      'Alive: $aliveCount',
                      style: AppTextStyles.caption.copyWith(color: AppColors.onSurface),
                    ),
                  ],
                  if (matchTime != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      matchTime!,
                      style: AppTextStyles.labelNumeric.copyWith(
                        color: AppColors.onSurface,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // CTA
          const SizedBox(height: AppDimensions.spaceMd),
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeightMd,
            child: OutlinedButton(
              onPressed: onCta,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onSurface,
                side: const BorderSide(color: AppColors.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (ctaLabel ?? _defaultCta).toUpperCase(),
                    style: AppTextStyles.buttonSm.copyWith(color: AppColors.onSurface),
                  ),
                  const SizedBox(width: 6),
                  Icon(_ctaIcon, size: 16, color: AppColors.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _defaultCta => switch (state) {
    MatchState.upcoming => 'ROOM DETAILS',
    MatchState.live => 'SPECTATE STREAM',
    MatchState.played => 'VIEW RESULTS',
  };

  IconData get _ctaIcon => switch (state) {
    MatchState.upcoming => Icons.vpn_key,
    MatchState.live => Icons.play_circle,
    MatchState.played => Icons.scoreboard,
  };

  Color get _modeColor => mode.contains('DUO')
      ? AppColors.secondary
      : mode.contains('PER KILL')
          ? AppColors.tertiary
          : AppColors.primary;

  IconData get _mapIcon => map.toLowerCase().contains('bermuda')
      ? Icons.map
      : map.toLowerCase().contains('kalahari')
          ? Icons.landscape
          : Icons.explore;
}

class _ImageBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const _ImageBadge({required this.text, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            text.toUpperCase(),
            style: AppTextStyles.labelCaps.copyWith(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;
  final Color? valueColor;
  final IconData? icon;
  final Color? iconColor;

  const _StatCell({
    required this.label,
    required this.value,
    this.suffix,
    this.valueColor,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 9),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: iconColor),
              const SizedBox(width: 3),
            ],
            Text(
              value,
              style: AppTextStyles.labelNumeric.copyWith(
                color: valueColor ?? AppColors.onSurface,
                fontSize: 14,
              ),
            ),
            if (suffix != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Text(
                  suffix!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _RoomStatusBox extends StatelessWidget {
  final String status;
  final String? countdown;
  const _RoomStatusBox({required this.status, this.countdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock, size: 18, color: AppColors.primary),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room ID & Password Protected',
                  style: AppTextStyles.titleSm.copyWith(color: AppColors.onSurface),
                ),
                Text(
                  status,
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          if (countdown != null)
            Text(
              countdown!,
              style: AppTextStyles.labelNumeric.copyWith(
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }
}
