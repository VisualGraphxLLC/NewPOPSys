# M010 - Deinstall Confirmation

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M010
> **Route**: `/app/campaign/:id/deinstall/confirm`
> **IEEE 830 Section**: 3.2.10 - User Interface Requirements
> **Version**: 1.0
> **Last Updated**: 2026-01-02

---

## 1. Screen Overview

### 1.1 Purpose

The Deinstall Confirmation screen serves as the final sign-off for the removal lifecycle. Users provide a final attestation that the deinstallation is complete and the store area is ready for the next campaign.

### 1.2 Scope

This specification covers:
- Final summary of deinstalled items
- Completion attestation checkbox
- Digital signature (if required by brand)
- Campaign closure trigger

### 1.3 Screenshot Reference

| Mobile View | Tablet View | Desktop View |
| :--- | :--- | :--- |
| ![Mobile Deinstall Confirm](../../screenshots/Store_Execution/mobile_deinstall_confirm.png) | ![Tablet Deinstall Confirm](../../screenshots/Store_Execution/tablet_deinstall_confirm.png) | ![Desktop Deinstall Confirm](../../screenshots/Store_Execution/desktop_deinstall_confirm.png) |

---

## 2. User Roles & Permissions

### 2.1 Authorized Roles

| Role | Access Level | Description |
|------|--------------|-------------|
| Store Manager (P07) | Full | Authorized to provide final deinstall sign-off |
| Store Operator (P08) | Execute | Can submit for manager review |

---

## 3. UI Components

| Component ID | Type | Description | Required |
| :--- | :--- | :--- | :--- |
| COMP-M010-001 | Summary | Count of items deinstalled | Yes |
| COMP-M010-002 | Attestation | "I certify materials are removed" checkbox | Yes |
| COMP-M010-003 | Signature | Digital signature pad | No |

---

## 10. Acceptance Criteria

| AC ID | Criterion | Verification Method |
| :--- | :--- | :--- |
| AC-M010-001 | Confirmation updates campaign status to CLOSED | E2E test |
| AC-M010-002 | Signature is captured and stored with audit trail | Manual test |

---

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2.10 - User Interface Requirements*
