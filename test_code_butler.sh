#!/bin/bash

# Code Butler Feature Test Script
# This script tests the Code Butler API endpoints

BASE_URL="http://localhost:8080"
echo "🧪 Testing Code Butler Features"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}1. Testing Health Check${NC}"
curl -s "$BASE_URL/healthCheck/healthCheck" | python3 -m json.tool 2>/dev/null || curl -s "$BASE_URL/healthCheck/healthCheck"
echo ""
echo ""

echo -e "${BLUE}2. Creating a Test Repository${NC}"
REPO_RESPONSE=$(curl -s -X POST "$BASE_URL/repository/createRepository" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "test-repo",
    "url": "https://github.com/testuser/test-repo.git",
    "owner": "testuser",
    "defaultBranch": "main"
  }')
echo "$REPO_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$REPO_RESPONSE"
REPO_ID=$(echo "$REPO_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "")
echo ""
if [ -z "$REPO_ID" ]; then
  echo -e "${YELLOW}⚠️  Could not extract repository ID. Continuing anyway...${NC}"
  REPO_ID=1
fi
echo ""

echo -e "${BLUE}3. Listing All Repositories${NC}"
curl -s "$BASE_URL/repository/listRepositories" | python3 -m json.tool 2>/dev/null || curl -s "$BASE_URL/repository/listRepositories"
echo ""
echo ""

echo -e "${BLUE}4. Creating a Test Pull Request${NC}"
PR_RESPONSE=$(curl -s -X POST "$BASE_URL/pullRequest/createPullRequest" \
  -H "Content-Type: application/json" \
  -d "{
    \"repositoryId\": $REPO_ID,
    \"prNumber\": 1,
    \"title\": \"Test PR for Code Butler\",
    \"baseBranch\": \"main\",
    \"headBranch\": \"feature-branch\",
    \"filesChanged\": 5
  }")
echo "$PR_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$PR_RESPONSE"
PR_ID=$(echo "$PR_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "")
echo ""
if [ -z "$PR_ID" ]; then
  echo -e "${YELLOW}⚠️  Could not extract PR ID. Continuing anyway...${NC}"
  PR_ID=1
fi
echo ""

echo -e "${BLUE}5. Starting a Code Review${NC}"
REVIEW_RESPONSE=$(curl -s -X POST "$BASE_URL/review/startReview" \
  -H "Content-Type: application/json" \
  -d "{
    \"pullRequestId\": $PR_ID
  }")
echo "$REVIEW_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$REVIEW_RESPONSE"
REVIEW_SESSION_ID=$(echo "$REVIEW_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "")
echo ""
if [ -z "$REVIEW_SESSION_ID" ]; then
  echo -e "${YELLOW}⚠️  Could not extract review session ID. Continuing anyway...${NC}"
  REVIEW_SESSION_ID=1
fi
echo ""

echo -e "${BLUE}6. Checking Review Status${NC}"
sleep 2
curl -s "$BASE_URL/review/getReviewStatus?reviewSessionId=$REVIEW_SESSION_ID" | python3 -m json.tool 2>/dev/null || curl -s "$BASE_URL/review/getReviewStatus?reviewSessionId=$REVIEW_SESSION_ID"
echo ""
echo ""

echo -e "${BLUE}7. Getting Findings for PR${NC}"
curl -s "$BASE_URL/review/getFindings?pullRequestId=$PR_ID" | python3 -m json.tool 2>/dev/null || curl -s "$BASE_URL/review/getFindings?pullRequestId=$PR_ID"
echo ""
echo ""

echo -e "${GREEN}✅ Test Complete!${NC}"
echo ""
echo "Note: The review runs asynchronously. Check the status again in a few seconds."
echo "Review Session ID: $REVIEW_SESSION_ID"
echo "Pull Request ID: $PR_ID"

