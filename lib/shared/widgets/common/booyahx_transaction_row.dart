import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

enum TransactionType {
  credit,
  debit,
  pending,
  tournamentEntry,
  winnings,
  refund,
  deposit,
  withdrawal,
}

class BooyahXTransactionRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String amount;
  final TransactionType type;
  final String? date;
  final IconData? icon;

  const BooyahXTransactionRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.amount,
    this.type = TransactionType.credit,
    this.date,
    this.icon,
  });

  Color get _amountColor => switch (type) {
    TransactionType.credit => AppColors.success,
    TransactionType.debit => AppColors.error,
    TransactionType.pending => AppColors.warning,
    TransactionType.tournamentEntry => AppColors.error,
    TransactionType.winnings => AppColors.success,
    TransactionType.refund => AppColors.success,
    TransactionType.deposit => AppColors.primary,
    TransactionType.withdrawal => AppColors.tertiary,
  };

  String get _prefix => switch (type) {
    TransactionType.credit => '+',
    TransactionType.debit => '-',
    TransactionType.pending => '',
    TransactionType.tournamentEntry => '-',
    TransactionType.winnings => '+',
    TransactionType.refund => '+',
    TransactionType.deposit => '+',
    TransactionType.withdrawal => '-',
  };

  IconData get _icon => icon ?? switch (type) {
    TransactionType.credit => Icons.arrow_downward,
    TransactionType.debit => Icons.arrow_upward,
    TransactionType.pending => Icons.schedule,
    TransactionType.tournamentEntry => Icons.sports_esports,
    TransactionType.winnings => Icons.emoji_events,
    TransactionType.refund => Icons.replay,
    TransactionType.deposit => Icons.account_balance_wallet,
    TransactionType.withdrawal => Icons.arrow_upward,
  };

  Color get _iconColor => switch (type) {
    TransactionType.credit => AppColors.success,
    TransactionType.debit => AppColors.error,
    TransactionType.pending => AppColors.warning,
    TransactionType.tournamentEntry => AppColors.error,
    TransactionType.winnings => AppColors.success,
    TransactionType.refund => AppColors.success,
    TransactionType.deposit => AppColors.primary,
    TransactionType.withdrawal => AppColors.tertiary,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(_icon, size: 18, color: _iconColor),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSm.copyWith(color: AppColors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_prefix$amount',
                style: AppTextStyles.labelNumeric.copyWith(color: _amountColor, fontSize: 14),
              ),
              if (date != null)
                Text(
                  date!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textLight, fontSize: 10),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
