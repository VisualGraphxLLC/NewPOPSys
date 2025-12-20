# NewPOPSys Database Model

> **Status**: In Development
> **Version**: v1.0
> **Created**: 2025-12-19
> **Source**: SUPP-035 v1.1

---

## Overview

This directory contains the complete PostgreSQL database model for NewPOPSys v1, expanded from the SUPP-035 specification into production-ready artifacts for AutoCoder implementation.

### Architecture
- **DBMS**: PostgreSQL 15+
- **ORM**: Drizzle ORM (TypeScript)
- **Patterns**: Multi-tenant, soft-delete, audit trail
- **Scale Target**: 1000+ stores per brand, 100+ concurrent campaigns

---

## Directory Structure

```
06_Database_Model/
├── README.md                       # This file
├── 00_ORCHESTRATION_LOG.md         # Master coordination document (READ FIRST)
│
├── 01_Schema/                      # DDL Scripts (CREATE TABLE)
│   ├── 01_tenancy_identity.sql     # Tenants, brands, users, memberships
│   ├── 02_stores_grouping.sql      # Stores, regions, districts, territories
│   ├── 03_surveys_layouts.sql      # Survey builder, photo rules, layouts
│   ├── 04_campaigns_kits.sql       # Campaigns, kits, assignments
│   ├── 05_fulfillment.sql          # Orders, shipments, tracking
│   ├── 06_execution_verification.sql # Photo uploads, reviews, retakes
│   ├── 07_issues_reorders.sql      # Issue tracking, reorder handling
│   ├── 08_notifications.sql        # Notifications, preferences
│   ├── 09_webhooks_integration.sql # Webhook endpoints, deliveries
│   ├── 10_exports_jobs.sql         # Export job queue
│   └── 11_audit_observability.sql  # Audit events
│
├── 02_Relationships/               # Foreign Keys & ERDs
│   ├── 01_fk_tenancy_identity.sql
│   ├── 02_fk_stores_grouping.sql
│   ├── ... (FK scripts per module)
│   └── ERD_specification.md        # Mermaid diagrams
│
├── 03_Constraints/                 # Business Rules
│   ├── 01_check_campaigns.sql      # Campaign validation rules
│   ├── 02_check_assignments.sql    # Assignment status rules
│   ├── 07_triggers_timestamps.sql  # Auto-update triggers
│   ├── 08_triggers_soft_delete.sql # Soft delete enforcement
│   └── 09_functions_status_computation.sql # Derived status functions
│
├── 04_Indexes/                     # Performance Indexes
│   ├── 01_idx_lookup.sql           # Primary lookups
│   ├── 02_idx_hierarchy.sql        # Geographic navigation
│   ├── 03_idx_campaigns.sql        # Campaign queries
│   ├── 08_idx_partial.sql          # Partial/filtered indexes
│   ├── 09_views_reporting.sql      # Reporting views
│   └── performance_notes.md        # Index strategy
│
├── 05_Seed_Data/                   # Reference Data
│   ├── 01_enums.sql                # Enum types and values
│   ├── 02_system_users.sql         # System user accounts
│   ├── 03_default_tenant.sql       # Dev/test tenant
│   ├── 04_notification_events.sql  # Notification event types
│   └── seed_data_manifest.md       # Documentation
│
├── 06_Migrations/                  # Drizzle Migrations
│   ├── 0001_initial_schema.sql
│   ├── 0002_relationships.sql
│   ├── 0003_constraints.sql
│   ├── 0004_indexes.sql
│   ├── 0005_seed_data.sql
│   ├── 0006_functions_views.sql
│   └── migration_guide.md
│
└── 07_Validation/                  # Quality Assurance
    ├── 01_schema_completeness.md
    ├── 02_relationship_validation.md
    ├── 03_constraint_validation.md
    ├── 05_data_validation.sql
    ├── 06_business_rule_tests.sql
    └── final_validation_report.md
```

---

## Getting Started

### For Architects & Reviewers
1. Start with `00_ORCHESTRATION_LOG.md` to understand:
   - Gap analysis vs. SUPP-035
   - Missing tables and fields identified
   - Work package structure
   - Open decisions requiring input

2. Review `07_Validation/` checklists to understand acceptance criteria

### For Implementers
1. Read `00_ORCHESTRATION_LOG.md` Section 4 (Work Packages)
2. Follow the dependency chain (Packages 1→2→3→4→...)
3. Each package has clear inputs/outputs/dependencies

### For AutoCoder
1. All schema in `01_Schema/` follows standard patterns
2. All relationships in `02_Relationships/` are explicit
3. All business rules in `03_Constraints/` are declarative
4. Use `06_Migrations/` for sequential application

---

## Key Design Principles

### 1. Multi-Tenancy
- Root entity: `tenants` (PSP customers)
- Brands belong to tenants (1:N)
- All data scoped by tenant_id or brand_id
- Row-level security planned for Phase 2

### 2. Soft Delete
- All tables include `deleted_at TIMESTAMPTZ`
- No hard deletes in application code
- Indexes use `WHERE deleted_at IS NULL` for active records

### 3. Audit Trail
- All tables include: `created_at`, `updated_at`, `deleted_at`
- User actions tracked in `audit_events`
- State changes logged with before/after snapshots

### 4. Temporal Integrity
- All timestamps use `TIMESTAMPTZ` (timezone-aware)
- All dates use `DATE` type (not TIMESTAMP)
- `updated_at` auto-updated via trigger on all tables

### 5. UUID Primary Keys
- All tables use `id UUID PRIMARY KEY DEFAULT gen_random_uuid()`
- No integer auto-increment IDs
- Enables distributed ID generation

### 6. JSONB for Flexibility
- `settings_json`, `metadata_json` for extensibility
- `definition_json` for versioned schemas
- `selection_recipe_json` for complex criteria
- All JSONB columns default to `'{}'` (not NULL)

---

## Table Statistics

### By Module
| Module | Tables | Enums | Key Relationships |
|--------|--------|-------|-------------------|
| 1. Tenancy & Identity | 5 | 2 | User → Membership → Brand |
| 2. Stores & Grouping | 7 | 1 | Brand → Region → Store |
| 3. Surveys & Layouts | 6 | 0 | Store → Layout → Slot |
| 4. Campaigns & Kits | 5 | 4 | Campaign → Assignment → Item |
| 5. Fulfillment | 4 | 3 | Order → Shipment → Tracking |
| 6. Execution & Verification | 5 | 2 | Photo → Review → Retake |
| 7. Issues & Reorders | 3 | 2 | Issue → Reorder → Order |
| 8. Notifications | 2 | 1 | User → Notification |
| 9. Webhooks & Integration | 2 | 0 | Endpoint → Delivery |
| 10. Exports & Jobs | 1 | 2 | Job → S3 File |
| 11. Audit | 1 | 1 | Event → Actor |
| **Total** | **41** | **18** | **100+ FKs** |

### Derived Status (Computed, Not Stored)
- FulfillmentStatus (from shipment quantities)
- ReceiptStatus (from delivery quantities)
- ExecutionStatus (from installation progress)
- VerificationStatus (from photo reviews)
- StorePhase (rollup of all statuses)

---

## Common Patterns

### Standard Table Template
```sql
CREATE TABLE example_table (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  brand_id UUID NOT NULL REFERENCES brands(id),
  name TEXT NOT NULL,
  status example_status_enum NOT NULL DEFAULT 'DRAFT',
  settings_json JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_example_brand ON example_table(brand_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_example_status ON example_table(status) WHERE deleted_at IS NULL;
```

### Timestamp Auto-Update Trigger
```sql
CREATE TRIGGER trg_example_updated_at
  BEFORE UPDATE ON example_table
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

### Soft Delete Pattern
```sql
-- Don't do this:
DELETE FROM example_table WHERE id = '...';

-- Do this:
UPDATE example_table SET deleted_at = NOW() WHERE id = '...';

-- Query active records:
SELECT * FROM example_table WHERE deleted_at IS NULL;
```

---

## Relationships Overview

### Primary Chains

#### Campaign Execution
```
tenants → brands → campaigns → store_assignments → [orders, photos, issues]
```

#### Store Hierarchy
```
brands → regions → stores → layouts → slots
         ↓
     districts → territories
```

#### Photo Verification
```
assignments → photos → reviews → retakes
```

#### Issue Resolution
```
assignments → issues → reorders → orders
```

---

## Status Enums Reference

See `01_Schema/` files for complete definitions. Quick reference:

- **CampaignStatus**: DRAFT, SCHEDULED, PUBLISHED, COMPLETED, CANCELLED, ARCHIVED
- **StoreAssignmentStatus**: ASSIGNED, READY, IN_PROGRESS, SUBMITTED, REWORK_REQUIRED, COMPLETE, REOPENED, WAIVED
- **StoreOrderStatus**: GENERATED, ACKNOWLEDGED, IN_PRODUCTION, KITTING, READY_TO_SHIP, PARTIALLY_SHIPPED, SHIPPED, DELIVERED, CLOSED, CANCELLED
- **PhotoReviewStatus**: PENDING, APPROVED, REJECTED, SUPERSEDED
- **IssueRequestStatus**: OPEN, TRIAGED, AWAITING_APPROVAL, APPROVED, IN_FULFILLMENT, DENIED, RESOLVED

Full list in `05_Seed_Data/01_enums.sql`

---

## Dependencies & Prerequisites

### Required PostgreSQL Extensions
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";  -- For UUID generation
CREATE EXTENSION IF NOT EXISTS "pg_trgm";    -- For fuzzy text search
```

### Required Roles
```sql
CREATE ROLE newpopsys_app WITH LOGIN PASSWORD '...';
CREATE ROLE newpopsys_readonly;
CREATE ROLE newpopsys_admin;
```

See `06_Migrations/migration_guide.md` for complete setup.

---

## Validation & Testing

### Schema Validation
```sql
-- Run all validation scripts
\i 07_Validation/05_data_validation.sql
\i 07_Validation/06_business_rule_tests.sql
```

### Expected Results
- All tables exist with correct columns
- All foreign keys resolve
- All CHECK constraints enforce rules
- All indexes created successfully
- All seed data loaded
- All business rule tests pass

### Performance Benchmarks
- Campaign with 1000 stores assigned: < 5 seconds
- Photo upload + review update: < 100ms
- Store assignment status query: < 50ms
- Audit event insertion: < 10ms

---

## Support & References

### Primary Documents
- **SUPP-035**: Field-level data model (source of truth)
- **SUPP-002**: Core domain model and state machines
- **SUPP-013**: Stores, regions, groups
- **SUPP-014**: Survey builder, layouts, photo rules
- **SUPP-015**: Campaigns, kits, assignment
- **SUPP-016**: Orders, shipments, batches
- **SUPP-017**: Store execution, proof capture
- **SUPP-018**: Verification, photo review, retake
- **SUPP-019**: Issues, reorders

### Tools
- **Drizzle ORM**: TypeScript ORM for PostgreSQL
- **Drizzle Kit**: Migration tool
- **pgAdmin**: Database administration
- **DBeaver**: Database IDE
- **Mermaid**: ERD visualization

### Contact
- Database questions: See `00_ORCHESTRATION_LOG.md` Section 6 (Open Questions)
- Schema issues: File in project tracker
- Validation failures: See `07_Validation/` reports

---

## Change Log

| Date | Version | Change |
|------|---------|--------|
| 2025-12-19 | v1.0 | Initial README created |

---

*For detailed gap analysis, work packages, and timeline, see `00_ORCHESTRATION_LOG.md`*
