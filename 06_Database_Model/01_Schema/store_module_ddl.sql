-- ==============================================================================
-- PopSystem Store Execution Module - PostgreSQL DDL
-- ==============================================================================
-- Version: 1.0
-- Date: 2025-12-19
-- Dependencies: SUPP-035 (Data Model), SUPP-017 (Proof Capture),
--               SUPP-011 (Offline Sync), SUPP-036 (Screens)
-- ==============================================================================

-- ==============================================================================
-- EXTENSIONS
-- ==============================================================================

-- UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- JSON operations (if not already available)
CREATE EXTENSION IF NOT EXISTS "btree_gin";

-- ==============================================================================
-- TYPE DEFINITIONS (ENUMS)
-- ==============================================================================

-- Role-based access control
CREATE TYPE role_enum AS ENUM (
  'PSP_ADMIN',           -- Full PSP tenant access
  'PSP_OPS',             -- PSP operations (orders, shipments)
  'BRAND_ADMIN',         -- Full brand access
  'REGIONAL_ADMIN',      -- Regional scope
  'STORE_USER'           -- Store execution only
);

-- Store operational status
CREATE TYPE store_status_enum AS ENUM (
  'ACTIVE',
  'INACTIVE',
  'TEMP_CLOSED',
  'CLOSED'
);

-- Campaign lifecycle status
CREATE TYPE campaign_status_enum AS ENUM (
  'DRAFT',               -- Being created/edited
  'SCHEDULED',           -- Finalized, future start date
  'PUBLISHED',           -- Live, stores can execute (alias: ACTIVE)
  'COMPLETED',           -- End date passed
  'CANCELLED',           -- Terminated early
  'ARCHIVED'             -- Historical reference only
);

-- Photo verification strictness
CREATE TYPE verification_mode_enum AS ENUM (
  'STRICT',              -- Every photo requires review
  'FAST'                 -- Auto-approve unless flagged
);

-- Store assignment lifecycle
CREATE TYPE store_assignment_status_enum AS ENUM (
  'ASSIGNED',            -- Store targeted; waiting on readiness
  'READY',               -- Store can execute
  'IN_PROGRESS',         -- Store actively working
  'SUBMITTED',           -- Awaiting review
  'REWORK_REQUIRED',     -- Retake requested
  'COMPLETE',            -- Counts toward campaign completion
  'REOPENED',            -- Admin reopened after complete
  'WAIVED'               -- Complete by exception/waiver
);

-- Store order fulfillment status
CREATE TYPE store_order_status_enum AS ENUM (
  'GENERATED',
  'ACKNOWLEDGED',
  'IN_PRODUCTION',
  'KITTING',
  'READY_TO_SHIP',
  'PARTIALLY_SHIPPED',
  'SHIPPED',
  'DELIVERED',
  'CLOSED',
  'CANCELLED'
);

-- Order type classification
CREATE TYPE order_type_enum AS ENUM (
  'INITIAL',
  'REORDER'
);

-- Shipment tracking status
CREATE TYPE shipment_status_enum AS ENUM (
  'LABEL_CREATED',
  'IN_TRANSIT',
  'DELIVERED',
  'EXCEPTION',
  'RETURNED'
);

-- Photo review outcomes
CREATE TYPE photo_review_status_enum AS ENUM (
  'PENDING',
  'APPROVED',
  'REJECTED',
  'SUPERSEDED'
);

-- Issue categories
CREATE TYPE issue_type_enum AS ENUM (
  'MISSING',
  'DAMAGED',
  'INCORRECT',
  'PACKAGING'
);

-- Issue request workflow status
CREATE TYPE issue_request_status_enum AS ENUM (
  'OPEN',                -- Reported by store
  'TRIAGED',             -- Classified + routed
  'AWAITING_APPROVAL',   -- Brand approval required
  'APPROVED',            -- Allowed to fulfill fix
  'IN_FULFILLMENT',      -- PSP producing/shipping replacement
  'DENIED',              -- No action (terminal)
  'RESOLVED'             -- Fixed (terminal)
);

-- Photo rejection reasons
CREATE TYPE rejection_reason_enum AS ENUM (
  'BLURRY',
  'WRONG_ANGLE',
  'WRONG_PLACEMENT',
  'DAMAGED',
  'INSUFFICIENT_LIGHTING',
  'OBSTRUCTION',
  'OTHER'
);

-- Audit trail actor types
CREATE TYPE audit_actor_type_enum AS ENUM (
  'HUMAN',
  'SYSTEM',
  'INTEGRATION'
);

-- Notification delivery channels
CREATE TYPE notification_channel_enum AS ENUM (
  'EMAIL',
  'IN_APP',
  'PUSH'                 -- Future
);

-- Export file formats
CREATE TYPE export_format_enum AS ENUM (
  'CSV',
  'XLSX',
  'PDF',
  'JSON',
  'XML'
);

-- Export job processing status
CREATE TYPE export_job_status_enum AS ENUM (
  'PENDING',
  'PROCESSING',
  'COMPLETED',
  'FAILED',
  'EXPIRED'
);

-- Assignment item fulfillment tracking
CREATE TYPE assignment_item_status_enum AS ENUM (
  'PLANNED',             -- Requirement exists from publish
  'ORDERED',             -- Ordered for this store
  'SHIPPED',             -- In transit
  'DELIVERED',           -- Delivered to store
  'RECEIVED',            -- Store confirmed receipt
  'INSTALLED',           -- Installed at slot
  'PROOF_SUBMITTED',     -- Proof submitted for review
  'RETAKE_REQUIRED',     -- Retake needed
  'SATISFIED',           -- Meets rules (terminal)
  'EXCEPTION'            -- Waived/alternate (terminal)
);

-- Slot verification completeness
CREATE TYPE slot_verification_status_enum AS ENUM (
  'PENDING',             -- Waiting on required proofs
  'SATISFIED',           -- Meets all rules (terminal)
  'REWORK',              -- Needs retake
  'WAIVED'               -- Accepted by exception (terminal)
);

-- ==============================================================================
-- DOMAIN FUNCTIONS
-- ==============================================================================

-- Update timestamp trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==============================================================================
-- CORE TENANCY & IDENTITY TABLES
-- ==============================================================================

-- Tenants (PSP Organizations)
CREATE TABLE tenants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  subscription_tier TEXT NOT NULL CHECK (subscription_tier IN ('PILOT', 'STANDARD', 'ENTERPRISE')),
  settings_json JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE tenants IS 'PSP organizations (Print Service Providers)';
COMMENT ON COLUMN tenants.slug IS 'URL-safe identifier for tenant';
COMMENT ON COLUMN tenants.subscription_tier IS 'Subscription level: PILOT, STANDARD, or ENTERPRISE';
COMMENT ON COLUMN tenants.settings_json IS 'Tenant-level configuration and feature flags';

CREATE TRIGGER tenants_updated_at BEFORE UPDATE ON tenants
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Brands (Retailer Brands)
CREATE TABLE brands (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  code TEXT,
  logo_url TEXT,
  settings_json JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT brands_code_unique_per_tenant UNIQUE (tenant_id, code)
);

COMMENT ON TABLE brands IS 'Retailer brands managed by PSPs';
COMMENT ON COLUMN brands.code IS 'Short brand code (e.g., G2G)';
COMMENT ON COLUMN brands.settings_json IS 'Brand-level configuration';

CREATE TRIGGER brands_updated_at BEFORE UPDATE ON brands
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  full_name TEXT NOT NULL,
  is_global_admin BOOLEAN DEFAULT FALSE,
  last_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE users IS 'Platform users across all tenants and brands';
COMMENT ON COLUMN users.email IS 'Unique login identifier';
COMMENT ON COLUMN users.password_hash IS 'bcrypt hashed password';
COMMENT ON COLUMN users.is_global_admin IS 'Platform administrator (v1 = false)';

CREATE TRIGGER users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Memberships (User-Tenant-Brand relationships)
CREATE TABLE memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  brand_id UUID REFERENCES brands(id) ON DELETE CASCADE,
  role role_enum NOT NULL,
  region_scope_id UUID,  -- FK added after regions table
  store_scope_id UUID,   -- FK added after stores table
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE memberships IS 'User access control and role assignments';
COMMENT ON COLUMN memberships.brand_id IS 'NULL for PSP staff roles';
COMMENT ON COLUMN memberships.role IS 'User role: PSP_ADMIN, PSP_OPS, BRAND_ADMIN, REGIONAL_ADMIN, STORE_USER';
COMMENT ON COLUMN memberships.region_scope_id IS 'Scope restriction for REGIONAL_ADMIN role';
COMMENT ON COLUMN memberships.store_scope_id IS 'Scope restriction for STORE_USER role';

CREATE TRIGGER memberships_updated_at BEFORE UPDATE ON memberships
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- API Keys
CREATE TABLE api_keys (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  key_hash TEXT NOT NULL,
  key_prefix TEXT NOT NULL,
  name TEXT NOT NULL,
  scopes TEXT[] DEFAULT '{}',
  expires_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE api_keys IS 'API authentication keys for integrations';
COMMENT ON COLUMN api_keys.key_hash IS 'SHA256 hash of the API key';
COMMENT ON COLUMN api_keys.key_prefix IS 'First 8 characters for identification';
COMMENT ON COLUMN api_keys.scopes IS 'Permitted operations (e.g., [read:stores, write:orders])';

CREATE TRIGGER api_keys_updated_at BEFORE UPDATE ON api_keys
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- STORES & GEOGRAPHIC HIERARCHY
-- ==============================================================================

-- Regions (Top-level geographic grouping)
CREATE TABLE regions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  code TEXT,
  parent_region_id UUID REFERENCES regions(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT regions_code_unique_per_brand UNIQUE (brand_id, code)
);

COMMENT ON TABLE regions IS 'Geographic regions for store organization (e.g., West Coast)';
COMMENT ON COLUMN regions.parent_region_id IS 'Supports hierarchical region structure';

CREATE TRIGGER regions_updated_at BEFORE UPDATE ON regions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Districts (Mid-level geographic grouping)
CREATE TABLE districts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  region_id UUID NOT NULL REFERENCES regions(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  code TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT districts_code_unique_per_brand UNIQUE (brand_id, code)
);

COMMENT ON TABLE districts IS 'District-level geographic grouping within regions';

CREATE TRIGGER districts_updated_at BEFORE UPDATE ON districts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Territories (Fine-grained geographic grouping)
CREATE TABLE territories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  district_id UUID REFERENCES districts(id) ON DELETE SET NULL,
  region_id UUID NOT NULL REFERENCES regions(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  code TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT territories_code_unique_per_brand UNIQUE (brand_id, code)
);

COMMENT ON TABLE territories IS 'Territory-level geographic grouping';
COMMENT ON COLUMN territories.district_id IS 'Optional parent district';
COMMENT ON COLUMN territories.region_id IS 'Required fallback parent region';

CREATE TRIGGER territories_updated_at BEFORE UPDATE ON territories
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Stores
CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  store_number TEXT NOT NULL,
  name TEXT NOT NULL,
  address_line1 TEXT NOT NULL,
  address_line2 TEXT,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  zip_code TEXT NOT NULL,
  country TEXT DEFAULT 'US',
  region_id UUID NOT NULL REFERENCES regions(id) ON DELETE RESTRICT,
  district_id UUID REFERENCES districts(id) ON DELETE SET NULL,
  territory_id UUID REFERENCES territories(id) ON DELETE SET NULL,
  status store_status_enum DEFAULT 'ACTIVE',
  primary_contact_name TEXT,
  primary_contact_email TEXT,
  primary_contact_phone TEXT,
  store_manager_name TEXT,
  external_store_guid TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT stores_number_unique_per_brand UNIQUE (brand_id, store_number)
);

COMMENT ON TABLE stores IS 'Retail store locations';
COMMENT ON COLUMN stores.store_number IS 'Brand-specific store identifier';
COMMENT ON COLUMN stores.status IS 'Operational status: ACTIVE, INACTIVE, TEMP_CLOSED, CLOSED';
COMMENT ON COLUMN stores.external_store_guid IS 'External system mapping identifier';
COMMENT ON COLUMN stores.country IS 'ISO country code (default: US)';

CREATE TRIGGER stores_updated_at BEFORE UPDATE ON stores
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Add foreign key constraints to memberships now that regions and stores exist
ALTER TABLE memberships
  ADD CONSTRAINT memberships_region_scope_fk
  FOREIGN KEY (region_scope_id) REFERENCES regions(id) ON DELETE SET NULL;

ALTER TABLE memberships
  ADD CONSTRAINT memberships_store_scope_fk
  FOREIGN KEY (store_scope_id) REFERENCES stores(id) ON DELETE CASCADE;

-- Store Groups (Ad-hoc store groupings)
CREATE TABLE store_groups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  created_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE store_groups IS 'Ad-hoc groupings of stores (e.g., High Volume, Test Markets)';
COMMENT ON COLUMN store_groups.created_by_user_id IS 'User who created this group';

CREATE TRIGGER store_groups_updated_at BEFORE UPDATE ON store_groups
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Store Group Memberships
CREATE TABLE store_group_memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  store_group_id UUID NOT NULL REFERENCES store_groups(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT store_group_membership_unique UNIQUE (store_id, store_group_id)
);

COMMENT ON TABLE store_group_memberships IS 'Many-to-many relationship between stores and groups';

CREATE TRIGGER store_group_memberships_updated_at BEFORE UPDATE ON store_group_memberships
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Store Layouts (Physical layout definitions)
CREATE TABLE store_layouts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  version INTEGER DEFAULT 1,
  is_current BOOLEAN DEFAULT TRUE,
  layout_json JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE store_layouts IS 'Store physical layout definitions (versioned)';
COMMENT ON COLUMN store_layouts.version IS 'Layout version number for change tracking';
COMMENT ON COLUMN store_layouts.is_current IS 'Indicates active layout version';
COMMENT ON COLUMN store_layouts.layout_json IS 'Full layout structure including slot definitions';

CREATE TRIGGER store_layouts_updated_at BEFORE UPDATE ON store_layouts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Location Slots (Installation points within store)
CREATE TABLE location_slots (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_layout_id UUID NOT NULL REFERENCES store_layouts(id) ON DELETE CASCADE,
  slot_name TEXT NOT NULL,
  slot_type TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0,
  dimensions JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE location_slots IS 'Physical installation locations within a store (e.g., Front Window, Shelf 3)';
COMMENT ON COLUMN location_slots.slot_type IS 'Type of location (e.g., WINDOW, SHELF, ENDCAP)';
COMMENT ON COLUMN location_slots.sort_order IS 'Display order for execution workflow';
COMMENT ON COLUMN location_slots.dimensions IS 'Physical dimensions if relevant (width, height in JSON)';

CREATE TRIGGER location_slots_updated_at BEFORE UPDATE ON location_slots
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- SURVEYS & PHOTO RULES
-- ==============================================================================

-- Survey Templates
CREATE TABLE survey_templates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE survey_templates IS 'Survey template definitions (e.g., Receipt Survey, Install Survey)';
COMMENT ON COLUMN survey_templates.is_active IS 'Whether template is available for new campaigns';

CREATE TRIGGER survey_templates_updated_at BEFORE UPDATE ON survey_templates
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Survey Versions (Versioned survey definitions)
CREATE TABLE survey_versions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  survey_template_id UUID NOT NULL REFERENCES survey_templates(id) ON DELETE CASCADE,
  version_number INTEGER NOT NULL,
  definition_json JSONB NOT NULL,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT survey_version_unique UNIQUE (survey_template_id, version_number)
);

COMMENT ON TABLE survey_versions IS 'Versioned survey structures to support evolution without breaking active campaigns';
COMMENT ON COLUMN survey_versions.definition_json IS 'Complete survey structure including questions, validation rules, and branching logic';
COMMENT ON COLUMN survey_versions.published_at IS 'When this version became available for use';

CREATE TRIGGER survey_versions_updated_at BEFORE UPDATE ON survey_versions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Photo Rules (Photo capture requirements)
CREATE TABLE photo_rules (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  min_photos INTEGER DEFAULT 1,
  max_photos INTEGER DEFAULT 5,
  require_flash BOOLEAN DEFAULT FALSE,
  min_resolution INTEGER,
  ghost_image_url TEXT,
  instructions TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT photo_rules_min_max_check CHECK (min_photos <= max_photos)
);

COMMENT ON TABLE photo_rules IS 'Photo capture requirements and validation rules';
COMMENT ON COLUMN photo_rules.min_photos IS 'Minimum number of photos required';
COMMENT ON COLUMN photo_rules.max_photos IS 'Maximum number of photos allowed';
COMMENT ON COLUMN photo_rules.min_resolution IS 'Minimum pixels required';
COMMENT ON COLUMN photo_rules.ghost_image_url IS 'Reference overlay image URL for guidance';
COMMENT ON COLUMN photo_rules.instructions IS 'User-facing guidance text';

CREATE TRIGGER photo_rules_updated_at BEFORE UPDATE ON photo_rules
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- CAMPAIGNS & KITS
-- ==============================================================================

-- Kit Definitions (Reusable kit templates)
CREATE TABLE kit_definitions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  is_template BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE kit_definitions IS 'Kit templates defining collections of promotional items';
COMMENT ON COLUMN kit_definitions.is_template IS 'Whether this is a reusable template or campaign-specific';

CREATE TRIGGER kit_definitions_updated_at BEFORE UPDATE ON kit_definitions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Kit Items (Items within a kit)
CREATE TABLE kit_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  kit_definition_id UUID NOT NULL REFERENCES kit_definitions(id) ON DELETE CASCADE,
  sku TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  quantity INTEGER DEFAULT 1,
  slot_type TEXT,
  photo_rule_id UUID REFERENCES photo_rules(id) ON DELETE SET NULL,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT kit_items_quantity_positive CHECK (quantity > 0)
);

COMMENT ON TABLE kit_items IS 'Individual items within a kit definition';
COMMENT ON COLUMN kit_items.sku IS 'Product SKU identifier';
COMMENT ON COLUMN kit_items.quantity IS 'Quantity per store';
COMMENT ON COLUMN kit_items.slot_type IS 'Suggested slot type (e.g., WINDOW, SHELF)';
COMMENT ON COLUMN kit_items.photo_rule_id IS 'Photo requirements for this item';
COMMENT ON COLUMN kit_items.sort_order IS 'Display order in execution workflow';

CREATE TRIGGER kit_items_updated_at BEFORE UPDATE ON kit_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Campaigns
CREATE TABLE campaigns (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status campaign_status_enum DEFAULT 'DRAFT',
  verification_mode verification_mode_enum DEFAULT 'STRICT',
  psp_campaign_ref TEXT,
  selection_recipe_json JSONB,
  kit_definition_id UUID REFERENCES kit_definitions(id) ON DELETE RESTRICT,
  survey_version_id UUID REFERENCES survey_versions(id) ON DELETE SET NULL,
  published_at TIMESTAMPTZ,
  published_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT campaigns_date_check CHECK (start_date <= end_date)
);

COMMENT ON TABLE campaigns IS 'Marketing campaigns executed across stores';
COMMENT ON COLUMN campaigns.status IS 'Lifecycle status: DRAFT, SCHEDULED, PUBLISHED, COMPLETED, CANCELLED, ARCHIVED';
COMMENT ON COLUMN campaigns.verification_mode IS 'Photo review mode: STRICT (manual review all) or FAST (auto-approve unless flagged)';
COMMENT ON COLUMN campaigns.psp_campaign_ref IS 'PSP MIS reference identifier';
COMMENT ON COLUMN campaigns.selection_recipe_json IS 'Store selection criteria (filters, groups, exclusions)';
COMMENT ON COLUMN campaigns.kit_definition_id IS 'Associated kit definition';
COMMENT ON COLUMN campaigns.survey_version_id IS 'Pinned survey version for this campaign';

CREATE TRIGGER campaigns_updated_at BEFORE UPDATE ON campaigns
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Store Assignments (Campaign-Store relationships)
CREATE TABLE store_assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  status store_assignment_status_enum DEFAULT 'ASSIGNED',
  assigned_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  layout_version_id UUID REFERENCES store_layouts(id) ON DELETE SET NULL,
  survey_version_id UUID REFERENCES survey_versions(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT store_assignment_unique UNIQUE (campaign_id, store_id)
);

COMMENT ON TABLE store_assignments IS 'Assignment of campaigns to stores with execution tracking';
COMMENT ON COLUMN store_assignments.status IS 'Execution status: ASSIGNED, READY, IN_PROGRESS, SUBMITTED, REWORK_REQUIRED, COMPLETE, REOPENED, WAIVED';
COMMENT ON COLUMN store_assignments.layout_version_id IS 'Pinned store layout version for this campaign';
COMMENT ON COLUMN store_assignments.survey_version_id IS 'Pinned survey version (can override campaign default)';

CREATE TRIGGER store_assignments_updated_at BEFORE UPDATE ON store_assignments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Assignment Items (Kit items assigned to specific stores)
CREATE TABLE assignment_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  kit_item_id UUID NOT NULL REFERENCES kit_items(id) ON DELETE RESTRICT,
  location_slot_id UUID REFERENCES location_slots(id) ON DELETE SET NULL,
  quantity INTEGER DEFAULT 1,
  status assignment_item_status_enum DEFAULT 'PLANNED',
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT assignment_items_quantity_positive CHECK (quantity > 0)
);

COMMENT ON TABLE assignment_items IS 'Specific kit items assigned to stores with installation tracking';
COMMENT ON COLUMN assignment_items.location_slot_id IS 'Mapped installation location for this item';
COMMENT ON COLUMN assignment_items.quantity IS 'Quantity assigned to this store';
COMMENT ON COLUMN assignment_items.status IS 'Item status: PLANNED, ORDERED, SHIPPED, DELIVERED, RECEIVED, INSTALLED, PROOF_SUBMITTED, RETAKE_REQUIRED, SATISFIED, EXCEPTION';

CREATE TRIGGER assignment_items_updated_at BEFORE UPDATE ON assignment_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- FULFILLMENT & LOGISTICS
-- ==============================================================================

-- Store Orders
CREATE TABLE store_orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  order_number TEXT NOT NULL UNIQUE,
  order_type order_type_enum DEFAULT 'INITIAL',
  psp_order_ref TEXT,
  status store_order_status_enum DEFAULT 'GENERATED',
  acknowledged_at TIMESTAMPTZ,
  shipping_address_snapshot JSONB,
  batch_label TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE store_orders IS 'Fulfillment orders generated for store assignments';
COMMENT ON COLUMN store_orders.order_number IS 'System-generated unique order number (e.g., ORD-1001)';
COMMENT ON COLUMN store_orders.order_type IS 'INITIAL or REORDER';
COMMENT ON COLUMN store_orders.psp_order_ref IS 'PSP MIS order reference';
COMMENT ON COLUMN store_orders.status IS 'Order status: GENERATED, ACKNOWLEDGED, IN_PRODUCTION, KITTING, READY_TO_SHIP, PARTIALLY_SHIPPED, SHIPPED, DELIVERED, CLOSED, CANCELLED';
COMMENT ON COLUMN store_orders.shipping_address_snapshot IS 'Frozen shipping address at order generation time';
COMMENT ON COLUMN store_orders.batch_label IS 'Optional PSP batch identifier';

CREATE TRIGGER store_orders_updated_at BEFORE UPDATE ON store_orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Order Lines (Items within orders)
CREATE TABLE order_lines (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_order_id UUID NOT NULL REFERENCES store_orders(id) ON DELETE CASCADE,
  kit_item_id UUID NOT NULL REFERENCES kit_items(id) ON DELETE RESTRICT,
  quantity INTEGER NOT NULL,
  sku TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT order_lines_quantity_positive CHECK (quantity > 0)
);

COMMENT ON TABLE order_lines IS 'Line items within store orders';
COMMENT ON COLUMN order_lines.sku IS 'Denormalized SKU for reporting';

CREATE TRIGGER order_lines_updated_at BEFORE UPDATE ON order_lines
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Shipments
CREATE TABLE shipments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_order_id UUID NOT NULL REFERENCES store_orders(id) ON DELETE CASCADE,
  carrier TEXT,
  tracking_numbers JSONB DEFAULT '[]'::jsonb,
  shipped_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  status shipment_status_enum DEFAULT 'LABEL_CREATED',
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE shipments IS 'Shipment tracking for store orders';
COMMENT ON COLUMN shipments.carrier IS 'Carrier name (e.g., UPS, FEDEX, USPS)';
COMMENT ON COLUMN shipments.tracking_numbers IS 'Array of tracking numbers (supports multi-package shipments)';
COMMENT ON COLUMN shipments.status IS 'Shipment status: LABEL_CREATED, IN_TRANSIT, DELIVERED, EXCEPTION, RETURNED';

CREATE TRIGGER shipments_updated_at BEFORE UPDATE ON shipments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Shipment Lines (Items within shipments)
CREATE TABLE shipment_lines (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shipment_id UUID NOT NULL REFERENCES shipments(id) ON DELETE CASCADE,
  kit_item_id UUID NOT NULL REFERENCES kit_items(id) ON DELETE RESTRICT,
  quantity INTEGER NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT shipment_lines_quantity_positive CHECK (quantity > 0)
);

COMMENT ON TABLE shipment_lines IS 'Line items within shipments (supports partial shipments)';
COMMENT ON COLUMN shipment_lines.quantity IS 'Quantity in this specific shipment';

CREATE TRIGGER shipment_lines_updated_at BEFORE UPDATE ON shipment_lines
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- EXECUTION & VERIFICATION
-- ==============================================================================

-- Receive Verifications (Receipt Survey Stage)
CREATE TABLE receive_verifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  verified_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  verified_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  all_items_received BOOLEAN DEFAULT TRUE,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE receive_verifications IS 'Receipt survey responses confirming inventory delivery';
COMMENT ON COLUMN receive_verifications.all_items_received IS 'Whether store confirmed receipt of all items';
COMMENT ON COLUMN receive_verifications.notes IS 'Additional notes from store about receipt';

CREATE TRIGGER receive_verifications_updated_at BEFORE UPDATE ON receive_verifications
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Store Survey Responses (Install Survey Stage)
CREATE TABLE store_survey_responses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  survey_version_id UUID NOT NULL REFERENCES survey_versions(id) ON DELETE RESTRICT,
  response_json JSONB NOT NULL,
  submitted_at TIMESTAMPTZ,
  submitted_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE store_survey_responses IS 'Store execution survey responses including attestations';
COMMENT ON COLUMN store_survey_responses.response_json IS 'Complete survey answers including attestation signature';
COMMENT ON COLUMN store_survey_responses.submitted_at IS 'Final submission timestamp (NULL = draft)';

CREATE TRIGGER store_survey_responses_updated_at BEFORE UPDATE ON store_survey_responses
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Photo Uploads
CREATE TABLE photo_uploads (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  assignment_item_id UUID REFERENCES assignment_items(id) ON DELETE SET NULL,
  location_slot_id UUID REFERENCES location_slots(id) ON DELETE SET NULL,
  s3_key TEXT NOT NULL,
  s3_url TEXT,
  file_size_bytes INTEGER,
  mime_type TEXT,
  review_status photo_review_status_enum DEFAULT 'PENDING',
  uploaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  uploaded_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE photo_uploads IS 'Proof photos uploaded by stores during execution';
COMMENT ON COLUMN photo_uploads.s3_key IS 'S3 object key for photo storage';
COMMENT ON COLUMN photo_uploads.s3_url IS 'Presigned URL for photo access (cached)';
COMMENT ON COLUMN photo_uploads.review_status IS 'Review status: PENDING, APPROVED, REJECTED, SUPERSEDED';
COMMENT ON COLUMN photo_uploads.assignment_item_id IS 'Associated kit item (if item-specific proof)';
COMMENT ON COLUMN photo_uploads.location_slot_id IS 'Associated location slot (if slot-specific proof)';

CREATE TRIGGER photo_uploads_updated_at BEFORE UPDATE ON photo_uploads
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Photo Reviews
CREATE TABLE photo_reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  photo_upload_id UUID NOT NULL REFERENCES photo_uploads(id) ON DELETE CASCADE,
  reviewer_user_id UUID NOT NULL REFERENCES users(id) ON DELETE SET NULL,
  status photo_review_status_enum NOT NULL,
  rejection_reason rejection_reason_enum,
  rejection_comment TEXT,
  reviewed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE photo_reviews IS 'Brand reviewer decisions on proof photos';
COMMENT ON COLUMN photo_reviews.status IS 'Review decision: APPROVED or REJECTED';
COMMENT ON COLUMN photo_reviews.rejection_reason IS 'Standardized reason if rejected';
COMMENT ON COLUMN photo_reviews.rejection_comment IS 'Additional explanation for store';

CREATE TRIGGER photo_reviews_updated_at BEFORE UPDATE ON photo_reviews
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Retake Requests
CREATE TABLE retake_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  photo_upload_id UUID NOT NULL REFERENCES photo_uploads(id) ON DELETE CASCADE,
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  reason rejection_reason_enum NOT NULL,
  comment TEXT,
  requested_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMPTZ,
  new_photo_upload_id UUID REFERENCES photo_uploads(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE retake_requests IS 'Photo retake requests when original is rejected';
COMMENT ON COLUMN retake_requests.photo_upload_id IS 'Original rejected photo';
COMMENT ON COLUMN retake_requests.new_photo_upload_id IS 'Replacement photo submitted by store';
COMMENT ON COLUMN retake_requests.completed_at IS 'When store submitted the replacement photo';

CREATE TRIGGER retake_requests_updated_at BEFORE UPDATE ON retake_requests
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- ISSUES & EXCEPTIONS
-- ==============================================================================

-- Issue Requests
CREATE TABLE issue_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_assignment_id UUID NOT NULL REFERENCES store_assignments(id) ON DELETE CASCADE,
  type issue_type_enum NOT NULL,
  description TEXT,
  status issue_request_status_enum DEFAULT 'OPEN',
  evidence_photo_id UUID REFERENCES photo_uploads(id) ON DELETE SET NULL,
  submitted_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  submitted_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  reviewed_at TIMESTAMPTZ,
  reviewed_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE issue_requests IS 'Store-reported issues with materials (missing, damaged, incorrect)';
COMMENT ON COLUMN issue_requests.type IS 'Issue type: MISSING, DAMAGED, INCORRECT, PACKAGING';
COMMENT ON COLUMN issue_requests.status IS 'Workflow status: OPEN, TRIAGED, AWAITING_APPROVAL, APPROVED, IN_FULFILLMENT, DENIED, RESOLVED';
COMMENT ON COLUMN issue_requests.evidence_photo_id IS 'Photo evidence (required for DAMAGED)';

CREATE TRIGGER issue_requests_updated_at BEFORE UPDATE ON issue_requests
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Issue Lines (Specific items affected by issue)
CREATE TABLE issue_lines (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  issue_request_id UUID NOT NULL REFERENCES issue_requests(id) ON DELETE CASCADE,
  kit_item_id UUID NOT NULL REFERENCES kit_items(id) ON DELETE RESTRICT,
  quantity INTEGER DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT issue_lines_quantity_positive CHECK (quantity > 0)
);

COMMENT ON TABLE issue_lines IS 'Specific kit items affected by an issue';

CREATE TRIGGER issue_lines_updated_at BEFORE UPDATE ON issue_lines
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Reorders (Replacement orders from issues)
CREATE TABLE reorders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  issue_request_id UUID NOT NULL REFERENCES issue_requests(id) ON DELETE RESTRICT,
  store_order_id UUID NOT NULL REFERENCES store_orders(id) ON DELETE CASCADE,
  status store_order_status_enum,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE reorders IS 'Replacement orders generated from issue requests';
COMMENT ON COLUMN reorders.status IS 'Tracks fulfillment of replacement order';

CREATE TRIGGER reorders_updated_at BEFORE UPDATE ON reorders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- NOTIFICATIONS & PREFERENCES
-- ==============================================================================

-- Notification Preferences
CREATE TABLE notification_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  channel notification_channel_enum NOT NULL,
  event_type TEXT NOT NULL,
  enabled BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  CONSTRAINT notification_preferences_unique UNIQUE (user_id, channel, event_type)
);

COMMENT ON TABLE notification_preferences IS 'User preferences for notification delivery';
COMMENT ON COLUMN notification_preferences.channel IS 'Delivery channel: EMAIL, IN_APP, PUSH';
COMMENT ON COLUMN notification_preferences.event_type IS 'Event type (e.g., photo.rejected, campaign.published)';

CREATE TRIGGER notification_preferences_updated_at BEFORE UPDATE ON notification_preferences
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Notifications
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  channel notification_channel_enum NOT NULL,
  event_type TEXT NOT NULL,
  subject TEXT,
  body TEXT,
  action_url TEXT,
  read_at TIMESTAMPTZ,
  sent_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE notifications IS 'Notification delivery log';
COMMENT ON COLUMN notifications.subject IS 'Email subject or notification title';
COMMENT ON COLUMN notifications.body IS 'Notification content';
COMMENT ON COLUMN notifications.action_url IS 'Deep link for user action';
COMMENT ON COLUMN notifications.read_at IS 'When user read the notification (IN_APP only)';

CREATE TRIGGER notifications_updated_at BEFORE UPDATE ON notifications
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- WEBHOOKS & INTEGRATIONS
-- ==============================================================================

-- Webhook Endpoints
CREATE TABLE webhook_endpoints (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  secret TEXT NOT NULL,
  events TEXT[] NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  last_success_at TIMESTAMPTZ,
  last_failure_at TIMESTAMPTZ,
  failure_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE webhook_endpoints IS 'Webhook endpoints for event notifications';
COMMENT ON COLUMN webhook_endpoints.secret IS 'HMAC signing key for webhook verification';
COMMENT ON COLUMN webhook_endpoints.events IS 'Subscribed event types';
COMMENT ON COLUMN webhook_endpoints.failure_count IS 'Consecutive failure count for circuit breaking';

CREATE TRIGGER webhook_endpoints_updated_at BEFORE UPDATE ON webhook_endpoints
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Webhook Deliveries
CREATE TABLE webhook_deliveries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  webhook_endpoint_id UUID NOT NULL REFERENCES webhook_endpoints(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL,
  payload_json JSONB NOT NULL,
  status_code INTEGER,
  response_body TEXT,
  attempt_count INTEGER DEFAULT 1,
  next_retry_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE webhook_deliveries IS 'Webhook delivery attempts and outcomes';
COMMENT ON COLUMN webhook_deliveries.status_code IS 'HTTP response status code';
COMMENT ON COLUMN webhook_deliveries.response_body IS 'Truncated response body for debugging';
COMMENT ON COLUMN webhook_deliveries.attempt_count IS 'Number of delivery attempts';
COMMENT ON COLUMN webhook_deliveries.delivered_at IS 'Successful delivery timestamp';

CREATE TRIGGER webhook_deliveries_updated_at BEFORE UPDATE ON webhook_deliveries
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- EXPORTS & JOBS
-- ==============================================================================

-- Export Jobs
CREATE TABLE export_jobs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id UUID REFERENCES brands(id) ON DELETE CASCADE,
  campaign_id UUID REFERENCES campaigns(id) ON DELETE CASCADE,
  requested_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE SET NULL,
  export_type TEXT NOT NULL,
  format export_format_enum NOT NULL,
  status export_job_status_enum DEFAULT 'PENDING',
  parameters_json JSONB,
  s3_key TEXT,
  file_size_bytes INTEGER,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  error_message TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE export_jobs IS 'Background export job tracking';
COMMENT ON COLUMN export_jobs.export_type IS 'Export type (e.g., campaign_summary, store_list)';
COMMENT ON COLUMN export_jobs.format IS 'Output format: CSV, XLSX, PDF, JSON, XML';
COMMENT ON COLUMN export_jobs.status IS 'Job status: PENDING, PROCESSING, COMPLETED, FAILED, EXPIRED';
COMMENT ON COLUMN export_jobs.parameters_json IS 'Export filters and options';
COMMENT ON COLUMN export_jobs.expires_at IS 'Auto-deletion timestamp';

CREATE TRIGGER export_jobs_updated_at BEFORE UPDATE ON export_jobs
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- AUDIT & OBSERVABILITY
-- ==============================================================================

-- Audit Events
CREATE TABLE audit_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  brand_id UUID REFERENCES brands(id) ON DELETE CASCADE,
  actor_type audit_actor_type_enum NOT NULL,
  actor_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  actor_api_key_id UUID REFERENCES api_keys(id) ON DELETE SET NULL,
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id UUID NOT NULL,
  before_json JSONB,
  after_json JSONB,
  metadata_json JSONB,
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE audit_events IS 'Comprehensive audit trail for all state changes';
COMMENT ON COLUMN audit_events.actor_type IS 'Actor type: HUMAN, SYSTEM, INTEGRATION';
COMMENT ON COLUMN audit_events.action IS 'Action performed (e.g., campaign.published, photo.reviewed)';
COMMENT ON COLUMN audit_events.entity_type IS 'Type of entity modified (e.g., Campaign, PhotoUpload)';
COMMENT ON COLUMN audit_events.entity_id IS 'ID of entity modified';
COMMENT ON COLUMN audit_events.before_json IS 'State before change';
COMMENT ON COLUMN audit_events.after_json IS 'State after change';
COMMENT ON COLUMN audit_events.metadata_json IS 'Additional context (e.g., selection criteria for bulk operations)';

CREATE TRIGGER audit_events_updated_at BEFORE UPDATE ON audit_events
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==============================================================================
-- INDEXES FOR QUERY OPTIMIZATION
-- ==============================================================================

-- Tenancy & Identity
CREATE INDEX idx_brands_tenant ON brands(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_memberships_user ON memberships(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_memberships_tenant_brand ON memberships(tenant_id, brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_memberships_role ON memberships(role) WHERE deleted_at IS NULL;
CREATE INDEX idx_api_keys_tenant ON api_keys(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_api_keys_prefix ON api_keys(key_prefix);

-- Stores & Geography
CREATE INDEX idx_regions_brand ON regions(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_districts_brand_region ON districts(brand_id, region_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_territories_brand ON territories(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_stores_brand ON stores(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_stores_brand_status ON stores(brand_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_stores_region ON stores(region_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_stores_number ON stores(store_number) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_groups_brand ON store_groups(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_group_memberships_store ON store_group_memberships(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_group_memberships_group ON store_group_memberships(store_group_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_layouts_store ON store_layouts(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_layouts_current ON store_layouts(store_id, is_current) WHERE deleted_at IS NULL AND is_current = TRUE;
CREATE INDEX idx_location_slots_layout ON location_slots(store_layout_id) WHERE deleted_at IS NULL;

-- Surveys & Photo Rules
CREATE INDEX idx_survey_templates_brand ON survey_templates(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_survey_versions_template ON survey_versions(survey_template_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_rules_brand ON photo_rules(brand_id) WHERE deleted_at IS NULL;

-- Campaigns & Kits
CREATE INDEX idx_kit_definitions_brand ON kit_definitions(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_kit_items_definition ON kit_items(kit_definition_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_campaigns_brand ON campaigns(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_campaigns_brand_status ON campaigns(brand_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_campaigns_status ON campaigns(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_campaigns_dates ON campaigns(start_date, end_date) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_assignments_campaign ON store_assignments(campaign_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_assignments_store ON store_assignments(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_assignments_status ON store_assignments(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_assignment_items_assignment ON assignment_items(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_assignment_items_kit_item ON assignment_items(kit_item_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_assignment_items_slot ON assignment_items(location_slot_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_assignment_items_status ON assignment_items(status) WHERE deleted_at IS NULL;

-- Fulfillment
CREATE INDEX idx_store_orders_campaign ON store_orders(campaign_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_store ON store_orders(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_assignment ON store_orders(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_status ON store_orders(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_orders_number ON store_orders(order_number);
CREATE INDEX idx_order_lines_order ON order_lines(store_order_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_shipments_order ON shipments(store_order_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_shipments_status ON shipments(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_shipment_lines_shipment ON shipment_lines(shipment_id) WHERE deleted_at IS NULL;

-- Execution & Verification
CREATE INDEX idx_receive_verifications_assignment ON receive_verifications(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_survey_responses_assignment ON store_survey_responses(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_assignment ON photo_uploads(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_item ON photo_uploads(assignment_item_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_slot ON photo_uploads(location_slot_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_uploads_review_status ON photo_uploads(review_status) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_reviews_photo ON photo_reviews(photo_upload_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_reviews_reviewer ON photo_reviews(reviewer_user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_retake_requests_assignment ON retake_requests(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_retake_requests_photo ON retake_requests(photo_upload_id) WHERE deleted_at IS NULL;

-- Issues
CREATE INDEX idx_issue_requests_assignment ON issue_requests(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_issue_requests_status ON issue_requests(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_issue_lines_request ON issue_lines(issue_request_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_reorders_issue ON reorders(issue_request_id) WHERE deleted_at IS NULL;

-- Notifications
CREATE INDEX idx_notification_preferences_user ON notification_preferences(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_notifications_user ON notifications(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_notifications_user_unread ON notifications(user_id, read_at) WHERE deleted_at IS NULL AND read_at IS NULL;

-- Webhooks
CREATE INDEX idx_webhook_endpoints_tenant ON webhook_endpoints(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_webhook_deliveries_endpoint ON webhook_deliveries(webhook_endpoint_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_webhook_deliveries_retry ON webhook_deliveries(next_retry_at) WHERE next_retry_at IS NOT NULL AND delivered_at IS NULL;

-- Exports
CREATE INDEX idx_export_jobs_brand ON export_jobs(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_export_jobs_campaign ON export_jobs(campaign_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_export_jobs_requester ON export_jobs(requested_by_user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_export_jobs_status ON export_jobs(status) WHERE deleted_at IS NULL;

-- Audit
CREATE INDEX idx_audit_events_tenant ON audit_events(tenant_id, created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_audit_events_brand ON audit_events(brand_id, created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_audit_events_entity ON audit_events(entity_type, entity_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_audit_events_actor_user ON audit_events(actor_user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_audit_events_action ON audit_events(action) WHERE deleted_at IS NULL;

-- GIN indexes for JSONB queries
CREATE INDEX idx_campaigns_selection_recipe_gin ON campaigns USING GIN (selection_recipe_json) WHERE deleted_at IS NULL;
CREATE INDEX idx_survey_versions_definition_gin ON survey_versions USING GIN (definition_json) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_survey_responses_response_gin ON store_survey_responses USING GIN (response_json) WHERE deleted_at IS NULL;

-- ==============================================================================
-- HELPER VIEWS (Optional - for common queries)
-- ==============================================================================

-- Active Campaigns View
CREATE VIEW v_active_campaigns AS
SELECT
  c.*,
  b.name AS brand_name,
  b.code AS brand_code,
  COUNT(DISTINCT sa.id) AS total_stores,
  COUNT(DISTINCT sa.id) FILTER (WHERE sa.status = 'COMPLETE') AS completed_stores
FROM campaigns c
INNER JOIN brands b ON c.brand_id = b.id
LEFT JOIN store_assignments sa ON c.id = sa.campaign_id AND sa.deleted_at IS NULL
WHERE c.deleted_at IS NULL
  AND c.status IN ('PUBLISHED', 'SCHEDULED')
GROUP BY c.id, b.name, b.code;

COMMENT ON VIEW v_active_campaigns IS 'Active campaigns with store completion counts';

-- Store Assignment Detail View
CREATE VIEW v_store_assignment_details AS
SELECT
  sa.*,
  c.name AS campaign_name,
  c.start_date AS campaign_start,
  c.end_date AS campaign_end,
  s.store_number,
  s.name AS store_name,
  s.city,
  s.state,
  r.name AS region_name,
  COUNT(DISTINCT ai.id) AS total_items,
  COUNT(DISTINCT ai.id) FILTER (WHERE ai.status = 'SATISFIED') AS satisfied_items,
  COUNT(DISTINCT pu.id) AS total_photos,
  COUNT(DISTINCT pu.id) FILTER (WHERE pu.review_status = 'APPROVED') AS approved_photos
FROM store_assignments sa
INNER JOIN campaigns c ON sa.campaign_id = c.id
INNER JOIN stores s ON sa.store_id = s.id
INNER JOIN regions r ON s.region_id = r.id
LEFT JOIN assignment_items ai ON sa.id = ai.store_assignment_id AND ai.deleted_at IS NULL
LEFT JOIN photo_uploads pu ON sa.id = pu.store_assignment_id AND pu.deleted_at IS NULL
WHERE sa.deleted_at IS NULL
  AND c.deleted_at IS NULL
  AND s.deleted_at IS NULL
GROUP BY sa.id, c.name, c.start_date, c.end_date, s.store_number, s.name, s.city, s.state, r.name;

COMMENT ON VIEW v_store_assignment_details IS 'Comprehensive store assignment details with progress metrics';

-- ==============================================================================
-- END OF DDL
-- ==============================================================================
