import 'package:booyahx/core/models/wallet.dart';

/// BooyahX — Mock Wallet Data
///
/// Realistic wallet data for development.
/// Will be replaced by a real API data source later.
class MockWalletData {
  MockWalletData._();

  /// Mock wallet balance.
  static const Wallet wallet = Wallet(
    availableBalance: 1250,
    winningsBalance: 4850,
    bonusBalance: 200,
  );

  /// All mock transactions, most recent first.
  static List<WalletTransaction> get transactions =>
      List.unmodifiable(_transactions);

  /// Fetch with simulated network delay.
  static Future<WalletSnapshot> fetchWithDelay({
    Duration delay = const Duration(milliseconds: 800),
  }) async {
    await Future.delayed(delay);
    return WalletSnapshot(
      wallet: wallet,
      transactions: List.unmodifiable(_transactions),
    );
  }

  static final _now = DateTime.now();

  static final List<WalletTransaction> _transactions = [
    WalletTransaction(
      id: 'txn1',
      type: WalletTransactionType.winnings,
      title: 'Prize — Solo BR Cup #140',
      amount: 250,
      status: WalletTransactionStatus.completed,
      timestamp: _now.subtract(const Duration(hours: 2)),
      referenceId: 'WIN-140-003',
      relatedTournamentId: 't1',
    ),
    WalletTransaction(
      id: 'txn2',
      type: WalletTransactionType.tournamentEntry,
      title: 'Entry — Duo Showdown #89',
      amount: 50,
      status: WalletTransactionStatus.completed,
      timestamp: _now.subtract(const Duration(hours: 5)),
      referenceId: 'REG-89-012',
      relatedTournamentId: 't2',
    ),
    WalletTransaction(
      id: 'txn3',
      type: WalletTransactionType.winnings,
      title: 'Prize — Squad Rush #67',
      amount: 500,
      status: WalletTransactionStatus.completed,
      timestamp: _now.subtract(const Duration(hours: 8)),
      referenceId: 'WIN-67-001',
      relatedTournamentId: 't3',
    ),
    WalletTransaction(
      id: 'txn4',
      type: WalletTransactionType.deposit,
      title: 'Wallet Top-up',
      amount: 500,
      status: WalletTransactionStatus.completed,
      timestamp: _now.subtract(const Duration(days: 1)),
      referenceId: 'DEP-0045',
    ),
    WalletTransaction(
      id: 'txn5',
      type: WalletTransactionType.tournamentEntry,
      title: 'Entry — Solo BR Cup #142',
      amount: 30,
      status: WalletTransactionStatus.pending,
      timestamp: _now.subtract(const Duration(days: 1, hours: 3)),
      referenceId: 'REG-142-008',
      relatedTournamentId: 't5',
    ),
    WalletTransaction(
      id: 'txn6',
      type: WalletTransactionType.refund,
      title: 'Refund — Weekend Warriors Cup (Cancelled)',
      amount: 100,
      status: WalletTransactionStatus.completed,
      timestamp: _now.subtract(const Duration(days: 2)),
      referenceId: 'REF-0012',
      relatedTournamentId: 't6',
    ),
    WalletTransaction(
      id: 'txn7',
      type: WalletTransactionType.winnings,
      title: 'Prize — Solo BR Cup #138',
      amount: 150,
      status: WalletTransactionStatus.completed,
      timestamp: _now.subtract(const Duration(days: 3)),
      referenceId: 'WIN-138-005',
      relatedTournamentId: 't7',
    ),
    WalletTransaction(
      id: 'txn8',
      type: WalletTransactionType.withdrawal,
      title: 'Withdrawal to UPI',
      amount: 1000,
      status: WalletTransactionStatus.failed,
      timestamp: _now.subtract(const Duration(days: 4)),
      referenceId: 'WTH-0008',
    ),
    WalletTransaction(
      id: 'txn9',
      type: WalletTransactionType.tournamentEntry,
      title: 'Entry — Duo Showdown #86',
      amount: 50,
      status: WalletTransactionStatus.completed,
      timestamp: _now.subtract(const Duration(days: 5)),
      referenceId: 'REG-86-004',
      relatedTournamentId: 't9',
    ),
    WalletTransaction(
      id: 'txn10',
      type: WalletTransactionType.deposit,
      title: 'Wallet Top-up',
      amount: 1000,
      status: WalletTransactionStatus.completed,
      timestamp: _now.subtract(const Duration(days: 6)),
      referenceId: 'DEP-0038',
    ),
    WalletTransaction(
      id: 'txn11',
      type: WalletTransactionType.winnings,
      title: 'Prize — Solo BR Cup #135',
      amount: 100,
      status: WalletTransactionStatus.completed,
      timestamp: _now.subtract(const Duration(days: 7)),
      referenceId: 'WIN-135-007',
      relatedTournamentId: 't11',
    ),
    WalletTransaction(
      id: 'txn12',
      type: WalletTransactionType.tournamentEntry,
      title: 'Entry — Free Fire Friday Cup',
      amount: 75,
      status: WalletTransactionStatus.completed,
      timestamp: _now.subtract(const Duration(days: 8)),
      referenceId: 'REG-FF-002',
      relatedTournamentId: 't12',
    ),
  ];
}

/// Combined wallet snapshot for loading.
class WalletSnapshot {
  final Wallet wallet;
  final List<WalletTransaction> transactions;

  const WalletSnapshot({
    required this.wallet,
    required this.transactions,
  });
}
