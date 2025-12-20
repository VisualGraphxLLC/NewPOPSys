-- ==============================================================================
-- CHECK CONSTRAINTS: ORDERS & FULFILLMENT
-- ==============================================================================
-- Business rule enforcement for order lifecycle, shipment tracking, and fulfillment
--
-- Dependencies: 00_foundation_ddl.sql, brand_module_ddl.sql, 13_missing_fields.sql
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- STORE_ORDERS TABLE CONSTRAINTS
-- ==============================================================================

-- Order type validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_store_orders_type CHECK (order_type IN ('INITIAL', 'REORDER'))
COMMENT ON CONSTRAINT chk_store_orders_type ON store_orders IS
  'Business Rule: Order type must be INITIAL or REORDER';

-- Status validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_store_orders_status CHECK (status IN ('GENERATED', 'ACKNOWLEDGED', 'IN_PRODUCTION', 'KITTING', 'READY_TO_SHIP', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED', 'CANCELLED'))
COMMENT ON CONSTRAINT chk_store_orders_status ON store_orders IS
  'Business Rule: Order status must be valid lifecycle state';

-- ACKNOWLEDGED or later status requires acknowledged_at timestamp
ALTER TABLE store_orders
  ADD CONSTRAINT chk_store_orders_acknowledged_at
  CHECK (
    (status IN ('ACKNOWLEDGED', 'IN_PRODUCTION', 'KITTING', 'READY_TO_SHIP', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED')
     AND acknowledged_at IS NOT NULL) OR
    (status NOT IN ('ACKNOWLEDGED', 'IN_PRODUCTION', 'KITTING', 'READY_TO_SHIP', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED'))
  );

COMMENT ON CONSTRAINT chk_store_orders_acknowledged_at ON store_orders IS
  'Business Rule: Orders that reached ACKNOWLEDGED or beyond must have acknowledged_at timestamp';

-- IN_PRODUCTION or later requires production_started_at
ALTER TABLE store_orders
  ADD CONSTRAINT chk_store_orders_production_started_at
  CHECK (
    (status IN ('IN_PRODUCTION', 'KITTING', 'READY_TO_SHIP', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED')
     AND production_started_at IS NOT NULL) OR
    (status NOT IN ('IN_PRODUCTION', 'KITTING', 'READY_TO_SHIP', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED'))
  );

COMMENT ON CONSTRAINT chk_store_orders_production_started_at ON store_orders IS
  'Business Rule: Orders that reached IN_PRODUCTION or beyond must have production_started_at timestamp';

-- KITTING or later requires kitting_started_at
ALTER TABLE store_orders
  ADD CONSTRAINT chk_store_orders_kitting_started_at
  CHECK (
    (status IN ('KITTING', 'READY_TO_SHIP', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED')
     AND kitting_started_at IS NOT NULL) OR
    (status NOT IN ('KITTING', 'READY_TO_SHIP', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED'))
  );

COMMENT ON CONSTRAINT chk_store_orders_kitting_started_at ON store_orders IS
  'Business Rule: Orders that reached KITTING or beyond must have kitting_started_at timestamp';

-- READY_TO_SHIP or later requires ready_to_ship_at
ALTER TABLE store_orders
  ADD CONSTRAINT chk_store_orders_ready_to_ship_at
  CHECK (
    (status IN ('READY_TO_SHIP', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED')
     AND ready_to_ship_at IS NOT NULL) OR
    (status NOT IN ('READY_TO_SHIP', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED'))
  );

COMMENT ON CONSTRAINT chk_store_orders_ready_to_ship_at ON store_orders IS
  'Business Rule: Orders that reached READY_TO_SHIP or beyond must have ready_to_ship_at timestamp';

-- PARTIALLY_SHIPPED, SHIPPED, or later requires shipped_at
ALTER TABLE store_orders
  ADD CONSTRAINT chk_store_orders_shipped_at
  CHECK (
    (status IN ('PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED')
     AND shipped_at IS NOT NULL) OR
    (status NOT IN ('PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED'))
  );

COMMENT ON CONSTRAINT chk_store_orders_shipped_at ON store_orders IS
  'Business Rule: Orders that reached PARTIALLY_SHIPPED or beyond must have shipped_at timestamp';

-- DELIVERED status requires delivered_at
ALTER TABLE store_orders
  ADD CONSTRAINT chk_store_orders_delivered_at
  CHECK (
    (status = 'DELIVERED' AND delivered_at IS NOT NULL) OR
    (status != 'DELIVERED')
  );

COMMENT ON CONSTRAINT chk_store_orders_delivered_at ON store_orders IS
  'Business Rule: DELIVERED orders must have delivered_at timestamp';

-- CANCELLED status requires cancellation details
ALTER TABLE store_orders
  ADD CONSTRAINT chk_store_orders_cancelled_at
  CHECK (
    (status = 'CANCELLED' AND cancelled_at IS NOT NULL) OR
    (status != 'CANCELLED')
  );

COMMENT ON CONSTRAINT chk_store_orders_cancelled_at ON store_orders IS
  'Business Rule: CANCELLED orders must have cancelled_at timestamp';

ALTER TABLE store_orders
  ADD CONSTRAINT chk_store_orders_cancelled_by
  CHECK (
    (status = 'CANCELLED' AND cancelled_by_user_id IS NOT NULL) OR
    (status != 'CANCELLED')
  );

COMMENT ON CONSTRAINT chk_store_orders_cancelled_by ON store_orders IS
  'Business Rule: CANCELLED orders must have cancelled_by_user_id';

ALTER TABLE store_orders
  ADD CONSTRAINT chk_store_orders_cancellation_reason
  CHECK (
    (status = 'CANCELLED' AND cancellation_reason IS NOT NULL AND LENGTH(TRIM(cancellation_reason)) > 0) OR
    (status != 'CANCELLED')
  );

COMMENT ON CONSTRAINT chk_store_orders_cancellation_reason ON store_orders IS
  'Business Rule: CANCELLED orders must have a non-empty cancellation_reason';

-- CLOSED status requires closed_at
ALTER TABLE store_orders
  ADD CONSTRAINT chk_store_orders_closed_at
  CHECK (
    (status = 'CLOSED' AND closed_at IS NOT NULL) OR
    (status != 'CLOSED')
  );

COMMENT ON CONSTRAINT chk_store_orders_closed_at ON store_orders IS
  'Business Rule: CLOSED orders must have closed_at timestamp';

-- ==============================================================================
-- ORDER_LINES TABLE CONSTRAINTS
-- ==============================================================================

-- Quantity validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_order_lines_quantity CHECK (quantity > 0)
COMMENT ON CONSTRAINT chk_order_lines_quantity ON order_lines IS
  'Business Rule: Order line quantity must be at least 1';

-- ==============================================================================
-- SHIPMENTS TABLE CONSTRAINTS
-- ==============================================================================

-- Status validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_shipments_status CHECK (status IN ('LABEL_CREATED', 'IN_TRANSIT', 'DELIVERED', 'EXCEPTION', 'RETURNED'))
COMMENT ON CONSTRAINT chk_shipments_status ON shipments IS
  'Business Rule: Shipment status must be valid lifecycle state';

-- IN_TRANSIT or later status requires shipped_at
ALTER TABLE shipments
  ADD CONSTRAINT chk_shipments_shipped_at
  CHECK (
    (status IN ('IN_TRANSIT', 'DELIVERED', 'RETURNED') AND shipped_at IS NOT NULL) OR
    (status NOT IN ('IN_TRANSIT', 'DELIVERED', 'RETURNED'))
  );

COMMENT ON CONSTRAINT chk_shipments_shipped_at ON shipments IS
  'Business Rule: Shipments that reached IN_TRANSIT or beyond must have shipped_at timestamp';

-- DELIVERED status requires delivered_at
ALTER TABLE shipments
  ADD CONSTRAINT chk_shipments_delivered_at
  CHECK (
    (status = 'DELIVERED' AND delivered_at IS NOT NULL) OR
    (status != 'DELIVERED')
  );

COMMENT ON CONSTRAINT chk_shipments_delivered_at ON shipments IS
  'Business Rule: DELIVERED shipments must have delivered_at timestamp';

-- Delivered_at must be after shipped_at when both are set
ALTER TABLE shipments
  ADD CONSTRAINT chk_shipments_delivered_after_shipped
  CHECK (
    (shipped_at IS NULL OR delivered_at IS NULL OR delivered_at >= shipped_at)
  );

COMMENT ON CONSTRAINT chk_shipments_delivered_after_shipped ON shipments IS
  'Business Rule: Delivery timestamp must be on or after ship timestamp';

-- ==============================================================================
-- SHIPMENT_LINES TABLE CONSTRAINTS
-- ==============================================================================

-- Quantity validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_shipment_lines_quantity CHECK (quantity > 0)
COMMENT ON CONSTRAINT chk_shipment_lines_quantity ON shipment_lines IS
  'Business Rule: Shipment line quantity must be at least 1';

-- ==============================================================================
-- REORDERS TABLE CONSTRAINTS
-- ==============================================================================

-- Reorders link to orders of type REORDER (enforced at application layer)
-- This constraint would require a join, so we document the business rule here:
COMMENT ON TABLE reorders IS
  'Business Rule: Reorders should link to store_orders with order_type = REORDER (enforced at application layer)';

-- ==============================================================================
-- END OF ORDER CONSTRAINTS
-- ==============================================================================
