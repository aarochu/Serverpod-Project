#!/bin/bash

# Start Code Butler Demo - Full Stack
# This script starts both backend and frontend for the demo

set -e

echo "🚀 Starting Code Butler Demo..."
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -d "code_butler_server" ] || [ ! -d "code_butler_flutter" ]; then
    echo -e "${RED}❌ Error: Must run from project root (Hexathon-Project)${NC}"
    exit 1
fi

# Step 1: Check dependencies
echo -e "${YELLOW}📦 Checking dependencies...${NC}"
cd code_butler_server
if [ ! -d ".dart_tool" ]; then
    echo "Installing server dependencies..."
    dart pub get
fi
cd ..

cd code_butler_flutter
if [ ! -d ".dart_tool" ]; then
    echo "Installing Flutter dependencies..."
    flutter pub get
fi
cd ..

# Step 2: Generate client code (with warnings, but continue)
echo -e "${YELLOW}🔧 Generating client code...${NC}"
cd code_butler_server
export PATH="$PATH:$HOME/.pub-cache/bin"
serverpod generate 2>&1 | grep -E "✓|✗" || echo "Generation completed (warnings may appear)"
cd ..

# Step 3: Start backend
echo -e "${YELLOW}🌐 Starting backend server...${NC}"
cd code_butler_server
dart run lib/server.dart &
BACKEND_PID=$!
cd ..

# Wait for backend to start
echo "Waiting for backend to start..."
sleep 5

# Check if backend is running
if curl -s http://localhost:8080/healthCheck/healthCheck > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend is running on http://localhost:8080${NC}"
else
    echo -e "${RED}⚠️  Backend may not have started. Check logs above.${NC}"
    echo "You can still try starting the frontend manually."
fi

# Step 4: Start frontend
echo -e "${YELLOW}📱 Starting Flutter frontend...${NC}"
echo ""
echo -e "${GREEN}✅ Starting services...${NC}"
echo "Backend: http://localhost:8080"
echo "Frontend: Will open in Chrome"
echo ""
echo "Press Ctrl+C to stop both services"
echo ""

cd code_butler_flutter
flutter run -d chrome

# Cleanup on exit
trap "kill $BACKEND_PID 2>/dev/null; exit" INT TERM

