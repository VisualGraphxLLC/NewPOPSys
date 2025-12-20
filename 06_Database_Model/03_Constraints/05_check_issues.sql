-- ==============================================================================
-- CHECK CONSTRAINTS: ISSUES & REORDERS
-- ==============================================================================
-- Business rule enforcement for issue requests, resolution workflow, and reorders
--
-- Dependencies: 00_foundation_ddl.sql, brand_module_ddl.sql, 13_missing_fields.sql
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- ISSUE_REQUESTS TABLE CONSTRAINTS
-- ==============================================================================

-- Type validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_issue_requests_type CHECK (type IN ('MISSING', 'DAMAGED', 'INCORRECT', 'PACKAGING'))
COMMENT ON CONSTRAINT chk_issue_requests_type ON issue_requests IS
  'Business Rule: Issue type must be MISSING, DAMAGED, INCORRECT, or PACKAGING';

-- Status validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_issue_requests_status CHECK (status IN ('OPEN', 'TRIAGED', 'AWAITING_APPROVAL', 'APPROVED', 'IN_FULFILLMENT', 'DENIED', 'RESOLVED'))
COMMENT ON CONSTRAINT chk_issue_requests_status ON issue_requests IS
  'Business Rule: Issue status must be valid lifecycle state';

-- DAMAGED and PACKAGING issues require evidence photo
ALTER TABLE issue_requests
  ADD CONSTRAINT chk_issue_requests_evidence_photo
  CHECK (
    (type IN ('DAMAGED', 'PACKAGING') AND evidence_photo_id IS NOT NULL) OR
    (type NOT IN ('DAMAGED', 'PACKAGING'))
  );

COMMENT ON CONSTRAINT chk_issue_requests_evidence_photo ON issue_requests IS
  'Business Rule: DAMAGED and PACKAGING issues must have evidence_photo_id';

-- TRIAGED status requires triage details
ALTER TABLE issue_requests
  ADD CONSTRAINT chk_issue_requests_triaged_at
  CHECK (
    (status IN ('TRIAGED', 'AWAITING_APPROVAL', 'APPROVED', 'IN_FULFILLMENT', 'DENIED', 'RESOLVED')
     AND triaged_at IS NOT NULL) OR
    (status NOT IN ('TRIAGED', 'AWAITING_APPROVAL', 'APPROVED', 'IN_FULFILLMENT', 'DENIED', 'RESOLVED'))
  );

COMMENT ON CONSTRAINT chk_issue_requests_triaged_at ON issue_requests IS
  'Business Rule: Issues that reached TRIAGED or beyond must have triaged_at timestamp';

ALTER TABLE issue_requests
  ADD CONSTRAINT chk_issue_requests_triaged_by
  CHECK (
    (status IN ('TRIAGED', 'AWAITING_APPROVAL', 'APPROVED', 'IN_FULFILLMENT', 'DENIED', 'RESOLVED')
     AND triaged_by_user_id IS NOT NULL) OR
    (status NOT IN ('TRIAGED', 'AWAITING_APPROVAL', 'APPROVED', 'IN_FULFILLMENT', 'DENIED', 'RESOLVED'))
  );

COMMENT ON CONSTRAINT chk_issue_requests_triaged_by ON issue_requests IS
  'Business Rule: Issues that reached TRIAGED or beyond must have triaged_by_user_id';

-- Priority validation (added in 13_missing_fields.sql)
COMMENT ON COLUMN issue_requests.priority IS
  'Business Rule: Issue priority must be LOW, MEDIUM, HIGH, or URGENT';

-- APPROVED status requires approval details
ALTER TABLE issue_requests
  ADD CONSTRAINT chk_issue_requests_approved_at
  CHECK (
    (status IN ('APPROVED', 'IN_FULFILLMENT', 'RESOLVED') AND approved_at IS NOT NULL) OR
    (status NOT IN ('APPROVED', 'IN_FULFILLMENT', 'RESOLVED'))
  );

COMMENT ON CONSTRAINT chk_issue_requests_approved_at ON issue_requests IS
  'Business Rule: Issues that reached APPROVED or beyond must have approved_at timestamp';

ALTER TABLE issue_requests
  ADD CONSTRAINT chk_issue_requests_approved_by
  CHECK (
    (status IN ('APPROVED', 'IN_FULFILLMENT', 'RESOLVED') AND approved_by_user_id IS NOT NULL) OR
    (status NOT IN ('APPROVED', 'IN_FULFILLMENT', 'RESOLVED'))
  );

COMMENT ON CONSTRAINT chk_issue_requests_approved_by ON issue_requests IS
  'Business Rule: Issues that reached APPROVED or beyond must have approved_by_user_id';

-- DENIED status requires denial details
ALTER TABLE issue_requests
  ADD CONSTRAINT chk_issue_requests_denied_at
  CHECK (
    (status = 'DENIED' AND denied_at IS NOT NULL) OR
    (status != 'DENIED')
  );

COMMENT ON CONSTRAINT chk_issue_requests_denied_at ON issue_requests IS
  'Business Rule: DENIED issues must have denied_at timestamp';

ALTER TABLE issue_requests
  ADD CONSTRAINT chk_issue_requests_denied_by
  CHECK (
    (status = 'DENIED' AND denied_by_user_id IS NOT NULL) OR
    (status != 'DENIED')
  );

COMMENT ON CONSTRAINT chk_issue_requests_denied_by ON issue_requests IS
  'Business Rule: DENIED issues must have denied_by_user_id';

ALTER TABLE issue_requests
  ADD CONSTRAINT chk_issue_requests_denial_reason
  CHECK (
    (status = 'DENIED' AND denial_reason IS NOT NULL AND LENGTH(TRIM(denial_reason)) > 0) OR
    (status != 'DENIED')
  );

COMMENT ON CONSTRAINT chk_issue_requests_denial_reason ON issue_requests IS
  'Business Rule: DENIED issues must have a non-empty denial_reason';

-- RESOLVED status requires resolution details
ALTER TABLE issue_requests
  ADD CONSTRAINT chk_issue_requests_resolved_at
  CHECK (
    (status = 'RESOLVED' AND resolved_at IS NOT NULL) OR
    (status != 'RESOLVED')
  );

COMMENT ON CONSTRAINT chk_issue_requests_resolved_at ON issue_requests IS
  'Business Rule: RESOLVED issues must have resolved_at timestamp';

ALTER TABLE issue_requests
  ADD CONSTRAINT chk_issue_requests_resolved_by
  CHECK (
    (status = 'RESOLVED' AND resolved_by_user_id IS NOT NULL) OR
    (status != 'RESOLVED')
  );

COMMENT ON CONSTRAINT chk_issue_requests_resolved_by ON issue_requests IS
  'Business Rule: RESOLVED issues must have resolved_by_user_id';

-- Resolution type validation (added in 13_missing_fields.sql)
COMMENT ON COLUMN issue_requests.resolution_type IS
  'Business Rule: Resolution type must be REORDER, CREDIT, WAIVED, DUPLICATE, or OTHER';

-- RESOLVED issues should have resolution_type
ALTER TABLE issue_requests
  ADD CONSTRAINT chk_issue_requests_resolution_type
  CHECK (
    (status = 'RESOLVED' AND resolution_type IS NOT NULL) OR
    (status != 'RESOLVED')
  );

COMMENT ON CONSTRAINT chk_issue_requests_resolution_type ON issue_requests IS
  'Business Rule: RESOLVED issues must have a resolution_type';

-- ==============================================================================
-- ISSUE_LINES TABLE CONSTRAINTS
-- ==============================================================================

-- Quantity validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_issue_lines_quantity CHECK (quantity > 0)
COMMENT ON CONSTRAINT chk_issue_lines_quantity ON issue_lines IS
  'Business Rule: Issue line quantity must be at least 1';

-- ==============================================================================
-- STORE_CHANGE_VERIFICATIONS TABLE CONSTRAINTS
-- ==============================================================================

-- Status validation (enum defined in 12_missing_tables.sql)
COMMENT ON COLUMN store_change_verifications.status IS
  'Business Rule: Change verification status must be PENDING, VERIFIED, REJECTED, or AUTO_APPROVED';

-- Changed fields JSON must not be empty
ALTER TABLE store_change_verifications
  ADD CONSTRAINT chk_store_change_verifications_changed_fields
  CHECK (
    changed_fields_json IS NOT NULL AND
    changed_fields_json != '{}'::jsonb
  );

COMMENT ON CONSTRAINT chk_store_change_verifications_changed_fields ON store_change_verifications IS
  'Business Rule: Changed fields JSON must not be empty';

-- VERIFIED status requires verification details
ALTER TABLE store_change_verifications
  ADD CONSTRAINT chk_store_change_verifications_verified_at
  CHECK (
    (status = 'VERIFIED' AND verified_at IS NOT NULL) OR
    (status != 'VERIFIED')
  );

COMMENT ON CONSTRAINT chk_store_change_verifications_verified_at ON store_change_verifications IS
  'Business Rule: VERIFIED changes must have verified_at timestamp';

ALTER TABLE store_change_verifications
  ADD CONSTRAINT chk_store_change_verifications_verified_by
  CHECK (
    (status = 'VERIFIED' AND verified_by_user_id IS NOT NULL) OR
    (status != 'VERIFIED')
  );

COMMENT ON CONSTRAINT chk_store_change_verifications_verified_by ON store_change_verifications IS
  'Business Rule: VERIFIED changes must have verified_by_user_id';

-- REJECTED status requires verification details and notes
ALTER TABLE store_change_verifications
  ADD CONSTRAINT chk_store_change_verifications_rejected_at
  CHECK (
    (status = 'REJECTED' AND verified_at IS NOT NULL) OR
    (status != 'REJECTED')
  );

COMMENT ON CONSTRAINT chk_store_change_verifications_rejected_at ON store_change_verifications IS
  'Business Rule: REJECTED changes must have verified_at timestamp';

ALTER TABLE store_change_verifications
  ADD CONSTRAINT chk_store_change_verifications_rejected_by
  CHECK (
    (status = 'REJECTED' AND verified_by_user_id IS NOT NULL) OR
    (status != 'REJECTED')
  );

COMMENT ON CONSTRAINT chk_store_change_verifications_rejected_by ON store_change_verifications IS
  'Business Rule: REJECTED changes must have verified_by_user_id';

ALTER TABLE store_change_verifications
  ADD CONSTRAINT chk_store_change_verifications_rejected_notes
  CHECK (
    (status = 'REJECTED' AND verification_notes IS NOT NULL AND LENGTH(TRIM(verification_notes)) > 0) OR
    (status != 'REJECTED')
  );

COMMENT ON CONSTRAINT chk_store_change_verifications_rejected_notes ON store_change_verifications IS
  'Business Rule: REJECTED changes must have non-empty verification_notes';

-- ==============================================================================
-- RESPONSE_EDIT_AUDIT TABLE CONSTRAINTS
-- ==============================================================================

-- Reason must not be empty
ALTER TABLE response_edit_audit
  ADD CONSTRAINT chk_response_edit_audit_reason
  CHECK (reason IS NOT NULL AND LENGTH(TRIM(reason)) > 0);

COMMENT ON CONSTRAINT chk_response_edit_audit_reason ON response_edit_audit IS
  'Business Rule: Survey response edits must have a non-empty reason';

-- Before and after hashes must be different
ALTER TABLE response_edit_audit
  ADD CONSTRAINT chk_response_edit_audit_hash_different
  CHECK (before_hash != after_hash);

COMMENT ON CONSTRAINT chk_response_edit_audit_hash_different ON response_edit_audit IS
  'Business Rule: Survey response edits must result in different hashes (before_hash != after_hash)';

-- Before and after JSON must be set
ALTER TABLE response_edit_audit
  ADD CONSTRAINT chk_response_edit_audit_json_not_null
  CHECK (
    before_json IS NOT NULL AND
    after_json IS NOT NULL AND
    before_json != 'null'::jsonb AND
    after_json != 'null'::jsonb
  );

COMMENT ON CONSTRAINT chk_response_edit_audit_json_not_null ON response_edit_audit IS
  'Business Rule: Survey response edit audit must have both before and after JSON snapshots';

-- ==============================================================================
-- END OF ISSUE CONSTRAINTS
-- ==============================================================================
