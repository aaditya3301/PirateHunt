@echo off
echo Setting Python 3.11 as default for this session...
echo.

set PATH=C:\Users\onlys\AppData\Local\Programs\Python\Python311;C:\Users\onlys\AppData\Local\Programs\Python\Python311\Scripts;%PATH%

python --version
echo.
echo ✅ Python 3.11 is now active for this terminal session
echo.
echo You can now run:
echo   python -m piratehunt.api.main --host localhost --port 8000
echo.
