-- =====================================================================================
-- File: 05_idx_photos.sql
-- Description: Photo upload and review queue indexes for NewPOPSys database
-- Created: 2025-12-19
-- Package: 5 - Index Optimization
-- =====================================================================================
-- Purpose: Indexes for photo upload tracking, review queue management, retake requests,
--          and photo verification workflows.
-- =====================================================================================

-- =============================================================================
-- PHOTO UPLOADS QUERY INDEXES
-- =============================================================================

-- Photo uploads by store assignment (already exists in brand_module_ddl.sql and psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_photo_uploads_assignment ON photo_uploads(store_assignment_id) WHERE deleted_at IS NULL;

-- Photo uploads by assignment item (already exists - SKIP)
-- CREATE INDEX idx_photo_uploads_item ON photo_uploads(assignment_item_id) WHERE deleted_at IS NULL;

-- Photo uploads by location slot (already exists - SKIP)
-- CREATE INDEX idx_photo_uploads_slot ON photo_uploads(location_slot_id) WHERE deleted_at IS NULL;

-- Photo uploads by review status (already exists - SKIP)
-- CREATE INDEX idx_photo_uploads_status ON photo_uploads(review_status) WHERE deleted_at IS NULL;

-- Photo uploads by assignment and status (composite for filtered queries)
CREATE INDEX IF NOT EXISTS idx_photo_uploads_assignment_status
  ON photo_uploads(store_assignment_id, review_status, uploaded_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_photo_uploads_assignment_status IS
  'Find photos for an assignment filtered by review status, sorted by upload time';

-- Photo uploads by status and creation time (for review queue)
CREATE INDEX IF NOT EXISTS idx_photo_uploads_status_created
  ON photo_uploads(review_status, created_at)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_photo_uploads_status_created IS
  'Review queue: find photos by status in chronological order (FIFO processing)';

-- Pending photo review queue (partial index)
CREATE INDEX IF NOT EXISTS idx_photo_uploads_pending_review
  ON photo_uploads(uploaded_at)
  WHERE review_status = 'PENDING' AND deleted_at IS NULL;

COMMENT ON INDEX idx_photo_uploads_pending_review IS
  'Efficiently find all photos awaiting review, sorted by upload time';

-- Rejected photos awaiting retake (partial index)
CREATE INDEX IF NOT EXISTS idx_photo_uploads_rejected
  ON photo_uploads(store_assignment_id, uploaded_at DESC)
  WHERE review_status = 'REJECTED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_photo_uploads_rejected IS
  'Find rejected photos for an assignment that may need retakes';

-- Approved photos by assignment (partial index for verification tracking)
CREATE INDEX IF NOT EXISTS idx_photo_uploads_approved
  ON photo_uploads(store_assignment_id, uploaded_at DESC)
  WHERE review_status = 'APPROVED' AND deleted_at IS NULL;

COMMENT ON INDEX idx_photo_uploads_approved IS
  'Find all approved photos for an assignment';

-- Photo uploads by uploader (for user activity tracking)
CREATE INDEX IF NOT EXISTS idx_photo_uploads_uploader
  ON photo_uploads(uploaded_by_user_id, uploaded_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_photo_uploads_uploader IS
  'Find all photos uploaded by a specific user, sorted by upload time';

-- Photo uploads by S3 key (for storage lookups, already exists in psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_photo_uploads_s3_key ON photo_uploads(s3_key) WHERE deleted_at IS NULL;

-- Photo uploads by file size (for storage monitoring)
CREATE INDEX IF NOT EXISTS idx_photo_uploads_file_size
  ON photo_uploads(file_size_bytes DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_photo_uploads_file_size IS
  'Find largest photo uploads for storage optimization';

-- Photo uploads by MIME type (for format analysis)
CREATE INDEX IF NOT EXISTS idx_photo_uploads_mime_type
  ON photo_uploads(mime_type)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_photo_uploads_mime_type IS
  'Analyze photo uploads by file format';

-- Photo uploads metadata GIN index
CREATE INDEX IF NOT EXISTS idx_photo_uploads_metadata_gin
  ON photo_uploads USING GIN (metadata)
  WHERE metadata IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_photo_uploads_metadata_gin IS
  'Query photo metadata (EXIF data, GPS coordinates, device info, etc.)';

-- =============================================================================
-- PHOTO REVIEWS QUERY INDEXES
-- =============================================================================

-- Photo reviews by photo upload (already exists in brand_module_ddl.sql and psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_photo_reviews_photo ON photo_reviews(photo_upload_id) WHERE deleted_at IS NULL;

-- Photo reviews by reviewer (already exists - SKIP)
-- CREATE INDEX idx_photo_reviews_reviewer ON photo_reviews(reviewer_user_id) WHERE deleted_at IS NULL;

-- Photo reviews by status (already exists in psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_photo_reviews_status ON photo_reviews(status) WHERE deleted_at IS NULL;

-- Photo reviews by reviewer and time (for reviewer activity tracking)
CREATE INDEX IF NOT EXISTS idx_photo_reviews_reviewer_time
  ON photo_reviews(reviewer_user_id, reviewed_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_photo_reviews_reviewer_time IS
  'Track review activity for a specific reviewer, sorted by review time';

-- Photo reviews by status and time (for review metrics)
CREATE INDEX IF NOT EXISTS idx_photo_reviews_status_time
  ON photo_reviews(status, reviewed_at DESC)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_photo_reviews_status_time IS
  'Analyze review outcomes over time (approval rates, rejection reasons)';

-- Rejected photo reviews with reasons (partial index)
CREATE INDEX IF NOT EXISTS idx_photo_reviews_rejected_reasons
  ON photo_reviews(reviewed_at DESC)
  WHERE status = 'REJECTED' AND rejection_reason IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_photo_reviews_rejected_reasons IS
  'Find rejected reviews to analyze rejection patterns';

-- Photo reviews by rejection reason (for quality analysis)
CREATE INDEX IF NOT EXISTS idx_photo_reviews_rejection_reason
  ON photo_reviews(rejection_reason)
  WHERE rejection_reason IS NOT NULL AND deleted_at IS NULL;

COMMENT ON INDEX idx_photo_reviews_rejection_reason IS
  'Analyze photo rejections by reason category';

-- =============================================================================
-- RETAKE REQUESTS QUERY INDEXES
-- =============================================================================

-- Retake requests by photo upload (already exists in psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_retake_requests_photo ON retake_requests(photo_upload_id) WHERE deleted_at IS NULL;

-- Retake requests by store assignment (already exists - SKIP)
-- CREATE INDEX idx_retake_requests_assignment ON retake_requests(store_assignment_id) WHERE deleted_at IS NULL;

-- Retake requests by new photo upload (already exists in psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_retake_requests_new_photo ON retake_requests(new_photo_upload_id) WHERE deleted_at IS NULL;

-- Pending retake requests (already exists in psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_retake_requests_pending ON retake_requests(requested_at DESC) WHERE deleted_at IS NULL AND completed_at IS NULL;

-- Retake requests by assignment and resolution status
CREATE INDEX IF NOT EXISTS idx_retake_requests_assignment_resolution
  ON retake_requests(store_assignment_id, resolution_status)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_retake_requests_assignment_resolution IS
  'Find retake requests for an assignment filtered by resolution status';

-- Retake requests resolved (already exists in psp_module_ddl.sql - SKIP)
-- CREATE INDEX idx_retake_requests_completed ON retake_requests(completed_at DESC) WHERE deleted_at IS NULL AND completed_at IS NOT NULL;

-- Retake requests by resolution status (for workflow tracking)
CREATE INDEX IF NOT EXISTS idx_retake_requests_resolution_status
  ON retake_requests(resolution_status, requested_at)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_retake_requests_resolution_status IS
  'Track retake requests by resolution status (PENDING, COMPLETED, WAIVED, SUPERSEDED)';

-- Overdue retake requests (for follow-up)
CREATE INDEX IF NOT EXISTS idx_retake_requests_overdue
  ON retake_requests(requested_at)
  WHERE resolution_status = 'PENDING'
    AND completed_at IS NULL
    AND requested_at < (CURRENT_TIMESTAMP - INTERVAL '7 days')
    AND deleted_at IS NULL;

COMMENT ON INDEX idx_retake_requests_overdue IS
  'Find retake requests pending for more than 7 days';

-- =============================================================================
-- PHOTO LINKS QUERY INDEXES
-- (From 12_missing_tables.sql - these indexes already exist)
-- =============================================================================

-- Photo links indexes already defined in 12_missing_tables.sql:
-- - idx_photo_links_photo
-- - idx_photo_links_campaign
-- - idx_photo_links_store
-- - idx_photo_links_assignment
-- - idx_photo_links_item
-- - idx_photo_links_slot
-- - idx_photo_links_rule

-- Additional composite index for photo rule compliance checking
CREATE INDEX IF NOT EXISTS idx_photo_links_requirement_check
  ON photo_links(store_assignment_id, photo_rule_id, photo_upload_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_photo_links_requirement_check IS
  'Verify photo rule compliance for an assignment (check if all required photos are uploaded)';

-- Photo links by campaign and rule (for campaign-wide photo compliance)
CREATE INDEX IF NOT EXISTS idx_photo_links_campaign_rule
  ON photo_links(campaign_id, photo_rule_id)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_photo_links_campaign_rule IS
  'Track photo rule compliance across a campaign';

-- =============================================================================
-- PHOTO RULES QUERY INDEXES
-- =============================================================================

-- Photo rules by brand (already exists in brand_module_ddl.sql - SKIP)
-- CREATE INDEX idx_photo_rules_brand ON photo_rules(brand_id) WHERE deleted_at IS NULL;

-- Active photo rules by brand (already exists in 13_missing_fields.sql - SKIP)
-- CREATE INDEX idx_photo_rules_active ON photo_rules(brand_id, is_active) WHERE deleted_at IS NULL;

-- Photo rules by brand and name (for rule lookups)
CREATE INDEX IF NOT EXISTS idx_photo_rules_brand_name
  ON photo_rules(brand_id, name)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_photo_rules_brand_name IS
  'Lookup photo rules by name within a brand';

-- Photo rules requiring specific verification mode
CREATE INDEX IF NOT EXISTS idx_photo_rules_verification_mode
  ON photo_rules(verification_mode)
  WHERE deleted_at IS NULL;

COMMENT ON INDEX idx_photo_rules_verification_mode IS
  'Find photo rules by verification mode (REQUIRED, OPTIONAL, CONDITIONAL)';

-- =============================================================================
-- CROSS-TABLE PHOTO WORKFLOW QUERY PATTERNS
-- =============================================================================

-- Pattern 1: Review Queue Dashboard
-- Query: Find all pending photos with their assignment and store context
-- Uses: idx_photo_uploads_pending_review + idx_photo_uploads_assignment (join)

-- Pattern 2: Assignment Photo Compliance Check
-- Query: Check if all required photos are uploaded and approved for an assignment
-- Uses: idx_photo_links_requirement_check + idx_photo_uploads_assignment_status

-- Pattern 3: Reviewer Performance Metrics
-- Query: Analyze review throughput and accuracy for a reviewer
-- Uses: idx_photo_reviews_reviewer_time + idx_photo_reviews_status_time

-- Pattern 4: Retake Management Workflow
-- Query: Find assignments with pending retakes and track completion
-- Uses: idx_retake_requests_assignment_resolution + idx_photo_uploads_rejected

-- Pattern 5: Photo Quality Analytics
-- Query: Analyze rejection patterns by reason, reviewer, time period
-- Uses: idx_photo_reviews_rejection_reason + idx_photo_reviews_status_time

-- Pattern 6: Campaign Photo Progress
-- Query: Track photo upload and approval progress across a campaign
-- Uses: idx_photo_links_campaign_rule + idx_photo_uploads_assignment_status

-- =============================================================================
-- PERFORMANCE NOTES
-- =============================================================================

-- 1. Review queue uses partial index on PENDING status for efficient queue processing
-- 2. Status-based partial indexes reduce index bloat on transient statuses
-- 3. GIN index on metadata JSONB enables flexible EXIF and device info queries
-- 4. Composite indexes prioritize: assignment_id → status → timestamp
-- 5. Rejection reason indexes support quality analytics and process improvement
-- 6. Overdue retake index uses computed date condition for proactive monitoring
-- 7. Photo links indexes support both requirement checking and compliance reporting
