# Plan to Get Code Butler Working - Full Demo

## Goal
Get Code Butler fully operational so you can see the complete demo:
- Backend server running
- Frontend UI working
- Full workflow: Create repo → Create PR → Start review → See findings → View dashboard

## Step-by-Step Execution Plan

### Phase 1: Fix Code Generation (Critical)
**Problem**: `serverpod generate` fails because endpoints reference protocol classes that don't exist yet.

**Solution**: 
1. Check if we can generate protocol classes first (from .spy.yaml files)
2. If not, temporarily comment out endpoint type annotations
3. Generate protocol classes
4. Restore endpoint code
5. Generate endpoints

### Phase 2: Fix Server Startup
**Problem**: Server may have configuration or dependency issues.

**Solution**:
1. Verify all dependencies installed
2. Check database connection
3. Fix any configuration errors
4. Test server startup

### Phase 3: Start Backend
**Goal**: Server running on localhost:8080

**Steps**:
1. Start database (Docker or verify connection)
2. Apply migrations
3. Start server
4. Verify health check works

### Phase 4: Start Frontend
**Goal**: Flutter app running in browser

**Steps**:
1. Verify Flutter dependencies
2. Check client code is generated
3. Start Flutter app
4. Verify UI loads

### Phase 5: Test Full Workflow
**Goal**: Complete end-to-end demo

**Steps**:
1. Create a test repository
2. Create a test pull request
3. Start a review
4. Watch progress
5. View findings
6. Check dashboard

## Execution Order

1. ✅ Fix code generation issues
2. ✅ Start database
3. ✅ Generate protocol code
4. ✅ Start backend server
5. ✅ Verify health check
6. ✅ Start frontend
7. ✅ Test workflow
8. ✅ Verify demo works

Let's execute this plan now!

