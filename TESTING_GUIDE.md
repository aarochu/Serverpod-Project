# Code Butler Testing Guide

## Quick Start Testing

### 1. Start the Server

```bash
cd code_butler_server
dart run lib/server.dart
```

The server should start on `http://localhost:8080` and show:
```
SERVERPOD version: 3.x.x, mode: development
```

### 2. Configure API Keys

Edit `code_butler_server/config/development.yaml`:
- Add your GitHub personal access token
- Add your Gemini API key

### 3. Test the Pipeline

#### Option A: Using the Test Script

```bash
cd code_butler_server
./test_agents.sh
```

#### Option B: Manual Testing with curl

**Step 1: Create a test repository**
```bash
curl -X POST http://localhost:8080/repository/createRepository \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "test-repo",
    "url": "https://github.com/your-username/test-repo.git",
    "owner": "your-username",
    "defaultBranch": "main"
  }'
```

**Step 2: Create a test pull request**
```bash
curl -X POST http://localhost:8080/pullRequest/createPullRequest \
  -H 'Content-Type: application/json' \
  -d '{
    "repositoryId": 1,
    "prNumber": 1,
    "title": "Test PR for Code Butler",
    "baseBranch": "main",
    "headBranch": "feature-branch",
    "filesChanged": 5
  }'
```

**Step 3: Start a review**
```bash
curl -X POST http://localhost:8080/review/startReview \
  -H 'Content-Type: application/json' \
  -d '{"pullRequestId": 1}'
```

This will return a `ReviewSession` object. Note the `id` field.

**Step 4: Monitor review progress**
```bash
# Get review status
curl http://localhost:8080/review/getReviewStatus?reviewSessionId=1

# Watch progress stream (in another terminal)
# The stream will output: "status:progress:currentFile"
```

**Step 5: Get findings**
```bash
curl http://localhost:8080/review/getFindings?pullRequestId=1

# Filter by severity
curl "http://localhost:8080/review/getFindings?pullRequestId=1&severity=critical"
```

## What to Watch For

### Server Logs

Watch the server console for:
- `[navigator]` - Repository cloning and file discovery
- `[reader]` - Code structure analysis
- `[security]` - Vulnerability scanning
- `[performance]` - Optimization suggestions
- `[documentation]` - Docstring generation
- `[verifier]` - Documentation verification

### Database Verification

Connect to PostgreSQL and check:
```sql
-- Check findings by agent type
SELECT agentType, severity, COUNT(*) 
FROM code_butler_agent_finding 
GROUP BY agentType, severity;

-- Check review progress
SELECT status, progressPercent, currentFile 
FROM code_butler_review_session;

-- Check generated documentation
SELECT filePath, functionName, verificationStatus 
FROM code_butler_generated_documentation;
```

## Expected Behavior

1. **Stage 1 (0-20%)**: NavigatorAgent clones repository and builds file list
2. **Stage 2 (20-60%)**: Files analyzed in parallel by ReaderAgent, SecurityAgent, PerformanceAgent
3. **Stage 3 (60-80%)**: DocumentationAgent generates docstrings, VerifierAgent validates them
4. **Stage 4 (80-100%)**: GitHubService posts formatted findings as PR comment

## Troubleshooting

### Server won't start
- Check if port 8080 is available
- Verify database is running: `docker compose ps`
- Check `config/development.yaml` syntax

### Agents not executing
- Verify API keys are configured (even if using fallbacks)
- Check server logs for errors
- Ensure repository URL is accessible

### No findings created
- Check if repository was cloned successfully
- Verify files exist in the cloned repository
- Check agent logs for specific errors

### GitHub comment not posted
- Verify GitHub token has correct permissions
- Check rate limiting in server logs
- Ensure PR number matches actual PR

## Next Steps

Once testing is successful:
1. Merge `backend/agent-implementation` to `main` (already done ✅)
2. Notify Person 2 that enhanced backend is ready
3. Person 2 can now integrate with Flutter frontend using the generated client code

