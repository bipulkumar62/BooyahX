/// BooyahX — Match Model
///
/// Represents a player's match entry in the My Matches screen.
/// Separate from Tournament model — a match is what happens
/// after a player registers for a tournament.
enum MatchStatus {
  upcoming,
  live,
  completed,
  cancelled,
  resultPending,
}

/// Room credential data — kept separate from general match info.
/// In a real app, this would only be fetched after release time.
class RoomCredentials {
  final String roomId;
  final String roomPassword;
  final DateTime? releaseTime;

  const RoomCredentials({
    required this.roomId,
    required this.roomPassword,
    this.releaseTime,
  });

  /// Whether room credentials should be visible given the current time.
  bool get isReleased {
    if (releaseTime == null) return true;
    return DateTime.now().isAfter(releaseTime!);
  }

  /// Duration until release, or null if already released.
  Duration? get timeUntilRelease {
    if (releaseTime == null) return null;
    final now = DateTime.now();
    if (now.isAfter(releaseTime!)) return null;
    return releaseTime!.difference(now);
  }
}

/// A player's result data for a completed match.
class PlayerMatchResult {
  final int? position;
  final int? kills;
  final int? points;
  final String? winnings;
  final String? resultLabel; // e.g. "Winner", "Top 5", "Booyah"

  const PlayerMatchResult({
    this.position,
    this.kills,
    this.points,
    this.winnings,
    this.resultLabel,
  });
}

/// Full match data for the My Matches / Match Details screens.
class MatchData {
  final String id;
  final String tournamentId;
  final String tournamentName;
  final String mode;
  final String map;
  final DateTime matchDateTime;
  final String entryFee;
  final String prizePool;
  final MatchStatus status;
  final String? statusLabel;
  final String? imageUrl;

  // Room
  final RoomCredentials? roomCredentials;

  // Player info
  final String? slotNumber;
  final String? playerStatus; // e.g. "Registered", "Joined", "N/A"
  final PlayerMatchResult? result;

  // Match timing
  final DateTime? roomReleaseTime;
  final Duration? countdownDuration; // pre-computed for display

  const MatchData({
    required this.id,
    required this.tournamentId,
    required this.tournamentName,
    required this.mode,
    required this.map,
    required this.matchDateTime,
    required this.entryFee,
    required this.prizePool,
    required this.status,
    this.statusLabel,
    this.imageUrl,
    this.roomCredentials,
    this.slotNumber,
    this.playerStatus,
    this.result,
    this.roomReleaseTime,
    this.countdownDuration,
  });

  /// Whether the room credentials are currently locked.
  bool get isRoomLocked {
    if (roomReleaseTime == null) return false;
    return DateTime.now().isBefore(roomReleaseTime!);
  }

  /// Time until match starts.
  Duration? get timeUntilMatch {
    final now = DateTime.now();
    if (now.isAfter(matchDateTime)) return null;
    return matchDateTime.difference(now);
  }
}
