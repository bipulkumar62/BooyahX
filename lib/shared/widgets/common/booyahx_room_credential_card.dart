import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';
import 'package:booyahx/core/constants/app_dimensions.dart';

class BooyahXRoomCredentialCard extends StatelessWidget {
  final String roomId;
  final String password;
  final VoidCallback? onCopyId;
  final VoidCallback? onCopyPass;
  final VoidCallback? onCopyBoth;
  final VoidCallback? onHelp;

  const BooyahXRoomCredentialCard({
    super.key,
    required this.roomId,
    required this.password,
    this.onCopyId,
    this.onCopyPass,
    this.onCopyBoth,
    this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.vpn_key,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room Credentials',
                      style: AppTextStyles.titleMd.copyWith(color: AppColors.onSurface),
                    ),
                    Text(
                      'Use credentials to enter Custom Room in Free Fire MAX',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Room ID
          _CredentialBox(
            label: 'ROOM ID',
            value: roomId,
            onCopy: onCopyId ?? () => _copy(context, roomId),
          ),
          const SizedBox(height: AppDimensions.spaceSm),

          // Password
          _CredentialBox(
            label: 'PASSWORD',
            value: password,
            onCopy: onCopyPass ?? () => _copy(context, password),
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          // Copy Both CTA
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeightLg,
            child: ElevatedButton(
              onPressed: onCopyBoth ?? () => _copy(context, 'Room ID: $roomId | Password: $password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.file_copy, size: 20),
                  const SizedBox(width: AppDimensions.spaceSm),
                  Text(
                    'COPY BOTH CREDENTIALS',
                    style: AppTextStyles.buttonLg.copyWith(color: AppColors.onPrimary),
                  ),
                ],
              ),
            ),
          ),

          // Help link
          if (onHelp != null) ...[
            const SizedBox(height: AppDimensions.spaceSm),
            Center(
              child: GestureDetector(
                onTap: onHelp,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.help_outline, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'How to join custom room in Free Fire?',
                      style: AppTextStyles.bodySm.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $text'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _CredentialBox extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _CredentialBox({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelCaps.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.displayHeroMobile.copyWith(
                    color: AppColors.onSurface,
                    letterSpacing: 0.04,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onCopy,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.outline),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.content_copy, size: 16, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    label == 'PASSWORD' ? 'Copy Pass' : 'Copy ID',
                    style: AppTextStyles.titleSm.copyWith(color: AppColors.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
