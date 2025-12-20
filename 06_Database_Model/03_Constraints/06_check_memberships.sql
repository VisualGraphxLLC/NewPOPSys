-- ==============================================================================
-- CHECK CONSTRAINTS: MEMBERSHIPS & RBAC
-- ==============================================================================
-- Business rule enforcement for role-based access control and scope requirements
--
-- Dependencies: 00_foundation_ddl.sql, 13_missing_fields.sql
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- MEMBERSHIPS TABLE CONSTRAINTS
-- ==============================================================================

-- PSP-level roles (PSP_ADMIN, PSP_OPS) must NOT have brand_id
ALTER TABLE memberships
  ADD CONSTRAINT chk_memberships_psp_no_brand
  CHECK (
    (role IN ('PSP_ADMIN', 'PSP_OPS') AND brand_id IS NULL) OR
    (role NOT IN ('PSP_ADMIN', 'PSP_OPS'))
  );

COMMENT ON CONSTRAINT chk_memberships_psp_no_brand ON memberships IS
  'Business Rule: PSP-level roles (PSP_ADMIN, PSP_OPS) must not have brand_id set';

-- Brand-level roles must HAVE brand_id
ALTER TABLE memberships
  ADD CONSTRAINT chk_memberships_brand_required
  CHECK (
    (role IN ('BRAND_ADMIN', 'CAMPAIGN_MANAGER', 'REGIONAL_MANAGER', 'STORE_MANAGER', 'STORE_OPERATOR')
     AND brand_id IS NOT NULL) OR
    (role NOT IN ('BRAND_ADMIN', 'CAMPAIGN_MANAGER', 'REGIONAL_MANAGER', 'STORE_MANAGER', 'STORE_OPERATOR'))
  );

COMMENT ON CONSTRAINT chk_memberships_brand_required ON memberships IS
  'Business Rule: Brand-level roles must have brand_id set';

-- REGIONAL_MANAGER role must have region_scope_id
ALTER TABLE memberships
  ADD CONSTRAINT chk_memberships_regional_scope
  CHECK (
    (role = 'REGIONAL_MANAGER' AND region_scope_id IS NOT NULL) OR
    (role != 'REGIONAL_MANAGER')
  );

COMMENT ON CONSTRAINT chk_memberships_regional_scope ON memberships IS
  'Business Rule: REGIONAL_MANAGER role must have region_scope_id set';

-- STORE_MANAGER and STORE_OPERATOR roles must have store_scope_id
ALTER TABLE memberships
  ADD CONSTRAINT chk_memberships_store_scope
  CHECK (
    (role IN ('STORE_MANAGER', 'STORE_OPERATOR') AND store_scope_id IS NOT NULL) OR
    (role NOT IN ('STORE_MANAGER', 'STORE_OPERATOR'))
  );

COMMENT ON CONSTRAINT chk_memberships_store_scope ON memberships IS
  'Business Rule: STORE_MANAGER and STORE_OPERATOR roles must have store_scope_id set';

-- Non-scoped roles should not have region or store scope
ALTER TABLE memberships
  ADD CONSTRAINT chk_memberships_no_scope
  CHECK (
    (role IN ('PSP_ADMIN', 'PSP_OPS', 'BRAND_ADMIN', 'CAMPAIGN_MANAGER')
     AND region_scope_id IS NULL
     AND store_scope_id IS NULL) OR
    (role NOT IN ('PSP_ADMIN', 'PSP_OPS', 'BRAND_ADMIN', 'CAMPAIGN_MANAGER'))
  );

COMMENT ON CONSTRAINT chk_memberships_no_scope ON memberships IS
  'Business Rule: Non-scoped roles must not have region_scope_id or store_scope_id set';

-- Expired memberships should not be in the past (soft validation)
-- This is enforced at query time via WHERE expires_at IS NULL OR expires_at > NOW()
COMMENT ON COLUMN memberships.expires_at IS
  'Business Rule: Expired memberships (expires_at < NOW) should be filtered in queries';

-- ==============================================================================
-- API_KEYS TABLE CONSTRAINTS
-- ==============================================================================

-- Expires_at must be in the future when set
ALTER TABLE api_keys
  ADD CONSTRAINT chk_api_keys_expires_future
  CHECK (
    expires_at IS NULL OR expires_at > created_at
  );

COMMENT ON CONSTRAINT chk_api_keys_expires_future ON api_keys IS
  'Business Rule: API key expiration must be after creation time';

-- Key prefix must be non-empty
ALTER TABLE api_keys
  ADD CONSTRAINT chk_api_keys_prefix
  CHECK (
    key_prefix IS NOT NULL AND LENGTH(TRIM(key_prefix)) > 0
  );

COMMENT ON CONSTRAINT chk_api_keys_prefix ON api_keys IS
  'Business Rule: API key prefix must be non-empty';

-- Key hash must be non-empty
ALTER TABLE api_keys
  ADD CONSTRAINT chk_api_keys_hash
  CHECK (
    key_hash IS NOT NULL AND LENGTH(TRIM(key_hash)) > 0
  );

COMMENT ON CONSTRAINT chk_api_keys_hash ON api_keys IS
  'Business Rule: API key hash must be non-empty';

-- Name must be non-empty
ALTER TABLE api_keys
  ADD CONSTRAINT chk_api_keys_name
  CHECK (
    name IS NOT NULL AND LENGTH(TRIM(name)) > 0
  );

COMMENT ON CONSTRAINT chk_api_keys_name ON api_keys IS
  'Business Rule: API key name must be non-empty';

-- ==============================================================================
-- USERS TABLE CONSTRAINTS
-- ==============================================================================

-- Email must be non-empty and lowercase
ALTER TABLE users
  ADD CONSTRAINT chk_users_email
  CHECK (
    email IS NOT NULL AND
    LENGTH(TRIM(email)) > 0 AND
    email = LOWER(email)
  );

COMMENT ON CONSTRAINT chk_users_email ON users IS
  'Business Rule: User email must be non-empty and lowercase';

-- Password hash must be non-empty
ALTER TABLE users
  ADD CONSTRAINT chk_users_password_hash
  CHECK (
    password_hash IS NOT NULL AND LENGTH(TRIM(password_hash)) > 0
  );

COMMENT ON CONSTRAINT chk_users_password_hash ON users IS
  'Business Rule: User password hash must be non-empty';

-- Email verified requires verification timestamp
ALTER TABLE users
  ADD CONSTRAINT chk_users_email_verified_at
  CHECK (
    (email_verified = TRUE AND email_verified_at IS NOT NULL) OR
    (email_verified = FALSE)
  );

COMMENT ON CONSTRAINT chk_users_email_verified_at ON users IS
  'Business Rule: Verified emails must have email_verified_at timestamp';

-- Timezone must be valid IANA format (enforced at application layer)
COMMENT ON COLUMN users.timezone IS
  'Business Rule: Timezone must be valid IANA timezone identifier (e.g., America/New_York) - validated at application layer';

-- Locale must be valid format (enforced at application layer)
COMMENT ON COLUMN users.locale IS
  'Business Rule: Locale must be valid format (e.g., en-US, es-MX) - validated at application layer';

-- ==============================================================================
-- TENANTS TABLE CONSTRAINTS
-- ==============================================================================

-- Subscription tier validation (already exists in DDL, documented here)
-- CONSTRAINT: CHECK (subscription_tier IN ('PILOT', 'STANDARD', 'ENTERPRISE'))
COMMENT ON CONSTRAINT tenants_subscription_tier_check ON tenants IS
  'Business Rule: Tenant subscription tier must be PILOT, STANDARD, or ENTERPRISE';

-- Max brands must be positive
ALTER TABLE tenants
  ADD CONSTRAINT chk_tenants_max_brands
  CHECK (max_brands IS NULL OR max_brands > 0);

COMMENT ON CONSTRAINT chk_tenants_max_brands ON tenants IS
  'Business Rule: Maximum brands must be positive when set';

-- Max users must be positive
ALTER TABLE tenants
  ADD CONSTRAINT chk_tenants_max_users
  CHECK (max_users IS NULL OR max_users > 0);

COMMENT ON CONSTRAINT chk_tenants_max_users ON tenants IS
  'Business Rule: Maximum users must be positive when set';

-- Subscription end date must be after start date
ALTER TABLE tenants
  ADD CONSTRAINT chk_tenants_subscription_dates
  CHECK (
    subscription_start_date IS NULL OR
    subscription_end_date IS NULL OR
    subscription_end_date >= subscription_start_date
  );

COMMENT ON CONSTRAINT chk_tenants_subscription_dates ON tenants IS
  'Business Rule: Subscription end date must be on or after start date';

-- Slug must be lowercase and URL-safe (enforced at application layer)
COMMENT ON COLUMN tenants.slug IS
  'Business Rule: Tenant slug must be lowercase, URL-safe (alphanumeric + hyphens) - validated at application layer';

-- ==============================================================================
-- BRANDS TABLE CONSTRAINTS
-- ==============================================================================

-- Brand tier validation (added in 13_missing_fields.sql)
COMMENT ON COLUMN brands.brand_tier IS
  'Business Rule: Brand tier must be BASIC, STANDARD, PREMIUM, or ENTERPRISE';

-- Code must be non-empty and uppercase
ALTER TABLE brands
  ADD CONSTRAINT chk_brands_code
  CHECK (
    code IS NOT NULL AND
    LENGTH(TRIM(code)) > 0 AND
    code = UPPER(code)
  );

COMMENT ON CONSTRAINT chk_brands_code ON brands IS
  'Business Rule: Brand code must be non-empty and uppercase';

-- ==============================================================================
-- END OF MEMBERSHIP CONSTRAINTS
-- ==============================================================================
