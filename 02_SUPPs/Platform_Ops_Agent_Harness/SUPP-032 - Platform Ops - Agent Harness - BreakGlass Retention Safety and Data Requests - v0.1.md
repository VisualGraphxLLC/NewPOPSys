Date: 2025-12-17

Purpose: Define production safety controls for break-glass operations, retention purge activation, dry-run enforcement, and how personal-data deletion requests are handled in v1. Includes post-v1 exploration for tenant data takeout/export.

# Locked Decisions

  -------------------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- -------------------------------------------------------------------------
  Break-glass approval                1B --- Two-person rule in production (A single sysadmin allowed in dev)

  Retention purge in prod             2A --- Default OFF; enable per tenant via feature flag

  Retention purge mode                3A --- Dry-run first 2 weeks, then enforce

  GDPR / delete requests              4A --- Not in v1 workflow; log request + manual process
  -------------------------------------------------------------------------------------------------------------

# 1) Break-Glass Two-Person Rule (Prod)

- Production break-glass actions (DB edits, forced state repairs, bulk changes) require two distinct approvers.

- Approver roles: Sysadmin Executor + Sysadmin Approver (cannot be same user).

- Dev/staging may allow single sysadmin, but still audited.

## Break-Glass Workflow (Minimum)

1.  Create BreakGlassRequest (includes tenantId, reason, intended SQL/actions, rollback plan).

2.  Approver reviews and approves (or rejects) with comment.

3.  Executor performs action and attaches executed SQL/script outputs.

4.  System records completion + validation checklist results.

5.  Auto-create incident record if severity threshold met (or link to existing incident).

# 2) Retention Purge Activation (2A)

- Retention purge is OFF by default in production for all tenants.

- Enable per tenant via feature flag (SUPP-023) after pilot validation.

- Retention policies follow the classification policy (SUPP-008) and respect exempt records.

# 3) Retention Dry-Run → Enforce (3A)

- First 2 weeks after enablement: dry-run only. System reports what WOULD be deleted.

- After 2 weeks: flip to enforce, with the option to return to dry-run if anomalies detected.

- Dry-run reports are exportable and can be delivered to admins.

  --------------------------------------------------------------------------------------------------------
  Mode                                Behavior
  ----------------------------------- --------------------------------------------------------------------
  DRY_RUN                             Compute candidates; write retention_candidate log; no deletion

  ENFORCE                             Delete eligible media blobs; update records; write audit + metrics
  --------------------------------------------------------------------------------------------------------

# 4) Data Deletion / 'Delete My Data' Requests (4A)

- v1: No automated GDPR workflow; system provides a place to log requests and track status manually.

- Requests include: requester identity, scope, tenant/brand/store, timeframe, and disposition.

- Manual fulfillment can include: redaction, anonymization, or export-and-delete as appropriate.

## Post-v1: Data Takeout Exploration

- Explore tenant/brand-level data export ("Takeout") as a standardized package.

- Package includes: campaign records, exports, audit logs, and optionally media pointers (or bundled media).

- This is a future module; add to backlog once v1 stabilizes.

# Acceptance Criteria

6.  Production break-glass requires two-person approval and is fully audited.

7.  Retention purge is tenant-flagged and default off; dry-run mode produces reports for 2 weeks before enforce.

8.  Manual data deletion requests can be logged and tracked with auditability.

9.  Core SOW references this policy and aligns retention jobs with safe defaults.
