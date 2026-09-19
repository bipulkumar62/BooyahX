/**
 * BooyahX — Match Routes
 *
 * Future endpoints:
 *   GET /api/matches       — List all matches for a player
 *   GET /api/matches/:id   — Get match detail
 */

const express = require('express');
const router = express.Router();
const { getMatches, getMatchById } = require('../controllers/match.controller');

router.get('/', getMatches);
router.get('/:id', getMatchById);

module.exports = router;
