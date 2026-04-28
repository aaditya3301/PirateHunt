# PirateHunt

Real-time live-stream piracy detection system for sports broadcasts.

PirateHunt monitors live sports streams across platforms, uses audio/visual fingerprinting combined with AI verification to detect unauthorized restreams, and auto-generates DMCA takedown notices in real-time.

---

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Python | 3.10+ | Backend API & workers |
| Node.js | 18+ | Dashboard frontend |
| Docker Desktop | Latest | PostgreSQL + Redis |
| FFmpeg | Latest | *(optional)* Video processing |

---

## Quick Start

### 1. Clone & Configure

```bash
git clone https://github.com/aaditya3301/PirateHunt.git
cd PirateHunter
cp .env.example .env
# Edit .env and add your GEMINI_API_KEY (optional)
```

### 2. Start Database Services

```bash
docker compose up -d
```

Starts PostgreSQL on port `5433` and Redis on port `6379`.

### 3. Setup Backend

Create and activate a virtual environment, then install dependencies.

```bash
# Create virtual environment
python -m venv venv

# Activate
source venv/Scripts/activate   # Git Bash
# or: .\venv\Scripts\Activate.ps1  (PowerShell)

# Install dependencies
python -m pip install --upgrade pip
pip install -e .[dev]
```

### 4. Initialize Database

```bash
python scripts/create_tables.py
```

### 5. Setup Dashboard

```bash
cd dashboard
npm install
cd ..
```

---

## Running the System

Run the following in three separate terminals (with venv active in terminals 1 and 3):

**Terminal 1 — Backend API**

```bash
python -m piratehunt.api.main --host localhost --port 8000
```

| Endpoint | URL |
|----------|-----|
| API | http://localhost:8000 |
| Swagger Docs | http://localhost:8000/docs |
| Health Check | http://localhost:8000/health |

**Terminal 2 — Dashboard**

```bash
cd dashboard
npm run dev
```

Dashboard available at http://localhost:3000

**Terminal 3 — Workers (optional)**

```bash
python -m piratehunt.cli worker dmca
```

---

## Project Structure

```
PirateHunter/
├── src/piratehunt/              # Python backend
│   ├── api/                     # FastAPI application and routers
│   │   ├── app.py
│   │   ├── routers/             # REST endpoints
│   │   └── realtime/            # WebSocket bridge (Redis to clients)
│   ├── fingerprint/             # Audio (Chromaprint) and visual (pHash/dHash)
│   ├── index/                   # FAISS vector store and audio store
│   ├── agents/                  # Detection agent orchestration
│   ├── ingestion/               # Stream ingestion pipeline
│   ├── verification/            # AI verification and evidence collection
│   ├── dmca/                    # DMCA notice generation and tracking
│   ├── db/                      # SQLAlchemy models and repository
│   ├── config.py                # Pydantic settings
│   └── cli.py                   # CLI entry point
│
├── dashboard/                   # Next.js 14 frontend
│   ├── app/                     # App Router
│   ├── components/              # React components
│   ├── lib/                     # Zustand store, WebSocket, API client
│   └── styles/
│
├── tests/                       # Pytest test suite
├── scripts/                     # Utility scripts
│   ├── demo.py                  # End-to-end offline demo
│   ├── simulate_dashboard.py    # Push mock events to dashboard
│   └── create_tables.py         # Direct table creation
│
├── alembic/                     # Database migrations
├── docker-compose.yml           # PostgreSQL + Redis
├── Dockerfile                   # Backend container (Cloud Run)
├── pyproject.toml               # Python project configuration
├── requirements.txt             # Python dependencies
├── .env.example                 # Environment variable template
└── .gitignore
```

---

## Development

**Run tests**

```bash
pytest -v
```

**Code formatting**

```bash
black src tests
ruff check --fix src tests
```

**Run offline demo**

```bash
python scripts/demo.py
```

**Simulate dashboard data**

```bash
python scripts/simulate_dashboard.py
```

---

## Architecture

```
                    ┌─────────────┐
                    │  Dashboard  │  Next.js :3000
                    └──────┬──────┘
                           │ WebSocket + REST
                    ┌──────┴──────┐
                    │  FastAPI    │  :8000
                    └──┬───┬───┬──┘
                       │   │   │
              ┌────────┘   │   └────────┐
              │            │            │
        ┌─────┴─────┐ ┌───┴────┐ ┌─────┴──────┐
        │ PostgreSQL │ │ Redis  │ │ Gemini API │
        │ + pgvector │ │        │ │ (optional) │
        └────────────┘ └────────┘ └────────────┘
```

**Detection pipeline:** Discover → Ingest → Fingerprint → Verify (AI) → Draft DMCA → Takedown

---

## Deployment

### Infrastructure

| Component | Service | Notes |
|-----------|---------|-------|
| Frontend (Next.js) | Vercel | Root directory: `dashboard` |
| Backend (FastAPI) | Google Cloud Run | Containerized via `Dockerfile` |
| PostgreSQL + pgvector | Neon.tech | Free tier |
| Redis | Upstash | Free tier |

### Frontend — Vercel

1. Import the GitHub repository at [vercel.com](https://vercel.com)
2. Set **Root Directory** to `dashboard`
3. Framework preset: `Next.js` (auto-detected)
4. Add the following environment variables:

| Variable | Value |
|----------|-------|
| `NEXT_PUBLIC_API_URL` | Your Cloud Run backend URL |
| `NEXT_PUBLIC_WS_URL` | Your Cloud Run WebSocket URL (`wss://...`) |
| `NEXT_PUBLIC_USE_MOCK` | `false` |

### Backend — Google Cloud Run

```bash
# Authenticate
gcloud auth login
gcloud config set project YOUR_PROJECT_ID

# Enable APIs
gcloud services enable run.googleapis.com containerregistry.googleapis.com

# Build and push image
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/piratehunt-api

# Deploy
gcloud run deploy piratehunt-api \
  --image gcr.io/YOUR_PROJECT_ID/piratehunt-api \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8000 \
  --memory 512Mi \
  --set-env-vars \
    DATABASE_URL="postgresql+asyncpg://user:pass@host.neon.tech/neondb?ssl=true",\
    REDIS_URL="rediss://default:xxx@global-xxx.upstash.io:6379",\
    GEMINI_API_KEY="your-key"
```

### AI — Google Gemini

PirateHunt uses **Gemini** for two core functions:

- **Multimodal verification** — Gemini Vision analyses sampled video frames to detect sports content and official broadcaster logos, returning a `pirate`, `clean`, or `inconclusive` verdict.
- **DMCA generation** — Gemini text generation drafts and legally polishes takedown notices targeted to the infringing platform.

---

## License

MIT
