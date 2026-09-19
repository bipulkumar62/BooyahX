/**
 * BooyahX — Wallet Controller
 *
 * Handles wallet-related API operations.
 * Currently returns placeholder responses.
 * Will be connected to MongoDB in a future step.
 */

const { sendSuccess } = require('../utils/response');

/**
 * GET /api/wallet/:playerId
 */
function getWallet(req, res) {
  return sendSuccess(res, 'Wallet endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

/**
 * GET /api/wallet/:playerId/transactions
 */
function getTransactions(req, res) {
  return sendSuccess(res, 'Transactions endpoint — coming soon', {
    note: 'Will be connected to MongoDB',
  });
}

module.exports = { getWallet, getTransactions };
