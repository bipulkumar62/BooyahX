import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/services/api_service.dart';
import 'package:booyahx/shared/widgets/widgets.dart';

/// BooyahX — Create Tournament Screen
///
/// Form to create a new tournament. Posts to POST /api/tournaments.
/// Game is automatically set to "Free Fire", status defaults to "upcoming".
class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _entryFeeController = TextEditingController();
  final _prizePoolController = TextEditingController();
  final _maxPlayersController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _entryFeeFocusNode = FocusNode();
  final _prizePoolFocusNode = FocusNode();
  final _maxPlayersFocusNode = FocusNode();

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _entryFeeController.dispose();
    _prizePoolController.dispose();
    _maxPlayersController.dispose();
    _nameFocusNode.dispose();
    _entryFeeFocusNode.dispose();
    _prizePoolFocusNode.dispose();
    _maxPlayersFocusNode.dispose();
    super.dispose();
  }

  // ── Validators ──

  String? _validateName(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Tournament name cannot be empty';
    if (trimmed.length > 100) return 'Name must be 100 characters or less';
    return null;
  }

  String? _validateEntryFee(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Entry fee is required';
    final num? fee = num.tryParse(trimmed);
    if (fee == null || fee < 0) return 'Enter a valid number';
    return null;
  }

  String? _validatePrizePool(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Prize pool is required';
    final num? pool = num.tryParse(trimmed);
    if (pool == null || pool < 0) return 'Enter a valid number';
    return null;
  }

  String? _validateMaxPlayers(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Maximum players is required';
    final int? players = int.tryParse(trimmed);
    if (players == null || players <= 0) return 'Must be a positive number';
    return null;
  }

  // ── Submit ──

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final entryFee = _entryFeeController.text.trim();
    final prizePool = _prizePoolController.text.trim();
    final maxPlayers = int.parse(_maxPlayersController.text.trim());

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await ApiService.instance.createTournament({
        'name': name,
        'game': 'Free Fire',
        'entryFee': '₹$entryFee',
        'prizePool': '₹$prizePool',
        'totalSlots': maxPlayers,
        'status': 'upcoming',
      });

      if (!mounted) return;

      // Show success and pop back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tournament "$name" created successfully!',
            style: AppTextStyles.bodySm.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
      );

      // Pop with true to signal refresh needed
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().contains('ApiException')
            ? 'Failed to create tournament. Please try again.'
            : 'An unexpected error occurred.';
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            _buildHeader(),

            // ── Form ──
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.gutter,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDimensions.spaceLg),

                        // ── Info Banner ──
                        _buildInfoBanner(),
                        const SizedBox(height: AppDimensions.spaceXl),

                        // ── Tournament Name ──
                        BooyahXTextField(
                          label: 'Tournament Name',
                          hintText: 'e.g. BooyahX Championship',
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          validator: _validateName,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_entryFeeFocusNode),
                        ),
                        const SizedBox(height: AppDimensions.spaceLg),

                        // ── Game (Auto-filled) ──
                        _buildAutoField(
                          label: 'Game',
                          value: 'Free Fire',
                          icon: Icons.sports_esports,
                        ),
                        const SizedBox(height: AppDimensions.spaceLg),

                        // ── Entry Fee ──
                        BooyahXTextField(
                          label: 'Entry Fee (₹)',
                          hintText: 'e.g. 50',
                          controller: _entryFeeController,
                          focusNode: _entryFeeFocusNode,
                          validator: _validateEntryFee,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_prizePoolFocusNode),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spaceLg),

                        // ── Prize Pool ──
                        BooyahXTextField(
                          label: 'Prize Pool (₹)',
                          hintText: 'e.g. 5000',
                          controller: _prizePoolController,
                          focusNode: _prizePoolFocusNode,
                          validator: _validatePrizePool,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_maxPlayersFocusNode),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spaceLg),

                        // ── Maximum Players ──
                        BooyahXTextField(
                          label: 'Maximum Players',
                          hintText: 'e.g. 48',
                          controller: _maxPlayersController,
                          focusNode: _maxPlayersFocusNode,
                          validator: _validateMaxPlayers,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _handleSubmit,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spaceLg),

                        // ── Status (Auto-filled) ──
                        _buildAutoField(
                          label: 'Status',
                          value: 'Upcoming',
                          icon: Icons.schedule,
                        ),
                        const SizedBox(height: AppDimensions.spaceXl),

                        // ── Error Message ──
                        if (_errorMessage != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppDimensions.spaceMd),
                            decoration: BoxDecoration(
                              color: AppColors.errorLight,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                              border: Border.all(
                                color: AppColors.error.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: AppTextStyles.bodySm.copyWith(
                                color: AppColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceLg),
                        ],

                        // ── Create Button ──
                        BooyahXButton(
                          label: 'Create Tournament',
                          onPressed: _isSubmitting ? null : _handleSubmit,
                          isLoading: _isSubmitting,
                          icon: Icons.add_circle_outline,
                        ),
                        const SizedBox(height: AppDimensions.spaceLg),

                        // ── Footer note ──
                        Center(
                          child: Text(
                            'Tournaments are visible to all players once created.',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceXxl),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──

  Widget _buildHeader() {
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
                  'Create Tournament',
                  style: AppTextStyles.titleLg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Info Banner ──

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(
            child: Text(
              'Game is set to Free Fire and status defaults to Upcoming.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Auto-filled Field ──

  Widget _buildAutoField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMd.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
            vertical: AppDimensions.spaceMd,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: AppDimensions.spaceSm),
              Text(
                value,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  'AUTO',
                  style: AppTextStyles.labelCaps.copyWith(
                    color: AppColors.primary,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
