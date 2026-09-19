/**
 * BooyahX — Match Controller
 *
 * Handles match-related API operations.
 * Currently returns placeholder responses.
 * Will be connected to MongoDB in a future step.
 */

const { sendSuccess } = require('../utils/response');

/**
 * GET /api/matches
 */
function getMatches(req, res) {
  return sendSuccess(res, 'Matches endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

/**
 * GET /api/matches/:id
 */
function getMatchById(req, res) {
  return sendSuccess(res, 'Match detail endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

module.exports = { getMatches, getMatchById };
