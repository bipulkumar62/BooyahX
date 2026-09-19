import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/shared/widgets/widgets.dart';
import 'package:booyahx/core/models/tournament.dart';

/// Internal component showcase for testing the design system.
/// This screen is for development only and can be removed later.
class ComponentShowcase extends StatelessWidget {
  const ComponentShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BooyahXAppBar(
        title: 'Component Showcase',
        showWallet: true,
        walletBalance: 450,
        showNotifications: true,
        notificationCount: 3,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.gutter),
        children: [
          _section('Buttons'),
          _buildButtons(context),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Status Badges'),
          _buildStatusBadges(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Chips'),
          _buildChips(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Cards'),
          _buildCards(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Text Fields'),
          _buildTextFields(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Tournament Card'),
          _buildTournamentCard(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Match Card — Upcoming'),
          _buildMatchCardUpcoming(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Match Card — Live'),
          _buildMatchCardLive(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Prize Rows'),
          _buildPrizeRows(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Player Rows'),
          _buildPlayerRows(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Notification Items'),
          _buildNotificationItems(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Transaction Rows'),
          _buildTransactionRows(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Avatars'),
          _buildAvatars(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Loading Skeleton'),
          const BooyahXLoadingSkeleton(width: double.infinity, height: 60),
          const SizedBox(height: AppDimensions.spaceMd),
          const BooyahXTournamentCardSkeleton(),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Empty State'),
          const BooyahXEmptyState(
            icon: Icons.sports_esports,
            title: 'No tournaments available',
            subtitle: 'Check back later for upcoming matches',
            actionLabel: 'Refresh',
          ),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Error State'),
          const BooyahXErrorState(
            title: 'Something went wrong',
            message: 'Failed to load tournaments. Please try again.',
            actionLabel: 'Try Again',
          ),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Section Header'),
          const BooyahXSectionHeader(
            title: 'Upcoming Tournaments',
            subtitle: 'Combat Schedule',
            badgeText: 'Live (2)',
          ),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Progress Bar'),
          const BooyahXProgressBar(value: 0.76),
          const SizedBox(height: AppDimensions.spaceMd),
          const BooyahXProgressBar(
            value: 0.87,
            progressColor: AppColors.warning,
          ),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Countdown'),
          BooyahXCountdown(
            duration: const Duration(hours: 1, minutes: 24, seconds: 12),
            label: 'Unlocks in:',
          ),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Dialog'),
          ElevatedButton(
            onPressed: () => BooyahXConfirmationDialog.show(
              context: context,
              icon: Icons.check_circle,
              title: 'Slot Confirmed!',
              message: 'You are officially registered for Bermuda Championship #104.',
              details: 'Allocated Slot: #77\nRoom Credentials: Live at 08:15 PM',
              confirmLabel: 'Got it, Back to Lobby',
              onConfirm: () {},
            ),
            child: const Text('SHOW CONFIRMATION DIALOG'),
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          _section('Bottom Sheet'),
          ElevatedButton(
            onPressed: () => BooyahXBottomSheet.show(
              context: context,
              title: 'How to Join Custom Room',
              child: Column(
                children: [
                  _GuideStep(1, 'Open Free Fire MAX and select the mode selector.'),
                  _GuideStep(2, 'Tap on Custom at the bottom of the screen.'),
                  _GuideStep(3, 'Tap the search icon, paste Room ID, and search.'),
                  _GuideStep(4, 'Select Join, enter Password, and take your slot.'),
                ],
              ),
            ),
            child: const Text('SHOW BOTTOM SHEET'),
          ),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Room Credential Card'),
          const BooyahXRoomCredentialCard(
            roomId: '8492019',
            password: 'BX7702',
          ),
          const SizedBox(height: AppDimensions.spaceXxl),

          _section('Divider'),
          const BooyahXDivider(),
          const SizedBox(height: AppDimensions.spaceXxl),
        ],
      ),
    );
  }

  static Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
      child: Text(
        title,
        style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface),
      ),
    );
  }

  static Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        const BooyahXButton(label: 'Join Match', style: BooyahXButtonStyle.primary),
        const SizedBox(height: AppDimensions.spaceSm),
        const BooyahXButton(label: 'Register Duo', style: BooyahXButtonStyle.secondary),
        const SizedBox(height: AppDimensions.spaceSm),
        const BooyahXButton(label: 'Match Rules', style: BooyahXButtonStyle.outlined),
        const SizedBox(height: AppDimensions.spaceSm),
        const BooyahXButton(label: 'Cancel Entry', style: BooyahXButtonStyle.destructive),
        const SizedBox(height: AppDimensions.spaceSm),
        const BooyahXButton(
          label: 'Join Now',
          style: BooyahXButtonStyle.cyan,
          icon: Icons.bolt,
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        const BooyahXButton(
          label: 'Loading',
          isLoading: true,
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        const BooyahXButton(
          label: 'Disabled',
          onPressed: null,
        ),
      ],
    );
  }

  static Widget _buildStatusBadges() {
    return Wrap(
      spacing: AppDimensions.spaceSm,
      runSpacing: AppDimensions.spaceSm,
      children: const [
        BooyahXStatusBadge(variant: BadgeVariant.open, label: 'Open'),
        BooyahXStatusBadge(variant: BadgeVariant.live, label: 'Live', showDot: true, animate: true),
        BooyahXStatusBadge(variant: BadgeVariant.registered, label: 'Registered'),
        BooyahXStatusBadge(variant: BadgeVariant.almostFull, label: 'Almost Full'),
        BooyahXStatusBadge(variant: BadgeVariant.closingSoon, label: 'Closing Soon'),
        BooyahXStatusBadge(variant: BadgeVariant.locked, label: 'Locked'),
        BooyahXStatusBadge(variant: BadgeVariant.pending, label: 'Pending'),
        BooyahXStatusBadge(variant: BadgeVariant.success, label: 'Success'),
        BooyahXStatusBadge(variant: BadgeVariant.failed, label: 'Failed'),
        BooyahXStatusBadge(variant: BadgeVariant.completed, label: 'Completed'),
        BooyahXStatusBadge(variant: BadgeVariant.info, label: 'Info'),
      ],
    );
  }

  static Widget _buildChips() {
    return Wrap(
      spacing: AppDimensions.spaceSm,
      runSpacing: AppDimensions.spaceSm,
      children: [
        BooyahXChip(label: 'SOLO BR', isSelected: true, icon: Icons.person),
        BooyahXChip(label: 'DUO BR', isSelected: false),
        BooyahXChip(label: 'DUO PER KILL', isSelected: false, icon: Icons.military_tech),
        BooyahXChip(label: 'SOLO PER KILL', isSelected: false),
      ],
    );
  }

  static Widget _buildCards() {
    return Column(
      children: [
        const BooyahXCard(
          child: Text('Normal Card — Standard border and no elevation'),
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        const BooyahXCard(
          style: BooyahXCardStyle.elevated,
          child: Text('Elevated Card — With shadow elevation'),
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        const BooyahXCard(
          style: BooyahXCardStyle.outlined,
          child: Text('Outlined Card — Strong border emphasis'),
        ),
      ],
    );
  }

  static Widget _buildTextFields() {
    return const Column(
      children: [
        BooyahXTextField(
          label: 'Username',
          hintText: 'Enter your username',
        ),
        SizedBox(height: AppDimensions.spaceMd),
        BooyahXTextField(
          label: 'Password',
          hintText: 'Enter your password',
          obscureText: true,
        ),
        SizedBox(height: AppDimensions.spaceMd),
        BooyahXTextField(
          label: 'Email with Error',
          hintText: 'invalid@email',
          errorText: 'Please enter a valid email',
        ),
        SizedBox(height: AppDimensions.spaceMd),
        BooyahXTextField(
          label: 'Disabled Field',
          hintText: 'Cannot edit',
          enabled: false,
        ),
      ],
    );
  }

  static Widget _buildTournamentCard() {
    return BooyahXTournamentCard(
      name: 'Bermuda Championship #104',
      description: 'Custom Room BR Ranked Mode • Official Anti-Cheat Verified',
      mode: 'SOLO BR',
      map: 'Bermuda',
      dateTime: 'Today, 08:30 PM IST',
      prizePool: '₹10,000',
      perKill: '₹25',
      entryFee: '₹50',
      totalSlots: 100,
      filledSlots: 76,
      status: TournamentStatus.registrationOpen,
      ctaLabel: 'JOIN MATCH',
      onJoin: () {},
    );
  }

  static Widget _buildMatchCardUpcoming() {
    return BooyahXMatchCard(
      name: 'Bermuda Championship #104',
      mode: 'SOLO BR',
      map: 'Bermuda',
      dateTime: 'Today, 08:30 PM IST',
      matchId: '#BR-SOLO-99104',
      slotNumber: '18',
      entryFee: '₹50',
      entryFeeStatus: 'Paid',
      prizePool: '₹10,000',
      state: MatchState.upcoming,
      roomStatus: 'Room credentials will unlock 15 minutes before the match start.',
      countdownText: '00h : 24m : 09s',
      isRegistered: true,
      onCta: () {},
    );
  }

  static Widget _buildMatchCardLive() {
    return BooyahXMatchCard(
      name: 'Purgatory Clash #77',
      mode: 'SOLO PER KILL',
      map: 'Purgatory',
      dateTime: 'Now',
      state: MatchState.live,
      livePhase: 'Zone Phase 4 / 6',
      aliveCount: '14/48 Players',
      matchTime: '11:42',
      ctaLabel: 'SPECTATE STREAM / LIVE SCOREBOARD',
      onCta: () {},
    );
  }

  static Widget _buildPrizeRows() {
    return const Column(
      children: [
        BooyahXPrizeRow(
          rank: 1,
          title: 'Champion',
          subtitle: 'Winner Trophy + Title',
          amount: '₹3,500',
          percentage: '35% of pool',
          rankBgColor: AppColors.warning,
          rankTextColor: AppColors.onSurface,
          isHighlighted: true,
        ),
        SizedBox(height: AppDimensions.spaceSm),
        BooyahXPrizeRow(
          rank: 2,
          title: 'Runner Up',
          subtitle: 'Silver Tier',
          amount: '₹2,000',
          percentage: '20% of pool',
          rankBgColor: AppColors.surfaceDim,
          rankTextColor: AppColors.onSurfaceVariant,
        ),
        SizedBox(height: AppDimensions.spaceSm),
        BooyahXPrizeRow(
          rank: 3,
          title: '2nd Runner Up',
          subtitle: 'Bronze Tier',
          amount: '₹1,200',
          percentage: '12% of pool',
          rankBgColor: AppColors.tertiaryContainer,
          rankTextColor: AppColors.tertiary,
        ),
      ],
    );
  }

  static Widget _buildPlayerRows() {
    return const Column(
      children: [
        BooyahXPlayerRow(
          rank: 1,
          name: 'Xenon_Striker',
          subtitle: 'UID: 849301294 • Lvl 72',
          slotLabel: 'SLOT 01',
        ),
        SizedBox(height: AppDimensions.spaceSm),
        BooyahXPlayerRow(
          rank: 2,
          name: 'Hydra_NinjaFF',
          subtitle: 'UID: 190483726 • Lvl 68',
          slotLabel: 'SLOT 02',
        ),
      ],
    );
  }

  static Widget _buildNotificationItems() {
    return const Column(
      children: [
        BooyahXNotificationItem(
          title: 'Bermuda Championship #104',
          message: 'Room credentials are now available. Join before 08:28 PM.',
          timeAgo: '5m',
          type: NotificationType.match,
          isRead: false,
        ),
        SizedBox(height: AppDimensions.spaceSm),
        BooyahXNotificationItem(
          title: 'Prize Credited',
          message: '₹500 credited to your wallet for Purgatory Kill Rush #88.',
          timeAgo: '1h',
          type: NotificationType.wallet,
          isRead: true,
        ),
        SizedBox(height: AppDimensions.spaceSm),
        BooyahXNotificationItem(
          title: 'Achievement Unlocked',
          message: 'You earned the "5 Win Streak" badge!',
          timeAgo: '2h',
          type: NotificationType.achievement,
          isRead: true,
        ),
      ],
    );
  }

  static Widget _buildTransactionRows() {
    return const Column(
      children: [
        BooyahXTransactionRow(
          title: 'Kill Bounty — Purgatory Clash #77',
          subtitle: '₹25 × 4 kills',
          amount: '₹100',
          type: TransactionType.credit,
          date: 'Today, 09:45 PM',
        ),
        SizedBox(height: AppDimensions.spaceSm),
        BooyahXTransactionRow(
          title: 'Entry Fee — Bermuda Championship #104',
          subtitle: 'Solo Slot',
          amount: '₹50',
          type: TransactionType.debit,
          date: 'Today, 06:30 PM',
        ),
        SizedBox(height: AppDimensions.spaceSm),
        BooyahXTransactionRow(
          title: 'Prize Pool — Kalahari Night Duo #12',
          subtitle: 'Pending anti-cheat validation',
          amount: '₹2,500',
          type: TransactionType.pending,
        ),
      ],
    );
  }

  static Widget _buildAvatars() {
    return const Row(
      children: [
        BooyahXAvatar(initials: 'V', size: AvatarSize.xs),
        SizedBox(width: AppDimensions.spaceSm),
        BooyahXAvatar(initials: 'XS', size: AvatarSize.sm),
        SizedBox(width: AppDimensions.spaceSm),
        BooyahXAvatar(initials: 'A', size: AvatarSize.md),
        SizedBox(width: AppDimensions.spaceSm),
        BooyahXAvatar(initials: 'B', size: AvatarSize.lg),
        SizedBox(width: AppDimensions.spaceSm),
        BooyahXAvatar(initials: 'XL', size: AvatarSize.xl),
      ],
    );
  }
}

class _GuideStep extends StatelessWidget {
  final int step;
  final String text;
  const _GuideStep(this.step, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
