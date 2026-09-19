import 'package:flutter_riverpod/flutter_riverpod.dart';

/// BooyahX — Profile Settings State
///
/// Manages local-only profile settings using Riverpod.
/// These are UI preferences that don't require a backend.
class ProfileSettings {
  final bool notificationsEnabled;
  final bool soundEnabled;

  const ProfileSettings({
    this.notificationsEnabled = true,
    this.soundEnabled = true,
  });

  ProfileSettings copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
  }) {
    return ProfileSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

class ProfileSettingsNotifier extends StateNotifier<ProfileSettings> {
  ProfileSettingsNotifier() : super(const ProfileSettings());

  void toggleNotifications() {
    state = state.copyWith(
      notificationsEnabled: !state.notificationsEnabled,
    );
  }

  void toggleSound() {
    state = state.copyWith(
      soundEnabled: !state.soundEnabled,
    );
  }
}

final profileSettingsProvider =
    StateNotifierProvider<ProfileSettingsNotifier, ProfileSettings>(
  (ref) => ProfileSettingsNotifier(),
);
