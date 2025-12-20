# SUPP-003 — RBAC and Permissions Matrix

> **Version**: v0.7
> **Status**: Locked
> **Updated**: 2025-12-20
> **Dependencies**: SUPP-001 (Personas), SUPP-031 (Supportability)

---

## Purpose

Deterministic roles, permissions, and completion/override authority for v1. Authoritative for UI access rules, API authorization, and audit coverage.

# Locked Inputs

  --------------------------------------------------------------------------------------------------------------------------------------------------
  Decision                            Value
  ----------------------------------- --------------------------------------------------------------------------------------------------------------
  Pilot PSP                           Speedy CPS / Alpha Graphics (plus Visual Graphx pilot PSP)

  Pilot Brand                         Good2Go

  Auth (v1)                           Email + password

  Integration scope                   PSP-tenant-wide service account across all brands within PSP tenant

  Completion overrides                Brand/Regional can waive missing proofs; Brand can force-complete campaign; reopen allowed (reason required)
  --------------------------------------------------------------------------------------------------------------------------------------------------

# Default Roles (v1)

## PSP Level (Platform & Print Service Provider)

| Role | Primary User | Permission Level | Core Responsibility |
|------|-------------|------------------|---------------------|
| Platform Admin | PSP leadership | All Privileged + Impersonate | Full system configuration, tenant management, user impersonation for support, security & audit access |
| PSP Admin | PSP admin staff | PSP All Privileged | Brand onboarding, PSP-level settings, user management, reporting & exports |
| Production Operator | PSP fulfillment team | Status & Shipping Updates | Update order statuses, create shipments & tracking, process batches, view fulfillment queues |
| Support Agent | PSP support staff | Read-Only + Debug | View all orders/shipments/issues, access audit logs, replay failed webhooks, impersonate Store Users (read-only) |

> **Note:** Support Agent uses `PSP_OPS` role enum with `support_scope = true` flag. Cannot modify any data or approve/deny anything. Per decision D17.

## Brand Level (Brand & Campaign Management)

| Role | Primary User | Permission Level | Core Responsibility |
|------|-------------|------------------|---------------------|
| Brand Admin | Brand program owner | Brand Level Privileged | Full brand configuration, all campaigns access, store management, user permissions |
| Campaign Manager | Brand campaign staff | Must be assigned to campaigns | Build new campaigns, manage assigned campaigns, define kits & photo rules, review proofs & approve |
| Regional Manager | Regional oversight | Store Compliance for segment | Oversee assigned stores, exception queue management, approve/reject proofs, escalate to Brand Admin |

## Store Level (Store Execution)

| Role | Primary User | Permission Level | Core Responsibility |
|------|-------------|------------------|---------------------|
| Store Manager | Store management | Full Store Privileges | Manage store team, approve replacement requests, view all store campaigns, full execution permissions |
| Store Operator | Store staff | View Only + Execution | Complete surveys, update status, request replacements (needs Store Manager approval), view assigned campaigns |

## System (Integration)

| Role | Primary User | Permission Level | Core Responsibility |
|------|-------------|------------------|---------------------|
| Integration User | Automation service account | API & Webhook Service Account | Inbound API writes, webhook consumption, export triggers, MIS integration |

# Tenancy & Scope Rules (v1)

- PSP is tenant root. Brand users operate only within their brand context unless explicitly granted by PSP.

- Platform Admin has tenant-wide access including impersonation capabilities for support.

- PSP Admin scope is limited to their PSP tenant; cannot impersonate users.

- Production Operator scope is limited to fulfillment operations; no admin capabilities.

- Brand Admin has full brand-level access; can manage all campaigns and users within brand.

- Campaign Manager scope is limited to campaigns they are explicitly assigned to.

- Regional Manager scope is limited to stores within their assigned regions/groups.

- Store Manager has full store-level access; can approve replacement requests from Store Operators.

- Store Operator scope is limited to viewing and executing assigned tasks; replacement requests require Store Manager approval.

- Integration User is PSP-tenant-wide but still least-privileged by per-key permission set.

# Completion Authority (v1)

| Action | Who Can Do It | Audit Requirements |
|--------|---------------|-------------------|
| Normal store submit completion | Store Manager, Store Operator | Completion survey + attestation |
| Request replacement items | Store Operator (requires Store Manager approval) | Request reason; Store Manager decision recorded |
| Approve replacement requests | Store Manager | Approval/denial recorded with reason |
| Approve/reject photos | Regional Manager, Campaign Manager*, Brand Admin | Reason codes required on rejection |
| Waive missing required proofs | Regional Manager, Brand Admin | Required reason; event store.completion_waived; record waived requirements |
| Reopen completed store | Regional Manager, Brand Admin | Required reason; event store.reopened |
| Force-complete campaign | Brand Admin | Required reason; event campaign.force_completed; snapshot incomplete stores |
| Approve reorders (when policy requires) | Brand Admin, Regional Manager, Production Operator (policy-based) | Decision recorded per issue line/request |

*Campaign Manager can only approve/reject for campaigns they are assigned to.

# Permission Matrix (Minimum v1)

## PSP Level Permissions

| Capability | Platform Admin | PSP Admin | Production Operator | Support Agent |
|------------|----------------|-----------|---------------------|---------------|
| Manage tenant settings | Y | N | N | N |
| Impersonate users | Y | N | N | Y* (Store Users, read-only) |
| Onboard brand (skeletonize) | Y | Y | N | N |
| Invite/manage PSP users | Y | Y | N | N |
| View all brands/campaigns | Y | Y | Y (read-only) | Y (read-only) |
| View orders (totals + store) | Y | Y | Y | Y (read-only) |
| Update order status | Y | Y | Y | N |
| Create/update shipments + tracking | Y | Y | Y | N |
| Manage batches | Y | Y | Y | N |
| Approve/reject issues (policy-based) | Y | Y | Y* | N |
| Trigger exports | Y | Y | Y* | N |
| View audit logs | Y | Y | Y* | Y (read-only) |
| Webhook/API configuration | Y | Y | N | N |
| Replay failed webhooks | Y | Y | N | Y (retry only) |
| Access audit explorer | Y | Y | Y* | Y (read-only) |

## Brand Level Permissions

| Capability | Brand Admin | Campaign Manager | Regional Manager |
|------------|-------------|------------------|------------------|
| Full brand configuration | Y | N | N |
| Invite/manage brand users | Y | N | N |
| Create/edit stores & groups | Y | N | N |
| Create/edit layouts & surveys | Y | Y* | N |
| Create campaigns & assign stores | Y | Y | N |
| Configure verificationMode + SLA | Y | Y* | N |
| View all campaigns | Y | Assigned only | Assigned stores only |
| Review/approve/reject proofs | Y | Y* | Y* |
| Waive missing proofs | Y | N | Y* |
| Reopen completed store | Y | N | Y* |
| Force-complete campaign | Y | N | N |
| Approve/reject issues (policy-based) | Y | Y* | Y* |
| Trigger exports | Y | Y* | Y* |
| View audit logs | Y | Y* | Y* |

## Store Level Permissions

| Capability | Store Manager | Store Operator |
|------------|---------------|----------------|
| Manage store team | Y | N |
| View all store campaigns | Y | Assigned only |
| Execute store tasks (receive/install) | Y | Y |
| Upload proofs + completion survey | Y | Y |
| Submit replacement requests | Y | Y (requires approval) |
| Approve replacement requests | Y | N |
| View store reports | Y | N |
| Trigger exports | Y* | N |
| View audit logs | Y* | N |

## System Permissions

| Capability | Integration User |
|------------|------------------|
| Inbound API writes (orders/shipments) | Y |
| Webhook consumption | Y |
| Export triggers | Y* |
| Create/edit stores (via API) | Y* |
| View orders/shipments | Y |
| Update order status | Y |
| Create/update shipments | Y |

**Legend:**
- Y = Full access
- Y* = Limited to assigned scope (brand/region/store/campaign) or least-privileged
- N = No access

# Security Requirements (v1)

## Authentication

- **MFA Required:** Platform Admin, PSP Admin, Brand Admin roles MUST use MFA (TOTP or WebAuthn).
- **MFA Recommended:** Regional Manager, Production Operator roles SHOULD use MFA (enforced per tenant policy).
- **Store Users:** MFA optional (configurable per brand).
- Password policy: 12+ characters, complexity requirements, 90-day rotation for admin roles.

## Impersonation Controls

- **Session Limits:** Impersonation sessions expire after 30 minutes (hard limit: 2 hours max).
- **Audit Trail:** All impersonation sessions create start/end audit events with reason field.
- **Scope Restrictions:**
  - Platform Admin: Can impersonate any user except other Platform Admins
  - Support Agent: Can impersonate Store Users only, read-only session
  - All others: Cannot impersonate
- **Active Session Warning:** Original user sees banner when being impersonated.

## API Security

- API keys stored hashed; shown only at creation; rotation + revoke supported; per-key audit trail.
- Idempotency required for integration writes; rate limits per key; anomaly detection for excessive failures.
- All permissioned writes emit immutable AuditEvents; integration writes include idempotency key reference.
- Per-brand API key scoping available (v1.1 consideration for multi-brand PSPs).

## Audit & Compliance

- Audit log access scoped by role (Platform Admin: all, PSP Admin: tenant, Brand Admin: brand, Regional Manager: region).
- Audit logs retained for 7 years per COMPLIANCE retention class.
- Failed authentication attempts trigger lockout after 5 failures (15-minute cooldown).

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.5 | 2025-12-17 | Initial 6-role model with unified permission matrix; no impersonation controls or MFA requirements defined |
| v0.6 | 2025-12-18 | Added Support Agent role (PSP_OPS with support_scope flag per D17); split Store role into Manager/Operator for replacement approval workflow; added impersonation controls (30-min sessions, audit trails, scope restrictions) |
| v0.7 | 2025-12-20 | Added MFA requirements (mandatory for Platform/PSP/Brand Admins); separated permission matrix by level (PSP/Brand/Store/System); added API security section with idempotency and audit requirements; stable filename adopted |
