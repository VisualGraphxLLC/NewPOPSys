-- ==============================================================================
-- CHECK CONSTRAINTS: STORE ASSIGNMENTS
-- ==============================================================================
-- Business rule enforcement for assignment lifecycle, readiness, and status transitions
--
-- Dependencies: 00_foundation_ddl.sql, brand_module_ddl.sql, 13_missing_fields.sql
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- STORE_ASSIGNMENTS TABLE CONSTRAINTS
-- ==============================================================================

-- Status validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_store_assignments_status CHECK (status IN ('ASSIGNED', 'READY', 'IN_PROGRESS', 'SUBMITTED', 'REWORK_REQUIRED', 'COMPLETE', 'REOPENED', 'WAIVED'))
COMMENT ON CONSTRAINT chk_store_assignments_status ON store_assignments IS
  'Business Rule: Assignment status must be valid lifecycle state';

-- READY status requires empty blocked reasons
ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_ready_unblocked
  CHECK (
    (status = 'READY' AND (
      readiness_blocked_reasons IS NULL OR
      readiness_blocked_reasons = '[]'::jsonb
    )) OR
    (status != 'READY')
  );

COMMENT ON CONSTRAINT chk_store_assignments_ready_unblocked ON store_assignments IS
  'Business Rule: READY assignments must have no blocking reasons';

-- READY status requires ready_at timestamp
ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_ready_at
  CHECK (
    (status IN ('READY', 'IN_PROGRESS', 'SUBMITTED', 'REWORK_REQUIRED', 'COMPLETE', 'REOPENED') AND ready_at IS NOT NULL) OR
    (status NOT IN ('READY', 'IN_PROGRESS', 'SUBMITTED', 'REWORK_REQUIRED', 'COMPLETE', 'REOPENED'))
  );

COMMENT ON CONSTRAINT chk_store_assignments_ready_at ON store_assignments IS
  'Business Rule: Assignments that reached READY or beyond must have ready_at timestamp';

-- IN_PROGRESS status requires started_at timestamp
ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_started_at
  CHECK (
    (status IN ('IN_PROGRESS', 'SUBMITTED', 'REWORK_REQUIRED', 'COMPLETE', 'REOPENED') AND started_at IS NOT NULL) OR
    (status NOT IN ('IN_PROGRESS', 'SUBMITTED', 'REWORK_REQUIRED', 'COMPLETE', 'REOPENED'))
  );

COMMENT ON CONSTRAINT chk_store_assignments_started_at ON store_assignments IS
  'Business Rule: Assignments that reached IN_PROGRESS or beyond must have started_at timestamp';

-- SUBMITTED status requires submitted_at and submitted_by
ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_submitted_at
  CHECK (
    (status IN ('SUBMITTED', 'REWORK_REQUIRED', 'COMPLETE') AND submitted_at IS NOT NULL) OR
    (status NOT IN ('SUBMITTED', 'REWORK_REQUIRED', 'COMPLETE'))
  );

COMMENT ON CONSTRAINT chk_store_assignments_submitted_at ON store_assignments IS
  'Business Rule: Assignments that reached SUBMITTED or beyond must have submitted_at timestamp';

ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_submitted_by
  CHECK (
    (status IN ('SUBMITTED', 'REWORK_REQUIRED', 'COMPLETE') AND submitted_by_user_id IS NOT NULL) OR
    (status NOT IN ('SUBMITTED', 'REWORK_REQUIRED', 'COMPLETE'))
  );

COMMENT ON CONSTRAINT chk_store_assignments_submitted_by ON store_assignments IS
  'Business Rule: Assignments that reached SUBMITTED or beyond must have submitted_by_user_id';

-- COMPLETE status requires completed_at and completed_by
ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_completed_at
  CHECK (
    (status = 'COMPLETE' AND completed_at IS NOT NULL) OR
    (status != 'COMPLETE')
  );

COMMENT ON CONSTRAINT chk_store_assignments_completed_at ON store_assignments IS
  'Business Rule: COMPLETE assignments must have completed_at timestamp';

ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_completed_by
  CHECK (
    (status = 'COMPLETE' AND completed_by_user_id IS NOT NULL) OR
    (status != 'COMPLETE')
  );

COMMENT ON CONSTRAINT chk_store_assignments_completed_by ON store_assignments IS
  'Business Rule: COMPLETE assignments must have completed_by_user_id';

-- REOPENED status requires reopened_at, reopened_by, and reopened_reason
ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_reopened_at
  CHECK (
    (status = 'REOPENED' AND reopened_at IS NOT NULL) OR
    (status != 'REOPENED')
  );

COMMENT ON CONSTRAINT chk_store_assignments_reopened_at ON store_assignments IS
  'Business Rule: REOPENED assignments must have reopened_at timestamp';

ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_reopened_by
  CHECK (
    (status = 'REOPENED' AND reopened_by_user_id IS NOT NULL) OR
    (status != 'REOPENED')
  );

COMMENT ON CONSTRAINT chk_store_assignments_reopened_by ON store_assignments IS
  'Business Rule: REOPENED assignments must have reopened_by_user_id';

ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_reopened_reason
  CHECK (
    (status = 'REOPENED' AND reopened_reason IS NOT NULL AND LENGTH(TRIM(reopened_reason)) > 0) OR
    (status != 'REOPENED')
  );

COMMENT ON CONSTRAINT chk_store_assignments_reopened_reason ON store_assignments IS
  'Business Rule: REOPENED assignments must have a non-empty reopened_reason';

-- WAIVED status requires waived_at, waived_by, and waived_reason
ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_waived_at
  CHECK (
    (status = 'WAIVED' AND waived_at IS NOT NULL) OR
    (status != 'WAIVED')
  );

COMMENT ON CONSTRAINT chk_store_assignments_waived_at ON store_assignments IS
  'Business Rule: WAIVED assignments must have waived_at timestamp';

ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_waived_by
  CHECK (
    (status = 'WAIVED' AND waived_by_user_id IS NOT NULL) OR
    (status != 'WAIVED')
  );

COMMENT ON CONSTRAINT chk_store_assignments_waived_by ON store_assignments IS
  'Business Rule: WAIVED assignments must have waived_by_user_id';

ALTER TABLE store_assignments
  ADD CONSTRAINT chk_store_assignments_waived_reason
  CHECK (
    (status = 'WAIVED' AND waived_reason IS NOT NULL AND LENGTH(TRIM(waived_reason)) > 0) OR
    (status != 'WAIVED')
  );

COMMENT ON CONSTRAINT chk_store_assignments_waived_reason ON store_assignments IS
  'Business Rule: WAIVED assignments must have a non-empty waived_reason';

-- ==============================================================================
-- ASSIGNMENT_ITEMS TABLE CONSTRAINTS
-- ==============================================================================

-- Status validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_assignment_items_status CHECK (status IN ('PLANNED', 'ORDERED', 'SHIPPED', 'DELIVERED', 'RECEIVED', 'INSTALLED', 'PROOF_SUBMITTED', 'RETAKE_REQUIRED', 'SATISFIED', 'EXCEPTION'))
COMMENT ON CONSTRAINT chk_assignment_items_status ON assignment_items IS
  'Business Rule: Assignment item status must be valid lifecycle state';

-- Quantity tracking validation
ALTER TABLE assignment_items
  ADD CONSTRAINT chk_assignment_items_qty_non_negative
  CHECK (
    shipped_qty >= 0 AND
    delivered_qty >= 0 AND
    received_good_qty >= 0 AND
    received_damaged_qty >= 0 AND
    installed_qty >= 0 AND
    satisfied_qty >= 0
  );

COMMENT ON CONSTRAINT chk_assignment_items_qty_non_negative ON assignment_items IS
  'Business Rule: All quantity fields must be non-negative';

-- Delivered qty cannot exceed shipped qty
ALTER TABLE assignment_items
  ADD CONSTRAINT chk_assignment_items_delivered_lte_shipped
  CHECK (delivered_qty <= shipped_qty);

COMMENT ON CONSTRAINT chk_assignment_items_delivered_lte_shipped ON assignment_items IS
  'Business Rule: Delivered quantity cannot exceed shipped quantity';

-- Received qty cannot exceed delivered qty
ALTER TABLE assignment_items
  ADD CONSTRAINT chk_assignment_items_received_lte_delivered
  CHECK (
    (received_good_qty + received_damaged_qty) <= delivered_qty
  );

COMMENT ON CONSTRAINT chk_assignment_items_received_lte_delivered ON assignment_items IS
  'Business Rule: Total received quantity (good + damaged) cannot exceed delivered quantity';

-- Installed qty cannot exceed received good qty
ALTER TABLE assignment_items
  ADD CONSTRAINT chk_assignment_items_installed_lte_received_good
  CHECK (installed_qty <= received_good_qty);

COMMENT ON CONSTRAINT chk_assignment_items_installed_lte_received_good ON assignment_items IS
  'Business Rule: Installed quantity cannot exceed received good quantity';

-- Satisfied qty cannot exceed installed qty
ALTER TABLE assignment_items
  ADD CONSTRAINT chk_assignment_items_satisfied_lte_installed
  CHECK (satisfied_qty <= installed_qty);

COMMENT ON CONSTRAINT chk_assignment_items_satisfied_lte_installed ON assignment_items IS
  'Business Rule: Satisfied quantity (with approved photos) cannot exceed installed quantity';

-- EXCEPTION status requires exception_reason
ALTER TABLE assignment_items
  ADD CONSTRAINT chk_assignment_items_exception_reason
  CHECK (
    (status = 'EXCEPTION' AND exception_reason IS NOT NULL AND LENGTH(TRIM(exception_reason)) > 0) OR
    (status != 'EXCEPTION')
  );

COMMENT ON CONSTRAINT chk_assignment_items_exception_reason ON assignment_items IS
  'Business Rule: EXCEPTION items must have a non-empty exception_reason';

-- ==============================================================================
-- COMPLETION_SUBMISSIONS TABLE CONSTRAINTS
-- ==============================================================================

-- Attestation signature required for non-withdrawn submissions
ALTER TABLE completion_submissions
  ADD CONSTRAINT chk_completion_submissions_attestation
  CHECK (
    (status != 'WITHDRAWN' AND attestation_signature IS NOT NULL) OR
    (status = 'WITHDRAWN')
  );

COMMENT ON CONSTRAINT chk_completion_submissions_attestation ON completion_submissions IS
  'Business Rule: Non-withdrawn completion submissions must have attestation signature';

-- Reviewed submissions must have reviewer and review timestamp
ALTER TABLE completion_submissions
  ADD CONSTRAINT chk_completion_submissions_reviewed_at
  CHECK (
    (status IN ('ACCEPTED', 'REJECTED') AND reviewed_at IS NOT NULL) OR
    (status NOT IN ('ACCEPTED', 'REJECTED'))
  );

COMMENT ON CONSTRAINT chk_completion_submissions_reviewed_at ON completion_submissions IS
  'Business Rule: Accepted/Rejected submissions must have reviewed_at timestamp';

ALTER TABLE completion_submissions
  ADD CONSTRAINT chk_completion_submissions_reviewed_by
  CHECK (
    (status IN ('ACCEPTED', 'REJECTED') AND reviewed_by_user_id IS NOT NULL) OR
    (status NOT IN ('ACCEPTED', 'REJECTED'))
  );

COMMENT ON CONSTRAINT chk_completion_submissions_reviewed_by ON completion_submissions IS
  'Business Rule: Accepted/Rejected submissions must have reviewed_by_user_id';

-- Rejected submissions must have rejection reason
ALTER TABLE completion_submissions
  ADD CONSTRAINT chk_completion_submissions_rejection_reason
  CHECK (
    (status = 'REJECTED' AND rejection_reason IS NOT NULL AND LENGTH(TRIM(rejection_reason)) > 0) OR
    (status != 'REJECTED')
  );

COMMENT ON CONSTRAINT chk_completion_submissions_rejection_reason ON completion_submissions IS
  'Business Rule: Rejected submissions must have a non-empty rejection_reason';

-- ==============================================================================
-- END OF ASSIGNMENT CONSTRAINTS
-- ==============================================================================
