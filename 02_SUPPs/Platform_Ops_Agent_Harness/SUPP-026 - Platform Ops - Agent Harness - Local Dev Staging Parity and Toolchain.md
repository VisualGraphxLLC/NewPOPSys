Date: 2025-12-17

Purpose: Define the local development toolchain and how it mirrors staging/prod enough to prevent 'works on my machine' failures. Specifies docker-compose dependencies, local S3 emulation, email behavior, and local worker/job execution.

# Locked Decisions

  -----------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- -----------------------------------------------------------
  Local dev stack                     1A --- docker-compose (Postgres + Redis + MinIO optional)

  Local storage emulation             2A --- MinIO (S3-compatible)

  Email in dev/staging                3B --- MailHog locally + SES staging

  Background jobs locally             4A --- Run worker locally
  -----------------------------------------------------------------------------------------------

# 1) docker-compose Services (Local)

- postgres: local DB for development (schema via Drizzle migrations)

- redis: queue + caching

- minio: S3-compatible object storage for uploads

- mailhog: local SMTP inbox for email previews

Optional: adminer/pgadmin for DB inspection.

# 2) Local Storage (MinIO)

- MinIO bucket names should mirror staging bucket structure (e.g., tenant-based prefixes).

- Use presigned URL flow locally the same way as staging/prod to validate upload paths.

- Provide a local utility to reset buckets between runs (dev hygiene).

# 3) Email Behavior

- Local: send via SMTP to MailHog; do not send real emails.

- Staging: SES sandbox or staging domain; optionally suppress external recipients.

- Production: SES with verified sender domain; deliverability monitoring later.

# 4) Worker Execution (Local)

- Worker process runs locally consuming BullMQ queues from Redis.

- Queues enabled in local: webhooks (can target localhost), exports, retention dry-run, email.

- Jobs must be idempotent: re-running should not corrupt state.

# Developer Commands (Draft)

\`\`\`bash\
\# Start dependencies\
docker compose up -d\
\
\# Apply migrations\
pnpm db:migrate\
\
\# Seed minimal dataset (P0 smoke)\
pnpm db:seed:p0\
\
\# Run apps\
pnpm dev:web\
pnpm dev:api\
pnpm dev:worker\
\
\# Run smoke tests\
pnpm test:smoke\
\`\`\`

# Parity Rules (Prevent Drift)

- Same request/response Zod schemas across web/api.

- Same presigned upload flows across local/staging/prod.

- Same queue/job names and outbox retry logic across environments.

- Same OpenAPI drift check in CI (no 'local only' endpoints).

# Definition of Done (Module 26)

1.  docker-compose boots all dependencies with one command.

2.  MinIO uploads work using presigned URLs; media asset records are created correctly.

3.  MailHog captures invite + notification emails locally.

4.  Worker runs locally and processes exports/webhooks/retention dry-run without manual hacks.

5.  A new dev can onboard using README steps in \<30 minutes.

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
