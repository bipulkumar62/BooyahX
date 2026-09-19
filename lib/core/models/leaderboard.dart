/// BooyahX — Leaderboard Model
///
/// Represents a player's ranking entry on the Leaderboard screen.
/// Fields are minimal for list views. Will be extended when backend arrives.
library;

enum LeaderboardFilter {
  overall,
  weekly,
  monthly,
  season,
}

class LeaderboardPlayer {
  final String id;
  final String inGameName;
  final String? avatarUrl;
  final int rank;
  final int matches;
  final int kills;
  final int points;
  final String? winnings;

  const LeaderboardPlayer({
    required this.id,
    required this.inGameName,
    this.avatarUrl,
    required this.rank,
    required this.matches,
    required this.kills,
    required this.points,
    this.winnings,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeaderboardPlayer && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'LeaderboardPlayer(id: $id, name: $inGameName, rank: $rank, points: $points)';
}
