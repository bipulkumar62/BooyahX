/**
 * BooyahX — Wallet Model
 *
 * Player wallet with three balance types.
 * This is database structure only — no real financial transactions yet.
 */

const mongoose = require('mongoose');

const walletSchema = new mongoose.Schema(
  {
    playerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Player',
      required: [true, 'Player ID is required'],
      unique: true,
      index: true,
    },
    availableBalance: {
      type: Number,
      default: 0,
      min: [0, 'Balance cannot be negative'],
    },
    winningsBalance: {
      type: Number,
      default: 0,
      min: [0, 'Winnings cannot be negative'],
    },
    bonusBalance: {
      type: Number,
      default: 0,
      min: [0, 'Bonus cannot be negative'],
    },
  },
  {
    timestamps: true,
  }
);

const Wallet = mongoose.model('Wallet', walletSchema);

module.exports = Wallet;
