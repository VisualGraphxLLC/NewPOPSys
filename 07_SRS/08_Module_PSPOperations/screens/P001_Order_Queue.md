# P001 - Order Queue Screen Specification

> **Module**: PSP Operations Portal
> **Screen ID**: P001
> **Route**: `/psp/orders`
> **Version**: 1.0
> **Last Updated**: 2026-01-01
> **IEEE 830 Reference**: Section 3.2 - Functional Requirements
> **SUPP Reference**: SUPP-016 (Fulfillment - Order Processing)

---

## 1. Screen Overview

### 1.1 Purpose

The Order Queue screen provides PSP Production Operators with a centralized view of all store orders requiring fulfillment action. It enables order acknowledgment, status tracking, and drill-down access to order details for production processing.

### 1.2 Business Context

This screen serves as the primary work queue for PSP fulfillment operations. Orders flow from campaign assignments through to shipment, with this screen managing the critical handoff between order generation and production.

### 1.3 Screenshot Reference

![Order Queue Screen](../../screenshots/PSP_Operations/psp_ops_orders.png)

### 1.4 Navigation Path

```
PSP Portal → Orders (sidebar) → /psp/orders
```

### 1.5 Related Screens

| Screen | Relationship |
|--------|--------------|
| [P002 Shipments](P002_Shipments.md) | Orders link to shipments after production |
| [P003 Issues](P003_Issues.md) | Issues may trigger reorders appearing in queue |

---

## 2. User Roles & Permissions

### 2.1 Authorized Roles

| Role | Access Level | Permissions |
|------|--------------|-------------|
| PLATFORM_ADMIN | Full | View all, update status, bulk actions |
| PSP_ADMIN | Full | View all, update status, bulk actions |
| PSP_OPS | Operational | View all, update status, bulk actions |
| Support Agent (PSP_OPS + support_scope) | Read-Only | View only, no status updates |

### 2.2 Permission Requirements

| Requirement ID | Description | Roles |
|----------------|-------------|-------|
| REQ-P001-SEC-001 | User SHALL be authenticated with valid JWT containing tenant_id | All |
| REQ-P001-SEC-002 | User SHALL have PSP-level role (PLATFORM_ADMIN, PSP_ADMIN, or PSP_OPS) | All |
| REQ-P001-SEC-003 | Support Agent users SHALL have read-only access when support_scope = true | PSP_OPS |
| REQ-P001-SEC-004 | All order data SHALL be scoped to user's tenant_id | All |

### 2.3 Data Scope

- **Tenant Isolation**: Orders filtered by JWT tenant_id
- **Brand Visibility**: All brands within tenant visible
- **Campaign Scope**: All campaigns across brands visible

---

## 3. UI Components

### 3.1 Component Inventory

| Component ID | Type | Description |
|--------------|------|-------------|
| P001-C001 | Page Header | Title, order counts by status |
| P001-C002 | Status Tabs | New, Acknowledged, All filter tabs |
| P001-C003 | Search Bar | Order ID, store number search |
| P001-C004 | Filter Panel | Brand, campaign, date range filters |
| P001-C005 | Order Table | Sortable data grid with order list |
| P001-C006 | Bulk Actions | Select-all, bulk acknowledge button |
| P001-C007 | Order Detail Panel | Side panel with full order information |
| P001-C008 | Pagination | Page navigation with count |
| P001-C009 | Status Badge | Color-coded order status indicator |

### 3.2 Layout Specification

```
+------------------------------------------------------------------+
| Order Queue                                                       |
| New: 12 | Acknowledged: 8 | Shipped: 45 | Delivered: 234         |
+------------------------------------------------------------------+
| [Search orders...]                    [Brand ▼] [Campaign ▼]     |
|                                                                   |
| [New (12)] [Acknowledged (8)] [All Orders]                        |
|                                                                   |
| [ ] Select All                              [Acknowledge Selected]|
|                                                                   |
| +---------------------------------------------------------------+ |
| | [ ] Order #   | Brand    | Store    | Items | Status   | Age  | |
| +---------------------------------------------------------------+ |
| | [ ] ORD-1234  | Acme     | STR-001  | 5     | New      | 2h   | |
| | [ ] ORD-1235  | Acme     | STR-002  | 3     | New      | 1h   | |
| | [ ] ORD-1236  | Beta Co  | STR-015  | 8     | Ack      | 4h   | |
| +---------------------------------------------------------------+ |
|                                                                   |
| Showing 1-25 of 299              [< Prev] Page 1 of 12 [Next >]  |
+------------------------------------------------------------------+
```

### 3.3 Component Specifications

#### P001-C001: Page Header

| Property | Value |
|----------|-------|
| Title | "Order Queue" |
| Status Counts | Real-time counts by status enum |
| Refresh | Auto-refresh every 60 seconds |

#### P001-C005: Order Table

| Column | Field | Width | Sortable | Default Sort |
|--------|-------|-------|----------|--------------|
| Checkbox | selection | 40px | No | - |
| Order # | order_number | 120px | Yes | - |
| Brand | brand.name | 150px | Yes | - |
| Store | store.store_number | 120px | Yes | - |
| Items | line_count | 80px | Yes | - |
| Status | status | 120px | Yes | - |
| Age | created_at | 100px | Yes | DESC (default) |

---

## 4. Data Requirements

### 4.1 Entity Mapping

| Entity | Table | Purpose |
|--------|-------|---------|
| StoreOrder | store_orders | Primary order record |
| OrderLine | order_lines | Line items in order |
| Store | stores | Store information |
| Campaign | campaigns | Campaign reference |
| Brand | brands | Brand reference |
| KitItem | kit_items | Item details |

### 4.2 Data Query

```sql
SELECT
  so.id, so.order_number, so.status, so.created_at,
  so.psp_order_ref, so.order_type,
  s.store_number, s.name as store_name,
  c.name as campaign_name,
  b.name as brand_name,
  COUNT(ol.id) as line_count,
  SUM(ol.quantity) as total_quantity
FROM store_orders so
JOIN stores s ON so.store_id = s.id
JOIN campaigns c ON so.campaign_id = c.id
JOIN brands b ON c.brand_id = b.id
LEFT JOIN order_lines ol ON ol.order_id = so.id
WHERE so.tenant_id = :tenant_id
  AND so.deleted_at IS NULL
  AND so.status IN (:status_filter)
GROUP BY so.id, s.id, c.id, b.id
ORDER BY so.created_at DESC
LIMIT :page_size OFFSET :offset
```

### 4.3 Data Requirements Matrix

| Requirement ID | Description | Validation |
|----------------|-------------|------------|
| REQ-P001-DATA-001 | Order list SHALL display orders scoped to tenant | tenant_id filter |
| REQ-P001-DATA-002 | Order list SHALL exclude soft-deleted records | deleted_at IS NULL |
| REQ-P001-DATA-003 | Order age SHALL be calculated from created_at | Real-time calculation |
| REQ-P001-DATA-004 | Line count SHALL reflect active order lines only | COUNT with deleted_at filter |
| REQ-P001-DATA-005 | Status counts SHALL refresh on tab change | Query per status |

---

## 5. Business Rules & Validation

### 5.1 Order Status Rules

| Requirement ID | Rule | Enforcement |
|----------------|------|-------------|
| REQ-P001-BR-001 | Orders in GENERATED status SHALL appear in "New" tab | Status filter |
| REQ-P001-BR-002 | Orders in ACKNOWLEDGED status SHALL appear in "Acknowledged" tab | Status filter |
| REQ-P001-BR-003 | Only GENERATED orders SHALL be selectable for bulk acknowledge | UI disable |
| REQ-P001-BR-004 | Order status progression SHALL follow: GENERATED → ACKNOWLEDGED → IN_PRODUCTION → SHIPPED | State machine |
| REQ-P001-BR-005 | Acknowledge action SHALL set acknowledged_at timestamp | Backend logic |

### 5.2 Validation Rules

| Requirement ID | Field | Validation | Error Message |
|----------------|-------|------------|---------------|
| REQ-P001-VAL-001 | Order selection | At least one order selected for bulk action | "Select at least one order" |
| REQ-P001-VAL-002 | Status transition | Order must be in valid source status | "Order cannot be acknowledged from current status" |
| REQ-P001-VAL-003 | PSP Reference | Optional, max 50 characters | "PSP reference too long" |

### 5.3 Business Constraints

| Requirement ID | Constraint | Rationale |
|----------------|------------|-----------|
| REQ-P001-BC-001 | Orders SHALL be displayed FIFO (oldest first) in New tab | Production priority |
| REQ-P001-BC-002 | Bulk acknowledge SHALL process maximum 100 orders per request | Performance limit |
| REQ-P001-BC-003 | Order detail panel SHALL load within 500ms | UX requirement |

---

## 6. API Integration Points

### 6.1 API Endpoints

| Endpoint | Method | Purpose | Request | Response |
|----------|--------|---------|---------|----------|
| `/api/v1/orders` | GET | List orders | Query params | OrderDTO[] |
| `/api/v1/orders/{id}` | GET | Order detail | Path param | OrderDetailDTO |
| `/api/v1/orders/{id}/acknowledge` | POST | Acknowledge order | OrderAckRequest | OrderDTO |
| `/api/v1/orders/bulk-acknowledge` | POST | Bulk acknowledge | BulkAckRequest | BulkAckResponse |
| `/api/v1/orders/counts` | GET | Status counts | Query params | CountsDTO |

### 6.2 Request/Response Schemas

#### GET /api/v1/orders

**Request Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string[] | No | Filter by status(es) |
| brand_id | uuid | No | Filter by brand |
| campaign_id | uuid | No | Filter by campaign |
| search | string | No | Search order_number, store_number |
| page | integer | No | Page number (default: 1) |
| page_size | integer | No | Items per page (default: 25, max: 100) |
| sort_by | string | No | Sort field |
| sort_order | string | No | ASC or DESC |

**Response Schema:**

```json
{
  "data": [
    {
      "id": "uuid",
      "order_number": "ORD-1234",
      "status": "GENERATED",
      "order_type": "INITIAL",
      "psp_order_ref": "PSP-REF-001",
      "created_at": "2025-12-15T10:30:00Z",
      "acknowledged_at": null,
      "store": {
        "id": "uuid",
        "store_number": "STR-001",
        "name": "Downtown Store"
      },
      "campaign": {
        "id": "uuid",
        "name": "Summer Promo"
      },
      "brand": {
        "id": "uuid",
        "name": "Acme Corp"
      },
      "line_count": 5,
      "total_quantity": 12
    }
  ],
  "pagination": {
    "page": 1,
    "page_size": 25,
    "total_items": 299,
    "total_pages": 12
  }
}
```

### 6.3 API Requirements

| Requirement ID | Description | Implementation |
|----------------|-------------|----------------|
| REQ-P001-API-001 | All API requests SHALL include Authorization header with JWT | Middleware |
| REQ-P001-API-002 | Bulk acknowledge SHALL use Idempotency-Key header | Request header |
| REQ-P001-API-003 | API responses SHALL include X-Request-ID for tracing | Response header |
| REQ-P001-API-004 | Rate limiting SHALL apply: 100 requests/minute per user | API gateway |

---

## 7. State Transitions

### 7.1 Order Status State Machine

```
                    ┌─────────────┐
                    │  GENERATED  │
                    └──────┬──────┘
                           │ acknowledge
                           ▼
                    ┌─────────────┐
                    │ ACKNOWLEDGED│
                    └──────┬──────┘
                           │ start_production
                           ▼
                    ┌─────────────┐
                    │IN_PRODUCTION│
                    └──────┬──────┘
                           │ complete_kitting
                           ▼
                    ┌─────────────┐
                    │   KITTING   │
                    └──────┬──────┘
                           │ ready_to_ship
                           ▼
                    ┌─────────────┐
               ┌────│READY_TO_SHIP│
               │    └──────┬──────┘
               │           │ ship (partial/full)
               │           ▼
               │    ┌─────────────────┐
               │    │PARTIALLY_SHIPPED│───┐
               │    └─────────────────┘   │
               │                          │ all_shipped
               │           ┌──────────────┘
               │           ▼
               │    ┌─────────────┐
               └───►│   SHIPPED   │
                    └──────┬──────┘
                           │ deliver
                           ▼
                    ┌─────────────┐
                    │  DELIVERED  │
                    └──────┬──────┘
                           │ close
                           ▼
                    ┌─────────────┐
                    │   CLOSED    │
                    └─────────────┘

        ┌─────────────┐
        │  CANCELLED  │ (from any state except CLOSED)
        └─────────────┘
```

### 7.2 State Transition Requirements

| Requirement ID | Transition | From | To | Trigger |
|----------------|------------|------|-----|---------|
| REQ-P001-ST-001 | Acknowledge | GENERATED | ACKNOWLEDGED | User action |
| REQ-P001-ST-002 | Start Production | ACKNOWLEDGED | IN_PRODUCTION | User action |
| REQ-P001-ST-003 | Cancel | Any (not CLOSED) | CANCELLED | User action with reason |
| REQ-P001-ST-004 | Ship | READY_TO_SHIP | SHIPPED/PARTIALLY_SHIPPED | Shipment creation |
| REQ-P001-ST-005 | Deliver | SHIPPED | DELIVERED | Carrier webhook |

### 7.3 Status Display Mapping

| Status | Badge Color | Display Text |
|--------|-------------|--------------|
| GENERATED | Yellow | New |
| ACKNOWLEDGED | Green | Acknowledged |
| IN_PRODUCTION | Blue | In Production |
| KITTING | Blue | Kitting |
| READY_TO_SHIP | Purple | Ready to Ship |
| PARTIALLY_SHIPPED | Orange | Partial Ship |
| SHIPPED | Blue | Shipped |
| DELIVERED | Gray | Delivered |
| CLOSED | Gray | Closed |
| CANCELLED | Red | Cancelled |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Requirement ID | Error Scenario | HTTP Code | User Message | Recovery Action |
|----------------|----------------|-----------|--------------|-----------------|
| REQ-P001-ERR-001 | Unauthorized access | 401 | "Session expired. Please log in again." | Redirect to login |
| REQ-P001-ERR-002 | Forbidden action | 403 | "You don't have permission to perform this action." | Display message |
| REQ-P001-ERR-003 | Order not found | 404 | "Order not found." | Refresh list |
| REQ-P001-ERR-004 | Invalid status transition | 409 | "Order cannot be acknowledged from current status." | Refresh order |
| REQ-P001-ERR-005 | Bulk acknowledge partial failure | 207 | "X of Y orders acknowledged. Z failed." | Show failure details |
| REQ-P001-ERR-006 | Server error | 500 | "Something went wrong. Please try again." | Retry with backoff |
| REQ-P001-ERR-007 | Network timeout | - | "Connection lost. Retrying..." | Auto-retry 3x |

### 8.2 Error Display

| Component | Error Type | Display Method |
|-----------|------------|----------------|
| Page Load | API failure | Full-page error with retry button |
| Table | Empty results | "No orders match your filters" message |
| Bulk Action | Partial failure | Toast notification with details link |
| Detail Panel | Load failure | Panel error state with retry |

### 8.3 Logging Requirements

| Requirement ID | Event | Log Level | Data |
|----------------|-------|-----------|------|
| REQ-P001-LOG-001 | Page load | INFO | user_id, filters |
| REQ-P001-LOG-002 | Order acknowledge | INFO | user_id, order_id, prev_status |
| REQ-P001-LOG-003 | Bulk acknowledge | INFO | user_id, order_ids, success_count |
| REQ-P001-LOG-004 | Error | ERROR | error_code, message, stack_trace |

---

## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance

| Requirement ID | Guideline | Implementation |
|----------------|-----------|----------------|
| REQ-P001-A11Y-001 | 1.1.1 Non-text Content | All icons have aria-label |
| REQ-P001-A11Y-002 | 1.3.1 Info and Relationships | Table uses proper th/td semantics |
| REQ-P001-A11Y-003 | 1.4.1 Use of Color | Status uses color + text label |
| REQ-P001-A11Y-004 | 1.4.3 Contrast | 4.5:1 minimum contrast ratio |
| REQ-P001-A11Y-005 | 2.1.1 Keyboard | All actions accessible via keyboard |
| REQ-P001-A11Y-006 | 2.4.1 Bypass Blocks | Skip navigation link provided |
| REQ-P001-A11Y-007 | 2.4.7 Focus Visible | Clear focus indicators |
| REQ-P001-A11Y-008 | 4.1.2 Name, Role, Value | ARIA roles for custom components |

### 9.2 Keyboard Navigation

| Key | Action |
|-----|--------|
| Tab | Navigate between interactive elements |
| Enter | Activate button/link, open detail panel |
| Space | Toggle checkbox selection |
| Escape | Close detail panel |
| Arrow Up/Down | Navigate table rows |

### 9.3 Screen Reader Support

| Component | Announcement |
|-----------|--------------|
| Status Tabs | "New orders tab, 12 items" |
| Order Row | "Order ORD-1234, Acme Corp, Store STR-001, 5 items, New, 2 hours ago" |
| Bulk Action | "Acknowledge 5 selected orders button" |
| Status Change | "Order ORD-1234 acknowledged" (live region) |

---

## 10. Acceptance Criteria

### 10.1 Functional Acceptance Criteria

| Criteria ID | Description | Verification Method |
|-------------|-------------|---------------------|
| REQ-P001-AC-001 | Order queue displays all orders for user's tenant | Query verification |
| REQ-P001-AC-002 | Status tabs correctly filter orders by status | UI testing |
| REQ-P001-AC-003 | Search filters orders by order number and store number | UI testing |
| REQ-P001-AC-004 | Click on order row opens detail panel | UI testing |
| REQ-P001-AC-005 | Acknowledge button updates order status to ACKNOWLEDGED | API + DB verification |
| REQ-P001-AC-006 | Bulk acknowledge processes multiple orders | API + DB verification |
| REQ-P001-AC-007 | Status counts update after acknowledge action | UI verification |
| REQ-P001-AC-008 | Pagination correctly limits and navigates results | UI testing |
| REQ-P001-AC-009 | Table sorting works for all sortable columns | UI testing |
| REQ-P001-AC-010 | FIFO ordering maintained in New tab (oldest first) | Query verification |

### 10.2 Non-Functional Acceptance Criteria

| Criteria ID | Description | Target | Verification |
|-------------|-------------|--------|--------------|
| REQ-P001-AC-011 | Page load time | < 2 seconds | Performance testing |
| REQ-P001-AC-012 | Order detail panel load | < 500ms | Performance testing |
| REQ-P001-AC-013 | Bulk acknowledge (100 orders) | < 5 seconds | Performance testing |
| REQ-P001-AC-014 | WCAG 2.1 AA compliance | 100% | Accessibility audit |
| REQ-P001-AC-015 | Browser support | Chrome, Firefox, Edge, Safari | Cross-browser testing |

### 10.3 Traceability Matrix

| Requirement | Source | Test Case |
|-------------|--------|-----------|
| REQ-P001-FR-001 | SUPP-016 | TC-P001-001 |
| REQ-P001-SEC-001 | SUPP-003 | TC-P001-SEC-001 |
| REQ-P001-DATA-001 | 3.1 Database Model | TC-P001-DATA-001 |
| REQ-P001-API-001 | 3.4 Integration Architecture | TC-P001-API-001 |

---

## Appendix A: Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | System | Initial specification |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements*
