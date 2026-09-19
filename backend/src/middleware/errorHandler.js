/**
 * BooyahX — Global Error Handler Middleware
 *
 * Catches unhandled errors and returns consistent JSON responses.
 * Does not expose stack traces in production.
 */

const config = require('../config');
const { sendError } = require('../utils/response');

/**
 * Global error handling middleware.
 * Must have 4 parameters for Express to recognize it as an error handler.
 */
function errorHandler(err, req, res, _next) {
  console.error(`[ERROR] ${req.method} ${req.path}:`, err.message);

  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal server error';

  const errors = config.isProduction
    ? []
    : [{ stack: err.stack }];

  return sendError(res, message, statusCode, errors);
}

module.exports = errorHandler;
