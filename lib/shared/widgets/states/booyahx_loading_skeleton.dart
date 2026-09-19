import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

class BooyahXLoadingSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const BooyahXLoadingSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  @override
  State<BooyahXLoadingSkeleton> createState() => _BooyahXLoadingSkeletonState();
}

class _BooyahXLoadingSkeletonState extends State<BooyahXLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-0.5 + 2.0 * _controller.value, 0),
              colors: const [
                AppColors.surfaceContainerHigh,
                AppColors.surfaceContainerHighest,
                AppColors.surfaceContainerHigh,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Pre-built skeleton layouts for common patterns.
class BooyahXTournamentCardSkeleton extends StatelessWidget {
  const BooyahXTournamentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          const BooyahXLoadingSkeleton(
            width: double.infinity,
            height: AppDimensions.thumbnailHeight,
            borderRadius: AppDimensions.radiusLg,
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const BooyahXLoadingSkeleton(width: 200, height: 18),
                const SizedBox(height: AppDimensions.spaceSm),
                // Subtitle
                const BooyahXLoadingSkeleton(width: 140, height: 12),
                const SizedBox(height: AppDimensions.spaceMd),
                // Metrics row
                Row(
                  children: [
                    const BooyahXLoadingSkeleton(width: 60, height: 32),
                    const SizedBox(width: AppDimensions.spaceSm),
                    const BooyahXLoadingSkeleton(width: 60, height: 32),
                    const SizedBox(width: AppDimensions.spaceSm),
                    const BooyahXLoadingSkeleton(width: 60, height: 32),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                // Progress bar
                const BooyahXLoadingSkeleton(
                  width: double.infinity,
                  height: AppDimensions.progressHeightSm,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                // Button
                const BooyahXLoadingSkeleton(
                  width: double.infinity,
                  height: AppDimensions.buttonHeightLg,
                  borderRadius: AppDimensions.radiusLg,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BooyahXListSkeleton extends StatelessWidget {
  final int itemCount;
  const BooyahXListSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (_) => const BooyahXTournamentCardSkeleton(),
      ),
    );
  }
}
