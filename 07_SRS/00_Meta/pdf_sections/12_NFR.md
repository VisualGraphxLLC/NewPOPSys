

---

# 12.1 Performance Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Performance
> **Source Documents**: SUPP-039 (Infrastructure, Performance & Security Requirements)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

---

## 12.1.1 Purpose

This section defines measurable performance requirements for NewPOPSys v1, including response time targets, throughput limits, and database query performance expectations. All requirements include specific targets and verification methods.

---

## 12.1.2 API Response Time Requirements

### 12.1.2.1 Response Time SLAs by Endpoint Category

| NFR-ID | Endpoint Category | p50 Target | p95 Target | p99 Target | Max Allowed | Priority |
|--------|-------------------|------------|------------|------------|-------------|----------|
| NFR-PERF-001 | Simple reads (GET list endpoints) | < 50ms | < 150ms | < 300ms | 1s | Must Have |
| NFR-PERF-002 | Complex reads (dashboard aggregations) | < 100ms | < 300ms | < 500ms | 2s | Must Have |
| NFR-PERF-003 | Write operations (create/update) | < 100ms | < 250ms | < 500ms | 2s | Must Have |
| NFR-PERF-004 | Photo upload initiation (presigned URL) | < 200ms | < 500ms | < 1s | 3s | Must Have |
| NFR-PERF-005 | Report generation (synchronous) | < 2s | < 5s | < 10s | 30s | Should Have |
| NFR-PERF-006 | Export generation (asynchronous) | N/A | N/A | N/A | 5 min | Should Have |

### 12.1.2.2 Verification Methods

| NFR-ID | Verification Method |
|--------|---------------------|
| NFR-PERF-001 through NFR-004 | Automated load testing with k6/Artillery in CI/CD pipeline |
| NFR-PERF-005 | Integration test suite with timing assertions |
| NFR-PERF-006 | Background job monitoring via BullMQ dashboard metrics |

---

## 12.1.3 Throughput Requirements

### 12.1.3.1 System Throughput Targets

| NFR-ID | Metric | Normal Target | Burst Capacity | Priority |
|--------|--------|---------------|----------------|----------|
| NFR-PERF-010 | API requests per second | 100 rps | 500 rps | Must Have |
| NFR-PERF-011 | Concurrent WebSocket connections | 200 | 500 | Should Have |
| NFR-PERF-012 | Photo uploads per minute | 50 | 200 | Must Have |
| NFR-PERF-013 | Database queries per second | 500 qps | 2,000 qps | Must Have |
| NFR-PERF-014 | Background jobs per minute | 100 | 500 | Should Have |

### 12.1.3.2 Concurrent User Capacity

| NFR-ID | Store Count | Concurrent Users | API Instances | Priority |
|--------|-------------|------------------|---------------|----------|
| NFR-PERF-015 | 100 stores | 10 users | 2 instances | Must Have (Pilot) |
| NFR-PERF-016 | 500 stores | 50 users | 2-4 instances | Must Have (v1) |
| NFR-PERF-017 | 2,000 stores | 200 users | 4-8 instances | Should Have (v1.1) |
| NFR-PERF-018 | 10,000 stores | 1,000 users | 8-16 instances | Nice to Have (v2) |

### 12.1.3.3 Verification Methods

| NFR-ID | Verification Method |
|--------|---------------------|
| NFR-PERF-010 through NFR-014 | Load testing with realistic traffic patterns |
| NFR-PERF-015 through NFR-018 | Staged pilot with progressive user onboarding |

---

## 12.1.4 Database Performance Requirements

### 12.1.4.1 Query Performance Targets

| NFR-ID | Query Type | Target Time | Index Strategy | Priority |
|--------|------------|-------------|----------------|----------|
| NFR-PERF-020 | Primary key lookup | < 1ms | B-tree on UUID PKs | Must Have |
| NFR-PERF-021 | Campaign list (filtered by tenant) | < 10ms | Composite on tenant_id + status | Must Have |
| NFR-PERF-022 | Store search by name/number | < 20ms | GIN index on name, store_number | Must Have |
| NFR-PERF-023 | Rollup aggregations (dashboards) | < 100ms | Materialized views with refresh | Should Have |
| NFR-PERF-024 | Full-text search | < 50ms | pg_trgm + GIN index | Should Have |

### 12.1.4.2 Connection Pool Configuration

| NFR-ID | Parameter | Value | Notes | Priority |
|--------|-----------|-------|-------|----------|
| NFR-PERF-025 | Min connections per instance | 5 | Warm pool for immediate use | Must Have |
| NFR-PERF-026 | Max connections per instance | 20 | Prevent connection exhaustion | Must Have |
| NFR-PERF-027 | Connection timeout | 5s | Fail fast on unavailability | Must Have |
| NFR-PERF-028 | Query timeout (default) | 30s | Prevent runaway queries | Must Have |

### 12.1.4.3 Verification Methods

- Query performance monitoring via `pg_stat_statements` extension
- Slow query logging for queries exceeding 100ms
- Explain plan analysis for all list/aggregation endpoints

---

## 12.1.5 Photo Processing Performance

### 12.1.5.1 Photo Pipeline Targets

| NFR-ID | Operation | Target Time | Implementation Strategy | Priority |
|--------|-----------|-------------|------------------------|----------|
| NFR-PERF-030 | Upload to S3 (10MB photo) | < 5s | Direct-to-S3 presigned URL | Must Have |
| NFR-PERF-031 | Thumbnail generation | < 2s | Lambda trigger on S3 upload | Must Have |
| NFR-PERF-032 | EXIF metadata extraction | < 500ms | Lambda in upload pipeline | Should Have |
| NFR-PERF-033 | CDN cache hit response | < 50ms | CloudFront edge caching | Must Have |

### 12.1.5.2 Photo Size Limits

| NFR-ID | Constraint | Value | Priority |
|--------|------------|-------|----------|
| NFR-PERF-034 | Maximum single photo size | 15 MB | Must Have |
| NFR-PERF-035 | Photos per survey submission | 20 max | Must Have |
| NFR-PERF-036 | Total upload per session | 100 MB | Should Have |

### 12.1.5.3 Verification Methods

- S3 upload timing instrumentation with OpenTelemetry
- Lambda CloudWatch metrics for processing duration
- CDN cache hit ratio monitoring via CloudFront analytics

---

## 12.1.6 Page Load Performance

### 12.1.6.1 Web Vitals Targets

| NFR-ID | Metric | Target | Priority |
|--------|--------|--------|----------|
| NFR-PERF-040 | Largest Contentful Paint (LCP) | < 2.5s | Must Have |
| NFR-PERF-041 | First Input Delay (FID) | < 100ms | Must Have |
| NFR-PERF-042 | Cumulative Layout Shift (CLS) | < 0.1 | Should Have |
| NFR-PERF-043 | Time to First Byte (TTFB) | < 600ms | Must Have |
| NFR-PERF-044 | First Contentful Paint (FCP) | < 1.8s | Should Have |

### 12.1.6.2 PWA Performance (Mobile Store App)

| NFR-ID | Metric | Target | Priority |
|--------|--------|--------|----------|
| NFR-PERF-045 | Initial app load (cold start) | < 3s on 4G | Must Have |
| NFR-PERF-046 | Cached app load (warm start) | < 1s | Must Have |
| NFR-PERF-047 | Survey form render time | < 500ms | Must Have |
| NFR-PERF-048 | Offline data sync (when reconnecting) | < 10s for 50 entries | Should Have |

### 12.1.6.3 Verification Methods

- Lighthouse CI integration in deployment pipeline
- Real User Monitoring (RUM) via Sentry Performance
- Synthetic monitoring for critical user journeys

---

## 12.1.7 Caching Strategy

### 12.1.7.1 Cache Layer Requirements

| NFR-ID | Cache Layer | TTL | Invalidation Strategy | Priority |
|--------|-------------|-----|----------------------|----------|
| NFR-PERF-050 | CDN (static assets) | 1 year (immutable) | Content-hash filenames | Must Have |
| NFR-PERF-051 | CDN (API responses) | 5 min | Cache-Control headers | Should Have |
| NFR-PERF-052 | Redis (session data) | 15 min sliding | Explicit invalidation on logout | Must Have |
| NFR-PERF-053 | Redis (list data) | 1 min | Invalidate on write | Should Have |
| NFR-PERF-054 | Application (reference data) | 5 min | Background refresh | Should Have |

### 12.1.7.2 Cache Hit Ratio Targets

| NFR-ID | Cache Layer | Target Hit Ratio | Priority |
|--------|-------------|------------------|----------|
| NFR-PERF-055 | CDN static assets | > 95% | Must Have |
| NFR-PERF-056 | Redis session cache | > 99% | Must Have |
| NFR-PERF-057 | API response cache | > 60% | Should Have |

---

## 12.1.8 Background Job Performance

### 12.1.8.1 Job Processing Targets

| NFR-ID | Job Type | Target Duration | Queue | Priority |
|--------|----------|-----------------|-------|----------|
| NFR-PERF-060 | Email notification send | < 2s | default | Must Have |
| NFR-PERF-061 | Webhook delivery attempt | < 5s | default | Must Have |
| NFR-PERF-062 | Thumbnail generation | < 10s | default | Must Have |
| NFR-PERF-063 | CSV export (1000 rows) | < 30s | long | Should Have |
| NFR-PERF-064 | Full export bundle | < 5 min | long | Should Have |
| NFR-PERF-065 | Media purge job (per campaign) | < 2 min | long | Should Have |

### 12.1.8.2 Queue Depth Limits

| NFR-ID | Queue | Max Depth (Alert) | Max Depth (Critical) | Priority |
|--------|-------|-------------------|---------------------|----------|
| NFR-PERF-066 | Default queue | 1,000 jobs | 5,000 jobs | Must Have |
| NFR-PERF-067 | Long-running queue | 100 jobs | 500 jobs | Should Have |
| NFR-PERF-068 | Dead-letter queue | 10 jobs | 50 jobs | Must Have |

---

## 12.1.9 Monitoring and Alerting

### 12.1.9.1 Performance Monitoring Requirements

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-PERF-070 | Request tracing | OpenTelemetry with request ID correlation | Must Have |
| NFR-PERF-071 | Performance dashboards | CloudWatch or Grafana with key metrics | Must Have |
| NFR-PERF-072 | Anomaly detection | Automated alerts for p95 degradation | Should Have |
| NFR-PERF-073 | Real-time error tracking | Sentry integration with performance context | Must Have |

### 12.1.9.2 Alert Thresholds

| NFR-ID | Metric | Warning Threshold | Critical Threshold | Priority |
|--------|--------|-------------------|-------------------|----------|
| NFR-PERF-074 | API p95 response time | > 500ms | > 2s | Must Have |
| NFR-PERF-075 | Error rate | > 1% | > 5% | Must Have |
| NFR-PERF-076 | Database connection pool usage | > 70% | > 90% | Must Have |
| NFR-PERF-077 | CPU utilization (container) | > 70% | > 90% | Must Have |
| NFR-PERF-078 | Memory utilization (container) | > 80% | > 95% | Must Have |

---

## 12.1.10 Cross-References

| Reference | Description |
|-----------|-------------|
| SUPP-039 | Authoritative infrastructure and performance requirements |
| SUPP-012 | Technology stack selections |
| Section 3.3 | Technology Stack documentation |
| Section 12.4 | Scalability requirements |
| Section 12.5 | Availability requirements |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Performance Requirements*


---

# 12.2 Security Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Security
> **Source Documents**: SUPP-039 (Infrastructure, Performance & Security Requirements), SUPP-003 (RBAC)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

---

## 12.2.1 Purpose

This section defines security requirements for NewPOPSys v1, covering authentication, authorization, data protection, compliance, and security operations. All requirements include specific implementation targets and verification methods.

---

## 12.2.2 Authentication Requirements

### 12.2.2.1 Primary Authentication

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-001 | Web application authentication | Server-side session cookies | Must Have |
| NFR-SEC-002 | API authentication | JWT tokens with RS256 signing | Must Have |
| NFR-SEC-003 | Access token lifetime | 15 minutes | Must Have |
| NFR-SEC-004 | Refresh token lifetime | 7 days | Must Have |
| NFR-SEC-005 | Session storage | Redis-backed with sliding expiration | Must Have |

### 12.2.2.2 Multi-Factor Authentication

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-010 | MFA for admin roles | TOTP required for PSP Admin, Platform Admin, Brand Admin | Must Have |
| NFR-SEC-011 | MFA for store users | Optional, user-configurable | Should Have |
| NFR-SEC-012 | MFA recovery | Backup codes (10 single-use codes) | Must Have |
| NFR-SEC-013 | MFA enrollment grace period | 7 days for new admin accounts | Should Have |

### 12.2.2.3 Password Policy

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-020 | Minimum password length | 12 characters | Must Have |
| NFR-SEC-021 | Password complexity | At least 1 uppercase, 1 lowercase, 1 number | Must Have |
| NFR-SEC-022 | Password history | Prevent reuse of last 5 passwords | Should Have |
| NFR-SEC-023 | Password hashing | Argon2id or bcrypt (cost factor 12) | Must Have |
| NFR-SEC-024 | Compromised password check | Integration with HaveIBeenPwned API | Nice to Have |

### 12.2.2.4 Account Lockout

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-025 | Failed login threshold | 5 consecutive failures | Must Have |
| NFR-SEC-026 | Lockout duration | 15 minutes (progressive) | Must Have |
| NFR-SEC-027 | Lockout notification | Email notification to user | Should Have |
| NFR-SEC-028 | Admin unlock capability | Manual unlock via admin console | Must Have |

### 12.2.2.5 Verification Methods

- Automated security testing for auth flows in CI/CD
- Penetration testing before launch
- Session hijacking prevention verification

---

## 12.2.3 Authorization Requirements

### 12.2.3.1 Role-Based Access Control (RBAC)

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-030 | Permission enforcement | Server-side RBAC at API layer | Must Have |
| NFR-SEC-031 | Role hierarchy | Defined role inheritance model | Must Have |
| NFR-SEC-032 | Permission granularity | Resource + action level (e.g., campaign:read) | Must Have |
| NFR-SEC-033 | Dynamic permission loading | No hardcoded permissions in UI | Must Have |

### 12.2.3.2 Tenant Isolation

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-035 | Data isolation | Tenant ID enforced on all queries | Must Have |
| NFR-SEC-036 | Cross-tenant prevention | Middleware validates tenant context | Must Have |
| NFR-SEC-037 | Tenant-scoped URLs | All resources include tenant context | Must Have |
| NFR-SEC-038 | Audit of cross-tenant attempts | Log and alert on violations | Must Have |

### 12.2.3.3 API Authorization

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-040 | Integration API keys | Hashed storage, scoped permissions | Must Have |
| NFR-SEC-041 | API key rotation | Support for key rotation without downtime | Should Have |
| NFR-SEC-042 | Webhook signatures | HMAC-SHA256 with shared secret | Must Have |
| NFR-SEC-043 | Idempotency keys | Required for webhook processing | Must Have |

### 12.2.3.4 Verification Methods

- Authorization bypass testing (horizontal and vertical)
- Automated RBAC matrix validation
- Tenant isolation penetration testing

---

## 12.2.4 Data Protection Requirements

### 12.2.4.1 Encryption at Rest

| NFR-ID | Data Type | Encryption Method | Priority |
|--------|-----------|-------------------|----------|
| NFR-SEC-050 | Database (RDS PostgreSQL) | AES-256 via RDS encryption | Must Have |
| NFR-SEC-051 | Object storage (S3) | SSE-S3 or SSE-KMS | Must Have |
| NFR-SEC-052 | Secrets and credentials | AWS KMS envelope encryption | Must Have |
| NFR-SEC-053 | Database backups | Encrypted snapshots | Must Have |
| NFR-SEC-054 | Application logs | CloudWatch encryption enabled | Must Have |

### 12.2.4.2 Encryption in Transit

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-055 | HTTPS enforcement | TLS 1.3 minimum, HTTP redirects to HTTPS | Must Have |
| NFR-SEC-056 | Database connections | TLS required for all connections | Must Have |
| NFR-SEC-057 | Internal service communication | mTLS or signed JWTs | Should Have |
| NFR-SEC-058 | S3 access | HTTPS-only bucket policy | Must Have |

### 12.2.4.3 Sensitive Data Handling

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-060 | PII field identification | Annotated in data model | Must Have |
| NFR-SEC-061 | PII in logs | Automatically redacted | Must Have |
| NFR-SEC-062 | PII in error messages | Never exposed in API responses | Must Have |
| NFR-SEC-063 | Sensitive data in URLs | Never include passwords or tokens | Must Have |

### 12.2.4.4 Verification Methods

- TLS certificate validation in monitoring
- Encryption verification via AWS Config rules
- Log audit for PII leakage

---

## 12.2.5 OWASP Top 10 Mitigation

### 12.2.5.1 Security Controls Matrix

| NFR-ID | OWASP Risk | Mitigation Strategy | Priority |
|--------|------------|---------------------|----------|
| NFR-SEC-070 | A01: Broken Access Control | RBAC at API layer, tenant isolation, authorization middleware | Must Have |
| NFR-SEC-071 | A02: Cryptographic Failures | TLS 1.3, AES-256 at rest, no sensitive data in URLs | Must Have |
| NFR-SEC-072 | A03: Injection | Parameterized queries via Drizzle ORM, input validation | Must Have |
| NFR-SEC-073 | A04: Insecure Design | Threat modeling, secure defaults, principle of least privilege | Must Have |
| NFR-SEC-074 | A05: Security Misconfiguration | Infrastructure as Code, security scanning in CI/CD | Must Have |
| NFR-SEC-075 | A06: Vulnerable Components | Dependabot alerts, regular patching, SCA scanning | Must Have |
| NFR-SEC-076 | A07: Auth Failures | Rate limiting, account lockout, strong password policy | Must Have |
| NFR-SEC-077 | A08: Data Integrity Failures | Signed deployments, audit logging, HMAC webhooks | Must Have |
| NFR-SEC-078 | A09: Logging Failures | Centralized logging, anomaly detection, log integrity | Must Have |
| NFR-SEC-079 | A10: SSRF | URL validation, egress filtering, allowlists | Must Have |

### 12.2.5.2 Verification Methods

- OWASP ZAP automated scanning in CI/CD
- Manual penetration testing quarterly
- Dependency vulnerability scanning with Snyk/Dependabot

---

## 12.2.6 Audit Logging Requirements

### 12.2.6.1 Audit Event Categories

| NFR-ID | Event Category | Events Captured | Priority |
|--------|----------------|-----------------|----------|
| NFR-SEC-080 | Authentication | Login, logout, failed attempts, MFA events | Must Have |
| NFR-SEC-081 | Authorization | Permission denied, role changes, access escalation | Must Have |
| NFR-SEC-082 | Data access | Read of sensitive resources, exports, bulk operations | Must Have |
| NFR-SEC-083 | Data modification | Create, update, delete of business entities | Must Have |
| NFR-SEC-084 | Administrative | User management, configuration changes, impersonation | Must Have |
| NFR-SEC-085 | System events | Backup, purge, integration sync | Should Have |

### 12.2.6.2 Audit Log Fields

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-086 | Timestamp | UTC with millisecond precision | Must Have |
| NFR-SEC-087 | Actor identification | User ID, role, IP address, user agent | Must Have |
| NFR-SEC-088 | Action details | Resource type, resource ID, action type | Must Have |
| NFR-SEC-089 | Request correlation | Request ID for distributed tracing | Must Have |
| NFR-SEC-090 | Tenant context | Tenant ID for multi-tenant isolation | Must Have |

### 12.2.6.3 Audit Log Protection

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-091 | Log immutability | Append-only, no deletion capability | Must Have |
| NFR-SEC-092 | Log retention | 2 years minimum | Must Have |
| NFR-SEC-093 | Log access control | Separate from application permissions | Must Have |
| NFR-SEC-094 | Log integrity | Tamper detection via checksums | Should Have |

---

## 12.2.7 Security Operations

### 12.2.7.1 Vulnerability Management

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-100 | Dependency scanning | Automated in CI/CD via Dependabot/Snyk | Must Have |
| NFR-SEC-101 | Container scanning | Image vulnerability scanning before deployment | Must Have |
| NFR-SEC-102 | Critical vulnerability SLA | Patch within 24 hours | Must Have |
| NFR-SEC-103 | High vulnerability SLA | Patch within 7 days | Must Have |
| NFR-SEC-104 | Medium vulnerability SLA | Patch within 30 days | Should Have |

### 12.2.7.2 Penetration Testing

| NFR-ID | Testing Phase | Timing | Scope | Priority |
|--------|---------------|--------|-------|----------|
| NFR-SEC-105 | Pre-launch | Before beta deployment | Full application + infrastructure | Must Have |
| NFR-SEC-106 | Quarterly | Every 3 months | Critical paths + new features | Should Have |
| NFR-SEC-107 | Annual | Yearly | Full scope + social engineering | Nice to Have |

### 12.2.7.3 Security Monitoring

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-110 | WAF deployment | AWS WAF with OWASP rule set | Must Have |
| NFR-SEC-111 | Rate limiting | Per-endpoint and per-IP limits | Must Have |
| NFR-SEC-112 | Anomaly detection | Automated alerts for unusual patterns | Should Have |
| NFR-SEC-113 | Failed auth monitoring | Alert on brute force patterns | Must Have |

---

## 12.2.8 Compliance Requirements

### 12.2.8.1 Regulatory Compliance

| NFR-ID | Standard | Applicability | v1 Status | Priority |
|--------|----------|---------------|-----------|----------|
| NFR-SEC-120 | GDPR | EU store/customer data | Basic compliance | Must Have |
| NFR-SEC-121 | CCPA | California stores | Basic compliance | Must Have |
| NFR-SEC-122 | SOC 2 Type II | Enterprise customers | Future (v2+) | Nice to Have |
| NFR-SEC-123 | PCI DSS | N/A (no payment processing) | Not applicable | N/A |

### 12.2.8.2 GDPR Specific Requirements

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-SEC-125 | Right to access | Data export functionality | Must Have |
| NFR-SEC-126 | Right to deletion | Data purge workflow | Must Have |
| NFR-SEC-127 | Data portability | Standard export formats (CSV, JSON) | Should Have |
| NFR-SEC-128 | Consent management | Consent tracking for communications | Should Have |
| NFR-SEC-129 | Privacy by design | Data minimization, purpose limitation | Must Have |

### 12.2.8.3 Verification Methods

- Compliance checklist review
- Third-party audit (for SOC 2)
- Privacy impact assessment

---

## 12.2.9 Incident Response

### 12.2.9.1 Security Incident Classification

| NFR-ID | Severity | Description | Response Time | Priority |
|--------|----------|-------------|---------------|----------|
| NFR-SEC-130 | Critical | Active breach, data exfiltration | Immediate (< 1 hour) | Must Have |
| NFR-SEC-131 | High | Vulnerability exploitation attempt | < 4 hours | Must Have |
| NFR-SEC-132 | Medium | Suspicious activity, policy violation | < 24 hours | Should Have |
| NFR-SEC-133 | Low | Security misconfiguration, audit finding | < 7 days | Should Have |

### 12.2.9.2 Incident Response Requirements

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SEC-135 | Incident runbook | Documented response procedures | Must Have |
| NFR-SEC-136 | Escalation path | Defined escalation contacts and thresholds | Must Have |
| NFR-SEC-137 | Breach notification | Process for regulatory notification (GDPR 72hr) | Must Have |
| NFR-SEC-138 | Post-incident review | Blameless retrospective within 7 days | Should Have |

---

## 12.2.10 Cross-References

| Reference | Description |
|-----------|-------------|
| SUPP-039 | Infrastructure and security requirements source |
| SUPP-003 | RBAC and permissions matrix |
| SUPP-031 | Supportability policies and impersonation |
| Section 4.2 | Permission Matrix documentation |
| Section 4.3 | Authentication Flows documentation |
| Section 12.6 | Data Retention requirements |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Security Requirements*


---

# 12.3 Accessibility Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Accessibility
> **Source Documents**: SUPP-038 (Section 508 Accessibility Scaffold)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

---

## 12.3.1 Purpose

This section defines accessibility requirements for NewPOPSys v1, ensuring the platform is usable by people with disabilities and compliant with federal accessibility mandates. The v1 release establishes foundational patterns enabling full WCAG 2.1 Level AA compliance in v1.1.

---

## 12.3.2 Compliance Targets

### 12.3.2.1 Accessibility Standards

| NFR-ID | Standard | Target Level | v1 Status | v1.1 Status | Priority |
|--------|----------|--------------|-----------|-------------|----------|
| NFR-ACC-001 | WCAG 2.1 | Level AA | Scaffold | Full Compliance | Must Have |
| NFR-ACC-002 | Section 508 | Full | Scaffold | Full Compliance | Must Have |
| NFR-ACC-003 | WCAG 2.1 | Level AAA | N/A | Partial | Nice to Have |

### 12.3.2.2 Target Audience

| NFR-ID | User Group | Accommodations | Priority |
|--------|------------|----------------|----------|
| NFR-ACC-005 | Visual impairments | Screen reader compatibility, high contrast | Must Have |
| NFR-ACC-006 | Motor impairments | Full keyboard navigation, large touch targets | Must Have |
| NFR-ACC-007 | Cognitive impairments | Clear language, consistent navigation | Should Have |
| NFR-ACC-008 | Hearing impairments | Text alternatives for audio content | Should Have |

---

## 12.3.3 Semantic HTML Requirements

### 12.3.3.1 Document Structure

| NFR-ID | Requirement | Implementation | Verification | Priority |
|--------|-------------|----------------|--------------|----------|
| NFR-ACC-010 | Semantic elements | Use `<header>`, `<nav>`, `<main>`, `<footer>`, `<section>`, `<article>` | Automated audit | Must Have |
| NFR-ACC-011 | Heading hierarchy | `<h1>` to `<h6>` in logical order, no skips | Automated audit | Must Have |
| NFR-ACC-012 | Landmark regions | All pages have identifiable main content area | Screen reader test | Must Have |
| NFR-ACC-013 | Semantic lists | Use `<ul>`, `<ol>` for list content | Semantic validation | Must Have |
| NFR-ACC-014 | Data tables | Use `<table>` with `<th>`, `<caption>` for tabular data | Table structure audit | Must Have |

### 12.3.3.2 Page Layout Template

```tsx
// Required page structure for all screens
<PageLayout>
  <header role="banner">...</header>
  <nav role="navigation">...</nav>
  <main role="main" id="main-content">...</main>
  <footer role="contentinfo">...</footer>
</PageLayout>
```

### 12.3.3.3 Verification Methods

- axe-core automated testing in CI/CD
- HTML validation via W3C validator
- Manual semantic structure review

---

## 12.3.4 Keyboard Navigation Requirements

### 12.3.4.1 Core Keyboard Requirements

| NFR-ID | Requirement | Implementation | Verification | Priority |
|--------|-------------|----------------|--------------|----------|
| NFR-ACC-020 | Tab order | Native focus order, avoid `tabindex > 0` | Manual tab test | Must Have |
| NFR-ACC-021 | Focus visibility | Visible focus indicator (never `outline: none` alone) | Visual inspection | Must Have |
| NFR-ACC-022 | Skip link | First focusable element: "Skip to main content" | Screen reader test | Must Have |
| NFR-ACC-023 | Modal focus trap | Modals contain focus; Escape closes | Keyboard-only test | Must Have |
| NFR-ACC-024 | No keyboard traps | All elements keyboard-escapable | Keyboard navigation test | Must Have |
| NFR-ACC-025 | Arrow key navigation | Implemented for tabs, menus, listboxes | Component test | Should Have |

### 12.3.4.2 Focus Indicator Standards

| NFR-ID | Element Type | Focus Style | Priority |
|--------|--------------|-------------|----------|
| NFR-ACC-026 | Interactive elements | 2px ring with 2px offset | Must Have |
| NFR-ACC-027 | Form inputs | Visible border change + ring | Must Have |
| NFR-ACC-028 | Links | Underline + color change or ring | Must Have |
| NFR-ACC-029 | Custom components | Equivalent visible focus | Must Have |

### 12.3.4.3 Keyboard Shortcuts (v1.1)

| NFR-ID | Shortcut | Action | Priority |
|--------|----------|--------|----------|
| NFR-ACC-030 | `/` | Focus search field | Nice to Have |
| NFR-ACC-031 | `?` | Open keyboard shortcuts help | Nice to Have |
| NFR-ACC-032 | `Escape` | Close modals, cancel operations | Must Have |

---

## 12.3.5 Form Accessibility Requirements

### 12.3.5.1 Form Field Requirements

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-ACC-040 | Label association | Every `<input>` has associated `<label>` via `htmlFor` | Must Have |
| NFR-ACC-041 | Error identification | Errors linked via `aria-describedby` | Must Have |
| NFR-ACC-042 | Required fields | `aria-required="true"` + visual indicator | Must Have |
| NFR-ACC-043 | Error state | `aria-invalid="true"` when validation fails | Must Have |
| NFR-ACC-044 | Input purpose | `autocomplete` attributes for user data | Should Have |
| NFR-ACC-045 | Error prevention | Confirmation for destructive actions | Must Have |

### 12.3.5.2 Form Pattern Template

```tsx
<div>
  <label htmlFor="store-name" id="store-name-label">
    Store Name <span aria-hidden="true">*</span>
  </label>
  <input
    id="store-name"
    aria-labelledby="store-name-label"
    aria-describedby={error ? "store-name-error" : undefined}
    aria-required="true"
    aria-invalid={!!error}
  />
  {error && (
    <span id="store-name-error" role="alert">
      {error}
    </span>
  )}
</div>
```

### 12.3.5.3 Verification Methods

- Form association validation via axe-core
- Screen reader announcement testing
- Error message accessibility review

---

## 12.3.6 Color and Contrast Requirements

### 12.3.6.1 Contrast Ratio Requirements

| NFR-ID | Element Type | Minimum Ratio | WCAG Criterion | Priority |
|--------|--------------|---------------|----------------|----------|
| NFR-ACC-050 | Normal text (< 18pt) | 4.5:1 | 1.4.3 AA | Must Have |
| NFR-ACC-051 | Large text (>= 18pt or 14pt bold) | 3:1 | 1.4.3 AA | Must Have |
| NFR-ACC-052 | UI components (borders, icons) | 3:1 | 1.4.11 AA | Must Have |
| NFR-ACC-053 | Focus indicators | 3:1 | 1.4.11 AA | Must Have |
| NFR-ACC-054 | Enhanced contrast (AAA) | 7:1 | 1.4.6 AAA | Nice to Have |

### 12.3.6.2 Color Independence

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-ACC-055 | Color not sole indicator | Use icons, text, patterns in addition to color | Must Have |
| NFR-ACC-056 | Status indicators | Icon + text + color for all statuses | Must Have |
| NFR-ACC-057 | Error states | Red + icon + text description | Must Have |
| NFR-ACC-058 | Links in text | Underline or non-color visual distinction | Must Have |

### 12.3.6.3 Accessible Color Palette

| Token | Value | Usage | Contrast on White |
|-------|-------|-------|-------------------|
| `--text-primary` | #1f2937 (gray-800) | Body text | 12.6:1 |
| `--text-secondary` | #4b5563 (gray-600) | Secondary text | 7.0:1 |
| `--text-on-primary` | #ffffff | Text on primary buttons | 4.5:1 (on blue-600) |
| `--error-text` | #991b1b (red-800) | Error messages | 9.4:1 |
| `--success-text` | #166534 (green-800) | Success messages | 7.1:1 |

### 12.3.6.4 Verification Methods

- Automated contrast checker in CI/CD
- Colorblind simulation testing
- Design review for color-only indicators

---

## 12.3.7 Interactive Component Patterns

### 12.3.7.1 ARIA Patterns by Component

| NFR-ID | Component | ARIA Pattern | Keyboard Support | Priority |
|--------|-----------|--------------|------------------|----------|
| NFR-ACC-060 | Buttons | `<button>` or `role="button"` + `tabindex="0"` | Enter, Space | Must Have |
| NFR-ACC-061 | Links | `<a href="...">` with descriptive text | Enter | Must Have |
| NFR-ACC-062 | Modals | `role="dialog"` + `aria-modal="true"` + `aria-labelledby` | Escape to close | Must Have |
| NFR-ACC-063 | Tabs | `role="tablist/tab/tabpanel"` | Arrow keys | Must Have |
| NFR-ACC-064 | Dropdowns | `role="listbox"` or native `<select>` | Arrow keys, Enter | Must Have |
| NFR-ACC-065 | Alerts | `role="alert"` for important messages | Auto-announced | Must Have |
| NFR-ACC-066 | Loading states | `aria-live="polite"` + `aria-busy` | Announce completion | Should Have |
| NFR-ACC-067 | Progress bars | `role="progressbar"` + `aria-valuenow` | Screen reader value | Should Have |

### 12.3.7.2 Prohibited Patterns

| NFR-ID | Prohibited Pattern | Correct Alternative | Priority |
|--------|-------------------|---------------------|----------|
| NFR-ACC-068 | `<div>` as button | `<button>` element | Must Have |
| NFR-ACC-069 | "Click here" link text | Descriptive link text | Must Have |
| NFR-ACC-070 | Icon-only buttons without labels | `aria-label` on button | Must Have |
| NFR-ACC-071 | Auto-playing media | User-initiated playback | Must Have |

---

## 12.3.8 Image and Media Requirements

### 12.3.8.1 Alternative Text

| NFR-ID | Image Type | Alt Text Requirement | Priority |
|--------|------------|---------------------|----------|
| NFR-ACC-080 | Informative images | Descriptive alt text | Must Have |
| NFR-ACC-081 | Decorative images | `alt=""` or `role="presentation"` | Must Have |
| NFR-ACC-082 | Complex images (charts) | `aria-describedby` linking to text description | Should Have |
| NFR-ACC-083 | Icons in buttons | `aria-label` on parent button | Must Have |

### 12.3.8.2 Media Alternatives

| NFR-ID | Media Type | Alternative Required | Priority |
|--------|------------|---------------------|----------|
| NFR-ACC-085 | Video content | Captions (v1.1) | Should Have |
| NFR-ACC-086 | Audio content | Transcript (v1.1) | Should Have |
| NFR-ACC-087 | Animated content | Pause/stop control | Should Have |

---

## 12.3.9 Mobile/PWA Accessibility

### 12.3.9.1 Touch Target Requirements

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-ACC-090 | Minimum touch target | 44x44 CSS pixels | Must Have |
| NFR-ACC-091 | Touch target spacing | 8px minimum between targets | Should Have |
| NFR-ACC-092 | Touch target padding | 12px internal padding | Should Have |

### 12.3.9.2 Responsive Accessibility

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-ACC-095 | Text resize | Content readable at 200% zoom | Must Have |
| NFR-ACC-096 | Orientation | Works in portrait and landscape | Must Have |
| NFR-ACC-097 | Motion preferences | Respect `prefers-reduced-motion` | Must Have |
| NFR-ACC-098 | Reflow | No horizontal scroll at 320px width | Should Have |

### 12.3.9.3 Motion Preference Pattern

```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## 12.3.10 Screen Reader Support

### 12.3.10.1 v1 Screen Reader Compatibility

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-ACC-100 | Basic screen reader support | Semantic HTML, ARIA labels | Must Have |
| NFR-ACC-101 | Form field announcements | Associated labels, error descriptions | Must Have |
| NFR-ACC-102 | Dynamic content updates | `aria-live` regions for updates | Should Have |
| NFR-ACC-103 | Navigation announcements | Page title updates, route changes | Should Have |

### 12.3.10.2 v1.1 Screen Reader Testing Matrix

| NFR-ID | Screen Reader | Platform | v1.1 Target | Priority |
|--------|---------------|----------|-------------|----------|
| NFR-ACC-105 | VoiceOver | iOS/macOS | Full testing pass | Should Have |
| NFR-ACC-106 | NVDA | Windows | Full testing pass | Should Have |
| NFR-ACC-107 | JAWS | Windows | Full testing pass | Nice to Have |
| NFR-ACC-108 | TalkBack | Android | Full testing pass | Should Have |

---

## 12.3.11 Testing and Validation

### 12.3.11.1 Automated Testing Requirements

| NFR-ID | Tool | Integration Point | Scope | Priority |
|--------|------|------------------|-------|----------|
| NFR-ACC-110 | axe-core | CI/CD pipeline | All pages | Must Have |
| NFR-ACC-111 | Lighthouse | Deployment check | Performance + accessibility | Must Have |
| NFR-ACC-112 | Pa11y | Pre-release | Full application | Should Have |

### 12.3.11.2 Manual Testing Requirements

| NFR-ID | Test Type | Frequency | v1 Status | Priority |
|--------|-----------|-----------|-----------|----------|
| NFR-ACC-115 | Keyboard-only navigation | Every sprint | Required | Must Have |
| NFR-ACC-116 | Focus order verification | Every sprint | Required | Must Have |
| NFR-ACC-117 | Color contrast audit | Monthly | Required | Must Have |
| NFR-ACC-118 | 200% zoom test | Monthly | Required | Must Have |
| NFR-ACC-119 | Screen reader testing | Quarterly (v1.1) | Deferred | Should Have |

### 12.3.11.3 CI/CD Gate

```yaml
- name: Accessibility Check
  run: |
    npx axe-core --tags wcag2a,wcag2aa
    # Fail on critical/serious issues
```

---

## 12.3.12 Documentation Requirements (v1.1)

### 12.3.12.1 Compliance Documentation

| NFR-ID | Document | Purpose | v1.1 Target | Priority |
|--------|----------|---------|-------------|----------|
| NFR-ACC-120 | VPAT | Voluntary Product Accessibility Template | Required | Should Have |
| NFR-ACC-121 | Accessibility Statement | Public accessibility commitment | Required | Should Have |
| NFR-ACC-122 | Keyboard shortcuts guide | User documentation | Recommended | Nice to Have |
| NFR-ACC-123 | Screen reader guide | User documentation | Recommended | Nice to Have |

---

## 12.3.13 Cross-References

| Reference | Description |
|-----------|-------------|
| SUPP-038 | Section 508 Accessibility Scaffold source document |
| SUPP-036 | Screen and interface design patterns |
| [WCAG 2.1 Guidelines](https://www.w3.org/TR/WCAG21/) | Full W3C specification |
| [Section 508 Standards](https://www.access-board.gov/ict/) | Federal accessibility requirements |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Accessibility Requirements*


---

# 12.4 Scalability Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Scalability
> **Source Documents**: SUPP-039 (Infrastructure, Performance & Security Requirements), SUPP-012 (Technology Selections)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

---

## 12.4.1 Purpose

This section defines scalability requirements for NewPOPSys v1, covering horizontal and vertical scaling strategies, load balancing, caching, and capacity planning. Requirements ensure the platform can grow from pilot scale to enterprise deployments.

---

## 12.4.2 Scaling Targets

### 12.4.2.1 Capacity Milestones

| NFR-ID | Milestone | Store Count | Concurrent Users | Monthly Cost Target | Priority |
|--------|-----------|-------------|------------------|---------------------|----------|
| NFR-SCL-001 | Pilot | 100 stores | 10 users | $500/month | Must Have |
| NFR-SCL-002 | v1 Launch | 500 stores | 50 users | $1,000/month | Must Have |
| NFR-SCL-003 | v1.1 Growth | 2,000 stores | 200 users | $2,500/month | Should Have |
| NFR-SCL-004 | v2 Enterprise | 10,000 stores | 1,000 users | $6,000/month | Nice to Have |

### 12.4.2.2 Scaling Triggers

| NFR-ID | Metric | Scale-Up Trigger | Scale-Down Trigger | Priority |
|--------|--------|------------------|-------------------|----------|
| NFR-SCL-005 | CPU utilization | > 70% for 5 min | < 30% for 15 min | Must Have |
| NFR-SCL-006 | Memory utilization | > 80% for 5 min | < 40% for 15 min | Must Have |
| NFR-SCL-007 | Request latency (p95) | > 500ms for 5 min | N/A | Must Have |
| NFR-SCL-008 | Queue depth | > 1,000 jobs | < 100 jobs | Should Have |

---

## 12.4.3 Horizontal Scaling

### 12.4.3.1 Application Layer Scaling

| NFR-ID | Component | Min Instances | Max Instances | Scaling Strategy | Priority |
|--------|-----------|---------------|---------------|------------------|----------|
| NFR-SCL-010 | API containers | 2 | 16 | CPU/memory-based auto-scaling | Must Have |
| NFR-SCL-011 | Worker containers | 2 | 8 | Queue depth-based scaling | Must Have |
| NFR-SCL-012 | WebSocket servers | 2 | 8 | Connection count scaling | Should Have |

### 12.4.3.2 Auto-Scaling Configuration

| NFR-ID | Parameter | Value | Notes | Priority |
|--------|-----------|-------|-------|----------|
| NFR-SCL-015 | Scale-up cooldown | 60 seconds | Prevent thrashing | Must Have |
| NFR-SCL-016 | Scale-down cooldown | 300 seconds | Ensure stability | Must Have |
| NFR-SCL-017 | Desired capacity buffer | +1 instance | Headroom for traffic spikes | Should Have |
| NFR-SCL-018 | Health check interval | 30 seconds | Detect unhealthy instances | Must Have |

### 12.4.3.3 Stateless Design Requirements

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-SCL-020 | Session externalization | Redis-backed sessions | Must Have |
| NFR-SCL-021 | No local file storage | S3 for all file operations | Must Have |
| NFR-SCL-022 | Shared cache layer | Redis for application cache | Must Have |
| NFR-SCL-023 | Idempotent operations | Request ID tracking | Must Have |

---

## 12.4.4 Vertical Scaling

### 12.4.4.1 Database Vertical Scaling Path

| NFR-ID | Instance Size | vCPU | Memory | Max Connections | Store Capacity | Priority |
|--------|---------------|------|--------|-----------------|----------------|----------|
| NFR-SCL-030 | db.t3.medium | 2 | 4 GB | 100 | 100 stores | Must Have (Pilot) |
| NFR-SCL-031 | db.r6g.large | 2 | 16 GB | 200 | 500 stores | Must Have (v1) |
| NFR-SCL-032 | db.r6g.xlarge | 4 | 32 GB | 400 | 2,000 stores | Should Have |
| NFR-SCL-033 | db.r6g.2xlarge | 8 | 64 GB | 800 | 10,000 stores | Nice to Have |

### 12.4.4.2 Container Sizing

| NFR-ID | Container Type | vCPU | Memory | Use Case | Priority |
|--------|----------------|------|--------|----------|----------|
| NFR-SCL-035 | API (standard) | 1 | 2 GB | Normal operations | Must Have |
| NFR-SCL-036 | API (high-load) | 2 | 4 GB | Campaign launch periods | Should Have |
| NFR-SCL-037 | Worker (standard) | 0.5 | 1 GB | Background jobs | Must Have |
| NFR-SCL-038 | Worker (export) | 2 | 4 GB | Large export jobs | Should Have |

---

## 12.4.5 Database Scaling Strategy

### 12.4.5.1 Read Replica Configuration

| NFR-ID | Requirement | Implementation | Activation Threshold | Priority |
|--------|-------------|----------------|---------------------|----------|
| NFR-SCL-040 | Read replica | RDS read replica in same region | > 500 stores | Should Have |
| NFR-SCL-041 | Read replica routing | Application-level routing for read queries | > 500 stores | Should Have |
| NFR-SCL-042 | Replica lag monitoring | Alert if lag > 10 seconds | Always | Must Have |
| NFR-SCL-043 | Cross-region replica | DR region read replica | > 2,000 stores | Nice to Have |

### 12.4.5.2 Connection Pooling

| NFR-ID | Requirement | Value | Notes | Priority |
|--------|-------------|-------|-------|----------|
| NFR-SCL-045 | Pool size per instance | 20 connections | Based on (vCPU * 2) + 2 | Must Have |
| NFR-SCL-046 | Total pool limit | 80% of max_connections | Reserve for admin | Must Have |
| NFR-SCL-047 | Connection timeout | 5 seconds | Fail fast | Must Have |
| NFR-SCL-048 | Idle timeout | 30 seconds | Release unused connections | Should Have |

### 12.4.5.3 Query Optimization

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-SCL-050 | Index coverage | All filtered columns indexed | Must Have |
| NFR-SCL-051 | Query planning | EXPLAIN ANALYZE for slow queries | Must Have |
| NFR-SCL-052 | Materialized views | Dashboard aggregations | Should Have |
| NFR-SCL-053 | Partition strategy | Time-based for audit logs (v1.1) | Nice to Have |

---

## 12.4.6 Caching Strategy

### 12.4.6.1 Cache Layer Architecture

| NFR-ID | Cache Layer | Technology | Scope | Priority |
|--------|-------------|------------|-------|----------|
| NFR-SCL-060 | Browser cache | HTTP Cache-Control | Static assets | Must Have |
| NFR-SCL-061 | CDN cache | CloudFront | Static assets, signed URLs | Must Have |
| NFR-SCL-062 | Application cache | Redis | Session, reference data | Must Have |
| NFR-SCL-063 | Query cache | Redis | Frequently accessed lists | Should Have |
| NFR-SCL-064 | Database cache | PostgreSQL shared_buffers | Query results | Must Have |

### 12.4.6.2 Cache Configuration

| NFR-ID | Cache Type | TTL | Invalidation | Priority |
|--------|------------|-----|--------------|----------|
| NFR-SCL-065 | Static assets (CDN) | 1 year | Content-hash filenames | Must Have |
| NFR-SCL-066 | Session data | 15 min sliding | Logout/expiration | Must Have |
| NFR-SCL-067 | Reference data | 5 min | Background refresh | Should Have |
| NFR-SCL-068 | List queries | 1 min | Write-through invalidation | Should Have |
| NFR-SCL-069 | User permissions | 5 min | Role change event | Must Have |

### 12.4.6.3 Redis Scaling

| NFR-ID | Configuration | Value | Store Capacity | Priority |
|--------|---------------|-------|----------------|----------|
| NFR-SCL-070 | Single node | cache.t3.medium | Up to 500 stores | Must Have |
| NFR-SCL-071 | Cluster mode | 3 nodes | 500-5,000 stores | Should Have |
| NFR-SCL-072 | Memory allocation | 2-4 GB | Based on session count | Must Have |

---

## 12.4.7 Load Balancing

### 12.4.7.1 Load Balancer Configuration

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-SCL-080 | Application Load Balancer | AWS ALB | Must Have |
| NFR-SCL-081 | Health check path | `/health` endpoint | Must Have |
| NFR-SCL-082 | Health check interval | 30 seconds | Must Have |
| NFR-SCL-083 | Unhealthy threshold | 2 consecutive failures | Must Have |
| NFR-SCL-084 | Connection draining | 30 seconds | Must Have |

### 12.4.7.2 Routing Strategy

| NFR-ID | Route Type | Distribution | Priority |
|--------|------------|--------------|----------|
| NFR-SCL-085 | HTTP/HTTPS traffic | Round-robin with health checks | Must Have |
| NFR-SCL-086 | WebSocket connections | Sticky sessions (source IP) | Should Have |
| NFR-SCL-087 | API rate limiting | Per-tenant, per-endpoint | Must Have |

### 12.4.7.3 SSL/TLS Configuration

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-SCL-090 | TLS version | 1.3 minimum | Must Have |
| NFR-SCL-091 | Certificate management | AWS ACM auto-renewal | Must Have |
| NFR-SCL-092 | HTTPS redirect | Automatic HTTP to HTTPS | Must Have |

---

## 12.4.8 Storage Scaling

### 12.4.8.1 Object Storage (S3)

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-SCL-100 | Bucket structure | Per-tenant prefix isolation | Must Have |
| NFR-SCL-101 | Upload pattern | Direct-to-S3 presigned URLs | Must Have |
| NFR-SCL-102 | Lifecycle policies | Transition to IA after 90 days | Should Have |
| NFR-SCL-103 | Glacier archival | Campaign media after 1 year | Nice to Have |

### 12.4.8.2 Storage Capacity Planning

| NFR-ID | Store Count | Monthly Upload | Annual Storage | Priority |
|--------|-------------|----------------|----------------|----------|
| NFR-SCL-105 | 100 stores | 10 GB | 120 GB | Must Have |
| NFR-SCL-106 | 500 stores | 50 GB | 600 GB | Must Have |
| NFR-SCL-107 | 2,000 stores | 200 GB | 2.4 TB | Should Have |
| NFR-SCL-108 | 10,000 stores | 1 TB | 12 TB | Nice to Have |

---

## 12.4.9 Background Job Scaling

### 12.4.9.1 Queue Architecture

| NFR-ID | Queue | Purpose | Concurrency | Priority |
|--------|-------|---------|-------------|----------|
| NFR-SCL-110 | default | Standard jobs (email, thumbnails) | 10 per worker | Must Have |
| NFR-SCL-111 | long | Exports, bulk operations | 2 per worker | Must Have |
| NFR-SCL-112 | critical | Webhooks, time-sensitive | 20 per worker | Must Have |
| NFR-SCL-113 | dead-letter | Failed job investigation | Manual processing | Must Have |

### 12.4.9.2 Job Scaling Strategy

| NFR-ID | Condition | Action | Priority |
|--------|-----------|--------|----------|
| NFR-SCL-115 | Queue depth > 1,000 | Add worker instance | Should Have |
| NFR-SCL-116 | Queue depth > 5,000 | Alert + auto-scale | Must Have |
| NFR-SCL-117 | Worker idle > 15 min | Remove worker instance | Should Have |
| NFR-SCL-118 | Dead-letter > 50 | Alert operations team | Must Have |

---

## 12.4.10 CDN and Edge Caching

### 12.4.10.1 CloudFront Configuration

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-SCL-120 | Global distribution | CloudFront edge locations | Must Have |
| NFR-SCL-121 | Origin shield | Enable for reduced origin load | Should Have |
| NFR-SCL-122 | Cache behaviors | Static (long), API (short/no cache) | Must Have |
| NFR-SCL-123 | Signed URLs | Photo access with expiration | Must Have |

### 12.4.10.2 Cache Behavior Rules

| NFR-ID | Path Pattern | Cache TTL | Signed | Priority |
|--------|--------------|-----------|--------|----------|
| NFR-SCL-125 | `/_next/static/*` | 1 year | No | Must Have |
| NFR-SCL-126 | `/api/*` | No cache | No | Must Have |
| NFR-SCL-127 | `/media/*` | 1 day | Yes | Must Have |
| NFR-SCL-128 | `/thumbnails/*` | 7 days | Yes | Must Have |

---

## 12.4.11 Multi-Tenancy Scaling

### 12.4.11.1 Tenant Isolation

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-SCL-130 | Logical isolation | Tenant ID in all queries | Must Have |
| NFR-SCL-131 | Resource quotas | Per-tenant limits (API, storage) | Should Have |
| NFR-SCL-132 | Noisy neighbor prevention | Rate limiting per tenant | Must Have |
| NFR-SCL-133 | Tenant monitoring | Per-tenant metrics dashboards | Should Have |

### 12.4.11.2 Tenant-Level Rate Limits

| NFR-ID | Resource | Limit per Tenant | Burst | Priority |
|--------|----------|------------------|-------|----------|
| NFR-SCL-135 | API requests | 1,000/min | 2,000/min | Must Have |
| NFR-SCL-136 | Photo uploads | 100/min | 200/min | Must Have |
| NFR-SCL-137 | Export jobs | 10/hour | 20/hour | Should Have |
| NFR-SCL-138 | Webhook endpoints | 5 per tenant | N/A | Must Have |

---

## 12.4.12 Verification and Testing

### 12.4.12.1 Load Testing Requirements

| NFR-ID | Test Type | Frequency | Target | Priority |
|--------|-----------|-----------|--------|----------|
| NFR-SCL-140 | Baseline load test | Each release | 100 concurrent users | Must Have |
| NFR-SCL-141 | Stress test | Monthly | 2x expected peak | Should Have |
| NFR-SCL-142 | Spike test | Quarterly | 5x normal traffic burst | Should Have |
| NFR-SCL-143 | Endurance test | Pre-launch | 24-hour sustained load | Should Have |

### 12.4.12.2 Scaling Verification

| NFR-ID | Scenario | Expected Behavior | Priority |
|--------|----------|-------------------|----------|
| NFR-SCL-145 | Traffic spike | Auto-scale within 2 minutes | Must Have |
| NFR-SCL-146 | Traffic decrease | Scale down within 10 minutes | Should Have |
| NFR-SCL-147 | Instance failure | Traffic rerouted within 30 seconds | Must Have |
| NFR-SCL-148 | Database failover | Automatic failover within 2 minutes | Should Have |

---

## 12.4.13 Cross-References

| Reference | Description |
|-----------|-------------|
| SUPP-039 | Infrastructure sizing and scaling projections |
| SUPP-012 | Technology stack selections |
| Section 3.3 | Technology Stack documentation |
| Section 12.1 | Performance requirements |
| Section 12.5 | Availability requirements |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Scalability Requirements*


---

# 12.5 Availability Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Availability
> **Source Documents**: SUPP-039 (Infrastructure, Performance & Security Requirements)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

---

## 12.5.1 Purpose

This section defines availability requirements for NewPOPSys v1, covering uptime SLAs, disaster recovery, failover mechanisms, backup strategies, and maintenance procedures. All requirements include specific targets and verification methods.

---

## 12.5.2 Uptime Requirements

### 12.5.2.1 Service Level Targets

| NFR-ID | Environment | Uptime Target | Allowed Downtime/Month | Priority |
|--------|-------------|---------------|------------------------|----------|
| NFR-AVL-001 | Production | 99.5% | 3.6 hours | Must Have |
| NFR-AVL-002 | Staging | 95% | 36 hours | Should Have |
| NFR-AVL-003 | Development | 90% | 72 hours | Nice to Have |

### 12.5.2.2 Uptime Calculation

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-AVL-005 | Measurement period | Calendar month | Must Have |
| NFR-AVL-006 | Measurement method | External synthetic monitoring | Must Have |
| NFR-AVL-007 | Exclusions | Scheduled maintenance windows | Must Have |
| NFR-AVL-008 | Reporting | Monthly availability report | Should Have |

### 12.5.2.3 Availability by Component

| NFR-ID | Component | Target | Dependency | Priority |
|--------|-----------|--------|------------|----------|
| NFR-AVL-010 | Web application | 99.5% | ALB, API containers | Must Have |
| NFR-AVL-011 | API endpoints | 99.5% | ALB, API containers, Database | Must Have |
| NFR-AVL-012 | Database | 99.95% | RDS Multi-AZ | Must Have |
| NFR-AVL-013 | Object storage | 99.99% | S3 (AWS SLA) | Must Have |
| NFR-AVL-014 | CDN | 99.9% | CloudFront | Must Have |
| NFR-AVL-015 | Background jobs | 99% | Redis, Worker containers | Should Have |

---

## 12.5.3 High Availability Architecture

### 12.5.3.1 Multi-AZ Deployment

| NFR-ID | Component | AZ Configuration | Failover | Priority |
|--------|-----------|------------------|----------|----------|
| NFR-AVL-020 | Application containers | 2+ AZs | Automatic via ALB | Must Have |
| NFR-AVL-021 | Database (RDS) | Multi-AZ standby | Automatic failover | Must Have |
| NFR-AVL-022 | Redis (ElastiCache) | Multi-AZ replication | Automatic failover | Should Have |
| NFR-AVL-023 | NAT Gateway | Per-AZ deployment | No single point of failure | Should Have |

### 12.5.3.2 Load Balancer Configuration

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-AVL-025 | Health check interval | 30 seconds | Must Have |
| NFR-AVL-026 | Healthy threshold | 2 consecutive successes | Must Have |
| NFR-AVL-027 | Unhealthy threshold | 2 consecutive failures | Must Have |
| NFR-AVL-028 | Health check path | `/health` (includes DB check) | Must Have |
| NFR-AVL-029 | Connection draining | 30 seconds | Must Have |

### 12.5.3.3 Container Health Checks

| NFR-ID | Check Type | Interval | Timeout | Retries | Priority |
|--------|------------|----------|---------|---------|----------|
| NFR-AVL-030 | Startup probe | 5s | 10s | 3 | Must Have |
| NFR-AVL-031 | Liveness probe | 30s | 5s | 3 | Must Have |
| NFR-AVL-032 | Readiness probe | 10s | 5s | 1 | Must Have |

---

## 12.5.4 Disaster Recovery

### 12.5.4.1 Recovery Objectives

| NFR-ID | Scenario | RTO (Recovery Time) | RPO (Recovery Point) | Priority |
|--------|----------|---------------------|---------------------|----------|
| NFR-AVL-040 | Single AZ failure | < 5 minutes | 0 (no data loss) | Must Have |
| NFR-AVL-041 | Database failure | < 5 minutes | 0 (Multi-AZ sync) | Must Have |
| NFR-AVL-042 | Region failure | < 4 hours | < 1 hour | Should Have |
| NFR-AVL-043 | Data corruption | < 1 hour | < 5 minutes (PITR) | Must Have |
| NFR-AVL-044 | Ransomware/breach | < 4 hours | < 1 hour | Should Have |
| NFR-AVL-045 | Complete rebuild | < 24 hours | < 1 hour | Should Have |

### 12.5.4.2 Disaster Recovery Strategy

| NFR-ID | Tier | Strategy | Implementation | Priority |
|--------|------|----------|----------------|----------|
| NFR-AVL-050 | Tier 1 (v1) | Backup and restore | Daily backups to DR region | Must Have |
| NFR-AVL-051 | Tier 2 (v1.1) | Pilot light | Cross-region DB replica (cold) | Should Have |
| NFR-AVL-052 | Tier 3 (v2) | Warm standby | Active-passive cross-region | Nice to Have |

### 12.5.4.3 Cross-Region Replication (v1.1+)

| NFR-ID | Component | Replication Method | Lag Target | Priority |
|--------|-----------|-------------------|------------|----------|
| NFR-AVL-055 | Database | RDS cross-region read replica | < 1 minute | Should Have |
| NFR-AVL-056 | Object storage | S3 cross-region replication | < 15 minutes | Should Have |
| NFR-AVL-057 | Configuration | Git-versioned + Secrets Manager | Immediate | Must Have |

---

## 12.5.5 Backup Strategy

### 12.5.5.1 Database Backup

| NFR-ID | Backup Type | Frequency | Retention | Priority |
|--------|-------------|-----------|-----------|----------|
| NFR-AVL-060 | Automated daily snapshots | Daily | 30 days | Must Have |
| NFR-AVL-061 | Continuous WAL archiving | Continuous | 7 days | Must Have |
| NFR-AVL-062 | Weekly full backup | Weekly | 90 days | Should Have |
| NFR-AVL-063 | Monthly archival | Monthly | 1 year | Nice to Have |

### 12.5.5.2 Point-in-Time Recovery (PITR)

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-AVL-065 | PITR window | 7 days | Must Have |
| NFR-AVL-066 | Recovery granularity | 5-minute intervals | Must Have |
| NFR-AVL-067 | Recovery testing | Quarterly DR drill | Should Have |

### 12.5.5.3 Object Storage Backup

| NFR-ID | Strategy | Implementation | Retention | Priority |
|--------|----------|----------------|-----------|----------|
| NFR-AVL-070 | Versioning | S3 versioning enabled | 90 days | Must Have |
| NFR-AVL-071 | Cross-region copy | S3 replication to DR region | Same as source | Should Have |
| NFR-AVL-072 | Lifecycle rules | Transition to Glacier after 1 year | 7 years | Nice to Have |

### 12.5.5.4 Configuration Backup

| NFR-ID | Configuration Type | Backup Method | Priority |
|--------|-------------------|---------------|----------|
| NFR-AVL-075 | Infrastructure code | Git (GitHub/GitLab) | Must Have |
| NFR-AVL-076 | Application config | Git + environment variables | Must Have |
| NFR-AVL-077 | Secrets | AWS Secrets Manager (versioned) | Must Have |
| NFR-AVL-078 | Database schema | Drizzle migrations in Git | Must Have |

---

## 12.5.6 Failover Mechanisms

### 12.5.6.1 Automatic Failover

| NFR-ID | Component | Failover Mechanism | Detection Time | Recovery Time | Priority |
|--------|-----------|-------------------|----------------|---------------|----------|
| NFR-AVL-080 | Application instances | ALB health checks | 60 seconds | Immediate | Must Have |
| NFR-AVL-081 | Database (Multi-AZ) | RDS automatic failover | 60-120 seconds | 60-120 seconds | Must Have |
| NFR-AVL-082 | Redis (Multi-AZ) | ElastiCache failover | 60 seconds | 60 seconds | Should Have |
| NFR-AVL-083 | DNS failover | Route 53 health checks | 30 seconds | 60 seconds | Should Have |

### 12.5.6.2 Manual Failover Procedures

| NFR-ID | Scenario | Procedure | Authorization Required | Priority |
|--------|----------|-----------|----------------------|----------|
| NFR-AVL-085 | Promote read replica | Database failover runbook | Database admin | Should Have |
| NFR-AVL-086 | Region switchover | DR activation runbook | Platform admin + approval | Should Have |
| NFR-AVL-087 | Rollback deployment | Deployment rollback runbook | DevOps team | Must Have |

### 12.5.6.3 Verification Methods

- Quarterly failover drills (documented)
- Annual DR simulation
- Chaos engineering tests (v1.1+)

---

## 12.5.7 Maintenance Windows

### 12.5.7.1 Scheduled Maintenance

| NFR-ID | Maintenance Type | Window | Frequency | Notification | Priority |
|--------|------------------|--------|-----------|--------------|----------|
| NFR-AVL-090 | Application deployment | Any (zero-downtime) | As needed | Optional | Must Have |
| NFR-AVL-091 | Database patching | Sunday 02:00-06:00 UTC | Monthly | 7 days advance | Must Have |
| NFR-AVL-092 | Infrastructure updates | Sunday 02:00-06:00 UTC | Quarterly | 14 days advance | Should Have |
| NFR-AVL-093 | Major version upgrades | Coordinated | As needed | 30 days advance | Should Have |

### 12.5.7.2 Zero-Downtime Deployment

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-AVL-095 | Rolling deployments | ECS rolling update | Must Have |
| NFR-AVL-096 | Database migrations | Backward-compatible only | Must Have |
| NFR-AVL-097 | Blue-green capability | For major changes | Should Have |
| NFR-AVL-098 | Canary releases | Gradual traffic shift | Nice to Have |

### 12.5.7.3 Emergency Maintenance

| NFR-ID | Requirement | SLA | Authorization | Priority |
|--------|-------------|-----|---------------|----------|
| NFR-AVL-100 | Security patching | Within 24 hours of critical CVE | Security lead | Must Have |
| NFR-AVL-101 | Critical bug fix | Within 4 hours of P1 incident | On-call engineer | Must Have |
| NFR-AVL-102 | Emergency notification | 30 minutes before if possible | On-call engineer | Must Have |

---

## 12.5.8 Incident Response

### 12.5.8.1 Incident Severity Classification

| NFR-ID | Severity | Description | Response Time | Resolution Target | Priority |
|--------|----------|-------------|---------------|-------------------|----------|
| NFR-AVL-110 | P1 - Critical | Complete outage, data loss risk | 15 minutes | 1 hour | Must Have |
| NFR-AVL-111 | P2 - High | Major feature unavailable | 30 minutes | 4 hours | Must Have |
| NFR-AVL-112 | P3 - Medium | Degraded performance | 2 hours | 24 hours | Should Have |
| NFR-AVL-113 | P4 - Low | Minor issue, workaround available | 8 hours | 7 days | Should Have |

### 12.5.8.2 On-Call Requirements

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-AVL-115 | On-call coverage | 24/7/365 | Must Have |
| NFR-AVL-116 | Escalation path | Primary -> Secondary -> Manager | Must Have |
| NFR-AVL-117 | Response acknowledgment | Within 15 minutes | Must Have |
| NFR-AVL-118 | Incident documentation | Post-incident report within 48 hours | Should Have |

### 12.5.8.3 Runbook Requirements

| NFR-ID | Runbook | Purpose | Priority |
|--------|---------|---------|----------|
| NFR-AVL-120 | Service restart | Container/service restart procedures | Must Have |
| NFR-AVL-121 | Database recovery | PITR and failover procedures | Must Have |
| NFR-AVL-122 | Deployment rollback | Quick rollback to previous version | Must Have |
| NFR-AVL-123 | DR activation | Region failover procedures | Should Have |
| NFR-AVL-124 | Security incident | Breach response procedures | Must Have |

---

## 12.5.9 Monitoring and Alerting

### 12.5.9.1 Availability Monitoring

| NFR-ID | Monitor Type | Check Interval | Threshold | Priority |
|--------|--------------|----------------|-----------|----------|
| NFR-AVL-130 | Synthetic monitoring | 1 minute | Response > 5s = warning | Must Have |
| NFR-AVL-131 | Endpoint health checks | 30 seconds | 2 failures = alert | Must Have |
| NFR-AVL-132 | Database connectivity | 30 seconds | 1 failure = alert | Must Have |
| NFR-AVL-133 | SSL certificate expiry | Daily | < 30 days = warning | Must Have |

### 12.5.9.2 Alert Channels

| NFR-ID | Severity | Alert Channel | Priority |
|--------|----------|---------------|----------|
| NFR-AVL-135 | P1 Critical | PagerDuty + Phone call | Must Have |
| NFR-AVL-136 | P2 High | PagerDuty + Slack | Must Have |
| NFR-AVL-137 | P3 Medium | Slack + Email | Should Have |
| NFR-AVL-138 | P4 Low | Email + Dashboard | Should Have |

### 12.5.9.3 Status Communication

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-AVL-140 | Status page | Public status page (e.g., Statuspage.io) | Should Have |
| NFR-AVL-141 | Incident updates | Every 30 minutes during P1/P2 | Must Have |
| NFR-AVL-142 | Maintenance announcements | In-app banner + email | Should Have |

---

## 12.5.10 Graceful Degradation

### 12.5.10.1 Degradation Strategies

| NFR-ID | Failure Scenario | Degraded Behavior | Priority |
|--------|------------------|-------------------|----------|
| NFR-AVL-150 | Redis unavailable | Fall back to database sessions | Should Have |
| NFR-AVL-151 | S3 unavailable | Queue uploads, display placeholders | Should Have |
| NFR-AVL-152 | Email service down | Queue emails, retry later | Must Have |
| NFR-AVL-153 | Read replica unavailable | Route reads to primary | Should Have |
| NFR-AVL-154 | CDN unavailable | Serve from origin directly | Should Have |

### 12.5.10.2 Circuit Breaker Patterns

| NFR-ID | Requirement | Specification | Priority |
|--------|-------------|---------------|----------|
| NFR-AVL-155 | Failure threshold | 50% failures in 10-second window | Should Have |
| NFR-AVL-156 | Open circuit duration | 30 seconds | Should Have |
| NFR-AVL-157 | Half-open testing | 3 successful requests to close | Should Have |

---

## 12.5.11 Cross-References

| Reference | Description |
|-----------|-------------|
| SUPP-039 | Infrastructure availability and DR requirements |
| Section 12.1 | Performance requirements |
| Section 12.4 | Scalability requirements |
| Section 12.6 | Data retention and backup policies |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Availability Requirements*


---

# 12.6 Data Retention Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Data Retention
> **Source Documents**: SUPP-008 (Data Retention Classification Policy), SUPP-039 (Infrastructure Requirements)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

---

## 12.6.1 Purpose

This section defines data retention requirements for NewPOPSys v1, covering data classification, retention periods, purge workflows, GDPR compliance, backup policies, and audit trail retention. The core principle is: **Delete heavy artifacts on a clock; keep lightweight accountability.**

---

## 12.6.2 Data Classification

### 12.6.2.1 Data Classes Overview

| NFR-ID | Class | Description | Examples | Retention Principle |
|--------|-------|-------------|----------|---------------------|
| NFR-RET-001 | Class A: Heavy Media | High-storage campaign artifacts | Install photos, receipt photos, deinstall photos, optional videos | Time-limited (90 days default) |
| NFR-RET-002 | Class B: Light Records | Campaign metadata and audit trail | Campaign records, assignments, statuses, review outcomes | Long horizon (2-5 years) |
| NFR-RET-003 | Class C: Master Data | Core operational data | Stores, regions, groups, store layouts | While active |
| NFR-RET-004 | Class D: Reusable Definitions | Templates and configurations | Survey templates, kit definitions, photo rule presets | While referenced |
| NFR-RET-005 | Class E: Asset Registry | Metadata and pointers | Asset metadata, checksums, versions, pointer URIs | While referenced |
| NFR-RET-006 | Class F: Exports | Generated output files | CSV, XLSX, JSON, PDF exports | Short-lived (regenerate on demand) |

### 12.6.2.2 Storage Classification

| NFR-ID | Class | Storage Type | Estimated Size per Campaign | Priority |
|--------|-------|--------------|----------------------------|----------|
| NFR-RET-010 | Class A | S3 Standard -> IA | 500 MB - 5 GB | Must Have |
| NFR-RET-011 | Class B | PostgreSQL | 1-10 MB | Must Have |
| NFR-RET-012 | Class C | PostgreSQL | < 1 MB | Must Have |
| NFR-RET-013 | Class D | PostgreSQL | < 500 KB | Must Have |
| NFR-RET-014 | Class E | PostgreSQL | < 100 KB | Must Have |
| NFR-RET-015 | Class F | S3 (temporary) | Variable | Should Have |

---

## 12.6.3 Retention Periods

### 12.6.3.1 Class A: Campaign Proof Media

| NFR-ID | Requirement | Default | Configurable Range | Priority |
|--------|-------------|---------|-------------------|----------|
| NFR-RET-020 | Retention after campaign completion | 90 days | 30-365 days | Must Have |
| NFR-RET-021 | Export bundle notification | 14 days before purge | 7-30 days | Must Have |
| NFR-RET-022 | Purge execution | Automated background job | N/A | Must Have |
| NFR-RET-023 | Purge audit logging | Required | N/A | Must Have |

### 12.6.3.2 Class B: Campaign Records (Light)

| NFR-ID | Requirement | Recommended | Configurable | Priority |
|--------|-------------|-------------|--------------|----------|
| NFR-RET-025 | Campaign metadata | 5 years | Yes (2-indefinite) | Must Have |
| NFR-RET-026 | Assignment records | 5 years | Yes | Must Have |
| NFR-RET-027 | Status history | 5 years | Yes | Must Have |
| NFR-RET-028 | Review outcomes | 5 years | Yes | Must Have |
| NFR-RET-029 | Audit events | 7 years (compliance) | Minimum only | Must Have |

### 12.6.3.3 Class C: Store Master Data

| NFR-ID | Requirement | Retention | Notes | Priority |
|--------|-------------|-----------|-------|----------|
| NFR-RET-030 | Active stores | Indefinite | While store is active | Must Have |
| NFR-RET-031 | Deactivated stores | 2 years | After deactivation | Should Have |
| NFR-RET-032 | Store layouts/surveys | Indefinite | While store exists | Must Have |
| NFR-RET-033 | Regions and groups | Indefinite | While referenced | Must Have |

### 12.6.3.4 Class D: Reusable Definitions

| NFR-ID | Requirement | Retention | Notes | Priority |
|--------|-------------|-----------|-------|----------|
| NFR-RET-035 | Survey templates | While referenced | Plus 2 years after last use | Must Have |
| NFR-RET-036 | Template versions | Indefinite | Immutable, never delete used versions | Must Have |
| NFR-RET-037 | Kit/item definitions | While referenced | Plus 2 years after last use | Must Have |
| NFR-RET-038 | Photo rule presets | While referenced | Supports repeat campaigns | Should Have |

### 12.6.3.5 Class E: Asset Registry

| NFR-ID | Requirement | Retention | Notes | Priority |
|--------|-------------|-----------|-------|----------|
| NFR-RET-040 | Asset metadata records | While binary exists | Pointer URI, checksum, version | Must Have |
| NFR-RET-041 | Orphaned asset records | 30 days | After binary purge | Should Have |
| NFR-RET-042 | Asset tags and versions | With parent record | N/A | Must Have |

### 12.6.3.6 Class F: Exports

| NFR-ID | Requirement | Retention | Notes | Priority |
|--------|-------------|-----------|-------|----------|
| NFR-RET-045 | Generated exports | 7 days | Regenerate on demand | Must Have |
| NFR-RET-046 | Export request logs | 90 days | Audit trail | Should Have |
| NFR-RET-047 | Large exports | 30 days | > 100 MB exports | Should Have |

---

## 12.6.4 Purge Workflow

### 12.6.4.1 Automated Purge Process

| NFR-ID | Step | Description | Timing | Priority |
|--------|------|-------------|--------|----------|
| NFR-RET-050 | Campaign completion trigger | Mark campaign as complete, schedule purge | Immediate | Must Have |
| NFR-RET-051 | Export bundle generation | Generate downloadable export bundle | T-14 days | Must Have |
| NFR-RET-052 | Purge notification | Notify tenant admins of pending purge | T-14 days | Must Have |
| NFR-RET-053 | Reminder notification | Second notification before purge | T-3 days | Should Have |
| NFR-RET-054 | Purge execution | Delete Class A media from S3 | T+0 | Must Have |
| NFR-RET-055 | Metadata update | Mark media records as purged, retain manifest | T+0 | Must Have |
| NFR-RET-056 | Audit log | Log purge action with actor=system | T+0 | Must Have |

### 12.6.4.2 Purge Job Configuration

| NFR-ID | Parameter | Value | Notes | Priority |
|--------|-----------|-------|-------|----------|
| NFR-RET-060 | Job schedule | Daily at 02:00 UTC | Off-peak processing | Must Have |
| NFR-RET-061 | Batch size | 100 campaigns per run | Prevent resource exhaustion | Must Have |
| NFR-RET-062 | Retry policy | 3 retries with exponential backoff | Handle transient failures | Must Have |
| NFR-RET-063 | Dead-letter handling | Alert on repeated failures | Manual investigation | Must Have |

### 12.6.4.3 Export Bundle Contents

| NFR-ID | Content | Format | Included | Priority |
|--------|---------|--------|----------|----------|
| NFR-RET-065 | Campaign summary | JSON + PDF | Always | Must Have |
| NFR-RET-066 | Store completion status | CSV | Always | Must Have |
| NFR-RET-067 | Verification outcomes | CSV | Always | Must Have |
| NFR-RET-068 | Issues and reorders | CSV | Always | Must Have |
| NFR-RET-069 | Audit events | JSON | Always | Must Have |
| NFR-RET-070 | Media manifest | JSON | Always (IDs + pointers) | Must Have |
| NFR-RET-071 | Media files (ZIP) | Binary | If within retention | Should Have |

---

## 12.6.5 GDPR Compliance

### 12.6.5.1 Data Subject Rights

| NFR-ID | Right | Implementation | Response Time | Priority |
|--------|-------|----------------|---------------|----------|
| NFR-RET-080 | Right to access (Article 15) | Data export functionality | 30 days | Must Have |
| NFR-RET-081 | Right to rectification (Article 16) | Self-service profile edit + admin tools | Immediate | Must Have |
| NFR-RET-082 | Right to erasure (Article 17) | Account deletion workflow | 30 days | Must Have |
| NFR-RET-083 | Right to portability (Article 20) | Standard export formats (JSON, CSV) | 30 days | Should Have |
| NFR-RET-084 | Right to object (Article 21) | Opt-out of marketing communications | Immediate | Should Have |

### 12.6.5.2 Right to Erasure (RTBF) Workflow

| NFR-ID | Step | Description | Notes | Priority |
|--------|------|-------------|-------|----------|
| NFR-RET-090 | Request submission | User or admin initiates deletion request | Via UI or support | Must Have |
| NFR-RET-091 | Verification | Verify identity of requester | Email confirmation | Must Have |
| NFR-RET-092 | Approval (if needed) | Brand Admin approval for store users | Optional workflow | Should Have |
| NFR-RET-093 | Data collection | Identify all data associated with subject | Automated scan | Must Have |
| NFR-RET-094 | Backup exclusion | Mark data for exclusion from future restores | Backup metadata | Should Have |
| NFR-RET-095 | Data deletion | Remove/anonymize personal data | Preserve audit integrity | Must Have |
| NFR-RET-096 | Confirmation | Notify requester of completion | Email notification | Must Have |

### 12.6.5.3 Data Anonymization

| NFR-ID | Data Type | Anonymization Method | Priority |
|--------|-----------|---------------------|----------|
| NFR-RET-100 | User names | Replace with "Deleted User [hash]" | Must Have |
| NFR-RET-101 | Email addresses | Hash or remove | Must Have |
| NFR-RET-102 | Phone numbers | Remove | Must Have |
| NFR-RET-103 | IP addresses | Truncate to /24 or remove | Should Have |
| NFR-RET-104 | User-generated content | Anonymize attribution | Should Have |

### 12.6.5.4 GDPR Exceptions

| NFR-ID | Exception | Justification | Retention | Priority |
|--------|-----------|---------------|-----------|----------|
| NFR-RET-105 | Legal hold | Legal proceedings | Until released | Must Have |
| NFR-RET-106 | Regulatory compliance | Audit trail requirements | Per regulation | Must Have |
| NFR-RET-107 | Contractual obligation | Active contract terms | Contract duration | Should Have |

---

## 12.6.6 Audit Trail Retention

### 12.6.6.1 Audit Log Types

| NFR-ID | Audit Type | Retention | Purge Allowed | Priority |
|--------|------------|-----------|---------------|----------|
| NFR-RET-110 | Authentication events | 2 years | After retention | Must Have |
| NFR-RET-111 | Authorization events | 2 years | After retention | Must Have |
| NFR-RET-112 | Data access events | 5 years | After retention | Must Have |
| NFR-RET-113 | Data modification events | 7 years | After retention | Must Have |
| NFR-RET-114 | Administrative actions | 7 years | After retention | Must Have |
| NFR-RET-115 | System events (purge, sync) | 2 years | After retention | Should Have |

### 12.6.6.2 Audit Log Protection

| NFR-ID | Requirement | Implementation | Priority |
|--------|-------------|----------------|----------|
| NFR-RET-120 | Immutability | Append-only storage | Must Have |
| NFR-RET-121 | Integrity verification | Checksums on log entries | Should Have |
| NFR-RET-122 | Separate access control | Audit logs isolated from app permissions | Must Have |
| NFR-RET-123 | Encryption at rest | AES-256 encryption | Must Have |

### 12.6.6.3 Audit Log Archival

| NFR-ID | Archive Stage | Timing | Storage | Priority |
|--------|---------------|--------|---------|----------|
| NFR-RET-125 | Hot storage | 0-90 days | PostgreSQL | Must Have |
| NFR-RET-126 | Warm storage | 90 days - 1 year | S3 Standard | Should Have |
| NFR-RET-127 | Cold storage | 1-7 years | S3 Glacier | Nice to Have |

---

## 12.6.7 Backup Retention

### 12.6.7.1 Database Backup Retention

| NFR-ID | Backup Type | Retention | Storage | Priority |
|--------|-------------|-----------|---------|----------|
| NFR-RET-130 | Daily snapshots | 30 days | RDS snapshots | Must Have |
| NFR-RET-131 | Weekly snapshots | 90 days | RDS snapshots | Should Have |
| NFR-RET-132 | Monthly snapshots | 1 year | S3 (cross-region) | Nice to Have |
| NFR-RET-133 | WAL archives (PITR) | 7 days | RDS continuous | Must Have |

### 12.6.7.2 Object Storage Retention

| NFR-ID | Strategy | Configuration | Retention | Priority |
|--------|----------|---------------|-----------|----------|
| NFR-RET-135 | Versioning | Enabled on all buckets | 90 days | Must Have |
| NFR-RET-136 | Delete markers | Retained for recovery | 30 days | Should Have |
| NFR-RET-137 | Cross-region replication | DR region copy | Same as source | Should Have |

### 12.6.7.3 Configuration Backup

| NFR-ID | Configuration | Backup Method | Retention | Priority |
|--------|---------------|---------------|-----------|----------|
| NFR-RET-140 | Infrastructure code | Git version control | Indefinite | Must Have |
| NFR-RET-141 | Application config | Git + environment backup | Indefinite | Must Have |
| NFR-RET-142 | Secrets | Secrets Manager versioning | 30 versions | Must Have |
| NFR-RET-143 | Database migrations | Git (Drizzle migrations) | Indefinite | Must Have |

---

## 12.6.8 Tenant Data Lifecycle

### 12.6.8.1 Tenant Offboarding

| NFR-ID | Step | Description | Timing | Priority |
|--------|------|-------------|--------|----------|
| NFR-RET-150 | Offboarding notice | Tenant provides termination notice | T-30 days | Must Have |
| NFR-RET-151 | Export provision | Generate complete data export | T-14 days | Must Have |
| NFR-RET-152 | Export download | Tenant downloads all data | T-7 days | Must Have |
| NFR-RET-153 | Account deactivation | Disable tenant access | T+0 | Must Have |
| NFR-RET-154 | Data deletion | Delete tenant data (except audit) | T+30 days | Must Have |
| NFR-RET-155 | Final confirmation | Confirm deletion to tenant | T+31 days | Must Have |

### 12.6.8.2 Tenant Data Export (Takeout)

| NFR-ID | Export Content | Format | Priority |
|--------|----------------|--------|----------|
| NFR-RET-160 | Store data | CSV + JSON | Must Have |
| NFR-RET-161 | Campaign data | CSV + JSON | Must Have |
| NFR-RET-162 | User data | JSON | Must Have |
| NFR-RET-163 | Media files | ZIP archive | Must Have |
| NFR-RET-164 | Configuration | JSON | Should Have |
| NFR-RET-165 | Audit logs | JSON | Should Have |

---

## 12.6.9 Storage Lifecycle Management

### 12.6.9.1 S3 Lifecycle Policies

| NFR-ID | Object Type | Transition | Archive | Delete | Priority |
|--------|-------------|------------|---------|--------|----------|
| NFR-RET-170 | Campaign media | Standard -> IA (90d) | Glacier (1y) | After purge | Must Have |
| NFR-RET-171 | Thumbnails | Standard only | N/A | With parent | Must Have |
| NFR-RET-172 | Exports | Standard only | N/A | 7 days | Must Have |
| NFR-RET-173 | Audit log archives | Standard -> IA (90d) | Glacier (1y) | 7 years | Should Have |

### 12.6.9.2 Database Maintenance

| NFR-ID | Maintenance | Frequency | Notes | Priority |
|--------|-------------|-----------|-------|----------|
| NFR-RET-175 | Vacuum analyze | Daily | Reclaim space | Must Have |
| NFR-RET-176 | Index maintenance | Weekly | Rebuild fragmented indexes | Should Have |
| NFR-RET-177 | Partition maintenance | Monthly (v1.1) | Audit log partitions | Nice to Have |

---

## 12.6.10 Verification and Compliance

### 12.6.10.1 Retention Verification

| NFR-ID | Verification | Frequency | Method | Priority |
|--------|--------------|-----------|--------|----------|
| NFR-RET-180 | Purge job execution | Daily | Job monitoring dashboard | Must Have |
| NFR-RET-181 | Backup integrity | Weekly | Automated restore test | Should Have |
| NFR-RET-182 | RTBF compliance | Per request | Verification checklist | Must Have |
| NFR-RET-183 | Retention policy audit | Quarterly | Manual review | Should Have |

### 12.6.10.2 Compliance Reporting

| NFR-ID | Report | Frequency | Audience | Priority |
|--------|--------|-----------|----------|----------|
| NFR-RET-185 | Data retention summary | Monthly | Internal ops | Should Have |
| NFR-RET-186 | GDPR compliance report | Quarterly | DPO / Legal | Should Have |
| NFR-RET-187 | Storage utilization | Monthly | Finance / Ops | Should Have |

---

## 12.6.11 Cross-References

| Reference | Description |
|-----------|-------------|
| SUPP-008 | Data Retention Classification Policy (Option A) |
| SUPP-039 | Infrastructure and backup requirements |
| SUPP-032 | Break-glass, retention safety, and data requests |
| Section 12.2 | Security requirements (audit logging) |
| Section 12.5 | Availability requirements (backup strategy) |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Data Retention Requirements*

