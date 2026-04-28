# 🚀 PirateHunt Quick Start

## ✅ Setup Complete!

All dependencies are installed and the database is initialized. You're ready to run PirateHunt!

## 🎯 Running the System

You need **2 terminals** running simultaneously:

### Terminal 1: Backend API
```bash
./start-backend.bat
```
Or manually:
```bash
C:\Users\onlys\AppData\Local\Programs\Python\Python311\python.exe -m piratehunt.api.main --host localhost --port 8000
```

**Backend will be available at:**
- 🌐 API: http://localhost:8000
- 📚 API Docs: http://localhost:8000/docs
- ❤️ Health Check: http://localhost:8000/health

### Terminal 2: Frontend Dashboard
```bash
./start-frontend.bat
```
Or manually:
```bash
cd dashboard
npm run dev
```

**Dashboard will be available at:**
- 🎨 Dashboard: http://localhost:3000

## 🎬 What You'll See

Once both are running, open http://localhost:3000 to see:

1. **Live Connection Status** - Green dot = connected to backend
2. **3D Globe** - Shows pirate stream locations (placeholder for now)
3. **Event Feed** - Real-time stream of detections and takedowns
4. **Revenue Loss Ticker** - Estimated financial impact
5. **Takedown Funnel** - Pipeline visualization
6. **Statistics** - Active pirates, detected, drafted, submitted, resolved

## 🧪 Testing the System

### 1. Check Backend Health
```bash
curl http://localhost:8000/health
```

### 2. View API Documentation
Open: http://localhost:8000/docs

### 3. Create a Test Match
```bash
curl -X POST http://localhost:8000/matches \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"Test Cricket Match\", \"source_url\": \"https://example.com/test.mp4\"}"
```

### 4. List Matches
```bash
curl http://localhost:8000/matches
```

## 🔧 Optional: Run Workers

For full functionality, you can run additional workers in separate terminals:

### Terminal 3: Verification Worker
```bash
C:\Users\onlys\AppData\Local\Programs\Python\Python311\python.exe -m piratehunt.cli worker verification
```

### Terminal 4: DMCA Worker
```bash
C:\Users\onlys\AppData\Local\Programs\Python\Python311\python.exe -m piratehunt.cli worker dmca
```

### Terminal 5: Discovery Agents
```bash
C:\Users\onlys\AppData\Local\Programs\Python\Python311\python.exe -m piratehunt.cli worker discovery
```

## 📊 Current Status

✅ Python 3.11.9 installed and configured
✅ All Python dependencies installed
✅ Frontend dependencies installed
✅ PostgreSQL running (port 5433)
✅ Redis running (port 6379)
✅ Database migrations completed
✅ Backend imports successfully
✅ Ready to run!

## ⚠️ Important Notes

### Python Version
You MUST use Python 3.11 (not 3.10). The project requires Python >=3.11.

**Correct command:**
```bash
C:\Users\onlys\AppData\Local\Programs\Python\Python311\python.exe
```

**Wrong command (will fail):**
```bash
python  # This uses Python 3.10
```

### Missing Dependencies (Optional)
FFmpeg and Chromaprint are required for video/audio processing but not needed for basic dashboard testing:

- **FFmpeg**: Download from https://www.gyan.dev/ffmpeg/builds/
- **Chromaprint**: Download from https://acoustid.org/chromaprint

## 🐛 Troubleshooting

### Backend won't start
```bash
# Check if port 8000 is in use
netstat -ano | findstr :8000

# Verify Python imports
C:\Users\onlys\AppData\Local\Programs\Python\Python311\python.exe -c "from piratehunt.api.app import app; print('OK')"
```

### Frontend won't start
```bash
# Reinstall dependencies
cd dashboard
npm install
```

### Database connection errors
```bash
# Check PostgreSQL is running
docker ps

# Restart services
docker compose restart postgres
```

### WebSocket not connecting
1. Make sure backend is running on port 8000
2. Check `dashboard/.env` has correct URLs:
   ```
   NEXT_PUBLIC_API_URL=http://localhost:8000
   NEXT_PUBLIC_WS_URL=ws://localhost:8000/ws
   ```
3. Check browser console for errors

## 📚 Documentation

- **Full Setup Guide**: `SETUP_GUIDE.md`
- **Project README**: `README.md`
- **Phase 6 Details**: `PHASE6_BUILD.md`
- **Deliverables**: `DELIVERABLES.md`

## 🎉 Next Steps

1. ✅ Start backend: `./start-backend.bat`
2. ✅ Start frontend: `./start-frontend.bat`
3. 🌐 Open http://localhost:3000
4. 🎬 Explore the dashboard
5. 📖 Read the documentation
6. 🔍 Test the API endpoints

---

**Happy Pirate Hunting! 🏴‍☠️🎯**
