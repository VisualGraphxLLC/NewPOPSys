# A003: Brand Configuration

## 1. Overview

| Field | Value |
|-------|-------|
| **Screen ID** | A003 |
| **Module** | Platform Admin |
| **Primary Persona** | Platform Admin (PSP-001) |
| **Secondary Personas** | PSP Admin |
| **SOW Reference** | SUPP-003, SUPP-023 |

## 2. Screenshot Reference

![Brand Configuration](../../screenshots/PSP_Admin/psp_admin_brands.png)

*Figure A003-1: Brand Configuration - Brand tenant onboarding, feature flags, and integration settings*

> **Layout Reference:** Design follows brand onboarding patterns from SUPP documents.

## 3. Screen Description

The Brand Configuration screen enables Platform Admins and PSP Admins to onboard and configure brand tenants within the PSP ecosystem. This screen provides comprehensive brand setup including branding assets, notification preferences, feature flag configurations, and integration settings.

Brand onboarding follows a "skeletonize" approach where the PSP creates the brand structure, configures initial settings, and then invites Brand Admin users to complete detailed configuration. This screen manages the PSP-level brand settings that determine platform behavior for each brand.

Key capabilities include brand creation, feature flag management, API key provisioning, notification channel configuration, and brand-level policy settings.

---

## 4. User Access (RBAC)

| Persona | Can Access | Permissions | Notes |
|---------|------------|-------------|-------|
| Platform Admin | Y | Full CRUD | All brands across all tenants |
| PSP Admin | Y | Full CRUD (tenant-scoped) | Brands within own PSP tenant only |
| Support Agent | Y | Read-Only | View brand configuration, no changes |
| Brand Admin | N | - | Uses Brand Admin module for self-config |
| Store Manager | N | - | No access |

---

## 5. Data Model

### Primary Entities

- **Brand** - Brand tenant configuration
  - Key fields: brand_id, name, tenant_id, status, logo_url, primary_color, created_at
- **BrandSettings** - Brand-specific settings
  - Key fields: brand_id, notification_preferences, verification_mode, sla_settings
- **FeatureFlag** - Feature flag configurations
  - Key fields: flag_id, flag_key, scope_type, scope_id, value, enabled
- **APIKey** - Brand API credentials
  - Key fields: key_id, brand_id, key_hash, permissions[], created_at, expires_at

### Relationships

![10_Module_PlatformAdmin_screens_A003_Brand_Configuration_diagram_0](../../diagrams_rendered/10_Module_PlatformAdmin_screens_A003_Brand_Configuration_diagram_0.png)

---

## 6. APIs

### Internal APIs

| Endpoint | Method | Purpose |
|----------|--------|---------|
| /api/v1/admin/brands | GET | List brands with filtering |
| /api/v1/admin/brands | POST | Create new brand (skeletonize) |
| /api/v1/admin/brands/{id} | GET | Get brand details |
| /api/v1/admin/brands/{id} | PUT | Update brand configuration |
| /api/v1/admin/brands/{id} | DELETE | Deactivate brand |
| /api/v1/admin/brands/{id}/settings | GET | Get brand settings |
| /api/v1/admin/brands/{id}/settings | PUT | Update brand settings |
| /api/v1/admin/brands/{id}/feature-flags | GET | List brand feature flags |
| /api/v1/admin/brands/{id}/feature-flags | PUT | Update feature flags |
| /api/v1/admin/brands/{id}/api-keys | GET | List API keys |
| /api/v1/admin/brands/{id}/api-keys | POST | Create API key |
| /api/v1/admin/brands/{id}/api-keys/{keyId} | DELETE | Revoke API key |

### External Integrations

| System | Purpose | Data Flow |
|--------|---------|-----------|
| Asset Storage | Brand logo/asset upload | Outbound |
| Email Service | Brand admin invitation | Outbound |

---

## 7. Business Rules

- BR-A003-01: Brand names must be unique within a PSP tenant
- BR-A003-02: Brand deletion is soft-delete; historical data retained
- BR-A003-03: API keys are shown only once at creation; stored hashed
- BR-A003-04: Feature flag changes are audited with before/after values
- BR-A003-05: Feature flags use scope precedence: USER > STORE > CAMPAIGN > BRAND > TENANT
- BR-A003-06: Brand status change to Inactive disables all brand user logins
- BR-A003-07: At least one Brand Admin must be invited before brand goes Active
- BR-A003-08: Notification preferences inherit from PSP defaults if not overridden

---

## 8. UI Components

### Brand List Table

| Column | Description | Sortable | Filterable |
|--------|-------------|----------|------------|
| Name | Brand name | Yes | Yes |
| Status | Active/Inactive/Pending | Yes | Yes (dropdown) |
| Campaigns | Active campaign count | Yes | No |
| Stores | Total store count | Yes | No |
| Created | Creation date | Yes | Yes (date range) |
| Actions | Edit, View, Deactivate | No | No |

### Brand Configuration Tabs

1. **General Settings**
   - Brand name, logo, colors
   - Contact information
   - Status management

2. **Notification Preferences**
   - Email notification toggles
   - Webhook configuration
   - Escalation rules

3. **Feature Flags**
   - Flag list with toggle controls
   - Scope selection (Brand-wide vs Campaign-specific)
   - Override inheritance display

4. **API Keys**
   - Key list with permissions
   - Create new key
   - Revoke existing keys

5. **Users**
   - Brand-level user list
   - Invite Brand Admin

---

## 9. State Transitions

![10_Module_PlatformAdmin_screens_A003_Brand_Configuration_diagram_1](../../diagrams_rendered/10_Module_PlatformAdmin_screens_A003_Brand_Configuration_diagram_1.png)

---

## 10. Feature Flag Configuration

### Available Feature Flags (v1)

| Flag Key | Description | Default | Scope Options |
|----------|-------------|---------|---------------|
| `photo_verification_enabled` | Enable photo proof verification | true | Brand, Campaign |
| `strict_verification_mode` | Require admin approval for all proofs | false | Brand, Campaign |
| `deinstall_tracking_enabled` | Track deinstallation completion | true | Brand, Campaign |
| `issue_auto_approval` | Auto-approve issues under threshold | false | Brand |
| `multi_language_enabled` | Enable multi-language support | false | Brand |

---

## 11. Acceptance Criteria

- [ ] AC-A003-01: Platform Admin can create brands in any tenant
- [ ] AC-A003-02: PSP Admin can only create brands in their tenant
- [ ] AC-A003-03: Brand creation initializes default settings
- [ ] AC-A003-04: Feature flag changes take effect immediately
- [ ] AC-A003-05: API key is displayed only once at creation
- [ ] AC-A003-06: Brand deactivation prevents user logins
- [ ] AC-A003-07: Logo upload accepts PNG/JPG up to 2MB
- [ ] AC-A003-08: Brand admin invitation sends email notification
- [ ] AC-A003-09: Audit log records all configuration changes
- [ ] AC-A003-10: Feature flag scope inheritance is visually indicated

---

## 12. Related Documents

- SUPP-003 - RBAC and Permissions Matrix
- SUPP-023 - Feature Flags Admin UX
- SUPP-004 - Notifications and Escalation Matrix
- SRS-4.4.1 - Platform Admin Persona

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*
