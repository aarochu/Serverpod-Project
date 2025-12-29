#!/bin/bash

# Quick start script for Person 1 - Backend Server
# Run this to start the server for integration testing

set -e

echo "🚀 Starting Code Butler Backend Server..."
echo ""

# Check if we're in the right directory
if [ ! -f "lib/server.dart" ]; then
    echo "❌ Error: Must run from code_butler_server directory"
    exit 1
fi

# Check if dependencies are installed
if [ ! -d ".dart_tool" ]; then
    echo "📦 Installing dependencies..."
    dart pub get
fi

# Check if code is generated
if [ ! -d "lib/src/generated" ]; then
    echo "🔧 Generating serverpod code..."
    serverpod generate
fi

# Check if Docker is running (optional)
if command -v docker &> /dev/null; then
    if docker ps &> /dev/null; then
        echo "✅ Docker is running"
    else
        echo "⚠️  Docker is not running. Database may not be available."
    fi
else
    echo "⚠️  Docker not found. Make sure database is accessible."
fi

echo ""
echo "🌐 Starting server on http://localhost:8080"
echo "📊 Health check: http://localhost:8080/healthCheck/healthCheck"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start the server
dart run lib/server.dart

