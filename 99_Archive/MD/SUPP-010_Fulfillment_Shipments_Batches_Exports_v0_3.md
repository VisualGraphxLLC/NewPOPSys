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

1.  Campaign publish deterministically generates store orders + lines; PSP receives notification.

2.  PSP can manage statuses, shipments, tracking and batches in UI; same operations possible via API with idempotency.

3.  Partial shipment and multi-tracking behave correctly and roll up to order status.

4.  Late shipping rules configurable per campaign and trigger notifications/webhooks when breached.

5.  Exports contain required operational fields and align to output contracts (SUPP-005).
