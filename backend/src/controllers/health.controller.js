/**
 * BooyahX — Health Controller
 *
 * Provides a health check endpoint to verify the API and database are running.
 * Never exposes credentials, URI, or sensitive details.
 */

const config = require('../config');
const { getDatabaseStatus } = require('../config/database');
const { sendSuccess, sendError } = require('../utils/response');

/**
 * GET /api/health
 */
function getHealth(req, res) {
  const dbStatus = getDatabaseStatus();
  const isHealthy = dbStatus === 'connected';

  const data = {
    environment: config.nodeEnv,
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
    database: dbStatus,
  };

  if (isHealthy) {
    return sendSuccess(res, 'BooyahX API is running', data);
  }

  // API is running but database is not connected
  return sendError(res, 'API running but database is not connected', 503);
}

module.exports = { getHealth };
