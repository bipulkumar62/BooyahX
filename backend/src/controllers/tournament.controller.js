/**
 * BooyahX — Tournament Controller
 *
 * Handles tournament-related API operations with MongoDB.
 */

const Tournament = require('../models/Tournament');
const Match = require('../models/Match');
const { sendSuccess, sendError } = require('../utils/response');

/**
 * GET /api/tournaments
 * List all tournaments. Supports ?category=soloBr filter.
 */
async function getTournaments(req, res) {
  try {
    const filter = {};
    if (req.query.category && req.query.category !== 'all') {
      filter.category = req.query.category;
    }

    const tournaments = await Tournament.find(filter).sort({ dateTime: 1 });
    return sendSuccess(res, 'Tournaments fetched successfully', tournaments);
  } catch (error) {
    return sendError(res, 'Failed to fetch tournaments', 500);
  }
}

/**
 * GET /api/tournaments/:id
 * Get a single tournament by ID.
 */
async function getTournamentById(req, res) {
  try {
    const tournament = await Tournament.findById(req.params.id);
    if (!tournament) {
      return sendError(res, 'Tournament not found', 404);
    }
    return sendSuccess(res, 'Tournament fetched successfully', tournament);
  } catch (error) {
    return sendError(res, 'Failed to fetch tournament', 500);
  }
}

/**
 * POST /api/tournaments
 * Create a new tournament.
 */
async function createTournament(req, res) {
  try {
    const tournament = await Tournament.create(req.body);
    return sendSuccess(res, 'Tournament created successfully', tournament, 201);
  } catch (error) {
    if (error.name === 'ValidationError') {
      const messages = Object.values(error.errors).map((e) => e.message);
      return sendError(res, 'Validation failed', 400, messages);
    }
    return sendError(res, 'Failed to create tournament', 500);
  }
}

/**
 * POST /api/tournaments/:id/join
 * Join a tournament — creates a match entry for the player.
 */
async function joinTournament(req, res) {
  try {
    const tournament = await Tournament.findById(req.params.id);
    if (!tournament) {
      return sendError(res, 'Tournament not found', 404);
    }

    const { playerId } = req.body;
    if (!playerId) {
      return sendError(res, 'playerId is required', 400);
    }

    // Check if already joined
    const existingMatch = await Match.findOne({
      tournamentId: tournament._id,
      playerId,
    });
    if (existingMatch) {
      return sendError(res, 'Already joined this tournament', 400);
    }

    // Check slot availability
    if (tournament.filledSlots >= tournament.totalSlots) {
      return sendError(res, 'Tournament is full', 400);
    }

    // Create match entry
    const match = await Match.create({
      tournamentId: tournament._id,
      tournamentName: tournament.name,
      playerId,
      mode: tournament.mode,
      map: tournament.map,
      matchDateTime: tournament.dateTime,
      entryFee: tournament.entryFee,
      prizePool: tournament.prizePool,
      status: 'upcoming',
      playerStatus: 'Registered',
      slotNumber: `SLOT ${tournament.filledSlots + 1}`,
    });

    // Increment filled slots
    tournament.filledSlots += 1;
    await tournament.save();

    return sendSuccess(res, 'Joined tournament successfully', match, 201);
  } catch (error) {
    return sendError(res, 'Failed to join tournament', 500);
  }
}

module.exports = {
  getTournaments,
  getTournamentById,
  createTournament,
  joinTournament,
};
