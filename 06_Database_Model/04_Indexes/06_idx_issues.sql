-- =====================================================================================
-- File: 06_idx_issues.sql
-- Description: Issue tracking and resolution indexes for NewPOPSys database
-- Created: 2025-12-19
-- Package: 5 - Index Optimization
-- =====================================================================================
-- Purpose: Indexes for issue request management, issue lines tracking, reorder processing,
--          and issue resolution workflows.
-- =====================================================================================

-- =============================================================================
-- ISSUE REQUESTS QUERY INDEXES
-- =============================================================================

-- Issue requests by store assignment (already exists in brand_module_ddl.sql and psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_issue_requests_assignment ON issue_requests(store_assignment_id) WHERE deleted_at IS NULL;

-- Issue requests by status (already exists - SKIP)
-- CREATE INDEX idx_issue_requests_status ON issue_requests(status) WHERE deleted_at IS NULL;

-- Issue requests by type (already exists in psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_issue_requests_type ON issue_requests(type) WHERE deleted_at IS NULL;

-- Issue requests by assignment and status (composite for filtered queries)
CREATE INDEX IF NOT EXISTS idx_issue_requests_assignment_status
  ON issue_requests(store_assignment_id, status, submitted_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_assignment_status IS
  'Find issue requests for an assignment filtered by status, sorted by submission time';

-- Issue requests by assignment and type (for type-specific queries)
CREATE INDEX IF NOT EXISTS idx_issue_requests_assignment_type
  ON issue_requests(store_assignment_id, type)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_assignment_type IS
  'Find issue requests for an assignment filtered by type (MISSING, DAMAGED, etc.)';

-- Open issue requests (partial index for active issue queue)
CREATE INDEX IF NOT EXISTS idx_issue_requests_open
  ON issue_requests(submitted_at)
  WHERE status = 'OPEN' AND deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_open IS
  'Find all open issue requests awaiting triage, sorted by submission time';

-- Triaged issue requests awaiting approval (partial index)
CREATE INDEX IF NOT EXISTS idx_issue_requests_awaiting_approval
  ON issue_requests(triaged_at DESC)
  WHERE status = 'AWAITING_APPROVAL' AND deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_awaiting_approval IS
  'Find triaged issue requests awaiting approval decision';

-- Approved issue requests (partial index for reorder generation)
CREATE INDEX IF NOT EXISTS idx_issue_requests_approved
  ON issue_requests(approved_at DESC)
  WHERE status = 'APPROVED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_approved IS
  'Find approved issue requests for reorder generation';

-- Issue requests with priority (already exists in 13_missing_fields.sql - SKIP)
-- CREATE INDEX idx_issue_requests_priority ON issue_requests(priority, status) WHERE deleted_at IS NULL;

-- Issue requests by priority and status (for prioritized queue)
CREATE INDEX IF NOT EXISTS idx_issue_requests_priority_status_time
  ON issue_requests(priority DESC, status, submitted_at)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_priority_status_time IS
  'Priority queue: find issues by priority, status, and submission time (high priority first)';

-- Issue requests by submitter (for user activity tracking)
CREATE INDEX IF NOT EXISTS idx_issue_requests_submitter_time
  ON issue_requests(submitted_by_user_id, submitted_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_submitter_time IS
  'Track issue requests submitted by a specific user';

-- Issue requests by reviewer (for reviewer workload tracking)
CREATE INDEX IF NOT EXISTS idx_issue_requests_reviewer_time
  ON issue_requests(reviewed_by_user_id, reviewed_at DESC)
  WHERE reviewed_by_user_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_reviewer_time IS
  'Track issue requests reviewed by a specific user';

-- Issue requests by evidence photo (for photo-linked issues)
CREATE INDEX IF NOT EXISTS idx_issue_requests_evidence_photo
  ON issue_requests(evidence_photo_id)
  WHERE evidence_photo_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_evidence_photo IS
  'Find issue requests linked to a specific evidence photo';

-- Denied issue requests (partial index for denial analysis)
CREATE INDEX IF NOT EXISTS idx_issue_requests_denied
  ON issue_requests(denied_at DESC)
  WHERE status = 'DENIED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_denied IS
  'Find denied issue requests for analysis and reporting';

-- Resolved issue requests (partial index)
CREATE INDEX IF NOT EXISTS idx_issue_requests_resolved
  ON issue_requests(resolved_at DESC)
  WHERE status = 'RESOLVED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_resolved IS
  'Find resolved issue requests, sorted by resolution time';

-- Overdue issue requests (for escalation)
CREATE INDEX IF NOT EXISTS idx_issue_requests_overdue
  ON issue_requests(submitted_at)
  WHERE status IN ('OPEN', 'TRIAGED', 'AWAITING_APPROVAL')
    AND submitted_at < (CURRENT_TIMESTAMP - INTERVAL '48 hours')
    AND deleted_at IS NULL;

COMMENT ON INDEX idx_issue_requests_overdue IS
  'Find issue requests pending for more than 48 hours requiring escalation';

-- =============================================================================
-- ISSUE LINES QUERY INDEXES
-- =============================================================================

-- Issue lines by issue request (already exists in brand_module_ddl.sql and psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_issue_lines_request ON issue_lines(issue_request_id) WHERE deleted_at IS NULL;

-- Issue lines by kit item (already exists in psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_issue_lines_kit_item ON issue_lines(kit_item_id) WHERE deleted_at IS NULL;

-- Issue lines by request and kit item (composite for line lookup)
CREATE INDEX IF NOT EXISTS idx_issue_lines_request_kit_item
  ON issue_lines(issue_request_id, kit_item_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_issue_lines_request_kit_item IS
  'Find specific issue lines for a request by kit item';

-- Issue lines by kit item and quantity (for inventory impact analysis)
CREATE INDEX IF NOT EXISTS idx_issue_lines_kit_item_qty
  ON issue_lines(kit_item_id, affected_qty DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_issue_lines_kit_item_qty IS
  'Analyze issue impact by kit item across all requests (e.g., most frequently damaged items)';

-- Issue lines with high quantities (for quality alerts)
CREATE INDEX IF NOT EXISTS idx_issue_lines_high_qty
  ON issue_lines(issue_request_id, affected_qty DESC)
  WHERE affected_qty >= 5 AND deleted_at IS NULL;

COMMENT ON INDEX idx_issue_lines_high_qty IS
  'Find issue lines with high affected quantities (potential quality problems)';

-- =============================================================================
-- REORDERS QUERY INDEXES
-- =============================================================================

-- Reorders by issue request (already exists in brand_module_ddl.sql and psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_reorders_issue ON reorders(issue_request_id) WHERE deleted_at IS NULL;

-- Reorders by store order (already exists - SKIP)
-- CREATE INDEX idx_reorders_order ON reorders(store_order_id) WHERE deleted_at IS NULL;

-- Reorders by status (already exists in psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_reorders_status ON reorders(status) WHERE deleted_at IS NULL;

-- Pending reorders (already exists in 04_idx_fulfillment.sql - may be duplicate)
-- CREATE INDEX idx_reorders_pending ON reorders(created_at DESC) WHERE status = 'PENDING' AND deleted_at IS NULL;

-- Reorders by issue and order (composite for linking issue to fulfillment)
CREATE INDEX IF NOT EXISTS idx_reorders_issue_order
  ON reorders(issue_request_id, store_order_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_reorders_issue_order IS
  'Link reorders to their issue request and fulfillment order';

-- Reorders by status and time (for reorder processing queue)
CREATE INDEX IF NOT EXISTS idx_reorders_status_time
  ON reorders(status, created_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_reorders_status_time IS
  'Process reorders by status in chronological order';

-- Fulfilled reorders (partial index)
CREATE INDEX IF NOT EXISTS idx_reorders_fulfilled
  ON reorders(fulfilled_at DESC)
  WHERE status = 'FULFILLED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_reorders_fulfilled IS
  'Find fulfilled reorders, sorted by fulfillment time';

-- Cancelled reorders (partial index)
CREATE INDEX IF NOT EXISTS idx_reorders_cancelled
  ON reorders(cancelled_at DESC)
  WHERE status = 'CANCELLED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_reorders_cancelled IS
  'Find cancelled reorders for analysis';

-- =============================================================================
-- STORE CHANGE VERIFICATIONS QUERY INDEXES
-- (From 12_missing_tables.sql - these indexes already exist)
-- =============================================================================

-- Store change verifications indexes already defined in 12_missing_tables.sql:
-- - idx_store_change_verifications_store
-- - idx_store_change_verifications_campaign
-- - idx_store_change_verifications_status
-- - idx_store_change_verifications_requested

-- Additional index for pending verifications by campaign
CREATE INDEX IF NOT EXISTS idx_store_change_verifications_campaign_pending
  ON store_change_verifications(campaign_id, requested_at)
  WHERE status = 'PENDING' AND campaign_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_change_verifications_campaign_pending IS
  'Find pending store change verifications for a specific campaign';

-- Store change verifications by verifier
CREATE INDEX IF NOT EXISTS idx_store_change_verifications_verifier
  ON store_change_verifications(verified_by_user_id, verified_at DESC)
  WHERE verified_by_user_id IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_change_verifications_verifier IS
  'Track store change verifications performed by a specific user';

-- Store change verifications changed fields GIN index
CREATE INDEX IF NOT EXISTS idx_store_change_verifications_fields_gin
  ON store_change_verifications USING GIN (changed_fields_json)
  WHERE changed_fields_json IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_store_change_verifications_fields_gin IS
  'Query store change verifications by specific changed fields';

-- =============================================================================
-- CROSS-TABLE ISSUE WORKFLOW QUERY PATTERNS
-- =============================================================================

-- Pattern 1: Issue Request Triage Queue
-- Query: Find all open issues, prioritized by priority and submission time
-- Uses: idx_issue_requests_priority_status_time

-- Pattern 2: Issue Resolution Workflow
-- Query: Track an issue from submission through approval to reorder fulfillment
-- Uses: idx_issue_requests_assignment_status + idx_reorders_issue + idx_reorders_issue_order

-- Pattern 3: Reorder Generation
-- Query: Find all approved issues that need reorders created
-- Uses: idx_issue_requests_approved + idx_reorders_issue (check if reorder exists)

-- Pattern 4: Quality Analytics
-- Query: Identify most frequently damaged/missing items across all issues
-- Uses: idx_issue_lines_kit_item_qty + idx_issue_requests_type

-- Pattern 5: Reviewer Performance Metrics
-- Query: Track issue triage and approval performance by reviewer
-- Uses: idx_issue_requests_reviewer_time + idx_issue_requests_priority_status_time

-- Pattern 6: Assignment Issue Summary
-- Query: Find all issues, reorders, and resolutions for a store assignment
-- Uses: idx_issue_requests_assignment_status + idx_issue_lines_request + idx_reorders_issue

-- Pattern 7: Overdue Issue Escalation
-- Query: Find and escalate issues pending beyond SLA
-- Uses: idx_issue_requests_overdue

-- Pattern 8: Store Change Impact Analysis
-- Query: Track store changes during active campaigns requiring verification
-- Uses: idx_store_change_verifications_campaign_pending + idx_store_change_verifications_fields_gin

-- =============================================================================
-- PERFORMANCE NOTES
-- =============================================================================

-- 1. Priority queue uses composite index with priority DESC for high-priority-first sorting
-- 2. Status-based partial indexes reduce index size for transient workflow states
-- 3. Overdue indexes use computed date conditions for SLA monitoring
-- 4. Issue lines quantity indexes support both quality analytics and threshold alerts
-- 5. GIN indexes on JSONB enable flexible querying of changed fields and metadata
-- 6. Composite indexes ordered by: assignment/request → status → timestamp
-- 7. Reviewer and submitter indexes support both workload tracking and audit trails
