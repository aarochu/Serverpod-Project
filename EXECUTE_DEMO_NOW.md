# Execute Demo Now - Step-by-Step Plan

## Current Status
- ✅ Code is pulled and ready
- ⚠️ Database needs to be started
- ⚠️ Code generation has warnings but may still work
- ⚠️ Server needs database connection

## Execution Plan

### Step 1: Start Database (REQUIRED FIRST)

**Option A: Using Docker (Recommended)**
```bash
# From project root
docker compose up -d

# Wait 5 seconds for database to start
sleep 5

# Verify database is running
docker compose ps
```

**Option B: If Docker not available**
- You'll need PostgreSQL running on localhost:5432
- Database name: `code_butler`
- Username: `postgres`
- Password: `password`

### Step 2: Apply Database Migrations

```bash
cd code_butler_server
export PATH="$PATH:$HOME/.pub-cache/bin"

# Create migration
serverpod create-migration

# Apply migration
serverpod apply-migrations --apply-migrations
```

### Step 3: Start Backend Server

```bash
cd code_butler_server
dart run lib/server.dart
```

**Expected Output:**
```
SERVERPOD version: 3.1.1, mode: development
Server running on http://localhost:8080
```

**If you see database errors:**
- Check database is running: `docker compose ps`
- Check database connection in config file
- Verify database credentials

### Step 4: Verify Backend (In New Terminal)

```bash
# Test health check
curl http://localhost:8080/healthCheck/healthCheck

# Should return JSON with status
```

### Step 5: Start Frontend

**In a NEW terminal:**
```bash
cd code_butler_flutter
flutter run -d chrome
```

**Expected:**
- Chrome browser opens
- Flutter app loads
- Dashboard appears

### Step 6: Test Full Workflow

1. **Create Repository**
   - Click "Repositories" in UI
   - Click "Add Repository"
   - Enter: `https://github.com/your-username/your-repo`

2. **Create Pull Request**
   - Click "Pull Requests"
   - Click "Add PR"
   - Enter PR details

3. **Start Review**
   - Click on a PR
   - Click "Start Review"
   - Watch progress bar

4. **View Findings**
   - Click "Findings" tab
   - See list of issues found

5. **View Dashboard**
   - Click "Dashboard"
   - See metrics and charts

## Quick Start Script

I've created `START_DEMO.sh` that automates this:

```bash
./START_DEMO.sh
```

This will:
1. Check dependencies
2. Generate client code
3. Start backend
4. Start frontend

## Troubleshooting

### "Database connection failed"
- Start database: `docker compose up -d`
- Check Docker is running
- Verify credentials in `config/development.yaml`

### "Server won't start"
- Check database is running
- Check for errors in terminal
- Verify `serverpod generate` completed

### "Frontend won't connect"
- Verify backend is running
- Check backend URL in Flutter config
- Check CORS settings

### "Protocol classes not found"
- Run `serverpod generate` again
- Check `code_butler_client/lib/src/protocol/` exists

## What Success Looks Like

✅ Backend: Server running on http://localhost:8080
✅ Frontend: Chrome opens with Code Butler UI
✅ Health Check: Returns JSON with "healthy" status
✅ UI: Can navigate between screens
✅ Workflow: Can create repo, PR, start review, see findings

## Next: Execute!

Run these commands in order:

```bash
# Terminal 1: Start database
docker compose up -d

# Wait 5 seconds
sleep 5

# Terminal 1: Start backend
cd code_butler_server
dart run lib/server.dart

# Terminal 2: Start frontend
cd code_butler_flutter
flutter run -d chrome
```

Then test the workflow in the browser!

