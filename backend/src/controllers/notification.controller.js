/**
 * BooyahX — Notification Controller
 *
 * Handles notification-related API operations.
 * Currently returns placeholder responses.
 * Will be connected to MongoDB in a future step.
 */

const { sendSuccess } = require('../utils/response');

/**
 * GET /api/notifications
 */
function getNotifications(req, res) {
  return sendSuccess(res, 'Notifications endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

/**
 * PUT /api/notifications/:id/read
 */
function markAsRead(req, res) {
  return sendSuccess(res, 'Mark notification read endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

module.exports = { getNotifications, markAsRead };
