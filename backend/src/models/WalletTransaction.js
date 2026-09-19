/**
 * BooyahX — WalletTransaction Model
 *
 * Records all wallet transactions (deposits, withdrawals, entries, winnings, refunds).
 * This is database structure only — no payment gateway integration.
 */

const mongoose = require('mongoose');

const walletTransactionSchema = new mongoose.Schema(
  {
    playerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Player',
      required: [true, 'Player ID is required'],
      index: true,
    },
    type: {
      type: String,
      enum: {
        values: [
          'deposit',
          'withdrawal',
          'tournamentEntry',
          'winnings',
          'refund',
          'bonus',
          'adjustment',
          'cashback',
        ],
        message: '{VALUE} is not a valid transaction type',
      },
      required: [true, 'Transaction type is required'],
    },
    title: {
      type: String,
      required: [true, 'Title is required'],
      trim: true,
    },
    amount: {
      type: Number,
      required: [true, 'Amount is required'],
    },
    status: {
      type: String,
      enum: {
        values: ['completed', 'pending', 'failed'],
        message: '{VALUE} is not a valid transaction status',
      },
      default: 'completed',
    },
    referenceId: {
      type: String,
      default: '',
    },
    relatedTournamentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Tournament',
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

// Compound index for efficient queries
walletTransactionSchema.index({ playerId: 1, createdAt: -1 });
walletTransactionSchema.index({ playerId: 1, type: 1 });

const WalletTransaction = mongoose.model(
  'WalletTransaction',
  walletTransactionSchema
);

module.exports = WalletTransaction;
