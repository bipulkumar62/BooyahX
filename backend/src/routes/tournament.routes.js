/**
 * BooyahX — Tournament Routes
 *
 *   GET    /api/tournaments          — List all tournaments
 *   GET    /api/tournaments/:id      — Get tournament by ID
 *   POST   /api/tournaments          — Create tournament
 *   POST   /api/tournaments/:id/join — Join tournament
 */

const express = require('express');
const router = express.Router();
const {
  getTournaments,
  getTournamentById,
  createTournament,
  joinTournament,
} = require('../controllers/tournament.controller');

router.get('/', getTournaments);
router.get('/:id', getTournamentById);
router.post('/', createTournament);
router.post('/:id/join', joinTournament);

module.exports = router;
