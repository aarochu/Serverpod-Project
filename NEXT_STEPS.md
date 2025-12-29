# Corrected Next Steps for Person 1

After installing Flutter/Dart, run these commands:

```bash
cd code_butler_server

# Step 1: Generate client protocol files from .spy.yaml models
serverpod generate

# Step 2: Start Docker (run from project root)
cd ..
docker compose up -d

# Step 3: Create and apply migrations
cd code_butler_server
serverpod create-migration
serverpod apply-migrations --apply-migrations

# Step 4: Verify server starts successfully
dart run lib/server.dart
```

## Important Notes

- The server entry point is `lib/server.dart` (not `bin/server.dart` or `bin/main.dart`)
- Serverpod 3 uses `serverpod apply-migrations --apply-migrations` to apply migrations
- The server should show "SERVERPOD version: 3.x.x, mode: development" when it starts
- Press Ctrl+C to stop the server after verification

## Verification Checklist

After running the setup:
- ✅ Server starts on `http://localhost:8080`
- ✅ Database has all 5 tables created:
  - `code_butler_repository`
  - `code_butler_pull_request`
  - `code_butler_agent_finding`
  - `code_butler_review_session`
  - `code_butler_generated_documentation`
- ✅ `code_butler_client/lib/src/protocol/` contains generated protocol files

