# SUPP-019 — PSP Operations — Issues & Reorders

> **Version**: v0.3  
> **Status**: Locked  
> **Updated**: 2025-12-18  
> **Dependencies**: SUPP-016 (Orders), SUPP-017 (Execution)

---

## Purpose
Define the **Automated Reorder Loop**: Store Report → Approval → Reorder Generation → Fulfillment.

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

## 2. Automated Reorder Workflow

1.  **Submission**: Store submits `IssueRequest`.
2.  **Approval** (Policy Check):
    - *Auto-Approve*: If < $X value and first request for store.
    - *Manual Review*: If > threshold or repeat offense (Route to PSP Ops).
3.  **Generation**:
    - On Approval, system creates `StoreOrder` (`type=REORDER`).
    - Links to original `assignmentId` and `issueRequestId`.
    - Contains only the affected line items.
4.  **Fulfillment**:
    - Pushed to PSP via API (SUPP-016).
    - Tracking number sent to store (distinct from original).

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

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.3 | 2025-12-20 | Stable filename adopted; version tracked in file |
