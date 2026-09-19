/**
 * BooyahX — Database Configuration
 *
 * MongoDB Atlas connection via Mongoose.
 * Reads MONGODB_URI from environment variables.
 * Never exposes credentials in logs.
 */

const mongoose = require('mongoose');

/**
 * Connect to MongoDB Atlas.
 * @returns {Promise<void>}
 */
async function connectDatabase() {
  const uri = process.env.MONGODB_URI;

  if (!uri) {
    console.error('╔═══════════════════════════════════════════╗');
    console.error('║  ❌ MONGODB_URI is not set in .env       ║');
    console.error('║  Please configure your database URI.     ║');
    console.error('╚═══════════════════════════════════════════╝');
    process.exit(1);
  }

  try {
    await mongoose.connect(uri);

    console.log('╔═══════════════════════════════════════════╗');
    console.log('║  🗄️  MongoDB Connected                    ║');
    console.log('╚═══════════════════════════════════════════╝');
  } catch (error) {
    console.error('╔═══════════════════════════════════════════╗');
    console.error('║  ❌ MongoDB Connection Failed             ║');
    console.error(`║  Error: ${error.message.substring(0, 30)}...  ║`);
    console.error('╚═══════════════════════════════════════════╝');
    process.exit(1);
  }
}

/**
 * Get the current database connection status.
 * @returns {string} 'connected' | 'disconnected' | 'connecting' | 'disconnecting'
 */
function getDatabaseStatus() {
  const states = {
    0: 'disconnected',
    1: 'connected',
    2: 'connecting',
    3: 'disconnecting',
  };
  return states[mongoose.connection.readyState] || 'unknown';
}

/**
 * Disconnect from MongoDB (for graceful shutdown).
 * @returns {Promise<void>}
 */
async function disconnectDatabase() {
  try {
    await mongoose.disconnect();
    console.log('MongoDB disconnected.');
  } catch (error) {
    console.error('Error disconnecting from MongoDB:', error.message);
  }
}

module.exports = {
  connectDatabase,
  getDatabaseStatus,
  disconnectDatabase,
};
