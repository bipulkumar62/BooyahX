import 'package:booyahx/core/models/notification.dart';

/// BooyahX — Mock Notification Data
///
/// Realistic notification data for development.
/// Will be replaced by a real API data source later.
class MockNotificationData {
  MockNotificationData._();

  /// All mock notifications, most recent first.
  static List<BooyahXNotification> get all => List.unmodifiable(_notifications);

  /// Fetch with simulated network delay.
  static Future<List<BooyahXNotification>> fetchWithDelay({
    Duration delay = const Duration(milliseconds: 800),
  }) async {
    await Future.delayed(delay);
    return List.unmodifiable(_notifications);
  }

  static final _now = DateTime.now();

  static final List<BooyahXNotification> _notifications = [
    // ── Recent unread ──
    BooyahXNotification(
      id: 'n1',
      title: 'Match Starting Soon!',
      message: 'FREE FIRE - OLD THUNDER starts in 10 minutes. Get ready to drop!',
      type: BooyahXNotificationType.match,
      timestamp: _now.subtract(const Duration(minutes: 3)),
      isRead: false,
      relatedMatchId: 'match-up-001',
    ),
    BooyahXNotification(
      id: 'n2',
      title: 'Room Credentials Released',
      message: 'Room ID and password for BERMUDA CHAMPIONSHIP #104 have been released. Check match details now.',
      type: BooyahXNotificationType.room,
      timestamp: _now.subtract(const Duration(minutes: 18)),
      isRead: false,
      relatedMatchId: 'match-up-002',
    ),
    BooyahXNotification(
      id: 'n3',
      title: 'Prize Credited! 🎉',
      message: 'Congratulations! ₹250 has been credited to your wallet for winning FREE FIRE MAX ELITE CUP.',
      type: BooyahXNotificationType.reward,
      timestamp: _now.subtract(const Duration(hours: 1)),
      isRead: false,
      relatedTournamentId: 'featured-elite-cup',
    ),
    BooyahXNotification(
      id: 'n4',
      title: 'Match Result Declared',
      message: 'Results for FREE FIRE - OLD THUNDER are out. You finished #3 with 8 kills!',
      type: BooyahXNotificationType.result,
      timestamp: _now.subtract(const Duration(hours: 2)),
      isRead: false,
      relatedMatchId: 'match-up-001',
    ),
    BooyahXNotification(
      id: 'n5',
      title: 'Tournament Registration Confirmed',
      message: 'Your registration for FREE FIRE - OLD THUNDER has been confirmed. 76/100 slots filled.',
      type: BooyahXNotificationType.tournament,
      timestamp: _now.subtract(const Duration(hours: 4)),
      isRead: false,
      relatedTournamentId: 'br-001',
    ),

    // ── Older read notifications ──
    BooyahXNotification(
      id: 'n6',
      title: 'Match is Live',
      message: 'FF - SOLO RAMPAGE is now live. Room credentials have been released.',
      type: BooyahXNotificationType.match,
      timestamp: _now.subtract(const Duration(hours: 8)),
      isRead: true,
      relatedMatchId: 'match-live-001',
    ),
    BooyahXNotification(
      id: 'n7',
      title: 'Tournament Cancelled',
      message: 'Unfortunately, DUO SHOWDOWN ARENA has been cancelled by the organizer. Refund will be processed.',
      type: BooyahXNotificationType.tournament,
      timestamp: _now.subtract(const Duration(days: 1)),
      isRead: true,
      relatedTournamentId: 'duo-002',
    ),
    BooyahXNotification(
      id: 'n8',
      title: 'New Tournament Available',
      message: 'FREE FIRE - SOLO HUNTER is now open for registration. Limited slots available!',
      type: BooyahXNotificationType.tournament,
      timestamp: _now.subtract(const Duration(days: 1, hours: 6)),
      isRead: true,
      relatedTournamentId: 'br-003',
    ),
    BooyahXNotification(
      id: 'n9',
      title: 'Prize Credited',
      message: '₹150 has been credited to your wallet for 2nd place in FF - SOLO RAMPAGE.',
      type: BooyahXNotificationType.reward,
      timestamp: _now.subtract(const Duration(days: 2)),
      isRead: true,
    ),
    BooyahXNotification(
      id: 'n10',
      title: 'Welcome to BooyahX! 🎮',
      message: 'Welcome to the ultimate Free Fire tournament hub. Join tournaments, compete, and win prizes!',
      type: BooyahXNotificationType.system,
      timestamp: _now.subtract(const Duration(days: 3)),
      isRead: true,
    ),
    BooyahXNotification(
      id: 'n11',
      title: 'Room Credentials Released',
      message: 'Room ID and password for FREE FIRE - OLD THUNDER have been released.',
      type: BooyahXNotificationType.room,
      timestamp: _now.subtract(const Duration(days: 3, hours: 5)),
      isRead: true,
      relatedMatchId: 'match-up-001',
    ),
    BooyahXNotification(
      id: 'n12',
      title: 'Match Result Declared',
      message: 'Results for PURGATORY KILL RUSH #88 are out. You finished #5 with 4 kills.',
      type: BooyahXNotificationType.result,
      timestamp: _now.subtract(const Duration(days: 4)),
      isRead: true,
      relatedMatchId: 'match-play-002',
    ),
    BooyahXNotification(
      id: 'n13',
      title: 'Maintenance Notice',
      message: 'BooyahX will undergo scheduled maintenance on Sunday, 2:00 AM - 4:00 AM IST.',
      type: BooyahXNotificationType.system,
      timestamp: _now.subtract(const Duration(days: 5)),
      isRead: true,
    ),
    BooyahXNotification(
      id: 'n14',
      title: 'Tournament Full',
      message: 'FF - SOLO RAMPAGE is now full. You have been placed on the waitlist.',
      type: BooyahXNotificationType.tournament,
      timestamp: _now.subtract(const Duration(days: 6)),
      isRead: true,
      relatedTournamentId: 'br-002',
    ),
  ];
}
