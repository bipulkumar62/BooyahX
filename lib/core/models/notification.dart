/// BooyahX — Notification Model
///
/// Represents a single notification entry.
/// Fields are minimal for list views. Will be extended when backend arrives.
library;

/// Types of notifications supported by the app.
enum BooyahXNotificationType {
  tournament,
  match,
  room,
  result,
  reward,
  system,
}

class BooyahXNotification {
  final String id;
  final String title;
  final String message;
  final BooyahXNotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? relatedTournamentId;
  final String? relatedMatchId;

  const BooyahXNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.relatedTournamentId,
    this.relatedMatchId,
  });

  BooyahXNotification copyWith({
    String? id,
    String? title,
    String? message,
    BooyahXNotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? relatedTournamentId,
    String? relatedMatchId,
  }) {
    return BooyahXNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      relatedTournamentId: relatedTournamentId,
      relatedMatchId: relatedMatchId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BooyahXNotification && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'BooyahXNotification(id: $id, title: $title, type: $type, isRead: $isRead)';
}
