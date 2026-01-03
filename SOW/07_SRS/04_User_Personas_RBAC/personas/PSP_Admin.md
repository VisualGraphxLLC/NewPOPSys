# PSP Admin Persona

**Document ID:** SRS-4.4.2
**Version:** 1.0
**Date:** 2026-01-01
**System:** NewPOPSys v1.38
**Category:** PSP Level Persona

---

## 1. Persona Overview

| Attribute | Value |
|-----------|-------|
| Persona ID | PSP-002 |
| Role Name | PSP Admin |
| Level | PSP (Platform & Print Service Provider) |
| Primary Responsibility | Brand onboarding, PSP-level settings, user management, reporting and exports |
| Permission Level | PSP All Privileged |

### 1.1 Role Description

The PSP Admin manages operations for a Print Service Provider tenant within the NewPOPSys platform. This persona handles brand client onboarding, configures PSP-level settings, manages internal users, oversees reporting, and maintains integration configurations. The PSP Admin serves as the primary administrative contact between the PSP organization and its brand clients.

---

## 2. Jobs to Be Done (JTBD)

### 2.1 Primary Jobs

| Job ID | Job Statement | Priority |
|--------|---------------|----------|
| JTBD-PSPA-01 | Onboard new brand clients to the PSP tenant | Critical |
| JTBD-PSPA-02 | Configure and maintain PSP-level settings | High |
| JTBD-PSPA-03 | Manage PSP user accounts and permissions | High |
| JTBD-PSPA-04 | Generate and export operational reports | High |
| JTBD-PSPA-05 | Monitor campaign totals and fulfillment status | Medium |
| JTBD-PSPA-06 | Configure and monitor API/webhook integrations | Medium |

### 2.2 Job Details

**JTBD-PSPA-01: Brand Onboarding**
- When a new brand client signs with our PSP, I want to onboard them quickly so that they can begin creating campaigns and managing their stores.

**JTBD-PSPA-02: PSP Configuration**
- When operational requirements change, I want to update PSP settings so that our workflows align with business needs.

**JTBD-PSPA-03: User Management**
- When team members join or leave, I want to manage their access efficiently so that security is maintained and operations continue smoothly.

**JTBD-PSPA-04: Reporting and Exports**
- When stakeholders need operational data, I want to generate comprehensive reports so that informed decisions can be made.

**JTBD-PSPA-06: Integration Management**
- When connecting to external systems (MIS, ERP), I want to configure reliable integrations so that data flows automatically between systems.

---

## 3. Primary Workflows

### 3.1 Brand Onboarding Workflow

1. Receive brand onboarding request with requirements
2. Create brand configuration in PSP tenant
3. Configure brand-specific settings and defaults
4. Create Brand Admin user account(s)
5. Provide onboarding documentation and training resources
6. Verify brand access and initial configuration
7. Hand off to Brand Admin for store and campaign setup

### 3.2 User Management Workflow

1. Receive user access request or change notification
2. Verify authorization for requested access level
3. Create, modify, or deactivate user account
4. Assign appropriate role and permissions
5. Notify user of account status
6. Document changes in system log

### 3.3 Reporting and Export Workflow

1. Identify reporting requirements
2. Access exports center
3. Configure report parameters and filters
4. Generate report or schedule recurring export
5. Review output for accuracy
6. Distribute to stakeholders or integrate with external systems

### 3.4 Integration Configuration Workflow

1. Receive integration requirements
2. Configure API credentials and endpoints
3. Set up webhook subscriptions
4. Test integration connectivity
5. Monitor API/webhook logs for issues
6. Troubleshoot and resolve integration errors

---

## 4. Key Screens Accessed

| Screen/Module | Purpose | Access Frequency |
|---------------|---------|------------------|
| Brand Onboarding | Create and configure new brand clients | As needed |
| PSP Settings | Manage PSP-level configuration | Weekly |
| User Management | Create and manage user accounts | Weekly |
| Campaign List/Totals | Overview of all campaigns and metrics | Daily |
| Exports Center | Generate and manage data exports | Daily |
| Webhook/API Logs | Monitor integration health and debug issues | Daily |

---

## 5. Permission Scope

### 5.1 Permission Summary

| Permission Category | Access Level |
|--------------------|--------------|
| PSP Configuration | Full Read/Write |
| Brand Onboarding | Full CRUD |
| User Management | PSP-level users |
| Campaign Visibility | All PSP campaigns (read) |
| Reporting | Full Access |
| Exports | Full Access |
| API/Webhook Config | Full Read/Write |
| Audit Logs | PSP-level access |

### 5.2 Permission Constraints

- Cannot access Platform Admin functions
- Cannot impersonate users in other PSP tenants
- Cannot modify system-wide platform settings
- Brand-level campaign editing requires Brand Admin delegation

---

## 6. Success Metrics

| Metric ID | Metric Name | Target | Measurement Method |
|-----------|-------------|--------|-------------------|
| PSPA-M01 | Brand Onboarding Time | < 24 hours | Time from request to active brand |
| PSPA-M02 | User Provisioning Time | < 2 hours | Time from request to active account |
| PSPA-M03 | Report Generation Success | 100% | Successful export completions |
| PSPA-M04 | Integration Uptime | 99.5% | API/webhook availability |
| PSPA-M05 | Support Ticket Resolution | < 4 hours | Time to resolve brand-reported issues |

---

## 7. Related Documents

- SRS-4.2 Permission Matrix
- SRS-4.1 Persona Matrix
- SRS-4.4.1 Platform Admin Persona
- SUPP-001 Shared Foundations - Persona Workflows JTBD Screens

---

*Document generated per IEEE 830 SRS format for NewPOPSys v1.38*
