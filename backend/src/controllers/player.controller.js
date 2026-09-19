/**
 * BooyahX — Player Controller
 *
 * Handles player-related API operations.
 * Currently returns placeholder responses.
 * Will be connected to MongoDB in a future step.
 */

const { sendSuccess, sendError } = require('../utils/response');

/**
 * GET /api/players/:id
 */
function getPlayer(req, res) {
  return sendSuccess(res, 'Player endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

/**
 * PUT /api/players/:id
 */
function updatePlayer(req, res) {
  return sendSuccess(res, 'Player update endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

module.exports = { getPlayer, updatePlayer };
