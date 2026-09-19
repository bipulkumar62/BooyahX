/**
 * BooyahX — Player Controller
 *
 * Handles player-related API operations with MongoDB.
 */

const Player = require('../models/Player');
const { sendSuccess, sendError } = require('../utils/response');

/**
 * GET /api/players
 * List all players.
 */
async function getPlayers(req, res) {
  try {
    const players = await Player.find().sort({ createdAt: -1 });
    return sendSuccess(res, 'Players fetched successfully', players);
  } catch (error) {
    return sendError(res, 'Failed to fetch players', 500);
  }
}

/**
 * GET /api/players/:id
 * Get a single player by ID.
 */
async function getPlayer(req, res) {
  try {
    const player = await Player.findById(req.params.id);
    if (!player) {
      return sendError(res, 'Player not found', 404);
    }
    return sendSuccess(res, 'Player fetched successfully', player);
  } catch (error) {
    return sendError(res, 'Failed to fetch player', 500);
  }
}

/**
 * POST /api/players
 * Create a new player (onboarding).
 */
async function createPlayer(req, res) {
  try {
    const { inGameName, freeFireUid } = req.body;

    if (!inGameName || !freeFireUid) {
      return sendError(res, 'inGameName and freeFireUid are required', 400);
    }

    // Check if player with this UID already exists
    const existing = await Player.findOne({ freeFireUid });
    if (existing) {
      return sendSuccess(res, 'Player already exists', existing);
    }

    const player = await Player.create({ inGameName, freeFireUid });
    return sendSuccess(res, 'Player created successfully', player, 201);
  } catch (error) {
    if (error.name === 'ValidationError') {
      const messages = Object.values(error.errors).map((e) => e.message);
      return sendError(res, 'Validation failed', 400, messages);
    }
    return sendError(res, 'Failed to create player', 500);
  }
}

/**
 * PUT /api/players/:id
 * Update a player profile.
 */
async function updatePlayer(req, res) {
  try {
    const { inGameName, freeFireUid } = req.body;
    const update = {};
    if (inGameName) update.inGameName = inGameName;
    if (freeFireUid) update.freeFireUid = freeFireUid;

    const player = await Player.findByIdAndUpdate(req.params.id, update, {
      new: true,
      runValidators: true,
    });

    if (!player) {
      return sendError(res, 'Player not found', 404);
    }

    return sendSuccess(res, 'Player updated successfully', player);
  } catch (error) {
    if (error.name === 'ValidationError') {
      const messages = Object.values(error.errors).map((e) => e.message);
      return sendError(res, 'Validation failed', 400, messages);
    }
    return sendError(res, 'Failed to update player', 500);
  }
}

module.exports = { getPlayers, getPlayer, createPlayer, updatePlayer };
