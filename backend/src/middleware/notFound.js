/**
 * BooyahX — 404 Not Found Handler
 *
 * Catches requests to undefined routes.
 */

const { sendError } = require('../utils/response');

function notFound(req, res) {
  return sendError(
    res,
    `Route not found: ${req.method} ${req.originalUrl}`,
    404
  );
}

module.exports = notFound;
