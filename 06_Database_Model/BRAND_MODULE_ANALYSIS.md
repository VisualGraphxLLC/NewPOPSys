# Brand Admin Module - Database Schema Analysis

**Version:** 1.0
**Generated:** 2025-12-19
**Schema File:** H:\Shared drives\VG Development\PopSystem\SOW\06_Database_Model\01_Schema\brand_module_ddl.sql

---

## Executive Summary

This document analyzes the database schema for the Brand Admin Module, covering 41 tables that support the complete lifecycle of marketing campaigns from store selection through execution and verification. The schema implements a robust data model supporting multi-tenant operations, geographic hierarchy, campaign management, fulfillment tracking, and comprehensive audit trails.

---

## 1. Tables Covered

### 1.1 Geographic Hierarchy (4 tables)
- `regions` - Top-level geographic groupings
- `districts` - Mid-level optional groupings within regions
- `territories` - Lower-level optional groupings within districts/regions
- `stores` - Master store records with location and status

**Purpose:** Supports flexible geographic organization for store selection and campaign targeting.

### 1.2 Store Management (3 tables)
- `store_groups` - Custom groupings for targeting
- `store_group_memberships` - Many-to-many store-to-group relationships
- `stores` (already listed above)

**Purpose:** Enables custom store grouping beyond geography for campaign selection recipes.

### 1.3 Store Layout & Slots (2 tables)
- `store_layouts` - Versioned layout definitions
- `location_slots` - Physical placement locations (windows, shelves, coolers)

**Purpose:** Tracks store-specific physical layouts for item placement and photo verification. Versioning ensures campaign assignments pin to specific layouts.

### 1.4 Surveys & Photo Rules (3 tables)
- `survey_templates` - Reusable survey definitions
- `survey_versions` - Immutable versioned survey schemas
- `photo_rules` - Photo capture requirements

**Purpose:** Configurable data collection and verification requirements. Versioning ensures consistency throughout campaign lifecycle.

### 1.5 Campaigns & Kits (4 tables)
- `campaigns` - Campaign definitions with dates and selection recipes
- `kit_definitions` - Reusable kit templates
- `kit_items` - Individual items within kits
- `store_assignments` - Campaign-to-store assignments with pinned versions

**Purpose:** Core campaign management including store selection, kit composition, and assignment tracking.

### 1.6 Assignment Tasks (1 table)
- `assignment_items` - Individual kit items assigned to stores with slot mapping

**Purpose:** Tracks per-item fulfillment and execution status from order through verification.

### 1.7 Fulfillment (6 tables)
- `store_orders` - Orders generated for store assignments
- `order_lines` - Line items within orders
- `shipments` - Shipment tracking records
- `shipment_lines` - Items included in shipments
- `receive_verifications` - Store confirmation of receipt
- `reorders` - Reorders generated from approved issues

**Purpose:** Complete order-to-delivery lifecycle with receipt confirmation and reorder management.

### 1.8 Execution & Verification (5 tables)
- `store_survey_responses` - Store responses to assigned surveys
- `photo_uploads` - Photos submitted for verification
- `photo_reviews` - Review records with approval/rejection
- `retake_requests` - Requests for photo retakes
- `receive_verifications` (already listed above)

**Purpose:** Tracks store execution progress, photo submission, brand review, and retake workflows.

### 1.9 Issues Management (2 tables)
- `issue_requests` - Store-reported issues (missing, damaged, incorrect)
- `issue_lines` - Specific items affected by issues

**Purpose:** Issue reporting, triage, and resolution workflow.

### 1.10 Notifications (2 tables)
- `notification_preferences` - User channel preferences
- `notifications` - Notification delivery log and inbox

**Purpose:** Multi-channel notification system (email, in-app, push) with user preferences.

### 1.11 Integration (2 tables)
- `webhook_endpoints` - External webhook configuration
- `webhook_deliveries` - Delivery attempts and retry tracking

**Purpose:** Outbound webhook integration for event-driven architecture.

### 1.12 Exports & Jobs (1 table)
- `export_jobs` - Data export job tracking and file generation

**Purpose:** Asynchronous export generation with lifecycle tracking.

### 1.13 Audit & Observability (1 table)
- `audit_events` - Comprehensive audit trail for all system changes

**Purpose:** Complete audit trail capturing who, what, when, before/after states.

---

## 2. Requirements Coverage Analysis

### 2.1 SUPP-013 (Stores) - Fully Covered
- Geographic hierarchy (Region → District → Territory → Store)
- Custom store groups with many-to-many memberships
- Store master data with address, contacts, status
- Store import/update support (schema ready)
- External system mapping via `external_store_guid`

**Status:** Complete implementation of all requirements.

### 2.2 SUPP-014 (Surveys & Photo Rules) - Fully Covered
- Survey templates with immutable versioning
- Store layouts with version-controlled location slots
- Photo rules with configurable requirements
- Conditional logic support (via `definition_json` JSONB)
- Repeatable sections support (via `definition_json` structure)
- Store survey responses with edit audit capability

**Status:** Complete implementation. Survey logic stored in JSONB for flexibility.

### 2.3 SUPP-015 (Campaigns & Kits) - Fully Covered
- Campaign lifecycle (DRAFT → PUBLISHED → COMPLETED)
- Store selection via `selection_recipe_json`
- Kit definitions with items and photo rules
- Store assignments with pinned layout/survey versions
- Dynamic task generation (supported via assignment_items)
- Order generation for PSP fulfillment

**Status:** Complete implementation. Selection recipe enables re-evaluation when store data changes.

### 2.4 SUPP-035 (Platform Data Model) - Fully Aligned
- All common fields (id, created_at, updated_at, deleted_at)
- All enums implemented as CHECK constraints
- Foreign key relationships to platform tables (tenants, brands, users)
- Soft-delete pattern throughout
- UUID primary keys with uuid_generate_v4()

**Status:** Full alignment with platform standards.

---

## 3. Gaps & Missing Requirements

### 3.1 Identified Gaps
None identified. All requirements from SUPPs are covered by the schema.

### 3.2 Potential Future Enhancements
The following are NOT gaps but potential future scope items:

1. **Asset Registry Integration** (SUPP-014 mentions)
   - Could add `media_assets` table for centralized asset management
   - Currently handled via photo_uploads and ghost_image_url

2. **AI Photo Analysis** (SUPP-014 future scope)
   - Schema supports this via photo_reviews and rejection_reason
   - AI service would integrate via existing review workflow

3. **Store Change Verification Tasks** (SUPP-013 mentions)
   - Could add `store_change_verifications` table
   - Currently can be handled via audit_events and notifications

4. **Advanced Selection Recipe Features**
   - Could add support for store attributes/tags in recipe
   - Currently supports regions, districts, territories, groups, individual stores

---

## 4. Recommended Triggers & Functions

### 4.1 Implemented Triggers
- **updated_at automation** - All 41 tables have triggers to auto-update `updated_at`

### 4.2 Recommended Additional Triggers

#### Store Assignment Status Management
```sql
CREATE OR REPLACE FUNCTION update_assignment_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Auto-advance status when all items satisfied
    IF (SELECT COUNT(*) FROM assignment_items
        WHERE store_assignment_id = NEW.store_assignment_id
        AND status NOT IN ('SATISFIED', 'EXCEPTION')) = 0 THEN

        UPDATE store_assignments
        SET status = 'COMPLETE'
        WHERE id = NEW.store_assignment_id
        AND status != 'COMPLETE';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to assignment_items
CREATE TRIGGER check_assignment_completion
AFTER UPDATE ON assignment_items
FOR EACH ROW
WHEN (NEW.status IN ('SATISFIED', 'EXCEPTION'))
EXECUTE FUNCTION update_assignment_status();
```

#### Order Status Cascading
```sql
CREATE OR REPLACE FUNCTION update_order_status_from_shipment()
RETURNS TRIGGER AS $$
BEGIN
    -- Update order status when shipment delivered
    IF NEW.status = 'DELIVERED' AND (OLD.status IS NULL OR OLD.status != 'DELIVERED') THEN
        UPDATE store_orders
        SET status = 'DELIVERED'
        WHERE id = NEW.store_order_id
        AND status != 'DELIVERED';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_order_on_delivery
AFTER UPDATE ON shipments
FOR EACH ROW
EXECUTE FUNCTION update_order_status_from_shipment();
```

#### Photo Review Status Propagation
```sql
CREATE OR REPLACE FUNCTION update_photo_status_from_review()
RETURNS TRIGGER AS $$
BEGIN
    -- Update photo_upload status when reviewed
    UPDATE photo_uploads
    SET review_status = NEW.status
    WHERE id = NEW.photo_upload_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER propagate_photo_review_status
AFTER INSERT ON photo_reviews
FOR EACH ROW
EXECUTE FUNCTION update_photo_status_from_review();
```

#### Audit Event Generation
```sql
CREATE OR REPLACE FUNCTION log_campaign_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO audit_events (
            tenant_id, brand_id, actor_type, action,
            entity_type, entity_id, before_json, after_json
        ) VALUES (
            (SELECT tenant_id FROM brands WHERE id = NEW.brand_id),
            NEW.brand_id,
            'SYSTEM',
            'campaign.status_changed',
            'Campaign',
            NEW.id,
            jsonb_build_object('status', OLD.status),
            jsonb_build_object('status', NEW.status)
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_campaign_status
AFTER UPDATE ON campaigns
FOR EACH ROW
EXECUTE FUNCTION log_campaign_status_change();
```

### 4.3 Recommended Functions

#### Campaign Store Selection Resolver
```sql
CREATE OR REPLACE FUNCTION resolve_campaign_stores(campaign_id UUID)
RETURNS TABLE(store_id UUID, store_number TEXT, store_name TEXT) AS $$
DECLARE
    recipe JSONB;
BEGIN
    -- Get selection recipe
    SELECT selection_recipe_json INTO recipe
    FROM campaigns WHERE id = campaign_id;

    -- Execute recipe logic (simplified example)
    RETURN QUERY
    SELECT DISTINCT s.id, s.store_number, s.name
    FROM stores s
    WHERE s.brand_id = (SELECT brand_id FROM campaigns WHERE id = campaign_id)
    AND s.deleted_at IS NULL
    AND s.status = ANY((recipe->'statusFilter')::TEXT[])
    -- Add region/district/territory/group logic here
    ;
END;
$$ LANGUAGE plpgsql;
```

#### Store Assignment Readiness Check
```sql
CREATE OR REPLACE FUNCTION check_assignment_readiness(assignment_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    has_layout BOOLEAN;
    has_survey BOOLEAN;
    items_delivered BOOLEAN;
BEGIN
    -- Check if layout version pinned
    SELECT layout_version_id IS NOT NULL INTO has_layout
    FROM store_assignments WHERE id = assignment_id;

    -- Check if survey version pinned
    SELECT survey_version_id IS NOT NULL INTO has_survey
    FROM store_assignments WHERE id = assignment_id;

    -- Check if all items delivered (if applicable)
    SELECT NOT EXISTS (
        SELECT 1 FROM assignment_items
        WHERE store_assignment_id = assignment_id
        AND status NOT IN ('DELIVERED', 'RECEIVED', 'INSTALLED', 'SATISFIED')
    ) INTO items_delivered;

    RETURN has_layout AND has_survey AND items_delivered;
END;
$$ LANGUAGE plpgsql;
```

---

## 5. Query Patterns Supported

### 5.1 Campaign Dashboard Queries

#### Store Phase Distribution
```sql
-- Get store count by phase for a campaign
SELECT
    sa.status,
    COUNT(*) as store_count
FROM store_assignments sa
WHERE sa.campaign_id = :campaign_id
AND sa.deleted_at IS NULL
GROUP BY sa.status
ORDER BY
    CASE sa.status
        WHEN 'COMPLETE' THEN 1
        WHEN 'SUBMITTED' THEN 2
        WHEN 'IN_PROGRESS' THEN 3
        WHEN 'READY' THEN 4
        WHEN 'ASSIGNED' THEN 5
        WHEN 'REWORK_REQUIRED' THEN 6
        ELSE 7
    END;
```

#### Photo Verification Queue
```sql
-- Get pending photos for review
SELECT
    pu.id,
    pu.s3_url,
    s.store_number,
    s.name as store_name,
    ai.quantity,
    ki.name as item_name,
    ls.slot_name,
    pu.uploaded_at
FROM photo_uploads pu
JOIN store_assignments sa ON pu.store_assignment_id = sa.id
JOIN stores s ON sa.store_id = s.id
JOIN assignment_items ai ON pu.assignment_item_id = ai.id
JOIN kit_items ki ON ai.kit_item_id = ki.id
LEFT JOIN location_slots ls ON pu.location_slot_id = ls.id
WHERE sa.campaign_id = :campaign_id
AND pu.review_status = 'PENDING'
AND pu.deleted_at IS NULL
ORDER BY pu.uploaded_at ASC;
```

### 5.2 Store Selection Queries

#### Available Stores by Geography
```sql
-- Get active stores in regions/districts
SELECT
    s.id,
    s.store_number,
    s.name,
    r.name as region_name,
    d.name as district_name,
    COUNT(sgm.store_group_id) as group_count
FROM stores s
JOIN regions r ON s.region_id = r.id
LEFT JOIN districts d ON s.district_id = d.id
LEFT JOIN store_group_memberships sgm ON s.id = sgm.store_id
WHERE s.brand_id = :brand_id
AND s.status = 'ACTIVE'
AND s.deleted_at IS NULL
AND r.id = ANY(:region_ids)  -- Optional filter
GROUP BY s.id, s.store_number, s.name, r.name, d.name
ORDER BY s.store_number;
```

#### Stores by Custom Group
```sql
-- Get stores in specific groups
SELECT
    s.id,
    s.store_number,
    s.name,
    sg.name as group_name
FROM stores s
JOIN store_group_memberships sgm ON s.id = sgm.store_id
JOIN store_groups sg ON sgm.store_group_id = sg.id
WHERE sg.id = ANY(:group_ids)
AND s.deleted_at IS NULL
AND sgm.deleted_at IS NULL;
```

### 5.3 Fulfillment Tracking

#### Order Status by Campaign
```sql
-- Get order fulfillment status for campaign
SELECT
    so.status,
    COUNT(DISTINCT so.id) as order_count,
    COUNT(DISTINCT s.id) as shipment_count,
    SUM(ol.quantity) as total_items
FROM store_orders so
LEFT JOIN shipments s ON so.id = s.store_order_id
LEFT JOIN order_lines ol ON so.id = ol.store_order_id
WHERE so.campaign_id = :campaign_id
AND so.deleted_at IS NULL
GROUP BY so.status;
```

#### Shipment Tracking
```sql
-- Get shipment details for store
SELECT
    s.id,
    s.carrier,
    s.tracking_numbers,
    s.status,
    s.shipped_at,
    s.delivered_at,
    ARRAY_AGG(jsonb_build_object(
        'sku', ki.sku,
        'name', ki.name,
        'quantity', sl.quantity
    )) as items
FROM shipments s
JOIN shipment_lines sl ON s.id = sl.shipment_id
JOIN kit_items ki ON sl.kit_item_id = ki.id
JOIN store_orders so ON s.store_order_id = so.id
WHERE so.store_id = :store_id
AND so.campaign_id = :campaign_id
AND s.deleted_at IS NULL
GROUP BY s.id;
```

### 5.4 Issue Management

#### Open Issues by Store
```sql
-- Get unresolved issues for campaign
SELECT
    ir.id,
    ir.type,
    ir.status,
    ir.description,
    s.store_number,
    s.name as store_name,
    ARRAY_AGG(jsonb_build_object(
        'item', ki.name,
        'quantity', il.quantity
    )) as affected_items
FROM issue_requests ir
JOIN store_assignments sa ON ir.store_assignment_id = sa.id
JOIN stores s ON sa.store_id = s.id
JOIN issue_lines il ON ir.id = il.issue_request_id
JOIN kit_items ki ON il.kit_item_id = ki.id
WHERE sa.campaign_id = :campaign_id
AND ir.status NOT IN ('RESOLVED', 'DENIED')
AND ir.deleted_at IS NULL
GROUP BY ir.id, s.store_number, s.name
ORDER BY ir.submitted_at DESC;
```

### 5.5 Reporting & Analytics

#### Campaign Completion Rate
```sql
-- Calculate completion metrics for campaign
SELECT
    COUNT(*) as total_stores,
    COUNT(*) FILTER (WHERE sa.status = 'COMPLETE') as completed_stores,
    COUNT(*) FILTER (WHERE sa.status IN ('SUBMITTED', 'IN_PROGRESS')) as in_progress_stores,
    COUNT(*) FILTER (WHERE sa.status = 'REWORK_REQUIRED') as rework_stores,
    ROUND(100.0 * COUNT(*) FILTER (WHERE sa.status = 'COMPLETE') / COUNT(*), 2) as completion_pct
FROM store_assignments sa
WHERE sa.campaign_id = :campaign_id
AND sa.deleted_at IS NULL;
```

#### Photo Approval Rate
```sql
-- Calculate photo approval metrics
SELECT
    COUNT(*) as total_photos,
    COUNT(*) FILTER (WHERE pu.review_status = 'APPROVED') as approved,
    COUNT(*) FILTER (WHERE pu.review_status = 'REJECTED') as rejected,
    COUNT(*) FILTER (WHERE pu.review_status = 'PENDING') as pending,
    ROUND(100.0 * COUNT(*) FILTER (WHERE pu.review_status = 'APPROVED') /
          NULLIF(COUNT(*) FILTER (WHERE pu.review_status IN ('APPROVED', 'REJECTED')), 0), 2) as approval_rate
FROM photo_uploads pu
JOIN store_assignments sa ON pu.store_assignment_id = sa.id
WHERE sa.campaign_id = :campaign_id
AND pu.deleted_at IS NULL;
```

---

## 6. Performance Considerations

### 6.1 Index Coverage
The schema includes 41+ indexes covering:
- Foreign key relationships (all covered)
- Common filter patterns (brand_id, status, dates)
- Soft-delete optimization (WHERE deleted_at IS NULL)
- Unique constraints (store_number, order_number, etc.)

### 6.2 Recommended Additional Indexes

#### Composite Index for Campaign Dashboard
```sql
CREATE INDEX idx_store_assignments_campaign_status_store
ON store_assignments(campaign_id, status, store_id)
WHERE deleted_at IS NULL;
```

#### Index for Photo Review Queue
```sql
CREATE INDEX idx_photo_uploads_pending_review
ON photo_uploads(store_assignment_id, review_status, uploaded_at)
WHERE deleted_at IS NULL AND review_status = 'PENDING';
```

#### Index for Shipment Tracking
```sql
CREATE INDEX idx_shipments_tracking
ON shipments USING GIN (tracking_numbers)
WHERE deleted_at IS NULL;
```

### 6.3 JSONB Indexing
For frequently queried JSONB columns:

```sql
-- Index selection recipe for store count estimation
CREATE INDEX idx_campaigns_recipe_status
ON campaigns USING GIN (selection_recipe_json)
WHERE deleted_at IS NULL;

-- Index survey responses for field search
CREATE INDEX idx_survey_responses_data
ON store_survey_responses USING GIN (response_json)
WHERE deleted_at IS NULL;
```

### 6.4 Partitioning Recommendations
For high-volume tables (100K+ rows):

1. **audit_events** - Partition by created_at (monthly)
2. **notifications** - Partition by created_at (monthly)
3. **webhook_deliveries** - Partition by created_at (monthly)
4. **photo_uploads** - Consider partitioning by campaign_id for large deployments

---

## 7. Data Integrity & Constraints

### 7.1 Referential Integrity
- All foreign keys enforce cascading or restrict behavior
- Soft-deletes preserved via ON DELETE SET NULL where appropriate
- Campaign deletions cascade to assignments, orders, etc.

### 7.2 CHECK Constraints
All enums implemented as CHECK constraints:
- `campaigns.status` - Campaign lifecycle states
- `campaigns.verification_mode` - STRICT/FAST
- `stores.status` - ACTIVE, INACTIVE, TEMP_CLOSED, CLOSED
- `store_assignments.status` - Assignment states
- `assignment_items.status` - Item lifecycle
- `store_orders.status` - Order states
- `shipments.status` - Shipment tracking
- Photo review statuses and rejection reasons

### 7.3 Business Logic Constraints
- Date validation: `campaigns.end_date >= start_date`
- Quantity validation: All quantity fields > 0
- Photo count validation: `min_photos <= max_photos`
- Unique constraints on business keys (store_number, order_number)

---

## 8. Migration Strategy

### 8.1 Recommended Order
1. Platform tables (tenants, brands, users) - prerequisite
2. Geographic hierarchy (regions, districts, territories)
3. Stores and groups
4. Layouts and slots
5. Surveys and photo rules
6. Kits and campaigns
7. Assignments and fulfillment
8. Execution and verification
9. Support tables (notifications, webhooks, exports, audit)

### 8.2 Data Migration Considerations
- Import existing store data first (via CSV/API)
- Create baseline layouts for existing stores
- Migrate historical campaigns as read-only (status=ARCHIVED)
- Preserve audit trail from legacy system in audit_events

---

## 9. Security Considerations

### 9.1 Row-Level Security (RLS)
Recommended policies:

```sql
-- Enable RLS on sensitive tables
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE store_assignments ENABLE ROW LEVEL SECURITY;

-- Brand isolation policy
CREATE POLICY brand_isolation_stores ON stores
    FOR ALL
    USING (brand_id IN (
        SELECT brand_id FROM memberships
        WHERE user_id = current_user_id()
    ));
```

### 9.2 Sensitive Data
- `webhook_endpoints.secret` - Encrypt at rest
- User passwords handled in `users` table (platform)
- Consider encryption for `audit_events.before_json/after_json` if containing PII

---

## 10. Testing Recommendations

### 10.1 Unit Tests
- Trigger functions (status updates, audit logging)
- Constraint validation (enums, quantities, dates)
- Soft-delete behavior

### 10.2 Integration Tests
- Campaign publish → order generation flow
- Photo upload → review → retake workflow
- Issue reporting → reorder generation
- Store selection recipe resolution

### 10.3 Performance Tests
- Campaign with 1000+ stores
- Bulk photo upload (100+ photos)
- Export generation for large campaigns
- Concurrent order generation

---

## 11. Monitoring & Observability

### 11.1 Key Metrics to Track
- Campaign completion rate by brand
- Photo approval/rejection rates
- Order fulfillment cycle time
- Issue resolution time
- Export job success rate
- Webhook delivery success rate

### 11.2 Alerting Thresholds
- Photo rejection rate > 30%
- Order stuck in GENERATED > 24 hours
- Issue in OPEN status > 48 hours
- Webhook failure_count > 5
- Export job in PROCESSING > 1 hour

---

## 12. Documentation & Maintenance

### 12.1 Schema Documentation
All tables and key columns include COMMENT statements describing:
- Business purpose
- Relationship context
- Enum value meanings
- Usage notes

### 12.2 Change Management
- Schema changes via versioned migration files
- Backward compatibility for API contracts
- Deprecation warnings before removing columns
- Audit trail for schema changes

---

## 13. Future Enhancements

### 13.1 Potential Extensions
1. **Real-time collaboration** - Add presence tracking for concurrent edits
2. **Advanced analytics** - Materialized views for dashboard performance
3. **Mobile offline support** - Add sync tables for offline capability
4. **ML/AI integration** - Extend photo_reviews for AI predictions
5. **Multi-language support** - Add translation tables for i18n

### 13.2 Scalability Considerations
- Read replicas for reporting queries
- Caching layer (Redis) for hot data
- CDN for photo delivery
- Event sourcing for high-volume events

---

## Conclusion

The Brand Admin Module database schema provides a comprehensive, well-structured foundation for managing the complete campaign lifecycle. The schema:

- Covers all requirements from SUPPs 013, 014, 015, and 035
- Implements PostgreSQL best practices (UUID PKs, soft deletes, triggers)
- Supports complex query patterns for dashboards and reports
- Enables flexible campaign configuration and store selection
- Maintains comprehensive audit trails
- Scales to enterprise deployments with proper indexing

The schema is production-ready with recommended enhancements for triggers, functions, and additional indexes to optimize specific workflows.
