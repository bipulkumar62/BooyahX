/// BooyahX — Player Stats Model
///
/// Represents mock player statistics for the Profile screen.
/// Will be replaced by real API data later.
library;

class PlayerStats {
  final int totalMatches;
  final int wins;
  final int kills;
  final int points;
  final String earnings;

  const PlayerStats({
    required this.totalMatches,
    required this.wins,
    required this.kills,
    required this.points,
    required this.earnings,
  });

  double get winRate =>
      totalMatches > 0 ? (wins / totalMatches * 100) : 0;

  double get killsPerMatch =>
      totalMatches > 0 ? (kills / totalMatches) : 0;
}
