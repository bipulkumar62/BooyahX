/**
 * BooyahX — Match Model
 *
 * Represents a player's match entry after tournament registration.
 * Room credentials are stored but MUST NOT be returned
 * to clients before roomReleaseTime.
 */

const mongoose = require('mongoose');

const matchSchema = new mongoose.Schema(
  {
    tournamentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Tournament',
      required: [true, 'Tournament ID is required'],
      index: true,
    },
    tournamentName: {
      type: String,
      required: [true, 'Tournament name is required'],
      trim: true,
    },
    playerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Player',
      required: [true, 'Player ID is required'],
      index: true,
    },
    mode: {
      type: String,
      required: [true, 'Mode is required'],
      trim: true,
    },
    map: {
      type: String,
      required: [true, 'Map is required'],
      trim: true,
    },
    matchDateTime: {
      type: Date,
      required: [true, 'Match date/time is required'],
      index: true,
    },
    entryFee: {
      type: String,
      required: [true, 'Entry fee is required'],
    },
    prizePool: {
      type: String,
      required: [true, 'Prize pool is required'],
    },
    status: {
      type: String,
      enum: {
        values: ['upcoming', 'live', 'completed', 'cancelled', 'resultPending'],
        message: '{VALUE} is not a valid match status',
      },
      default: 'upcoming',
      index: true,
    },
    playerStatus: {
      type: String,
      default: 'Registered',
    },
    slotNumber: {
      type: String,
      default: '',
    },
    imageUrl: {
      type: String,
      default: '',
    },
    // Room credentials — stored but gated by releaseTime
    roomId: {
      type: String,
      default: '',
    },
    roomPassword: {
      type: String,
      default: '',
    },
    roomReleaseTime: {
      type: Date,
      default: null,
    },
    // Result data (populated after match completes)
    result: {
      position: { type: Number, default: null },
      kills: { type: Number, default: null },
      points: { type: Number, default: null },
      winnings: { type: String, default: '' },
      resultLabel: { type: String, default: '' },
    },
  },
  {
    timestamps: true,
  }
);

// Compound index for efficient queries
matchSchema.index({ playerId: 1, status: 1 });
matchSchema.index({ tournamentId: 1, playerId: 1 });

const Match = mongoose.model('Match', matchSchema);

module.exports = Match;
