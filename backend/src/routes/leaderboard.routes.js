/**
 * BooyahX — Leaderboard Routes
 *
 * Future endpoints:
 *   GET /api/leaderboard           — Get leaderboard (supports ?filter=overall|weekly|monthly|season)
 *   GET /api/leaderboard/player/:id — Get a specific player's rank
 */

const express = require('express');
const router = express.Router();
const { getLeaderboard } = require('../controllers/leaderboard.controller');

router.get('/', getLeaderboard);

module.exports = router;
