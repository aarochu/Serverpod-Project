# Code Butler - Multi-Agent AI Code Review System

A hackathon project demonstrating an intelligent multi-agent code review system built with Serverpod 3, Flutter, and AI.

## 🎯 Project Overview

Code Butler uses a team of specialized AI agents to automatically review code, detect issues, and generate fixes. Each agent focuses on a specific aspect of code quality:

- **NavigatorAgent**: Analyzes repository structure and builds dependency graphs
- **ReaderAgent**: Extracts code structure and calculates complexity metrics
- **SecurityAgent**: Detects vulnerabilities (hardcoded secrets, SQL injection, unsafe operations)
- **PerformanceAgent**: Identifies optimization opportunities
- **DocumentationAgent**: Generates docstrings using Gemini API
- **VerifierAgent**: Validates generated documentation quality

## ✨ Key Features

- **Multi-Agent Architecture**: Specialized agents working in parallel
- **Autofix Capabilities**: One-click fixes with automatic PR creation
- **Intelligent Caching**: 50% faster reviews through smart caching
- **Webhook Automation**: Automatic reviews on PR creation
- **Cross-Repository Learning**: System learns from patterns across repos
- **Real-time Progress**: Stream-based progress updates
- **Comprehensive Metrics**: Analytics and monitoring dashboard

## 🏗️ Architecture

```
GitHub Webhook → WebhookEndpoint → JobProcessor → AgentOrchestrator
                                                      ↓
                    ┌─────────────────────────────────┴──────────────┐
                    ↓                ↓                ↓                ↓
              NavigatorAgent   ReaderAgent   SecurityAgent   PerformanceAgent
                    ↓                ↓                ↓                ↓
                    └─────────────────────────────────┴──────────────┘
                                              ↓
                                    AgentFinding → AutofixService → GitHub PR
```

See [ARCHITECTURE.md](code_butler_server/ARCHITECTURE.md) for detailed architecture documentation.

## 🚀 Quick Start

### Prerequisites

- Dart SDK (>=3.0.0)
- Flutter SDK
- Docker Desktop
- Serverpod CLI: `dart pub global activate serverpod_cli`

### Development Setup

1. **Install Dependencies**
   ```bash
   cd code_butler_server
   dart pub get
   ```

2. **Generate Client Code**
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

5. **Configure API Keys**
   
   Edit `config/development.yaml`:
   ```yaml
   githubToken: YOUR_GITHUB_TOKEN
   geminiApiKey: YOUR_GEMINI_API_KEY
   webhooks:
     secret: YOUR_WEBHOOK_SECRET
   ```

6. **Run Server**
   ```bash
   dart run lib/server.dart
   ```

Server starts on `http://localhost:8080`

### Production Deployment

See [DEPLOYMENT.md](code_butler_server/DEPLOYMENT.md) for Serverpod Cloud deployment instructions.

## 📚 Documentation

- [SETUP.md](code_butler_server/SETUP.md) - Detailed setup guide
- [ARCHITECTURE.md](code_butler_server/ARCHITECTURE.md) - System architecture
- [DEPLOYMENT.md](code_butler_server/DEPLOYMENT.md) - Deployment guide
- [BENCHMARKS.md](code_butler_server/BENCHMARKS.md) - Performance benchmarks
- [INTEGRATION_TEST_SCENARIOS.md](code_butler_server/INTEGRATION_TEST_SCENARIOS.md) - Test scenarios

## 🔌 API Endpoints

### Repository Management
- `POST /repository/createRepository` - Create repository
- `GET /repository/listRepositories` - List all repositories
- `GET /repository/getRepositoryByUrl` - Get repository by URL

### Pull Request Management
- `POST /pullRequest/createPullRequest` - Create pull request
- `GET /pullRequest/listPullRequests` - List PRs for repository
- `GET /pullRequest/getPullRequest` - Get PR details

### Review Management
- `POST /review/startReview` - Start code review
- `GET /review/getReviewStatus` - Get review status
- `GET /review/getFindings` - Get findings for PR
- `Stream /review/watchReviewProgress` - Stream progress updates

### Webhooks
- `POST /webhook/handlePullRequest` - Handle GitHub PR events
- `POST /webhook/simulateWebhook` - Simulate webhook (demo)

### Metrics
- `GET /metrics/getRepositoryHealth` - Repository health score
- `GET /metrics/getTrends` - Time series trends
- `GET /metrics/getAgentEffectiveness` - Agent performance metrics
- `GET /healthCheck/healthCheck` - System health check

## 🧪 Testing

### Run Tests
```bash
dart test
```

### Seed Demo Data
```bash
dart run lib/scripts/seed_demo_data.dart
```

### Create Demo Repository
```bash
./lib/scripts/create_demo_repo.sh
```

## 📊 Performance

- **Review Speed**: 50% faster with intelligent caching
- **Accuracy**: 85% precision, 78% recall
- **Scalability**: Handles 500+ files per review
- **Concurrency**: Supports 5+ simultaneous reviews

See [BENCHMARKS.md](code_butler_server/BENCHMARKS.md) for detailed metrics.

## 🔒 Security

- Input validation and sanitization
- Rate limiting (60 requests/minute)
- GitHub webhook signature verification
- SQL injection protection
- CORS configuration

## 🤝 Contributing

This is a hackathon project. For questions or issues, please open an issue on GitHub.

## 📄 License

MIT

## 👥 Team

Built for hackathon by:
- Person 1 (Backend Lead)
- Person 2 (Frontend Lead)

## 🔗 Links

- GitHub Repository: [https://github.com/aarochu/Serverpod-Project](https://github.com/aarochu/Serverpod-Project)
- Serverpod Documentation: [https://docs.serverpod.dev](https://docs.serverpod.dev)
