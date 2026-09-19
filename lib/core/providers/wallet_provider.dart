import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booyahx/core/models/wallet.dart';
import 'package:booyahx/core/data/mock_wallet.dart';

/// BooyahX — Wallet State
///
/// Manages wallet data using Riverpod.
/// This is a local-only state abstraction. When the backend is added,
/// this provider will be replaced with an async provider that fetches
/// from the API, but the UI consumers won't need to change.

enum WalletStatus { loading, normal, empty, error }

class WalletData {
  final Wallet? wallet;
  final List<WalletTransaction> transactions;
  final WalletStatus status;
  final String? errorMessage;

  const WalletData({
    this.wallet,
    this.transactions = const [],
    this.status = WalletStatus.loading,
    this.errorMessage,
  });

  WalletData copyWith({
    Wallet? wallet,
    List<WalletTransaction>? transactions,
    WalletStatus? status,
    String? errorMessage,
  }) {
    return WalletData(
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletData> {
  WalletNotifier() : super(const WalletData());

  Future<void> loadWallet() async {
    state = state.copyWith(status: WalletStatus.loading);

    try {
      final snapshot = await MockWalletData.fetchWithDelay();

      if (snapshot.transactions.isEmpty) {
        state = state.copyWith(
          wallet: snapshot.wallet,
          transactions: [],
          status: WalletStatus.empty,
        );
      } else {
        state = state.copyWith(
          wallet: snapshot.wallet,
          transactions: snapshot.transactions,
          status: WalletStatus.normal,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> retry() async {
    await loadWallet();
  }
}

final walletProvider =
    StateNotifierProvider<WalletNotifier, WalletData>(
  (ref) => WalletNotifier(),
);
