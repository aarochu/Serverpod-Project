# Code Butler - Multi-Agent AI Code Review System

A Serverpod 3 project for automated code review using multi-agent AI systems.

## Project Structure

- `code_butler_server/` - Main Serverpod server
- `code_butler_client/` - Auto-generated client (run `serverpod generate` to create)
- `code_butler_flutter/` - Flutter application
- `config/` - Shared configuration files for GitHub OAuth and Gemini API

## Prerequisites

- Dart SDK (>=3.0.0)
- Flutter SDK
- Docker and Docker Compose
- Serverpod CLI: `dart pub global activate serverpod_cli`

## Setup Instructions

### 1. Install Dependencies

```bash
# Install Serverpod CLI
dart pub global activate serverpod_cli

# Install server dependencies
cd code_butler_server
dart pub get

# Install Flutter dependencies
cd ../code_butler_flutter
flutter pub get
```

### 2. Generate Client Code

```bash
cd code_butler_server
serverpod generate
```

This will auto-generate the client code in `code_butler_client/`.

### 3. Start PostgreSQL Database

```bash
# From project root
docker compose up -d
```

### 4. Apply Database Migrations

```bash
cd code_butler_server
serverpod create-migration
serverpod apply-migrations --apply-migrations
```

### 5. Configure API Keys

Edit the following files with your credentials:
- `config/github_oauth.yaml` - GitHub OAuth credentials
- `config/gemini_api.yaml` - Google Gemini API key

### 6. Run the Server

```bash
cd code_butler_server
dart run lib/server.dart
```

The server will start on `http://localhost:8080`.

## Database Models

1. **Repository** - Stores repository information with unique URL index
2. **PullRequest** - Tracks pull requests with status and file changes
3. **AgentFinding** - Stores AI agent findings with severity and suggestions
4. **ReviewSession** - Tracks review progress and status
5. **GeneratedDocumentation** - Stores generated documentation with verification status

## Development

- Server runs on `localhost:8080`
- Database runs on `localhost:5432`
- Flutter app can be run with `flutter run` from `code_butler_flutter/`

## License

MIT
