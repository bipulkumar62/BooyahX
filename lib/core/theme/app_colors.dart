import 'package:flutter/material.dart';

/// BooyahX Design System — Color Tokens
///
/// Centralized color definitions extracted from the Stitch design system.
/// All colors are defined here. Never hardcode colors elsewhere.
abstract final class AppColors {
  // ──────────────────────────────────────────────
  // Background & Surface
  // ──────────────────────────────────────────────
  static const background = Color(0xFFF8FAFC); // slate-50
  static const surface = Color(0xFFFFFFFF);
  static const surfaceDim = Color(0xFFE2E8F0); // slate-200
  static const surfaceBright = Color(0xFFFFFFFF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF8FAFC);
  static const surfaceContainer = Color(0xFFFFFFFF);
  static const surfaceContainerHigh = Color(0xFFF1F5F9); // slate-100
  static const surfaceContainerHighest = Color(0xFFE2E8F0); // slate-200
  static const surfaceVariant = Color(0xFFF1F5F9); // slate-100

  // ──────────────────────────────────────────────
  // Primary (Sky Blue)
  // ──────────────────────────────────────────────
  static const primary = Color(0xFF0284C7); // sky-600
  static const primaryLight = Color(0xFF38BDF8); // sky-400
  static const primaryDark = Color(0xFF0369A1); // sky-700
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF0284C7);
  static const onPrimaryContainer = Color(0xFFFFFFFF);
  static const primaryFixed = Color(0xFFBAE6FD);
  static const primaryFixedDim = Color(0xFF38BDF8);
  static const onPrimaryFixed = Color(0xFF001F24);
  static const onPrimaryFixedVariant = Color(0xFF004F58);

  // ──────────────────────────────────────────────
  // Secondary (Indigo)
  // ──────────────────────────────────────────────
  static const secondary = Color(0xFF4F46E5); // indigo-600
  static const secondaryLight = Color(0xFF818CF8); // indigo-400
  static const secondaryDark = Color(0xFF3730A3); // indigo-800
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFE0E7FF); // indigo-100
  static const onSecondaryContainer = Color(0xFF4338CA);
  static const secondaryFixed = Color(0xFFE0E7FF);
  static const secondaryFixedDim = Color(0xFFC7D2FE);

  // ──────────────────────────────────────────────
  // Tertiary (Amber / Gold)
  // ──────────────────────────────────────────────
  static const tertiary = Color(0xFFD97706); // amber-600
  static const tertiaryLight = Color(0xFFFDE68A); // amber-200
  static const tertiaryDark = Color(0xFFB45309); // amber-700
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFFFEF3C7); // amber-100
  static const onTertiaryContainer = Color(0xFF92400E);
  static const tertiaryFixed = Color(0xFFFEF3C7);
  static const tertiaryFixedDim = Color(0xFFFDE68A);

  // ──────────────────────────────────────────────
  // Error
  // ──────────────────────────────────────────────
  static const error = Color(0xFFDC2626); // red-600
  static const errorLight = Color(0xFFFEE2E2); // red-100
  static const errorDark = Color(0xFF991B1B); // red-800
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFEE2E2);
  static const onErrorContainer = Color(0xFF991B1B);

  // ──────────────────────────────────────────────
  // Success
  // ──────────────────────────────────────────────
  static const success = Color(0xFF10B981); // emerald-500
  static const successLight = Color(0xFFD1FAE5); // emerald-100
  static const successDark = Color(0xFF059669); // emerald-600
  static const onSuccess = Color(0xFFFFFFFF);

  // ──────────────────────────────────────────────
  // Warning
  // ──────────────────────────────────────────────
  static const warning = Color(0xFFF59E0B); // amber-500
  static const warningLight = Color(0xFFFEF3C7); // amber-100
  static const warningDark = Color(0xFFD97706); // amber-600
  static const onWarning = Color(0xFFFFFFFF);

  // ──────────────────────────────────────────────
  // Text / On-Surface
  // ──────────────────────────────────────────────
  static const onSurface = Color(0xFF0F172A); // slate-900
  static const onSurfaceVariant = Color(0xFF475569); // slate-600
  static const onBackground = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B); // slate-500
  static const textLight = Color(0xFF94A3B8); // slate-400

  // ──────────────────────────────────────────────
  // Outline / Border
  // ──────────────────────────────────────────────
  static const outline = Color(0xFFCBD5E1); // slate-300
  static const outlineVariant = Color(0xFFE2E8F0); // slate-200
  static const border = Color(0xFFE2E8F0);
  static const borderLight = Color(0xFFF1F5F9);

  // ──────────────────────────────────────────────
  // Inverse
  // ──────────────────────────────────────────────
  static const inverseSurface = Color(0xFF1E293B); // slate-800
  static const inverseOnSurface = Color(0xFFF8FAFC);
  static const inversePrimary = Color(0xFF38BDF8);

  // ──────────────────────────────────────────────
  // Semantic / Status
  // ──────────────────────────────────────────────
  static const liveRed = Color(0xFFDC2626);
  static const liveRedBg = Color(0xFFFEF2F2);
  static const registeredGreen = Color(0xFF059669);
  static const registeredGreenBg = Color(0xFFD1FAE5);
  static const closingSoon = Color(0xFFDC2626);
  static const closingSoonBg = Color(0xFFFEE2E2);
  static const almostFull = Color(0xFFF59E0B);
  static const almostFullBg = Color(0xFFFEF3C7);
  static const openBlue = Color(0xFF0284C7);
  static const openBlueBg = Color(0xFFE0F2FE);

  // ──────────────────────────────────────────────
  // Gradient Stops (Cyan Accent for CTAs)
  // ──────────────────────────────────────────────
  static const cyanAccent = Color(0xFF22D3EE); // cyan-400
  static const cyanDark = Color(0xFF06B6D4); // cyan-500
}
