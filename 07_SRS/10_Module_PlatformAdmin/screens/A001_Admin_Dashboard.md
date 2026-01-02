# A001: Admin Dashboard

## 1. Overview

| Field | Value |
|-------|-------|
| **Screen ID** | A001 |
| **Module** | Platform Admin |
| **Primary Persona** | Platform Admin (PSP-001) |
| **Secondary Personas** | PSP Admin, Support Agent |
| **SOW Reference** | SUPP-029, SUPP-030, SUPP-031 |

## 2. Screenshot Reference

![Admin Dashboard](../../screenshots/PSP_Admin/psp_admin_dashboard.png)

*Figure A001-1: Admin Dashboard - Platform-wide system health, security events, and operational metrics*

> **Layout Reference:** Design patterns follow Brand Dashboard (B01) conventions.

## 3. Screen Description

The Admin Dashboard serves as the command center for Platform Administrators, providing a consolidated view of system health, security events, tenant status, and operational metrics. This screen is the primary landing page for users with Platform Admin or PSP Admin roles.

The dashboard displays real-time system health indicators, recent security events requiring attention, tenant activity summaries, and quick-access navigation to critical administrative functions. Key performance indicators (KPIs) are prominently displayed to enable rapid assessment of platform status.

Platform Admins use this screen to monitor overall system health, identify security anomalies, and navigate to detailed administrative functions. The dashboard supports drill-down into specific metrics and provides contextual links to relevant management screens.

---

## 4. User Access (RBAC)

| Persona | Can Access | Permissions | Notes |
|---------|------------|-------------|-------|
| Platform Admin | Y | Full Access | All widgets, all drill-downs |
| PSP Admin | Y | Tenant-Scoped | Own tenant metrics only |
| Support Agent | Y | Read-Only | View only, no configuration |
| Brand Admin | N | - | No access to admin dashboard |
| Store Manager | N | - | No access to admin dashboard |

---

## 5. Data Model

### Primary Entities

- **Tenant** - PSP tenant configuration and status
  - Key fields: tenant_id, name, status, created_at, settings
- **AuditEvent** - System-wide audit trail entries
  - Key fields: event_id, event_type, actor_id, timestamp, correlation_id
- **User** - Platform user accounts
  - Key fields: user_id, email, role, tenant_id, last_login
- **SystemHealth** - Real-time system metrics (derived)
  - Key fields: service_name, status, latency, error_rate

### Relationships

![10_Module_PlatformAdmin_screens_A001_Admin_Dashboard_diagram_0](../../diagrams_rendered/10_Module_PlatformAdmin_screens_A001_Admin_Dashboard_diagram_0.png)

---

## 6. APIs

### Internal APIs

| Endpoint | Method | Purpose |
|----------|--------|---------|
| /api/v1/admin/dashboard/health | GET | Retrieve system health metrics |
| /api/v1/admin/dashboard/security-events | GET | Get recent security events |
| /api/v1/admin/dashboard/tenant-summary | GET | Get tenant activity summary |
| /api/v1/admin/dashboard/kpis | GET | Retrieve dashboard KPI data |

### External Integrations

| System | Purpose | Data Flow |
|--------|---------|-----------|
| Logging Service | System health metrics | Inbound |
| Auth Provider | Login/session metrics | Inbound |

---

## 7. Business Rules

- BR-A001-01: Dashboard data refreshes every 60 seconds automatically
- BR-A001-02: Security events with severity >= HIGH display in alert panel
- BR-A001-03: PSP Admin sees only their tenant's data (tenant isolation)
- BR-A001-04: System health indicators use traffic-light status (green/yellow/red)
- BR-A001-05: Failed authentication attempts > 5 in 15 minutes triggers security alert

---

## 8. UI Components

### Dashboard Widgets

| Widget | Description | Refresh Rate |
|--------|-------------|--------------|
| System Health | Service status indicators | 60s |
| Security Events | Recent high-priority security alerts | 30s |
| Active Users | Current logged-in users count | 60s |
| Tenant Overview | Active tenants and their status | 5min |
| Recent Audit Activity | Last 10 audit events | 30s |
| Quick Actions | Links to common admin tasks | Static |

### Quick Actions Menu

- User Management (A002)
- Brand Configuration (A003)
- System Settings (A004)
- Audit Logs (A005)
- Support Queue (A006)

---

## 9. Acceptance Criteria

- [ ] AC-A001-01: Platform Admin can view all tenant data on dashboard
- [ ] AC-A001-02: PSP Admin sees only their tenant's metrics
- [ ] AC-A001-03: Support Agent can view dashboard in read-only mode
- [ ] AC-A001-04: Security events display with severity color coding
- [ ] AC-A001-05: Dashboard auto-refreshes without page reload
- [ ] AC-A001-06: Clicking on KPI navigates to detailed view
- [ ] AC-A001-07: System health shows status for all critical services
- [ ] AC-A001-08: MFA status indicator visible for admin session

---

## 10. Related Documents

- SUPP-029 - Observability, Metrics, and Audit
- SUPP-030 - Admin Ops Console (deprecated, merged into module)
- SUPP-031 - Supportability, Logs, and Impersonation
- SRS-4.4.1 - Platform Admin Persona

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*
