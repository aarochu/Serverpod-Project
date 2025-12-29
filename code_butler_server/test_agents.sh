#!/bin/bash

# Test script for Code Butler agent pipeline
# This script helps test the multi-agent system locally

set -e

echo "🧪 Code Butler Agent Pipeline Test"
echo "===================================="
echo ""

# Check if server is running
echo "📡 Checking if server is running on localhost:8080..."
if curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "✅ Server is running"
else
    echo "❌ Server is not running. Please start it first:"
    echo "   cd code_butler_server && dart run lib/server.dart"
    exit 1
fi

echo ""
echo "📝 Testing Agent Pipeline"
echo "-------------------------"
echo ""
echo "To test the full pipeline:"
echo ""
echo "1. Create a test repository:"
echo "   curl -X POST http://localhost:8080/repository/createRepository \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -d '{\"name\":\"test-repo\",\"url\":\"https://github.com/owner/test-repo.git\",\"owner\":\"owner\",\"defaultBranch\":\"main\"}'"
echo ""
echo "2. Create a test pull request:"
echo "   curl -X POST http://localhost:8080/pullRequest/createPullRequest \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -d '{\"repositoryId\":1,\"prNumber\":1,\"title\":\"Test PR\",\"baseBranch\":\"main\",\"headBranch\":\"feature\",\"filesChanged\":5}'"
echo ""
echo "3. Start a review:"
echo "   curl -X POST http://localhost:8080/review/startReview \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -d '{\"pullRequestId\":1}'"
echo ""
echo "4. Watch review progress:"
echo "   curl http://localhost:8080/review/getReviewStatus?reviewSessionId=1"
echo ""
echo "5. Get findings:"
echo "   curl http://localhost:8080/review/getFindings?pullRequestId=1"
echo ""
echo "📊 Monitor server logs to see agent execution:"
echo "   The server will log all agent activities as they process files."
echo ""

