/**
 * BooyahX — Tournament Controller
 *
 * Handles tournament-related API operations.
 * Currently returns placeholder responses.
 * Will be connected to MongoDB in a future step.
 */

const { sendSuccess } = require('../utils/response');

/**
 * GET /api/tournaments
 */
function getTournaments(req, res) {
  return sendSuccess(res, 'Tournaments endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

/**
 * GET /api/tournaments/:id
 */
function getTournamentById(req, res) {
  return sendSuccess(res, 'Tournament detail endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

/**
 * POST /api/tournaments/:id/join
 */
function joinTournament(req, res) {
  return sendSuccess(res, 'Tournament join endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

module.exports = { getTournaments, getTournamentById, joinTournament };
