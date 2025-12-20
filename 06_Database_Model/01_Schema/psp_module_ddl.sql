-- ============================================================================
-- PSP Operations Module DDL
-- PostgreSQL Database Schema
-- ============================================================================
-- Purpose: Complete database schema for PSP-level operations including
--          orders, shipments, batches, fulfillment, verification, and issues
-- Version: 1.0
-- Created: 2025-12-19
-- Dependencies: Core platform tables (tenants, brands, users, campaigns,
--               store_assignments, kit_items)
-- ============================================================================

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- SECTION 1: ENUMERATIONS
-- ============================================================================
-- Defines all enum types used in the PSP Operations Module

-- Order Type Enum
-- Distinguishes initial campaign orders from replacement reorders
CREATE TYPE order_type AS ENUM (
  'INITIAL',   -- Original campaign order
  'REORDER'    -- Replacement order triggered by issue request
);
COMMENT ON TYPE order_type IS 'Type of order: INITIAL (campaign) or REORDER (issue replacement)';

-- Store Order Status Enum
-- Tracks the lifecycle of an order from generation through delivery
CREATE TYPE store_order_status AS ENUM (
  'GENERATED',         -- Order created in system, not yet sent to PSP
  'ACKNOWLEDGED',      -- PSP has received and acknowledged order
  'IN_PRODUCTION',     -- PSP is actively producing items
  'KITTING',           -- Items being assembled into shipment kits
  'READY_TO_SHIP',     -- Kitted and ready for carrier pickup
  'PARTIALLY_SHIPPED', -- Some items shipped, others pending
  'SHIPPED',           -- All items shipped
  'DELIVERED',         -- All shipments delivered to store
  'CLOSED',            -- Order complete and archived
  'CANCELLED'          -- Order cancelled before fulfillment
);
COMMENT ON TYPE store_order_status IS 'Lifecycle status of a store order from generation through delivery';

-- Shipment Status Enum
-- Tracks individual shipment progress through carrier network
CREATE TYPE shipment_status AS ENUM (
  'LABEL_CREATED',  -- Shipping label generated, not yet picked up
  'IN_TRANSIT',     -- Carrier has package, in transit
  'DELIVERED',      -- Successfully delivered to destination
  'EXCEPTION',      -- Carrier exception (delay, damage, etc.)
  'RETURNED'        -- Shipment returned to sender
);
COMMENT ON TYPE shipment_status IS 'Status of a shipment in the carrier network';

-- Photo Review Status Enum
-- Tracks the review state of uploaded verification photos
CREATE TYPE photo_review_status AS ENUM (
  'PENDING',     -- Awaiting review by brand admin
  'APPROVED',    -- Accepted by reviewer
  'REJECTED',    -- Rejected, retake required
  'SUPERSEDED'   -- Replaced by a newer photo (audit trail)
);
COMMENT ON TYPE photo_review_status IS 'Review status of uploaded verification photos';

-- Rejection Reason Enum
-- Standardized reasons for photo rejection
CREATE TYPE rejection_reason AS ENUM (
  'BLURRY',                -- Image out of focus
  'WRONG_ANGLE',           -- Incorrect camera angle
  'WRONG_PLACEMENT',       -- Item not placed correctly
  'DAMAGED',               -- Item appears damaged
  'INSUFFICIENT_LIGHTING', -- Too dark or poorly lit
  'OBSTRUCTION',           -- View blocked by object
  'OTHER'                  -- Other reason (requires comment)
);
COMMENT ON TYPE rejection_reason IS 'Standardized reasons for photo rejection';

-- Issue Type Enum
-- Categories of issues stores can report
CREATE TYPE issue_type AS ENUM (
  'MISSING',    -- Item not received
  'DAMAGED',    -- Item received damaged
  'INCORRECT',  -- Wrong item received
  'PACKAGING'   -- Packaging issue (may affect multiple items)
);
COMMENT ON TYPE issue_type IS 'Categories of fulfillment issues stores can report';

-- Issue Request Status Enum
-- Tracks the lifecycle of an issue request through resolution
CREATE TYPE issue_request_status AS ENUM (
  'OPEN',               -- Reported by store, not yet reviewed
  'TRIAGED',            -- Classified and routed to appropriate team
  'AWAITING_APPROVAL',  -- Waiting for brand/PSP approval
  'APPROVED',           -- Approved, reorder can be generated
  'IN_FULFILLMENT',     -- Reorder being produced/shipped
  'DENIED',             -- Request denied (terminal state)
  'RESOLVED'            -- Issue resolved (terminal state)
);
COMMENT ON TYPE issue_request_status IS 'Lifecycle status of issue request from report through resolution';

-- ============================================================================
-- SECTION 2: ORDERS & ORDER LINES
-- ============================================================================
-- Core order management for campaign fulfillment and reorders

-- Store Orders Table
-- One order per store per campaign (initial), plus additional reorders as needed
CREATE TABLE store_orders (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE RESTRICT,
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE RESTRICT,
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE RESTRICT,

  -- Order Identity
  order_number TEXT NOT NULL UNIQUE,  -- System-generated (e.g., 'ORD-1001')
  psp_order_ref TEXT,                 -- PSP's MIS order ID (set via API)

  -- Order Classification
  order_type order_type NOT NULL DEFAULT 'INITIAL',
  status store_order_status NOT NULL DEFAULT 'GENERATED',

  -- Batch Grouping (Optional)
  batch_label TEXT,  -- PSP can tag orders for batch processing

  -- Timestamps
  acknowledged_at TIMESTAMPTZ,  -- When PSP acknowledged receipt

  -- Shipping Address Snapshot
  -- Frozen copy of store address at time of order generation
  shipping_address_snapshot JSONB NOT NULL,

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT chk_store_orders_batch_label CHECK (batch_label IS NULL OR LENGTH(batch_label) <= 100),
  CONSTRAINT chk_store_orders_psp_ref CHECK (psp_order_ref IS NULL OR LENGTH(psp_order_ref) <= 255)
);

-- Indexes for common query patterns
CREATE INDEX idx_store_orders_campaign ON store_orders(campaign_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_store ON store_orders(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_assignment ON store_orders(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_status ON store_orders(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_type ON store_orders(order_type) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_batch ON store_orders(batch_label) WHERE deleted_at IS NULL AND batch_label IS NOT NULL;
CREATE INDEX idx_store_orders_psp_ref ON store_orders(psp_order_ref) WHERE deleted_at IS NULL AND psp_order_ref IS NOT NULL;
CREATE INDEX idx_store_orders_created ON store_orders(created_at DESC) WHERE deleted_at IS NULL;

-- Comments
COMMENT ON TABLE store_orders IS 'Store orders for campaign fulfillment and reorders. One INITIAL order per store per campaign, plus REORDER records as needed.';
COMMENT ON COLUMN store_orders.order_number IS 'System-generated unique order identifier (e.g., ORD-1001)';
COMMENT ON COLUMN store_orders.psp_order_ref IS 'PSP MIS order ID, populated via API when PSP acknowledges';
COMMENT ON COLUMN store_orders.order_type IS 'INITIAL for campaign orders, REORDER for issue replacements';
COMMENT ON COLUMN store_orders.batch_label IS 'Optional PSP batch identifier for grouping orders in production';
COMMENT ON COLUMN store_orders.shipping_address_snapshot IS 'Frozen store shipping address at time of generation (JSONB)';
COMMENT ON COLUMN store_orders.acknowledged_at IS 'Timestamp when PSP acknowledged receipt of order';

-- Order Lines Table
-- Line items within an order (kit items with quantities)
CREATE TABLE order_lines (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  store_order_id UUID NOT NULL REFERENCES store_orders(id) ON DELETE CASCADE,
  kit_item_id UUID NOT NULL REFERENCES kit_items(id) ON DELETE RESTRICT,

  -- Line Item Details
  sku TEXT NOT NULL,           -- Denormalized from kit_item for stability
  quantity INTEGER NOT NULL,   -- Quantity ordered

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT chk_order_lines_quantity CHECK (quantity > 0),
  CONSTRAINT chk_order_lines_sku CHECK (LENGTH(sku) > 0 AND LENGTH(sku) <= 100)
);

-- Indexes
CREATE INDEX idx_order_lines_order ON order_lines(store_order_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_order_lines_kit_item ON order_lines(kit_item_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_order_lines_sku ON order_lines(sku) WHERE deleted_at IS NULL;

-- Comments
COMMENT ON TABLE order_lines IS 'Line items within a store order, linking to kit items with quantities';
COMMENT ON COLUMN order_lines.sku IS 'Denormalized SKU from kit_item for historical stability';
COMMENT ON COLUMN order_lines.quantity IS 'Quantity of this item ordered';

-- ============================================================================
-- SECTION 3: SHIPMENTS & TRACKING
-- ============================================================================
-- Manages split shipments and multi-package tracking

-- Shipments Table
-- One order can have multiple shipments (partial/split fulfillment)
CREATE TABLE shipments (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  store_order_id UUID NOT NULL REFERENCES store_orders(id) ON DELETE CASCADE,

  -- Shipment Details
  carrier TEXT,                       -- Carrier name (UPS, FEDEX, USPS, etc.)
  tracking_numbers JSONB DEFAULT '[]', -- Array of tracking numbers for this shipment
  status shipment_status NOT NULL DEFAULT 'LABEL_CREATED',

  -- Timestamps
  shipped_at TIMESTAMPTZ,    -- When carrier picked up package
  delivered_at TIMESTAMPTZ,  -- When delivered to store

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT chk_shipments_carrier CHECK (carrier IS NULL OR LENGTH(carrier) <= 100),
  CONSTRAINT chk_shipments_dates CHECK (delivered_at IS NULL OR shipped_at IS NULL OR delivered_at >= shipped_at)
);

-- Indexes
CREATE INDEX idx_shipments_order ON shipments(store_order_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_shipments_status ON shipments(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_shipments_carrier ON shipments(carrier) WHERE deleted_at IS NULL AND carrier IS NOT NULL;
CREATE INDEX idx_shipments_shipped ON shipments(shipped_at DESC) WHERE deleted_at IS NULL AND shipped_at IS NOT NULL;
CREATE INDEX idx_shipments_delivered ON shipments(delivered_at DESC) WHERE deleted_at IS NULL AND delivered_at IS NOT NULL;

-- GIN index for tracking numbers array search
CREATE INDEX idx_shipments_tracking_numbers ON shipments USING GIN (tracking_numbers) WHERE deleted_at IS NULL;

-- Comments
COMMENT ON TABLE shipments IS 'Individual shipments for orders. Supports split/partial fulfillment with multiple shipments per order.';
COMMENT ON COLUMN shipments.carrier IS 'Carrier name (UPS, FEDEX, USPS, etc.)';
COMMENT ON COLUMN shipments.tracking_numbers IS 'Array of tracking numbers (JSONB) - single shipment can have multiple boxes';
COMMENT ON COLUMN shipments.shipped_at IS 'Timestamp when carrier picked up package';
COMMENT ON COLUMN shipments.delivered_at IS 'Timestamp when delivered to store address';

-- Shipment Lines Table
-- Tracks exactly which items and quantities were in each shipment
CREATE TABLE shipment_lines (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  shipment_id UUID NOT NULL REFERENCES shipments(id) ON DELETE CASCADE,
  kit_item_id UUID NOT NULL REFERENCES kit_items(id) ON DELETE RESTRICT,

  -- Line Item Details
  quantity INTEGER NOT NULL,  -- Quantity of this item in this shipment

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT chk_shipment_lines_quantity CHECK (quantity > 0),
  CONSTRAINT uq_shipment_lines_item UNIQUE (shipment_id, kit_item_id)
);

-- Indexes
CREATE INDEX idx_shipment_lines_shipment ON shipment_lines(shipment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_shipment_lines_kit_item ON shipment_lines(kit_item_id) WHERE deleted_at IS NULL;

-- Comments
COMMENT ON TABLE shipment_lines IS 'Items and quantities included in each shipment (supports partial fulfillment)';
COMMENT ON COLUMN shipment_lines.quantity IS 'Quantity of this kit item included in this specific shipment';

-- ============================================================================
-- SECTION 4: PHOTO VERIFICATION & REVIEWS
-- ============================================================================
-- Manages photo upload, review, and retake workflow

-- Photo Uploads Table
-- Stores uploaded verification photos from store users
CREATE TABLE photo_uploads (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  assignment_item_id UUID REFERENCES assignment_items(id) ON DELETE SET NULL,  -- Optional item link
  location_slot_id UUID REFERENCES location_slots(id) ON DELETE SET NULL,      -- Optional slot link
  uploaded_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,

  -- Storage Details
  s3_key TEXT NOT NULL,           -- S3 object key (path)
  s3_url TEXT,                    -- Presigned URL (cached, regenerated as needed)
  file_size_bytes INTEGER,        -- File size for quota tracking
  mime_type TEXT,                 -- image/jpeg, image/png, etc.

  -- Review Status
  review_status photo_review_status NOT NULL DEFAULT 'PENDING',

  -- Timestamps
  uploaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT chk_photo_uploads_s3_key CHECK (LENGTH(s3_key) > 0 AND LENGTH(s3_key) <= 1024),
  CONSTRAINT chk_photo_uploads_mime_type CHECK (mime_type IS NULL OR mime_type LIKE 'image/%'),
  CONSTRAINT chk_photo_uploads_file_size CHECK (file_size_bytes IS NULL OR file_size_bytes > 0)
);

-- Indexes
CREATE INDEX idx_photo_uploads_assignment ON photo_uploads(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_item ON photo_uploads(assignment_item_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_slot ON photo_uploads(location_slot_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_user ON photo_uploads(uploaded_by_user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_status ON photo_uploads(review_status) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_uploaded ON photo_uploads(uploaded_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_s3_key ON photo_uploads(s3_key) WHERE deleted_at IS NULL;

-- Comments
COMMENT ON TABLE photo_uploads IS 'Verification photos uploaded by store users for campaign assignments';
COMMENT ON COLUMN photo_uploads.s3_key IS 'S3 object key (path) for stored image';
COMMENT ON COLUMN photo_uploads.s3_url IS 'Cached presigned URL (regenerate as needed)';
COMMENT ON COLUMN photo_uploads.file_size_bytes IS 'File size in bytes for quota tracking';
COMMENT ON COLUMN photo_uploads.review_status IS 'Current review status (PENDING/APPROVED/REJECTED/SUPERSEDED)';

-- Photo Reviews Table
-- Records of admin reviews (approval/rejection) of photos
CREATE TABLE photo_reviews (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  photo_upload_id UUID NOT NULL REFERENCES photo_uploads(id) ON DELETE CASCADE,
  reviewer_user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,

  -- Review Decision
  status photo_review_status NOT NULL,  -- APPROVED or REJECTED
  rejection_reason rejection_reason,    -- Required if REJECTED
  rejection_comment TEXT,               -- Optional additional instructions

  -- Timestamps
  reviewed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT chk_photo_reviews_status CHECK (status IN ('APPROVED', 'REJECTED')),
  CONSTRAINT chk_photo_reviews_rejection CHECK (
    (status = 'REJECTED' AND rejection_reason IS NOT NULL) OR
    (status = 'APPROVED' AND rejection_reason IS NULL)
  )
);

-- Indexes
CREATE INDEX idx_photo_reviews_photo ON photo_reviews(photo_upload_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_reviews_reviewer ON photo_reviews(reviewer_user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_reviews_status ON photo_reviews(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_reviews_reviewed ON photo_reviews(reviewed_at DESC) WHERE deleted_at IS NULL;

-- Comments
COMMENT ON TABLE photo_reviews IS 'Review records for photo uploads (approval/rejection decisions)';
COMMENT ON COLUMN photo_reviews.status IS 'Review decision: APPROVED or REJECTED';
COMMENT ON COLUMN photo_reviews.rejection_reason IS 'Standardized rejection reason (required if REJECTED)';
COMMENT ON COLUMN photo_reviews.rejection_comment IS 'Optional additional instructions for store on what to fix';

-- Retake Requests Table
-- Tracks retake workflow when photos are rejected
CREATE TABLE retake_requests (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  photo_upload_id UUID NOT NULL REFERENCES photo_uploads(id) ON DELETE CASCADE,  -- Original rejected photo
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  new_photo_upload_id UUID REFERENCES photo_uploads(id) ON DELETE SET NULL,  -- Replacement photo

  -- Retake Details
  reason rejection_reason NOT NULL,  -- Why retake is needed
  comment TEXT,                      -- Instructions to store

  -- Timestamps
  requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,  -- When replacement photo submitted

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT chk_retake_requests_completion CHECK (
    completed_at IS NULL OR
    (completed_at >= requested_at AND new_photo_upload_id IS NOT NULL)
  )
);

-- Indexes
CREATE INDEX idx_retake_requests_photo ON retake_requests(photo_upload_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_retake_requests_assignment ON retake_requests(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_retake_requests_new_photo ON retake_requests(new_photo_upload_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_retake_requests_pending ON retake_requests(requested_at DESC) WHERE deleted_at IS NULL AND completed_at IS NULL;
CREATE INDEX idx_retake_requests_completed ON retake_requests(completed_at DESC) WHERE deleted_at IS NULL AND completed_at IS NOT NULL;

-- Comments
COMMENT ON TABLE retake_requests IS 'Tracks retake workflow for rejected photos';
COMMENT ON COLUMN retake_requests.photo_upload_id IS 'Original rejected photo that needs replacement';
COMMENT ON COLUMN retake_requests.new_photo_upload_id IS 'Replacement photo uploaded by store (when completed)';
COMMENT ON COLUMN retake_requests.reason IS 'Why retake is needed (from rejection reason)';
COMMENT ON COLUMN retake_requests.comment IS 'Additional instructions to store on what to fix';

-- ============================================================================
-- SECTION 5: ISSUE REPORTING & RESOLUTION
-- ============================================================================
-- Manages store-reported issues and automated reorder workflow

-- Issue Requests Table
-- Store-reported issues with received items (missing, damaged, incorrect)
CREATE TABLE issue_requests (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  submitted_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  reviewed_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  evidence_photo_id UUID REFERENCES photo_uploads(id) ON DELETE SET NULL,

  -- Issue Details
  type issue_type NOT NULL,
  description TEXT,
  status issue_request_status NOT NULL DEFAULT 'OPEN',

  -- Timestamps
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  reviewed_at TIMESTAMPTZ,

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT chk_issue_requests_reviewed CHECK (
    reviewed_at IS NULL OR reviewed_by_user_id IS NOT NULL
  ),
  CONSTRAINT chk_issue_requests_evidence CHECK (
    (type = 'DAMAGED' AND evidence_photo_id IS NOT NULL) OR
    type != 'DAMAGED'
  )
);

-- Indexes
CREATE INDEX idx_issue_requests_assignment ON issue_requests(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_issue_requests_submitter ON issue_requests(submitted_by_user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_issue_requests_reviewer ON issue_requests(reviewed_by_user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_issue_requests_type ON issue_requests(type) WHERE deleted_at IS NULL;
CREATE INDEX idx_issue_requests_status ON issue_requests(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_issue_requests_submitted ON issue_requests(submitted_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_issue_requests_pending ON issue_requests(status) WHERE deleted_at IS NULL AND status IN ('OPEN', 'TRIAGED', 'AWAITING_APPROVAL');

-- Comments
COMMENT ON TABLE issue_requests IS 'Store-reported issues with received items (missing, damaged, incorrect, packaging)';
COMMENT ON COLUMN issue_requests.type IS 'Type of issue: MISSING, DAMAGED, INCORRECT, or PACKAGING';
COMMENT ON COLUMN issue_requests.description IS 'Store description of the issue';
COMMENT ON COLUMN issue_requests.evidence_photo_id IS 'Required for DAMAGED type, optional for others';
COMMENT ON COLUMN issue_requests.status IS 'Workflow status from OPEN through RESOLVED/DENIED';

-- Issue Lines Table
-- Specific kit items affected by an issue request
CREATE TABLE issue_lines (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  issue_request_id UUID NOT NULL REFERENCES issue_requests(id) ON DELETE CASCADE,
  kit_item_id UUID NOT NULL REFERENCES kit_items(id) ON DELETE RESTRICT,

  -- Line Details
  quantity INTEGER NOT NULL DEFAULT 1,  -- Quantity affected

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT chk_issue_lines_quantity CHECK (quantity > 0),
  CONSTRAINT uq_issue_lines_item UNIQUE (issue_request_id, kit_item_id)
);

-- Indexes
CREATE INDEX idx_issue_lines_request ON issue_lines(issue_request_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_issue_lines_kit_item ON issue_lines(kit_item_id) WHERE deleted_at IS NULL;

-- Comments
COMMENT ON TABLE issue_lines IS 'Specific kit items and quantities affected by an issue request';
COMMENT ON COLUMN issue_lines.quantity IS 'Quantity of this item affected by the issue';

-- Reorders Table
-- Links approved issue requests to generated replacement orders
CREATE TABLE reorders (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  issue_request_id UUID NOT NULL REFERENCES issue_requests(id) ON DELETE RESTRICT,
  store_order_id UUID NOT NULL REFERENCES store_orders(id) ON DELETE RESTRICT,

  -- Status (denormalized from store_order for convenience)
  status store_order_status,

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT uq_reorders_issue UNIQUE (issue_request_id),
  CONSTRAINT uq_reorders_order UNIQUE (store_order_id)
);

-- Indexes
CREATE INDEX idx_reorders_issue ON reorders(issue_request_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_reorders_order ON reorders(store_order_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_reorders_status ON reorders(status) WHERE deleted_at IS NULL;

-- Comments
COMMENT ON TABLE reorders IS 'Links approved issue requests to generated replacement orders';
COMMENT ON COLUMN reorders.issue_request_id IS 'Issue request that triggered this reorder';
COMMENT ON COLUMN reorders.store_order_id IS 'Generated replacement order (type=REORDER)';
COMMENT ON COLUMN reorders.status IS 'Denormalized status from store_order for quick queries';

-- ============================================================================
-- SECTION 6: QUANTITY TRACKING (ASSIGNMENT ITEMS)
-- ============================================================================
-- Extends assignment_items with detailed quantity tracking for fulfillment

-- Add quantity tracking columns to assignment_items
-- These support derived FulfillmentStatus and ReceiptStatus computations
COMMENT ON TABLE assignment_items IS 'Kit items assigned to stores in campaigns, with quantity tracking for fulfillment and receipt';

-- Add columns for quantity tracking (if not already present)
-- Note: These columns may already exist from core schema; include here for documentation

-- Required Quantity
COMMENT ON COLUMN assignment_items.quantity IS 'Required quantity of this item for the store';

-- Fulfillment quantities
ALTER TABLE assignment_items ADD COLUMN IF NOT EXISTS shipped_qty INTEGER NOT NULL DEFAULT 0;
ALTER TABLE assignment_items ADD COLUMN IF NOT EXISTS delivered_qty INTEGER NOT NULL DEFAULT 0;

COMMENT ON COLUMN assignment_items.shipped_qty IS 'Total quantity shipped across all shipments';
COMMENT ON COLUMN assignment_items.delivered_qty IS 'Total quantity delivered to store';

-- Receipt quantities
ALTER TABLE assignment_items ADD COLUMN IF NOT EXISTS received_good_qty INTEGER NOT NULL DEFAULT 0;
ALTER TABLE assignment_items ADD COLUMN IF NOT EXISTS received_damaged_qty INTEGER NOT NULL DEFAULT 0;

COMMENT ON COLUMN assignment_items.received_good_qty IS 'Quantity received in good condition (store-confirmed)';
COMMENT ON COLUMN assignment_items.received_damaged_qty IS 'Quantity received damaged (store-reported)';

-- Installation quantity
ALTER TABLE assignment_items ADD COLUMN IF NOT EXISTS installed_qty INTEGER NOT NULL DEFAULT 0;

COMMENT ON COLUMN assignment_items.installed_qty IS 'Quantity installed at location slots';

-- Verification quantity
ALTER TABLE assignment_items ADD COLUMN IF NOT EXISTS satisfied_qty INTEGER NOT NULL DEFAULT 0;

COMMENT ON COLUMN assignment_items.satisfied_qty IS 'Quantity with approved verification photos';

-- Add constraints
ALTER TABLE assignment_items ADD CONSTRAINT IF NOT EXISTS chk_assignment_items_shipped
  CHECK (shipped_qty >= 0 AND shipped_qty <= quantity * 2);  -- Allow some overage for replacements

ALTER TABLE assignment_items ADD CONSTRAINT IF NOT EXISTS chk_assignment_items_delivered
  CHECK (delivered_qty >= 0 AND delivered_qty <= shipped_qty);

ALTER TABLE assignment_items ADD CONSTRAINT IF NOT EXISTS chk_assignment_items_received
  CHECK (received_good_qty >= 0 AND received_damaged_qty >= 0 AND
         (received_good_qty + received_damaged_qty) <= delivered_qty);

ALTER TABLE assignment_items ADD CONSTRAINT IF NOT EXISTS chk_assignment_items_installed
  CHECK (installed_qty >= 0 AND installed_qty <= received_good_qty);

ALTER TABLE assignment_items ADD CONSTRAINT IF NOT EXISTS chk_assignment_items_satisfied
  CHECK (satisfied_qty >= 0 AND satisfied_qty <= installed_qty);

-- Indexes for quantity queries
CREATE INDEX IF NOT EXISTS idx_assignment_items_quantities ON assignment_items(
  store_assignment_id,
  quantity,
  shipped_qty,
  delivered_qty,
  satisfied_qty
) WHERE deleted_at IS NULL;

-- ============================================================================
-- SECTION 7: RECEIVE VERIFICATIONS
-- ============================================================================
-- Store confirmation of receipt (may be per-shipment or cumulative)

-- Receive Verifications Table
-- Records store confirmation of receipt
CREATE TABLE receive_verifications (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  verified_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  shipment_id UUID REFERENCES shipments(id) ON DELETE SET NULL,  -- Optional link to specific shipment

  -- Verification Details
  all_items_received BOOLEAN NOT NULL DEFAULT TRUE,
  notes TEXT,

  -- Timestamps
  verified_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT chk_receive_verifications_notes CHECK (notes IS NULL OR LENGTH(notes) <= 2000)
);

-- Indexes
CREATE INDEX idx_receive_verifications_assignment ON receive_verifications(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_receive_verifications_user ON receive_verifications(verified_by_user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_receive_verifications_shipment ON receive_verifications(shipment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_receive_verifications_verified ON receive_verifications(verified_at DESC) WHERE deleted_at IS NULL;

-- Comments
COMMENT ON TABLE receive_verifications IS 'Store confirmation of receipt for shipments';
COMMENT ON COLUMN receive_verifications.all_items_received IS 'Whether store confirmed all items received in good condition';
COMMENT ON COLUMN receive_verifications.notes IS 'Optional notes about receipt (damages, discrepancies, etc.)';
COMMENT ON COLUMN receive_verifications.shipment_id IS 'Optional link to specific shipment (if per-shipment verification)';

-- ============================================================================
-- SECTION 8: SURVEY RESPONSES
-- ============================================================================
-- Store responses to installation/receipt surveys

-- Store Survey Responses Table
-- Full survey responses submitted by stores
CREATE TABLE store_survey_responses (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Foreign Keys
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  survey_version_id UUID NOT NULL REFERENCES survey_versions(id) ON DELETE RESTRICT,
  submitted_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,

  -- Response Data
  response_json JSONB NOT NULL,  -- Full survey answers

  -- Timestamps
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Audit Fields
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints
  CONSTRAINT chk_survey_responses_json CHECK (response_json IS NOT NULL AND response_json != '{}'::jsonb)
);

-- Indexes
CREATE INDEX idx_survey_responses_assignment ON store_survey_responses(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_survey_responses_survey ON store_survey_responses(survey_version_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_survey_responses_user ON store_survey_responses(submitted_by_user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_survey_responses_submitted ON store_survey_responses(submitted_at DESC) WHERE deleted_at IS NULL;

-- GIN index for JSONB queries
CREATE INDEX idx_survey_responses_json ON store_survey_responses USING GIN (response_json) WHERE deleted_at IS NULL;

-- Comments
COMMENT ON TABLE store_survey_responses IS 'Store responses to installation and receipt surveys';
COMMENT ON COLUMN store_survey_responses.response_json IS 'Full survey answers in JSONB format';

-- ============================================================================
-- SECTION 9: TRIGGERS
-- ============================================================================
-- Automated triggers for timestamp management and denormalization

-- Function: Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at trigger to all PSP module tables
CREATE TRIGGER trg_store_orders_updated_at
  BEFORE UPDATE ON store_orders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_order_lines_updated_at
  BEFORE UPDATE ON order_lines
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_shipments_updated_at
  BEFORE UPDATE ON shipments
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_shipment_lines_updated_at
  BEFORE UPDATE ON shipment_lines
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_photo_uploads_updated_at
  BEFORE UPDATE ON photo_uploads
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_photo_reviews_updated_at
  BEFORE UPDATE ON photo_reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_retake_requests_updated_at
  BEFORE UPDATE ON retake_requests
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_issue_requests_updated_at
  BEFORE UPDATE ON issue_requests
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_issue_lines_updated_at
  BEFORE UPDATE ON issue_lines
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_reorders_updated_at
  BEFORE UPDATE ON reorders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_receive_verifications_updated_at
  BEFORE UPDATE ON receive_verifications
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_survey_responses_updated_at
  BEFORE UPDATE ON store_survey_responses
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Function: Sync reorder status from store_order
CREATE OR REPLACE FUNCTION sync_reorder_status()
RETURNS TRIGGER AS $$
BEGIN
  -- Update reorders table status when store_order status changes
  UPDATE reorders
  SET status = NEW.status,
      updated_at = NOW()
  WHERE store_order_id = NEW.id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sync_reorder_status
  AFTER UPDATE OF status ON store_orders
  FOR EACH ROW
  WHEN (OLD.status IS DISTINCT FROM NEW.status)
  EXECUTE FUNCTION sync_reorder_status();

-- Function: Auto-update photo_upload review_status when reviewed
CREATE OR REPLACE FUNCTION update_photo_review_status()
RETURNS TRIGGER AS $$
BEGIN
  -- Update photo_upload status based on latest review
  UPDATE photo_uploads
  SET review_status = NEW.status,
      updated_at = NOW()
  WHERE id = NEW.photo_upload_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_photo_review_status
  AFTER INSERT ON photo_reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_photo_review_status();

-- ============================================================================
-- SECTION 10: UTILITY FUNCTIONS
-- ============================================================================
-- Helper functions for common query patterns

-- Function: Calculate fulfillment status for an assignment item
CREATE OR REPLACE FUNCTION get_fulfillment_status(
  p_required_qty INTEGER,
  p_shipped_qty INTEGER,
  p_delivered_qty INTEGER,
  p_is_cancelled BOOLEAN DEFAULT FALSE
)
RETURNS TEXT AS $$
BEGIN
  IF p_is_cancelled THEN
    RETURN 'CANCELLED';
  ELSIF p_shipped_qty = 0 THEN
    RETURN 'NOT_SHIPPED';
  ELSIF p_shipped_qty < p_required_qty THEN
    RETURN 'PARTIALLY_SHIPPED';
  ELSIF p_delivered_qty = 0 THEN
    RETURN 'SHIPPED';
  ELSIF p_delivered_qty < p_required_qty THEN
    RETURN 'PARTIALLY_DELIVERED';
  ELSE
    RETURN 'DELIVERED';
  END IF;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION get_fulfillment_status IS 'Computes derived FulfillmentStatus from quantities';

-- Function: Calculate receipt status for an assignment item
CREATE OR REPLACE FUNCTION get_receipt_status(
  p_delivered_qty INTEGER,
  p_received_good_qty INTEGER,
  p_received_damaged_qty INTEGER
)
RETURNS TEXT AS $$
DECLARE
  v_received_total INTEGER;
BEGIN
  v_received_total := p_received_good_qty + p_received_damaged_qty;

  IF p_delivered_qty = 0 THEN
    RETURN 'NOT_DELIVERED';
  ELSIF v_received_total = 0 THEN
    RETURN 'NOT_RECEIVED';
  ELSIF v_received_total < p_delivered_qty THEN
    RETURN 'PARTIALLY_RECEIVED';
  ELSIF p_received_damaged_qty > 0 THEN
    RETURN 'RECEIVED_WITH_DAMAGE';
  ELSE
    RETURN 'RECEIVED';
  END IF;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION get_receipt_status IS 'Computes derived ReceiptStatus from delivery and receipt quantities';

-- Function: Calculate verification status for an assignment item
CREATE OR REPLACE FUNCTION get_verification_status(
  p_required_qty INTEGER,
  p_satisfied_qty INTEGER,
  p_has_rejected BOOLEAN,
  p_is_waived BOOLEAN DEFAULT FALSE
)
RETURNS TEXT AS $$
BEGIN
  IF p_is_waived THEN
    RETURN 'WAIVED';
  ELSIF p_has_rejected THEN
    RETURN 'REJECTED';
  ELSIF p_satisfied_qty = 0 THEN
    RETURN 'NA';
  ELSIF p_satisfied_qty >= p_required_qty THEN
    RETURN 'APPROVED';
  ELSIF p_satisfied_qty > 0 THEN
    RETURN 'PARTIALLY_APPROVED';
  ELSE
    RETURN 'PENDING';
  END IF;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION get_verification_status IS 'Computes derived VerificationStatus from satisfied quantity and rejection state';

-- ============================================================================
-- SECTION 11: VIEWS
-- ============================================================================
-- Convenience views for common query patterns

-- View: Order fulfillment summary
CREATE OR REPLACE VIEW v_order_fulfillment_summary AS
SELECT
  so.id AS order_id,
  so.order_number,
  so.campaign_id,
  so.store_id,
  so.order_type,
  so.status,
  so.batch_label,
  COUNT(DISTINCT s.id) AS shipment_count,
  COUNT(DISTINCT ol.id) AS line_count,
  SUM(ol.quantity) AS total_items_ordered,
  SUM(sl.quantity) AS total_items_shipped,
  MIN(s.shipped_at) AS first_shipment_date,
  MAX(s.delivered_at) AS last_delivery_date,
  BOOL_OR(s.status = 'EXCEPTION') AS has_exception,
  so.created_at,
  so.acknowledged_at
FROM store_orders so
LEFT JOIN order_lines ol ON ol.store_order_id = so.id AND ol.deleted_at IS NULL
LEFT JOIN shipments s ON s.store_order_id = so.id AND s.deleted_at IS NULL
LEFT JOIN shipment_lines sl ON sl.shipment_id = s.id AND sl.deleted_at IS NULL
WHERE so.deleted_at IS NULL
GROUP BY so.id;

COMMENT ON VIEW v_order_fulfillment_summary IS 'Summary view of order fulfillment with shipment counts and dates';

-- View: Assignment verification status
CREATE OR REPLACE VIEW v_assignment_verification_status AS
SELECT
  sa.id AS assignment_id,
  sa.campaign_id,
  sa.store_id,
  sa.status AS assignment_status,
  COUNT(DISTINCT ai.id) AS item_count,
  SUM(ai.quantity) AS total_required_qty,
  SUM(ai.satisfied_qty) AS total_satisfied_qty,
  COUNT(DISTINCT pu.id) FILTER (WHERE pu.review_status = 'PENDING') AS pending_photos,
  COUNT(DISTINCT pu.id) FILTER (WHERE pu.review_status = 'APPROVED') AS approved_photos,
  COUNT(DISTINCT pu.id) FILTER (WHERE pu.review_status = 'REJECTED') AS rejected_photos,
  COUNT(DISTINCT rr.id) FILTER (WHERE rr.completed_at IS NULL) AS open_retakes,
  MAX(pu.uploaded_at) AS last_photo_upload,
  MAX(pr.reviewed_at) AS last_review_date
FROM store_assignments sa
LEFT JOIN assignment_items ai ON ai.store_assignment_id = sa.id AND ai.deleted_at IS NULL
LEFT JOIN photo_uploads pu ON pu.store_assignment_id = sa.id AND pu.deleted_at IS NULL
LEFT JOIN photo_reviews pr ON pr.photo_upload_id = pu.id AND pr.deleted_at IS NULL
LEFT JOIN retake_requests rr ON rr.store_assignment_id = sa.id AND rr.deleted_at IS NULL
WHERE sa.deleted_at IS NULL
GROUP BY sa.id;

COMMENT ON VIEW v_assignment_verification_status IS 'Summary of verification status for each store assignment';

-- View: Issue request summary
CREATE OR REPLACE VIEW v_issue_request_summary AS
SELECT
  ir.id AS issue_id,
  ir.store_assignment_id,
  sa.campaign_id,
  sa.store_id,
  ir.type,
  ir.status,
  ir.submitted_at,
  ir.reviewed_at,
  COUNT(DISTINCT il.id) AS affected_items,
  SUM(il.quantity) AS total_affected_qty,
  r.store_order_id AS reorder_id,
  so.order_number AS reorder_number,
  r.status AS reorder_status
FROM issue_requests ir
JOIN store_assignments sa ON sa.id = ir.store_assignment_id
LEFT JOIN issue_lines il ON il.issue_request_id = ir.id AND il.deleted_at IS NULL
LEFT JOIN reorders r ON r.issue_request_id = ir.id AND r.deleted_at IS NULL
LEFT JOIN store_orders so ON so.id = r.store_order_id AND so.deleted_at IS NULL
WHERE ir.deleted_at IS NULL
GROUP BY ir.id, sa.id, r.id, so.id;

COMMENT ON VIEW v_issue_request_summary IS 'Summary of issue requests with affected items and reorder status';

-- ============================================================================
-- SECTION 12: SAMPLE QUERIES
-- ============================================================================
-- Document common query patterns

COMMENT ON DATABASE current_database() IS '
PSP Operations Module Sample Queries:

-- 1. Get all pending orders for a campaign
SELECT * FROM store_orders
WHERE campaign_id = :campaign_id
  AND status IN (''GENERATED'', ''ACKNOWLEDGED'')
  AND deleted_at IS NULL;

-- 2. Get shipment tracking for a store
SELECT s.*, so.order_number, so.order_type
FROM shipments s
JOIN store_orders so ON so.id = s.store_order_id
WHERE so.store_id = :store_id
  AND s.deleted_at IS NULL
ORDER BY s.shipped_at DESC;

-- 3. Get photos pending review for a brand
SELECT pu.*, sa.store_id, c.name AS campaign_name
FROM photo_uploads pu
JOIN store_assignments sa ON sa.id = pu.store_assignment_id
JOIN campaigns c ON c.id = sa.campaign_id
WHERE c.brand_id = :brand_id
  AND pu.review_status = ''PENDING''
  AND pu.deleted_at IS NULL
ORDER BY pu.uploaded_at ASC;

-- 4. Get open issues for a store
SELECT ir.*, COUNT(il.id) AS affected_items
FROM issue_requests ir
JOIN issue_lines il ON il.issue_request_id = ir.id
JOIN store_assignments sa ON sa.id = ir.store_assignment_id
WHERE sa.store_id = :store_id
  AND ir.status NOT IN (''RESOLVED'', ''DENIED'')
  AND ir.deleted_at IS NULL
GROUP BY ir.id;

-- 5. Get reorder status for an issue
SELECT r.*, so.order_number, so.status AS order_status, s.tracking_numbers
FROM reorders r
JOIN store_orders so ON so.id = r.store_order_id
LEFT JOIN shipments s ON s.store_order_id = so.id
WHERE r.issue_request_id = :issue_id
  AND r.deleted_at IS NULL;
';

-- ============================================================================
-- END OF PSP OPERATIONS MODULE DDL
-- ============================================================================
