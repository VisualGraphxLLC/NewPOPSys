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
    ADD COLUMN IF NOT EXISTS survey_type TEXT NOT NULL DEFAULT 'LAYOUT',
    ADD COLUMN IF NOT EXISTS created_by_user_id UUID,
    ADD COLUMN IF NOT EXISTS store_type_id UUID,
    ADD COLUMN IF NOT EXISTS is_default BOOLEAN NOT NULL DEFAULT FALSE,
    ADD CONSTRAINT chk_survey_templates_type
        CHECK (survey_type IN ('LAYOUT', 'CAMPAIGN', 'EXCEPTION')),
    ADD CONSTRAINT fk_survey_templates_creator
        FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_survey_templates_store_type
        FOREIGN KEY (store_type_id) REFERENCES store_types(id) ON DELETE SET NULL;

COMMENT ON COLUMN survey_templates.survey_type IS 'Survey category: LAYOUT (store layout definition), CAMPAIGN (campaign-specific universal survey), EXCEPTION (fixed exception reporting)';
COMMENT ON COLUMN survey_templates.store_type_id IS 'Optional store type for custom layout surveys (NULL = default for all store types)';
COMMENT ON COLUMN survey_templates.is_default IS 'Whether this is the default layout survey for the brand';
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
-- TABLE: slot_types
-- Purpose: Brand-configurable slot types (extensible for different industries)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS slot_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL,
    code TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    icon TEXT,
    color TEXT,
    sort_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_slot_types_brand FOREIGN KEY (brand_id)
        REFERENCES brands(id) ON DELETE CASCADE,
    CONSTRAINT uq_slot_types_brand_code UNIQUE (brand_id, code)
);

COMMENT ON TABLE slot_types IS 'Brand-configurable slot types for different industries (retail, hospital, food truck, medical office, etc.)';
COMMENT ON COLUMN slot_types.code IS 'Unique code within brand (e.g., WINDOW, EXAM_ROOM, TRUCK_SIDE)';
COMMENT ON COLUMN slot_types.name IS 'Display name (e.g., Window Display, Exam Room, Truck Side Panel)';
COMMENT ON COLUMN slot_types.icon IS 'Optional icon identifier for UI display';
COMMENT ON COLUMN slot_types.color IS 'Optional color hex code for UI display';

-- Default retail slot types (can be seeded per brand or copied from template)
-- Example industry types:
-- RETAIL: WINDOW, DOOR, SHELF, COOLER, FREEZER, END_CAP, COUNTER, FLOOR, CEILING, WALL
-- HOSPITAL: LOBBY, WAITING_ROOM, EXAM_ROOM, HALLWAY, NURSES_STATION, PHARMACY
-- FOOD_TRUCK: EXTERIOR_FRONT, EXTERIOR_SIDE, EXTERIOR_BACK, MENU_BOARD, WINDOW
-- MEDICAL_OFFICE: RECEPTION, WAITING_AREA, EXAM_ROOM, CONSULTATION, CHECKOUT

-- ---------------------------------------------------------------------------
-- Update location_slots to reference slot_types table
-- ---------------------------------------------------------------------------
ALTER TABLE location_slots
    ADD COLUMN IF NOT EXISTS slot_type_id UUID,
    ADD COLUMN IF NOT EXISTS description TEXT,
    ADD COLUMN IF NOT EXISTS photo_rule_id UUID,
    ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE,
    ADD CONSTRAINT fk_location_slots_slot_type FOREIGN KEY (slot_type_id)
        REFERENCES slot_types(id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_location_slots_photo_rule FOREIGN KEY (photo_rule_id)
        REFERENCES photo_rules(id) ON DELETE SET NULL;

COMMENT ON COLUMN location_slots.slot_type_id IS 'Reference to brand-configurable slot type';
COMMENT ON COLUMN location_slots.description IS 'Detailed description or instructions for this slot';
COMMENT ON COLUMN location_slots.photo_rule_id IS 'Default photo rule for this slot type';
COMMENT ON COLUMN location_slots.is_active IS 'Whether this slot is currently active';

-- ---------------------------------------------------------------------------
-- TABLE: location_slot_attachments
-- Purpose: Attachments for location slots (photos, templates, mockups)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS location_slot_attachments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    location_slot_id UUID NOT NULL,
    attachment_type TEXT NOT NULL,
    file_url TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size_bytes INT,
    mime_type TEXT,
    title TEXT,
    description TEXT,
    sort_order INT NOT NULL DEFAULT 0,
    uploaded_by_user_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_location_slot_attachments_slot FOREIGN KEY (location_slot_id)
        REFERENCES location_slots(id) ON DELETE CASCADE,
    CONSTRAINT fk_location_slot_attachments_uploader FOREIGN KEY (uploaded_by_user_id)
        REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_location_slot_attachments_type CHECK (attachment_type IN (
        'REFERENCE_PHOTO',   -- Reference photo showing expected installation
        'ARTWORK_TEMPLATE',  -- Artwork template for designers
        'MOCKUP',            -- Brand approval mockup / install guide
        'PLANOGRAM'          -- Planogram or layout diagram
    ))
);

COMMENT ON TABLE location_slot_attachments IS 'Attachments for location slots including reference photos, artwork templates, and mockups';
COMMENT ON COLUMN location_slot_attachments.attachment_type IS 'Type: REFERENCE_PHOTO (expected install), ARTWORK_TEMPLATE (for designers), MOCKUP (brand approval/install guide), PLANOGRAM';
COMMENT ON COLUMN location_slot_attachments.file_url IS 'URL to the attachment file in cloud storage';
COMMENT ON COLUMN location_slot_attachments.title IS 'Display title for the attachment';
COMMENT ON COLUMN location_slot_attachments.description IS 'Description or instructions for this attachment';

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

-- Location slot attachments
CREATE INDEX IF NOT EXISTS idx_location_slot_attachments_slot ON location_slot_attachments(location_slot_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_location_slot_attachments_type ON location_slot_attachments(attachment_type) WHERE deleted_at IS NULL;

-- Slot types
CREATE INDEX IF NOT EXISTS idx_slot_types_brand ON slot_types(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_slot_types_brand_active ON slot_types(brand_id, is_active) WHERE deleted_at IS NULL;

-- Location slots slot type
CREATE INDEX IF NOT EXISTS idx_location_slots_slot_type ON location_slots(slot_type_id) WHERE deleted_at IS NULL;

-- Survey templates store type
CREATE INDEX IF NOT EXISTS idx_survey_templates_store_type ON survey_templates(store_type_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_survey_templates_default ON survey_templates(brand_id, is_default) WHERE deleted_at IS NULL AND is_default = TRUE;

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

CREATE TRIGGER update_location_slot_attachments_updated_at BEFORE UPDATE ON location_slot_attachments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_slot_types_updated_at BEFORE UPDATE ON slot_types
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ===========================================================================
-- END OF SURVEY ENHANCEMENTS SCHEMA
-- ===========================================================================
