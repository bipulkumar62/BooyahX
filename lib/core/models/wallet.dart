/// BooyahX — Wallet Model
///
/// Represents wallet balance and transaction data.
/// Fields are minimal for list views. Will be extended when backend arrives.
library;

/// Types of wallet transactions.
enum WalletTransactionType {
  tournamentEntry,
  winnings,
  refund,
  deposit,
  withdrawal,
}

/// Status of a wallet transaction.
enum WalletTransactionStatus {
  completed,
  pending,
  failed,
}

class Wallet {
  final double availableBalance;
  final double winningsBalance;
  final double bonusBalance;

  const Wallet({
    required this.availableBalance,
    required this.winningsBalance,
    this.bonusBalance = 0,
  });

  double get totalBalance => availableBalance + winningsBalance + bonusBalance;
}

class WalletTransaction {
  final String id;
  final WalletTransactionType type;
  final String title;
  final double amount;
  final WalletTransactionStatus status;
  final DateTime timestamp;
  final String? referenceId;
  final String? relatedTournamentId;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.title,
    required this.amount,
    required this.status,
    required this.timestamp,
    this.referenceId,
    this.relatedTournamentId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WalletTransaction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'WalletTransaction(id: $id, title: $title, amount: $amount, status: $status)';
}
