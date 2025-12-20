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

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
