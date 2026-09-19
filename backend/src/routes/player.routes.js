/**
 * BooyahX — Player Routes
 *
 *   GET    /api/players       — List all players
 *   GET    /api/players/:id   — Get player by ID
 *   POST   /api/players       — Create player (onboarding)
 *   PUT    /api/players/:id   — Update player profile
 */

const express = require('express');
const router = express.Router();
const {
  getPlayers,
  getPlayer,
  createPlayer,
  updatePlayer,
} = require('../controllers/player.controller');

router.get('/', getPlayers);
router.get('/:id', getPlayer);
router.post('/', createPlayer);
router.put('/:id', updatePlayer);

module.exports = router;
