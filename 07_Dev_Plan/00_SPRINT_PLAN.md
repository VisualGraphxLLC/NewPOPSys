# NewPOPSys v1 - Sprint Development Plan

## Executive Summary

| Attribute | Value |
|-----------|-------|
| **Project** | NewPOPSys v1 - Point of Purchase System |
| **Timeline** | 12 Weeks (3 Months) to Beta |
| **Target** | End of Q1 2025 |
| **Budget** | $150,000 |
| **Version** | 1.0 |
| **Created** | 2025-12-30 |

---

## Sprint Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        12-WEEK SPRINT ROADMAP                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  PHASE 1: FOUNDATION        PHASE 2: CORE           PHASE 3: EXECUTION     │
│  ──────────────────         ──────────                ───────────────       │
│  Week 1-4                   Week 5-8                 Week 9-12              │
│                                                                             │
│  ┌─────────────┐           ┌─────────────┐          ┌─────────────┐        │
│  │ Sprint 1    │           │ Sprint 3    │          │ Sprint 5    │        │
│  │ Core +      │──────────▶│ Campaign    │─────────▶│ Execution   │        │
│  │ Identity    │           │ Engine      │          │ & Mobile    │        │
│  └─────────────┘           └─────────────┘          └─────────────┘        │
│         │                         │                        │               │
│         ▼                         ▼                        ▼               │
│  ┌─────────────┐           ┌─────────────┐          ┌─────────────┐        │
│  │ Sprint 2    │           │ Sprint 4    │          │ Sprint 6    │        │
│  │ Store +     │──────────▶│ Fulfillment │─────────▶│ Platform &  │        │
│  │ Survey      │           │ & Orders    │          │ Integration │        │
│  └─────────────┘           └─────────────┘          └─────────────┘        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Foundation (Weeks 1-4)

### Sprint 1: Core Infrastructure & Identity (Weeks 1-2)

**Objective**: Establish database foundation, multi-tenancy, and authentication

#### Database Schema (Layer 1)

| Table | Priority | Lines | Dependencies | SUPP Reference |
|-------|----------|-------|--------------|----------------|
| `tenants` | P0 | 45 | None | SUPP-002 |
| `brands` | P0 | 52 | tenants | SUPP-002 |
| `users` | P0 | 68 | tenants, brands | SUPP-003 |
| `user_sessions` | P0 | 35 | users | SUPP-003 |
| `user_brand_access` | P0 | 28 | users, brands | SUPP-003 |
| `audit_events` | P1 | 42 | users | SUPP-035 |

**Enumerations Required**:
```sql
-- Foundation enums (8 total)
role_enum, tenant_status_enum, brand_status_enum,
audit_action_enum, notification_channel_enum,
notification_priority_enum, webhook_status_enum, export_status_enum
```

**Indexes Required**:
- `idx_users_email` (UNIQUE)
- `idx_users_tenant_brand` (composite)
- `idx_user_sessions_token` (UNIQUE)
- `idx_user_sessions_expires` (for cleanup)
- `idx_audit_events_entity` (composite)
- `idx_audit_events_user` (for user activity)

#### API Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/api/v1/auth/login` | POST | Public | User authentication |
| `/api/v1/auth/logout` | POST | Bearer | Session termination |
| `/api/v1/auth/refresh` | POST | Bearer | Token refresh |
| `/api/v1/users` | GET | Bearer+RBAC | List users |
| `/api/v1/users/{id}` | GET/PUT | Bearer+RBAC | User CRUD |
| `/api/v1/tenants` | GET | Platform Admin | List tenants |
| `/api/v1/brands` | GET | Bearer+RBAC | List brands |

#### Screens Delivered

| Screen | Application | Priority | Personas |
|--------|-------------|----------|----------|
| Login/Auth | All Apps | P0 | All |
| User Profile | All Apps | P1 | All |
| Platform Dashboard | Brand Admin | P1 | PLATFORM_ADMIN |

#### Acceptance Criteria

- [ ] Multi-tenant isolation verified with test data
- [ ] JWT authentication flow complete
- [ ] RBAC middleware enforcing 8 role types
- [ ] Audit trail capturing all write operations
- [ ] Session management with expiry and refresh
- [ ] Password hashing with bcrypt (cost 12)
- [ ] Rate limiting on auth endpoints (10/min)

#### Immutability & Idempotency Rules

| Table | Immutable Fields | Idempotent Operations |
|-------|------------------|----------------------|
| `tenants` | `id`, `created_at` | Create by slug |
| `brands` | `id`, `tenant_id`, `created_at` | Create by name+tenant |
| `users` | `id`, `created_at` | Create by email |
| `audit_events` | ALL (append-only) | N/A - log only |

---

### Sprint 2: Store & Survey Foundation (Weeks 3-4)

**Objective**: Complete store management and survey builder infrastructure

#### Database Schema (Layer 2)

| Table | Priority | Lines | Dependencies | SUPP Reference |
|-------|----------|-------|--------------|----------------|
| `regions` | P0 | 38 | brands | SUPP-013 |
| `districts` | P0 | 40 | regions | SUPP-013 |
| `territories` | P0 | 42 | districts | SUPP-013 |
| `stores` | P0 | 95 | territories | SUPP-013 |
| `store_groups` | P1 | 35 | brands | SUPP-013 |
| `store_group_members` | P1 | 22 | store_groups, stores | SUPP-013 |
| `store_layouts` | P1 | 48 | stores | SUPP-013 |
| `location_slots` | P1 | 55 | store_layouts | SUPP-013 |
| `store_id_aliases` | P2 | 45 | stores | SUPP-013 |
| `store_change_verifications` | P2 | 58 | stores | SUPP-013 |
| `survey_templates` | P0 | 52 | brands | SUPP-014 |
| `survey_versions` | P0 | 65 | survey_templates | SUPP-014 |
| `repeatable_sections` | P1 | 48 | survey_versions | SUPP-014 |
| `photo_rules` | P1 | 62 | survey_versions | SUPP-014 |

**Enumerations Required**:
```sql
-- Store & Survey enums (6 total)
store_status_enum, layout_status_enum, slot_type_enum,
survey_status_enum, question_type_enum, store_change_status_enum
```

**Indexes Required**:
- `idx_stores_territory` (geographic queries)
- `idx_stores_status` (filtered lists)
- `idx_stores_brand` (multi-tenant isolation)
- `idx_location_slots_layout` (slot lookups)
- `idx_survey_versions_template` (version history)
- `idx_survey_versions_status` (active version lookup)
- GIN index on `stores.address_json` (address search)
- GIN index on `survey_versions.definition_json` (survey structure)

#### API Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/api/v1/stores` | GET/POST | Bearer+RBAC | Store CRUD |
| `/api/v1/stores/{id}` | GET/PUT/DELETE | Bearer+RBAC | Store detail |
| `/api/v1/stores/{id}/layout` | GET/PUT | Bearer+RBAC | Layout management |
| `/api/v1/stores/import` | POST | Bearer+RBAC | Bulk CSV import |
| `/api/v1/regions` | GET/POST | Bearer+RBAC | Region hierarchy |
| `/api/v1/surveys` | GET/POST | Bearer+RBAC | Survey templates |
| `/api/v1/surveys/{id}/versions` | GET/POST | Bearer+RBAC | Version control |
| `/api/v1/surveys/{id}/publish` | POST | Bearer+RBAC | Publish version |

#### Screens Delivered

| Screen | Application | Priority | Personas |
|--------|-------------|----------|----------|
| Store List | Brand Admin | P0 | BRAND_ADMIN, REGIONAL_MANAGER |
| Store Detail | Brand Admin | P0 | BRAND_ADMIN, REGIONAL_MANAGER |
| Store Import | Brand Admin | P1 | BRAND_ADMIN |
| Survey Builder | Brand Admin | P0 | BRAND_ADMIN, CAMPAIGN_MANAGER |
| Survey Preview | Brand Admin | P1 | BRAND_ADMIN, CAMPAIGN_MANAGER |

#### Geographic Hierarchy

```
Brand
  └── Region (e.g., "Northeast")
       └── District (e.g., "New England")
            └── Territory (e.g., "Boston Metro")
                 └── Store (e.g., "Store #1234")
                      └── Layout
                           └── Location Slots (Cooler-1, Endcap-A, etc.)
```

#### Survey Version Workflow

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  DRAFT   │───▶│  REVIEW  │───▶│ APPROVED │───▶│ ARCHIVED │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
     │               │               │
     │    Edit OK    │    Edit OK    │    Read-only
     ▼               ▼               ▼
   [Create]      [Submit]       [Publish]      [Supersede]
```

#### Acceptance Criteria

- [ ] Geographic hierarchy CRUD with cascading updates
- [ ] Store CSV import with 10,000+ record support
- [ ] Store layout slot definition and ordering
- [ ] Survey builder with all question types
- [ ] Survey version control with diff view
- [ ] Photo rule configuration per survey
- [ ] Store grouping (static and dynamic rules)
- [ ] Store change verification workflow

---

## Phase 2: Core Business Logic (Weeks 5-8)

### Sprint 3: Campaign Engine (Weeks 5-6)

**Objective**: Complete campaign lifecycle and store assignment logic

#### Database Schema (Layer 3)

| Table | Priority | Lines | Dependencies | SUPP Reference |
|-------|----------|-------|--------------|----------------|
| `kit_definitions` | P0 | 55 | brands | SUPP-015 |
| `kit_items` | P0 | 48 | kit_definitions | SUPP-015 |
| `campaigns` | P0 | 98 | brands, surveys, kits | SUPP-015 |
| `store_assignments` | P0 | 85 | campaigns, stores | SUPP-015 |
| `assignment_items` | P0 | 72 | store_assignments, kit_items | SUPP-015 |

**Enumerations Required**:
```sql
-- Campaign enums (4 total)
campaign_status_enum, campaign_type_enum,
store_assignment_status_enum, verification_mode_enum
```

**State Machine: Campaign Lifecycle**

```
                              ┌────────────────┐
                              │    CREATED     │
                              │  (draft mode)  │
                              └───────┬────────┘
                                      │ configure
                                      ▼
                              ┌────────────────┐
                              │   CONFIGURED   │
                              │ (ready to run) │
                              └───────┬────────┘
                                      │ activate
          ┌───────────────────────────┼───────────────────────────┐
          ▼                           ▼                           ▼
┌────────────────┐          ┌────────────────┐          ┌────────────────┐
│    PENDING     │─────────▶│     ACTIVE     │─────────▶│   COMPLETED    │
│ (future start) │  start   │  (in progress) │   end    │   (finished)   │
└────────────────┘          └───────┬────────┘          └────────────────┘
                                    │ pause
                                    ▼
                            ┌────────────────┐
                            │     PAUSED     │
                            │  (temporary)   │
                            └────────────────┘
                                    │
                                    ▼
                            ┌────────────────┐
                            │   CANCELLED    │
                            │  (terminated)  │
                            └────────────────┘
```

**State Machine: Store Assignment**

```
┌───────────┐    ┌───────────┐    ┌───────────┐    ┌───────────┐
│  PENDING  │───▶│  SHIPPED  │───▶│ DELIVERED │───▶│ RECEIVED  │
└───────────┘    └───────────┘    └───────────┘    └───────────┘
                                                         │
                      ┌──────────────────────────────────┤
                      ▼                                  ▼
               ┌───────────┐                      ┌───────────┐
               │ INSTALLING│─────────────────────▶│ COMPLETED │
               └───────────┘                      └───────────┘
                      │                                  │
                      ▼                                  ▼
               ┌───────────┐                      ┌───────────┐
               │  ISSUES   │                      │  VERIFIED │
               └───────────┘                      └───────────┘
```

#### API Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/api/v1/kits` | GET/POST | Bearer+RBAC | Kit definitions |
| `/api/v1/kits/{id}/items` | GET/POST | Bearer+RBAC | Kit items |
| `/api/v1/campaigns` | GET/POST | Bearer+RBAC | Campaign CRUD |
| `/api/v1/campaigns/{id}` | GET/PUT | Bearer+RBAC | Campaign detail |
| `/api/v1/campaigns/{id}/activate` | POST | Bearer+RBAC | State transition |
| `/api/v1/campaigns/{id}/assignments` | GET/POST | Bearer+RBAC | Store assignments |
| `/api/v1/campaigns/{id}/assignments/generate` | POST | Bearer+RBAC | Auto-generate |
| `/api/v1/assignments/{id}` | GET/PUT | Bearer+RBAC | Assignment detail |

#### Store Selection Recipe

```json
{
  "selection_recipe": {
    "mode": "FILTER",
    "filters": [
      { "field": "region_id", "op": "IN", "value": ["uuid1", "uuid2"] },
      { "field": "store_type", "op": "EQ", "value": "CONVENIENCE" },
      { "field": "tier", "op": "GTE", "value": "GOLD" }
    ],
    "exclusions": {
      "store_ids": ["uuid3"],
      "store_groups": ["INACTIVE_2024"]
    },
    "sampling": {
      "enabled": false,
      "percentage": null,
      "seed": null
    }
  }
}
```

#### Screens Delivered

| Screen | Application | Priority | Personas |
|--------|-------------|----------|----------|
| Campaign List | Brand Admin | P0 | BRAND_ADMIN, CAMPAIGN_MANAGER |
| Campaign Builder | Brand Admin | P0 | BRAND_ADMIN, CAMPAIGN_MANAGER |
| Kit Builder | Brand Admin | P0 | BRAND_ADMIN |
| Assignment Manager | Brand Admin | P0 | CAMPAIGN_MANAGER |
| Campaign Dashboard | Brand Admin | P1 | All Brand roles |

#### Acceptance Criteria

- [ ] Campaign CRUD with state machine enforcement
- [ ] Kit definition with item quantities
- [ ] Store selection recipe builder (UI)
- [ ] Auto-generate assignments from recipe
- [ ] Assignment item quantity tracking
- [ ] Campaign cloning for repeat programs
- [ ] Campaign scheduling with timezone support
- [ ] Real-time assignment status aggregation

---

### Sprint 4: Fulfillment & Orders (Weeks 7-8)

**Objective**: Complete order management, shipping, and receiving workflows

#### Database Schema (Layer 4)

| Table | Priority | Lines | Dependencies | SUPP Reference |
|-------|----------|-------|--------------|----------------|
| `store_orders` | P0 | 78 | store_assignments | SUPP-016 |
| `order_lines` | P0 | 55 | store_orders, assignment_items | SUPP-016 |
| `shipments` | P0 | 72 | store_orders | SUPP-016 |
| `shipment_lines` | P0 | 48 | shipments, order_lines | SUPP-016 |
| `receive_verifications` | P0 | 62 | store_assignments | SUPP-016 |

**Enumerations Required**:
```sql
-- Fulfillment enums (5 total)
order_status_enum, order_type_enum,
shipment_status_enum, carrier_enum, receipt_status_enum
```

**Quantity Tracking Fields** (on `assignment_items`):
```sql
required_qty INTEGER NOT NULL DEFAULT 1,
shipped_qty INTEGER NOT NULL DEFAULT 0,
delivered_qty INTEGER NOT NULL DEFAULT 0,
received_good_qty INTEGER NOT NULL DEFAULT 0,
received_damaged_qty INTEGER NOT NULL DEFAULT 0,
installed_qty INTEGER NOT NULL DEFAULT 0,
satisfied_qty INTEGER NOT NULL DEFAULT 0
```

**Derived Status Functions**:
```sql
-- Fulfillment status derivation
CREATE OR REPLACE FUNCTION get_fulfillment_status(
  p_required_qty INTEGER,
  p_shipped_qty INTEGER,
  p_delivered_qty INTEGER,
  p_is_cancelled BOOLEAN DEFAULT FALSE
) RETURNS TEXT AS $$
BEGIN
  IF p_is_cancelled THEN RETURN 'CANCELLED';
  ELSIF p_shipped_qty = 0 THEN RETURN 'NOT_SHIPPED';
  ELSIF p_shipped_qty < p_required_qty THEN RETURN 'PARTIALLY_SHIPPED';
  ELSIF p_delivered_qty = 0 THEN RETURN 'SHIPPED';
  ELSIF p_delivered_qty < p_required_qty THEN RETURN 'PARTIALLY_DELIVERED';
  ELSE RETURN 'DELIVERED';
  END IF;
END;
$$ LANGUAGE plpgsql IMMUTABLE;
```

**State Machine: Order**

```
┌───────────┐    ┌───────────┐    ┌───────────┐    ┌───────────┐
│  CREATED  │───▶│ SUBMITTED │───▶│ CONFIRMED │───▶│ FULFILLED │
└───────────┘    └───────────┘    └───────────┘    └───────────┘
                      │                                   │
                      ▼                                   ▼
               ┌───────────┐                       ┌───────────┐
               │ CANCELLED │                       │ COMPLETED │
               └───────────┘                       └───────────┘
```

**State Machine: Shipment**

```
┌───────────┐    ┌───────────┐    ┌───────────┐    ┌───────────┐
│  CREATED  │───▶│  SHIPPED  │───▶│ IN_TRANSIT│───▶│ DELIVERED │
└───────────┘    └───────────┘    └───────────┘    └───────────┘
                      │                │                │
                      ▼                ▼                ▼
               ┌───────────┐    ┌───────────┐    ┌───────────┐
               │  FAILED   │    │ EXCEPTION │    │  PARTIAL  │
               └───────────┘    └───────────┘    └───────────┘
```

#### API Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/api/v1/orders` | GET/POST | Bearer+RBAC | Order management |
| `/api/v1/orders/{id}` | GET/PUT | Bearer+RBAC | Order detail |
| `/api/v1/orders/{id}/submit` | POST | Bearer+RBAC | Submit for fulfillment |
| `/api/v1/shipments` | GET/POST | Bearer+RBAC | Shipment tracking |
| `/api/v1/shipments/{id}` | GET/PUT | Bearer+RBAC | Shipment detail |
| `/api/v1/shipments/{id}/delivered` | POST | Bearer+RBAC | Mark delivered |
| `/api/v1/assignments/{id}/receive` | POST | Bearer+RBAC | Receive verification |

#### Views Delivered

```sql
-- Order fulfillment summary view
CREATE VIEW v_order_fulfillment_summary AS
SELECT
  so.id AS order_id,
  so.order_number,
  COUNT(ol.id) AS total_lines,
  SUM(ol.quantity) AS total_items,
  SUM(CASE WHEN ol.shipped_qty >= ol.quantity THEN 1 ELSE 0 END) AS shipped_lines,
  SUM(CASE WHEN ol.delivered_qty >= ol.quantity THEN 1 ELSE 0 END) AS delivered_lines
FROM store_orders so
JOIN order_lines ol ON ol.store_order_id = so.id
WHERE so.deleted_at IS NULL
GROUP BY so.id, so.order_number;
```

#### Screens Delivered

| Screen | Application | Priority | Personas |
|--------|-------------|----------|----------|
| Order Queue | PSP Operations | P0 | PSP_OPS |
| Order Detail | PSP Operations | P0 | PSP_OPS |
| Shipment Tracker | PSP Operations | P0 | PSP_OPS |
| Fulfillment Dashboard | PSP Operations | P1 | PSP_ADMIN |

#### Acceptance Criteria

- [ ] Order generation from assignments (auto/manual)
- [ ] Order line quantity management
- [ ] Shipment creation with carrier integration hooks
- [ ] Tracking number capture and display
- [ ] Delivery confirmation workflow
- [ ] Receiving verification (good/damaged counts)
- [ ] Quantity reconciliation across chain
- [ ] Fulfillment status dashboard with KPIs

---

## Phase 3: Execution & Integration (Weeks 9-12)

### Sprint 5: Store Execution & Mobile (Weeks 9-10)

**Objective**: Complete mobile app and store execution workflows

#### Database Schema (Layer 5)

| Table | Priority | Lines | Dependencies | SUPP Reference |
|-------|----------|-------|--------------|----------------|
| `store_survey_responses` | P0 | 85 | store_assignments, surveys | SUPP-017 |
| `response_edit_audit` | P0 | 45 | store_survey_responses | SUPP-014 |
| `photo_uploads` | P0 | 92 | store_assignments | SUPP-017 |
| `photo_links` | P0 | 58 | photo_uploads | SUPP-017 |
| `photo_reviews` | P1 | 55 | photo_uploads | SUPP-018 |
| `retake_requests` | P1 | 48 | photo_uploads | SUPP-018 |
| `issue_requests` | P1 | 72 | store_assignments | SUPP-019 |
| `issue_lines` | P1 | 45 | issue_requests | SUPP-019 |
| `reorders` | P2 | 52 | issue_lines | SUPP-019 |
| `completion_submissions` | P0 | 55 | store_assignments | SUPP-002 |

**Enumerations Required**:
```sql
-- Execution enums (8 total)
survey_response_status_enum, photo_status_enum, photo_type_enum,
review_status_enum, review_result_enum, retake_reason_enum,
issue_type_enum, issue_status_enum, completion_status_enum
```

**Two-Stage Survey Workflow**:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     STORE EXECUTION WORKFLOW                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  STAGE 1: RECEIPT SURVEY              STAGE 2: INSTALL SURVEY               │
│  ─────────────────────                ─────────────────────                 │
│                                                                             │
│  ┌─────────────┐                     ┌─────────────┐                       │
│  │ Shipment    │                     │ Install     │                       │
│  │ Received    │                     │ Materials   │                       │
│  └──────┬──────┘                     └──────┬──────┘                       │
│         │                                   │                              │
│         ▼                                   ▼                              │
│  ┌─────────────┐                     ┌─────────────┐                       │
│  │ Unpack &    │                     │ Photo Each  │                       │
│  │ Verify Qty  │                     │ Location    │                       │
│  └──────┬──────┘                     └──────┬──────┘                       │
│         │                                   │                              │
│         ▼                                   ▼                              │
│  ┌─────────────┐                     ┌─────────────┐                       │
│  │ Photo Box   │                     │ Complete    │                       │
│  │ Contents    │                     │ Survey      │                       │
│  └──────┬──────┘                     └──────┬──────┘                       │
│         │                                   │                              │
│         ▼                                   ▼                              │
│  ┌─────────────┐                     ┌─────────────┐                       │
│  │ Report      │                     │ Submit for  │                       │
│  │ Damages     │                     │ Review      │                       │
│  └─────────────┘                     └─────────────┘                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Photo State Machine**:

```
┌───────────┐    ┌───────────┐    ┌───────────┐
│ UPLOADED  │───▶│ SUBMITTED │───▶│ APPROVED  │
└───────────┘    └───────────┘    └───────────┘
                      │                │
                      ▼                │
               ┌───────────┐          │
               │  REVIEW   │──────────┘
               └───────────┘
                      │
                      ▼
               ┌───────────┐    ┌───────────┐
               │ REJECTED  │───▶│ RETAKE    │
               └───────────┘    │ REQUESTED │
                                └───────────┘
```

#### Mobile App Screens (8 Total)

| Screen | Priority | Description | Personas |
|--------|----------|-------------|----------|
| My Tasks | P0 | Assignment list with filters | STORE_MANAGER, STORE_OPERATOR |
| Task Detail | P0 | Assignment items and status | STORE_MANAGER, STORE_OPERATOR |
| Receipt Survey | P0 | Receiving verification form | STORE_MANAGER, STORE_OPERATOR |
| Install Survey | P0 | Installation completion form | STORE_MANAGER, STORE_OPERATOR |
| Camera/Upload | P0 | Photo capture with guides | STORE_MANAGER, STORE_OPERATOR |
| Report Issue | P1 | Damage/shortage reporting | STORE_MANAGER, STORE_OPERATOR |
| Task History | P1 | Completed assignments | STORE_MANAGER |
| Settings | P2 | Notification preferences | All |

#### API Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/api/v1/mobile/tasks` | GET | Bearer | My assignments |
| `/api/v1/mobile/tasks/{id}` | GET | Bearer | Task detail |
| `/api/v1/mobile/tasks/{id}/survey/receipt` | GET/POST | Bearer | Receipt survey |
| `/api/v1/mobile/tasks/{id}/survey/install` | GET/POST | Bearer | Install survey |
| `/api/v1/mobile/tasks/{id}/photos` | POST | Bearer | Photo upload |
| `/api/v1/mobile/tasks/{id}/issues` | POST | Bearer | Report issue |
| `/api/v1/mobile/tasks/{id}/complete` | POST | Bearer | Submit completion |
| `/api/v1/photos/{id}` | GET | Bearer+RBAC | Photo detail |
| `/api/v1/photos/{id}/review` | POST | Bearer+RBAC | Review photo |

#### Photo Upload Requirements

```json
{
  "photo_rules": [
    {
      "rule_id": "uuid",
      "location_type": "SLOT",
      "location_slot_id": "uuid",
      "min_photos": 1,
      "max_photos": 3,
      "required_angles": ["FRONT", "CLOSE"],
      "guidelines": "Photo must show full installation at eye level"
    }
  ],
  "upload_spec": {
    "max_size_mb": 10,
    "allowed_formats": ["JPEG", "PNG", "HEIC"],
    "min_resolution": "1280x720",
    "require_geolocation": true,
    "require_timestamp": true
  }
}
```

#### Acceptance Criteria

- [ ] Mobile app responsive design (iOS/Android PWA)
- [ ] Offline-capable survey with sync
- [ ] Camera integration with photo guides
- [ ] GPS validation for store location
- [ ] Receipt survey with quantity capture
- [ ] Install survey with slot-specific photos
- [ ] Issue reporting with photo evidence
- [ ] Push notifications for assignments
- [ ] Photo review queue for QA
- [ ] Retake request workflow
- [ ] Completion attestation with signature

---

### Sprint 6: Platform & Integration (Weeks 11-12)

**Objective**: Complete platform features, webhooks, and beta preparation

#### Database Schema (Layer 6)

| Table | Priority | Lines | Dependencies | SUPP Reference |
|-------|----------|-------|--------------|----------------|
| `notification_preferences` | P0 | 45 | users | SUPP-004 |
| `notifications` | P0 | 55 | users | SUPP-004 |
| `webhook_endpoints` | P0 | 52 | brands | SUPP-006 |
| `webhook_deliveries` | P0 | 48 | webhook_endpoints | SUPP-006 |
| `export_jobs` | P1 | 45 | brands | SUPP-006 |

**Webhook Event Types**:
```
campaign.created, campaign.activated, campaign.completed
assignment.created, assignment.shipped, assignment.delivered
assignment.completed, assignment.issue_reported
photo.uploaded, photo.approved, photo.rejected
survey.submitted, survey.approved
```

**Webhook Delivery Spec**:
```json
{
  "webhook_delivery": {
    "signing_algorithm": "HMAC-SHA256",
    "signature_header": "X-POPSys-Signature",
    "retry_policy": {
      "max_attempts": 5,
      "backoff": "exponential",
      "initial_delay_seconds": 60,
      "max_delay_seconds": 3600
    },
    "timeout_seconds": 30
  }
}
```

#### Store Manager Portal Screens (5 Total)

| Screen | Priority | Description | Personas |
|--------|----------|-------------|----------|
| Store Dashboard | P0 | KPIs and active campaigns | STORE_MANAGER |
| Team Management | P1 | Store operators list | STORE_MANAGER |
| Assignment History | P1 | Historical assignments | STORE_MANAGER |
| Reports | P2 | Store performance | STORE_MANAGER |
| Settings | P2 | Store preferences | STORE_MANAGER |

#### Views Delivered

```sql
-- Assignment verification status view
CREATE VIEW v_assignment_verification_status AS
SELECT
  sa.id AS assignment_id,
  sa.campaign_id,
  sa.store_id,
  COUNT(ai.id) AS total_items,
  SUM(ai.required_qty) AS total_required,
  SUM(ai.received_good_qty) AS total_received_good,
  SUM(ai.installed_qty) AS total_installed,
  get_verification_status(
    SUM(ai.required_qty)::INTEGER,
    SUM(ai.received_good_qty)::INTEGER,
    SUM(ai.installed_qty)::INTEGER
  ) AS verification_status
FROM store_assignments sa
JOIN assignment_items ai ON ai.store_assignment_id = sa.id
WHERE sa.deleted_at IS NULL
GROUP BY sa.id, sa.campaign_id, sa.store_id;

-- Issue request summary view
CREATE VIEW v_issue_request_summary AS
SELECT
  ir.id AS issue_id,
  ir.store_assignment_id,
  ir.issue_type,
  ir.status,
  COUNT(il.id) AS line_count,
  SUM(il.quantity) AS total_quantity,
  COALESCE(SUM(r.quantity), 0) AS reorder_quantity
FROM issue_requests ir
LEFT JOIN issue_lines il ON il.issue_request_id = ir.id
LEFT JOIN reorders r ON r.issue_line_id = il.id
WHERE ir.deleted_at IS NULL
GROUP BY ir.id;
```

#### API Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/api/v1/notifications` | GET | Bearer | User notifications |
| `/api/v1/notifications/preferences` | GET/PUT | Bearer | Preferences |
| `/api/v1/webhooks` | GET/POST | Bearer+RBAC | Webhook management |
| `/api/v1/webhooks/{id}` | GET/PUT/DELETE | Bearer+RBAC | Webhook detail |
| `/api/v1/webhooks/{id}/test` | POST | Bearer+RBAC | Test delivery |
| `/api/v1/exports` | GET/POST | Bearer+RBAC | Export jobs |
| `/api/v1/exports/{id}` | GET | Bearer+RBAC | Export status |
| `/api/v1/exports/{id}/download` | GET | Bearer+RBAC | Download file |

#### Export Formats

| Format | Use Case | Max Records |
|--------|----------|-------------|
| CSV | Store data, assignments | 100,000 |
| XLSX | Reports with formatting | 50,000 |
| JSON | API integrations | Unlimited |
| PDF | Branded reports | 1,000 |

#### Beta Preparation Checklist

- [ ] Load testing (1000 concurrent users)
- [ ] Security audit (OWASP Top 10)
- [ ] API documentation (OpenAPI 3.0)
- [ ] Error monitoring (Sentry integration)
- [ ] Log aggregation (structured JSON)
- [ ] Database backup/restore tested
- [ ] Staging environment deployed
- [ ] Beta user accounts provisioned
- [ ] Feedback collection mechanism
- [ ] Rollback procedures documented

---

## Dependency Matrix

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SPRINT DEPENDENCY GRAPH                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Sprint 1 ────┬────▶ Sprint 3 ────┬────▶ Sprint 5                          │
│  (Identity)   │      (Campaign)   │      (Execution)                       │
│               │                   │                                        │
│               │                   │                                        │
│  Sprint 2 ────┘                   └────▶ Sprint 6                          │
│  (Store)                                 (Platform)                        │
│               │                   │                                        │
│               │                   │                                        │
│               └────▶ Sprint 4 ────┘                                        │
│                      (Fulfillment)                                         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

LEGEND:
────▶  Hard dependency (must complete before starting)
- - ▶  Soft dependency (can parallel with partial completion)
```

### Critical Path Items

| Sprint | Blocking Items | Risk Level |
|--------|----------------|------------|
| Sprint 1 | RBAC system, JWT auth | LOW |
| Sprint 2 | Store import, survey builder | MEDIUM |
| Sprint 3 | Campaign state machine | MEDIUM |
| Sprint 4 | Fulfillment integration | HIGH |
| Sprint 5 | Photo upload, mobile offline | HIGH |
| Sprint 6 | Webhook reliability | MEDIUM |

---

## Resource Allocation

### Team Structure (Recommended)

| Role | Count | Sprint Focus |
|------|-------|--------------|
| Tech Lead | 1 | All sprints, architecture |
| Backend Dev (Senior) | 2 | API, database, integrations |
| Frontend Dev (Senior) | 2 | Admin UI, Store Portal |
| Mobile Dev | 1 | Mobile app, offline sync |
| QA Engineer | 1 | Testing, automation |
| DevOps | 0.5 | CI/CD, infrastructure |

### Sprint Velocity Targets

| Sprint | Story Points | Confidence |
|--------|--------------|------------|
| Sprint 1 | 80 | 95% |
| Sprint 2 | 100 | 90% |
| Sprint 3 | 90 | 85% |
| Sprint 4 | 85 | 80% |
| Sprint 5 | 110 | 75% |
| Sprint 6 | 75 | 85% |

---

## Risk Mitigation

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Scope creep | HIGH | HIGH | Strict change control, MVP focus |
| Mobile offline sync complexity | MEDIUM | HIGH | Use proven sync library (e.g., WatermelonDB) |
| Photo storage costs | MEDIUM | MEDIUM | S3 lifecycle policies, compression |
| Third-party fulfillment API delays | MEDIUM | HIGH | Abstract integration layer, mock fallback |
| Performance at scale | LOW | HIGH | Early load testing, index optimization |

---

## Success Metrics (Beta)

| Metric | Target | Measurement |
|--------|--------|-------------|
| API Response Time (p95) | < 200ms | APM monitoring |
| Photo Upload Success Rate | > 99% | Error tracking |
| Mobile App Crash Rate | < 0.1% | Crashlytics |
| Survey Completion Rate | > 95% | Analytics |
| System Uptime | > 99.5% | Health checks |
| Beta User NPS | > 40 | In-app survey |

---

## Document References

| Document | Path | Description |
|----------|------|-------------|
| SOW Framework | [SOW_FRAMEWORK.md](../00_Index/SOW_FRAMEWORK.md) | Module build order |
| Screen Index | [00_SCREEN_INDEX.md](../06_Screen_Specs/00_SCREEN_INDEX.md) | All 23 screens |
| Foundation DDL | [00_foundation_ddl.sql](../06_Database_Model/01_Schema/00_foundation_ddl.sql) | Core schema |
| Brand Module DDL | [brand_module_ddl.sql](../06_Database_Model/01_Schema/brand_module_ddl.sql) | Brand tables |
| PSP Module DDL | [psp_module_ddl.sql](../06_Database_Model/01_Schema/psp_module_ddl.sql) | PSP tables |
| Store Module DDL | [store_module_ddl.sql](../06_Database_Model/01_Schema/store_module_ddl.sql) | Store tables |
| Missing Tables DDL | [12_missing_tables.sql](../06_Database_Model/01_Schema/12_missing_tables.sql) | Gap tables |

---

*Generated: 2025-12-30 | Version: 1.0 | Status: DRAFT*
