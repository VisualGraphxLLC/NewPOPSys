# Store Operator Persona Specification

**Document ID:** SRS-PERSONA-STORE-OPR
**Version:** 1.0
**Date:** 2026-01-01
**System:** NewPOPSys v1.38
**Classification:** Store Level

---

## 1. Persona Overview

### 1.1 Role Definition

The Store Operator is the front-line execution role responsible for completing campaign surveys, performing installations, and documenting proof of execution at the store level.

### 1.2 Primary Responsibility

Complete surveys, update status, request replacements (requires Store Manager approval), and view assigned campaigns.

### 1.3 Permission Level

**View Only + Execution** - Limited to viewing assigned campaigns and executing designated workflow tasks. Replacement requests require Store Manager approval.

---

## 2. Jobs to be Done (JTBD)

| Job ID | Job Statement | Priority |
|--------|---------------|----------|
| JTBD-SO-01 | Complete campaign installation tasks according to brand specifications | High |
| JTBD-SO-02 | Capture and upload proof photos meeting quality requirements | High |
| JTBD-SO-03 | Document item anomalies (missing/damaged/incorrect) with evidence | High |
| JTBD-SO-04 | Submit replacement requests for defective or missing items | Medium |
| JTBD-SO-05 | Complete pre-install checklists and safety acknowledgements | High |
| JTBD-SO-06 | Retake rejected photos until approved or waived | Medium |
| JTBD-SO-07 | Execute deinstall tasks when campaigns expire | Medium |

---

## 3. Primary Workflows

### 3.1 Campaign Execution Workflow

1. Receive campaign notification and review instructions, mockups, and due dates
2. Receive/Verify: confirm order-level receipt; record item-level anomalies (missing/damaged/incorrect) with photos/evidence as required
3. Submit major packaging damage as a single request (PSP may expand into item lines)
4. Complete pre-install checklist: safety, old campaign removal, readiness acknowledgements
5. Install per item and location slot; upload proof photos as-you-go; meet brand's required minimums and suggested angles
6. Complete completion survey with attestation checkbox (userId + timestamp)
7. Submission goes to review if STRICT mode, or completes immediately if FAST mode
8. If photos rejected: retake only rejected photos; resubmit until satisfied/waived
9. If campaign expires: complete deinstall task and end survey; proof optional/required per campaign

### 3.2 Replacement Request Workflow

1. Identify missing, damaged, or incorrect item during receive/verify
2. Document issue with required photos/evidence
3. Submit replacement request
4. Request enters Store Manager approval queue
5. Track request status (pending/approved/rejected)
6. Receive replacement upon fulfillment

### 3.3 Photo Retake Workflow

1. Receive notification of rejected photos with reason codes
2. Navigate to retake queue
3. Capture new photos addressing rejection reasons
4. Submit retakes for re-review
5. Repeat until approved or waived by reviewer

---

## 4. Key Screens/APIs Accessed

### 4.1 Screens

| Screen | Purpose | Access Level |
|--------|---------|--------------|
| My Tasks | View personal task assignments and deadlines | View + Execute |
| Campaign Detail | Review campaign instructions, mockups, timeline | View Only |
| Receive/Verify | Confirm order receipt and record anomalies | Execute |
| Issue/Reorder Request | Submit replacement requests (requires approval) | Execute |
| Pre-Install Checklist | Complete safety and readiness checks | Execute |
| Install + Proof Capture | Execute installation with photo documentation | Execute |
| Completion Survey + Attestation | Submit final survey and attestation | Execute |
| Retake Queue | View and address rejected photo retakes | Execute |
| Deinstall Task | Execute campaign removal when required | Execute |

### 4.2 API Endpoints

| Endpoint Category | Operations | Access |
|-------------------|------------|--------|
| `/store/campaigns` | GET (assigned only) | Read |
| `/store/tasks` | GET, PUT (own tasks) | Read/Update |
| `/store/orders` | GET (assigned) | Read |
| `/store/replacements` | POST (submit only) | Create |
| `/store/surveys` | GET, POST, PUT (own) | Full |
| `/store/proofs` | GET, POST (own) | Full |
| `/store/checklists` | GET, POST, PUT | Execute |

---

## 5. Permission Scope

### 5.1 Permission Matrix

| Permission | Granted | Notes |
|------------|---------|-------|
| View assigned campaigns | Yes | Assigned campaigns only |
| Execute campaign tasks | Yes | Own task assignments |
| Submit replacement requests | Yes | Requires Store Manager approval |
| Approve replacement requests | No | Store Manager only |
| Manage store team | No | Store Manager only |
| View store analytics | No | Store Manager only |
| View campaign history | Limited | Own completed tasks only |
| Escalate to Brand/Regional | No | Via Store Manager |
| Access other stores | No | Single store scope |
| View other operator tasks | No | Own tasks only |

### 5.2 Data Scope

- **Store Scope:** Single assigned store
- **Campaign Visibility:** Assigned campaigns only
- **Task Visibility:** Own assignments only
- **Historical Access:** Own completed work only

---

## 6. Success Metrics

| Metric ID | Metric | Target | Measurement |
|-----------|--------|--------|-------------|
| SO-M01 | Task completion rate | >= 95% | Completed on-time / Total assigned |
| SO-M02 | Photo quality pass rate | >= 90% | Approved first-try / Total submitted |
| SO-M03 | Anomaly documentation compliance | 100% | Documented with photos / Total reported |
| SO-M04 | Checklist completion rate | 100% | Completed / Required |
| SO-M05 | Retake turnaround time | < 24 hours | Rejection to retake submission |
| SO-M06 | Survey completion accuracy | >= 98% | Valid submissions / Total submissions |

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
