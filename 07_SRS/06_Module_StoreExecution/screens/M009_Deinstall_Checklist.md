# M009 - Deinstall Checklist

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M009
> **Route**: `/app/campaign/:id/deinstall`
> **IEEE 830 Section**: 3.2.9 - User Interface Requirements
> **Version**: 1.0
> **Last Updated**: 2026-01-02

---

## 1. Screen Overview

### 1.1 Purpose

The Deinstall Checklist screen facilitates the removal of POP materials once a campaign has ended. It provides a list of all items previously installed and requires the user to confirm their removal. This ensures that old promotional materials are not left in-store, maintaining brand consistency and clearing space for new campaigns.

### 1.2 Scope

This specification covers:
- List of installed items for removal
- Multi-select removal confirmation
- Disposal instructions per item type (e.g., "Recycle", "Return to Brand")
- Progress tracking for deinstallation phase

### 1.3 Screenshot Reference

| Mobile View | Tablet View | Desktop View |
| :--- | :--- | :--- |
| ![Mobile Deinstall](../../screenshots/Store_Execution/mobile_deinstall_list.png) | ![Tablet Deinstall](../../screenshots/Store_Execution/tablet_deinstall_list.png) | ![Desktop Deinstall](../../screenshots/Store_Execution/desktop_deinstall_list.png) |

---

## 2. User Roles & Permissions

### 2.1 Authorized Roles

| Role | Access Level | Description |
|------|--------------|-------------|
| Store Manager (P07) | Full | Can execute and confirm deinstallation |
| Store Operator (P08) | Execute | Can execute deinstallation tasks |

---

## 3. UI Components

### 3.1 Component Inventory

| Component ID | Type | Description | Required |
| :--- | :--- | :--- | :--- |
| COMP-M009-001 | Header | Campaign name and "Deinstall" status | Yes |
| COMP-M009-002 | Checklist | List of items with removal checkboxes | Yes |
| COMP-M009-003 | Instructions | Disposal/recycling notes | Yes |
| COMP-M009-004 | Submit Button | Proceed to final confirmation | Yes |

---

## 10. Acceptance Criteria

### 10.1 Functional Acceptance

| AC ID | Criterion | Verification Method |
| :--- | :--- | :--- |
| AC-M009-001 | Screen displays all items marked as INSTALLED | Manual test |
| AC-M009-002 | User can check off multiple items | Manual test |
| AC-M009-003 | Disposal instructions are visible for each item | Manual test |

---

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2.9 - User Interface Requirements*
