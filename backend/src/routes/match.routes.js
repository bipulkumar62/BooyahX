/**
 * BooyahX — Match Routes
 *
 *   GET /api/matches       — List matches (supports ?playerId=xxx)
 *   GET /api/matches/:id   — Get match by ID
 *   POST /api/matches      — Create match
 */

const express = require('express');
const router = express.Router();
const {
  getMatches,
  getMatchById,
  createMatch,
} = require('../controllers/match.controller');

router.get('/', getMatches);
router.get('/:id', getMatchById);
router.post('/', createMatch);

module.exports = router;
