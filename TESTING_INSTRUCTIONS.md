# Integration Testing Instructions

## Quick Start

### Option 1: Use the Start Script (Recommended)

```bash
./START_TESTING.sh
```

This will:
- Check dependencies
- Generate client code
- Start backend server
- Start Flutter app

### Option 2: Manual Start (Two Terminals)

**Terminal 1 - Backend:**
```bash
cd code_butler_server
dart run lib/server.dart
```

**Terminal 2 - Frontend:**
```bash
cd code_butler_flutter
flutter run -d chrome
```

## Pre-Testing Checklist

- [ ] Code pulled from GitHub (`git pull origin main`)
- [ ] Flutter dependencies installed (`flutter pub get`)
- [ ] Server dependencies installed (`dart pub get`)
- [ ] Client code generated (`serverpod generate`)
- [ ] Database running (if using Docker: `docker compose up -d`)
- [ ] Migrations applied (if needed: `serverpod apply-migrations --apply-migrations`)

## Testing Flow

1. **Backend Health Check**
   - Open: http://localhost:8080/healthCheck/healthCheck
   - Should return JSON with status

2. **Flutter App**
   - Should open in Chrome automatically
   - Check console for connection to backend

3. **Test Features**
   - Create repository
   - Create pull request
   - Start review
   - Monitor progress
   - View findings
   - Test autofix (if implemented)

## Troubleshooting

### Backend won't start
- Check port 8080 is available
- Verify `serverpod generate` completed
- Check database is running
- Review server logs for errors

### Flutter app won't connect
- Verify backend is running
- Check backend URL in Flutter config
- Check CORS settings in `development.yaml`
- Review browser console for errors

### Client code errors
- Run `serverpod generate` again
- Check `code_butler_client/lib/src/protocol/` exists
- Verify imports in Flutter code

## URLs

- **Backend**: http://localhost:8080
- **Health Check**: http://localhost:8080/healthCheck/healthCheck
- **Flutter App**: http://localhost:XXXX (shown in terminal)

## Next Steps

After successful testing:
1. Document any issues found
2. Fix critical bugs
3. Prepare for demo
4. Record demo video

