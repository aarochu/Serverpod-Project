# Code Butler Setup Guide

## Prerequisites

- Dart SDK (>=3.0.0)
- Flutter SDK (includes Dart)
- Docker Desktop
- PostgreSQL (via Docker)

## Installation

1. **Install Dependencies**
   ```bash
   cd code_butler_server
   dart pub get
   ```

2. **Generate Serverpod Code**
   ```bash
   serverpod generate
   ```

3. **Start Database**
   ```bash
   docker compose up -d
   ```

4. **Apply Migrations**
   ```bash
   serverpod create-migration
   serverpod apply-migrations --apply-migrations
   ```

## Configuration

### API Keys

Edit `config/development.yaml`:

```yaml
# GitHub Personal Access Token
githubToken: YOUR_GITHUB_PERSONAL_ACCESS_TOKEN

# Gemini API Key
geminiApiKey: YOUR_GEMINI_API_KEY

# Webhook Secret (for GitHub webhooks)
webhooks:
  secret: YOUR_WEBHOOK_SECRET
```

### GitHub Token Setup

1. Go to https://github.com/settings/tokens
2. Generate new token (classic)
3. Select scopes: `repo`, `read:org`, `read:user`
4. Copy token to `config/development.yaml`

### Gemini API Key

1. Get API key from hackathon signup email
2. Or visit: https://makersuite.google.com/app/apikey
3. Add to `config/development.yaml`

### Webhook Setup

1. Go to your GitHub repository settings
2. Navigate to Webhooks
3. Add webhook with:
   - Payload URL: `http://your-server:8080/webhook/handlePullRequest`
   - Content type: `application/json`
   - Secret: Same as in `config/development.yaml`
   - Events: `Pull requests`, `Pushes`

## Running the Server

```bash
dart run lib/server.dart
```

Server will start on `http://localhost:8080`

## Health Check

```bash
curl http://localhost:8080/healthCheck/healthCheck
```

## Testing

```bash
dart test
```

