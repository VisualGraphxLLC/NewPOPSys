# A005: Audit Logs

## 1. Overview

| Field | Value |
|-------|-------|
| **Screen ID** | A005 |
| **Module** | Platform Admin |
| **Primary Persona** | Platform Admin (PSP-001) |
| **Secondary Personas** | PSP Admin, Support Agent |
| **SOW Reference** | SUPP-029, SUPP-031 |

## 2. Screenshot Reference

![Audit Logs](../../screenshots/PSP_Admin/psp_admin_audit.png)

*Figure A005-1: Audit Logs - Immutable audit trail with search, filtering, and compliance export*

> **Layout Reference:** Design follows Audit Explorer patterns from SUPP-029.

## 3. Screen Description

The Audit Logs screen provides comprehensive access to the platform's immutable audit trail. This screen enables administrators to search, filter, and analyze all audited events across the platform for security monitoring, compliance reporting, and troubleshooting.

The audit log captures all significant system events including user actions, data modifications, authentication events, impersonation sessions, and system configuration changes. Each event includes correlation IDs for end-to-end request tracing and actor identification for accountability.

Platform Admins have access to all audit events across all tenants, while PSP Admins and Support Agents are scoped to their tenant's events. The screen supports advanced filtering, date range selection, and export capabilities for compliance reporting.

---

## 4. User Access (RBAC)

| Persona | Can Access | Permissions | Notes |
|---------|------------|-------------|-------|
| Platform Admin | Y | Full Access | All tenants, all events |
| PSP Admin | Y | Tenant-Scoped | Own tenant events only |
| Support Agent | Y | Read-Only (Tenant-Scoped) | View only, own tenant |
| Brand Admin | Y | Brand-Scoped | Own brand events only |
| Regional Manager | Y | Region-Scoped | Assigned region events only |
| Store Manager | Y | Store-Scoped | Own store events only |

---

## 5. Data Model

### Primary Entities

- **AuditEvent** - Immutable audit trail entries
  - Key fields: event_id, event_type, actor_id, actor_type, target_type, target_id, action, timestamp, correlation_id, request_id, tenant_id, brand_id, metadata
- **AuditEventType** - Event type definitions
  - Key fields: type_code, description, severity, retention_class

### Event Categories

| Category | Event Types |
|----------|-------------|
| Authentication | login.success, login.failure, logout, password.changed, mfa.enabled |
| Authorization | permission.denied, role.assigned, role.removed |
| Data Modification | record.created, record.updated, record.deleted |
| Impersonation | impersonation.started, impersonation.ended |
| System | setting.changed, webhook.delivered, job.completed |
| Security | lockout.triggered, suspicious.activity, api_key.created |

### Relationships

![10_Module_PlatformAdmin_screens_A005_Audit_Logs_diagram_0](../../diagrams_rendered/10_Module_PlatformAdmin_screens_A005_Audit_Logs_diagram_0.png)

---

## 6. APIs

### Internal APIs

| Endpoint | Method | Purpose |
|----------|--------|---------|
| /api/v1/admin/audit | GET | Search audit events with filters |
| /api/v1/admin/audit/{id} | GET | Get audit event details |
| /api/v1/admin/audit/export | POST | Export audit events to file |
| /api/v1/admin/audit/event-types | GET | List available event types |
| /api/v1/admin/audit/statistics | GET | Get audit statistics summary |
| /api/v1/admin/audit/trace/{correlationId} | GET | Get all events for correlation ID |

### External Integrations

| System | Purpose | Data Flow |
|--------|---------|-----------|
| SIEM Integration | Security event export | Outbound |
| Log Aggregation | Centralized logging | Outbound |

---

## 7. Business Rules

- BR-A005-01: Audit log entries are immutable; cannot be modified or deleted
- BR-A005-02: Audit logs are retained for 7 years per COMPLIANCE retention class
- BR-A005-03: Access to audit logs is itself audited
- BR-A005-04: Impersonation events include both actual actor and impersonated actor
- BR-A005-05: High-severity events trigger real-time notifications (per SUPP-004)
- BR-A005-06: Export requests create audit events with export metadata
- BR-A005-07: Correlation ID links all events from a single request chain
- BR-A005-08: Request ID identifies individual service calls within correlation

---

## 8. UI Components

### Search and Filter Panel

| Filter | Type | Options |
|--------|------|---------|
| Date Range | Date Picker | Start/End dates, presets (Today, Last 7 days, etc.) |
| Event Type | Multi-select | All event type categories |
| Severity | Multi-select | INFO, WARNING, HIGH, CRITICAL |
| Actor | Search | User name or ID |
| Target | Search | Resource type and ID |
| Tenant | Dropdown | (Platform Admin only) |
| Brand | Dropdown | (Admin only) |
| Correlation ID | Text | For request tracing |

### Event List Table

| Column | Description | Sortable |
|--------|-------------|----------|
| Timestamp | Event occurrence time (with timezone) | Yes |
| Event Type | Event category and action | Yes |
| Severity | Visual severity indicator | Yes |
| Actor | User who performed action | Yes |
| Target | Affected resource | Yes |
| Summary | Brief event description | No |
| Details | Expand for full details | No |

### Event Detail Panel

- **Event Metadata**
  - Event ID, Type, Timestamp
  - Correlation ID, Request ID
  - Source IP, User Agent

- **Actor Information**
  - Actual Actor (who performed action)
  - Impersonated Actor (if applicable)
  - Actor Role and Tenant

- **Target Information**
  - Resource Type and ID
  - Before/After values (for modifications)

- **Related Events**
  - Events with same Correlation ID
  - Events affecting same target

---

## 9. Audit Event Schema

```json
{
  "event_id": "uuid",
  "event_type": "record.updated",
  "severity": "INFO",
  "timestamp": "2026-01-01T10:30:00Z",
  "correlation_id": "uuid",
  "request_id": "uuid",
  "actor": {
    "user_id": "uuid",
    "email": "admin@example.com",
    "role": "PLATFORM_ADMIN",
    "ip_address": "192.168.1.1",
    "user_agent": "Mozilla/5.0..."
  },
  "impersonated_actor": null,
  "target": {
    "type": "Brand",
    "id": "uuid",
    "name": "Good2Go"
  },
  "action": "UPDATE",
  "changes": {
    "before": {"status": "active"},
    "after": {"status": "inactive"}
  },
  "metadata": {
    "reason": "Brand requested deactivation"
  }
}
```

---

## 10. Export Capabilities

### Export Formats

| Format | Description | Use Case |
|--------|-------------|----------|
| CSV | Comma-separated values | Spreadsheet analysis |
| JSON | Full event details | API integration |
| PDF | Formatted report | Compliance documentation |

### Export Options

- Date range selection
- Event type filtering
- Include/exclude sensitive fields
- Scheduled exports (daily/weekly)

---

## 11. Acceptance Criteria

- [ ] AC-A005-01: Platform Admin can view all tenant audit events
- [ ] AC-A005-02: PSP Admin sees only their tenant's events
- [ ] AC-A005-03: Date range filter returns events within range
- [ ] AC-A005-04: Correlation ID search returns all related events
- [ ] AC-A005-05: Event detail shows before/after values for changes
- [ ] AC-A005-06: Impersonation events show both actors clearly
- [ ] AC-A005-07: Export generates file in selected format
- [ ] AC-A005-08: Search returns results within 2 seconds for typical queries
- [ ] AC-A005-09: Pagination works correctly for large result sets
- [ ] AC-A005-10: Accessing audit logs creates its own audit event

---

## 12. Related Documents

- SUPP-029 - Observability, Metrics, and Audit
- SUPP-031 - Supportability, Logs, and Impersonation
- SUPP-003 - RBAC and Permissions Matrix
- SRS-4.4.1 - Platform Admin Persona

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*
