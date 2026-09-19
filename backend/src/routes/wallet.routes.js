/**
 * BooyahX — Wallet Routes
 *
 * Future endpoints:
 *   GET /api/wallet/:playerId              — Get wallet balance
 *   GET /api/wallet/:playerId/transactions — Get transaction history
 *   POST /api/wallet/:playerId/deposit     — Add money (mock)
 *   POST /api/wallet/:playerId/withdraw    — Withdraw money (mock)
 */

const express = require('express');
const router = express.Router();
const { getWallet, getTransactions } = require('../controllers/wallet.controller');

router.get('/:playerId', getWallet);
router.get('/:playerId/transactions', getTransactions);

module.exports = router;
