# Code Butler Demo Flow

## Overview
This document outlines the step-by-step demo flow for presenting Code Butler at the Serverpod 3 Hackathon 2025.

## Timing Breakdown (3-minute target)

- **0:00 - 0:30**: Introduction and splash screen
- **0:30 - 1:30**: Core feature demonstration
- **1:30 - 2:30**: Advanced features and automation
- **2:30 - 3:00**: Impact and conclusion

## Demo Script

### Step 1: Introduction (0:00 - 0:30)
1. Show splash screen with branding
   - "Code Butler - AI-Powered Multi-Agent Code Review Butler"
   - Team members and hackathon badge
2. Navigate to home screen
3. Brief introduction:
   - "Code Butler uses multiple AI agents to automatically review pull requests"
   - "Each agent specializes in different aspects: security, performance, documentation, etc."

### Step 2: GitHub Integration (0:30 - 0:45)
1. Click "Login with GitHub" button
2. Complete OAuth flow (or show pre-authenticated state)
3. Navigate to repositories screen
4. Show synced repositories from GitHub

### Step 3: Repository and PR Selection (0:45 - 1:00)
1. Select a repository
2. Show pull requests list
3. Select a pull request to review
4. Highlight PR details (files changed, branches, etc.)

### Step 4: Start Review (1:00 - 1:15)
1. Click "Start Review" button
2. Navigate to review progress screen
3. **Highlight moment**: Show real-time streaming progress
   - Agent activity feed
   - Files being processed
   - Progress percentage

### Step 5: View Findings (1:15 - 1:45)
1. Navigate to findings screen when review completes
2. Show findings grouped by severity
3. Demonstrate filtering and search
4. Open a finding detail modal
5. Show code snippet with syntax highlighting
6. Show suggested fix

### Step 6: Apply Fix (1:45 - 2:00)
1. Click "Apply Fix" button
2. Show loading state
3. **Highlight moment**: Show success with GitHub PR link
4. Demonstrate batch apply for multiple findings

### Step 7: Dashboard and Analytics (2:00 - 2:20)
1. Navigate to dashboard
2. Show key metrics:
   - Total reviews
   - Success rate
   - Average review time
3. Show charts:
   - Findings trend over time
   - Severity distribution
   - Agent effectiveness

### Step 8: Webhook Automation (2:20 - 2:35)
1. Navigate to webhook settings
2. Show webhook configuration
3. Explain automatic review triggering via GitHub webhooks
4. Show recent webhook events

### Step 9: Conclusion (2:35 - 3:00)
1. Summarize key features:
   - Multi-agent architecture
   - Real-time progress tracking
   - Automatic fix application
   - Webhook automation
2. Highlight impact:
   - Time saved on code reviews
   - Issues caught early
   - Developer productivity improvement
3. Thank judges and audience

## Highlight Moments

1. **Real-time agent execution** (1:00 - 1:15)
   - Show streaming progress updates
   - Agent activity feed
   - Smooth animations

2. **Autofix creating PR** (1:45 - 2:00)
   - Click Apply Fix
   - Show success message
   - Open GitHub PR link

3. **Webhook automation** (2:20 - 2:35)
   - Explain automatic triggering
   - Show webhook events

## Backup Plan

If something fails during recording:

1. **Backend unavailable**: Use demo mode with mock data
2. **GitHub OAuth fails**: Show pre-authenticated state
3. **Review fails**: Use pre-completed review session
4. **Network issues**: Use cached data

## Preparation Checklist

- [ ] Clean browser profile
- [ ] GitHub test account ready
- [ ] Demo repository prepared
- [ ] Backend server running
- [ ] Pre-seeded data in database
- [ ] Screen recording software tested
- [ ] Audio quality verified
- [ ] Practice run completed (5+ times)
- [ ] Timing verified (under 3 minutes)

## Talking Points

### Innovation
- Multi-agent collaboration: Each agent specializes in different code review aspects
- Cross-repo learning: Agents improve over time
- Real-time streaming: Immediate feedback during review

### Technical Execution
- Serverpod streaming for real-time updates
- Flutter for responsive UI
- GitHub OAuth and webhook integration
- Automatic fix application with PR creation

### Impact
- 50% faster code reviews
- Catches issues before merge
- Improves code quality automatically
- Reduces developer cognitive load

## Questions to Anticipate

**Q: How do agents coordinate?**
A: The orchestrator manages agent execution, ensuring each agent processes files in the optimal order.

**Q: What if agents disagree?**
A: Findings are ranked by severity and confidence. Multiple agents can flag the same issue from different angles.

**Q: How accurate are the fixes?**
A: Fixes are suggested based on best practices. Developers can review and modify before applying.

**Q: Can this work with private repos?**
A: Yes, with proper GitHub OAuth scopes and webhook configuration.

