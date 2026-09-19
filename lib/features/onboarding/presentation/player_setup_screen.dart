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
/// Collects the player's Name, In-Game Name, and Free Fire UID.
/// No authentication — just local state + backend sync.
class PlayerSetupScreen extends ConsumerStatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  ConsumerState<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends ConsumerState<PlayerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ignController = TextEditingController();
  final _uidController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _ignFocusNode = FocusNode();
  final _uidFocusNode = FocusNode();

  bool _isSubmitting = false;
  String? _errorMessage;

  // ── Validation Constants ──
  static const int _maxNameLength = 50;
  static const int _maxIgnLength = 20;
  static const int _minUidLength = 6;
  static const int _maxUidLength = 12;

  @override
  void dispose() {
    _nameController.dispose();
    _ignController.dispose();
    _uidController.dispose();
    _nameFocusNode.dispose();
    _ignFocusNode.dispose();
    _uidFocusNode.dispose();
    super.dispose();
  }

  // ── Validators ──

  String? _validateName(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Please enter your name';
    }
    if (trimmed.length > _maxNameLength) {
      return 'Name must be $_maxNameLength characters or less';
    }
    return null;
  }

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

    final name = _nameController.text.trim();
    final ign = _ignController.text.trim();
    final uid = _uidController.text.trim();

    // Double-check
    if (name.isEmpty || ign.isEmpty || uid.isEmpty) return;
    if (name.length > _maxNameLength) return;
    if (ign.length > _maxIgnLength) return;
    if (uid.length < _minUidLength || uid.length > _maxUidLength) return;
    if (!RegExp(r'^\d+$').hasMatch(uid)) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    // Save profile to Riverpod state (syncs with backend)
    await ref.read(playerProfileProvider.notifier).setProfile(
          name: name,
          inGameName: ign,
          uid: uid,
        );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

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
                    'Enter your details to get started with competitive tournaments.',
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXxl),

                  // ── Name Field ──
                  BooyahXTextField(
                    label: 'Player Name',
                    hintText: 'Enter your full name',
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    validator: _validateName,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_ignFocusNode),
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),

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
