-- ==============================================================================
-- SYSTEM USER SEED DATA - NewPOPSys v1
-- ==============================================================================
-- Creates a special system user account for automated actions and system processes.
-- This user appears in audit trails when actions are performed by the system
-- rather than by human users or API integrations.
--
-- Dependencies: 00_foundation_ddl.sql (users table must exist)
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- SYSTEM USER
-- ==============================================================================
-- Purpose: Special user account for system-initiated actions
-- Use Cases:
--   - Automated campaign status transitions
--   - System-generated orders
--   - Automated photo review workflows
--   - Background job operations
--   - Data cleanup/archival processes

-- Special UUID for system user (easy to identify in queries)
-- Format: 00000000-0000-0000-0000-000000000001

INSERT INTO users (
  id,
  email,
  password_hash,
  full_name,
  is_global_admin,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000001'::UUID,
  'system@newpopsys.internal',
  '$2a$10$SYSTEM_ACCOUNT_NO_PASSWORD_HASH_REQUIRED_FOR_THIS_ACCOUNT',  -- Invalid hash, cannot login
  'System',
  FALSE,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- Add comment to users table explaining system user
COMMENT ON COLUMN users.id IS 'Primary key; system user uses 00000000-0000-0000-0000-000000000001';

-- ==============================================================================
-- USAGE NOTES
-- ==============================================================================

-- The system user should be referenced in audit events when:
-- 1. actor_type = 'SYSTEM'
-- 2. actor_user_id = '00000000-0000-0000-0000-000000000001'
-- 3. actor_api_key_id IS NULL

-- Example audit event for system action:
/*
INSERT INTO audit_events (
  tenant_id,
  brand_id,
  actor_type,
  actor_user_id,
  actor_api_key_id,
  action,
  entity_type,
  entity_id,
  after_json,
  created_at
) VALUES (
  '...',  -- tenant_id
  '...',  -- brand_id
  'SYSTEM',
  '00000000-0000-0000-0000-000000000001'::UUID,  -- system user
  NULL,   -- no API key
  'campaign.auto_completed',
  'Campaign',
  '...',  -- campaign_id
  '{"status": "COMPLETED", "reason": "end_date_reached"}'::jsonb,
  NOW()
);
*/

-- The system user cannot:
-- - Login to the application (invalid password hash)
-- - Have memberships (no role assignments)
-- - Have API keys
-- - Be deleted (protected by application logic)

-- The system user is not assigned to any tenant or brand directly.
-- In multi-tenant contexts, the system user acts on behalf of the system
-- as a whole, with the specific tenant/brand context provided in the
-- audit event or action context.

-- ==============================================================================
-- VALIDATION QUERY
-- ==============================================================================

-- Verify system user exists with correct attributes
/*
SELECT
  id,
  email,
  full_name,
  is_global_admin,
  created_at,
  deleted_at,
  (id = '00000000-0000-0000-0000-000000000001'::UUID) AS is_system_user
FROM users
WHERE id = '00000000-0000-0000-0000-000000000001'::UUID;
*/

-- Expected result:
-- id: 00000000-0000-0000-0000-000000000001
-- email: system@newpopsys.internal
-- full_name: System
-- is_global_admin: false
-- deleted_at: NULL
-- is_system_user: true

-- ==============================================================================
-- END OF SYSTEM USER SEED DATA
-- ==============================================================================
