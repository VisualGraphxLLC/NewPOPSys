# 10 - Module: Platform Admin

System administration and support screens for platform-wide management, user administration, audit compliance, and support operations.

## Module Overview

| Field | Value |
|-------|-------|
| **Screen Prefix** | A-series (Admin) |
| **Primary Users** | Platform Admin (PSP-001), PSP Admin, Support Agent |
| **Key Functions** | User management, system configuration, audit logs, brand onboarding, support queue |
| **SOW References** | SUPP-003, SUPP-004, SUPP-023, SUPP-029, SUPP-031 |

## Screens

Located in `screens/` subfolder:

| Screen ID | Name | Status | Description |
|-----------|------|--------|-------------|
| A001 | Admin Dashboard | Complete | Command center with system health, security events, tenant overview |
| A002 | User Management | Complete | User CRUD, role assignment, MFA management, impersonation |
| A003 | Brand Configuration | Complete | Brand onboarding, feature flags, API keys |
| A004 | System Settings | Complete | Platform-wide config: auth, API, webhooks, email, retention |
| A005 | Audit Logs | Complete | Immutable audit trail with correlation tracking, 7-year retention |
| A006 | Support Queue | Complete | Support cases, failed webhook retry, system alerts, SLA tracking |

## Key Capabilities

### User Impersonation
- Platform Admin: Full impersonation of all users except other Platform Admins
- Support Agent: Read-only impersonation of Store Users only
- All sessions: 30-minute default, 2-hour hard limit, reason required, fully audited

### Feature Flags
- Scope precedence: USER > STORE > CAMPAIGN > BRAND > TENANT
- DB-backed with real-time updates
- Available flags: photo_verification, strict_verification, deinstall_tracking, issue_auto_approval, multi_language

### Audit System
- Immutable entries with correlationId + requestId correlation
- Event categories: Authentication, Authorization, Data Modification, Impersonation, System, Security
- Export formats: CSV, JSON, PDF

### Support SLA
| Priority | First Response | Resolution | Escalation |
|----------|----------------|------------|------------|
| Critical | 15 min | 4 hours | Immediate to PSP Admin |
| High | 1 hour | 8 hours | After 2 hours |
| Medium | 4 hours | 24 hours | After 8 hours |
| Low | 8 hours | 72 hours | After 24 hours |

## Wireframe References

- `../screenshots/PSP_Admin/`
- `../../05_Wireframes/`

## Source Documents

- SUPP-003 - RBAC and Permissions Matrix
- SUPP-004 - Notifications and Escalation Matrix
- SUPP-023 - Feature Flags Admin UX
- SUPP-029 - Observability, Metrics, and Audit
- SUPP-031 - Supportability, Logs, and Impersonation

---
*Module Status: Complete*
*Last Updated: 2026-01-01*
*Total Screens: 6/6*
