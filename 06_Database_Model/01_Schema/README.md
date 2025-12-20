# Schema DDL Scripts

This directory contains CREATE TABLE statements for all database tables, organized by functional module.

## Files Structure

| File | Module | Tables | Status |
|------|--------|--------|--------|
| `01_tenancy_identity.sql` | Tenancy & Identity | tenants, brands, users, memberships, api_keys | Pending |
| `02_stores_grouping.sql` | Stores & Grouping | regions, districts, territories, stores, store_groups, store_group_memberships, store_layouts, location_slots | Pending |
| `03_surveys_layouts.sql` | Surveys & Photo Rules | survey_templates, survey_versions, photo_rules, repeatable_sections | Pending |
| `04_campaigns_kits.sql` | Campaigns & Kits | campaigns, kit_definitions, kit_items, store_assignments, assignment_items | Pending |
| `05_fulfillment.sql` | Fulfillment | store_orders, order_lines, shipments, shipment_lines | Pending |
| `06_execution_verification.sql` | Execution & Verification | receive_verifications, store_survey_responses, photo_uploads, photo_reviews, retake_requests, response_edit_audit | Pending |
| `07_issues_reorders.sql` | Issues & Reorders | issue_requests, issue_lines, reorders | Pending |
| `08_notifications.sql` | Notifications | notification_preferences, notifications | Pending |
| `09_webhooks_integration.sql` | Webhooks & Integration | webhook_endpoints, webhook_deliveries | Pending |
| `10_exports_jobs.sql` | Exports & Jobs | export_jobs | Pending |
| `11_audit_observability.sql` | Audit & Observability | audit_events | Pending |

## Guidelines for Schema Creation

### Standard Table Template

```sql
-- Module: [MODULE_NAME]
-- Table: [table_name]
-- Purpose: [Brief description]

CREATE TABLE [table_name] (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign keys (if applicable)
  brand_id UUID NOT NULL,
  parent_id UUID,

  -- Business fields
  name TEXT NOT NULL,
  status [enum_type] NOT NULL DEFAULT '[DEFAULT_VALUE]',

  -- Extensibility
  settings_json JSONB NOT NULL DEFAULT '{}',
  metadata_json JSONB NOT NULL DEFAULT '{}',

  -- Standard audit fields (ALL TABLES)
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Constraints (define here, FKs in separate file)
  CONSTRAINT [table_name]_unique_[field] UNIQUE ([field1], [field2])
);

-- Add comments for documentation
COMMENT ON TABLE [table_name] IS '[Detailed purpose and usage]';
COMMENT ON COLUMN [table_name].[field] IS '[Field description]';
```

### Enum Type Definition

```sql
-- Define enum types before tables that use them
CREATE TYPE [enum_name] AS ENUM (
  'VALUE_1',
  'VALUE_2',
  'VALUE_3'
);

COMMENT ON TYPE [enum_name] IS '[Enum purpose and valid transitions]';
```

### Common Field Patterns

#### All Tables Must Include
```sql
id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
deleted_at TIMESTAMPTZ
```

#### Multi-Tenant Scoped Tables
```sql
tenant_id UUID NOT NULL  -- For PSP-level data
brand_id UUID NOT NULL   -- For brand-level data
```

#### Status Tracking
```sql
status [status_enum] NOT NULL DEFAULT '[INITIAL_STATE]',
status_changed_at TIMESTAMPTZ,
status_changed_by_user_id UUID
```

#### User Audit Trail
```sql
created_by_user_id UUID,
updated_by_user_id UUID
```

#### Temporal Validity
```sql
valid_from DATE NOT NULL,
valid_to DATE,
is_current BOOLEAN NOT NULL DEFAULT TRUE
```

### Data Types Standards

| Use Case | Type | Example |
|----------|------|---------|
| Primary Key | UUID | `id UUID PRIMARY KEY DEFAULT gen_random_uuid()` |
| Foreign Key | UUID | `brand_id UUID NOT NULL` |
| Short Text | TEXT | `name TEXT NOT NULL` |
| Long Text | TEXT | `description TEXT` |
| Constrained Text | TEXT + CHECK | `email TEXT NOT NULL CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z\|a-z]{2,}$')` |
| Enumeration | ENUM | `status campaign_status NOT NULL` |
| Boolean | BOOLEAN | `is_active BOOLEAN NOT NULL DEFAULT TRUE` |
| Integer | INTEGER | `quantity INTEGER NOT NULL CHECK (quantity >= 0)` |
| Decimal | NUMERIC | `amount NUMERIC(10,2)` |
| Date | DATE | `start_date DATE NOT NULL` |
| Timestamp | TIMESTAMPTZ | `created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()` |
| JSON | JSONB | `settings_json JSONB NOT NULL DEFAULT '{}'` |
| Array | TEXT[] | `scopes TEXT[] NOT NULL DEFAULT '{}'` |
| Binary | BYTEA | `file_data BYTEA` (avoid; use S3 instead) |

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Table | Plural snake_case | `store_assignments` |
| Column | Singular snake_case | `store_id` |
| Enum Type | Singular snake_case | `campaign_status` |
| Enum Value | SCREAMING_SNAKE_CASE | `IN_PROGRESS` |
| FK Column | `[table]_id` | `brand_id`, `parent_region_id` |
| Junction Table | `[table1]_[table2]s` | `store_group_memberships` |
| Constraint | `[table]_[type]_[fields]` | `campaigns_check_dates` |
| Index | `idx_[table]_[fields]` | `idx_campaigns_brand_status` |

### Anti-Patterns to Avoid

❌ **Don't**: Use `TIMESTAMP` (no timezone)
✅ **Do**: Use `TIMESTAMPTZ`

❌ **Don't**: Use `SERIAL` or `BIGSERIAL` for IDs
✅ **Do**: Use `UUID`

❌ **Don't**: Use `JSON` type
✅ **Do**: Use `JSONB` (better performance, indexable)

❌ **Don't**: Hard delete with `DELETE FROM`
✅ **Do**: Soft delete with `UPDATE ... SET deleted_at = NOW()`

❌ **Don't**: Store files in database
✅ **Do**: Store S3 keys/URLs

❌ **Don't**: Use `NULL` for JSONB columns
✅ **Do**: Default to `'{}'` for objects, `'[]'` for arrays

❌ **Don't**: Mix camelCase in database
✅ **Do**: Use snake_case everywhere

## Checklist for Each File

Before marking a schema file complete:

- [ ] All tables from SUPP-035 for this module are defined
- [ ] All missing tables from orchestration log are added
- [ ] All missing fields from orchestration log are added
- [ ] All enum types defined before use
- [ ] All common fields (id, created_at, updated_at, deleted_at) present
- [ ] All TIMESTAMPTZ (not TIMESTAMP)
- [ ] All UUID primary keys
- [ ] All JSONB (not JSON) with defaults
- [ ] All table and column comments added
- [ ] All UNIQUE constraints defined (FK constraints go in 02_Relationships/)
- [ ] All CHECK constraints defined (complex ones can go in 03_Constraints/)
- [ ] File is valid PostgreSQL SQL (can be executed standalone)

## Order of Execution

These files should be executed in order (1-11) due to enum dependencies, but foreign keys are added later in `02_Relationships/`.

---

**Next Steps**: Create each SQL file following the template above. Reference SUPP-035 for table definitions.
