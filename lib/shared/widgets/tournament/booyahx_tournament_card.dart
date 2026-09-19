import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/shared/widgets/status/booyahx_status_badge.dart';
import 'package:booyahx/core/models/tournament.dart' show TournamentStatus;

class BooyahXTournamentCard extends StatelessWidget {
  final String name;
  final String? description;
  final String mode;
  final String map;
  final String? dateTime;
  final String? prizePool;
  final String? perKill;
  final String? entryFee;
  final int? totalSlots;
  final int? filledSlots;
  final TournamentStatus status;
  final String? statusLabel;
  final String? imageUrl;
  final String? ctaLabel;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final bool showImage;

  const BooyahXTournamentCard({
    super.key,
    required this.name,
    this.description,
    required this.mode,
    required this.map,
    this.dateTime,
    this.prizePool,
    this.perKill,
    this.entryFee,
    this.totalSlots,
    this.filledSlots,
    this.status = TournamentStatus.open,
    this.statusLabel,
    this.imageUrl,
    this.ctaLabel,
    this.onTap,
    this.onJoin,
    this.showImage = true,
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
          border: Border.all(color: AppColors.border, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showImage) _buildImageHeader(),
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
          height: AppDimensions.thumbnailHeight,
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
                  child: Icon(Icons.image, color: AppColors.textLight, size: 32),
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
          right: AppDimensions.spaceSm,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _Badge(text: mode),
                  const SizedBox(width: 4),
                  _Badge(text: map, icon: Icons.map),
                ],
              ),
              _buildStatusBadge(),
            ],
          ),
        ),
        // Date/time at bottom
        if (dateTime != null)
          Positioned(
            bottom: AppDimensions.spaceSm,
            left: AppDimensions.spaceSm,
            child: Row(
              children: [
                const Icon(Icons.schedule, size: 14, color: AppColors.primaryLight),
                const SizedBox(width: 4),
                Text(
                  dateTime!,
                  style: AppTextStyles.bodySm.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
          // Title & description
          Text(
            name,
            style: AppTextStyles.titleLg.copyWith(color: AppColors.onSurface),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(
              description!,
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppDimensions.spaceMd),

          // Metrics grid
          _buildMetricsGrid(),
          const SizedBox(height: AppDimensions.spaceMd),

          // Slot progress
          if (totalSlots != null && filledSlots != null) ...[
            _buildSlotProgress(),
            const SizedBox(height: AppDimensions.spaceMd),
          ],

          // CTA button
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeightLg,
            child: ElevatedButton(
              onPressed: onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor: _ctaColor,
                foregroundColor: _ctaTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (ctaLabel ?? _defaultCtaLabel).toUpperCase(),
                    style: AppTextStyles.buttonLg.copyWith(color: _ctaTextColor),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  Icon(_ctaIcon, size: 20, color: _ctaTextColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceSm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          if (prizePool != null)
            Expanded(child: _MetricCell(label: 'PRIZE POOL', value: prizePool!, icon: Icons.emoji_events, iconColor: AppColors.tertiary, valueColor: AppColors.tertiary)),
          if (perKill != null)
            Expanded(child: _MetricCell(label: 'PER KILL', value: perKill!)),
          if (entryFee != null)
            Expanded(child: _MetricCell(label: 'ENTRY FEE', value: entryFee!, valueColor: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildSlotProgress() {
    final remaining = totalSlots! - filledSlots!;
    final progress = filledSlots! / totalSlots!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '$filledSlots',
                  style: AppTextStyles.labelNumeric.copyWith(
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '/$totalSlots Filled',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _slotBadgeBg,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _slotBadgeBg.withValues(alpha: 0.5)),
              ),
              child: Text(
                '$remaining ${totalSlots! > 20 ? 'TEAMS' : 'SLOTS'} LEFT',
                style: AppTextStyles.caption.copyWith(
                  color: _slotBadgeText,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.progressHeightSm / 2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: AppDimensions.progressHeightSm,
            backgroundColor: AppColors.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
          ),
        ),
      ],
    );
  }

  Color get _progressColor => switch (status) {
    TournamentStatus.almostFull || TournamentStatus.closingSoon => AppColors.warning,
    TournamentStatus.full => AppColors.error,
    _ => AppColors.primary,
  };

  Color get _slotBadgeBg => switch (status) {
    TournamentStatus.almostFull || TournamentStatus.closingSoon => AppColors.almostFullBg,
    TournamentStatus.full => AppColors.errorLight,
    _ => AppColors.primaryFixed,
  };

  Color get _slotBadgeText => switch (status) {
    TournamentStatus.almostFull || TournamentStatus.closingSoon => AppColors.warningDark,
    TournamentStatus.full => AppColors.error,
    _ => AppColors.primary,
  };

  Color get _ctaColor => AppColors.cyanAccent;

  Color get _ctaTextColor => AppColors.onSurface;

  IconData get _ctaIcon => Icons.sports_esports;

  String get _defaultCtaLabel => switch (status) {
    TournamentStatus.full => 'FULL',
    TournamentStatus.completed => 'COMPLETED',
    TournamentStatus.cancelled => 'CANCELLED',
    _ => 'JOIN MATCH',
  };

  Widget _buildStatusBadge() {
    final variant = switch (status) {
      TournamentStatus.open => BadgeVariant.open,
      TournamentStatus.registrationOpen => BadgeVariant.open,
      TournamentStatus.almostFull => BadgeVariant.almostFull,
      TournamentStatus.closingSoon => BadgeVariant.closingSoon,
      TournamentStatus.full => BadgeVariant.failed,
      TournamentStatus.live => BadgeVariant.live,
      TournamentStatus.completed => BadgeVariant.completed,
      TournamentStatus.cancelled => BadgeVariant.failed,
    };
    return BooyahXStatusBadge(
      variant: variant,
      label: statusLabel ?? _defaultStatusLabel,
      showDot: status == TournamentStatus.live,
      animate: status == TournamentStatus.live,
    );
  }

  String get _defaultStatusLabel => switch (status) {
    TournamentStatus.open => 'Open',
    TournamentStatus.registrationOpen => 'Registration Open',
    TournamentStatus.almostFull => 'Almost Full',
    TournamentStatus.closingSoon => 'Closing Soon',
    TournamentStatus.full => 'Full',
    TournamentStatus.live => 'Live',
    TournamentStatus.completed => 'Completed',
    TournamentStatus.cancelled => 'Cancelled',
  };
}

class _Badge extends StatelessWidget {
  final String text;
  final IconData? icon;
  const _Badge({required this.text, this.icon});

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
            Icon(icon, size: 12, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 3),
          ],
          Text(
            text.toUpperCase(),
            style: AppTextStyles.labelCaps.copyWith(
              color: AppColors.onSurface,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;

  const _MetricCell({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMuted,
            fontSize: 9,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: iconColor),
              const SizedBox(width: 2),
            ],
            Flexible(
              child: Text(
                value,
                style: AppTextStyles.labelNumeric.copyWith(
                  color: valueColor ?? AppColors.onSurface,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
