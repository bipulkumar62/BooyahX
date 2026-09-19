/**
 * BooyahX — Tournament Model
 *
 * Represents a tournament in the BooyahX ecosystem.
 * Covers all fields needed for the Home and Tournament Details UI.
 */

const mongoose = require('mongoose');

const prizeDistributionSchema = new mongoose.Schema(
  {
    position: { type: String, required: true }, // e.g. "1st", "2nd", "3rd"
    prize: { type: String, required: true }, // e.g. "₹25,000"
  },
  { _id: false }
);

const tournamentRuleSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    description: { type: String, required: true },
  },
  { _id: false }
);

const tournamentSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Tournament name is required'],
      trim: true,
      maxlength: [100, 'Name cannot exceed 100 characters'],
    },
    description: {
      type: String,
      trim: true,
      default: '',
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
    dateTime: {
      type: Date,
      required: [true, 'Date/time is required'],
      index: true,
    },
    prizePool: {
      type: String,
      required: [true, 'Prize pool is required'],
    },
    entryFee: {
      type: String,
      required: [true, 'Entry fee is required'],
    },
    perKill: {
      type: String,
      default: '',
    },
    totalSlots: {
      type: Number,
      required: [true, 'Total slots is required'],
      min: [1, 'Must have at least 1 slot'],
    },
    filledSlots: {
      type: Number,
      default: 0,
      min: 0,
    },
    status: {
      type: String,
      enum: {
        values: [
          'open',
          'registrationOpen',
          'almostFull',
          'closingSoon',
          'full',
          'live',
          'completed',
          'cancelled',
        ],
        message: '{VALUE} is not a valid tournament status',
      },
      default: 'open',
      index: true,
    },
    category: {
      type: String,
      enum: {
        values: ['soloBr', 'duoBr', 'duoPerKill', 'soloPerKill', 'all'],
        message: '{VALUE} is not a valid category',
      },
      default: 'all',
    },
    isFeatured: {
      type: Boolean,
      default: false,
    },
    imageUrl: {
      type: String,
      default: '',
    },
    rules: [tournamentRuleSchema],
    prizeDistribution: [prizeDistributionSchema],
  },
  {
    timestamps: true,
  }
);

const Tournament = mongoose.model('Tournament', tournamentSchema);

module.exports = Tournament;
