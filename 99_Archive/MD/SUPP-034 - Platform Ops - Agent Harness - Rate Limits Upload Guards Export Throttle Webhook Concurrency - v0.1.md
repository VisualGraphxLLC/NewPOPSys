Date: 2025-12-17

Purpose: Prevent a single user/store/tenant from overwhelming the system. Defines rate limiting, upload constraints, export throttling, and webhook concurrency controls.

# Locked Decisions

  ----------------------------------------------------------------------------------------------
  Control Area                           Decision
  -------------------------------------- -------------------------------------------------------
  API rate limiting                      1A --- Per user + per IP + per tenant

  Upload limits (per store submission)   2A --- Max files + max total MB per survey submission

  Export throttling                      3A --- Limit concurrent exports per tenant

  Webhook throttling                     4A --- Per endpoint concurrency limit + queue
  ----------------------------------------------------------------------------------------------

# 1) API Rate Limiting

- Enforce at API gateway/middleware layer with tenant-aware keys.

- Limit dimensions: tenantId, userId (if present), IP address, and route group.

- Return 429 with Retry-After header; log structured event with requestId/correlationId where available.

  --------------------------------------------------------------------------
  Route Group             Suggested Default (v1)   Notes
  ----------------------- ------------------------ -------------------------
  Auth/session            20/min per IP            Protect login endpoints

  General API             300/min per user         Tenant + user enforced

  Uploads presign         60/min per user          Protect storage costs

  Exports create          10/min per tenant        Exports are heavy
  --------------------------------------------------------------------------

# 2) Upload Guards (Store Submission)

- Each survey submission enforces: max file count + max total bytes + allowed mime types.

- Per-photo max MB guard plus total submission cap.

- Client shows progress and warns before upload; server remains source of truth.

  ----------------------------------------------------------------------------------------
  Guard                         Suggested Default (v1)   Notes
  ----------------------------- ------------------------ ---------------------------------
  Max photos per submission     20                       Configurable per brand/campaign

  Max MB per photo              15 MB                    Allows modern phone images

  Max total MB per submission   200 MB                   Protects abuse + timeouts

  Allowed mime types            image/jpeg, image/png    Scaffold video later
  ----------------------------------------------------------------------------------------

# 3) Export Throttling

- Exports run as async jobs (worker).

- Per-tenant concurrency limit prevents resource starvation.

- Queue prioritization: operational exports (support) \> scheduled reports \> bulk dumps.

  -----------------------------------------------------------------------
  Constraint                          Suggested Default (v1)
  ----------------------------------- -----------------------------------
  Concurrent exports per tenant       2

  Concurrent exports system-wide      10 (scales with workers)

  Max export size                     Config guard (rows/MB) + chunking
  -----------------------------------------------------------------------

# 4) Webhook Concurrency Throttle

- Each webhook endpoint has a concurrency limit (in-flight requests).

- Deliveries are queued; retry/replay rules per SUPP-027.

- If endpoint is consistently slow/failing: circuit breaker can temporarily pause sends and alert admins.

  ----------------------------------------------------------------------------
  Setting                             Suggested Default (v1)
  ----------------------------------- ----------------------------------------
  Max in-flight per endpoint          2

  Request timeout                     10s

  Circuit breaker                     Open after N failures; cool-down 5 min
  ----------------------------------------------------------------------------

# Config & Feature Flags

- All limits are configurable per environment; production defaults are conservative.

- Allow per-tenant overrides for large brands after validation.

- Expose only SAFE knobs in UI; other knobs remain config-only.

# Acceptance Criteria

1.  Rate limiting returns 429 and does not crash the service under burst traffic.

2.  Upload submissions enforce count/size/mime guards server-side.

3.  Export jobs respect per-tenant concurrency and do not starve other tenants.

4.  Webhook deliveries respect per-endpoint concurrency and queue/retry behavior is observable (logs/metrics).
