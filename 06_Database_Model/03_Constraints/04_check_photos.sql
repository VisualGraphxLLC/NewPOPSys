-- ==============================================================================
-- CHECK CONSTRAINTS: PHOTOS & VERIFICATION
-- ==============================================================================
-- Business rule enforcement for photo uploads, reviews, and retake requests
--
-- Dependencies: 00_foundation_ddl.sql, brand_module_ddl.sql, 12_missing_tables.sql
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- PHOTO_UPLOADS TABLE CONSTRAINTS
-- ==============================================================================

-- Review status validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_photo_uploads_status CHECK (review_status IN ('PENDING', 'APPROVED', 'REJECTED', 'SUPERSEDED'))
COMMENT ON CONSTRAINT chk_photo_uploads_status ON photo_uploads IS
  'Business Rule: Photo review status must be valid state';

-- File size must be positive
ALTER TABLE photo_uploads
  ADD CONSTRAINT chk_photo_uploads_file_size
  CHECK (file_size_bytes IS NULL OR file_size_bytes > 0);

COMMENT ON CONSTRAINT chk_photo_uploads_file_size ON photo_uploads IS
  'Business Rule: Photo file size must be positive when set';

-- MIME type must be valid image format
ALTER TABLE photo_uploads
  ADD CONSTRAINT chk_photo_uploads_mime_type
  CHECK (
    mime_type IS NULL OR
    mime_type IN ('image/jpeg', 'image/jpg', 'image/png', 'image/heic', 'image/heif', 'image/webp')
  );

COMMENT ON CONSTRAINT chk_photo_uploads_mime_type ON photo_uploads IS
  'Business Rule: Photo MIME type must be valid image format (jpeg, png, heic, heif, webp)';

-- Photo must be linked to either an assignment item OR a location slot (or both)
ALTER TABLE photo_uploads
  ADD CONSTRAINT chk_photo_uploads_item_or_slot
  CHECK (
    assignment_item_id IS NOT NULL OR location_slot_id IS NOT NULL
  );

COMMENT ON CONSTRAINT chk_photo_uploads_item_or_slot ON photo_uploads IS
  'Business Rule: Photo must be linked to at least one target (assignment_item_id or location_slot_id)';

-- S3 key must be set
ALTER TABLE photo_uploads
  ADD CONSTRAINT chk_photo_uploads_s3_key
  CHECK (s3_key IS NOT NULL AND LENGTH(TRIM(s3_key)) > 0);

COMMENT ON CONSTRAINT chk_photo_uploads_s3_key ON photo_uploads IS
  'Business Rule: Photo must have a valid S3 storage key';

-- ==============================================================================
-- PHOTO_REVIEWS TABLE CONSTRAINTS
-- ==============================================================================

-- Status validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_photo_reviews_status CHECK (status IN ('APPROVED', 'REJECTED'))
COMMENT ON CONSTRAINT chk_photo_reviews_status ON photo_reviews IS
  'Business Rule: Photo review status must be APPROVED or REJECTED';

-- Rejection reason validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_photo_reviews_reason CHECK (rejection_reason IS NULL OR rejection_reason IN ('BLURRY', 'WRONG_ANGLE', 'WRONG_PLACEMENT', 'DAMAGED', 'INSUFFICIENT_LIGHTING', 'OBSTRUCTION', 'OTHER'))
COMMENT ON CONSTRAINT chk_photo_reviews_reason ON photo_reviews IS
  'Business Rule: Rejection reason must be valid code or NULL';

-- Rejected photos must have rejection reason
ALTER TABLE photo_reviews
  ADD CONSTRAINT chk_photo_reviews_rejected_reason
  CHECK (
    (status = 'REJECTED' AND rejection_reason IS NOT NULL) OR
    (status != 'REJECTED')
  );

COMMENT ON CONSTRAINT chk_photo_reviews_rejected_reason ON photo_reviews IS
  'Business Rule: REJECTED photo reviews must have a rejection_reason';

-- Approved photos should not have rejection reason (soft rule - allows legacy data)
ALTER TABLE photo_reviews
  ADD CONSTRAINT chk_photo_reviews_approved_no_reason
  CHECK (
    (status = 'APPROVED' AND rejection_reason IS NULL AND rejection_comment IS NULL) OR
    (status != 'APPROVED')
  );

COMMENT ON CONSTRAINT chk_photo_reviews_approved_no_reason ON photo_reviews IS
  'Business Rule: APPROVED photo reviews should not have rejection reason or comment';

-- ==============================================================================
-- RETAKE_REQUESTS TABLE CONSTRAINTS
-- ==============================================================================

-- Reason validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_retake_requests_reason CHECK (reason IN ('BLURRY', 'WRONG_ANGLE', 'WRONG_PLACEMENT', 'DAMAGED', 'INSUFFICIENT_LIGHTING', 'OBSTRUCTION', 'OTHER'))
COMMENT ON CONSTRAINT chk_retake_requests_reason ON retake_requests IS
  'Business Rule: Retake reason must be valid rejection reason code';

-- Resolution status must be valid
-- Note: Check constraint added in 13_missing_fields.sql
COMMENT ON COLUMN retake_requests.resolution_status IS
  'Business Rule: Resolution status must be PENDING, COMPLETED, APPROVED, SUPERSEDED, WAIVED, or EXPIRED';

-- COMPLETED or later resolution requires resolved_at
ALTER TABLE retake_requests
  ADD CONSTRAINT chk_retake_requests_resolved_at
  CHECK (
    (resolution_status IN ('COMPLETED', 'APPROVED', 'SUPERSEDED', 'WAIVED') AND resolved_at IS NOT NULL) OR
    (resolution_status NOT IN ('COMPLETED', 'APPROVED', 'SUPERSEDED', 'WAIVED'))
  );

COMMENT ON CONSTRAINT chk_retake_requests_resolved_at ON retake_requests IS
  'Business Rule: Resolved retake requests must have resolved_at timestamp';

-- COMPLETED resolution requires new_photo_upload_id
ALTER TABLE retake_requests
  ADD CONSTRAINT chk_retake_requests_completed_photo
  CHECK (
    (resolution_status IN ('COMPLETED', 'APPROVED') AND new_photo_upload_id IS NOT NULL) OR
    (resolution_status NOT IN ('COMPLETED', 'APPROVED'))
  );

COMMENT ON CONSTRAINT chk_retake_requests_completed_photo ON retake_requests IS
  'Business Rule: COMPLETED/APPROVED retake requests must have new_photo_upload_id';

-- WAIVED resolution requires resolved_by and resolution_notes
ALTER TABLE retake_requests
  ADD CONSTRAINT chk_retake_requests_waived_by
  CHECK (
    (resolution_status = 'WAIVED' AND resolved_by_user_id IS NOT NULL) OR
    (resolution_status != 'WAIVED')
  );

COMMENT ON CONSTRAINT chk_retake_requests_waived_by ON retake_requests IS
  'Business Rule: WAIVED retake requests must have resolved_by_user_id';

ALTER TABLE retake_requests
  ADD CONSTRAINT chk_retake_requests_waived_notes
  CHECK (
    (resolution_status = 'WAIVED' AND resolution_notes IS NOT NULL AND LENGTH(TRIM(resolution_notes)) > 0) OR
    (resolution_status != 'WAIVED')
  );

COMMENT ON CONSTRAINT chk_retake_requests_waived_notes ON retake_requests IS
  'Business Rule: WAIVED retake requests must have non-empty resolution_notes';

-- Requested_at must be before completed_at when both are set
ALTER TABLE retake_requests
  ADD CONSTRAINT chk_retake_requests_completed_after_requested
  CHECK (
    completed_at IS NULL OR completed_at >= requested_at
  );

COMMENT ON CONSTRAINT chk_retake_requests_completed_after_requested ON retake_requests IS
  'Business Rule: Completion timestamp must be on or after request timestamp';

-- ==============================================================================
-- PHOTO_LINKS TABLE CONSTRAINTS
-- ==============================================================================

-- Link type validation (already exists in DDL, documented here)
-- CONSTRAINT: CHECK (link_type IN ('REQUIREMENT', 'EVIDENCE', 'GENERAL'))
COMMENT ON TABLE photo_links IS
  'Business Rule: Photo link type must be REQUIREMENT, EVIDENCE, or GENERAL';

-- REQUIREMENT type links should have photo_rule_id (soft recommendation)
COMMENT ON COLUMN photo_links.photo_rule_id IS
  'Business Rule: REQUIREMENT type links should reference a photo_rule_id (recommended, not enforced)';

-- EVIDENCE type links are typically for issue_requests (enforced at application layer)
COMMENT ON COLUMN photo_links.link_type IS
  'Business Rule: EVIDENCE type links are typically associated with issue requests (enforced at application layer)';

-- ==============================================================================
-- RECEIVE_VERIFICATIONS TABLE CONSTRAINTS
-- ==============================================================================

-- All items received flag is set
ALTER TABLE receive_verifications
  ADD CONSTRAINT chk_receive_verifications_all_items
  CHECK (all_items_received IS NOT NULL);

COMMENT ON CONSTRAINT chk_receive_verifications_all_items ON receive_verifications IS
  'Business Rule: All items received flag must be explicitly set (TRUE or FALSE)';

-- Partial receipt (all_items_received = FALSE) should have notes explaining discrepancy
-- This is a soft rule documented here:
COMMENT ON COLUMN receive_verifications.notes IS
  'Business Rule: When all_items_received = FALSE, notes should explain what is missing (recommended, not enforced)';

-- ==============================================================================
-- END OF PHOTO CONSTRAINTS
-- ==============================================================================
