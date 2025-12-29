# Code Butler Server Setup Commands

## Prerequisites
- Dart SDK installed and in PATH
- Docker installed and running
- Serverpod CLI installed: `dart pub global activate serverpod_cli`

## Setup Steps

Run these commands from the `code_butler_server` directory:

```bash
cd code_butler_server

# Step 1: Generate client protocol files from your .spy.yaml models
serverpod generate

# Step 2: Start Docker PostgreSQL database (from project root)
cd ..
docker compose up -d

# Step 3: Apply database migrations to create tables
cd code_butler_server
serverpod create-migration
serverpod apply-migrations --apply-migrations

# Step 4: Verify server starts successfully
# The server entry point is lib/server.dart (not bin/main.dart)
dart run lib/server.dart
```

## Notes

- The server entry point is `lib/server.dart`, not `bin/main.dart`
- Serverpod 3 uses `serverpod apply-migrations --apply-migrations`, not `dart run bin/main.dart --apply-migrations`
- The server should show "SERVERPOD version: 3.x.x, mode: development" when it starts
- Press Ctrl+C to stop the server after verification

## Verification

After running the setup:
- ✅ Server starts on `http://localhost:8080`
- ✅ Database has all 5 tables created
- ✅ `code_butler_client/lib/src/protocol/` contains generated protocol files

