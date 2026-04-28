@echo off
echo ========================================
echo PirateHunt Setup Script
echo ========================================
echo.

echo [1/6] Checking Docker...
docker --version
if %errorlevel% neq 0 (
    echo ERROR: Docker not found. Please install Docker Desktop.
    pause
    exit /b 1
)
echo ✓ Docker found
echo.

echo [2/6] Starting PostgreSQL and Redis...
docker compose up -d
if %errorlevel% neq 0 (
    echo ERROR: Failed to start Docker services
    pause
    exit /b 1
)
echo ✓ Services started
echo.

echo [3/6] Waiting for services to be ready...
timeout /t 5 /nobreak > nul
echo ✓ Services ready
echo.

echo [4/6] Installing Python dependencies...
pip install -e ".[dev]"
if %errorlevel% neq 0 (
    echo ERROR: Failed to install Python dependencies
    pause
    exit /b 1
)
echo ✓ Python dependencies installed
echo.

echo [5/6] Running database migrations...
alembic upgrade head
if %errorlevel% neq 0 (
    echo WARNING: Migrations failed. Trying alternative...
    python create_tables.py
)
echo ✓ Database initialized
echo.

echo [6/6] Installing frontend dependencies...
cd dashboard
call npm install
cd ..
echo ✓ Frontend dependencies installed
echo.

echo ========================================
echo Setup Complete! 🎉
echo ========================================
echo.
echo Next steps:
echo.
echo 1. Start Backend (Terminal 1):
echo    python -m piratehunt.api.main --host localhost --port 8000
echo.
echo 2. Start Frontend (Terminal 2):
echo    cd dashboard
echo    npm run dev
echo.
echo 3. Open Dashboard:
echo    http://localhost:3000
echo.
echo For detailed instructions, see SETUP_GUIDE.md
echo.
pause
