-- =====================================================================================
-- File: 01_idx_lookup.sql
-- Description: Primary lookup pattern indexes for NewPOPSys database
-- Created: 2025-12-19
-- Package: 5 - Index Optimization
-- =====================================================================================
-- Purpose: Indexes for common lookup operations including user email, API keys,
--          membership relationships, and tenant/brand associations.
-- =====================================================================================

-- =============================================================================
-- USERS & MEMBERSHIPS LOOKUP INDEXES
-- =============================================================================

-- User email lookup (already covered by UNIQUE constraint, but adding explicit for clarity)
-- Note: idx_users_email already exists in 00_foundation_ddl.sql - SKIP

-- Membership lookups by user and brand combination
CREATE INDEX IF NOT EXISTS idx_memberships_user_brand
  ON memberships(user_id, brand_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_memberships_user_brand IS
  'Lookup memberships for a specific user in a specific brand (e.g., checking permissions)';

-- Membership lookups by brand and role (for listing all users with a specific role in a brand)
CREATE INDEX IF NOT EXISTS idx_memberships_brand_role
  ON memberships(brand_id, role)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_memberships_brand_role IS
  'Find all users with a specific role within a brand (e.g., all REGIONAL_ADMIN users)';

-- Membership lookups by role only (for cross-brand role queries)
CREATE INDEX IF NOT EXISTS idx_memberships_role
  ON memberships(role)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_memberships_role IS
  'Find all users with a specific role across all brands (e.g., all PSP_ADMIN users)';

-- Membership scope lookups for regional scoping
CREATE INDEX IF NOT EXISTS idx_memberships_region_scope
  ON memberships(region_scope_id)
  WHERE region_scope_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_memberships_region_scope IS
  'Find all memberships scoped to a specific region';

-- Membership scope lookups for store scoping
CREATE INDEX IF NOT EXISTS idx_memberships_store_scope
  ON memberships(store_scope_id)
  WHERE store_scope_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_memberships_store_scope IS
  'Find all memberships scoped to a specific store';

-- =============================================================================
-- API KEYS LOOKUP INDEXES
-- =============================================================================

-- API key tenant lookup (already exists in 00_foundation_ddl.sql - SKIP)
-- API key prefix lookup (already exists in 00_foundation_ddl.sql - SKIP)

-- Active API keys by tenant (partial index for active keys only)
CREATE INDEX IF NOT EXISTS idx_api_keys_tenant_active
  ON api_keys(tenant_id, created_at DESC)
  WHERE deleted_at IS NULL AND revoked_at IS NULL
    AND (expires_at IS NULL OR expires_at > CURRENT_TIMESTAMP);

COMMENT ON INDEX idx_api_keys_tenant_active IS
  'Efficiently find all currently active API keys for a tenant';

-- API key lookups by last used timestamp for cleanup/monitoring
CREATE INDEX IF NOT EXISTS idx_api_keys_last_used
  ON api_keys(last_used_at DESC NULLS LAST)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_api_keys_last_used IS
  'Find API keys by last usage time for monitoring and cleanup operations';

-- =============================================================================
-- STORE LOOKUP INDEXES
-- =============================================================================

-- Store lookup by brand and status (for listing active stores)
-- Note: idx_stores_brand_status pattern partially exists, enhancing with status combinations
CREATE INDEX IF NOT EXISTS idx_stores_brand_status_active
  ON stores(brand_id, region_id, district_id)
  WHERE deleted_at IS NULL AND status = 'ACTIVE';

COMMENT ON INDEX idx_stores_brand_status_active IS
  'Efficiently find all active stores for a brand with hierarchy filtering';

-- Store external GUID lookup (already exists in brand_module_ddl.sql - SKIP)

-- Store district lookup (for district-level operations)
CREATE INDEX IF NOT EXISTS idx_stores_district
  ON stores(district_id)
  WHERE district_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_stores_district IS
  'Find all stores in a specific district';

-- Store territory lookup (for territory-level operations)
CREATE INDEX IF NOT EXISTS idx_stores_territory
  ON stores(territory_id)
  WHERE territory_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_stores_territory IS
  'Find all stores in a specific territory';

-- Store number + brand unique lookup (for external integrations)
-- Note: This should be UNIQUE constraint, adding it here for reference
CREATE UNIQUE INDEX IF NOT EXISTS idx_stores_number_brand_unique
  ON stores(store_number, brand_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_stores_number_brand_unique IS
  'Enforce unique store numbers within a brand, ignoring soft-deleted stores';

-- =============================================================================
-- NOTIFICATION LOOKUP INDEXES
-- =============================================================================

-- User notifications by read status and creation time
CREATE INDEX IF NOT EXISTS idx_notifications_user_read_status
  ON notifications(user_id, read_at, created_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_notifications_user_read_status IS
  'Efficiently retrieve notifications for a user filtered by read status and sorted by time';

-- =============================================================================
-- WEBHOOK LOOKUP INDEXES
-- =============================================================================

-- Active webhook endpoints by tenant
CREATE INDEX IF NOT EXISTS idx_webhook_endpoints_tenant_active
  ON webhook_endpoints(tenant_id, is_active)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_webhook_endpoints_tenant_active IS
  'Find all active webhook endpoints for a tenant';

-- Webhook deliveries needing retry (already exists in 00_foundation_ddl.sql - SKIP)

-- =============================================================================
-- PERFORMANCE NOTES
-- =============================================================================

-- 1. All indexes use partial WHERE deleted_at IS NULL for soft-delete pattern
-- 2. Composite indexes are ordered by selectivity (most selective first)
-- 3. DESC ordering on timestamps for recent-first queries
-- 4. NULLS LAST for nullable timestamp columns in descending order
-- 5. Unique indexes enforce business rules while providing lookup performance
