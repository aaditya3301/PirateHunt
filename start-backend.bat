@echo off
echo ========================================
echo Starting PirateHunt Backend API
echo ========================================
echo.
echo API will be available at: http://localhost:8000
echo API Docs: http://localhost:8000/docs
echo Health Check: http://localhost:8000/health
echo.
echo Press Ctrl+C to stop the server
echo.

C:\Users\onlys\AppData\Local\Programs\Python\Python311\python.exe -m piratehunt.api.main --host localhost --port 8000
