# Store Manager Persona Specification

**Document ID:** SRS-PERSONA-STORE-MGR
**Version:** 1.0
**Date:** 2026-01-01
**System:** NewPOPSys v1.38
**Classification:** Store Level

---

## 1. Persona Overview

### 1.1 Role Definition

The Store Manager is the primary authority at the store level, responsible for team management, campaign execution oversight, and approval workflows within their assigned store location.

### 1.2 Primary Responsibility

Manage store team, approve replacement requests, view all store campaigns, and exercise full execution permissions for store-level operations.

### 1.3 Permission Level

**Full Store Privileges** - Complete access to all store-level functions including team management, approval workflows, analytics, and campaign history.

---

## 2. Jobs to be Done (JTBD)

| Job ID | Job Statement | Priority |
|--------|---------------|----------|
| JTBD-SM-01 | Oversee and manage store team members executing campaigns | High |
| JTBD-SM-02 | Approve or reject replacement requests submitted by Store Operators | High |
| JTBD-SM-03 | Monitor all active and historical campaigns for the store | Medium |
| JTBD-SM-04 | Ensure timely completion of campaign installations and surveys | High |
| JTBD-SM-05 | Review store analytics and performance metrics | Medium |
| JTBD-SM-06 | Escalate issues requiring Brand or Regional Manager intervention | Low |

---

## 3. Primary Workflows

### 3.1 Campaign Execution Workflow

1. Receive campaign notification and review instructions, mockups, and due dates
2. Receive/Verify: confirm order-level receipt; record item-level anomalies (missing/damaged/incorrect) with photos/evidence as required
3. Submit major packaging damage as a single request (PSP may expand into item lines)
4. Complete pre-install checklist: safety, old campaign removal, readiness acknowledgements
5. Install per item and location slot; upload proof photos as-you-go; meet brand's required minimums and suggested angles
6. Complete completion survey with attestation checkbox (userId + timestamp)
7. If photos rejected: retake only rejected photos; resubmit until satisfied/waived
8. If campaign expires: complete deinstall task and end survey

### 3.2 Approval Workflow

1. Review pending replacement requests from Store Operators
2. Evaluate request validity against campaign requirements
3. Approve or reject with documented reason
4. Track approved requests through fulfillment

### 3.3 Team Management Workflow

1. View team roster and role assignments
2. Monitor individual operator task progress
3. Reassign tasks as needed for coverage

---

## 4. Key Screens/APIs Accessed

### 4.1 Screens

| Screen | Purpose | Access Level |
|--------|---------|--------------|
| My Tasks | View and manage personal task assignments | Full |
| Campaign Detail | Review campaign instructions, mockups, timeline | Full |
| Receive/Verify | Confirm order receipt and record anomalies | Full |
| Issue/Reorder Request | Submit and manage replacement requests | Full |
| Pre-Install Checklist | Complete safety and readiness checks | Full |
| Install + Proof Capture | Execute installation with photo documentation | Full |
| Completion Survey + Attestation | Submit final survey and attestation | Full |
| Retake Queue | Manage rejected photo retakes | Full |
| Deinstall Task | Execute campaign removal when required | Full |
| Team Management | Manage store team roster and assignments | Full |
| Replacement Approvals | Review and approve/reject operator requests | Full |
| Store Analytics | View store performance metrics | Full |
| Store Campaign History | Access historical campaign records | Full |

### 4.2 API Endpoints

| Endpoint Category | Operations | Access |
|-------------------|------------|--------|
| `/store/team` | GET, POST, PUT | Full |
| `/store/campaigns` | GET | Full |
| `/store/orders` | GET, PUT | Full |
| `/store/replacements` | GET, POST, PUT (approve/reject) | Full |
| `/store/surveys` | GET, POST, PUT | Full |
| `/store/proofs` | GET, POST | Full |
| `/store/analytics` | GET | Full |

---

## 5. Permission Scope

### 5.1 Permission Matrix

| Permission | Granted | Notes |
|------------|---------|-------|
| View all store campaigns | Yes | Full visibility |
| Execute campaign tasks | Yes | All workflow steps |
| Submit replacement requests | Yes | Direct submission |
| Approve replacement requests | Yes | For Store Operator requests |
| Manage store team | Yes | Roster and assignments |
| View store analytics | Yes | Performance dashboards |
| View campaign history | Yes | Full historical access |
| Escalate to Brand/Regional | Yes | Via in-app comments |
| Access other stores | No | Single store scope |
| Brand configuration | No | Store level only |

### 5.2 Data Scope

- **Store Scope:** Single assigned store
- **Campaign Visibility:** All campaigns assigned to store
- **User Management:** Store team members only
- **Historical Access:** Full store history

---

## 6. Success Metrics

| Metric ID | Metric | Target | Measurement |
|-----------|--------|--------|-------------|
| SM-M01 | Campaign completion rate | >= 95% | Completed on-time / Total assigned |
| SM-M02 | Replacement approval turnaround | < 4 hours | Request to decision time |
| SM-M03 | Photo rejection rate | < 10% | Rejected photos / Total submitted |
| SM-M04 | Team task completion | >= 90% | Operator tasks completed on-time |
| SM-M05 | Anomaly documentation rate | 100% | Anomalies with photos / Total anomalies |
| SM-M06 | Deinstall compliance | >= 98% | On-time deinstalls / Required deinstalls |

---

## 7. References

- SUPP-001: Shared Foundations - Persona Workflows JTBD Screens
- SRS 4.1: Persona Matrix
- SRS 4.2: Permission Matrix

---

**Document Control**

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 2026-01-01 | System | Initial persona specification |
