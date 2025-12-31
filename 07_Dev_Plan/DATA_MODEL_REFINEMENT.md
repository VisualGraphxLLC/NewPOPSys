# Data Model Refinement & Patterns Guide

> **Version**: 1.0
> **Created**: 2025-12-30
> **Purpose**: AI-actionable database patterns for NewPOPSys v1 implementation
> **Prerequisites**: 06_Database_Model/*.sql files

---

## Table of Contents

1. [Schema Overview](#1-schema-overview)
2. [Immutability Patterns](#2-immutability-patterns)
3. [Idempotency Patterns](#3-idempotency-patterns)
4. [Index Strategy Summary](#4-index-strategy-summary)
5. [Foreign Key Reference Matrix](#5-foreign-key-reference-matrix)
6. [Schema Consolidation Notes](#6-schema-consolidation-notes)
7. [ORM Implementation Guide](#7-orm-implementation-guide)
8. [API Design Patterns](#8-api-design-patterns)

---

## 1. Schema Overview

### 1.1 Module Structure

| Module | DDL File | Tables | Purpose |
|--------|----------|--------|---------|
| Foundation | `00_foundation_ddl.sql` | 10 | Tenancy, users, memberships, API keys, audit |
| Brand | `brand_module_ddl.sql` | 25 | Geographic hierarchy, stores, campaigns, kits |
| PSP | `psp_module_ddl.sql` | 12 | Orders, shipments, photo verification, issues |
| Store | `store_module_ddl.sql` | 30 | Complete execution schema (some overlap) |
| Missing | `12_missing_tables.sql` | 6 | Gap-fill tables (repeatable_sections, etc.) |
| Survey | `14_survey_enhancements.sql` | 2 | Survey definition enhancements |

### 1.2 Core Patterns Applied

| Pattern | Implementation | Tables Affected |
|---------|---------------|-----------------|
| UUID Primary Keys | `uuid_generate_v4()` | ALL (46+ tables) |
| Soft Delete | `deleted_at TIMESTAMPTZ` | 45 tables (except immutable) |
| Auto-Update Timestamp | `updated_at` trigger | 46 tables (except immutable) |
| Tenant Isolation | `tenant_id` column + FK | brands, memberships, api_keys, webhooks |
| Version Control | `version INTEGER`, `is_current BOOLEAN` | survey_versions, store_layouts |
| Status Enums | Type-safe enum columns | 6 state machines (18+ enums) |
| Audit Trail | `audit_events` table | All state transitions |
| JSONB Flexibility | Structured JSON columns | 15+ columns |

### 1.3 Enum Inventory

```sql
-- Identity & Tenancy
CREATE TYPE role_enum AS ENUM ('PSP_ADMIN', 'PSP_OPS', 'BRAND_ADMIN', 'REGIONAL_ADMIN', 'STORE_USER');
CREATE TYPE actor_type_enum AS ENUM ('HUMAN', 'SYSTEM', 'INTEGRATION');

-- Campaign Lifecycle
CREATE TYPE campaign_status AS ENUM ('DRAFT', 'SCHEDULED', 'PUBLISHED', 'COMPLETED', 'CANCELLED', 'ARCHIVED');
CREATE TYPE assignment_status AS ENUM ('ASSIGNED', 'READY', 'IN_PROGRESS', 'SUBMITTED', 'REWORK_REQUIRED', 'COMPLETE', 'REOPENED', 'WAIVED');
CREATE TYPE assignment_item_status AS ENUM ('PENDING', 'SHIPPED', 'RECEIVED', 'INSTALLED', 'VERIFIED', 'EXCEPTION');

-- Fulfillment
CREATE TYPE order_type AS ENUM ('INITIAL', 'REORDER', 'REPLACEMENT');
CREATE TYPE store_order_status AS ENUM ('GENERATED', 'ACKNOWLEDGED', 'IN_PRODUCTION', 'KITTING', 'READY_TO_SHIP', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CLOSED', 'CANCELLED');
CREATE TYPE shipment_status AS ENUM ('LABEL_CREATED', 'IN_TRANSIT', 'DELIVERED', 'EXCEPTION', 'RETURNED');

-- Verification
CREATE TYPE photo_review_status AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'SUPERSEDED');
CREATE TYPE rejection_reason AS ENUM ('BLURRY', 'WRONG_ANGLE', 'WRONG_ITEM', 'WRONG_LOCATION', 'NOT_INSTALLED', 'INSUFFICIENT_VISIBILITY', 'OTHER');
CREATE TYPE retake_status AS ENUM ('OPEN', 'COMPLETED', 'WAIVED');

-- Issues
CREATE TYPE issue_type AS ENUM ('MISSING', 'DAMAGED', 'DEFECTIVE', 'WRONG_ITEM', 'QUANTITY_SHORT', 'PACKAGING');
CREATE TYPE issue_request_status AS ENUM ('OPEN', 'TRIAGED', 'AWAITING_APPROVAL', 'APPROVED', 'IN_FULFILLMENT', 'DENIED', 'RESOLVED');

-- Verification Changes
CREATE TYPE store_change_status_enum AS ENUM ('PENDING', 'VERIFIED', 'REJECTED', 'AUTO_APPROVED');
CREATE TYPE completion_status_enum AS ENUM ('SUBMITTED', 'UNDER_REVIEW', 'ACCEPTED', 'REJECTED', 'WITHDRAWN');
```

---

## 2. Immutability Patterns

### 2.1 Immutable Tables (No Updates Allowed)

These tables represent historical records that must NEVER be modified after creation:

| Table | Purpose | Immutability Mechanism |
|-------|---------|----------------------|
| `audit_events` | Complete audit trail | No `updated_at`, no `deleted_at` |
| `response_edit_audit` | Survey edit history | No `updated_at`, no `deleted_at` |
| `survey_versions` (published) | Published survey snapshots | `status = 'PUBLISHED'` blocks updates |
| `photo_reviews` (final) | Final review decisions | Application logic: no re-review |

**Implementation Pattern for Immutable Tables**:

```sql
-- Example: response_edit_audit (fully immutable)
CREATE TABLE response_edit_audit (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_survey_response_id UUID NOT NULL,
  actor_user_id UUID NOT NULL,
  actor_role role_enum NOT NULL,
  reason TEXT NOT NULL,                -- REQUIRED: justification
  before_hash TEXT NOT NULL,           -- SHA256 for integrity
  after_hash TEXT NOT NULL,            -- Must differ from before_hash
  before_json JSONB NOT NULL,          -- Full snapshot
  after_json JSONB NOT NULL,           -- Full snapshot
  ip_address TEXT,
  user_agent TEXT,
  edited_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  -- NOTE: No updated_at, no deleted_at = immutable
);

-- Trigger to prevent updates
CREATE OR REPLACE FUNCTION prevent_update_immutable()
RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION 'Updates not allowed on immutable table %', TG_TABLE_NAME;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_update_response_edit_audit
BEFORE UPDATE ON response_edit_audit
FOR EACH ROW EXECUTE FUNCTION prevent_update_immutable();
```

### 2.2 Append-Only Tables (Inserts Only, Soft Deletes)

| Table | Purpose | Pattern |
|-------|---------|---------|
| `photo_uploads` | Photo submission history | New upload = new row (never overwrite) |
| `store_survey_responses` | Survey response history | New submission = new row |
| `shipments` | Shipment tracking | One shipment per tracking event |
| `notifications` | Notification delivery | Mark as read, never delete |

**Implementation Pattern**:

```typescript
// In Drizzle ORM / application layer
async function submitSurveyResponse(assignmentId: UUID, response: SurveyResponse) {
  // NEVER update existing response - always insert new
  const newResponse = await db.insert(storeSurveyResponses).values({
    id: uuid(),
    storeAssignmentId: assignmentId,
    surveyVersionId: response.surveyVersionId,
    responseJson: response.answers,
    submittedByUserId: getCurrentUser().id,
    submittedAt: new Date(),
    // If previous response exists, it remains for audit
  });

  // Emit audit event
  await emitAuditEvent('survey_response.submitted', {
    entityId: newResponse.id,
    entityType: 'StoreSurveyResponse',
  });

  return newResponse;
}
```

### 2.3 Version-Controlled Tables

| Table | Version Column | Current Flag | Pattern |
|-------|---------------|--------------|---------|
| `survey_versions` | `version_number` | `is_published` | Clone + increment for new version |
| `store_layouts` | `version` | `is_current` | Clone + set previous.is_current = false |

**Implementation Pattern**:

```typescript
async function publishSurveyVersion(templateId: UUID, definitionJson: JSONB) {
  return await db.transaction(async (tx) => {
    // Get current max version
    const maxVersion = await tx.select({ max: sql`MAX(version_number)` })
      .from(surveyVersions)
      .where(eq(surveyVersions.surveyTemplateId, templateId));

    const newVersion = (maxVersion?.max || 0) + 1;

    // Insert new version (old versions remain unchanged)
    const newSurvey = await tx.insert(surveyVersions).values({
      id: uuid(),
      surveyTemplateId: templateId,
      versionNumber: newVersion,
      definitionJson: definitionJson,
      status: 'PUBLISHED',
      publishedAt: new Date(),
      publishedByUserId: getCurrentUser().id,
    });

    return newSurvey;
  });
}
```

### 2.4 Hash-Protected Fields

For data integrity verification, certain fields use content hashes:

```sql
-- response_edit_audit uses before_hash/after_hash
-- Application must compute SHA256 of response_json

CREATE OR REPLACE FUNCTION compute_response_hash(response_json JSONB)
RETURNS TEXT AS $$
BEGIN
  RETURN encode(digest(response_json::text, 'sha256'), 'hex');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- CHECK constraint ensures hash changed
ALTER TABLE response_edit_audit
ADD CONSTRAINT chk_response_edit_audit_hash_different
CHECK (before_hash <> after_hash);
```

---

## 3. Idempotency Patterns

### 3.1 Idempotency Keys Table

For critical write operations, implement idempotency at the API layer:

```sql
-- Add to foundation schema
CREATE TABLE idempotency_keys (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  idempotency_key TEXT NOT NULL,           -- Client-provided key
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  user_id UUID REFERENCES users(id),       -- Nullable for API key auth
  api_key_id UUID REFERENCES api_keys(id), -- Nullable for user auth
  request_path TEXT NOT NULL,              -- e.g., '/api/v1/orders'
  request_hash TEXT NOT NULL,              -- SHA256 of request body
  response_status INTEGER,                 -- HTTP status code
  response_body JSONB,                     -- Cached response
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMPTZ NOT NULL DEFAULT NOW() + INTERVAL '24 hours',
  UNIQUE (tenant_id, idempotency_key)
);

CREATE INDEX idx_idempotency_keys_lookup ON idempotency_keys(tenant_id, idempotency_key) WHERE expires_at > NOW();
CREATE INDEX idx_idempotency_keys_cleanup ON idempotency_keys(expires_at);

-- Cleanup job (run daily)
DELETE FROM idempotency_keys WHERE expires_at < NOW();
```

### 3.2 API Implementation Pattern

```typescript
// Middleware for idempotent operations
async function idempotencyMiddleware(req: Request, res: Response, next: NextFunction) {
  const idempotencyKey = req.headers['idempotency-key'];

  if (!idempotencyKey) {
    // Non-idempotent request - proceed normally
    return next();
  }

  const tenantId = req.tenant.id;
  const requestHash = computeHash(req.body);

  // Check for existing key
  const existing = await db.select()
    .from(idempotencyKeys)
    .where(and(
      eq(idempotencyKeys.tenantId, tenantId),
      eq(idempotencyKeys.idempotencyKey, idempotencyKey),
      gt(idempotencyKeys.expiresAt, new Date())
    ))
    .first();

  if (existing) {
    // Verify request matches original
    if (existing.requestHash !== requestHash) {
      return res.status(422).json({
        error: 'Idempotency key reused with different request body'
      });
    }

    // Return cached response
    return res.status(existing.responseStatus).json(existing.responseBody);
  }

  // Store key before processing
  await db.insert(idempotencyKeys).values({
    tenantId,
    idempotencyKey,
    userId: req.user?.id,
    apiKeyId: req.apiKey?.id,
    requestPath: req.path,
    requestHash,
  });

  // Proceed and capture response
  const originalSend = res.send;
  res.send = function(body) {
    // Update with response
    db.update(idempotencyKeys)
      .set({
        responseStatus: res.statusCode,
        responseBody: typeof body === 'string' ? JSON.parse(body) : body,
      })
      .where(and(
        eq(idempotencyKeys.tenantId, tenantId),
        eq(idempotencyKeys.idempotencyKey, idempotencyKey)
      ))
      .execute();

    return originalSend.call(this, body);
  };

  next();
}
```

### 3.3 Natural Idempotency (Database-Level)

For operations with natural keys, use UNIQUE constraints:

```sql
-- store_assignments: One assignment per store per campaign
ALTER TABLE store_assignments
ADD CONSTRAINT uq_store_assignments_store_campaign
UNIQUE (store_id, campaign_id) WHERE deleted_at IS NULL;

-- store_group_memberships: One membership per store per group
ALTER TABLE store_group_memberships
ADD CONSTRAINT uq_store_group_memberships_store_group
UNIQUE (store_id, store_group_id) WHERE deleted_at IS NULL;

-- photo_links: One link per photo/item/slot combination
-- Already defined in 12_missing_tables.sql
UNIQUE (photo_upload_id, assignment_item_id, location_slot_id)
```

### 3.4 Upsert Patterns

For safe upsert operations, use ON CONFLICT:

```sql
-- Example: Store external ID alias (idempotent upsert)
INSERT INTO store_id_aliases (store_id, external_system, external_id, is_primary)
VALUES ($1, $2, $3, $4)
ON CONFLICT (store_id, external_system, external_id)
DO UPDATE SET
  is_primary = EXCLUDED.is_primary,
  updated_at = NOW()
WHERE store_id_aliases.deleted_at IS NULL;

-- Example: Notification preference (idempotent upsert)
INSERT INTO notification_preferences (user_id, event_type, channel, enabled)
VALUES ($1, $2, $3, $4)
ON CONFLICT (user_id, event_type, channel)
DO UPDATE SET
  enabled = EXCLUDED.enabled,
  updated_at = NOW();
```

### 3.5 External Reference Idempotency

PSP integration uses external references for idempotency:

```sql
-- store_orders has psp_order_ref for PSP-side idempotency
-- Unique per campaign to allow same ref across campaigns
CREATE UNIQUE INDEX idx_store_orders_psp_ref_unique
ON store_orders (campaign_id, psp_order_ref)
WHERE psp_order_ref IS NOT NULL AND deleted_at IS NULL;

-- campaigns has psp_campaign_ref
CREATE UNIQUE INDEX idx_campaigns_psp_ref_unique
ON campaigns (tenant_id, psp_campaign_ref)
WHERE psp_campaign_ref IS NOT NULL AND deleted_at IS NULL;
```

---

## 4. Index Strategy Summary

### 4.1 Index Categories (267 Total)

| Category | Count | Purpose |
|----------|-------|---------|
| Foreign Key Indexes | ~80 | Join performance |
| Status Indexes | ~60 | Queue and filter queries |
| Timestamp Indexes | ~45 | Time-based queries (DESC) |
| Composite Indexes | ~70 | Multi-column query patterns |
| GIN Indexes (JSONB) | ~20 | JSON field queries |
| Partial Indexes | ~52 | Soft-delete optimization |

### 4.2 Key Index Patterns

**Pattern 1: Soft Delete Optimization**
```sql
-- All indexes include WHERE deleted_at IS NULL
CREATE INDEX idx_stores_brand_active
ON stores (brand_id, status)
WHERE deleted_at IS NULL;
```

**Pattern 2: Status Queue Indexes**
```sql
-- Partial indexes for specific status values
CREATE INDEX idx_photo_uploads_pending_review
ON photo_uploads (store_assignment_id, created_at)
WHERE status = 'PENDING' AND deleted_at IS NULL;

CREATE INDEX idx_issue_requests_awaiting_approval
ON issue_requests (brand_id, priority DESC, created_at)
WHERE status = 'AWAITING_APPROVAL' AND deleted_at IS NULL;
```

**Pattern 3: GIN Indexes for JSONB**
```sql
-- Selection recipe queries
CREATE INDEX idx_campaigns_selection_recipe_gin
ON campaigns USING GIN (selection_recipe_json);

-- Audit event changes
CREATE INDEX idx_audit_events_changes_gin
ON audit_events USING GIN (changes);

-- Multiple tracking numbers
CREATE INDEX idx_shipments_tracking_gin
ON shipments USING GIN (tracking_numbers);
```

**Pattern 4: Composite Index Ordering**
```sql
-- Equality columns first, range columns second, sort columns last
CREATE INDEX idx_store_assignments_dashboard
ON store_assignments (campaign_id, status, submitted_at DESC)
WHERE deleted_at IS NULL;
```

### 4.3 Critical Query Indexes

| Query Pattern | Index | Tables |
|--------------|-------|--------|
| User login | `idx_users_email` | users |
| API authentication | `idx_api_keys_prefix` | api_keys |
| Campaign dashboard | `idx_store_assignments_campaign_status` | store_assignments |
| Photo review queue | `idx_photo_uploads_pending_review` | photo_uploads |
| Issue triage | `idx_issue_requests_priority_status_time` | issue_requests |
| Order fulfillment | `idx_store_orders_psp_ref` | store_orders |

---

## 5. Foreign Key Reference Matrix

### 5.1 Tenancy & Identity

```
tenants (root)
├── brands (tenant_id) [CASCADE]
├── memberships (tenant_id) [CASCADE]
├── api_keys (tenant_id) [CASCADE]
├── webhook_endpoints (tenant_id) [CASCADE]
└── audit_events (tenant_id) [RESTRICT]

users (root)
├── memberships (user_id) [CASCADE]
├── notifications (user_id) [CASCADE]
├── notification_preferences (user_id) [CASCADE]
├── campaigns.published_by_user_id [SET NULL]
├── store_assignments.submitted_by_user_id [SET NULL]
├── photo_uploads.uploaded_by_user_id [RESTRICT]
├── photo_reviews.reviewer_user_id [SET NULL]
└── audit_events.actor_user_id [SET NULL]
```

### 5.2 Geographic Hierarchy

```
brands
├── regions (brand_id) [RESTRICT]
├── districts (brand_id) [RESTRICT]
├── territories (brand_id) [RESTRICT]
├── stores (brand_id) [RESTRICT]
├── store_groups (brand_id) [CASCADE]
├── survey_templates (brand_id) [CASCADE]
├── photo_rules (brand_id) [CASCADE]
├── kit_definitions (brand_id) [CASCADE]
└── campaigns (brand_id) [RESTRICT]

regions
├── regions.parent_region_id (self-ref) [RESTRICT]
├── districts (region_id) [RESTRICT]
├── territories (region_id) [RESTRICT]
├── stores (region_id) [RESTRICT]
└── memberships.region_scope_id [SET NULL]

districts
├── territories (district_id) [SET NULL]
└── stores (district_id) [SET NULL]

territories
└── stores (territory_id) [SET NULL]
```

### 5.3 Campaign & Execution

```
campaigns
├── store_assignments (campaign_id) [RESTRICT]
├── store_orders (campaign_id) [RESTRICT]
├── photo_links (campaign_id) [CASCADE]
└── store_change_verifications (campaign_id) [SET NULL]

store_assignments
├── assignment_items (store_assignment_id) [CASCADE]
├── store_orders (store_assignment_id) [CASCADE]
├── receive_verifications (store_assignment_id) [CASCADE]
├── store_survey_responses (store_assignment_id) [CASCADE]
├── photo_uploads (store_assignment_id) [CASCADE]
├── retake_requests (store_assignment_id) [CASCADE]
├── issue_requests (store_assignment_id) [CASCADE]
├── photo_links (store_assignment_id) [CASCADE]
└── completion_submissions (store_assignment_id) [CASCADE]

assignment_items
├── photo_uploads (assignment_item_id) [SET NULL]
└── photo_links (assignment_item_id) [SET NULL]
```

### 5.4 Fulfillment Chain

```
store_orders
├── order_lines (store_order_id) [CASCADE]
├── shipments (store_order_id) [CASCADE]
└── reorders.store_order_id [CASCADE]

shipments
└── shipment_lines (shipment_id) [CASCADE]

issue_requests
├── issue_lines (issue_request_id) [CASCADE]
└── reorders (issue_request_id) [CASCADE]
```

### 5.5 ON DELETE Behavior Summary

| Behavior | Use Case | Example |
|----------|----------|---------|
| CASCADE | Child has no meaning without parent | order_lines → store_order |
| RESTRICT | Prevent deletion if children exist | campaigns → brand |
| SET NULL | Preserve child, lose parent ref | published_by_user_id → user |

---

## 6. Schema Consolidation Notes

### 6.1 Table Duplication Across Modules

Some tables appear in multiple DDL files with slightly different definitions. The canonical source for each:

| Table | Canonical Source | Also Appears In | Resolution |
|-------|-----------------|-----------------|------------|
| `stores` | `brand_module_ddl.sql` | `store_module_ddl.sql` | Use brand_module version |
| `store_orders` | `psp_module_ddl.sql` | `brand_module_ddl.sql` | Use psp_module (has PSP-specific fields) |
| `photo_uploads` | `psp_module_ddl.sql` | `store_module_ddl.sql` | Use psp_module (has review workflow) |
| `issue_requests` | `psp_module_ddl.sql` | `brand_module_ddl.sql` | Use psp_module (has triage fields) |

### 6.2 Enum Duplication

Enums are defined in multiple files. Consolidate in `00_foundation_ddl.sql`:

```sql
-- Add to foundation DDL (after extensions, before tables)
-- All enums should be defined ONCE in foundation

-- Identity
CREATE TYPE role_enum AS ENUM (...);
CREATE TYPE actor_type_enum AS ENUM (...);

-- All other enums...
```

### 6.3 Migration Order

Execute DDL files in this order to avoid dependency issues:

```bash
# 1. Foundation (extensions, enums, core tables)
psql -f 00_foundation_ddl.sql

# 2. Brand module (hierarchy, stores, campaigns)
psql -f brand_module_ddl.sql

# 3. PSP module (orders, fulfillment, verification)
psql -f psp_module_ddl.sql

# 4. Store module (views, additional indexes)
psql -f store_module_ddl.sql

# 5. Gap-fill tables
psql -f 12_missing_tables.sql
psql -f 13_missing_fields.sql
psql -f 14_survey_enhancements.sql

# 6. Foreign keys (after all tables exist)
psql -f 02_Relationships/*.sql

# 7. Constraints
psql -f 03_Constraints/*.sql

# 8. Indexes
psql -f 04_Indexes/*.sql

# 9. Seed data
psql -f 05_Seed_Data/*.sql
```

---

## 7. ORM Implementation Guide

### 7.1 Drizzle Schema Structure

```typescript
// src/db/schema/index.ts
export * from './foundation';   // tenants, users, memberships, api_keys
export * from './geography';    // regions, districts, territories
export * from './stores';       // stores, store_groups, store_layouts
export * from './surveys';      // survey_templates, survey_versions, photo_rules
export * from './campaigns';    // campaigns, kit_definitions, store_assignments
export * from './fulfillment';  // store_orders, shipments, order_lines
export * from './execution';    // photo_uploads, photo_reviews, retake_requests
export * from './issues';       // issue_requests, issue_lines, reorders
export * from './audit';        // audit_events, response_edit_audit
```

### 7.2 Common Patterns

**Soft Delete Mixin**:
```typescript
// src/db/schema/mixins.ts
import { timestamp, uuid } from 'drizzle-orm/pg-core';

export const timestamps = {
  createdAt: timestamp('created_at').notNull().defaultNow(),
  updatedAt: timestamp('updated_at').notNull().defaultNow(),
  deletedAt: timestamp('deleted_at'),
};

export const primaryKey = {
  id: uuid('id').primaryKey().defaultRandom(),
};

// Usage in table definition
export const campaigns = pgTable('campaigns', {
  ...primaryKey,
  ...timestamps,
  brandId: uuid('brand_id').notNull().references(() => brands.id),
  // ... other columns
});
```

**Enum Definition**:
```typescript
// src/db/schema/enums.ts
import { pgEnum } from 'drizzle-orm/pg-core';

export const roleEnum = pgEnum('role_enum', [
  'PSP_ADMIN', 'PSP_OPS', 'BRAND_ADMIN', 'REGIONAL_ADMIN', 'STORE_USER'
]);

export const campaignStatusEnum = pgEnum('campaign_status', [
  'DRAFT', 'SCHEDULED', 'PUBLISHED', 'COMPLETED', 'CANCELLED', 'ARCHIVED'
]);
```

### 7.3 Query Patterns

**Active Records (Soft Delete)**:
```typescript
// Always filter out soft-deleted records
const activeStores = await db.select()
  .from(stores)
  .where(and(
    eq(stores.brandId, brandId),
    isNull(stores.deletedAt)
  ));
```

**Status Queue Queries**:
```typescript
// Get pending photo reviews
const pendingReviews = await db.select()
  .from(photoUploads)
  .where(and(
    eq(photoUploads.status, 'PENDING'),
    isNull(photoUploads.deletedAt)
  ))
  .orderBy(asc(photoUploads.createdAt))
  .limit(50);
```

---

## 8. API Design Patterns

### 8.1 Required Headers

| Header | Required For | Purpose |
|--------|-------------|---------|
| `Authorization` | All authenticated requests | Bearer token or API key |
| `X-Tenant-ID` | Multi-tenant operations | Tenant isolation |
| `Idempotency-Key` | POST/PUT/DELETE | Prevent duplicate operations |
| `X-Request-ID` | All requests | Distributed tracing |

### 8.2 Audit Event Emission

Every state-changing operation MUST emit an audit event:

```typescript
// src/services/audit.ts
interface AuditEventData {
  action: string;
  entityType: string;
  entityId: string;
  before?: Record<string, unknown>;
  after?: Record<string, unknown>;
  metadata?: Record<string, unknown>;
}

async function emitAuditEvent(data: AuditEventData, context: RequestContext) {
  await db.insert(auditEvents).values({
    tenantId: context.tenantId,
    brandId: context.brandId,
    action: data.action,
    entityType: data.entityType,
    entityId: data.entityId,
    actorType: context.isApiKey ? 'INTEGRATION' : 'HUMAN',
    actorUserId: context.userId,
    actorApiKeyId: context.apiKeyId,
    beforeJson: data.before,
    afterJson: data.after,
    metadataJson: data.metadata,
    ipAddress: context.ipAddress,
    userAgent: context.userAgent,
  });
}
```

### 8.3 Standard Audit Actions

| Action Pattern | Example | Trigger |
|---------------|---------|---------|
| `{entity}.created` | `campaign.created` | Insert |
| `{entity}.updated` | `store.updated` | Update |
| `{entity}.deleted` | `assignment.deleted` | Soft delete |
| `{entity}.{status}` | `campaign.published` | Status transition |
| `{entity}.{action}` | `photo.approved` | Specific action |

---

## Summary

This document provides the essential patterns for implementing NewPOPSys v1:

1. **Immutability**: Audit tables and survey responses are append-only with hash verification
2. **Idempotency**: API-level idempotency keys + natural database constraints
3. **Indexes**: 267 optimized indexes including partial indexes for soft-delete
4. **Foreign Keys**: Complete reference matrix with appropriate ON DELETE behaviors
5. **Schema**: Consolidation notes for avoiding table duplication
6. **ORM**: Drizzle patterns with soft-delete mixins
7. **API**: Standard headers and audit event patterns

Use this document alongside the validation report and DDL files for implementation.

---

*End of Data Model Refinement Guide*
