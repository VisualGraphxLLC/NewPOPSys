# Database Model Orchestration Log

> **Version**: v1.0
> **Created**: 2025-12-19
> **Status**: Active
> **Purpose**: Track comprehensive database expansion effort for NewPOPSys v1

---

## Executive Summary

This orchestration log tracks the expansion of the existing SUPP-035 database model into a production-ready PostgreSQL schema with complete DDL, relationships, constraints, indexes, and seed data.

### Current State
- **Source**: SUPP-035 v1.1 (11 sections, ~40 tables, all enums defined)
- **Dependencies**: SUPP-002, SUPP-013, SUPP-014, SUPP-015, SUPP-016, SUPP-017, SUPP-018, SUPP-019
- **Target**: Complete database artifacts for AutoCoder implementation

### Outputs Directory Structure
```
06_Database_Model/
├── 00_ORCHESTRATION_LOG.md (this file)
├── 01_Schema/                  # DDL scripts per module
├── 02_Relationships/           # FK definitions, ERD specifications
├── 03_Constraints/             # CHECK constraints, triggers, business rules
├── 04_Indexes/                 # Performance indexes, query optimization
├── 05_Seed_Data/               # Reference data, enum tables, initial data
├── 06_Migrations/              # Versioned Drizzle migrations
└── 07_Validation/              # Validation reports, gap analysis
```

---

## 1. Gap Analysis: Model vs. Requirements

### 1.1 MISSING TABLES

Based on SUPP requirements analysis, the following tables are MISSING from SUPP-035:

#### From SUPP-014 (Survey Builder & Layouts)
1. **repeatable_sections**
   - Purpose: Support repeatable survey blocks (e.g., Cooler #1..#N)
   - Fields: section_id, survey_version_id, name, min_instances, max_instances, instance_label_pattern
   - Referenced by: None yet (future: response tracking)

2. **response_edit_audit**
   - Purpose: Audit trail for admin edits of store survey responses
   - Fields: edit_id, response_id, actor_user_id, actor_role, reason, before_hash, after_hash, edited_at
   - Referenced by: store_survey_responses

3. **photo_links** (or enhance photo_uploads)
   - Purpose: Explicit binding of photos to campaign/store/item/slot requirements
   - Fields: link_id, campaign_id, store_id, assignment_item_id, location_slot_id, photo_rule_id, photo_upload_id
   - Status: SUPP-035 has photo_uploads; may need enhancement or separate link table

#### From SUPP-013 (Stores & Hierarchies)
4. **store_change_verifications**
   - Purpose: Track critical store field changes that need approval during active campaigns
   - Fields: change_id, store_id, campaign_id (nullable), changed_fields_json, requested_at, verified_at, verified_by_user_id, status
   - Referenced by: stores, campaigns

5. **store_id_aliases** (or enhance stores table)
   - Purpose: External ID mappings for brand's store number system
   - Fields: alias_id, store_id, external_system, external_id, is_primary
   - Status: SUPP-035 has external_store_guid; may be sufficient or needs expansion

#### From SUPP-002 (Core Domain)
6. **completion_submissions** (distinct from store_survey_responses)
   - Purpose: Store's final submission attestation for campaign completion
   - Fields: submission_id, store_assignment_id, submitted_at, submitted_by_user_id, attestation_signature, status
   - Status: May be merged with store_assignment status tracking

### 1.2 MISSING FIELDS IN EXISTING TABLES

#### tenants
- Missing: subscription_start_date, subscription_end_date, max_brands, max_users
- Reason: Needed for billing and tenant lifecycle management

#### brands
- Missing: brand_tier (if different from tenant tier), support_contact_email, support_contact_phone
- Reason: Brand-level support routing

#### users
- Missing: phone_number, timezone, locale, profile_image_url, email_verified, must_change_password
- Reason: User profile completeness and security

#### memberships
- Missing: assigned_at, assigned_by_user_id, expires_at, last_access_at
- Reason: Temporal tracking and security audit

#### campaigns
- Missing: created_by_user_id, locked_at, locked_by_user_id, archived_at, archived_by_user_id
- Reason: Full lifecycle audit trail

#### store_assignments
- Missing: readiness_blocked_reasons (JSONB), completed_at, completed_by_user_id, reopened_at, reopened_by_user_id, reopened_reason
- Reason: Status transition audit and blocking reasons

#### store_orders
- Missing: generated_by_user_id, generated_at, cancelled_at, cancelled_by_user_id, cancellation_reason, closed_at
- Reason: Order lifecycle audit

#### assignment_items
- Missing: planned_at, ordered_at, shipped_at, delivered_at, received_at, installed_at, proof_submitted_at
- Reason: Status transition timestamps for AssignmentItemStatus enum

#### location_slots
- Missing: is_active (soft delete alternative), position_x, position_y (for future visual layout)
- Reason: Slot lifecycle and positioning

#### photo_rules
- Missing: created_by_user_id, is_active
- Reason: Photo rule lifecycle management

#### issue_requests
- Missing: triaged_at, triaged_by_user_id, approved_at, approved_by_user_id, denied_at, denied_by_user_id, denial_reason, resolved_at, resolution_notes
- Reason: IssueRequestStatus enum requires these timestamps

#### retake_requests
- Missing: resolved_at, resolution_status (approved/superseded/waived)
- Reason: Retake lifecycle tracking

### 1.3 MISSING CONSTRAINTS

#### Business Rule Constraints Needed:

1. **campaigns**
   - CHECK: end_date >= start_date
   - CHECK: status transitions valid (DRAFT → SCHEDULED → PUBLISHED, etc.)
   - CHECK: published_at NOT NULL when status = 'PUBLISHED'

2. **store_assignments**
   - CHECK: Valid status transitions (ASSIGNED → READY → IN_PROGRESS → SUBMITTED → COMPLETE)
   - UNIQUE: (campaign_id, store_id) - already specified

3. **store_orders**
   - CHECK: acknowledged_at NOT NULL when status >= 'ACKNOWLEDGED'
   - CHECK: Valid order_type values
   - UNIQUE: order_number - already specified

4. **shipments**
   - CHECK: shipped_at NOT NULL when status >= 'IN_TRANSIT'
   - CHECK: delivered_at NOT NULL when status = 'DELIVERED'

5. **photo_uploads**
   - CHECK: file_size_bytes > 0
   - CHECK: mime_type IN ('image/jpeg', 'image/png', 'image/heic')
   - CHECK: Either assignment_item_id OR location_slot_id must be set

6. **photo_reviews**
   - CHECK: rejection_reason NOT NULL when status = 'REJECTED'

7. **issue_requests**
   - CHECK: evidence_photo_id NOT NULL when type = 'DAMAGED' or type = 'PACKAGING'

8. **memberships**
   - CHECK: (brand_id IS NULL AND role = 'PSP_ADMIN' OR 'PSP_OPS') OR (brand_id IS NOT NULL)
   - CHECK: region_scope_id NOT NULL when role = 'REGIONAL_ADMIN'
   - CHECK: store_scope_id NOT NULL when role = 'STORE_USER'

9. **api_keys**
   - CHECK: expires_at IS NULL OR expires_at > created_at

10. **store_layouts**
    - CHECK: version >= 1
    - UNIQUE: (store_id, version)

11. **survey_versions**
    - CHECK: version_number >= 1
    - UNIQUE: (survey_template_id, version_number) - already specified

### 1.4 MISSING INDEXES

Beyond the indexes listed in SUPP-035, these are needed for performance:

#### Lookup Indexes
1. `idx_users_email` - Already implicit via UNIQUE constraint
2. `idx_memberships_user_brand` ON memberships(user_id, brand_id)
3. `idx_memberships_brand_role` ON memberships(brand_id, role)
4. `idx_api_keys_tenant` ON api_keys(tenant_id) WHERE deleted_at IS NULL
5. `idx_api_keys_prefix` ON api_keys(key_prefix) WHERE deleted_at IS NULL

#### Hierarchy Navigation
6. `idx_regions_brand` ON regions(brand_id) WHERE deleted_at IS NULL
7. `idx_regions_parent` ON regions(parent_region_id) WHERE deleted_at IS NULL
8. `idx_districts_brand_region` ON districts(brand_id, region_id)
9. `idx_territories_brand_district` ON territories(brand_id, district_id)
10. `idx_stores_brand_status` ON stores(brand_id, status) WHERE deleted_at IS NULL
11. `idx_stores_region` ON stores(region_id)
12. `idx_stores_district` ON stores(district_id)
13. `idx_stores_territory` ON stores(territory_id)
14. `idx_stores_number_brand` ON stores(store_number, brand_id) UNIQUE

#### Campaign & Assignment Queries
15. `idx_campaigns_brand_dates` ON campaigns(brand_id, start_date, end_date)
16. `idx_campaigns_status_dates` ON campaigns(status, start_date)
17. `idx_store_assignments_status` ON store_assignments(status)
18. `idx_store_assignments_campaign_status` ON store_assignments(campaign_id, status)
19. `idx_assignment_items_assignment` ON assignment_items(store_assignment_id)
20. `idx_assignment_items_status` ON assignment_items(status)

#### Fulfillment & Orders
21. `idx_store_orders_campaign_store` ON store_orders(campaign_id, store_id)
22. `idx_store_orders_assignment` ON store_orders(store_assignment_id)
23. `idx_store_orders_psp_ref` ON store_orders(psp_order_ref) WHERE psp_order_ref IS NOT NULL
24. `idx_order_lines_order` ON order_lines(store_order_id)
25. `idx_shipments_order` ON shipments(store_order_id)
26. `idx_shipments_status` ON shipments(status)

#### Photos & Verification
27. `idx_photo_uploads_assignment_item` ON photo_uploads(assignment_item_id)
28. `idx_photo_uploads_slot` ON photo_uploads(location_slot_id)
29. `idx_photo_uploads_status_created` ON photo_uploads(review_status, created_at)
30. `idx_photo_reviews_photo` ON photo_reviews(photo_upload_id)
31. `idx_photo_reviews_reviewer` ON photo_reviews(reviewer_user_id)

#### Issues & Reorders
32. `idx_issue_requests_assignment` ON issue_requests(store_assignment_id)
33. `idx_issue_requests_status` ON issue_requests(status)
34. `idx_issue_lines_request` ON issue_lines(issue_request_id)
35. `idx_reorders_issue` ON reorders(issue_request_id)

#### Surveys & Layouts
36. `idx_survey_templates_brand` ON survey_templates(brand_id) WHERE deleted_at IS NULL
37. `idx_survey_versions_template` ON survey_versions(survey_template_id)
38. `idx_store_layouts_store` ON store_layouts(store_id, is_current)
39. `idx_location_slots_layout` ON location_slots(store_layout_id)
40. `idx_store_survey_responses_assignment` ON store_survey_responses(store_assignment_id)

#### Notifications & Integration
41. `idx_notifications_user_read` ON notifications(user_id, read_at)
42. `idx_notifications_user_created` ON notifications(user_id, created_at DESC)
43. `idx_webhook_endpoints_tenant` ON webhook_endpoints(tenant_id, is_active)
44. `idx_webhook_deliveries_endpoint` ON webhook_deliveries(webhook_endpoint_id)
45. `idx_webhook_deliveries_retry` ON webhook_deliveries(next_retry_at) WHERE status_code >= 400

#### Audit
46. `idx_audit_events_tenant_action` ON audit_events(tenant_id, action, created_at DESC)
47. `idx_audit_events_actor` ON audit_events(actor_user_id, created_at DESC) WHERE actor_user_id IS NOT NULL

#### Partial/Filtered Indexes (for soft-delete pattern)
48. `idx_active_stores` ON stores(brand_id) WHERE deleted_at IS NULL AND status = 'ACTIVE'
49. `idx_active_campaigns` ON campaigns(brand_id, start_date, end_date) WHERE deleted_at IS NULL AND status != 'ARCHIVED'
50. `idx_pending_photos` ON photo_uploads(store_assignment_id) WHERE review_status = 'PENDING'

### 1.5 MISSING RELATIONSHIPS (Foreign Keys)

SUPP-035 shows relationships conceptually but doesn't specify all FK constraints. Need to define:

#### Core Identity
- memberships.user_id → users.id
- memberships.tenant_id → tenants.id
- memberships.brand_id → brands.id (nullable)
- memberships.region_scope_id → regions.id (nullable)
- memberships.store_scope_id → stores.id (nullable)
- api_keys.tenant_id → tenants.id

#### Geography
- regions.brand_id → brands.id
- regions.parent_region_id → regions.id (nullable, self-reference)
- districts.brand_id → brands.id
- districts.region_id → regions.id
- territories.brand_id → brands.id
- territories.district_id → districts.id (nullable)
- territories.region_id → regions.id
- stores.brand_id → brands.id
- stores.region_id → regions.id
- stores.district_id → districts.id (nullable)
- stores.territory_id → territories.id (nullable)

#### Store Groups
- store_groups.brand_id → brands.id
- store_groups.created_by_user_id → users.id
- store_group_memberships.store_id → stores.id
- store_group_memberships.store_group_id → store_groups.id

#### Surveys & Layouts
- survey_templates.brand_id → brands.id
- survey_versions.survey_template_id → survey_templates.id
- store_layouts.store_id → stores.id
- location_slots.store_layout_id → store_layouts.id
- photo_rules.brand_id → brands.id
- store_survey_responses.store_assignment_id → store_assignments.id
- store_survey_responses.survey_version_id → survey_versions.id

#### Campaigns & Kits
- campaigns.brand_id → brands.id
- campaigns.kit_definition_id → kit_definitions.id
- campaigns.survey_version_id → survey_versions.id
- campaigns.published_by_user_id → users.id
- kit_definitions.brand_id → brands.id
- kit_items.kit_definition_id → kit_definitions.id
- kit_items.photo_rule_id → photo_rules.id (nullable)
- store_assignments.campaign_id → campaigns.id
- store_assignments.store_id → stores.id
- store_assignments.layout_version_id → store_layouts.id
- store_assignments.survey_version_id → survey_versions.id
- assignment_items.store_assignment_id → store_assignments.id
- assignment_items.kit_item_id → kit_items.id
- assignment_items.location_slot_id → location_slots.id (nullable)

#### Fulfillment
- store_orders.campaign_id → campaigns.id
- store_orders.store_id → stores.id
- store_orders.store_assignment_id → store_assignments.id
- order_lines.store_order_id → store_orders.id
- order_lines.kit_item_id → kit_items.id
- shipments.store_order_id → store_orders.id
- shipment_lines.shipment_id → shipments.id
- shipment_lines.kit_item_id → kit_items.id

#### Execution & Verification
- receive_verifications.store_assignment_id → store_assignments.id
- receive_verifications.verified_by_user_id → users.id
- photo_uploads.store_assignment_id → store_assignments.id
- photo_uploads.assignment_item_id → assignment_items.id (nullable)
- photo_uploads.location_slot_id → location_slots.id (nullable)
- photo_uploads.uploaded_by_user_id → users.id
- photo_reviews.photo_upload_id → photo_uploads.id
- photo_reviews.reviewer_user_id → users.id
- retake_requests.photo_upload_id → photo_uploads.id
- retake_requests.store_assignment_id → store_assignments.id
- retake_requests.new_photo_upload_id → photo_uploads.id (nullable)

#### Issues & Reorders
- issue_requests.store_assignment_id → store_assignments.id
- issue_requests.evidence_photo_id → photo_uploads.id (nullable)
- issue_requests.submitted_by_user_id → users.id
- issue_requests.reviewed_by_user_id → users.id (nullable)
- issue_lines.issue_request_id → issue_requests.id
- issue_lines.kit_item_id → kit_items.id
- reorders.issue_request_id → issue_requests.id
- reorders.store_order_id → store_orders.id

#### Notifications
- notification_preferences.user_id → users.id
- notifications.user_id → users.id

#### Integration
- webhook_endpoints.tenant_id → tenants.id
- webhook_deliveries.webhook_endpoint_id → webhook_endpoints.id

#### Exports
- export_jobs.brand_id → brands.id (nullable)
- export_jobs.campaign_id → campaigns.id (nullable)
- export_jobs.requested_by_user_id → users.id

#### Audit
- audit_events.tenant_id → tenants.id
- audit_events.brand_id → brands.id (nullable)
- audit_events.actor_user_id → users.id (nullable)
- audit_events.actor_api_key_id → api_keys.id (nullable)

### 1.6 MISSING TRIGGERS & COMPUTED COLUMNS

Based on SUPP-035 derived status section, these need implementation:

#### Timestamp Triggers
1. **updated_at trigger** - All tables need auto-update of updated_at on row modification
2. **soft_delete trigger** - Prevent hard deletes on tables with deleted_at column

#### Status Computation Functions
These are computed, not stored, but need database functions for consistency:

1. **compute_fulfillment_status(order_id)**
   - Logic: Based on shippedQty, deliveredQty, requiredQty
   - Returns: NOT_SHIPPED | PARTIALLY_SHIPPED | SHIPPED | PARTIALLY_DELIVERED | DELIVERED | EXCEPTION | CANCELLED

2. **compute_receipt_status(assignment_id)**
   - Logic: Based on deliveredQty, receivedGoodQty, receivedDamagedQty
   - Returns: NOT_DELIVERED | NOT_RECEIVED | PARTIALLY_RECEIVED | RECEIVED_WITH_DAMAGE | RECEIVED

3. **compute_execution_status(assignment_id)**
   - Logic: Based on readiness, installation progress, submission state
   - Returns: NOT_READY | READY | IN_PROGRESS | SUBMITTED | REWORK_REQUIRED | COMPLETE | REOPENED | BLOCKED

4. **compute_verification_status(assignment_id)**
   - Logic: Based on photo review states
   - Returns: NA | PENDING | PARTIALLY_APPROVED | APPROVED | REJECTED | WAIVED

5. **compute_store_phase(assignment_id)**
   - Logic: Priority-based rollup of all statuses
   - Returns: REWORK | COMPLETE | IN_REVIEW | EXECUTING | READY_TO_EXECUTE | BLOCKED_BY_EXCEPTION | WAITING_FOR_SHIPMENT | IN_TRANSIT | AWAITING_RECEIPT | UNKNOWN

### 1.7 MISSING SEED DATA REQUIREMENTS

#### Enum Tables (if using lookup tables instead of PG enums)
Need reference data for all enums defined in SUPP-035:
- roles
- store_statuses
- campaign_statuses
- verification_modes
- store_assignment_statuses
- store_order_statuses
- order_types
- shipment_statuses
- photo_review_statuses
- issue_types
- issue_request_statuses
- rejection_reasons
- audit_actor_types
- notification_channels
- export_formats
- export_job_statuses
- assignment_item_statuses
- slot_verification_statuses

#### Reference Data
1. **Default notification preferences** - For each event type and channel
2. **Default photo rules** - Baseline requirements for common scenarios
3. **System user** - For automated actions (actor_type = 'SYSTEM')
4. **Default tenant** - For initial development/testing

---

## 2. Cross-Module Dependencies

### 2.1 Module Dependency Graph

```
Tenancy & Identity (Module 1)
    ↓
Stores & Grouping (Module 2)
    ↓
Surveys & Photo Rules (Module 3)
    ↓
Campaigns & Kits (Module 4)
    ↓
Fulfillment (Module 5)
    ↓
Execution & Verification (Module 6)
    ↓
Issues & Reorders (Module 7)

Cross-cutting:
- Notifications & Preferences (Module 8)
- Webhooks & Integration (Module 9)
- Exports & Jobs (Module 10)
- Audit & Observability (Module 11)
```

### 2.2 Critical FK Chains

1. **Campaign Execution Flow**
   ```
   tenants → brands → campaigns → store_assignments → store_orders → shipments
                                                    → assignment_items → photo_uploads
   ```

2. **Store Hierarchy Flow**
   ```
   brands → regions → districts → territories → stores → store_layouts → location_slots
   ```

3. **Verification Flow**
   ```
   store_assignments → photo_uploads → photo_reviews → retake_requests
   ```

4. **Issue Resolution Flow**
   ```
   store_assignments → issue_requests → issue_lines → reorders → store_orders
   ```

### 2.3 Circular Reference Handling

**NONE DETECTED** - The model is properly acyclic with nullable FKs where needed (e.g., parent_region_id, retake_requests.new_photo_upload_id).

---

## 3. Validation Criteria

### 3.1 Schema Validation Checklist

- [ ] All 40+ tables from SUPP-035 have complete DDL
- [ ] All missing tables identified in this log are added
- [ ] All missing fields identified in this log are added
- [ ] All common fields (id, created_at, updated_at, deleted_at) present on every table
- [ ] All timestamp fields are TIMESTAMPTZ (not TIMESTAMP)
- [ ] All UUID fields use UUID type (not TEXT)
- [ ] All JSON fields use JSONB (not JSON)
- [ ] All enum fields reference proper enum types
- [ ] All nullable vs NOT NULL constraints match business requirements

### 3.2 Relationship Validation Checklist

- [ ] All FK relationships defined with proper ON DELETE behavior
- [ ] All self-referential FKs properly handled (e.g., regions.parent_region_id)
- [ ] All nullable FKs documented with reason (e.g., optional hierarchy levels)
- [ ] All composite unique constraints defined (e.g., store_number + brand_id)
- [ ] All junction tables have composite PKs or surrogate keys as appropriate

### 3.3 Constraint Validation Checklist

- [ ] All CHECK constraints for date ranges (start_date <= end_date)
- [ ] All CHECK constraints for status transitions
- [ ] All CHECK constraints for conditional requirements (e.g., rejection_reason when rejected)
- [ ] All CHECK constraints for mutually exclusive fields
- [ ] All UNIQUE constraints for business keys

### 3.4 Index Validation Checklist

- [ ] All FK columns have indexes (unless very small dimension tables)
- [ ] All status columns have indexes (for filtering)
- [ ] All timestamp columns used for sorting have indexes
- [ ] All composite search patterns have covering indexes
- [ ] All partial indexes for common filtered queries (soft-delete, active only)

### 3.5 Data Validation Checklist

- [ ] All enum values match SUPP-035 exactly
- [ ] All seed data for reference tables complete
- [ ] All default records for system operations (system user, default tenant)
- [ ] All notification event types seeded with default preferences

### 3.6 Business Rule Validation Checklist

- [ ] Campaign cannot be published without stores selected
- [ ] Orders cannot be generated for campaigns without kit definitions
- [ ] Photos cannot be approved if review status is rejected
- [ ] Retakes cannot be created for approved photos
- [ ] Reorders cannot be created without approved issue requests
- [ ] Store assignments enforce readiness before execution
- [ ] Photo uploads require either assignment_item_id OR location_slot_id
- [ ] Issue requests require evidence photo for DAMAGED/PACKAGING types

---

## 4. Work Packages

### Package 1: Core Schema (PRIORITY 1)
**Status**: Not Started
**Target**: Complete DDL for all tables from SUPP-035

**Files to Create:**
- `01_Schema/01_tenancy_identity.sql` - tenants, brands, users, memberships, api_keys
- `01_Schema/02_stores_grouping.sql` - regions, districts, territories, stores, store_groups, store_group_memberships
- `01_Schema/03_surveys_layouts.sql` - survey_templates, survey_versions, store_layouts, location_slots, photo_rules
- `01_Schema/04_campaigns_kits.sql` - campaigns, kit_definitions, kit_items, store_assignments, assignment_items
- `01_Schema/05_fulfillment.sql` - store_orders, order_lines, shipments, shipment_lines
- `01_Schema/06_execution_verification.sql` - receive_verifications, store_survey_responses, photo_uploads, photo_reviews, retake_requests
- `01_Schema/07_issues_reorders.sql` - issue_requests, issue_lines, reorders
- `01_Schema/08_notifications.sql` - notification_preferences, notifications
- `01_Schema/09_webhooks_integration.sql` - webhook_endpoints, webhook_deliveries
- `01_Schema/10_exports_jobs.sql` - export_jobs
- `01_Schema/11_audit_observability.sql` - audit_events

**Dependencies**: None
**Estimated Complexity**: High (40+ tables)

### Package 2: Missing Tables (PRIORITY 1)
**Status**: ✅ COMPLETED (2025-12-19)
**Target**: Add tables identified in gap analysis

**Files Created:**
- `01_Schema/12_missing_tables.sql`:
  - repeatable_sections (survey repeatable blocks)
  - response_edit_audit (survey response edit trail)
  - photo_links (explicit photo-to-requirement bindings)
  - store_change_verifications (store change approval workflow)
  - store_id_aliases (external system ID mappings)
  - completion_submissions (final attestation)
- `01_Schema/13_missing_fields.sql`:
  - ALTER TABLE statements for 12 tables with missing fields
  - Additional indexes for new columns

**Dependencies**: Package 1
**Complexity**: Medium (6 tables + 12 table alterations)

### Package 3: Relationships (PRIORITY 1)
**Status**: Not Started
**Target**: All FK constraints with proper ON DELETE/UPDATE rules

**Files to Create:**
- `02_Relationships/01_fk_tenancy_identity.sql`
- `02_Relationships/02_fk_stores_grouping.sql`
- `02_Relationships/03_fk_surveys_layouts.sql`
- `02_Relationships/04_fk_campaigns_kits.sql`
- `02_Relationships/05_fk_fulfillment.sql`
- `02_Relationships/06_fk_execution_verification.sql`
- `02_Relationships/07_fk_issues_reorders.sql`
- `02_Relationships/08_fk_notifications.sql`
- `02_Relationships/09_fk_webhooks_integration.sql`
- `02_Relationships/10_fk_exports_jobs.sql`
- `02_Relationships/11_fk_audit_observability.sql`
- `02_Relationships/ERD_specification.md` - Mermaid ERD diagrams

**Dependencies**: Package 1, Package 2
**Estimated Complexity**: High (100+ FKs)

### Package 4: Constraints (PRIORITY 2)
**Status**: Not Started
**Target**: Business rule enforcement via CHECK constraints

**Files to Create:**
- `03_Constraints/01_check_campaigns.sql` - Date ranges, status transitions
- `03_Constraints/02_check_assignments.sql` - Status validation, readiness rules
- `03_Constraints/03_check_orders.sql` - Order lifecycle rules
- `03_Constraints/04_check_photos.sql` - Upload validation, review rules
- `03_Constraints/05_check_issues.sql` - Evidence requirements
- `03_Constraints/06_check_memberships.sql` - Role-based scope requirements
- `03_Constraints/07_triggers_timestamps.sql` - updated_at triggers
- `03_Constraints/08_triggers_soft_delete.sql` - Soft delete enforcement

**Dependencies**: Package 3
**Estimated Complexity**: High (business logic complexity)

### Package 5: Indexes (PRIORITY 2)
**Status**: Not Started
**Target**: Performance indexes for common queries

**Files to Create:**
- `04_Indexes/01_idx_lookup.sql` - Primary lookup patterns
- `04_Indexes/02_idx_hierarchy.sql` - Geographic hierarchy navigation
- `04_Indexes/03_idx_campaigns.sql` - Campaign and assignment queries
- `04_Indexes/04_idx_fulfillment.sql` - Order and shipment tracking
- `04_Indexes/05_idx_photos.sql` - Photo upload and review queries
- `04_Indexes/06_idx_issues.sql` - Issue tracking and resolution
- `04_Indexes/07_idx_audit.sql` - Audit and reporting queries
- `04_Indexes/08_idx_partial.sql` - Partial/filtered indexes
- `04_Indexes/performance_notes.md` - Index strategy documentation

**Dependencies**: Package 3
**Estimated Complexity**: Medium (50+ indexes)

### Package 6: Seed Data (PRIORITY 2)
**Status**: Not Started
**Target**: Reference data and enums

**Files to Create:**
- `05_Seed_Data/01_enums.sql` - All enum types and lookup tables
- `05_Seed_Data/02_system_users.sql` - System user for automated actions
- `05_Seed_Data/03_default_tenant.sql` - Development/test tenant
- `05_Seed_Data/04_notification_events.sql` - Event types and default preferences
- `05_Seed_Data/05_photo_rules_defaults.sql` - Baseline photo requirements
- `05_Seed_Data/seed_data_manifest.md` - Documentation of all seed data

**Dependencies**: Package 1, Package 2
**Estimated Complexity**: Medium

### Package 7: Functions & Views (PRIORITY 3)
**Status**: Not Started
**Target**: Computed status functions and reporting views

**Files to Create:**
- `03_Constraints/09_functions_status_computation.sql`:
  - compute_fulfillment_status()
  - compute_receipt_status()
  - compute_execution_status()
  - compute_verification_status()
  - compute_store_phase()
- `04_Indexes/09_views_reporting.sql`:
  - vw_campaign_summary
  - vw_store_assignment_detail
  - vw_photo_review_queue
  - vw_issue_request_queue
  - vw_order_status_summary

**Dependencies**: Package 4
**Estimated Complexity**: High (complex business logic)

### Package 8: Migrations (PRIORITY 3)
**Status**: Not Started
**Target**: Drizzle-compatible migration scripts

**Files to Create:**
- `06_Migrations/0001_initial_schema.sql` - Combined schema from packages 1-2
- `06_Migrations/0002_relationships.sql` - FK constraints from package 3
- `06_Migrations/0003_constraints.sql` - CHECK constraints and triggers from package 4
- `06_Migrations/0004_indexes.sql` - All indexes from package 5
- `06_Migrations/0005_seed_data.sql` - Reference data from package 6
- `06_Migrations/0006_functions_views.sql` - Functions and views from package 7
- `06_Migrations/migration_guide.md` - How to apply migrations

**Dependencies**: All previous packages
**Estimated Complexity**: Medium (assembly work)

### Package 9: Validation (PRIORITY 3)
**Status**: Not Started
**Target**: Comprehensive validation reports

**Files to Create:**
- `07_Validation/01_schema_completeness.md` - Gap analysis resolution report
- `07_Validation/02_relationship_validation.md` - FK coverage report
- `07_Validation/03_constraint_validation.md` - Business rule coverage
- `07_Validation/04_index_validation.md` - Performance index coverage
- `07_Validation/05_data_validation.sql` - Validation queries
- `07_Validation/06_business_rule_tests.sql` - Test cases for constraints
- `07_Validation/final_validation_report.md` - Master validation summary

**Dependencies**: All previous packages
**Estimated Complexity**: Medium

---

## 5. Timeline & Dependencies

### Phase 1: Foundation (Packages 1-2)
- **Duration**: 2-3 days
- **Deliverable**: Complete schema DDL for all tables
- **Blocker for**: All other packages

### Phase 2: Relationships & Constraints (Packages 3-4)
- **Duration**: 2-3 days
- **Deliverable**: All FKs, CHECK constraints, triggers defined
- **Blocker for**: Migrations, validation

### Phase 3: Performance & Data (Packages 5-6)
- **Duration**: 1-2 days
- **Deliverable**: Indexes and seed data complete
- **Blocker for**: Production readiness

### Phase 4: Business Logic (Package 7)
- **Duration**: 2-3 days
- **Deliverable**: Status computation functions and reporting views
- **Blocker for**: Application layer integration

### Phase 5: Assembly & Validation (Packages 8-9)
- **Duration**: 1-2 days
- **Deliverable**: Migration scripts and validation reports
- **Blocker for**: AutoCoder implementation

**Total Estimated Duration**: 8-13 days

---

## 6. Open Questions & Decisions Needed

### 6.1 Technical Decisions

1. **Enum Implementation Strategy**
   - [ ] Use PostgreSQL native ENUMs (harder to change)
   - [ ] Use lookup tables with FK constraints (more flexible)
   - [ ] Use CHECK constraints on TEXT columns (simplest)
   - **Recommendation**: PostgreSQL ENUMs for SUPP-035 enums; can migrate to lookup tables later if needed

2. **Soft Delete vs Hard Delete**
   - [ ] All tables use deleted_at soft delete
   - [ ] Only audit-critical tables use soft delete
   - [ ] Configurable per table
   - **Recommendation**: All tables use soft delete (as specified in SUPP-035 common fields)

3. **Timestamp Precision**
   - [ ] TIMESTAMPTZ with millisecond precision (default)
   - [ ] TIMESTAMPTZ with microsecond precision
   - **Recommendation**: Default millisecond precision sufficient for business requirements

4. **UUID Generation**
   - [ ] Database-generated via gen_random_uuid()
   - [ ] Application-generated UUIDs
   - [ ] ULID (ordered UUIDs) for better index performance
   - **Recommendation**: Database-generated UUIDs via gen_random_uuid() for consistency

5. **JSONB Indexing Strategy**
   - [ ] GIN indexes on all JSONB columns
   - [ ] GIN indexes only on frequently queried JSONB
   - [ ] No JSONB indexes (query full column)
   - **Recommendation**: GIN indexes on selection_recipe_json, layout_json, settings_json, definition_json

### 6.2 Business Logic Decisions

1. **Photo Upload Requirements**
   - [ ] Photos must link to assignment_item_id OR location_slot_id (mutually exclusive)
   - [ ] Photos can link to both (for precision)
   - [ ] Photos can link to neither (for general evidence)
   - **Need**: Clarification from SUPP-014 and SUPP-017

2. **Store Assignment Readiness**
   - [ ] Readiness is a computed boolean from multiple conditions
   - [ ] Readiness is a stored field with manual override
   - [ ] Readiness has blocking reasons tracked explicitly
   - **Recommendation**: Stored field with explicit readiness_blocked_reasons JSONB array

3. **Order Generation Timing**
   - [ ] Orders generated on campaign publish
   - [ ] Orders generated on store assignment (can be incremental)
   - [ ] Orders generated on store readiness (delayed)
   - **Per SUPP-015**: Orders generated on campaign publish for all assignments

4. **Reorder Handling**
   - [ ] Reorders are separate store_orders linked to original assignment
   - [ ] Reorders are additional lines on original order
   - [ ] Reorders are tracked in separate reorder table only
   - **Per SUPP-016**: Separate store_orders with type=REORDER

### 6.3 Integration Decisions

1. **PSP Integration Fields**
   - [ ] psp_campaign_ref and psp_order_ref are nullable (PSP assigns after acknowledgment)
   - [ ] System pre-generates refs and pushes to PSP
   - **Per SUPP-016**: PSP assigns their own refs; fields are nullable initially

2. **Webhook Retry Strategy**
   - [ ] Database-managed retry queue via next_retry_at
   - [ ] External queue (e.g., BullMQ, Temporal)
   - **Recommendation**: Database-managed for v1 simplicity; can migrate to queue later

3. **Export File Storage**
   - [ ] S3 keys stored in export_jobs.s3_key
   - [ ] Separate file_storage table for all S3 assets
   - **Per SUPP-035**: s3_key directly in export_jobs (and photo_uploads)

---

## 7. Change Log

| Date | Version | Change | Author |
|------|---------|--------|--------|
| 2025-12-19 | v1.0 | Initial orchestration log created with comprehensive gap analysis | Orchestrator Agent |
| 2025-12-19 | v1.1 | Added 12_missing_tables.sql with 6 tables from gap analysis (repeatable_sections, response_edit_audit, photo_links, store_change_verifications, store_id_aliases, completion_submissions) | AutoCoder by ServFlow |
| 2025-12-19 | v1.1 | Added 13_missing_fields.sql with ALTER TABLE statements for 12 tables (tenants, brands, users, memberships, campaigns, store_assignments, store_orders, assignment_items, location_slots, photo_rules, issue_requests, retake_requests) | AutoCoder by ServFlow |

---

## 8. Next Steps

1. **Completed Actions**:
   - [x] Initial orchestration log created with comprehensive gap analysis
   - [x] Package 2 completed: Missing tables and fields added
     - 12_missing_tables.sql (6 tables)
     - 13_missing_fields.sql (12 table alterations)

2. **Immediate Actions**:
   - [ ] Review this orchestration log with stakeholders
   - [ ] Resolve open questions in Section 6
   - [ ] Continue with Package 3 (FK relationships)
   - [ ] Continue with Package 4 (CHECK constraints)

3. **Agent Assignments** (TBD):
   - Schema Agent → Packages 1-2 ✅ COMPLETED
   - Relationship Agent → Package 3 (NEXT)
   - Constraint Agent → Package 4
   - Performance Agent → Package 5
   - Data Agent → Package 6
   - Business Logic Agent → Package 7
   - Migration Agent → Package 8
   - Validation Agent → Package 9

4. **Quality Gates**:
   - Each package requires validation report before merging
   - All validation checklists must pass before Package 8
   - Final validation report required before AutoCoder handoff

---

*End of Orchestration Log v1.0*
