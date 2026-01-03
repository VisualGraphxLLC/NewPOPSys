# Platform Admin Persona

**Document ID:** SRS-4.4.1
**Version:** 1.0
**Date:** 2026-01-01
**System:** NewPOPSys v1.38
**Category:** PSP Level Persona

---

## 1. Persona Overview

| Attribute | Value |
|-----------|-------|
| Persona ID | PSP-001 |
| Role Name | Platform Admin |
| Level | PSP (Platform & Print Service Provider) |
| Primary Responsibility | Full system configuration, tenant management, user impersonation for support, security and audit access |
| Permission Level | All Privileged + Impersonate |

### 1.1 Role Description

The Platform Admin is the highest-privilege user within the NewPOPSys platform. This persona is responsible for system-wide configuration, multi-tenant management, security oversight, and provides escalated support through user impersonation capabilities. Platform Admins ensure the platform operates securely and reliably across all PSP tenants.

---

## 2. Jobs to Be Done (JTBD)

### 2.1 Primary Jobs

| Job ID | Job Statement | Priority |
|--------|---------------|----------|
| JTBD-PA-01 | Configure and maintain system-wide platform settings | Critical |
| JTBD-PA-02 | Manage PSP tenant onboarding and configuration | Critical |
| JTBD-PA-03 | Provide escalated support via user impersonation | High |
| JTBD-PA-04 | Monitor security events and system audit logs | Critical |
| JTBD-PA-05 | Manage platform-level user accounts and permissions | High |

### 2.2 Job Details

**JTBD-PA-01: System Configuration**
- When I need to configure platform behavior, I want to access centralized settings so that all tenants operate under consistent policies.

**JTBD-PA-02: Tenant Management**
- When a new PSP joins the platform, I want to onboard them efficiently so that they can begin operations with proper isolation and configuration.

**JTBD-PA-03: Support Escalation**
- When a user reports an issue I cannot reproduce, I want to impersonate their session so that I can diagnose and resolve problems accurately.

**JTBD-PA-04: Security Oversight**
- When security events occur, I want immediate visibility into audit logs so that I can respond to threats and maintain compliance.

---

## 3. Primary Workflows

### 3.1 Tenant Onboarding Workflow

1. Receive new PSP onboarding request
2. Create tenant configuration in system settings
3. Configure tenant-specific settings and limits
4. Create initial PSP Admin user account
5. Verify tenant isolation and access controls
6. Document configuration in audit log

### 3.2 User Impersonation Workflow

1. Receive escalated support request
2. Verify request legitimacy and document reason
3. Access user impersonation interface
4. Impersonate target user session
5. Diagnose reported issue
6. Exit impersonation and document findings
7. Resolve issue or escalate further

### 3.3 Security Monitoring Workflow

1. Access security dashboard
2. Review security events and alerts
3. Investigate anomalous activities
4. Take corrective action as needed
5. Document findings and actions in audit log
6. Update security policies if required

---

## 4. Key Screens Accessed

| Screen/Module | Purpose | Access Frequency |
|---------------|---------|------------------|
| Tenant Config | Create and manage PSP tenant configurations | As needed |
| System Settings | Configure platform-wide settings and policies | Weekly |
| User Impersonation | Access user sessions for support purposes | As needed |
| Security Dashboard | Monitor security events and threats | Daily |
| Full Audit Log | Review comprehensive system activity logs | Daily |

---

## 5. Permission Scope

### 5.1 Permission Summary

| Permission Category | Access Level |
|--------------------|--------------|
| System Configuration | Full Read/Write |
| Tenant Management | Full CRUD |
| User Management | All tenants |
| Audit Logs | Full Access |
| User Impersonation | Enabled |
| Security Settings | Full Read/Write |
| API/Webhook Configuration | Full Access |

### 5.2 Permission Constraints

- All impersonation sessions are logged with reason codes
- Security-critical changes require confirmation
- Audit log entries cannot be deleted or modified
- Password and credential access is restricted even during impersonation

---

## 6. Success Metrics

| Metric ID | Metric Name | Target | Measurement Method |
|-----------|-------------|--------|-------------------|
| PA-M01 | Tenant Onboarding Time | < 4 hours | Time from request to active tenant |
| PA-M02 | Support Escalation Resolution | < 2 hours | Time to resolve impersonation-assisted tickets |
| PA-M03 | Security Incident Response | < 30 minutes | Time from alert to initial response |
| PA-M04 | System Uptime | 99.9% | Platform availability monitoring |
| PA-M05 | Audit Log Completeness | 100% | Verification of logged actions |

---

## 7. Related Documents

- SRS-4.2 Permission Matrix
- SRS-4.1 Persona Matrix
- SUPP-001 Shared Foundations - Persona Workflows JTBD Screens

---

*Document generated per IEEE 830 SRS format for NewPOPSys v1.38*
