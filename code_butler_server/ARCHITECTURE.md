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

## Deployment Considerations

### Scaling Strategy

**Horizontal Scaling:**
- Serverpod Cloud supports multiple server instances
- Load balancing handled automatically
- Database connection pooling (5-20 connections)

**Vertical Scaling:**
- Increase server resources in Serverpod Cloud dashboard
- Adjust connection pool size based on load
- Monitor memory usage and scale accordingly

### Security Model

**Authentication:**
- GitHub OAuth for user authentication
- API key validation for external services
- Webhook signature verification

**Authorization:**
- Repository-level access control
- User preferences for personalized experience

**Data Encryption:**
- HTTPS for all communications
- Encrypted database connections
- Secure storage of API keys in environment variables

### Data Retention Policies

**Review Data:**
- Keep reviews for 90 days by default
- Archive old reviews to cold storage
- Configurable retention period

**Performance Logs:**
- Retain for 30 days
- Aggregate for long-term metrics
- Clean up old logs automatically

**Cache:**
- TTL-based expiration (1 hour default)
- LRU eviction for memory management
- Clear on repository updates

### Backup and Disaster Recovery

**Database Backups:**
- Daily automated backups via Serverpod Cloud
- Manual backup before migrations
- Point-in-time recovery available

**Disaster Recovery:**
- Multi-region deployment option
- Automated failover in Serverpod Cloud
- Rollback procedures documented

### Cost Estimation

**Small Scale (1-10 repos, <100 reviews/day):**
- Server: ~$20/month
- Database: ~$15/month
- API calls: ~$10/month
- **Total: ~$45/month**

**Medium Scale (10-100 repos, 100-1000 reviews/day):**
- Server: ~$50/month
- Database: ~$30/month
- API calls: ~$50/month
- **Total: ~$130/month**

**Large Scale (100+ repos, 1000+ reviews/day):**
- Server: ~$150/month
- Database: ~$100/month
- API calls: ~$200/month
- **Total: ~$450/month**

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

