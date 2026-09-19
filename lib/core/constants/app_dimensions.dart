/// BooyahX Design System — Dimensions & Spacing Tokens
///
/// Centralized dimension constants. Uses a consistent spacing scale.
/// Border radius, icon sizes, button heights, and common paddings.
abstract final class AppDimensions {
  // ──────────────────────────────────────────────
  // Spacing Scale (4px base)
  // ──────────────────────────────────────────────
  static const double space0 = 0;
  static const double spaceXxs = 2;
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 24;
  static const double spaceXxl = 32;
  static const double spaceXxxl = 48;

  // ──────────────────────────────────────────────
  // Gutter / Margin
  // ──────────────────────────────────────────────
  static const double gutter = 16;
  static const double gutterMobile = 12;
  static const double marginHorizontal = 16;

  // ──────────────────────────────────────────────
  // Border Radius
  // ──────────────────────────────────────────────
  static const double radiusNone = 0;
  static const double radiusXs = 2;
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusFull = 9999;

  // ──────────────────────────────────────────────
  // Icon Sizes
  // ──────────────────────────────────────────────
  static const double iconXs = 14;
  static const double iconSm = 18;
  static const double iconMd = 22;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // ──────────────────────────────────────────────
  // Button Heights
  // ──────────────────────────────────────────────
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 44;
  static const double buttonHeightLg = 48;

  // ──────────────────────────────────────────────
  // Avatar Sizes
  // ──────────────────────────────────────────────
  static const double avatarXs = 24;
  static const double avatarSm = 32;
  static const double avatarMd = 36;
  static const double avatarLg = 40;
  static const double avatarXl = 56;

  // ──────────────────────────────────────────────
  // Card
  // ──────────────────────────────────────────────
  static const double cardPadding = 12;
  static const double cardPaddingLg = 16;
  static const double cardBorderWidth = 1;

  // ──────────────────────────────────────────────
  // Header / Nav Heights
  // ──────────────────────────────────────────────
  static const double topHeaderHeight = 64;
  static const double bottomNavHeight = 64;
  static const double filterBarHeight = 40;

  // ──────────────────────────────────────────────
  // Progress Bar
  // ──────────────────────────────────────────────
  static const double progressHeight = 8;
  static const double progressHeightSm = 4;

  // ──────────────────────────────────────────────
  // Badge / Dot Sizes
  // ──────────────────────────────────────────────
  static const double badgeDotSize = 8;
  static const double statusDotSize = 6;
  static const double statusDotSizeLg = 10;

  // ──────────────────────────────────────────────
  // Thumbnail / Image Heights
  // ──────────────────────────────────────────────
  static const double thumbnailHeight = 112; // h-28
  static const double thumbnailHeightSm = 96; // h-24
  static const double heroBannerHeight = 176; // h-44

  // ──────────────────────────────────────────────
  // Min Touch Target
  // ──────────────────────────────────────────────
  static const double minTouchTarget = 44;
}
