Date: 2025-12-18

Purpose: Define the PSP operational backbone: order generation structure, partial shipments, batch tracking, PSP portal requirements, and API automation boundaries.

Revision note: This SUPP is a full replacement. It incorporates overlapping material from SUPP-010_Fulfillment_Shipments_Batches_Exports_v0_3.docx as an appendix for traceability; where conflicts exist, the main body of this SUPP is authoritative.

# Locked Decisions (Module 5)

  -----------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- -----------------------------------------------------------------------------------------------
  Order granularity (v1)              Default: 1 order per store per campaign; Supplemental: add-on orders supported (future-ready)

  Partial shipments                   YES --- multiple shipments can fulfill a single store order (partial allowed)

  Batch types                         Enum list (fixed) + optional \'CUSTOM\' type with label

  Late shipping                       Configurable per campaign (rule-based thresholds)

  API writes                          Integration can update order + shipment + batch fields (idempotent)

  PSP portal must-haves               Campaign summary totals + store order list with filters
  -----------------------------------------------------------------------------------------------------------------------------------

# 1) Order Model (v1)

- Default order model: one StoreOrder per StoreAssignment per Campaign.

- StoreOrder contains one or more OrderLine items derived from AssignmentItems.

- Supplemental add-on orders: v1 scaffolds additional StoreOrders linked to the same StoreAssignment (for later add-ons/upsells).

- Every order and line item is immutable in identity; edits create versioned status/history and audit events.

## Entities (Draft)

  -------------------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- -------------------------------------------------------------------------------------------------------------
  StoreOrder                          orderId, campaignId, storeId, assignmentId, orderNumber, status, createdAt, createdBy, shippingSnapshotJson

  OrderLine                           lineId, orderId, itemId, sku/name, qty, unit, batchId?, status

  OrderStatusHistory                  historyId, orderId, fromStatus, toStatus, actorId/actorType, occurredAt, notes
  -------------------------------------------------------------------------------------------------------------------------------------------------

# 2) Shipments Model (Partial + Multi-Tracking)

- A StoreOrder can have 0..N Shipments (partial shipments supported).

- A Shipment can have 1..N tracking numbers (carrier-dependent).

- ShipmentLine optionally maps which OrderLines/quantities were included in a shipment (recommended for partials).

- Shipments updates may be performed via UI or integration API.

## Entities (Draft)

  ------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- ------------------------------------------------------------------------------------
  Shipment                            shipmentId, orderId, status, carrier, shippedAt, deliveredAt, createdAt, createdBy

  ShipmentTracking                    trackingId, shipmentId, trackingNumber, trackingUrl?, status, lastEventAt

  ShipmentLine                        shipmentLineId, shipmentId, orderLineId, qtyShipped
  ------------------------------------------------------------------------------------------------------------------------

# 3) Batch Tracking (v1)

- Batch represents a grouped set of items within a campaign (may span orders).

- Batch types are fixed enums for reporting/automation; CUSTOM type allows freeform labeling.

- Recommended enums (v1): PRODUCTION, PICK_PACK, SHIP_WAVE, INSTALL_WAVE, CUSTOM.

## Entities (Draft)

  ---------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- ---------------------------------------------------------------------
  Batch                               batchId, campaignId, type(enum), label, createdBy, createdAt, notes

  BatchMembership                     batchId, orderLineId (or assignmentItemId), createdAt
  ---------------------------------------------------------------------------------------------------------

# 4) Late Shipping Rules (Per Campaign Config)

- Late shipping is configurable per campaign to support varying complexity.

- Default rule suggestion (if not set): late if order has no shipment created by shipByDate end-of-day in campaign timezone.

- Config fields (draft): lateRuleType (no_shipment_by_date \| not_delivered_by_date \| custom), thresholdDateField(shipByDate), graceHours, escalationSchedule.

- Late shipping event triggers notifications to PSP + Brand Campaign Admin/Manager (per SUPP-004) and emits webhook alert.late_shipping (SUPP-006).

# 5) PSP Portal UX Requirements (v1 Must-Have)

- Campaign summary totals view: store counts, completion %, order counts, shipment counts, exceptions.

- Store order list with filters: by campaign, status, region/district/territory, group, batch, shipment status, late flag.

- Bulk actions (nice-to-have in v1): update status, assign batch, export filtered list.

# 6) API Automation (Integration User)

- Inbound API supports idempotent writes for:

- \- order status updates (and notes)

- \- create/update shipments + tracking numbers

- \- create/update batches and membership assignments

- All endpoints require Idempotency-Key and emit AuditEvents with actorType=integration.

# 7) APIs (Draft Endpoint List)

- GET /orders (filters, pagination)

- GET /orders/{orderId}

- PATCH /orders/{orderId} (status updates; notes)

- POST /orders/{orderId}/shipments

- PATCH /shipments/{shipmentId}

- POST /shipments/{shipmentId}/trackingNumbers

- POST /batches; PATCH /batches/{batchId}; POST /batches/{batchId}/members

- POST /campaigns/{id}/lateShippingConfig (set rules)

# 8) Acceptance Criteria (Module 5)

1.  Publishing a campaign generates one store order per assignment with deterministic line items.

2.  PSP portal shows campaign totals and store order list with filters.

3.  PSP can update order status and shipments in UI; integration can do same via API with idempotency.

4.  Orders support partial shipments with multiple tracking numbers; shipment status changes propagate to brand views and notifications.

5.  Batch types use enum list; CUSTOM batch type supports freeform label; batches can span orders within a campaign.

6.  Late shipping thresholds are configurable per campaign; triggering late creates notifications + webhook event.

# Future Scaffold Notes

- Add-on orders: allow multiple orders per store assignment for later upsells, replacements beyond standard reorder flow, or split billing.

- Carrier integrations: future connector modules (UPS/FedEx/USPS) can populate tracking events automatically.

- Warehouse pick/pack workflows: deeper batch/scan flows can be layered without changing the core entities.

# Appendix --- Integrated Material (for traceability)

SUPP-010 --- Fulfillment, Shipments, Batches & Export Hooks (v0.3)

Date: 2025-12-17

Purpose: PSP-friendly operational model aligned with Module 5 (SUPP-016). Defines statuses, partial shipments, batch enums + CUSTOM, and how fulfillment data feeds exports/webhooks.

# Locked Requirements

- PSP needs campaign totals + store-level orders list.

- Orders generated on campaign publish; PSP alerted via email/webhook; PSP updates via UI or API.

- Partial shipments supported; multiple tracking numbers supported.

- Batch is dynamic but uses fixed enum types in v1 with CUSTOM option.

- Exports priority: CSV/XLSX, PDF, JSON, XML (schemas in SUPP-005).

# Fulfillment Objects (v1)

  ----------------------------------------------------------------------------------------------------
  Object                  Cardinality                          Notes
  ----------------------- ------------------------------------ ---------------------------------------
  StoreOrder              1 per store per campaign (default)   Scaffold add-on orders later

  OrderLine               1..N per order                       Derived from assignment items

  Shipment                0..N per order                       Partial shipments allowed

  ShipmentTracking        1..N per shipment                    Carrier + tracking numbers

  Batch                   0..N per campaign                    May span orders; enums + CUSTOM label
  ----------------------------------------------------------------------------------------------------

# Status Taxonomy (v1)

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Object                              Statuses
  ----------------------------------- -------------------------------------------------------------------------------------------------------------------------------------
  Order                               GENERATED → ACKNOWLEDGED → IN_PRODUCTION → KITTING → READY_TO_SHIP → PARTIALLY_SHIPPED → SHIPPED → DELIVERED → CLOSED (→ CANCELLED)

  Shipment                            LABEL_CREATED → IN_TRANSIT → DELIVERED → EXCEPTION → RETURNED
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Batch Types (v1)

- Enums: PRODUCTION, PICK_PACK, SHIP_WAVE, INSTALL_WAVE, CUSTOM

- CUSTOM requires a label; report it as type=CUSTOM and label=\...

# Late Shipping (Per Campaign Config)

- Late threshold is configurable per campaign (complexity varies).

- Default suggestion if unset: no shipment created by shipByDate end-of-day in campaign timezone.

- Triggers alert.late_shipping to PSP + Brand (see SUPP-004) and webhook (see SUPP-006).

# Export Hooks (Feed SUPP-005)

- Fulfillment exports include stable IDs + business keys; include batchId/type/label and shipment tracking fields.

- Retention-aware: include mediaAssetIds/pointers; do not embed permanent URLs.

# Inbound API Writes (Integration User)

- Idempotent endpoints for: order status updates, shipment create/update, tracking updates, batch create/update, batch membership updates.

- All writes emit audit events with actorType=integration and include idempotency key reference.

# Acceptance Criteria

7.  Campaign publish deterministically generates store orders + lines; PSP receives notification.

8.  PSP can manage statuses, shipments, tracking and batches in UI; same operations possible via API with idempotency.

9.  Partial shipment and multi-tracking behave correctly and roll up to order status.

10. Late shipping rules configurable per campaign and trigger notifications/webhooks when breached.

11. Exports contain required operational fields and align to output contracts (SUPP-005).
