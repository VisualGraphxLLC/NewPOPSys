Date: 2025-12-17

Purpose: Ensure production pilots are diagnosable. Defines request correlation strategy, structured logging, OpenTelemetry tracing (scaffold with optional enablement), and how audit events link to runtime requests and async jobs.

# Locked Decisions

  ---------------------------------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- ---------------------------------------------------------------------------------------
  Request correlation                 1B --- Optional X-Request-Id (system generates if missing; not required from clients)

  Log format                          2A --- JSON structured logs everywhere

  Tracing                             3A/B --- OpenTelemetry scaffolded; enabled in staging/prod, optional in local dev

  Audit correlation                   4A --- Every audit_event includes correlationId + requestId
  ---------------------------------------------------------------------------------------------------------------------------

# 1) Correlation IDs & Request IDs

- correlationId: UUIDv7 used to link multi-step workflows across entities (campaign → orders → shipments → execution → exports).

- requestId: per-request identifier for runtime observability; system generates if client doesn't send X-Request-Id.

- Async jobs must carry both correlationId and a jobId; job executions emit their own requestId for each attempt.

# 2) Structured Logging (2A)

All services (web/api/worker) emit JSON logs with consistent fields.

  -----------------------------------------------------------------------------
  Field                               Notes
  ----------------------------------- -----------------------------------------
  timestamp                           ISO8601

  level                               debug\|info\|warn\|error

  service                             web\|api\|worker

  env                                 dev\|staging\|prod

  requestId                           generated if missing

  correlationId                       present when available

  tenantId                            PSP tenant scope

  brandId/campaignId/storeId          optional context when known

  route                               HTTP route or job name

  durationMs                          request/job duration

  error                               structured error object when applicable
  -----------------------------------------------------------------------------

# 3) Tracing (OpenTelemetry) (3A/B)

- OpenTelemetry SDK integrated in api + worker (web optional).

- Enabled by config in staging/prod; can be disabled in local dev for simplicity.

- Trace context propagates correlationId and requestId into spans as attributes.

- Exporters: start with OTLP (Collector), or vendor agent later; do not hard-couple vendor.

# 4) Audit Correlation (4A)

- audit_event schema includes: correlation_id + request_id + actor + entity type/id + before/after.

- Every state transition writes audit_event in the same transaction where possible.

- For async jobs: audit_event includes jobId and attempt_count in details JSON.

# 5) Minimum Dashboards/Views (v1)

- Delivery logs: webhook_delivery + email suppressions (SUPP-027).

- Job health: queue depth, job failures by type, retry counts.

- API health: p95 latency by route, 5xx rate, top error codes.

- Audit explorer (PSP Admin): filter by correlationId to see end-to-end chain.

# Acceptance Criteria

1.  All services emit JSON logs with requestId; requestId is generated when absent.

2.  correlationId is propagated through HTTP requests, async jobs, and persisted in audit_event.

3.  OpenTelemetry spans appear in staging/prod with route/job names and error status.

4.  Investigating a pilot incident is possible using (tenantId + correlationId) without manual guesswork.

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
