# What is Code Butler?

## The Product

**Code Butler** is an **AI-powered multi-agent code review system** that automatically analyzes GitHub pull requests and provides intelligent feedback.

### Core Concept

Instead of manually reviewing every PR, Code Butler uses **6 specialized AI agents** that work together to:
- 🔍 **Analyze code** for bugs, security issues, performance problems
- 📝 **Generate documentation** for undocumented functions
- ✅ **Verify quality** of generated documentation
- 🚀 **Suggest fixes** and even create PRs with autofixes
- 📊 **Track metrics** across all your repositories

## The 6 AI Agents

1. **NavigatorAgent** - Clones repos, builds dependency graphs, identifies files to review
2. **ReaderAgent** - Parses code structure, extracts functions/classes, calculates complexity
3. **SecurityAgent** - Finds vulnerabilities (hardcoded secrets, SQL injection, unsafe operations)
4. **PerformanceAgent** - Detects bottlenecks (inefficient loops, missing optimizations)
5. **DocumentationAgent** - Generates docstrings using Gemini AI
6. **VerifierAgent** - Validates that generated docs match the actual code

## What You Should See When It's Working

### 1. Backend Server Running

**Terminal 1 - Backend:**
```bash
cd code_butler_server
dart run lib/server.dart
```

**Expected Output:**
```
SERVERPOD version: 3.1.1, mode: development
Server running on http://localhost:8080
```

✅ **Success indicators:**
- No error messages
- Server shows "running on http://localhost:8080"
- No crashes or exceptions

### 2. Flutter Frontend Running

**Terminal 2 - Frontend:**
```bash
cd code_butler_flutter
flutter run -d chrome
```

**Expected Output:**
- Chrome browser opens automatically
- You see a **dashboard interface** with:
  - Navigation menu (Repositories, Pull Requests, Reviews, Findings, Notifications)
  - Dashboard with metrics and charts
  - Clean, modern UI

✅ **Success indicators:**
- Browser opens without errors
- UI loads and displays
- No red error screens
- Can navigate between screens

### 3. Health Check Endpoint

**In browser or terminal:**
```bash
curl http://localhost:8080/healthCheck/healthCheck
```

**Expected Output:**
```json
{
  "status": "healthy",
  "database": "connected",
  "timestamp": "2025-12-30T..."
}
```

✅ **Success indicators:**
- Returns JSON response
- Status shows "healthy"
- Database shows "connected"

### 4. Full Workflow Test

**What to test:**

1. **Create a Repository**
   - In Flutter app: Click "Repositories" → "Add Repository"
   - Enter: `https://github.com/your-username/your-repo`
   - Should see repository added to list

2. **Create a Pull Request**
   - In Flutter app: Click "Pull Requests" → "Add PR"
   - Enter PR number and details
   - Should see PR in list

3. **Start a Review**
   - Click on a PR → "Start Review"
   - Watch progress bar update
   - Should see status change: "initializing" → "analyzing" → "completed"

4. **View Findings**
   - Click "Findings" tab
   - Should see list of issues found by agents:
     - Security issues (red badges)
     - Performance issues (yellow badges)
     - Documentation issues (blue badges)
   - Each finding shows: file, line number, severity, agent type, message

5. **Check GitHub**
   - If GitHub token configured, check the actual PR on GitHub
   - Should see a comment posted by Code Butler with formatted findings table

## Visual Indicators of Success

### ✅ Backend Working:
- Server logs show agent execution:
  ```
  [navigator] Cloning repository...
  [reader] Analyzing file...
  [security] Scanning for vulnerabilities...
  [performance] Analyzing performance...
  [documentation] Generating docstring...
  Review session completed successfully
  ```

### ✅ Frontend Working:
- Dashboard shows:
  - Total repositories count
  - Total pull requests count
  - Total findings count
  - Charts/graphs with data
  - Recent activity feed

- Findings screen shows:
  - List of all findings
  - Filterable by severity, agent type, category
  - Clickable to see details
  - Code snippets showing the issue

### ✅ Integration Working:
- Frontend can fetch data from backend
- Progress updates in real-time
- Findings appear in UI after review completes
- No "connection refused" or CORS errors

## What the Product Does (End-to-End)

1. **You connect a GitHub repository** → Code Butler tracks it
2. **A PR is created** → Code Butler automatically detects it (via webhook)
3. **Review starts** → 6 agents analyze the code in parallel
4. **Findings generated** → Security issues, performance problems, missing docs
5. **Posted to GitHub** → Formatted comment appears on the PR
6. **Dashboard updates** → You see metrics, trends, and all findings
7. **Autofix available** → Click to apply fixes, creates new PR with changes

## Demo Scenario

For the hackathon demo, you would:

1. **Show the dashboard** - "Here's Code Butler, our AI code review system"
2. **Add a demo repository** - "Let's connect a repository"
3. **Start a review** - "Watch as 6 AI agents analyze the code"
4. **Show findings** - "Here are security issues, performance problems, and missing documentation"
5. **Show GitHub integration** - "The findings are automatically posted to the PR"
6. **Show autofix** - "We can even automatically fix some issues"

## Success Criteria

✅ **System is working if:**
- Backend server starts without errors
- Frontend loads and displays UI
- Health check returns "healthy"
- Can create repository and PR
- Review starts and completes
- Findings appear in UI
- No crashes or connection errors

❌ **System has issues if:**
- Server won't start (check logs for errors)
- Frontend shows error screen
- Health check fails
- Can't connect frontend to backend
- Reviews don't complete
- Findings don't appear

## Next Steps After Verification

Once you confirm it's working:

1. **Test with real repository** - Use an actual GitHub repo
2. **Configure API keys** - Add GitHub token and Gemini API key for full functionality
3. **Test webhook automation** - Set up GitHub webhook for automatic reviews
4. **Prepare demo** - Practice the demo flow for the hackathon
5. **Record video** - Create 3-minute demo video

## Quick Verification Checklist

- [ ] Backend server starts: `dart run lib/server.dart`
- [ ] Health check works: `curl http://localhost:8080/healthCheck/healthCheck`
- [ ] Frontend loads: `flutter run -d chrome`
- [ ] Can navigate between screens
- [ ] Can create a repository
- [ ] Can create a pull request
- [ ] Can start a review
- [ ] Review completes successfully
- [ ] Findings appear in UI
- [ ] No errors in console/logs

If all these work, **Code Butler is fully operational!** 🎉

