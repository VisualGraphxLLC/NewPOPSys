# External Dependency Risks

## Overview

This document tracks all external dependencies that could impact project delivery, including third-party APIs, cloud services, and package dependencies.

---

## Third-Party APIs

### Critical Dependencies

| API | Provider | Purpose | Risk Level | Fallback Strategy |
|-----|----------|---------|------------|-------------------|
| OnPrintShop GraphQL API | OnPrintShop | Order management, product catalog | Critical | Queue orders locally, sync when available |
| OneVision API | OneVision | Print production workflow | Critical | Manual production queue, PDF export |
| Ziflow API | Ziflow | Proof approval workflow | High | Email-based approval fallback |
| XPS Ship API | XPS | Shipping label generation | High | Manual carrier website access |
| MightyCall API | MightyCall | Phone/SMS communication | Medium | Alternative communication channels |
| Chatwoot API | Chatwoot | Customer messaging | Medium | Email fallback |

### API Risk Details

#### OnPrintShop GraphQL API
- **Version**: Current production
- **SLA**: 99.9% uptime
- **Rate Limits**: 1000 requests/minute
- **Authentication**: API Key + OAuth2
- **Known Issues**:
  - Occasional timeout on large order queries
  - Schema changes require advance notice
- **Monitoring**: Health check every 5 minutes
- **Contact**: support@onprintshop.com

#### OneVision API
- **Version**: v2.1
- **SLA**: 99.5% uptime
- **Rate Limits**: 500 requests/minute
- **Authentication**: Bearer token
- **Known Issues**:
  - Webhook delivery delays during peak hours
  - Large file uploads may timeout
- **Monitoring**: Webhook status monitoring
- **Contact**: api-support@onevision.com

#### Ziflow API
- **Version**: v3
- **SLA**: 99.9% uptime
- **Rate Limits**: 100 requests/minute
- **Authentication**: OAuth2
- **Known Issues**:
  - Proof generation may queue during high load
- **Monitoring**: API response time tracking
- **Contact**: developers@ziflow.io

---

## Cloud Services

### Infrastructure Dependencies

| Service | Provider | Purpose | Risk Level | Fallback |
|---------|----------|---------|------------|----------|
| Docker Hosting | Local/Cloud | Container runtime | Critical | Backup host ready |
| PostgreSQL | Self-hosted | Primary database | Critical | Replica failover |
| Redis | Self-hosted | Caching/Sessions | High | Direct DB fallback |
| Qdrant | Self-hosted | Vector search | Medium | Degraded search |
| LightRAG | Self-hosted | Knowledge graph | Low | Cached responses |

### Cloud Service Details

#### Container Hosting
- **Current**: Docker on local infrastructure
- **Backup**: Cloud provider ready (AWS/Azure)
- **Recovery Time**: 4-8 hours for full migration
- **Backup Frequency**: Daily container snapshots

#### Database (PostgreSQL)
- **Configuration**: Primary + Read replica
- **Backup**: Hourly incremental, daily full
- **Recovery Point Objective (RPO)**: 1 hour
- **Recovery Time Objective (RTO)**: 30 minutes
- **Monitoring**: Connection pool, query performance

#### Redis Cache
- **Configuration**: Standalone with persistence
- **Fallback**: Application continues with DB-only
- **Performance Impact**: 20-30% slower response times
- **Monitoring**: Memory usage, hit ratio

---

## Package Dependencies

### Critical Packages

| Package | Version | Purpose | Risk | Update Policy |
|---------|---------|---------|------|---------------|
| Frappe Framework | 15.x | Core platform | High | Major: Quarterly, Security: ASAP |
| n8n | Latest | Workflow automation | Medium | Monthly updates |
| Python | 3.11+ | Backend runtime | Low | LTS versions only |
| Node.js | 20.x LTS | Frontend/tooling | Low | LTS versions only |

### Dependency Management

#### Python Dependencies
```
Location: requirements.txt, pyproject.toml
Lock File: poetry.lock / pip-tools
Update Frequency: Monthly security scan
Vulnerability Scanning: Dependabot, Snyk
```

#### JavaScript Dependencies
```
Location: package.json
Lock File: package-lock.json / yarn.lock
Update Frequency: Monthly security scan
Vulnerability Scanning: npm audit, Dependabot
```

### Version Pinning Strategy

| Dependency Type | Pinning Strategy |
|----------------|------------------|
| Framework (Frappe) | Exact version, tested upgrades |
| Major libraries | Minor version range (^x.y.0) |
| Utilities | Patch version range (~x.y.z) |
| Dev dependencies | Latest compatible |

---

## Dependency Health Dashboard

### Current Status

| Dependency Category | Health | Last Checked | Issues |
|--------------------|--------|--------------|--------|
| Third-Party APIs | 🟢 Healthy | 2026-01-01 | None |
| Cloud Services | 🟢 Healthy | 2026-01-01 | None |
| Package Dependencies | 🟡 Attention | 2026-01-01 | 2 outdated |

### Monitoring Schedule

| Check Type | Frequency | Automated |
|------------|-----------|-----------|
| API Health | Every 5 min | Yes |
| Service Status | Every 1 min | Yes |
| Dependency Audit | Weekly | Yes |
| Full Risk Review | Monthly | No |

---

## Mitigation Actions

### Immediate Actions Required
- [ ] None currently

### Scheduled Reviews
- [ ] Monthly dependency audit
- [ ] Quarterly vendor review
- [ ] Annual contract renewals

### Contingency Plans

#### Complete API Outage
1. Activate local queue system
2. Notify affected users
3. Monitor for recovery
4. Sync data upon restoration

#### Cloud Service Failure
1. Failover to backup systems
2. Notify stakeholders
3. Initiate incident response
4. Post-incident review

#### Critical Package Vulnerability
1. Assess impact immediately
2. Test patch in staging
3. Emergency deployment if needed
4. Document and communicate

---

*Last Updated: 2026-01-01*
