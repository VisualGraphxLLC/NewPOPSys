-- ==============================================================================
-- FOREIGN KEY RELATIONSHIPS - Missing Tables & Cross-Cutting Modules
-- ==============================================================================
-- Module: Missing Tables (from gap analysis) + Cross-cutting (Notifications,
--         Webhooks, Exports, Audit)
-- Tables: store_change_verifications, store_id_aliases, notification_preferences,
--         notifications, webhook_endpoints, webhook_deliveries, export_jobs,
--         audit_events
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- STORE CHANGE VERIFICATIONS
-- ==============================================================================

-- Store change verification belongs to store
ALTER TABLE store_change_verifications
  ADD CONSTRAINT fk_store_change_verifications_store
  FOREIGN KEY (store_id)
  REFERENCES stores(id)
  ON DELETE CASCADE  -- Delete verifications when store deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_change_verifications_store ON store_change_verifications IS
  'Store change verification belongs to store; cascade delete when store deleted';

-- Store change verification may affect campaign
ALTER TABLE store_change_verifications
  ADD CONSTRAINT fk_store_change_verifications_campaign
  FOREIGN KEY (campaign_id)
  REFERENCES campaigns(id)
  ON DELETE SET NULL  -- Clear campaign if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_change_verifications_campaign ON store_change_verifications IS
  'Optional campaign affected by change; set to NULL if campaign deleted';

-- Store change verification requested by user
ALTER TABLE store_change_verifications
  ADD CONSTRAINT fk_store_change_verifications_requested_by
  FOREIGN KEY (requested_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve verification even if requester deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_change_verifications_requested_by ON store_change_verifications IS
  'User who requested change verification; set to NULL if user deleted';

-- Store change verification verified by user
ALTER TABLE store_change_verifications
  ADD CONSTRAINT fk_store_change_verifications_verified_by
  FOREIGN KEY (verified_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve verification even if verifier deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_change_verifications_verified_by ON store_change_verifications IS
  'User who verified change; set to NULL if user deleted';


-- ==============================================================================
-- STORE ID ALIASES
-- ==============================================================================

-- Store ID alias belongs to store
ALTER TABLE store_id_aliases
  ADD CONSTRAINT fk_store_id_aliases_store
  FOREIGN KEY (store_id)
  REFERENCES stores(id)
  ON DELETE CASCADE  -- Delete aliases when store deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_id_aliases_store ON store_id_aliases IS
  'Store ID alias belongs to store; cascade delete when store deleted';


-- ==============================================================================
-- NOTIFICATION PREFERENCES
-- ==============================================================================

-- Notification preference belongs to user
ALTER TABLE notification_preferences
  ADD CONSTRAINT fk_notification_preferences_user
  FOREIGN KEY (user_id)
  REFERENCES users(id)
  ON DELETE CASCADE  -- Delete preferences when user deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_notification_preferences_user ON notification_preferences IS
  'Notification preference belongs to user; cascade delete when user deleted';


-- ==============================================================================
-- NOTIFICATIONS
-- ==============================================================================

-- Notification belongs to user
ALTER TABLE notifications
  ADD CONSTRAINT fk_notifications_user
  FOREIGN KEY (user_id)
  REFERENCES users(id)
  ON DELETE CASCADE  -- Delete notifications when user deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_notifications_user ON notifications IS
  'Notification belongs to user; cascade delete when user deleted';


-- ==============================================================================
-- WEBHOOK ENDPOINTS
-- ==============================================================================

-- Webhook endpoint belongs to tenant
ALTER TABLE webhook_endpoints
  ADD CONSTRAINT fk_webhook_endpoints_tenant
  FOREIGN KEY (tenant_id)
  REFERENCES tenants(id)
  ON DELETE CASCADE  -- Delete endpoints when tenant deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_webhook_endpoints_tenant ON webhook_endpoints IS
  'Webhook endpoint belongs to tenant; cascade delete when tenant deleted';


-- ==============================================================================
-- WEBHOOK DELIVERIES
-- ==============================================================================

-- Webhook delivery belongs to endpoint
ALTER TABLE webhook_deliveries
  ADD CONSTRAINT fk_webhook_deliveries_endpoint
  FOREIGN KEY (webhook_endpoint_id)
  REFERENCES webhook_endpoints(id)
  ON DELETE CASCADE  -- Delete deliveries when endpoint deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_webhook_deliveries_endpoint ON webhook_deliveries IS
  'Webhook delivery belongs to endpoint; cascade delete when endpoint deleted';


-- ==============================================================================
-- EXPORT JOBS
-- ==============================================================================

-- Export job may be scoped to brand
ALTER TABLE export_jobs
  ADD CONSTRAINT fk_export_jobs_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE SET NULL  -- Preserve export job even if brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_export_jobs_brand ON export_jobs IS
  'Optional brand scope for export; set to NULL if brand deleted';

-- Export job may be scoped to campaign
ALTER TABLE export_jobs
  ADD CONSTRAINT fk_export_jobs_campaign
  FOREIGN KEY (campaign_id)
  REFERENCES campaigns(id)
  ON DELETE SET NULL  -- Preserve export job even if campaign deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_export_jobs_campaign ON export_jobs IS
  'Optional campaign scope for export; set to NULL if campaign deleted';

-- Export job requested by user
ALTER TABLE export_jobs
  ADD CONSTRAINT fk_export_jobs_user
  FOREIGN KEY (requested_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve export job even if user deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_export_jobs_user ON export_jobs IS
  'User who requested export; set to NULL if user deleted';


-- ==============================================================================
-- AUDIT EVENTS
-- ==============================================================================

-- Audit event belongs to tenant
ALTER TABLE audit_events
  ADD CONSTRAINT fk_audit_events_tenant
  FOREIGN KEY (tenant_id)
  REFERENCES tenants(id)
  ON DELETE RESTRICT  -- Cannot delete tenant with audit trail
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_audit_events_tenant ON audit_events IS
  'Audit event belongs to tenant; cannot delete tenant with audit history';

-- Audit event may be scoped to brand
ALTER TABLE audit_events
  ADD CONSTRAINT fk_audit_events_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE SET NULL  -- Preserve audit even if brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_audit_events_brand ON audit_events IS
  'Optional brand scope for audit event; set to NULL if brand deleted';

-- Audit event may have user actor
ALTER TABLE audit_events
  ADD CONSTRAINT fk_audit_events_actor_user
  FOREIGN KEY (actor_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve audit even if actor deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_audit_events_actor_user ON audit_events IS
  'Optional user actor; set to NULL if user deleted';

-- Audit event may have API key actor
ALTER TABLE audit_events
  ADD CONSTRAINT fk_audit_events_actor_api_key
  FOREIGN KEY (actor_api_key_id)
  REFERENCES api_keys(id)
  ON DELETE SET NULL  -- Preserve audit even if API key deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_audit_events_actor_api_key ON audit_events IS
  'Optional API key actor; set to NULL if API key deleted';


-- ==============================================================================
-- END OF MISSING TABLES & CROSS-CUTTING FOREIGN KEYS
-- ==============================================================================
