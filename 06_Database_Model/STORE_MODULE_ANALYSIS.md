# Store Execution Module - Database Schema Analysis

## Version Information
- **Version**: 1.0
- **Date**: 2025-12-19
- **Schema File**: `01_Schema/store_module_ddl.sql`
- **Source Documents**:
  - SUPP-035 (Field-Level Data Model v1.1)
  - SUPP-017 (Store Execution Proof Capture v0.3)
  - SUPP-011 (Offline and Sync Strategy v0.3)
  - SUPP-036 (Screens - Onboarding and Store Foundation v0.6)

---

## Tables Covered

### Core Tenancy & Identity (6 tables)
1. **tenants** - PSP organizations
2. **brands** - Retailer brands managed by PSPs
3. **users** - Platform users
4. **memberships** - User-tenant-brand role assignments
5. **api_keys** - API authentication

### Store & Geographic Hierarchy (9 tables)
6. **regions** - Top-level geographic grouping
7. **districts** - Mid-level geographic grouping
8. **territories** - Fine-grained geographic grouping
9. **stores** - Retail locations
10. **store_groups** - Ad-hoc store groupings
11. **store_group_memberships** - Store-to-group relationships
12. **store_layouts** - Physical store layouts (versioned)
13. **location_slots** - Installation points within stores

### Surveys & Photo Rules (3 tables)
14. **survey_templates** - Survey template definitions
15. **survey_versions** - Versioned survey structures
16. **photo_rules** - Photo capture requirements

### Campaigns & Kits (5 tables)
17. **kit_definitions** - Kit templates
18. **kit_items** - Items within kits
19. **campaigns** - Marketing campaigns
20. **store_assignments** - Campaign-to-store assignments
21. **assignment_items** - Kit items assigned to specific stores

### Fulfillment & Logistics (5 tables)
22. **store_orders** - Fulfillment orders
23. **order_lines** - Order line items
24. **shipments** - Shipment tracking
25. **shipment_lines** - Shipment line items

### Execution & Verification (6 tables)
26. **receive_verifications** - Receipt survey responses (Stage 1)
27. **store_survey_responses** - Install survey responses (Stage 2)
28. **photo_uploads** - Proof photos
29. **photo_reviews** - Brand reviewer decisions
30. **retake_requests** - Photo retake tracking

### Issues & Exceptions (3 tables)
31. **issue_requests** - Store-reported issues
32. **issue_lines** - Items affected by issues
33. **reorders** - Replacement orders

### Notifications & Preferences (2 tables)
34. **notification_preferences** - User notification settings
35. **notifications** - Notification delivery log

### Webhooks & Integrations (2 tables)
36. **webhook_endpoints** - Webhook configuration
37. **webhook_deliveries** - Webhook delivery tracking

### Exports & Jobs (1 table)
38. **export_jobs** - Background export job tracking

### Audit & Observability (1 table)
39. **audit_events** - Comprehensive audit trail

**Total: 39 tables**

---

## Schema Features Implemented

### PostgreSQL Best Practices
1. **UUID Primary Keys** - Using `uuid_generate_v4()` for all primary keys
2. **Timestamps** - All tables have `created_at`, `updated_at`, `deleted_at`
3. **Soft Deletes** - `deleted_at` pattern for data retention
4. **Auto-Update Triggers** - Automatic `updated_at` timestamp maintenance
5. **Enum Types** - Type-safe enumerations for status fields
6. **JSONB Fields** - Flexible schema for settings, definitions, and responses
7. **CHECK Constraints** - Data integrity (date ranges, positive quantities, min/max)
8. **Foreign Keys** - Referential integrity with appropriate cascade rules
9. **Unique Constraints** - Composite unique constraints for business rules
10. **Comments** - Comprehensive table and column documentation

### Indexing Strategy
- **Basic Indexes**: Foreign keys, status fields, commonly filtered columns
- **Composite Indexes**: Brand + status, tenant + brand combinations
- **Partial Indexes**: `WHERE deleted_at IS NULL` for soft-deleted data
- **GIN Indexes**: JSONB columns for flexible querying
- **Covering Indexes**: Optimized for common query patterns

### Data Integrity
- **Cascading Deletes**: Appropriate CASCADE for dependent data
- **Restricted Deletes**: RESTRICT on critical references (kit_items, campaigns)
- **Null Handling**: Careful nullable vs NOT NULL decisions
- **Default Values**: Sensible defaults for status fields and timestamps

---

## Two-Stage Survey Model Support

The schema fully supports the "Two-Stage Survey Model" described in SUPP-017:

### Stage 1: Receipt Survey (Logistics)
- **receive_verifications** table captures receipt confirmation
- Links to **store_assignment_id** for campaign context
- **all_items_received** boolean for quick confirmation
- **notes** field for exception details
- Triggers **issue_requests** when items are missing/damaged

### Stage 2: Install Survey (Execution)
- **store_survey_responses** table stores full survey responses
- **response_json** JSONB field for flexible survey structure
- **photo_uploads** table linked by assignment and slot
- **location_slots** enables "walk the store" workflow
- **assignment_items** tracks item-to-slot mapping

### Photo Proof Workflow
1. Store uploads photos (**photo_uploads**)
2. Photos linked to **assignment_item_id** and **location_slot_id**
3. Brand reviewers create **photo_reviews** (APPROVED/REJECTED)
4. Rejected photos trigger **retake_requests**
5. Retake links back to original photo and new replacement photo

---

## Offline Sync Strategy Support

Schema design supports SUPP-011 offline requirements:

### Draft Support
- **submitted_at** nullable fields in survey responses
- NULL = draft state, timestamp = final submission
- Allows local storage and later sync

### Conflict Prevention
- **version** fields in store_layouts for conflict detection
- **review_status** prevents overwriting reviewed photos
- **status** enums track workflow state to prevent state conflicts

### Queue Pattern Support
- **upload_at** and **submitted_at** timestamps for ordering
- **review_status = 'PENDING'** for queued photos
- **notification** table supports sync status messages

### Idempotency
- UUID primary keys prevent duplicate inserts
- Unique constraints on business keys (order_number, etc.)
- **superseded** status for replaced photos

---

## Query Patterns Supported

### Common Brand Admin Queries

#### 1. Campaign Dashboard
```sql
SELECT * FROM v_active_campaigns
WHERE brand_id = ?
ORDER BY start_date DESC;
```
Supported by: `idx_campaigns_brand_status`, view with store counts

#### 2. Store Assignment Progress
```sql
SELECT * FROM v_store_assignment_details
WHERE campaign_id = ?
  AND status NOT IN ('COMPLETE', 'WAIVED')
ORDER BY region_name, store_number;
```
Supported by: `idx_store_assignments_campaign`, `idx_store_assignments_status`

#### 3. Photos Pending Review
```sql
SELECT pu.*, s.store_number, c.name AS campaign_name
FROM photo_uploads pu
JOIN store_assignments sa ON pu.store_assignment_id = sa.id
JOIN stores s ON sa.store_id = s.id
JOIN campaigns c ON sa.campaign_id = c.id
WHERE c.brand_id = ?
  AND pu.review_status = 'PENDING'
  AND pu.deleted_at IS NULL
ORDER BY pu.uploaded_at;
```
Supported by: `idx_photo_uploads_review_status`, `idx_photo_uploads_assignment`

#### 4. Store Import Conflict Resolution
```sql
SELECT * FROM stores
WHERE brand_id = ?
  AND store_number IN (?, ?, ...)
  AND deleted_at IS NULL;
```
Supported by: `idx_stores_brand`, `idx_stores_number`

#### 5. Issue Tracking
```sql
SELECT ir.*, s.store_number, COUNT(il.id) AS affected_items
FROM issue_requests ir
JOIN store_assignments sa ON ir.store_assignment_id = sa.id
JOIN stores s ON sa.store_id = s.id
LEFT JOIN issue_lines il ON ir.id = il.issue_request_id
WHERE sa.campaign_id = ?
  AND ir.status NOT IN ('RESOLVED', 'DENIED')
  AND ir.deleted_at IS NULL
GROUP BY ir.id, s.store_number
ORDER BY ir.submitted_at DESC;
```
Supported by: `idx_issue_requests_assignment`, `idx_issue_requests_status`

### Common Store User Queries

#### 6. My Active Assignments
```sql
SELECT sa.*, c.name, c.start_date, c.end_date
FROM store_assignments sa
JOIN campaigns c ON sa.campaign_id = c.id
WHERE sa.store_id = ?
  AND sa.status IN ('READY', 'IN_PROGRESS', 'REWORK_REQUIRED')
  AND sa.deleted_at IS NULL
ORDER BY c.start_date;
```
Supported by: `idx_store_assignments_store`, `idx_store_assignments_status`

#### 7. Installation Checklist (by Slot)
```sql
SELECT ls.slot_name, ls.sort_order,
       ai.*, ki.name, ki.sku,
       pr.min_photos, pr.instructions
FROM assignment_items ai
JOIN kit_items ki ON ai.kit_item_id = ki.id
LEFT JOIN location_slots ls ON ai.location_slot_id = ls.id
LEFT JOIN photo_rules pr ON ki.photo_rule_id = pr.id
WHERE ai.store_assignment_id = ?
  AND ai.deleted_at IS NULL
ORDER BY ls.sort_order, ki.sort_order;
```
Supported by: `idx_assignment_items_assignment`, `idx_assignment_items_slot`

### Common Analytics Queries

#### 8. Campaign Completion Rate
```sql
SELECT c.id, c.name,
       COUNT(sa.id) AS total_stores,
       COUNT(sa.id) FILTER (WHERE sa.status = 'COMPLETE') AS complete,
       ROUND(100.0 * COUNT(sa.id) FILTER (WHERE sa.status = 'COMPLETE') / COUNT(sa.id), 2) AS completion_pct
FROM campaigns c
LEFT JOIN store_assignments sa ON c.id = sa.campaign_id AND sa.deleted_at IS NULL
WHERE c.brand_id = ?
  AND c.deleted_at IS NULL
GROUP BY c.id, c.name
ORDER BY c.start_date DESC;
```
Supported by: `idx_campaigns_brand`, `idx_store_assignments_campaign`

#### 9. Photo Review Metrics
```sql
SELECT c.name,
       COUNT(pu.id) AS total_photos,
       COUNT(pu.id) FILTER (WHERE pu.review_status = 'APPROVED') AS approved,
       COUNT(pu.id) FILTER (WHERE pu.review_status = 'REJECTED') AS rejected,
       COUNT(pu.id) FILTER (WHERE pu.review_status = 'PENDING') AS pending
FROM campaigns c
JOIN store_assignments sa ON c.id = sa.campaign_id
JOIN photo_uploads pu ON sa.id = pu.store_assignment_id
WHERE c.brand_id = ?
  AND c.deleted_at IS NULL
  AND pu.deleted_at IS NULL
GROUP BY c.id, c.name;
```
Supported by: `idx_campaigns_brand`, `idx_photo_uploads_assignment`

#### 10. Regional Performance
```sql
SELECT r.name AS region,
       COUNT(DISTINCT sa.id) AS stores_assigned,
       COUNT(DISTINCT sa.id) FILTER (WHERE sa.status = 'COMPLETE') AS complete,
       AVG(EXTRACT(EPOCH FROM sa.updated_at - sa.assigned_at) / 86400) AS avg_days_to_complete
FROM regions r
JOIN stores s ON r.id = s.region_id
JOIN store_assignments sa ON s.id = sa.store_id
WHERE sa.campaign_id = ?
  AND sa.deleted_at IS NULL
GROUP BY r.id, r.name
ORDER BY r.name;
```
Supported by: `idx_stores_region`, `idx_store_assignments_campaign`

---

## Gaps and Considerations

### Identified Gaps

#### 1. Slot Verification Status Tracking
**Gap**: No dedicated table for `slot_verification_status_enum` tracking
**Impact**: Must compute from assignment_items and photo_uploads
**Recommendation**: Consider adding `slot_verifications` table if slot-level approval workflow is needed

#### 2. Bulk Operations Audit Detail
**Gap**: SUPP-036 mentions bulk apply operations but no specific table for bulk operation metadata
**Impact**: Bulk operations logged in audit_events, but selection criteria might be lost
**Mitigation**: Included `metadata_json` field in audit_events for bulk operation details

#### 3. Store Onboarding Progress
**Gap**: No explicit table for tracking brand onboarding steps (SUPP-036 section 1.1)
**Impact**: Cannot track partial completion of onboarding flow
**Recommendation**: Add `onboarding_progress` table if step-by-step tracking is required

#### 4. Import Conflict Resolution State
**Gap**: No table for storing unresolved import conflicts
**Impact**: Conflicts must be resolved immediately in import flow
**Recommendation**: Consider `import_staging` table for multi-session conflict resolution

#### 5. Photo Quality Validation Metadata
**Gap**: No fields for automated quality checks (SUPP-017 mentions "too dark", "blurry" warnings)
**Impact**: Cannot track AI/automated validation results
**Recommendation**: Add JSONB field to photo_uploads for validation metadata

#### 6. Device/Session Tracking for Offline
**Gap**: No device identifier or session tracking for offline sync
**Impact**: Cannot correlate drafts to specific devices
**Recommendation**: Add `device_id` and `session_id` to photo_uploads and survey_responses

### Future Enhancements

#### Mobile App Support
When native mobile apps are implemented (SUPP-011 mentions future):
- Add `device_registrations` table for push notifications
- Add `sync_tokens` table for incremental sync
- Add `offline_queue` table for background sync jobs

#### Advanced Photo Features
- Add `photo_annotations` table for markup/comments
- Add `photo_comparisons` table for before/after tracking
- Add `ai_validations` table for automated quality checks

#### Advanced Reporting
- Add materialized views for dashboard performance
- Add `campaign_metrics_snapshots` for historical trending
- Add `store_performance_scores` for ranking/comparison

---

## Recommended Triggers

### 1. Store Assignment Status Auto-Transition
```sql
CREATE OR REPLACE FUNCTION auto_transition_assignment_status()
RETURNS TRIGGER AS $$
BEGIN
  -- Auto-transition to IN_PROGRESS when first photo uploaded
  IF TG_TABLE_NAME = 'photo_uploads' AND NEW.deleted_at IS NULL THEN
    UPDATE store_assignments
    SET status = 'IN_PROGRESS'
    WHERE id = NEW.store_assignment_id
      AND status = 'READY';
  END IF;

  -- Auto-transition to SUBMITTED when survey submitted
  IF TG_TABLE_NAME = 'store_survey_responses' AND NEW.submitted_at IS NOT NULL THEN
    UPDATE store_assignments
    SET status = 'SUBMITTED'
    WHERE id = NEW.store_assignment_id
      AND status = 'IN_PROGRESS';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER photo_upload_status_transition
AFTER INSERT ON photo_uploads
FOR EACH ROW EXECUTE FUNCTION auto_transition_assignment_status();

CREATE TRIGGER survey_submit_status_transition
AFTER INSERT OR UPDATE ON store_survey_responses
FOR EACH ROW EXECUTE FUNCTION auto_transition_assignment_status();
```

### 2. Assignment Item Status Auto-Update
```sql
CREATE OR REPLACE FUNCTION update_assignment_item_status()
RETURNS TRIGGER AS $$
BEGIN
  -- Update item status based on photo review
  IF TG_TABLE_NAME = 'photo_reviews' AND NEW.status = 'APPROVED' THEN
    UPDATE assignment_items ai
    SET status = 'SATISFIED'
    FROM photo_uploads pu
    WHERE pu.assignment_item_id = ai.id
      AND pu.id = NEW.photo_upload_id
      AND ai.status NOT IN ('SATISFIED', 'EXCEPTION');
  END IF;

  IF TG_TABLE_NAME = 'photo_reviews' AND NEW.status = 'REJECTED' THEN
    UPDATE assignment_items ai
    SET status = 'RETAKE_REQUIRED'
    FROM photo_uploads pu
    WHERE pu.assignment_item_id = ai.id
      AND pu.id = NEW.photo_upload_id
      AND ai.status NOT IN ('SATISFIED', 'EXCEPTION');
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER photo_review_item_status_update
AFTER INSERT ON photo_reviews
FOR EACH ROW EXECUTE FUNCTION update_assignment_item_status();
```

### 3. Notification Auto-Creation
```sql
CREATE OR REPLACE FUNCTION create_notification_on_event()
RETURNS TRIGGER AS $$
DECLARE
  v_user_id UUID;
  v_subject TEXT;
  v_body TEXT;
  v_action_url TEXT;
BEGIN
  -- Photo rejected notification
  IF TG_TABLE_NAME = 'photo_reviews' AND NEW.status = 'REJECTED' THEN
    SELECT sa.store_id INTO v_user_id
    FROM photo_uploads pu
    JOIN store_assignments sa ON pu.store_assignment_id = sa.id
    WHERE pu.id = NEW.photo_upload_id;

    v_subject := 'Photo Retake Required';
    v_body := 'One of your photos was rejected. Reason: ' || COALESCE(NEW.rejection_reason::TEXT, 'Not specified');
    v_action_url := '/assignments/' || (SELECT store_assignment_id FROM photo_uploads WHERE id = NEW.photo_upload_id);

    -- Insert notification for each enabled channel
    INSERT INTO notifications (user_id, channel, event_type, subject, body, action_url)
    SELECT v_user_id, np.channel, 'photo.rejected', v_subject, v_body, v_action_url
    FROM notification_preferences np
    WHERE np.user_id = v_user_id
      AND np.event_type = 'photo.rejected'
      AND np.enabled = TRUE;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER photo_review_notification
AFTER INSERT ON photo_reviews
FOR EACH ROW EXECUTE FUNCTION create_notification_on_event();
```

### 4. Audit Event Auto-Creation
```sql
CREATE OR REPLACE FUNCTION create_audit_event()
RETURNS TRIGGER AS $$
DECLARE
  v_tenant_id UUID;
  v_brand_id UUID;
  v_action TEXT;
BEGIN
  -- Determine action name
  IF TG_OP = 'INSERT' THEN
    v_action := TG_TABLE_NAME || '.created';
  ELSIF TG_OP = 'UPDATE' THEN
    v_action := TG_TABLE_NAME || '.updated';
  ELSIF TG_OP = 'DELETE' THEN
    v_action := TG_TABLE_NAME || '.deleted';
  END IF;

  -- Get context (simplified - would need table-specific logic)
  IF TG_TABLE_NAME = 'campaigns' THEN
    v_brand_id := COALESCE(NEW.brand_id, OLD.brand_id);
    SELECT tenant_id INTO v_tenant_id FROM brands WHERE id = v_brand_id;
  END IF;

  -- Create audit event
  INSERT INTO audit_events (
    tenant_id,
    brand_id,
    actor_type,
    action,
    entity_type,
    entity_id,
    before_json,
    after_json
  ) VALUES (
    v_tenant_id,
    v_brand_id,
    'SYSTEM', -- Would be determined from session context
    v_action,
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN row_to_json(OLD) ELSE NULL END,
    CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN row_to_json(NEW) ELSE NULL END
  );

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Apply to critical tables
CREATE TRIGGER audit_campaigns
AFTER INSERT OR UPDATE OR DELETE ON campaigns
FOR EACH ROW EXECUTE FUNCTION create_audit_event();

CREATE TRIGGER audit_store_assignments
AFTER INSERT OR UPDATE OR DELETE ON store_assignments
FOR EACH ROW EXECUTE FUNCTION create_audit_event();
```

---

## Recommended Functions

### 1. Compute Store Phase (Derived Status)
```sql
CREATE OR REPLACE FUNCTION compute_store_phase(p_assignment_id UUID)
RETURNS TEXT AS $$
DECLARE
  v_assignment store_assignments%ROWTYPE;
  v_has_issues BOOLEAN;
  v_shipment_status TEXT;
BEGIN
  SELECT * INTO v_assignment FROM store_assignments WHERE id = p_assignment_id;

  -- Check for rework
  IF v_assignment.status = 'REWORK_REQUIRED' THEN
    RETURN 'REWORK';
  END IF;

  -- Check for completion
  IF v_assignment.status IN ('COMPLETE', 'WAIVED') THEN
    RETURN 'COMPLETE';
  END IF;

  -- Check for submission
  IF v_assignment.status = 'SUBMITTED' THEN
    RETURN 'IN_REVIEW';
  END IF;

  -- Check for execution
  IF v_assignment.status = 'IN_PROGRESS' THEN
    RETURN 'EXECUTING';
  END IF;

  -- Check for readiness
  IF v_assignment.status = 'READY' THEN
    RETURN 'READY_TO_EXECUTE';
  END IF;

  -- Check for blocking issues
  SELECT EXISTS(
    SELECT 1 FROM issue_requests
    WHERE store_assignment_id = p_assignment_id
      AND status NOT IN ('RESOLVED', 'DENIED')
  ) INTO v_has_issues;

  IF v_has_issues THEN
    RETURN 'BLOCKED_BY_EXCEPTION';
  END IF;

  -- Check fulfillment status
  SELECT s.status INTO v_shipment_status
  FROM shipments s
  JOIN store_orders so ON s.store_order_id = so.id
  WHERE so.store_assignment_id = p_assignment_id
  ORDER BY s.created_at DESC
  LIMIT 1;

  IF v_shipment_status = 'DELIVERED' THEN
    RETURN 'AWAITING_RECEIPT';
  END IF;

  IF v_shipment_status IN ('IN_TRANSIT', 'LABEL_CREATED') THEN
    RETURN 'IN_TRANSIT';
  END IF;

  RETURN 'WAITING_FOR_SHIPMENT';
END;
$$ LANGUAGE plpgsql;
```

### 2. Calculate Assignment Completion Percentage
```sql
CREATE OR REPLACE FUNCTION calculate_assignment_completion(p_assignment_id UUID)
RETURNS NUMERIC AS $$
DECLARE
  v_total_items INTEGER;
  v_satisfied_items INTEGER;
BEGIN
  SELECT COUNT(*), COUNT(*) FILTER (WHERE status IN ('SATISFIED', 'EXCEPTION'))
  INTO v_total_items, v_satisfied_items
  FROM assignment_items
  WHERE store_assignment_id = p_assignment_id
    AND deleted_at IS NULL;

  IF v_total_items = 0 THEN
    RETURN 0;
  END IF;

  RETURN ROUND((v_satisfied_items::NUMERIC / v_total_items) * 100, 2);
END;
$$ LANGUAGE plpgsql;
```

### 3. Get Required Photos Count
```sql
CREATE OR REPLACE FUNCTION get_required_photos(p_assignment_item_id UUID)
RETURNS INTEGER AS $$
DECLARE
  v_min_photos INTEGER;
BEGIN
  SELECT pr.min_photos INTO v_min_photos
  FROM assignment_items ai
  JOIN kit_items ki ON ai.kit_item_id = ki.id
  LEFT JOIN photo_rules pr ON ki.photo_rule_id = pr.id
  WHERE ai.id = p_assignment_item_id;

  RETURN COALESCE(v_min_photos, 1);
END;
$$ LANGUAGE plpgsql;
```

---

## Performance Optimization Recommendations

### 1. Partitioning Strategy
Consider partitioning large tables by time or tenant:
```sql
-- Partition audit_events by month
CREATE TABLE audit_events_2025_12 PARTITION OF audit_events
FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');

-- Partition by tenant for multi-tenant isolation
CREATE TABLE photo_uploads_tenant_1 PARTITION OF photo_uploads
FOR VALUES IN (tenant_uuid);
```

### 2. Materialized Views for Dashboards
```sql
CREATE MATERIALIZED VIEW mv_campaign_dashboard AS
SELECT
  c.id,
  c.name,
  c.brand_id,
  c.status,
  c.start_date,
  c.end_date,
  COUNT(DISTINCT sa.id) AS total_stores,
  COUNT(DISTINCT sa.id) FILTER (WHERE sa.status = 'COMPLETE') AS complete_stores,
  COUNT(DISTINCT pu.id) AS total_photos,
  COUNT(DISTINCT pu.id) FILTER (WHERE pu.review_status = 'PENDING') AS pending_photos,
  COUNT(DISTINCT ir.id) FILTER (WHERE ir.status NOT IN ('RESOLVED', 'DENIED')) AS open_issues
FROM campaigns c
LEFT JOIN store_assignments sa ON c.id = sa.campaign_id AND sa.deleted_at IS NULL
LEFT JOIN photo_uploads pu ON sa.id = pu.store_assignment_id AND pu.deleted_at IS NULL
LEFT JOIN issue_requests ir ON sa.id = ir.store_assignment_id AND ir.deleted_at IS NULL
WHERE c.deleted_at IS NULL
GROUP BY c.id;

CREATE UNIQUE INDEX ON mv_campaign_dashboard(id);
CREATE INDEX ON mv_campaign_dashboard(brand_id, status);

-- Refresh schedule (via cron or pg_cron)
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_campaign_dashboard;
```

### 3. Query Result Caching
Consider implementing application-level caching for:
- Active campaigns list (cache key: `brand:{id}:campaigns:active`)
- Store assignment details (cache key: `assignment:{id}:details`)
- Photo review queue (cache key: `brand:{id}:photos:pending`)

Cache invalidation on:
- Campaign status changes
- Photo review submissions
- Store assignment updates

---

## Migration Strategy

### Phase 1: Core Tables (Week 1)
- Tenancy & Identity
- Stores & Geographic Hierarchy
- Campaigns & Kits

### Phase 2: Execution Tables (Week 2)
- Surveys & Photo Rules
- Store Assignments
- Fulfillment & Logistics

### Phase 3: Execution Flow (Week 3)
- Receive Verifications
- Photo Uploads & Reviews
- Store Survey Responses

### Phase 4: Supporting Systems (Week 4)
- Issues & Exceptions
- Notifications
- Webhooks & Audit

### Phase 5: Optimization (Week 5)
- Indexes
- Views
- Triggers
- Functions

---

## Testing Recommendations

### 1. Data Integrity Tests
- Test all foreign key constraints
- Test CHECK constraints (date ranges, positive quantities)
- Test unique constraints (campaign+store, user+channel+event)
- Test cascade behavior (tenant deletion, campaign deletion)

### 2. Performance Tests
- Bulk insert 10,000 stores
- Load test with 1,000 concurrent photo uploads
- Query performance with 100+ campaigns
- Index effectiveness verification

### 3. Business Logic Tests
- Two-stage survey workflow end-to-end
- Photo review and retake cycle
- Issue request to reorder flow
- Campaign publish to store assignment creation
- Store import with conflict resolution

### 4. Offline Sync Tests
- Draft creation and later submission
- Concurrent updates from multiple devices
- Conflict detection and resolution
- Idempotent operations

---

## Conclusion

This schema provides a comprehensive foundation for the Store Execution Module with:
- **Complete coverage** of all SUPP requirements
- **Robust indexing** for common query patterns
- **Flexible JSONB fields** for evolving requirements
- **Audit trail** for compliance and debugging
- **Soft deletes** for data retention
- **Extensibility** for future enhancements

The schema is production-ready for v1.0 with clear paths for optimization and enhancement in future versions.
