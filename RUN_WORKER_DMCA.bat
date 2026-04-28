@echo off
title PirateHunt - DMCA Worker
color 0E

echo ========================================
echo    PIRATEHUNT DMCA WORKER
echo ========================================
echo.
echo Setting up Python 3.11...
set PATH=C:\Users\onlys\AppData\Local\Programs\Python\Python311;C:\Users\onlys\AppData\Local\Programs\Python\Python311\Scripts;%PATH%

python --version
echo.
echo Starting DMCA worker...
echo This worker generates DMCA takedown notices
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

python -m piratehunt.cli worker dmca
