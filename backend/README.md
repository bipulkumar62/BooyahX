# BooyahX Backend

REST API backend for the BooyahX competitive mobile esports tournament hub.

## Tech Stack

- **Runtime:** Node.js
- **Framework:** Express.js
- **Language:** JavaScript (CommonJS)

## Current Status

This is the **backend foundation** — a clean Express server with route stubs and placeholder controllers. No database is connected yet. MongoDB integration will be added in a future step.

## Project Structure

```
backend/
├── src/
│   ├── config/           # Environment configuration
│   ├── controllers/      # Request handlers (placeholder)
│   ├── middleware/        # Error handling, 404, etc.
│   ├── models/           # Database models (empty — MongoDB next)
│   ├── routes/           # API route definitions
│   ├── services/         # Business logic (empty — future)
│   ├── repositories/     # Data access layer (empty — future)
│   ├── utils/            # Response helpers
│   ├── app.js            # Express app configuration
│   └── server.js         # Server entry point
├── .env.example          # Environment variable template
├── .gitignore
├── package.json
└── README.md
```

## Local Setup

### Prerequisites

- Node.js v18+ (tested on v24.18.0)
- npm v9+ (tested on v11.16.0)

### Install

```bash
cd backend
npm install
```

### Configure

```bash
cp .env.example .env
```

Edit `.env` with your local settings.

### Run

```bash
# Development (with auto-reload)
npm run dev

# Production
npm start
```

Server starts at `http://localhost:5000`.

## API Endpoints

### Health Check

```
GET /api/health
```

Response:
```json
{
  "success": true,
  "message": "BooyahX API is running",
  "data": {
    "environment": "development",
    "uptime": 123.456,
    "timestamp": "2026-09-19T18:00:00.000Z"
  }
}
```

### Placeholder Endpoints

These endpoints exist but return placeholder responses:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/players/:id` | Get player profile |
| PUT | `/api/players/:id` | Update player profile |
| GET | `/api/tournaments` | List tournaments |
| GET | `/api/tournaments/:id` | Get tournament detail |
| POST | `/api/tournaments/:id/join` | Join tournament |
| GET | `/api/matches` | List matches |
| GET | `/api/matches/:id` | Get match detail |
| GET | `/api/leaderboard` | Get leaderboard |
| GET | `/api/notifications` | List notifications |
| PUT | `/api/notifications/:id/read` | Mark notification read |
| GET | `/api/wallet/:playerId` | Get wallet balance |
| GET | `/api/wallet/:playerId/transactions` | Get transactions |

## Architecture

```
Request → Route → Controller → Service → Repository → Database
```

Currently only Route → Controller → Placeholder Response is implemented. The service and repository layers are created but empty, ready for MongoDB integration.

## Known Limitations

- **No database:** MongoDB is not connected yet
- **No authentication:** All endpoints are open
- **No real data:** All responses are placeholder stubs
- **No tests yet:** Test infrastructure is configured but tests are not written

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `5000` | Server port |
| `NODE_ENV` | `development` | Environment mode |
| `CORS_ORIGIN` | `http://localhost:3000` | Allowed CORS origin |

## License

MIT
