-- ===========================================================================
-- BRAND ADMIN MODULE - DATABASE SCHEMA
-- ===========================================================================
-- Version: 1.0
-- Generated: 2025-12-19
-- Dependencies: Platform Ops tables (tenants, users, brands)
--
-- This schema defines all database tables for the Brand Admin Module including:
-- - Geographic hierarchy (regions, districts, territories)
-- - Store management and grouping
-- - Store layouts and location slots
-- - Survey templates and versioning
-- - Photo rules and verification
-- - Campaigns and kit definitions
-- - Store assignments and tasks
-- - Orders, shipments, and fulfillment
-- - Execution tracking and photo verification
-- - Issues and reorders
-- - Notifications and audit trails
-- ===========================================================================

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ===========================================================================
-- SECTION 1: GEOGRAPHIC HIERARCHY & STORES
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: regions
-- Purpose: Top-level geographic grouping for stores (e.g., "West Coast", "Northeast")
-- ---------------------------------------------------------------------------
CREATE TABLE regions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL,
    name TEXT NOT NULL,
    code TEXT NOT NULL,
    parent_region_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_regions_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE,
    CONSTRAINT fk_regions_parent FOREIGN KEY (parent_region_id)
        REFERENCES regions(id) ON DELETE SET NULL,
    CONSTRAINT uq_regions_brand_code UNIQUE (brand_id, code)
);

COMMENT ON TABLE regions IS 'Top-level geographic hierarchy for store organization';
COMMENT ON COLUMN regions.code IS 'Short code for region (e.g., WC, NE)';
COMMENT ON COLUMN regions.parent_region_id IS 'Optional parent region for hierarchical regions';

-- ---------------------------------------------------------------------------
-- TABLE: districts
-- Purpose: Optional mid-level geographic grouping within regions
-- ---------------------------------------------------------------------------
CREATE TABLE districts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL,
    region_id UUID NOT NULL,
    name TEXT NOT NULL,
    code TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_districts_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE,
    CONSTRAINT fk_districts_region FOREIGN KEY (region_id)
        REFERENCES regions(id) ON DELETE CASCADE,
    CONSTRAINT uq_districts_brand_code UNIQUE (brand_id, code)
);

COMMENT ON TABLE districts IS 'Optional mid-level geographic grouping within regions';
COMMENT ON COLUMN districts.code IS 'Short code for district';

-- ---------------------------------------------------------------------------
-- TABLE: territories
-- Purpose: Optional lower-level geographic grouping within districts/regions
-- ---------------------------------------------------------------------------
CREATE TABLE territories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL,
    district_id UUID,
    region_id UUID NOT NULL,
    name TEXT NOT NULL,
    code TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_territories_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE,
    CONSTRAINT fk_territories_district FOREIGN KEY (district_id)
        REFERENCES districts(id) ON DELETE SET NULL,
    CONSTRAINT fk_territories_region FOREIGN KEY (region_id)
        REFERENCES regions(id) ON DELETE CASCADE,
    CONSTRAINT uq_territories_brand_code UNIQUE (brand_id, code)
);

COMMENT ON TABLE territories IS 'Optional lower-level geographic grouping, can belong to district or directly to region';
COMMENT ON COLUMN territories.district_id IS 'Optional parent district';
COMMENT ON COLUMN territories.region_id IS 'Fallback parent region if no district';

-- ---------------------------------------------------------------------------
-- TABLE: stores
-- Purpose: Master store records with address, contact, and geography
-- ---------------------------------------------------------------------------
CREATE TABLE stores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL,
    store_number TEXT NOT NULL,
    name TEXT NOT NULL,
    address_line1 TEXT NOT NULL,
    address_line2 TEXT,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    zip_code TEXT NOT NULL,
    country TEXT NOT NULL DEFAULT 'US',
    region_id UUID NOT NULL,
    district_id UUID,
    territory_id UUID,
    status TEXT NOT NULL DEFAULT 'ACTIVE',
    primary_contact_name TEXT,
    primary_contact_email TEXT,
    primary_contact_phone TEXT,
    store_manager_name TEXT,
    external_store_guid TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_stores_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE,
    CONSTRAINT fk_stores_region FOREIGN KEY (region_id)
        REFERENCES regions(id) ON DELETE RESTRICT,
    CONSTRAINT fk_stores_district FOREIGN KEY (district_id)
        REFERENCES districts(id) ON DELETE SET NULL,
    CONSTRAINT fk_stores_territory FOREIGN KEY (territory_id)
        REFERENCES territories(id) ON DELETE SET NULL,
    CONSTRAINT uq_stores_brand_number UNIQUE (brand_id, store_number),
    CONSTRAINT chk_stores_status CHECK (status IN ('ACTIVE', 'INACTIVE', 'TEMP_CLOSED', 'CLOSED'))
);

COMMENT ON TABLE stores IS 'Master store records with location, contact, and operational status';
COMMENT ON COLUMN stores.store_number IS 'Brand-specific unique store identifier';
COMMENT ON COLUMN stores.external_store_guid IS 'External system mapping identifier';
COMMENT ON COLUMN stores.status IS 'Store operational status: ACTIVE, INACTIVE, TEMP_CLOSED, CLOSED';

-- ---------------------------------------------------------------------------
-- TABLE: store_groups
-- Purpose: Custom groupings for stores (e.g., "High Volume", "Test Markets")
-- ---------------------------------------------------------------------------
CREATE TABLE store_groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    created_by_user_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_store_groups_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE,
    CONSTRAINT fk_store_groups_creator FOREIGN KEY (created_by_user_id)
        REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE store_groups IS 'Custom groupings for campaign targeting and reporting';
COMMENT ON COLUMN store_groups.created_by_user_id IS 'User who created this group';

-- ---------------------------------------------------------------------------
-- TABLE: store_group_memberships
-- Purpose: Many-to-many relationship between stores and groups
-- ---------------------------------------------------------------------------
CREATE TABLE store_group_memberships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL,
    store_group_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_store_group_memberships_store FOREIGN KEY (store_id)
        REFERENCES stores(id) ON DELETE CASCADE,
    CONSTRAINT fk_store_group_memberships_group FOREIGN KEY (store_group_id)
        REFERENCES store_groups(id) ON DELETE CASCADE,
    CONSTRAINT uq_store_group_memberships UNIQUE (store_id, store_group_id)
);

COMMENT ON TABLE store_group_memberships IS 'Association between stores and custom groups';

-- ===========================================================================
-- SECTION 2: STORE LAYOUTS & LOCATION SLOTS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: store_layouts
-- Purpose: Version-controlled layout definitions for stores
-- ---------------------------------------------------------------------------
CREATE TABLE store_layouts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL,
    version INT NOT NULL DEFAULT 1,
    is_current BOOLEAN NOT NULL DEFAULT TRUE,
    layout_json JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_store_layouts_store FOREIGN KEY (store_id)
        REFERENCES stores(id) ON DELETE CASCADE,
    CONSTRAINT uq_store_layouts_version UNIQUE (store_id, version)
);

COMMENT ON TABLE store_layouts IS 'Version-controlled layout definitions for stores';
COMMENT ON COLUMN store_layouts.version IS 'Incrementing version number for layout changes';
COMMENT ON COLUMN store_layouts.is_current IS 'Whether this is the active layout version';
COMMENT ON COLUMN store_layouts.layout_json IS 'Full layout definition in JSON format';

-- ---------------------------------------------------------------------------
-- TABLE: location_slots
-- Purpose: Physical placement slots within a store (e.g., "Front Window", "Cooler 1")
-- ---------------------------------------------------------------------------
CREATE TABLE location_slots (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_layout_id UUID NOT NULL,
    slot_name TEXT NOT NULL,
    slot_type TEXT NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    dimensions JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_location_slots_layout FOREIGN KEY (store_layout_id)
        REFERENCES store_layouts(id) ON DELETE CASCADE
);

COMMENT ON TABLE location_slots IS 'Physical placement locations within a store layout';
COMMENT ON COLUMN location_slots.slot_name IS 'Display name for the slot (e.g., Front Window)';
COMMENT ON COLUMN location_slots.slot_type IS 'Category of slot (e.g., WINDOW, SHELF, COOLER, DOOR)';
COMMENT ON COLUMN location_slots.dimensions IS 'Optional width/height metadata in JSON';

-- ===========================================================================
-- SECTION 3: SURVEYS & PHOTO RULES
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: survey_templates
-- Purpose: Reusable survey definitions owned by brands
-- ---------------------------------------------------------------------------
CREATE TABLE survey_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_survey_templates_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE
);

COMMENT ON TABLE survey_templates IS 'Reusable survey definitions for store data collection';
COMMENT ON COLUMN survey_templates.is_active IS 'Whether template is available for new campaigns';

-- ---------------------------------------------------------------------------
-- TABLE: survey_versions
-- Purpose: Immutable versioned survey definitions
-- ---------------------------------------------------------------------------
CREATE TABLE survey_versions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    survey_template_id UUID NOT NULL,
    version_number INT NOT NULL,
    definition_json JSONB NOT NULL,
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_survey_versions_template FOREIGN KEY (survey_template_id)
        REFERENCES survey_templates(id) ON DELETE CASCADE,
    CONSTRAINT uq_survey_versions UNIQUE (survey_template_id, version_number)
);

COMMENT ON TABLE survey_versions IS 'Immutable versioned survey definitions';
COMMENT ON COLUMN survey_versions.definition_json IS 'Complete survey structure including fields, logic, validation';
COMMENT ON COLUMN survey_versions.published_at IS 'When this version was made active';

-- ---------------------------------------------------------------------------
-- TABLE: photo_rules
-- Purpose: Photo capture requirements for items/slots
-- ---------------------------------------------------------------------------
CREATE TABLE photo_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL,
    name TEXT NOT NULL,
    min_photos INT NOT NULL DEFAULT 1,
    max_photos INT NOT NULL DEFAULT 5,
    require_flash BOOLEAN NOT NULL DEFAULT FALSE,
    min_resolution INT,
    ghost_image_url TEXT,
    instructions TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_photo_rules_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE,
    CONSTRAINT chk_photo_rules_count CHECK (min_photos <= max_photos)
);

COMMENT ON TABLE photo_rules IS 'Photo capture requirements for verification';
COMMENT ON COLUMN photo_rules.min_photos IS 'Minimum number of photos required';
COMMENT ON COLUMN photo_rules.max_photos IS 'Maximum number of photos allowed';
COMMENT ON COLUMN photo_rules.ghost_image_url IS 'Reference overlay image for guidance';
COMMENT ON COLUMN photo_rules.instructions IS 'User guidance for photo capture';

-- ===========================================================================
-- SECTION 4: CAMPAIGNS & KITS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: kit_definitions
-- Purpose: Reusable kit templates containing items
-- ---------------------------------------------------------------------------
CREATE TABLE kit_definitions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    is_template BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_kit_definitions_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE
);

COMMENT ON TABLE kit_definitions IS 'Reusable kit templates containing items to be shipped';
COMMENT ON COLUMN kit_definitions.is_template IS 'Whether this is a reusable template or campaign-specific';

-- ---------------------------------------------------------------------------
-- TABLE: kit_items
-- Purpose: Individual items within a kit definition
-- ---------------------------------------------------------------------------
CREATE TABLE kit_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kit_definition_id UUID NOT NULL,
    sku TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    quantity INT NOT NULL DEFAULT 1,
    slot_type TEXT,
    photo_rule_id UUID,
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_kit_items_kit FOREIGN KEY (kit_definition_id)
        REFERENCES kit_definitions(id) ON DELETE CASCADE,
    CONSTRAINT fk_kit_items_photo_rule FOREIGN KEY (photo_rule_id)
        REFERENCES photo_rules(id) ON DELETE SET NULL,
    CONSTRAINT chk_kit_items_quantity CHECK (quantity > 0)
);

COMMENT ON TABLE kit_items IS 'Individual items within a kit definition';
COMMENT ON COLUMN kit_items.sku IS 'Product SKU identifier';
COMMENT ON COLUMN kit_items.slot_type IS 'Target location type (e.g., WINDOW, SHELF)';
COMMENT ON COLUMN kit_items.photo_rule_id IS 'Photo requirements for this item';

-- ---------------------------------------------------------------------------
-- TABLE: campaigns
-- Purpose: Marketing campaigns with store assignments
-- ---------------------------------------------------------------------------
CREATE TABLE campaigns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status TEXT NOT NULL DEFAULT 'DRAFT',
    verification_mode TEXT NOT NULL DEFAULT 'STRICT',
    psp_campaign_ref TEXT,
    selection_recipe_json JSONB,
    kit_definition_id UUID,
    survey_version_id UUID,
    published_at TIMESTAMPTZ,
    published_by_user_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_campaigns_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE,
    CONSTRAINT fk_campaigns_kit FOREIGN KEY (kit_definition_id)
        REFERENCES kit_definitions(id) ON DELETE SET NULL,
    CONSTRAINT fk_campaigns_survey FOREIGN KEY (survey_version_id)
        REFERENCES survey_versions(id) ON DELETE SET NULL,
    CONSTRAINT fk_campaigns_publisher FOREIGN KEY (published_by_user_id)
        REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_campaigns_status CHECK (status IN ('DRAFT', 'SCHEDULED', 'PUBLISHED', 'COMPLETED', 'CANCELLED', 'ARCHIVED')),
    CONSTRAINT chk_campaigns_verification CHECK (verification_mode IN ('STRICT', 'FAST')),
    CONSTRAINT chk_campaigns_dates CHECK (end_date >= start_date)
);

COMMENT ON TABLE campaigns IS 'Marketing campaigns with execution timeline and store selection';
COMMENT ON COLUMN campaigns.status IS 'Campaign lifecycle status: DRAFT, SCHEDULED, PUBLISHED, COMPLETED, CANCELLED, ARCHIVED';
COMMENT ON COLUMN campaigns.verification_mode IS 'Photo review mode: STRICT (all reviewed) or FAST (auto-approve unless flagged)';
COMMENT ON COLUMN campaigns.psp_campaign_ref IS 'Reference to PSP MIS system campaign ID';
COMMENT ON COLUMN campaigns.selection_recipe_json IS 'Store selection criteria (regions, groups, includes, excludes)';
COMMENT ON COLUMN campaigns.published_at IS 'When campaign was published and assignments generated';

-- ===========================================================================
-- SECTION 5: STORE ASSIGNMENTS & TASKS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: store_assignments
-- Purpose: Campaign-to-store assignment with pinned versions
-- ---------------------------------------------------------------------------
CREATE TABLE store_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campaign_id UUID NOT NULL,
    store_id UUID NOT NULL,
    status TEXT NOT NULL DEFAULT 'ASSIGNED',
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    layout_version_id UUID,
    survey_version_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_store_assignments_campaign FOREIGN KEY (campaign_id)
        REFERENCES campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_store_assignments_store FOREIGN KEY (store_id)
        REFERENCES stores(id) ON DELETE CASCADE,
    CONSTRAINT fk_store_assignments_layout FOREIGN KEY (layout_version_id)
        REFERENCES store_layouts(id) ON DELETE SET NULL,
    CONSTRAINT fk_store_assignments_survey FOREIGN KEY (survey_version_id)
        REFERENCES survey_versions(id) ON DELETE SET NULL,
    CONSTRAINT uq_store_assignments UNIQUE (campaign_id, store_id),
    CONSTRAINT chk_store_assignments_status CHECK (status IN ('ASSIGNED', 'READY', 'IN_PROGRESS', 'SUBMITTED', 'REWORK_REQUIRED', 'COMPLETE', 'REOPENED', 'WAIVED'))
);

COMMENT ON TABLE store_assignments IS 'Campaign assignment to stores with pinned layout and survey versions';
COMMENT ON COLUMN store_assignments.status IS 'Assignment status: ASSIGNED, READY, IN_PROGRESS, SUBMITTED, REWORK_REQUIRED, COMPLETE, REOPENED, WAIVED';
COMMENT ON COLUMN store_assignments.layout_version_id IS 'Pinned store layout version for this assignment';
COMMENT ON COLUMN store_assignments.survey_version_id IS 'Pinned survey version for this assignment';

-- ---------------------------------------------------------------------------
-- TABLE: assignment_items
-- Purpose: Individual kit items assigned to stores with slot mapping
-- ---------------------------------------------------------------------------
CREATE TABLE assignment_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_assignment_id UUID NOT NULL,
    kit_item_id UUID NOT NULL,
    location_slot_id UUID,
    quantity INT NOT NULL DEFAULT 1,
    status TEXT NOT NULL DEFAULT 'PLANNED',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_assignment_items_assignment FOREIGN KEY (store_assignment_id)
        REFERENCES store_assignments(id) ON DELETE CASCADE,
    CONSTRAINT fk_assignment_items_kit_item FOREIGN KEY (kit_item_id)
        REFERENCES kit_items(id) ON DELETE RESTRICT,
    CONSTRAINT fk_assignment_items_slot FOREIGN KEY (location_slot_id)
        REFERENCES location_slots(id) ON DELETE SET NULL,
    CONSTRAINT chk_assignment_items_status CHECK (status IN ('PLANNED', 'ORDERED', 'SHIPPED', 'DELIVERED', 'RECEIVED', 'INSTALLED', 'PROOF_SUBMITTED', 'RETAKE_REQUIRED', 'SATISFIED', 'EXCEPTION'))
);

COMMENT ON TABLE assignment_items IS 'Individual kit items assigned to stores with location mapping';
COMMENT ON COLUMN assignment_items.status IS 'Item lifecycle: PLANNED, ORDERED, SHIPPED, DELIVERED, RECEIVED, INSTALLED, PROOF_SUBMITTED, RETAKE_REQUIRED, SATISFIED, EXCEPTION';

-- ===========================================================================
-- SECTION 6: FULFILLMENT (ORDERS & SHIPMENTS)
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: store_orders
-- Purpose: Orders generated for store assignments
-- ---------------------------------------------------------------------------
CREATE TABLE store_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campaign_id UUID NOT NULL,
    store_id UUID NOT NULL,
    store_assignment_id UUID NOT NULL,
    order_number TEXT NOT NULL UNIQUE,
    order_type TEXT NOT NULL DEFAULT 'INITIAL',
    psp_order_ref TEXT,
    status TEXT NOT NULL DEFAULT 'GENERATED',
    acknowledged_at TIMESTAMPTZ,
    shipping_address_snapshot JSONB,
    batch_label TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_store_orders_campaign FOREIGN KEY (campaign_id)
        REFERENCES campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_store_orders_store FOREIGN KEY (store_id)
        REFERENCES stores(id) ON DELETE CASCADE,
    CONSTRAINT fk_store_orders_assignment FOREIGN KEY (store_assignment_id)
        REFERENCES store_assignments(id) ON DELETE CASCADE,
    CONSTRAINT chk_store_orders_type CHECK (order_type IN ('INITIAL', 'REORDER')),
    CONSTRAINT chk_store_orders_status CHECK (status IN ('GENERATED', 'ACKNOWLEDGED', 'IN_PRODUCTION', 'KITTING', 'READY_TO_SHIP', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED', 'CANCELLED'))
);

COMMENT ON TABLE store_orders IS 'Orders generated for campaign store assignments';
COMMENT ON COLUMN store_orders.order_number IS 'Unique order identifier (e.g., ORD-1001)';
COMMENT ON COLUMN store_orders.order_type IS 'Order type: INITIAL or REORDER';
COMMENT ON COLUMN store_orders.psp_order_ref IS 'PSP MIS system order reference';
COMMENT ON COLUMN store_orders.shipping_address_snapshot IS 'Frozen shipping address at order generation time';
COMMENT ON COLUMN store_orders.batch_label IS 'Optional PSP batch identifier';

-- ---------------------------------------------------------------------------
-- TABLE: order_lines
-- Purpose: Line items within store orders
-- ---------------------------------------------------------------------------
CREATE TABLE order_lines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_order_id UUID NOT NULL,
    kit_item_id UUID NOT NULL,
    quantity INT NOT NULL,
    sku TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_order_lines_order FOREIGN KEY (store_order_id)
        REFERENCES store_orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_lines_kit_item FOREIGN KEY (kit_item_id)
        REFERENCES kit_items(id) ON DELETE RESTRICT,
    CONSTRAINT chk_order_lines_quantity CHECK (quantity > 0)
);

COMMENT ON TABLE order_lines IS 'Line items within store orders';
COMMENT ON COLUMN order_lines.sku IS 'Denormalized SKU for performance';

-- ---------------------------------------------------------------------------
-- TABLE: shipments
-- Purpose: Shipment tracking for store orders
-- ---------------------------------------------------------------------------
CREATE TABLE shipments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_order_id UUID NOT NULL,
    carrier TEXT,
    tracking_numbers JSONB DEFAULT '[]',
    shipped_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    status TEXT NOT NULL DEFAULT 'LABEL_CREATED',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_shipments_order FOREIGN KEY (store_order_id)
        REFERENCES store_orders(id) ON DELETE CASCADE,
    CONSTRAINT chk_shipments_status CHECK (status IN ('LABEL_CREATED', 'IN_TRANSIT', 'DELIVERED', 'EXCEPTION', 'RETURNED'))
);

COMMENT ON TABLE shipments IS 'Shipment tracking information for orders';
COMMENT ON COLUMN shipments.tracking_numbers IS 'Array of tracking numbers for this shipment';
COMMENT ON COLUMN shipments.status IS 'Shipment status: LABEL_CREATED, IN_TRANSIT, DELIVERED, EXCEPTION, RETURNED';

-- ---------------------------------------------------------------------------
-- TABLE: shipment_lines
-- Purpose: Items included in shipments
-- ---------------------------------------------------------------------------
CREATE TABLE shipment_lines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    shipment_id UUID NOT NULL,
    kit_item_id UUID NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_shipment_lines_shipment FOREIGN KEY (shipment_id)
        REFERENCES shipments(id) ON DELETE CASCADE,
    CONSTRAINT fk_shipment_lines_kit_item FOREIGN KEY (kit_item_id)
        REFERENCES kit_items(id) ON DELETE RESTRICT,
    CONSTRAINT chk_shipment_lines_quantity CHECK (quantity > 0)
);

COMMENT ON TABLE shipment_lines IS 'Items included in each shipment';

-- ===========================================================================
-- SECTION 7: EXECUTION & VERIFICATION
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: receive_verifications
-- Purpose: Store confirmation of receipt
-- ---------------------------------------------------------------------------
CREATE TABLE receive_verifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_assignment_id UUID NOT NULL,
    verified_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    verified_by_user_id UUID,
    all_items_received BOOLEAN NOT NULL DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_receive_verifications_assignment FOREIGN KEY (store_assignment_id)
        REFERENCES store_assignments(id) ON DELETE CASCADE,
    CONSTRAINT fk_receive_verifications_user FOREIGN KEY (verified_by_user_id)
        REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE receive_verifications IS 'Store confirmation that items were received';
COMMENT ON COLUMN receive_verifications.all_items_received IS 'Whether all ordered items were received';

-- ---------------------------------------------------------------------------
-- TABLE: store_survey_responses
-- Purpose: Store responses to surveys
-- ---------------------------------------------------------------------------
CREATE TABLE store_survey_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_assignment_id UUID NOT NULL,
    survey_version_id UUID NOT NULL,
    response_json JSONB NOT NULL,
    submitted_at TIMESTAMPTZ,
    submitted_by_user_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_store_survey_responses_assignment FOREIGN KEY (store_assignment_id)
        REFERENCES store_assignments(id) ON DELETE CASCADE,
    CONSTRAINT fk_store_survey_responses_version FOREIGN KEY (survey_version_id)
        REFERENCES survey_versions(id) ON DELETE RESTRICT,
    CONSTRAINT fk_store_survey_responses_user FOREIGN KEY (submitted_by_user_id)
        REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE store_survey_responses IS 'Store responses to assigned surveys';
COMMENT ON COLUMN store_survey_responses.response_json IS 'Complete survey answers in JSON format';

-- ---------------------------------------------------------------------------
-- TABLE: photo_uploads
-- Purpose: Photos uploaded for verification
-- ---------------------------------------------------------------------------
CREATE TABLE photo_uploads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_assignment_id UUID NOT NULL,
    assignment_item_id UUID,
    location_slot_id UUID,
    s3_key TEXT NOT NULL,
    s3_url TEXT,
    file_size_bytes INT,
    mime_type TEXT,
    review_status TEXT NOT NULL DEFAULT 'PENDING',
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    uploaded_by_user_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_photo_uploads_assignment FOREIGN KEY (store_assignment_id)
        REFERENCES store_assignments(id) ON DELETE CASCADE,
    CONSTRAINT fk_photo_uploads_item FOREIGN KEY (assignment_item_id)
        REFERENCES assignment_items(id) ON DELETE CASCADE,
    CONSTRAINT fk_photo_uploads_slot FOREIGN KEY (location_slot_id)
        REFERENCES location_slots(id) ON DELETE SET NULL,
    CONSTRAINT fk_photo_uploads_user FOREIGN KEY (uploaded_by_user_id)
        REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_photo_uploads_status CHECK (review_status IN ('PENDING', 'APPROVED', 'REJECTED', 'SUPERSEDED'))
);

COMMENT ON TABLE photo_uploads IS 'Photos uploaded for installation verification';
COMMENT ON COLUMN photo_uploads.s3_key IS 'Storage path in S3';
COMMENT ON COLUMN photo_uploads.s3_url IS 'Cached presigned URL for access';
COMMENT ON COLUMN photo_uploads.review_status IS 'Review status: PENDING, APPROVED, REJECTED, SUPERSEDED';

-- ---------------------------------------------------------------------------
-- TABLE: photo_reviews
-- Purpose: Review records for uploaded photos
-- ---------------------------------------------------------------------------
CREATE TABLE photo_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    photo_upload_id UUID NOT NULL,
    reviewer_user_id UUID NOT NULL,
    status TEXT NOT NULL,
    rejection_reason TEXT,
    rejection_comment TEXT,
    reviewed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_photo_reviews_photo FOREIGN KEY (photo_upload_id)
        REFERENCES photo_uploads(id) ON DELETE CASCADE,
    CONSTRAINT fk_photo_reviews_reviewer FOREIGN KEY (reviewer_user_id)
        REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_photo_reviews_status CHECK (status IN ('APPROVED', 'REJECTED')),
    CONSTRAINT chk_photo_reviews_reason CHECK (rejection_reason IS NULL OR rejection_reason IN ('BLURRY', 'WRONG_ANGLE', 'WRONG_PLACEMENT', 'DAMAGED', 'INSUFFICIENT_LIGHTING', 'OBSTRUCTION', 'OTHER'))
);

COMMENT ON TABLE photo_reviews IS 'Review records for photo verification';
COMMENT ON COLUMN photo_reviews.rejection_reason IS 'Reason code if rejected: BLURRY, WRONG_ANGLE, WRONG_PLACEMENT, DAMAGED, INSUFFICIENT_LIGHTING, OBSTRUCTION, OTHER';

-- ---------------------------------------------------------------------------
-- TABLE: retake_requests
-- Purpose: Requests for photo retakes
-- ---------------------------------------------------------------------------
CREATE TABLE retake_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    photo_upload_id UUID NOT NULL,
    store_assignment_id UUID NOT NULL,
    reason TEXT NOT NULL,
    comment TEXT,
    requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    new_photo_upload_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_retake_requests_photo FOREIGN KEY (photo_upload_id)
        REFERENCES photo_uploads(id) ON DELETE CASCADE,
    CONSTRAINT fk_retake_requests_assignment FOREIGN KEY (store_assignment_id)
        REFERENCES store_assignments(id) ON DELETE CASCADE,
    CONSTRAINT fk_retake_requests_new_photo FOREIGN KEY (new_photo_upload_id)
        REFERENCES photo_uploads(id) ON DELETE SET NULL,
    CONSTRAINT chk_retake_requests_reason CHECK (reason IN ('BLURRY', 'WRONG_ANGLE', 'WRONG_PLACEMENT', 'DAMAGED', 'INSUFFICIENT_LIGHTING', 'OBSTRUCTION', 'OTHER'))
);

COMMENT ON TABLE retake_requests IS 'Requests for photo retakes after rejection';
COMMENT ON COLUMN retake_requests.new_photo_upload_id IS 'Reference to replacement photo when retake is completed';

-- ===========================================================================
-- SECTION 8: ISSUES & REORDERS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: issue_requests
-- Purpose: Store-reported issues with shipments or items
-- ---------------------------------------------------------------------------
CREATE TABLE issue_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_assignment_id UUID NOT NULL,
    type TEXT NOT NULL,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'OPEN',
    evidence_photo_id UUID,
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    submitted_by_user_id UUID,
    reviewed_at TIMESTAMPTZ,
    reviewed_by_user_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_issue_requests_assignment FOREIGN KEY (store_assignment_id)
        REFERENCES store_assignments(id) ON DELETE CASCADE,
    CONSTRAINT fk_issue_requests_photo FOREIGN KEY (evidence_photo_id)
        REFERENCES photo_uploads(id) ON DELETE SET NULL,
    CONSTRAINT fk_issue_requests_submitter FOREIGN KEY (submitted_by_user_id)
        REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_issue_requests_reviewer FOREIGN KEY (reviewed_by_user_id)
        REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_issue_requests_type CHECK (type IN ('MISSING', 'DAMAGED', 'INCORRECT', 'PACKAGING')),
    CONSTRAINT chk_issue_requests_status CHECK (status IN ('OPEN', 'TRIAGED', 'AWAITING_APPROVAL', 'APPROVED', 'IN_FULFILLMENT', 'DENIED', 'RESOLVED'))
);

COMMENT ON TABLE issue_requests IS 'Store-reported issues with shipments or items';
COMMENT ON COLUMN issue_requests.type IS 'Issue type: MISSING, DAMAGED, INCORRECT, PACKAGING';
COMMENT ON COLUMN issue_requests.status IS 'Issue status: OPEN, TRIAGED, AWAITING_APPROVAL, APPROVED, IN_FULFILLMENT, DENIED, RESOLVED';

-- ---------------------------------------------------------------------------
-- TABLE: issue_lines
-- Purpose: Specific items affected by an issue
-- ---------------------------------------------------------------------------
CREATE TABLE issue_lines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    issue_request_id UUID NOT NULL,
    kit_item_id UUID NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_issue_lines_issue FOREIGN KEY (issue_request_id)
        REFERENCES issue_requests(id) ON DELETE CASCADE,
    CONSTRAINT fk_issue_lines_kit_item FOREIGN KEY (kit_item_id)
        REFERENCES kit_items(id) ON DELETE RESTRICT,
    CONSTRAINT chk_issue_lines_quantity CHECK (quantity > 0)
);

COMMENT ON TABLE issue_lines IS 'Specific items affected by an issue request';

-- ---------------------------------------------------------------------------
-- TABLE: reorders
-- Purpose: Reorders generated from approved issues
-- ---------------------------------------------------------------------------
CREATE TABLE reorders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    issue_request_id UUID NOT NULL,
    store_order_id UUID NOT NULL,
    status TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_reorders_issue FOREIGN KEY (issue_request_id)
        REFERENCES issue_requests(id) ON DELETE CASCADE,
    CONSTRAINT fk_reorders_order FOREIGN KEY (store_order_id)
        REFERENCES store_orders(id) ON DELETE CASCADE
);

COMMENT ON TABLE reorders IS 'Reorders generated from approved issue requests';

-- ===========================================================================
-- SECTION 9: NOTIFICATIONS & PREFERENCES
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: notification_preferences
-- Purpose: User notification channel preferences
-- ---------------------------------------------------------------------------
CREATE TABLE notification_preferences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    channel TEXT NOT NULL,
    event_type TEXT NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_notification_preferences_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uq_notification_preferences UNIQUE (user_id, channel, event_type),
    CONSTRAINT chk_notification_preferences_channel CHECK (channel IN ('EMAIL', 'IN_APP', 'PUSH'))
);

COMMENT ON TABLE notification_preferences IS 'User preferences for notification delivery';
COMMENT ON COLUMN notification_preferences.channel IS 'Delivery channel: EMAIL, IN_APP, PUSH';

-- ---------------------------------------------------------------------------
-- TABLE: notifications
-- Purpose: Notification delivery log
-- ---------------------------------------------------------------------------
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    channel TEXT NOT NULL,
    event_type TEXT NOT NULL,
    subject TEXT,
    body TEXT,
    action_url TEXT,
    read_at TIMESTAMPTZ,
    sent_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_notifications_channel CHECK (channel IN ('EMAIL', 'IN_APP', 'PUSH'))
);

COMMENT ON TABLE notifications IS 'Notification delivery log and in-app inbox';
COMMENT ON COLUMN notifications.action_url IS 'Deep link for notification action';
COMMENT ON COLUMN notifications.read_at IS 'When notification was read (for IN_APP)';

-- ===========================================================================
-- SECTION 10: WEBHOOKS & INTEGRATION
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: webhook_endpoints
-- Purpose: External webhook endpoint registration
-- ---------------------------------------------------------------------------
CREATE TABLE webhook_endpoints (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL,
    url TEXT NOT NULL,
    secret TEXT NOT NULL,
    events TEXT[] NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_success_at TIMESTAMPTZ,
    last_failure_at TIMESTAMPTZ,
    failure_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_webhook_endpoints_tenant FOREIGN KEY (tenant_id)
        REFERENCES tenants(id) ON DELETE CASCADE
);

COMMENT ON TABLE webhook_endpoints IS 'External webhook endpoint configuration';
COMMENT ON COLUMN webhook_endpoints.secret IS 'HMAC signing key for webhook verification';
COMMENT ON COLUMN webhook_endpoints.events IS 'Array of subscribed event types';

-- ---------------------------------------------------------------------------
-- TABLE: webhook_deliveries
-- Purpose: Webhook delivery attempts and status
-- ---------------------------------------------------------------------------
CREATE TABLE webhook_deliveries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    webhook_endpoint_id UUID NOT NULL,
    event_type TEXT NOT NULL,
    payload_json JSONB NOT NULL,
    status_code INT,
    response_body TEXT,
    attempt_count INT NOT NULL DEFAULT 1,
    next_retry_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_webhook_deliveries_endpoint FOREIGN KEY (webhook_endpoint_id)
        REFERENCES webhook_endpoints(id) ON DELETE CASCADE
);

COMMENT ON TABLE webhook_deliveries IS 'Webhook delivery attempts and retry tracking';
COMMENT ON COLUMN webhook_deliveries.payload_json IS 'Event payload sent to webhook';

-- ===========================================================================
-- SECTION 11: EXPORTS & JOBS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: export_jobs
-- Purpose: Data export job tracking
-- ---------------------------------------------------------------------------
CREATE TABLE export_jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID,
    campaign_id UUID,
    requested_by_user_id UUID NOT NULL,
    export_type TEXT NOT NULL,
    format TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'PENDING',
    parameters_json JSONB,
    s3_key TEXT,
    file_size_bytes INT,
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    error_message TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_export_jobs_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE,
    CONSTRAINT fk_export_jobs_campaign FOREIGN KEY (campaign_id)
        REFERENCES campaigns(id) ON DELETE CASCADE,
    CONSTRAINT fk_export_jobs_user FOREIGN KEY (requested_by_user_id)
        REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_export_jobs_format CHECK (format IN ('CSV', 'XLSX', 'PDF', 'JSON', 'XML')),
    CONSTRAINT chk_export_jobs_status CHECK (status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'EXPIRED'))
);

COMMENT ON TABLE export_jobs IS 'Data export job tracking and file generation';
COMMENT ON COLUMN export_jobs.export_type IS 'Type of export (e.g., campaign_summary, store_report)';
COMMENT ON COLUMN export_jobs.parameters_json IS 'Export filters and options';

-- ===========================================================================
-- SECTION 12: AUDIT & OBSERVABILITY
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: audit_events
-- Purpose: Comprehensive audit trail for all system changes
-- ---------------------------------------------------------------------------
CREATE TABLE audit_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL,
    brand_id UUID,
    actor_type TEXT NOT NULL,
    actor_user_id UUID,
    actor_api_key_id UUID,
    action TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    entity_id UUID NOT NULL,
    before_json JSONB,
    after_json JSONB,
    metadata_json JSONB,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_audit_events_tenant FOREIGN KEY (tenant_id)
        REFERENCES tenants(id) ON DELETE CASCADE,
    CONSTRAINT fk_audit_events_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE,
    CONSTRAINT fk_audit_events_user FOREIGN KEY (actor_user_id)
        REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_audit_events_api_key FOREIGN KEY (actor_api_key_id)
        REFERENCES api_keys(id) ON DELETE SET NULL,
    CONSTRAINT chk_audit_events_actor_type CHECK (actor_type IN ('HUMAN', 'SYSTEM', 'INTEGRATION'))
);

COMMENT ON TABLE audit_events IS 'Comprehensive audit trail for all system changes';
COMMENT ON COLUMN audit_events.actor_type IS 'Type of actor: HUMAN, SYSTEM, INTEGRATION';
COMMENT ON COLUMN audit_events.before_json IS 'Entity state before change';
COMMENT ON COLUMN audit_events.after_json IS 'Entity state after change';

-- ===========================================================================
-- INDEXES
-- ===========================================================================

-- Geographic hierarchy and stores
CREATE INDEX idx_regions_brand ON regions(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_districts_brand_region ON districts(brand_id, region_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_territories_brand_region ON territories(brand_id, region_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_stores_brand_region ON stores(brand_id, region_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_stores_brand_number ON stores(brand_id, store_number) WHERE deleted_at IS NULL;
CREATE INDEX idx_stores_status ON stores(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_stores_external_guid ON stores(external_store_guid) WHERE deleted_at IS NULL;

-- Store groups
CREATE INDEX idx_store_groups_brand ON store_groups(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_group_memberships_store ON store_group_memberships(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_group_memberships_group ON store_group_memberships(store_group_id) WHERE deleted_at IS NULL;

-- Layouts and slots
CREATE INDEX idx_store_layouts_store ON store_layouts(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_layouts_current ON store_layouts(store_id, is_current) WHERE deleted_at IS NULL AND is_current = TRUE;
CREATE INDEX idx_location_slots_layout ON location_slots(store_layout_id) WHERE deleted_at IS NULL;

-- Surveys
CREATE INDEX idx_survey_templates_brand ON survey_templates(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_survey_versions_template ON survey_versions(survey_template_id) WHERE deleted_at IS NULL;

-- Photo rules
CREATE INDEX idx_photo_rules_brand ON photo_rules(brand_id) WHERE deleted_at IS NULL;

-- Campaigns and kits
CREATE INDEX idx_campaigns_brand_status ON campaigns(brand_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_campaigns_dates ON campaigns(start_date, end_date) WHERE deleted_at IS NULL;
CREATE INDEX idx_kit_definitions_brand ON kit_definitions(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_kit_items_kit ON kit_items(kit_definition_id) WHERE deleted_at IS NULL;

-- Assignments
CREATE INDEX idx_store_assignments_campaign ON store_assignments(campaign_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_assignments_store ON store_assignments(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_assignments_status ON store_assignments(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_assignment_items_assignment ON assignment_items(store_assignment_id) WHERE deleted_at IS NULL;

-- Orders and shipments
CREATE INDEX idx_store_orders_campaign ON store_orders(campaign_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_store ON store_orders(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_status ON store_orders(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_number ON store_orders(order_number) WHERE deleted_at IS NULL;
CREATE INDEX idx_order_lines_order ON order_lines(store_order_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_shipments_order ON shipments(store_order_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_shipment_lines_shipment ON shipment_lines(shipment_id) WHERE deleted_at IS NULL;

-- Execution and verification
CREATE INDEX idx_receive_verifications_assignment ON receive_verifications(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_survey_responses_assignment ON store_survey_responses(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_assignment ON photo_uploads(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_review_status ON photo_uploads(review_status) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_reviews_photo ON photo_reviews(photo_upload_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_retake_requests_assignment ON retake_requests(store_assignment_id) WHERE deleted_at IS NULL;

-- Issues
CREATE INDEX idx_issue_requests_assignment ON issue_requests(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_issue_requests_status ON issue_requests(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_issue_lines_issue ON issue_lines(issue_request_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_reorders_issue ON reorders(issue_request_id) WHERE deleted_at IS NULL;

-- Notifications
CREATE INDEX idx_notification_preferences_user ON notification_preferences(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_notifications_user ON notifications(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_notifications_unread ON notifications(user_id, read_at) WHERE deleted_at IS NULL AND read_at IS NULL;

-- Webhooks
CREATE INDEX idx_webhook_endpoints_tenant ON webhook_endpoints(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_webhook_deliveries_endpoint ON webhook_deliveries(webhook_endpoint_id) WHERE deleted_at IS NULL;

-- Exports
CREATE INDEX idx_export_jobs_brand ON export_jobs(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_export_jobs_campaign ON export_jobs(campaign_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_export_jobs_status ON export_jobs(status) WHERE deleted_at IS NULL;

-- Audit
CREATE INDEX idx_audit_events_tenant_time ON audit_events(tenant_id, created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_audit_events_entity ON audit_events(entity_type, entity_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_audit_events_actor ON audit_events(actor_user_id) WHERE deleted_at IS NULL;

-- ===========================================================================
-- TRIGGERS FOR UPDATED_AT
-- ===========================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to all tables
CREATE TRIGGER update_regions_updated_at BEFORE UPDATE ON regions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_districts_updated_at BEFORE UPDATE ON districts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_territories_updated_at BEFORE UPDATE ON territories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_stores_updated_at BEFORE UPDATE ON stores
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_store_groups_updated_at BEFORE UPDATE ON store_groups
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_store_group_memberships_updated_at BEFORE UPDATE ON store_group_memberships
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_store_layouts_updated_at BEFORE UPDATE ON store_layouts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_location_slots_updated_at BEFORE UPDATE ON location_slots
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_survey_templates_updated_at BEFORE UPDATE ON survey_templates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_survey_versions_updated_at BEFORE UPDATE ON survey_versions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_photo_rules_updated_at BEFORE UPDATE ON photo_rules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_kit_definitions_updated_at BEFORE UPDATE ON kit_definitions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_kit_items_updated_at BEFORE UPDATE ON kit_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_campaigns_updated_at BEFORE UPDATE ON campaigns
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_store_assignments_updated_at BEFORE UPDATE ON store_assignments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_assignment_items_updated_at BEFORE UPDATE ON assignment_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_store_orders_updated_at BEFORE UPDATE ON store_orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_order_lines_updated_at BEFORE UPDATE ON order_lines
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_shipments_updated_at BEFORE UPDATE ON shipments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_shipment_lines_updated_at BEFORE UPDATE ON shipment_lines
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_receive_verifications_updated_at BEFORE UPDATE ON receive_verifications
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_store_survey_responses_updated_at BEFORE UPDATE ON store_survey_responses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_photo_uploads_updated_at BEFORE UPDATE ON photo_uploads
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_photo_reviews_updated_at BEFORE UPDATE ON photo_reviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_retake_requests_updated_at BEFORE UPDATE ON retake_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_issue_requests_updated_at BEFORE UPDATE ON issue_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_issue_lines_updated_at BEFORE UPDATE ON issue_lines
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reorders_updated_at BEFORE UPDATE ON reorders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notification_preferences_updated_at BEFORE UPDATE ON notification_preferences
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON notifications
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_webhook_endpoints_updated_at BEFORE UPDATE ON webhook_endpoints
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_webhook_deliveries_updated_at BEFORE UPDATE ON webhook_deliveries
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_export_jobs_updated_at BEFORE UPDATE ON export_jobs
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_audit_events_updated_at BEFORE UPDATE ON audit_events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ===========================================================================
-- END OF SCHEMA
-- ===========================================================================
