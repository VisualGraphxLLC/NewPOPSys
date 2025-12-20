Date: 2025-12-17

Purpose: Define how environments are configured (dev/staging/prod), how secrets are managed safely while supporting fast local/AI development, how PSP/Brand tenants are bootstrapped, and how staging gets reliable synthetic data for continuous testing.

# Locked Decisions

  ---------------------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- ---------------------------------------------------------------------------
  Secrets management                  Hybrid: Dev = .env files (1C); Production = AWS Secrets Manager (1A)

  Tenant bootstrap                    2A --- PSP Admin creates PSP + Brand via UI wizard

  Environment config approach         3A --- Per-env config files + env vars

  Staging seeding                     4A --- Required: synthetic tenants/brands/stores/campaigns seeded nightly
  ---------------------------------------------------------------------------------------------------------------

# 1) Secrets Management (Hybrid)

- Local Dev: .env files and docker-compose secrets for speed and simplicity.

- Staging/Production: AWS Secrets Manager is the source of truth; secrets are injected at deploy time.

- Never commit secrets. Provide .env.example with placeholders and required keys.

## Required Secrets (Draft)

  --------------------------------------------------------------------------------------------------------------------------------
  Category                            Keys (examples)
  ----------------------------------- --------------------------------------------------------------------------------------------
  Auth                                SESSION_SECRET, CSRF_SECRET

  Database                            DATABASE_URL

  Redis/Queues                        REDIS_URL

  Storage                             S3_BUCKET, S3_REGION, S3_ACCESS_KEY_ID\*, S3_SECRET_ACCESS_KEY\* (prefer IAM roles in AWS)

  Email                               SES_REGION, SES_FROM_ADDRESS

  Integrations                        WEBHOOK_SIGNING_SECRET, API_KEY_HASH_SALT

  Observability                       SENTRY_DSN (prod), OTEL_EXPORTER\_\* (optional)
  --------------------------------------------------------------------------------------------------------------------------------

\*Prefer IAM task roles in AWS so you don't store long-lived access keys.

# 2) Environment Config (3A)

- Configuration is layered: base config → environment overlay → env vars override.

- Keep env-specific files in repo (no secrets), e.g., config/dev.json, config/staging.json, config/prod.json.

- All configs validate at startup (Zod). Fail fast if missing/invalid.

Config items (examples): feature flag defaults, retention defaults, webhook retry policy, export size guards, late-shipping thresholds default, S3 bucket name, allowed upload mime types.

# 3) Tenant Bootstrap (2A)

- UI Wizard (PSP Admin): Create PSP Tenant → Create Brand Admin user → Create first Brand → Invite additional admins.

- Wizard also initializes: default roles, default notification endpoints (disabled), default feature flags (off), and starter export profiles.

- All actions audited with correlationId.

## Bootstrap Acceptance Criteria

1.  A PSP Admin can create a tenant and first brand in \<5 minutes.

2.  Brand Admin receives invite, can log in, and sees guided next steps (import stores, build survey, create campaign).

3.  No tenant can access another tenant's data (app enforcement; RLS scaffolded per SUPP-020).

# 4) Staging Seeding (4A)

- Nightly seed job resets/refreshes synthetic datasets in staging (or creates new test tenants).

- Seed includes: PSP tenants, brands, regions/groups, stores, survey templates, campaigns, orders, shipments, proofs (synthetic), review outcomes.

- Seed is deterministic: use fixed RNG seeds and stable IDs where possible for test reproducibility.

## Seed Mechanism (Recommended)

- Seed scripts live in packages/db (Drizzle) and are runnable via CI.

- Optionally: seed API endpoints in staging only (protected) for Playwright E2E setup.

- Do not seed production.

# Operational Guardrails

- Retention purge jobs default to dry-run in staging until explicitly enabled per tenant.

- Uploads in staging can use a separate bucket with lifecycle rules to auto-clean media.

- Audit logging in staging is on; sample data volumes should reflect pilot scale (\~1000 stores/brand).

# Definition of Done (Module 24)

4.  Secrets model implemented: .env local; Secrets Manager for prod; no secrets in repo.

5.  Validated configuration loader exists and is used by web/api/worker.

6.  Tenant bootstrap wizard implemented and audited.

7.  Nightly staging seed job exists and supports Playwright smoke/E2E.

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
