/**
 * BooyahX — Match Controller
 *
 * Handles match-related API operations with MongoDB.
 */

const Match = require('../models/Match');
const { sendSuccess, sendError } = require('../utils/response');

/**
 * GET /api/matches
 * List matches. Supports ?playerId=xxx filter.
 */
async function getMatches(req, res) {
  try {
    const filter = {};
    if (req.query.playerId) {
      filter.playerId = req.query.playerId;
    }

    const matches = await Match.find(filter).sort({ matchDateTime: -1 });
    return sendSuccess(res, 'Matches fetched successfully', matches);
  } catch (error) {
    return sendError(res, 'Failed to fetch matches', 500);
  }
}

/**
 * GET /api/matches/:id
 * Get a single match by ID.
 */
async function getMatchById(req, res) {
  try {
    const match = await Match.findById(req.params.id);
    if (!match) {
      return sendError(res, 'Match not found', 404);
    }
    return sendSuccess(res, 'Match fetched successfully', match);
  } catch (error) {
    return sendError(res, 'Failed to fetch match', 500);
  }
}

/**
 * POST /api/matches
 * Create a new match entry.
 */
async function createMatch(req, res) {
  try {
    const match = await Match.create(req.body);
    return sendSuccess(res, 'Match created successfully', match, 201);
  } catch (error) {
    if (error.name === 'ValidationError') {
      const messages = Object.values(error.errors).map((e) => e.message);
      return sendError(res, 'Validation failed', 400, messages);
    }
    return sendError(res, 'Failed to create match', 500);
  }
}

module.exports = { getMatches, getMatchById, createMatch };
