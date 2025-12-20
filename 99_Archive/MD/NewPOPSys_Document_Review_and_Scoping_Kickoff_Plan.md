Prepared: December 17, 2025

This document summarizes the five uploaded reference documents and converts them into a practical, step-by-step plan to start development scoping and run the build efficiently with AI agents (agentic/vibe coding) while keeping v1 scope protected.

# 1) What the docs collectively decide (treat these as v1 constraints)

- Product model: v1 is PSP-led. PSP is the paying customer/system owner; brands participate inside the PSP tenant; stores execute.

- Core loop: Campaign → Store assignment → PSP fulfillment → Store execution → Verification → Visibility.

- v1 scope: Feature-matched modernization of legacy PrecisionPOP with usability + operability improvements.

- Non-negotiable UX posture: mobile-first for store execution; progressive disclosure for long surveys/large kits; exception-first for regional.

- Hard guardrails: NOT an MIS, NOT a marketplace, NOT analytics-heavy, and does NOT store data forever (90-day post-completion retention).

- Future optionality: architect v1 so brands can be first-class and portable across PSPs later (without expanding v1 scope).

# 2) How to use each of the five docs during scoping

## 2.1 Platform Direction & Execution Guide (v1 PSP-led)

Use as the canonical \'source of truth\' for v1. If anything conflicts, this wins. It defines who the customer is, what the platform loop is, what is in/out of scope, UX principles, and high-level technical direction.

## 2.2 Developer Starting Guide

Use as a dev-facing quick reference for the core domain objects and v1 priorities. Note: the appendix header exists, but the detailed data object model is not populated yet---this becomes an immediate scoping deliverable.

## 2.3 v1 --- What This Platform Will Never Be

Use as the scope-control gate. Every feature request should be checked against this list before it becomes a story. If it violates this doc, it is automatically rejected or deferred.

## 2.4 SaaS Evolution & Market Expansion Strategy

Use as an architectural constraint (future-proofing). It does NOT add v1 features; it only informs how we design tenancy, brand identity, and data portability so future phases are possible without rewrites.

## 2.5 PrecisionPOP Product Walkthrough

Use as the legacy workflow reference for feature parity and UX improvements. It is especially useful to define the store-facing flows (survey, kits, reorders, photos, activity log) that v1 must modernize.

# 3) The minimum set of artifacts to create before (or while) coding

- v1 Scope Statement (1--2 pages): in-scope, out-of-scope, non-negotiables, retention rule, and target delivery constraints.

- User & permission model: roles, permissions, tenant boundaries, invite/onboarding rules.

- Domain model + glossary: campaign, store, kit, item, order/fulfillment job, execution state, verification artifact, issue, activity event.

- State machines: status transitions for kit/item execution, reorder lifecycle, verification/review states, campaign lifecycle.

- User journey map (happy path + exceptions): Brand, PSP ops, Store manager, Regional manager.

- API contract (OpenAPI): minimal endpoints needed for the vertical slice + auth + audit.

- Non-functional requirements: logging/audit, retention/deletion, upload/storage strategy, performance targets, security baseline.

- Definition of Done: what a completed story must include (tests, docs, audit events, review, etc.).

# 4) Best way to begin: a practical kickoff sequence (fast, but disciplined)

1.  Lock the v1 boundaries: write the v1 Scope Statement + Not-Now list (derived directly from the uploaded docs).

2.  Build a user-story map around the core loop (campaign → assignment → fulfillment → execution → verification → visibility).

3.  Define the domain objects + state machines (this prevents churn and makes agentic coding safer).

4.  Choose a single \'beta vertical slice\' scenario (one PSP, one brand, 1--5 stores, 1 campaign, 1 kit).

5.  Draft the OpenAPI contract for that slice (even if the implementation changes, the contract anchors work).

6.  Stand up repo + harness: linting, tests, CI, environments, seeding data, and a PR template.

7.  Run agentic implementation in small PRs gated by the scope doc + tests + acceptance criteria.

8.  Repeat: expand slice breadth (more statuses, large kits, reorders, reporting) while keeping scope protected.

# 5) Initial v1 epic map (recommended backlog buckets)

- Tenant & Identity: PSP tenant setup, brand invitations, user onboarding, role-based access control.

- Stores & Surveys: store profiles, attribute survey model, progressive disclosure UI, audit trail of changes.

- Campaigns: campaign creation, timelines, instructions, store assignment logic.

- Kits & Items: kit templates, kit contents (including large kits), item metadata and images.

- Fulfillment: predictable order generation for PSP ops; operational views for kitting/shipping.

- Store Execution (mobile-first): receive → install → confirm; fast paths; issues + photo capture/upload.

- Issues & Reorders: missing/damaged flows, reorder request capture, reorder tracking.

- Verification & Reporting: photo review artifacts, exception-first regional views, baseline dashboards.

- Activity / Audit Logging: event stream for all meaningful changes; exportability for troubleshooting.

- Platform Foundations: CI/CD, logging/monitoring, storage, retention enforcement, seed/demo data.

# 6) Agentic development harness (so AI agents can run safely)

## 6.1 Recommended agents (roles)

- Product/Scope Agent: converts constraints into epics/stories with acceptance criteria; runs scope checks.

- Domain/Architecture Agent: owns domain model, state machines, API boundaries, and tech decisions log.

- Backend Agent: data schema, services/APIs, auth, audit logging, retention jobs.

- Frontend Agent: UX flows (mobile-first store), admin/reporting screens, accessibility, performance.

- QA/Test Agent: test plan, automated tests, regression suite, scenario-based acceptance tests.

- DevOps/Release Agent: CI/CD, environments, observability, deployment and rollback strategy.

- Documentation Agent: keeps docs in sync with code, maintains runbooks and \'how-to\' content.

## 6.2 Guardrails for autonomy (non-negotiable)

- Every task must reference: (a) the v1 Scope Statement, (b) the Not-Now list, and (c) the user journey it supports.

- Anything that resembles MIS, marketplace, advanced analytics, or long-term storage is rejected/deferred automatically.

- Every meaningful data change must emit an Activity/Audit event.

- Every PR must include: tests, migration notes (if any), and updated docs (if the behavior changed).

- Keep PRs small: one story, one set of acceptance criteria, one end-to-end scenario.

## 6.3 Suggested repo structure (docs-first)

- /docs/00_vision.md

- /docs/01_scope_v1.md (includes Not-Now list)

- /docs/02_roles_permissions.md

- /docs/03_domain_model.md

- /docs/04_state_machines.md

- /docs/05_user_journeys.md

- /docs/06_api/openapi.yaml

- /docs/07_nonfunctional.md (retention, uploads, audit, security, perf)

- /agents/ (agent prompts + skills + playbooks)

- /.github/ (issue + PR templates; CI workflows)

## 6.4 Story template for agentic work (copy/paste)

Story Title: \<verb\> \<object\> so that \<persona\> can \<outcome\>

- Persona + context

- In-scope justification (link to scope doc section)

- Acceptance criteria (Given/When/Then)

- Data impacts (objects/tables/events touched)

- API impacts (endpoints added/changed)

- UI impacts (screens/flows)

- Audit events emitted

- Out-of-scope check (explicitly note what is NOT being built)

- Test plan (unit/integration/e2e)

# 7) Open questions to answer early (to avoid rework)

- Pilot customer: Which PSP is the initial v1 operator (or is v1 built PSP-agnostic from day one)?

- Data migration: Are we migrating PrecisionPOP data, starting fresh, or doing a limited import (stores/campaign templates only)?

- Store list & survey: Do you already have canonical survey questions/attributes, or do we extract them from PrecisionPOP?

- Fulfillment integration: For v1, is \'order generation\' an internal view/export, or must it integrate with a PSP system (W2P/MIS/shipping)?

- Auth approach: email/password, SSO, magic links, or PSP-managed identity?

- Photos/files: preferred storage (S3-equivalent), max file sizes, and how strict the 90-day deletion must be (soft delete vs hard delete).

- Reporting: what counts as \'baseline reporting\' for each persona (top 5 metrics per role).

- Tech constraints: preferred stack, hosting, CI platform, and any compliance requirements.
