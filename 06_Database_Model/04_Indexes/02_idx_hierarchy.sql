-- =====================================================================================
-- File: 02_idx_hierarchy.sql
-- Description: Geographic hierarchy navigation indexes for NewPOPSys database
-- Created: 2025-12-19
-- Package: 5 - Index Optimization
-- =====================================================================================
-- Purpose: Indexes for navigating the geographic hierarchy (regions, districts,
--          territories, stores) efficiently. Supports both top-down and bottom-up
--          hierarchy traversal.
-- =====================================================================================

-- =============================================================================
-- REGIONS HIERARCHY INDEXES
-- =============================================================================

-- Regions by brand (already exists in brand_module_ddl.sql - SKIP)
-- CREATE INDEX idx_regions_brand ON regions(brand_id) WHERE deleted_at IS NULL;

-- Regions by parent (for hierarchical tree traversal)
CREATE INDEX IF NOT EXISTS idx_regions_parent
  ON regions(parent_region_id)
  WHERE parent_region_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_regions_parent IS
  'Find all child regions of a parent region (hierarchical navigation)';

-- All root regions by brand (regions without parents)
CREATE INDEX IF NOT EXISTS idx_regions_brand_root
  ON regions(brand_id)
  WHERE parent_region_id IS NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_regions_brand_root IS
  'Find all root-level regions for a brand';

-- Regions by name for search/autocomplete
CREATE INDEX IF NOT EXISTS idx_regions_brand_name
  ON regions(brand_id, name)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_regions_brand_name IS
  'Search regions by name within a brand';

-- =============================================================================
-- DISTRICTS HIERARCHY INDEXES
-- =============================================================================

-- Districts by brand and region (already exists in brand_module_ddl.sql - SKIP)
-- CREATE INDEX idx_districts_brand_region ON districts(brand_id, region_id) WHERE deleted_at IS NULL;

-- Districts by region only (for region-centric queries)
CREATE INDEX IF NOT EXISTS idx_districts_region
  ON districts(region_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_districts_region IS
  'Find all districts within a specific region';

-- Districts by brand only (for brand-wide operations)
CREATE INDEX IF NOT EXISTS idx_districts_brand
  ON districts(brand_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_districts_brand IS
  'Find all districts for a brand';

-- Districts by name for search
CREATE INDEX IF NOT EXISTS idx_districts_brand_name
  ON districts(brand_id, name)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_districts_brand_name IS
  'Search districts by name within a brand';

-- =============================================================================
-- TERRITORIES HIERARCHY INDEXES
-- =============================================================================

-- Territories by brand and district (already exists in brand_module_ddl.sql as idx_territories_brand_region)
-- Need to add explicit district index

-- Territories by district only
CREATE INDEX IF NOT EXISTS idx_territories_district
  ON territories(district_id)
  WHERE district_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_territories_district IS
  'Find all territories within a specific district';

-- Territories by region only
CREATE INDEX IF NOT EXISTS idx_territories_region
  ON territories(region_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_territories_region IS
  'Find all territories within a specific region';

-- Territories by brand only
CREATE INDEX IF NOT EXISTS idx_territories_brand
  ON territories(brand_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_territories_brand IS
  'Find all territories for a brand';

-- Territories without district assignment (for data quality checks)
CREATE INDEX IF NOT EXISTS idx_territories_no_district
  ON territories(brand_id, region_id)
  WHERE district_id IS NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_territories_no_district IS
  'Find territories not assigned to a district (data quality monitoring)';

-- Territories by name for search
CREATE INDEX IF NOT EXISTS idx_territories_brand_name
  ON territories(brand_id, name)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_territories_brand_name IS
  'Search territories by name within a brand';

-- =============================================================================
-- STORES HIERARCHY INDEXES
-- =============================================================================

-- Store region lookup (already partially covered, adding explicit index)
CREATE INDEX IF NOT EXISTS idx_stores_region
  ON stores(region_id)
  WHERE region_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_stores_region IS
  'Find all stores in a specific region';

-- Store district lookup (already in 01_idx_lookup.sql but duplicating here for hierarchy context)
-- CREATE INDEX idx_stores_district ON stores(district_id) WHERE district_id IS NOT NULL AND deleted_at IS NULL;

-- Store territory lookup (already in 01_idx_lookup.sql but duplicating here for hierarchy context)
-- CREATE INDEX idx_stores_territory ON stores(territory_id) WHERE territory_id IS NOT NULL AND deleted_at IS NULL;

-- Stores by brand and hierarchy levels
CREATE INDEX IF NOT EXISTS idx_stores_brand_region_district
  ON stores(brand_id, region_id, district_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_stores_brand_region_district IS
  'Find stores by brand and hierarchy path (region > district)';

-- Stores missing hierarchy assignments (for data quality)
CREATE INDEX IF NOT EXISTS idx_stores_missing_hierarchy
  ON stores(brand_id, status)
  WHERE (region_id IS NULL OR district_id IS NULL) AND deleted_at IS NULL;

COMMENT ON INDEX idx_stores_missing_hierarchy IS
  'Find stores with incomplete hierarchy assignments (data quality monitoring)';

-- =============================================================================
-- STORE GROUPS HIERARCHY INDEXES
-- =============================================================================

-- Store group memberships by store (for finding groups a store belongs to)
-- Already exists: idx_store_group_memberships_store

-- Store group memberships by group (for listing stores in a group)
-- Already exists: idx_store_group_memberships_group

-- Store groups by brand with active member count tracking
CREATE INDEX IF NOT EXISTS idx_store_groups_brand_created
  ON store_groups(brand_id, created_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_store_groups_brand_created IS
  'List store groups for a brand sorted by creation time';

-- =============================================================================
-- HIERARCHICAL QUERY PATTERNS
-- =============================================================================

-- Pattern 1: Top-Down Traversal (Brand → Region → District → Territory → Store)
-- Uses indexes:
--   - idx_regions_brand (find regions in brand)
--   - idx_districts_region (find districts in region)
--   - idx_territories_district (find territories in district)
--   - idx_stores_territory (find stores in territory)

-- Pattern 2: Bottom-Up Traversal (Store → Territory → District → Region → Brand)
-- Uses foreign key indexes on stores table (implicitly indexed)

-- Pattern 3: Cross-Hierarchy Queries (e.g., all stores in region, skipping district)
-- Uses indexes:
--   - idx_stores_region (direct region to stores)
--   - idx_stores_brand_region_district (composite hierarchy path)

-- Pattern 4: Sibling Queries (e.g., all districts in same region)
-- Uses indexes:
--   - idx_districts_region
--   - idx_territories_district

-- =============================================================================
-- PERFORMANCE NOTES
-- =============================================================================

-- 1. Self-referential hierarchy (regions.parent_region_id) requires careful indexing
-- 2. Nullable foreign keys (district_id, territory_id on stores) use partial indexes
-- 3. Composite indexes ordered by cardinality: brand_id (low) → region_id (medium) → district_id (high)
-- 4. Data quality indexes help identify incomplete hierarchy assignments
-- 5. Name-based search indexes support autocomplete and lookup operations
