/// BooyahX — Time Formatting Utility
///
/// Formats DateTime objects into user-friendly relative time strings.
/// No external dependencies required.
library;

class TimeFormatter {
  TimeFormatter._();

  /// Format a [DateTime] into a relative time string.
  ///
  /// Examples:
  /// - "Just now" (< 1 minute)
  /// - "5 min ago" (< 60 minutes)
  /// - "2 hours ago" (< 24 hours)
  /// - "Yesterday" (< 48 hours)
  /// - "Sep 18" (same year)
  /// - "Sep 18, 2025" (different year)
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inHours < 48) {
      return 'Yesterday';
    } else if (difference.inDays < 365 && dateTime.year == now.year) {
      return _formatDate(dateTime);
    } else {
      return '${_formatDate(dateTime)}, ${dateTime.year}';
    }
  }

  static String _formatDate(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}';
  }
}
