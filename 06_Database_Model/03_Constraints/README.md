# Package 4: CHECK Constraints & Triggers

**Version**: 1.0
**Created**: 2025-12-19
**Status**: Complete

## Overview

This package contains all CHECK constraints, business rule validations, and triggers for the NewPOPSys database. It enforces data integrity at the database level to ensure business rules are consistently applied.

## Files in This Package

### 1. `01_check_campaigns.sql`
**Purpose**: Campaign lifecycle and validation rules

**Constraints Added**:
- `chk_campaigns_published_at`: Published campaigns must have published_at timestamp
- `chk_campaigns_published_by`: Published campaigns must have published_by_user_id
- `chk_campaigns_archived_at`: Archived campaigns must have archived_at timestamp
- `chk_campaigns_archived_by`: Archived campaigns must have archived_by_user_id
- `chk_store_layouts_version`: Layout version must be >= 1
- `chk_survey_versions_version`: Survey version must be >= 1
- `chk_photo_rules_min_photos`: Min photos must be >= 0
- `chk_photo_rules_max_photos`: Max photos must be >= 1

**Key Business Rules**:
- Campaign dates: end_date >= start_date
- Status must be valid lifecycle state
- Published campaigns require publisher and timestamp
- Photo rules: min_photos <= max_photos

---

### 2. `02_check_assignments.sql`
**Purpose**: Assignment lifecycle, readiness, and status transition rules

**Constraints Added**:
- `chk_store_assignments_ready_unblocked`: READY status requires empty blocked_reasons
- `chk_store_assignments_ready_at`: READY+ requires ready_at timestamp
- `chk_store_assignments_started_at`: IN_PROGRESS+ requires started_at timestamp
- `chk_store_assignments_submitted_at`: SUBMITTED+ requires submitted_at timestamp
- `chk_store_assignments_submitted_by`: SUBMITTED+ requires submitted_by_user_id
- `chk_store_assignments_completed_at`: COMPLETE requires completed_at timestamp
- `chk_store_assignments_completed_by`: COMPLETE requires completed_by_user_id
- `chk_store_assignments_reopened_*`: REOPENED requires at, by, and reason
- `chk_store_assignments_waived_*`: WAIVED requires at, by, and reason
- `chk_assignment_items_qty_*`: Quantity tracking validation (non-negative, flow validation)
- `chk_assignment_items_exception_reason`: EXCEPTION items require reason
- `chk_completion_submissions_*`: Completion attestation validation

**Key Business Rules**:
- Status transitions require appropriate timestamps and actors
- Quantity flow: shipped >= delivered >= received >= installed >= satisfied
- Reopened and waived assignments require justification
- Exception items must explain the problem

---

### 3. `03_check_orders.sql`
**Purpose**: Order lifecycle, shipment tracking, and fulfillment rules

**Constraints Added**:
- `chk_store_orders_acknowledged_at`: ACKNOWLEDGED+ requires timestamp
- `chk_store_orders_production_started_at`: IN_PRODUCTION+ requires timestamp
- `chk_store_orders_kitting_started_at`: KITTING+ requires timestamp
- `chk_store_orders_ready_to_ship_at`: READY_TO_SHIP+ requires timestamp
- `chk_store_orders_shipped_at`: SHIPPED+ requires timestamp
- `chk_store_orders_delivered_at`: DELIVERED requires timestamp
- `chk_store_orders_cancelled_*`: CANCELLED requires at, by, and reason
- `chk_store_orders_closed_at`: CLOSED requires timestamp
- `chk_shipments_shipped_at`: IN_TRANSIT+ requires timestamp
- `chk_shipments_delivered_at`: DELIVERED requires timestamp
- `chk_shipments_delivered_after_shipped`: Delivery must be after shipment

**Key Business Rules**:
- Each status requires its corresponding timestamp
- Cancelled orders require cancellation details
- Delivery timestamp must be after shipment timestamp
- Line item quantities must be positive

---

### 4. `04_check_photos.sql`
**Purpose**: Photo upload validation, review rules, and retake requirements

**Constraints Added**:
- `chk_photo_uploads_file_size`: File size must be positive
- `chk_photo_uploads_mime_type`: MIME type must be valid image format
- `chk_photo_uploads_item_or_slot`: Photo must link to item OR slot
- `chk_photo_uploads_s3_key`: S3 key must be set
- `chk_photo_reviews_rejected_reason`: REJECTED reviews require reason
- `chk_photo_reviews_approved_no_reason`: APPROVED reviews should not have rejection details
- `chk_retake_requests_resolved_at`: Resolved retakes require timestamp
- `chk_retake_requests_completed_photo`: COMPLETED retakes require new_photo_upload_id
- `chk_retake_requests_waived_*`: WAIVED retakes require by and notes
- `chk_receive_verifications_all_items`: Receipt flag must be explicitly set

**Key Business Rules**:
- Photos must be valid images (jpeg, png, heic, heif, webp)
- Photos must have at least one target (item or slot)
- Rejected photos require rejection reason
- Retakes require new photo when completed
- Receive verifications must explicitly state if all items received

---

### 5. `05_check_issues.sql`
**Purpose**: Issue request validation, resolution workflow, and change verification

**Constraints Added**:
- `chk_issue_requests_evidence_photo`: DAMAGED/PACKAGING require evidence_photo_id
- `chk_issue_requests_triaged_*`: TRIAGED+ requires at and by
- `chk_issue_requests_approved_*`: APPROVED+ requires at and by
- `chk_issue_requests_denied_*`: DENIED requires at, by, and reason
- `chk_issue_requests_resolved_*`: RESOLVED requires at, by, and type
- `chk_store_change_verifications_changed_fields`: Changed fields must not be empty
- `chk_store_change_verifications_verified_*`: VERIFIED requires at and by
- `chk_store_change_verifications_rejected_*`: REJECTED requires at, by, and notes
- `chk_response_edit_audit_reason`: Survey edits require reason
- `chk_response_edit_audit_hash_different`: Edit must change data
- `chk_response_edit_audit_json_not_null`: Audit must have before/after snapshots

**Key Business Rules**:
- DAMAGED and PACKAGING issues require photo evidence
- Issue resolution workflow requires tracking at each stage
- Store changes during active campaigns require verification
- Survey response edits must be justified with before/after audit trail

---

### 6. `06_check_memberships.sql`
**Purpose**: Role-based access control and scope requirements

**Constraints Added**:
- `chk_memberships_psp_no_brand`: PSP roles must NOT have brand_id
- `chk_memberships_brand_required`: Brand roles MUST have brand_id
- `chk_memberships_regional_scope`: REGIONAL_MANAGER requires region_scope_id
- `chk_memberships_store_scope`: STORE_MANAGER/OPERATOR require store_scope_id
- `chk_memberships_no_scope`: Non-scoped roles must not have scope fields
- `chk_api_keys_expires_future`: API key expiration must be after creation
- `chk_users_email`: Email must be non-empty and lowercase
- `chk_users_email_verified_at`: Verified emails require timestamp
- `chk_tenants_max_brands`: Max brands must be positive
- `chk_tenants_max_users`: Max users must be positive
- `chk_tenants_subscription_dates`: End date >= start date
- `chk_brands_code`: Brand code must be non-empty and uppercase

**Key Business Rules**:
- PSP staff (PSP_ADMIN, PSP_OPS) work across all brands
- Brand users must be scoped to a specific brand
- Regional managers must be scoped to a region
- Store users must be scoped to a store
- Emails must be lowercase for consistency
- Subscription dates must be logical

---

### 7. `07_triggers_timestamps.sql`
**Purpose**: Auto-update triggers for updated_at on ALL tables

**Implementation**:
- Documents existing triggers (already defined in DDL files)
- Provides verification query to ensure all tables have triggers
- Establishes pattern for new tables

**Trigger Function**:
```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**Coverage**: All tables with `updated_at` column have auto-update triggers

**Exception**: `response_edit_audit` (immutable, created_at only)

---

### 8. `08_triggers_soft_delete.sql`
**Purpose**: Prevent hard deletes and enforce soft delete pattern

**Implementation**:
- `enforce_soft_delete()`: Trigger function that blocks DELETE and suggests UPDATE
- BEFORE DELETE triggers on all tables with `deleted_at` column
- `soft_delete(table_name, id)`: Helper function for programmatic soft deletes
- `soft_undelete(table_name, id)`: Helper function to restore soft-deleted records

**Protected Tables** (45 tables total):
- All tables with `deleted_at` column are protected
- Hard DELETE will raise exception with helpful error message
- Use `UPDATE table SET deleted_at = NOW() WHERE id = '...'` instead

**Exceptions** (intentionally allow hard delete):
- `audit_events`: Immutable audit trail (should never be deleted)
- `response_edit_audit`: Immutable edit history (should never be deleted)

**Helper Functions**:
```sql
-- Soft delete a record
SELECT soft_delete('campaigns', 'uuid-here');

-- Restore a soft-deleted record
SELECT soft_undelete('campaigns', 'uuid-here');
```

---

## Application Order

Apply constraints in this order to avoid dependency issues:

```bash
# 1. Basic constraints (can be applied after schema creation)
psql -f 01_check_campaigns.sql
psql -f 02_check_assignments.sql
psql -f 03_check_orders.sql
psql -f 04_check_photos.sql
psql -f 05_check_issues.sql
psql -f 06_check_memberships.sql

# 2. Triggers (requires all tables to exist)
psql -f 07_triggers_timestamps.sql   # Verify existing triggers
psql -f 08_triggers_soft_delete.sql  # Add soft delete protection
```

## Validation Queries

### Verify All Constraints Applied
```sql
SELECT
  conname AS constraint_name,
  conrelid::regclass AS table_name,
  pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE contype = 'c'  -- CHECK constraints
  AND connamespace = 'public'::regnamespace
ORDER BY conrelid::regclass::text, conname;
```

### Verify All Timestamp Triggers
```sql
SELECT
  t.table_name,
  CASE
    WHEN EXISTS (
      SELECT 1 FROM information_schema.triggers tr
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
    SELECT 1 FROM information_schema.columns c
    WHERE c.table_name = t.table_name AND c.column_name = 'updated_at'
  )
ORDER BY trigger_status DESC, t.table_name;
```

### Verify All Soft Delete Triggers
```sql
SELECT
  t.table_name,
  CASE
    WHEN EXISTS (
      SELECT 1 FROM information_schema.triggers tr
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
    SELECT 1 FROM information_schema.columns c
    WHERE c.table_name = t.table_name AND c.column_name = 'deleted_at'
  )
ORDER BY soft_delete_status DESC, t.table_name;
```

## Summary Statistics

- **Total CHECK Constraints**: 80+ constraints across 8 files
- **Total Triggers**:
  - 45+ updated_at auto-update triggers
  - 45+ soft delete prevention triggers
- **Tables Protected**: All tables with deleted_at column (45 tables)
- **Tables with Auto-Update**: All tables with updated_at column (46 tables)

## Business Rule Coverage

All constraints from Section 1.3 of the orchestration log have been implemented:

- ✅ Campaign date ranges and status transitions
- ✅ Assignment status validation and readiness rules
- ✅ Order lifecycle rules and acknowledgment requirements
- ✅ Photo upload validation (file size, MIME type, photo/slot requirements)
- ✅ Photo review evidence requirements and rejection reasons
- ✅ Issue request evidence requirements for DAMAGED/PACKAGING
- ✅ Membership role-based scope requirements
- ✅ API key expiration validation
- ✅ Store layout version requirements
- ✅ Survey version requirements
- ✅ Auto-update triggers for updated_at on all tables
- ✅ Soft delete enforcement on all tables with deleted_at

## Notes

- All constraints include COMMENT documentation for business rule clarity
- Nullable fields are handled correctly in all constraints
- Timestamps follow logical order (created < started < completed, etc.)
- Soft delete pattern is enforced consistently across all tables
- Helper functions provided for programmatic soft delete operations

---

**Package Status**: ✅ Complete
**Next Package**: Package 5 - Indexes (04_Indexes/)
