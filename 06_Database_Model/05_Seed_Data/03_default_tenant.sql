-- ==============================================================================
-- DEFAULT TENANT & BRAND SEED DATA - NewPOPSys v1
-- ==============================================================================
-- Creates a default tenant and brand for development, testing, and initial setup.
-- This allows developers to work with the system without needing to manually
-- create tenant/brand hierarchy first.
--
-- Dependencies: 00_foundation_ddl.sql (tenants, brands tables must exist)
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- DEFAULT TENANT
-- ==============================================================================
-- Purpose: Development and testing tenant
-- Slug: dev-tenant (for local development)
-- Tier: PILOT (lowest tier for testing)

INSERT INTO tenants (
  id,
  name,
  slug,
  subscription_tier,
  settings_json,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000100'::UUID,
  'Development Tenant',
  'dev-tenant',
  'PILOT',
  '{
    "features": {
      "webhook_integration": true,
      "export_api": true,
      "advanced_analytics": false
    },
    "limits": {
      "max_brands": 10,
      "max_users": 50,
      "max_active_campaigns": 5
    },
    "contact": {
      "primary_email": "dev@newpopsys.internal",
      "support_email": "support@newpopsys.internal"
    }
  }'::jsonb,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- Alternative INSERT with conflict handling on slug
INSERT INTO tenants (
  id,
  name,
  slug,
  subscription_tier,
  settings_json,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000100'::UUID,
  'Development Tenant',
  'dev-tenant',
  'PILOT',
  '{
    "features": {
      "webhook_integration": true,
      "export_api": true,
      "advanced_analytics": false
    },
    "limits": {
      "max_brands": 10,
      "max_users": 50,
      "max_active_campaigns": 5
    },
    "contact": {
      "primary_email": "dev@newpopsys.internal",
      "support_email": "support@newpopsys.internal"
    }
  }'::jsonb,
  NOW(),
  NOW()
)
ON CONFLICT (slug) DO NOTHING;

-- ==============================================================================
-- DEFAULT BRAND
-- ==============================================================================
-- Purpose: Default brand for development and testing
-- Code: DEV (development brand code)
-- Belongs to: Development Tenant

INSERT INTO brands (
  id,
  tenant_id,
  name,
  code,
  logo_url,
  settings_json,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000200'::UUID,
  '00000000-0000-0000-0000-000000000100'::UUID,  -- dev-tenant
  'Development Brand',
  'DEV',
  NULL,  -- No logo for dev brand
  '{
    "theme": {
      "primary_color": "#1976D2",
      "secondary_color": "#424242"
    },
    "store_management": {
      "auto_assign_territory": false,
      "require_store_approval": true
    },
    "campaign_defaults": {
      "verification_mode": "STRICT",
      "auto_publish_orders": false
    },
    "photo_rules": {
      "max_file_size_mb": 10,
      "allowed_mime_types": ["image/jpeg", "image/png", "image/heic"],
      "min_resolution": {
        "width": 1024,
        "height": 768
      }
    },
    "contact": {
      "support_email": "brand-support@newpopsys.internal",
      "support_phone": "+1-555-0100"
    }
  }'::jsonb,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- Alternative INSERT with conflict handling on tenant_id + code
INSERT INTO brands (
  id,
  tenant_id,
  name,
  code,
  logo_url,
  settings_json,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000200'::UUID,
  '00000000-0000-0000-0000-000000000100'::UUID,  -- dev-tenant
  'Development Brand',
  'DEV',
  NULL,
  '{
    "theme": {
      "primary_color": "#1976D2",
      "secondary_color": "#424242"
    },
    "store_management": {
      "auto_assign_territory": false,
      "require_store_approval": true
    },
    "campaign_defaults": {
      "verification_mode": "STRICT",
      "auto_publish_orders": false
    },
    "photo_rules": {
      "max_file_size_mb": 10,
      "allowed_mime_types": ["image/jpeg", "image/png", "image/heic"],
      "min_resolution": {
        "width": 1024,
        "height": 768
      }
    },
    "contact": {
      "support_email": "brand-support@newpopsys.internal",
      "support_phone": "+1-555-0100"
    }
  }'::jsonb,
  NOW(),
  NOW()
)
ON CONFLICT (tenant_id, code) DO NOTHING;

-- ==============================================================================
-- USAGE NOTES
-- ==============================================================================

-- The default tenant and brand should be used for:
-- 1. Local development environment setup
-- 2. Integration testing
-- 3. Demo/sandbox environments
-- 4. Initial system bootstrapping

-- These records should NOT be used for:
-- 1. Production environments
-- 2. Customer-facing demos (create dedicated tenant/brand)
-- 3. Performance testing (use realistic data)

-- Development users can be assigned to the default tenant/brand:
/*
-- Example: Create dev user with BRAND_ADMIN role
INSERT INTO users (email, password_hash, full_name)
VALUES ('dev@example.com', '$2a$10$...', 'Dev User');

INSERT INTO memberships (user_id, tenant_id, brand_id, role)
VALUES (
  (SELECT id FROM users WHERE email = 'dev@example.com'),
  '00000000-0000-0000-0000-000000000100'::UUID,  -- dev-tenant
  '00000000-0000-0000-0000-000000000200'::UUID,  -- dev-brand
  'BRAND_ADMIN'
);
*/

-- ==============================================================================
-- VALIDATION QUERIES
-- ==============================================================================

-- Verify default tenant exists
/*
SELECT
  id,
  name,
  slug,
  subscription_tier,
  settings_json,
  created_at,
  deleted_at
FROM tenants
WHERE id = '00000000-0000-0000-0000-000000000100'::UUID
   OR slug = 'dev-tenant';
*/

-- Expected result:
-- id: 00000000-0000-0000-0000-000000000100
-- name: Development Tenant
-- slug: dev-tenant
-- subscription_tier: PILOT
-- deleted_at: NULL

-- Verify default brand exists
/*
SELECT
  b.id,
  b.name,
  b.code,
  b.tenant_id,
  t.name AS tenant_name,
  b.settings_json,
  b.created_at,
  b.deleted_at
FROM brands b
JOIN tenants t ON t.id = b.tenant_id
WHERE b.id = '00000000-0000-0000-0000-000000000200'::UUID;
*/

-- Expected result:
-- id: 00000000-0000-0000-0000-000000000200
-- name: Development Brand
-- code: DEV
-- tenant_id: 00000000-0000-0000-0000-000000000100
-- tenant_name: Development Tenant
-- deleted_at: NULL

-- ==============================================================================
-- CLEANUP (for testing environments)
-- ==============================================================================

-- To remove default tenant and brand (cascades to brands):
/*
DELETE FROM tenants WHERE id = '00000000-0000-0000-0000-000000000100'::UUID;
*/

-- To soft-delete default tenant and brand:
/*
UPDATE brands
SET deleted_at = NOW()
WHERE id = '00000000-0000-0000-0000-000000000200'::UUID;

UPDATE tenants
SET deleted_at = NOW()
WHERE id = '00000000-0000-0000-0000-000000000100'::UUID;
*/

-- ==============================================================================
-- END OF DEFAULT TENANT & BRAND SEED DATA
-- ==============================================================================
