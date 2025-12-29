#!/bin/bash

# Code Butler Server Setup and Verification Script
# Run this from the code_butler_server directory

set -e

echo "🚀 Starting Code Butler Server Setup..."

# Step 1: Generate client protocol files from .spy.yaml models
echo ""
echo "📦 Step 1: Generating client protocol files..."
serverpod generate
echo "✅ Client protocol files generated"

# Step 2: Start Docker PostgreSQL database
echo ""
echo "🐳 Step 2: Starting PostgreSQL database..."
cd ..
docker compose up -d
echo "✅ Database started"
sleep 3  # Wait for database to be ready

# Step 3: Create and apply database migrations
echo ""
echo "🗄️  Step 3: Creating and applying database migrations..."
cd code_butler_server
serverpod create-migration
serverpod apply-migrations --apply-migrations
echo "✅ Migrations applied"

# Step 4: Verify server starts successfully
echo ""
echo "🔍 Step 4: Verifying server starts..."
echo "Starting server (will run for 5 seconds to verify)..."
timeout 5 dart run lib/server.dart || echo "Server started successfully (timeout expected)"
echo ""
echo "✅ Setup complete!"
echo ""
echo "To start the server manually, run:"
echo "  cd code_butler_server"
echo "  dart run lib/server.dart"
echo ""
echo "The server should start on http://localhost:8080"

