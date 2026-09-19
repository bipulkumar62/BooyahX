import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';

/// BooyahX Design System — Typography
///
/// Centralized text style definitions extracted from the Stitch design.
/// Uses Space Grotesk for headings/labels and Plus Jakarta Sans for body text.
abstract final class AppTextStyles {
  // ──────────────────────────────────────────────
  // Font Families
  // ──────────────────────────────────────────────
  static const String _headingFont = 'SpaceGrotesk';
  static const String _bodyFont = 'PlusJakartaSans';

  // ──────────────────────────────────────────────
  // Display / Hero
  // ──────────────────────────────────────────────
  static const displayHero = TextStyle(
    fontFamily: _headingFont,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02,
    height: 1.2,
    color: AppColors.onSurface,
  );

  static const displayHeroMobile = TextStyle(
    fontFamily: _headingFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    height: 1.19,
    color: AppColors.onSurface,
  );

  // ──────────────────────────────────────────────
  // Headlines
  // ──────────────────────────────────────────────
  static const headlineLg = TextStyle(
    fontFamily: _headingFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    height: 1.25,
    color: AppColors.onSurface,
  );

  static const headlineMd = TextStyle(
    fontFamily: _headingFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.onSurface,
  );

  static const headlineSm = TextStyle(
    fontFamily: _headingFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.33,
    color: AppColors.onSurface,
  );

  // ──────────────────────────────────────────────
  // Titles
  // ──────────────────────────────────────────────
  static const titleLg = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.33,
    color: AppColors.onSurface,
  );

  static const titleMd = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.38,
    color: AppColors.onSurface,
  );

  static const titleSm = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    color: AppColors.onSurface,
  );

  // ──────────────────────────────────────────────
  // Body
  // ──────────────────────────────────────────────
  static const bodyLg = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.47,
    color: AppColors.onSurface,
  );

  static const bodyMd = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: AppColors.onSurface,
  );

  static const bodySm = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.38,
    color: AppColors.onSurface,
  );

  // ──────────────────────────────────────────────
  // Labels
  // ──────────────────────────────────────────────
  static const labelCaps = TextStyle(
    fontFamily: _headingFont,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.08,
    height: 1.27,
    color: AppColors.onSurface,
  );

  static const labelNumeric = TextStyle(
    fontFamily: _headingFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.02,
    height: 1.25,
    color: AppColors.onSurface,
  );

  static const labelSm = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.02,
    height: 1.27,
    color: AppColors.onSurface,
  );

  // ──────────────────────────────────────────────
  // Caption
  // ──────────────────────────────────────────────
  static const caption = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.36,
    color: AppColors.textMuted,
  );

  // ──────────────────────────────────────────────
  // Button
  // ──────────────────────────────────────────────
  static const buttonLg = TextStyle(
    fontFamily: _headingFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.04,
    height: 1.5,
    color: AppColors.onPrimary,
  );

  static const buttonMd = TextStyle(
    fontFamily: _headingFont,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.04,
    height: 1.43,
    color: AppColors.onPrimary,
  );

  static const buttonSm = TextStyle(
    fontFamily: _headingFont,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.08,
    height: 1.27,
    color: AppColors.onPrimary,
  );
}
