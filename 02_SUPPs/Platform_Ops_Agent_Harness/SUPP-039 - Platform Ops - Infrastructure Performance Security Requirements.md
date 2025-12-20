# SUPP-039 — Infrastructure, Performance & Security Requirements

> **Version**: v0.1
> **Status**: Draft
> **Updated**: 2025-12-20
> **Dependencies**: SUPP-012 (Technology Selections), SUPP-035 (Data Model)

---

## Purpose

Defines infrastructure sizing, performance targets, security requirements, and cloud cost estimates for NewPOPSys v1 deployment. Provides clear benchmarks for development, testing, and production readiness.

---

## Infrastructure Architecture

### Recommended Cloud Platform

**Primary: AWS** (alternative: Azure)

| Component | AWS Service | Purpose |
|-----------|-------------|---------|
| Compute | ECS Fargate / EKS | Container orchestration |
| Database | RDS PostgreSQL | Primary data store |
| Cache | ElastiCache Redis | Session, cache, queues |
| Object Storage | S3 | Photo uploads, exports |
| CDN | CloudFront | Static assets, signed URLs |
| Load Balancer | ALB | HTTPS termination, routing |
| DNS | Route 53 | Domain management |
| Secrets | Secrets Manager | API keys, credentials |
| Monitoring | CloudWatch + X-Ray | Logs, metrics, tracing |

### Environment Tiers

| Environment | Purpose | Sizing |
|-------------|---------|--------|
| Development | Local + shared dev | Minimal (single instance) |
| Staging | QA, UAT, demo | Production-like (scaled down) |
| Production | Live system | Full capacity |

---

## Infrastructure Sizing

### Production Environment (Target: 500 stores, 50 concurrent users)

| Component | Specification | Quantity | Monthly Cost (est.) |
|-----------|---------------|----------|---------------------|
| **API Containers** | 2 vCPU, 4GB RAM | 2-4 (auto-scale) | $150-300 |
| **Worker Containers** | 1 vCPU, 2GB RAM | 2 | $75 |
| **PostgreSQL RDS** | db.r6g.large (2 vCPU, 16GB) | 1 primary + 1 read replica | $400 |
| **Redis ElastiCache** | cache.t3.medium | 1 | $50 |
| **S3 Storage** | Standard + Glacier | 500GB initial | $15 |
| **CloudFront** | Standard distribution | 1TB transfer | $85 |
| **ALB** | Application Load Balancer | 1 | $25 |
| **NAT Gateway** | For private subnets | 1 | $35 |
| **Secrets Manager** | Per secret/month | 20 secrets | $10 |
| **CloudWatch** | Logs + metrics | Standard | $50 |
| **Route 53** | Hosted zone + queries | 1 zone | $5 |
| **WAF** | Web Application Firewall | Basic rules | $25 |
| **Backup** | Daily snapshots | 30-day retention | $30 |
| **Total Monthly** | | | **~$955-1,105** |

### Scaling Projections

| Store Count | Concurrent Users | API Instances | DB Size | Monthly Cost |
|-------------|------------------|---------------|---------|--------------|
| 100 | 10 | 2 | db.t3.medium | $500 |
| 500 | 50 | 2-4 | db.r6g.large | $1,000 |
| 2,000 | 200 | 4-8 | db.r6g.xlarge | $2,500 |
| 10,000 | 1,000 | 8-16 | db.r6g.2xlarge + replicas | $6,000 |

---

## Performance Requirements

### API Response Time SLAs

| Endpoint Category | p50 | p95 | p99 | Max |
|-------------------|-----|-----|-----|-----|
| Simple reads (GET list) | < 50ms | < 150ms | < 300ms | 1s |
| Complex reads (dashboard) | < 100ms | < 300ms | < 500ms | 2s |
| Writes (create/update) | < 100ms | < 250ms | < 500ms | 2s |
| Photo upload initiation | < 200ms | < 500ms | < 1s | 3s |
| Report generation | < 2s | < 5s | < 10s | 30s |
| Export (async) | N/A | N/A | N/A | 5 min |

### Throughput Targets

| Metric | Target | Burst |
|--------|--------|-------|
| API requests/second | 100 | 500 |
| Concurrent WebSocket connections | 200 | 500 |
| Photo uploads/minute | 50 | 200 |
| Database queries/second | 500 | 2,000 |
| Background jobs/minute | 100 | 500 |

### Database Performance

| Query Type | Target | Index Strategy |
|------------|--------|----------------|
| Primary key lookup | < 1ms | B-tree on UUID |
| Campaign list (filtered) | < 10ms | Composite on tenant_id + status |
| Store search | < 20ms | GIN on name, store_number |
| Rollup aggregation | < 100ms | Materialized view + refresh |
| Full-text search | < 50ms | pg_trgm + GIN |

### Photo Processing

| Operation | Target Time | Strategy |
|-----------|-------------|----------|
| Upload to S3 | < 5s for 10MB | Direct-to-S3 presigned URL |
| Thumbnail generation | < 2s | Lambda trigger on upload |
| EXIF extraction | < 500ms | Lambda in upload pipeline |
| CDN cache hit | < 50ms | CloudFront edge caching |

---

## Security Requirements

### Authentication & Authorization

| Requirement | Implementation |
|-------------|----------------|
| Authentication | JWT tokens (RS256), 15-min access / 7-day refresh |
| MFA | TOTP for admin roles (optional for store users) |
| Session management | Redis-backed, sliding expiration |
| API authentication | Bearer token + tenant header |
| Service-to-service | mTLS or signed JWTs |

### Data Protection

| Data Type | At Rest | In Transit |
|-----------|---------|------------|
| Database | AES-256 (RDS encryption) | TLS 1.3 |
| Object storage | SSE-S3 or SSE-KMS | HTTPS only |
| Secrets | AWS KMS envelope encryption | TLS 1.3 |
| Backups | Encrypted snapshots | N/A |
| Logs | CloudWatch encryption | TLS 1.3 |

### OWASP Top 10 Compliance

| Risk | Mitigation |
|------|------------|
| A01: Broken Access Control | RBAC enforced at API layer, tenant isolation |
| A02: Cryptographic Failures | TLS 1.3, AES-256 at rest, no sensitive data in URLs |
| A03: Injection | Parameterized queries, input validation |
| A04: Insecure Design | Threat modeling, secure defaults |
| A05: Security Misconfiguration | Infrastructure as Code, security scanning |
| A06: Vulnerable Components | Dependabot, regular patching |
| A07: Auth Failures | Rate limiting, account lockout, strong passwords |
| A08: Data Integrity Failures | Signed deployments, audit logging |
| A09: Logging Failures | Centralized logging, anomaly detection |
| A10: SSRF | URL validation, egress filtering |

### Penetration Testing

| Phase | Timing | Scope |
|-------|--------|-------|
| Pre-launch | Before beta | Full application + infrastructure |
| Quarterly | Ongoing | Critical paths + new features |
| Annual | Yearly | Full scope + social engineering |

### Compliance Considerations

| Standard | Applicability | Status |
|----------|---------------|--------|
| SOC 2 Type II | If enterprise customers require | Future (v2+) |
| GDPR | EU store data | Basic compliance in v1 |
| CCPA | California stores | Basic compliance in v1 |
| PCI DSS | N/A (no payment processing) | Not applicable |

---

## Availability & Disaster Recovery

### Uptime Targets

| Environment | Target | Allowed Downtime/Month |
|-------------|--------|------------------------|
| Production | 99.5% | 3.6 hours |
| Staging | 95% | 36 hours |

### Backup Strategy

| Data Type | Frequency | Retention | Recovery Target |
|-----------|-----------|-----------|-----------------|
| Database | Daily full + continuous WAL | 30 days | < 1 hour (RTO) |
| Object storage | Versioning enabled | 90 days | < 15 min |
| Configuration | Git-versioned | Unlimited | < 30 min |
| Secrets | Replicated to DR region | N/A | < 15 min |

### Disaster Recovery

| Scenario | Strategy | RTO | RPO |
|----------|----------|-----|-----|
| Single AZ failure | Multi-AZ RDS + ECS | < 5 min | 0 |
| Region failure | Cross-region replica (if required) | < 4 hours | < 1 hour |
| Data corruption | Point-in-time recovery | < 1 hour | < 5 min |
| Ransomware | Immutable backups + restore | < 4 hours | < 1 hour |

---

## Implementation Timeline

### Phase 1: Foundation (Sprints 1-4)
- [ ] Infrastructure as Code (Terraform/Pulumi)
- [ ] CI/CD pipeline with security scanning
- [ ] Development and staging environments
- [ ] Database provisioning with encryption
- [ ] S3 buckets with lifecycle policies

### Phase 2: Core Application (Sprints 5-12)
- [ ] API deployment with auto-scaling
- [ ] Redis cache configuration
- [ ] CloudFront distribution
- [ ] Monitoring and alerting setup
- [ ] Log aggregation

### Phase 3: Hardening (Sprints 13-16)
- [ ] WAF rules and rate limiting
- [ ] Penetration testing
- [ ] Performance load testing
- [ ] Backup verification
- [ ] Runbook documentation

### Phase 4: Production Launch
- [ ] Production environment provisioning
- [ ] DNS cutover
- [ ] Monitoring dashboards
- [ ] On-call rotation setup
- [ ] Incident response procedures

---

## Cost Summary

### Year 1 Infrastructure Costs

| Category | Monthly | Annual |
|----------|---------|--------|
| Cloud infrastructure (500 stores) | $1,000 | $12,000 |
| Domain + SSL certificates | $10 | $120 |
| Third-party services (email, SMS) | $100 | $1,200 |
| Monitoring tools (if external) | $50 | $600 |
| Security tools (scanning) | $100 | $1,200 |
| **Total** | **$1,260** | **$15,120** |

### Scaling Cost Model

| Store Count | Annual Infrastructure |
|-------------|----------------------|
| 100 | $6,000 |
| 500 | $15,000 |
| 2,000 | $30,000 |
| 10,000 | $72,000 |

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Initial draft covering infrastructure, performance, and security |
