@echo off
title PirateHunt - Dashboard
color 0B

echo ========================================
echo    PIRATEHUNT DASHBOARD
echo ========================================
echo.
echo Starting frontend server...
echo.
echo ✅ Dashboard: http://localhost:3000
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

cd dashboard
npm run dev
