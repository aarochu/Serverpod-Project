# Code Butler Architecture

## System Overview

Code Butler is a multi-agent code review system built on Serverpod 3. It uses specialized agents to analyze code, detect issues, and generate fixes.

## Architecture Diagram

```
┌─────────────────┐
│  GitHub Webhook │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ WebhookEndpoint  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  JobProcessor    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│AgentOrchestrator │
└────────┬────────┘
         │
    ┌────┴────┬──────────┬──────────┬──────────┐
    ▼         ▼          ▼          ▼          ▼
┌────────┐ ┌──────┐ ┌────────┐ ┌─────────┐ ┌────────┐
│Navigator│ │Reader│ │Security│ │Performance│ │Document│
│ Agent  │ │Agent │ │ Agent  │ │  Agent  │ │ Agent  │
└────────┘ └──────┘ └────────┘ └─────────┘ └────────┘
    │         │          │           │           │
    └─────────┴──────────┴───────────┴───────────┘
                    │
                    ▼
            ┌───────────────┐
            │ AgentFinding  │
            └───────────────┘
                    │
                    ▼
            ┌───────────────┐
            │ AutofixService│
            └───────────────┘
                    │
                    ▼
            ┌───────────────┐
            │ GitPatchService│
            └───────────────┘
                    │
                    ▼
            ┌───────────────┐
            │  GitHub API    │
            └───────────────┘
```

## Components

### Agents

1. **NavigatorAgent**: Clones repository, builds dependency graph, discovers files
2. **ReaderAgent**: Analyzes code structure, extracts functions, calculates complexity
3. **SecurityAgent**: Scans for vulnerabilities (secrets, SQL injection, unsafe ops)
4. **PerformanceAgent**: Detects performance bottlenecks and optimization opportunities
5. **DocumentationAgent**: Generates docstrings using Gemini API
6. **VerifierAgent**: Verifies generated documentation quality

### Services

- **AutofixService**: Generates code fixes for findings
- **GitPatchService**: Creates git patches and PRs with fixes
- **RepositoryCache**: Caches file content and dependency graphs
- **FindingsCache**: Prevents duplicate findings
- **PatternLearningService**: Learns from patterns across repositories
- **JobProcessor**: Processes background review jobs
- **NotificationService**: Manages user notifications

### Endpoints

- **RepositoryEndpoint**: Repository management
- **PullRequestEndpoint**: PR management
- **ReviewEndpoint**: Review session management
- **WebhookEndpoint**: GitHub webhook handling
- **NotificationEndpoint**: User notifications
- **MetricsEndpoint**: Analytics and metrics
- **HealthCheckEndpoint**: System health monitoring

## Data Flow

1. GitHub webhook triggers review
2. WebhookEndpoint creates ReviewJob
3. JobProcessor picks up job
4. AgentOrchestrator coordinates agents
5. Agents analyze code and create findings
6. AutofixService generates fixes
7. GitPatchService creates PR with fixes
8. NotificationService notifies users

## Database Models

- Repository
- PullRequest
- AgentFinding
- ReviewSession
- GeneratedDocumentation
- AppliedFix
- PatternLibrary
- UserPreference
- WebhookEvent
- ReviewJob
- ReviewNotification
- PerformanceLog

## Caching Strategy

- File content cached with hash-based invalidation
- Dependency graphs cached per repository
- LRU eviction for memory management
- TTL-based expiration

## Performance Optimizations

- Parallel file processing
- Intelligent file filtering
- Early termination on critical issues
- Configurable limits (files, time, findings)

