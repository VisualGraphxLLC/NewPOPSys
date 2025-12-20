-- ==============================================================================
-- TRIGGERS: SOFT DELETE ENFORCEMENT
-- ==============================================================================
-- Prevent hard deletes and enforce soft delete pattern for all tables with deleted_at
--
-- Dependencies: 00_foundation_ddl.sql, brand_module_ddl.sql, 12_missing_tables.sql
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- SOFT DELETE TRIGGER FUNCTION
-- ==============================================================================

CREATE OR REPLACE FUNCTION enforce_soft_delete()
RETURNS TRIGGER AS $$
BEGIN
  -- Prevent hard delete, raise exception
  RAISE EXCEPTION 'Hard delete not allowed on table %. Use UPDATE to set deleted_at instead.',
    TG_TABLE_NAME
    USING HINT = 'Execute: UPDATE ' || TG_TABLE_NAME || ' SET deleted_at = NOW() WHERE id = ''' || OLD.id || '''';

  RETURN NULL; -- Prevent the DELETE
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION enforce_soft_delete IS
  'Trigger function to prevent hard deletes and enforce soft delete pattern (deleted_at)';

-- ==============================================================================
-- APPLY SOFT DELETE TRIGGER TO ALL TABLES WITH deleted_at
-- ==============================================================================

-- Foundation tables (from 00_foundation_ddl.sql)
CREATE TRIGGER prevent_hard_delete_tenants
  BEFORE DELETE ON tenants
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_brands
  BEFORE DELETE ON brands
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_users
  BEFORE DELETE ON users
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_memberships
  BEFORE DELETE ON memberships
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_api_keys
  BEFORE DELETE ON api_keys
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_notification_preferences
  BEFORE DELETE ON notification_preferences
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_notifications
  BEFORE DELETE ON notifications
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_webhook_endpoints
  BEFORE DELETE ON webhook_endpoints
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_webhook_deliveries
  BEFORE DELETE ON webhook_deliveries
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_export_jobs
  BEFORE DELETE ON export_jobs
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

-- Geographic hierarchy (from brand_module_ddl.sql)
CREATE TRIGGER prevent_hard_delete_regions
  BEFORE DELETE ON regions
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_districts
  BEFORE DELETE ON districts
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_territories
  BEFORE DELETE ON territories
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_stores
  BEFORE DELETE ON stores
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_store_groups
  BEFORE DELETE ON store_groups
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_store_group_memberships
  BEFORE DELETE ON store_group_memberships
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

-- Layouts and surveys (from brand_module_ddl.sql)
CREATE TRIGGER prevent_hard_delete_store_layouts
  BEFORE DELETE ON store_layouts
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_location_slots
  BEFORE DELETE ON location_slots
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_survey_templates
  BEFORE DELETE ON survey_templates
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_survey_versions
  BEFORE DELETE ON survey_versions
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_photo_rules
  BEFORE DELETE ON photo_rules
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

-- Campaigns and kits (from brand_module_ddl.sql)
CREATE TRIGGER prevent_hard_delete_kit_definitions
  BEFORE DELETE ON kit_definitions
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_kit_items
  BEFORE DELETE ON kit_items
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_campaigns
  BEFORE DELETE ON campaigns
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

-- Assignments (from brand_module_ddl.sql)
CREATE TRIGGER prevent_hard_delete_store_assignments
  BEFORE DELETE ON store_assignments
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_assignment_items
  BEFORE DELETE ON assignment_items
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

-- Orders and shipments (from brand_module_ddl.sql)
CREATE TRIGGER prevent_hard_delete_store_orders
  BEFORE DELETE ON store_orders
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_order_lines
  BEFORE DELETE ON order_lines
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_shipments
  BEFORE DELETE ON shipments
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_shipment_lines
  BEFORE DELETE ON shipment_lines
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

-- Execution and verification (from brand_module_ddl.sql)
CREATE TRIGGER prevent_hard_delete_receive_verifications
  BEFORE DELETE ON receive_verifications
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_store_survey_responses
  BEFORE DELETE ON store_survey_responses
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_photo_uploads
  BEFORE DELETE ON photo_uploads
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_photo_reviews
  BEFORE DELETE ON photo_reviews
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_retake_requests
  BEFORE DELETE ON retake_requests
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

-- Issues and reorders (from brand_module_ddl.sql)
CREATE TRIGGER prevent_hard_delete_issue_requests
  BEFORE DELETE ON issue_requests
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_issue_lines
  BEFORE DELETE ON issue_lines
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_reorders
  BEFORE DELETE ON reorders
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

-- Missing tables (from 12_missing_tables.sql)
CREATE TRIGGER prevent_hard_delete_repeatable_sections
  BEFORE DELETE ON repeatable_sections
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_photo_links
  BEFORE DELETE ON photo_links
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_store_change_verifications
  BEFORE DELETE ON store_change_verifications
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_store_id_aliases
  BEFORE DELETE ON store_id_aliases
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

CREATE TRIGGER prevent_hard_delete_completion_submissions
  BEFORE DELETE ON completion_submissions
  FOR EACH ROW EXECUTE FUNCTION enforce_soft_delete();

-- ==============================================================================
-- TABLES WITHOUT SOFT DELETE (BY DESIGN)
-- ==============================================================================
-- The following tables do NOT have deleted_at and allow hard deletes:
--
-- Immutable audit/event tables:
--   - audit_events: Immutable audit trail (never delete)
--   - response_edit_audit: Immutable edit history (never delete)
--
-- These tables should never be deleted in normal operations.
-- If cleanup is needed, it should be done via archival processes.
-- ==============================================================================

-- ==============================================================================
-- SOFT DELETE HELPER FUNCTION
-- ==============================================================================

CREATE OR REPLACE FUNCTION soft_delete(
  p_table_name TEXT,
  p_id UUID
) RETURNS BOOLEAN AS $$
DECLARE
  v_sql TEXT;
  v_rows_affected INTEGER;
BEGIN
  -- Construct dynamic SQL for soft delete
  v_sql := format(
    'UPDATE %I SET deleted_at = NOW() WHERE id = $1 AND deleted_at IS NULL',
    p_table_name
  );

  -- Execute soft delete
  EXECUTE v_sql USING p_id;

  GET DIAGNOSTICS v_rows_affected = ROW_COUNT;

  RETURN v_rows_affected > 0;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION soft_delete IS
  'Helper function to soft delete a record by table name and ID. Returns TRUE if row was deleted, FALSE if not found or already deleted.';

-- Example usage:
-- SELECT soft_delete('campaigns', 'uuid-here');

-- ==============================================================================
-- SOFT DELETE RESTORE HELPER FUNCTION
-- ==============================================================================

CREATE OR REPLACE FUNCTION soft_undelete(
  p_table_name TEXT,
  p_id UUID
) RETURNS BOOLEAN AS $$
DECLARE
  v_sql TEXT;
  v_rows_affected INTEGER;
BEGIN
  -- Construct dynamic SQL for restore
  v_sql := format(
    'UPDATE %I SET deleted_at = NULL WHERE id = $1 AND deleted_at IS NOT NULL',
    p_table_name
  );

  -- Execute restore
  EXECUTE v_sql USING p_id;

  GET DIAGNOSTICS v_rows_affected = ROW_COUNT;

  RETURN v_rows_affected > 0;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION soft_undelete IS
  'Helper function to restore a soft-deleted record by table name and ID. Returns TRUE if row was restored, FALSE if not found or not deleted.';

-- Example usage:
-- SELECT soft_undelete('campaigns', 'uuid-here');

-- ==============================================================================
-- VERIFICATION QUERY
-- ==============================================================================

-- Query to verify all tables with deleted_at have soft delete triggers:
/*
SELECT
  t.table_name,
  CASE
    WHEN EXISTS (
      SELECT 1
      FROM information_schema.triggers tr
      WHERE tr.event_object_table = t.table_name
        AND tr.trigger_name LIKE 'prevent_hard_delete_%'
        AND tr.action_timing = 'BEFORE'
        AND tr.event_manipulation = 'DELETE'
    ) THEN 'PROTECTED'
    ELSE 'UNPROTECTED'
  END AS soft_delete_status
FROM information_schema.tables t
WHERE t.table_schema = 'public'
  AND t.table_type = 'BASE TABLE'
  AND EXISTS (
    SELECT 1
    FROM information_schema.columns c
    WHERE c.table_name = t.table_name
      AND c.column_name = 'deleted_at'
  )
ORDER BY soft_delete_status DESC, t.table_name;
*/

-- ==============================================================================
-- END OF SOFT DELETE TRIGGERS
-- ==============================================================================
