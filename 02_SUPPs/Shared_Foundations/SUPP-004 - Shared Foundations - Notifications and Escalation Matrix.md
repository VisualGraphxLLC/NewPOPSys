# SUPP-004 — Shared Foundations — Notifications Matrix

> **Version**: v0.4  
> **Status**: Locked  
> **Updated**: 2025-12-18  
> **Dependencies**: SUPP-015, SUPP-017, SUPP-018, SUPP-019

---

## Purpose
Define all system notifications (Email & In-App) triggered by the execution state machine.

---

## 1. Store Notifications (Mobile/Email)

| Trigger Event | Subject / Message | Action Deep Link |
|---------------|-------------------|------------------|
| **Shipment Delivered** | "Kit Arrived: Verify Receipt" | Open Receipt Survey |
| **Campaign Start** | "Install Phase Started" | Open Install Survey |
| **Photo Rejected** | "Action Required: Retake [Item]" | Open Retake Task |
| **Issue Approved** | "Reorder #[ID] Approved" | View Reorder Status |
| **Reorder Shipped** | "Reorder #[ID] Shipped" | Track Shipment |

---

## 2. Admin/PSP Notifications

| Trigger Event | Recipient | Message | Action |
|---------------|-----------|---------|--------|
| **Campaign Published** | PSP Ops | "New Orders: [Campaign]" | View Orders |
| **Issue Reported** | PSP Ops | "Issue: [Store] [Type]" | Approve/Reject |
| **Store Completed** | Brand Admin | "[Store] Submitted" | Review Photos |
| **Late Shipping** | PSP Ops | "Alert: Orders Overdue" | View Dashboard |

---

## 3. Delivery Logic
- **Email**: SendGlide / SES (via SUPP-027).
- **Push**: Future scope.
- **In-App**: "Bell" icon notification center.

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.4 | 2025-12-20 | Stable filename adopted; version tracked in file |
