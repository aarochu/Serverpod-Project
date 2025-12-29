# Code Butler Setup Guide

## ✅ Completed Steps

1. ✅ Project structure created
2. ✅ 5 database models created in `code_butler_server/lib/src/models/`:
   - `repository.spy.yaml`
   - `pull_request.spy.yaml`
   - `agent_finding.spy.yaml`
   - `review_session.spy.yaml`
   - `generated_documentation.spy.yaml`
3. ✅ Docker Compose configuration created
4. ✅ Flutter app structure created
5. ✅ Shared configuration files created (`config/github_oauth.yaml`, `config/gemini_api.yaml`)
6. ✅ Git repository initialized and pushed to GitHub
7. ✅ GitHub repository created: https://github.com/joshnaimcwx/code-butler

## ⚠️ Next Steps (Requires Dart/Flutter Installation)

### Prerequisites Installation

1. **Install Dart SDK**: https://dart.dev/get-dart
2. **Install Flutter SDK**: https://flutter.dev/docs/get-started/install
3. **Install Docker**: https://docs.docker.com/get-docker/

### Setup Commands

Once prerequisites are installed, run:

```bash
# Option 1: Use the setup script
./setup.sh

# Option 2: Manual setup
# 1. Install Serverpod CLI
dart pub global activate serverpod_cli

# 2. Install server dependencies
cd code_butler_server
dart pub get

# 3. Generate client code (IMPORTANT - creates code_butler_client protocol files)
serverpod generate

# 4. Install Flutter dependencies
cd ../code_butler_flutter
flutter pub get

# 5. Start PostgreSQL
cd ..
docker compose up -d

# 6. Apply database migrations
cd code_butler_server
serverpod create-migration
serverpod apply-migrations --apply-migrations

# 7. Start the server
dart run bin/server.dart
```

## Verification Checklist

After running the setup:

- [ ] Server starts on `http://localhost:8080`
- [ ] Database has all 5 tables created:
  - `code_butler_repository`
  - `code_butler_pull_request`
  - `code_butler_agent_finding`
  - `code_butler_review_session`
  - `code_butler_generated_documentation`
- [ ] `code_butler_client/lib/src/protocol/` contains generated protocol files
- [ ] Flutter app can connect to the server

## Configuration

Before running the server, configure your API keys:

1. Edit `config/github_oauth.yaml` with your GitHub OAuth credentials
2. Edit `config/gemini_api.yaml` with your Gemini API key

## Project Structure

```
code_butler/
├── code_butler_server/          # Main Serverpod server
│   ├── lib/
│   │   ├── src/
│   │   │   ├── models/          # 5 .spy.yaml model files
│   │   │   └── endpoints/        # API endpoints
│   │   ├── server.dart
│   │   └── protocol.dart
│   └── config/                   # Server configuration
├── code_butler_client/           # Auto-generated client (after serverpod generate)
├── code_butler_flutter/          # Flutter application
├── config/                       # Shared config files
│   ├── github_oauth.yaml
│   └── gemini_api.yaml
└── docker-compose.yml            # PostgreSQL setup
```

## Database Models Summary

1. **Repository**: Stores repository info with unique URL index
2. **PullRequest**: Tracks PRs with status (pending/in_progress/completed/failed)
3. **AgentFinding**: Stores AI findings with severity (critical/warning/info)
4. **ReviewSession**: Tracks review progress and status
5. **GeneratedDocumentation**: Stores generated docs with verification status

## GitHub Repository

Repository URL: **https://github.com/joshnaimcwx/code-butler**

The code has been pushed to the `main` branch.

