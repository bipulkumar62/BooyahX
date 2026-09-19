/// BooyahX — Player Profile Model
///
/// Represents the player information collected during onboarding.
/// Supports both local-only mode and backend integration via `_id`.
class PlayerProfile {
  /// Backend MongoDB ID. Null when created locally before API sync.
  final String? id;
  final String inGameName;
  final String freeFireUid;

  const PlayerProfile({
    this.id,
    required this.inGameName,
    required this.freeFireUid,
  });

  /// Create from API JSON response.
  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    return PlayerProfile(
      id: json['_id']?.toString(),
      inGameName: json['inGameName'] as String? ?? '',
      freeFireUid: json['freeFireUid'] as String? ?? '',
    );
  }

  /// Convert to JSON for API calls.
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'inGameName': inGameName,
      'freeFireUid': freeFireUid,
    };
  }

  /// Create a copy with optional overrides.
  PlayerProfile copyWith({
    String? id,
    String? inGameName,
    String? freeFireUid,
  }) {
    return PlayerProfile(
      id: id ?? this.id,
      inGameName: inGameName ?? this.inGameName,
      freeFireUid: freeFireUid ?? this.freeFireUid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerProfile &&
        other.id == id &&
        other.inGameName == inGameName &&
        other.freeFireUid == freeFireUid;
  }

  @override
  int get hashCode => id.hashCode ^ inGameName.hashCode ^ freeFireUid.hashCode;

  @override
  String toString() =>
      'PlayerProfile(id: $id, inGameName: $inGameName, freeFireUid: $freeFireUid)';
}
