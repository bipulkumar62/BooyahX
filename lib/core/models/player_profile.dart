/// BooyahX — Player Profile Model
///
/// Represents the player information collected during onboarding.
/// Supports both local-only mode and backend integration via `_id`.
class PlayerProfile {
  /// Backend MongoDB ID. Null when created locally before API sync.
  final String? id;
  final String name;
  final String inGameName;
  final String uid;

  const PlayerProfile({
    this.id,
    required this.name,
    required this.inGameName,
    required this.uid,
  });

  /// Create from API JSON response.
  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    return PlayerProfile(
      id: json['_id']?.toString(),
      name: json['name'] as String? ?? '',
      inGameName: json['inGameName'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
    );
  }

  /// Convert to JSON for API calls.
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'inGameName': inGameName,
      'uid': uid,
    };
  }

  /// Create a copy with optional overrides.
  PlayerProfile copyWith({
    String? id,
    String? name,
    String? inGameName,
    String? uid,
  }) {
    return PlayerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      inGameName: inGameName ?? this.inGameName,
      uid: uid ?? this.uid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerProfile &&
        other.id == id &&
        other.name == name &&
        other.inGameName == inGameName &&
        other.uid == uid;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ inGameName.hashCode ^ uid.hashCode;

  @override
  String toString() =>
      'PlayerProfile(id: $id, name: $name, inGameName: $inGameName, uid: $uid)';
}
