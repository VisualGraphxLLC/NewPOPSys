# Runbook Templates

## Overview
This document provides comprehensive operational runbook templates for PopSystem, enabling consistent and reliable execution of critical operations, incident response, and maintenance procedures. These templates ensure operational excellence and minimize downtime.

## Runbook Philosophy

### Core Principles

**Clarity and Precision:**
- Step-by-step instructions that anyone can follow
- No assumptions about prior knowledge
- Clear success criteria for each step
- Explicit rollback procedures

**Reliability:**
- Tested procedures with verified outcomes
- Regular review and updates
- Version control for all runbooks
- Post-execution validation

**Safety:**
- Pre-flight checks before execution
- Rollback plans for all changes
- Backup verification before destructive operations
- Multiple approval gates for high-risk procedures

**Continuous Improvement:**
- Post-incident reviews inform updates
- Automation opportunities identified
- Lessons learned documented
- Regular testing and drills

## Deployment Runbooks

### Standard Application Deployment

**Purpose:** Deploy new application version to production environment

**Prerequisites:**
- [ ] Code reviewed and merged to main branch
- [ ] CI/CD pipeline tests passed (100% success)
- [ ] Staging deployment successful and validated
- [ ] Release notes prepared and approved
- [ ] Database migrations tested in staging
- [ ] Rollback plan prepared and tested
- [ ] On-call engineer identified
- [ ] Customer notification sent (if user-facing changes)
- [ ] Change management ticket approved

**Risk Level:** Medium
**Estimated Duration:** 30-60 minutes
**Required Approvals:** Engineering Manager, Product Manager (for major releases)

**Pre-Deployment Checklist:**
```
[ ] Verify current production health (all systems green)
[ ] Backup database (verify backup completion)
[ ] Take snapshot of current deployment configuration
[ ] Verify rollback procedure is ready
[ ] Notify support team of deployment window
[ ] Enable maintenance mode (if required)
[ ] Verify all dependencies are available
```

**Deployment Steps:**

**1. Pre-Deployment Validation**
```bash
# Verify production status
kubectl get pods -n production
kubectl get services -n production

# Check database connectivity
psql -h production-db.example.com -U app_user -c "SELECT 1"

# Verify application health
curl https://api.popsystem.com/health
```

**Expected Output:** All services running, database accessible, health check returns 200 OK

**2. Database Migration (if applicable)**
```bash
# Backup database
pg_dump -h production-db.example.com -U app_user popsystem_prod > \
  backup_$(date +%Y%m%d_%H%M%S).sql

# Verify backup
ls -lh backup_*.sql

# Run migrations in transaction mode
NODE_ENV=production npm run migrate:up

# Verify migration success
NODE_ENV=production npm run migrate:status
```

**Rollback for this step:**
```bash
NODE_ENV=production npm run migrate:down
psql -h production-db.example.com -U app_user popsystem_prod < backup_YYYYMMDD_HHMMSS.sql
```

**3. Deploy Application**
```bash
# Tag the release
git tag -a v2.5.0 -m "Release v2.5.0"
git push origin v2.5.0

# Trigger deployment
kubectl set image deployment/popsystem-api \
  popsystem-api=popsystem/api:v2.5.0 \
  -n production

# Watch rollout
kubectl rollout status deployment/popsystem-api -n production
```

**Expected Output:** "deployment 'popsystem-api' successfully rolled out"

**4. Post-Deployment Validation**
```bash
# Verify pods are running
kubectl get pods -n production | grep popsystem-api

# Check application logs
kubectl logs -f deployment/popsystem-api -n production --tail=50

# Health check
curl https://api.popsystem.com/health
curl https://api.popsystem.com/version

# Smoke tests
npm run test:smoke:production
```

**Expected Output:** All pods running, no errors in logs, health check 200 OK, version shows v2.5.0

**5. Monitoring Validation**
```
[ ] Check error rates in Datadog (should be normal)
[ ] Verify response times (p95 < 500ms)
[ ] Check database connection pool
[ ] Verify background jobs processing
[ ] Review Sentry for new errors
[ ] Confirm user sessions active
```

**6. Gradual Traffic Ramp (for major releases)**
```bash
# Route 10% of traffic to new version
kubectl set traffic popsystem-api --revision=latest --percent=10

# Monitor for 15 minutes

# If stable, increase to 50%
kubectl set traffic popsystem-api --revision=latest --percent=50

# Monitor for 15 minutes

# If stable, route 100%
kubectl set traffic popsystem-api --revision=latest --percent=100
```

**Post-Deployment Tasks:**
```
[ ] Disable maintenance mode (if enabled)
[ ] Update status page (deployment complete)
[ ] Notify support team deployment successful
[ ] Post in Slack #engineering channel
[ ] Monitor for 2 hours post-deployment
[ ] Update deployment log
[ ] Close change management ticket
```

**Rollback Procedure:**

**Trigger Criteria:**
- Error rate >5% above baseline
- P95 response time >2x baseline
- Critical functionality broken
- Database issues detected
- Multiple customer complaints

**Rollback Steps:**
```bash
# Immediately rollback deployment
kubectl rollout undo deployment/popsystem-api -n production

# Verify rollback
kubectl rollout status deployment/popsystem-api -n production

# Rollback database migrations if needed
NODE_ENV=production npm run migrate:down

# Verify application health
curl https://api.popsystem.com/health

# Notify stakeholders
# Post-mortem scheduled within 24 hours
```

**Post-Rollback:**
- Document reason for rollback
- Schedule post-mortem
- Update deployment log
- Notify stakeholders
- Fix issues in staging
- Reschedule deployment

**Success Criteria:**
- [ ] Application version updated successfully
- [ ] Database migrations applied
- [ ] All services healthy and responding
- [ ] Error rates within normal range
- [ ] Response times within SLA
- [ ] No increase in support tickets
- [ ] Monitoring dashboards green

---

### Database Migration Deployment

**Purpose:** Apply database schema changes to production

**Prerequisites:**
- [ ] Migration scripts tested in development
- [ ] Migration scripts tested in staging
- [ ] Performance impact assessed
- [ ] Rollback migration prepared
- [ ] Database backup verified
- [ ] Downtime approval (if required)
- [ ] DBA review completed (for complex migrations)

**Risk Level:** High
**Estimated Duration:** 15-90 minutes (depends on migration complexity)
**Required Approvals:** Engineering Manager, DBA (for large migrations)

**Migration Types:**

**Type 1: Non-Blocking Migrations (Zero Downtime)**
- Adding nullable columns
- Adding indexes (concurrently)
- Creating new tables
- Adding columns with defaults (PostgreSQL 11+)

**Type 2: Potentially Blocking Migrations (Brief Locks)**
- Adding NOT NULL constraints
- Modifying column types
- Renaming columns
- Adding foreign keys

**Type 3: Blocking Migrations (Downtime Required)**
- Large table modifications
- Adding indexes on large tables (without CONCURRENTLY)
- Complex data transformations

**Execution Steps:**

**1. Pre-Migration Backup**
```bash
# Full database backup
pg_dump -h production-db.example.com \
  -U app_user \
  -Fc \
  popsystem_prod > backup_pre_migration_$(date +%Y%m%d_%H%M%S).dump

# Verify backup
pg_restore --list backup_pre_migration_*.dump | head -20

# Upload to S3 for redundancy
aws s3 cp backup_pre_migration_*.dump s3://popsystem-backups/migrations/
```

**2. Test Migration in Staging-Like Environment**
```bash
# Restore production backup to staging
pg_restore -h staging-db.example.com \
  -U app_user \
  -d popsystem_staging \
  -c \
  backup_pre_migration_*.dump

# Run migration in staging
NODE_ENV=staging npm run migrate:up

# Verify data integrity
npm run test:integration
```

**3. Execute Production Migration**
```bash
# Set migration lock to prevent concurrent migrations
psql -h production-db.example.com -U app_user -d popsystem_prod \
  -c "SELECT pg_advisory_lock(123456789)"

# Run migration
NODE_ENV=production npm run migrate:up

# Verify migration
NODE_ENV=production npm run migrate:status

# Release lock
psql -h production-db.example.com -U app_user -d popsystem_prod \
  -c "SELECT pg_advisory_unlock(123456789)"
```

**4. Validation Queries**
```sql
-- Verify new columns exist
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'campaigns'
  AND column_name = 'new_column';

-- Check row counts
SELECT COUNT(*) FROM campaigns;

-- Validate data integrity
SELECT COUNT(*) FROM campaigns WHERE new_column IS NULL;

-- Verify indexes
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'campaigns';
```

**Rollback Procedure:**
```bash
# Run down migration
NODE_ENV=production npm run migrate:down

# OR restore from backup if down migration fails
pg_restore -h production-db.example.com \
  -U app_user \
  -d popsystem_prod \
  -c \
  backup_pre_migration_*.dump

# Verify rollback
psql -h production-db.example.com -U app_user -d popsystem_prod \
  -c "\d campaigns"
```

**Success Criteria:**
- [ ] Migration completed without errors
- [ ] Data integrity verified
- [ ] Application functions normally
- [ ] No blocking queries remaining
- [ ] Performance within acceptable range
- [ ] Rollback tested and ready if needed

---

### Blue-Green Deployment

**Purpose:** Zero-downtime deployment using parallel environments

**Prerequisites:**
- [ ] Blue environment (current production) healthy
- [ ] Green environment (new version) provisioned
- [ ] Load balancer configured
- [ ] Database migrations backward compatible
- [ ] Health checks passing on green
- [ ] Rollback plan ready

**Risk Level:** Low
**Estimated Duration:** 30-45 minutes
**Required Approvals:** Engineering Manager

**Deployment Steps:**

**1. Prepare Green Environment**
```bash
# Deploy to green environment
kubectl apply -f k8s/green-deployment.yaml

# Verify green pods running
kubectl get pods -l environment=green -n production

# Run health checks on green
curl https://green.popsystem.com/health
```

**2. Smoke Test Green Environment**
```bash
# Run automated smoke tests
npm run test:smoke -- --env=green

# Manual verification
# - Test login
# - Create test campaign
# - Verify reporting
# - Check integrations
```

**3. Switch Traffic to Green**
```bash
# Route 10% traffic to green
kubectl patch service popsystem-api -p \
  '{"spec":{"selector":{"environment":"green","traffic":"10"}}}'

# Monitor for 10 minutes
watch -n 5 'kubectl top pods -l environment=green'

# If stable, route 50%
kubectl patch service popsystem-api -p \
  '{"spec":{"selector":{"environment":"green","traffic":"50"}}}'

# Monitor for 10 minutes

# Route 100% to green
kubectl patch service popsystem-api -p \
  '{"spec":{"selector":{"environment":"green"}}}'
```

**4. Monitor and Validate**
```
[ ] Error rates normal
[ ] Response times acceptable
[ ] User sessions active
[ ] Background jobs processing
[ ] No increase in support tickets
```

**5. Decommission Blue Environment**
```bash
# Wait 24 hours before decommissioning blue
# Keep blue as rollback option

# After 24 hours, scale down blue
kubectl scale deployment popsystem-api-blue --replicas=0

# After 7 days, delete blue deployment
kubectl delete deployment popsystem-api-blue
```

**Rollback Procedure:**
```bash
# Immediately switch traffic back to blue
kubectl patch service popsystem-api -p \
  '{"spec":{"selector":{"environment":"blue"}}}'

# Verify blue is healthy
curl https://api.popsystem.com/health

# Scale up blue if needed
kubectl scale deployment popsystem-api-blue --replicas=10
```

---

## Incident Response Runbooks

### P1 Incident: Production Outage

**Severity:** Critical (P1)
**Definition:** Complete service outage, core functionality unavailable to all users

**Response Time:** 15 minutes
**Resolution Target:** 2 hours
**Communication Frequency:** Every 30 minutes

**Incident Commander Checklist:**

**Immediate Actions (First 15 minutes):**
```
[ ] Acknowledge incident in PagerDuty
[ ] Create incident channel in Slack: #incident-YYYY-MM-DD-description
[ ] Assign roles:
    - Incident Commander (IC)
    - Technical Lead (engineering investigation)
    - Communications Lead (customer updates)
    - Scribe (timeline documentation)
[ ] Post initial status update
[ ] Escalate to on-call engineers
[ ] Notify executive team (if >1 hour estimated downtime)
```

**Investigation Steps:**

**1. Gather Information**
```bash
# Check system health
curl https://api.popsystem.com/health

# Check service status
kubectl get pods -n production
kubectl get services -n production

# Check recent deployments
kubectl rollout history deployment/popsystem-api -n production

# Check database connectivity
psql -h production-db.example.com -U app_user -c "SELECT 1"

# Review error logs (last 30 minutes)
kubectl logs -n production -l app=popsystem-api \
  --since=30m | grep ERROR

# Check monitoring dashboards
# - Datadog: System overview
# - Sentry: Error tracking
# - AWS CloudWatch: Infrastructure
```

**2. Identify Root Cause**
```
Common Causes to Check:
[ ] Recent deployment issue
[ ] Database connection pool exhausted
[ ] Third-party service outage (AWS, Stripe, etc.)
[ ] DDoS or traffic spike
[ ] Disk space full
[ ] Memory/CPU exhaustion
[ ] Network connectivity issue
[ ] Certificate expiration
[ ] Configuration error
```

**3. Implement Fix**

**If recent deployment caused issue:**
```bash
# Rollback deployment
kubectl rollout undo deployment/popsystem-api -n production

# Verify rollback
kubectl rollout status deployment/popsystem-api -n production
curl https://api.popsystem.com/health
```

**If database issue:**
```bash
# Check connections
psql -h production-db.example.com -U app_user -c \
  "SELECT count(*) FROM pg_stat_activity"

# Kill long-running queries if needed
psql -h production-db.example.com -U app_user -c \
  "SELECT pg_terminate_backend(pid)
   FROM pg_stat_activity
   WHERE state = 'active'
     AND query_start < NOW() - INTERVAL '5 minutes'"

# Restart connection pool
kubectl rollout restart deployment/popsystem-api -n production
```

**If infrastructure issue:**
```bash
# Scale up pods
kubectl scale deployment/popsystem-api --replicas=20 -n production

# Check node health
kubectl get nodes
kubectl describe node <node-name>

# Add emergency capacity (if needed)
# Manually add nodes via AWS console or CLI
```

**4. Verify Resolution**
```bash
# Health check
curl https://api.popsystem.com/health

# Test core functionality
npm run test:smoke:production

# Monitor error rates
# Check Datadog dashboard for 10 minutes

# Verify user activity resuming
# Check active sessions in database
```

**Communication Templates:**

**Initial Communication (within 15 min):**
```
Subject: [INCIDENT] PopSystem Platform Experiencing Issues

We are aware that PopSystem is currently experiencing issues and users
may be unable to access the platform. Our engineering team is actively
investigating the issue.

Status: Investigating
Started: 2025-12-21 14:30 UTC
Next Update: 15:00 UTC (30 minutes)

We apologize for the inconvenience and will provide updates every 30 minutes.

Status Page: https://status.popsystem.com
```

**Update Communication (every 30 min):**
```
Subject: [UPDATE] PopSystem Platform Issues

Update on ongoing platform issues:

Root Cause: [Brief description]
Current Status: [Implementing fix / Testing solution / Monitoring]
Estimated Resolution: [Time or "investigating"]
Next Update: [30 minutes]

What we're doing:
- [Action 1]
- [Action 2]

Thank you for your patience.
```

**Resolution Communication:**
```
Subject: [RESOLVED] PopSystem Platform Restored

The platform issue has been resolved. All services are now operational.

Incident Summary:
- Start Time: 2025-12-21 14:30 UTC
- End Time: 2025-12-21 16:15 UTC
- Duration: 1 hour 45 minutes
- Root Cause: [Description]
- Resolution: [Description]

We sincerely apologize for the disruption to your operations. A full
post-incident report will be published within 48 hours.

If you continue to experience any issues, please contact support.
```

**Post-Incident Activities:**

**Within 24 Hours:**
```
[ ] Update incident timeline with all actions taken
[ ] Document root cause analysis
[ ] Identify action items to prevent recurrence
[ ] Schedule post-incident review meeting
[ ] Update runbook with lessons learned
```

**Within 48 Hours:**
```
[ ] Publish post-incident report
[ ] Customer communication (summary and apology)
[ ] Create tickets for prevention action items
[ ] Update monitoring and alerting if gaps identified
```

**Post-Incident Report Template:**
```markdown
# Incident Report: [Brief Description]

**Incident ID:** INC-2025-001
**Date:** 2025-12-21
**Severity:** P1
**Duration:** 1 hour 45 minutes
**Impact:** All users unable to access platform

## Summary
Brief description of what happened and impact.

## Timeline (all times UTC)
- 14:30 - First alert received
- 14:32 - Incident declared, team assembled
- 14:45 - Root cause identified
- 15:00 - Fix implemented
- 15:30 - Verification complete
- 16:15 - Incident resolved

## Root Cause
Detailed explanation of what caused the incident.

## Resolution
How the incident was resolved.

## Impact
- Users affected: All users (approximately 5,000)
- Duration: 1 hour 45 minutes
- Revenue impact: Estimated $X
- Data loss: None

## What Went Well
- Quick root cause identification
- Effective communication
- Successful rollback procedure

## What Went Wrong
- Late detection (10 minutes before alert)
- Incomplete rollback testing
- Manual intervention required

## Action Items
1. [Action item 1] - Owner: [Name] - Due: [Date]
2. [Action item 2] - Owner: [Name] - Due: [Date]
3. [Action item 3] - Owner: [Name] - Due: [Date]

## Lessons Learned
Key takeaways to prevent future incidents.
```

---

### P2 Incident: Degraded Performance

**Severity:** High (P2)
**Definition:** Significant performance degradation, elevated error rates, or major feature unavailable

**Response Time:** 1 hour
**Resolution Target:** 4 hours
**Communication Frequency:** Every 2 hours

**Investigation Steps:**

**1. Triage and Assess**
```bash
# Check key metrics
# - Response time (p50, p95, p99)
# - Error rate (%)
# - Request volume
# - Database query performance

# Datadog dashboard review
# - Application performance
# - Database performance
# - Infrastructure metrics

# Identify affected components
kubectl top pods -n production
kubectl get hpa -n production
```

**2. Determine Impact**
```
[ ] What percentage of requests affected?
[ ] Which features/endpoints impacted?
[ ] Are specific customer segments affected?
[ ] Is issue intermittent or constant?
[ ] Are workarounds available?
```

**3. Immediate Mitigation**
```bash
# If specific pods are struggling
kubectl delete pod <struggling-pod> -n production

# If traffic spike
kubectl scale deployment/popsystem-api --replicas=30 -n production

# If database query issue
# Review slow query log
psql -h production-db.example.com -U app_user -c \
  "SELECT * FROM pg_stat_statements
   ORDER BY total_time DESC LIMIT 20"

# If specific feature causing issues
# Feature flag to disable temporarily
curl -X POST https://api.popsystem.com/admin/feature-flags \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{"feature": "problematic-feature", "enabled": false}'
```

**4. Root Cause Analysis**
```
Common Causes:
[ ] Inefficient database query
[ ] Memory leak
[ ] External API slowness
[ ] Increased traffic
[ ] Resource contention
[ ] Cache invalidation issue
[ ] Disk I/O saturation
```

**5. Implement Solution**
```
Short-term:
- Scale resources
- Implement caching
- Optimize queries
- Rate limiting

Long-term:
- Code optimization
- Index creation
- Architecture changes
- Capacity planning
```

**Communication Template:**
```
Subject: [PERFORMANCE ISSUE] PopSystem Experiencing Slowness

We are currently experiencing slower than normal response times on
the PopSystem platform. Our team is actively working to resolve the issue.

Impact: Users may experience delays of 5-10 seconds on certain operations
Affected Features: [List if specific]
Workaround: [If available]

Status: Investigating
Next Update: [2 hours]

We apologize for the inconvenience.
```

---

### Security Incident Response

**Severity:** Varies (P1-P3 depending on scope)
**Definition:** Security breach, data exposure, or vulnerability exploitation

**Response Time:** 30 minutes
**Resolution Target:** Varies
**Communication:** Restricted until containment

**Incident Types:**
- Data breach or unauthorized access
- Vulnerability exploitation
- DDoS attack
- Credential compromise
- Malware or ransomware

**Immediate Actions:**

**1. Containment (First 30 minutes)**
```
[ ] Isolate affected systems
[ ] Revoke compromised credentials
[ ] Block malicious IPs/traffic
[ ] Preserve evidence (logs, snapshots)
[ ] Notify security team and legal
[ ] Do NOT shut down systems (preserve forensics)
```

**2. Assessment**
```
[ ] What data was accessed?
[ ] How was access gained?
[ ] When did breach occur?
[ ] What systems are affected?
[ ] Are attackers still in the system?
[ ] Is PII/customer data involved?
```

**3. Eradication**
```bash
# Rotate all credentials
# - Database passwords
# - API keys
# - Service account credentials
# - User session tokens

# Patch vulnerabilities
# - Update dependencies
# - Apply security patches
# - Fix application vulnerabilities

# Remove malicious access
# - Delete unauthorized users
# - Remove backdoors
# - Clear malicious code
```

**4. Recovery**
```
[ ] Restore from clean backups if needed
[ ] Verify system integrity
[ ] Monitor for re-infection
[ ] Gradual service restoration
[ ] Enhanced monitoring
```

**5. Legal and Compliance**
```
[ ] Notify legal team
[ ] Document all actions taken
[ ] Preserve evidence for investigation
[ ] Prepare regulatory notifications (if required)
[ ] Customer notification (if PII exposed)
[ ] Law enforcement contact (if needed)
```

**Communication Protocol:**

**Internal Only (during containment):**
- Restricted Slack channel
- Need-to-know basis
- Legal team involvement
- Executive notification

**Customer Communication (after containment):**
```
Subject: Important Security Notice

We recently identified a security incident affecting PopSystem.
We have taken immediate action to secure our systems and protect your data.

What happened: [Brief description]
What data was affected: [Specific details]
What we're doing: [Actions taken]
What you should do: [Customer actions if needed]

We take security very seriously and apologize for this incident.
For questions, please contact security@popsystem.com.
```

**Post-Incident:**
- Comprehensive forensic analysis
- Security audit
- Penetration testing
- Policy and procedure updates
- Staff security training
- Customer notification if required by regulation

---

## Database Maintenance Runbooks

### Database Backup and Verification

**Purpose:** Regular database backup and verification of backup integrity

**Frequency:** Automated daily, manual verification weekly
**Risk Level:** Low
**Duration:** 30-60 minutes

**Automated Daily Backup:**

```bash
#!/bin/bash
# Scheduled via cron: 0 2 * * * /scripts/backup_database.sh

set -e  # Exit on error

# Configuration
DB_HOST="production-db.example.com"
DB_NAME="popsystem_prod"
DB_USER="backup_user"
BACKUP_DIR="/backups/postgresql"
S3_BUCKET="s3://popsystem-backups/daily"
RETENTION_DAYS=30

# Create backup directory if not exists
mkdir -p $BACKUP_DIR

# Generate backup filename
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_$(date +%Y%m%d_%H%M%S).dump"

# Perform backup
echo "Starting backup at $(date)"
pg_dump -h $DB_HOST \
        -U $DB_USER \
        -Fc \
        -f $BACKUP_FILE \
        $DB_NAME

# Verify backup was created
if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERROR: Backup file not created!"
    exit 1
fi

# Get backup size
BACKUP_SIZE=$(du -h $BACKUP_FILE | cut -f1)
echo "Backup created: $BACKUP_FILE ($BACKUP_SIZE)"

# Upload to S3
aws s3 cp $BACKUP_FILE $S3_BUCKET/
echo "Backup uploaded to S3"

# Verify S3 upload
aws s3 ls $S3_BUCKET/ | grep $(basename $BACKUP_FILE)

# Delete local backups older than 7 days
find $BACKUP_DIR -name "*.dump" -mtime +7 -delete

# Delete S3 backups older than retention period
# Uses S3 lifecycle policy

# Send success notification
curl -X POST https://api.popsystem.com/admin/monitoring/backup-success \
     -H "Authorization: Bearer $MONITORING_TOKEN" \
     -d "{\"backup_file\": \"$BACKUP_FILE\", \"size\": \"$BACKUP_SIZE\"}"

echo "Backup completed successfully at $(date)"
```

**Weekly Backup Verification:**

```bash
#!/bin/bash
# Verify backup can be restored

# Download latest backup
LATEST_BACKUP=$(aws s3 ls s3://popsystem-backups/daily/ | sort | tail -1 | awk '{print $4}')
aws s3 cp s3://popsystem-backups/daily/$LATEST_BACKUP /tmp/

# Restore to test database
dropdb -h test-db.example.com -U postgres popsystem_test --if-exists
createdb -h test-db.example.com -U postgres popsystem_test

pg_restore -h test-db.example.com \
           -U postgres \
           -d popsystem_test \
           /tmp/$LATEST_BACKUP

# Verify restoration
ROW_COUNT=$(psql -h test-db.example.com -U postgres -d popsystem_test \
            -t -c "SELECT COUNT(*) FROM campaigns")

if [ $ROW_COUNT -gt 0 ]; then
    echo "Backup verification successful. Row count: $ROW_COUNT"
else
    echo "ERROR: Backup verification failed!"
    # Send alert
    exit 1
fi

# Cleanup
rm /tmp/$LATEST_BACKUP
dropdb -h test-db.example.com -U postgres popsystem_test
```

**Success Criteria:**
- [ ] Backup file created successfully
- [ ] Backup uploaded to S3
- [ ] Backup size reasonable (within 20% of previous backup)
- [ ] Weekly verification test passes
- [ ] No errors in backup logs
- [ ] Monitoring notification sent

---

### Database Performance Tuning

**Purpose:** Optimize database performance through maintenance tasks

**Frequency:** Monthly (or as needed based on performance metrics)
**Risk Level:** Medium
**Duration:** 2-4 hours
**Required Approvals:** DBA, Engineering Manager

**Performance Analysis:**

**1. Identify Slow Queries**
```sql
-- Enable pg_stat_statements if not already
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Top 20 slowest queries by total time
SELECT
    query,
    calls,
    total_time,
    mean_time,
    max_time,
    stddev_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 20;

-- Queries with high I/O
SELECT
    query,
    calls,
    shared_blks_hit,
    shared_blks_read,
    shared_blks_hit / (shared_blks_hit + shared_blks_read)::float AS hit_ratio
FROM pg_stat_statements
WHERE shared_blks_hit + shared_blks_read > 0
ORDER BY shared_blks_read DESC
LIMIT 20;
```

**2. Analyze Table Bloat**
```sql
-- Check table bloat
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename) -
                   pg_relation_size(schemaname||'.'||tablename)) AS index_size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
LIMIT 20;

-- Estimate bloat percentage
SELECT
    tablename,
    pg_size_pretty(pg_relation_size(tablename::text)) AS size,
    100 - (100.0 * pg_relation_size(tablename::text) /
           GREATEST(pg_total_relation_size(tablename::text), 1)) AS bloat_pct
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY bloat_pct DESC;
```

**3. Check Index Usage**
```sql
-- Unused indexes (candidates for removal)
SELECT
    schemaname,
    tablename,
    indexname,
    idx_scan,
    pg_size_pretty(pg_relation_size(indexrelid)) AS size
FROM pg_stat_user_indexes
WHERE idx_scan = 0
    AND indexrelname NOT LIKE '%pkey%'
ORDER BY pg_relation_size(indexrelid) DESC;

-- Missing indexes (sequential scans on large tables)
SELECT
    schemaname,
    tablename,
    seq_scan,
    seq_tup_read,
    idx_scan,
    seq_tup_read / seq_scan AS avg_seq_tup_read
FROM pg_stat_user_tables
WHERE seq_scan > 0
    AND pg_relation_size(schemaname||'.'||tablename) > 10000000
ORDER BY seq_tup_read DESC
LIMIT 20;
```

**Maintenance Tasks:**

**1. Vacuum and Analyze**
```sql
-- Full vacuum analyze (during maintenance window)
VACUUM VERBOSE ANALYZE;

-- Vacuum specific large tables
VACUUM VERBOSE ANALYZE campaigns;
VACUUM VERBOSE ANALYZE executions;
VACUUM VERBOSE ANALYZE photos;

-- Check autovacuum settings
SELECT
    schemaname,
    tablename,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze,
    vacuum_count,
    autovacuum_count
FROM pg_stat_user_tables
ORDER BY last_autovacuum NULLS FIRST;
```

**2. Reindex**
```sql
-- Reindex bloated indexes (one at a time to avoid locks)
REINDEX INDEX CONCURRENTLY campaigns_pkey;
REINDEX INDEX CONCURRENTLY idx_campaigns_status;

-- Reindex entire table (during maintenance window)
REINDEX TABLE CONCURRENTLY campaigns;
```

**3. Update Statistics**
```sql
-- Update statistics for query planner
ANALYZE VERBOSE;

-- Update statistics for specific tables
ANALYZE VERBOSE campaigns;
ANALYZE VERBOSE executions;
```

**4. Optimize Queries**
```sql
-- Create missing indexes based on analysis
CREATE INDEX CONCURRENTLY idx_campaigns_brand_id_created
    ON campaigns(brand_id, created_at);

-- Create partial indexes for common filtered queries
CREATE INDEX CONCURRENTLY idx_campaigns_active
    ON campaigns(status, start_date)
    WHERE status = 'active';

-- Drop unused indexes
DROP INDEX CONCURRENTLY idx_old_unused_index;
```

**5. Configure AutoVacuum (if needed)**
```sql
-- Adjust autovacuum for specific high-churn tables
ALTER TABLE executions SET (
    autovacuum_vacuum_scale_factor = 0.05,
    autovacuum_analyze_scale_factor = 0.02
);
```

**Post-Maintenance Validation:**
```sql
-- Verify query performance improved
EXPLAIN ANALYZE
SELECT * FROM campaigns
WHERE brand_id = 123
    AND status = 'active'
ORDER BY created_at DESC
LIMIT 10;

-- Check index sizes reduced
SELECT
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) AS size
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY pg_relation_size(indexrelid) DESC
LIMIT 20;
```

**Success Criteria:**
- [ ] Slow queries identified and optimized
- [ ] Table bloat reduced
- [ ] Unused indexes removed
- [ ] Missing indexes created
- [ ] Query performance improved (>20% for targeted queries)
- [ ] No increase in error rates post-maintenance

---

## Scaling Procedures

### Horizontal Scaling (Add Capacity)

**Purpose:** Scale application to handle increased load

**Trigger Criteria:**
- CPU utilization >70% for 10+ minutes
- Memory utilization >80% for 10+ minutes
- Request queue depth >100
- Response time p95 >2x baseline
- Anticipated traffic spike (planned event)

**Manual Scaling:**

```bash
# Check current scaling
kubectl get deployment popsystem-api -n production
kubectl get hpa -n production

# Scale up application
kubectl scale deployment/popsystem-api --replicas=20 -n production

# Verify scaling
kubectl get pods -l app=popsystem-api -n production -w

# Monitor performance
watch -n 5 'kubectl top pods -l app=popsystem-api -n production'
```

**Auto-Scaling Configuration:**

```yaml
# Horizontal Pod Autoscaler
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: popsystem-api-hpa
  namespace: production
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: popsystem-api
  minReplicas: 10
  maxReplicas: 50
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 60
```

**Database Scaling:**

```bash
# Read replica scaling (horizontal)
aws rds create-db-instance-read-replica \
    --db-instance-identifier popsystem-read-replica-3 \
    --source-db-instance-identifier popsystem-prod \
    --db-instance-class db.r5.2xlarge \
    --publicly-accessible false

# Vertical scaling (requires brief downtime)
aws rds modify-db-instance \
    --db-instance-identifier popsystem-prod \
    --db-instance-class db.r5.4xlarge \
    --apply-immediately

# Monitor scaling
aws rds describe-db-instances \
    --db-instance-identifier popsystem-prod \
    --query 'DBInstances[0].DBInstanceStatus'
```

**Success Criteria:**
- [ ] New pods/instances healthy
- [ ] Load distributed evenly
- [ ] Response times improved
- [ ] Error rates stable
- [ ] No user impact during scaling

---

### Vertical Scaling (Increase Resources)

**Purpose:** Increase resources for existing pods/instances

**Use Cases:**
- Memory-intensive operations
- CPU-bound workloads
- Database performance optimization

**Procedure:**

```bash
# Update deployment with new resource limits
kubectl set resources deployment/popsystem-api \
    -n production \
    --limits=cpu=2000m,memory=4Gi \
    --requests=cpu=1000m,memory=2Gi

# Trigger rolling update
kubectl rollout status deployment/popsystem-api -n production

# Verify new resources
kubectl describe pod -l app=popsystem-api -n production | grep -A 5 "Limits"
```

**Success Criteria:**
- [ ] Pods running with new resource allocation
- [ ] No performance degradation during rollout
- [ ] Resource utilization improved
- [ ] Application functioning normally

---

## Backup and Recovery Runbooks

### Full System Backup

**Purpose:** Complete backup of all systems for disaster recovery

**Frequency:** Weekly (full), Daily (incremental)
**Risk Level:** Low
**Duration:** 4-8 hours

**Backup Components:**

**1. Database Backup**
```bash
# Full PostgreSQL backup
pg_dump -h production-db.example.com \
        -U backup_user \
        -Fc \
        -f /backups/popsystem_full_$(date +%Y%m%d).dump \
        popsystem_prod

# Upload to S3 with encryption
aws s3 cp /backups/popsystem_full_$(date +%Y%m%d).dump \
    s3://popsystem-backups/full/ \
    --sse AES256
```

**2. File Storage Backup**
```bash
# S3 bucket backup (cross-region replication configured)
aws s3 sync s3://popsystem-uploads/ \
    s3://popsystem-uploads-backup/ \
    --source-region us-east-1 \
    --region us-west-2

# Verify replication
aws s3 ls s3://popsystem-uploads-backup/ --recursive | wc -l
```

**3. Configuration Backup**
```bash
# Kubernetes configurations
kubectl get all -n production -o yaml > k8s-config-$(date +%Y%m%d).yaml
kubectl get configmaps -n production -o yaml >> k8s-config-$(date +%Y%m%d).yaml
kubectl get secrets -n production -o yaml >> k8s-config-$(date +%Y%m%d).yaml

# Upload to secure storage
aws s3 cp k8s-config-$(date +%Y%m%d).yaml \
    s3://popsystem-backups/configs/ \
    --sse aws:kms \
    --sse-kms-key-id alias/backup-key
```

**4. Code Repository Backup**
```bash
# Clone all repositories
for repo in api frontend mobile; do
    git clone --mirror git@github.com:popsystem/$repo.git
    tar -czf ${repo}-mirror-$(date +%Y%m%d).tar.gz $repo.git
    aws s3 cp ${repo}-mirror-$(date +%Y%m%d).tar.gz s3://popsystem-backups/repos/
done
```

**Backup Verification:**
```
[ ] Database backup exists and is restorable
[ ] File storage replicated to backup region
[ ] Configuration backup encrypted and uploaded
[ ] Code repositories backed up
[ ] Backup integrity checks passed
[ ] Backup size within expected range
[ ] Monitoring alert sent (success/failure)
```

---

### Disaster Recovery Procedure

**Purpose:** Restore full system functionality after catastrophic failure

**Recovery Time Objective (RTO):** 4 hours
**Recovery Point Objective (RPO):** 1 hour

**Scenario:** Complete production environment loss

**Recovery Steps:**

**Phase 1: Assessment (30 minutes)**
```
[ ] Determine scope of failure
[ ] Identify last good backup
[ ] Verify backup region available
[ ] Assemble recovery team
[ ] Notify stakeholders
[ ] Activate disaster recovery plan
```

**Phase 2: Infrastructure Rebuild (1 hour)**
```bash
# Provision new infrastructure via IaC
cd terraform/production
terraform init
terraform plan -out=recovery.tfplan
terraform apply recovery.tfplan

# Verify infrastructure
terraform output
aws ec2 describe-instances --filters "Name=tag:Environment,Values=production"
```

**Phase 3: Database Restoration (1 hour)**
```bash
# Download latest backup
aws s3 cp s3://popsystem-backups/full/latest.dump /tmp/

# Restore database
pg_restore -h new-db.example.com \
           -U postgres \
           -d popsystem_prod \
           -c \
           /tmp/latest.dump

# Verify restoration
psql -h new-db.example.com -U postgres -d popsystem_prod -c \
    "SELECT COUNT(*) FROM campaigns"
```

**Phase 4: Application Deployment (1 hour)**
```bash
# Deploy latest stable version
kubectl apply -f k8s/production/

# Verify deployment
kubectl get pods -n production
kubectl get services -n production

# Run smoke tests
npm run test:smoke:production
```

**Phase 5: Data Validation (30 minutes)**
```
[ ] Verify user authentication works
[ ] Test core workflows
[ ] Validate data integrity
[ ] Check integrations
[ ] Verify reporting
```

**Phase 6: DNS Cutover (30 minutes)**
```bash
# Update DNS to point to new environment
aws route53 change-resource-record-sets \
    --hosted-zone-id Z1234567890ABC \
    --change-batch file://dns-update.json

# Monitor DNS propagation
watch -n 10 'dig api.popsystem.com +short'
```

**Phase 7: Monitoring and Validation (Ongoing)**
```
[ ] Monitor error rates
[ ] Monitor response times
[ ] Verify user activity
[ ] Check background jobs
[ ] Monitor support tickets
[ ] Continuous validation for 24 hours
```

**Success Criteria:**
- [ ] All services restored and operational
- [ ] Data loss within RPO (1 hour)
- [ ] Recovery completed within RTO (4 hours)
- [ ] No data corruption detected
- [ ] All integrations functional
- [ ] User activity resumed
- [ ] Post-recovery report completed

---

## Performance Troubleshooting Guides

### High Response Time Investigation

**Symptom:** API response times >2x baseline

**Investigation Checklist:**

**1. Identify Scope**
```
[ ] Is it affecting all endpoints or specific ones?
[ ] Is it intermittent or constant?
[ ] Started after a recent deployment?
[ ] Correlated with traffic spike?
[ ] Database-related or application-related?
```

**2. Check Application Metrics**
```bash
# Request duration by endpoint
curl https://api.popsystem.com/metrics | grep http_request_duration

# Check error rates
curl https://api.popsystem.com/metrics | grep http_requests_total

# Review application logs
kubectl logs -n production -l app=popsystem-api --tail=100 | grep "duration"
```

**3. Check Database Performance**
```sql
-- Active queries
SELECT pid, now() - query_start AS duration, query
FROM pg_stat_activity
WHERE state = 'active'
ORDER BY duration DESC;

-- Blocking queries
SELECT
    blocked_locks.pid AS blocked_pid,
    blocking_locks.pid AS blocking_pid,
    blocked_activity.query AS blocked_query,
    blocking_activity.query AS blocking_query
FROM pg_locks blocked_locks
JOIN pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_locks blocking_locks ON blocking_locks.locktype = blocked_locks.locktype
JOIN pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;

-- Slow queries (requires pg_stat_statements)
SELECT query, mean_time, calls
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;
```

**4. Check Infrastructure**
```bash
# CPU and memory utilization
kubectl top pods -n production

# Network latency
kubectl exec -it popsystem-api-pod -n production -- \
    curl -w "@curl-format.txt" -o /dev/null -s https://external-api.com

# Disk I/O
kubectl exec -it popsystem-api-pod -n production -- iostat -x 1 5
```

**5. Check External Dependencies**
```bash
# Test third-party API response times
curl -w "Response time: %{time_total}s\n" -o /dev/null -s https://stripe.com/api/v1/health
curl -w "Response time: %{time_total}s\n" -o /dev/null -s https://api.sendgrid.com/health

# Check DNS resolution
dig api.popsystem.com
```

**Common Fixes:**

**Slow Database Queries:**
```sql
-- Add missing index
CREATE INDEX CONCURRENTLY idx_campaigns_user_id_status
ON campaigns(user_id, status);

-- Kill long-running query
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE pid = 12345;
```

**Resource Exhaustion:**
```bash
# Scale up pods
kubectl scale deployment/popsystem-api --replicas=20 -n production

# Increase resource limits
kubectl set resources deployment/popsystem-api \
    --limits=cpu=2,memory=4Gi
```

**External API Slowness:**
```javascript
// Implement timeout and circuit breaker
const axios = require('axios');
const axiosRetry = require('axios-retry');

axiosRetry(axios, {
    retries: 3,
    retryDelay: axiosRetry.exponentialDelay
});

const response = await axios.get('https://external-api.com', {
    timeout: 5000  // 5 second timeout
});
```

**Caching:**
```javascript
// Add Redis caching for expensive queries
const redis = require('redis');
const client = redis.createClient();

async function getCampaigns(userId) {
    const cacheKey = `campaigns:${userId}`;
    const cached = await client.get(cacheKey);

    if (cached) {
        return JSON.parse(cached);
    }

    const campaigns = await db.query('SELECT * FROM campaigns WHERE user_id = $1', [userId]);
    await client.setex(cacheKey, 300, JSON.stringify(campaigns));  // Cache 5 minutes

    return campaigns;
}
```

---

### Memory Leak Investigation

**Symptom:** Memory usage continuously increasing, eventual OOM kills

**Investigation Steps:**

**1. Identify Leaking Pods**
```bash
# Monitor memory usage over time
watch -n 30 'kubectl top pods -n production | grep popsystem-api'

# Check pod restart history
kubectl get pods -n production -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.containerStatuses[0].restartCount}{"\n"}{end}'

# Get pod age vs memory usage
kubectl get pods -n production -o custom-columns=NAME:.metadata.name,AGE:.metadata.creationTimestamp,MEMORY:.status.containerStatuses[0].state.running.startedAt
```

**2. Generate Heap Dump**
```bash
# For Node.js applications
kubectl exec -it popsystem-api-pod -n production -- \
    node --inspect=0.0.0.0:9229 &

# Trigger heap dump
kubectl exec -it popsystem-api-pod -n production -- \
    kill -USR2 $(pgrep node)

# Copy heap dump locally
kubectl cp production/popsystem-api-pod:/tmp/heapdump-*.heapsnapshot ./heapdump.heapsnapshot
```

**3. Analyze Heap Dump**
```javascript
// Use Chrome DevTools
// 1. Open Chrome DevTools
// 2. Go to Memory tab
// 3. Load heap snapshot
// 4. Look for objects with large retained size
// 5. Check for detached DOM nodes
// 6. Identify circular references
```

**Common Causes and Fixes:**

**Event Listener Leaks:**
```javascript
// BAD - Leak
setInterval(() => {
    eventEmitter.on('data', handler);
}, 1000);

// GOOD - Cleanup
const interval = setInterval(() => {
    // work
}, 1000);

// Cleanup on shutdown
process.on('SIGTERM', () => {
    clearInterval(interval);
    eventEmitter.removeAllListeners();
});
```

**Cache Without Expiration:**
```javascript
// BAD - Unbounded cache
const cache = {};
function getData(key) {
    if (!cache[key]) {
        cache[key] = expensiveOperation(key);
    }
    return cache[key];
}

// GOOD - LRU cache with size limit
const LRU = require('lru-cache');
const cache = new LRU({
    max: 500,
    maxAge: 1000 * 60 * 60  // 1 hour
});
```

**Database Connection Leaks:**
```javascript
// BAD - Connection not released
async function queryDatabase() {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM campaigns');
    return result.rows;
    // Client not released!
}

// GOOD - Always release
async function queryDatabase() {
    const client = await pool.connect();
    try {
        const result = await client.query('SELECT * FROM campaigns');
        return result.rows;
    } finally {
        client.release();
    }
}
```

**Immediate Mitigation:**
```bash
# Restart leaking pods
kubectl rollout restart deployment/popsystem-api -n production

# Reduce pod lifespan until fix deployed
# Add liveness probe to restart pods automatically
```

---

## Monitoring and Alerting Setup

### Alert Configuration

**Purpose:** Configure monitoring alerts for critical system metrics

**Alert Levels:**
- **Critical (P1):** Immediate response required, page on-call
- **High (P2):** Response within 1 hour, Slack notification
- **Medium (P3):** Response within 4 hours, email notification
- **Low (P4):** Informational, log only

**Critical Alerts:**

**1. Service Down**
```yaml
# Datadog monitor configuration
name: "Production API Down"
type: service check
query: '"http.can_connect".over("env:production","service:api").last(2).count_by_status()'
message: |
  {{#is_alert}}
  CRITICAL: Production API is unreachable!

  Check:
  1. kubectl get pods -n production
  2. kubectl logs -n production -l app=popsystem-api
  3. Review recent deployments

  Runbook: https://docs.popsystem.com/runbooks/incident-response-p1
  @pagerduty-production
  {{/is_alert}}
thresholds:
  critical: 1
  ok: 1
escalation_message: "Service still down after 15 minutes @engineering-manager"
no_data_timeframe: 10  # minutes
```

**2. High Error Rate**
```yaml
name: "High Error Rate (5xx)"
type: metric alert
query: "sum(last_5m):sum:http.requests{status:5xx,env:production}.as_count() / sum:http.requests{env:production}.as_count() > 0.05"
message: |
  {{#is_alert}}
  CRITICAL: Error rate at {{value}}% (threshold: 5%)

  Recent 5xx errors:
  - Check Sentry: https://sentry.io/popsystem/production
  - Check logs: kubectl logs -n production -l app=api --tail=100 | grep ERROR

  @slack-engineering-alerts
  {{/is_alert}}
thresholds:
  critical: 0.05  # 5%
  warning: 0.02   # 2%
```

**3. Database Connection Pool Exhausted**
```yaml
name: "Database Connection Pool Critical"
type: metric alert
query: "avg(last_5m):avg:postgresql.connections.active{env:production} / avg:postgresql.connections.max{env:production} > 0.9"
message: |
  {{#is_alert}}
  CRITICAL: Database connection pool at {{value}}% capacity

  Immediate actions:
  1. Check for connection leaks
  2. Review slow queries
  3. Consider scaling read replicas

  @pagerduty-database
  {{/is_alert}}
thresholds:
  critical: 0.9   # 90%
  warning: 0.75   # 75%
```

**High Priority Alerts:**

**1. Slow Response Time**
```yaml
name: "API Response Time High"
type: metric alert
query: "avg(last_10m):avg:http.request.duration.p95{env:production,service:api} > 2000"
message: |
  {{#is_warning}}
  WARNING: API p95 response time at {{value}}ms (threshold: 2000ms)
  {{/is_warning}}
  {{#is_alert}}
  ALERT: API p95 response time at {{value}}ms (threshold: 3000ms)
  {{/is_alert}}

  Runbook: https://docs.popsystem.com/runbooks/high-response-time
  @slack-engineering-alerts
thresholds:
  critical: 3000  # 3 seconds
  warning: 2000   # 2 seconds
```

**2. Disk Space Low**
```yaml
name: "Disk Space Critical"
type: metric alert
query: "avg(last_5m):avg:system.disk.free{env:production} by {host} < 10"
message: |
  {{#is_alert}}
  ALERT: Disk space on {{host.name}} at {{value}}% free

  Actions:
  1. Clear old logs
  2. Clean up temp files
  3. Expand disk if needed

  @slack-infrastructure
  {{/is_alert}}
thresholds:
  critical: 10   # 10% free
  warning: 20    # 20% free
```

**Medium Priority Alerts:**

**1. Increased Traffic**
```yaml
name: "Traffic Spike Detected"
type: metric alert
query: "avg(last_10m):avg:http.requests.rate{env:production} > 1000"
message: |
  Traffic spike detected: {{value}} requests/second

  Monitor for:
  - Increased resource usage
  - Potential DDoS
  - Marketing campaign traffic

  @slack-engineering-info
thresholds:
  warning: 1000  # requests/second
notify_no_data: false
```

**2. Failed Background Jobs**
```yaml
name: "Background Job Failures"
type: metric alert
query: "sum(last_15m):sum:background.jobs.failed{env:production}.as_count() > 10"
message: |
  {{value}} background jobs failed in last 15 minutes

  Check job queue and error logs
  @slack-engineering-info
thresholds:
  warning: 10
  critical: 50
```

**Alert Routing:**

```yaml
# PagerDuty integration for P1/P2
integrations:
  pagerduty:
    services:
      - name: production-critical
        escalation_policy: on-call-engineering
        alerts:
          - "Production API Down"
          - "High Error Rate"
          - "Database Connection Pool Critical"

      - name: production-high
        escalation_policy: business-hours
        alerts:
          - "API Response Time High"
          - "Disk Space Critical"

# Slack integration for all alerts
  slack:
    channels:
      - name: "#engineering-alerts"
        severity: [critical, high]
      - name: "#engineering-info"
        severity: [medium, low]
```

**Dashboard Setup:**

```yaml
# Main Production Dashboard
dashboard:
  name: "Production Overview"
  widgets:
    - type: timeseries
      title: "Request Rate"
      metrics:
        - "sum:http.requests{env:production}.as_rate()"

    - type: timeseries
      title: "Response Time (p50, p95, p99)"
      metrics:
        - "avg:http.request.duration.p50{env:production}"
        - "avg:http.request.duration.p95{env:production}"
        - "avg:http.request.duration.p99{env:production}"

    - type: timeseries
      title: "Error Rate"
      metrics:
        - "sum:http.requests{status:5xx,env:production}.as_rate()"
        - "sum:http.requests{status:4xx,env:production}.as_rate()"

    - type: query_value
      title: "Active Pods"
      query: "sum:kubernetes.pods.running{env:production}"

    - type: timeseries
      title: "Database Performance"
      metrics:
        - "avg:postgresql.query.duration{env:production}"
        - "sum:postgresql.connections.active{env:production}"

    - type: timeseries
      title: "Infrastructure"
      metrics:
        - "avg:system.cpu.user{env:production}"
        - "avg:system.mem.used{env:production}"
        - "avg:system.disk.used{env:production}"
```

---

## On-Call Handoff Procedures

### On-Call Responsibilities

**Primary On-Call Engineer:**
- First responder for all P1/P2 incidents
- Monitor alerts and dashboards
- Escalate when necessary
- Document all incidents
- Perform scheduled maintenance

**Secondary On-Call Engineer:**
- Backup for primary on-call
- Assist with complex incidents
- Take over if primary unavailable

**On-Call Schedule:**
- Weekly rotation (Monday 9 AM to Monday 9 AM)
- Secondary rotation staggered by 3 days
- Minimum 2 engineers on rotation
- Holiday coverage planned in advance

### Handoff Checklist

**Outgoing On-Call (Monday 9 AM):**

**1. Prepare Handoff Document**
```markdown
# On-Call Handoff Report
**Week:** Dec 14-21, 2025
**Outgoing:** Jane Doe
**Incoming:** John Smith

## Summary
- Total incidents: 3 (2 P2, 1 P3)
- Deployments: 2 successful
- Maintenance: Database vacuum completed
- Overall health: Good

## Active Issues
### ISSUE-123: Intermittent Timeout on Reports Endpoint
- Status: Investigating
- Next action: Review database query performance
- Owner: Jane Doe (handing off to John)
- Context: Started Friday evening, affects ~5% of report requests

## Incidents This Week
### INC-2025-042: High database CPU (P2)
- Date: Dec 18, 2025 14:30 UTC
- Duration: 2 hours
- Root cause: Inefficient query from new feature
- Resolution: Added index, optimized query
- Post-mortem: https://docs.popsystem.com/incidents/INC-2025-042

### INC-2025-043: Slow API responses (P2)
- Date: Dec 20, 2025 09:15 UTC
- Duration: 45 minutes
- Root cause: Third-party API slowness
- Resolution: Increased timeout, added circuit breaker
- Post-mortem: Pending

## Deployments
- v2.5.1 deployed Dec 16 (successful)
- v2.5.2 deployed Dec 19 (successful)

## Upcoming
- Scheduled maintenance: Database backup verification (Dec 22)
- Expected deployment: v2.6.0 (Dec 23)
- Holiday coverage needed: Dec 24-26

## Notes
- Monitoring showing slight increase in memory usage, watching for leak
- New alert added for background job failures
- Secondary database replica added, verify replication lag

## Escalation Contacts
- Engineering Manager: Sarah Johnson (sarah@popsystem.com, +1-555-0101)
- DBA: Mike Chen (mike@popsystem.com, +1-555-0102)
- VP Engineering: Alex Kumar (alex@popsystem.com, +1-555-0103)
```

**2. Handoff Meeting (15-30 minutes)**
```
[ ] Review handoff document
[ ] Walk through active issues
[ ] Share context on incidents
[ ] Review monitoring dashboards
[ ] Check runbook updates
[ ] Verify access to all systems
[ ] Answer incoming engineer's questions
```

**3. System Health Check**
```bash
# Run health check script
./scripts/system-health-check.sh

# Review output
# - All services: UP
# - Database: Healthy
# - Background jobs: Processing
# - Disk space: >20% free
# - Recent deployments: Successful
```

**Incoming On-Call (Monday 9 AM):**

**1. Review Handoff Materials**
```
[ ] Read handoff document thoroughly
[ ] Review incident reports from past week
[ ] Check current monitoring dashboards
[ ] Review upcoming deployments
[ ] Understand active issues
```

**2. Verify Access and Tools**
```
[ ] PagerDuty notifications working
[ ] Slack alerts configured
[ ] VPN access functional
[ ] AWS console access
[ ] Kubernetes cluster access
[ ] Database access
[ ] Monitoring dashboards accessible
[ ] Runbook access
```

**3. Test On-Call Setup**
```bash
# Test PagerDuty alert
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "your_integration_key",
    "event_action": "trigger",
    "payload": {
      "summary": "Test alert - On-call handoff",
      "severity": "info",
      "source": "on-call-test"
    }
  }'

# Verify alert received via PagerDuty app and phone
```

**4. Acknowledge Handoff**
```
[ ] Send confirmation to team
[ ] Update on-call calendar
[ ] Post in #engineering channel
[ ] Save handoff document
```

**Handoff Template (Slack):**
```
:rotating_light: On-Call Handoff Complete

Outgoing: @jane
Incoming: @john
Week: Dec 21-28, 2025

Summary: 3 incidents this week (2 P2, 1 P3), all resolved.
One active issue being monitored (ISSUE-123).

Full handoff doc: https://docs.popsystem.com/oncall/handoff-2025-12-21

John is now primary on-call. Sarah is secondary.

Handoff meeting completed. :white_check_mark:
```

---

## Customer Escalation Procedures

### Escalation Criteria

**Technical Escalation:**
- Issue unresolved after 2 support interactions
- Requires engineering investigation
- Affects multiple customers
- Potential product bug
- Security concern

**Management Escalation:**
- Customer dissatisfaction (CSAT <3)
- Repeated issues (>3 tickets in 7 days)
- VIP/Enterprise customer concern
- Renewal risk
- Executive involvement requested

### Escalation Flow

**Level 1: Support Team**
- Initial triage and troubleshooting
- Knowledge base and runbook consultation
- Standard issue resolution
- Timeline: 24-48 hours

**Level 2: Customer Success Manager**
- Customer relationship management
- Issue coordination
- Workaround provision
- Regular updates
- Timeline: 4-24 hours

**Level 3: Engineering Team**
- Technical investigation
- Bug identification and fixes
- Custom solutions
- Timeline: 1-4 hours (based on severity)

**Level 4: Engineering Manager**
- Resource allocation
- Priority assessment
- Cross-team coordination
- Timeline: 1 hour (P1/P2 only)

**Level 5: Executive Team**
- Strategic decisions
- Major account retention
- Policy exceptions
- Timeline: As needed

### Escalation Runbook

**When Customer Reports Critical Issue:**

**1. Immediate Response (within 15 minutes)**
```
Support Engineer Actions:
[ ] Acknowledge ticket immediately
[ ] Classify severity (P1-P4)
[ ] Gather initial information
[ ] Check status page for known issues
[ ] Search for similar recent tickets
[ ] Attempt initial troubleshooting
```

**2. Escalation Decision (within 30 minutes)**
```
Escalate to Engineering if:
[ ] Cannot resolve with standard troubleshooting
[ ] Suspected product bug
[ ] Requires code-level investigation
[ ] Affects multiple customers
[ ] Security or data integrity concern

Escalate to CSM if:
[ ] Customer is frustrated (CSAT concern)
[ ] Enterprise/VIP customer
[ ] Renewal risk identified
[ ] Executive involved
[ ] Repeated issues from customer
```

**3. Engineering Escalation Process**
```
Support Engineer:
[ ] Create detailed engineering ticket in Jira
[ ] Include reproduction steps
[ ] Attach relevant logs and screenshots
[ ] Document customer impact
[ ] Link to support ticket
[ ] Notify engineering in Slack #support-escalations

Engineering Response:
[ ] Acknowledge escalation (within 1 hour)
[ ] Assign engineer
[ ] Provide initial assessment (within 2 hours)
[ ] Give time estimate for resolution
[ ] Update ticket regularly
```

**4. CSM Escalation Process**
```
Support Engineer:
[ ] Notify assigned CSM via Slack and email
[ ] Provide ticket summary and history
[ ] Share customer sentiment
[ ] Recommend next steps

CSM Response:
[ ] Contact customer directly (within 1 hour)
[ ] Provide personal attention
[ ] Set expectations
[ ] Coordinate with support and engineering
[ ] Schedule follow-up if needed
```

**5. Executive Escalation Process**
```
Trigger:
- P1 incident affecting major customer
- Potential churn risk (high ARR)
- Legal or compliance issue
- Significant PR risk

CSM or Engineering Manager:
[ ] Brief executive on situation
[ ] Provide customer context (ARR, tenure, relationship)
[ ] Outline proposed resolution
[ ] Facilitate executive-to-executive call if needed

Executive Actions:
[ ] Direct customer outreach
[ ] Resource allocation decisions
[ ] Policy exceptions if appropriate
[ ] Strategic partnership discussion
```

### Escalation Communication Template

**To Customer (CSM):**
```
Subject: Personal Follow-up on Support Ticket #12345

Hi [Customer Name],

I'm [CSM Name], your Customer Success Manager at PopSystem. I wanted
to personally reach out regarding the issue you reported today.

I understand that [brief issue description] and I know how critical
this is to your operations. I want to assure you that we're treating
this with the highest priority.

Here's what's happening:
- Our engineering team is actively investigating
- We've identified [preliminary findings if available]
- Expected resolution timeline: [timeframe]
- I will personally keep you updated every [frequency]

In the meantime, [workaround if available].

I'm available anytime at [phone] or you can reply to this email.

We appreciate your patience and partnership.

Best regards,
[CSM Name]
```

**To Engineering (Support):**
```
Jira Ticket: ENG-5678
Priority: High
Customer: Acme Corp (Enterprise, $150K ARR)
Support Ticket: #12345

Issue: Campaign creation failing with 500 error

Impact:
- Customer unable to create new campaigns since 2 PM
- Affects their time-sensitive holiday campaign launch
- Multiple users experiencing issue
- Customer frustration high (CSAT risk)

Reproduction Steps:
1. Login as brand user
2. Navigate to Campaigns > New Campaign
3. Fill in campaign details
4. Click "Create Campaign"
5. Result: 500 error, campaign not created

Environment:
- Production
- Customer: acme-corp (account ID: 12345)
- User: john@acmecorp.com (user ID: 67890)
- Timestamp: 2025-12-21 14:30 UTC

Logs:
- Error: "ValidationError: Campaign.budget is required"
- But budget field is populated in UI
- Attached: Screenshots, browser console logs, HAR file

Workaround: None identified

Customer contact: John Smith (john@acmecorp.com, +1-555-1234)
CSM: Jane Doe (notified, standing by)

Please acknowledge and provide ETA.
```

**To Customer (Post-Resolution):**
```
Subject: Issue Resolved - Ticket #12345

Hi [Customer Name],

Great news! The issue you reported has been resolved.

What happened:
[Brief non-technical explanation of root cause]

What we did:
[Brief explanation of fix]

What we're doing to prevent this:
[Future prevention measures]

Everything should now be working normally. I've tested the workflow
on your account and confirmed it's functioning as expected.

As an apology for the inconvenience, [compensation if applicable,
e.g., "we've added 2 weeks to your subscription at no charge"].

Please let me know if you experience any further issues or have
any questions. I'll follow up with you [timeframe] to ensure
everything continues to run smoothly.

Thank you for your patience and for being a valued PopSystem customer.

Best regards,
[CSM Name]
```

**Success Criteria:**
- [ ] Customer feels heard and valued
- [ ] Clear communication throughout
- [ ] Issue resolved to satisfaction
- [ ] Relationship maintained or strengthened
- [ ] Root cause addressed for future prevention
- [ ] Documentation updated

---

**Document Owner:** VP of Engineering / Director of Operations
**Last Updated:** 2025-12-21
**Next Review:** Quarterly
**Related Documents:** Support_Tiers.md, Customer_Success_Playbook.md, Onboarding_Process.md, Documentation_Plan.md
