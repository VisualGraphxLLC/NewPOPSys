Date: 2025-12-17

Purpose: Define how the codebase is organized, how CI enforces build quality, and how we deliver the v1 vertical slice in a deterministic, agent-friendly order. This is the execution plan for Module 21.

# Locked Decisions (Module 21 Defaults)

  --------------------------------------------------------------------------------------------------------------------------------------------
  Decision                            Selection
  ----------------------------------- --------------------------------------------------------------------------------------------------------
  1\) Repo strategy (Monorepo)        A --- Turborepo monorepo (apps/web, apps/api, apps/worker, packages/shared)

  2\) Backend framework               A --- Fastify (lean, Zod-friendly). Alt: NestJS if you want heavier structure/DI

  3\) Validation                      A --- Zod shared schemas; OpenAPI generated + canonical YAML (per SUPP-020)

  4\) CI gates                        B --- lint + typecheck + unit + Playwright smoke + OpenAPI contract drift check

  5\) Deployment target (pilots)      A --- ECS Fargate (more control; easy to add worker service). Alt: App Runner if you want ultra-simple
  --------------------------------------------------------------------------------------------------------------------------------------------

# 1) What a Monorepo Is (Quick)

- A monorepo keeps web app + API + worker + shared packages in ONE git repo.

- Benefits: shared types/schemas, single CI pipeline, consistent linting/formatting, faster cross-module changes.

- Tradeoff: needs tooling to keep builds fast (Turborepo).

# 2) Recommended Repo Layout (Turborepo)

Draft folder structure:

\`\`\`text\
repo/\
apps/\
web/ \# Next.js UI (store, brand, PSP portals)\
api/ \# Fastify service (core domain APIs)\
worker/ \# BullMQ workers (webhooks, exports, retention purge, email digests)\
packages/\
shared/ \# Types, Zod schemas, OpenAPI gen utilities, enums, RBAC helpers\
db/ \# Drizzle schema + migrations + seed scripts\
ui/ \# Shared UI components (optional)\
openapi/\
v1.yaml \# Canonical OpenAPI spec (CI drift-gated)\
infra/\
terraform/ \# Optional IaC (ECS, RDS, S3, Redis)\
\`\`\`

# 3) Backend Framework (Fastify) --- Why

- Fastify is fast, minimal, and plays nicely with Zod schema validation.

- Easier for agentic development: fewer magic layers, smaller surface area, clearer debugging.

- NestJS remains an acceptable upgrade path if you later want stronger conventions, DI, decorators, etc.

# 4) Validation + OpenAPI (3A + 20.4C)

- All request/response models are defined in Zod in packages/shared.

- API uses those Zod schemas for runtime validation.

- OpenAPI is generated from Zod and compared against openapi/v1.yaml in CI to prevent drift.

- Exports and webhooks reuse the same schemas for consistency.

# 5) CI Gates (4B)

  -----------------------------------------------------------------------------------------------
  Gate                    Runs On                 Fail Condition
  ----------------------- ----------------------- -----------------------------------------------
  Lint                    PR + main               ESLint violations

  Typecheck               PR + main               TS errors

  Unit tests              PR + main               Any failure

  Playwright smoke        PR + main               Vertical slice flows fail

  OpenAPI drift check     PR + main               Generated OpenAPI differs from committed YAML

  Migration check         PR + main               Drizzle migrations do not apply cleanly
  -----------------------------------------------------------------------------------------------

# 6) Vertical Slice (v1) --- Build Order

1.  Auth + tenancy bootstrap (PSP → Brand) + RBAC enforcement.

2.  Stores import + regions/groups + store selection recipe preview.

3.  Survey templates + store survey responses + location slot generation.

4.  Campaign builder + kit definition + publish → assignment + order generation.

5.  PSP ops: campaign totals + store orders list + status updates + batches.

6.  Shipments + tracking + partial shipments + notifications/webhooks.

7.  Store execution: receive/verify → install → proof capture → completion + attestation.

8.  Verification queue: approve/reject photos → retake queue → resubmission.

9.  Issues/reorders: submit issue → approval policy → reorder shipment updates.

10. Exports center: small sync + async jobs + downloadable artifacts.

11. Retention job scaffolding (no destructive purge in early pilots; dry-run mode first).

# 7) Deployment Plan (Pilots) --- ECS Fargate

- Services: web, api, worker (separate ECS services).

- Managed dependencies: RDS Postgres, ElastiCache Redis, S3, SES.

- Staging environment mirrors prod for pilot validation; blue/green optional later.

- App Runner alternative is acceptable if you want fewer knobs, but worker separation is cleaner in ECS.

# Definition of Done (Module 21)

12. Repo scaffolded with the structure above; local dev works with docker-compose for postgres/redis.

13. CI pipeline enforces gates; PR template includes testing proof.

14. Shared schema package exists and is used by API + OpenAPI generation.

15. Vertical slice backlog written as executable milestones for human devs or agent swarm.
