-- ==============================================================================
-- FOUNDATIONAL SCHEMA DDL - NewPOPSys v1
-- ==============================================================================
-- This is the FIRST migration to run - creates extensions, enums, and core
-- shared foundation tables that all other modules depend on.
--
-- Dependencies: NONE (this is the root schema)
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- EXTENSIONS
-- ==============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ==============================================================================
-- ENUMERATIONS
-- ==============================================================================

-- Role Enum (RBAC - 8 roles from SUPP-003)
CREATE TYPE role_enum AS ENUM (
  'PLATFORM_ADMIN',       -- Full system + impersonation
  'PSP_ADMIN',            -- PSP tenant admin
  'PSP_OPS',              -- Production/fulfillment operator
  'BRAND_ADMIN',          -- Full brand access
  'CAMPAIGN_MANAGER',     -- Campaign-scoped brand user
  'REGIONAL_MANAGER',     -- Region-scoped oversight
  'STORE_MANAGER',        -- Full store privileges
  'STORE_OPERATOR'        -- Store execution only
);

-- Store Status
CREATE TYPE store_status_enum AS ENUM (
  'ACTIVE',
  'INACTIVE',
  'TEMP_CLOSED',
  'CLOSED'
);

-- Campaign Status
CREATE TYPE campaign_status_enum AS ENUM (
  'DRAFT',
  'SCHEDULED',
  'PUBLISHED',
  'COMPLETED',
  'CANCELLED',
  'ARCHIVED'
);

-- Verification Mode
CREATE TYPE verification_mode_enum AS ENUM (
  'STRICT',   -- Every photo requires review
  'FAST'      -- Auto-approve unless flagged
);

-- Store Assignment Status
CREATE TYPE store_assignment_status_enum AS ENUM (
  'ASSIGNED',
  'READY',
  'IN_PROGRESS',
  'SUBMITTED',
  'REWORK_REQUIRED',
  'COMPLETE',
  'REOPENED',
  'WAIVED'
);

-- Store Order Status
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

-- Order Type
CREATE TYPE order_type_enum AS ENUM (
  'INITIAL',
  'REORDER'
);

-- Shipment Status
CREATE TYPE shipment_status_enum AS ENUM (
  'LABEL_CREATED',
  'IN_TRANSIT',
  'DELIVERED',
  'EXCEPTION',
  'RETURNED'
);

-- Photo Review Status
CREATE TYPE photo_review_status_enum AS ENUM (
  'PENDING',
  'APPROVED',
  'REJECTED',
  'SUPERSEDED'
);

-- Issue Type
CREATE TYPE issue_type_enum AS ENUM (
  'MISSING',
  'DAMAGED',
  'INCORRECT',
  'PACKAGING'
);

-- Issue Request Status
CREATE TYPE issue_request_status_enum AS ENUM (
  'OPEN',
  'TRIAGED',
  'AWAITING_APPROVAL',
  'APPROVED',
  'IN_FULFILLMENT',
  'DENIED',
  'RESOLVED'
);

-- Rejection Reason
CREATE TYPE rejection_reason_enum AS ENUM (
  'BLURRY',
  'WRONG_ANGLE',
  'WRONG_PLACEMENT',
  'DAMAGED',
  'INSUFFICIENT_LIGHTING',
  'OBSTRUCTION',
  'OTHER'
);

-- Audit Actor Type
CREATE TYPE audit_actor_type_enum AS ENUM (
  'HUMAN',
  'SYSTEM',
  'INTEGRATION'
);

-- Notification Channel
CREATE TYPE notification_channel_enum AS ENUM (
  'EMAIL',
  'IN_APP',
  'PUSH'  -- Future
);

-- Export Format
CREATE TYPE export_format_enum AS ENUM (
  'CSV',
  'XLSX',
  'PDF',
  'JSON',
  'XML'
);

-- Export Job Status
CREATE TYPE export_job_status_enum AS ENUM (
  'PENDING',
  'PROCESSING',
  'COMPLETED',
  'FAILED',
  'EXPIRED'
);

-- Assignment Item Status
CREATE TYPE assignment_item_status_enum AS ENUM (
  'PLANNED',
  'ORDERED',
  'SHIPPED',
  'DELIVERED',
  'RECEIVED',
  'INSTALLED',
  'PROOF_SUBMITTED',
  'RETAKE_REQUIRED',
  'SATISFIED',
  'EXCEPTION'
);

-- Slot Verification Status
CREATE TYPE slot_verification_status_enum AS ENUM (
  'PENDING',
  'SATISFIED',
  'REWORK',
  'WAIVED'
);

-- ==============================================================================
-- COMMON FUNCTIONS
-- ==============================================================================

-- Trigger function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==============================================================================
-- CORE TABLES: TENANCY & IDENTITY
-- ==============================================================================

-- Tenants (PSP level)
CREATE TABLE tenants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  subscription_tier TEXT NOT NULL CHECK (subscription_tier IN ('PILOT', 'STANDARD', 'ENTERPRISE')),
  settings_json JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TRIGGER tenants_updated_at BEFORE UPDATE ON tenants
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE tenants IS 'Root multi-tenant entities (PSP organizations)';
COMMENT ON COLUMN tenants.slug IS 'URL-safe identifier for subdomain/routing';
COMMENT ON COLUMN tenants.subscription_tier IS 'PILOT, STANDARD, or ENTERPRISE billing tier';

-- Brands (belong to PSP tenants)
CREATE TABLE brands (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE RESTRICT,
  name TEXT NOT NULL,
  code TEXT NOT NULL,
  logo_url TEXT,
  settings_json JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  UNIQUE (tenant_id, code)
);

CREATE TRIGGER brands_updated_at BEFORE UPDATE ON brands
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_brands_tenant ON brands(tenant_id);

COMMENT ON TABLE brands IS 'Brand entities under PSP tenant umbrella';
COMMENT ON COLUMN brands.code IS 'Short brand code (e.g., G2G) unique within tenant';

-- Users (email-based authentication)
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  full_name TEXT NOT NULL,
  is_global_admin BOOLEAN DEFAULT FALSE,
  last_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TRIGGER users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;

COMMENT ON TABLE users IS 'Platform users with email+password authentication';
COMMENT ON COLUMN users.password_hash IS 'bcrypt hashed password';
COMMENT ON COLUMN users.is_global_admin IS 'Platform admin flag (v1 = always false)';

-- Memberships (users have roles within tenants/brands)
CREATE TABLE memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  brand_id UUID REFERENCES brands(id) ON DELETE CASCADE,
  role role_enum NOT NULL,
  region_scope_id UUID,  -- FK to regions (defined in module schema)
  store_scope_id UUID,   -- FK to stores (defined in module schema)
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  UNIQUE (user_id, tenant_id, brand_id, role)
);

CREATE TRIGGER memberships_updated_at BEFORE UPDATE ON memberships
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_memberships_user ON memberships(user_id);
CREATE INDEX idx_memberships_tenant ON memberships(tenant_id);
CREATE INDEX idx_memberships_brand ON memberships(brand_id);

COMMENT ON TABLE memberships IS 'User role assignments within tenant/brand context';
COMMENT ON COLUMN memberships.brand_id IS 'NULL for PSP staff, set for brand users';
COMMENT ON COLUMN memberships.region_scope_id IS 'Scope limiter for REGIONAL_MANAGER role';
COMMENT ON COLUMN memberships.store_scope_id IS 'Scope limiter for STORE_OPERATOR role';

-- API Keys (for integration users)
CREATE TABLE api_keys (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  key_hash TEXT NOT NULL,
  key_prefix TEXT NOT NULL,
  name TEXT NOT NULL,
  scopes TEXT[] DEFAULT '{}'::TEXT[],
  expires_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TRIGGER api_keys_updated_at BEFORE UPDATE ON api_keys
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_api_keys_tenant ON api_keys(tenant_id);
CREATE INDEX idx_api_keys_prefix ON api_keys(key_prefix);

COMMENT ON TABLE api_keys IS 'API keys for integration users (HMAC-signed)';
COMMENT ON COLUMN api_keys.key_hash IS 'SHA256 hash of the full API key';
COMMENT ON COLUMN api_keys.key_prefix IS 'First 8 characters for identification';
COMMENT ON COLUMN api_keys.scopes IS 'Array of permitted operations/resources';

-- ==============================================================================
-- AUDIT TABLES
-- ==============================================================================

-- Audit Events (immutable audit trail)
CREATE TABLE audit_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE RESTRICT,
  brand_id UUID REFERENCES brands(id) ON DELETE RESTRICT,
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
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_events_tenant_time ON audit_events(tenant_id, created_at DESC);
CREATE INDEX idx_audit_events_entity ON audit_events(entity_type, entity_id);
CREATE INDEX idx_audit_events_action ON audit_events(action);
CREATE INDEX idx_audit_events_actor_user ON audit_events(actor_user_id) WHERE actor_user_id IS NOT NULL;

COMMENT ON TABLE audit_events IS 'Immutable audit trail for all permissioned actions';
COMMENT ON COLUMN audit_events.action IS 'Dot-notation action (e.g., campaign.published)';
COMMENT ON COLUMN audit_events.entity_type IS 'Table/model name (e.g., Campaign)';
COMMENT ON COLUMN audit_events.before_json IS 'State snapshot before change';
COMMENT ON COLUMN audit_events.after_json IS 'State snapshot after change';

-- ==============================================================================
-- NOTIFICATION TABLES
-- ==============================================================================

-- Notification Preferences (user channel preferences)
CREATE TABLE notification_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  channel notification_channel_enum NOT NULL,
  event_type TEXT NOT NULL,
  enabled BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  UNIQUE (user_id, channel, event_type)
);

CREATE TRIGGER notification_preferences_updated_at BEFORE UPDATE ON notification_preferences
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_notification_preferences_user ON notification_preferences(user_id);

COMMENT ON TABLE notification_preferences IS 'Per-user channel+event notification preferences';
COMMENT ON COLUMN notification_preferences.event_type IS 'Event pattern (e.g., photo.rejected, shipment.delivered)';

-- Notifications (delivered messages)
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
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TRIGGER notifications_updated_at BEFORE UPDATE ON notifications
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_notifications_user ON notifications(user_id, created_at DESC);
CREATE INDEX idx_notifications_unread ON notifications(user_id) WHERE read_at IS NULL;
CREATE INDEX idx_notifications_event_type ON notifications(event_type);

COMMENT ON TABLE notifications IS 'Delivered notification messages per user';
COMMENT ON COLUMN notifications.subject IS 'Email subject or in-app title';
COMMENT ON COLUMN notifications.action_url IS 'Deep link to relevant resource';

-- ==============================================================================
-- WEBHOOK TABLES
-- ==============================================================================

-- Webhook Endpoints (registered webhook destinations)
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
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TRIGGER webhook_endpoints_updated_at BEFORE UPDATE ON webhook_endpoints
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_webhook_endpoints_tenant ON webhook_endpoints(tenant_id);
CREATE INDEX idx_webhook_endpoints_active ON webhook_endpoints(is_active) WHERE is_active = TRUE;

COMMENT ON TABLE webhook_endpoints IS 'Registered webhook destinations for event delivery';
COMMENT ON COLUMN webhook_endpoints.secret IS 'HMAC signing key for X-VG-Signature header';
COMMENT ON COLUMN webhook_endpoints.events IS 'Subscribed event types (e.g., campaign.published)';
COMMENT ON COLUMN webhook_endpoints.failure_count IS 'Consecutive failure count for circuit breaker';

-- Webhook Deliveries (delivery attempts and status)
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
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TRIGGER webhook_deliveries_updated_at BEFORE UPDATE ON webhook_deliveries
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_webhook_deliveries_endpoint ON webhook_deliveries(webhook_endpoint_id, created_at DESC);
CREATE INDEX idx_webhook_deliveries_retry ON webhook_deliveries(next_retry_at) WHERE next_retry_at IS NOT NULL;

COMMENT ON TABLE webhook_deliveries IS 'Webhook delivery attempts with retry tracking';
COMMENT ON COLUMN webhook_deliveries.status_code IS 'HTTP response code from destination';
COMMENT ON COLUMN webhook_deliveries.next_retry_at IS 'Scheduled retry timestamp (exponential backoff)';

-- ==============================================================================
-- EXPORT TABLES
-- ==============================================================================

-- Export Jobs (async export request tracking)
CREATE TABLE export_jobs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id UUID REFERENCES brands(id) ON DELETE SET NULL,
  campaign_id UUID,  -- FK to campaigns (defined in module schema)
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
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TRIGGER export_jobs_updated_at BEFORE UPDATE ON export_jobs
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_export_jobs_brand ON export_jobs(brand_id);
CREATE INDEX idx_export_jobs_campaign ON export_jobs(campaign_id);
CREATE INDEX idx_export_jobs_status ON export_jobs(status);
CREATE INDEX idx_export_jobs_user ON export_jobs(requested_by_user_id);
CREATE INDEX idx_export_jobs_expires ON export_jobs(expires_at) WHERE expires_at IS NOT NULL;

COMMENT ON TABLE export_jobs IS 'Async export job tracking with S3 output references';
COMMENT ON COLUMN export_jobs.export_type IS 'Export package type (e.g., campaign_summary, store_orders)';
COMMENT ON COLUMN export_jobs.parameters_json IS 'Filter criteria and export options';
COMMENT ON COLUMN export_jobs.expires_at IS 'Auto-delete timestamp for generated files';

-- ==============================================================================
-- END OF FOUNDATION SCHEMA
-- ==============================================================================
