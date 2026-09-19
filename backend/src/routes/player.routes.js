/**
 * BooyahX — Player Routes
 *
 * Future endpoints:
 *   GET    /api/players/:id       — Get player profile
 *   PUT    /api/players/:id       — Update player profile
 *   DELETE /api/players/:id       — Delete player
 */

const express = require('express');
const router = express.Router();
const { getPlayer, updatePlayer } = require('../controllers/player.controller');

router.get('/:id', getPlayer);
router.put('/:id', updatePlayer);

module.exports = router;
