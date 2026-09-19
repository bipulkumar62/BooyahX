/**
 * BooyahX — Tournament Routes
 *
 * Future endpoints:
 *   GET    /api/tournaments          — List all tournaments
 *   GET    /api/tournaments/:id      — Get tournament detail
 *   POST   /api/tournaments/:id/join — Join a tournament
 */

const express = require('express');
const router = express.Router();
const {
  getTournaments,
  getTournamentById,
  joinTournament,
} = require('../controllers/tournament.controller');

router.get('/', getTournaments);
router.get('/:id', getTournamentById);
router.post('/:id/join', joinTournament);

module.exports = router;
