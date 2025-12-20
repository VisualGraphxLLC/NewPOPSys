Date: 2025-12-17

Purpose: Lock the v1 engineering stack and operational decisions so the build (human or agentic) is deterministic. This ADR is authoritative for repo setup, infra modules, and CI/CD gates.

# Decisions Locked (v1 Defaults)

  ------------------------------------------------------------------------------------------
  Area                                Selection
  ----------------------------------- ------------------------------------------------------
  Hosting                             AWS (ECS Fargate or App Runner)

  Database                            PostgreSQL (RDS)

  Cache/Queue                         Redis (ElastiCache) + BullMQ

  Object Storage                      S3 (presigned uploads)

  CDN                                 CloudFront

  Email                               SES (or SendGrid as swap)

  Webhooks                            Outbox pattern + retry worker (BullMQ)

  Error Tracking                      Sentry

  Observability                       OpenTelemetry + structured logs (JSON) + request IDs

  CI/CD                               GitHub Actions

  Environments                        dev + staging + prod (staging required for pilots)

  Auth (web)                          Session cookies (server)

  Auth (integration)                  API keys + HMAC webhooks + Idempotency-Key

  i18n                                next-intl (English v1; scaffold Spanish)

  File scanning                       Optional (ClamAV or provider scan) scaffold only
  ------------------------------------------------------------------------------------------

# Rationale (Short)

- AWS + RDS Postgres + S3 is the lowest-friction path for a multi-tenant, media-heavy workflow app at pilot scale.

- Sentry accelerates pilot stabilization; OpenTelemetry gives portability if you switch observability vendors later.

- Session cookies for the web app keep UX sane; API keys + signed webhooks keep integrations simple and auditable.

- next-intl keeps i18n clean with Next.js; Spanish scaffold is prepared without shipping translations prematurely.

# Reference Architecture (v1)

- Frontend: Next.js (React) --- app router acceptable; PWA scaffold for store execution.

- Backend: TypeScript Node.js services (can be Next API routes or a separate Fastify/Nest service).

- Data: Postgres (JSONB for survey schemas/responses + relational constraints for fulfillment/execution).

- Media: S3 objects; DB stores metadata + pointers; all uploads via presigned URLs; thumbnails optional.

- Async: BullMQ workers for exports, webhooks retries, purge jobs, email digests.

# Non-Functional Requirements (v1)

  --------------------------------------------------------------------------------------------------------------------------------
  Category                            Requirement
  ----------------------------------- --------------------------------------------------------------------------------------------
  Security                            HMAC signed webhooks; API keys hashed; least privilege scopes; audit events for all writes

  Reliability                         Outbox pattern for webhooks; idempotent inbound writes; retries + dead-letter

  Performance                         Index store selection fields; paginate all list endpoints; lazy-load proof media

  Data retention                      90-day heavy media purge jobs; export bundle before purge (Option A)

  Testing gates                       Unit + contract tests + Playwright smoke for vertical slice; lint/typecheck required
  --------------------------------------------------------------------------------------------------------------------------------

# Implementation Notes (To Prevent Rewrites)

- Adopt an event envelope format early (SUPP-006).

- Use stable IDs everywhere; exports should never depend on internal DB row order.

- Treat survey versions as immutable; pin to assignments; require explicit rebase workflow.

- Use migration tooling (Prisma/Drizzle/Knex) but enforce SQL-level constraints for core relationships.

# Open Overrides (Allowed)

- Email provider can be swapped (SES ↔ SendGrid) without API changes.

- Hosting can move to GCP/Azure later if OpenTelemetry + containerized deployment is maintained.

- i18n language list can expand; keep keys stable from day 1.
