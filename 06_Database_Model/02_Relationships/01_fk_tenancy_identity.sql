-- ==============================================================================
-- FOREIGN KEY RELATIONSHIPS - Tenancy & Identity
-- ==============================================================================
-- Module: Tenancy & Identity
-- Tables: tenants, brands, users, memberships, api_keys
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- BRANDS
-- ==============================================================================

-- Brand belongs to tenant
ALTER TABLE brands
  ADD CONSTRAINT fk_brands_tenant
  FOREIGN KEY (tenant_id)
  REFERENCES tenants(id)
  ON DELETE RESTRICT  -- Cannot delete tenant with brands
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_brands_tenant ON brands IS
  'Brand belongs to a PSP tenant; cannot delete tenant with active brands';


-- ==============================================================================
-- MEMBERSHIPS
-- ==============================================================================

-- Membership links user to tenant
ALTER TABLE memberships
  ADD CONSTRAINT fk_memberships_user
  FOREIGN KEY (user_id)
  REFERENCES users(id)
  ON DELETE CASCADE  -- Delete memberships when user deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_memberships_user ON memberships IS
  'User who has this membership; cascade delete memberships when user deleted';

-- Membership belongs to tenant
ALTER TABLE memberships
  ADD CONSTRAINT fk_memberships_tenant
  FOREIGN KEY (tenant_id)
  REFERENCES tenants(id)
  ON DELETE CASCADE  -- Delete memberships when tenant deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_memberships_tenant ON memberships IS
  'Tenant context for membership; cascade delete when tenant deleted';

-- Membership may be scoped to brand (NULL for PSP roles)
ALTER TABLE memberships
  ADD CONSTRAINT fk_memberships_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE CASCADE  -- Delete memberships when brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_memberships_brand ON memberships IS
  'Optional brand scope for membership; NULL for PSP-level roles';

-- Membership may be scoped to region (for REGIONAL_MANAGER role)
ALTER TABLE memberships
  ADD CONSTRAINT fk_memberships_region_scope
  FOREIGN KEY (region_scope_id)
  REFERENCES regions(id)
  ON DELETE SET NULL  -- Clear scope if region deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_memberships_region_scope ON memberships IS
  'Optional region scope for REGIONAL_MANAGER role';

-- Membership may be scoped to store (for STORE_OPERATOR role)
ALTER TABLE memberships
  ADD CONSTRAINT fk_memberships_store_scope
  FOREIGN KEY (store_scope_id)
  REFERENCES stores(id)
  ON DELETE CASCADE  -- Delete membership if scoped store deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_memberships_store_scope ON memberships IS
  'Optional store scope for STORE_OPERATOR role; cascade delete if store deleted';

-- Membership assignment audit (who assigned this role)
ALTER TABLE memberships
  ADD CONSTRAINT fk_memberships_assigned_by
  FOREIGN KEY (assigned_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve membership even if assigner deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_memberships_assigned_by ON memberships IS
  'User who assigned this membership; set to NULL if user deleted';


-- ==============================================================================
-- API KEYS
-- ==============================================================================

-- API key belongs to tenant
ALTER TABLE api_keys
  ADD CONSTRAINT fk_api_keys_tenant
  FOREIGN KEY (tenant_id)
  REFERENCES tenants(id)
  ON DELETE CASCADE  -- Delete API keys when tenant deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_api_keys_tenant ON api_keys IS
  'API key belongs to tenant; cascade delete when tenant deleted';


-- ==============================================================================
-- END OF TENANCY & IDENTITY FOREIGN KEYS
-- ==============================================================================
