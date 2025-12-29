#!/bin/bash

# Script to create demo repository with intentional issues
# Run this script to create a local demo repository

set -e

DEMO_REPO_DIR="../demo_repo"
REPO_NAME="code-butler-demo"

echo "Creating demo repository..."

# Create directory
mkdir -p "$DEMO_REPO_DIR"
cd "$DEMO_REPO_DIR"

# Initialize git repo
git init
git config user.name "Code Butler Demo"
git config user.email "demo@codebutler.com"

# Create main.dart with security issues
cat > lib/main.dart << 'EOF'
import 'dart:io';

// Security issue: Hardcoded API key
final String apiKey = "sk-live-1234567890abcdef";

void main() {
  // Performance issue: Inefficient string concatenation
  String result = "";
  for (int i = 0; i < 1000; i++) {
    result += "value $i";
  }
  
  // Security issue: SQL injection vulnerability
  String userInput = Platform.environment['USER_INPUT'] ?? '';
  String query = "SELECT * FROM users WHERE name = '" + userInput + "'";
  print(query);
  
  // Performance issue: Nested loops
  for (int i = 0; i < 100; i++) {
    for (int j = 0; j < 100; j++) {
      for (int k = 0; k < 100; k++) {
        print("Processing $i-$j-$k");
      }
    }
  }
}

// Missing documentation
class DataProcessor {
  // Missing const constructor
  DataProcessor({required this.value});
  
  final int value;
  
  // Undocumented method
  String processData(String input) {
    return input.toUpperCase();
  }
}
EOF

# Create security_vulnerable.dart
cat > lib/security_vulnerable.dart << 'EOF'
import 'dart:io';

// Security issue: Unsafe eval usage
void executeUserCode(String code) {
  // WARNING: This is unsafe
  // eval(code); // Commented but shows the pattern
  print("Would execute: $code");
}

// Security issue: Hardcoded password
class DatabaseConfig {
  final String password = "admin123";
  final String connectionString = "postgresql://user:password@localhost/db";
}
EOF

# Create performance_issues.dart
cat > lib/performance_issues.dart << 'EOF'
// Performance issue: Missing const constructors
class Widget {
  Widget({required this.title});
  final String title;
}

// Performance issue: Synchronous file operations
import 'dart:io';

Future<String> readFileSync(String path) async {
  // Should use async version
  final file = File(path);
  return file.readAsStringSync(); // Blocking operation
}

// Performance issue: Inefficient data structure
List<String> processLargeList(List<String> items) {
  List<String> result = [];
  for (var item in items) {
    result.add(item.toUpperCase()); // Should use map
  }
  return result;
}
EOF

# Create undocumented.py
cat > python_module.py << 'EOF'
# Missing documentation for module

# Undocumented function
def calculate_total(items):
    total = 0
    for item in items:
        total += item.price
    return total

# Undocumented class
class OrderProcessor:
    def __init__(self, order_id):
        self.order_id = order_id
    
    # Missing docstring
    def process_order(self, items):
        return calculate_total(items)

# Security issue: SQL injection
def get_user_data(username):
    query = f"SELECT * FROM users WHERE name = '{username}'"
    # Should use parameterized queries
    return query
EOF

# Create pubspec.yaml
cat > pubspec.yaml << 'EOF'
name: code_butler_demo
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'
EOF

# Create README.md
cat > README.md << 'EOF'
# Code Butler Demo Repository

This repository contains intentional code issues for demonstration purposes:

- Security vulnerabilities (hardcoded secrets, SQL injection)
- Performance problems (nested loops, inefficient operations)
- Missing documentation
- Code quality issues

Use this repository to test Code Butler's multi-agent review system.
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
.dart_tool/
build/
*.iml
.idea/
.vscode/
EOF

# Initial commit
git add .
git commit -m "Initial commit with intentional issues for Code Butler demo"

echo "Demo repository created at: $DEMO_REPO_DIR"
echo ""
echo "To push to GitHub:"
echo "1. Create a new repository on GitHub"
echo "2. Run: git remote add origin https://github.com/your-username/code-butler-demo.git"
echo "3. Run: git push -u origin main"

