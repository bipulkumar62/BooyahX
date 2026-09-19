import 'package:booyahx/core/models/match.dart';

/// BooyahX — Mock Match Data
///
/// Realistic match data for My Matches, Match Details, and Room Details screens.
/// Will be replaced by a real API data source later.
class MockMatchData {
  MockMatchData._();

  // ── Helper: build DateTime relative to now ──
  static DateTime _future(Duration offset) => DateTime.now().add(offset);
  static DateTime _past(Duration offset) => DateTime.now().subtract(offset);

  // ── Upcoming Matches ──
  static final List<MatchData> upcoming = [
    // 1 — Room locked (release in 4h 32m)
    MatchData(
      id: 'match-up-001',
      tournamentId: 'br-001',
      tournamentName: 'FREE FIRE - OLD THUNDER',
      mode: 'SOLO BR',
      map: 'Bermuda',
      matchDateTime: _future(const Duration(hours: 5)),
      entryFee: '₹50',
      prizePool: '₹10,000',
      status: MatchStatus.upcoming,
      statusLabel: 'Upcoming',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBvt8LxaOaJEGut5AH5GdcYvAQPhFd4aywrRQ6thy47c1Bjdz16BIHblnLK_W03drfWJ0Lto0Iua96RmWzvSBbE-hNT52dP8Lg7ziU97Ux-VLicjFCwU3AOkI3Z6Pxc2Vn_ua_M5FhEEQCEvrSM90GGFlX732SO9-p4Sw8wY04QkMzMEL76_EftVP9_XFgn_UWGoYTqobxnLrJRpfjksYesWWcW81Q8m8ohoYcdOUZOTv5TvqzCyV5U',
      slotNumber: 'SLOT 23',
      playerStatus: 'Registered',
      roomCredentials: RoomCredentials(
        roomId: '504871236',
        roomPassword: 'THUNDER01',
        releaseTime: _future(const Duration(hours: 4, minutes: 32)),
      ),
      roomReleaseTime: _future(const Duration(hours: 4, minutes: 32)),
    ),
    // 2 — Room already released (testable)
    MatchData(
      id: 'match-up-002',
      tournamentId: 'br-004',
      tournamentName: 'BERMUDA CHAMPIONSHIP #104',
      mode: 'SOLO BR',
      map: 'Bermuda',
      matchDateTime: _future(const Duration(hours: 2, minutes: 30)),
      entryFee: '₹50',
      prizePool: '₹10,000',
      status: MatchStatus.upcoming,
      statusLabel: 'Upcoming',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBvt8LxaOaJEGut5AH5GdcYvAQPhFd4aywrRQ6thy47c1Bjdz16BIHblnLK_W03drfWJ0Lto0Iua96RmWzvSBbE-hNT52dP8Lg7ziU97Ux-VLicjFCwU3AOkI3Z6Pxc2Vn_ua_M5FhEEQCEvrSM90GGFlX732SO9-p4Sw8wY04QkMzMEL76_EftVP9_XFgn_UWGoYTqobxnLrJRpfjksYesWWcW81Q8m8ohoYcdOUZOTv5TvqzCyV5U',
      slotNumber: 'SLOT 07',
      playerStatus: 'Registered',
      roomCredentials: RoomCredentials(
        roomId: '501923478',
        roomPassword: 'CHAMP04',
        releaseTime: _past(const Duration(minutes: 10)),
      ),
      roomReleaseTime: _past(const Duration(minutes: 10)),
    ),
  ];

  // ── Live Matches ──
  static final List<MatchData> live = [
    MatchData(
      id: 'match-live-001',
      tournamentId: 'br-002',
      tournamentName: 'FF - SOLO RAMPAGE',
      mode: 'SOLO BR',
      map: 'Bermuda',
      matchDateTime: _past(const Duration(minutes: 15)),
      entryFee: '₹40',
      prizePool: '₹8,000',
      status: MatchStatus.live,
      statusLabel: 'Live',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBvt8LxaOaJEGut5AH5GdcYvAQPhFd4aywrRQ6thy47c1Bjdz16BIHblnLK_W03drfWJ0Lto0Iua96RmWzvSBbE-hNT52dP8Lg7ziU97Ux-VLicjFCwU3AOkI3Z6Pxc2Vn_ua_M5FhEEQCEvrSM90GGFlX732SO9-p4Sw8wY04QkMzMEL76_EftVP9_XFgn_UWGoYTqobxnLrJRpfjksYesWWcW81Q8m8ohoYcdOUZOTv5TvqzCyV5U',
      slotNumber: 'SLOT 15',
      playerStatus: 'In Match',
      roomCredentials: RoomCredentials(
        roomId: '503218476',
        roomPassword: 'RAMPAGE',
      ),
    ),
  ];

  // ── Played Matches ──
  static final List<MatchData> played = [
    // Completed with result
    MatchData(
      id: 'match-play-001',
      tournamentId: 'featured-elite-cup',
      tournamentName: 'FREE FIRE MAX ELITE CUP',
      mode: 'SOLO BR',
      map: 'Bermuda',
      matchDateTime: _past(const Duration(days: 1, hours: 3)),
      entryFee: '₹100',
      prizePool: '₹50,000',
      status: MatchStatus.completed,
      statusLabel: 'Completed',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBvt8LxaOaJEGut5AH5GdcYvAQPhFd4aywrRQ6thy47c1Bjdz16BIHblnLK_W03drfWJ0Lto0Iua96RmWzvSBbE-hNT52dP8Lg7ziU97Ux-VLicjFCwU3AOkI3Z6Pxc2Vn_ua_M5FhEEQCEvrSM90GGFlX732SO9-p4Sw8wY04QkMzMEL76_EftVP9_XFgn_UWGoYTqobxnLrJRpfjksYesWWcW81Q8m8ohoYcdOUZOTv5TvqzCyV5U',
      slotNumber: 'SLOT 42',
      playerStatus: 'Completed',
      result: const PlayerMatchResult(
        position: 5,
        kills: 8,
        points: 45,
        winnings: '₹250',
        resultLabel: 'Top 5',
      ),
    ),
    // Result pending
    MatchData(
      id: 'match-play-002',
      tournamentId: 'kill-001',
      tournamentName: 'PURGATORY KILL RUSH #88',
      mode: 'SOLO PER KILL',
      map: 'Purgatory',
      matchDateTime: _past(const Duration(hours: 4)),
      entryFee: '₹30',
      prizePool: '₹5,000',
      status: MatchStatus.resultPending,
      statusLabel: 'Result Pending',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB8TuY8g-iIobdUwIuG1PRqYhBk8Y4AP3DlbbTRQ7JSS5JIchqfwDAgMbeBFMPQUbQiH1x9ozu0ALmQbOSVpp-J1FeQhJ0A4pckRhKI-1kS0aVT5G_5VPrgNeDsEeIybhKfz9qDLhfyV_-mi8ZJSg-CAPUiPDAHvnoNb68YBVKWHZsTmBgAMd5XtpZ21JyD93HX_F6dse7CI3_7wyNp7qNo1mMFwc255GSJj8V9mtPQOeGP9BlCrLDp',
      slotNumber: 'SLOT 11',
      playerStatus: 'Awaiting Result',
    ),
    // Completed — cancelled
    MatchData(
      id: 'match-play-003',
      tournamentId: 'duo-002',
      tournamentName: 'DUO SHOWDOWN ARENA',
      mode: 'DUO BR',
      map: 'Bermuda',
      matchDateTime: _past(const Duration(days: 3)),
      entryFee: '₹70',
      prizePool: '₹12,000',
      status: MatchStatus.cancelled,
      statusLabel: 'Cancelled',
      slotNumber: 'TEAM 06',
      playerStatus: 'Cancelled',
    ),
    // Completed with good result
    MatchData(
      id: 'match-play-004',
      tournamentId: 'br-003',
      tournamentName: 'FREE FIRE - SOLO HUNTER',
      mode: 'SOLO BR',
      map: 'Kalahari',
      matchDateTime: _past(const Duration(days: 5)),
      entryFee: '₹30',
      prizePool: '₹6,000',
      status: MatchStatus.completed,
      statusLabel: 'Completed',
      slotNumber: 'SLOT 34',
      playerStatus: 'Completed',
      result: const PlayerMatchResult(
        position: 1,
        kills: 12,
        points: 72,
        winnings: '₹2,000',
        resultLabel: 'Booyah',
      ),
    ),
  ];

  /// Get all matches for a given status.
  static List<MatchData> byStatus(MatchStatus status) {
    return switch (status) {
      MatchStatus.upcoming => upcoming,
      MatchStatus.live => live,
      MatchStatus.completed || MatchStatus.resultPending || MatchStatus.cancelled => played,
    };
  }

  /// Get a match by its ID. Returns null if not found.
  static MatchData? byId(String id) {
    final all = [...upcoming, ...live, ...played];
    try {
      return all.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Total live match count for badge display.
  static int get liveCount => live.length;
}
