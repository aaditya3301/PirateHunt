# PirateHunt

Real-time live-stream piracy detection system for sports broadcasts. Phase 1 focuses on fingerprinting core and project scaffold.

## Installation

### Prerequisites

- **Python 3.11+** (required)
- **Node.js 18+** (required)
- **Docker** (required for PostgreSQL + Redis)
- **FFmpeg** (optional, for video processing)
- **Chromaprint** (optional, for audio fingerprinting)

### 1. Start Database Services

```bash
docker compose up -d
```

This starts PostgreSQL (port 5433) and Redis (port 6379).

### 2. Install Backend Dependencies

**Important:** Use Python 3.11 or higher.

```bash
pip install -e ".[dev]"
```

### 3. Initialize Database

```bash
alembic upgrade head
```

### 4. Install Frontend Dependencies

```bash
cd dashboard
npm install
cd ..
```

### 5. Configure Environment

Edit `.env` and add your Gemini API key (optional):

```env
GEMINI_API_KEY=your_api_key_here
```

## Running the System

### Backend API

```bash
python -m piratehunt.api.main --host localhost --port 8000
```

API available at: http://localhost:8000
API Docs: http://localhost:8000/docs

### Frontend Dashboard

```bash
cd dashboard
npm run dev
```

Dashboard available at: http://localhost:3000

### Workers (Optional)

Run in separate terminals:

```bash
# Discovery worker (finds pirate streams)
python -m piratehunt.cli worker discovery

# Verification worker (verifies candidates)
python -m piratehunt.cli worker verification

# DMCA worker (generates takedown notices)
python -m piratehunt.cli worker dmca
```

## Project Structure

```
piratehunt/
├── src/piratehunt/
│   ├── config.py               # Pydantic settings
│   ├── fingerprint/            # Fingerprinting core
│   │   ├── audio.py            # Chromaprint wrapper
│   │   ├── visual.py           # pHash + dHash
│   │   ├── extractor.py        # ffmpeg wrapper
│   │   └── types.py            # Pydantic models
│   ├── index/                  # Vector indexing
│   │   ├── faiss_store.py      # Visual hash index
│   │   └── audio_store.py      # Audio fingerprint store
│   ├── api/
│   │   ├── app.py              # FastAPI application
│   │   ├── routers/            # API endpoints
│   │   │   ├── health.py
│   │   │   ├── matches.py
│   │   │   ├── discovery.py
│   │   │   ├── verification.py
│   │   │   ├── takedowns.py
│   │   │   ├── rights_holders.py
│   │   │   └── dashboard.py    # Aggregation endpoints (Phase 6)
│   │   └── realtime/           # WebSocket bridge (Phase 6)
│   │       ├── types.py        # Event types
│   │       ├── bridge.py       # Redis → WebSocket
│   │       ├── manager.py      # Connection management
│   │       ├── geolocation.py  # URL → location lookup
│   │       └── endpoint.py     # WebSocket endpoint
│   ├── dmca/                   # DMCA notice generation (Phase 5)
│   ├── db/                     # Database models
│   └── cli.py                  # Command-line interface
├── dashboard/                  # Next.js frontend (Phase 6)
│   ├── app/                    # Next.js App Router
│   │   ├── layout.tsx
│   │   ├── page.tsx            # Main dashboard
│   │   └── globals.css
│   ├── components/             # React components
│   ├── lib/                    # Utilities
│   │   ├── store.ts            # Zustand state
│   │   ├── ws.ts               # WebSocket client
│   │   ├── api.ts              # Fetch wrappers
│   │   └── types.ts            # TypeScript types
│   ├── styles/
│   ├── package.json
│   └── tsconfig.json
├── tests/                      # Pytest suite
├── docker-compose.yml          # Services
├── pyproject.toml              # Project config
├── PHASE6_BUILD.md             # Phase 6 build summary
└── README.md
```

## Project Phases

### Phase 1 ✅
- ✅ Project scaffold and dependencies
- ✅ Audio fingerprinting with Chromaprint
- ✅ Visual fingerprinting (pHash + dHash)
- ✅ Media extraction (ffmpeg integration)
- ✅ In-memory fingerprint indices
- ✅ Health check endpoint

### Phase 2-5 ✅
- ✅ Database persistence (PostgreSQL + SQLAlchemy)
- ✅ Ingestion endpoints and candidate streams
- ✅ Streaming verification pipelines
- ✅ Detection agents with audio/visual scoring
- ✅ DMCA notice generation and takedown tracking
- ✅ Rights holder management

### Phase 6 ✅ (JUST COMPLETED)
- ✅ WebSocket real-time event bridge (Redis → clients)
- ✅ Dashboard aggregation endpoints (summary, timeline, pirates, funnel)
- ✅ Next.js 14 frontend with dark theme
- ✅ Live event feed, 3D globe visualization, takedown funnel
- ✅ Zustand state management + auto-reconnecting WebSocket client
- ✅ Revenue loss estimation + real-time metrics

### Planned for Future Phases

- Mock event generator for offline demos
- Full deck.gl 3D globe with animated pins (currently placeholder)
- Frontend unit tests (Vitest + React Testing Library)
- Screenshot automation for demo documentation
- Platform-specific crawlers (YouTube, Telegram, Discord, etc.)
- Automated DMCA submission to hosting providers

## Development

### Code Style

```bash
black src tests
ruff check --fix src tests
```

### Running Tests

```bash
pytest -v
```

### Type Checking

All code uses full type hints with `from __future__ import annotations`.

## License

MIT
