-- =====================================================================================
-- File: 08_idx_partial.sql
-- Description: Partial/filtered indexes for soft-delete and status patterns
-- Created: 2025-12-19
-- Package: 5 - Index Optimization
-- =====================================================================================
-- Purpose: Specialized partial indexes for common filtering patterns including
--          soft-delete queries, active record filtering, and status-specific operations.
--          These indexes significantly reduce size and improve query performance for
--          filtered queries that would otherwise scan full indexes.
-- =====================================================================================

-- =============================================================================
-- SOFT-DELETE PATTERN INDEXES
-- =============================================================================
-- Note: Most tables already have "WHERE deleted_at IS NULL" in their base indexes.
-- This section adds additional soft-delete optimizations for specific query patterns.

-- Active stores (store listings and hierarchy queries)
CREATE INDEX IF NOT EXISTS idx_active_stores
  ON stores(brand_id, status, region_id)
  WHERE deleted_at IS NULL AND status = 'ACTIVE';

COMMENT ON INDEX idx_active_stores IS
  'Efficiently find active stores for a brand (most common query pattern)';

-- Active stores by region (for regional operations)
CREATE INDEX IF NOT EXISTS idx_active_stores_region
  ON stores(region_id, district_id)
  WHERE deleted_at IS NULL AND status = 'ACTIVE';

COMMENT ON INDEX idx_active_stores_region IS
  'Find active stores within a region, organized by district';

-- Active stores by district (for district operations)
CREATE INDEX IF NOT EXISTS idx_active_stores_district
  ON stores(district_id, territory_id)
  WHERE deleted_at IS NULL AND status = 'ACTIVE';

COMMENT ON INDEX idx_active_stores_district IS
  'Find active stores within a district, organized by territory';

-- Inactive stores (for cleanup and audit)
CREATE INDEX IF NOT EXISTS idx_inactive_stores
  ON stores(brand_id, status, updated_at DESC)
  WHERE deleted_at IS NULL AND status IN ('INACTIVE', 'CLOSED', 'PENDING');

COMMENT ON INDEX idx_inactive_stores IS
  'Find inactive stores for audit and cleanup operations';

-- Active campaigns (campaign listings and dashboards)
CREATE INDEX IF NOT EXISTS idx_active_campaigns
  ON campaigns(brand_id, start_date, end_date)
  WHERE deleted_at IS NULL AND status IN ('PUBLISHED', 'IN_PROGRESS');

COMMENT ON INDEX idx_active_campaigns IS
  'Find currently active campaigns for a brand (excludes DRAFT and ARCHIVED)';

-- Published campaigns (for campaign selection)
CREATE INDEX IF NOT EXISTS idx_published_campaigns
  ON campaigns(brand_id, published_at DESC)
  WHERE deleted_at IS NULL AND status = 'PUBLISHED';

COMMENT ON INDEX idx_published_campaigns IS
  'Find published campaigns, sorted by publish date';

-- Draft campaigns (for author workflows)
CREATE INDEX IF NOT EXISTS idx_draft_campaigns
  ON campaigns(brand_id, created_at DESC)
  WHERE deleted_at IS NULL AND status = 'DRAFT';

COMMENT ON INDEX idx_draft_campaigns IS
  'Find draft campaigns for editing and completion';

-- Archived campaigns (exclude from default listings)
CREATE INDEX IF NOT EXISTS idx_archived_campaigns
  ON campaigns(brand_id, archived_at DESC)
  WHERE deleted_at IS NULL AND status = 'ARCHIVED';

COMMENT ON INDEX idx_archived_campaigns IS
  'Access archived campaigns (excluded from active listings)';

-- Active regions (for hierarchy navigation)
CREATE INDEX IF NOT EXISTS idx_active_regions
  ON regions(brand_id, parent_region_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_active_regions IS
  'Navigate active regions in hierarchy (soft-delete filter)';

-- Active districts (for hierarchy navigation)
CREATE INDEX IF NOT EXISTS idx_active_districts
  ON districts(brand_id, region_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_active_districts IS
  'Navigate active districts in hierarchy (soft-delete filter)';

-- Active territories (for hierarchy navigation)
CREATE INDEX IF NOT EXISTS idx_active_territories
  ON territories(brand_id, region_id, district_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_active_territories IS
  'Navigate active territories in hierarchy (soft-delete filter)';

-- Active store groups (for group management)
CREATE INDEX IF NOT EXISTS idx_active_store_groups
  ON store_groups(brand_id, name)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_active_store_groups IS
  'Find active store groups by name (soft-delete filter)';

-- Active store group memberships (for group member queries)
CREATE INDEX IF NOT EXISTS idx_active_store_group_members
  ON store_group_memberships(store_group_id, store_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_active_store_group_members IS
  'Find active store memberships in a group (soft-delete filter)';

-- =============================================================================
-- PHOTO REVIEW STATUS PATTERN INDEXES
-- =============================================================================

-- Pending photos (review queue - most critical)
-- Already defined in 05_idx_photos.sql - SKIP
-- CREATE INDEX idx_photo_uploads_pending_review ON photo_uploads(uploaded_at) WHERE review_status = 'PENDING' AND deleted_at IS NULL;

-- Pending photos by assignment (for assignment-specific review)
CREATE INDEX IF NOT EXISTS idx_pending_photos_assignment
  ON photo_uploads(store_assignment_id, uploaded_at)
  WHERE review_status = 'PENDING' AND deleted_at IS NULL;

COMMENT ON INDEX idx_pending_photos_assignment IS
  'Find pending photos for a specific assignment (assignment review workflow)';

-- Rejected photos requiring retake
CREATE INDEX IF NOT EXISTS idx_rejected_photos_no_retake
  ON photo_uploads(store_assignment_id, uploaded_at DESC)
  WHERE review_status = 'REJECTED'
    AND deleted_at IS NULL
    AND id NOT IN (SELECT photo_upload_id FROM retake_requests WHERE deleted_at IS NULL);

COMMENT ON INDEX idx_rejected_photos_no_retake IS
  'Find rejected photos without retake requests (gap detection)';

-- Approved photos (for verification status computation)
CREATE INDEX IF NOT EXISTS idx_approved_photos_assignment
  ON photo_uploads(store_assignment_id, COUNT(*))
  WHERE review_status = 'APPROVED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_approved_photos_assignment IS
  'Count approved photos per assignment (verification status computation)';

-- =============================================================================
-- ASSIGNMENT STATUS PATTERN INDEXES
-- =============================================================================

-- Ready assignments (execution queue)
-- Already defined in 03_idx_campaigns.sql - SKIP
-- CREATE INDEX idx_store_assignments_ready ON store_assignments(campaign_id, created_at) WHERE status = 'READY' AND deleted_at IS NULL;

-- In-progress assignments (active work tracking)
-- Already defined in 03_idx_campaigns.sql - SKIP
-- CREATE INDEX idx_store_assignments_in_progress ON store_assignments(campaign_id, updated_at DESC) WHERE status = 'IN_PROGRESS' AND deleted_at IS NULL;

-- Submitted assignments (review queue)
-- Already defined in 03_idx_campaigns.sql - SKIP
-- CREATE INDEX idx_store_assignments_submitted ON store_assignments(campaign_id, updated_at DESC) WHERE status = 'SUBMITTED' AND deleted_at IS NULL;

-- Blocked assignments (exception management)
-- Already defined in 03_idx_campaigns.sql - SKIP
-- CREATE INDEX idx_store_assignments_blocked ON store_assignments(campaign_id, updated_at DESC) WHERE status = 'BLOCKED' AND deleted_at IS NULL;

-- Completed assignments (for reporting)
CREATE INDEX IF NOT EXISTS idx_completed_assignments
  ON store_assignments(campaign_id, completed_at DESC)
  WHERE status = 'COMPLETE' AND deleted_at IS NULL;

COMMENT ON INDEX idx_completed_assignments IS
  'Find completed assignments for a campaign, sorted by completion time';

-- Reopened assignments (for rework tracking)
CREATE INDEX IF NOT EXISTS idx_reopened_assignments
  ON store_assignments(campaign_id, reopened_at DESC)
  WHERE status = 'REOPENED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_reopened_assignments IS
  'Find reopened assignments requiring rework';

-- =============================================================================
-- ORDER STATUS PATTERN INDEXES
-- =============================================================================

-- Pending orders (PSP integration queue)
-- Already defined in 04_idx_fulfillment.sql - SKIP
-- CREATE INDEX idx_store_orders_pending_ack ON store_orders(campaign_id, created_at) WHERE status = 'PENDING' AND deleted_at IS NULL;

-- Acknowledged orders (awaiting shipment)
-- Already defined in 04_idx_fulfillment.sql - SKIP
-- CREATE INDEX idx_store_orders_acknowledged ON store_orders(campaign_id, acknowledged_at DESC) WHERE status = 'ACKNOWLEDGED' AND deleted_at IS NULL;

-- Shipped orders (in-transit tracking)
CREATE INDEX IF NOT EXISTS idx_shipped_orders
  ON store_orders(campaign_id, updated_at DESC)
  WHERE status IN ('PARTIALLY_SHIPPED', 'SHIPPED') AND deleted_at IS NULL;

COMMENT ON INDEX idx_shipped_orders IS
  'Find orders that have been shipped (partial or complete)';

-- Delivered orders (receipt verification)
CREATE INDEX IF NOT EXISTS idx_delivered_orders
  ON store_orders(campaign_id, updated_at DESC)
  WHERE status IN ('PARTIALLY_DELIVERED', 'DELIVERED') AND deleted_at IS NULL;

COMMENT ON INDEX idx_delivered_orders IS
  'Find delivered orders awaiting receipt verification';

-- Orders with exceptions (issue management)
CREATE INDEX IF NOT EXISTS idx_orders_with_exceptions
  ON store_orders(campaign_id, updated_at DESC)
  WHERE status = 'EXCEPTION' AND deleted_at IS NULL;

COMMENT ON INDEX idx_orders_with_exceptions IS
  'Find orders with fulfillment exceptions requiring intervention';

-- =============================================================================
-- SHIPMENT STATUS PATTERN INDEXES
-- =============================================================================

-- In-transit shipments (active tracking)
-- Already defined in 04_idx_fulfillment.sql - SKIP
-- CREATE INDEX idx_shipments_in_transit ON shipments(shipped_at DESC) WHERE status = 'IN_TRANSIT' AND deleted_at IS NULL;

-- Shipments with exceptions (exception handling)
-- Already defined in 04_idx_fulfillment.sql - SKIP
-- CREATE INDEX idx_shipments_exceptions ON shipments(updated_at DESC) WHERE status = 'EXCEPTION' AND deleted_at IS NULL;

-- Delivered shipments pending receipt (verification queue)
CREATE INDEX IF NOT EXISTS idx_delivered_shipments_pending_receipt
  ON shipments(store_order_id, delivered_at DESC)
  WHERE status = 'DELIVERED'
    AND deleted_at IS NULL
    AND store_order_id NOT IN (
      SELECT DISTINCT shipment_id
      FROM receive_verifications
      WHERE deleted_at IS NULL
    );

COMMENT ON INDEX idx_delivered_shipments_pending_receipt IS
  'Find delivered shipments without receive verifications';

-- =============================================================================
-- ISSUE STATUS PATTERN INDEXES
-- =============================================================================

-- Open issues (triage queue)
-- Already defined in 06_idx_issues.sql - SKIP
-- CREATE INDEX idx_issue_requests_open ON issue_requests(submitted_at) WHERE status = 'OPEN' AND deleted_at IS NULL;

-- Triaged issues (approval queue)
-- Already defined in 06_idx_issues.sql - SKIP
-- CREATE INDEX idx_issue_requests_awaiting_approval ON issue_requests(triaged_at DESC) WHERE status = 'AWAITING_APPROVAL' AND deleted_at IS NULL;

-- Approved issues (reorder queue)
-- Already defined in 06_idx_issues.sql - SKIP
-- CREATE INDEX idx_issue_requests_approved ON issue_requests(approved_at DESC) WHERE status = 'APPROVED' AND deleted_at IS NULL;

-- High-priority issues (escalation queue)
CREATE INDEX IF NOT EXISTS idx_high_priority_issues
  ON issue_requests(submitted_at)
  WHERE priority = 'HIGH' AND status IN ('OPEN', 'TRIAGED') AND deleted_at IS NULL;

COMMENT ON INDEX idx_high_priority_issues IS
  'Find high-priority issues requiring immediate attention';

-- Critical issues (urgent escalation)
CREATE INDEX IF NOT EXISTS idx_critical_issues
  ON issue_requests(submitted_at)
  WHERE priority = 'CRITICAL' AND status IN ('OPEN', 'TRIAGED', 'AWAITING_APPROVAL') AND deleted_at IS NULL;

COMMENT ON INDEX idx_critical_issues IS
  'Find critical issues requiring urgent escalation';

-- =============================================================================
-- NOTIFICATION PATTERN INDEXES
-- =============================================================================

-- Unread notifications (user inbox)
-- Already exists in brand_module_ddl.sql and 00_foundation_ddl.sql - SKIP
-- CREATE INDEX idx_notifications_unread ON notifications(user_id, read_at) WHERE deleted_at IS NULL AND read_at IS NULL;

-- Failed notifications (retry queue)
-- Already defined in 07_idx_audit.sql - SKIP
-- CREATE INDEX idx_notifications_failed ON notifications(created_at) WHERE delivery_status = 'FAILED' AND deleted_at IS NULL;

-- Pending notifications (delivery queue)
CREATE INDEX IF NOT EXISTS idx_pending_notifications
  ON notifications(created_at)
  WHERE delivery_status = 'PENDING' AND deleted_at IS NULL;

COMMENT ON INDEX idx_pending_notifications IS
  'Find notifications pending delivery';

-- =============================================================================
-- WEBHOOK PATTERN INDEXES
-- =============================================================================

-- Active webhook endpoints (event delivery)
-- Already exists in 00_foundation_ddl.sql and brand_module_ddl.sql - enhanced
CREATE INDEX IF NOT EXISTS idx_active_webhooks_by_event
  ON webhook_endpoints(tenant_id, event_types)
  WHERE is_active = TRUE AND deleted_at IS NULL;

COMMENT ON INDEX idx_active_webhooks_by_event IS
  'Find active webhook endpoints for event delivery';

-- Failed webhook deliveries (retry queue)
CREATE INDEX IF NOT EXISTS idx_failed_webhook_deliveries
  ON webhook_deliveries(next_retry_at)
  WHERE status_code >= 400 AND retry_count < max_retries AND deleted_at IS NULL;

COMMENT ON INDEX idx_failed_webhook_deliveries IS
  'Find failed webhook deliveries for retry processing';

-- =============================================================================
-- EXPORT JOB PATTERN INDEXES
-- =============================================================================

-- Pending exports (processing queue)
-- Already defined in 07_idx_audit.sql - SKIP
-- CREATE INDEX idx_export_jobs_pending ON export_jobs(requested_at) WHERE status = 'PENDING' AND deleted_at IS NULL;

-- Processing exports (monitor long-running jobs)
CREATE INDEX IF NOT EXISTS idx_processing_exports
  ON export_jobs(started_at)
  WHERE status = 'PROCESSING' AND deleted_at IS NULL;

COMMENT ON INDEX idx_processing_exports IS
  'Monitor currently processing export jobs';

-- Expired exports (cleanup queue)
-- Already defined in 07_idx_audit.sql - SKIP
-- CREATE INDEX idx_export_jobs_expired ON export_jobs(expires_at) WHERE status = 'COMPLETED' AND expires_at < CURRENT_TIMESTAMP AND deleted_at IS NULL;

-- =============================================================================
-- API KEY PATTERN INDEXES
-- =============================================================================

-- Active API keys (already defined in 01_idx_lookup.sql - SKIP)
-- CREATE INDEX idx_api_keys_tenant_active ON api_keys(tenant_id, created_at DESC) WHERE deleted_at IS NULL AND revoked_at IS NULL AND (expires_at IS NULL OR expires_at > CURRENT_TIMESTAMP);

-- Revoked API keys (for audit)
CREATE INDEX IF NOT EXISTS idx_revoked_api_keys
  ON api_keys(tenant_id, revoked_at DESC)
  WHERE revoked_at IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_revoked_api_keys IS
  'Find revoked API keys for audit and security analysis';

-- Expired API keys (for cleanup)
CREATE INDEX IF NOT EXISTS idx_expired_api_keys
  ON api_keys(expires_at)
  WHERE expires_at IS NOT NULL AND expires_at < CURRENT_TIMESTAMP AND deleted_at IS NULL;

COMMENT ON INDEX idx_expired_api_keys IS
  'Find expired API keys for cleanup';

-- Unused API keys (for cleanup and security)
CREATE INDEX IF NOT EXISTS idx_unused_api_keys
  ON api_keys(created_at DESC)
  WHERE last_used_at IS NULL
    AND created_at < (CURRENT_TIMESTAMP - INTERVAL '90 days')
    AND deleted_at IS NULL;

COMMENT ON INDEX idx_unused_api_keys IS
  'Find API keys created over 90 days ago that have never been used';

-- =============================================================================
-- SURVEY PATTERN INDEXES
-- =============================================================================

-- Active survey templates (for template selection)
CREATE INDEX IF NOT EXISTS idx_active_survey_templates
  ON survey_templates(brand_id, updated_at DESC)
  WHERE deleted_at IS NULL AND is_active = TRUE;

COMMENT ON INDEX idx_active_survey_templates IS
  'Find active survey templates for a brand';

-- Current survey versions (for version selection)
CREATE INDEX IF NOT EXISTS idx_current_survey_versions
  ON survey_versions(survey_template_id, version_number DESC)
  WHERE deleted_at IS NULL AND is_active = TRUE;

COMMENT ON INDEX idx_current_survey_versions IS
  'Find active survey versions for a template, sorted by version number';

-- =============================================================================
-- LAYOUT PATTERN INDEXES
-- =============================================================================

-- Current store layouts (for layout selection)
CREATE INDEX IF NOT EXISTS idx_current_store_layouts
  ON store_layouts(store_id, version DESC)
  WHERE is_current = TRUE AND deleted_at IS NULL;

COMMENT ON INDEX idx_current_store_layouts IS
  'Find the current layout version for a store';

-- Active location slots (for slot management)
CREATE INDEX IF NOT EXISTS idx_active_location_slots
  ON location_slots(store_layout_id, name)
  WHERE is_active = TRUE AND deleted_at IS NULL;

COMMENT ON INDEX idx_active_location_slots IS
  'Find active location slots in a store layout';

-- =============================================================================
-- PERFORMANCE BENEFITS
-- =============================================================================

-- Partial indexes provide significant benefits:
-- 1. Smaller index size (only indexes matching rows)
-- 2. Faster index scans (fewer entries to traverse)
-- 3. Reduced maintenance overhead (fewer index updates)
-- 4. More efficient query plans (better selectivity estimates)
-- 5. Lower memory footprint (smaller indexes stay in cache)

-- Typical size reduction: 50-95% depending on filter selectivity
-- Example: idx_active_stores vs full stores(brand_id, status, region_id)
--   - Full index: ~100% of table rows
--   - Partial index: ~10-20% of table rows (only ACTIVE stores)
--   - Space savings: 80-90%

-- =============================================================================
-- MAINTENANCE NOTES
-- =============================================================================

-- 1. Partial indexes require predicate matching in queries
--    - Query must include WHERE clause matching index predicate
--    - Example: WHERE status = 'ACTIVE' matches idx_active_stores
--
-- 2. Monitor index usage with pg_stat_user_indexes
--    - Remove unused partial indexes to reduce maintenance overhead
--
-- 3. Consider creating partial indexes for:
--    - High-selectivity filters (status, boolean flags)
--    - Temporal queries (recent records, active periods)
--    - Workflow states (queues, pending items)
--
-- 4. Avoid creating partial indexes for:
--    - Low-selectivity filters (most rows match)
--    - Rarely-used query patterns
--    - Conditions that change frequently
