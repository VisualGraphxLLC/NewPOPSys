Date: 2025-12-17

Purpose: Deterministic roles, permissions, and completion/override authority for v1. Authoritative for UI access rules, API authorization, and audit coverage.

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

  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Role                    Primary User                 Core Responsibility
  ----------------------- ---------------------------- -----------------------------------------------------------------------------------------------
  PSP_ADMIN               PSP leadership/admin         Tenant config, brand onboarding, permissions, security settings

  PSP_OPS                 PSP fulfillment team         Orders, batches, shipments, reorders, status updates (UI/API)

  BRAND_ADMIN             Brand program owner          Campaigns/kits, store selection, surveys/layouts, verification mode/SLA, overrides, reporting

  REGIONAL_ADMIN          Regional oversight           Exception monitoring, photo review, retakes, store reopen/waivers

  STORE_USER              Store manager/facilitator    Receive/verify/install, proofs, completion/attestation, issues, retakes/deinstall

  INTEGRATION_USER        Automation service account   Inbound API writes for fulfillment/shipments/batches; export triggers; webhook setup
  ----------------------------------------------------------------------------------------------------------------------------------------------------

# Tenancy & Scope Rules (v1)

- PSP is tenant root. Brand users operate only within their brand context unless explicitly granted by PSP.

- Regional admin scope is limited to configured regions/groups where applicable.

- Store users are single-store in v1; scaffold multi-store assignment later.

- Integration user is PSP-tenant-wide but still least-privileged by per-key permission set.

# Completion Authority (v1)

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Action                                    Who Can Do It                                       Audit Requirements
  ----------------------------------------- --------------------------------------------------- -----------------------------------------------------------------------------
  Normal store submit completion            STORE_USER                                          Completion survey + attestation

  Approve/reject photos                     REGIONAL_ADMIN, BRAND_ADMIN                         Reason codes required on rejection

  Waive missing required proofs             REGIONAL_ADMIN, BRAND_ADMIN                         Required reason; event store.completion_waived; record waived requirements

  Reopen completed store                    REGIONAL_ADMIN, BRAND_ADMIN                         Required reason; event store.reopened

  Force-complete campaign                   BRAND_ADMIN                                         Required reason; event campaign.force_completed; snapshot incomplete stores

  Approve reorders (when policy requires)   BRAND_ADMIN/REGIONAL_ADMIN/PSP_OPS (policy-based)   Decision recorded per issue line/request
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Permission Matrix (Minimum v1)

  -----------------------------------------------------------------------------------------------------------------------------
  Capability                              PSP_ADMIN   PSP_OPS    BRAND_ADMIN   REGIONAL_ADMIN   STORE_USER   INTEGRATION_USER
  --------------------------------------- ----------- ---------- ------------- ---------------- ------------ ------------------
  Manage tenant settings                  Y           N          N             N                N            N

  Onboard brand (skeletonize)             Y           N          N             N                N            N

  Invite/manage users                     Y           Y\*        Y             Y\*              N            N

  Create/edit stores & groups             Y           Y\*        Y\*           Y\*              N            Y\*

  Create/edit layouts & surveys           Y           N          Y             Y\*              N            N

  Submit store survey responses           N           N          Y\*           Y\*              Y            N

  Create campaigns & assign stores        Y           N          Y             Y\*              N            N

  Configure verificationMode + SLA        Y\*         N          Y             Y\*              N            N

  View orders (totals + store)            Y           Y          Y             Y                N            Y

  Update order status                     Y           Y          N             N                N            Y

  Create/update shipments + tracking      Y           Y          N             N                N            Y

  Manage batches                          Y           Y          N             N                N            Y

  Execute store tasks (receive/install)   N           N          N             N                Y            N

  Upload proofs + completion survey       N           N          N             N                Y            N

  Review/approve/reject proofs            N           N          Y             Y                N            N

  Submit issues/reorders                  N           N          N             N                Y            N

  Approve/reject issues (policy-based)    Y\*         Y\*        Y\*           Y\*              N            N

  Trigger exports                         Y           Y          Y             Y                Y\*          Y\*

  View audit logs                         Y           Y          Y             Y                Y\*          Y\*
  -----------------------------------------------------------------------------------------------------------------------------

\* = limited to assigned brand/region/store scope; integration keys are least-privileged even if tenant-wide.

# Security Requirements (v1)

- API keys stored hashed; shown only at creation; rotation + revoke supported; per-key audit trail.

- Idempotency required for integration writes; rate limits per key; anomaly detection for excessive failures.

- All permissioned writes emit immutable AuditEvents; integration writes include idempotency key reference.
