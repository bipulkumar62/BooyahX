import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/core/constants/app_routes.dart';
import 'package:booyahx/core/providers/player_profile_provider.dart';
import 'package:booyahx/shared/widgets/inputs/booyahx_text_field.dart';
import 'package:booyahx/shared/widgets/buttons/booyahx_button.dart';

/// BooyahX — Player Setup Screen (Onboarding)
///
/// Collects the player's In-Game Name and Free Fire UID.
/// No authentication, no backend — just local state.
class PlayerSetupScreen extends ConsumerStatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  ConsumerState<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends ConsumerState<PlayerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ignController = TextEditingController();
  final _uidController = TextEditingController();
  final _ignFocusNode = FocusNode();
  final _uidFocusNode = FocusNode();

  bool _isSubmitting = false;

  // ── Validation Constants ──
  static const int _maxIgnLength = 20;
  static const int _minUidLength = 6;
  static const int _maxUidLength = 12;

  @override
  void dispose() {
    _ignController.dispose();
    _uidController.dispose();
    _ignFocusNode.dispose();
    _uidFocusNode.dispose();
    super.dispose();
  }

  // ── Validators ──

  String? _validateIgn(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Please enter your In-Game Name';
    }
    if (trimmed.length > _maxIgnLength) {
      return 'Name must be $_maxIgnLength characters or less';
    }
    return null;
  }

  String? _validateUid(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Please enter your Free Fire UID';
    }
    if (trimmed.length < _minUidLength || trimmed.length > _maxUidLength) {
      return 'UID must be $_minUidLength–$_maxUidLength digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
      return 'UID must contain only numbers';
    }
    return null;
  }

  // ── Submit ──

  Future<void> _handleSubmit() async {
    // Remove focus to dismiss keyboard
    FocusScope.of(context).unfocus();

    // Validate form
    if (!_formKey.currentState!.validate()) return;

    final ign = _ignController.text.trim();
    final uid = _uidController.text.trim();

    // Double-check (shouldn't reach here if validation fails)
    if (ign.isEmpty || uid.isEmpty) return;
    if (ign.length > _maxIgnLength) return;
    if (uid.length < _minUidLength || uid.length > _maxUidLength) return;
    if (!RegExp(r'^\d+$').hasMatch(uid)) return;

    setState(() => _isSubmitting = true);

    // Small delay to simulate processing
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // Save profile to Riverpod state
    ref.read(playerProfileProvider.notifier).setProfile(
          inGameName: ign,
          freeFireUid: uid,
        );

    // Navigate to Home
    context.go(AppRoutes.homePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceXl,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.spaceXxxl),
                  const SizedBox(height: AppDimensions.spaceXxl),

                  // ── Logo ──
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixed,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXl),

                  // ── Title ──
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'BOOYAH',
                            style: AppTextStyles.headlineLg.copyWith(
                              color: AppColors.onSurface,
                              letterSpacing: 0.04,
                            ),
                          ),
                          TextSpan(
                            text: 'X',
                            style: AppTextStyles.headlineLg.copyWith(
                              color: AppColors.primary,
                              letterSpacing: 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXxl),

                  // ── Heading ──
                  Text(
                    'Set up your\nBooyahX profile',
                    style: AppTextStyles.displayHeroMobile.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),

                  // ── Subtitle ──
                  Text(
                    'Enter your Free Fire details to get started with competitive tournaments.',
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXxl),

                  // ── IGN Field ──
                  BooyahXTextField(
                    label: 'In-Game Name',
                    hintText: 'Enter your Free Fire name',
                    controller: _ignController,
                    focusNode: _ignFocusNode,
                    validator: _validateIgn,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_uidFocusNode),
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),

                  // ── UID Field ──
                  BooyahXTextField(
                    label: 'Free Fire UID',
                    hintText: 'Enter your UID',
                    controller: _uidController,
                    focusNode: _uidFocusNode,
                    validator: _validateUid,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _handleSubmit,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(_maxUidLength),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceXxl),

                  // ── Continue Button ──
                  BooyahXButton(
                    label: 'Continue',
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    isLoading: _isSubmitting,
                    icon: Icons.arrow_forward,
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),

                  // ── Footer note ──
                  Center(
                    child: Text(
                      'Your gaming info is used to match you in tournaments.',
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
    );
  }
}
