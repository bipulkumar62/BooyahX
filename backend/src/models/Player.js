/**
 * BooyahX — Player Model
 *
 * Represents a player in the BooyahX ecosystem.
 * Minimal fields — no authentication, no email, no phone.
 * Fields: name, inGameName, uid.
 */

const mongoose = require('mongoose');

const playerSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Player name is required'],
      trim: true,
      minlength: [2, 'Name must be at least 2 characters'],
      maxlength: [50, 'Name cannot exceed 50 characters'],
    },
    inGameName: {
      type: String,
      required: [true, 'In-Game Name is required'],
      trim: true,
      minlength: [2, 'IGN must be at least 2 characters'],
      maxlength: [20, 'IGN cannot exceed 20 characters'],
    },
    uid: {
      type: String,
      required: [true, 'Free Fire UID is required'],
      trim: true,
      minlength: [6, 'UID must be at least 6 characters'],
      maxlength: [12, 'UID cannot exceed 12 characters'],
      unique: true,
      index: true,
    },
  },
  {
    timestamps: true,
  }
);

const Player = mongoose.model('Player', playerSchema);

module.exports = Player;
