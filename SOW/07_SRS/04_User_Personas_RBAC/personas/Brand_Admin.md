# Brand Admin Persona

**Document ID:** SRS-4.4.1
**Version:** 1.0
**System:** NewPOPSys v1.38
**Category:** Brand Level Persona
**Last Updated:** 2026-01-01

---

## 1. Persona Overview

### 1.1 Role Definition

The Brand Admin is the highest-authority user within a brand's organizational hierarchy. This persona has full administrative control over brand configuration, campaign management, store operations, and user permissions. Brand Admins serve as the primary point of accountability for all POP marketing execution activities within their brand.

### 1.2 Primary Responsibility

Full brand configuration, all campaigns access, store management, and user permissions administration.

### 1.3 Permission Level

**Brand Level Privileged** - Complete read/write access to all brand resources, including:
- All campaign data regardless of assignment
- All store records within the brand
- All user accounts at brand and store levels
- Brand-wide configuration settings
- Full reporting and export capabilities

---

## 2. Jobs to Be Done (JTBD)

### 2.1 Primary Jobs

| Job ID | Job Statement | Priority |
|--------|---------------|----------|
| BA-J01 | Configure brand-level settings and defaults to ensure consistent campaign execution | Critical |
| BA-J02 | Manage all campaigns across the brand portfolio without assignment restrictions | Critical |
| BA-J03 | Administer user accounts and permission assignments for Campaign Managers and Regional Managers | Critical |
| BA-J04 | Monitor brand-wide compliance and performance through comprehensive reporting | High |
| BA-J05 | Apply waivers or force-complete campaigns when business exceptions require (with audit trail) | High |
| BA-J06 | Escalate critical issues to PSP Admin when platform-level intervention is needed | Medium |

### 2.2 Functional Requirements

- **FR-BA-001:** The system shall provide Brand Admin access to all campaigns without requiring explicit assignment.
- **FR-BA-002:** The system shall allow Brand Admin to create, modify, and deactivate user accounts at brand and store levels.
- **FR-BA-003:** The system shall enable Brand Admin to configure brand-wide defaults for photo rules, verification modes, and SLAs.
- **FR-BA-004:** The system shall generate audit logs for all waiver and force-complete actions performed by Brand Admin.

---

## 3. Primary Workflows

### 3.1 Campaign Management Workflow

1. Define campaign parameters: type (expiring vs. core branding), timeline, instructions, verificationMode (STRICT/FAST), verification SLA, deinstall rules.
2. Define kit contents: items with required location slot mappings; attach mockups/reference images; configure photo rules (defaults + overrides).
3. Select target stores using all/region/group/custom includes and exclusions; preview selection recipe.
4. Publish campaign to initiate store assignments and order generation.
5. Monitor dashboard metrics: completion percentage, late shipping, anomalies, issue counts, rejection counts.
6. Review proofs (photo + slot packet); reject specific photos with reason codes; approve when satisfied.
7. Apply waivers or force-complete when business conditions require (reason + audit mandatory).

### 3.2 User Administration Workflow

1. Access brand user management interface.
2. Create or modify Campaign Manager accounts with campaign assignments.
3. Create or modify Regional Manager accounts with store segment assignments.
4. Review and adjust permission levels as organizational needs change.
5. Deactivate user accounts upon role termination.

---

## 4. Key Screens Accessed

| Screen/Module | Purpose | Access Frequency |
|---------------|---------|------------------|
| Campaign Builder | Create and configure new campaigns | Weekly |
| Store Selector | Define store participation for campaigns | Weekly |
| Kit/Items Editor | Configure kit contents and location mappings | Weekly |
| Photo Rules | Set brand defaults and campaign overrides | As needed |
| Dashboard | Monitor campaign performance metrics | Daily |
| Store Detail | View individual store execution status | Daily |
| Review Queue | Approve or reject proof submissions | Daily |
| Retake Queue | Monitor and manage photo retake requests | Daily |
| Brand Config | Configure brand-level settings and defaults | Monthly |
| Store Management | Administer store records and attributes | As needed |
| User Permissions | Manage brand and store user accounts | As needed |
| Full Brand Reporting | Generate comprehensive performance reports | Weekly |
| Exports/Reports | Export data for external analysis | As needed |

---

## 5. Permission Scope

### 5.1 Data Access

| Resource Type | Create | Read | Update | Delete |
|---------------|--------|------|--------|--------|
| Brand Configuration | Yes | Yes | Yes | No |
| Campaigns (All) | Yes | Yes | Yes | Yes |
| Stores | Yes | Yes | Yes | Yes |
| Users (Brand Level) | Yes | Yes | Yes | Yes |
| Users (Store Level) | Yes | Yes | Yes | Yes |
| Reports | Yes | Yes | N/A | N/A |
| Audit Logs | No | Yes | No | No |

### 5.2 Administrative Actions

- Assign/unassign Campaign Managers to campaigns
- Assign/unassign Regional Managers to store segments
- Apply completion waivers with mandatory reason documentation
- Force-complete campaigns with mandatory reason documentation
- Configure verification mode (STRICT/FAST) per campaign
- Set brand-wide photo rule defaults

---

## 6. Success Metrics

### 6.1 Key Performance Indicators

| Metric ID | Metric Name | Target | Measurement Frequency |
|-----------|-------------|--------|----------------------|
| BA-KPI-01 | Campaign Completion Rate | >= 95% | Per campaign |
| BA-KPI-02 | Average Time to Proof Approval | <= 24 hours | Weekly |
| BA-KPI-03 | Exception Resolution Time | <= 48 hours | Weekly |
| BA-KPI-04 | User Account Accuracy | 100% active users valid | Monthly |
| BA-KPI-05 | Waiver Usage Rate | <= 5% of completions | Per campaign |
| BA-KPI-06 | Late Shipping Incidents | <= 3% of orders | Per campaign |

### 6.2 Quality Indicators

- Zero unauthorized access incidents from misconfigured permissions
- Complete audit trail for all administrative actions
- All waivers documented with valid business justification

---

## 7. References

- SUPP-001: Shared Foundations - Persona Workflows JTBD Screens
- SRS-4.1: Persona Matrix
- SRS-4.2: Permission Matrix

---

*Document Control: This persona specification is part of the NewPOPSys v1.38 SRS documentation suite.*
