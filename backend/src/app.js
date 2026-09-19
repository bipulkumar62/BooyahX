/**
 * BooyahX — Express Application
 *
 * Configures middleware, registers routes, and sets up error handling.
 * Separated from server.js for testability.
 */

const express = require('express');
const cors = require('cors');
const config = require('./config');
const notFound = require('./middleware/notFound');
const errorHandler = require('./middleware/errorHandler');

// ── Route Imports ──
const healthRoutes = require('./routes/health.routes');
const playerRoutes = require('./routes/player.routes');
const tournamentRoutes = require('./routes/tournament.routes');
const matchRoutes = require('./routes/match.routes');
const leaderboardRoutes = require('./routes/leaderboard.routes');
const notificationRoutes = require('./routes/notification.routes');
const walletRoutes = require('./routes/wallet.routes');

// ── Create Express App ──
const app = express();

// ── Middleware ──
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({
  origin: config.corsOrigin,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// ── Request Logging (Development) ──
if (!config.isProduction) {
  app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl}`);
    next();
  });
}

// ── API Routes ──
app.use('/api', healthRoutes);
app.use('/api/players', playerRoutes);
app.use('/api/tournaments', tournamentRoutes);
app.use('/api/matches', matchRoutes);
app.use('/api/leaderboard', leaderboardRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/wallet', walletRoutes);

// ── Root Route ──
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Welcome to BooyahX API',
    version: '1.0.0',
    docs: '/api/health',
  });
});

// ── 404 Handler ──
app.use(notFound);

// ── Global Error Handler ──
app.use(errorHandler);

module.exports = app;
