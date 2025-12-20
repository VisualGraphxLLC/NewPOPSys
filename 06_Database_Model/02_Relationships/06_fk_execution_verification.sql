-- ==============================================================================
-- FOREIGN KEY RELATIONSHIPS - Execution & Verification
-- ==============================================================================
-- Module: Execution & Verification
-- Tables: receive_verifications, store_survey_responses, photo_uploads,
--         photo_reviews, retake_requests, response_edit_audit, photo_links,
--         completion_submissions
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- RECEIVE VERIFICATIONS
-- ==============================================================================

-- Receive verification belongs to store assignment
ALTER TABLE receive_verifications
  ADD CONSTRAINT fk_receive_verifications_assignment
  FOREIGN KEY (store_assignment_id)
  REFERENCES store_assignments(id)
  ON DELETE CASCADE  -- Delete verifications when assignment deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_receive_verifications_assignment ON receive_verifications IS
  'Receive verification belongs to store assignment; cascade delete when assignment deleted';

-- Receive verification performed by user
ALTER TABLE receive_verifications
  ADD CONSTRAINT fk_receive_verifications_user
  FOREIGN KEY (verified_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve verification even if user deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_receive_verifications_user ON receive_verifications IS
  'User who verified receipt; set to NULL if user deleted';


-- ==============================================================================
-- STORE SURVEY RESPONSES
-- ==============================================================================

-- Survey response belongs to store assignment
ALTER TABLE store_survey_responses
  ADD CONSTRAINT fk_store_survey_responses_assignment
  FOREIGN KEY (store_assignment_id)
  REFERENCES store_assignments(id)
  ON DELETE CASCADE  -- Delete responses when assignment deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_survey_responses_assignment ON store_survey_responses IS
  'Survey response belongs to store assignment; cascade delete when assignment deleted';

-- Survey response references survey version
ALTER TABLE store_survey_responses
  ADD CONSTRAINT fk_store_survey_responses_version
  FOREIGN KEY (survey_version_id)
  REFERENCES survey_versions(id)
  ON DELETE RESTRICT  -- Cannot delete survey version with responses
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_survey_responses_version ON store_survey_responses IS
  'Survey response uses survey version; cannot delete version with active responses';

-- Survey response submitted by user
ALTER TABLE store_survey_responses
  ADD CONSTRAINT fk_store_survey_responses_user
  FOREIGN KEY (submitted_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve response even if user deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_survey_responses_user ON store_survey_responses IS
  'User who submitted survey response; set to NULL if user deleted';


-- ==============================================================================
-- RESPONSE EDIT AUDIT
-- ==============================================================================

-- Edit audit belongs to survey response
ALTER TABLE response_edit_audit
  ADD CONSTRAINT fk_response_edit_audit_response
  FOREIGN KEY (store_survey_response_id)
  REFERENCES store_survey_responses(id)
  ON DELETE RESTRICT  -- Cannot delete response with audit trail
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_response_edit_audit_response ON response_edit_audit IS
  'Audit trail for survey response; cannot delete response with audit records';

-- Edit audit performed by user
ALTER TABLE response_edit_audit
  ADD CONSTRAINT fk_response_edit_audit_actor
  FOREIGN KEY (actor_user_id)
  REFERENCES users(id)
  ON DELETE RESTRICT  -- Cannot delete user with audit trail
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_response_edit_audit_actor ON response_edit_audit IS
  'User who edited survey response; cannot delete user with audit records';


-- ==============================================================================
-- PHOTO UPLOADS
-- ==============================================================================

-- Photo upload belongs to store assignment
ALTER TABLE photo_uploads
  ADD CONSTRAINT fk_photo_uploads_assignment
  FOREIGN KEY (store_assignment_id)
  REFERENCES store_assignments(id)
  ON DELETE CASCADE  -- Delete photos when assignment deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_uploads_assignment ON photo_uploads IS
  'Photo upload belongs to store assignment; cascade delete when assignment deleted';

-- Photo upload may link to assignment item
ALTER TABLE photo_uploads
  ADD CONSTRAINT fk_photo_uploads_item
  FOREIGN KEY (assignment_item_id)
  REFERENCES assignment_items(id)
  ON DELETE SET NULL  -- Clear item link if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_uploads_item ON photo_uploads IS
  'Optional assignment item link; set to NULL if item deleted';

-- Photo upload may link to location slot
ALTER TABLE photo_uploads
  ADD CONSTRAINT fk_photo_uploads_slot
  FOREIGN KEY (location_slot_id)
  REFERENCES location_slots(id)
  ON DELETE SET NULL  -- Clear slot link if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_uploads_slot ON photo_uploads IS
  'Optional location slot link; set to NULL if slot deleted';

-- Photo upload performed by user
ALTER TABLE photo_uploads
  ADD CONSTRAINT fk_photo_uploads_user
  FOREIGN KEY (uploaded_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve photo even if user deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_uploads_user ON photo_uploads IS
  'User who uploaded photo; set to NULL if user deleted';


-- ==============================================================================
-- PHOTO LINKS
-- ==============================================================================

-- Photo link references photo upload
ALTER TABLE photo_links
  ADD CONSTRAINT fk_photo_links_photo
  FOREIGN KEY (photo_upload_id)
  REFERENCES photo_uploads(id)
  ON DELETE CASCADE  -- Delete links when photo deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_links_photo ON photo_links IS
  'Photo link references photo upload; cascade delete when photo deleted';

-- Photo link references campaign
ALTER TABLE photo_links
  ADD CONSTRAINT fk_photo_links_campaign
  FOREIGN KEY (campaign_id)
  REFERENCES campaigns(id)
  ON DELETE CASCADE  -- Delete links when campaign deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_links_campaign ON photo_links IS
  'Photo link references campaign; cascade delete when campaign deleted';

-- Photo link references store
ALTER TABLE photo_links
  ADD CONSTRAINT fk_photo_links_store
  FOREIGN KEY (store_id)
  REFERENCES stores(id)
  ON DELETE CASCADE  -- Delete links when store deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_links_store ON photo_links IS
  'Photo link references store; cascade delete when store deleted';

-- Photo link may reference store assignment
ALTER TABLE photo_links
  ADD CONSTRAINT fk_photo_links_assignment
  FOREIGN KEY (store_assignment_id)
  REFERENCES store_assignments(id)
  ON DELETE CASCADE  -- Delete links when assignment deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_links_assignment ON photo_links IS
  'Optional store assignment link; cascade delete when assignment deleted';

-- Photo link may reference assignment item
ALTER TABLE photo_links
  ADD CONSTRAINT fk_photo_links_item
  FOREIGN KEY (assignment_item_id)
  REFERENCES assignment_items(id)
  ON DELETE SET NULL  -- Clear item link if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_links_item ON photo_links IS
  'Optional assignment item link; set to NULL if item deleted';

-- Photo link may reference location slot
ALTER TABLE photo_links
  ADD CONSTRAINT fk_photo_links_slot
  FOREIGN KEY (location_slot_id)
  REFERENCES location_slots(id)
  ON DELETE SET NULL  -- Clear slot link if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_links_slot ON photo_links IS
  'Optional location slot link; set to NULL if slot deleted';

-- Photo link may reference photo rule
ALTER TABLE photo_links
  ADD CONSTRAINT fk_photo_links_rule
  FOREIGN KEY (photo_rule_id)
  REFERENCES photo_rules(id)
  ON DELETE SET NULL  -- Clear rule link if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_links_rule ON photo_links IS
  'Optional photo rule link; set to NULL if rule deleted';


-- ==============================================================================
-- PHOTO REVIEWS
-- ==============================================================================

-- Photo review belongs to photo upload
ALTER TABLE photo_reviews
  ADD CONSTRAINT fk_photo_reviews_photo
  FOREIGN KEY (photo_upload_id)
  REFERENCES photo_uploads(id)
  ON DELETE CASCADE  -- Delete reviews when photo deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_reviews_photo ON photo_reviews IS
  'Photo review belongs to photo upload; cascade delete when photo deleted';

-- Photo review performed by user
ALTER TABLE photo_reviews
  ADD CONSTRAINT fk_photo_reviews_reviewer
  FOREIGN KEY (reviewer_user_id)
  REFERENCES users(id)
  ON DELETE RESTRICT  -- Cannot delete reviewer with review history
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_reviews_reviewer ON photo_reviews IS
  'User who reviewed photo; cannot delete user with review history';


-- ==============================================================================
-- RETAKE REQUESTS
-- ==============================================================================

-- Retake request links to original photo
ALTER TABLE retake_requests
  ADD CONSTRAINT fk_retake_requests_photo
  FOREIGN KEY (photo_upload_id)
  REFERENCES photo_uploads(id)
  ON DELETE CASCADE  -- Delete retake request when photo deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_retake_requests_photo ON retake_requests IS
  'Retake request for original photo; cascade delete when photo deleted';

-- Retake request belongs to store assignment
ALTER TABLE retake_requests
  ADD CONSTRAINT fk_retake_requests_assignment
  FOREIGN KEY (store_assignment_id)
  REFERENCES store_assignments(id)
  ON DELETE CASCADE  -- Delete retake requests when assignment deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_retake_requests_assignment ON retake_requests IS
  'Retake request belongs to store assignment; cascade delete when assignment deleted';

-- Retake request may link to new photo
ALTER TABLE retake_requests
  ADD CONSTRAINT fk_retake_requests_new_photo
  FOREIGN KEY (new_photo_upload_id)
  REFERENCES photo_uploads(id)
  ON DELETE SET NULL  -- Clear new photo link if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_retake_requests_new_photo ON retake_requests IS
  'Optional replacement photo; set to NULL if photo deleted';

-- Retake request resolved by user
ALTER TABLE retake_requests
  ADD CONSTRAINT fk_retake_requests_resolved_by
  FOREIGN KEY (resolved_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve retake request even if resolver deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_retake_requests_resolved_by ON retake_requests IS
  'User who resolved retake request; set to NULL if user deleted';


-- ==============================================================================
-- COMPLETION SUBMISSIONS
-- ==============================================================================

-- Completion submission belongs to store assignment (one-to-one)
ALTER TABLE completion_submissions
  ADD CONSTRAINT fk_completion_submissions_assignment
  FOREIGN KEY (store_assignment_id)
  REFERENCES store_assignments(id)
  ON DELETE CASCADE  -- Delete submission when assignment deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_completion_submissions_assignment ON completion_submissions IS
  'Completion submission belongs to store assignment (one-to-one); cascade delete when assignment deleted';

-- Completion submission submitted by user
ALTER TABLE completion_submissions
  ADD CONSTRAINT fk_completion_submissions_submitter
  FOREIGN KEY (submitted_by_user_id)
  REFERENCES users(id)
  ON DELETE RESTRICT  -- Cannot delete user with submission history
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_completion_submissions_submitter ON completion_submissions IS
  'User who submitted completion; cannot delete user with submission history';

-- Completion submission reviewed by user
ALTER TABLE completion_submissions
  ADD CONSTRAINT fk_completion_submissions_reviewer
  FOREIGN KEY (reviewed_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve submission even if reviewer deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_completion_submissions_reviewer ON completion_submissions IS
  'User who reviewed completion; set to NULL if user deleted';


-- ==============================================================================
-- END OF EXECUTION & VERIFICATION FOREIGN KEYS
-- ==============================================================================
