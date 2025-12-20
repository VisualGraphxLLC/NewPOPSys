-- ==============================================================================
-- CHECK CONSTRAINTS: CAMPAIGNS
-- ==============================================================================
-- Business rule enforcement for campaign lifecycle and validation
--
-- Dependencies: 00_foundation_ddl.sql, brand_module_ddl.sql, 13_missing_fields.sql
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- CAMPAIGNS TABLE CONSTRAINTS
-- ==============================================================================

-- Campaign date range validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_campaigns_dates CHECK (end_date >= start_date)
COMMENT ON CONSTRAINT chk_campaigns_dates ON campaigns IS
  'Business Rule: Campaign end date must be on or after start date';

-- Campaign status validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_campaigns_status CHECK (status IN ('DRAFT', 'SCHEDULED', 'PUBLISHED', 'COMPLETED', 'CANCELLED', 'ARCHIVED'))
COMMENT ON CONSTRAINT chk_campaigns_status ON campaigns IS
  'Business Rule: Campaign status must be valid lifecycle state';

-- Verification mode validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_campaigns_verification CHECK (verification_mode IN ('STRICT', 'FAST'))
COMMENT ON CONSTRAINT chk_campaigns_verification ON campaigns IS
  'Business Rule: Campaign verification mode must be STRICT (all reviewed) or FAST (auto-approve unless flagged)';

-- Published campaigns must have published_at timestamp
ALTER TABLE campaigns
  ADD CONSTRAINT chk_campaigns_published_at
  CHECK (
    (status = 'PUBLISHED' AND published_at IS NOT NULL) OR
    (status != 'PUBLISHED')
  );

COMMENT ON CONSTRAINT chk_campaigns_published_at ON campaigns IS
  'Business Rule: Published campaigns must have published_at timestamp set';

-- Published campaigns must have a publisher
ALTER TABLE campaigns
  ADD CONSTRAINT chk_campaigns_published_by
  CHECK (
    (status = 'PUBLISHED' AND published_by_user_id IS NOT NULL) OR
    (status != 'PUBLISHED')
  );

COMMENT ON CONSTRAINT chk_campaigns_published_by ON campaigns IS
  'Business Rule: Published campaigns must have published_by_user_id set';

-- Archived campaigns must have archived_at timestamp
ALTER TABLE campaigns
  ADD CONSTRAINT chk_campaigns_archived_at
  CHECK (
    (status = 'ARCHIVED' AND archived_at IS NOT NULL) OR
    (status != 'ARCHIVED')
  );

COMMENT ON CONSTRAINT chk_campaigns_archived_at ON campaigns IS
  'Business Rule: Archived campaigns must have archived_at timestamp set';

-- Archived campaigns must have archiver
ALTER TABLE campaigns
  ADD CONSTRAINT chk_campaigns_archived_by
  CHECK (
    (status = 'ARCHIVED' AND archived_by_user_id IS NOT NULL) OR
    (status != 'ARCHIVED')
  );

COMMENT ON CONSTRAINT chk_campaigns_archived_by ON campaigns IS
  'Business Rule: Archived campaigns must have archived_by_user_id set';

-- Published campaigns should have kit definition or survey (soft rule - warning only)
-- Note: This is validated at application layer since both can be NULL for announcement-only campaigns

-- ==============================================================================
-- KIT_DEFINITIONS TABLE CONSTRAINTS
-- ==============================================================================

-- No additional CHECK constraints needed beyond existing schema

-- ==============================================================================
-- KIT_ITEMS TABLE CONSTRAINTS
-- ==============================================================================

-- Quantity must be positive (already exists in DDL, documented here)
-- CONSTRAINT: chk_kit_items_quantity CHECK (quantity > 0)
COMMENT ON CONSTRAINT chk_kit_items_quantity ON kit_items IS
  'Business Rule: Kit item quantity must be at least 1';

-- ==============================================================================
-- STORE_LAYOUTS TABLE CONSTRAINTS
-- ==============================================================================

-- Version must be at least 1
ALTER TABLE store_layouts
  ADD CONSTRAINT chk_store_layouts_version
  CHECK (version >= 1);

COMMENT ON CONSTRAINT chk_store_layouts_version ON store_layouts IS
  'Business Rule: Store layout version must be at least 1';

-- ==============================================================================
-- SURVEY_VERSIONS TABLE CONSTRAINTS
-- ==============================================================================

-- Version number must be at least 1
ALTER TABLE survey_versions
  ADD CONSTRAINT chk_survey_versions_version
  CHECK (version_number >= 1);

COMMENT ON CONSTRAINT chk_survey_versions_version ON survey_versions IS
  'Business Rule: Survey version number must be at least 1';

-- ==============================================================================
-- PHOTO_RULES TABLE CONSTRAINTS
-- ==============================================================================

-- Min/max photos validation (already exists in DDL, documented here)
-- CONSTRAINT: chk_photo_rules_count CHECK (min_photos <= max_photos)
COMMENT ON CONSTRAINT chk_photo_rules_count ON photo_rules IS
  'Business Rule: Minimum photos cannot exceed maximum photos';

-- Min photos must be at least 0
ALTER TABLE photo_rules
  ADD CONSTRAINT chk_photo_rules_min_photos
  CHECK (min_photos >= 0);

COMMENT ON CONSTRAINT chk_photo_rules_min_photos ON photo_rules IS
  'Business Rule: Minimum photos must be non-negative';

-- Max photos must be at least 1
ALTER TABLE photo_rules
  ADD CONSTRAINT chk_photo_rules_max_photos
  CHECK (max_photos >= 1);

COMMENT ON CONSTRAINT chk_photo_rules_max_photos ON photo_rules IS
  'Business Rule: Maximum photos must be at least 1';

-- ==============================================================================
-- END OF CAMPAIGN CONSTRAINTS
-- ==============================================================================
