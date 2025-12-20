-- ==============================================================================
-- TRIGGERS: AUTO-UPDATE TIMESTAMPS
-- ==============================================================================
-- Automatic updated_at timestamp updates for all tables
--
-- Dependencies: 00_foundation_ddl.sql (defines update_updated_at_column function)
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- TRIGGER FUNCTION (already defined in 00_foundation_ddl.sql)
-- ==============================================================================
-- CREATE OR REPLACE FUNCTION update_updated_at_column()
-- RETURNS TRIGGER AS $$
-- BEGIN
--   NEW.updated_at = NOW();
--   RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- ==============================================================================
-- NOTE ON EXISTING TRIGGERS
-- ==============================================================================
-- The following tables already have updated_at triggers defined in their DDL:
--
-- From 00_foundation_ddl.sql:
--   - tenants, brands, users, memberships, api_keys
--   - audit_events, notification_preferences, notifications
--   - webhook_endpoints, webhook_deliveries, export_jobs
--
-- From brand_module_ddl.sql:
--   - regions, districts, territories, stores
--   - store_groups, store_group_memberships
--   - store_layouts, location_slots
--   - survey_templates, survey_versions, photo_rules
--   - kit_definitions, kit_items, campaigns
--   - store_assignments, assignment_items
--   - store_orders, order_lines, shipments, shipment_lines
--   - receive_verifications, store_survey_responses
--   - photo_uploads, photo_reviews, retake_requests
--   - issue_requests, issue_lines, reorders
--
-- From 12_missing_tables.sql:
--   - repeatable_sections, photo_links
--   - store_change_verifications, store_id_aliases
--   - completion_submissions
--
-- This file ensures coverage for any tables that might be missing triggers
-- and serves as a reference for the trigger pattern.
-- ==============================================================================

-- ==============================================================================
-- VERIFY ALL TABLES HAVE updated_at TRIGGERS
-- ==============================================================================

-- The following query can be used to verify all tables with updated_at column have triggers:
/*
SELECT
  t.table_name,
  CASE
    WHEN EXISTS (
      SELECT 1
      FROM information_schema.triggers tr
      WHERE tr.event_object_table = t.table_name
        AND tr.trigger_name LIKE '%updated_at%'
        AND tr.action_timing = 'BEFORE'
        AND tr.event_manipulation = 'UPDATE'
    ) THEN 'HAS_TRIGGER'
    ELSE 'MISSING_TRIGGER'
  END AS trigger_status
FROM information_schema.tables t
WHERE t.table_schema = 'public'
  AND t.table_type = 'BASE TABLE'
  AND EXISTS (
    SELECT 1
    FROM information_schema.columns c
    WHERE c.table_name = t.table_name
      AND c.column_name = 'updated_at'
  )
ORDER BY trigger_status DESC, t.table_name;
*/

-- ==============================================================================
-- TRIGGER PATTERN FOR NEW TABLES
-- ==============================================================================
-- When adding new tables with updated_at column, use this pattern:
--
-- CREATE TRIGGER <table_name>_updated_at
--   BEFORE UPDATE ON <table_name>
--   FOR EACH ROW
--   EXECUTE FUNCTION update_updated_at_column();
--
-- Example:
-- CREATE TRIGGER new_table_updated_at
--   BEFORE UPDATE ON new_table
--   FOR EACH ROW
--   EXECUTE FUNCTION update_updated_at_column();
-- ==============================================================================

-- ==============================================================================
-- AUDIT: TABLES WITHOUT updated_at (BY DESIGN)
-- ==============================================================================
-- The following tables intentionally do NOT have updated_at:
--   - response_edit_audit: Immutable audit trail (only created_at)
--
-- These tables use created_at only as they represent immutable events.
-- ==============================================================================

-- ==============================================================================
-- ADDITIONAL TIMESTAMP TRIGGERS (IF NEEDED)
-- ==============================================================================

-- No additional timestamp triggers needed at this time.
-- All tables with updated_at column already have triggers defined in their DDL.

-- ==============================================================================
-- END OF TIMESTAMP TRIGGERS
-- ==============================================================================
