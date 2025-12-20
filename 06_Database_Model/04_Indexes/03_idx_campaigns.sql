-- =====================================================================================
-- File: 03_idx_campaigns.sql
-- Description: Campaign and assignment query pattern indexes for NewPOPSys database
-- Created: 2025-12-19
-- Package: 5 - Index Optimization
-- =====================================================================================
-- Purpose: Indexes for campaign management, store assignments, assignment items,
--          and campaign-related date range queries.
-- =====================================================================================

-- =============================================================================
-- CAMPAIGNS QUERY INDEXES
-- =============================================================================

-- Campaigns by brand and date range
CREATE INDEX IF NOT EXISTS idx_campaigns_brand_dates
  ON campaigns(brand_id, start_date, end_date)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_campaigns_brand_dates IS
  'Find campaigns for a brand within a date range';

-- Campaigns by status and dates (for active/upcoming campaign dashboards)
CREATE INDEX IF NOT EXISTS idx_campaigns_status_dates
  ON campaigns(status, start_date, end_date)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_campaigns_status_dates IS
  'Find campaigns by status and date range (e.g., all PUBLISHED campaigns)';

-- Active campaigns by brand (partial index)
CREATE INDEX IF NOT EXISTS idx_campaigns_brand_active
  ON campaigns(brand_id, start_date)
  WHERE deleted_at IS NULL AND status IN ('PUBLISHED', 'IN_PROGRESS');

COMMENT ON INDEX idx_campaigns_brand_active IS
  'Find currently active campaigns for a brand';

-- Campaigns by brand, status, and creation time
-- Note: idx_campaigns_brand_status already exists in brand_module_ddl.sql
-- Enhancing with created_at for sorting

CREATE INDEX IF NOT EXISTS idx_campaigns_brand_status_created
  ON campaigns(brand_id, status, created_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_campaigns_brand_status_created IS
  'List campaigns by brand and status, sorted by creation time';

-- Campaigns by kit definition (for finding campaigns using a specific kit)
CREATE INDEX IF NOT EXISTS idx_campaigns_kit_definition
  ON campaigns(kit_definition_id)
  WHERE kit_definition_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_campaigns_kit_definition IS
  'Find all campaigns using a specific kit definition';

-- Campaigns by survey version (for finding campaigns using a specific survey)
CREATE INDEX IF NOT EXISTS idx_campaigns_survey_version
  ON campaigns(survey_version_id)
  WHERE survey_version_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_campaigns_survey_version IS
  'Find all campaigns using a specific survey version';

-- Campaigns published by user (audit trail)
CREATE INDEX IF NOT EXISTS idx_campaigns_published_by
  ON campaigns(published_by_user_id, published_at DESC)
  WHERE published_by_user_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_campaigns_published_by IS
  'Find campaigns published by a specific user, sorted by publish time';

-- Campaign selection recipe GIN index (for JSONB queries)
CREATE INDEX IF NOT EXISTS idx_campaigns_selection_recipe_gin
  ON campaigns USING GIN (selection_recipe_json)
  WHERE selection_recipe_json IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_campaigns_selection_recipe_gin IS
  'Enable efficient queries on campaign selection recipe JSON (e.g., finding campaigns targeting specific store groups)';

-- =============================================================================
-- STORE ASSIGNMENTS QUERY INDEXES
-- =============================================================================

-- Store assignments by campaign (already exists in brand_module_ddl.sql - SKIP)
-- CREATE INDEX idx_store_assignments_campaign ON store_assignments(campaign_id) WHERE deleted_at IS NULL;

-- Store assignments by status (already exists in brand_module_ddl.sql - SKIP)
-- CREATE INDEX idx_store_assignments_status ON store_assignments(status) WHERE deleted_at IS NULL;

-- Store assignments by campaign and status (composite for filtered queries)
CREATE INDEX IF NOT EXISTS idx_store_assignments_campaign_status
  ON store_assignments(campaign_id, status)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_store_assignments_campaign_status IS
  'Find store assignments for a campaign filtered by status (e.g., all IN_PROGRESS assignments)';

-- Store assignments by store and campaign (find assignment for specific store in campaign)
CREATE INDEX IF NOT EXISTS idx_store_assignments_store_campaign
  ON store_assignments(store_id, campaign_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_store_assignments_store_campaign IS
  'Find the assignment for a specific store in a specific campaign';

-- Store assignments by store across campaigns (store's assignment history)
-- Already exists: idx_store_assignments_store

-- Assignments ready for execution (partial index)
CREATE INDEX IF NOT EXISTS idx_store_assignments_ready
  ON store_assignments(campaign_id, created_at)
  WHERE status = 'READY' AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_assignments_ready IS
  'Find all assignments ready for execution in a campaign';

-- Assignments in progress (partial index)
CREATE INDEX IF NOT EXISTS idx_store_assignments_in_progress
  ON store_assignments(campaign_id, updated_at DESC)
  WHERE status = 'IN_PROGRESS' AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_assignments_in_progress IS
  'Find all in-progress assignments for a campaign, sorted by last update';

-- Assignments submitted for review (partial index)
CREATE INDEX IF NOT EXISTS idx_store_assignments_submitted
  ON store_assignments(campaign_id, updated_at DESC)
  WHERE status = 'SUBMITTED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_assignments_submitted IS
  'Find all submitted assignments awaiting review in a campaign';

-- Assignments blocked (partial index for issue management)
CREATE INDEX IF NOT EXISTS idx_store_assignments_blocked
  ON store_assignments(campaign_id, updated_at DESC)
  WHERE status = 'BLOCKED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_assignments_blocked IS
  'Find all blocked assignments requiring attention in a campaign';

-- Assignments by layout version
CREATE INDEX IF NOT EXISTS idx_store_assignments_layout
  ON store_assignments(layout_version_id)
  WHERE layout_version_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_assignments_layout IS
  'Find all assignments using a specific store layout version';

-- Assignments by survey version
CREATE INDEX IF NOT EXISTS idx_store_assignments_survey
  ON store_assignments(survey_version_id)
  WHERE survey_version_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_assignments_survey IS
  'Find all assignments using a specific survey version';

-- Assignments with blocked reasons (for reporting)
CREATE INDEX IF NOT EXISTS idx_store_assignments_blocked_reasons_gin
  ON store_assignments USING GIN (readiness_blocked_reasons)
  WHERE readiness_blocked_reasons IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_assignments_blocked_reasons_gin IS
  'Query assignments by blocking reasons (e.g., find all assignments blocked due to missing materials)';

-- =============================================================================
-- ASSIGNMENT ITEMS QUERY INDEXES
-- =============================================================================

-- Assignment items by store assignment (already exists in brand_module_ddl.sql - SKIP)
-- CREATE INDEX idx_assignment_items_assignment ON assignment_items(store_assignment_id) WHERE deleted_at IS NULL;

-- Assignment items by status (for tracking item-level progress)
CREATE INDEX IF NOT EXISTS idx_assignment_items_status
  ON assignment_items(status)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_assignment_items_status IS
  'Find all assignment items with a specific status across all assignments';

-- Assignment items by assignment and status (composite)
CREATE INDEX IF NOT EXISTS idx_assignment_items_assignment_status
  ON assignment_items(store_assignment_id, status)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_assignment_items_assignment_status IS
  'Find assignment items for a specific assignment filtered by status';

-- Assignment items by kit item (for tracking which assignments use a specific item)
CREATE INDEX IF NOT EXISTS idx_assignment_items_kit_item
  ON assignment_items(kit_item_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_assignment_items_kit_item IS
  'Find all assignment items referencing a specific kit item';

-- Assignment items by location slot (for slot-based queries)
CREATE INDEX IF NOT EXISTS idx_assignment_items_location_slot
  ON assignment_items(location_slot_id)
  WHERE location_slot_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_assignment_items_location_slot IS
  'Find all assignment items assigned to a specific location slot';

-- Assignment items by status timestamps (for phase tracking)
CREATE INDEX IF NOT EXISTS idx_assignment_items_ordered_at
  ON assignment_items(ordered_at DESC)
  WHERE ordered_at IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_assignment_items_ordered_at IS
  'Find recently ordered assignment items';

CREATE INDEX IF NOT EXISTS idx_assignment_items_shipped_at
  ON assignment_items(shipped_at DESC)
  WHERE shipped_at IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_assignment_items_shipped_at IS
  'Find recently shipped assignment items';

CREATE INDEX IF NOT EXISTS idx_assignment_items_installed_at
  ON assignment_items(installed_at DESC)
  WHERE installed_at IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_assignment_items_installed_at IS
  'Find recently installed assignment items';

-- =============================================================================
-- KIT DEFINITIONS & ITEMS QUERY INDEXES
-- =============================================================================

-- Kit definitions by brand (already exists in brand_module_ddl.sql - SKIP)
-- CREATE INDEX idx_kit_definitions_brand ON kit_definitions(brand_id) WHERE deleted_at IS NULL;

-- Kit definitions by brand and active status
CREATE INDEX IF NOT EXISTS idx_kit_definitions_brand_active
  ON kit_definitions(brand_id, created_at DESC)
  WHERE is_active = TRUE AND deleted_at IS NULL;

COMMENT ON INDEX idx_kit_definitions_brand_active IS
  'Find active kit definitions for a brand, sorted by creation time';

-- Kit items by kit definition (already exists in brand_module_ddl.sql - SKIP)
-- CREATE INDEX idx_kit_items_kit ON kit_items(kit_definition_id) WHERE deleted_at IS NULL;

-- Kit items by SKU (for inventory lookups)
CREATE INDEX IF NOT EXISTS idx_kit_items_sku
  ON kit_items(sku)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_kit_items_sku IS
  'Find kit items by SKU (for inventory and fulfillment lookups)';

-- Kit items by photo rule
CREATE INDEX IF NOT EXISTS idx_kit_items_photo_rule
  ON kit_items(photo_rule_id)
  WHERE photo_rule_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_kit_items_photo_rule IS
  'Find all kit items that require a specific photo rule';

-- =============================================================================
-- PERFORMANCE NOTES
-- =============================================================================

-- 1. Campaign date range queries use composite (brand_id, start_date, end_date)
-- 2. Status-based partial indexes reduce index size for high-cardinality status columns
-- 3. GIN indexes on JSONB columns enable flexible queries on selection recipes
-- 4. Timestamp indexes support phase-based reporting and dashboards
-- 5. Composite indexes ordered by filter selectivity: ID columns → status → dates
