-- =====================================================================================
-- File: 07_idx_audit.sql
-- Description: Audit and reporting query indexes for NewPOPSys database
-- Created: 2025-12-19
-- Package: 5 - Index Optimization
-- =====================================================================================
-- Purpose: Indexes for audit trail queries, reporting, user activity tracking,
--          and compliance monitoring.
-- =====================================================================================

-- =============================================================================
-- AUDIT EVENTS QUERY INDEXES
-- =============================================================================

-- Audit events by tenant and time (already exists in 00_foundation_ddl.sql and brand_module_ddl.sql - SKIP)
-- CREATE INDEX idx_audit_events_tenant_time ON audit_events(tenant_id, created_at DESC) WHERE deleted_at IS NULL;

-- Audit events by entity (already exists - SKIP)
-- CREATE INDEX idx_audit_events_entity ON audit_events(entity_type, entity_id) WHERE deleted_at IS NULL;

-- Audit events by action (already exists in 00_foundation_ddl.sql - SKIP)
-- CREATE INDEX idx_audit_events_action ON audit_events(action) WHERE deleted_at IS NULL;

-- Audit events by actor user (already exists - SKIP)
-- CREATE INDEX idx_audit_events_actor_user ON audit_events(actor_user_id) WHERE actor_user_id IS NOT NULL AND deleted_at IS NULL;

-- Audit events by tenant, action, and time (composite for filtered audit logs)
CREATE INDEX IF NOT EXISTS idx_audit_events_tenant_action_time
  ON audit_events(tenant_id, action, created_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_audit_events_tenant_action_time IS
  'Find audit events for a tenant filtered by action type, sorted by time';

-- Audit events by brand and time (for brand-specific audit trails)
CREATE INDEX IF NOT EXISTS idx_audit_events_brand_time
  ON audit_events(brand_id, created_at DESC)
  WHERE brand_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_audit_events_brand_time IS
  'Find audit events for a specific brand, sorted by time';

-- Audit events by brand, action, and time
CREATE INDEX IF NOT EXISTS idx_audit_events_brand_action_time
  ON audit_events(brand_id, action, created_at DESC)
  WHERE brand_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_audit_events_brand_action_time IS
  'Find audit events for a brand filtered by action type';

-- Audit events by actor user and time (for user activity history)
CREATE INDEX IF NOT EXISTS idx_audit_events_actor_time
  ON audit_events(actor_user_id, created_at DESC)
  WHERE actor_user_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_audit_events_actor_time IS
  'Track all actions performed by a specific user, sorted chronologically';

-- Audit events by actor API key (for API key usage tracking)
CREATE INDEX IF NOT EXISTS idx_audit_events_api_key_time
  ON audit_events(actor_api_key_id, created_at DESC)
  WHERE actor_api_key_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_audit_events_api_key_time IS
  'Track all actions performed via a specific API key';

-- Audit events by actor type (for distinguishing user vs system vs API actions)
CREATE INDEX IF NOT EXISTS idx_audit_events_actor_type
  ON audit_events(actor_type, created_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_audit_events_actor_type IS
  'Find audit events by actor type (USER, API_KEY, SYSTEM)';

-- Audit events by entity type and ID (for entity-specific audit trail)
CREATE INDEX IF NOT EXISTS idx_audit_events_entity_type_id_time
  ON audit_events(entity_type, entity_id, created_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_audit_events_entity_type_id_time IS
  'Full audit trail for a specific entity (e.g., all changes to campaign #123)';

-- Audit events for sensitive actions (partial index)
CREATE INDEX IF NOT EXISTS idx_audit_events_sensitive_actions
  ON audit_events(tenant_id, created_at DESC)
  WHERE action IN ('DELETE', 'PUBLISH', 'APPROVE', 'DENY', 'CANCEL') AND deleted_at IS NULL;

COMMENT ON INDEX idx_audit_events_sensitive_actions IS
  'Track sensitive actions requiring elevated audit scrutiny';

-- Audit events by IP address (for security monitoring)
CREATE INDEX IF NOT EXISTS idx_audit_events_ip_address
  ON audit_events(ip_address, created_at DESC)
  WHERE ip_address IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_audit_events_ip_address IS
  'Track actions from a specific IP address (security investigation)';

-- Audit events metadata GIN index (for flexible querying of context data)
CREATE INDEX IF NOT EXISTS idx_audit_events_metadata_gin
  ON audit_events USING GIN (metadata)
  WHERE metadata IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_audit_events_metadata_gin IS
  'Query audit events by metadata fields (request details, context, etc.)';

-- Audit events changes GIN index (for before/after diff queries)
CREATE INDEX IF NOT EXISTS idx_audit_events_changes_gin
  ON audit_events USING GIN (changes)
  WHERE changes IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_audit_events_changes_gin IS
  'Query audit events by specific field changes (e.g., find all status changes)';

-- =============================================================================
-- NOTIFICATION EVENTS QUERY INDEXES
-- =============================================================================

-- Notifications by user (already exists in 00_foundation_ddl.sql and brand_module_ddl.sql - SKIP)
-- CREATE INDEX idx_notifications_user ON notifications(user_id, created_at DESC) WHERE deleted_at IS NULL;

-- Unread notifications by user (already exists - SKIP)
-- CREATE INDEX idx_notifications_unread ON notifications(user_id) WHERE read_at IS NULL AND deleted_at IS NULL;

-- Notifications by event type (already exists in 00_foundation_ddl.sql - SKIP)
-- CREATE INDEX idx_notifications_event_type ON notifications(event_type) WHERE deleted_at IS NULL;

-- Notifications by user, read status, and time (from 01_idx_lookup.sql - may be duplicate)
-- CREATE INDEX idx_notifications_user_read_status ON notifications(user_id, read_at, created_at DESC) WHERE deleted_at IS NULL;

-- Notifications by event type and time (for notification volume analysis)
CREATE INDEX IF NOT EXISTS idx_notifications_event_type_time
  ON notifications(event_type, created_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_notifications_event_type_time IS
  'Analyze notification volume by event type over time';

-- Notifications by channel (for channel-specific delivery tracking)
CREATE INDEX IF NOT EXISTS idx_notifications_channel
  ON notifications(channel, created_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_notifications_channel IS
  'Track notifications by delivery channel (IN_APP, EMAIL, SMS)';

-- Notifications by delivery status (for failed delivery tracking)
CREATE INDEX IF NOT EXISTS idx_notifications_delivery_status
  ON notifications(delivery_status, created_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_notifications_delivery_status IS
  'Monitor notification delivery success/failure rates';

-- Failed notifications (partial index for retry queue)
CREATE INDEX IF NOT EXISTS idx_notifications_failed
  ON notifications(created_at)
  WHERE delivery_status = 'FAILED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_notifications_failed IS
  'Find failed notifications for retry processing';

-- Notifications by entity reference (for entity-specific notification history)
CREATE INDEX IF NOT EXISTS idx_notifications_entity_ref
  ON notifications(entity_type, entity_id, created_at DESC)
  WHERE entity_type IS NOT NULL AND entity_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_notifications_entity_ref IS
  'Find all notifications related to a specific entity (e.g., all notifications for campaign #123)';

-- =============================================================================
-- NOTIFICATION PREFERENCES QUERY INDEXES
-- =============================================================================

-- Notification preferences by user (already exists - SKIP)
-- CREATE INDEX idx_notification_preferences_user ON notification_preferences(user_id) WHERE deleted_at IS NULL;

-- Notification preferences by user and event type (for preference lookups)
CREATE INDEX IF NOT EXISTS idx_notification_preferences_user_event
  ON notification_preferences(user_id, event_type)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_notification_preferences_user_event IS
  'Lookup notification preferences for a user by event type';

-- Notification preferences by event type (for default preference analysis)
CREATE INDEX IF NOT EXISTS idx_notification_preferences_event_type
  ON notification_preferences(event_type)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_notification_preferences_event_type IS
  'Analyze notification preference patterns by event type';

-- =============================================================================
-- EXPORT JOBS QUERY INDEXES
-- =============================================================================

-- Export jobs by brand (already exists - SKIP)
-- CREATE INDEX idx_export_jobs_brand ON export_jobs(brand_id) WHERE deleted_at IS NULL;

-- Export jobs by campaign (already exists - SKIP)
-- CREATE INDEX idx_export_jobs_campaign ON export_jobs(campaign_id) WHERE deleted_at IS NULL;

-- Export jobs by status (already exists - SKIP)
-- CREATE INDEX idx_export_jobs_status ON export_jobs(status) WHERE deleted_at IS NULL;

-- Export jobs by requesting user (already exists - SKIP)
-- CREATE INDEX idx_export_jobs_user ON export_jobs(requested_by_user_id) WHERE deleted_at IS NULL;

-- Export jobs by expiration (already exists in 00_foundation_ddl.sql - SKIP)
-- CREATE INDEX idx_export_jobs_expires ON export_jobs(expires_at) WHERE expires_at IS NOT NULL;

-- Export jobs by brand, status, and time
CREATE INDEX IF NOT EXISTS idx_export_jobs_brand_status_time
  ON export_jobs(brand_id, status, requested_at DESC)
  WHERE brand_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_export_jobs_brand_status_time IS
  'Find export jobs for a brand filtered by status, sorted by request time';

-- Export jobs by user and time (for user export history)
CREATE INDEX IF NOT EXISTS idx_export_jobs_user_time
  ON export_jobs(requested_by_user_id, requested_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_export_jobs_user_time IS
  'Track all export jobs requested by a specific user';

-- Pending export jobs (partial index for processing queue)
CREATE INDEX IF NOT EXISTS idx_export_jobs_pending
  ON export_jobs(requested_at)
  WHERE status = 'PENDING' AND deleted_at IS NULL;

COMMENT ON INDEX idx_export_jobs_pending IS
  'Find pending export jobs for processing queue';

-- Completed export jobs awaiting cleanup (partial index)
CREATE INDEX IF NOT EXISTS idx_export_jobs_expired
  ON export_jobs(expires_at)
  WHERE status = 'COMPLETED' AND expires_at < CURRENT_TIMESTAMP AND deleted_at IS NULL;

COMMENT ON INDEX idx_export_jobs_expired IS
  'Find expired export jobs for cleanup';

-- Export jobs by format (for format usage analysis)
CREATE INDEX IF NOT EXISTS idx_export_jobs_format
  ON export_jobs(format, requested_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_export_jobs_format IS
  'Analyze export job usage by format (CSV, EXCEL, JSON)';

-- Export jobs filters GIN index (for querying by export parameters)
CREATE INDEX IF NOT EXISTS idx_export_jobs_filters_gin
  ON export_jobs USING GIN (filters)
  WHERE filters IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_export_jobs_filters_gin IS
  'Query export jobs by filter criteria (date ranges, status filters, etc.)';

-- =============================================================================
-- SURVEY RESPONSES AUDIT INDEXES
-- =============================================================================

-- Store survey responses by assignment (already exists in brand_module_ddl.sql - SKIP)
-- CREATE INDEX idx_store_survey_responses_assignment ON store_survey_responses(store_assignment_id) WHERE deleted_at IS NULL;

-- Store survey responses by assignment and survey version
CREATE INDEX IF NOT EXISTS idx_store_survey_responses_assignment_survey
  ON store_survey_responses(store_assignment_id, survey_version_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_store_survey_responses_assignment_survey IS
  'Find survey responses for an assignment by survey version';

-- Store survey responses by submission time
CREATE INDEX IF NOT EXISTS idx_store_survey_responses_submitted_at
  ON store_survey_responses(submitted_at DESC)
  WHERE submitted_at IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_survey_responses_submitted_at IS
  'Find recently submitted survey responses';

-- Store survey responses data GIN index (for querying response content)
CREATE INDEX IF NOT EXISTS idx_store_survey_responses_data_gin
  ON store_survey_responses USING GIN (response_data)
  WHERE response_data IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_survey_responses_data_gin IS
  'Query survey responses by specific answer values or patterns';

-- =============================================================================
-- RESPONSE EDIT AUDIT INDEXES
-- (From 12_missing_tables.sql - these indexes already exist)
-- =============================================================================

-- Response edit audit indexes already defined in 12_missing_tables.sql:
-- - idx_response_edit_audit_response
-- - idx_response_edit_audit_actor
-- - idx_response_edit_audit_time

-- Additional index for response edits by role
CREATE INDEX IF NOT EXISTS idx_response_edit_audit_role
  ON response_edit_audit(actor_role, edited_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_response_edit_audit_role IS
  'Track survey response edits by actor role (for compliance monitoring)';

-- =============================================================================
-- CROSS-TABLE AUDIT & REPORTING QUERY PATTERNS
-- =============================================================================

-- Pattern 1: User Activity Audit Trail
-- Query: Track all actions performed by a user across all entities
-- Uses: idx_audit_events_actor_time + idx_audit_events_entity_type_id_time

-- Pattern 2: Entity Change History
-- Query: View complete change history for a specific entity
-- Uses: idx_audit_events_entity_type_id_time + idx_audit_events_changes_gin

-- Pattern 3: Security Investigation
-- Query: Track suspicious activity from an IP address or API key
-- Uses: idx_audit_events_ip_address + idx_audit_events_api_key_time

-- Pattern 4: Compliance Reporting
-- Query: Generate compliance reports for sensitive actions
-- Uses: idx_audit_events_sensitive_actions + idx_audit_events_tenant_action_time

-- Pattern 5: Notification Delivery Metrics
-- Query: Analyze notification delivery success rates by channel and event type
-- Uses: idx_notifications_delivery_status + idx_notifications_event_type_time

-- Pattern 6: Export Job Management
-- Query: Monitor export job queue and cleanup expired exports
-- Uses: idx_export_jobs_pending + idx_export_jobs_expired

-- Pattern 7: Survey Response Audit
-- Query: Track survey response submissions and subsequent edits
-- Uses: idx_store_survey_responses_submitted_at + idx_response_edit_audit_response

-- Pattern 8: User Notification History
-- Query: View all notifications sent to a user with delivery status
-- Uses: idx_notifications_user_read_status + idx_notifications_delivery_status

-- =============================================================================
-- PERFORMANCE NOTES
-- =============================================================================

-- 1. Audit indexes prioritize time-based queries with DESC ordering for recent-first access
-- 2. GIN indexes on JSONB columns enable flexible querying without schema changes
-- 3. Partial indexes for sensitive actions reduce index size while supporting compliance queries
-- 4. Actor-based indexes support both user activity tracking and security investigations
-- 5. Entity reference indexes enable complete audit trails for any business object
-- 6. Composite indexes ordered by: tenant/brand → filter → timestamp
-- 7. Status-based partial indexes optimize queue processing and cleanup operations
