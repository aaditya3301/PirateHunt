# PirateHunt Setup Guide

Complete step-by-step guide to get PirateHunt running on your Windows machine.

## Prerequisites ✅

You already have:
- ✅ Docker (v29.2.0)
- ✅ Node.js (v24.14.0)
- ✅ Python (3.10.11)

## Step 1: Install System Dependencies

### Install FFmpeg (Required for video processing)

**Option A: Using Chocolatey (Recommended)**
```powershell
choco install ffmpeg
```

**Option B: Manual Installation**
1. Download FFmpeg from: https://www.gyan.dev/ffmpeg/builds/
2. Extract to `C:\ffmpeg`
3. Add `C:\ffmpeg\bin` to your PATH environment variable

**Verify installation:**
```bash
ffmpeg -version
```

### Install Chromaprint (Required for audio fingerprinting)

**Option A: Using Chocolatey**
```powershell
choco install chromaprint
```

**Option B: Manual Installation**
1. Download from: https://acoustid.org/chromaprint
2. Extract and add to PATH

**Verify installation:**
```bash
fpcalc -version
```

## Step 2: Start Database Services

Your `docker-compose.yml` is already configured. Start PostgreSQL and Redis:

```bash
docker compose up -d
```

**Verify services are running:**
```bash
docker ps
```

You should see:
- `piratehunt-postgres` on port 5433
- `piratehunt-redis` on port 6379

**Check service health:**
```bash
docker compose ps
```

## Step 3: Install Python Dependencies

⚠️ **IMPORTANT**: This project requires Python 3.11 or higher!

Check your Python version:
```bash
python --version
```

If you have Python 3.10, you need to use Python 3.11 explicitly:
```bash
# Find Python 3.11 location
where python

# Use Python 3.11 (adjust path if different)
C:\Users\onlys\AppData\Local\Programs\Python\Python311\python.exe --version
```

### Option A: Using pip (Standard)

```bash
# If you have Python 3.11 as default
pip install -e ".[dev]"

# OR if you need to use Python 3.11 explicitly
C:\Users\onlys\AppData\Local\Programs\Python\Python311\python.exe -m pip install -e ".[dev]"
```

### Option B: Using uv (Faster, Recommended)

```bash
# Install uv first
pip install uv

# Install dependencies
uv sync
```

**Verify installation:**
```bash
python -c "import piratehunt; print('✅ PirateHunt installed')"
```

## Step 4: Initialize Database

Run database migrations to create all tables:

```bash
# Run Alembic migrations
alembic upgrade head
```

**Alternative: Use the create_tables script**
```bash
python create_tables.py
```

**Verify database:**
```bash
# Connect to PostgreSQL
docker exec -it piratehunt-postgres psql -U piratehunt -d piratehunt

# List tables
\dt

# Exit
\q
```

You should see tables like: `matches`, `audio_fingerprints`, `visual_fingerprints`, `candidate_streams`, etc.

## Step 5: Install Frontend Dependencies

```bash
cd dashboard
npm install
cd ..
```

## Step 6: Configure Environment Variables (Optional)

Your `.env` files are already set up, but you can customize:

### Backend `.env`
```env
DATABASE_URL=postgresql+asyncpg://piratehunt:piratehunt@localhost:5433/piratehunt
REDIS_URL=redis://localhost:6379
LOG_LEVEL=INFO

# Optional: Add Gemini API key for AI verification
GEMINI_API_KEY=your_api_key_here
```

### Frontend `dashboard/.env`
```env
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_WS_URL=ws://localhost:8000/ws
NEXT_PUBLIC_USE_MOCK=false
```

## Step 7: Run the System

You need 3 terminals running simultaneously:

### Terminal 1: Backend API Server
```bash
# Start the FastAPI server
python -m piratehunt.api.main --host localhost --port 8000
```

**Or using uvicorn directly:**
```bash
uvicorn piratehunt.api.app:app --host localhost --port 8000 --reload
```

**Verify:** Open http://localhost:8000/health in your browser

### Terminal 2: Frontend Dashboard
```bash
cd dashboard
npm run dev
```

**Verify:** Open http://localhost:3000 in your browser

### Terminal 3: Workers (Optional for full demo)

**Verification Worker:**
```bash
python -m piratehunt.cli worker verification
```

**DMCA Worker:**
```bash
python -m piratehunt.cli worker dmca
```

**Discovery Agents:**
```bash
python -m piratehunt.cli worker discovery
```

## Step 8: Test the System

### Quick Health Check
```bash
curl http://localhost:8000/health
```

### Create a Test Match
```bash
curl -X POST http://localhost:8000/matches \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Cricket Match",
    "source_url": "https://example.com/test.mp4"
  }'
```

### View Dashboard
Open http://localhost:3000 and you should see:
- Live connection indicator (green dot)
- Real-time event feed
- 3D globe placeholder
- Takedown funnel
- Revenue loss ticker

## Troubleshooting

### Docker services won't start
```bash
# Check if ports are already in use
netstat -ano | findstr :5433
netstat -ano | findstr :6379

# Stop and restart
docker compose down
docker compose up -d
```

### Database connection errors
```bash
# Check PostgreSQL is running
docker logs piratehunt-postgres

# Test connection
docker exec -it piratehunt-postgres psql -U piratehunt -d piratehunt -c "SELECT 1;"
```

### Redis connection errors
```bash
# Check Redis is running
docker logs piratehunt-redis

# Test connection
docker exec -it piratehunt-redis redis-cli ping
```

### Python import errors
```bash
# Reinstall in development mode
pip uninstall piratehunt
pip install -e ".[dev]"
```

### Frontend won't connect to backend
1. Check backend is running on port 8000
2. Check CORS is enabled in `src/piratehunt/api/app.py`
3. Verify `dashboard/.env` has correct URLs
4. Check browser console for WebSocket errors

### FFmpeg not found
```bash
# Add to PATH or install
where ffmpeg

# If not found, install via chocolatey
choco install ffmpeg
```

## Running Tests

```bash
# Run all tests
pytest -v

# Run specific test file
pytest tests/test_fingerprint.py -v

# Run with coverage
pytest --cov=piratehunt tests/
```

## Development Workflow

### Format code
```bash
black src tests
ruff check --fix src tests
```

### Run linting
```bash
ruff check src tests
```

### Watch mode for frontend
```bash
cd dashboard
npm run dev
```

## Production Deployment

### Build frontend
```bash
cd dashboard
npm run build
npm run start
```

### Run backend with gunicorn
```bash
gunicorn piratehunt.api.app:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```

## Quick Start Commands (Copy-Paste)

```bash
# 1. Start services
docker compose up -d

# 2. Install Python deps
pip install -e ".[dev]"

# 3. Initialize database
alembic upgrade head

# 4. Install frontend deps
cd dashboard && npm install && cd ..

# 5. Start backend (Terminal 1)
python -m piratehunt.api.main --host localhost --port 8000

# 6. Start frontend (Terminal 2)
cd dashboard && npm run dev

# 7. Open dashboard
# Visit: http://localhost:3000
```

## Next Steps

1. ✅ System is running
2. 📊 Explore the dashboard at http://localhost:3000
3. 📡 Check API docs at http://localhost:8000/docs
4. 🎬 Add sample video for testing
5. 🔍 Run discovery agents to find pirates
6. ✅ Watch real-time verification and takedowns

## Useful Commands

```bash
# View logs
docker compose logs -f postgres
docker compose logs -f redis

# Stop all services
docker compose down

# Reset database
docker compose down -v
docker compose up -d
alembic upgrade head

# Check Python package
pip show piratehunt

# List all routes
python -c "from piratehunt.api.app import app; print('\n'.join([f'{r.methods} {r.path}' for r in app.routes]))"
```

## Support

- 📖 Full documentation: `README.md`
- 🏗️ Architecture: `PHASE6_BUILD.md`
- ✅ Deliverables: `DELIVERABLES.md`
- 🐛 Issues: Check logs in `docker compose logs`

---

**Status:** Ready to hunt pirates! 🏴‍☠️🎯
