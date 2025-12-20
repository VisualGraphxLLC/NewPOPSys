Date: 2025-12-17

Purpose: Implement feature flags as a first-class platform capability to safely ship AI-driven development into staging and selectively expose pilot features in production. Defines DB model, evaluation precedence, admin UX, and audit requirements.

# Locked Decisions

  ----------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- ----------------------------------------------
  Storage                             1A --- DB-backed feature flags

  Evaluation scope                    2C --- tenant + brand + campaign + store

  Admin UX placement                  3A --- In-app (PSP Admin only)

  Audit rules                         4A --- Audit every change (who/when/old/new)
  ----------------------------------------------------------------------------------

# 1) Data Model (DB-backed)

- feature_flag: id(UUIDv7), key, description, created_at, created_by

- feature_flag_rule: id(UUIDv7), flag_id, enabled(bool), scope_type(enum), scope_id(uuid), priority(int), constraints_json, created_at

- feature_flag_audit: id(UUIDv7), flag_id, actor_type, actor_id, before_json, after_json, occurred_at, correlation_id

Scope types (enum): TENANT, BRAND, CAMPAIGN, STORE, USER (USER is scaffold only unless required).

# 2) Evaluation Precedence (Deterministic)

- Most specific wins: STORE → CAMPAIGN → BRAND → TENANT → DEFAULT.

- If multiple rules exist at same scope, highest priority wins (then newest wins as tiebreak).

- Rules evaluated by context: {tenantId, brandId?, campaignId?, storeId?, userId?}.

- Evaluation result can be cached per request; optional short TTL cache across requests for performance.

# 3) Admin UX (PSP Admin Only)

- Screen: Platform Settings → Feature Flags.

- List flags with search + filter by key and scope.

- Flag detail shows rule table (scope, enabled, priority, constraints) and audit history.

- PSP Admin can create flags and rules; Brand admins cannot modify flags by default (scaffold future delegation).

# 4) Audit Requirements (4A)

- Every create/update/delete of a flag or rule emits an audit event.

- Audit includes before/after snapshots and actor identity.

- Flag changes in production are tagged with environment to support investigations.

# Performance Notes

- Index feature_flag_rule on (flag_id, scope_type, scope_id, priority).

- If evaluation becomes hot: add Redis cache keyed by (tenantId, brandId, campaignId, storeId) with short TTL.

# Acceptance Criteria

1.  PSP Admin can create a feature flag, add rules at tenant/brand/campaign/store scope, and evaluation matches precedence rules.

2.  Evaluation is deterministic and test-covered.

3.  All flag changes are audited and visible in the UI.

4.  Flags can gate UI features and backend behaviors consistently.
