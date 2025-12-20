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

- Require at least one human approval for release/\* → main (pilot safety).

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

3.  CI deploys develop → staging automatically; production deploy is gated and scheduled weekly.

4.  Worker service boots and consumes named queues; queue metrics visible (dashboard or logs).
