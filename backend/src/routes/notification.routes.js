/**
 * BooyahX — Notification Routes
 *
 * Future endpoints:
 *   GET /api/notifications              — List notifications for a player
 *   PUT /api/notifications/:id/read     — Mark a notification as read
 *   PUT /api/notifications/read-all     — Mark all notifications as read
 */

const express = require('express');
const router = express.Router();
const {
  getNotifications,
  markAsRead,
} = require('../controllers/notification.controller');

router.get('/', getNotifications);
router.put('/:id/read', markAsRead);

module.exports = router;
