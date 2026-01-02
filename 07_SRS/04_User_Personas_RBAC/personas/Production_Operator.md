# Production Operator Persona

**Document ID:** SRS-4.4.3
**Version:** 1.0
**Date:** 2026-01-01
**System:** NewPOPSys v1.38
**Category:** PSP Level Persona

---

## 1. Persona Overview

| Attribute | Value |
|-----------|-------|
| Persona ID | PSP-003 |
| Role Name | Production Operator |
| Level | PSP (Platform & Print Service Provider) |
| Primary Responsibility | Update order statuses, create shipments and tracking, process batches, view fulfillment queues |
| Permission Level | Status and Shipping Updates |

### 1.1 Role Description

The Production Operator is responsible for the day-to-day fulfillment operations within a PSP. This persona manages the production lifecycle from campaign publication through final shipment, including batch processing, order status management, shipment creation, tracking updates, and handling issues and reorders. The Production Operator ensures timely and accurate delivery of campaign materials to stores.

---

## 2. Jobs to Be Done (JTBD)

### 2.1 Primary Jobs

| Job ID | Job Statement | Priority |
|--------|---------------|----------|
| JTBD-PO-01 | Review campaign totals and plan production/kitting | Critical |
| JTBD-PO-02 | Assign and manage production batches | Critical |
| JTBD-PO-03 | Progress order statuses through fulfillment stages | Critical |
| JTBD-PO-04 | Create shipments and add tracking information | Critical |
| JTBD-PO-05 | Process issues, reorders, and replacement shipments | High |
| JTBD-PO-06 | Export fulfillment data packages | Medium |

### 2.2 Job Details

**JTBD-PO-01: Production Planning**
- When a campaign is published, I want to review store orders and totals so that I can plan production and kitting efficiently.

**JTBD-PO-02: Batch Management**
- When processing orders, I want to assign them to batches (PRODUCTION, PICK_PACK, SHIP_WAVE, CUSTOM) so that I can track and manage work in logical groups.

**JTBD-PO-03: Order Status Management**
- When orders progress through production, I want to update statuses accurately so that stakeholders have visibility into fulfillment progress.

**JTBD-PO-04: Shipment Creation**
- When orders are ready to ship, I want to create shipments with tracking so that stores can monitor delivery and we have proof of shipment.

**JTBD-PO-05: Issue Resolution**
- When stores report issues or request replacements, I want to process them according to campaign approval policy so that stores receive correct materials.

---

## 3. Primary Workflows

### 3.1 Canonical Fulfillment Workflow

1. Campaign published triggers system to generate assignments and store orders
2. Receive notification (email/webhook/in-app) of new campaign orders
3. Review campaign totals and store orders
4. Confirm production/kitting plan
5. Assign batches (PRODUCTION / PICK_PACK / SHIP_WAVE / CUSTOM)
6. Progress order statuses through fulfillment stages
7. Create shipments (partial shipments allowed)
8. Add tracking numbers to shipments
9. Update shipment and order status (UI or API)
10. Close fulfillment when complete

### 3.2 Issues and Reorders Workflow

1. Receive issue or reorder request from queue
2. Review request details and supporting evidence
3. Verify approval per campaign approval policy
4. Approve or reject request
5. If approved, create replacement order
6. Process replacement through fulfillment
7. Ship replacement with tracking
8. Update request status to resolved

### 3.3 Export Workflow

1. Identify export requirements (orders/shipments/execution/reorders)
2. Access export function
3. Configure export parameters and date ranges
4. Generate export package
5. Distribute to stakeholders or integrate with external systems (MIS)
6. Archive export for records

---

## 4. Key Screens Accessed

| Screen/Module | Purpose | Access Frequency |
|---------------|---------|------------------|
| Store Order List + Filters | View and filter all store orders | Continuous |
| Order Detail | View complete order information and update status | Continuous |
| Batch Manager | Create, assign, and manage production batches | Daily |
| Shipments + Tracking | Create shipments and add tracking numbers | Daily |
| Issues/Reorders Queue | Process replacement requests and issues | Daily |

---

## 5. Permission Scope

### 5.1 Permission Summary

| Permission Category | Access Level |
|--------------------|--------------|
| Order Viewing | All PSP orders (read) |
| Order Status Updates | Full Write |
| Batch Management | Full CRUD |
| Shipment Creation | Full CRUD |
| Tracking Updates | Full Write |
| Issues/Reorders | Approve/Fulfill per policy |
| Exports | Fulfillment packages |
| Campaign Configuration | No Access |
| User Management | No Access |

### 5.2 Permission Constraints

- Cannot modify campaign configurations or settings
- Cannot access user management functions
- Cannot access PSP or platform administrative settings
- Issue/reorder approvals limited by campaign approval policy
- Cannot delete orders (only update status)

---

## 6. Success Metrics

| Metric ID | Metric Name | Target | Measurement Method |
|-----------|-------------|--------|-------------------|
| PO-M01 | Order Processing Time | < 48 hours | Time from order creation to shipment |
| PO-M02 | Shipment Accuracy | 99.5% | Correct items shipped vs ordered |
| PO-M03 | Tracking Update Timeliness | < 4 hours | Time from shipment to tracking entry |
| PO-M04 | Issue Resolution Time | < 24 hours | Time from issue report to resolution |
| PO-M05 | Late Shipment Rate | < 2% | Shipments past campaign shipping SLA |
| PO-M06 | Batch Completion Rate | 100% | Batches completed within target date |

---

## 7. Batch Types Reference

| Batch Type | Description |
|------------|-------------|
| PRODUCTION | Items in active production/printing |
| PICK_PACK | Items being picked and packed for shipment |
| SHIP_WAVE | Items grouped for shipping wave |
| CUSTOM | User-defined batch type for special handling |

---

## 8. Related Documents

- SRS-4.2 Permission Matrix
- SRS-4.1 Persona Matrix
- SRS-4.4.1 Platform Admin Persona
- SRS-4.4.2 PSP Admin Persona
- SUPP-001 Shared Foundations - Persona Workflows JTBD Screens

---

*Document generated per IEEE 830 SRS format for NewPOPSys v1.38*
