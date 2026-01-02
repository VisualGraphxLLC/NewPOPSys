# Regional Manager Persona

**Document ID:** SRS-4.4.3
**Version:** 1.0
**System:** NewPOPSys v1.38
**Category:** Brand Level Persona
**Last Updated:** 2026-01-01

---

## 1. Persona Overview

### 1.1 Role Definition

The Regional Manager operates with an exception-first workflow, focusing on store compliance within an assigned geographic segment or store group. This persona monitors execution quality, manages exception queues, reviews proofs, and escalates critical issues to Brand Admin. Regional Managers serve as the primary compliance oversight for their assigned store portfolio.

### 1.2 Primary Responsibility

Oversee assigned stores, manage exception queues, approve/reject proofs, and escalate issues to Brand Admin.

### 1.3 Permission Level

**Store Compliance for segment** - Access scoped to:
- Stores explicitly assigned to the Regional Manager's segment
- Campaign execution data for assigned stores only
- Exception and compliance queues filtered to assigned stores
- Limited administrative actions (waivers where policy allows)

---

## 2. Jobs to Be Done (JTBD)

### 2.1 Primary Jobs

| Job ID | Job Statement | Priority |
|--------|---------------|----------|
| RM-J01 | Monitor exception queue to identify and resolve store execution issues | Critical |
| RM-J02 | Review and approve/reject proof submissions for assigned stores | Critical |
| RM-J03 | Track store compliance rates across assigned segment | Critical |
| RM-J04 | Request retakes and reopen stores for corrective action | High |
| RM-J05 | Apply completion waivers where policy allows (with documented reason) | High |
| RM-J06 | Escalate critical issues to Brand Admin via in-app notification | High |
| RM-J07 | Identify patterns of non-compliance for regional coaching | Medium |

### 2.2 Functional Requirements

- **FR-RM-001:** The system shall filter all queues and dashboards to show only stores assigned to the Regional Manager.
- **FR-RM-002:** The system shall prioritize exception queue items by severity and time overdue.
- **FR-RM-003:** The system shall enable Regional Manager to apply waivers only where brand policy permits.
- **FR-RM-004:** The system shall provide in-app escalation with comment and notification trigger to Brand Admin.
- **FR-RM-005:** The system shall log all waiver applications with user ID, timestamp, and mandatory reason.

---

## 3. Primary Workflows

### 3.1 Exception Queue Workflow (Primary)

The Regional Manager operates from an exception-first model, prioritizing resolution of issues over routine monitoring.

1. **Access Exception Queue**
   - View filtered list of stores with outstanding exceptions
   - Sort by severity: critical > high > medium > low
   - Sort by time: most overdue first

2. **Exception Types Handled**
   - **Overdue Execution:** Store has not completed installation by deadline
   - **Missing Proofs:** Installation marked complete but photos not submitted
   - **Rejected Proofs:** Photos previously rejected, awaiting retake
   - **Deinstall Overdue:** Campaign expired, deinstall not completed (if enabled)
   - **Severe Anomalies:** Significant discrepancies flagged by system

3. **Resolution Actions**
   - Contact store for status update (external to system)
   - Request retakes for quality issues
   - Reopen store execution for corrective action
   - Apply completion waiver (where policy allows, reason required)
   - Escalate to Brand Admin for issues beyond authority

### 3.2 Proof Review Workflow

1. Access Review Queue filtered to assigned stores.
2. Open proof submission (photo + slot packet).
3. Evaluate photos against quality standards and requirements.
4. For acceptable submissions: approve to complete store execution.
5. For unacceptable submissions:
   - Reject specific photos with reason codes
   - Store receives retake notification automatically
6. Monitor Retake Queue for resubmissions.
7. Escalate persistent quality issues to Brand Admin.

### 3.3 Escalation Workflow

1. Identify issue requiring Brand Admin intervention:
   - Policy exceptions beyond Regional Manager authority
   - Systemic issues affecting multiple stores
   - Critical compliance failures
   - Resource or timeline conflicts

2. Initiate in-app escalation:
   - Add detailed comment describing issue
   - Select escalation type/category
   - System triggers notification to Brand Admin

3. Track escalation status in queue.
4. Receive resolution notification and implement as directed.

---

## 4. Key Screens Accessed

| Screen/Module | Purpose | Access Frequency |
|---------------|---------|------------------|
| Exception Queue | Primary work queue for compliance issues | Multiple times daily |
| Store Compliance Dashboard | Overview of segment performance metrics | Daily |
| Review Queue | Approve or reject proof submissions | Daily |
| Retake Queue | Monitor and manage photo retake requests | Daily |
| Waivers/Reopen | Apply waivers and reopen store execution | As needed |
| Escalation Tools | Initiate and track Brand Admin escalations | As needed |

---

## 5. Permission Scope

### 5.1 Data Access

| Resource Type | Create | Read | Update | Delete |
|---------------|--------|------|--------|--------|
| Stores (Assigned Segment) | No | Yes | Limited | No |
| Stores (Other Segments) | No | No | No | No |
| Campaigns | No | Yes | No | No |
| Proofs (Assigned Stores) | No | Yes | Yes | No |
| Exception Queue (Assigned) | No | Yes | Yes | No |
| Waivers | Yes* | Yes | No | No |
| Escalations | Yes | Yes | Yes | No |

*Waiver creation restricted by brand policy configuration.

### 5.2 Compliance Actions

- Approve proof submissions for assigned stores
- Reject individual photos with reason codes
- Request retakes from stores
- Reopen store execution for corrective action
- Apply completion waivers (where brand policy allows)
- Create escalations to Brand Admin with comments

### 5.3 Restricted Actions

- Cannot modify campaign configuration
- Cannot access stores outside assigned segment
- Cannot manage user accounts or permissions
- Cannot override brand policy restrictions on waivers
- Cannot force-complete without waiver authority

---

## 6. Success Metrics

### 6.1 Key Performance Indicators

| Metric ID | Metric Name | Target | Measurement Frequency |
|-----------|-------------|--------|----------------------|
| RM-KPI-01 | Exception Queue Clearance Rate | >= 90% within SLA | Daily |
| RM-KPI-02 | Segment Compliance Rate | >= 95% | Weekly |
| RM-KPI-03 | Proof Review Turnaround | <= 24 hours | Daily |
| RM-KPI-04 | Escalation Resolution Time | <= 48 hours | Weekly |
| RM-KPI-05 | Waiver Usage Rate | <= 5% of completions | Per campaign |
| RM-KPI-06 | Repeat Exception Rate | <= 10% | Monthly |

### 6.2 Quality Indicators

- Exception queue reviewed minimum twice daily
- All waivers documented with valid business justification
- Escalations include complete context for Brand Admin
- Zero stores in segment exceed maximum overdue threshold

---

## 7. References

- SUPP-001: Shared Foundations - Persona Workflows JTBD Screens
- SRS-4.1: Persona Matrix
- SRS-4.2: Permission Matrix

---

*Document Control: This persona specification is part of the NewPOPSys v1.38 SRS documentation suite.*
