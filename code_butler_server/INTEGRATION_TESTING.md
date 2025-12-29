# Integration Testing Guide for Person 1 & Person 2

## Pre-Testing Checklist

### Person 1 (Backend) - Before Starting

- [ ] Dependencies installed: `dart pub get`
- [ ] Database running: `docker compose up -d`
- [ ] Migrations applied: `serverpod apply-migrations --apply-migrations`
- [ ] API keys configured in `config/development.yaml`:
  - [ ] GitHub token (optional for basic testing)
  - [ ] Gemini API key (optional, will use fallback)
  - [ ] Webhook secret (optional)
- [ ] Server can start without errors

### Person 2 (Frontend) - Before Starting

- [ ] Flutter dependencies installed
- [ ] Backend URL configured in Flutter app
- [ ] Client code generated (if needed)

## Starting the Backend Server

### Person 1: Start Server

```bash
cd code_butler_server
dart run lib/server.dart
```

**Expected Output:**
```
SERVERPOD version: 3.x.x, mode: development
Server running on http://localhost:8080
```

**If you see errors:**
- Check database is running: `docker compose ps`
- Verify migrations: `serverpod apply-migrations --apply-migrations`
- Check config file syntax

### Verify Server is Running

In another terminal, test the health endpoint:

```bash
curl http://localhost:8080/healthCheck/healthCheck
```

Should return JSON with status information.

## Integration Test Flow

### 1. Health Check (Person 2)
- Frontend calls `/healthCheck/healthCheck`
- Verify connection successful

### 2. Repository Management (Person 2)
- Create repository via frontend
- Backend: Check logs for repository creation
- List repositories
- Verify data appears in frontend

### 3. Pull Request Creation (Person 2)
- Create PR via frontend
- Backend: Check logs for PR creation
- Verify PR appears in frontend

### 4. Start Review (Person 2)
- Click "Start Review" in frontend
- Backend: Watch logs for:
  - `Started review session: X for PR Y`
  - `Starting agent processing`
  - Agent execution logs

### 5. Monitor Progress (Person 2)
- Frontend should show progress stream
- Backend: Check `ReviewSession` status updates
- Verify progress percentage increases

### 6. View Findings (Person 2)
- Frontend fetches findings
- Backend: Verify findings in database
- Check findings appear in UI

### 7. GitHub Integration (Optional)
- If GitHub token configured:
  - Verify PR comment posted
  - Check GitHub for comment

### 8. Autofix (Optional)
- If autofix enabled:
  - Apply fix via frontend
  - Backend: Check autofix generation
  - Verify PR creation (if configured)

## Common Issues & Solutions

### Issue: Connection Refused
**Solution:**
- Verify server is running on port 8080
- Check firewall settings
- Verify frontend URL is correct

### Issue: CORS Errors
**Solution:**
- Check `development.yaml` CORS settings
- Add frontend origin to allowed origins
- Restart server

### Issue: Database Connection Failed
**Solution:**
- Check Docker is running: `docker compose ps`
- Verify database credentials in config
- Check database logs: `docker compose logs db`

### Issue: Agent Processing Fails
**Solution:**
- Check server logs for specific error
- Verify repository URL is accessible
- Check API keys are valid (if using external APIs)

### Issue: Progress Not Updating
**Solution:**
- Check stream endpoint is working
- Verify ReviewSession is updating in database
- Check frontend stream connection

## Testing Checklist

- [ ] Health check works
- [ ] Repository creation works
- [ ] PR creation works
- [ ] Review starts successfully
- [ ] Progress stream updates
- [ ] Findings appear in UI
- [ ] All 6 agents execute
- [ ] GitHub comment posted (if configured)
- [ ] Autofix works (if tested)
- [ ] Error handling works
- [ ] UI remains responsive

## Log Monitoring

### Key Log Messages to Watch

**Successful Review:**
```
Started review session: X for PR Y
Starting agent processing for review session X
[navigator] Cloning repository...
[reader] Analyzing file...
[security] Scanning file...
[performance] Analyzing performance...
[documentation] Generating docstring...
[verifier] Verifying documentation...
Agent processing completed for review session X
```

**Errors to Watch For:**
```
ERROR: Repository not found
ERROR: Failed to clone repository
ERROR: Agent processing failed
ERROR: Database connection failed
```

## Next Steps After Testing

1. **Fix any issues found**
2. **Document integration results**
3. **Prepare for demo**
4. **Coordinate demo video recording**

## Support

If issues arise during testing:
1. Check server logs
2. Check database logs
3. Verify configuration
4. Test endpoints individually with curl
5. Review error messages carefully

