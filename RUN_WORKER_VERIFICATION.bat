@echo off
title PirateHunt - Verification Worker
color 0D

echo ========================================
echo    PIRATEHUNT VERIFICATION WORKER
echo ========================================
echo.
echo Setting up Python 3.11...
set PATH=C:\Users\onlys\AppData\Local\Programs\Python\Python311;C:\Users\onlys\AppData\Local\Programs\Python\Python311\Scripts;%PATH%

python --version
echo.
echo Starting verification worker...
echo This worker verifies pirate candidates
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

python -m piratehunt.cli worker verification
