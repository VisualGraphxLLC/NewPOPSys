# SUPP-019 — PSP Operations — Issues, Reorders, Expiration & Deinstall

> **Version**: v0.4
> **Status**: Draft
> **Updated**: 2026-01-02
> **Dependencies**: SUPP-016 (Orders), SUPP-017 (Execution)

---

## Purpose
Define the **Automated Reorder Loop** and **Campaign Deinstall Workflow**:
- Issues & Reorders: Store Report → Approval → Reorder Generation → Fulfillment
- Campaign Expiration: Campaign Period → Deinstall Window → Task Completion

---

## 1. Issue Types
Stores can report issues during **Receipt Survey** or **Install Survey**.

| Type | Evidence Required | Reorder Action |
|------|-------------------|----------------|
| **MISSING** | No | 1:1 Replacement |
| **DAMAGED** | **Photo Required** | 1:1 Replacement |
| **INCORRECT** | Photo optional | 1:1 Replacement |
| **PACKAGING** | Photo Required | Bulk Replacement (PSP discretion) |

---

## 2. Automated Reorder Workflow (Split Logic)

1.  **Submission**: Store submits `IssueRequest` during Receipt Survey.
2.  **Split Logic**: 
    - **Original Order**: Correctly received items are marked `READY` and immediately unlock their corresponding **Installation Tasks** on the Layout Map.
    - **Supplemental Order**: Missing/damaged items are moved to a new `StoreOrder` (type=SUPPLEMENTAL) within the same campaign.
3.  **Approval** (Policy Check):
    - *Auto-Approve*: If < $X value and first request for store.
    - *Manual Review*: If > threshold or repeat offense (Route to PSP Ops).
4.  **Generation**:
    - On Approval, the `SUPPLEMENTAL` order is finalized.
    - Links to original `assignmentId` and `issueRequestId`.
5.  **Fulfillment**:
    - Pushed to PSP via API (SUPP-016).
    - Tracking number sent to store.
    - Upon delivery, these items unlock their remaining **Installation Tasks** on the Layout Map.

---

## 3. Interfaces

### Store App
- "Report Issue" button on any item.
- "Reorder Status" card: Submitted → Approved → Shipped.

### PSP Portal / Admin
- **Issue Queue**: Review pending requests.
- **Action**: Approve (Generates Order) or Reject (with Reason).
- **Consolidation**: Option to "Combine Reorders" into one shipment (manual override).

---

## 4. Acceptance Criteria
1.  **Reporting**: Store can report Missing/Damaged on specific items.
2.  **Evidence**: Damaged items block submission without photo.
3.  **Automation**: Approved request *automatically* triggers `StoreOrder` creation.
4.  **Visibility**: Reorder tracking text is visible to store user.
5.  **Limits**: System flags excessive reorders for manual review.

---

## 5. Campaign Expiration Logic

Campaign lifecycle configuration set by Brand/Campaign Manager at setup:

| Setting | Description | Required |
|---------|-------------|----------|
| **Campaign Period** | Start and end dates for active campaign | Yes |
| **Deinstall Window** | Days after campaign end for deinstall completion | No (null = permanent) |
| **deinstall_tracking_enabled** | Whether deinstall tasks are created | Derived from Window |

**Logic:**
- If `Deinstall Window` is set → System creates `DeinstallTask` records X days before campaign end
- If `Deinstall Window` is null → Campaign is permanent, no deinstall required
- Deinstall tasks appear in store's task list when campaign enters deinstall phase

---

## 6. Deinstall Workflow

### 6.1 Task States
`PENDING` → `IN_PROGRESS` → `SUBMITTED` → `VERIFIED` / `REJECTED`

### 6.2 Brand Configuration

| Setting | Description |
|---------|-------------|
| **bypass_photos** | Store can skip photo evidence (default: false) |
| **bypass_attestation** | Store can skip deinstall attestation (default: false) |

### 6.3 Deinstall Steps
1. **Notification**: Store receives deinstall task when campaign enters deinstall phase
2. **Execution**: Store removes materials per layout map (reverse of install)
3. **Evidence**: Photo documentation (unless bypass_photos = true)
4. **Attestation**: Manager signature confirming removal (unless bypass_attestation = true)
5. **Submission**: Store submits completed deinstall

### 6.4 Non-Compliance Flow
If deinstall not completed within Deinstall Window:
1. System marks task as `OVERDUE`
2. Notification sent to **Regional Manager**
3. Escalation to **Brand Manager** after +3 days
4. Store flagged for compliance review

---

## 7. Deinstall Interfaces

### Store App
- **Task Tab**: "Deinstall" appears alongside Receipt/Install when campaign in deinstall phase
- **Checklist**: Materials removal checklist (mirrors install checklist)
- **Photo Capture**: Evidence upload (if required by brand)
- **Attestation**: Manager signature screen (if required by brand)

### Brand Portal
- **Campaign Setup**: Configure Deinstall Window and bypass settings
- **Compliance Dashboard**: View deinstall completion rates by region/store
- **Escalation Queue**: Overdue deinstalls requiring attention

---

## 8. Deinstall Acceptance Criteria
1. **Configuration**: Brand can set Deinstall Window (or null for permanent)
2. **Bypass Options**: Brand can enable/disable photo and attestation requirements
3. **Task Visibility**: Deinstall tasks appear only when campaign enters deinstall phase
4. **Evidence**: Photos required unless bypass_photos enabled
5. **Attestation**: Signature required unless bypass_attestation enabled
6. **Non-Compliance**: Overdue tasks trigger Regional → Brand Manager notifications
7. **Permanent Campaigns**: No deinstall tasks created when window is null

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.4 | 2026-01-02 | Added Sections 5-8: Campaign Expiration, Deinstall Workflow |
| v0.3 | 2025-12-20 | Stable filename adopted; version tracked in file |
