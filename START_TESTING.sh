#!/bin/bash

# Start both backend and frontend for integration testing
# Run this script to start the full stack

set -e

echo "🚀 Starting Code Butler Full Stack..."
echo ""

# Check if we're in the right directory
if [ ! -d "code_butler_server" ] || [ ! -d "code_butler_flutter" ]; then
    echo "❌ Error: Must run from project root (Hexathon-Project)"
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed"
    exit 1
fi

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo "❌ Dart is not installed"
    exit 1
fi

echo "📦 Checking dependencies..."

# Install Flutter dependencies
if [ ! -d "code_butler_flutter/.dart_tool" ]; then
    echo "📦 Installing Flutter dependencies..."
    cd code_butler_flutter
    flutter pub get
    cd ..
fi

# Install server dependencies
if [ ! -d "code_butler_server/.dart_tool" ]; then
    echo "📦 Installing server dependencies..."
    cd code_butler_server
    dart pub get
    cd ..
fi

# Generate client code
echo "🔧 Generating client code..."
cd code_butler_server
serverpod generate
cd ..

echo ""
echo "✅ Dependencies ready!"
echo ""
echo "🌐 Starting services..."
echo ""
echo "Terminal 1: Backend Server (http://localhost:8080)"
echo "Terminal 2: Flutter App (http://localhost:XXXX)"
echo ""
echo "Press Ctrl+C to stop"
echo ""

# Start backend in background
echo "Starting backend server..."
cd code_butler_server
dart run lib/server.dart &
BACKEND_PID=$!
cd ..

# Wait a moment for backend to start
sleep 3

# Check if backend started successfully
if ! curl -s http://localhost:8080/healthCheck/healthCheck > /dev/null 2>&1; then
    echo "⚠️  Backend may not have started. Check logs above."
else
    echo "✅ Backend is running on http://localhost:8080"
fi

echo ""
echo "Starting Flutter app..."
cd code_butler_flutter
flutter run -d chrome

# Cleanup on exit
trap "kill $BACKEND_PID 2>/dev/null" EXIT

