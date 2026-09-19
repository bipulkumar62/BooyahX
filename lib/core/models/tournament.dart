/// BooyahX — Tournament Model
///
/// Represents a tournament entry on the Home screen.
/// Fields are intentionally minimal for the Home list view.
/// This model will be extended when backend integration arrives.
enum TournamentCategory {
  soloBr,
  duoBr,
  duoPerKill,
  soloPerKill,
  all,
}

enum TournamentStatus {
  open,
  registrationOpen,
  almostFull,
  closingSoon,
  full,
  live,
  completed,
  cancelled,
}

/// Lightweight tournament data for list views.
class Tournament {
  final String id;
  final String name;
  final String? description;
  final String mode;
  final String map;
  final String? dateTime;
  final String? prizePool;
  final String? perKill;
  final String? entryFee;
  final int? totalSlots;
  final int? filledSlots;
  final TournamentStatus status;
  final String? statusLabel;
  final String? ctaLabel;
  final String? imageUrl;
  final TournamentCategory category;
  final bool isFeatured;
  final String? featuredPrizePool;
  final String? featuredTimeLeft;
  final int? featuredJoinedCount;
  final int? featuredTotalCount;

  const Tournament({
    required this.id,
    required this.name,
    this.description,
    required this.mode,
    required this.map,
    this.dateTime,
    this.prizePool,
    this.perKill,
    this.entryFee,
    this.totalSlots,
    this.filledSlots,
    this.status = TournamentStatus.open,
    this.statusLabel,
    this.ctaLabel,
    this.imageUrl,
    this.category = TournamentCategory.all,
    this.isFeatured = false,
    this.featuredPrizePool,
    this.featuredTimeLeft,
    this.featuredJoinedCount,
    this.featuredBannerImage,
    this.featuredTotalCount,
  });

  /// Alternate image for the featured banner.
  final String? featuredBannerImage;

  int? get remainingSlots {
    if (totalSlots == null || filledSlots == null) return null;
    return totalSlots! - filledSlots!;
  }

  double? get slotProgress {
    if (totalSlots == null || filledSlots == null || totalSlots == 0) return null;
    return filledSlots! / totalSlots!;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tournament && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Tournament(id: $id, name: $name, category: $category)';
}

// ══════════════════════════════════════════════════════════
// Tournament Detail Models
// ══════════════════════════════════════════════════════════

/// A prize distribution entry for a tournament rank.
class PrizeDistribution {
  final int? rank;
  final String? rankRange; // e.g. "#4 - #5"
  final String title;
  final String? subtitle;
  final String amount;
  final String? amountEach;
  final String? percentage;
  final bool isHighlighted; // for champion / special prizes
  final bool isSpecialBonus;

  const PrizeDistribution({
    this.rank,
    this.rankRange,
    required this.title,
    this.subtitle,
    required this.amount,
    this.amountEach,
    this.percentage,
    this.isHighlighted = false,
    this.isSpecialBonus = false,
  });
}

/// A player who has joined a tournament.
class TournamentPlayer {
  final int rank;
  final String name;
  final String uid;
  final int level;
  final String? slotLabel;
  final String? avatarUrl;

  const TournamentPlayer({
    required this.rank,
    required this.name,
    required this.uid,
    required this.level,
    this.slotLabel,
    this.avatarUrl,
  });
}

/// A single tournament rule with a title and description.
class TournamentRule {
  final int number;
  final String title;
  final String description;

  const TournamentRule({
    required this.number,
    required this.title,
    required this.description,
  });
}

/// Full tournament detail data, loaded from the detail data source.
class TournamentDetail {
  final Tournament tournament;
  final List<PrizeDistribution> prizeDistribution;
  final String? killBountyLabel;
  final String? killBountyAmount;
  final String? killBountyDescription;
  final List<TournamentPlayer> players;
  final List<TournamentRule> rules;
  final bool hasJoined;
  final String? joinSlotLabel;
  final String? perKillAmount;
  final String? tournamentModeDetail; // e.g. "TPP"
  final String? regionLabel;

  const TournamentDetail({
    required this.tournament,
    required this.prizeDistribution,
    this.killBountyLabel,
    this.killBountyAmount,
    this.killBountyDescription,
    required this.players,
    required this.rules,
    this.hasJoined = false,
    this.joinSlotLabel,
    this.perKillAmount,
    this.tournamentModeDetail,
    this.regionLabel,
  });
}
