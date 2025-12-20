-- ==============================================================================
-- FOREIGN KEY RELATIONSHIPS - Campaigns & Kits
-- ==============================================================================
-- Module: Campaigns & Kits
-- Tables: campaigns, kit_definitions, kit_items, store_assignments, assignment_items
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- KIT DEFINITIONS
-- ==============================================================================

-- Kit definition belongs to brand
ALTER TABLE kit_definitions
  ADD CONSTRAINT fk_kit_definitions_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE CASCADE  -- Delete kits when brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_kit_definitions_brand ON kit_definitions IS
  'Kit definition belongs to brand; cascade delete when brand deleted';


-- ==============================================================================
-- KIT ITEMS
-- ==============================================================================

-- Kit item belongs to kit definition
ALTER TABLE kit_items
  ADD CONSTRAINT fk_kit_items_kit
  FOREIGN KEY (kit_definition_id)
  REFERENCES kit_definitions(id)
  ON DELETE CASCADE  -- Delete items when kit deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_kit_items_kit ON kit_items IS
  'Kit item belongs to kit definition; cascade delete when kit deleted';

-- Kit item may reference photo rule
ALTER TABLE kit_items
  ADD CONSTRAINT fk_kit_items_photo_rule
  FOREIGN KEY (photo_rule_id)
  REFERENCES photo_rules(id)
  ON DELETE SET NULL  -- Clear rule if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_kit_items_photo_rule ON kit_items IS
  'Optional photo rule for this kit item; set to NULL if rule deleted';


-- ==============================================================================
-- CAMPAIGNS
-- ==============================================================================

-- Campaign belongs to brand
ALTER TABLE campaigns
  ADD CONSTRAINT fk_campaigns_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE CASCADE  -- Delete campaigns when brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_campaigns_brand ON campaigns IS
  'Campaign belongs to brand; cascade delete when brand deleted';

-- Campaign references kit definition
ALTER TABLE campaigns
  ADD CONSTRAINT fk_campaigns_kit
  FOREIGN KEY (kit_definition_id)
  REFERENCES kit_definitions(id)
  ON DELETE RESTRICT  -- Cannot delete kit with active campaigns
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_campaigns_kit ON campaigns IS
  'Campaign uses kit definition; cannot delete kit with active campaigns';

-- Campaign references survey version
ALTER TABLE campaigns
  ADD CONSTRAINT fk_campaigns_survey
  FOREIGN KEY (survey_version_id)
  REFERENCES survey_versions(id)
  ON DELETE SET NULL  -- Clear survey if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_campaigns_survey ON campaigns IS
  'Optional survey version for campaign; set to NULL if version deleted';

-- Campaign published by user
ALTER TABLE campaigns
  ADD CONSTRAINT fk_campaigns_publisher
  FOREIGN KEY (published_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve campaign even if publisher deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_campaigns_publisher ON campaigns IS
  'User who published this campaign; set to NULL if user deleted';

-- Campaign created by user (audit)
ALTER TABLE campaigns
  ADD CONSTRAINT fk_campaigns_creator
  FOREIGN KEY (created_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve campaign even if creator deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_campaigns_creator ON campaigns IS
  'User who created this campaign; set to NULL if user deleted';

-- Campaign locked by user (audit)
ALTER TABLE campaigns
  ADD CONSTRAINT fk_campaigns_locked_by
  FOREIGN KEY (locked_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve campaign even if locker deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_campaigns_locked_by ON campaigns IS
  'User who locked this campaign; set to NULL if user deleted';

-- Campaign archived by user (audit)
ALTER TABLE campaigns
  ADD CONSTRAINT fk_campaigns_archived_by
  FOREIGN KEY (archived_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve campaign even if archiver deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_campaigns_archived_by ON campaigns IS
  'User who archived this campaign; set to NULL if user deleted';


-- ==============================================================================
-- STORE ASSIGNMENTS
-- ==============================================================================

-- Store assignment links to campaign
ALTER TABLE store_assignments
  ADD CONSTRAINT fk_store_assignments_campaign
  FOREIGN KEY (campaign_id)
  REFERENCES campaigns(id)
  ON DELETE CASCADE  -- Delete assignments when campaign deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_assignments_campaign ON store_assignments IS
  'Store assignment belongs to campaign; cascade delete when campaign deleted';

-- Store assignment links to store
ALTER TABLE store_assignments
  ADD CONSTRAINT fk_store_assignments_store
  FOREIGN KEY (store_id)
  REFERENCES stores(id)
  ON DELETE CASCADE  -- Delete assignments when store deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_assignments_store ON store_assignments IS
  'Store assignment belongs to store; cascade delete when store deleted';

-- Store assignment references pinned layout version
ALTER TABLE store_assignments
  ADD CONSTRAINT fk_store_assignments_layout
  FOREIGN KEY (layout_version_id)
  REFERENCES store_layouts(id)
  ON DELETE SET NULL  -- Clear layout if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_assignments_layout ON store_assignments IS
  'Pinned store layout version; set to NULL if layout deleted';

-- Store assignment references pinned survey version
ALTER TABLE store_assignments
  ADD CONSTRAINT fk_store_assignments_survey
  FOREIGN KEY (survey_version_id)
  REFERENCES survey_versions(id)
  ON DELETE SET NULL  -- Clear survey if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_assignments_survey ON store_assignments IS
  'Pinned survey version (overrides campaign default); set to NULL if version deleted';

-- Store assignment audit - submitted by
ALTER TABLE store_assignments
  ADD CONSTRAINT fk_store_assignments_submitted_by
  FOREIGN KEY (submitted_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve assignment even if submitter deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_assignments_submitted_by ON store_assignments IS
  'User who submitted this assignment; set to NULL if user deleted';

-- Store assignment audit - completed by
ALTER TABLE store_assignments
  ADD CONSTRAINT fk_store_assignments_completed_by
  FOREIGN KEY (completed_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve assignment even if completer deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_assignments_completed_by ON store_assignments IS
  'User who completed this assignment; set to NULL if user deleted';

-- Store assignment audit - reopened by
ALTER TABLE store_assignments
  ADD CONSTRAINT fk_store_assignments_reopened_by
  FOREIGN KEY (reopened_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve assignment even if reopener deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_assignments_reopened_by ON store_assignments IS
  'User who reopened this assignment; set to NULL if user deleted';

-- Store assignment audit - waived by
ALTER TABLE store_assignments
  ADD CONSTRAINT fk_store_assignments_waived_by
  FOREIGN KEY (waived_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve assignment even if waiver deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_assignments_waived_by ON store_assignments IS
  'User who waived this assignment; set to NULL if user deleted';


-- ==============================================================================
-- ASSIGNMENT ITEMS
-- ==============================================================================

-- Assignment item belongs to store assignment
ALTER TABLE assignment_items
  ADD CONSTRAINT fk_assignment_items_assignment
  FOREIGN KEY (store_assignment_id)
  REFERENCES store_assignments(id)
  ON DELETE CASCADE  -- Delete items when assignment deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_assignment_items_assignment ON assignment_items IS
  'Assignment item belongs to store assignment; cascade delete when assignment deleted';

-- Assignment item references kit item
ALTER TABLE assignment_items
  ADD CONSTRAINT fk_assignment_items_kit_item
  FOREIGN KEY (kit_item_id)
  REFERENCES kit_items(id)
  ON DELETE RESTRICT  -- Cannot delete kit item with active assignments
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_assignment_items_kit_item ON assignment_items IS
  'Assignment item references kit item; cannot delete kit item with active assignments';

-- Assignment item may be mapped to location slot
ALTER TABLE assignment_items
  ADD CONSTRAINT fk_assignment_items_slot
  FOREIGN KEY (location_slot_id)
  REFERENCES location_slots(id)
  ON DELETE SET NULL  -- Clear slot if deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_assignment_items_slot ON assignment_items IS
  'Optional location slot mapping; set to NULL if slot deleted';


-- ==============================================================================
-- END OF CAMPAIGNS & KITS FOREIGN KEYS
-- ==============================================================================
