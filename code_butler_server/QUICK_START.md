# Quick Start Guide for Integration Testing

## Step 1: Generate Protocol Code

**CRITICAL:** You must run this first to generate all the database model classes:

```bash
cd code_butler_server
serverpod generate
```

This generates:
- `lib/src/generated/protocol.dart` - All database models
- Client code in `code_butler_client/`

## Step 2: Start Database (if not running)

```bash
# From project root
docker compose up -d
```

## Step 3: Apply Migrations

```bash
cd code_butler_server
serverpod create-migration
serverpod apply-migrations --apply-migrations
```

## Step 4: Start Server

**Option A: Use the start script**
```bash
./START_SERVER.sh
```

**Option B: Manual start**
```bash
dart run lib/server.dart
```

## Expected Output

```
SERVERPOD version: 3.x.x, mode: development
Server running on http://localhost:8080
```

## Verify Server is Running

In another terminal:

```bash
curl http://localhost:8080/healthCheck/healthCheck
```

Should return JSON with health status.

## For Person 2

Share this information:
- **Backend URL**: `http://localhost:8080`
- **Health Check**: `http://localhost:8080/healthCheck/healthCheck`
- **API Base**: `http://localhost:8080`

## Troubleshooting

### "Protocol classes not found" errors
→ Run `serverpod generate` first

### "Database connection failed"
→ Check Docker is running: `docker compose ps`
→ Start database: `docker compose up -d`

### "Port 8080 already in use"
→ Kill process on port 8080 or change port in `config/development.yaml`

### Server won't start
→ Check logs for specific errors
→ Verify `serverpod generate` completed successfully
→ Check database is accessible

## Next Steps

1. Server running ✅
2. Share backend URL with Person 2
3. Test health check endpoint together
4. Begin integration testing (see INTEGRATION_TESTING.md)

