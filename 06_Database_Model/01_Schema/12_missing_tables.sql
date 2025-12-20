-- ==============================================================================
-- MISSING TABLES DDL - NewPOPSys v1
-- ==============================================================================
-- Tables identified in gap analysis (00_ORCHESTRATION_LOG.md Section 1.1)
-- that are required by SUPP specifications but missing from SUPP-035.
--
-- Dependencies: 00_foundation_ddl.sql, brand_module_ddl.sql
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- TABLE 1: repeatable_sections (SUPP-014)
-- ==============================================================================
-- Purpose: Support repeatable survey blocks (e.g., Cooler #1..#N)
-- Each section can be repeated min_instances to max_instances times

CREATE TABLE repeatable_sections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  survey_version_id UUID NOT NULL,  -- FK to survey_versions.id
  name TEXT NOT NULL,
  description TEXT,
  min_instances INTEGER NOT NULL DEFAULT 1 CHECK (min_instances >= 0),
  max_instances INTEGER NOT NULL DEFAULT 1 CHECK (max_instances >= 1),
  instance_label_pattern TEXT NOT NULL DEFAULT '{name} #{n}',
  display_order INTEGER NOT NULL DEFAULT 0,
  settings_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT repeatable_sections_min_max_check CHECK (max_instances >= min_instances)
);

CREATE TRIGGER repeatable_sections_updated_at BEFORE UPDATE ON repeatable_sections
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_repeatable_sections_survey_version ON repeatable_sections(survey_version_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_repeatable_sections_display_order ON repeatable_sections(survey_version_id, display_order);

COMMENT ON TABLE repeatable_sections IS 'Repeatable survey blocks that can be instantiated multiple times (e.g., multiple coolers)';
COMMENT ON COLUMN repeatable_sections.survey_version_id IS 'Parent survey version containing this repeatable section';
COMMENT ON COLUMN repeatable_sections.min_instances IS 'Minimum required instances (0 = optional section)';
COMMENT ON COLUMN repeatable_sections.max_instances IS 'Maximum allowed instances';
COMMENT ON COLUMN repeatable_sections.instance_label_pattern IS 'Pattern for instance labels with {n} placeholder (e.g., "Cooler #{n}")';
COMMENT ON COLUMN repeatable_sections.settings_json IS 'Section-specific configuration options';


-- ==============================================================================
-- TABLE 2: response_edit_audit (SUPP-014)
-- ==============================================================================
-- Purpose: Audit trail for admin edits of store survey responses
-- Tracks who edited what and why for compliance

CREATE TABLE response_edit_audit (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_survey_response_id UUID NOT NULL,  -- FK to store_survey_responses.id
  actor_user_id UUID NOT NULL,  -- FK to users.id
  actor_role role_enum NOT NULL,
  reason TEXT NOT NULL,
  before_hash TEXT NOT NULL,
  after_hash TEXT NOT NULL,
  before_json JSONB NOT NULL,
  after_json JSONB NOT NULL,
  ip_address TEXT,
  user_agent TEXT,
  edited_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  -- Note: No updated_at/deleted_at - audit records are immutable
);

CREATE INDEX idx_response_edit_audit_response ON response_edit_audit(store_survey_response_id, edited_at DESC);
CREATE INDEX idx_response_edit_audit_actor ON response_edit_audit(actor_user_id, edited_at DESC);
CREATE INDEX idx_response_edit_audit_time ON response_edit_audit(edited_at DESC);

COMMENT ON TABLE response_edit_audit IS 'Immutable audit trail for admin edits of survey responses';
COMMENT ON COLUMN response_edit_audit.store_survey_response_id IS 'Survey response that was modified';
COMMENT ON COLUMN response_edit_audit.actor_user_id IS 'User who performed the edit';
COMMENT ON COLUMN response_edit_audit.actor_role IS 'Role of actor at time of edit';
COMMENT ON COLUMN response_edit_audit.reason IS 'Required justification for the edit';
COMMENT ON COLUMN response_edit_audit.before_hash IS 'SHA256 hash of response data before edit';
COMMENT ON COLUMN response_edit_audit.after_hash IS 'SHA256 hash of response data after edit';


-- ==============================================================================
-- TABLE 3: photo_links (SUPP-014, SUPP-017)
-- ==============================================================================
-- Purpose: Explicit binding of photos to campaign/store/item/slot requirements
-- Enables many-to-many between photos and requirements

CREATE TABLE photo_links (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  photo_upload_id UUID NOT NULL,  -- FK to photo_uploads.id
  campaign_id UUID NOT NULL,  -- FK to campaigns.id
  store_id UUID NOT NULL,  -- FK to stores.id
  store_assignment_id UUID,  -- FK to store_assignments.id (nullable for general photos)
  assignment_item_id UUID,  -- FK to assignment_items.id (nullable)
  location_slot_id UUID,  -- FK to location_slots.id (nullable)
  photo_rule_id UUID,  -- FK to photo_rules.id (nullable - specific rule this satisfies)
  link_type TEXT NOT NULL CHECK (link_type IN ('REQUIREMENT', 'EVIDENCE', 'GENERAL')),
  is_primary BOOLEAN NOT NULL DEFAULT FALSE,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  UNIQUE (photo_upload_id, assignment_item_id, location_slot_id)
);

CREATE TRIGGER photo_links_updated_at BEFORE UPDATE ON photo_links
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_photo_links_photo ON photo_links(photo_upload_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_links_campaign ON photo_links(campaign_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_links_store ON photo_links(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_links_assignment ON photo_links(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_photo_links_item ON photo_links(assignment_item_id) WHERE assignment_item_id IS NOT NULL;
CREATE INDEX idx_photo_links_slot ON photo_links(location_slot_id) WHERE location_slot_id IS NOT NULL;
CREATE INDEX idx_photo_links_rule ON photo_links(photo_rule_id) WHERE photo_rule_id IS NOT NULL;

COMMENT ON TABLE photo_links IS 'Explicit bindings between photos and their required targets (items, slots, rules)';
COMMENT ON COLUMN photo_links.link_type IS 'REQUIREMENT=satisfies a rule, EVIDENCE=supports issue, GENERAL=context only';
COMMENT ON COLUMN photo_links.is_primary IS 'True if this is the primary photo for the target (slot/item)';
COMMENT ON COLUMN photo_links.photo_rule_id IS 'Specific photo rule this photo satisfies (if applicable)';


-- ==============================================================================
-- TABLE 4: store_change_verifications (SUPP-013)
-- ==============================================================================
-- Purpose: Track critical store field changes that need approval during active campaigns
-- E.g., address change during execution requires verification before shipping

-- Verification status for store changes
CREATE TYPE store_change_status_enum AS ENUM (
  'PENDING',
  'VERIFIED',
  'REJECTED',
  'AUTO_APPROVED'
);

CREATE TABLE store_change_verifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL,  -- FK to stores.id
  campaign_id UUID,  -- FK to campaigns.id (nullable - may affect all campaigns)
  changed_fields_json JSONB NOT NULL,  -- { "field": { "old": value, "new": value } }
  change_reason TEXT,
  status store_change_status_enum NOT NULL DEFAULT 'PENDING',
  requested_by_user_id UUID,  -- FK to users.id (nullable if system-detected)
  requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  verified_by_user_id UUID,  -- FK to users.id
  verified_at TIMESTAMPTZ,
  verification_notes TEXT,
  auto_approve_eligible BOOLEAN NOT NULL DEFAULT FALSE,
  impact_assessment_json JSONB,  -- { "affected_orders": [], "affected_shipments": [] }
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TRIGGER store_change_verifications_updated_at BEFORE UPDATE ON store_change_verifications
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_store_change_verifications_store ON store_change_verifications(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_change_verifications_campaign ON store_change_verifications(campaign_id) WHERE campaign_id IS NOT NULL;
CREATE INDEX idx_store_change_verifications_status ON store_change_verifications(status) WHERE status = 'PENDING';
CREATE INDEX idx_store_change_verifications_requested ON store_change_verifications(requested_at DESC);

COMMENT ON TABLE store_change_verifications IS 'Tracks store field changes requiring approval during active campaigns';
COMMENT ON COLUMN store_change_verifications.changed_fields_json IS 'Fields changed with old/new values (e.g., address, contact info)';
COMMENT ON COLUMN store_change_verifications.campaign_id IS 'Specific campaign affected (NULL = all active campaigns)';
COMMENT ON COLUMN store_change_verifications.auto_approve_eligible IS 'True if change type allows automatic approval';
COMMENT ON COLUMN store_change_verifications.impact_assessment_json IS 'Analysis of affected orders, shipments, and assignments';


-- ==============================================================================
-- TABLE 5: store_id_aliases (SUPP-013)
-- ==============================================================================
-- Purpose: External ID mappings for brand's store number systems
-- Allows multiple external system references per store

CREATE TABLE store_id_aliases (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL,  -- FK to stores.id
  external_system TEXT NOT NULL,  -- e.g., 'SAP', 'ORACLE', 'LEGACY', 'POS'
  external_id TEXT NOT NULL,
  is_primary BOOLEAN NOT NULL DEFAULT FALSE,
  valid_from DATE,
  valid_until DATE,
  metadata_json JSONB,  -- System-specific metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  UNIQUE (store_id, external_system, external_id)
);

CREATE TRIGGER store_id_aliases_updated_at BEFORE UPDATE ON store_id_aliases
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_store_id_aliases_store ON store_id_aliases(store_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_id_aliases_external ON store_id_aliases(external_system, external_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_store_id_aliases_primary ON store_id_aliases(store_id, is_primary) WHERE is_primary = TRUE;

COMMENT ON TABLE store_id_aliases IS 'External system ID mappings for stores (e.g., SAP store numbers)';
COMMENT ON COLUMN store_id_aliases.external_system IS 'Source system identifier (e.g., SAP, ORACLE, POS)';
COMMENT ON COLUMN store_id_aliases.external_id IS 'Store identifier in the external system';
COMMENT ON COLUMN store_id_aliases.is_primary IS 'True if this is the primary ID for this external system';
COMMENT ON COLUMN store_id_aliases.valid_from IS 'Start of validity period (NULL = always valid)';
COMMENT ON COLUMN store_id_aliases.valid_until IS 'End of validity period (NULL = still valid)';


-- ==============================================================================
-- TABLE 6: completion_submissions (SUPP-002)
-- ==============================================================================
-- Purpose: Store's final submission attestation for campaign completion
-- Distinct from survey responses - this is the "done" attestation

-- Completion submission status
CREATE TYPE completion_status_enum AS ENUM (
  'SUBMITTED',
  'UNDER_REVIEW',
  'ACCEPTED',
  'REJECTED',
  'WITHDRAWN'
);

CREATE TABLE completion_submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_assignment_id UUID NOT NULL UNIQUE,  -- FK to store_assignments.id (one per assignment)
  submitted_by_user_id UUID NOT NULL,  -- FK to users.id
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  status completion_status_enum NOT NULL DEFAULT 'SUBMITTED',
  attestation_text TEXT,  -- "I confirm all materials installed..."
  attestation_signature TEXT,  -- Digital signature or acknowledgment hash
  attestation_ip_address TEXT,
  notes TEXT,
  reviewed_by_user_id UUID,  -- FK to users.id
  reviewed_at TIMESTAMPTZ,
  review_notes TEXT,
  rejection_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TRIGGER completion_submissions_updated_at BEFORE UPDATE ON completion_submissions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_completion_submissions_assignment ON completion_submissions(store_assignment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_completion_submissions_status ON completion_submissions(status) WHERE status = 'SUBMITTED';
CREATE INDEX idx_completion_submissions_submitted_at ON completion_submissions(submitted_at DESC);
CREATE INDEX idx_completion_submissions_submitter ON completion_submissions(submitted_by_user_id);

COMMENT ON TABLE completion_submissions IS 'Final completion attestation from store for campaign assignments';
COMMENT ON COLUMN completion_submissions.store_assignment_id IS 'One-to-one with store_assignments (only one submission allowed)';
COMMENT ON COLUMN completion_submissions.attestation_text IS 'Full text of what the store user attested to';
COMMENT ON COLUMN completion_submissions.attestation_signature IS 'Hash or digital signature of attestation';
COMMENT ON COLUMN completion_submissions.attestation_ip_address IS 'IP address at time of submission for audit';


-- ==============================================================================
-- FOREIGN KEY CONSTRAINTS
-- ==============================================================================
-- Note: These will be added after referenced tables exist in the database
-- For now, documenting the intended relationships:

-- ALTER TABLE repeatable_sections
--   ADD CONSTRAINT fk_repeatable_sections_survey_version
--   FOREIGN KEY (survey_version_id) REFERENCES survey_versions(id) ON DELETE CASCADE;

-- ALTER TABLE response_edit_audit
--   ADD CONSTRAINT fk_response_edit_audit_response
--   FOREIGN KEY (store_survey_response_id) REFERENCES store_survey_responses(id) ON DELETE RESTRICT;

-- ALTER TABLE response_edit_audit
--   ADD CONSTRAINT fk_response_edit_audit_actor
--   FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE RESTRICT;

-- ALTER TABLE photo_links
--   ADD CONSTRAINT fk_photo_links_photo
--   FOREIGN KEY (photo_upload_id) REFERENCES photo_uploads(id) ON DELETE CASCADE;

-- ALTER TABLE photo_links
--   ADD CONSTRAINT fk_photo_links_campaign
--   FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE;

-- ALTER TABLE photo_links
--   ADD CONSTRAINT fk_photo_links_store
--   FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE;

-- ALTER TABLE photo_links
--   ADD CONSTRAINT fk_photo_links_assignment
--   FOREIGN KEY (store_assignment_id) REFERENCES store_assignments(id) ON DELETE CASCADE;

-- ALTER TABLE photo_links
--   ADD CONSTRAINT fk_photo_links_item
--   FOREIGN KEY (assignment_item_id) REFERENCES assignment_items(id) ON DELETE SET NULL;

-- ALTER TABLE photo_links
--   ADD CONSTRAINT fk_photo_links_slot
--   FOREIGN KEY (location_slot_id) REFERENCES location_slots(id) ON DELETE SET NULL;

-- ALTER TABLE photo_links
--   ADD CONSTRAINT fk_photo_links_rule
--   FOREIGN KEY (photo_rule_id) REFERENCES photo_rules(id) ON DELETE SET NULL;

-- ALTER TABLE store_change_verifications
--   ADD CONSTRAINT fk_store_change_verifications_store
--   FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE;

-- ALTER TABLE store_change_verifications
--   ADD CONSTRAINT fk_store_change_verifications_campaign
--   FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE SET NULL;

-- ALTER TABLE store_change_verifications
--   ADD CONSTRAINT fk_store_change_verifications_requested_by
--   FOREIGN KEY (requested_by_user_id) REFERENCES users(id) ON DELETE SET NULL;

-- ALTER TABLE store_change_verifications
--   ADD CONSTRAINT fk_store_change_verifications_verified_by
--   FOREIGN KEY (verified_by_user_id) REFERENCES users(id) ON DELETE SET NULL;

-- ALTER TABLE store_id_aliases
--   ADD CONSTRAINT fk_store_id_aliases_store
--   FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE;

-- ALTER TABLE completion_submissions
--   ADD CONSTRAINT fk_completion_submissions_assignment
--   FOREIGN KEY (store_assignment_id) REFERENCES store_assignments(id) ON DELETE CASCADE;

-- ALTER TABLE completion_submissions
--   ADD CONSTRAINT fk_completion_submissions_submitter
--   FOREIGN KEY (submitted_by_user_id) REFERENCES users(id) ON DELETE RESTRICT;

-- ALTER TABLE completion_submissions
--   ADD CONSTRAINT fk_completion_submissions_reviewer
--   FOREIGN KEY (reviewed_by_user_id) REFERENCES users(id) ON DELETE SET NULL;


-- ==============================================================================
-- END OF MISSING TABLES DDL
-- ==============================================================================
