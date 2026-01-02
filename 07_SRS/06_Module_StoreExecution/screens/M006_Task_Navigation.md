# M006 - Task Navigation
 
 > **Module**: Store Execution (Mobile PWA)
 > **Screen ID**: M006
 > **Route**: `/app/tasks`
 > **IEEE 830 Section**: 3.2.6 - User Interface Requirements
 > **Version**: 1.1
 > **Last Updated**: 2026-01-02
 
 ---
 
 ## 1. Screen Overview
 
 ### 1.1 Purpose
 
 The Task Navigation screen (formerly Tasks List) provides a consolidated view of all pending work items for the store user. Tasks are dynamically derived from entity states and grouped by phase (Receive, Install, Deinstall, Attest).
 
 ### 1.2 Scope
 
 This specification covers:
 - Task derivation from entity states
 - Task list display with filtering (Receive / Install / Deinstall)
 - Priority calculation and sorting
 - Attestation workflow entry points
 
 ### 1.3 Screenshot Reference
 
 | Mobile View | Tablet View | Desktop View |
 | :--- | :--- | :--- |
 | ![Mobile Tasks](../../screenshots/Store_Execution/mobile_tasks_receive.png) | ![Tablet Tasks](../../screenshots/Store_Execution/tablet_tasks_receive.png) | ![Desktop Tasks](../../screenshots/Store_Execution/desktop_tasks_receive.png) |

### 1.4 Source Documents

| Document | Reference |
|----------|-----------|
| Screen Spec | [M06_Tasks.md](../../../../06_Screen_Specs/M06_Tasks.md) |
| SUPP Reference | SUPP-017 (Store Execution) |
| Attestation | [4.3_Authentication_Flows.md](../../04_User_Personas_RBAC/4.3_Authentication_Flows.md) |

---

## 2. User Roles & Permissions

### 2.1 Authorized Roles

| Role | Access Level | Description |
|------|--------------|-------------|
| Store Manager (P07) | Full | Can view all tasks, submit attestations |
| Store Operator (P08) | Execute | Can view and execute assigned tasks |

### 2.2 Role Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M006-ROLE-001 | System SHALL display tasks for user's assigned store | Must |
| REQ-M006-ROLE-002 | System SHALL allow task execution for both STORE_MANAGER and STORE_OPERATOR | Must |
| REQ-M006-ROLE-003 | System SHALL restrict attestation submission to authenticated users only | Must |
| REQ-M006-ROLE-004 | System SHALL record attesting user's identity with signature | Must |

### 2.3 Permission Constraints

- User must have active `Membership` for the store
- Tasks visible only for campaigns assigned to user's store
- Attestation requires all mandatory photos to be uploaded

---

## 3. UI Components

### 3.1 Component Inventory

| Component ID | Type | Description | Required |
|--------------|------|-------------|----------|
| COMP-M006-001 | Header | App bar with "My Tasks" title and filter button | Yes |
| COMP-M006-002 | Filter Chips | Chip group: All, Receipts, Installs, Retakes | Yes |
| COMP-M006-003 | Task List | Card list grouped by priority/due date | Yes |
| COMP-M006-004 | Task Card | Type icon, title, campaign, due date | Yes |
| COMP-M006-005 | Badge | Count indicator for total pending tasks | Yes |
| COMP-M006-006 | Empty State | "All caught up!" message when no tasks | Yes |
| COMP-M006-007 | Attestation Summary | Location completion checklist | Conditional |
| COMP-M006-008 | Certification Checkbox | Legal attestation agreement | Conditional |
| COMP-M006-009 | Signature Canvas | Touch/stylus signature capture | Conditional |
| COMP-M006-010 | Submit Button | Final submission trigger | Conditional |

### 3.2 Component Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M006-UI-001 | Task cards SHALL display type icon, title, campaign name, and due date | Must |
| REQ-M006-UI-002 | Tasks SHALL be sorted by priority (HIGH first), then due date | Must |
| REQ-M006-UI-003 | Filter chips SHALL immediately filter displayed tasks | Must |
| REQ-M006-UI-004 | Badge SHALL show total pending task count | Must |
| REQ-M006-UI-005 | Empty state SHALL display when no tasks match filter | Must |
| REQ-M006-UI-006 | Signature canvas SHALL capture touch/stylus input | Must |

### 3.3 Task Card Layout

```
+---------------------------------------+
| [Icon] HIGH                Due: Today |
|                                       |
| Retake Required                       |
| Summer Promo - Front Window Poster    |
|                                       |
| "Wrong angle - please recapture"      |
|                                       |
|                      [View Details >] |
+---------------------------------------+

+---------------------------------------+
| [Icon] MEDIUM            Due: 3 days  |
|                                       |
| Verify Shipment Receipt               |
| Holiday Campaign                      |
|                                       |
| 5 items delivered                     |
|                                       |
|                          [Start >]    |
+---------------------------------------+
```

### 3.4 Attestation Screen Layout

**Route**: `/app/campaign/:id/submit`

```
+---------------------------------------+
| Submit Installation               [X] |
+---------------------------------------+
|                                       |
| Summary                               |
| +-----------------------------------+ |
| | [check] Front Window (2 items)    | |
| | [check] End Cap A (1 item)        | |
| | [check] Checkout Counter (2 items)| |
| +-----------------------------------+ |
|                                       |
| Photos: 8 uploaded                    |
|                                       |
| +-----------------------------------+ |
| | [ ] I certify that all items      | |
| |     shown above are installed     | |
| |     correctly at this store.      | |
| +-----------------------------------+ |
|                                       |
| Signature:                            |
| +-----------------------------------+ |
| |     [Signature Canvas]            | |
| +-----------------------------------+ |
|                                       |
| [Cancel]              [Submit]        |
+---------------------------------------+
```

---

## 4. Data Requirements

### 4.1 Input Data

| Field | Type | Validation | Source |
|-------|------|------------|--------|
| `store_id` | UUID | Required, active store | Auth context |
| `filter_type` | Enum | Optional: ALL, RECEIPT, INSTALL, RETAKE | User selection |

### 4.2 Output Data

| Field | Type | Description | Destination |
|-------|------|-------------|-------------|
| `attestation_text` | String | Certification statement text | Database |
| `attested_at` | Timestamp | When user attested | Database |
| `attested_by` | UUID | User who attested | Database |
| `signature_url` | URL | Signature image storage location | Database |

### 4.3 Task Derivation Rules

Tasks are dynamically generated from entity states:

```
RECEIPT tasks:
  - StoreAssignment WHERE store_phase = READY_TO_RECEIVE

INSTALL tasks:
  - AssignmentItem WHERE item_status = RECEIVED
  - Grouped by LocationSlot

RETAKE tasks:
  - PhotoUpload WHERE review_status = REJECTED

ISSUE_UPDATE tasks:
  - IssueRequest WHERE status changed (RESOLVED, etc.)
```

### 4.4 Data Model References

| Entity | Fields Used | Access |
|--------|-------------|--------|
| `StoreAssignment` | id, status, store_phase | Read |
| `AssignmentItem` | id, item_status | Read |
| `Campaign` | name, install_end_date | Read |
| `PhotoReview` | status, rejection_reason | Read |
| `IssueRequest` | status, resolution_notes | Read |
| `CompletionAttestation` | attested_at, attested_by, signature_url | Write |

### 4.5 Data Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M006-DATA-001 | System SHALL derive tasks from entity states, not store separately | Must |
| REQ-M006-DATA-002 | System SHALL include campaign name and due date in task data | Must |
| REQ-M006-DATA-003 | System SHALL store attestation with signature image | Must |
| REQ-M006-DATA-004 | System SHALL capture attestation timestamp in UTC | Must |

---

## 5. Business Rules & Validation

### 5.1 Task Type Definitions

| Type | Icon | Description | Navigation |
|------|------|-------------|------------|
| RECEIPT | Package icon | Verify shipment delivery | M003 Receipt Survey |
| INSTALL | Wrench icon | Install items at locations | M004 Install Survey |
| RETAKE | Camera icon | Recapture rejected photos | M008 Retake Flow |
| ISSUE_UPDATE | Info icon | View issue resolution | Modal with details |

### 5.2 Priority Calculation Rules

| Rule ID | Priority | Criteria |
|---------|----------|----------|
| BR-M006-001 | HIGH | Due today or overdue |
| BR-M006-002 | HIGH | Retake required (blocking completion) |
| BR-M006-003 | MEDIUM | Due within 3 days |
| BR-M006-004 | MEDIUM | Issue resolved (acknowledgment needed) |
| BR-M006-005 | LOW | Due in 4+ days |

### 5.3 Filter Options

| Filter | Shows |
|--------|-------|
| All | All pending tasks |
| Receipts | RECEIPT type only |
| Installs | INSTALL type only |
| Retakes | RETAKE type only |
| Overdue | Past due date |

### 5.4 Attestation Rules

| Rule ID | Rule | Implementation |
|---------|------|----------------|
| BR-M006-006 | All locations must be complete | Check all AssignmentItems have item_status = INSTALLED |
| BR-M006-007 | Certification checkbox required | Checkbox must be checked before Submit enabled |
| BR-M006-008 | Signature required | Signature canvas must contain input |
| BR-M006-009 | Attestation is irrevocable | Once submitted, cannot be undone |

### 5.5 Validation Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M006-VAL-001 | System SHALL prevent attestation if any location incomplete | Must |
| REQ-M006-VAL-002 | System SHALL require certification checkbox before submit | Must |
| REQ-M006-VAL-003 | System SHALL require signature before submit | Must |
| REQ-M006-VAL-004 | System SHALL validate all required photos uploaded | Must |

---

## 6. API Integration Points

### 6.1 Get Tasks Endpoint

| Property | Value |
|----------|-------|
| **Endpoint** | `GET /api/v1/stores/{storeId}/tasks` |
| **Auth Required** | Yes (Bearer token) |

#### Response Schema (Success - 200)

```json
{
  "tasks": [
    {
      "id": "derived-uuid",
      "type": "RETAKE",
      "priority": "HIGH",
      "title": "Retake Required",
      "subtitle": "Summer Promo - Front Window Poster",
      "description": "Wrong angle - please recapture",
      "due_date": "2026-01-01",
      "campaign_id": "uuid",
      "campaign_name": "Summer Promo",
      "assignment_item_id": "uuid",
      "photo_upload_id": "uuid"
    }
  ],
  "counts": {
    "total": 5,
    "high_priority": 2,
    "overdue": 1
  }
}
```

### 6.2 Submit Attestation Endpoint

| Property | Value |
|----------|-------|
| **Endpoint** | `POST /api/v1/assignments/{id}/submit` |
| **Auth Required** | Yes (Bearer token) |

#### Request Schema

```json
{
  "attestation_text": "I certify that all items shown above are installed correctly at this store.",
  "signature_data": "data:image/png;base64,..."
}
```

#### Response Schema (Success - 200)

```json
{
  "assignment_id": "uuid",
  "status": "SUBMITTED",
  "attested_at": "2026-01-01T14:30:00Z",
  "attested_by": "uuid",
  "signature_url": "https://cdn.example.com/signatures/uuid.png"
}
```

### 6.3 API Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M006-API-001 | System SHALL aggregate tasks from multiple entity sources | Must |
| REQ-M006-API-002 | System SHALL include priority and due date in task response | Must |
| REQ-M006-API-003 | System SHALL upload signature image before submission | Must |
| REQ-M006-API-004 | System SHALL update assignment status to SUBMITTED on success | Must |

---

## 7. State Transitions

### 7.1 Task Navigation State Machine

```
[TASK_LIST] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚                         â”‚
   â”‚ Tap task card           â”‚
   â–¼                         â”‚
[DETERMINE_TYPE]             â”‚
   â”‚                         â”‚
   â”œâ”€â”€ RECEIPT â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€ Navigate to M003
   â”‚                         â”‚
   â”œâ”€â”€ INSTALL â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€ Navigate to M004
   â”‚                         â”‚
   â”œâ”€â”€ RETAKE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€ Navigate to M008
   â”‚                         â”‚
   â””â”€â”€ ISSUE_UPDATE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€ Show modal
                             â”‚
                    [TASK_LIST] (on return)
```

### 7.2 Attestation Submission State Machine

```
[REVIEW_SUMMARY] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚                            â”‚
   â”‚ All locations complete?    â”‚ No
   â”‚ â–¼                          â–¼
   â”‚ Yes                    [BLOCKED]
   â–¼
[CHECKBOX_REQUIRED]
   â”‚
   â”‚ Check certification
   â–¼
[SIGNATURE_REQUIRED]
   â”‚
   â”‚ Sign canvas
   â–¼
[SUBMIT_ENABLED]
   â”‚
   â”‚ Tap Submit
   â–¼
[SUBMITTING]
   â”‚
   â”‚ API success
   â–¼
[SUBMITTED] â”€â”€â”€â”€â”€â”€â”€â”€ Navigate to Dashboard
```

### 7.3 Assignment Status After Attestation

```
StoreAssignment.status:
  IN_PROGRESS â†’ SUBMITTED

CompletionAttestation:
  Created with attested_at, attested_by, signature_url
```

### 7.4 State Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M006-STATE-001 | System SHALL navigate to appropriate screen based on task type | Must |
| REQ-M006-STATE-002 | System SHALL update assignment status on successful submission | Must |
| REQ-M006-STATE-003 | System SHALL create CompletionAttestation record | Must |
| REQ-M006-STATE-004 | System SHALL return to Dashboard after successful submission | Must |

---

## 8. Error Handling

### 8.1 Error Categories

| Category | Handling Approach |
|----------|-------------------|
| Network Errors | Retry with offline queue |
| Incomplete Tasks | Block submission, show missing items |
| Signature Failure | Allow retry, preserve canvas |
| Submission Failure | Retry button, preserve attestation state |

### 8.2 Error Messages

| Error Code | User Message | Technical Action |
|------------|--------------|------------------|
| `INCOMPLETE_LOCATIONS` | "Complete all locations before submitting." | Highlight incomplete items |
| `MISSING_PHOTOS` | "{X} required photos not yet uploaded." | List missing items |
| `SIGNATURE_REQUIRED` | "Please sign before submitting." | Focus signature canvas |
| `SUBMISSION_FAILED` | "Submission failed. Please try again." | Retry button |
| `NETWORK_ERROR` | "Unable to connect. Check your connection." | Retry with offline support |

### 8.3 Attestation Validation Errors

| Validation | Error Display |
|------------|---------------|
| Locations incomplete | Red indicator on incomplete locations |
| Photos missing | Count of missing photos shown |
| Checkbox unchecked | Submit button disabled |
| Signature empty | Submit button disabled |

### 8.4 Error Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M006-ERR-001 | System SHALL display specific errors for incomplete attestation | Must |
| REQ-M006-ERR-002 | System SHALL preserve signature canvas on submission retry | Should |
| REQ-M006-ERR-003 | System SHALL highlight incomplete locations visually | Must |
| REQ-M006-ERR-004 | System SHALL allow retry for failed submissions | Must |

---

## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance

| Req ID | Requirement | WCAG Criterion | Priority |
|--------|-------------|----------------|----------|
| REQ-M006-A11Y-001 | Task cards SHALL be navigable via keyboard/switch | 2.1.1 Keyboard | Must |
| REQ-M006-A11Y-002 | Priority indicators SHALL use icons and text, not color alone | 1.4.1 Use of Color | Must |
| REQ-M006-A11Y-003 | Signature canvas SHALL have alternative text input option | 1.1.1 Non-text Content | Should |
| REQ-M006-A11Y-004 | Filter state changes SHALL be announced by screen readers | 4.1.3 Status Messages | Must |
| REQ-M006-A11Y-005 | Touch targets SHALL be minimum 44x44 pixels | 2.5.5 Target Size | Must |

### 9.2 Assistive Technology Support

| Feature | Implementation |
|---------|----------------|
| Screen Reader | ARIA labels on task cards, live regions for filters |
| Voice Control | Named buttons and actions |
| Signature Alternative | Type-to-sign option for motor impairments |
| Large Text | Responsive scaling up to 200% |

### 9.3 ARIA Implementation

```html
<div role="main" aria-labelledby="tasks-heading">
  <h1 id="tasks-heading">My Tasks <span aria-label="5 tasks">(5)</span></h1>

  <div role="group" aria-label="Task filters">
    <button role="radio" aria-checked="true">All</button>
    <button role="radio" aria-checked="false">Receipts</button>
    <button role="radio" aria-checked="false">Installs</button>
    <button role="radio" aria-checked="false">Retakes</button>
  </div>

  <ul role="list" aria-label="Task list">
    <li role="listitem">
      <article aria-labelledby="task-1-title">
        <span aria-label="High priority">HIGH</span>
        <h2 id="task-1-title">Retake Required</h2>
        <p>Summer Promo - Front Window Poster</p>
        <time datetime="2026-01-01">Due: Today</time>
        <button>View Details</button>
      </article>
    </li>
  </ul>
</div>
```

---

## 10. Acceptance Criteria

### 10.1 Functional Acceptance

| AC ID | Criterion | Verification Method |
|-------|-----------|---------------------|
| AC-M006-001 | Tasks list shows all pending work for store | API integration test |
| AC-M006-002 | Tasks grouped/sorted by priority and due date | Manual test |
| AC-M006-003 | Task cards show type, campaign, due date | Manual test |
| AC-M006-004 | Tapping task navigates to appropriate screen | E2E test |
| AC-M006-005 | Filter chips filter task list by type | Manual test |
| AC-M006-006 | Badge shows total pending count | Manual test |
| AC-M006-007 | Attestation required before final submit | E2E test |
| AC-M006-008 | Signature capture works on touch devices | Manual test |
| AC-M006-009 | Empty state shown when no tasks | Manual test |

### 10.2 Non-Functional Acceptance

| AC ID | Criterion | Target | Verification |
|-------|-----------|--------|--------------|
| AC-M006-NF-001 | Task list load time | < 2 seconds | Performance test |
| AC-M006-NF-002 | Filter response time | < 100ms | Performance test |
| AC-M006-NF-003 | Signature canvas responsiveness | 60fps drawing | Performance test |
| AC-M006-NF-004 | Accessibility score | 100% WCAG 2.1 AA | axe-core audit |

### 10.3 Security Acceptance

| AC ID | Criterion | Verification |
|-------|-----------|--------------|
| AC-M006-SEC-001 | Attestation bound to authenticated user | Security audit |
| AC-M006-SEC-002 | Signature images stored securely | Security audit |
| AC-M006-SEC-003 | Attestation timestamp tamper-proof | Code review |
| AC-M006-SEC-004 | Tasks only visible for user's store | Penetration test |

---

## 11. Traceability Matrix

| Requirement | Source | Test Case |
|-------------|--------|-----------|
| REQ-M006-ROLE-001 | SUPP-017 | TC-M006-001 |
| REQ-M006-UI-002 | SUPP-017 | TC-M006-002 |
| REQ-M006-VAL-002 | Business Rules | TC-M006-003 |
| REQ-M006-API-004 | SUPP-017 | TC-M006-004 |
| REQ-M006-A11Y-001 | WCAG 2.1 | TC-M006-005 |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.6 - User Interface Requirements*
