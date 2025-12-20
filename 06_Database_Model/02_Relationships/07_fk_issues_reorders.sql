-- ==============================================================================
-- FOREIGN KEY RELATIONSHIPS - Issues & Reorders
-- ==============================================================================
-- Module: Issues & Reorders
-- Tables: issue_requests, issue_lines, reorders
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- ISSUE REQUESTS
-- ==============================================================================

-- Issue request belongs to store assignment
ALTER TABLE issue_requests
  ADD CONSTRAINT fk_issue_requests_assignment
  FOREIGN KEY (store_assignment_id)
  REFERENCES store_assignments(id)
  ON DELETE CASCADE  -- Delete issues when assignment deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_issue_requests_assignment ON issue_requests IS
  'Issue request belongs to store assignment; cascade delete when assignment deleted';

-- Issue request may reference evidence photo
ALTER TABLE issue_requests
  ADD CONSTRAINT fk_issue_requests_photo
  FOREIGN KEY (evidence_photo_id)
  REFERENCES photo_uploads(id)
  ON DELETE SET NULL  -- Clear photo if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_issue_requests_photo ON issue_requests IS
  'Optional evidence photo; set to NULL if photo deleted';

-- Issue request submitted by user
ALTER TABLE issue_requests
  ADD CONSTRAINT fk_issue_requests_submitter
  FOREIGN KEY (submitted_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve issue even if submitter deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_issue_requests_submitter ON issue_requests IS
  'User who submitted issue request; set to NULL if user deleted';

-- Issue request reviewed by user
ALTER TABLE issue_requests
  ADD CONSTRAINT fk_issue_requests_reviewer
  FOREIGN KEY (reviewed_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve issue even if reviewer deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_issue_requests_reviewer ON issue_requests IS
  'User who reviewed issue request; set to NULL if user deleted';

-- Issue request triaged by user
ALTER TABLE issue_requests
  ADD CONSTRAINT fk_issue_requests_triaged_by
  FOREIGN KEY (triaged_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve issue even if triager deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_issue_requests_triaged_by ON issue_requests IS
  'User who triaged issue request; set to NULL if user deleted';

-- Issue request approved by user
ALTER TABLE issue_requests
  ADD CONSTRAINT fk_issue_requests_approved_by
  FOREIGN KEY (approved_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve issue even if approver deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_issue_requests_approved_by ON issue_requests IS
  'User who approved issue request; set to NULL if user deleted';

-- Issue request denied by user
ALTER TABLE issue_requests
  ADD CONSTRAINT fk_issue_requests_denied_by
  FOREIGN KEY (denied_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve issue even if denier deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_issue_requests_denied_by ON issue_requests IS
  'User who denied issue request; set to NULL if user deleted';

-- Issue request resolved by user
ALTER TABLE issue_requests
  ADD CONSTRAINT fk_issue_requests_resolved_by
  FOREIGN KEY (resolved_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve issue even if resolver deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_issue_requests_resolved_by ON issue_requests IS
  'User who resolved issue request; set to NULL if user deleted';


-- ==============================================================================
-- ISSUE LINES
-- ==============================================================================

-- Issue line belongs to issue request
ALTER TABLE issue_lines
  ADD CONSTRAINT fk_issue_lines_issue
  FOREIGN KEY (issue_request_id)
  REFERENCES issue_requests(id)
  ON DELETE CASCADE  -- Delete lines when issue deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_issue_lines_issue ON issue_lines IS
  'Issue line belongs to issue request; cascade delete when issue deleted';

-- Issue line references kit item
ALTER TABLE issue_lines
  ADD CONSTRAINT fk_issue_lines_kit_item
  FOREIGN KEY (kit_item_id)
  REFERENCES kit_items(id)
  ON DELETE RESTRICT  -- Cannot delete kit item with issue lines
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_issue_lines_kit_item ON issue_lines IS
  'Issue line references kit item; cannot delete kit item with active issue lines';


-- ==============================================================================
-- REORDERS
-- ==============================================================================

-- Reorder triggered by issue request
ALTER TABLE reorders
  ADD CONSTRAINT fk_reorders_issue
  FOREIGN KEY (issue_request_id)
  REFERENCES issue_requests(id)
  ON DELETE RESTRICT  -- Cannot delete issue with reorder
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_reorders_issue ON reorders IS
  'Reorder triggered by issue request; cannot delete issue with active reorder';

-- Reorder creates store order
ALTER TABLE reorders
  ADD CONSTRAINT fk_reorders_order
  FOREIGN KEY (store_order_id)
  REFERENCES store_orders(id)
  ON DELETE RESTRICT  -- Cannot delete reorder order
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_reorders_order ON reorders IS
  'Reorder creates replacement store order; cannot delete reorder order';


-- ==============================================================================
-- END OF ISSUES & REORDERS FOREIGN KEYS
-- ==============================================================================
