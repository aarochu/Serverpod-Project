# Code Butler Deployment Guide

## Serverpod Cloud Deployment

### Prerequisites

1. Serverpod Cloud account with credits
2. Serverpod CLI installed: `dart pub global activate serverpod_cli`
3. Environment variables prepared:
   - `GITHUB_TOKEN` - GitHub personal access token
   - `GEMINI_API_KEY` - Google Gemini API key
   - `WEBHOOK_SECRET` - GitHub webhook secret
   - `FLUTTER_APP_DOMAIN` - Flutter web app domain

### Step 1: Authenticate with Serverpod Cloud

```bash
serverpod cloud login
```

Follow the prompts to authenticate with your Serverpod Cloud account.

### Step 2: Create Project in Serverpod Cloud

1. Log in to Serverpod Cloud dashboard
2. Create a new project: "code-butler"
3. Note the project ID and domain

### Step 3: Configure Environment Variables

In Serverpod Cloud dashboard, go to your project settings and add:

```
GITHUB_TOKEN=your_github_token_here
GEMINI_API_KEY=your_gemini_api_key_here
WEBHOOK_SECRET=your_webhook_secret_here
FLUTTER_APP_DOMAIN=https://your-flutter-app.web.app
DATABASE_HOST=your_db_host
DATABASE_PORT=5432
DATABASE_NAME=code_butler
DATABASE_USERNAME=your_db_user
DATABASE_PASSWORD=your_db_password
PUBLIC_HOST=your-domain.serverpod.cloud
PRIVATE_HOST=your-private-host.serverpod.cloud
```

### Step 4: Deploy to Serverpod Cloud

```bash
cd code_butler_server
serverpod cloud deploy
```

This will:
- Build the server
- Upload to Serverpod Cloud
- Apply database migrations
- Start the server

### Step 5: Verify Deployment

1. Check health endpoint:
   ```bash
   curl https://your-domain.serverpod.cloud/healthCheck/healthCheck
   ```

2. Verify database connection in logs

3. Test a simple endpoint:
   ```bash
   curl https://your-domain.serverpod.cloud/repository/listRepositories
   ```

## Database Migration Strategy

### Before Migration

1. **Backup Database**
   ```bash
   # Export current database
   pg_dump -h localhost -U postgres code_butler > backup_$(date +%Y%m%d).sql
   ```

2. **Test Migration Locally**
   ```bash
   cd code_butler_server
   serverpod create-migration
   serverpod apply-migrations --apply-migrations
   ```

3. **Verify Data Integrity**
   - Check all tables exist
   - Verify data is intact
   - Test critical queries

### Production Migration

1. **Create Migration**
   ```bash
   serverpod create-migration
   ```

2. **Review Migration Files**
   - Check `migrations/` directory
   - Verify SQL changes are correct

3. **Apply Migration**
   ```bash
   serverpod cloud deploy --apply-migrations
   ```

### Rollback Plan

If migration fails:

1. **Stop Deployment**
   - Cancel deployment in Serverpod Cloud dashboard

2. **Restore Database**
   ```bash
   # Restore from backup
   psql -h your-db-host -U your-db-user code_butler < backup_YYYYMMDD.sql
   ```

3. **Revert Code**
   ```bash
   git revert HEAD
   serverpod cloud deploy
   ```

## Health Check Verification

After deployment, verify:

1. **Database Connectivity**
   ```bash
   curl https://your-domain.serverpod.cloud/healthCheck/healthCheck
   ```
   Should return `{"status": "healthy", ...}`

2. **GitHub API Access**
   - Check logs for authentication success
   - Test repository endpoint

3. **Gemini API Access**
   - Check logs for API key validation
   - Test documentation generation

4. **Webhook Endpoint**
   - Configure GitHub webhook pointing to:
     `https://your-domain.serverpod.cloud/webhook/handlePullRequest`
   - Test with a test PR

## Monitoring and Logging

### Logs

Access logs in Serverpod Cloud dashboard:
- Application logs
- Error logs
- Performance logs

### Monitoring

1. **Health Check Endpoint**
   - Monitor `/healthCheck/healthCheck`
   - Set up alerts for unhealthy status

2. **Metrics Endpoint**
   - Monitor `/metrics/getReviewStats`
   - Track review completion rates

3. **Error Tracking**
   - Monitor error logs
   - Set up alerts for critical errors

## Rollback Procedures

### If Deployment Fails

1. **Immediate Actions**
   - Check Serverpod Cloud dashboard for errors
   - Review application logs
   - Check database connection

2. **Rollback Steps**
   ```bash
   # Revert to previous version
   git checkout previous-stable-tag
   serverpod cloud deploy
   ```

3. **Database Rollback**
   - Restore from backup (see Database Migration Strategy)

### If Application Errors Occur

1. **Check Logs**
   - Review error logs in dashboard
   - Check for rate limiting
   - Verify API keys are valid

2. **Restart Service**
   - Use Serverpod Cloud dashboard to restart
   - Or redeploy: `serverpod cloud deploy`

3. **Scale Resources**
   - Increase database connections if needed
   - Scale server instances if under load

## Post-Deployment Checklist

- [ ] Health check endpoint returns healthy
- [ ] Database migrations applied successfully
- [ ] Environment variables configured correctly
- [ ] GitHub webhook configured and tested
- [ ] All endpoints responding correctly
- [ ] Logs showing no critical errors
- [ ] Monitoring alerts configured
- [ ] Backup strategy in place

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Verify database credentials
   - Check firewall rules
   - Ensure database is accessible

2. **Environment Variables Not Loading**
   - Check Serverpod Cloud dashboard
   - Verify variable names match `production.yaml`
   - Restart service after changes

3. **CORS Errors**
   - Verify `FLUTTER_APP_DOMAIN` is correct
   - Check CORS configuration in `production.yaml`

4. **Rate Limiting**
   - Check rate limit settings
   - Verify client IP is not blocked
   - Review request patterns

## Support

For issues:
1. Check Serverpod Cloud documentation
2. Review application logs
3. Contact Serverpod support if needed

