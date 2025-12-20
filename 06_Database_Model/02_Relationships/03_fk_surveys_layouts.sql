-- ==============================================================================
-- FOREIGN KEY RELATIONSHIPS - Surveys & Layouts
-- ==============================================================================
-- Module: Surveys & Layouts
-- Tables: survey_templates, survey_versions, store_layouts, location_slots, photo_rules,
--         repeatable_sections
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- SURVEY TEMPLATES
-- ==============================================================================

-- Survey template belongs to brand
ALTER TABLE survey_templates
  ADD CONSTRAINT fk_survey_templates_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE CASCADE  -- Delete templates when brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_survey_templates_brand ON survey_templates IS
  'Survey template belongs to brand; cascade delete when brand deleted';


-- ==============================================================================
-- SURVEY VERSIONS
-- ==============================================================================

-- Survey version belongs to template
ALTER TABLE survey_versions
  ADD CONSTRAINT fk_survey_versions_template
  FOREIGN KEY (survey_template_id)
  REFERENCES survey_templates(id)
  ON DELETE CASCADE  -- Delete versions when template deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_survey_versions_template ON survey_versions IS
  'Survey version belongs to template; cascade delete when template deleted';


-- ==============================================================================
-- REPEATABLE SECTIONS
-- ==============================================================================

-- Repeatable section belongs to survey version
ALTER TABLE repeatable_sections
  ADD CONSTRAINT fk_repeatable_sections_survey_version
  FOREIGN KEY (survey_version_id)
  REFERENCES survey_versions(id)
  ON DELETE CASCADE  -- Delete sections when survey version deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_repeatable_sections_survey_version ON repeatable_sections IS
  'Repeatable section belongs to survey version; cascade delete when version deleted';


-- ==============================================================================
-- STORE LAYOUTS
-- ==============================================================================

-- Store layout belongs to store
ALTER TABLE store_layouts
  ADD CONSTRAINT fk_store_layouts_store
  FOREIGN KEY (store_id)
  REFERENCES stores(id)
  ON DELETE CASCADE  -- Delete layouts when store deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_store_layouts_store ON store_layouts IS
  'Store layout belongs to store; cascade delete when store deleted';


-- ==============================================================================
-- LOCATION SLOTS
-- ==============================================================================

-- Location slot belongs to store layout
ALTER TABLE location_slots
  ADD CONSTRAINT fk_location_slots_layout
  FOREIGN KEY (store_layout_id)
  REFERENCES store_layouts(id)
  ON DELETE CASCADE  -- Delete slots when layout deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_location_slots_layout ON location_slots IS
  'Location slot belongs to store layout; cascade delete when layout deleted';


-- ==============================================================================
-- PHOTO RULES
-- ==============================================================================

-- Photo rule belongs to brand
ALTER TABLE photo_rules
  ADD CONSTRAINT fk_photo_rules_brand
  FOREIGN KEY (brand_id)
  REFERENCES brands(id)
  ON DELETE CASCADE  -- Delete rules when brand deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_rules_brand ON photo_rules IS
  'Photo rule belongs to brand; cascade delete when brand deleted';

-- Photo rule created by user (audit)
ALTER TABLE photo_rules
  ADD CONSTRAINT fk_photo_rules_creator
  FOREIGN KEY (created_by_user_id)
  REFERENCES users(id)
  ON DELETE SET NULL  -- Preserve rule even if creator deleted
  ON UPDATE CASCADE;

COMMENT ON CONSTRAINT fk_photo_rules_creator ON photo_rules IS
  'User who created this photo rule; set to NULL if user deleted';


-- ==============================================================================
-- END OF SURVEYS & LAYOUTS FOREIGN KEYS
-- ==============================================================================
