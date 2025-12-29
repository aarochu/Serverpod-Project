# Configuration Guide

## API Keys Setup

### 1. GitHub Personal Access Token

1. Go to https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Give it a name: "Code Butler"
4. Select scopes:
   - `repo` (full control of private repositories)
   - `read:org` (read org membership)
   - `read:user` (read user profile)
5. Generate token and copy it
6. Edit `config/development.yaml`:
   ```yaml
   githubToken: YOUR_ACTUAL_TOKEN_HERE
   ```

### 2. Gemini API Key

1. Get your Gemini API key from the hackathon signup email
2. Or visit: https://makersuite.google.com/app/apikey
3. Edit `config/development.yaml`:
   ```yaml
   geminiApiKey: YOUR_ACTUAL_API_KEY_HERE
   ```

## Agent Configuration

The following settings are available in `config/development.yaml`:

```yaml
agents:
  maxFilesToProcess: 100        # Maximum files to analyze per review
  fileTimeoutSeconds: 30         # Timeout per file analysis
  concurrentTaskLimit: 5        # Max concurrent file processing tasks
```

Adjust these based on your system resources and repository sizes.

## Security Note

⚠️ **Never commit API keys to git!** 

The `config/development.yaml` file should be in `.gitignore` or use environment variables in production.

