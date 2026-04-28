@echo off
title PirateHunt - Backend API Server
color 0A

echo ========================================
echo    PIRATEHUNT BACKEND API SERVER
echo ========================================
echo.
echo Setting up Python 3.11...
set PATH=C:\Users\onlys\AppData\Local\Programs\Python\Python311;C:\Users\onlys\AppData\Local\Programs\Python\Python311\Scripts;%PATH%

python --version
echo.
echo Starting backend server...
echo.
echo ✅ API: http://localhost:8000
echo ✅ Docs: http://localhost:8000/docs
echo ✅ Health: http://localhost:8000/health
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

python -m piratehunt.api.main --host localhost --port 8000
