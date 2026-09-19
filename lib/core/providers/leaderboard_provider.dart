import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booyahx/core/models/leaderboard.dart';
import 'package:booyahx/core/data/mock_leaderboard.dart';

/// BooyahX — Leaderboard State
///
/// Manages leaderboard data using Riverpod.
/// This is a local-only state abstraction. When the backend is added,
/// this provider will be replaced with an async provider that fetches
/// from the API, but the UI consumers won't need to change.

enum LeaderboardStatus { loading, normal, empty, error }

class LeaderboardData {
  final List<LeaderboardPlayer> players;
  final LeaderboardStatus status;
  final String? errorMessage;

  const LeaderboardData({
    this.players = const [],
    this.status = LeaderboardStatus.loading,
    this.errorMessage,
  });

  LeaderboardData copyWith({
    List<LeaderboardPlayer>? players,
    LeaderboardStatus? status,
    String? errorMessage,
  }) {
    return LeaderboardData(
      players: players ?? this.players,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class LeaderboardNotifier extends StateNotifier<LeaderboardData> {
  LeaderboardFilter _filter = LeaderboardFilter.overall;

  LeaderboardNotifier() : super(const LeaderboardData());

  LeaderboardFilter get filter => _filter;

  Future<void> loadLeaderboard() async {
    state = state.copyWith(status: LeaderboardStatus.loading);

    try {
      final players = await MockLeaderboardData.fetchWithDelay(_filter);

      if (players.isEmpty) {
        state = state.copyWith(
          players: [],
          status: LeaderboardStatus.empty,
        );
      } else {
        state = state.copyWith(
          players: players,
          status: LeaderboardStatus.normal,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: LeaderboardStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> changeFilter(LeaderboardFilter filter) async {
    if (filter == _filter) return;
    _filter = filter;
    await loadLeaderboard();
  }

  Future<void> retry() async {
    await loadLeaderboard();
  }
}

final leaderboardProvider =
    StateNotifierProvider<LeaderboardNotifier, LeaderboardData>(
  (ref) => LeaderboardNotifier(),
);
