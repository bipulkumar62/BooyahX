/**
 * BooyahX — Server Entry Point
 *
 * Startup order:
 *   1. Load environment variables
 *   2. Connect to MongoDB
 *   3. Start Express server
 *
 * If MongoDB connection fails, the server does NOT start.
 */

// Load environment variables first
require('dotenv').config();

const app = require('./app');
const config = require('./config');
const { connectDatabase, disconnectDatabase } = require('./config/database');

// ── Start Server ──
async function startServer() {
  try {
    // Step 1: Connect to MongoDB
    await connectDatabase();

    // Step 2: Start HTTP server
    const server = app.listen(config.port, () => {
      console.log('');
      console.log('═══════════════════════════════════════════');
      console.log('  🎮 BooyahX API Server');
      console.log('═══════════════════════════════════════════');
      console.log(`  Status:    Running`);
      console.log(`  Port:      ${config.port}`);
      console.log(`  Env:       ${config.nodeEnv}`);
      console.log(`  Health:    http://localhost:${config.port}/api/health`);
      console.log('═══════════════════════════════════════════');
      console.log('');
    });

    // ── Graceful Shutdown ──
    const shutdown = async (signal) => {
      console.log(`\n${signal} received. Shutting down gracefully...`);

      server.close(async () => {
        console.log('HTTP server closed.');
        await disconnectDatabase();
        process.exit(0);
      });

      // Force shutdown after 10 seconds if graceful shutdown hangs
      setTimeout(() => {
        console.error('Forced shutdown after timeout.');
        process.exit(1);
      }, 10000);
    };

    process.on('SIGTERM', () => shutdown('SIGTERM'));
    process.on('SIGINT', () => shutdown('SIGINT'));

    module.exports = server;
  } catch (error) {
    console.error('Failed to start server:', error.message);
    process.exit(1);
  }
}

startServer();
