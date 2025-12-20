-- ==============================================================================
-- FOREIGN KEY RELATIONSHIPS - Stores & Geographic Grouping
-- ==============================================================================
-- Module: Stores & Grouping
-- Tables: regions, districts, territories, stores, store_groups, store_group_memberships
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- REGIONS
-- ==============================================================================

-- Region belongs to brand
ALTER TABLE regions
  ADD CONSTRAINT fk_regions_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE CASCADE  -- Delete regions when brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_regions_brand ON regions IS
  'Region belongs to brand; cascade delete when brand deleted';

-- Region may have parent region (hierarchical)
ALTER TABLE regions
  ADD CONSTRAINT fk_regions_parent
  FOREIGN KEY (parent_region_id)
  REFERENCES regions(id)
  ON DELETE SET NULL  -- Clear parent reference if parent deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_regions_parent ON regions IS
  'Optional parent region for hierarchical structure; set to NULL if parent deleted';


-- ==============================================================================
-- DISTRICTS
-- ==============================================================================

-- District belongs to brand
ALTER TABLE districts
  ADD CONSTRAINT fk_districts_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE CASCADE  -- Delete districts when brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_districts_brand ON districts IS
  'District belongs to brand; cascade delete when brand deleted';

-- District belongs to region
ALTER TABLE districts
  ADD CONSTRAINT fk_districts_region
  FOREIGN KEY (region_id)
  REFERENCES regions(id)
  ON DELETE CASCADE  -- Delete districts when region deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_districts_region ON districts IS
  'District belongs to region; cascade delete when region deleted';


-- ==============================================================================
-- TERRITORIES
-- ==============================================================================

-- Territory belongs to brand
ALTER TABLE territories
  ADD CONSTRAINT fk_territories_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE CASCADE  -- Delete territories when brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_territories_brand ON territories IS
  'Territory belongs to brand; cascade delete when brand deleted';

-- Territory may belong to district (optional mid-level)
ALTER TABLE territories
  ADD CONSTRAINT fk_territories_district
  FOREIGN KEY (district_id)
  REFERENCES districts(id)
  ON DELETE SET NULL  -- Clear district if deleted (falls back to region)
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_territories_district ON territories IS
  'Optional parent district; set to NULL if district deleted';

-- Territory belongs to region (required parent)
ALTER TABLE territories
  ADD CONSTRAINT fk_territories_region
  FOREIGN KEY (region_id)
  REFERENCES regions(id)
  ON DELETE CASCADE  -- Delete territories when region deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_territories_region ON territories IS
  'Territory belongs to region (required parent); cascade delete when region deleted';


-- ==============================================================================
-- STORES
-- ==============================================================================

-- Store belongs to brand
ALTER TABLE stores
  ADD CONSTRAINT fk_stores_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE CASCADE  -- Delete stores when brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_stores_brand ON stores IS
  'Store belongs to brand; cascade delete when brand deleted';

-- Store belongs to region (required)
ALTER TABLE stores
  ADD CONSTRAINT fk_stores_region
  FOREIGN KEY (region_id)
  REFERENCES regions(id)
  ON DELETE RESTRICT  -- Cannot delete region with active stores
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_stores_region ON stores IS
  'Store belongs to region; cannot delete region with active stores';

-- Store may belong to district (optional)
ALTER TABLE stores
  ADD CONSTRAINT fk_stores_district
  FOREIGN KEY (district_id)
  REFERENCES districts(id)
  ON DELETE SET NULL  -- Clear district if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_stores_district ON stores IS
  'Optional district assignment; set to NULL if district deleted';

-- Store may belong to territory (optional)
ALTER TABLE stores
  ADD CONSTRAINT fk_stores_territory
  FOREIGN KEY (territory_id)
  REFERENCES territories(id)
  ON DELETE SET NULL  -- Clear territory if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_stores_territory ON stores IS
  'Optional territory assignment; set to NULL if territory deleted';


-- ==============================================================================
-- STORE GROUPS
-- ==============================================================================

-- Store group belongs to brand
ALTER TABLE store_groups
  ADD CONSTRAINT fk_store_groups_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE CASCADE  -- Delete groups when brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_groups_brand ON store_groups IS
  'Store group belongs to brand; cascade delete when brand deleted';

-- Store group created by user (audit)
ALTER TABLE store_groups
  ADD CONSTRAINT fk_store_groups_creator
  FOREIGN KEY (created_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve group even if creator deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_groups_creator ON store_groups IS
  'User who created this group; set to NULL if user deleted';


-- ==============================================================================
-- STORE GROUP MEMBERSHIPS
-- ==============================================================================

-- Membership links to store
ALTER TABLE store_group_memberships
  ADD CONSTRAINT fk_store_group_memberships_store
  FOREIGN KEY (store_id)
  REFERENCES stores(id)
  ON DELETE CASCADE  -- Delete membership when store deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_group_memberships_store ON store_group_memberships IS
  'Store in this group; cascade delete when store deleted';

-- Membership links to group
ALTER TABLE store_group_memberships
  ADD CONSTRAINT fk_store_group_memberships_group
  FOREIGN KEY (store_group_id)
  REFERENCES store_groups(id)
  ON DELETE CASCADE  -- Delete membership when group deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_group_memberships_group ON store_group_memberships IS
  'Store group; cascade delete when group deleted';


-- ==============================================================================
-- END OF STORES & GROUPING FOREIGN KEYS
-- ==============================================================================
