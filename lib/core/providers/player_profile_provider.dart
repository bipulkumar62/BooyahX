import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booyahx/core/models/player_profile.dart';

/// BooyahX — Player Profile State
///
/// Manages the current player's profile data using Riverpod.
/// This is a local-only state abstraction. When the backend is added,
/// this provider will be replaced with an async provider that fetches
/// from the API, but the UI consumers won't need to change.
class PlayerProfileNotifier extends StateNotifier<PlayerProfile?> {
  PlayerProfileNotifier() : super(null);

  /// Set the player profile after onboarding.
  void setProfile({required String inGameName, required String freeFireUid}) {
    state = PlayerProfile(
      inGameName: inGameName,
      freeFireUid: freeFireUid,
    );
  }

  /// Clear the player profile (e.g., on logout).
  void clearProfile() {
    state = null;
  }

  /// Update specific fields.
  void updateProfile({
    String? inGameName,
    String? freeFireUid,
  }) {
    if (state == null) return;
    state = state!.copyWith(
      inGameName: inGameName,
      freeFireUid: freeFireUid,
    );
  }
}

/// Provider for the player profile state.
///
/// Reads: `ref.watch(playerProfileProvider)`
/// Updates: `ref.read(playerProfileProvider.notifier).setProfile(...)`
final playerProfileProvider =
    StateNotifierProvider<PlayerProfileNotifier, PlayerProfile?>(
  (ref) => PlayerProfileNotifier(),
);

/// Convenience provider to check if the player has completed onboarding.
final isPlayerSetupProvider = Provider<bool>((ref) {
  final profile = ref.watch(playerProfileProvider);
  return profile != null;
});
