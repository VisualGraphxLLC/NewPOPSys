# Seed Data Manifest - NewPOPSys v1

> **Version**: v1.0
> **Created**: 2025-12-19
> **Purpose**: Documentation of all seed data files, their contents, and usage guidelines

---

## Overview

This directory contains seed data files for reference data and initial system records required for the NewPOPSys database to function properly. Seed data should be loaded after the schema DDL is applied and before the application is started.

### Seed Data Principles

1. **Idempotency**: All seed data uses `ON CONFLICT DO NOTHING` to allow safe re-running
2. **Fixed UUIDs**: System records use deterministic UUIDs for easy reference (e.g., `00000000-0000-0000-0000-000000000001`)
3. **Environment Awareness**: Development seed data is clearly marked and should not be used in production
4. **Documentation**: Each seed file includes extensive comments explaining purpose and usage

---

## Seed Data Files

### 1. 01_enums.sql - Enum Type Reference

**Purpose**: Documents all PostgreSQL enum types defined in the foundation DDL.

**Contents**:
- Documentation of 18 enum types
- Value definitions and meanings for each enum
- Usage notes and business rules
- Cross-references to SUPP specifications

**Enum Types Documented**:
1. `role_enum` - RBAC roles (8 roles)
2. `store_status_enum` - Store operational status
3. `campaign_status_enum` - Campaign lifecycle status
4. `verification_mode_enum` - Photo review workflow modes
5. `store_assignment_status_enum` - Store assignment execution status
6. `store_order_status_enum` - Order fulfillment status
7. `order_type_enum` - Order type classification
8. `shipment_status_enum` - Shipment tracking status
9. `photo_review_status_enum` - Photo approval status
10. `issue_type_enum` - Issue request classification
11. `issue_request_status_enum` - Issue workflow status
12. `rejection_reason_enum` - Photo rejection reasons
13. `audit_actor_type_enum` - Audit event actor types
14. `notification_channel_enum` - Notification delivery channels
15. `export_format_enum` - Export file formats
16. `export_job_status_enum` - Export job status
17. `assignment_item_status_enum` - Assignment item lifecycle status
18. `slot_verification_status_enum` - Location slot verification status

**Note**: The enum types themselves are created in `00_foundation_ddl.sql` via `CREATE TYPE` statements. This file is reference documentation only.

**Dependencies**: `00_foundation_ddl.sql`

**Load Order**: After schema DDL, informational only

---

### 2. 02_system_users.sql - System User Account

**Purpose**: Creates a special system user account for automated actions.

**Contents**:
- System user with fixed UUID: `00000000-0000-0000-0000-000000000001`
- Email: `system@newpopsys.internal`
- Invalid password hash (cannot login)
- Usage documentation for audit trails

**Use Cases**:
- Automated campaign status transitions
- System-generated orders
- Automated photo review workflows
- Background job operations
- Data cleanup/archival processes

**Key Attributes**:
- **ID**: `00000000-0000-0000-0000-000000000001`
- **Email**: `system@newpopsys.internal`
- **Full Name**: `System`
- **Cannot Login**: Password hash is invalid
- **No Memberships**: Not assigned to any tenant/brand
- **Cannot Be Deleted**: Protected by application logic

**Usage in Audit Events**:
```sql
INSERT INTO audit_events (
  tenant_id,
  brand_id,
  actor_type,
  actor_user_id,
  action,
  entity_type,
  entity_id,
  created_at
) VALUES (
  '...',
  '...',
  'SYSTEM',
  '00000000-0000-0000-0000-000000000001'::UUID,
  'campaign.auto_completed',
  'Campaign',
  '...',
  NOW()
);
```

**Dependencies**: `00_foundation_ddl.sql` (users table)

**Load Order**: 1st (required for other seed data that references system user)

---

### 3. 03_default_tenant.sql - Development Tenant & Brand

**Purpose**: Creates default tenant and brand for development, testing, and initial setup.

**Contents**:
- Default tenant with fixed UUID: `00000000-0000-0000-0000-000000000100`
- Default brand with fixed UUID: `00000000-0000-0000-0000-000000000200`
- Development-appropriate settings and configuration

**Default Tenant Attributes**:
- **ID**: `00000000-0000-0000-0000-000000000100`
- **Name**: `Development Tenant`
- **Slug**: `dev-tenant`
- **Tier**: `PILOT`
- **Settings**: Development-friendly feature flags and limits

**Default Brand Attributes**:
- **ID**: `00000000-0000-0000-0000-000000000200`
- **Tenant ID**: `00000000-0000-0000-0000-000000000100` (dev-tenant)
- **Name**: `Development Brand`
- **Code**: `DEV`
- **Settings**: Default theme, campaign settings, photo rules

**Use Cases**:
- Local development environment setup
- Integration testing
- Demo/sandbox environments
- Initial system bootstrapping

**NOT For**:
- Production environments
- Customer-facing demos (create dedicated tenant/brand)
- Performance testing (use realistic data)

**Settings Included**:
- Feature flags (webhook integration, export API, etc.)
- Resource limits (max brands, users, campaigns)
- Theme configuration (colors, branding)
- Campaign defaults (verification mode, auto-publish)
- Photo rule defaults (file size, formats, resolution)
- Contact information

**Dependencies**: `00_foundation_ddl.sql` (tenants, brands tables)

**Load Order**: 2nd (required for photo rules and other brand-scoped seed data)

---

### 4. 04_notification_events.sql - Notification Event Types

**Purpose**: Documents standard notification event types and default channel preferences.

**Contents**:
- Reference documentation for 30+ notification event types
- Default channel preferences (EMAIL, IN_APP, PUSH)
- Priority levels for each event type
- Sample code for creating notifications and preferences
- Helper function for initializing user preferences

**Event Type Categories**:

1. **Campaign Events** (5 events)
   - `campaign.published` - Campaign published and live
   - `campaign.scheduled` - Campaign scheduled for future
   - `campaign.completed` - Campaign execution ended
   - `campaign.cancelled` - Campaign cancelled

2. **Store Assignment Events** (6 events)
   - `assignment.created` - Store assigned to campaign
   - `assignment.ready` - Store ready to execute
   - `assignment.submitted` - Store submitted for review
   - `assignment.complete` - Store execution approved
   - `assignment.rework_required` - Store must fix issues
   - `assignment.reopened` - Assignment reopened for corrections

3. **Order & Fulfillment Events** (4 events)
   - `order.generated` - Order created
   - `order.acknowledged` - PSP acknowledged order
   - `order.shipped` - Order shipped
   - `order.delivered` - Order delivered

4. **Shipment Events** (3 events)
   - `shipment.in_transit` - Shipment in carrier network
   - `shipment.delivered` - Shipment delivered
   - `shipment.exception` - Delivery exception

5. **Photo & Verification Events** (4 events)
   - `photo.uploaded` - Photo uploaded
   - `photo.approved` - Photo approved
   - `photo.rejected` - Photo rejected, retake required
   - `retake.requested` - Retake request created

6. **Issue & Reorder Events** (6 events)
   - `issue.submitted` - Issue request submitted
   - `issue.triaged` - Issue reviewed and categorized
   - `issue.approved` - Issue approved for reorder
   - `issue.denied` - Issue denied
   - `issue.resolved` - Issue fully resolved
   - `reorder.created` - Reorder generated

7. **Export Events** (3 events)
   - `export.completed` - Export job completed
   - `export.failed` - Export job failed
   - `export.expired` - Export file expired

8. **Webhook Events** (1 event)
   - `webhook.delivery_failed` - Webhook delivery failed

**Default Channel Preferences**:
- **High Priority**: EMAIL + IN_APP (campaign.published, photo.rejected, issue.submitted)
- **Medium Priority**: IN_APP only (assignment.complete, photo.approved)
- **Low Priority**: IN_APP only (order.acknowledged)

**Helper Function Included**:
```sql
initialize_default_notification_preferences(p_user_id UUID)
```
This function should be called when a new user is created to set up their default notification preferences.

**Dependencies**: `00_foundation_ddl.sql` (notification_preferences, notifications tables)

**Load Order**: 3rd (informational, can be loaded any time after schema)

---

### 5. 05_photo_rules_defaults.sql - Default Photo Requirements

**Purpose**: Creates baseline photo requirement templates for common scenarios.

**Contents**:
- 6 default photo rule templates
- Detailed requirements in JSONB format
- Usage examples for kit definitions
- Validation queries

**Default Photo Rules**:

1. **Standard Proof** (`00000000-0000-0000-0000-000000000301`)
   - Purpose: Standard proof-of-execution photo
   - Angle: Frontal, 3-8 feet distance
   - Use Case: Basic campaign completion verification
   - Requirements: Clear frontal view, good lighting, materials visible

2. **Detail Shot** (`00000000-0000-0000-0000-000000000302`)
   - Purpose: Close-up detail photo
   - Angle: Close-up, 1-3 feet distance
   - Use Case: Quality verification, brand compliance
   - Requirements: Sharp focus, even lighting, detail fills frame

3. **Location Context** (`00000000-0000-0000-0000-000000000303`)
   - Purpose: Wide-angle context photo
   - Angle: Wide angle, 8-15 feet distance
   - Use Case: Store layout verification, placement context
   - Requirements: Materials plus surrounding area visible

4. **Damage Documentation** (`00000000-0000-0000-0000-000000000304`)
   - Purpose: Damage evidence photo
   - Angle: Focused, 1-5 feet distance
   - Use Case: Issue request evidence, damage claims
   - Requirements: Damage clearly visible, item identifiable

5. **Packaging Receipt** (`00000000-0000-0000-0000-000000000305`)
   - Purpose: Package receipt photo
   - Angle: Frontal, 2-6 feet distance
   - Use Case: Receipt verification, packaging condition
   - Requirements: Shipping label visible, tracking number readable

6. **Installation Progress** (`00000000-0000-0000-0000-000000000306`)
   - Purpose: In-progress documentation
   - Angle: Frontal, 3-10 feet distance
   - Use Case: Progress tracking, step-by-step documentation
   - Requirements: Current state and work area visible

**Requirements Structure** (JSONB format):
```json
{
  "angle": {
    "type": "frontal|close_up|wide_angle|focused",
    "description": "...",
    "min_distance_feet": N,
    "max_distance_feet": N
  },
  "lighting": {
    "min_brightness": "adequate|good",
    "avoid_glare": true,
    "avoid_shadows": true
  },
  "visibility": {
    "materials_visible": true,
    "no_obstructions": true
  },
  "technical": {
    "min_resolution": {
      "width": 1024,
      "height": 768
    },
    "max_blur_score": 0.3,
    "max_file_size_mb": 10,
    "allowed_formats": ["image/jpeg", "image/png", "image/heic"]
  },
  "content": {
    "show_installation_complete": true,
    "show_materials_undamaged": true
  }
}
```

**Usage in Kit Definitions**:
```sql
INSERT INTO kit_items (
  kit_definition_id,
  item_sku,
  item_name,
  quantity,
  photo_rule_id
) VALUES (
  '...',
  'POSTER-001',
  '24x36 Promotional Poster',
  1,
  '00000000-0000-0000-0000-000000000301'::UUID  -- Standard Proof
);
```

**Replication for Production Brands**:
The file includes a query to replicate these default rules for new brands:
```sql
INSERT INTO photo_rules (brand_id, name, description, requirements_json)
SELECT
  '...'::UUID AS brand_id,  -- New brand ID
  name,
  description,
  requirements_json
FROM photo_rules
WHERE brand_id = '00000000-0000-0000-0000-000000000200'::UUID;
```

**Dependencies**:
- `00_foundation_ddl.sql` (brands table)
- `store_module_ddl.sql` or equivalent (photo_rules table)

**Load Order**: 4th (requires brands table and photo_rules table to exist)

**Important Note**: Photo rules are brand-specific. These defaults use the development brand ID. Production brands should have their own photo rules created during onboarding.

---

## Load Order & Dependencies

### Dependency Graph

```
00_foundation_ddl.sql (schema)
  ↓
01_enums.sql (reference documentation)
  ↓
02_system_users.sql (system user)
  ↓
03_default_tenant.sql (tenant + brand)
  ↓
04_notification_events.sql (event types reference)
  ↓
store_module_ddl.sql or equivalent (photo_rules table)
  ↓
05_photo_rules_defaults.sql (photo rules)
```

### Recommended Load Order

1. **Schema DDL First**: Load all schema DDL files (`00_foundation_ddl.sql`, module schemas)
2. **System User**: Load `02_system_users.sql` (required for audit trails)
3. **Default Tenant**: Load `03_default_tenant.sql` (required for brand-scoped data)
4. **Photo Rules**: Load `05_photo_rules_defaults.sql` (requires brands table)
5. **Reference Docs**: Load `01_enums.sql` and `04_notification_events.sql` any time (informational only)

### Load Script Example

```bash
# Load schema DDL
psql -d newpopsys -f 01_Schema/00_foundation_ddl.sql
psql -d newpopsys -f 01_Schema/store_module_ddl.sql
psql -d newpopsys -f 01_Schema/brand_module_ddl.sql
# ... other module schemas

# Load seed data
psql -d newpopsys -f 05_Seed_Data/02_system_users.sql
psql -d newpopsys -f 05_Seed_Data/03_default_tenant.sql
psql -d newpopsys -f 05_Seed_Data/05_photo_rules_defaults.sql

# Load reference documentation (optional)
psql -d newpopsys -f 05_Seed_Data/01_enums.sql
psql -d newpopsys -f 05_Seed_Data/04_notification_events.sql
```

---

## Environment-Specific Considerations

### Development Environment
- **Load All Seed Data**: Development tenant, brand, and photo rules are useful
- **System User Required**: Needed for testing automated workflows
- **Default Preferences**: Use notification event defaults for testing

### Testing/CI Environment
- **Load All Seed Data**: Same as development
- **Reset Between Runs**: Use `ON CONFLICT DO NOTHING` for idempotency
- **Cleanup Scripts**: Soft-delete default tenant/brand after tests if needed

### Staging Environment
- **Load System User Only**: Do not load development tenant/brand
- **Production-Like Data**: Create realistic tenant/brand structures
- **Custom Photo Rules**: Create brand-specific photo rules

### Production Environment
- **Load System User Only**: Required for system operations
- **NO Development Data**: Do not load default tenant or default brand
- **Brand Onboarding**: Create tenant/brand during customer onboarding
- **Custom Photo Rules**: Create brand-specific photo rules during setup

---

## Validation & Verification

### System User Validation
```sql
SELECT
  id,
  email,
  full_name,
  is_global_admin,
  created_at,
  deleted_at,
  (id = '00000000-0000-0000-0000-000000000001'::UUID) AS is_system_user
FROM users
WHERE id = '00000000-0000-0000-0000-000000000001'::UUID;
```

**Expected Result**:
- ID: `00000000-0000-0000-0000-000000000001`
- Email: `system@newpopsys.internal`
- Full Name: `System`
- is_global_admin: `false`
- deleted_at: `NULL`
- is_system_user: `true`

### Default Tenant Validation
```sql
SELECT
  id,
  name,
  slug,
  subscription_tier,
  created_at,
  deleted_at
FROM tenants
WHERE id = '00000000-0000-0000-0000-000000000100'::UUID
   OR slug = 'dev-tenant';
```

**Expected Result**:
- ID: `00000000-0000-0000-0000-000000000100`
- Name: `Development Tenant`
- Slug: `dev-tenant`
- Tier: `PILOT`
- deleted_at: `NULL`

### Default Brand Validation
```sql
SELECT
  b.id,
  b.name,
  b.code,
  b.tenant_id,
  t.name AS tenant_name,
  b.created_at,
  b.deleted_at
FROM brands b
JOIN tenants t ON t.id = b.tenant_id
WHERE b.id = '00000000-0000-0000-0000-000000000200'::UUID;
```

**Expected Result**:
- ID: `00000000-0000-0000-0000-000000000200`
- Name: `Development Brand`
- Code: `DEV`
- Tenant ID: `00000000-0000-0000-0000-000000000100`
- Tenant Name: `Development Tenant`
- deleted_at: `NULL`

### Photo Rules Validation
```sql
SELECT
  id,
  name,
  description,
  requirements_json->>'angle' AS angle_type,
  created_at
FROM photo_rules
WHERE brand_id = '00000000-0000-0000-0000-000000000200'::UUID
  AND deleted_at IS NULL
ORDER BY name;
```

**Expected Result**: 6 photo rules for development brand

### Comprehensive Seed Data Check
```sql
SELECT
  'System User' AS seed_type,
  COUNT(*) AS count,
  (COUNT(*) = 1) AS is_valid
FROM users
WHERE id = '00000000-0000-0000-0000-000000000001'::UUID

UNION ALL

SELECT
  'Default Tenant',
  COUNT(*),
  (COUNT(*) = 1)
FROM tenants
WHERE id = '00000000-0000-0000-0000-000000000100'::UUID

UNION ALL

SELECT
  'Default Brand',
  COUNT(*),
  (COUNT(*) = 1)
FROM brands
WHERE id = '00000000-0000-0000-0000-000000000200'::UUID

UNION ALL

SELECT
  'Photo Rules',
  COUNT(*),
  (COUNT(*) = 6)
FROM photo_rules
WHERE brand_id = '00000000-0000-0000-0000-000000000200'::UUID;
```

**Expected Result**: All rows should show `is_valid = true`

---

## Fixed UUID Reference

For easy reference, here are all fixed UUIDs used in seed data:

| Entity | UUID | Name |
|--------|------|------|
| System User | `00000000-0000-0000-0000-000000000001` | System |
| Default Tenant | `00000000-0000-0000-0000-000000000100` | Development Tenant |
| Default Brand | `00000000-0000-0000-0000-000000000200` | Development Brand |
| Photo Rule: Standard Proof | `00000000-0000-0000-0000-000000000301` | Standard Proof |
| Photo Rule: Detail Shot | `00000000-0000-0000-0000-000000000302` | Detail Shot |
| Photo Rule: Location Context | `00000000-0000-0000-0000-000000000303` | Location Context |
| Photo Rule: Damage Documentation | `00000000-0000-0000-0000-000000000304` | Damage Documentation |
| Photo Rule: Packaging Receipt | `00000000-0000-0000-0000-000000000305` | Packaging Receipt |
| Photo Rule: Installation Progress | `00000000-0000-0000-0000-000000000306` | Installation Progress |

**UUID Ranges**:
- `000000xx-0000-0000-0000-00000000000x`: System users (x1-x9)
- `000000xx-0000-0000-0000-0000000001xx`: Tenants (x00-x99)
- `000000xx-0000-0000-0000-0000000002xx`: Brands (x00-x99)
- `000000xx-0000-0000-0000-0000000003xx`: Photo Rules (x01-x99)

---

## Maintenance & Updates

### Adding New Seed Data

1. **Create New File**: Add new seed data file with sequential number (e.g., `06_new_seed.sql`)
2. **Use Fixed UUIDs**: Follow UUID range conventions above
3. **Document Thoroughly**: Include purpose, usage, dependencies, validation queries
4. **Update Manifest**: Add entry to this manifest document
5. **Test Idempotency**: Ensure `ON CONFLICT DO NOTHING` works correctly

### Updating Existing Seed Data

1. **Backwards Compatible**: Ensure changes don't break existing data
2. **Version Comments**: Add version comments to seed files
3. **Update Manifest**: Update this manifest with change notes
4. **Test Migration**: Test updating from previous version

### Deprecating Seed Data

1. **Mark Deprecated**: Add deprecation notice to seed file
2. **Update Manifest**: Mark as deprecated in this manifest
3. **Migration Path**: Provide migration path to replacement seed data
4. **Remove After Grace Period**: Remove after suitable grace period

---

## Troubleshooting

### "Relation does not exist" Error
**Cause**: Seed data loaded before schema DDL
**Solution**: Load schema DDL files first, then seed data

### "Foreign key violation" Error
**Cause**: Seed data loaded in wrong order
**Solution**: Follow load order: system user → tenant → brand → photo rules

### "Duplicate key value" Error
**Cause**: Seed data already exists (expected on re-run)
**Solution**: This is normal - `ON CONFLICT DO NOTHING` should handle it

### "Invalid UUID" Error
**Cause**: Typo in UUID string
**Solution**: Verify UUID format matches fixed UUID reference above

### Photo Rules Not Found
**Cause**: Photo rules require photo_rules table from module schemas
**Solution**: Load store/campaign module schemas before photo rules seed data

---

## References

- **SUPP-002**: Core Domain (campaigns, assignments)
- **SUPP-003**: Access Control (roles, permissions)
- **SUPP-013**: Stores & Hierarchies
- **SUPP-014**: Survey Builder & Layouts
- **SUPP-015**: Fulfillment (orders, shipments)
- **SUPP-016**: Issues & Reorders
- **SUPP-017**: Photo Requirements
- **SUPP-018**: Notifications
- **SUPP-019**: Exports
- **SUPP-035**: Database Model (complete schema)

---

## Change Log

| Date | Version | Change | Author |
|------|---------|--------|--------|
| 2025-12-19 | v1.0 | Initial manifest created with 5 seed data files | Data Agent |

---

*End of Seed Data Manifest*
