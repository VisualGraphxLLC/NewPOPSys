Date: 2025-12-17

Purpose: Define how NewPOPSys is supported during pilots and production. Covers support roles, when direct DB edits are permissible, incident documentation, and user impersonation with strong audit controls.

# Locked Decisions

  ------------------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- ------------------------------------------------------------------------
  Support roles access                1B --- PSP Admin + Support Agent role (read-only + replay permissions)

  Production data changes             2B --- DB edits allowed by sysadmin (break-glass)

  Incident response                   3A --- Incident record + correlationId required (B informal fallback)

  User impersonation                  4A --- Allowed (even in production) with audit + explicit banner
  ------------------------------------------------------------------------------------------------------------

# 1) Support Roles & Permissions (1B)

- Support Agent (PSP-level): read-only access across tenant; can view Delivery Log, Audit Explorer, and initiate manual webhook replay (per SUPP-027).

- Support Agent cannot change business data (stores/campaigns/orders) except operational actions explicitly allowed (e.g., replay deliveries).

- PSP Admin retains full administrative capabilities (tenant/brand management, feature flags, user management).

RBAC note: Support Agent permissions must be explicitly enumerated in SUPP-003 RBAC matrix.

# 2) Production Data Changes --- DB Edits (2B)

- Direct DB edits are permitted only as a break-glass procedure when the UI/API cannot resolve a production issue fast enough.

- DB edits must be performed by a designated sysadmin role and should be the exception, not the default.

- Every DB edit requires an accompanying incident record and post-change validation steps.

## 2.1 Break-Glass Requirements (Minimum)

1.  Create an incident record first (or immediately after if time-critical).

2.  Record tenantId + correlationId(s) impacted, and exact tables/rows/fields changed.

3.  Capture the SQL executed (or migration script) and store it with the incident record.

4.  Run validation checklist: affected API endpoints, UI screens, and any downstream events.

5.  If edits bypass outbox events, create compensating outbox events or document why not.

## 2.2 Recommended Guardrail (Even though DB edits are allowed)

- Create a small internal \'Admin Repair Tools\' set over time to reduce DB edits.

- When a DB edit happens, log a tech debt issue with a recommended admin tool feature to prevent future repeats.

# 3) Incident Process (3A with B fallback)

- Formal: create incident record with severity, impacted tenants/brands, timeline, and correlationId(s).

- Fallback: informal notes allowed during chaos, but must be converted into an incident record within 24 hours.

  ------------------------------------------------------------------------
  Incident Field                      Notes
  ----------------------------------- ------------------------------------
  incidentId                          UUIDv7

  severity                            S1--S4

  tenantId/brandId                    Scopes impacted

  correlationIds                      Primary diagnostic join key

  symptoms                            User-visible behavior

  rootCause                           Best-known cause

  fix                                 Actions taken (including DB edits)

  followUps                           Preventative work items
  ------------------------------------------------------------------------

# 4) User Impersonation (4A)

- PSP Admin and Support Agent can impersonate users to reproduce issues (including in production).

- Impersonation must be obvious: persistent banner + different color theme + \'Stop impersonating\' control.

- All actions during impersonation are audited with both: acting_support_user_id AND impersonated_user_id.

- Impersonation is time-bounded (default 30 minutes) and can be ended early.

## 4.1 Impersonation Controls

- Require reason text when starting impersonation (stored in audit event).

- Block high-risk actions while impersonating unless PSP Admin explicitly overrides (feature-flagged).

- Record IP/device metadata in audit trails where feasible.

# Acceptance Criteria

6.  Support Agent role exists and can access Delivery Log + Audit Explorer + manual replay actions.

7.  Impersonation works with required banner, time limit, and dual-actor auditing.

8.  Incident records can be created and linked to correlationId.

9.  DB break-glass procedure is documented and used consistently when DB edits occur.

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
