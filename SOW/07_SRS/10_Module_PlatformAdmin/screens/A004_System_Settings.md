# A004: System Settings

## 1. Overview

| Field | Value |
|-------|-------|
| **Screen ID** | A004 |
| **Module** | Platform Admin |
| **Primary Persona** | Platform Admin (PSP-001) |
| **Secondary Personas** | PSP Admin (limited access) |
| **SOW Reference** | SUPP-023, SUPP-029, SUPP-006 |

## 2. Screenshot Reference

![System Settings](../../screenshots/PSP_Admin/psp_admin_settings.png)

*Figure A004-1: System Settings - Platform-wide configuration, webhooks, and feature flag management*

> **Layout Reference:** Design follows standard settings management patterns.

## 3. Screen Description

The System Settings screen provides centralized configuration for platform-wide and tenant-wide settings. Platform Admins have access to global system configuration, while PSP Admins can configure tenant-specific settings within their scope.

This screen manages critical platform behaviors including authentication policies, API rate limits, webhook configurations, feature flags at the platform level, email delivery settings, and data retention policies. Changes to system settings are considered high-risk operations and require confirmation.

The settings are organized into logical categories with clear descriptions of each setting's impact. All changes are audited with before/after values for compliance and troubleshooting purposes.

---

## 4. User Access (RBAC)

| Persona | Can Access | Permissions | Notes |
|---------|------------|-------------|-------|
| Platform Admin | Y | Full Read/Write | All system settings |
| PSP Admin | Y | Tenant Settings Only | Own tenant configuration |
| Support Agent | Y | Read-Only | View settings, no changes |
| Brand Admin | N | - | No access |
| Store Manager | N | - | No access |

---

## 5. Data Model

### Primary Entities

- **SystemSetting** - Platform-wide settings
  - Key fields: setting_id, key, value, data_type, category, description, last_modified
- **TenantSetting** - Tenant-specific settings
  - Key fields: tenant_id, key, value, inherits_from_system
- **WebhookEndpoint** - Configured webhook destinations
  - Key fields: endpoint_id, url, events[], secret_hash, status, last_delivery
- **EmailConfiguration** - Email delivery settings
  - Key fields: provider, api_key_hash, from_address, reply_to

### Relationships

![10_Module_PlatformAdmin_screens_A004_System_Settings_diagram_0](../../diagrams_rendered/10_Module_PlatformAdmin_screens_A004_System_Settings_diagram_0.png)

---

## 6. APIs

### Internal APIs

| Endpoint | Method | Purpose |
|----------|--------|---------|
| /api/v1/admin/settings | GET | List all settings (filtered by access) |
| /api/v1/admin/settings/{key} | GET | Get specific setting |
| /api/v1/admin/settings/{key} | PUT | Update setting value |
| /api/v1/admin/settings/categories | GET | List setting categories |
| /api/v1/admin/webhooks | GET | List webhook endpoints |
| /api/v1/admin/webhooks | POST | Create webhook endpoint |
| /api/v1/admin/webhooks/{id} | PUT | Update webhook endpoint |
| /api/v1/admin/webhooks/{id} | DELETE | Delete webhook endpoint |
| /api/v1/admin/webhooks/{id}/test | POST | Send test webhook |
| /api/v1/admin/email/test | POST | Send test email |
| /api/v1/admin/feature-flags | GET | List platform feature flags |
| /api/v1/admin/feature-flags/{key} | PUT | Update feature flag |

### External Integrations

| System | Purpose | Data Flow |
|--------|---------|-----------|
| Email Provider (SendGrid/SES) | Email delivery configuration | Outbound |
| Webhook Destinations | Event delivery | Outbound |

---

## 7. Business Rules

- BR-A004-01: System settings changes require confirmation dialog
- BR-A004-02: Security-critical settings require MFA re-authentication
- BR-A004-03: Tenant settings inherit from system settings if not overridden
- BR-A004-04: Webhook secrets are shown only once at creation
- BR-A004-05: Webhook delivery uses exponential backoff retry (per SUPP-006)
- BR-A004-06: Email configuration changes require test email before activation
- BR-A004-07: Rate limit changes take effect within 60 seconds
- BR-A004-08: All setting changes are immutably audited

---

## 8. UI Components

### Settings Categories

1. **Authentication & Security**
   - Password policy (length, complexity, rotation)
   - MFA enforcement rules
   - Session timeout settings
   - Account lockout thresholds
   - IP allowlist/blocklist

2. **API Configuration**
   - Rate limiting (requests per minute)
   - API versioning settings
   - CORS allowed origins
   - Request size limits

3. **Webhooks**
   - Endpoint management
   - Event subscription configuration
   - Retry policy settings
   - Webhook signing key management

4. **Email Delivery**
   - Provider configuration
   - From address settings
   - Template management
   - Delivery queue settings

5. **Feature Flags (Platform Level)**
   - Global feature toggles
   - Rollout percentage controls
   - Kill switches for emergencies

6. **Data Retention**
   - Audit log retention period
   - Session data retention
   - Deleted record retention
   - Export file retention

### Setting Entry Format

| Field | Description |
|-------|-------------|
| Key | Setting identifier |
| Value | Current value with type-appropriate input |
| Default | System default value |
| Description | Setting purpose and impact |
| Last Modified | Timestamp and modifier |
| Inherited | Whether tenant inherits from system |

---

## 9. Webhook Configuration

### Event Types Available

| Event | Description | Payload |
|-------|-------------|---------|
| `order.created` | New order generated | Order details |
| `shipment.updated` | Shipping status change | Shipment details |
| `proof.submitted` | Store submits completion proof | Proof metadata |
| `issue.submitted` | Issue/reorder request created | Issue details |
| `campaign.status_changed` | Campaign status transition | Campaign summary |

### Webhook Delivery Specification

- **Retry Policy**: Exponential backoff (1s, 2s, 4s, 8s, 16s) up to 5 attempts
- **Signing**: HMAC-SHA256 signature in `X-Signature-256` header
- **Timeout**: 30 second connection timeout
- **Idempotency**: Unique `X-Delivery-Id` header for deduplication

---

## 10. Security Settings Detail

### Password Policy Options

| Setting | Options | Default |
|---------|---------|---------|
| Minimum Length | 8-32 characters | 12 |
| Require Uppercase | Yes/No | Yes |
| Require Lowercase | Yes/No | Yes |
| Require Numbers | Yes/No | Yes |
| Require Special Characters | Yes/No | Yes |
| Password History | 0-24 passwords | 12 |
| Max Age (Admin Roles) | 30-365 days | 90 |
| Max Age (Store Roles) | 0 (disabled) - 365 days | 0 |

### Session Settings

| Setting | Options | Default |
|---------|---------|---------|
| Session Timeout (Idle) | 5-60 minutes | 30 |
| Session Timeout (Absolute) | 1-24 hours | 8 |
| Concurrent Sessions | 1-10 | 3 |
| Remember Me Duration | 1-30 days | 14 |

---

## 11. Acceptance Criteria

- [ ] AC-A004-01: Platform Admin can modify all system settings
- [ ] AC-A004-02: PSP Admin can only modify tenant settings
- [ ] AC-A004-03: Setting changes display confirmation dialog
- [ ] AC-A004-04: Security settings require MFA re-authentication
- [ ] AC-A004-05: Webhook test sends sample payload successfully
- [ ] AC-A004-06: Email test delivers to specified address
- [ ] AC-A004-07: Setting inheritance is visually indicated
- [ ] AC-A004-08: All changes are recorded in audit log
- [ ] AC-A004-09: Invalid setting values show validation errors
- [ ] AC-A004-10: Rate limit changes apply within 60 seconds

---

## 12. Related Documents

- SUPP-006 - Webhooks and External Integration
- SUPP-023 - Feature Flags Admin UX
- SUPP-029 - Observability, Metrics, and Audit
- SUPP-027 - Message Delivery
- SRS-4.4.1 - Platform Admin Persona

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*
