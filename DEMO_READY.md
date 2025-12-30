# 🚀 Code Butler Demo - Ready to Execute!

## Quick Start (3 Commands)

### 1. Start Database
```bash
docker compose up -d
```

### 2. Start Backend (Terminal 1)
```bash
cd code_butler_server
dart run lib/server.dart
```

### 3. Start Frontend (Terminal 2)
```bash
cd code_butler_flutter
flutter run -d chrome
```

## What You'll See

### Backend Terminal
```
SERVERPOD version: 3.1.1, mode: development
Server running on http://localhost:8080
```

### Frontend Browser
- Code Butler dashboard
- Navigation menu
- Clean, modern UI

## Demo Flow

1. **Dashboard** → See overview
2. **Repositories** → Add a repository
3. **Pull Requests** → Create a PR
4. **Start Review** → Watch agents work
5. **Findings** → See issues found
6. **Dashboard** → View metrics

## Success Indicators

✅ Server shows "running on http://localhost:8080"
✅ Browser opens with Code Butler UI
✅ Can navigate between screens
✅ Can create repository and PR
✅ Review starts and completes
✅ Findings appear in UI

## If Something Fails

1. **Database not running**: `docker compose up -d`
2. **Server errors**: Check database is running
3. **Frontend won't load**: Check backend is running
4. **Connection errors**: Check CORS in config

## Full Documentation

- `EXECUTE_DEMO_NOW.md` - Detailed step-by-step plan
- `WHAT_IS_CODE_BUTLER.md` - Product explanation
- `GET_IT_WORKING_PLAN.md` - Technical plan

## Ready? Let's Go! 🎉

Run the 3 commands above and watch Code Butler come to life!

