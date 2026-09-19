/// BooyahX — Player Profile Model
///
/// Represents the minimal player information collected during onboarding.
/// This model is intentionally simple. Backend fields (IDs, auth tokens)
/// will be added later without changing the UI layer.
class PlayerProfile {
  final String inGameName;
  final String freeFireUid;

  const PlayerProfile({
    required this.inGameName,
    required this.freeFireUid,
  });

  /// Create a copy with optional overrides.
  PlayerProfile copyWith({
    String? inGameName,
    String? freeFireUid,
  }) {
    return PlayerProfile(
      inGameName: inGameName ?? this.inGameName,
      freeFireUid: freeFireUid ?? this.freeFireUid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerProfile &&
        other.inGameName == inGameName &&
        other.freeFireUid == freeFireUid;
  }

  @override
  int get hashCode => inGameName.hashCode ^ freeFireUid.hashCode;

  @override
  String toString() =>
      'PlayerProfile(inGameName: $inGameName, freeFireUid: $freeFireUid)';
}
