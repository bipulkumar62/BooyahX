import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/core/models/wallet.dart';
import 'package:booyahx/core/providers/wallet_provider.dart';
import 'package:booyahx/core/utils/time_formatter.dart';
import 'package:booyahx/shared/widgets/widgets.dart';

/// BooyahX — Wallet Screen
///
/// Displays wallet balance, action buttons (Add Money / Withdraw),
/// and transaction history. All data is mock/local only.
/// No real financial transactions occur.
class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  void initState() {
    super.initState();
    // Load wallet data on first render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletProvider.notifier).loadWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletData = ref.watch(walletProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BooyahXAppBar(
        title: 'WALLET',
        showBackButton: true,
        showWallet: false,
        showNotifications: false,
      ),
      body: _buildBody(walletData),
    );
  }

  Widget _buildBody(WalletData data) {
    return switch (data.status) {
      WalletStatus.loading => _buildLoadingState(),
      WalletStatus.normal => _buildNormalState(data),
      WalletStatus.empty => _buildEmptyState(),
      WalletStatus.error => _buildErrorState(data.errorMessage),
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
          const SizedBox(height: AppDimensions.spaceLg),
          // Skeleton balance card
          const BooyahXLoadingSkeleton(
            width: double.infinity,
            height: 180,
            borderRadius: AppDimensions.radiusXl,
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          // Skeleton action buttons
          Row(
            children: [
              const Expanded(
                child: BooyahXLoadingSkeleton(
                  height: 48,
                  borderRadius: AppDimensions.radiusLg,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              const Expanded(
                child: BooyahXLoadingSkeleton(
                  height: 48,
                  borderRadius: AppDimensions.radiusLg,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceXl),
          // Skeleton transaction rows
          ...List.generate(
            5,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.spaceSm),
              child: BooyahXLoadingSkeleton(
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

  // ── Normal State ──

  Widget _buildNormalState(WalletData data) {
    return RefreshIndicator(
      onRefresh: () => ref.read(walletProvider.notifier).retry(),
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // ── Balance Card ──
          if (data.wallet != null)
            SliverToBoxAdapter(
              child: _BalanceCard(wallet: data.wallet!),
            ),

          // ── Action Buttons ──
          SliverToBoxAdapter(
            child: _ActionButtons(
              onAddMoney: () => _showAddMoney(context),
              onWithdraw: () => _showWithdraw(context),
            ),
          ),

          // ── Transaction History Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.gutter,
                AppDimensions.spaceXl,
                AppDimensions.gutter,
                AppDimensions.spaceMd,
              ),
              child: BooyahXSectionHeader(
                title: 'Transactions',
                badgeText: '${data.transactions.length}',
              ),
            ),
          ),

          // ── Transaction List ──
          if (data.transactions.isEmpty)
            const SliverFillRemaining(child: _EmptyTransactions())
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.gutter,
              ),
              sliver: SliverList.builder(
                itemCount: data.transactions.length,
                itemBuilder: (context, index) {
                  final txn = data.transactions[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.spaceSm,
                    ),
                    child: _TransactionCard(transaction: txn),
                  );
                },
              ),
            ),

          // ── Bottom Safe Area ──
          const SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.spaceXxl),
          ),
        ],
      ),
    );
  }

  // ── Empty State ──

  Widget _buildEmptyState() {
    return BooyahXEmptyState(
      icon: Icons.account_balance_wallet_outlined,
      title: 'No transactions yet',
      subtitle: 'Your transaction history will appear here.',
      actionLabel: 'Refresh',
      onAction: () => ref.read(walletProvider.notifier).retry(),
    );
  }

  // ── Error State ──

  Widget _buildErrorState(String? message) {
    return BooyahXErrorState(
      title: 'Unable to load wallet',
      message:
          message ?? 'Something went wrong. Please check your connection and try again.',
      actionLabel: 'Try Again',
      onAction: () => ref.read(walletProvider.notifier).retry(),
    );
  }

  // ── Mock Add Money Flow ──

  void _showAddMoney(BuildContext context) {
    BooyahXBottomSheet.show(
      context: context,
      title: 'Add Money',
      child: _AddMoneyForm(),
    );
  }

  // ── Mock Withdraw Flow ──

  void _showWithdraw(BuildContext context) {
    BooyahXBottomSheet.show(
      context: context,
      title: 'Withdraw',
      child: _WithdrawForm(),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Private Sub-Widgets
// ══════════════════════════════════════════════════════════

/// Wallet balance card with gradient background.
class _BalanceCard extends StatelessWidget {
  final Wallet wallet;

  const _BalanceCard({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.gutter,
        AppDimensions.spaceLg,
        AppDimensions.gutter,
        0,
      ),
      padding: const EdgeInsets.all(AppDimensions.spaceXl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Text(
                'Available Balance',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          // Main balance
          Text(
            '₹${_formatAmount(wallet.availableBalance)}',
            style: AppTextStyles.displayHeroMobile.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Breakdown row
          Row(
            children: [
              _BalanceChip(
                label: 'Winnings',
                amount: '₹${_formatAmount(wallet.winningsBalance)}',
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              _BalanceChip(
                label: 'Bonus',
                amount: '₹${_formatAmount(wallet.bonusBalance)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

class _BalanceChip extends StatelessWidget {
  final String label;
  final String amount;

  const _BalanceChip({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMd,
        vertical: AppDimensions.spaceSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceXs),
          Text(
            amount,
            style: AppTextStyles.labelNumeric.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Add Money / Withdraw action buttons.
class _ActionButtons extends StatelessWidget {
  final VoidCallback onAddMoney;
  final VoidCallback onWithdraw;

  const _ActionButtons({
    required this.onAddMoney,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.gutter,
        AppDimensions.spaceLg,
        AppDimensions.gutter,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: BooyahXButton(
              label: 'Add Money',
              icon: Icons.add,
              style: BooyahXButtonStyle.primary,
              isExpanded: true,
              onPressed: onAddMoney,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(
            child: BooyahXButton(
              label: 'Withdraw',
              icon: Icons.arrow_upward,
              style: BooyahXButtonStyle.outlined,
              isExpanded: true,
              onPressed: onWithdraw,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual transaction card with icon.
class _TransactionCard extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionCard({required this.transaction});

  /// Map wallet transaction type to widget TransactionType.
  TransactionType get _widgetType => switch (transaction.type) {
        WalletTransactionType.tournamentEntry =>
          TransactionType.tournamentEntry,
        WalletTransactionType.winnings => TransactionType.winnings,
        WalletTransactionType.refund => TransactionType.refund,
        WalletTransactionType.deposit => TransactionType.deposit,
        WalletTransactionType.withdrawal => TransactionType.withdrawal,
      };

  /// Get status label for subtitle.
  String? get _statusLabel => switch (transaction.status) {
        WalletTransactionStatus.completed => null,
        WalletTransactionStatus.pending => 'Pending',
        WalletTransactionStatus.failed => 'Failed',
      };

  @override
  Widget build(BuildContext context) {
    return BooyahXTransactionRow(
      title: transaction.title,
      subtitle: _statusLabel,
      amount: '₹${transaction.amount.toInt()}',
      type: _widgetType,
      date: TimeFormatter.formatRelative(transaction.timestamp),
    );
  }
}

/// Empty transactions placeholder.
class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long,
              size: 48,
              color: AppColors.textLight,
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            Text(
              'No transactions yet',
              style: AppTextStyles.titleSm.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              'Join tournaments to see your transaction history.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Mock Forms (Add Money / Withdraw)
// ══════════════════════════════════════════════════════════

/// Mock Add Money form — NO real transaction.
class _AddMoneyForm extends StatefulWidget {
  @override
  State<_AddMoneyForm> createState() => _AddMoneyFormState();
}

class _AddMoneyFormState extends State<_AddMoneyForm> {
  final _amountController = TextEditingController();
  final _presetAmounts = [100, 200, 500, 1000];
  bool _confirmed = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectAmount(int amount) {
    setState(() {
      _amountController.text = '$amount';
    });
  }

  void _handleConfirm() {
    setState(() {
      _confirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_confirmed) {
      return _MockConfirmation(
        icon: Icons.account_balance_wallet,
        iconColor: AppColors.primary,
        title: 'Demo Mode',
        message:
            'This is a mock Add Money flow. No real transaction has been processed. In production, this will connect to a payment gateway.',
        onDone: () => Navigator.of(context).pop(),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Preset amounts
        Wrap(
          spacing: AppDimensions.spaceSm,
          runSpacing: AppDimensions.spaceSm,
          children: _presetAmounts.map((amount) {
            return GestureDetector(
              onTap: () => _selectAmount(amount),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceLg,
                  vertical: AppDimensions.spaceMd,
                ),
                decoration: BoxDecoration(
                  color: _amountController.text == '$amount'
                      ? AppColors.primaryFixed
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  border: Border.all(
                    color: _amountController.text == '$amount'
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  '₹$amount',
                  style: AppTextStyles.titleSm.copyWith(
                    color: _amountController.text == '$amount'
                        ? AppColors.primary
                        : AppColors.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppDimensions.spaceLg),

        // Amount input
        BooyahXTextField(
          label: 'Enter Amount',
          hintText: '₹0',
          controller: _amountController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter an amount';
            }
            final amount = int.tryParse(value.trim());
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
        const SizedBox(height: AppDimensions.spaceXl),

        // Disclaimer
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceMd),
          decoration: BoxDecoration(
            color: AppColors.warningLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.warningDark,
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: Text(
                  'This is a demo. No real money will be added.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warningDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceLg),

        // Continue button
        BooyahXButton(
          label: 'Continue',
          icon: Icons.arrow_forward,
          onPressed: _handleConfirm,
        ),
      ],
    );
  }
}

/// Mock Withdraw form — NO real transaction.
class _WithdrawForm extends StatefulWidget {
  @override
  State<_WithdrawForm> createState() => _WithdrawFormState();
}

class _WithdrawFormState extends State<_WithdrawForm> {
  final _amountController = TextEditingController();
  bool _confirmed = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    setState(() {
      _confirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_confirmed) {
      return _MockConfirmation(
        icon: Icons.arrow_upward,
        iconColor: AppColors.tertiary,
        title: 'Demo Mode',
        message:
            'This is a mock Withdraw flow. No real withdrawal has been processed. In production, this will connect to a payment gateway.',
        onDone: () => Navigator.of(context).pop(),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Amount input
        BooyahXTextField(
          label: 'Withdrawal Amount',
          hintText: '₹0',
          controller: _amountController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter an amount';
            }
            final amount = int.tryParse(value.trim());
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
        const SizedBox(height: AppDimensions.spaceLg),

        // Disclaimer
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceMd),
          decoration: BoxDecoration(
            color: AppColors.warningLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.warningDark,
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: Text(
                  'This is a demo. No real withdrawal will be processed.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warningDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceLg),

        // Continue button
        BooyahXButton(
          label: 'Continue',
          icon: Icons.arrow_forward,
          style: BooyahXButtonStyle.outlined,
          onPressed: _handleConfirm,
        ),
      ],
    );
  }
}

/// Mock confirmation message shown after Add Money / Withdraw.
class _MockConfirmation extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final VoidCallback onDone;

  const _MockConfirmation({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 32, color: iconColor),
        ),
        const SizedBox(height: AppDimensions.spaceLg),
        Text(
          title,
          style: AppTextStyles.headlineMd.copyWith(
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        Text(
          message,
          style: AppTextStyles.bodySm.copyWith(
            color: AppColors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceXl),
        BooyahXButton(
          label: 'Done',
          onPressed: onDone,
        ),
      ],
    );
  }
}
