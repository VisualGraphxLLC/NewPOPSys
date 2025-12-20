# SUPP-018 — PSP Operations Module — Verification & Retake

> **Version**: v0.3 (Redesign)  
> **Status**: Locked  
> **Updated**: 2025-12-18  
> **Dependencies**: SUPP-017 (Execution)

---

## Purpose
Define the **Verification Loop**: Admin Review of photos → Rejection Logic → Store Retake Workflow. This is a NEW capability for v1.

---

## 1. Admin Review Dashboard
*Users: Brand Admin, Regional Admin*

### Review Queue
- Filter by: Campaign, Store, Region, Status (`Submitted for Review`).
- "Fast Mode": Grid view of photos.
- "Strict Mode": Store-by-store deep dive.

### Review Action (Per Photo)
- **Approve**: Standard path.
- **Reject**: Triggers Retake.
    - **Reason Code** (Required): `Blurry`, `Wrong Angle`, `Damaged`, `Wrong Placement`.
    - **Comment** (Optional): Instructions for fix.

---

## 2. Rejection Logic & State Machine
Rejection happens at the **Photo/Item Level**, but affects **Store Assignment Status**.

1.  **Photo Status**: `PENDING` → `REJECTED`.
2.  **Assignment Status**: `SUBMITTED` → `REWORK_REQUESTED`.
3.  **Notification**: Store Manager receives push/email: "Action Required: 2 Photos Rejected."

---

## 3. Store Retake Workflow (Mobile)
When a store has `REWORK_REQUESTED` status:

1.  **Task List**: Shows "Retake Tasks" at top (High Priority).
2.  **Retake Screen**:
    - Shows Rejected Photo.
    - Shows Reason ("Wrong Angle") + Admin Comment.
    - Action: "Retake Photo".
3.  **Submission**:
    - New photo uploads as `PENDING`.
    - Old photo moved to `SUPERSEDED` history.
    - Assignment moves back to `SUBMITTED_FOR_REVIEW`.

---

## 4. Acceptance Criteria
1.  **Review**: Admin can reject specific photos with a reason code.
2.  **Notification**: Rejection triggers immediate notification to store.
3.  **Retake UI**: Store sees specific feedback and camera button to replace.
4.  **History**: Old rejected photos are preserved (not deleted) for audit.
5.  **Loop**: Cycle continues until approved or waived.

