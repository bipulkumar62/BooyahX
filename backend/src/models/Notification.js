/**
 * BooyahX — Notification Model
 *
 * In-app notifications for players.
 * Supports tournament, match, room, result, reward, and system types.
 */

const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema(
  {
    playerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Player',
      required: [true, 'Player ID is required'],
      index: true,
    },
    title: {
      type: String,
      required: [true, 'Title is required'],
      trim: true,
      maxlength: [100, 'Title cannot exceed 100 characters'],
    },
    message: {
      type: String,
      required: [true, 'Message is required'],
      trim: true,
      maxlength: [500, 'Message cannot exceed 500 characters'],
    },
    type: {
      type: String,
      enum: {
        values: ['tournament', 'match', 'room', 'result', 'reward', 'system'],
        message: '{VALUE} is not a valid notification type',
      },
      required: [true, 'Type is required'],
    },
    isRead: {
      type: Boolean,
      default: false,
      index: true,
    },
    relatedTournamentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Tournament',
      default: null,
    },
    relatedMatchId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Match',
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

// Compound index for efficient queries
notificationSchema.index({ playerId: 1, isRead: 1 });
notificationSchema.index({ playerId: 1, createdAt: -1 });

const Notification = mongoose.model('Notification', notificationSchema);

module.exports = Notification;
