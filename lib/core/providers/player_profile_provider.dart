import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booyahx/core/models/player_profile.dart';
import 'package:booyahx/services/api_service.dart';

/// BooyahX — Player Profile State
///
/// Manages the current player's profile data using Riverpod.
/// Syncs with the backend API when available.
class PlayerProfileNotifier extends StateNotifier<PlayerProfile?> {
  PlayerProfileNotifier() : super(null);

  final _api = ApiService.instance;

  /// Set the player profile after onboarding.
  /// Creates the player on the backend if possible.
  Future<void> setProfile({
    required String name,
    required String inGameName,
    required String uid,
  }) async {
    try {
      // Try to create/fetch player on backend
      final data = await _api.createPlayer(
        name: name,
        inGameName: inGameName,
        uid: uid,
      );
      state = PlayerProfile.fromJson(data);
    } catch (e) {
      // If backend is unreachable, save locally
      state = PlayerProfile(
        name: name,
        inGameName: inGameName,
        uid: uid,
      );
    }
  }

  /// Clear the player profile (e.g., on logout).
  void clearProfile() {
    state = null;
  }

  /// Update specific fields.
  void updateProfile({
    String? name,
    String? inGameName,
    String? uid,
  }) {
    if (state == null) return;
    state = state!.copyWith(
      name: name,
      inGameName: inGameName,
      uid: uid,
    );

    // Sync with backend if we have an ID
    if (state!.id != null) {
      _api.updatePlayer(
        state!.id!,
        name: name,
        inGameName: inGameName,
        uid: uid,
      );
    }
  }
}

/// Provider for the player profile state.
final playerProfileProvider =
    StateNotifierProvider<PlayerProfileNotifier, PlayerProfile?>(
  (ref) => PlayerProfileNotifier(),
);

/// Convenience provider to check if the player has completed onboarding.
final isPlayerSetupProvider = Provider<bool>((ref) {
  final profile = ref.watch(playerProfileProvider);
  return profile != null;
});
