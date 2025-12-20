Date: 2025-12-18

This is the single master document for v1 scope, technical direction, delivery approach, and acceptance. Module-level implementation details are defined in the attached Supplemental Specifications (SUPPs).

# Document Control

This master SOW is a compiled build artifact. It contains the full text of all active SUPPs (Appendices) while the SUPPs remain separate, developer/agent-friendly references.

Editing rule: Update the relevant SUPP(s) first (as a full replacement with a version bump). Then regenerate this master SOW so the compiled Appendices stay in sync.

Nonâ€‘negotiable document rules:

- No placeholder sections: headings must contain real content (not single-line \'see file\' references).

- No addendums: changes are full replacements (vX â†’ vX+1) for any impacted SUPP.

- No scope invention: v1 remains PSP-led campaign orchestration with hard guardrails (Not MIS, Not marketplace, Not analytics-heavy, No long-term storage).

- Single release package: every delivery includes (1) compiled master SOW, (2) separate SUPPs, (3) archive of superseded files.

  ------------------------------------------------------------------------------------------------------------------------------------
  Document Set Release                v1.34
  ----------------------------------- ------------------------------------------------------------------------------------------------
  Master Document                     Compiled (includes SUPPs as Appendices)

  Canonical Build Specs               SUPP files under /02_SUPPs (each has its own version)

  Scope Guardrails                    See Section 2.3 + \'What This Platform Will Never Be\'

  Core Loop                           Campaign â†’ Store Assignment â†’ PSP Fulfillment â†’ Store Execution â†’ Verification â†’ Visibility

  Retention Rule                      Operational campaign data retained 90 days after completion; export offered; otherwise deleted
  ------------------------------------------------------------------------------------------------------------------------------------

Revision History (master document):

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Version                 Date                    Summary
  ----------------------- ----------------------- ------------------------------------------------------------------------------------------------------------------------------------
  v1.33                   2025-12-17              Cleanup pass; SUPPs normalized and indexed.

  v1.34                   2025-12-18              Compiled master now includes full SUPP text as Appendices; removed placeholder-only sections; established doc-set operating rules.
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Revision History (master document):

  ----------------------------------------------------------------------------------------------------
  Field                               Value
  ----------------------------------- ----------------------------------------------------------------
  Project                             NewPOPSys v1

  Prepared For                        Pilot PSPs and Brand Stakeholders

  Prepared By                         Delivery Team / AI Agent Swarm

  Version                             v1.0 (Master)

  Update Cadence                      Bi-weekly written update; decision log maintained continuously

  Order of Precedence                 Master SOW â†’ SUPPs â†’ Decision Log â†’ Backlog/Tickets
  ----------------------------------------------------------------------------------------------------

# 1. Executive Summary

NewPOPSys v1 is a PSP-led campaign orchestration platform that replaces spreadsheets and email threads with an auditable lifecycle: Campaign â†’ Store Assignment â†’ PSP Fulfillment â†’ Store Execution â†’ Verification â†’ Visibility. v1 is a modernized, feature-matched rebuild of the PrecisionPOP operational loop with a mobile-first store web experience and automation-ready APIs.

# 2. Product Context (v1 Intent, Audience, Guardrails)

NewPOPSys v1 is a PSP-led campaign orchestration platform: it coordinates a repeatable campaign lifecycle across Brands, Stores, and the PSP fulfillment operation. The system replaces spreadsheet-and-email workflows with deterministic order generation, guided store execution, proof capture, verification, and status visibility.

Core platform loop (v1): Campaign â†’ Store Assignment â†’ PSP Fulfillment â†’ Store Execution â†’ Verification â†’ Visibility.

## 2.1 Who It Is For

- PSP Operations (paying customer): runs fulfillment (production/kitting/shipping), manages exceptions, and needs predictable exports/integrations.

- Brand Campaign Admin: configures campaigns, kits, and store assignments; needs progress visibility and controlled change management.

- Regional Manager: monitors execution and intervenes by exception.

- Store Manager / Store Execution: completes a mobile-first execution flow, captures required proof, and resolves retake requests.

## 2.2 Problems It Solves (v1)

- Eliminates ad-hoc campaign setup and inconsistent store instructions by standardizing campaigns, kits, and store assignments.

- Creates predictable, deterministic orders for PSP fulfillment (including partial shipments and batch tracking).

- Provides an execution-focused store flow with proof capture and completion/attestation, designed for speed and clarity.

- Supports verification workflows (approve/reject/retake) and real-time visibility into status and exceptions.

- Enforces operational discipline: versioned surveys/layouts, auditable state transitions, controlled overrides, and short retention with export pathways.

## 2.3 What It Explicitly Does NOT Do (Protected Not-Now)

v1 guardrails are intentional. If a request falls into the categories below, it is out of scope for v1 unless explicitly traded in through formal scope control:

- Not an MIS/ERP: no job costing, accounting, production scheduling, payroll, or financial reporting.

- Not a marketplace: no installer bidding/matchmaking, vendor marketplaces, ratings/reviews, or dynamic pricing.

- Not analytics-heavy: no benchmarking, predictive dashboards, or AI insights surfaced to users (data readiness only).

- Not long-term storage: no archival data warehouse; operational campaign data retention is 90 days after completion (export or deletion thereafter).

- Not built to optimize for everyone: PSP adoption and delivery discipline are prioritized; store UX is execution-focused, not endlessly customizable.

- No silent scope expansion: new scope requires tradeoffs; timeline and budget are fixed constraints.

## 2.4 How v1 Scaffolds the Future (Without Expanding v1 Scope)

v1 is intentionally PSP-led to drive adoption through real operational pain and fulfillment efficiency. However, the architecture must preserve optionality to evolve toward a brand-led SaaS model over time.

- Brands are treated as first-class entities from v1.

- Avoid hard-coupling a brand to a single PSP; preserve clean portability pathways.

- Adopt neutral campaign and reporting models; exports and event envelopes stay stable as the platform scales.

- Build integration scaffolding early (API/event contracts, webhooks, exports) so future systems can attach without rewriting core flows.

# 3. Technology Overview (Authoritative; referenced by all SUPPs)

This section is the authoritative v1 technology baseline. SUPPs must reference this section and should not redefine the stack unless a change is explicitly approved through scope control.

## 3.1 Stack Summary

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Technology                       Purpose                                                                                 Version policy                                                   FOSS vs Paid          License / Notes
  -------------------------------- --------------------------------------------------------------------------------------- ---------------------------------------------------------------- --------------------- ----------------------------------------------------------------------------------------------
  AWS (hosting baseline)           Pilot-grade hosting and managed services.                                               N/A (managed services).                                          Paid                  Primary pilot target; keeps infra low-friction.

  PostgreSQL (AWS RDS)             System of record for tenants, campaigns, assignments, execution, and audit.             Pin major version for pilot; upgrade in controlled windows.      FOSS + paid managed   Use relational constraints for core relationships; JSONB for survey schemas/responses.

  S3 (object storage)              Store uploaded media (proof photos) and export packages; DB stores metadata/pointers.   N/A (managed).                                                   Paid                  All uploads via presigned URLs; thumbnails optional.

  Next.js (React)                  Primary web UI (PSP, Brand, Store); supports PWA scaffold for store execution.          Pin major for pilot; avoid breaking router rewrites mid-pilot.   FOSS                  i18n scaffold via next-intl; Spanish prepared but not shipped prematurely.

  TypeScript + Node.js services    API and workers; deterministic business logic and integration surfaces.                 Node LTS only; pin major framework versions.                     FOSS                  Backend may be Next API routes or separate service (Fastify/Nest allowed per ADR).

  Fastify (API service)            Dedicated API layer (where separated from UI).                                          Pin major for pilot.                                             FOSS                  Shown as default repo structure in SUPP-021.

  Drizzle (DB schema/migrations)   Schema definitions and migrations; keeps migrations explicit and reviewable.            Pin major; lock migration behavior.                              FOSS                  ADR allows Prisma/Knex alternatives if constraints remain enforced at SQL level.

  Zod                              Shared request/response schemas; drift-gated OpenAPI generation.                        Pin major; treat schema changes as API contract changes.         FOSS                  Shared across web/api/worker; used for OpenAPI drift checks.

  BullMQ                           Async jobs for exports, webhook retries, retention purge, email digests.                Pin major; ensure deterministic retries and idempotency.         FOSS                  Runs on Redis-compatible backend.

  Redis (or compatible)            Queue backend + caching.                                                                Pin major; confirm licensing/managed provider choice.            Varies                Local dev uses redis; consider Redis-compatible alternatives if licensing constraints apply.

  OpenTelemetry                    Tracing and correlation across web/api/worker; portability across vendors.              Pin major SDK versions.                                          FOSS                  OTLP exporters; do not hard-couple to one vendor.

  Sentry                           Pilot stabilization: error capture/alerting.                                            Service-managed; SDK pinned.                                     Paid (typical)        Optional but recommended for pilot.

  docker-compose                   Local dev parity: Postgres, Redis, MinIO, MailHog.                                      Pin image tags to known-good versions.                           FOSS                  One-command boot for new dev onboarding.

  MinIO (local)                    Local S3-compatible object storage for validating presigned upload paths.               Pin image tag.                                                   FOSS                  Bucket structure mirrors staging.

  MailHog (local)                  Local SMTP capture for invite/notification emails.                                      Pin image tag.                                                   FOSS                  No real emails in local environment.

  pnpm                             Monorepo package management and deterministic installs.                                 Pin major; lockfile required.                                    FOSS                  Used in SUPP-026 scripts.

  Terraform (optional)             Infrastructure as code for ECS/RDS/S3/Redis.                                            Pin provider versions.                                           FOSS                  Optional per repo structure; acceptable alternative IaC tools if outputs match.
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Version policy: pin major versions for the pilot. Minor/patch updates are allowed on a controlled cadence (with CI gates) to avoid breaking changes during active pilot execution.

Commercial vs FOSS note: paid services (e.g., AWS managed services, Sentry) are permitted where they materially reduce pilot risk. Vendor lock-in is reduced via OpenTelemetry and stable API/event contracts.

# 4. Pilot Context & Scale

Pilot context exists to anchor build decisions (throughput, storage, permissions, and supportability). Pilot scale values are not assumed; they must be confirmed during stakeholder Q&A before performance or cost optimizations are locked.

## 4.1 Pilot Operating Model (v1)

- PSP-led tenant: PSP is the paying customer and operational owner of fulfillment and support.

- Brands configure campaigns; stores execute; regional managers intervene by exception.

- Pilot optimizes for deterministic execution, auditability, and operational visibility (not broad configurability).

## 4.2 Pilot Scale Inputs Required (Q&A Gate)

The following pilot parameters must be confirmed and then treated as input constraints for sizing and acceptance criteria:

- Number of PSP tenants in pilot; number of brands per PSP.

- Number of stores/locations per brand and expected geographic hierarchy usage (region/district).

- Expected campaign volume (per week/month) and average assignment size (stores per campaign).

- Media volume assumptions (photos per store, average file size, peak upload periods).

- Export cadence and payload size expectations (daily/weekly, brand takeout packages).

- Integration surfaces required for pilot (webhooks, inbound events, API keys) and any mandatory downstream systems.

## 4.3 Pilot Success Definition (Operational)

- A campaign can be configured, published, fulfilled, executed, verified, and exported end-to-end without spreadsheets or manual reconciliation.

- Support can trace incidents end-to-end using correlationId/requestId and audit logs.

- Retention and export policies are enforced automatically (no manual cleanup).

  ------------------------------------------------------------------------------------------------------------
  Dimension                           Pilot Target
  ----------------------------------- ------------------------------------------------------------------------
  Pilot PSPs                          2 (Visual Graphx; Speedy CPS / Alpha Graphics)

  Pilot Brands                        2--3 (Good2Go is confirmed for Speedy/AG pilot)

  Stores per Brand                    Up to 1,000

  Media Volume                        \>= 1 photo per item per location per campaign

  Execution                           Web app first; PWA scaffold; best-effort offline drafts + sync-on-open
  ------------------------------------------------------------------------------------------------------------

# 5. Scope (v1)

- Tenant model (PSP root) + invitations + RBAC

- Stores + hierarchical geography (Region/District/Territory optional) + custom groups w/ include/exclude selection recipes

- Store layout + survey builder (templated, versioned, dynamic field types, conditional logic, repeatable sections)

- Campaigns + kits + per-store assignment pinning with controlled rebase option

- Order generation + PSP portal + partial shipments + batch tracking

- Store execution flow: notify â†’ receive/verify â†’ issues/reorders â†’ pre-install checklist â†’ install â†’ proof capture â†’ completion + attestation

- Verification: review queue, approval/rejection, reason codes, retake loop, campaign-configurable SLA, strict/fast completion modes

- Exports: CSV/XLSX, PDF, JSON, XML

- Integrations: signed webhooks, idempotent inbound API updates, event outbox, retries

- Retention: Option A asset registry; campaign proof media purged at 90 days post completion (default)

- Audit logging across core objects and state transitions

# 6. Out of Scope (Protected Not-Now List)

- Installer marketplace / bidding

- PSP MIS (accounting, costing, scheduling, payroll)

- Advanced analytics/benchmarking beyond baseline visibility

- Long-term archival storage/data warehouse beyond defined retention policy

- AI automation features beyond data-readiness scaffolding (AI proof analysis is future)

# 7. High-Level Architecture (Selected; see Section 3 for authoritative stack)

Architecture summary lives here. Technology selections live in Section 3 and are referenced by SUPPs.

- Frontend: Next.js (React), mobile-first responsive UI, PWA support

- Backend: Node.js (TypeScript) modular monolith (Fastify/Nest or Next API routes)

- DB: PostgreSQL with JSONB for schema-driven forms; strong relational constraints for fulfillment/execution

- Object Storage: S3-compatible with presigned uploads (store only metadata in DB)

- Jobs/Queue: Redis + BullMQ for exports, webhook retries, media processing

- Auth: Email/password v1; scaffold OAuth/magic links/2FA

- Testing: unit (Vitest), E2E (Playwright), contract tests for webhooks/API

- CI/CD: GitHub Actions, migrations gated, preview environments

- Observability: structured logs + request IDs; audit events for all state changes

# 8. Conceptual Domain Model

Tenant root is PSP. Brands operate within PSP context. The core entity chain is: Campaign â†’ StoreAssignment â†’ StoreOrder â†’ Shipment â†’ Execution/Proof â†’ Verification â†’ Reporting.

- Stores belong to exactly one Region; District/Territory are optional layers; stores can belong to multiple custom StoreGroups.

- Surveys are versioned: SurveyTemplate â†’ immutable SurveyVersion â†’ StoreSurveyResponse.

- Photos are bound to item + store layout slot requirements (not generic 'campaign photos').

- All key actions emit AuditEvents; integration/webhook dispatch uses an Outbox pattern for reliability.

# 9. Modules & Acceptance (Implementation Roadmap)

Each module below is implemented per its SUPP. This master document provides the single roadmap and vertical-slice acceptance.

  ----------------------------------------------------------------------------------------------------
  Module                                              Status                  Authoritative Spec
  --------------------------------------------------- ----------------------- ------------------------
  Module 1 --- Identity/RBAC                          Locked                  SUPP-003 v0.4

  Module 2 --- Stores/Regions/Groups                  Locked                  SUPP-013 v0.2

  Module 3 --- Survey Builder/Layout/Photo Rules      Locked                  SUPP-014 v0.3

  Module 4 --- Campaigns/Kits/Assignment              Locked                  SUPP-015 v0.2

  Module 5 --- Orders/Shipments/Batches/PSP Ops       Locked                  SUPP-016 v0.2

  Module 6 --- Store Execution/Proof Capture          Locked                  SUPP-017 v0.2

  Module 7 --- Verification/Retake Loop               Locked                  SUPP-018 v0.2

  Module 8 --- Issues/Reorders/Expiration/Deinstall   Locked                  SUPP-019 v0.2

  Module 9 --- Exports/Reports                        Locked                  SUPP-005 v0.2

  Module 10 --- Integrations/Webhooks                 Locked                  SUPP-006 v0.2

  Module 11 --- Retention Lifecycle                   Locked                  SUPP-008 v0.3 Option A

  Module 12 --- Offline/Sync Strategy                 Locked                  SUPP-011 v0.2
  ----------------------------------------------------------------------------------------------------

# 10. Core Vertical Slice Acceptance (Pilot)

1.  Create an expiring campaign for Good2Go; select stores via region/group/custom include/exclude; preview and publish.

2.  On publish: assignments are created; survey/layout versions pinned; orders and line items generated deterministically; PSP is notified (email + webhook).

3.  PSP updates order/shipment/batch status via UI or integration API; partial shipments and multi-tracking work; webhooks emitted; audit logged.

4.  Store completes the web execution flow including pre-install checklist; uploads required proof photos per item/location; completes completion survey and attestation.

5.  Admin reviews proofs; rejects specific photos with reason codes; store retakes and resubmits; completion behavior follows campaign verificationMode (STRICT or FAST).

6.  Store submits a missing/damaged issue with per-item lines; approval follows campaign rules; PSP fulfills reorder; asset substitution is allowed with audit.

7.  Exports produce CSV/XLSX + PDF and JSON/XML; retention job purges campaign proof media at 90 days post completion while preserving master definitions.

# 11. Delivery Plan (Agentic + Human Gates)

- Autonomous loop: Plan â†’ Implement â†’ Verify â†’ Review â†’ Merge.

- Always-on gates: lint/typecheck, unit tests, integration tests, E2E smoke (critical path), basic security checks.

- Traceability: every PR maps to a story/use-case; acceptance criteria map to tests; audit events verify state transitions.

- Artifacts: PR description, decision log updates, defect/tech-debt log, screenshots for progress reporting, updated docs/tooltips/i18n keys.

# 12. Supplement Index + Compiled Appendices (SUPPs remain authoritative)

This index is authoritative for what constitutes the build spec. The master SOW includes the full text of each active SUPP below as compiled Appendices (so nothing is \'missing\' when reading the master), but the SUPP files remain the developer/AI-agent working documents.

Update workflow: edit the relevant SUPP(s) â†’ bump version â†’ regenerate this compiled master â†’ deliver as one zip (master + SUPPs + archive).

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Appendix    SUPP        Version     Module                       Title                                                                                          File (relative)
  ----------- ----------- ----------- ---------------------------- ---------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------
  App A.01    SUPP-001    v0.2        Shared Foundations           Shared Foundations - Persona Workflows JTBD Screens                                            02_SUPPs/Shared_Foundations/SUPP-001 - Shared Foundations - Persona Workflows JTBD Screens - v0.2.docx

  App A.02    SUPP-002    v0.2        Shared Foundations           Shared Foundations - Core Domain Model and State Machines                                      02_SUPPs/Shared_Foundations/SUPP-002 - Shared Foundations - Core Domain Model and State Machines - v0.2.docx

  App A.03    SUPP-003    v0.5        Shared Foundations           Shared Foundations - RBAC and Permissions Matrix                                               02_SUPPs/Shared_Foundations/SUPP-003 - Shared Foundations - RBAC and Permissions Matrix - v0.5.docx

  App A.04    SUPP-004    v0.3        Shared Foundations           Shared Foundations - Notifications and Escalation Matrix                                       02_SUPPs/Shared_Foundations/SUPP-004 - Shared Foundations - Notifications and Escalation Matrix - v0.3.docx

  App A.05    SUPP-005    v0.3        Shared Foundations           Shared Foundations - Exports Reports Output Contracts                                          02_SUPPs/Shared_Foundations/SUPP-005 - Shared Foundations - Exports Reports Output Contracts - v0.3.docx

  App A.06    SUPP-006    v0.4        Shared Foundations           Shared Foundations - Webhooks and Inbound API Event Contract                                   02_SUPPs/Shared_Foundations/SUPP-006 - Shared Foundations - Webhooks and Inbound API Event Contract - v0.4.docx

  App A.07    SUPP-007    v0.4        Shared Foundations           Shared Foundations - Completion Expiration Overrides                                           02_SUPPs/Shared_Foundations/SUPP-007 - Shared Foundations - Completion Expiration Overrides - v0.4.docx

  App A.08    SUPP-008    v0.4        Shared Foundations           Shared Foundations - Data Retention Classification Policy Option A                             02_SUPPs/Shared_Foundations/SUPP-008 - Shared Foundations - Data Retention Classification Policy Option A - v0.4.docx

  App B.01    SUPP-013    v0.2        Brand Admin Module           Brand Admin Module - Stores Regions Groups                                                     02_SUPPs/Brand_Admin_Module/SUPP-013 - Brand Admin Module - Stores Regions Groups - v0.2.docx

  App B.02    SUPP-014    v0.4        Brand Admin Module           Brand Admin Module - Survey Builder Layout Photo Rules                                         02_SUPPs/Brand_Admin_Module/SUPP-014 - Brand Admin Module - Survey Builder Layout Photo Rules - v0.4.docx

  App B.03    SUPP-015    v0.2        Brand Admin Module           Brand Admin Module - Campaigns Kits Assignment                                                 02_SUPPs/Brand_Admin_Module/SUPP-015 - Brand Admin Module - Campaigns Kits Assignment - v0.2.docx

  App B.04    SUPP-033    v0.1        Brand Admin Module           Brand Admin Module - Brand Takeout Export Package Scaffold                                     02_SUPPs/Brand_Admin_Module/SUPP-033 - Brand Admin Module - Brand Takeout Export Package Scaffold - v0.1.docx

  App C.01    SUPP-016    v0.3        PSP Operations Module        PSP Operations Module - Orders Shipments Batches PSP Ops                                       02_SUPPs/PSP_Operations_Module/SUPP-016 - PSP Operations Module - Orders Shipments Batches PSP Ops - v0.3.docx

  App C.02    SUPP-018    v0.2        PSP Operations Module        PSP Operations Module - Verification Photo Review Retake                                       02_SUPPs/PSP_Operations_Module/SUPP-018 - PSP Operations Module - Verification Photo Review Retake - v0.2.docx

  App C.03    SUPP-019    v0.2        PSP Operations Module        PSP Operations Module - Issues Reorders Expiration Deinstall                                   02_SUPPs/PSP_Operations_Module/SUPP-019 - PSP Operations Module - Issues Reorders Expiration Deinstall - v0.2.docx

  App D.01    SUPP-011    v0.3        Store Execution Module       Store Execution Module - Offline and Sync Strategy                                             02_SUPPs/Store_Execution_Module/SUPP-011 - Store Execution Module - Offline and Sync Strategy - v0.3.docx

  App D.02    SUPP-017    v0.2        Store Execution Module       Store Execution Module - Store Execution Proof Capture                                         02_SUPPs/Store_Execution_Module/SUPP-017 - Store Execution Module - Store Execution Proof Capture - v0.2.docx

  App E.01    SUPP-012    v0.2        Platform Ops Agent Harness   Platform Ops - Agent Harness - Technology Selections ADR                                       02_SUPPs/Platform_Ops_Agent_Harness/SUPP-012 - Platform Ops - Agent Harness - Technology Selections ADR - v0.2.docx

  App E.02    SUPP-020    v0.2        Platform Ops Agent Harness   Platform Ops - Agent Harness - Build Contracts and Physical Schema                             02_SUPPs/Platform_Ops_Agent_Harness/SUPP-020 - Platform Ops - Agent Harness - Build Contracts and Physical Schema - v0.2.docx

  App E.03    SUPP-021    v0.1        Platform Ops Agent Harness   Platform Ops - Agent Harness - Repo CI and Vertical Slice Plan                                 02_SUPPs/Platform_Ops_Agent_Harness/SUPP-021 - Platform Ops - Agent Harness - Repo CI and Vertical Slice Plan - v0.1.docx

  App E.04    SUPP-022    v0.1        Platform Ops Agent Harness   Platform Ops - Agent Harness - Branching FeatureFlags Release Workers                          02_SUPPs/Platform_Ops_Agent_Harness/SUPP-022 - Platform Ops - Agent Harness - Branching FeatureFlags Release Workers - v0.1.docx

  App E.05    SUPP-023    v0.1        Platform Ops Agent Harness   Platform Ops - Agent Harness - Feature Flags Data Model and Admin UX                           02_SUPPs/Platform_Ops_Agent_Harness/SUPP-023 - Platform Ops - Agent Harness - Feature Flags Data Model and Admin UX - v0.1.docx

  App E.06    SUPP-024    v0.1        Platform Ops Agent Harness   Platform Ops - Agent Harness - Env Config Secrets Tenant Bootstrap Seeding                     02_SUPPs/Platform_Ops_Agent_Harness/SUPP-024 - Platform Ops - Agent Harness - Env Config Secrets Tenant Bootstrap Seeding - v0.1.docx

  App E.07    SUPP-025    v0.1        Platform Ops Agent Harness   Platform Ops - Agent Harness - Staging Seed Scale Plan and Testing Targets                     02_SUPPs/Platform_Ops_Agent_Harness/SUPP-025 - Platform Ops - Agent Harness - Staging Seed Scale Plan and Testing Targets - v0.1.docx

  App E.08    SUPP-026    v0.1        Platform Ops Agent Harness   Platform Ops - Agent Harness - Local Dev Staging Parity and Toolchain                          02_SUPPs/Platform_Ops_Agent_Harness/SUPP-026 - Platform Ops - Agent Harness - Local Dev Staging Parity and Toolchain - v0.1.docx

  App E.09    SUPP-027    v0.1        Platform Ops Agent Harness   Platform Ops - Agent Harness - Notifications Webhooks Deliverability Retry and Replay          02_SUPPs/Platform_Ops_Agent_Harness/SUPP-027 - Platform Ops - Agent Harness - Notifications Webhooks Deliverability Retry and Replay - v0.1.docx

  App E.10    SUPP-029    v0.1        Platform Ops Agent Harness   Platform Ops - Agent Harness - Observability Tracing Logging and Audit Correlation             02_SUPPs/Platform_Ops_Agent_Harness/SUPP-029 - Platform Ops - Agent Harness - Observability Tracing Logging and Audit Correlation - v0.1.docx

  App E.11    SUPP-030    v0.2        Platform Ops Agent Harness   Platform Ops - Agent Harness - Admin Ops Console Minimum Screens                               02_SUPPs/Platform_Ops_Agent_Harness/SUPP-030 - Platform Ops - Agent Harness - Admin Ops Console Minimum Screens - v0.2.docx

  App E.12    SUPP-031    v0.1        Platform Ops Agent Harness   Platform Ops - Agent Harness - Supportability Policies Impersonation and Incident Process      02_SUPPs/Platform_Ops_Agent_Harness/SUPP-031 - Platform Ops - Agent Harness - Supportability Policies Impersonation and Incident Process - v0.1.docx

  App E.13    SUPP-032    v0.1        Platform Ops Agent Harness   Platform Ops - Agent Harness - BreakGlass Retention Safety and Data Requests                   02_SUPPs/Platform_Ops_Agent_Harness/SUPP-032 - Platform Ops - Agent Harness - BreakGlass Retention Safety and Data Requests - v0.1.docx

  App E.14    SUPP-034    v0.1        Platform Ops Agent Harness   Platform Ops - Agent Harness - Rate Limits Upload Guards Export Throttle Webhook Concurrency   02_SUPPs/Platform_Ops_Agent_Harness/SUPP-034 - Platform Ops - Agent Harness - Rate Limits Upload Guards Export Throttle Webhook Concurrency - v0.1.docx

  App E.15    SUPP-035    v0.8        Platform Ops Agent Harness   Platform Ops - Agent Harness - Field Level Data Model Tables Fields Enums                      02_SUPPs/Platform_Ops_Agent_Harness/SUPP-035 - Platform Ops - Agent Harness - Field Level Data Model Tables Fields Enums - v0.8.docx

  App F.01    SUPP-036    v0.4        Screens Interfaces           Screens - Interfaces - Screens Onboarding and Store Foundation                                 02_SUPPs/Screens_Interfaces/SUPP-036 - Screens - Interfaces - Screens Onboarding and Store Foundation - v0.4.docx

  App F.02    SUPP-037    v0.8        Screens Interfaces           Screens - Interfaces - Screens SurveyBuilder and StoreSurveys                                  02_SUPPs/Screens_Interfaces/SUPP-037 - Screens - Interfaces - Screens SurveyBuilder and StoreSurveys - v0.8.docx
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 13. Status & Roadmap (Current as of 2025-12-18)

This section is the current editorial status of the document set. It is not new scope; it is a gate checklist for what can be built now vs what must be validated first.

## 13.1 Clean and Locked

- SUPP-002 --- Core Domain Model and State Machines

- SUPP-003 --- RBAC and Permissions Matrix

- SUPP-005 --- Exports Reports Output Contracts

- SUPP-006 --- Webhooks and Inbound API Event Contract

- SUPP-008 --- Data Retention Classification Policy Option A

- SUPP-012 --- Technology Selections ADR

- SUPP-021 --- Repo CI and Vertical Slice Plan

- SUPP-022 --- Branching FeatureFlags Release Workers

- SUPP-023 --- Feature Flags Data Model and Admin UX

- SUPP-024 --- Env Config Secrets Tenant Bootstrap Seeding

- SUPP-026 --- Local Dev Staging Parity and Toolchain

- SUPP-029 --- Observability Tracing Logging and Audit Correlation

- SUPP-032 --- BreakGlass Retention Safety and Data Requests

## 13.2 In Review

- SUPP-004 --- Notifications and Escalation Matrix

- SUPP-015 --- Campaigns Kits Assignment

- SUPP-018 --- Verification Photo Review Retake

- SUPP-027 --- Notifications Webhooks Deliverability Retry and Replay

- SUPP-035 --- Field Level Data Model Tables Fields Enums

- SUPP-036 --- Screens Onboarding and Store Foundation

- SUPP-037 --- Screens SurveyBuilder and StoreSurveys

## 13.3 Requires Next Q&A (Do not guess)

- Pilot scale confirmation (brands, stores, campaigns/month, photo volume, export cadence).

- Store execution workflow truth-table (what store users actually do today, including edge cases).

- PSP fulfillment workflow specifics (batching behavior, partial shipment rules, exception handling).

- Integration requirements for pilot (webhooks destinations, inbound events, mandatory downstream systems).

- Retention and export expectations by artifact type (media vs operational records vs audit).

## 13.4 Recommended Next Module Once Cleanup Is Approved

PSP Operations Module (SUPP-016). It forces early clarity on fulfillment throughput, exception handling, and export/integration realities without expanding scope.

# APPENDICES --- Compiled SUPPs (SUPP files remain authoritative)

Each appendix below embeds the full text of the corresponding SUPP so the master SOW can be read standalone. For implementation work, use the separate SUPP file listed in Section 12 (same content, easier to reference).


## Appendix A --- Shared Foundations

### App A.01 --- SUPP-001: Shared Foundations - Persona Workflows JTBD Screens (v0.2)

Date: 2025-12-17

Purpose: Define v1 personas, jobs-to-be-done, canonical workflows (happy + exceptions), and the minimum screens/modules required for the pilot vertical slice at scale.

# Locked Inputs (Current)

  ----------------------------------------------------------------------------------------------------------------------------------
  Decision                            Value
  ----------------------------------- ----------------------------------------------------------------------------------------------
  Pilot PSPs                          Visual Graphx; Speedy CPS / Alpha Graphics

  Pilot Brand (confirmed)             Good2Go (Speedy/AG pilot)

  Auth (v1)                           Email + password

  Execution platform                  Mobile-first web app + PWA scaffold; best-effort offline drafts + sync-on-open

  Photos                              Bound to item + store location slot; brand-owned requirements (defaults + overrides)

  Verification                        Photo-level + slot-level review; retake only rejected photos; STRICT/FAST mode per campaign

  Fulfillment                         Orders generated on publish; partial shipments supported; batch tracking with enums + CUSTOM
  ----------------------------------------------------------------------------------------------------------------------------------

# Personas (v1)

  ----------------------------------------------------------------------------------------------------------------------------------------
  Persona                             Primary Responsibility
  ----------------------------------- ----------------------------------------------------------------------------------------------------
  PSP_ADMIN                           Tenant config, brand onboarding, security, permissions, system settings

  PSP_OPS                             Fulfillment ops: orders, production/batches, shipments, reorders; updates via UI/API

  BRAND_ADMIN / Campaign Admin        Campaign creation, store selection, kit definitions, verification mode/SLA, reporting

  REGIONAL_ADMIN                      Exception-first oversight, photo review, store reopen/waivers, escalations

  STORE_USER                          Receive/verify, report issues, install, proof capture, completion + attestation, retakes/deinstall

  INTEGRATION_USER                    PSP automation service account: inbound API writes; webhook consumption; export triggers
  ----------------------------------------------------------------------------------------------------------------------------------------

# PSP_OPS --- Canonical Workflow

1.  Campaign published â†’ system generates assignments + store orders â†’ PSP notified (email/webhook/in-app).

2.  PSP reviews campaign totals + store orders; confirms production/kitting plan.

3.  PSP assigns batches (PRODUCTION / PICK_PACK / SHIP_WAVE / CUSTOM) and progresses order statuses.

4.  PSP creates shipments (partial allowed), adds tracking, updates shipment/order status (UI or API).

5.  PSP processes issues/reorders: approve/fulfill per campaign approval policy; ship replacements.

6.  PSP exports required packages (orders/shipments/execution/reorders) and closes fulfillment as needed.

# Brand Admin --- Canonical Workflow

7.  Define campaign: type (expiring vs core branding), timeline, instructions, verificationMode (STRICT/FAST), verification SLA, deinstall rules.

8.  Define kit: items + required location slot mappings; attach mockups/reference images; set photo rules (defaults + overrides).

9.  Select stores using all/region/group/custom includes + exclusions; preview selection recipe; publish campaign.

10. Monitor dashboard: completion %, late shipping, anomalies, issue counts, rejection counts.

11. Review proofs (photo + slot packet). Reject specific photos with reason codes; store retakes; approve when satisfied.

12. Apply waivers or force-complete when allowed (requires reason + audit).

# Regional Admin --- Exception-first Workflow

- Work from exception queue: overdue, missing proofs, rejected proofs, deinstall overdue (if enabled), severe anomalies.

- Approve/reject proofs; request retakes; reopen stores; apply completion waivers where policy allows (reason required).

- Escalate to Brand Admin/PSP Ops via in-app comment + notification triggers.

# Store User --- Execution Workflow (v1)

13. Receive campaign notification and review instructions + mockups and due dates.

14. Receive/Verify: confirm order-level receipt; record item-level anomalies (missing/damaged/incorrect) with photos/evidence as required.

15. Optional: Submit major packaging damage as a single request (PSP may expand into item lines).

16. Pre-install checklist: safety + old campaign removal + readiness acknowledgements.

17. Install per item + location slot; upload proof photos as-you-go; meet brand's required minimums and suggested angles.

18. Completion survey + attestation checkbox (userId + timestamp). Submission goes to review if STRICT, or completes immediately if FAST.

19. If photos rejected: retake only rejected photos; resubmit until satisfied/waived.

20. If campaign expires: complete deinstall task and end survey; proof optional/required per campaign.

# Minimum Screens/Modules (v1)

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Persona                             Screens/Modules
  ----------------------------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  PSP                                 Campaign list/totals; Store order list+filters; Order detail; Batch manager; Shipments+tracking; Issues/Reorders queue; Exports center; Webhook/API logs; Audit log

  Brand/Regional                      Campaign builder; Store selector; Kit/items editor; Photo rules; Dashboard; Store detail; Review queue; Retake queue; Waivers/Reopen; Exports/reports

  Store                               My tasks; Campaign detail; Receive/verify; Issue/reorder; Pre-install checklist; Install + proof capture; Completion survey + attestation; Retake queue; Deinstall task
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Edge Cases (Must Support)

- Store layout/survey updates mid-campaign: default pinning + controlled Rebase to Latest with verification tasks if fulfillment started.

- Partial shipments and backorders; multiple tracking numbers per shipment.

- STRICT vs FAST verification behavior (brand optional per campaign) with auto-reopen on rejection in FAST.

- Asset substitution for reprints/reorders with audit trail.

- Late shipping thresholds configurable per campaign; escalations routed per notifications matrix.


---

### App A.02 --- SUPP-002: Shared Foundations - Core Domain Model and State Machines (v0.2)

Date: 2025-12-17

Purpose: Canonical domain model and state machines for v1. This anchors data modeling, API contracts, reporting, and agentic development so implementations remain deterministic.

# Core Loop Anchor

Campaign â†’ Store Assignment â†’ Orders/Shipments (PSP) â†’ Store Execution â†’ Verification/Retakes â†’ Visibility/Exports â†’ Retention.

# Primary Entities (v1)

  --------------------------------------------------------------------------------------------------------------------------------------------------------------
  Domain                              Entities
  ----------------------------------- --------------------------------------------------------------------------------------------------------------------------
  Tenancy & Identity                  PSP Tenant, Brand, User, Membership, Role, APIKey/IntegrationUser, AuditEvent

  Stores & Grouping                   Store, Region (optional hierarchy), District (optional), Territory (optional), StoreGroup, GroupMembership, StoreIdAlias

  Layouts/Surveys/Rules               StoreLayout, LocationSlot, SurveyTemplate, SurveyVersion, StoreSurveyResponse, RepeatableSection, PhotoRule, PhotoLink

  Campaigns/Kits/Assignment           Campaign, SelectionRecipe, StoreAssignment, KitDefinition, KitItemDefinition, AssignmentItem, RebaseEvent

  Fulfillment                         StoreOrder, OrderLine, Shipment, ShipmentLine, ShipmentTracking, Batch, BatchMembership

  Execution & Verification            StoreTask, ReceiveVerification, InstallRecord, CompletionSubmission, PhotoReview, SlotVerification, RetakeTask

  Issues/Reorders                     IssueRequest, IssueLine, ApprovalPolicy, ApprovalDecision, Reorder, NonComplianceCase, AssetSubstitution
  --------------------------------------------------------------------------------------------------------------------------------------------------------------

# Key Relationship Rules

- PSP is tenant root; brands exist within PSP tenant.

- Store belongs to exactly one Region node; District/Territory layers optional. Stores may belong to multiple StoreGroups.

- Store Assignment pins SurveyVersion + LayoutVersion by default; controlled rebase allowed with audit + verification tasks if fulfillment started.

- Photos always bind to: campaign + store + item + locationSlot + ruleId (never 'floating' campaign photos).

- Orders default: 1 store order per store per campaign; scaffold add-on orders later.

- Shipments: 0..N per order; partial shipments supported; shipment can have 1..N tracking numbers.

# Canonical Status Enumerations (v1)

  --------------------------------------------------------------------------------------------------------------------------------------------------------------
  Object                              States (v1)
  ----------------------------------- --------------------------------------------------------------------------------------------------------------------------
  Campaign                            DRAFT, SCHEDULED, ACTIVE, COMPLETED, ARCHIVED

  StoreAssignment Execution           IN_PROGRESS, SUBMITTED_FOR_REVIEW, REWORK_REQUESTED, COMPLETE

  Order                               GENERATED, ACKNOWLEDGED, IN_PRODUCTION, KITTING, READY_TO_SHIP, PARTIALLY_SHIPPED, SHIPPED, DELIVERED, CLOSED, CANCELLED

  Shipment                            LABEL_CREATED, IN_TRANSIT, DELIVERED, EXCEPTION, RETURNED

  PhotoReview                         PENDING, APPROVED, REJECTED, SUPERSEDED

  Issue/Reorder                       ISSUE_SUBMITTED, APPROVAL_PENDING, APPROVED, REJECTED, REORDER_IN_PRODUCTION, REORDER_SHIPPED, REORDER_DELIVERED, CLOSED

  NonComplianceCase                   OPEN, ACKNOWLEDGED, RESOLVED, WAIVED, CLOSED
  --------------------------------------------------------------------------------------------------------------------------------------------------------------

# State Machines (Mermaid - Reference)

Store Assignment Execution (assignment-level):

\`\`\`mermaid\
stateDiagram-v2\
\[\*\] \--\> IN_PROGRESS\
IN_PROGRESS \--\> SUBMITTED_FOR_REVIEW : store submits completion\
SUBMITTED_FOR_REVIEW \--\> COMPLETE : all proofs satisfied OR waiver\
SUBMITTED_FOR_REVIEW \--\> REWORK_REQUESTED : photo rejected (STRICT mode)\
COMPLETE \--\> REWORK_REQUESTED : photo rejected (FAST mode auto-reopen)\
REWORK_REQUESTED \--\> SUBMITTED_FOR_REVIEW : store resubmits retake\
COMPLETE \--\> IN_PROGRESS : admin reopens\
\`\`\`

Photo Review (photo-level):

\`\`\`mermaid\
stateDiagram-v2\
\[\*\] \--\> PENDING\
PENDING \--\> APPROVED\
PENDING \--\> REJECTED\
REJECTED \--\> PENDING : retake uploaded\
APPROVED \--\> SUPERSEDED : replaced\
PENDING \--\> SUPERSEDED : replaced before review\
\`\`\`

Fulfillment Order (store order):

\`\`\`mermaid\
stateDiagram-v2\
\[\*\] \--\> GENERATED\
GENERATED \--\> ACKNOWLEDGED\
ACKNOWLEDGED \--\> IN_PRODUCTION\
IN_PRODUCTION \--\> KITTING\
KITTING \--\> READY_TO_SHIP\
READY_TO_SHIP \--\> PARTIALLY_SHIPPED\
READY_TO_SHIP \--\> SHIPPED\
PARTIALLY_SHIPPED \--\> SHIPPED\
SHIPPED \--\> DELIVERED\
DELIVERED \--\> CLOSED\
GENERATED \--\> CANCELLED\
ACKNOWLEDGED \--\> CANCELLED\
\`\`\`

# Reporting & Export Dimensions

- Required query chain: campaign â†’ store â†’ item â†’ locationSlot â†’ proofs â†’ review outcomes.

- All status transitions must emit immutable AuditEvents (actorType human\|integration).

- Exports must include stable identifiers + human-readable keys (storeNumber + GUID alias).

- Retention-aware: proof URLs may expire; exports include asset IDs/pointers.


---

### App A.03 --- SUPP-003: Shared Foundations - RBAC and Permissions Matrix (v0.5)

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


---

### App A.04 --- SUPP-004: Shared Foundations - Notifications and Escalation Matrix (v0.3)

Date: 2025-12-17

Purpose: Define notification triggers, recipients, channels, and escalation rules to keep v1 operations disciplined (PSP + brand + store) and automation-friendly.

# Channels (v1)

- In-app notifications (required)

- Email (required for PSP + brand admins; optional for store for non-critical)

- Outbound webhooks (required for PSP automation and downstream systems)

# Event â†’ Recipients â†’ Channels (v1 Minimum)

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Event                                 Trigger                                       Recipients                                       Channels
  ------------------------------------- --------------------------------------------- ------------------------------------------------ -------------------------------------
  order.created                         Campaign publish generates store orders       PSP_OPS, PSP_ADMIN                               Email + Webhook + In-app

  alert.late_shipping                   Late rule threshold breached (per campaign)   PSP_OPS, PSP_ADMIN, BRAND_ADMIN                  Email + Webhook + In-app

  shipment.updated                      Tracking/status change                        BRAND_ADMIN, REGIONAL_ADMIN; Store (optional)    Webhook + In-app (Email optional)

  execution.anomaly                     Receive/verify or completion anomaly          BRAND_ADMIN, REGIONAL_ADMIN                      Webhook + In-app (Email optional)

  proof.submitted                       Store submits completion (STRICT or FAST)     BRAND_ADMIN, REGIONAL_ADMIN                      Webhook + In-app

  photo.rejected                        Photo rejected w/ reason code                 STORE_USER                                       In-app + (Email optional)

  review.overdue                        Verification SLA missed (per campaign)        REGIONAL_ADMIN, BRAND_ADMIN                      In-app + Email

  issue.submitted                       Issue/reorder submitted                       PSP_OPS, PSP_ADMIN; BRAND_ADMIN (policy-based)   Email + In-app + Webhook

  issue.approval_required               ApprovalMode requires admin decision          BRAND_ADMIN/REGIONAL_ADMIN (as configured)       In-app + Email

  issue.approved_or_rejected            Decision recorded                             PSP_OPS (+ Store optional)                       Webhook + In-app

  campaign.expired.deinstall_required   End date reached (expiring)                   STORE_USER, BRAND_ADMIN, PSP_OPS                 In-app + Email + Webhook

  deinstall.overdue                     Grace period exceeded                         REGIONAL_ADMIN, BRAND_ADMIN                      In-app + Email

  noncompliance.case_created            Case toggle enabled and overdue               REGIONAL_ADMIN, BRAND_ADMIN                      In-app + Email + Webhook (optional)

  store.reopened_or_waived              Admin reopens store or waives proof           STORE_USER (+ Brand/Regional)                    In-app + (Email optional)
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Preferences (v1)

- Users can opt out of non-critical emails per category.

- Critical alerts (late shipping, overdue deinstall, approval required, review overdue) are not fully disableable.

- Store email defaults to minimal: proof rejection + deinstall required + critical reminders (configurable).

# Escalation Rules (Defaults)

- Late shipping: evaluate per campaign rule; escalate to PSP + brand.

- Verification SLA: overdue escalates to Regional â†’ Brand (schedule configurable per campaign).

- Deinstall overdue: brand optional case creation; otherwise escalation only.


---

### App A.05 --- SUPP-005: Shared Foundations - Exports Reports Output Contracts (v0.3)

Date: 2025-12-17

Purpose: Define export/report outputs (schemas and minimum fields) for deterministic pipelines across CSV/XLSX, PDF, JSON, XML. Supports retention-aware media handling.

# Formats & Priority (v1)

- Primary: CSV/XLSX

- Secondary: PDF (summaries + proof packets)

- Tertiary: JSON

- Quaternary: XML

# Required Export Packages (v1)

  ------------------------------------------------------------------------------------------------------------------------------------------------------
  Package                             Purpose                                                      Formats
  ----------------------------------- ------------------------------------------------------------ -----------------------------------------------------
  Campaign Summary                    Progress + exceptions + policy settings                      CSV/XLSX + PDF + JSON + XML

  Store Orders (Line-level)           Fulfillment-ready per-store order lines                      CSV/XLSX + JSON + XML

  Shipments & Tracking                Partial shipments, tracking numbers, delivery confirmation   CSV/XLSX + PDF + JSON + XML

  Execution & Proof                   Per item/location status + proof references + outcomes       CSV/XLSX + PDF + JSON + XML

  Verification & Retakes              Review decisions + reason codes + retake tasks               CSV/XLSX + JSON + XML

  Issues & Reorders                   Requests, approvals, evidence refs, substitutions            CSV/XLSX + PDF + JSON + XML

  Non-Compliance Cases (if enabled)   Deinstall overdue cases and resolution                       CSV/XLSX + JSON + XML

  Retention Export Bundle             Pre-purge archive bundle                                     ZIP manifest + CSV/XLSX + PDF + JSON/XML (optional)
  ------------------------------------------------------------------------------------------------------------------------------------------------------

# Minimum Fields (Additions)

- All exports include stable IDs plus business keys (storeNumber + storeGuidAlias).

- Media fields: include mediaAssetId and (if within retention) a short-lived URL; do not assume permanence.

- Include campaign policy fields: verificationMode (STRICT/FAST), verificationSlaHours, approvalMode, deinstallProofRequired, nonComplianceCaseEnabled.

## Key Field Sets (Draft)

Campaign Summary: campaignId, name, brandId, pspId, type, startDate, shipByDate, installByDate, endDate, verificationMode, verificationSlaHours, approvalMode, deinstallProofRequired, storeCountAssigned, storeCountComplete, completionPercent, lateShippingCount, anomalyCount, reorderCount, photoRejectionCount, reviewOverdueCount.

Execution & Proof (line): campaignId, storeId, storeNumber, itemId, locationSlotId, executionStatus, installedAt, submittedAt, slotVerificationStatus, requiredMinCount, approvedCount, waivedCount, attestationUserId, attestationAt.

Verification & Retakes: photoLinkId, mediaAssetId, reviewStatus, reasonCode, comments, reviewerId, reviewedAt, retakeTaskId, retakeStatus, dueAt.

Issues & Reorders: issueRequestId, issueLineId, itemId, qty, reasonCode, evidenceAssetIds, approvalStatus, approverId, decidedAt, reorderId, replacementShipmentIds, assetSubstitutionId(optional).

# PDF Guidance (v1)

- Default PDF uses thumbnails + links (full-res optional toggle).

- Proof packets grouped by store; rejected items called out with reason codes.

- Include policy summary page (verificationMode, SLA, deinstall requirements).

# Open Decisions

- Confirm required columns after reviewing 1--2 historical Good2Go campaigns.

- If XML needs a specific partner schema vs generic export in v1.


---

### App A.06 --- SUPP-006: Shared Foundations - Webhooks and Inbound API Event Contract (v0.4)

Date: 2025-12-18

Purpose: Integration contract for outbound webhooks (system â†’ PSP/brand) and inbound API writes (PSP automation â†’ system) including signing, idempotency, retries, schema versioning, and required event types.

Revision note: This SUPP is a full replacement. It incorporates overlapping material from SUPP-028_Webhook_Security_Event_Envelope_and_Idempotency_v0_1.docx as an appendix for traceability; where conflicts exist, the main body of this SUPP is authoritative.

# Outbound Webhooks (v1)

- Delivery: at-least-once with retries; consumers must dedupe by eventId.

- Security: HMAC signature + timestamp header; secret rotation supported.

- Headers (draft): X-NewPOPSys-Event, X-NewPOPSys-Event-Id, X-NewPOPSys-Timestamp, X-NewPOPSys-Signature-256, X-NewPOPSys-Schema-Version

- Envelope: {eventId, eventType, occurredAt, schemaVersion, pspId, brandId?, campaignId?, storeId?, correlationId?, data:{\...}}

- Operational: delivery logs, retry schedule, dead-letter after N failures, manual replay UI.

# Required Webhook Events (v1 Minimum)

  ------------------------------------------------------------------------------------------------------------------------
  Event Type                            When Fired                                        Primary Recipients
  ------------------------------------- ------------------------------------------------- --------------------------------
  order.created                         Orders generated for campaign publish             PSP

  order.updated                         Order status/fields updated                       PSP (+ Brand optional)

  shipment.created                      Shipment created (partial allowed)                PSP (+ Brand)

  shipment.updated                      Tracking/status updated; multi-tracking allowed   PSP + Brand (+ Store optional)

  batch.updated                         Batch created/updated or membership changed       PSP

  alert.late_shipping                   Late shipping threshold breached (per campaign)   PSP + Brand

  alert.execution_anomaly               Receive/verify or completion anomaly detected     Brand

  proof.submitted                       Store submits completion (STRICT/FAST)            Brand/Regional

  photo.rejected                        Admin rejects photo(s) with comments/reason       Store

  review.overdue                        Verification SLA breached                         Brand/Regional

  issue.submitted                       Issue/reorder submitted                           PSP (+ Brand policy-based)

  issue.approval_required               Approval needed by brand/regional                 Brand/Regional

  issue.decided                         Issue approved/rejected                           PSP (+ Store optional)

  reorder.shipment.updated              Replacement shipment status/tracking updated      PSP + Brand

  campaign.expired.deinstall_required   Campaign end triggers deinstall                   Store + Brand/PSP

  deinstall.overdue                     Deinstall overdue (grace exceeded)                Brand/Regional

  noncompliance.case_created            Case created when enabled                         Brand/Regional
  ------------------------------------------------------------------------------------------------------------------------

# Inbound API Writes (v1)

- All write endpoints require Idempotency-Key header; server returns same response for duplicates.

- Auth: API keys per PSP tenant; least-privilege scopes per key; rotate/revoke supported.

- Minimum write scopes: update order status; create/update shipments + tracking; manage batches; trigger exports.

- Optional v1: store bulk upsert (if enabled for PSP integration user).

# Idempotency & Correlation

- Inbound: Idempotency-Key + stable request hash; store key for replay window.

- Outbound: eventId is globally unique; consumers dedupe by eventId.

- Correlation: correlationId links campaign â†’ orders â†’ shipments â†’ execution â†’ exports.

# Schema Versioning

- Events include schemaVersion (e.g., 1.0). Breaking changes increment major; additive changes increment minor.

- Consumers should ignore unknown fields and handle eventType + schemaVersion explicitly.

# Sample Event (order.created)

\`\`\`json\
{\
\"eventId\": \"evt_123\",\
\"eventType\": \"order.created\",\
\"occurredAt\": \"2025-12-17T18:00:00Z\",\
\"schemaVersion\": \"1.0\",\
\"pspId\": \"psp\_\...\",\
\"brandId\": \"br\_\...\",\
\"campaignId\": \"cmp\_\...\",\
\"correlationId\": \"corr\_\...\",\
\"data\": {\
\"orderId\": \"ord\_\...\",\
\"orderNumber\": \"G2G-000123\",\
\"storeId\": \"sto\_\...\",\
\"status\": \"GENERATED\"\
}\
}\
\`\`\`

# Open Decisions

- Whether PSP webhook registration requires IP allowlists in pilots.

- Exact retry schedule and dead-letter thresholds (recommend: exponential backoff + max 24h).

# Appendix --- Integrated Material (for traceability)

SUPP-028 --- Webhook Security, Event Envelope & Idempotency (v0.1)

Date: 2025-12-17

Purpose: Define webhook security and delivery contracts: signing, replay protection, envelope format, and idempotency requirements for inbound integration writes. This closes the gap between SUPP-006 (events) and Module 20 physical schema (outbox/idempotency).

# Locked Decisions

  -----------------------------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- -----------------------------------------------------------------------------------
  Webhook signing                     1A --- HMAC SHA-256 signature header (Prod/Staging). Dev may disable signing (1C)

  Replay protection                   2A --- Timestamp + nonce window

  Payload format                      3A --- Standard event envelope

  Inbound idempotency                 4A --- Require Idempotency-Key header on integration writes
  -----------------------------------------------------------------------------------------------------------------------

# 1) Webhook Signature (HMAC SHA-256)

- Header: X-NewPOPSys-Signature: sha256=\<hex\>

- Header: X-NewPOPSys-Timestamp: \<unix_ms\>

- String to sign: \<timestamp\>.\<raw_body_bytes\>

- Signature: HMAC_SHA256(secret, string_to_sign)

- Dev mode: signing can be disabled for localhost testing, but should be on in staging/prod.

# 2) Replay Protection (2A)

- Receiver validates timestamp is within allowed window (default Â±5 minutes).

- Receiver validates nonce/eventId not seen before within window (store nonce/eventId hash).

- If timestamp outside window: reject with 401/403 and log as \'replay_window_violation\'.

# 3) Event Envelope (3A)

All webhook deliveries use this envelope (payload varies by type/version):

\`\`\`json\
{\
\"eventId\": \"uuidv7\",\
\"type\": \"campaign.order.created\",\
\"version\": 1,\
\"occurredAt\": \"2025-12-17T00:00:00.000Z\",\
\"tenantId\": \"uuidv7\",\
\"brandId\": \"uuidv7\",\
\"correlationId\": \"uuidv7\",\
\"actor\": { \"type\": \"system\|human\|integration\", \"id\": \"uuidv7\" },\
\"payload\": { }\
}\
\`\`\`

- type is namespaced and stable; version increments on breaking changes.

- payload schemas are defined in shared Zod + OpenAPI (SUPP-020 + Module 21).

# 4) Inbound Integration Writes --- Idempotency (4A)

- All integration write endpoints require Idempotency-Key for POST/PUT that mutate state.

- Server stores {tenantId, key, method, path, request_hash, response_hash, created_at, expires_at}.

- If duplicate key is received: return original response (same status code + body).

- If key reused with different request_hash: return 409 conflict (idempotency_key_reuse).

# 5) Response Codes (Recommended)

  ----------------------------------------------------------------------------------
  Scenario                                       Code
  ---------------------------------------------- -----------------------------------
  Signature invalid                              401 Unauthorized

  Timestamp/nonce replay                         403 Forbidden

  Webhook accepted                               2xx (200/202)

  Receiver temporarily failing                   5xx (will retry per SUPP-027)

  Idempotency key missing                        400 Bad Request

  Idempotency key reuse with different payload   409 Conflict
  ----------------------------------------------------------------------------------

# 6) Implementation Notes

- Webhooks are at-least-once delivery; consumers must be idempotent.

- Prefer responding quickly (200/202) and doing heavy work async on consumer side.

- Keep secrets rotated: store current + previous secret for grace period; support key rotation in UI.

# Acceptance Criteria

1.  Staging/prod webhook signatures validate and reject tampered bodies.

2.  Replay protection blocks old timestamps and duplicate eventIds within window.

3.  Event envelope is emitted consistently for all webhook types.

4.  Integration endpoints enforce Idempotency-Key and return consistent responses on repeats.

5.  Dev can disable signing only for localhost and only when configured explicitly.


---

### App A.07 --- SUPP-007: Shared Foundations - Completion Expiration Overrides (v0.4)

Date: 2025-12-17

Purpose: Definitive rules for store completion, campaign completion, expiring vs non-expiring campaigns, deinstall workflows, brand-optional case creation, and administrative overrides.

# Campaign Types (v1)

  ---------------------------------------------------------------------------------------
  Type                                Expiration Behavior
  ----------------------------------- ---------------------------------------------------
  Promotional (Expiring)              Has end date; triggers deinstall workflow

  Core Branding (Non-expiring)        No end date; deinstall only if manually triggered
  ---------------------------------------------------------------------------------------

# Store Completion States (v1)

  -----------------------------------------------------------------------------------------------------
  State                   Meaning                                          Typical Actor
  ----------------------- ------------------------------------------------ ----------------------------
  IN_PROGRESS             Work not certified yet                           STORE_USER

  SUBMITTED_FOR_REVIEW    Submitted; awaiting admin review (STRICT mode)   STORE_USER

  REWORK_REQUESTED        Rejected proof; retake required                  REGIONAL/BRAND

  COMPLETE                Certified complete; proofs satisfied or waived   STORE_USER or ADMIN waiver
  -----------------------------------------------------------------------------------------------------

# Verification Mode (Per Campaign)

- STRICT: store submission goes to SUBMITTED_FOR_REVIEW and is not COMPLETE until proofs satisfied or waiver applied.

- FAST: store becomes COMPLETE immediately on submission; if proofs later rejected, store auto-reopens to REWORK_REQUESTED.

- Both modes require audit events for waiver/reopen and preserve review outcomes for reporting.

# Store Completion Definition (Normal Path)

- Receive/verify completed (or documented exceptions).

- Install completed for required items/locations.

- Completion survey submitted.

- Required photo slots submitted per brand rules.

- Signature/attestation checkbox recorded (userId + timestamp).

# Completion Waivers (Allowed)

- BRAND_ADMIN or REGIONAL_ADMIN may waive missing required proofs and mark store COMPLETE.

- Waiver requires reason; emit audit event store.completion_waived; record which requirements were waived.

# Reopen Rules

- BRAND_ADMIN and REGIONAL_ADMIN may reopen a completed store (reason required; emit store.reopened).

- In FAST mode, photo rejection automatically reopens the store into REWORK_REQUESTED.

# Campaign Completion Definition

- A\) All assigned stores reach COMPLETE; OR

- B\) BRAND_ADMIN force-completes campaign (reason required; emit campaign.force_completed); OR

- C\) For expiring campaigns: end date reached AND required deinstall workflow completed (if enabled).

# Expiration & Deinstall (Expiring Campaigns)

- On end date: deinstall task created; notify store + brand + PSP.

- Deinstall survey + attestation required; photo proof optional by default and configurable per campaign.

- Deinstall overdue triggers escalation after grace period (per campaign config).

- Brand/campaign may enable NonComplianceCase creation for overdue deinstall (see SUPP-019).

# Retention Clock Trigger

- Retention clock (proof media purge) starts at campaign completion timestamp.

- If campaign is force-completed, retention still starts and records the incomplete stores snapshot.

# Config Fields (Draft)

  -------------------------------------------------------------------------------------
  Field                               Meaning
  ----------------------------------- -------------------------------------------------
  verificationMode                    STRICT \| FAST

  verificationSlaHours                hours until review overdue triggers escalations

  deinstallProofRequired              true/false (default false)

  deinstallGraceDays                  grace period before overdue escalation

  nonComplianceCaseEnabled            true/false (brand optional)
  -------------------------------------------------------------------------------------


---

### App A.08 --- SUPP-008: Shared Foundations - Data Retention Classification Policy (v0.4)

Date: 2025-12-17

Purpose: Enforce v1 90-day retention for heavy campaign artifacts while retaining master data, reusable definitions, and an asset registry to support reprints/inventory/repeat campaigns without becoming an archive/DAM.

# Locked Decisions (v1)

  --------------------------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- --------------------------------------------------------------------------------------------------------------
  Option A selected                   Asset Registry (metadata + pointers), not an asset vault

  Heavy proof media retention         90 days after campaign completion (default)

  Binary storage                      External pointers and/or PSP-managed S3 bucket (tenant configurable)

  Keep forever-ish                    Campaign records (light), audit events, store surveys/templates/kit definitions (while active or referenced)

  Exports                             Offer export bundle prior to purge; exports are regeneratable (avoid sprawl)
  --------------------------------------------------------------------------------------------------------------------------------------------------

# Retention Principle

- Delete heavy artifacts on a clock; keep lightweight accountability.

- Never lose the 'how we decided' records (audit, selection recipe, review outcomes).

- Keep what enables repeatability: templates, kit/item definitions, photo rule presets, and asset registry pointers.

# Data Classes & Retention

  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Class                             Examples                                                                  Retention                     Notes
  --------------------------------- ------------------------------------------------------------------------- ----------------------------- ----------------------------------------------------
  A. Campaign Proof Media (Heavy)   Install photos, receipt photos, deinstall photos, optional videos         90 days post completion       Lifecycle job purge; export bundle first

  B. Campaign Records (Light)       Campaign metadata, assignments, statuses, review outcomes, audit events   Long horizon (configurable)   Default recommended: 2--5 years; can be indefinite

  C. Store Master Data              Stores, regions/groups, store layout/survey responses                     While active                  Not tied to campaign completion

  D. Reusable Definitions           Survey templates/versions, kit/item templates, photo rule presets         While referenced              Supports repeat campaigns

  E. Asset Registry                 Asset metadata, checksum, version, tags, pointer URI                      While referenced              Binary external or tenant storage

  F. Exports                        Generated CSV/XLSX/XML/JSON/PDF                                           Short-lived                   Regenerate on demand; avoid storing forever
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Asset Registry Behavior (Option A)

- Asset record stores: filename, type/MIME, checksum, version, tags, createdBy/createdAt, and pointer URI.

- Pointer targets may be tenant-configured:

- \- PSP-managed S3 object (tenant bucket), OR

- \- Brand-provided external link (validated allowlist).

- v1 may cache thumbnails/previews for UX but does not guarantee long-term binary hosting.

# Purge Workflow (v1)

1.  At campaign completion, schedule purge of Class A media at +90 days (default).

2.  Generate and notify export bundle availability before purge (configurable lead time).

3.  Purge job deletes binaries (or marks for delete if external is PSP bucket) and scrubs direct URLs; keep mediaAssetId + manifest records.

4.  Retain audit trail of purge action (actor=system).

# Export Bundle Requirement

- Bundle includes: campaign summary, store completion status, verification outcomes, issues/reorders, audit events, and media manifest.

- If binaries still within retention: optional ZIP download; otherwise manifest only (IDs + pointers if allowed).

# Open Decisions / TODOs (Need Inputs)

- Default long-horizon setting for Class B (recommend 5 years unless customer requires indefinite).

- External link validation policy (allowed domains/filetypes; HEAD check; expiry handling).

- Whether any v1 campaigns include video (cost driver).


---



## Appendix B --- Brand Admin Module

### App B.01 --- SUPP-013: Brand Admin Module - Stores Regions Groups (v0.2)

Date: 2025-12-17

Purpose: Define store master data, hierarchical geography, custom groupings, import/update flows, and how changes interact with active campaigns and fulfillment.

# Locked Decisions (Module 2)

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- -------------------------------------------------------------------------------------------------------------------------------------
  Canonical Store Identifiers         Store Number + external GUID alias (both stored; one primary key strategy)

  Hierarchy Depth                     Region â†’ District â†’ Territory â†’ Store (District/Territory optional layers)

  Custom Groups Ownership             Regional Admin + Brand Admin can create/edit groups

  Store Address Changes               Prefer always reflect latest store record; add verification prompt before fulfillment; freeze shipping snapshot on generated orders

  Import & Integration                CSV/XLSX import + API import endpoint (v1)

  Integration User Scope              Platform/PSP-level service account; permitted across all brands within the PSP tenant
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1) Data Model (Conceptual)

- Store identifiers:

- \- storeId (ULID/UUID PK)

- \- storeNumber (brand-facing unique identifier; required)

- \- externalStoreGuid (optional; for brand/PSP system mapping)

- Geography:

- \- Region (required)

- \- District (optional; belongs to Region)

- \- Territory (optional; belongs to District or Region depending on model)

- Store belongs to exactly one Region. District/Territory are nullable references to support optional layers.

- Groups: StoreGroup (custom grouping) with many-to-many StoreGroupMembership(storeId, groupId).

# 2) Store Import & Update Flows (Inputs â†’ Outputs)

  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  Flow                    User/Input                              System Output
  ----------------------- --------------------------------------- ------------------------------------------------------------------------------------------------
  CSV/XLSX Import         Brand Admin uploads store file          Creates/updates stores; validates duplicates; logs audit events; returns import report

  API Import              Integration user posts store payloads   Upserts stores; returns per-row results; emits audit events; supports idempotency

  Manual Edit             Admin edits store fields                Updates store; triggers verification prompts for active campaigns (if critical fields changed)
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------

# 3) Required Store Fields (v1 Minimum)

- storeNumber (required), storeName, address1, address2, city, state/province, postalCode, country

- regionId (required), districtId (optional), territoryId (optional)

- primaryContactName/email/phone (optional), storeManagerName (optional)

- status (active/inactive), notes

- externalStoreGuid (optional)

# 4) How Store Changes Interact with Active Campaigns

- Master record: store master data always reflects latest known truth (preferred).

- Fulfillment safety: if a critical shipping field changes (address fields, storeNumber, region), and the store is assigned to an active campaign before orders are shipped:

- \- System creates a \'Store Change Verification\' task for Brand Admin + PSP Ops to acknowledge/approve.

- \- Until verified, fulfillment for that store may be paused (configurable).

- Shipping snapshot: once an Order/Shipment is created, the order record stores a snapshot of shipping fields used for that fulfillment run (immutable for audit).

# 5) Custom Groups (v1)

- Group types: custom (user-defined) groups used for store selection and reporting.

- Creators/editors: Regional Admin + Brand Admin (within their scope).

- Group membership: store can belong to multiple groups; membership changes are audit-logged.

- Campaign selection supports: include/exclude by groups and by hierarchy filters (region/district/territory).

# 6) APIs (Draft Endpoint List)

- GET /stores (filter by region/district/territory/group, search, pagination)

- POST /stores/import (CSV/XLSX upload)

- POST /stores/bulkUpsert (API import; integration user)

- PATCH /stores/{storeId} (manual edit)

- GET/POST/PATCH /storeGroups and /storeGroups/{id}/members

- GET /regions, /districts, /territories (hierarchy management; optional admin endpoints)

- POST /storeChanges/{changeId}/verify (Brand + PSP acknowledgement)

# 7) Acceptance Criteria (Module 2)

1.  Admin can import stores via CSV/XLSX and receive an import report with created/updated/skipped rows.

2.  Integration user can upsert stores via API with idempotency support.

3.  Geography filters support optional layers (Region only; Region+District; Region+District+Territory).

4.  Admins can create custom groups and assign stores; store can belong to multiple groups.

5.  Campaign store selection can include/exclude by group and by hierarchy.

6.  Critical store changes for active campaigns create verification tasks and preserve order shipping snapshots.

# Open Decisions

7.  Define which fields are \'critical\' to trigger verification (address, storeNumber, region, contacts?).

8.  Decide whether verification blocks fulfillment automatically or only warns (default: blocks for address changes).

9.  Confirm whether territory belongs to district only (strict) or can be directly under region (flex).


---

### App B.02 --- SUPP-014: Brand Admin Module - Survey Builder Layout Photo Rules (v0.4)

Date: 2025-12-18

Purpose: Deterministic specification for store-based surveys, store layout/location slots, repeatable sections, conditional logic, and brand-owned photo requirements (defaults + overrides).

Revision note: This SUPP is a full replacement. It incorporates overlapping material from SUPP-009_Survey_Builder_and_Photo_Rules_v0_3.docx as an appendix for traceability; where conflicts exist, the main body of this SUPP is authoritative.

# Locked Decisions (Module 3)

  ----------------------------------------------------------------------------------------------------------------------
  Topic                                Decision
  ------------------------------------ ---------------------------------------------------------------------------------
  Conditional logic (v1)               YES --- basic show/hide + required-if rules

  Repeatable sections (v1)             YES --- repeatable blocks (e.g., Cooler #1..#N, Door #1..#N)

  Location slots architecture          Store Layout section (separate) referenced by surveys

  Photo rules granularity              Both: campaign-wide defaults + per-item/per-location overrides

  Asset Registry pointers (Option A)   Both: PSP-managed storage + Brand-provided links (tenant configurable)

  Survey response edits                Store user + Regional/Brand admins can edit on behalf of store (audit required)
  ----------------------------------------------------------------------------------------------------------------------

# 1) Conceptual Data Model

- SurveyTemplate â†’ SurveyVersion (immutable) defines schema and UI layout for responses.

- StoreLayout defines reusable location slots for a store; surveys reference locationSlotId values.

- RepeatableSection definitions allow multiple instances of the same block (e.g., Cooler instances).

- StoreSurveyResponse stores answers + references to location slots and media assets.

## Entities (Draft)

  -------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- -------------------------------------------------------------------------------------------
  SurveyTemplate                      templateId, brandId, name, description, createdBy

  SurveyVersion                       versionId, templateId, versionNumber, schemaJson (JSONB), uiJson, createdAt

  StoreLayout                         layoutId, storeId, versionNumber, createdAt, createdBy

  LocationSlot                        slotId, layoutId, name, type, order, tags, referenceMediaAssetId(optional)

  RepeatableSection                   sectionId, surveyVersionId, name, minInstances, maxInstances, instanceLabelPattern

  StoreSurveyResponse                 responseId, storeId, surveyVersionId, layoutId, answersJson (JSONB), updatedAt, updatedBy

  ResponseEditAudit                   editId, responseId, actorId, actorRole, reason, beforeHash, afterHash
  -------------------------------------------------------------------------------------------------------------------------------

# 2) Store Layout (Location Slots)

- Store Layout is a dedicated module/section where admins define the store's physical placement slots.

- Slots are reusable across campaigns and surveys; campaigns bind proof photos to these slots.

- Slot types (v1 baseline): signage location, fixture, window, door, pump, cooler, aisle/endcap, custom.

- Slots may include reference imagery/mockups to guide capture.

# 3) Survey Builder (Store-Based)

- Survey builder supports templating/duplication and immutable versioning.

- Survey schema stored as JSON Schema (or equivalent) in SurveyVersion.schemaJson (Postgres JSONB).

- Survey references store layout slots via fields that bind to locationSlotId values.

- Regional/Brand admins can edit responses on behalf of store; edits require reason + audit.

# 4) Conditional Logic (v1)

- Logic types:

- \- show/hide field based on answer

- \- required-if based on answer

- \- enable/disable based on answer

- Rule storage: logicRules\[\] inside schemaJson with predicate + effect.

- At minimum, logic must be evaluated client-side for UX and server-side for validation.

# 5) Repeatable Sections (v1)

- Repeatable blocks allow N instances (e.g., Cooler #1..#N).

- Each instance may create new LocationSlots or bind to existing slots depending on configuration.

- Constraints: minInstances/maxInstances; instance naming convention for UI and exports.

# 6) Photo Requirements Model (Brand-Owned)

- Brand defines photo requirements because it benefits the brand, not PSP.

- Photo rules exist at two levels:

- \- Campaign-wide defaults (e.g., 1 photo per item/location, suggested angles)

- \- Overrides per KitItemDefinition and per LocationSlot (e.g., 3 angles required for Front Door decal)

- Photos are stored as MediaAsset records; PhotoLink binds asset â†’ campaign/store/item/locationSlot requirement.

## PhotoRule Entity (Draft)

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------
  PhotoRule                           ruleId, scopeType(campaignDefault\|itemOverride\|slotOverride\|item+slot), campaignId, itemId?, slotId?, minCount, requiredAngles\[\], suggestedAngles\[\], notes

  PhotoLink                           linkId, campaignId, storeId, itemId, slotId, ruleId, mediaAssetId, createdAt, createdBy

  PhotoReview                         reviewId, photoLinkId, status(approved\|rejected), reviewerId, comments, rejectedReasonCode, createdAt
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 7) Inputs â†’ Outputs (Build Guide)

  ------------------------------------------------------------------------------------------------------------------------------------
  User Input                                                          Expected Output
  ------------------------------------------------------------------- ----------------------------------------------------------------
  Admin defines/updates Store Layout slots                            LocationSlots created; version incremented; audit logged

  Admin builds/duplicates a SurveyTemplate; publishes SurveyVersion   Version locked; schemaJson stored; available for stores

  Store (or admin) completes survey response                          StoreSurveyResponse saved; validation enforced; audit logged

  Brand sets campaign default photo rules + item/slot overrides       PhotoRule records created; enforced on completion requirements
  ------------------------------------------------------------------------------------------------------------------------------------

# 8) APIs (Draft Endpoint List)

- GET/POST/PATCH /storeLayouts and /storeLayouts/{layoutId}/slots

- GET/POST /surveyTemplates; POST /surveyTemplates/{id}/duplicate

- POST /surveyTemplates/{id}/publish (creates SurveyVersion)

- GET/POST/PATCH /stores/{storeId}/surveyResponses

- POST /surveyResponses/{id}/editOnBehalf (requires reason; admin only)

- GET/POST/PATCH /campaigns/{id}/photoRules (defaults + overrides)

# 9) Acceptance Criteria (Module 3)

1.  Admins can define store layout slots in a dedicated module and reference them from surveys.

2.  Survey builder supports templates, duplication, and immutable version publishing.

3.  Conditional logic works for show/hide + required-if and is validated server-side.

4.  Repeatable sections support multiple instances with min/max constraints.

5.  Brand can set campaign-wide photo defaults and override per item and per slot.

6.  Regional/Brand admins can edit store survey responses on behalf of store with a required reason and audit trail.

# Open Decisions

7.  Whether repeatable section instances automatically create new location slots (recommended: configurable per section).

8.  Whether layout changes require campaign verification prompts when a store is mid-campaign (likely yes for critical slot changes).

9.  Whether survey version pinning is per campaign or always latest (recommended: campaigns pin SurveyVersion at assignment time).

# Appendix --- Integrated Material (for traceability)

SUPP-009 --- Survey Builder & Photo Rules (v0.3)

Date: 2025-12-17

Purpose: Implement a deterministic, brand-configurable survey + location-slot model so campaigns conform to each store's realities, proofs attach to the right placements, and future AI compliance is possible.

# Locked Requirements

- Surveys are store-based and updated when stores change (remodels, new ad areas, etc.).

- Stores are not identical; campaigns conform to store survey + layout.

- Surveys must be templatable/duplicable with immutable versioning.

- Brands need flexible field types (schema-driven forms).

- Image-driven UX: product templates, mockups, and artwork accelerate decisions and accuracy.

- Photos are tied to item + location slot dictated by store survey; brand defines requirements (defaults + overrides).

- Signature/attestation is a checkbox capturing user identity + timestamp (completion + reorder certification).

# Survey Builder --- Field Types (v1 Minimum)

  --------------------------------------------------------------------------------------------------
  Category                            Types
  ----------------------------------- --------------------------------------------------------------
  Text & choices                      text, textarea, number, single-select, multi-select, boolean

  Time & structure                    date

  Files/media                         file upload, photo upload

  Certification                       attestation checkbox (signature-like)
  --------------------------------------------------------------------------------------------------

# Strongly Recommended v1 (Scaffold if not full)

- Conditional logic (show/hide) and validations: scaffold data model even if UI is basic.

- Repeatable sections: scaffold for multi-cooler/endcap scenarios (store-specific).

- Template import/export (JSON) for rapid iteration and portability.

# Versioning & Binding

- SurveyTemplate â†’ immutable SurveyVersion (published) â†’ StoreSurveyResponse (answers).

- Campaigns pin SurveyVersion by default at assignment time; controlled \'Rebase to Latest\' creates verification tasks when fulfillment started.

- Optional snapshot at campaign publish for audit/reporting (recommended).

# Location Slots & Layout Model

- Store survey defines LocationSlots (named placements).

- Each LocationSlot can include: name, category, notes, reference images, and optional geometry metadata (future).

- Campaign kit items map to one or more LocationSlots per store assignment.

# Photo Rules

- Rules are brand-owned (benefit of the brand), applied per campaign and can override per item and per location slot.

- Rules include: requiredMinCount, suggestedAngles, reference mockups, and capture guidance text.

- Admins (Regional and above) approve/reject; rejection triggers retake workflow.

- v1 supports brand rejection of photos (manual); future scope: AI analysis and automatic rejection suggestions.

# Data Storage Approach (Deterministic)

- Store schemas as JSON schema (or equivalent) + typed response JSON.

- Index selected fields (storeNumber, region path, slot names/categories) to support filtering and store selection UX.

# APIs (Draft)

- POST /surveyTemplates; POST /surveyTemplates/{id}/publishVersion

- GET/PUT /stores/{storeId}/surveyResponses (store or admin edits per RBAC)

- GET /stores/{storeId}/locationSlots

- POST /campaigns/{id}/photoRules (defaults + overrides)

# Acceptance Criteria

10. Brand can create a survey template, publish a version, duplicate it, and assign to stores.

11. Store/layout slots exist and can be referenced in campaign kits/assignments.

12. Campaigns pin survey versions; rebase creates audit + verification tasks when fulfillment started.

13. Photo rules bind to item+slot; required minimums enforced at submission; admins can reject with reason codes; store can retake only rejected photos.

14. Attestation checkbox is captured on completion and on issue/reorder submissions where required.

# Open Decisions / TODOs (Need Inputs)

- Conditional logic v1 scope (examples from 1--2 historical campaigns).

- Repeatable sections v1 scope (how common in Good2Go and VG campaigns).

- Validation rules: required-if, min/max photos per slot, range constraints.


---

### App B.03 --- SUPP-015: Brand Admin Module - Campaigns Kits Assignment (v0.2)

Date: 2025-12-17

Purpose: Define campaign creation, store selection/inclusion-exclusion, kit modeling, version pinning, and order-generation triggers. This is the core engine that drives fulfillment and execution.

# Locked Decisions (Module 4)

  --------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- --------------------------------------------------------------------------------------------
  Campaign assignment versioning      Pin SurveyVersion + LayoutVersion at assignment time (default)

  Version flexibility                 Allow controlled \'Rebase to Latest\' with admin approval + audit + verification tasks

  Kit modeling                        Kit includes items + required location slot mappings (per store layout slots)

  Order generation trigger            Generate orders on campaign publish (default); manual \'Generate Orders\' backup if needed

  Store selection precedence          Start with \'All\' â†’ subtract exclusions; inclusions add to base selection as needed

  Install instructions/assets         Both campaign-level and item-level instructions

  Campaign type default               Default = Expiring promotional campaign unless marked Core Branding (non-expiring)
  --------------------------------------------------------------------------------------------------------------------------------

# 1) Campaign Types (v1)

  ------------------------------------------------------------------------------------------------------
  Type                           Default?          Has End Date?     Deinstall Workflow
  ------------------------------ ----------------- ----------------- -----------------------------------
  Promotional (Expiring)         Yes               Yes               Enabled by default (configurable)

  Core Branding (Non-expiring)   No (opt-in)       No                Manual only (future options)
  ------------------------------------------------------------------------------------------------------

# 2) Store Selection Model (Inclusions/Exclusions)

- Selection sources: individual stores, by group, by region/district/territory, all stores.

- Evaluation precedence (v1):

- 1\) Base set = ALL stores (if selected) OR explicit inclusions (if not).

- 2\) Apply include filters (add stores): specific stores, groups, regions.

- 3\) Apply exclusions (subtract stores): specific stores, groups, regions.

- All selection operations must be deterministic and stored as a selection \'recipe\' for reproducibility (exportable JSON).

## Selection Recipe (Draft Schema)

Example JSON (draft):\
{\
\"mode\": \"ALL\",\
\"include\": \[{\"type\":\"group\",\"id\":\"grp\_\...\"},{\"type\":\"store\",\"id\":\"sto\_\...\"}\],\
\"exclude\": \[{\"type\":\"region\",\"id\":\"reg\_\...\"}\]\
}

# 3) Version Pinning Strategy (Survey + Layout)

- Default: when a store is assigned to a campaign, the system pins:

- \- surveyVersionId (immutable schema/UI for that campaign)

- \- layoutVersionId (store layout/location slots as of assignment)

- Rationale: prevents moving targets during execution and ensures proofs map to stable location slots.

- 

- Flexibility (\'Reality happens\'): allow controlled \'Rebase to Latest\' when store survey/layout updates are unavoidable.

- Rebase rules (v1):

- \- Only BRAND_ADMIN or REGIONAL_ADMIN may initiate.

- \- System creates verification tasks for BRAND_ADMIN + PSP_OPS if fulfillment already started.

- \- System records a diff summary + emits audit event campaign.assignment_rebased.

- \- Execution tasks and photo requirements must be recalculated after rebase.

# 4) Kit Model (Items + Location Slot Mappings)

- KitDefinition: reusable kit template for a campaign (can be copied per campaign).

- KitItemDefinition: item template containing SKU/name, quantities, mockups, and photo rules references.

- Location mapping: items may specify required location slots (by slot type/tag) OR specific slots per store (resolved at assignment time).

- Because stores vary, final itemâ†’slot mapping is resolved per StoreAssignment using that store\'s pinned layout.

## Entities (Draft)

  ----------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- ----------------------------------------------------------------------------------------------------
  Campaign                            campaignId, brandId, name, type, startDate, shipByDate, installByDate, endDate?, status, createdBy

  CampaignSelectionRecipe             campaignId, recipeJson (JSONB), computedStoreCount, computedAt

  StoreAssignment                     assignmentId, campaignId, storeId, surveyVersionId, layoutVersionId, status, createdAt

  KitDefinition                       kitId, campaignId (or templateId), name, notes

  KitItemDefinition                   itemId, kitId, name/SKU, qty, mockupAssetRef, defaultPhotoRuleId, instructionsText/assetRefs

  AssignmentItem                      assignmentItemId, assignmentId, itemId, qty, resolvedSlotBindings (JSONB), status
  ----------------------------------------------------------------------------------------------------------------------------------------

# 5) Order Generation (Default + Backup)

- Default: when campaign is published, system generates:

- \- campaign order totals

- \- per-store orders (one per store assignment unless overridden)

- \- line items mapped from assignment items

- Backup: manual \'Generate Orders\' action exists to recover from integration/API failure or to gate generation in edge cases.

- Every generation run emits audit event order.generation_run and is idempotent (does not duplicate).

# 6) Install Instructions & Assets

- Campaign-level instructions: general rollout guidance, timelines, contact info, FAQs.

- Item-level instructions: location-specific install notes, mockups, required photos, safety guidance.

- Assets are referenced via Asset Registry pointers (Option A).

# 7) APIs (Draft Endpoint List)

- POST /campaigns (create)

- PATCH /campaigns/{id} (edit)

- POST /campaigns/{id}/publish (generates assignments + orders by default)

- POST /campaigns/{id}/computeSelection (preview store count)

- POST /campaigns/{id}/generateOrders (manual backup; idempotent)

- POST /campaigns/{id}/rebaseAssignments (admin-only; triggers verification tasks)

- GET /campaigns/{id}/assignments and /assignments/{id}

- GET/POST/PATCH /kits and /kits/{id}/items

# 8) Acceptance Criteria (Module 4)

1.  Admin can create an expiring campaign with ship/install dates and optional end date.

2.  Admin can select stores using all/region/group/custom includes + exclusions; system previews and persists the selection recipe.

3.  On publish, system creates store assignments and pins survey/layout versions; orders are generated automatically.

4.  If store survey/layout updates occur, admin can rebase assignments to latest with reason; verification tasks are created if fulfillment has started.

5.  Kit items can specify required slot mappings; per-store mapping resolves against pinned store layout.

6.  Campaign instructions and item instructions are both supported; referenced assets use Option A pointers.

# Open Decisions

7.  Define what constitutes \'fulfillment has started\' (order generated vs shipment created) for rebase verification gating.

8.  Define default behavior when a pinned slot no longer exists after rebase (map by tag/type? require manual remap?).

9.  Define whether one store can have multiple orders per campaign in v1 (usually no; future optional).


---

### App B.04 --- SUPP-033: Brand Admin Module - Brand Takeout Export Package Scaffold (v0.1)

Date: 2025-12-17

Purpose: Define the postâ€‘v1 "Takeout" capability at a brand scope: what it includes, how it's delivered, and how it interacts with retention policies. This is a scaffold for future production enhancements (no shadow storage).

# Locked Decisions

  --------------------------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- --------------------------------------------------------------------------------
  Takeout scope                       1B --- Brand-only by default

  Include media                       2C --- Optional per request (metadata-only or full bundle)

  Delivery method                     3C --- Both: download link and push to customer S3

  Retention interaction               4C --- Admin chooses at export time; deleted means deleted (no shadow storage)
  --------------------------------------------------------------------------------------------------------------------

# Principle: No Shadow Storage

- Takeout does NOT resurrect deleted media or records.

- If retention has deleted a blob, takeout can only include the metadata record and note it as deleted/unavailable.

- No hidden backup copies solely for takeout.

# 1) Package Contents (Brand Scope)

- Brand configuration: roles/users (metadata), stores, regions/groups, survey templates, product templates/mockups.

- Campaign records: campaigns, kits, assignments, orders, shipments, proofs, reviews, issues/reorders, completion/deinstall records.

- Audit exports: audit_event (brand-scoped), webhook_delivery logs (optional), export_job history (optional).

- Artifacts: generated exports/reports (CSV/XLSX/PDF/JSON/XML) as available and not expired.

# 2) Media Options (2C)

  -----------------------------------------------------------------------------------------------------------------------
  Option                              What's included
  ----------------------------------- -----------------------------------------------------------------------------------
  Metadata-only                       media_asset rows + URLs (signed) where still present; missing flagged

  Full bundle                         zip/object pack of media still available within retention window; missing flagged
  -----------------------------------------------------------------------------------------------------------------------

Admin selects media mode per takeout request. If full bundle selected, system warns about size/time/cost.

# 3) Delivery Options (3C)

- Download link: async export job generates package and provides time-limited download URL.

- Push to customer S3: brand/tenant supplies bucket + role/credentials; system uploads package and writes manifest.

- Both can be enabled for the same takeout request.

# 4) Retention Choice at Export Time (4C)

- Admin chooses one of: (a) respect retention (default), (b) include all currently-available data regardless of classification, (c) include only "business permanent" classes.

- Regardless of selection: anything already deleted remains deleted/unavailable.

- Export manifest includes counts: included, missing, deleted, suppressed-by-policy.

# Data Contracts

- Takeout produces a manifest.json with versions, schema hashes, and file list.

- Each dataset is exported in stable formats (JSON lines + CSV) to support ingestion.

- Schemas reference OpenAPI/Zod contracts to keep parsing consistent across versions.

# Security Controls

- Only PSP Admin can initiate takeout by default (scaffold delegation later).

- Takeout requests are audited with reason, scope, and delivery method.

- Packages are encrypted at rest (S3 SSE) and optionally encrypted with customer PGP key (future).

# Acceptance Criteria (Scaffold)

1.  A brand-scoped takeout request can be created and run as an async export job (even if postâ€‘v1).

2.  Manifest lists included datasets and flags missing/deleted media clearly.

3.  Delivery supports both download link and push-to-S3 modes.

4.  No shadow storage: exports only include what currently exists.


---


## Appendix C --- PSP Operations Module

### App C.01 --- SUPP-016: PSP Operations Module - Orders Shipments Batches (v0.3)

Date: 2025-12-18

Purpose: Define the PSP operational backbone: order generation structure, partial shipments, batch tracking, PSP portal requirements, and API automation boundaries.

Revision note: This SUPP is a full replacement. It incorporates overlapping material from SUPP-010_Fulfillment_Shipments_Batches_Exports_v0_3.docx as an appendix for traceability; where conflicts exist, the main body of this SUPP is authoritative.

# Locked Decisions (Module 5)

  -----------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- -----------------------------------------------------------------------------------------------
  Order granularity (v1)              Default: 1 order per store per campaign; Supplemental: add-on orders supported (future-ready)

  Partial shipments                   YES --- multiple shipments can fulfill a single store order (partial allowed)

  Batch types                         Enum list (fixed) + optional \'CUSTOM\' type with label

  Late shipping                       Configurable per campaign (rule-based thresholds)

  API writes                          Integration can update order + shipment + batch fields (idempotent)

  PSP portal must-haves               Campaign summary totals + store order list with filters
  -----------------------------------------------------------------------------------------------------------------------------------

# 1) Order Model (v1)

- Default order model: one StoreOrder per StoreAssignment per Campaign.

- StoreOrder contains one or more OrderLine items derived from AssignmentItems.

- Supplemental add-on orders: v1 scaffolds additional StoreOrders linked to the same StoreAssignment (for later add-ons/upsells).

- Every order and line item is immutable in identity; edits create versioned status/history and audit events.

## Entities (Draft)

  -------------------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- -------------------------------------------------------------------------------------------------------------
  StoreOrder                          orderId, campaignId, storeId, assignmentId, orderNumber, status, createdAt, createdBy, shippingSnapshotJson

  OrderLine                           lineId, orderId, itemId, sku/name, qty, unit, batchId?, status

  OrderStatusHistory                  historyId, orderId, fromStatus, toStatus, actorId/actorType, occurredAt, notes
  -------------------------------------------------------------------------------------------------------------------------------------------------

# 2) Shipments Model (Partial + Multi-Tracking)

- A StoreOrder can have 0..N Shipments (partial shipments supported).

- A Shipment can have 1..N tracking numbers (carrier-dependent).

- ShipmentLine optionally maps which OrderLines/quantities were included in a shipment (recommended for partials).

- Shipments updates may be performed via UI or integration API.

## Entities (Draft)

  ------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- ------------------------------------------------------------------------------------
  Shipment                            shipmentId, orderId, status, carrier, shippedAt, deliveredAt, createdAt, createdBy

  ShipmentTracking                    trackingId, shipmentId, trackingNumber, trackingUrl?, status, lastEventAt

  ShipmentLine                        shipmentLineId, shipmentId, orderLineId, qtyShipped
  ------------------------------------------------------------------------------------------------------------------------

# 3) Batch Tracking (v1)

- Batch represents a grouped set of items within a campaign (may span orders).

- Batch types are fixed enums for reporting/automation; CUSTOM type allows freeform labeling.

- Recommended enums (v1): PRODUCTION, PICK_PACK, SHIP_WAVE, INSTALL_WAVE, CUSTOM.

## Entities (Draft)

  ---------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- ---------------------------------------------------------------------
  Batch                               batchId, campaignId, type(enum), label, createdBy, createdAt, notes

  BatchMembership                     batchId, orderLineId (or assignmentItemId), createdAt
  ---------------------------------------------------------------------------------------------------------

# 4) Late Shipping Rules (Per Campaign Config)

- Late shipping is configurable per campaign to support varying complexity.

- Default rule suggestion (if not set): late if order has no shipment created by shipByDate end-of-day in campaign timezone.

- Config fields (draft): lateRuleType (no_shipment_by_date \| not_delivered_by_date \| custom), thresholdDateField(shipByDate), graceHours, escalationSchedule.

- Late shipping event triggers notifications to PSP + Brand Campaign Admin/Manager (per SUPP-004) and emits webhook alert.late_shipping (SUPP-006).

# 5) PSP Portal UX Requirements (v1 Must-Have)

- Campaign summary totals view: store counts, completion %, order counts, shipment counts, exceptions.

- Store order list with filters: by campaign, status, region/district/territory, group, batch, shipment status, late flag.

- Bulk actions (nice-to-have in v1): update status, assign batch, export filtered list.

# 6) API Automation (Integration User)

- Inbound API supports idempotent writes for:

- \- order status updates (and notes)

- \- create/update shipments + tracking numbers

- \- create/update batches and membership assignments

- All endpoints require Idempotency-Key and emit AuditEvents with actorType=integration.

# 7) APIs (Draft Endpoint List)

- GET /orders (filters, pagination)

- GET /orders/{orderId}

- PATCH /orders/{orderId} (status updates; notes)

- POST /orders/{orderId}/shipments

- PATCH /shipments/{shipmentId}

- POST /shipments/{shipmentId}/trackingNumbers

- POST /batches; PATCH /batches/{batchId}; POST /batches/{batchId}/members

- POST /campaigns/{id}/lateShippingConfig (set rules)

# 8) Acceptance Criteria (Module 5)

1.  Publishing a campaign generates one store order per assignment with deterministic line items.

2.  PSP portal shows campaign totals and store order list with filters.

3.  PSP can update order status and shipments in UI; integration can do same via API with idempotency.

4.  Orders support partial shipments with multiple tracking numbers; shipment status changes propagate to brand views and notifications.

5.  Batch types use enum list; CUSTOM batch type supports freeform label; batches can span orders within a campaign.

6.  Late shipping thresholds are configurable per campaign; triggering late creates notifications + webhook event.

# Future Scaffold Notes

- Add-on orders: allow multiple orders per store assignment for later upsells, replacements beyond standard reorder flow, or split billing.

- Carrier integrations: future connector modules (UPS/FedEx/USPS) can populate tracking events automatically.

- Warehouse pick/pack workflows: deeper batch/scan flows can be layered without changing the core entities.

# Appendix --- Integrated Material (for traceability)

SUPP-010 --- Fulfillment, Shipments, Batches & Export Hooks (v0.3)

Date: 2025-12-17

Purpose: PSP-friendly operational model aligned with Module 5 (SUPP-016). Defines statuses, partial shipments, batch enums + CUSTOM, and how fulfillment data feeds exports/webhooks.

# Locked Requirements

- PSP needs campaign totals + store-level orders list.

- Orders generated on campaign publish; PSP alerted via email/webhook; PSP updates via UI or API.

- Partial shipments supported; multiple tracking numbers supported.

- Batch is dynamic but uses fixed enum types in v1 with CUSTOM option.

- Exports priority: CSV/XLSX, PDF, JSON, XML (schemas in SUPP-005).

# Fulfillment Objects (v1)

  ----------------------------------------------------------------------------------------------------
  Object                  Cardinality                          Notes
  ----------------------- ------------------------------------ ---------------------------------------
  StoreOrder              1 per store per campaign (default)   Scaffold add-on orders later

  OrderLine               1..N per order                       Derived from assignment items

  Shipment                0..N per order                       Partial shipments allowed

  ShipmentTracking        1..N per shipment                    Carrier + tracking numbers

  Batch                   0..N per campaign                    May span orders; enums + CUSTOM label
  ----------------------------------------------------------------------------------------------------

# Status Taxonomy (v1)

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Object                              Statuses
  ----------------------------------- -------------------------------------------------------------------------------------------------------------------------------------
  Order                               GENERATED â†’ ACKNOWLEDGED â†’ IN_PRODUCTION â†’ KITTING â†’ READY_TO_SHIP â†’ PARTIALLY_SHIPPED â†’ SHIPPED â†’ DELIVERED â†’ CLOSED (â†’ CANCELLED)

  Shipment                            LABEL_CREATED â†’ IN_TRANSIT â†’ DELIVERED â†’ EXCEPTION â†’ RETURNED
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Batch Types (v1)

- Enums: PRODUCTION, PICK_PACK, SHIP_WAVE, INSTALL_WAVE, CUSTOM

- CUSTOM requires a label; report it as type=CUSTOM and label=\...

# Late Shipping (Per Campaign Config)

- Late threshold is configurable per campaign (complexity varies).

- Default suggestion if unset: no shipment created by shipByDate end-of-day in campaign timezone.

- Triggers alert.late_shipping to PSP + Brand (see SUPP-004) and webhook (see SUPP-006).

# Export Hooks (Feed SUPP-005)

- Fulfillment exports include stable IDs + business keys; include batchId/type/label and shipment tracking fields.

- Retention-aware: include mediaAssetIds/pointers; do not embed permanent URLs.

# Inbound API Writes (Integration User)

- Idempotent endpoints for: order status updates, shipment create/update, tracking updates, batch create/update, batch membership updates.

- All writes emit audit events with actorType=integration and include idempotency key reference.

# Acceptance Criteria

7.  Campaign publish deterministically generates store orders + lines; PSP receives notification.

8.  PSP can manage statuses, shipments, tracking and batches in UI; same operations possible via API with idempotency.

9.  Partial shipment and multi-tracking behave correctly and roll up to order status.

10. Late shipping rules configurable per campaign and trigger notifications/webhooks when breached.

11. Exports contain required operational fields and align to output contracts (SUPP-005).


---

### App C.02 --- SUPP-018: PSP Operations Module - Verification Photo Review Retake (v0.2)

Date: 2025-12-17

Purpose: Define the admin verification system (brand/regional), approval/rejection granularity, retake behavior, review SLAs with campaign-level overrides, and how verification interacts with store/campaign completion.

# Locked Decisions (Module 7)

  -------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- -------------------------------------------------------------------------------------------
  Approval granularity                Both: approve/reject per photo AND per location-slot proof packet

  Rejection behavior                  Photo-level retake only (reject specific photo; others remain)

  Verification SLA                    Yes: SLA is configurable per campaign; campaign-level override allowed

  Submission status behavior          Brand optional: choose whether completion waits for verification or completes immediately

  Rejection reasons                   Fixed reason codes + optional comments (structured + freeform)
  -------------------------------------------------------------------------------------------------------------------------------

# 1) Roles Allowed to Review

- Reviewers: Regional Admin and above (Brand Admin included).

- Review permissions are scoped to assigned regions/brands per RBAC spec (SUPP-003).

# 2) Review Objects (What gets reviewed)

- Proof photos are linked to Item + LocationSlot + PhotoRule requirement.

- Admins review:

- \- individual photos (photo-level) AND/OR

- \- the full proof packet for a location slot (slot-level)

- Slot-level review is useful when a slot requires multiple angles; photo-level review is used for targeted rejections.

# 3) States & Transitions (v1)

  ----------------------------------------------------------------------------------------------------
  Object                  State                   Meaning
  ----------------------- ----------------------- ----------------------------------------------------
  PhotoReview             PENDING                 Awaiting admin review

  PhotoReview             APPROVED                Accepted as valid proof

  PhotoReview             REJECTED                Invalid; retake required

  SlotVerification        PENDING                 At least one required proof pending

  SlotVerification        SATISFIED               All required proofs satisfied (approved or waived)

  SlotVerification        REWORK                  One or more proofs rejected; retake required
  ----------------------------------------------------------------------------------------------------

# 4) Brand-Optional Completion Mode

- Per campaign setting: verificationMode controls how store status behaves at submission time.

- Mode A (STRICT): store status becomes SUBMITTED_FOR_REVIEW; store is not COMPLETE until proofs are satisfied/waived.

- Mode B (FAST): store status becomes COMPLETE immediately upon submission; if proofs are later rejected, store is automatically REOPENED and moved to REWORK_REQUESTED.

- Both modes preserve audit events and export visibility.

## VerificationMode (Draft Fields)

  ----------------------------------------------------------------------------------------
  Field                               Values
  ----------------------------------- ----------------------------------------------------
  verificationMode                    STRICT \| FAST

  autoReopenOnRejection               true (required when FAST)

  allowWaivers                        true/false (default true; requires reason + audit)
  ----------------------------------------------------------------------------------------

# 5) Rejection Model (Photo-level Retake)

- Rejecting a specific photo triggers a retake task for the store user tied to the same item + slot + ruleId.

- Previously approved photos remain approved; only rejected photos require replacement.

- If a slot has a minimum count requirement, the slot remains unsatisfied until enough approved photos exist.

## Rejection Reason Codes (v1 Draft)

- WRONG_LOCATION

- WRONG_ANGLE

- BLURRY_OR_UNREADABLE

- INSUFFICIENT_LIGHTING

- INCOMPLETE_INSTALL

- OLD_CAMPAIGN_NOT_REMOVED

- WRONG_QUANTITY_INSTALLED

- OTHER (requires comment)

# 6) Verification SLA & Escalations

- SLA is configured per campaign (e.g., review within 48 hours of submission).

- Escalation schedule is configurable per campaign and can be overridden by Brand Admin for that campaign.

- Overdue reviews trigger alerts to Regional Admin + Brand Admin and may appear in an exception queue.

# 7) Data Model (Draft)

  --------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- --------------------------------------------------------------------------------------------------
  PhotoReview                         reviewId, photoLinkId, status, reviewerId, reasonCode, comments, reviewedAt

  SlotVerification                    slotVerificationId, campaignId, storeId, itemId, slotId, status, requiredMinCount, approvedCount

  RetakeTask                          taskId, storeId, campaignId, itemId, slotId, photoLinkId?, dueAt?, status, createdBySystem=true

  VerificationSlaConfig               campaignId, slaHours, escalationStepsJson, overrideEnabled
  --------------------------------------------------------------------------------------------------------------------------------------

# 8) APIs (Draft Endpoint List)

- GET /reviewQueue (filters: campaign, region, store, overdue, status)

- POST /photoReviews/{photoLinkId}/approve

- POST /photoReviews/{photoLinkId}/reject (reasonCode + comments)

- POST /slotVerifications/{slotId}/approveAll (optional bulk)

- POST /campaigns/{id}/verificationConfig (verificationMode + SLA)

- GET /storeApp/reworkQueue (store sees retake tasks and comments)

# 9) Acceptance Criteria (Module 7)

1.  Admins can review proofs by photo and by location slot proof packet.

2.  Admins can reject individual photos with reason code + optional comments; store receives retake task for only rejected photos.

3.  Campaign supports STRICT and FAST verification modes; behavior matches mode definitions including auto-reopen on rejection.

4.  Verification SLA is configurable per campaign; overdue items trigger alerts and appear in exception queue.

5.  Waivers (if enabled) require reason and emit audit events; waived proofs count as satisfied for slot verification.

# Future Scaffold Notes

- AI-assisted proof analysis can map onto structured reason codes and slot verification states later.

- Role-based review routing (e.g., regional first, brand escalation) can be layered onto reviewQueue logic.

- Bulk approval workflows (approve all for store/campaign) can be added with audit safeguards.


---

### App C.03 --- SUPP-019: PSP Operations Module - Issues Reorders Expiration Deinstall (v0.2)

Date: 2025-12-17

Purpose: Define issue reporting, reorder approvals, reorder constraints, expiring campaign deinstall flow, non-compliance handling, and asset/version substitution rules.

# Locked Decisions (Module 8)

  ----------------------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- ----------------------------------------------------------------------------------------------------------
  Reorder approvals                   Rules-based: brand can require approval per campaign/item; PSP can fulfill without approval when allowed

  Reorder limits                      No caps enforced in v1 (scaffold for future configurable caps)

  Deinstall proof (default)           Optional by default; brand may require per campaign

  Expiration non-compliance cases     Auto-create non-compliance case record when enabled; this behavior is brand/campaign optional

  Asset version substitution          PSP may substitute updated asset version for reprints/reorders with audit + traceability
  ----------------------------------------------------------------------------------------------------------------------------------------------

# 1) Issue & Reorder Overview

- Issues originate from store execution (missing/damaged/incorrect/etc.) and create structured IssueRequests.

- Default handling is per-item IssueLines for granular fulfillment tracking.

- Major packaging damage can be captured at order/shipment level and expanded by PSP ops if needed.

# 2) Approval Model (Rules-Based)

- ApprovalPolicy is configured per campaign and can be overridden per item.

- Modes:

- \- AUTO_APPROVE: issue lines automatically become reorder-ready for PSP.

- \- BRAND_APPROVAL_REQUIRED: brand/regional must approve before PSP produces/ships.

- \- PSP_APPROVAL_ONLY: PSP decides (useful when brand wants speed or trusts PSP).

- All approvals/rejections require actor + timestamp; rejections require reason code + comment.

## Approval Policy Fields (Draft)

  --------------------------------------------------------------------------------------------------
  Field                               Notes
  ----------------------------------- --------------------------------------------------------------
  approvalMode                        AUTO_APPROVE \| BRAND_APPROVAL_REQUIRED \| PSP_APPROVAL_ONLY

  defaultMode                         campaign-level default

  itemOverrides                       optional per KitItemDefinition

  notifyOnSubmit                      routing to PSP + brand per SUPP-004
  --------------------------------------------------------------------------------------------------

# 3) Reorder Constraints (v1 + Scaffold)

- v1 does not enforce numeric caps to avoid blocking operations during pilots.

- System MUST still capture reorder metrics to enable future caps: requestedQty, approvedQty, fulfilledQty, reason codes.

- Future scaffold: per-campaign caps (absolute qty or % of original) + approval escalation.

# 4) Expiration & Deinstall Workflow

- Expiring campaign reaches endDate (or end window) â†’ system creates deinstall tasks for stores.

- Deinstall proof requirements are brand-configurable per campaign:

- \- Optional by default

- \- Brand can require min photo count and/or specific angles per location slot

- Deinstall completion can be reviewed with the same verification/retake mechanism (SUPP-018) if enabled.

# 5) Non-Compliance Case Record (Brand Optional)

- When enabled, overdue deinstall creates a NonComplianceCase record for reporting and follow-up.

- Case includes: store, campaign, due date, days overdue, last activity, and escalation history.

- If disabled, system only escalates via notifications without creating a formal case object.

# Entities (Draft)

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- ---------------------------------------------------------------------------------------------------------------------------
  IssueRequest                        issueRequestId, orderId, storeId, campaignId, type, status, createdAt

  IssueLine                           issueLineId, issueRequestId, itemId, qty, reasonCode, description, evidenceAssetIds\[\], attestationUserId, attestationAt

  ApprovalDecision                    decisionId, issueLineId (or requestId), status(approved\|rejected), actorId, reasonCode?, comment?, decidedAt

  Reorder                             reorderId, issueRequestId, status, createdAt; may produce 1..N replacement shipments

  NonComplianceCase                   caseId, campaignId, storeId, type(deinstall_overdue), status, createdAt, closedAt?, notes

  AssetSubstitution                   subId, originalAssetRef, substitutedAssetRef, actorId, reason, createdAt
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# 6) Asset Substitution Rules (Reprints/Reorders)

- Default behavior is to reference the item's asset pointer used in the original order generation run.

- PSP can substitute an updated asset version when required (e.g., corrected artwork, reprint, inventory standardization).

- Substitution must:

- \- record who/when/why

- \- preserve original reference

- \- update downstream reorder shipment docs/exports

- \- emit webhook event asset.substituted (future-ready; optional v1)

# 7) Notifications & Webhooks

- Submitting issues notifies PSP; brand notified based on approval policy and anomaly rules (SUPP-004).

- Approval-required issues generate review tasks in brand/admin queue.

- Deinstall overdue triggers escalation per campaign rule; optional case creation per brand/campaign.

# 8) APIs (Draft Endpoint List)

- POST /issues (create IssueRequest + IssueLines)

- GET /issues (filters: campaign, store, status, overdue)

- POST /issues/{issueLineId}/approve \| /reject (reasonCode + comment)

- POST /issues/{issueRequestId}/createReorder (PSP)

- GET/POST /campaigns/{id}/approvalPolicy (configure)

- POST /campaigns/{id}/deinstallConfig (proof requirements + case toggle)

- GET /nonComplianceCases (if enabled)

- POST /assets/substitute (records substitution with audit)

# 9) Acceptance Criteria (Module 8)

1.  Store can submit missing/damaged issues with per-item issue lines including qty, reason, evidence, and attestation.

2.  Campaign can require brand approval for reorders by policy; PSP can fulfill automatically when allowed.

3.  PSP can convert approved issues into reorders and manage replacement shipments.

4.  Expiring campaigns create deinstall tasks at end date; deinstall proof can be optional or required per campaign.

5.  When enabled, overdue deinstall creates a NonComplianceCase record; otherwise only escalations are sent.

6.  PSP can substitute an updated asset version for reorders with full audit and traceability.


---


## Appendix D --- Store Execution Module

### App D.01 --- SUPP-011: Store Execution Module - Offline and Sync Strategy (v0.3)

Date: 2025-12-17

Purpose: v1-appropriate offline strategy for store execution in mobile browsers (iOS/Android) with PWA scaffold; supports draft saving and queued submissions with sync-on-open.

# Locked Decisions (v1)

  -----------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- -----------------------------------------------------------------------------
  Delivery                            Responsive web app (mobile-first) + PWA scaffold

  Offline approach                    Local drafts + queued submissions + sync-on-open (not true background sync)

  Storage                             IndexedDB for drafts/outbox; object storage for media via presigned uploads

  Native apps                         Future: true background sync + richer integrations
  -----------------------------------------------------------------------------------------------------------------

# Minimum Offline Capabilities (v1)

- Save progress offline (survey drafts + task progress).

- Stage photos locally with storage warnings and a clear "queued uploads" count.

- Auto-upload queued submissions when app is opened online (with retries).

- Sync Status screen: queued / failed / last sync / retry button.

# Implementation Notes (Draft)

- Service Worker caches app shell + critical assets for resilience (offline UI).

- Outbox pattern on client (IndexedDB queue) + server-side outbox/audit events per submission.

- Photo upload: presigned URLs; resumable/chunking where possible; retry with backoff.

- Conflict handling: server is source of truth; prevent overwriting verified/approved submissions without admin action.

# Failure Modes & UX

- If storage is full: block new photo capture and prompt user to upload/sync or delete drafts.

- If upload fails repeatedly: keep in failed queue with last error; allow manual retry; surface contact/help text.

- If user logs out: drafts remain on device; protect with user scoping and optional device purge on logout.

# Acceptance Criteria

1.  Store can complete steps offline and return later without losing progress.

2.  Queued uploads sync when app is opened online; retries work; failures are visible.

3.  User can see what is queued vs submitted; submissions are not duplicated.

4.  Verified/reviewed artifacts are never overwritten by stale offline drafts.

# Open Decisions / TODOs (Need Inputs)

- Offline photo capture expectations for pilot stores (best-effort is current).

- Max offline storage assumption per device; recommended guidance text for stores.


---

### App D.02 --- SUPP-017: Store Execution Module - Store Execution Proof Capture (v0.2)

Date: 2025-12-17

Purpose: Define the store-facing execution workflow (mobile-first web), receiving/verification, install confirmation, proof capture, replacements, offline behavior, and rollups to store/order/campaign completion.

# Locked Decisions (Module 6)

  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- ----------------------------------------------------------------------------------------------------------------------------------
  Execution steps (v1)                Notify â†’ Receive/Verify â†’ Pre-install checklist â†’ Install â†’ Completion Survey + Proof + Attestation

  Receiving verification              Hybrid: order-level confirm + item-level anomaly classification (missing/damaged/incorrect)

  Replacement request model           Hybrid: per-item issue lines by default; allow \'major packaging damage\' single request that can fan-out into item lines by PSP

  Install confirmation                Item-level per location slot; rolls up to order/store completion

  Proof upload timing                 Upload-as-you-go per item/location slot (preferred)

  Offline expectation                 Best-effort offline drafts + sync-on-open (v1)
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1) Store Journey (Step-by-Step)

1.  Campaign Notification: store sees upcoming campaign + due dates + quick summary of required actions.

2.  Receive/Verify: store confirms delivery status; records anomalies (missing/damaged/incorrect) at item level.

3.  Pre-Install Checklist: guided checklist (safety, remove old campaign materials, confirm tools/space, confirm mockups).

4.  Install: store marks install for each item/location slot; uploads proof photos as required/suggested.

5.  Completion Survey: collect final confirmation questions + attestation checkbox signature.

6.  Submit: transitions to SUBMITTED_FOR_REVIEW if admin verification required; otherwise COMPLETE when proofs satisfied or waived.

# 2) Receive/Verify Model (Hybrid)

- Order-level confirmation: store answers \'Did you receive the kit/order?\' (Yes/No/Partial).

- Item-level anomaly capture: for each item (and optionally per shipment) store can report:

- \- reasonCode: MISSING, DAMAGED, INCORRECT_ITEM, INCORRECT_QTY, OTHER

- \- qtyAffected

- \- description

- \- evidence photos (optional/required per policy)

- \- attestation checkbox + timestamp (required for reorder submission)

- If \'major packaging damage\' is selected, store can submit a single request referencing the order; PSP may expand into item lines later.

# 3) Replacement Requests (Issues/Reorders)

- Default: each affected item becomes its own IssueLine (granular tracking).

- Exception: major packaging damage can be captured once, tied to order/shipment; PSP can resolve by creating one or many replacement shipments.

- All requests generate alerts to PSP Ops and (optionally) brand admins (per notifications matrix).

## Entities (Draft)

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- ---------------------------------------------------------------------------------------------------------------------------
  StoreTask                           taskId, storeId, campaignId, type(receive\|install\|complete\|deinstall), status, dueAt

  ReceiveVerification                 verificationId, orderId, receivedStatus(yes/no/partial), notes, createdAt

  IssueRequest                        issueRequestId, orderId, storeId, campaignId, type(itemIssues\|packagingDamage), status

  IssueLine                           issueLineId, issueRequestId, itemId, qty, reasonCode, description, evidenceAssetIds\[\], attestationUserId, attestationAt

  InstallRecord                       installId, assignmentItemId, slotId, installedAt, installedBy, status

  ProofCapture                        proofId, installId (or assignmentItemId+slotId), mediaAssetId, ruleId, createdAt

  CompletionSubmission                submissionId, storeId, campaignId, status(submitted\|verified\|rework), attestationUserId, attestationAt
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# 4) Install + Proof Capture (Upload-as-you-go)

- Store completes install per item/location slot (resolved in assignment).

- Required photo rules enforced by brand defaults + overrides (SUPP-014).

- Capture guidance: show mockup/reference image; show recommended angles; show minimum required count.

- Proof photos are linked to item + location slot; admins can later approve/reject.

- Store can submit completion only when required proof minimums are met OR an admin waiver is applied.

# 5) Completion & Rollups

- Item/location completion rolls up to StoreAssignment completion.

- Store completion transitions: IN_PROGRESS â†’ SUBMITTED_FOR_REVIEW â†’ (REWORK_REQUESTED \| COMPLETE).

- Order rollup: order is \'execution complete\' when all required assignment items are complete (or waived).

- Campaign rollup is defined in SUPP-007 (all stores complete or force-complete).

# 6) Offline & Sync (Best-Effort v1)

- Support saving drafts offline: checklist status, survey answers, install progress.

- Photos may be queued locally; uploads occur when the app is open and connectivity exists.

- Provide Sync Status screen: queued uploads, failed uploads, retry action.

- Server-side validation still required on submission; client warns user when offline might block final submission.

# 7) UI Screens (v1 Minimum)

- Store Home: list of active campaigns + tasks + due dates.

- Campaign Detail: kit overview, instructions, due dates, contact info.

- Receive/Verify: order-level confirm + item anomaly capture.

- Pre-install Checklist: guided steps + acknowledgment.

- Install Task: per item/location slot checklist + photo capture UI.

- Completion Survey: final questions + attestation checkbox.

- Retake Queue: list of rejected proofs with comments and resubmit actions.

- Sync Status: queued uploads and retry.

# 8) APIs (Draft Endpoint List)

- GET /storeApp/campaigns (store-scoped list)

- GET /storeApp/campaigns/{id} (details + tasks + required proofs)

- POST /storeApp/orders/{orderId}/receiveVerification

- POST /storeApp/issues (create IssueRequest + IssueLines)

- POST /storeApp/installRecords (create/update install per item+slot)

- POST /storeApp/proofs (register proof + presigned upload handshake)

- POST /storeApp/completionSubmissions

- GET /storeApp/reworkQueue

# 9) Acceptance Criteria (Module 6)

7.  Store can complete Receive/Verify with order-level received status and item-level anomaly classification.

8.  Store can submit per-item issue lines; major packaging damage can be submitted as a single request.

9.  Store can complete pre-install checklist prior to install tasks.

10. Store installs items per location slot; uploads proof photos as they go; rules enforced per campaign defaults + overrides.

11. Store completion requires completion survey + attestation; transitions to submitted/rework/complete states accordingly.

12. Admins can reject proofs; store sees rejection comments and can resubmit.

13. Offline drafts work; queued uploads sync when app is open and online; sync status visible.

# Future Scaffold Notes

- AI proof analysis and auto-rejection is future scope; v1 supports manual rejection workflow with structured reason codes.

- Native apps can add true background sync and better media handling later.

- Barcode/QR scanning for receiving verification can be added later without changing the core entities.


---



## Appendix E --- Platform Ops Agent Harness

### App E.01 --- SUPP-012: Technology Selections ADR (v0.2)

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

- Email provider can be swapped (SES â†” SendGrid) without API changes.

- Hosting can move to GCP/Azure later if OpenTelemetry + containerized deployment is maintained.

- i18n language list can expand; keep keys stable from day 1.


---

### App E.02 --- SUPP-020: Build Contracts and Physical Schema (v0.2)

Date: 2025-12-17

Purpose: Authoritative build blueprint for Module 20: physical Postgres schema, OpenAPI contracts, auth, audit, idempotency, outbox/webhooks, pagination, export job interfaces, and scale-ready guardrails.

# Locked Decisions (Module 20)

  --------------------------------------------------------------------------------------------------------------------------------------
  Decision                            Selection
  ----------------------------------- --------------------------------------------------------------------------------------------------
  Multi-tenant strategy               1A --- Single DB, shared schema, tenant_id on every row

  Primary ID strategy                 2A --- UUIDv7 across all entities

  Migrations/query layer              Drizzle ORM schema (TS) + drizzle-kit migrations (20.1A)

  API architecture                    4C --- Hybrid (Next for simple; backend service for core)

  API versioning                      5A --- /api/v1 path versioning

  Web auth + integration auth         6A --- Cookies for web + API keys for integrations + signed webhooks + Idempotency-Key

  Outbox                              7A --- DB outbox table + worker dispatcher; Kafka later via outbox publisher (20.5A)

  Exports                             8B --- Small exports sync; large exports async jobs

  Media model                         9A --- MediaAsset table + join tables for proof bindings

  Audit logging                       10A --- Audit events for every state change + actor + correlationId

  Tenant enforcement                  20.2B --- Scaffold Postgres RLS policies now; enable later (app-layer enforcement in v1 runtime)

  Pagination                          20.3A --- Cursor pagination using (createdAt, id(UUIDv7))

  OpenAPI format                      20.4C --- Both: canonical OpenAPI YAML + generated validators/types (CI-enforced)
  --------------------------------------------------------------------------------------------------------------------------------------

## Recommendation Note on RLS (20.2)

- 2B is the least long-term pain: you design tables and policies with RLS in mind without paying the day-1 velocity tax of turning it on everywhere.

- 2C (RLS from day 1) is great when you already have a mature ops/security posture and time for policy debugging; otherwise it slows pilots.

- So: scaffold policies now, keep runtime enforcement in the app for v1, flip the switch later when traffic and teams justify it.

# 1) Postgres Physical Schema (Draft)

All tenant-scoped tables include tenant_id (pspId). Brand is a secondary scope dimension within tenant_id.

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Domain                              Tables (Draft)
  ----------------------------------- -----------------------------------------------------------------------------------------------------------------------------------------
  Tenancy/Identity                    psp_tenant, brand, app_user, membership, role, permission, api_key, audit_event

  Stores/Grouping                     store, region_node, store_group, store_group_membership, store_alias

  Surveys/Layout                      survey_template, survey_version, store_survey_response, store_layout, location_slot, photo_rule, photo_rule_override

  Campaigns/Assignment                campaign, selection_recipe, store_assignment, kit_definition, kit_item_definition, assignment_item, rebase_event

  Fulfillment                         store_order, order_line, shipment, shipment_line, shipment_tracking, batch, batch_membership

  Execution/Verification              store_task, receive_verification, install_record, proof_photo_link, completion_submission, photo_review, slot_verification, retake_task

  Issues/Reorders                     issue_request, issue_line, approval_policy, approval_decision, reorder, non_compliance_case, asset_substitution

  Async/Infra                         outbox_event, webhook_endpoint, webhook_delivery, idempotency_key, export_job, export_artifact, retention_job
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Key Constraints (Minimum)

- Unique(store.tenant_id, store.store_number)

- Unique(store_group.tenant_id, store_group.slug)

- Unique(survey_version.template_id, survey_version.version)

- Unique(store_assignment.campaign_id, store_assignment.store_id)

- Unique(store_order.campaign_id, store_order.store_id) --- v1 default

- FK constraints for core relationships; soft-delete only for media/purge flows where needed.

## Indexing (Pilot + Scale)

- Tenant lists: index (tenant_id, created_at desc) (+ id) for cursor pagination.

- Store selection: (tenant_id, region_node_id), (tenant_id, store_number), group membership indexes.

- Execution reporting: (campaign_id, store_id), (assignment_item_id), (location_slot_id), (slot_verification_status).

- Outbox/Delivery workers: (status, next_attempt_at), (endpoint_id, status, next_attempt_at).

# 2) RLS Scaffold (20.2B)

- Schema must support future RLS: every tenant-scoped table has tenant_id and (optionally) brand_id.

- Policy pattern (scaffold now): USING (tenant_id = current_setting(\'app.tenant_id\')::uuid).

- App sets \'app.tenant_id\' at connection/session scope when/if RLS is enabled later.

- v1 runtime: enforce tenant checks in the service layer; still keep policy SQL checked in repo for later enablement.

Example policy snippet (for later enablement):

\`\`\`sql\
\-- Scaffold: keep in /db/rls/ as future-ready artifacts\
ALTER TABLE store ENABLE ROW LEVEL SECURITY;\
CREATE POLICY store_tenant_isolation ON store\
USING (tenant_id = current_setting(\'app.tenant_id\')::uuid);\
\`\`\`

# 3) Media Asset Model (9A)

- media_asset: id(UUIDv7), tenant_id, brand_id?, type, mime, size, checksum, storage_provider, storage_key/pointer_uri, retention_class, created_by, created_at, expires_at?

- proof_photo_link binds media_asset to: campaign_id, store_id, assignment_item_id, location_slot_id, rule_id

- All access via presigned URLs; exports contain mediaAssetId + (optional) short-lived URL.

# 4) Audit + Idempotency + Outbox (7A/10A)

- audit_event is append-only; every state transition emits an event with actorType and correlationId.

- idempotency_key prevents duplicate integration writes; key scope = tenant_id + key + endpoint + method.

- outbox_event drives webhook dispatch (at-least-once). webhook_delivery records attempts, errors, and replays.

- Kafka later: add an outbox publisher that mirrors outbox_event to Kafka topics without changing write paths.

# 5) Pagination Contract (20.3A)

- Cursor-based pagination for high-volume lists: cursor = base64({createdAt, id}).

- Sorting: ORDER BY created_at DESC, id DESC (id is UUIDv7 so time-sortable).

- Stable even under inserts; avoids offset/limit performance cliffs.

# 6) OpenAPI + Validation (20.4C)

- Canonical spec: /openapi/v1.yaml in repo (reviewable, diffable).

- Code validation: request/response schemas in code (e.g., Zod) + generated validators/types.

- CI gate: regenerate openapi from schemas and fail if diff from committed YAML (prevents drift).

- Error envelope: {errorCode, message, correlationId, details?}

# 7) Endpoint Index (Draft)

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Area                                Endpoints (Draft)
  ----------------------------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Auth                                POST /api/v1/auth/login, POST /api/v1/auth/logout, POST /api/v1/auth/invite/accept

  Stores                              GET/POST/PUT /api/v1/stores, POST /api/v1/stores/import

  Groups/Regions                      GET/POST /api/v1/regions, GET/POST /api/v1/groups, POST /api/v1/groups/{id}/members

  Surveys/Layout                      POST /api/v1/surveyTemplates, POST /api/v1/surveyTemplates/{id}/publish, GET/PUT /api/v1/stores/{id}/surveyResponse

  Campaigns                           POST /api/v1/campaigns, PUT /api/v1/campaigns/{id}, POST /api/v1/campaigns/{id}/publish, GET /api/v1/campaigns/{id}/dashboard

  PSP Ops                             GET /api/v1/psp/campaigns/{id}/orders, GET/PUT /api/v1/psp/orders/{id}, POST/PUT /api/v1/psp/shipments, POST/PUT /api/v1/psp/batches

  Store App                           GET /api/v1/storeApp/campaigns, POST /api/v1/storeApp/orders/{id}/receiveVerification, POST /api/v1/storeApp/proofs, POST /api/v1/storeApp/completionSubmissions

  Review                              GET /api/v1/reviewQueue, POST /api/v1/photoReviews/{photoLinkId}/approve, POST /api/v1/photoReviews/{photoLinkId}/reject

  Issues/Reorders                     POST /api/v1/issues, POST /api/v1/issues/{lineId}/approve\|reject, POST /api/v1/issues/{requestId}/createReorder

  Exports                             POST /api/v1/exports, GET /api/v1/exports/{jobId}, GET /api/v1/exports/{jobId}/download

  Integration                         POST/PUT /api/v1/integration/orders, /shipments, /batches (idempotent)
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 8) Export Job Contract (8B)

- Small exports can run sync with size guard (row count or time budget).

- Large exports run async (export_job + export_artifact).

- Artifacts have expiry; avoid storing forever.

# Acceptance Criteria (Module 20)

1.  DB migrations create schema with constraints + indexes and pass CI.

2.  OpenAPI v1 YAML exists and matches generated schemas (CI drift gate).

3.  Cursor pagination implemented for stores, campaigns, orders, proofs, issues.

4.  Outbox + webhook deliveries provide at-least-once delivery with retries + replay UI hooks.

5.  Idempotency works for integration write endpoints and returns consistent responses.

6.  Audit events emitted for every state transition with correlationId and actor typing.


---

### App E.03 --- SUPP-021: Repo CI and Vertical Slice Plan (v0.1)

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

1.  Auth + tenancy bootstrap (PSP â†’ Brand) + RBAC enforcement.

2.  Stores import + regions/groups + store selection recipe preview.

3.  Survey templates + store survey responses + location slot generation.

4.  Campaign builder + kit definition + publish â†’ assignment + order generation.

5.  PSP ops: campaign totals + store orders list + status updates + batches.

6.  Shipments + tracking + partial shipments + notifications/webhooks.

7.  Store execution: receive/verify â†’ install â†’ proof capture â†’ completion + attestation.

8.  Verification queue: approve/reject photos â†’ retake queue â†’ resubmission.

9.  Issues/reorders: submit issue â†’ approval policy â†’ reorder shipment updates.

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


---

### App E.04 --- SUPP-022: Branching FeatureFlags Release Workers (v0.1)

Date: 2025-12-17

Purpose: Define how changes flow through the repo(s), how pilots are protected with feature flags, how staging/prod releases are handled while AI-driven development runs continuously, and how workers/queues are organized.

# Locked Decisions

  ---------------------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- ---------------------------------------------------------------------------
  Branch strategy                     1B --- main + develop + release branches

  Feature flags                       2A --- Required for pilots

  Release cadence                     3A --- Weekly to production; Continuous staging for active AI development

  Worker topology                     4A --- Single worker service with named queues
  ---------------------------------------------------------------------------------------------------------------

# 1) Branch Strategy (1B)

- develop: active integration branch (AI agents merge here after CI gates pass).

- main: protected, production-ready line; merges from release/\* only.

- release/\*: cut from develop for stabilization; hotfixes allowed; merged to main and back to develop.

## PR & Merge Rules

- All changes land via PR with CI gates (lint/typecheck/unit/playwright/OpenAPI drift).

- Require at least one human approval for release/\* â†’ main (pilot safety).

- Agents may auto-merge to develop if all checks pass and change is within allowed scope.

# 2) Feature Flags (2A)

- Feature flags are mandatory for pilot-facing features that could break workflows.

- Flags are evaluated at tenant + brand + campaign level where applicable.

- Default: new features off in production until validated in staging.

  -------------------------------------------------------------------------------------------------
  Flag Type                           Scope
  ----------------------------------- -------------------------------------------------------------
  tenantFlag                          PSP-wide

  brandFlag                           Single brand

  campaignFlag                        Per campaign (e.g., STRICT/FAST behaviors, deinstall proof)

  userFlag                            Optional (admin-only previews)
  -------------------------------------------------------------------------------------------------

# 3) Release Cadence (3A)

- Staging: continuous deployment from develop after CI passes (AI dev lives here).

- Production: weekly releases from release/\* branches after smoke + pilot validation.

- Emergency hotfix: release/hotfix-\* cut from main, merged back to main + develop.

# 4) Worker Topology (4A)

- Single worker service runs multiple named queues; easier ops and scaling early.

- Queues (draft): webhooks, exports, retention, email, indexing, thumbnails.

- Scale strategy: increase worker replicas; later split queues into dedicated workers if needed.

# Operational Guardrails

- Staging has synthetic test tenant + automated seed data.

- Production requires migration review and dry-run checks.

- Destructive jobs (retention purge) run in dry-run mode until explicitly enabled per tenant.

# Definition of Done

1.  Git branches and protections configured as specified.

2.  Feature flag service exists (initially DB-backed) with admin UI toggles per tenant/brand/campaign.

3.  CI deploys develop â†’ staging automatically; production deploy is gated and scheduled weekly.

4.  Worker service boots and consumes named queues; queue metrics visible (dashboard or logs).


---

### App E.05 --- SUPP-023: Feature Flags Data Model and Admin UX (v0.1)

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

- Most specific wins: STORE â†’ CAMPAIGN â†’ BRAND â†’ TENANT â†’ DEFAULT.

- If multiple rules exist at same scope, highest priority wins (then newest wins as tiebreak).

- Rules evaluated by context: {tenantId, brandId?, campaignId?, storeId?, userId?}.

- Evaluation result can be cached per request; optional short TTL cache across requests for performance.

# 3) Admin UX (PSP Admin Only)

- Screen: Platform Settings â†’ Feature Flags.

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


---

### App E.06 --- SUPP-024: Env Config Secrets Tenant Bootstrap (v0.1)

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

- Configuration is layered: base config â†’ environment overlay â†’ env vars override.

- Keep env-specific files in repo (no secrets), e.g., config/dev.json, config/staging.json, config/prod.json.

- All configs validate at startup (Zod). Fail fast if missing/invalid.

Config items (examples): feature flag defaults, retention defaults, webhook retry policy, export size guards, late-shipping thresholds default, S3 bucket name, allowed upload mime types.

# 3) Tenant Bootstrap (2A)

- UI Wizard (PSP Admin): Create PSP Tenant â†’ Create Brand Admin user â†’ Create first Brand â†’ Invite additional admins.

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

### App E.07 --- SUPP-025: Staging Seed Scale Plan and Testing (v0.1)

Date: 2025-12-17

Purpose: Define how staging seed data scales from minimal smoke-test datasets to pilot-scale datasets, without overwhelming early development. Also defines proof media strategy in staging, initial load targets, and an incremental campaign mix plan.

# Locked Decisions

  -------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- -------------------------------------------------------------
  Seed volume strategy                Start minimal (1 store) and ramp as test maturity increases

  Proof media in seeds                2B --- Use a small reusable set of sample images

  Initial load target                 3A --- 50 concurrent store users + 10 admin/PSP users

  Synthetic campaign mix              Progressive scaling tied to test phases
  -------------------------------------------------------------------------------------------------

# 1) Staging Seed Phases (Progressive)

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Phase                    Stores         Campaigns                      Purpose                                              Gating Criteria
  ------------------------ -------------- ------------------------------ ---------------------------------------------------- --------------------------------------------
  P0 --- Smoke             1 store        1 tiny campaign                Validate end-to-end flow quickly                     Playwright smoke passes

  P1 --- Basic             10 stores      1 small + 1 medium             Exercise selection, batching, review queues          No P0 regressions; exports/webhooks green

  P2 --- Pilot-ish         100 stores     1 medium + 10 small            Catch pagination, performance, data quality issues   Load test A target stable

  P3 --- Scale rehearsal   1,000 stores   1 huge + 5 medium + 20 small   Stress lists/exports/queues/retention dry-runs       Perf budgets met; queue latency acceptable
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 2) Proof Media Strategy (2B)

- Staging uses a small curated library of sample images reused across seeded proofs.

- Images live in a staging-only S3 bucket with lifecycle rules (auto-clean).

- Seed records reference media_asset rows + proof_photo_link bindings (location slot + assignment item).

- Avoid generating large volumes of unique images (cost + noise).

# 3) Load Testing Targets (3A)

- Initial target: 50 concurrent store users + 10 concurrent admin/PSP users.

- Focus endpoints: storeApp task lists, proof submission, review queue, PSP order lists, exports creation.

- Success metric: p95 API latency within acceptable bounds + no error spikes + queues drain steadily.

Note: Increase targets after P2 stabilization; do not optimize prematurely.

# 4) Campaign Mix Plan (Progressive)

- P0/P1: tiny campaigns that validate workflows and contracts.

- P2: realistic mixture to validate list scaling, batch behavior, and notification volume.

- P3: scale rehearsal with a large campaign and long lists to validate cursor pagination and export timeouts.

# Implementation Notes

- Seed scripts must be deterministic: fixed RNG seed, stable naming, and reproducible IDs where practical.

- Seed execution should be idempotent: re-running refreshes data safely (truncate per-tenant in staging).

- Provide seed presets via CLI: seed:p0, seed:p1, seed:p2, seed:p3.

- Keep P0 quick (\<2 minutes) so AI-driven iteration remains fast.

# Definition of Done (Module 25)

1.  Seed presets exist (P0--P3) and can be run locally and in staging.

2.  P0 is the default CI seed for smoke tests; P1/P2 run nightly; P3 runs weekly or on-demand.

3.  Sample proof media library exists and is referenced by seeded proof records.

4.  Load test script exists for target A scenario and is runnable against staging.


---

### App E.08 --- SUPP-026: Local Dev Staging Parity and Toolchain (v0.1)

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

### App E.09 --- SUPP-027: Notifications Webhooks Deliverability (v0.1)

Date: 2025-12-17

Purpose: Define safe notification behavior across dev/staging/prod, including email deliverability controls, webhook endpoint allowlists, channel priorities, retry rules, and manual replay mechanics for eventual delivery.

# Locked Decisions

  ------------------------------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- ------------------------------------------------------------------------------------
  Staging email safety                1A --- Allow real emails ONLY to whitelisted domains/addresses

  Staging webhooks                    2A --- Allow ONLY whitelisted URLs/hosts

  Channel priority (v1)               3C --- Both email + webhooks (when configured)

  Retry rules (webhooks)              4A --- Exponential backoff + dead-letter after N attempts; unlimited MANUAL replay
  ------------------------------------------------------------------------------------------------------------------------

# 1) Notification Channels (v1)

- Email: default channel for human-facing alerts (Brand Admins, PSP staff, Stores).

- Webhooks: event delivery for PSP automation and external systems; configured per tenant/brand.

- Both can be enabled simultaneously; behavior is event-specific (see SUPP-004 + SUPP-006).

# 2) Staging Safety Controls

## 2.1 Email Allowlist (1A)

- Staging only sends to recipients in allowlist (domains and/or explicit addresses).

- Non-allowlisted recipients are suppressed and logged (audit trail).

- Local dev continues using MailHog (SUPP-026).

## 2.2 Webhook Allowlist (2A)

- Staging only dispatches webhooks to allowlisted hosts/URLs.

- Requests to non-allowlisted endpoints are blocked and recorded as \'blocked_by_policy\' (no retries).

- Production allowlist is optional; recommended for higher security tenants.

# 3) Webhook Retry + Dead-Letter + Manual Replay (4A + manual unlimited)

- Automatic retries use exponential backoff with jitter.

- After N attempts (default 10), delivery is marked DEAD_LETTER with last_error retained.

- Manual replay is unlimited: an admin can re-queue a dead-letter or failed delivery at any time.

- Manual replay requires a reason/comment and is audited (who/when/why).

## Default Retry Schedule (Draft)

  -----------------------------------------------------------------------
  Attempt                             Delay (approx)
  ----------------------------------- -----------------------------------
  1                                   1 min

  2                                   5 min

  3                                   15 min

  4                                   1 hr

  5                                   3 hr

  6                                   6 hr

  7                                   12 hr

  8                                   24 hr

  9                                   48 hr

  10                                  72 hr
  -----------------------------------------------------------------------

After attempt 10, delivery enters DEAD_LETTER unless manually replayed.

# 4) Delivery Records (Data Model Hooks)

- webhook_delivery records: eventId, endpointId, status, http_status, attempt_count, next_attempt_at, last_attempt_at, last_error, request_id, correlation_id.

- email_delivery (optional): messageId, recipient_hash, template_key, status, suppressed_reason? (for allowlist blocks), correlation_id.

# 5) Admin UX (Minimum)

- PSP Admin: Notification Settings includes webhook endpoints + allowlists + test send.

- Delivery Log screen: filter by status (FAILED/DEAD_LETTER/BLOCKED), event type, campaign, store.

- Replay action: requeue delivery; requires reason; emits audit_event.

# Acceptance Criteria

1.  Staging suppresses non-allowlisted emails and logs suppression.

2.  Staging blocks non-allowlisted webhook URLs and logs blockage without retry.

3.  Webhook retries execute with exponential backoff and stop at N attempts.

4.  Dead-letter deliveries are replayable manually without limit and are audited.

5.  Email + webhook can both fire for the same event when configured.


---

### App E.10 --- SUPP-029: Observability Tracing Logging Audit (v0.1)

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

- correlationId: UUIDv7 used to link multi-step workflows across entities (campaign â†’ orders â†’ shipments â†’ execution â†’ exports).

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

### App E.11 --- SUPP-030: Admin Ops Console Minimum Screens (v0.2)

Date: 2025-12-18

v0.2 adds a support-only note for computed field overrides (no dedicated review UI in v1).

# Addendum: Override Visibility (v1)

- No dedicated Admin review screen for overrides in v1 (post-v1 feature).

- Support can still access overrides via: exports (responses include response_json_meta) and audit_event logs.

- Scaffold: add an \'Overrides\' filter in Post-v1 Admin Ops Console.


---

### App E.12 --- SUPP-031: Supportability Policies and Incidents (v0.1)

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

### App E.13 --- SUPP-032: BreakGlass Retention Safety (v0.1)

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

# 3) Retention Dry-Run â†’ Enforce (3A)

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


---

### App E.14 --- SUPP-034: Rate Limits Upload Guards Throttle (v0.1)

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


---

### App E.15 --- SUPP-035: Field Level Data Model Tables Enums (v0.8)

Date: 2025-12-18

v0.8 adds computed/override metadata and hidden-field keep/clear semantics to schema/rules and response storage provenance.

# survey_template.schema_json (field metadata additions)

  --------------------------------------------------------------------------------------------------------
  Field Path                    Type                    Notes
  ----------------------------- ----------------------- --------------------------------------------------
  fields\[\].is_computed        bool                    If true, value is derived by COMPUTE action/expr

  fields\[\].compute_expr       json                    Whitelisted expression AST (fn + args)

  fields\[\].read_only          bool                    Default true when computed

  fields\[\].allow_override     bool                    Enables safe override UI

  fields\[\].hidden_default     bool                    If true, field not shown but still stored

  fields\[\].on_hide_behavior   enum                    KEEP \| CLEAR (per-field)

  fields\[\].display_key        string?                 Export column label (optional)
  --------------------------------------------------------------------------------------------------------

# rules_json action parameter additions

  ----------------------------------------------------------------------------------------------------------
  Action                  Params                                    Notes
  ----------------------- ----------------------------------------- ----------------------------------------
  HIDE                    {target_field_id, on_hide_behavior?}      If omitted, use field.on_hide_behavior

  SHOW                    {target_field_id}                         

  COMPUTE                 {target_field_id, expr}                   Expr is whitelisted AST

  AUTO_FILL               {target_field_id, source, const_value?}   As prior
  ----------------------------------------------------------------------------------------------------------

# store_survey_response (provenance storage)

  -----------------------------------------------------------------------------------------------------------------
  Column               Type              Null?             Notes
  -------------------- ----------------- ----------------- --------------------------------------------------------
  input_json           jsonb             Y                 Raw user inputs (including override input)

  response_json        jsonb             N                 Final values after rules + compute

  response_json_meta   jsonb             Y                 Small provenance object: computed map + overrides list
  -----------------------------------------------------------------------------------------------------------------

If input_json/response_json_meta columns are not desired in v1 schema, they can be stored inside response_json under reserved keys; columns are preferred for clarity.

# Override provenance (response_json_meta)

  ------------------------------------------------------------------------------------------------------------------
  Key                     Type                    Example
  ----------------------- ----------------------- ------------------------------------------------------------------
  overrides\[\]           array                   {field_id, value, overridden_by_user_id, overridden_at, reason?}

  computed\[\]            array                   {field_id, computed_at, expr_version}
  ------------------------------------------------------------------------------------------------------------------


---


## Appendix F --- Screens Interfaces

### App F.01 --- SUPP-036: Screens Onboarding and Store Foundation (v0.4)

Date: 2025-12-17

Purpose: Lock onboarding screens and store foundation workflows. v0.4 locks conflict bulk-apply controls for store import.

# Screen Map (Visual)

![](media/image1.png){width="6.8in" height="2.8333333333333335in"}

# Locked Import Semantics

  ---------------------------------------------------------------------------------------------------------------------
  Area                                Locked
  ----------------------------------- ---------------------------------------------------------------------------------
  Import truth-set                    Partial update (missing stores unaffected; never deactivate)

  Match behavior                      Conflict requiring explicit action (Keep/Update/Skip)

  Bulk apply                          ALLOWED: user can bulk-apply UPDATE/KEEP to selected conflicts (still explicit)
  ---------------------------------------------------------------------------------------------------------------------

# Conflict Resolution UX (Bulk Apply)

- Conflicts grid includes checkboxes + filter/sort (by region, city, etc.).

- Bulk actions: APPLY_UPDATE, APPLY_KEEP, APPLY_SKIP to selected rows.

- Before apply: show summary counts and require confirm.

- Per-row override remains available even after bulk apply (edit before final apply).

# Audit & Safety

- Bulk apply writes an audit_event recording: selection criteria, row ids selected, and action applied.

- Applying UPDATE_EXISTING produces audit_event per store updated with before/after snapshots.

- Hard deletion never occurs via import.


---

### App F.02 --- SUPP-037: Screens SurveyBuilder and StoreSurveys (v0.8)

Date: 2025-12-18

v0.8 locks override policy toggles and export behavior for computed/overridden fields.

# Locked Policy Toggles (v1)

  -------------------------------------------------------------------------------------------------
  Topic                               Locked
  ----------------------------------- -------------------------------------------------------------
  Brand can disable overrides         A --- Yes (brand setting: allow_computed_overrides=false)

  Campaign override tightening        B --- No (brand-only policy; campaign cannot tighten in v1)

  Exports include values              B --- Include final + computed + override metadata
  -------------------------------------------------------------------------------------------------

# Settings & Data Model Notes

- brand.settings_json.allow_computed_overrides (default true) controls whether store-side override UI is available.

- Field-level allow_override must also be true AND user role eligible (Store Manager/Brand Admin) for override control to appear.

- No campaign-level tightening in v1 to avoid conflicting policy sources; scaffold for post-v1 if needed.

# Export Contract (v1)

  -------------------------------------------------------------------------------------------------------------------
  Column/Field                        Description
  ----------------------------------- -------------------------------------------------------------------------------
  value_final                         Final value used for reporting and downstream ops (after override if present)

  value_computed                      The computed value at time of submission (if computed field)

  is_overridden                       Boolean flag

  override_value                      Value entered by user (if overridden)

  override_user_id                    User who overrode (if overridden)

  override_timestamp                  When override occurred

  override_reason                     Optional reason text
  -------------------------------------------------------------------------------------------------------------------

# Scaffold for later

- Add campaign-level tightening (allow_overrides_override=false) under feature flag if brands demand it.

- Add admin review UI (post-v1) to filter by is_overridden and reason.


---


---

# End of Compiled Master SOW

This document was compiled on 2025-12-18 09:49 from all active SUPPs. For any updates, edit the individual SUPP files first, then regenerate this compiled document.

