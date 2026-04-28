@echo off
title PirateHunt - Discovery Worker
color 0C

echo ========================================
echo    PIRATEHUNT DISCOVERY WORKER
echo ========================================
echo.
echo Setting up Python 3.11...
set PATH=C:\Users\onlys\AppData\Local\Programs\Python\Python311;C:\Users\onlys\AppData\Local\Programs\Python\Python311\Scripts;%PATH%

python --version
echo.
echo Starting discovery worker...
echo This worker discovers pirate streams
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

python -m piratehunt.cli worker discovery
