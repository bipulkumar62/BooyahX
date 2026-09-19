/**
 * BooyahX — Leaderboard Controller
 *
 * Handles leaderboard-related API operations.
 * Currently returns placeholder responses.
 * Will be connected to MongoDB in a future step.
 */

const { sendSuccess } = require('../utils/response');

/**
 * GET /api/leaderboard
 */
function getLeaderboard(req, res) {
  return sendSuccess(res, 'Leaderboard endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

module.exports = { getLeaderboard };
