# Foundation Schema Analysis

> **Version**: 1.0
> **Created**: 2025-12-19
> **Schema File**: `01_Schema/00_foundation_ddl.sql`

---

## Overview

The Foundation Schema is the root database layer for NewPOPSys v1. It must be executed FIRST before any module-specific schemas, as it provides:

1. Core extensions (uuid-ossp, pgcrypto)
2. All system-wide enumerations
3. Tenant/brand multi-tenancy infrastructure
4. User authentication and RBAC membership model
5. Audit trail for compliance
6. Notification delivery system
7. Webhook event infrastructure
8. Export job tracking

---

## RBAC Model Implementation

### Role Hierarchy (8 Roles from SUPP-003)

The RBAC model uses a role-based membership system with three-tier hierarchy:

#### Platform Tier
- **PLATFORM_ADMIN**: Full system access + user impersonation (v1: always false, future-proofed)
- **PSP_ADMIN**: PSP tenant administration, brand onboarding, user management
- **PSP_OPS**: Production/fulfillment operations (order/shipment updates only)

#### Brand Tier
- **BRAND_ADMIN**: Full brand configuration, all campaigns, store management
- **CAMPAIGN_MANAGER**: Campaign-scoped access (must be assigned to campaigns)
- **REGIONAL_MANAGER**: Region-scoped oversight, exception queue management

#### Store Tier
- **STORE_MANAGER**: Full store privileges, approve replacement requests
- **STORE_OPERATOR**: Execute tasks only, view assigned campaigns

### Membership Model

The `memberships` table implements scope-based access control:

```sql
CREATE TABLE memberships (
  user_id UUID NOT NULL,
  tenant_id UUID NOT NULL,        -- PSP scope (always set)
  brand_id UUID,                   -- NULL for PSP staff
  role role_enum NOT NULL,
  region_scope_id UUID,            -- For REGIONAL_MANAGER
  store_scope_id UUID,             -- For STORE_OPERATOR
  ...
);
```

**Key Design Decisions:**

1. **Multi-membership**: Users can have multiple roles across brands/scopes
2. **PSP staff isolation**: `brand_id = NULL` for PSP-level roles
3. **Scope enforcement**: `region_scope_id` and `store_scope_id` limit access boundaries
4. **Explicit assignment**: Campaign Manager access requires explicit campaign assignment (enforced at application layer)

### Permission Enforcement Pattern

Authorization is enforced in application code using this model:

1. **Tenant isolation**: All queries scoped by `tenant_id` from JWT
2. **Brand filtering**: Brand users restricted to `brand_id` from membership
3. **Role checks**: Actions validated against role enum + scope fields
4. **Audit requirement**: All privileged actions emit `audit_events` records

---

## Multi-Tenancy Implementation

### Tenant Structure

```
tenants (PSP root)
  └── brands (customer brands)
      ├── campaigns
      ├── stores
      └── users (via memberships)
```

### Isolation Strategy

1. **Tenant root**: Every tenant is a PSP organization with isolated data
2. **Brand segmentation**: Brands cannot see other brands' data within same PSP
3. **RLS consideration**: v1 uses application-layer filtering; Row-Level Security can be added in v2
4. **Slug-based routing**: `tenants.slug` enables subdomain routing (e.g., `speedycps.newpopsys.app`)

### Foreign Key Cascade Rules

- **Tenant deletion**: RESTRICT (cannot delete tenant with active brands)
- **User deletion**: CASCADE memberships, SET NULL audit references
- **API key deletion**: CASCADE deliveries, SET NULL audit references

---

## Security Considerations

### API Key Management

```sql
CREATE TABLE api_keys (
  key_hash TEXT NOT NULL,        -- SHA256 of full key
  key_prefix TEXT NOT NULL,      -- First 8 chars for display
  secret TEXT NOT NULL,          -- Signing secret
  scopes TEXT[] DEFAULT '{}',    -- Granular permissions
  expires_at TIMESTAMPTZ,        -- Optional expiration
  last_used_at TIMESTAMPTZ       -- Usage tracking
);
```

**Security Features:**

1. **Hash storage**: Full keys never stored in database
2. **Prefix identification**: Only first 8 characters exposed for UI display
3. **Scope limitation**: Array of permitted operations (e.g., `['orders:write', 'shipments:create']`)
4. **Expiration**: Optional time-based key rotation
5. **Audit trail**: All API actions logged via `actor_api_key_id`

### Password Storage

- **Algorithm**: bcrypt (implemented in application layer)
- **Field**: `users.password_hash` stores bcrypt output
- **Reset flow**: Handled via email token (not in v1 schema)

### Webhook Security

```sql
CREATE TABLE webhook_endpoints (
  secret TEXT NOT NULL,          -- HMAC signing key
  failure_count INTEGER DEFAULT 0 -- Circuit breaker
);
```

**Implementation:**

1. **HMAC-SHA256 signing**: `X-VG-Signature` header validates payload authenticity
2. **Retry logic**: Exponential backoff up to 72 hours
3. **Circuit breaker**: Disable endpoint after consecutive failures
4. **Idempotency**: Inbound events require `Idempotency-Key` header (enforced at application layer)

---

## Audit Event Patterns

### Event Structure

```sql
CREATE TABLE audit_events (
  actor_type audit_actor_type_enum NOT NULL,  -- HUMAN, SYSTEM, INTEGRATION
  action TEXT NOT NULL,                       -- campaign.published, photo.rejected
  entity_type TEXT NOT NULL,                  -- Campaign, Photo
  entity_id UUID NOT NULL,                    -- Target record ID
  before_json JSONB,                          -- State before
  after_json JSONB,                           -- State after
  metadata_json JSONB                         -- Additional context
);
```

### Critical Audit Events

| Actor Type | Example Action | Purpose |
|------------|----------------|---------|
| HUMAN | `campaign.published` | Track who launched campaigns |
| HUMAN | `photo.rejected` | Review decisions + reason codes |
| HUMAN | `store.completion_waived` | Override approvals (requires reason) |
| SYSTEM | `order.generated` | Campaign publish triggers |
| INTEGRATION | `shipment.created` | PSP MIS integration |

### Audit Requirements (from SUPP-003)

1. **All privileged writes**: Campaign edits, photo reviews, waivers, force-completes
2. **Integration writes**: Include idempotency key in `metadata_json`
3. **Before/After snapshots**: State changes recorded for compliance
4. **Immutable**: No DELETE allowed on `audit_events` table

### Indexing Strategy

```sql
CREATE INDEX idx_audit_events_tenant_time ON audit_events(tenant_id, created_at DESC);
CREATE INDEX idx_audit_events_entity ON audit_events(entity_type, entity_id);
```

- **Tenant timeline**: Chronological audit log per PSP
- **Entity history**: All changes to specific record (e.g., all actions on campaign X)

---

## Notification System

### Two-Table Design

```sql
-- User preferences (opt-in/opt-out)
CREATE TABLE notification_preferences (
  user_id UUID,
  channel notification_channel_enum,  -- EMAIL, IN_APP, PUSH
  event_type TEXT,                    -- photo.rejected, shipment.delivered
  enabled BOOLEAN DEFAULT TRUE
);

-- Delivered messages
CREATE TABLE notifications (
  user_id UUID,
  channel notification_channel_enum,
  event_type TEXT,
  subject TEXT,
  body TEXT,
  action_url TEXT,  -- Deep link
  read_at TIMESTAMPTZ,
  sent_at TIMESTAMPTZ
);
```

### Event-Driven Pattern (from SUPP-004)

1. **System event occurs** (e.g., photo rejected)
2. **Application emits event** to notification service
3. **Check preferences**: Query `notification_preferences` for user + event
4. **Generate messages**: Create `notifications` records per enabled channel
5. **Send externally**: Email via SendGlide/SES, in-app via polling/WebSocket

### Key Events (from SUPP-004)

| Trigger | Recipients | Channels |
|---------|------------|----------|
| Shipment Delivered | Store Manager/Operator | EMAIL, IN_APP |
| Photo Rejected | Store Manager/Operator | EMAIL, IN_APP |
| Campaign Published | PSP Ops | EMAIL, IN_APP |
| Issue Reported | PSP Ops, Brand Admin | EMAIL, IN_APP |

---

## Webhook Infrastructure

### Outbound Event Contract (from SUPP-006)

```sql
CREATE TABLE webhook_deliveries (
  event_type TEXT,        -- campaign.published, order.generated
  payload_json JSONB,     -- Event-specific payload
  status_code INTEGER,    -- HTTP response
  attempt_count INTEGER,  -- Retry tracking
  next_retry_at TIMESTAMPTZ
);
```

### Event Topics

| Topic | Events | Key Consumers |
|-------|--------|---------------|
| `campaign` | `campaign.published` | PSP MIS, Brand systems |
| `order` | `order.generated`, `order.acknowledged` | PSP fulfillment, inventory |
| `shipment` | `shipment.created`, `shipment.delivered` | Tracking APIs, Brand dashboards |
| `issue` | `issue.created`, `issue.approved` | PSP support, reorder systems |
| `photo` | `photo.rejected` | Quality assurance tools |

### Retry Strategy

1. **Immediate attempt**: First delivery on event
2. **Exponential backoff**: 1m, 5m, 15m, 1h, 6h, 24h
3. **Max duration**: 72 hours total
4. **Circuit breaker**: Disable endpoint after 10 consecutive failures
5. **Manual retry**: PSP Admin can reset failure count

---

## Export Job Tracking

### Job Lifecycle

```sql
CREATE TABLE export_jobs (
  export_type TEXT,           -- campaign_summary, store_orders
  format export_format_enum,  -- CSV, XLSX, PDF, JSON, XML
  status export_job_status_enum,
  s3_key TEXT,                -- Output file location
  expires_at TIMESTAMPTZ      -- Auto-delete
);
```

### Export Packages (from SUPP-005)

| Package | Formats | Purpose |
|---------|---------|---------|
| Campaign Summary | CSV/XLSX, PDF, JSON/XML | Progress + exceptions + policy |
| Store Orders | CSV/XLSX, JSON/XML | Fulfillment-ready line items |
| Shipments & Tracking | CSV/XLSX, PDF, JSON/XML | Delivery confirmation |
| Execution & Proof | CSV/XLSX, PDF, JSON/XML | Item status + proof references |
| Issues & Reorders | CSV/XLSX, PDF, JSON/XML | Requests + approvals + evidence |

### Retention Strategy

1. **S3 lifecycle rules**: Auto-delete files after `expires_at`
2. **Job retention**: Keep metadata for 90 days
3. **Pre-purge exports**: Retention Export Bundle before data deletion

---

## Enum Completeness

All enums from SUPP-035 are defined as PostgreSQL ENUMs:

### Core Business Enums
- `role_enum` (8 roles)
- `store_status_enum` (4 states)
- `campaign_status_enum` (6 states)
- `verification_mode_enum` (2 modes)

### State Machine Enums
- `store_assignment_status_enum` (8 states)
- `store_order_status_enum` (10 states)
- `shipment_status_enum` (5 states)
- `photo_review_status_enum` (4 states)
- `issue_request_status_enum` (7 states)

### Support Enums
- `order_type_enum` (2 types)
- `issue_type_enum` (4 types)
- `rejection_reason_enum` (7 reasons)
- `notification_channel_enum` (3 channels)
- `export_format_enum` (5 formats)
- `audit_actor_type_enum` (3 types)

**Note**: Derived statuses (FulfillmentStatus, ReceiptStatus, ExecutionStatus, etc.) are computed at application layer, not stored as enums.

---

## Common Functions

### Updated At Trigger

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

Applied to all mutable tables via:

```sql
CREATE TRIGGER <table>_updated_at BEFORE UPDATE ON <table>
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

---

## Soft Delete Pattern

All tables include:

```sql
deleted_at TIMESTAMPTZ
```

**Implementation:**

1. **Logical deletes**: Set `deleted_at = NOW()` instead of physical DELETE
2. **Index filters**: `WHERE deleted_at IS NULL` on unique indexes
3. **Query filtering**: Application layer excludes soft-deleted records
4. **Audit trail**: Deletion events logged in `audit_events`

---

## Foreign Key Considerations

### Cross-Module References

The foundation schema includes forward references to module tables:

```sql
-- memberships table
region_scope_id UUID,  -- FK to regions (defined in stores module)
store_scope_id UUID,   -- FK to stores (defined in stores module)

-- export_jobs table
campaign_id UUID,      -- FK to campaigns (defined in campaigns module)
```

**Migration Strategy:**

1. **Phase 1**: Create foundation schema (this file)
2. **Phase 2**: Create module schemas (stores, campaigns, etc.)
3. **Phase 3**: Add foreign key constraints via ALTER TABLE in module migrations

---

## Index Strategy

### Performance Indexes

```sql
-- Tenant isolation
CREATE INDEX idx_brands_tenant ON brands(tenant_id);
CREATE INDEX idx_memberships_tenant ON memberships(tenant_id);

-- User lookups
CREATE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;
CREATE INDEX idx_memberships_user ON memberships(user_id);

-- Audit queries
CREATE INDEX idx_audit_events_tenant_time ON audit_events(tenant_id, created_at DESC);
CREATE INDEX idx_audit_events_entity ON audit_events(entity_type, entity_id);

-- Notification queries
CREATE INDEX idx_notifications_user ON notifications(user_id, created_at DESC);
CREATE INDEX idx_notifications_unread ON notifications(user_id) WHERE read_at IS NULL;

-- Export job tracking
CREATE INDEX idx_export_jobs_status ON export_jobs(status);
CREATE INDEX idx_export_jobs_expires ON export_jobs(expires_at) WHERE expires_at IS NOT NULL;
```

### Partial Indexes

Partial indexes optimize common filtered queries:

- Active users: `WHERE deleted_at IS NULL`
- Unread notifications: `WHERE read_at IS NULL`
- Pending exports: `WHERE expires_at IS NOT NULL`

---

## Migration Dependencies

### Execution Order

```
1. 00_foundation_ddl.sql (this file)
   ↓
2. 01_stores_ddl.sql (regions, stores, layouts)
   ↓
3. 02_campaigns_ddl.sql (campaigns, kits, assignments)
   ↓
4. 03_fulfillment_ddl.sql (orders, shipments)
   ↓
5. 04_execution_ddl.sql (proofs, reviews, issues)
```

### Foreign Key Additions (Phase 3)

After all module schemas exist, add cross-module constraints:

```sql
-- In stores module migration
ALTER TABLE memberships
  ADD CONSTRAINT fk_memberships_region
  FOREIGN KEY (region_scope_id) REFERENCES regions(id);

ALTER TABLE memberships
  ADD CONSTRAINT fk_memberships_store
  FOREIGN KEY (store_scope_id) REFERENCES stores(id);

-- In campaigns module migration
ALTER TABLE export_jobs
  ADD CONSTRAINT fk_export_jobs_campaign
  FOREIGN KEY (campaign_id) REFERENCES campaigns(id);
```

---

## Data Seeding Requirements

### Minimum Seed Data (v1 Pilot)

1. **Tenant**: Speedy CPS/Alpha Graphics PSP
2. **Brand**: Good2Go
3. **Users**: Platform Admin, PSP Admin, Brand Admin
4. **Memberships**: Assign roles to users
5. **Notification Preferences**: Default opt-ins for critical events

### Seed Script Pattern

```sql
-- Insert pilot tenant
INSERT INTO tenants (id, name, slug, subscription_tier)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'Speedy CPS / Alpha Graphics',
  'speedycps',
  'PILOT'
);

-- Insert pilot brand
INSERT INTO brands (id, tenant_id, name, code)
VALUES (
  '00000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000001',
  'Good2Go',
  'G2G'
);
```

---

## Future Enhancements (v2 Considerations)

### Row-Level Security (RLS)

Add PostgreSQL RLS policies for defense-in-depth:

```sql
ALTER TABLE brands ENABLE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON brands
  USING (tenant_id = current_setting('app.tenant_id')::uuid);
```

### Password Reset Tokens

Add table for secure password reset flow:

```sql
CREATE TABLE password_reset_tokens (
  user_id UUID REFERENCES users(id),
  token_hash TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  used_at TIMESTAMPTZ
);
```

### Email Verification

Add email confirmation workflow:

```sql
ALTER TABLE users ADD COLUMN email_verified BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN email_verification_token TEXT;
```

### OAuth/SSO Support

Extend users table for external auth providers:

```sql
ALTER TABLE users ADD COLUMN auth_provider TEXT;  -- 'local', 'google', 'okta'
ALTER TABLE users ADD COLUMN external_id TEXT;
```

---

## Testing Considerations

### Schema Validation Tests

1. **Enum integrity**: All enums from SUPP-035 present
2. **Foreign key cascades**: Proper ON DELETE behavior
3. **Index coverage**: All foreign keys indexed
4. **Trigger functions**: `updated_at` auto-updates

### Data Integrity Tests

1. **Unique constraints**: Tenant slug, user email, brand code
2. **Check constraints**: `subscription_tier` limited values
3. **Not null enforcement**: Required fields validated

### RBAC Tests

1. **Multi-membership**: User can have multiple roles
2. **Scope enforcement**: Regional/Store limits respected
3. **Audit coverage**: All privileged actions logged

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-19 | Initial foundation schema based on SUPP-001, SUPP-003, SUPP-004, SUPP-005, SUPP-006, SUPP-035 |

---

*End of Foundation Analysis*
