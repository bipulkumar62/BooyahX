/**
 * BooyahX — Configuration
 *
 * Centralized configuration loaded from environment variables.
 * No secrets are hardcoded.
 */

const config = {
  port: parseInt(process.env.PORT, 10) || 5000,
  nodeEnv: process.env.NODE_ENV || 'development',
  corsOrigin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  isProduction: process.env.NODE_ENV === 'production',
};

module.exports = config;
