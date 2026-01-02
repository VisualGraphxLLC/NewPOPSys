# Release Checklist

## Overview

This checklist ensures all necessary steps are completed before deploying a release to production. All items must be verified and signed off by the appropriate team members.

---

## Pre-Release Verification

### Release Information

| Field | Value |
|-------|-------|
| **Release Version** | v_._._ |
| **Release Date** | YYYY-MM-DD |
| **Release Manager** | @name |
| **Release Type** | Major / Minor / Patch / Hotfix |

---

## Checklist

### 1. Bug Status ✅

- [ ] **All P0 bugs resolved** - No critical/blocker issues remain open
- [ ] **All P1 bugs resolved** - No high-priority issues remain open
- [ ] **P2/P3 bugs triaged** - Remaining bugs assessed and deferred if necessary
- [ ] **Bug fixes verified** - All resolved bugs retested and confirmed fixed
- [ ] **No regressions** - Existing functionality verified to work correctly

**Sign-off:** _________________ **Date:** _________

---

### 2. Performance Benchmarks ✅

- [ ] **Load testing completed** - Application tested under expected load
- [ ] **Response time within SLA** - API endpoints meet latency requirements
  - Target: < 200ms for 95th percentile
- [ ] **Memory usage acceptable** - No memory leaks detected
- [ ] **Database queries optimized** - No N+1 or slow queries identified
- [ ] **CDN/caching configured** - Static assets properly cached

**Performance Metrics:**
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| API Response Time (p95) | < 200ms | | ⬜ |
| Page Load Time | < 3s | | ⬜ |
| Error Rate | < 0.1% | | ⬜ |
| Throughput | > 1000 req/s | | ⬜ |

**Sign-off:** _________________ **Date:** _________

---

### 3. Security Scan ✅

- [ ] **Dependency vulnerability scan** - No critical vulnerabilities in dependencies
- [ ] **SAST (Static Analysis) passed** - Code scanned for security issues
- [ ] **DAST (Dynamic Analysis) passed** - Running application tested for vulnerabilities
- [ ] **Secrets scan passed** - No credentials or API keys in codebase
- [ ] **OWASP Top 10 reviewed** - Common vulnerabilities checked
- [ ] **Penetration test (if applicable)** - External security review completed

**Security Scan Results:**
| Tool | Status | Critical | High | Medium | Low |
|------|--------|----------|------|--------|-----|
| Snyk/Dependabot | | | | | |
| SonarQube | | | | | |
| OWASP ZAP | | | | | |

**Sign-off:** _________________ **Date:** _________

---

### 4. Documentation ✅

- [ ] **Release notes prepared** - User-facing changes documented
- [ ] **API documentation updated** - New/changed endpoints documented
- [ ] **README updated** - Setup instructions current
- [ ] **Changelog updated** - Technical changes recorded
- [ ] **Runbook updated** - Operational procedures documented
- [ ] **User documentation updated** - Help docs reflect new features

**Sign-off:** _________________ **Date:** _________

---

### 5. Rollback Plan ✅

- [ ] **Rollback procedure documented** - Step-by-step rollback instructions
- [ ] **Previous version tagged** - Can easily identify last stable release
- [ ] **Database migration reversible** - Down migrations tested
- [ ] **Feature flags configured** - Can disable new features without deploy
- [ ] **Rollback tested** - Verified rollback works in staging
- [ ] **Team notified of rollback procedure** - Everyone knows the process

**Rollback Procedure:**
1. _________________________________
2. _________________________________
3. _________________________________

**Sign-off:** _________________ **Date:** _________

---

### 6. Testing Verification ✅

- [ ] **All unit tests passing** - No test failures
- [ ] **Integration tests passing** - API and service tests green
- [ ] **E2E tests passing** - Critical user flows verified
- [ ] **Manual testing completed** - Exploratory testing done
- [ ] **Accessibility testing completed** - WCAG 2.1 AA compliance verified
- [ ] **Cross-browser testing** - Tested in supported browsers
- [ ] **Mobile testing** - Tested on mobile devices/viewports

**Sign-off:** _________________ **Date:** _________

---

### 7. Deployment Preparation ✅

- [ ] **Environment variables configured** - All env vars set for production
- [ ] **Database migrations ready** - Migrations tested and staged
- [ ] **Infrastructure changes applied** - Any required infra updates completed
- [ ] **Monitoring configured** - Alerts and dashboards ready
- [ ] **Deployment window scheduled** - Team aware of deployment time
- [ ] **Stakeholders notified** - Business teams informed of release

**Sign-off:** _________________ **Date:** _________

---

## Final Approval

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Development Lead | | | |
| QA Lead | | | |
| Product Owner | | | |
| DevOps/SRE | | | |

---

## Post-Release Tasks

- [ ] Monitor error rates and performance for 1 hour post-deploy
- [ ] Verify production functionality with smoke tests
- [ ] Notify stakeholders of successful release
- [ ] Close release ticket/milestone
- [ ] Update status page (if applicable)
- [ ] Schedule retrospective if major release

---

## Emergency Contacts

| Role | Name | Contact |
|------|------|---------|
| On-call Engineer | | |
| DevOps Lead | | |
| Product Owner | | |

---

*Last Updated: 2026-01-01*
