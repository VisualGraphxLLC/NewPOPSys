-- ===========================================================================
-- SURVEY ENHANCEMENTS - DATABASE SCHEMA
-- ===========================================================================
-- Version: 1.0
-- Generated: 2025-12-23
-- Dependencies: brand_module_ddl.sql (survey_templates, survey_versions, store_survey_responses)
--
-- This schema adds enhanced survey functionality including:
-- - Survey response edit audits (for brand admin edits on behalf of stores)
-- - Survey field definitions (normalized field metadata)
-- - Survey type enumeration
-- - Store layout templates (for bulk layout creation)
-- ===========================================================================

-- Enable UUID generation (if not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ===========================================================================
-- SECTION 1: SURVEY TEMPLATE ENHANCEMENTS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Add survey_type to survey_templates for categorization
-- ---------------------------------------------------------------------------
ALTER TABLE survey_templates
    ADD COLUMN IF NOT EXISTS survey_type TEXT NOT NULL DEFAULT 'CUSTOM',
    ADD COLUMN IF NOT EXISTS created_by_user_id UUID,
    ADD CONSTRAINT chk_survey_templates_type
        CHECK (survey_type IN ('RECEIPT', 'INSTALL', 'AUDIT', 'CUSTOM')),
    ADD CONSTRAINT fk_survey_templates_creator
        FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON COLUMN survey_templates.survey_type IS 'Survey category: RECEIPT (kit verification), INSTALL (photo proof), AUDIT (compliance check), CUSTOM (brand-specific)';
COMMENT ON COLUMN survey_templates.created_by_user_id IS 'User who created this template';

-- ---------------------------------------------------------------------------
-- TABLE: survey_fields
-- Purpose: Normalized survey field definitions for analytics and validation
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS survey_fields (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    survey_version_id UUID NOT NULL,
    field_id TEXT NOT NULL,
    field_type TEXT NOT NULL,
    label TEXT NOT NULL,
    description TEXT,
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order INT NOT NULL DEFAULT 0,
    validation_rules JSONB,
    options JSONB,
    conditional_logic JSONB,
    photo_rule_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_survey_fields_version FOREIGN KEY (survey_version_id)
        REFERENCES survey_versions(id) ON DELETE CASCADE,
    CONSTRAINT fk_survey_fields_photo_rule FOREIGN KEY (photo_rule_id)
        REFERENCES photo_rules(id) ON DELETE SET NULL,
    CONSTRAINT uq_survey_fields_version_field UNIQUE (survey_version_id, field_id),
    CONSTRAINT chk_survey_fields_type CHECK (field_type IN (
        'TEXT', 'TEXTAREA', 'NUMBER', 'DROPDOWN', 'CHECKBOX',
        'RADIO', 'DATE', 'DATETIME', 'PHOTO', 'SIGNATURE',
        'SECTION', 'REPEATABLE'
    ))
);

COMMENT ON TABLE survey_fields IS 'Normalized field definitions extracted from survey_versions.definition_json for analytics';
COMMENT ON COLUMN survey_fields.field_id IS 'Unique identifier within the survey (e.g., all_items_received)';
COMMENT ON COLUMN survey_fields.field_type IS 'Field input type: TEXT, TEXTAREA, NUMBER, DROPDOWN, CHECKBOX, RADIO, DATE, DATETIME, PHOTO, SIGNATURE, SECTION, REPEATABLE';
COMMENT ON COLUMN survey_fields.validation_rules IS 'JSON validation config (min, max, pattern, etc.)';
COMMENT ON COLUMN survey_fields.options IS 'JSON array of options for DROPDOWN/RADIO fields';
COMMENT ON COLUMN survey_fields.conditional_logic IS 'JSON rules for conditional visibility';
COMMENT ON COLUMN survey_fields.photo_rule_id IS 'Associated photo rule for PHOTO field types';

-- ===========================================================================
-- SECTION 2: SURVEY RESPONSE ENHANCEMENTS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Add additional metadata to store_survey_responses
-- ---------------------------------------------------------------------------
ALTER TABLE store_survey_responses
    ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'IN_PROGRESS',
    ADD COLUMN IF NOT EXISTS device_info JSONB,
    ADD COLUMN IF NOT EXISTS location_lat DECIMAL(10, 8),
    ADD COLUMN IF NOT EXISTS location_lng DECIMAL(11, 8),
    ADD COLUMN IF NOT EXISTS completion_time_seconds INT,
    ADD CONSTRAINT chk_store_survey_responses_status
        CHECK (status IN ('IN_PROGRESS', 'SUBMITTED', 'NEEDS_REVIEW', 'APPROVED', 'REJECTED'));

COMMENT ON COLUMN store_survey_responses.status IS 'Response status: IN_PROGRESS, SUBMITTED, NEEDS_REVIEW, APPROVED, REJECTED';
COMMENT ON COLUMN store_survey_responses.device_info IS 'Device metadata (model, OS, app version)';
COMMENT ON COLUMN store_survey_responses.location_lat IS 'GPS latitude at submission';
COMMENT ON COLUMN store_survey_responses.location_lng IS 'GPS longitude at submission';
COMMENT ON COLUMN store_survey_responses.completion_time_seconds IS 'Time taken to complete survey';

-- ---------------------------------------------------------------------------
-- TABLE: survey_response_edits
-- Purpose: Audit trail for brand admin edits to store survey responses
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS survey_response_edits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_survey_response_id UUID NOT NULL,
    edited_by_user_id UUID NOT NULL,
    edit_reason TEXT NOT NULL,
    field_id TEXT NOT NULL,
    old_value JSONB,
    new_value JSONB,
    edited_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_survey_response_edits_response FOREIGN KEY (store_survey_response_id)
        REFERENCES store_survey_responses(id) ON DELETE CASCADE,
    CONSTRAINT fk_survey_response_edits_user FOREIGN KEY (edited_by_user_id)
        REFERENCES users(id) ON DELETE RESTRICT
);

COMMENT ON TABLE survey_response_edits IS 'Audit trail for brand admin edits to store survey responses';
COMMENT ON COLUMN survey_response_edits.edit_reason IS 'Reason for the edit (required for audit)';
COMMENT ON COLUMN survey_response_edits.field_id IS 'Which field was edited';
COMMENT ON COLUMN survey_response_edits.old_value IS 'Previous value before edit';
COMMENT ON COLUMN survey_response_edits.new_value IS 'New value after edit';

-- ===========================================================================
-- SECTION 3: STORE LAYOUT ENHANCEMENTS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- TABLE: layout_templates
-- Purpose: Reusable layout templates for bulk store configuration
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS layout_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    template_json JSONB NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_by_user_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_layout_templates_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE,
    CONSTRAINT fk_layout_templates_creator FOREIGN KEY (created_by_user_id)
        REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE layout_templates IS 'Reusable layout templates for quick store setup';
COMMENT ON COLUMN layout_templates.template_json IS 'JSON array of slot definitions to copy to stores';
COMMENT ON COLUMN layout_templates.is_default IS 'Whether this is the default template for new stores';

-- ---------------------------------------------------------------------------
-- Add slot_type enumeration and additional metadata to location_slots
-- ---------------------------------------------------------------------------
ALTER TABLE location_slots
    ADD COLUMN IF NOT EXISTS description TEXT,
    ADD COLUMN IF NOT EXISTS photo_rule_id UUID,
    ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE,
    ADD CONSTRAINT fk_location_slots_photo_rule FOREIGN KEY (photo_rule_id)
        REFERENCES photo_rules(id) ON DELETE SET NULL,
    ADD CONSTRAINT chk_location_slots_type CHECK (slot_type IN (
        'WINDOW', 'DOOR', 'SHELF', 'COOLER', 'FREEZER',
        'END_CAP', 'COUNTER', 'FLOOR', 'CEILING', 'WALL', 'OTHER'
    ));

COMMENT ON COLUMN location_slots.description IS 'Detailed description or instructions for this slot';
COMMENT ON COLUMN location_slots.photo_rule_id IS 'Default photo rule for this slot type';
COMMENT ON COLUMN location_slots.is_active IS 'Whether this slot is currently active';

-- ===========================================================================
-- SECTION 4: PHOTO RULES ENHANCEMENTS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Add additional fields to photo_rules
-- ---------------------------------------------------------------------------
ALTER TABLE photo_rules
    ADD COLUMN IF NOT EXISTS created_by_user_id UUID,
    ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE,
    ADD COLUMN IF NOT EXISTS allowed_sources TEXT[] DEFAULT ARRAY['CAMERA', 'GALLERY'],
    ADD CONSTRAINT fk_photo_rules_creator FOREIGN KEY (created_by_user_id)
        REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON COLUMN photo_rules.created_by_user_id IS 'User who created this rule';
COMMENT ON COLUMN photo_rules.is_active IS 'Whether this rule is currently active';
COMMENT ON COLUMN photo_rules.allowed_sources IS 'Allowed photo sources: CAMERA, GALLERY';

-- ===========================================================================
-- SECTION 5: INDEXES
-- ===========================================================================

-- Survey fields
CREATE INDEX IF NOT EXISTS idx_survey_fields_version ON survey_fields(survey_version_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_survey_fields_type ON survey_fields(field_type) WHERE deleted_at IS NULL;

-- Survey response edits
CREATE INDEX IF NOT EXISTS idx_survey_response_edits_response ON survey_response_edits(store_survey_response_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_survey_response_edits_user ON survey_response_edits(edited_by_user_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_survey_response_edits_time ON survey_response_edits(edited_at DESC) WHERE deleted_at IS NULL;

-- Store survey responses status
CREATE INDEX IF NOT EXISTS idx_store_survey_responses_status ON store_survey_responses(status) WHERE deleted_at IS NULL;

-- Layout templates
CREATE INDEX IF NOT EXISTS idx_layout_templates_brand ON layout_templates(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_layout_templates_default ON layout_templates(brand_id, is_default) WHERE deleted_at IS NULL AND is_default = TRUE;

-- ===========================================================================
-- SECTION 6: TRIGGERS
-- ===========================================================================

-- Apply updated_at trigger to new tables
CREATE TRIGGER update_survey_fields_updated_at BEFORE UPDATE ON survey_fields
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_survey_response_edits_updated_at BEFORE UPDATE ON survey_response_edits
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_layout_templates_updated_at BEFORE UPDATE ON layout_templates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ===========================================================================
-- END OF SURVEY ENHANCEMENTS SCHEMA
-- ===========================================================================
