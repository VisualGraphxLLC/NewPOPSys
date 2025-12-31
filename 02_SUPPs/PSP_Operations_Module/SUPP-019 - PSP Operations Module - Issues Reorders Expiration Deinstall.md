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

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.3 | 2025-12-20 | Stable filename adopted; version tracked in file |
