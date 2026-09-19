import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';
import 'package:booyahx/core/constants/app_routes.dart';
import 'package:booyahx/core/providers/player_profile_provider.dart';

/// BooyahX — Splash Screen
///
/// Displays the BooyahX branding while the app initializes.
/// After a brief delay, checks if the player has a profile:
/// - Yes → navigate to Home
/// - No → navigate to Onboarding
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final hasProfile = ref.read(isPlayerSetupProvider);

    if (hasProfile) {
      context.go(AppRoutes.homePath);
    } else {
      context.go(AppRoutes.onboardingPath);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), // slate-900
              Color(0xFF1E293B), // slate-800
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo container
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.local_fire_department,
                          size: 48,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXl),

                      // App name
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'BOOYAH',
                              style: AppTextStyles.displayHeroMobile.copyWith(
                                color: Colors.white,
                                letterSpacing: 0.06,
                              ),
                            ),
                            TextSpan(
                              text: 'X',
                              style: AppTextStyles.displayHeroMobile.copyWith(
                                color: AppColors.primaryLight,
                                letterSpacing: 0.06,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceSm),

                      // Tagline
                      Text(
                        'TOURNAMENT HUB',
                        style: AppTextStyles.labelCaps.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 0.12,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXxl),

                      // Loading indicator
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryLight.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
