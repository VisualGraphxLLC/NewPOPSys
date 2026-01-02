# A002: User Management

## 1. Overview

| Field | Value |
|-------|-------|
| **Screen ID** | A002 |
| **Module** | Platform Admin |
| **Primary Persona** | Platform Admin (PSP-001) |
| **Secondary Personas** | PSP Admin |
| **SOW Reference** | SUPP-003, SUPP-031 |

## 2. Screenshot Reference

![User Management](../../screenshots/PSP_Admin/psp_admin_users.png)

*Figure A002-1: User Management - Platform user administration with roles, permissions, and session management*

> **Layout Reference:** Design follows standard user management grid patterns.

## 3. Screen Description

The User Management screen provides comprehensive user account administration capabilities across the platform. Platform Admins can manage users across all tenants, while PSP Admins are scoped to their own tenant.

This screen enables user creation, role assignment, permission management, and account lifecycle operations (enable/disable/delete). It also provides access to user activity logs, session management, and security settings including MFA enforcement.

Key features include bulk user operations, role-based filtering, user search, and the ability to view impersonation history for any user account.

---

## 4. User Access (RBAC)

| Persona | Can Access | Permissions | Notes |
|---------|------------|-------------|-------|
| Platform Admin | Y | Full CRUD + Impersonate | All tenants, all users |
| PSP Admin | Y | Full CRUD (tenant-scoped) | Own tenant users only, no impersonation |
| Support Agent | Y | Read-Only | View user details, no modifications |
| Brand Admin | N | - | Uses Brand-level user management |
| Store Manager | N | - | No access |

---

## 5. Data Model

### Primary Entities

- **User** - Platform user accounts
  - Key fields: user_id, email, first_name, last_name, role, tenant_id, status, mfa_enabled, created_at, last_login
- **Role** - System role definitions
  - Key fields: role_id, name, permissions[], scope_type
- **UserSession** - Active user sessions
  - Key fields: session_id, user_id, created_at, expires_at, ip_address
- **ImpersonationLog** - Impersonation history
  - Key fields: log_id, impersonator_id, target_user_id, reason, start_time, end_time

### Relationships

![10_Module_PlatformAdmin_screens_A002_User_Management_diagram_0](../../diagrams_rendered/10_Module_PlatformAdmin_screens_A002_User_Management_diagram_0.png)

---

## 6. APIs

### Internal APIs

| Endpoint | Method | Purpose |
|----------|--------|---------|
| /api/v1/admin/users | GET | List users with filtering |
| /api/v1/admin/users | POST | Create new user |
| /api/v1/admin/users/{id} | GET | Get user details |
| /api/v1/admin/users/{id} | PUT | Update user |
| /api/v1/admin/users/{id} | DELETE | Delete/deactivate user |
| /api/v1/admin/users/{id}/sessions | GET | Get user's active sessions |
| /api/v1/admin/users/{id}/sessions | DELETE | Terminate user sessions |
| /api/v1/admin/users/{id}/mfa/reset | POST | Reset user's MFA |
| /api/v1/admin/users/{id}/impersonate | POST | Start impersonation session |
| /api/v1/admin/roles | GET | List available roles |

### External Integrations

| System | Purpose | Data Flow |
|--------|---------|-----------|
| Auth Provider | SSO/OAuth integration | Bidirectional |
| Email Service | User invitation emails | Outbound |

---

## 7. Business Rules

- BR-A002-01: Platform Admin cannot delete other Platform Admins (requires direct DB access)
- BR-A002-02: MFA is mandatory for Platform Admin, PSP Admin, and Brand Admin roles (per SUPP-003)
- BR-A002-03: User deletion is soft-delete; records retained for audit compliance
- BR-A002-04: PSP Admin can only manage users within their tenant
- BR-A002-05: Impersonation requires reason field and creates audit trail
- BR-A002-06: Impersonation sessions expire after 30 minutes (hard limit: 2 hours)
- BR-A002-07: Password reset triggers mandatory password change on next login
- BR-A002-08: Account lockout after 5 failed login attempts (15-minute cooldown)
- BR-A002-09: Support Agent can only impersonate Store Users in read-only mode

---

## 8. UI Components

### User List Table

| Column | Description | Sortable | Filterable |
|--------|-------------|----------|------------|
| Name | User full name | Yes | Yes |
| Email | User email address | Yes | Yes |
| Role | Assigned role | Yes | Yes (dropdown) |
| Tenant | Tenant name | Yes | Yes (dropdown) |
| Status | Active/Inactive/Locked | Yes | Yes (dropdown) |
| MFA | MFA enabled status | Yes | Yes (toggle) |
| Last Login | Last login timestamp | Yes | Yes (date range) |
| Actions | Edit, Impersonate, Delete | No | No |

### User Detail Panel

- Profile Information (editable)
- Role Assignment
- Permission Overrides (if applicable)
- MFA Settings
- Session History
- Impersonation History
- Audit Trail (recent actions by user)

### Bulk Actions

- Enable/Disable selected users
- Force password reset
- Export user list (CSV)

---

## 9. State Transitions

![10_Module_PlatformAdmin_screens_A002_User_Management_diagram_1](../../diagrams_rendered/10_Module_PlatformAdmin_screens_A002_User_Management_diagram_1.png)

---

## 10. Acceptance Criteria

- [ ] AC-A002-01: Platform Admin can create users in any tenant
- [ ] AC-A002-02: PSP Admin can only see and manage users in their tenant
- [ ] AC-A002-03: User creation sends invitation email
- [ ] AC-A002-04: Role assignment updates permissions immediately
- [ ] AC-A002-05: Impersonation requires reason and creates audit event
- [ ] AC-A002-06: Impersonation session shows banner to impersonated user
- [ ] AC-A002-07: MFA reset requires confirmation
- [ ] AC-A002-08: Bulk actions apply to selected users only
- [ ] AC-A002-09: User search returns results within 500ms
- [ ] AC-A002-10: Deleted users cannot log in but records are retained

---

## 11. Related Documents

- SUPP-003 - RBAC and Permissions Matrix
- SUPP-031 - Supportability, Logs, and Impersonation
- SRS-4.2 - Permission Matrix
- SRS-4.4.1 - Platform Admin Persona

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*
