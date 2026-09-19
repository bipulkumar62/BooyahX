import 'package:booyahx/core/models/player_stats.dart';

/// BooyahX — Mock Player Stats Data
///
/// Realistic player statistics for the Profile screen.
/// Will be replaced by a real API data source later.
class MockPlayerStats {
  MockPlayerStats._();

  /// Default stats for the current player.
  static const PlayerStats currentPlayer = PlayerStats(
    totalMatches: 87,
    wins: 23,
    kills: 945,
    points: 12450,
    earnings: '₹4,850',
  );
}
